package  {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	
	public class ButtonColorset extends ButtonBase{
		private var id:String;
		private var groupId:String;
		public var isActive:Boolean;
		
		private var controlWidth:Number;
		public static const BUTT_HEIGHT:int = 25;

		public function ButtonColorset(w:Number, groupId:String, id:String, _name:String){
			trace("ButtonColorset init", groupId, id, _name);
			this.groupId = groupId;
			this.id = id;
			this.controlWidth = w;
			
			this.createBackground();

			super(false, true);
			
			this.name = "colorset_" + id;
			this.labelField.text = this.labelText = _name;
			this.labelField.setTextFormat(Studio.rootStg.getTextFormat2(13, "center", 0x333333));
			this.labelField.y = 0; //* to get correct this.height
			this.labelField.y = this.height/2 - labelField.height / 2;			
			
			this.enable();
		}
		
		override public function overHandler(e:MouseEvent){
			if(this.isActive)
				return;
			this.labelField.transform.colorTransform = COLOR_TRANS_OVER;
		}
		override public function outHandler(e:MouseEvent){
			if(this.isActive)
				return;
			this.labelField.transform.colorTransform = COLOR_TRANS_NORMAL;
		}
		
		override public function clickHandler(e:MouseEvent){
			Studio.rootStg.panelColors.colorsetsMenu.switchButtons(this.id);
			//this.setActive(true);			
		}
		
		public function setActive(activate:Boolean){
			this.isActive = activate;
			
			var gradHeight:Number = this.height,
				matrix:Matrix = new Matrix();
				
			matrix.createGradientBox(this.width, gradHeight, Math.PI / 2, 0, 0);
			this.graphics.clear();
			if(activate){
				this.labelField.transform.colorTransform = COLOR_TRANS_WACTIVE;
				
				this.graphics.beginGradientFill("linear", [0x009de1, 0x67D1FF], [1, 1], [0x00, 0xFF], matrix, "pad");
				this.graphics.drawRoundRect(0, 0, controlWidth, BUTT_HEIGHT, 12);
				this.graphics.endFill();
			}
			else{
				this.labelField.transform.colorTransform = COLOR_TRANS_NORMAL;
				
				this.graphics.beginGradientFill("linear", [0xFFFFFF, 0xbebebe], [1, 1], [0x00, 0xFF], matrix, "pad");
				this.graphics.drawRoundRect(0, 0, controlWidth, BUTT_HEIGHT, 12);
				this.graphics.endFill();
			}
		}
		
		public function createBackground(){
			var gradHeight:Number = BUTT_HEIGHT,
				matrix:Matrix = new Matrix();
				
			matrix.createGradientBox(controlWidth, gradHeight, Math.PI / 2, 0, 0);

			this.graphics.beginGradientFill("linear", [0xFFFFFF, 0xbebebe], [1, 1], [0x00, 0xFF], matrix, "pad");
			this.graphics.drawRoundRect(0, 0, controlWidth, BUTT_HEIGHT, 12);
			this.graphics.endFill();
		}

	}
	
}
