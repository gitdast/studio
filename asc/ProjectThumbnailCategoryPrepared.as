package{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	
	public class ProjectThumbnailCategoryPrepared extends ProjectThumbnailCategory{
		public var thumbCount:int = 0;
		public var thumbLoaded:int = 0;
		
		public const imgW:Number = 158;
		public const imgH:Number = 100;

		public function ProjectThumbnailCategoryPrepared(catNode:XML, w:Number){
			super(w, imgH);
			this.visible = false;
			
			var imW = this.addThumbnails(catNode);

			if(imW > w){
				this.addMask(w, imgH);
				this.addButtons(w);
			}
		}
		
		private function addThumbnails(catNode:XML):Number{
			var projectNum:int = 0;
			var projThum:ProjectThumbnail;
			var o:Object;
			var elems:Array;
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
				
				projThum = new ProjectThumbnail(projectNum, o);
				projThum.x = 0 + projectNum*10 + projectNum*imgW;
				images.addChild(projThum);
				
				projectNum++;
			}
			
			this.thumbCount = projectNum;

			return projThum.x + imgW;
		}
		
		public function signalImageLoaded(){
			this.thumbLoaded++;
			
			// nahravaji se najednou a pridaly se jine rozmery - tak se preskadaji zde
			var img;
			var xpos = 0;
			for(var i=0; i<images.numChildren; i++){
				img = images.getChildAt(i);
				img.x = xpos;
				xpos += img.width + 10;
			}
			
			if(thumbLoaded == thumbCount){
				this.visible = true;
				var opener = this.parent as Class(getDefinitionByName(getQualifiedClassName(this.parent)));
				opener.thumbnailsReady();
			}
		}
		
	}
	
}
