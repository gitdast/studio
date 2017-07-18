package{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class ButtonClose extends ButtonBase{
		public var mc_ico:MovieClip;
		
		public function ButtonClose(){
			super();
			this.y = 6;
			this.disable();
		}
		
		override public function clickHandler(e:MouseEvent){
			if(Studio.rootStg.projectP.type == "prepared"){
				Studio.rootStg.closeProject();
			}else{
				Studio.rootStg.createPanelInfoClose(false);
			}
			/*
			Studio.rootStg.closeProject();
			Studio.rootStg.addHomepage();
			*/
		}
	}
	
}
