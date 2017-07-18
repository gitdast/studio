package{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class PanelWalls extends Sprite{
		public var wallsControl:WallsControl;
		public var scrollBar:ScrollBarVertical;
		
		public var butt_newWall;
		public var butt_calculate;
		public var mc_bgd:MovieClip;
		
		public var state:String;
		public var panelHeight:int;
		
		private const WALLSCONTROL_YPOS:int = 40;

		public function PanelWalls(h:Number){
			this.x = 0;
			this.y = Logo.PANEL_HEIGHT + PanelMain.PANEL_HEIGHT + PanelSave.PANEL_HEIGHT + PanelTools.PANEL_HEIGHT;
			this.panelHeight = h - this.y;
			trace("PanelWalls: init", panelHeight);
			
			this.createBackground();
			this.addLabel();
		}
		
		// testing
		public function testingStart(){
			this.addWallsControl("active");
			this.wallsControl.addFirstWall();
		}
		
		public function addWallsControl(state:String = "active"):WallsControl{
			this.state = state;
			
			var controlHeight = panelHeight - WALLSCONTROL_YPOS - Studio.PANEL_PADDING,
				controlWidth = Studio.PANEL_WIDTH;
				
			if(state == "active"){
				butt_newWall = new ButtonNewWall(false, true);
				butt_newWall.x = Studio.PANEL_PADDING;
				butt_newWall.y = WALLSCONTROL_YPOS + butt_newWall.height / 2 + 10 + WallsControlItem.CONTROL_HEIGHT;
				
				this.addChild(butt_newWall);
				
				controlHeight -= butt_newWall.height - 10;
			}
			else if(state == "pasive"){
			}
			
			if(wallsControl){
				this.removeWallsControl();
			}
			
			wallsControl = new WallsControl(controlHeight);
			wallsControl.x = 0;
			wallsControl.y = WALLSCONTROL_YPOS;
			this.addChildAt(wallsControl, getChildIndex(butt_newWall));
			
			scrollBar = new ScrollBarVertical(wallsControl, controlWidth, controlHeight);
			scrollBar.x = controlWidth - Studio.PANEL_PADDING;
			scrollBar.y = WALLSCONTROL_YPOS;
			this.addChild(scrollBar);
			
			return wallsControl;
		}
		
		public function removeWallsControl(){
			if(wallsControl){
				wallsControl.remove();
				this.removeChild(wallsControl);
				wallsControl = null;
			}
			
			if(scrollBar){
				scrollBar.remove();
				this.removeChild(scrollBar);
				scrollBar = null;
			}
			
			if(butt_newWall){
				butt_newWall.removeEventListeners();
				this.removeChild(butt_newWall);
			}
		}
		
		private function addLabel(){
			var format = Studio.rootStg.getTextFormatCond(15, "left", 0x8E8E8E);
			
			var labelField = new TextField();
			labelField.autoSize = "left";
			labelField.text = Studio.rootStg.xmlDictionary.getTranslate("wallsControlLabel");
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
			mc_bgd.height = this.panelHeight;
			this.addChild(mc_bgd);
		}
		
		public function resizeHandler(h:Number, scrollRatio:Number = -1){
			this.panelHeight = h - this.y;
			mc_bgd.height = this.panelHeight;
			
			var controlHeight = panelHeight - WALLSCONTROL_YPOS - Studio.PANEL_PADDING - (this.butt_newWall ? butt_newWall.height + 10 : 0);
			
			if(this.wallsControl) this.wallsControl.resizeHandler(controlHeight);
			if(this.scrollBar) this.scrollBar.resizeHandler(controlHeight, scrollRatio);
			if(this.butt_newWall) {
				butt_newWall.y = WALLSCONTROL_YPOS + Math.min(wallsControl.height, controlHeight) + 10 + butt_newWall.height / 2;
			}
		}
	}
	
}
