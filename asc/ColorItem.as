package{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.text.TextField;
	import fl.motion.Color;
	
	public class ColorItem extends Sprite {
		public var r:Number;
		public var g:Number;
		public var b:Number;
		public var colorInstance:Color;
		public var colorLabel:TextField;
		protected var displayLabel:Boolean = true;
		private var initIndex:int;
		
		public static const COLOR_SIZE = 40;
		public static const COLOR_SCALE_HOVER = 1.2;
	
		public function ColorItem(_name:String, r:Number, g:Number, b:Number){
			this.name = _name;
			this.mouseChildren = false;
			this.r = r;
			this.g = g;
			this.b = b;
			this.colorInstance = new Color(0,0,0,0,r,g,b,1);
			
			this.drawRect();
			this.enable();
			
			if(this.displayLabel){
				this.addEventListener("enterFrame", addColorLabel);
			}
		}

		public function drawRect(){
			this.graphics.lineStyle(2, 0xffffff, 1, true, "normal", "square", "miter", 3);
			this.graphics.beginFill(colorInstance.color, 1);
			this.graphics.drawRect(-COLOR_SIZE/2, -COLOR_SIZE/2, COLOR_SIZE, COLOR_SIZE);
			this.graphics.endFill();
		}
		
		public function enable(){
			this.addEventListeners();
			if(this.colorLabel){
				this.addLabelListeners();
			}
		}
		
		public function disable(){
			this.removeEventListeners();
			if(this.colorLabel){
				this.colorLabel.visible = false;
			}
		}
		
		public function addEventListeners(){
			this.buttonMode = true;
			this.addEventListener("mouseOver", overHandler);
			this.addEventListener("mouseOut", outHandler);
			this.addEventListener("click", clickHandler);
		}
		
		public function addLabelListeners(){
			this.addEventListener("rollOver", rollOverHandler);
			this.addEventListener("rollOut", rollOutHandler);
		}
		
		public function removeEventListeners(){
			this.buttonMode = false;
			this.removeEventListener("mouseOver", overHandler);
			this.removeEventListener("mouseOut", outHandler);
			this.removeEventListener("click", clickHandler);
			this.removeEventListener("rollOver", rollOverHandler);
			this.removeEventListener("rollOut", rollOutHandler);
			this.removeEventListener(MouseEvent.MOUSE_MOVE, moveColorLabel);
			this.removeEventListener("enterFrame", this.addColorLabel);
		}
		
		public function overHandler(e:MouseEvent){
			this.scaleX = COLOR_SCALE_HOVER;
			this.scaleY = COLOR_SCALE_HOVER;
			this.initIndex = this.parent.getChildIndex(this);
			this.parent.swapChildren(this, parent.getChildAt(parent.numChildren-1));
		}
		
		public function outHandler(e:MouseEvent){
			this.scaleX = 1;
			this.scaleY = 1;
			this.parent.swapChildren(this, parent.getChildAt(initIndex));
		}
		
		public function clickHandler(e:MouseEvent){
		}
		
		public function addColorLabel(e:Event){
			if(!this.stage){
				return;
			}
			
			var tf = Studio.rootStg.getTextFormatCond(10, "left", 0xffffff);
			tf.letterSpacing = 0.9;
			
			colorLabel = new TextField();
			colorLabel.multiline = false;
			colorLabel.autoSize = "left";
			colorLabel.mouseEnabled = false;
			colorLabel.defaultTextFormat = tf;
			colorLabel.text = this.name;
			colorLabel.embedFonts = true;
			colorLabel.antiAliasType = "advanced";
			colorLabel.visible = false;
			
			this.stage.addChild(colorLabel);
			
			this.addLabelListeners();
			
			this.removeEventListener("enterFrame", addColorLabel);
		}
		
		public function rollOverHandler(e:MouseEvent){
			colorLabel.visible = true;
			colorLabel.x = e.stageX;
			colorLabel.y = e.stageY - 25;
			this.addEventListener(MouseEvent.MOUSE_MOVE, moveColorLabel);
		}
		
		public function rollOutHandler(e:MouseEvent){
			colorLabel.visible = false;
			this.removeEventListener(MouseEvent.MOUSE_MOVE, moveColorLabel);
		}
		
		protected function moveColorLabel(e:MouseEvent){
			colorLabel.x = e.stageX;
			colorLabel.y = e.stageY - 25;
		}
		
		public function remove(){
			this.removeEventListeners();
			if(this.colorLabel){
				this.stage.removeChild(this.colorLabel);
			}
		}
	}
	
}
