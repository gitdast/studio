package{
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class ProjectThumbnail extends Sprite{
		public var projData:Object;
		public var loader:Loader;
		public var hilite:Sprite;
		
		public const imgW:Number = 158;
		public const imgH:Number = 100;

		public function ProjectThumbnail(projNum:int, o:Object){
			this.projData = o;
			this.loadImg(o.thumb);
			this.buttonMode = true; 
		}
		
		public function loadImg(link:String){
			loader = new Loader;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imgLoaded);
			loader.load(new URLRequest(link));
		}
		
		public function unloadImg(){
			loader.unloadAndStop();
		}
		
		private function imgLoaded(e:Event){
			//trace("project loaded");
			this.addChild(loader);
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imgLoaded);
			
			this.hilite = new Sprite();
			hilite.graphics.lineStyle(2, 0xFFFFFF, 1);
			hilite.graphics.drawRect(0,0,this.width,this.height);
			this.addChild(hilite);
			
			this.addEventListeners();
			
			var category = this.parent.parent as ProjectThumbnailCategoryPrepared;
			category.signalImageLoaded();
		}
		
		public function addEventListeners(){
			this.addEventListener("mouseOver", overHandler);
			this.addEventListener("mouseOut", outHandler);
			this.addEventListener("click",clickHandler);
		}
		
		public function removeEventListeners(){
			this.removeEventListener("mouseOver", overHandler);
			this.removeEventListener("mouseOut", outHandler);
			this.removeEventListener("click",clickHandler);
		}
		
		public function overHandler(e:MouseEvent){
			hilite.graphics.clear();
			hilite.graphics.lineStyle(4, 0x0066FF, 1);
			hilite.graphics.drawRect(0,0,this.width,this.height);
		}
		
		public function outHandler(e:MouseEvent){
			hilite.graphics.clear();
			hilite.graphics.lineStyle(2, 0xFFFFFF, 1);
			hilite.graphics.drawRect(0,0,this.width,this.height);
		}
		
		private function clickHandler(e:MouseEvent){
			Studio.rootStg.closeProjectOpener();
			Studio.rootStg.createPreparedProject(projData);
		}
		
		public function removeAll(){
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imgLoaded);
			this.unloadImg();
			this.removeEventListeners();
		}

	}
	
}
