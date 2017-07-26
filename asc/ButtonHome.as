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
		
		override public function clickHandler(e:MouseEvent){
			if(Studio.rootStg.project && Studio.rootStg.project.type != "prepared"){
				Studio.rootStg.createPanelInfoClose(Studio.rootStg.addHomepage);
			}
			else{
				Studio.rootStg.addHomepage();
			}
		}
	}
}

