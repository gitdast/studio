package{
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.text.TextField;
	
	public class PanelBottom extends Sprite{
		public var tfieldLeft:TextField;
		public var tfieldRight:TextField;
		
		private var panelWidth:Number;
		private const panelHeight = 15;
		
		public function PanelBottom(w:Number, h:Number){
			trace("PanelBottom: init");
			this.x = 0;
			this.y = h - panelHeight;
			this.panelWidth = w;
			this.createBackground(w);
			this.addText();
		}
		
		private function addText(){
			tfieldRight = new TextField();
			tfieldRight.autoSize = "left";
			tfieldRight.text = Studio.rootStg.xmlDictionary.getTranslate("bottomPanelRight");
			this.addChild(tfieldRight);

			Studio.rootStg.addTextFormat2(tfieldRight, 9, 0xAAAAAA);
			tfieldRight.x = this.width - tfieldRight.textWidth - 10;
			tfieldRight.y = 0;
			
			tfieldLeft = new TextField();
			tfieldLeft.autoSize = "left";
			tfieldLeft.text = Studio.rootStg.xmlDictionary.getTranslate("bottomPanelLeft");
			this.addChild(tfieldLeft);

			Studio.rootStg.addTextFormat2(tfieldLeft, 9, 0xAAAAAA);
			tfieldLeft.x = 0;
			tfieldLeft.y = 0;
			
			this.checkTextWidth();
		}
		
		private function checkTextWidth(){
			if(tfieldLeft.textWidth + tfieldRight.textWidth > this.panelWidth)
				tfieldLeft.visible = false;
			else
				tfieldLeft.visible = true;
		}
		
		private function createBackground(w:Number){
			this.graphics.lineStyle(1, 0x000000, 1);
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(w, 15, (Math.PI/180)*90, 0, 00);
			this.graphics.beginGradientFill("linear", [0x333333, 0x222222], [1, 50], [0x00, 0xFF], matrix, "pad");
	 		this.graphics.drawRect(0, 0, w, panelHeight);
			this.graphics.endFill();
		}
		
		public function resizeHandler(w:Number, h:Number){
			this.panelWidth = w;
			this.y = h - panelHeight;
			this.graphics.clear();
			this.graphics.lineStyle(1, 0x000000, 1);
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(w, 15, (Math.PI/180)*90, 0, 00);
			this.graphics.beginGradientFill("linear", [0x333333, 0x222222], [1, 50], [0x00, 0xFF], matrix, "pad");
			this.graphics.drawRect(0, 0, w, panelHeight);
			this.graphics.endFill();
			
			tfieldRight.x = w - tfieldRight.textWidth - 10;
			
			this.checkTextWidth();
		}
	}
	
}
