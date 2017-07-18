package{
	import flash.events.MouseEvent;
	
	public class ButtonZoomMove extends ButtonBase{
		
		public function ButtonZoomMove(){
			super();
		}
		
		override public function clickHandler(e:MouseEvent){
			Studio.rootStg.panelTools.deselectTool();
			Studio.rootStg.artBoard.setMode("move");
		}
	}
	
}
