package{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	import flash.filters.GlowFilter;
	import flash.utils.getQualifiedClassName;
	import flash.events.KeyboardEvent;
	
	public class WallsControlItem extends Sprite{
		public var bgd:Sprite;
		public var labelWall:TextField;
		public var labelColor:TextField;
		public var colorRect:Sprite;
		public var buttRemove:ButtonBase;
		public var slider:Slider;
		
		public var colorData:Object = {};
		public var wallAlpha:Number = 0.5;
		public var wallNum:int;
		public var wallName:String;
		
		public var isActive:Boolean = false;
		
		private var controlWidth;
		public static const CONTROL_HEIGHT = 78;

		public function WallsControlItem(w:int, num:int, wallData:XML = null){
			trace("WallsControlItem: init...", num);
			this.controlWidth = w;
			this.wallNum = num;
			
			if(wallData){
				this.wallName = wallData.wall_name;
				if(wallData.hasOwnProperty("color")){
					var rgbcolor:Number;
					if(wallData.color.hasOwnProperty("definitions")){
						rgbcolor = ((wallData.color.definitions.@r << 16)& 0xff0000)  + ((wallData.color.definitions.@g << 8)& 0x00ff00) + ((wallData.color.definitions.@b)& 0xff);
					}
					if(wallData.color.hasOwnProperty("hex")){
						rgbcolor = wallData.color.hex;
					}
					this.colorData = {color:rgbcolor, setId:wallData.color.@setid, label:wallData.color.name};
				}
			}
			else{
				this.wallName = Studio.rootStg.xmlDictionary.getTranslate("defaultWall");
			}
			
			this.createBackground();
			this.addLabels();
			this.addColorRect();
			
			this.addEventListeners();
			
			if(Studio.rootStg.panelWalls.state == "active"){
				this.addButtons();
				this.addSlider();
				this.addEventListenersActive();
			}
			else{
				this.addEventListenersPasive();
			}			
		}
		
		public function addEventListeners(){
			this.colorRect.buttonMode = true;
			this.colorRect.addEventListener("click", colorClickHandler);
		}
		
		public function removeAllListeners(){
			this.removeEventListener("mouseOver", pasiveOverHandler);
			this.removeEventListener("mouseOut", pasiveOutHandler);
			
			this.removeEventListener("click", activeClickHandler);
			this.removeEventListener("keyDown", keyHandler);
			
			colorRect.removeEventListener("click", colorClickHandler);
		}
		
		private function colorClickHandler(e:MouseEvent){
			Studio.rootStg.createPanelColors(this.wallNum);
		}
		
		/***** active mode *****/
		
		public function addEventListenersActive(){
			this.mouseChildren = true;
			this.buttonMode = true;
			this.addEventListener("click", activeClickHandler);
			this.addEventListener("keyDown", keyHandler);
			
			this.buttRemove.enable();
			this.buttRemove.addEventListener("click", removeClickHandler);			
		}

		private function activeClickHandler(e:MouseEvent){
			e.preventDefault();
			
			//* reseting all after paint mode
			if(Studio.rootStg.artBoard && Studio.rootStg.artBoard.actionMode == "paint"){
				Studio.rootStg.panelWalls.wallsControl.reselectWall();
				Studio.rootStg.panelTools.deselectTool();
			}
			
			Studio.rootStg.panelWalls.wallsControl.changeWall(wallNum);
			
			if(getQualifiedClassName(e.target) != "flash.text::TextField"){
				stage.focus = null;
			}
			else if(labelWall.selectionBeginIndex == labelWall.selectionEndIndex){
				labelWall.setSelection(0, labelWall.length);
			}
		}
		
		private function keyHandler(e:KeyboardEvent){
			if(e.charCode == 13) stage.focus = null;
		}
		
		private function removeClickHandler(e:MouseEvent){
			Studio.rootStg.panelWalls.wallsControl.removeWall(this.wallNum);
		}
		
		/***** pasive mode *****/
		
		public function addEventListenersPasive(){
			this.mouseChildren = false;
			this.buttonMode = false;
			this.addEventListener("mouseOver", pasiveOverHandler);
			this.addEventListener("mouseOut", pasiveOutHandler);
			
		}
		
		private function pasiveOverHandler(e:MouseEvent){
			Studio.rootStg.artBoard.projectMc.signalWallOver(wallNum+1);
		}
		
		private function pasiveOutHandler(e:MouseEvent){
			Studio.rootStg.artBoard.projectMc.signalWallOut(wallNum+1);
		}
		
		/***** ----- *****/
		
		public function setSelected(selected:Boolean){
			if(selected){
				bgd.alpha = 1;
			}
			else{
				bgd.alpha = 0;
			}
		}
		
		private function addSlider(){
			var xOffsetForIcon = 0;
			var sliderPadding = 10;
			
			//* bgd
			var bgd = new Sprite();
			bgd.graphics.beginFill(0x444444, 1);
			bgd.graphics.drawRoundRect(55, colorRect.y, controlWidth / 2 - 10, 31, 16, 16);
			bgd.graphics.endFill();
			this.addChild(bgd);
			
			slider = new Slider(controlWidth / 2 - 10 - xOffsetForIcon, 31, sliderPadding, 7, 0.5);
			slider.x = 55 + xOffsetForIcon;
			slider.y = colorRect.y + 15;
			this.addChild(slider);
			
			slider.addCallback(this.sliderCallback);
		}
		
		public function sliderCallback(val:Number){
			
		}
		
		private function addButtons(){
			buttRemove = new Ico_remove();
			buttRemove.x = Studio.PANEL_PADDING + buttRemove.width/2 - 5;
			buttRemove.y = CONTROL_HEIGHT / 2;
			this.addChild(buttRemove);
		}
				
		private function addColorRect(){
			colorRect = new Sprite();
			colorRect.graphics.lineStyle(2, 0x777777, 1);
			colorRect.graphics.beginFill(0x000000, 0);
			colorRect.graphics.drawRect(0, 0, 31, 31);
			colorRect.graphics.endFill();
			colorRect.x = controlWidth - 40 - 31;
			colorRect.y = this.labelColor.y + this.labelColor.height + 5;
			
			var ico = new ico_color_empty();
			ico.x = colorRect.x + colorRect.width / 2;
			ico.y = colorRect.y + colorRect.height / 2;
			
			this.addChild(ico);
			this.addChild(colorRect);
			
			if(this.colorData.hasOwnProperty("color")){
				this.setColor(colorData);
			}
		}
		
		public function setColor(colorData:Object){
			this.colorData = colorData;
			
			labelColor.text = this.colorData.label;
			
			colorRect.graphics.clear();
			colorRect.graphics.lineStyle(2, 0x777777, 1);
			colorRect.graphics.beginFill(colorData.color, 1);
			colorRect.graphics.drawRect(0, 0, 31, 31);
			colorRect.graphics.endFill();
		}
		
		private function addLabels(){
			var format = Studio.rootStg.getTextFormatCond(12, "right", 0x8E8E8E);
			labelColor = new TextField();
			labelColor.autoSize = "center";
			labelColor.text = Studio.rootStg.xmlDictionary.getTranslate("colorLabel");
			labelColor.setTextFormat(format);
			labelColor.multiline = false;
			labelColor.embedFonts = true;
			labelColor.antiAliasType = "advanced";
			labelColor.x = controlWidth - 40 - labelColor.width + 2;
			labelColor.y = 14;
			this.addChild(labelColor);
			
			labelWall = new TextField();
			labelWall.type = "input";
			labelWall.autoSize = "left";
			labelWall.maxChars = 30;
			labelWall.multiline = false;
			labelWall.embedFonts = true;
			labelWall.antiAliasType = "advanced";
			labelWall.defaultTextFormat = Studio.rootStg.getTextFormatBold(18, "left", 0x8E8E8E);
			labelWall.text = wallName;
			labelWall.x = 55 - 2;
			labelWall.y = 8;
			this.addChild(labelWall);
		}
		
		private function createBackground(){
			//var g_filter = new GlowFilter(0x333333, 0.6, 2, 3, 2, 15, true);
			bgd = new Sprite();
			bgd.graphics.lineStyle(1, 0x444444, 1);
			bgd.graphics.beginFill(0x666666, 1);
			bgd.graphics.drawRect(0, 0, controlWidth, CONTROL_HEIGHT);
			bgd.graphics.endFill();
			
			//bgd.filters = new Array(g_filter);
			bgd.alpha = 0;			
			this.addChild(bgd);
			
			this.graphics.lineStyle(1, 0x444444, 1);
			this.graphics.moveTo(Studio.PANEL_PADDING, 0);
			this.graphics.lineTo(controlWidth - Studio.PANEL_PADDING, 0);
			this.graphics.moveTo(Studio.PANEL_PADDING, CONTROL_HEIGHT);
			this.graphics.lineTo(controlWidth - Studio.PANEL_PADDING, CONTROL_HEIGHT);
		}
		
		public function remove(){
			this.removeAllListeners();
			if(this.buttRemove){
				this.buttRemove.remove();
				this.buttRemove.removeEventListener("click", removeClickHandler);
			}
		}
								 

	}
	
}
