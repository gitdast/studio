package{
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class ProjectThumbnailPrepared extends ProjectThumbnail{
		public var loader:Loader;
	
		public function ProjectThumbnailPrepared(o:Object, w:int, h:int){
			super(o, w, h);
			
			this.loadImg(o.thumb);
			this.loader.mask = maskShape;
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
			//trace("image loaded");
			this.addChildAt(loader, this.numChildren-1);
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imgLoaded);
			
			var min = Math.min(loader.width, loader.height);
			loader.scaleX = loader.scaleY = controlWidth / min;
			
			this.addEventListeners();
			
			var category = this.parent as ProjectThumbnailCategoryPrepared;
			category.signalImageLoaded();
		}
		
		override protected function clickHandler(e:MouseEvent){
			Studio.rootStg.createPreparedProject(projData);
		}
		
		override public function remove(){
			super.remove();
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imgLoaded);
			this.unloadImg();
		}

	}
	
}
