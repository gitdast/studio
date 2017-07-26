package{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFormat
	import flash.text.TextFormatAlign;
	import flash.utils.getQualifiedClassName;
	import flash.events.Event;
	
	public class ButtonBase extends MovieClip{
		public var labelField:TextField;
		public var hintField:TextField;
		public var labelText:String;
		protected var displayLabel:Boolean;
		protected var displayHint:Boolean;
		
		protected const COLOR_TRANS_NORMAL = new ColorTransform();
		protected const COLOR_TRANS_DISABLED = new ColorTransform(0,0,0,1,105,105,105,1);
		protected const COLOR_TRANS_ACTIVE = new ColorTransform(0,0,0,0,0,157,225,255);
		protected const COLOR_TRANS_WACTIVE = new ColorTransform(0,0,0,0,255,255,255,255);
		protected const COLOR_TRANS_OVER = new ColorTransform(0,0,0,1,0,153,255,0);
		
		public function ButtonBase(displayHint:Boolean = true, displayLabel:Boolean = false, _name:String = null){
			this.name = _name ? _name : this.name;
			this.y = PanelMain.PANEL_HEIGHT / 2;
			this.mouseChildren = false;
			this.labelText = Studio.rootStg.xmlDictionary.getTranslate(this.name.substr(0,8) == "instance" ? getQualifiedClassName(this) : this.name);
			this.displayHint = displayHint;
			this.displayLabel = displayLabel;
			
			if(displayLabel && this.labelText){
				this.addLabel();
			}
			if(displayHint && this.labelText){
				this.addEventListener("enterFrame", this.addHintLabel);
				this.addTitleListeners();
			}
			
			this.disable();
		}
		
		public function enable(){
			this.addEventListeners();
			this.transform.colorTransform = COLOR_TRANS_NORMAL;
			
			if(this.displayHint && this.labelText){
				this.addTitleListeners();
			}
		}
		
		public function disable(){
			this.gotoAndStop(1);
			this.removeEventListeners();
			this.transform.colorTransform = COLOR_TRANS_DISABLED;
			if(this.hintField) hintField.visible = false;
		}
		
		public function addEventListeners(){
			this.buttonMode = true;
			this.addEventListener("mouseOver", overHandler);
			this.addEventListener("mouseOut", outHandler);
			this.addEventListener("click", clickHandler);
		}
		
		public function removeEventListeners(){
			this.buttonMode = false;
			this.removeEventListener("mouseOver", overHandler);
			this.removeEventListener("mouseOut", outHandler);
			this.removeEventListener("click", clickHandler);
			this.removeEventListener("rollOver", rollOverHandler);
			this.removeEventListener("rollOut", rollOutHandler);
			this.removeEventListener(MouseEvent.MOUSE_MOVE, moveHintField);
		}
		
		public function overHandler(e:MouseEvent){
			this.gotoAndStop(2);
		}
		public function outHandler(e:MouseEvent){
			this.gotoAndStop(1);
		}
		public function clickHandler(e:MouseEvent){
		}
		
		public function addTitleListeners(){
			this.addEventListener("rollOver", rollOverHandler);
			this.addEventListener("rollOut", rollOutHandler);
		}
		
		public function rollOverHandler(e:MouseEvent){
			hintField.visible = true;
			hintField.x = e.stageX;
			hintField.y = e.stageY - 25;
			this.addEventListener(MouseEvent.MOUSE_MOVE, moveHintField);
		}
		
		public function rollOutHandler(e:MouseEvent){
			hintField.visible = false;
			this.removeEventListener(MouseEvent.MOUSE_MOVE, moveHintField);
		}
		
		protected function moveHintField(e:MouseEvent){
			hintField.x = e.stageX;
			hintField.y = e.stageY - 25;
		}
		
		protected function addHintLabel(e:Event){
			var tf = Studio.rootStg.getTextFormatCond(10, "left", 0xffffff);
			tf.letterSpacing = 0.9;
			
			hintField = new TextField();
			hintField.multiline = false;
			hintField.autoSize = "left";
			hintField.mouseEnabled = false;
			hintField.defaultTextFormat = tf;
			hintField.text = this.labelText;
			hintField.embedFonts = true;
			hintField.antiAliasType = "advanced";
			
			this.stage.addChild(hintField);
			
			hintField.visible = false;
			
			this.removeEventListener("enterFrame", this.addHintLabel);
		}
		
		protected function addLabel(){
			var format = Studio.rootStg.getTextFormatBold(14, "center", 0x333333);
			
			labelField = new TextField();
			labelField.width = this.width;
			labelField.height = this.height;
			labelField.autoSize = "center";
			labelField.selectable = false;
			labelField.defaultTextFormat = format;
			labelField.text = this.labelText;
			labelField.setTextFormat(format);
			labelField.embedFonts = true;
			labelField.antiAliasType = "advanced";
			labelField.y -= Math.round(labelField.height / 2);
			
			this.addChild(labelField);
		}
		
		public function remove(){
			this.removeEventListeners();
			if(this.hintField){
				this.stage.removeChild(this.hintField);
			}
		}
		
	}
	
}
