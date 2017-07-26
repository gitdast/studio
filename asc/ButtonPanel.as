package  {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.filters.DropShadowFilter;
	
	public class ButtonPanel extends ButtonBase{
		private var id:String;
		private var groupId:String;
		public var isActive:Boolean;
		
		private var controlWidth:Number;
		public static const BUTT_HEIGHT:int = 31;

		public function ButtonPanel(w:int, _name:String){
			trace("ButtonPanel init", _name);
			this.controlWidth = w;
			this.createBackground();
			
			super(false, true, _name);
			this.labelField.y = 0; //* to get correct this.height
			this.labelField.y = this.height/2 - labelField.height / 2;
			
			this.enable();
		}
		
		override public function overHandler(e:MouseEvent){
			this.labelField.transform.colorTransform = COLOR_TRANS_WACTIVE;
			
			var gradHeight:Number = this.height,
				matrix:Matrix = new Matrix();
				
			matrix.createGradientBox(this.width, gradHeight, Math.PI / 2, 0, 0);
			this.graphics.clear();
			this.graphics.beginGradientFill("linear", [0x67D1FF, 0x009de1], [1, 1], [0x00, 0xFF], matrix, "pad");
			this.graphics.drawRoundRect(0, 0, controlWidth, BUTT_HEIGHT, 12);
			this.graphics.endFill();
		}
		
		override public function outHandler(e:MouseEvent){
			this.labelField.transform.colorTransform = COLOR_TRANS_NORMAL;
			
			var gradHeight:Number = this.height,
				matrix:Matrix = new Matrix();
				
			matrix.createGradientBox(this.width, gradHeight, Math.PI / 2, 0, 0);
			this.graphics.clear();
			this.graphics.beginGradientFill("linear", [0xFFFFFF, 0xbebebe], [1, 1], [0x00, 0xFF], matrix, "pad");
			this.graphics.drawRoundRect(0, 0, controlWidth, BUTT_HEIGHT, 12);
			this.graphics.endFill();
		}
		
		override public function clickHandler(e:MouseEvent){
		}
		
		public function createBackground(){
			var gradHeight:Number = BUTT_HEIGHT,
				matrix:Matrix = new Matrix();
				
			matrix.createGradientBox(controlWidth, gradHeight, Math.PI / 2, 0, 0);

			this.graphics.beginGradientFill("linear", [0xFFFFFF, 0xbebebe], [1, 1], [0x00, 0xFF], matrix, "pad");
			this.graphics.drawRoundRect(0, 0, controlWidth, BUTT_HEIGHT, 12);
			this.graphics.endFill();
			
			var shadow:DropShadowFilter = new DropShadowFilter(2, 40, 0x000000, 0.5, 4, 4, 2, 2);
			this.filters = new Array(shadow);
		}

	}
	
}
