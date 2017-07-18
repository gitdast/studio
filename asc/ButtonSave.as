package{
	import flash.events.MouseEvent;

	public class ButtonSave extends ButtonRect{
		
		public function ButtonSave(){
			super(false, true);
		}

		/*
		override public function clickHandler(e:MouseEvent){
			ColorStudio.rootStg.createPanelInfoSave();
			if(ColorStudio.rootStg.projectP.prData){
				ColorStudio.rootStg.panelInfo.addQuestion();
			}else{
				ColorStudio.rootStg.projectP.export();
			}
		}
		*/
	}
}
