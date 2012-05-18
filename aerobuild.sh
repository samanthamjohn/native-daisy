#!/bin/sh

#
# aerobuild.sh
#
# What does this do?
# ==================
# - Bumps build numbers in your project using agvtool
# - Builds your app and packages it for testing/ad-hoc distribution
# - Commits build number changes to git
# - Tags successful builds in git
# - Uploads builds to testflight with notes based on commits since the last build
# - If your branch is remote-tracking, it will ensure all changes are pushed first,
#   and will push the tagging on a successful build.
#
# Requirements
# ============
# - your target is an iOS App
# - you have a valid code signing identity & mobileprovision file
# - you use git for your version control
# - you use agvtool for versioning your builds, it's easy to enable:
#    1. In your project build settings:
#       a. set "Versioning System" to "Apple Generic"
#       b. set "Current Project Version" to "1"
#    2. In your applications info.plist file, set "Bundle version" (NOTE: not "Bundle versions string, short") to "1"
# - you use testflight for publishing builds
# - Xcode is configured to place build products in locations specified by targets
#     (Under Preferences > Locations, in the section labelled "Build Location")
#
# Known issues
# ============
# When agvtool bumps the version numbers, for some reason the platform build selector
# in Xcode gets messed up.  It returns to normal if you close and re-open the project.
#

#
# BUILD SETTINGS
#
# Name of target
TARGET_NAME="DaisyTheDinosaur"

# Target SDK
# If you need to specify a specific version you can change this
TARGET_SDK=iphoneos

# Build configuration to use
CONFIGURATION=Release

# Name of .mobileprovision file in the PROFILES_PATH directory (see below)
PROVISIONING="467439DF-1940-4FA8-A703-78F788007210.mobileprovision"

# Code signing identity, as it appears in Xcode's Organizer (e.g. "iPhone Developer: John Doe")
SIGNER="iPhone Developer: Samantha John"

#
# TESTFLIGHT SETTINGS
#
# Your testflightapp.com API token (see https://testflightapp.com/account/)
TESTFLIGHT_API_TOKEN=572b32590dbc5a15d3e81e34a8f6b77c_MjAwNTY5MjAxMS0xMC0yOSAxNzo1OTo0OS43MjY1MTg
# Your testflightapp.com Team Token (see https://testflightapp.com/dashboard/team/edit/)
TESTFLIGHT_TEAM_TOKEN=e14398255285464e47c089b95699d6b7_Mzc3MDkyMDExLTEwLTMxIDE4OjE3OjU4LjA1NzI4Mw
# List of testflightapp.com distribution lists to send the build to (and send notifications)
TESTFLIGHT_GROUPS="Dev"

#
# GIT SETTINGS
#
# The prefix for build tags.  Change this if "build-n" will collide with other tags you create in git.
GIT_TAG_PREFIX=ipa-
GIT_BRANCH=$(git name-rev --name-only HEAD)
GIT_REMOTE=$(git branch -r | grep -v \/HEAD | grep \/${GIT_BRANCH} | sed -E 's/ +([^\/]+).*/\1/g')

#
# PATH SETTINGS
#
# Override these if you're experiencing problems with the script locating your build artifacts or
# provisioning profiles
PROFILES_PATH="${HOME}/Library/MobileDevice/Provisioning Profiles/"
APP_PATH="build/${CONFIGURATION}-iphoneos/${TARGET_NAME}.app"

# Where the ipa file will be written prior to being uploaded to testflightapp.com
OUTPUT_PATH="/tmp/${TARGET_NAME}.ipa"

#
# SCRIPT STARTS
#
echo "Pre-build checks..."

# Make sure there are no uncommitted changes
STATUS=x$(git status --porcelain)
if [ "${STATUS}" != "x" ]
then
  echo "!!! Git checkout is not clean.  Not building."
  exit 1
fi

# Make sure there are no unpushed changes
if [ "x" != "x"${GIT_REMOTE} ]
then
  echo "Checking for unpushed changes to ${GIT_REMOTE}/${GIT_BRANCH}"
  UNPUSHED=$(git log ${GIT_REMOTE}/${GIT_BRANCH}..${GIT_BRANCH} --format=oneline --abbrev=6 --abbrev-commit)
  if [ -n "${UNPUSHED}" ]
  then
    echo "!!! Not building. You have the following unpushed changes:"
    echo "${UNPUSHED}"
    exit 1
  fi
fi

# Determine the build tag that the last built version had
OLD_BUILD_TAG="${GIT_TAG_PREFIX}$(agvtool what-version -terse)"

# Check if the tag actually exists in git
if [ "x" != "x"${GIT_REMOTE} ]
then
  git fetch
fi
OLD_BUILD_TAG=$(git tag -l "${OLD_BUILD_TAG}")

# Bump up version number, but don't commit yet
agvtool bump -all
VERSION_NUMBER=$(agvtool what-marketing-version -terse1)
BUILD_NUMBER=$(agvtool what-version -terse)
VERSION_STRING="${VERSION_NUMBER} (${BUILD_NUMBER})"
BUILD_TAG="${GIT_TAG_PREFIX}${BUILD_NUMBER}"

# Build target
echo
echo Building target: "${TARGET_NAME}" "${VERSION_STRING}"...
echo

xcodebuild -target "${TARGET_NAME}" \
  -sdk "${TARGET_SDK}" \
  -configuration "${CONFIGURATION}"

if [ $? -ne 0 ]
then
  echo
  echo "!!! xcodebuild failed"
  git reset --hard HEAD
  exit 1
fi

# Package .ipa
echo
echo Packaging target...
echo

xcrun -sdk "${TARGET_SDK}" \
  PackageApplication \
  -v ${APP_PATH} \
  -o ${OUTPUT_PATH} \
  --sign "${SIGNER}" \
  --embed "${PROFILES_PATH}${PROVISIONING}"

if [ $? -ne 0 ]
then
  echo
  echo "!!! xcrun failed to package application"
  git reset --hard HEAD
  exit 1
fi

# Get build notes from commit messages, from the last build tag (if present, otherwise all)
if [ -n "${OLD_BUILD_TAG}" ]
then
  BUILD_NOTES=$(git log "${OLD_BUILD_TAG}".. --format=oneline --abbrev=6 --abbrev-commit)
else
  BUILD_NOTES=$(git log --format=oneline --abbrev=6 --abbrev-commit)
fi

# Commit version bump and tag build
echo
echo Committing version bump and tagging build...
echo

git commit -am "Build ${VERSION_STRING} published"
git tag -a "${BUILD_TAG}" HEAD -m "Tagging published build ${VERSION_STRING}"

if [ "x" != "x"${GIT_REMOTE} ]
then
  git push ${GIT_REMOTE} ${GIT_BRANCH}
  git push ${GIT_REMOTE} ${GIT_BRANCH} --tags
fi

# Testflight!
echo
echo Submitting to testflightapp...
echo

NOTES=$(git log -1 --format=oneline --abbrev=6 --abbrev-commit)

echo curl http://testflightapp.com/api/builds.json \
  -F file=@"${OUTPUT_PATH}" \
  -F api_token="${TESTFLIGHT_API_TOKEN}" \
  -F team_token="${TESTFLIGHT_TEAM_TOKEN}" \
  -F notes="${BUILD_NOTES}" \
  -F notify=True \
  -F distribution_lists="${TESTFLIGHT_GROUPS}"
curl http://testflightapp.com/api/builds.json \
  -F file=@"${OUTPUT_PATH}" \
  -F api_token="${TESTFLIGHT_API_TOKEN}" \
  -F team_token="${TESTFLIGHT_TEAM_TOKEN}" \
  -F notes="${BUILD_NOTES}" \
  -F notify=True \
  -F distribution_lists="${TESTFLIGHT_GROUPS}"

if [ $? -ne 0 ]
then
  echo
  echo "!!! Error uploading to testflightapp"
  exit 1
fi
