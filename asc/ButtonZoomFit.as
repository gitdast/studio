package{
	import flash.events.MouseEvent;
	
	public class ButtonZoomFit extends ButtonBase{
		
		public function ButtonZoomFit(){
			super();
		}
		
		override public function clickHandler(e:MouseEvent){
			Studio.rootStg.artBoard.zoomFit();
		}
	}
	
}
