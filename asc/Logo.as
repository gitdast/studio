package{
	import flash.display.MovieClip;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	public class Logo extends MovieClip {
		public var mc_logo:MovieClip;
		public var mc_bgd:MovieClip;
		public var loader:Loader;
		
		public static const PANEL_HEIGHT = 100;
		
		public function Logo() {
			trace("Logo: init");
			
			//this.createBackground();
			//this.addLogo();
			
			this.createWhiteBackground();
			this.loadLogo();
			
			this.buttonMode = true;
			this.addEventListener("click", function(){ navigateToURL(new URLRequest("http://www.esmal.sk"), "_top") });
		}
		
		private function addLogo(){
			mc_logo = new logo_img;
			mc_logo.x = Studio.PANEL_WIDTH / 2;
			mc_logo.y = PANEL_HEIGHT / 2;
			this.addChild(mc_logo);
		}
		
		public function loadLogo(){
			loader = new Loader;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completedHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			loader.load(new URLRequest("logo.png"));
		}
		
		private function completedHandler(e:Event){
			this.addChild(loader);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, completedHandler);
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, errorHandler);
			/*
			var scale = Studio.PANEL_WIDTH / loader.width;
			loader.scaleX = loader.scaleY = scale;
			*/
			loader.x = Studio.PANEL_WIDTH / 2 - loader.width / 2;
			loader.y = PANEL_HEIGHT / 2 - loader.height / 2;
		}
		
		private function errorHandler(e:Event){
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, completedHandler);
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, errorHandler);
		}
		
		private function createWhiteBackground(){
			this.graphics.beginFill(0xFFFFFF, 1);
			this.graphics.drawRect(0, 0, Studio.PANEL_WIDTH, PANEL_HEIGHT);
			this.graphics.endFill();
		}
		
		private function createBackground(){
			mc_bgd = new background_panel;
			mc_bgd.width = Studio.PANEL_WIDTH;
			mc_bgd.height = PANEL_HEIGHT;
			this.addChild(mc_bgd);
		}
	}
	
}
