package{
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class ProjectThumbnailTemp extends ProjectThumbnail{
		public var button:MovieClip;
		public var image:Sprite;

		public function ProjectThumbnailTemp(o:Object, w:int, h:int){
			super(o, w, h);
			
			this.addImage();
			this.image.mask = maskShape;
			
			this.addButton();
			
			this.addEventListeners();
		}
		
		private function addImage(){
			image = new Sprite();
			this.addChild(image);
			image.addChild(projData.thumb);
			
			var min = Math.min(image.width, image.height);
			image.scaleX = image.scaleY = controlWidth / min;			
		}
		
		private function addButton(){
			this.button = new Button_delete();
			button.enable();
			button.x = this.controlWidth;
			button.y = 0;
			this.addChild(button);
		}
		
		override public function addEventListeners(){
			super.addEventListeners();
			button.addEventListener("click", removeClickHandler);
		}
		
		override public function removeEventListeners(){
			super.removeEventListeners();
			button.removeEventListener("click", removeClickHandler);
		}
		
		override protected function clickHandler(e:MouseEvent){
			Studio.rootStg.createRestoredProject(projData);
		}
		
		private function removeClickHandler(e:MouseEvent){
			Studio.rootStg.homepage.removeTempProject(projData.prId);
		}
		
		override public function remove(){
			super.remove();
			this.button.remove();
		}

	}
	
}
