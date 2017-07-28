package{
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
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
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadError);
			loader.load(new URLRequest(link));
		}
		
		public function unloadImg(){
			loader.unloadAndStop();
		}
		
		private function imgLoaded(e:Event){
			this.addChildAt(loader, this.numChildren-1);
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imgLoaded);
			
			var min = Math.min(loader.width, loader.height);
			loader.scaleX = loader.scaleY = controlWidth / min;
			
			this.addEventListeners();
			
			var category = this.parent as ProjectThumbnailCategoryPrepared;
			category.signalImageLoaded();
		}
		
		private function loadError(e:Event){
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadError);
			var category = this.parent as ProjectThumbnailCategoryPrepared;
			category.removeChild(this);
			category.signalImageError();
			this.remove();
		}
		
		override protected function clickHandler(e:MouseEvent){
			Studio.rootStg.createPreparedProject(projData);
		}
		
		override public function remove(){
			super.remove();
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imgLoaded);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadError);
			this.unloadImg();
		}

	}
	
}
