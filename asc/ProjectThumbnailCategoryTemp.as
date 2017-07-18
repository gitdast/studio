package{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class ProjectThumbnailCategoryTemp extends ProjectThumbnailCategory{
		public const imgW:Number = 158;
		public const imgH:Number = 100;

		public function ProjectThumbnailCategoryTemp(temp:Array, w:Number){
			super(w, imgH);
			
			var imW = this.addThumbnails(temp);
			
			if(imW > w){
				this.addMask(w, imgH);
				this.addButtons(w);
			}
		}
		
		private function addThumbnails(temp:Array):Number{
			var projThum:ProjectThumbnailTemp;
			var xpos:Number = 0;

			for(var i=0; i<temp.length; i++){
				trace("thumbcategtemp :", temp[i].prId);
				projThum = new ProjectThumbnailTemp(i, temp[i]);
				projThum.x = xpos;
				xpos += temp[i].thumb.width + 10;
				images.addChild(projThum);
			}

			return xpos-10;
		}
		
	}
	
}
