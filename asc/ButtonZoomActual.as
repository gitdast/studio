package{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class ButtonZoomActual extends ButtonBase{
		public var mc_ico:MovieClip;
		
		public function ButtonZoomActual(){
			super();
			this.y = 6;
			this.disable();
		}
		
		override public function clickHandler(e:MouseEvent){
			Studio.rootStg.artBoard.zoomActual();
		}
	}
	
}
