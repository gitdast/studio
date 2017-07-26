package{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class PanelTools extends Sprite{
		public var tsettings:ToolSettings;
		public var activeTool:Tool;		
		private var namesArray:Array = ["curvePlus", "curveMinus", "magicPlus", "magicMinus", "brush", "gum", "move"];
		private var hasSettingsArray:Array = ["magicPlus", "magicMinus", "brush", "gum"];
		
		public var setting_brush:Number = 0.5; //* brushThickness = 8
		public var setting_gum:Number = 0.5; //* gumThickness = 8
		public var setting_magic:Number = 1; //* wandTolerance = 15
		
		public var mc_bgd:MovieClip;
		
		public static const PANEL_HEIGHT = 170;
		
		public function PanelTools(){
			trace("PanelTools: init");
			this.x = 0;
			this.y = Logo.PANEL_HEIGHT + PanelMain.PANEL_HEIGHT + PanelSave.PANEL_HEIGHT;
			
			this.createBackground();
			this.addLabel();
			this.addTools();
		}
		
		private function addTools(toolsEnable:Boolean = false){
			var tool:Tool;
			var xPos:int = Studio.PANEL_PADDING,
				margin:int = 11,
				yPos1 = 55;
				
			for(var i = 0; i < namesArray.length; i++){
				tool = new Tool(namesArray[i]);
				tool.x = xPos + tool.width / 2;
				tool.y = yPos1;
				
				xPos += tool.width + margin;
				
				this.addChild(tool);
				if(toolsEnable) tool.enable();				
			}
			
			if(toolsEnable){
				tool = getChildByName("curvePlus") as Tool;
				tool.setActive(true);
			}
		}
		
		public function enable(){
			var tool:Tool;
			for(var i=0; i<namesArray.length; i++){
				tool = getChildByName(namesArray[i]) as Tool;
				tool.enable();
			}
		}
		
		public function disable(){
			var tool:Tool;
			for(var i=0; i<namesArray.length; i++){
				tool = getChildByName(namesArray[i]) as Tool;
				tool.disable();
			}
			this.removeSettings();
		}
		
		public function changeToolHandler(activateTool:Tool){
			this.activeTool = activateTool;
			
			var tool:Tool;
			for(var i=0; i<namesArray.length; i++){
				tool = getChildByName(namesArray[i]) as Tool;
				if(tool.name != activateTool.name){
					tool.setActive(false);
				}
			}
			
			this.removeSettings();
			if(hasSettingsArray.indexOf(activateTool.name) >= 0){
				this.addSettings(activateTool.name);
			}
		}
				
		public function deselectTool(){
			if(activeTool){
				activeTool.setActive(false);
				this.removeSettings();
			}
			
			Studio.rootStg.artBoard.setMode("");
		}
		
		/***** settings *****/
		
		private function addSettings(_tname:String){
			tsettings = new ToolSettings(_tname);
			tsettings.y = 75;
			this.addChild(tsettings);
		}
		
		private function removeSettings(){
			if(tsettings){
				tsettings.remove();
				this.removeChild(tsettings);
				tsettings = null;
			}
		}
		
		/***** rest *****/
		
		protected function addLabel(){
			var format = Studio.rootStg.getTextFormatCond(15, "left", 0x8E8E8E);
			
			var labelField = new TextField();
			labelField.selectable = false;
			labelField.autoSize = "left";
			labelField.text = Studio.rootStg.xmlDictionary.getTranslate("toolsLabel");
			labelField.setTextFormat(format);
			labelField.embedFonts = true;
			labelField.antiAliasType = "advanced";
			labelField.x = 30;
			labelField.y = 10;
			
			this.addChild(labelField);
		}
		
		private function createBackground(){
			mc_bgd = new background_panel();
			mc_bgd.width = Studio.PANEL_WIDTH;
			mc_bgd.height = PANEL_HEIGHT;
			this.addChild(mc_bgd);
			
			var settingsShape = new Sprite();
			settingsShape.y = 75;
			settingsShape.graphics.lineStyle(1, 0x444444);
			settingsShape.graphics.beginFill(0x444444, 0.2);
			settingsShape.graphics.drawRoundRect(Studio.PANEL_PADDING + 1, Studio.PANEL_PADDING + 1, Studio.PANEL_WIDTH - 2 * Studio.PANEL_PADDING - 2, ToolSettings.HEIGHT - 2, 16, 16);
			settingsShape.graphics.endFill();
			this.addChild(settingsShape);
		}
		
	}
	
}
