package  {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	
	public class ButtonNewWall extends ButtonBase{
		public var mc_bgd:MovieClip;

		public function ButtonNewWall(displayHint:Boolean = true, displayLabel:Boolean = false){
			super(displayHint, displayLabel);
			this.enable();
			this.labelField.transform.colorTransform = new ColorTransform(0,0,0,0,0,158,158,158);
		}
		
		override public function overHandler(e:MouseEvent){
			this.transform.colorTransform = COLOR_TRANS_OVER;
		}
		override public function outHandler(e:MouseEvent){
			this.transform.colorTransform = COLOR_TRANS_NORMAL;
		}
		
		override public function clickHandler(e:MouseEvent){
			var wc = Studio.rootStg.panelWalls.wallsControl;
			
			//* reseting all after paint mode
			if(Studio.rootStg.artBoard && Studio.rootStg.artBoard.actionMode == "paint"){				
				wc.reselectWall();
				Studio.rootStg.panelTools.deselectTool();
			}
			
			wc.changeWall(wc.addWall().wallNum);
		}

	}
	
}
