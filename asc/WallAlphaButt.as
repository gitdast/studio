package{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.filters.GlowFilter;
	import flash.filters.BevelFilter;
	
	public class WallAlphaButt extends Sprite{
		public var sTool:Sprite;
		public var activeWall:WallsControlItem;
		
		
		private const pWidth = 55;
		private const pHeight = 34;
		private const opacityMin = 0;
		private const opacityMax = 1;
		
		private var pomX:Number;
		private var pomY:Number;
		
		private var baseY:Number;
		
		public function WallAlphaButt(contY:Number){
			//baseY = contY + this.pHeight/2; ..before scroll
			
			this.createRecSlider();
			this.initRecSliderButton(0);
			
			this.addEventListeners();
		}
		
		public function changeWall(wall:WallsControlItem){
			this.activeWall = wall;
			//this.y = baseY + wall.y ...before scroll
			var wc = Studio.rootStg.panelWalls.wallsControl;
			this.y = 10 + wall.y + wc.wallsCont.y;
			this.initRecSliderButton(wall.wallAlpha);
		}
		
		private function createRecSlider(){
			//* slider's axis *//
			this.graphics.lineStyle(2, 0x191919, 1);
			this.graphics.moveTo(0, 0);
			this.graphics.lineTo(pWidth, 0);
			
			//* slider's button *//
			var toolW:int = 10;
			var b_filter:Array = new Array(new BevelFilter(1,45,0xFFFFFF,0.7,0,0.7,1,1,1,1));
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(toolW, toolW, (Math.PI/180)*90, 0, 0);
			
			sTool = new Sprite();
			sTool.x = toolW/2;
			sTool.y = 0;
			sTool.graphics.lineStyle(1, 0x000000, 1);
			sTool.graphics.beginGradientFill("linear", [0x444444, 0x222222], [1, 255], [0x00, 0xFF], matrix, "pad");
			sTool.graphics.drawRect(-toolW/2, -toolW/2, toolW, toolW);
			sTool.graphics.endFill();
			sTool.filters = b_filter;
			this.addChild(sTool);
		}
		
		private function initRecSliderButton(opacity:Number){
			var l = pWidth;
			var initX = (opacity - opacityMin) / (opacityMax - opacityMin) * l;
			this.sTool.x = initX;
			//trace(sTool.x);
		}
		
		private function mouseRecDownHandler(e:MouseEvent){
			var rec:Rectangle = new Rectangle(0, 0, pWidth, 0);
			sTool.startDrag(false, rec);
			sTool.addEventListener("rollOut", mouseRecUpHandler);
		}
		private function mouseRecUpHandler(e:MouseEvent){
			sTool.removeEventListener("rollOut", mouseRecUpHandler);
			sTool.stopDrag();
			var l = pWidth;
			var ratio = (sTool.x) / l;
			var opacity = opacityMin + (opacityMax - opacityMin)*ratio;
			Studio.rootStg.panelWalls.wallsControl.signalAlphaChanged(opacity);
		}
		
		public function addEventListeners(){
			//this.mouseChildren = false;
			sTool.buttonMode = true;
			sTool.addEventListener("mouseDown", mouseRecDownHandler);
			sTool.addEventListener("mouseUp", mouseRecUpHandler);
		}
		
		public function removeEventListeners(){
			sTool.buttonMode = false;
			sTool.removeEventListener("mouseDown", mouseRecDownHandler);
			sTool.removeEventListener("mouseUp", mouseRecUpHandler);
			sTool.removeEventListener("rollOut", mouseRecUpHandler);
		}
	}
	
}
