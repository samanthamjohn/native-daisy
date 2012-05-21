//
//  ScriptViewCell.m
//  DaisyTheDinosaur
//
//  Created by Samantha John on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScriptViewCell.h"

@implementation ScriptViewCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//
//- (void) setEditing:(BOOL)editing animated:(BOOL)animated
//{
//    [super setEditing: editing animated: YES];
//    
//    if (editing) {
//        
//        for (UIView * view in self.subviews) {
//            if ([NSStringFromClass([view class]) rangeOfString: @"Reorder"].location != NSNotFound) {
//                for (UIView * subview in view.subviews) {
//                    if ([subview isKindOfClass: [UIImageView class]]) {
//                        ((UIImageView *)subview).image = nil;
//                    }
//                }
//            }
//        }
//    }   
//}

@end
