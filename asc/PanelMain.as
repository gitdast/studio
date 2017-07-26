package{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class PanelMain extends Sprite{
		public var butt_undo;
		public var butt_zoomup;
		public var butt_zoomdown;
		public var butt_zoomfit;
		public var butt_zoommove;
		public var butt_print;
		public var butt_output;
		
		public var mc_bgd:MovieClip;
		
		public static const PANEL_HEIGHT = 60;
		
		public function PanelMain(){
			trace("PanelMain: init");
			this.x = 0;
			this.y = Logo.PANEL_HEIGHT;
			this.createBackground();
			this.addButtons();
		}
		
		private function addButtons(){
			this.addChild(butt_undo = new ButtonUndo);
			this.addChild(butt_zoomup = new ButtonZoomUp);
			this.addChild(butt_zoomdown = new ButtonZoomDown);
			this.addChild(butt_zoomfit = new ButtonZoomFit);
			this.addChild(butt_print = new ButtonPrint);
			this.addChild(butt_output = new ButtonOutput);
			
			var xPos:int = Studio.PANEL_PADDING,
				mx:int = 15,
				butt;
			for(var i:int = 1; i < numChildren; i++){
				butt = this.getChildAt(i);
				butt.x = xPos;
				xPos += butt.width + mx;
			}
			butt_zoomup.x += 3;	//* zoom icons move a little closer
		}
		
		public function enable(isNewProject:Boolean = false){
			butt_print.enable();
			butt_output.enable();
			butt_zoomfit.enable();
			
			if(isNewProject){
				butt_zoomup.enable();
				butt_zoomdown.enable();
			}
		}
		
		public function disable(){
			butt_undo.disable();
			butt_zoomup.disable();
			butt_zoomdown.disable();
			butt_zoomfit.disable();
			butt_print.disable();
			butt_output.disable();
		}
		
		private function createBackground(){
			mc_bgd = new background_panel();
			mc_bgd.width = Studio.PANEL_WIDTH;
			mc_bgd.height = PANEL_HEIGHT;
			this.addChild(mc_bgd);
		}
		
	}
	
}
