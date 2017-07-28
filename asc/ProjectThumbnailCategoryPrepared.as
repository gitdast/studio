package{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	
	public class ProjectThumbnailCategoryPrepared extends ProjectThumbnailCategory{
		public var thumbCount:int = 0;
		public var thumbLoaded:int = 0;
		
		public static const THUMB_WIDTH:int = 120;
		public static const THUMB_HEIGHT:int = 120;

		public function ProjectThumbnailCategoryPrepared(w:Number, num:int, catNode:XML){
			super(w, num);
			this.visible = false;
			
			this.addThumbnails(catNode);
		}
		
		private function addThumbnails(catNode:XML){
			var projThum:ProjectThumbnailPrepared;
			var o:Object;
			var elems:Array;
			var posX:int = - margin,
				posY:int = 0;
			
			for each(var node:XML in catNode.project){
				o = new Object();
				elems = new Array();
				o["prepared"] = "prepared";
				o["thumb"] = node.url_img;
				o["link"] = node.url_clip;
				o["name"] = node.name;
				for each(var el:XML in node.elements.el_wall){
					elems.push(el);
				}
				o["elements"] = elems;
				
				projThum = new ProjectThumbnailPrepared(o, THUMB_WIDTH, THUMB_HEIGHT);
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
		
		public function getScrollbarPosition():int{
			var child,
				posX:int = 0;
				
			for(var i:int = 0; i < numChildren; i++){
				child = this.getChildAt(i);
				posX = Math.max(posX, child.x);
			}
			
			return this.x + posX + THUMB_WIDTH + 15;
		}
		
		public function signalImageLoaded(){
			this.thumbLoaded++;
			
			if(thumbLoaded == this.numChildren){
				this.visible = true;
				var opener = this.parent as Class(getDefinitionByName(getQualifiedClassName(this.parent)));
				opener.thumbnailsReady(this.num);
			}
		}
		
		public function signalImageError(){
			if(thumbLoaded == this.numChildren){
				this.visible = true;
				var opener = this.parent as Class(getDefinitionByName(getQualifiedClassName(this.parent)));
				opener.thumbnailsReady(this.num);
			}
		}
		
		override public function resizeHandler(w:Number){
			super.resizeHandler(w);
			
			var child,
				posX:int = - margin,
				posY:int = 0;
				
			for(var i:int = 0; i < numChildren; i++){
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
			for(var i:int = this.numChildren - 1; i > 0; i--){
				child = this.getChildAt(i);
				child.remove();
				this.removeChild(child);
			}
		}
		
	}
	
}
