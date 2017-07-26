package{
	import flash.events.MouseEvent;

	public class ButtonSave extends ButtonRect{
		
		public function ButtonSave(){
			super(false, true);
		}

		override public function clickHandler(e:MouseEvent){
			if(Studio.rootStg.project.projectSaved){
				Studio.rootStg.createPanelInfoSave("panelInfoSaveRewrite");
			}
			else{
				Studio.rootStg.createPanelInfoSave("panelInfoSaveEmail");
			}
		}
		
	}
} 
