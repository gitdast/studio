package{
	import flash.events.MouseEvent;

	public class ButtonSaveTemp extends ButtonRect{
		
		public function ButtonSaveTemp(){
			super(false, true);
		}
		
		/*
		override public function overHandler(e:MouseEvent){
			if(this.currentFrame == 1){
				super.overHandler(e);
				Studio.rootStg.panelMain.createProjectTempSaver();
			}
		}
		override public function outHandler(e:MouseEvent){
			if(Studio.rootStg.panelMain.tryCloseProjectTempSaver(e)){
				super.outHandler(e);
			}
		}*/
	}
}
