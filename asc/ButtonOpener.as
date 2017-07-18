package{
	import flash.events.MouseEvent;
	
	public class ButtonOpener extends ButtonBase{
		public var moveDirection:int;
		
		public function ButtonOpener(){
			super();
			//this.moveDirection = dir;
		}
		
		override public function addEventListeners(){
			super.addEventListeners();
			this.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			this.addEventListener(MouseEvent.MOUSE_UP, upHandler);
		}
		
		private function upHandler(e:MouseEvent){
			trace("mouseUp");
			this.gotoAndStop(1);
			var thumbs:ProjectThumbnailCategory = this.parent as ProjectThumbnailCategory;
			thumbs.stopMoveHandler();
		}
		
		private function downHandler(e:MouseEvent){
			trace("mouseDown");
			this.gotoAndStop(3);
			var thumbs:ProjectThumbnailCategory = this.parent as ProjectThumbnailCategory;
			thumbs.moveHandler(moveDirection);
		}
		
		public function removeAll(){
			super.removeEventListeners();
			this.removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			this.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
		}

	}
}
