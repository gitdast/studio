package{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class ProjectThumbnailCategory extends Sprite{
		public var images:Sprite;
		public var imMask:Sprite;
		public var buttL:ButtonOpener;
		public var buttR:ButtonOpener;
		public var moveDirection:int;
		public var speed:Number;
		
		public var pWidth:Number;
		
		public function ProjectThumbnailCategory(w:Number, imgh:Number){
			this.pWidth = w;
			
			images = new Sprite();
			this.addChild(images);
		}
		
		public function addMask(w, h){
			imMask = new Sprite();
			imMask.graphics.beginFill(0x000000, 0);
			imMask.graphics.drawRect(28, -24, w-56, h+20+8);
			imMask.graphics.endFill();
			images.mask = imMask;
			this.addChild(imMask);
		}
		
		public function addButtons(w:Number){
			this.images.x = 30;
			
			buttL = new ButtonOpenerLeft();
			buttL.x = 0;
			buttL.y = 0;
			buttL.moveDirection = 1;
			this.addChild(buttL);
			
			buttR = new ButtonOpenerRight();
			buttR.x = w;
			buttR.y = 0;
			buttR.moveDirection = -1;
			this.addChild(buttR);
		}
		
		public function stopMoveHandler(){
			this.removeEventListener("enterFrame", doMoving);
		}
		
		public function moveHandler(dir:int){
			this.moveDirection = dir;
			this.speed = 1;
			this.addEventListener("enterFrame", doMoving);
		}
		
		public function doMoving(e:Event){
			var xIm = images.x;
			var wIm = images.width;
			var wMask = imMask.width;
			var delW = wIm-wMask-28;
			var xIm_new = xIm + 5*speed*moveDirection;
			
			if(((moveDirection < 0) && (xIm_new > -delW)) ||
			   ((moveDirection > 0) && (xIm_new < 30))){
				images.x = xIm_new;
				speed += 0.15;
			}else{
				images.x = moveDirection < 0 ? -delW : 30;
				this.stopMoveHandler();
			}
		}
		
		public function removeAll(){
			var child, thumb, i:int;
			for(i=this.numChildren-1; i>=0; i--){
				child = this.getChildAt(i);
				if(!(child is Sprite)){
					child.removeAll();
				}
			}
			for(i=images.numChildren-1; i>=0; i--){
				thumb = images.getChildAt(i);
				thumb.removeAll();
			}
		}
	}
	
}
