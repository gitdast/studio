package{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	
	public class ButtonFoto extends ButtonBase{
		public var mc_ico:MovieClip;
		public var bgd:Shape;
		
		public function ButtonFoto(){
			super();
			this.y = 6;
		}
		
		override public function overHandler(e:MouseEvent){
			if(this.currentFrame == 1){
				super.overHandler(e);
				Studio.rootStg.createProjectOpener();
			}
		}
		override public function outHandler(e:MouseEvent){
			if(Studio.rootStg.tryCloseProjectOpener(e)){
				super.outHandler(e);
			}
		}
	}
}

