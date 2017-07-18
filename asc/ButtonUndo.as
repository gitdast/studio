package{
	import flash.events.MouseEvent;

	public class ButtonUndo extends ButtonBase{
		
		public function ButtonUndo(){
			super();
			//this.disable();
		}
		
		override public function clickHandler(e:MouseEvent){
			Studio.rootStg.artBoard.projectMc.undo();
			this.disable();
		}

	}
}
