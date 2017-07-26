package{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class ProjectThumbnailCategoryTemp extends ProjectThumbnailCategory{
		public var butt_new:ButtonNewProject;
		
		public static const THUMB_WIDTH:int = 120;
		public static const THUMB_HEIGHT:int = 120;

		public function ProjectThumbnailCategoryTemp(w:Number, temp:Array){
			super(w, 1);
			
			this.addNewButton();
			this.addThumbnails(temp);			
		}
		
		private function addNewButton(){
			butt_new = new ButtonNewProject();
			butt_new.y = 15;
			this.addChild(butt_new);
		}
		
		private function addThumbnails(temp:Array){
			var projThum:ProjectThumbnailTemp,
				posX:int = butt_new.x + butt_new.width,
				posY:int = 15;

			for(var i = 0; i < temp.length; i++){
				trace("thumbcategtemp :", temp[i].prId);
				projThum = new ProjectThumbnailTemp(temp[i], THUMB_WIDTH, THUMB_HEIGHT);
				projThum.x = posX + margin;
				projThum.y = posY;
				this.addChild(projThum);
				
				if(projThum.x + margin + 2 * THUMB_WIDTH <= controlWidth){
					posX = posX + margin + THUMB_WIDTH;
				}
				else{
					posX = - margin;
					posY = posY + margin + THUMB_HEIGHT;
				}
			}
		}
		
		override public function resizeHandler(w:Number){
			super.resizeHandler(w);
			
			var child,
				posX:int = butt_new.x + butt_new.width,
				posY:int = 15;
				
			for(var i:int = 1; i < numChildren; i++){
				child = getChildAt(i);
				child.x = posX + margin;
				child.y = posY;
				
				if(child.x + margin + 2 * THUMB_WIDTH <= controlWidth){
					posX = posX + margin + THUMB_WIDTH;
				}
				else{
					posX = - margin;
					posY = posY + margin + THUMB_HEIGHT;
				}				
			}
		}
		
		override public function remove(){
			var child;
			for(var i:int = this.numChildren - 1; i >= 0; i--){
				child = this.getChildAt(i);
				child.remove();
				this.removeChild(child);
			}
			//butt_new.remove();
		}
		
	}
	
}
