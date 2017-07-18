package{
	import flash.events.MouseEvent;
	
	public class ButtonZoomUp extends ButtonBase{
		
		public function ButtonZoomUp(){
			super();
		}
		
		override public function clickHandler(e:MouseEvent){
			Studio.rootStg.artBoard.zoomUp();
		}
	}
	
}
