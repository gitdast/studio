package{
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	
	public class ButtonZoomFit extends ButtonBase{
		public var mc_ico:MovieClip;
		private var icoState:int;
		
		public static const ZOOM_FIT = 1;
		public static const ZOOM_ACTUAL = 2;
		
		public function ButtonZoomFit(){
			super();
			this.icoState = this.mc_ico.currentFrame;
		}
		
		override public function clickHandler(e:MouseEvent){
			if(this.icoState == ZOOM_FIT){
				Studio.rootStg.artBoard.zoomFit();
				this.icoState = ZOOM_ACTUAL;
			}
			else{
				Studio.rootStg.artBoard.zoomActual();
				this.icoState = ZOOM_FIT;
			}
			this.mc_ico.gotoAndStop(this.icoState);
		}
	}
	
}
