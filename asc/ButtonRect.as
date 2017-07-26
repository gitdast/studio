package  {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFormat
	import flash.text.TextFormatAlign;
	import flash.utils.getQualifiedClassName;
	
	public class ButtonRect extends ButtonBase{
		public var mc_bgd:MovieClip;
		protected const COLOR_TRANS_DISABLED2 = new ColorTransform(1,1,1,1,40,40,40,1);
		protected const COLOR_TRANS_BGD_DISABLED = new ColorTransform(0.8,0.8,0.8,0.5,-40,-40,-40,0.2);
		
		public function ButtonRect(displayHint:Boolean = true, displayLabel:Boolean = false, _name:String = ""){
			super(displayHint, displayLabel, _name);
		}
		
		override public function enable(){
			this.addEventListeners();
			
			this.mc_bgd.transform.colorTransform = COLOR_TRANS_NORMAL;
			
			if(this.displayHint && this.labelText){
				this.addTitleListeners();
			}
			
			if(this.labelField){
				this.labelField.transform.colorTransform = COLOR_TRANS_NORMAL;
			}
		}
		
		override public function disable(){
			this.gotoAndStop(1);
			this.removeEventListeners();
			
			this.mc_bgd.transform.colorTransform = COLOR_TRANS_BGD_DISABLED;
			
			if(this.hintField) hintField.visible = false;
			
			if(this.labelField){
				this.labelField.transform.colorTransform = COLOR_TRANS_DISABLED2;
			}
		}

	}
	
}
