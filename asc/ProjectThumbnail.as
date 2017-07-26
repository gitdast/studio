package{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	
	public class ProjectThumbnail extends Sprite{
		public var projData:Object;
		public var bgd:Shape;
		public var maskShape:Shape;
		
		public var controlWidth:int;
		public var controlHeight:int;

		public function ProjectThumbnail(o:Object, w:int, h:int){
			this.buttonMode = true;
			this.projData = o;
			this.controlWidth = w;
			this.controlHeight = h;
			
			this.createBgd();
			this.createMask();
		}
		
		protected function createBgd(){
			bgd = new Shape();
			bgd.graphics.lineStyle(1, 0x8e8e8e);
			bgd.graphics.beginFill(0xffffff, 1);
			bgd.graphics.drawRect(0, 0, controlWidth-1, controlHeight);
			bgd.graphics.endFill();
			this.addChild(bgd);
		}
		
		protected function createMask(){
			maskShape = new Shape();
			maskShape.graphics.lineStyle(1, 0x000000, 0);
			maskShape.graphics.beginFill(0x000000, 1);
			maskShape.graphics.drawRect(5, 5, controlWidth - 10, controlHeight - 10);
			maskShape.graphics.endFill();
			this.addChild(maskShape);
		}
		
		public function addEventListeners(){
			this.addEventListener("mouseOver", overHandler);
			this.addEventListener("mouseOut", outHandler);
			this.addEventListener("click", clickHandler);
		}
		
		public function removeEventListeners(){
			this.removeEventListener("mouseOver", overHandler);
			this.removeEventListener("mouseOut", outHandler);
			this.removeEventListener("click",clickHandler);
		}
		
		protected function overHandler(e:MouseEvent){
			bgd.graphics.clear();
			bgd.graphics.lineStyle(1, 0x0099FF);
			bgd.graphics.beginFill(0xffffff, 1);
			bgd.graphics.drawRect(0, 0, controlWidth-1, controlHeight);
			bgd.graphics.endFill();
		}
		
		protected function outHandler(e:MouseEvent){
			bgd.graphics.clear();
			bgd.graphics.lineStyle(1, 0x8e8e8e);
			bgd.graphics.beginFill(0xffffff, 1);
			bgd.graphics.drawRect(0, 0, controlWidth-1, controlHeight);
			bgd.graphics.endFill();
		}
		
		protected function clickHandler(e:MouseEvent){
		}
		
		public function remove(){
			this.removeEventListeners();
		}

	}
	
}
