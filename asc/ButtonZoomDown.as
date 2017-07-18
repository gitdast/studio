package{
	import flash.events.MouseEvent;
	
	public class ButtonZoomDown extends ButtonBase{
		
		public function ButtonZoomDown(){
			super();
		}
		
		override public function clickHandler(e:MouseEvent){
			Studio.rootStg.artBoard.zoomDown();
		}
	}
	
}
