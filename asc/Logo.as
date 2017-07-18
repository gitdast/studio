package{
	import flash.display.MovieClip;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	public class Logo extends MovieClip {
		public var mc_logo:MovieClip;
		public var mc_bgd:MovieClip;
		
		public static const PANEL_HEIGHT = 100;
		
		public function Logo() {
			trace("Logo: init");
			
			this.createBackground();
			
			mc_logo = new logo_img;
			mc_logo.x = Studio.PANEL_WIDTH / 2;
			mc_logo.y = PANEL_HEIGHT / 2;
			this.addChild(mc_logo);
			
			this.buttonMode = true;
			this.addEventListener("click", function(){ navigateToURL(new URLRequest("http://www.esmal.sk"), "_top") });
		}
		
		private function createBackground(){
			mc_bgd = new background_panel;
			mc_bgd.width = Studio.PANEL_WIDTH;
			mc_bgd.height = PANEL_HEIGHT;
			this.addChild(mc_bgd);
		}
	}
	
}
