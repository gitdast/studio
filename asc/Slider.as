package{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;

	public class Slider extends Sprite{
		public var sliderWidth:int;
		public var sliderHeight:int;
		public var sliderPadding:int;
		public var buttonRadius:int;
		
		public var axis:Sprite;
		public var butt:Sprite;
		public var callbacks:Array;

		public function Slider(w:int, h:int, p:int, r:int, initVal:Number = 0){
			this.sliderWidth = w;
			this.sliderHeight = h;
			this.sliderPadding = p;
			this.buttonRadius = r;
			this.callbacks = [];
			
			this.createSlider(initVal);
			
			this.addEventListeners();
		}
		
		private function createSlider(initVal:Number){
			axis = new Sprite();
			axis.graphics.beginFill(0x303030, 1);
			axis.graphics.drawRoundRect(0, -3, sliderWidth - 2 * sliderPadding, 6, 8, 8);
			axis.graphics.endFill();
			axis.x = sliderPadding;
			
			var shadow = new DropShadowFilter(1, 45, 0x787878, 0.6, 1, 1, 2);
			axis.filters = new Array(shadow);
			
			this.addChild(axis);
			
			var position:int = sliderPadding + Math.round((sliderWidth - 2 * sliderPadding) * initVal);
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(buttonRadius * 2, buttonRadius * 2, Math.PI / 2, 0, -buttonRadius);
			
			butt = new Sprite();
			butt.graphics.clear();
			butt.graphics.beginGradientFill("linear", [0xFFFFFF, 0xBEBEBE], [1, 1], [0, 255], matrix, "pad");
			butt.graphics.drawCircle(0, 0, buttonRadius);
			butt.graphics.endFill();
			butt.x = position;
			
			var shadowB = new DropShadowFilter(1, 60, 0x333333, 0.6, 4, 6, 2);
			butt.filters = new Array(shadowB);
			
			this.addChild(butt);
		}
		
		public function setPosition(val:Number){
			var position:int = sliderPadding + Math.round((sliderWidth - 2 * sliderPadding) * val);
			this.butt.x = position;
		}
		
		public function addCallback(callback:Function){
			this.callbacks.push(callback);
		}
		
		public function publishValue(){
			var val = (butt.x - sliderPadding) / (sliderWidth - 2 * sliderPadding);
			for(var i in this.callbacks){
				this.callbacks[i](val);
			}
		}
										
		public function addEventListeners(){
			butt.buttonMode = true;
			butt.addEventListener("mouseDown", mouseDownHandler);
			butt.addEventListener("mouseUp", mouseUpHandler);
		}
		
		public function removeEventListeners(){
			butt.buttonMode = false;
			butt.removeEventListener("mouseDown", mouseDownHandler);
			butt.removeEventListener("mouseUp", mouseUpHandler);
			this.stage.removeEventListener("mouseUp", mouseUpHandler);
		}
		
		private function mouseDownHandler(e:MouseEvent){
			var rec:Rectangle = new Rectangle(sliderPadding, 0, sliderWidth - 2 * sliderPadding, 0);
			butt.startDrag(false, rec);
			this.stage.addEventListener("mouseUp", mouseUpHandler);
		}
		
		private function mouseUpHandler(e:MouseEvent){
			butt.stopDrag();
			this.stage.removeEventListener("mouseUp", mouseUpHandler);
			this.publishValue();
		}
	}
	
}
