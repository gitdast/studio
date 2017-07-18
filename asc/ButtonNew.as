package  {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFormat
	import flash.text.TextFormatAlign;
	import flash.geom.Rectangle;
	
	public class ButtonNew extends ButtonBase{
		public var mc_bgd:MovieClip;

		public function ButtonNew(w:int, h:int, name:String = "", displayHint:Boolean = true, displayLabel:Boolean = false){
			if(name != "") this.name = name;
			
			super(displayHint, displayLabel);
			
			var cornerRadius = 16;
			
			mc_bgd.scale9Grid = new Rectangle(cornerRadius, cornerRadius, mc_bgd.width - 2 * cornerRadius, mc_bgd.height - 2 * cornerRadius);
			mc_bgd.width = w;
			mc_bgd.height = h;
			//this.createBgd(w, h);
		}
		
		override public function overHandler(e:MouseEvent){
			this.transform.colorTransform = COLOR_TRANS_OVER;
		}
		override public function outHandler(e:MouseEvent){
			this.transform.colorTransform = COLOR_TRANS_NORMAL;
		}
		
		private function createBgd(w:int, h:int){
			/*
			sTool.graphics.lineStyle(1, 0x000000, 1);
			sTool.graphics.beginGradientFill("linear", [0x444444, 0x222222], [1, 255], [0x00, 0xFF], matrix, "pad");
			sTool.graphics.drawRect(-toolW/2, -toolW/2, toolW, toolW);
			sTool.graphics.endFill();*/
		}
									 

	}
	
}
