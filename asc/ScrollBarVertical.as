package{
	import flash.display.Sprite;
	import flash.display.Shape;
	//import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.filters.BevelFilter;
	import flash.display.DisplayObject;
	import flash.display.CapsStyle;
	
	public class ScrollBarVertical extends Sprite{
		public var target;
		public var butt:Sprite;
		public var maskShape:Shape;
		
		private var targetX:int;
		private var targetY:int;
		private var paneHeight:int;
		private var paneWidth:int;
		private var scrollRatio:Number;
		
		private const BUTT_WIDTH = 10;
		private const BUTT_HEIGHT = 50;
		private const BAR_WIDTH = 5;
		
		private var buttRatioMin:Number = 0.08;
		private var buttRatioMax:Number = 0.8;

		public function ScrollBarVertical(target:DisplayObject, paneWidth:int, paneHeight:int, initRatio:Number = 0){
			this.target = target;
			this.targetX = target.x;
			this.targetY = target.y;
			this.paneHeight = paneHeight;
			this.paneWidth = paneWidth;
			this.scrollRatio = initRatio;
			
			this.visible = paneHeight - target.height < 0;
			trace("scrollbar:", visible, paneHeight, target.height);
			this.create();
			this.createMask();
			this.addEventListeners();
		}
		
		private function create(){
			this.graphics.beginFill(0x444444, 1);
			this.graphics.drawRoundRect(12, 0, 6, paneHeight, 8, 8);
			this.graphics.endFill();
			
			var heightRatio = paneHeight / (target.height > 0 ? target.height : 1),
				buttonnHeight = (heightRatio < buttRatioMin ? buttRatioMin : (heightRatio >= buttRatioMax ? buttRatioMax : heightRatio)) * paneHeight;
			
			butt = new Sprite();
			butt.x = 11;
			butt.y = 0;
			butt.graphics.beginFill(0x8E8E8E, 1);
			butt.graphics.drawRoundRect(0, 0, 8, buttonnHeight, 8, 8);
			butt.graphics.endFill();
			this.addChild(butt);
		}
		
		private function createMask(){
			this.maskShape = new Shape();
			maskShape.x = target.x;
			maskShape.y = targetY;
			maskShape.graphics.lineStyle(1, 0x000000, 0);
			maskShape.graphics.beginFill(0x000000, 1);
			maskShape.graphics.drawRect(0, 0, paneWidth, paneHeight);
			maskShape.graphics.endFill();
			this.target.parent.addChild(maskShape);
			this.target.mask = maskShape;
		}
		
		public function addEventListeners(){
			butt.buttonMode = true;
			butt.addEventListener("mouseDown", mouseDownHandler);
			butt.addEventListener("mouseUp", mouseUpHandler);
			target.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
		}
		
		public function removeEventListeners(){
			butt.buttonMode = false;
			butt.removeEventListener("mouseDown", mouseDownHandler);
			butt.removeEventListener("mouseUp", mouseUpHandler);
			butt.removeEventListener("rollOut", mouseUpHandler);
			stage.removeEventListener("mouseUp", mouseUpHandler);
			stage.removeEventListener("mouseMove", mouseMoveHandler);
			target.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
		}
		
		private function mouseDownHandler(e:MouseEvent){
			var rec:Rectangle = new Rectangle(11, 0, 0, paneHeight - butt.height);
			butt.startDrag(false, rec);
			stage.addEventListener("mouseUp", mouseUpHandler);
			stage.addEventListener("mouseMove", mouseMoveHandler);
		}
		private function mouseUpHandler(e:MouseEvent){
			stage.removeEventListener("mouseUp", mouseUpHandler);
			stage.removeEventListener("mouseMove", mouseMoveHandler);
			butt.stopDrag();
		}
		private function mouseMoveHandler(e:MouseEvent){
			scrollRatio = butt.y / (paneHeight - butt.height);
			this.scroll(scrollRatio);
		}
		
		public function scroll(ratio:Number, alignButton:Boolean = false){
			this.scrollRatio = ratio;
			var scrollDel = paneHeight - this.target.height;
			if(scrollDel <= 0){
				target.y = targetY + scrollDel * ratio;
			}
			else{
				target.y = targetY;
			}
	
			if(alignButton){
				butt.y = (target.y - targetY) / scrollDel  * (paneHeight - butt.height);
			}
		}
		
		public function mouseWheelHandler(e:MouseEvent){
			if(this.visible){
				var dir:int = e.delta > 0 ? 1 : -1;				
				var scrollDel = paneHeight - target.height;
				var yPosNew = target.y + dir * 6;
				
				if(yPosNew > targetY){
					this.scroll(0, true);
				}
				else if(yPosNew < scrollDel + targetY){
					this.scroll(1, true);
				}
				else{
					scrollRatio = (yPosNew - targetY) / scrollDel;
					this.scroll(scrollRatio, true);
				}
			}
		}
		
		public function resizeHandler(w:Number, h:Number, ratio:Number = -1){
			this.paneWidth = w;
			this.paneHeight = h;
			this.scrollRatio = ratio >= 0 ? ratio : scrollRatio;
			
			this.graphics.clear();
			this.graphics.beginFill(0x444444, 1);
			this.graphics.drawRoundRect(12, 0, 6, paneHeight, 8, 8);
			this.graphics.endFill();
			
			var scrollDel = paneHeight - target.height,
				heightRatio = paneHeight / (target.height > 0 ? target.height : 1),
				buttonnHeight = (heightRatio < buttRatioMin ? buttRatioMin : (heightRatio >= buttRatioMax ? buttRatioMax : heightRatio)) * paneHeight;
				
			butt.graphics.clear();
			butt.graphics.beginFill(0x8E8E8E, 1);
			butt.graphics.drawRoundRect(0, 0, 8, buttonnHeight, 8, 8);
			butt.graphics.endFill();
			
			maskShape.x = target.x;
			maskShape.graphics.clear();
			maskShape.graphics.lineStyle(1, 0x000000, 0);
			maskShape.graphics.beginFill(0x000000, 1);
			maskShape.graphics.drawRect(0, 0, paneWidth, paneHeight);
			maskShape.graphics.endFill();
			
			this.visible = scrollDel < 0;
			this.scroll(this.scrollRatio, true);
		}
		
		public function remove(){
			this.removeEventListeners();
			this.target.parent.removeChild(maskShape);
			this.target.mask = null;
		}

	}
	
}
