package{
	import flash.display.Sprite;
	
	public class ProjectThumbnailCategory extends Sprite{
		
		public var controlWidth:Number;
		public var num:int;
		
		public const margin:int = 30;
		
		public function ProjectThumbnailCategory(w:Number, num:int){
			this.controlWidth = w;
			this.num = num;
		}
		
		public function resizeHandler(w:Number){
			this.controlWidth = w;
		}
	
		public function remove(){
		}
	}
	
}
