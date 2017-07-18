package{
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	
	public class ButtonHome extends ButtonRect{
		public var mc_ico:MovieClip;
		
		public function ButtonHome(){
			super(true, false);
		}
		
		override public function enable(){
			super.enable();
			
			this.mc_ico.transform.colorTransform = COLOR_TRANS_NORMAL;
		}
		
		override public function disable(){
			super.disable();
			
			this.mc_ico.transform.colorTransform = COLOR_TRANS_DISABLED2;
		}
		
		/*
		override public function overHandler(e:MouseEvent){
			if(this.currentFrame == 1){
				super.overHandler(e);
				Studio.rootStg.panelMain.openHomeSubmenu();
			}
		}
		override public function outHandler(e:MouseEvent){
			if(Studio.rootStg.panelMain.tryCloseSubmenu(e)){
				super.outHandler(e);
			}
		}*/
		
		
		override public function clickHandler(e:MouseEvent){
			if(Studio.rootStg.projectP){
				if(Studio.rootStg.projectP.type == "prepared"){
					Studio.rootStg.closeProject();
					Studio.rootStg.addHomepage();
				}else{
					Studio.rootStg.createPanelInfoClose(true);
				}
			}else{
				Studio.rootStg.addHomepage();
			}
		}
	}
}

