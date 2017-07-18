package{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	
	public class ButtonNewProject extends ButtonBase{

		public function ButtonNewProject(displayHint:Boolean = true, displayLabel:Boolean = false){
			super(displayHint, displayLabel);
			this.enable();
			this.addEventListener("enterFrame", this.setHintColor);
		}
		
		private function setHintColor(e:Event){
			this.hintField.transform.colorTransform = new ColorTransform(0,0,0,1,158,158,158,0);
			this.removeEventListener("enterFrame", this.setHintColor);
		}
		
		override public function overHandler(e:MouseEvent){
			this.transform.colorTransform = COLOR_TRANS_OVER;
		}
		override public function outHandler(e:MouseEvent){
			this.transform.colorTransform = COLOR_TRANS_NORMAL;
		}
		
		override public function clickHandler(e:MouseEvent){
			Studio.rootStg.openFileDialog();
		}

	}
	
}
