package{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	
	public class ColorHolder extends Sprite{
		public var warning:Shape;
		public var colorLabel:TextField;
		public var colorData:Object; //* properties: color, setId, label *//
		public var fillalpha:int;
		public var isSet:Boolean = false;
		
		private var inWidth:Number;
		private var inHeight:Number;
		private var counter:int;

		public function ColorHolder(_x:Number,_y:Number, w:Number, h:Number, colorData:Object){
			this.x = _x;
			this.y = _y;
			this.colorData = colorData; //new Object();
			this.createBgd(w,h,0x000000,0);
			this.createLabel();
			this.inWidth = w;
			this.inHeight = h;
			this.setColor(colorData);
		}
		
		public function setColor(colorData:Object){
			trace("ColorHolder: "+colorData.color);
			this.colorData = colorData;
			this.isSet = true;
			this.colorize(colorData.color, 1);
			colorLabel.text = this.colorData.label;
		}
		
		public function createBgd(w:Number, h:Number, fillcolor:uint, falpha:int = 1, bcolor:uint = 0x191919){
			//this.colorData.color = fillcolor;
			this.fillalpha = falpha;
			this.graphics.clear();
			this.graphics.lineStyle(3, bcolor, 1, true, "normal", "square", "miter", 3);
			this.graphics.beginFill(fillcolor, falpha);
			this.graphics.drawRect(0, 0, w, h);
			this.graphics.endFill();
		}
		
		public function resizeHandler(w:Number, h:Number){
			this.createBgd(w,h,this.colorData.color,this.fillalpha);
		}
		
		public function colorize(fcolor:uint, falpha:int){
			this.createBgd(this.inWidth,this.inHeight,fcolor,falpha);
		}
		
		public function showEmptyWarning(){
			if(!warning){
				counter = 0;
				warning = new Shape();
				this.addChild(warning);
				this.addEventListener("enterFrame", borderColorWarning);
			}
		}
		
		private function borderColorWarning(e:Event){
			var balpha:int = 1;
			
			if(counter > 40){
				counter = 0;
				warning.graphics.clear();
				this.removeChild(warning);
				warning = null;
				this.removeEventListener("enterFrame", borderColorWarning);
			}else if(counter%10 < 5){
				warning.graphics.lineStyle(1, 0xFF0000, 1);
				warning.graphics.drawRect(2, 2, this.width-4, this.height-5);
			}else{
				warning.graphics.clear();
			}

			counter++;
		}
		
		private function createLabel(){
			colorLabel = new TextField();
			colorLabel.multiline = false;
			colorLabel.text = this.colorData.label;
			colorLabel.embedFonts = true;
			colorLabel.antiAliasType = "advanced";
			colorLabel.setTextFormat(Studio.rootStg.getTextFormatCond(10, "left", 0xffffff));
			colorLabel.x = 0;
			colorLabel.y = -16;
			this.addChild(colorLabel);
			
			
		}
		
	}
}

