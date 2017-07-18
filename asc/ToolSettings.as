package{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	import flash.geom.ColorTransform;
	
	public class ToolSettings extends Sprite{
		public var slider:Slider;
		public var toolName:String;
		
		public static const HEIGHT = 45;
		public static const sliderPadding = 15;
		
		private const radiusMin = 2;
		private const radiusMax = 14;
		private const toleranceMin = 0;
		private const toleranceMax = 70;
		
		public function ToolSettings(_toolname:String){
			trace("ToolSettings: init...");
			this.toolName = _toolname;
			this.addLabel();
			this.addIcon();
			this.createSlider();
		}
		
		private function createSlider(){
			var xOffsetForIcon = 40;
				
			//* bgd
			this.graphics.beginFill(0x444444, 1);
			this.graphics.drawRoundRect(Studio.PANEL_PADDING, Studio.PANEL_PADDING, Studio.PANEL_WIDTH - 2 * Studio.PANEL_PADDING, ToolSettings.HEIGHT, 16, 16);
			this.graphics.endFill();
			
			slider = new Slider(Studio.PANEL_WIDTH - 2 * Studio.PANEL_PADDING - xOffsetForIcon, 30, sliderPadding, 10, Studio.rootStg.panelTools["setting_" + toolName.replace(/plus|minus/i, "")]);
			slider.x = Studio.PANEL_PADDING + xOffsetForIcon;
			slider.y = Studio.PANEL_PADDING + ToolSettings.HEIGHT / 2;
			this.addChild(slider);
			
			slider.addCallback(this.sliderCallback);
		}
		
		public function sliderCallback(val:Number){
			Studio.rootStg.panelTools["setting_" + toolName.replace(/plus|minus/i, "")] = val;
			if(["gum", "brush"].indexOf(toolName) >= 0){
				 Studio.rootStg.artBoard.updateCursor();
			}
		}
		
		private function addIcon(){
			var icoClassRef:Class = getDefinitionByName("ico_tool_" + toolName) as Class,
				ico = new icoClassRef();
			ico.scaleX = ico.scaleY = .75;
			ico.x = Studio.PANEL_PADDING + sliderPadding + ico.width / 2;
			ico.y = Studio.PANEL_PADDING + ToolSettings.HEIGHT / 2;
			ico.transform.colorTransform = new ColorTransform(0,0,0,0,0,157,225,255);
			this.addChild(ico);			
		}
		
		private function addLabel(){
			var format = Studio.rootStg.getTextFormatCond(12, "left", 0x8E8E8E);
			
			var labelField = new TextField();
			labelField.autoSize = "left";
			labelField.text = Studio.rootStg.xmlDictionary.getTranslate(toolName+"Settings");
			labelField.setTextFormat(format);
			labelField.embedFonts = true;
			labelField.antiAliasType = "advanced";
			labelField.x = 30;
			labelField.y = 10;
			
			this.addChild(labelField);
		}
		
		public function remove(){
			this.slider.removeEventListeners()
		}
		
	}	
}
