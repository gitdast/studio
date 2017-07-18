package{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	//import flash.text.TextField;
	
	public class ProjectThumbnailTemp extends Sprite{
		public var projData:Object;
		public var hilite:Sprite;
		public var img:Sprite;
		public var butt_close;
		//public var idLabel:TextField;
		
		//public const imgW:Number = 158;
		//public const imgH:Number = 100;

		public function ProjectThumbnailTemp(projNum:int, o:Object){
			this.projData = o;
			this.buttonMode = true;
			
			this.appendRemoveButton();
			this.addThumb();
			//this.addIdLabel();
			
			this.addEventListeners();
		}
		
		public function addThumb(){
			this.img = new Sprite();
			img.addChild(projData.thumb);
			this.addChild(img);
			
			this.hilite = new Sprite();
			hilite.graphics.lineStyle(2, 0xFFFFFF, 1);
			hilite.graphics.drawRect(0, 0, projData.thumb.width, projData.thumb.height);
			this.addChild(hilite);
		}
		
		public function appendRemoveButton(){
			butt_close = new buttonThumbClose();
			butt_close.x = 0;
			butt_close.y = -19;

			this.addChild(butt_close);
		}
		/*
		public function addIdLabel(){
			idLabel = new TextField();
			idLabel.x = 25;
			idLabel.y = -19;
			idLabel.autoSize = "left";
			idLabel.text = projData.prId;
			this.addChild(idLabel);
			Studio.rootStg.addTextFormat(idLabel, 12, 0x000000);
		}
		*/
		public function addEventListeners(){
			img.addEventListener("mouseOver", overHandler);
			img.addEventListener("mouseOut", outHandler);
			img.addEventListener("click",clickHandler);
			
			butt_close.addEventListener("mouseOver", removeOverHandler);
			butt_close.addEventListener("mouseOut", removeOutHandler);
			butt_close.addEventListener("click", removeClickHandler);
		}
		
		public function removeEventListeners(){
			img.removeEventListener("mouseOver", overHandler);
			img.removeEventListener("mouseOut", outHandler);
			img.removeEventListener("click",clickHandler);
			
			butt_close.removeEventListener("mouseOver", removeOverHandler);
			butt_close.removeEventListener("mouseOut", removeOutHandler);
			butt_close.removeEventListener("click", removeClickHandler);
		}
		
		public function overHandler(e:MouseEvent){
			hilite.graphics.clear();
			hilite.graphics.lineStyle(4, 0x0066FF, 1);
			hilite.graphics.drawRect(0, 0, projData.thumb.width, projData.thumb.height);
		}
		
		public function outHandler(e:MouseEvent){
			hilite.graphics.clear();
			hilite.graphics.lineStyle(2, 0xFFFFFF, 1);
			hilite.graphics.drawRect(0, 0, projData.thumb.width, projData.thumb.height);
		}
		
		private function clickHandler(e:MouseEvent){
			Studio.rootStg.panelMain.closeProjectTempSaver();
			Studio.rootStg.createRestoredProject(projData.prId);
		}
		
		public function removeOverHandler(e:MouseEvent){
			hilite.graphics.clear();
			hilite.graphics.lineStyle(4, 0x990000, 1);
			hilite.graphics.beginFill(0x999999, 0.5);
			hilite.graphics.drawRect(0, 0, projData.thumb.width, projData.thumb.height);
			hilite.graphics.endFill();
		}
		
		public function removeOutHandler(e:MouseEvent){
			hilite.graphics.clear();
			hilite.graphics.lineStyle(2, 0xFFFFFF, 1);
			hilite.graphics.drawRect(0, 0, projData.thumb.width, projData.thumb.height);
		}
		
		private function removeClickHandler(e:MouseEvent){
			Studio.rootStg.panelMain.saver.removeTempProject(projData.prId);
		}
		
		public function removeAll(){
			this.removeEventListeners();
		}

	}
	
}
