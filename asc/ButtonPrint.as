package{
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.printing.*;
	
	public class ButtonPrint extends ButtonBase{

		public function ButtonPrint(){
			super();
		}
		
		override public function clickHandler(e:MouseEvent){
			var printJob = new PrintJob();
			
 			if(printJob.start()){
				var printSprite = new PrintTemplate(true, printJob.pageHeight),
					footerAdded:Boolean = printSprite.footerAdded,
					itemNum:int = printSprite.finishedOnItem,
					minWidth:Number = Math.min(printJob.pageWidth, printJob.paperWidth);
				
				/* scale content to fit page width */
				if(minWidth < printSprite.width){
					printSprite.scaleX = minWidth / printSprite.width;
					printSprite.scaleY = printSprite.scaleX;
				}
				
				var rec:Rectangle = new Rectangle(0, 1, printSprite.width/printSprite.scaleX, printJob.pageHeight);
				if(footerAdded){
					trace("print: footer ok");
					printJob.addPage(printSprite, rec);
				}
				else{
					trace("print: footer next page");
					printJob.addPage(printSprite, rec);
					
					var page2 = new PrintTemplate(false, printJob.pageHeight, itemNum+1);
					page2.scaleX = page2.scaleY = printSprite.scaleX;
					printJob.addPage(page2, rec);
				}

    			printJob.send();
 			}
		}
				
	}
}

