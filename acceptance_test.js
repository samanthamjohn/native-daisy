target = UIATarget.localTarget();
var mainWindow = target.frontMostApp().mainWindow();

mainWindow.buttons()["FreePlay"].tap();
mainWindow.tableViews()[0].cells()["move"].dragInsideWithOptions({startOffset:{x:0, y:0}, endOffset:{x:1.0, y:1.0}, duration:1.0});

mainWindow.tableViews()[0].cells()["turn"].dragInsideWithOptions({startOffset:{x:0, y:0}, endOffset:{x:1.0, y:1.0}, duration:1.0});
mainWindow.tableViews()[0].cells()["turn"].dragInsideWithOptions({startOffset:{x:0, y:0}, endOffset:{x:1.0, y:1.0}, duration:1.0});

if (mainWindow.tableViews()[1].cells()[1].isValid() )
{
	UIALogger.logPass("Method moved into script area");
	
	if (mainWindow.tableViews()[1].cells()[0].name() == "move")
	{
		UIALogger.logPass("move is first");
	} else {
		UIALogger.logFail(mainWindow.tableViews()[1].cells()[0].name());
		UIALogger.logFail("move is not firts");
	}
	
	if (mainWindow.tableViews()[1].cells()[1].name() == "turn")
	{
		UIALogger.logPass("turn is second");		
	} else {
		UIALogger.logFail("turn is not second");
	}
	
} else {	
	UIALogger.logFail("Method wasn't moved!");
}
target.frontMostApp().mainWindow().buttons()["Play Button"].tap();