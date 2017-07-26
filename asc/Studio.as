package{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	//import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.FileReference;
	import flash.net.FileFilter;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat
	import flash.text.TextFormatAlign;
	import prepared.ArtBoardPrepared;
	
	public class Studio extends MovieClip{
		public static var rootStg:Studio;
		public var xmlConfig:XmlConfig;
		public var xmlDictionary:XmlDictionary;
		
		public var project;
		
		public var sessionIdLabel:TextField;
		public var sessionIdField:TextField;
		public var sessionEmail:String;
		public var temp:Array = new Array();
		public var homepage;//:Homepage;
		
		public var panelLogo:Logo;
		public var panelMain:PanelMain;
		public var panelSave:PanelSave;
		public var panelTools:PanelTools;
		public var panelWalls:PanelWalls;
		public var panelColors:PanelColors;
		public var panelInfo;
		public var artBoard;
		public var opener;//:ProjectOpener/ProjectPreparedOpener;
		public var fileRef:FileReference;
		public var preloader;
		
		
		public var appResizable:Boolean = true;
		public var appWidth:Number;
		public var appHeight:Number;
		
		public static const PANEL_WIDTH:Number = 340;
		public static const PANEL_PADDING:Number = 30;
		public static const VERSION = 1.0;
		
		public function Studio(){
			trace("Studio: starting...");
			
			rootStg = this;
			stage.scaleMode = "noScale";
			stage.align = "TL";
			
			this.init();
		}
		
		private function init(){
			xmlConfig = new XmlConfig();
			xmlConfig.addEventListener(XmlConfig.XML_READY, this.configXmlReady);
			xmlConfig.loadXml(loaderInfo.parameters.configFile);
		}
		
		public function configXmlReady(e:Event){
			trace("Studio: config ready");
			this.loadDictionary();
		}
		
		private function loadDictionary(){
			xmlDictionary = new XmlDictionary();
			xmlDictionary.addEventListener(XmlDictionary.XML_READY, this.dictXmlReady);
			xmlDictionary.loadXml(xmlConfig.getDictUrl());
		}
		
		public function dictXmlReady(e:Event){
			trace("Studio: dictionary ready");
			this.calculateDimensions();
			this.setScene();
		}
		
		private function calculateDimensions(){
			this.appResizable = xmlConfig.getConfigResizable();
			stage.stageWidth = this.appWidth = appResizable ? stage.stageWidth : xmlConfig.getConfigWidth();
			stage.stageHeight = this.appHeight = appResizable ? stage.stageHeight : xmlConfig.getConfigHeight();
			if(appWidth < 500) this.appWidth = 500;
			if(appHeight < 460) this.appHeight = 460;
		}
		
		private function setScene(){
			this.createLogo();
			this.createPanelMain();
			this.createPanelSave();
			this.createPanelTools();
			this.createPanelWalls();
			//panelWalls.testingStart();
			//this.createPanelColors();
			//this.createPanelBottom();
			
			////this.getSessionId();
			if(this.appResizable) stage.addEventListener(Event.RESIZE, resizeHandler);
			
			this.addHomepage();
		}
		
		private function resizeHandler(e:Event){
			this.calculateDimensions();

			panelWalls.resizeHandler(appHeight);
			if(panelColors) panelColors.resizeHandler(appWidth, appHeight);
			if(artBoard) artBoard.resizeHandler(appWidth, appHeight);
			if(panelInfo) panelInfo.resizeHandler(appWidth, appHeight);
			if(homepage) homepage.resizeHandler(appWidth, appHeight);
		}
		
		private function createLogo(){
			panelLogo = new Logo();
			this.addChild(panelLogo);
		}

		private function createPanelMain(){
			panelMain = new PanelMain();
			this.addChild(panelMain);
		}
		
		private function createPanelSave(){
			panelSave = new PanelSave();
			this.addChild(panelSave);
		}
		
		private function createPanelTools(){
			panelTools = new PanelTools();
			this.addChild(panelTools);
		}
		
		private function createPanelWalls(){
			panelWalls = new PanelWalls(appHeight);
			this.addChild(panelWalls);
		}
		
		public function createPanelColors(wallNum:int){
			panelColors = new PanelColors(appWidth, appHeight, 500, 700);
			this.addChildAt(panelColors, this.numChildren);
		}
		
		public function createPanelNew(){
			if(panelInfo) closePanelInfo();
			
			panelInfo = new PanelNew(appWidth, appHeight, 450, 350);
			this.addChild(panelInfo);
			panelInfo.slideDown();
		}
		
		public function createPanelInfoClose(callback:Function = null){
			if(panelInfo) closePanelInfo();
			
			panelInfo = new PanelInfoClose(appWidth, appHeight, 400, 300, callback);
			this.addChild(panelInfo);
			panelInfo.slideDown();
		}
			
		public function createPanelInfoSave(_name:String = null){
			if(panelInfo) closePanelInfo();
			
			panelInfo = new PanelInfoSave(appWidth, appHeight, 500, 300, _name);
			this.addChild(panelInfo);
			panelInfo.slideDown();
		}
		
		
		
		public function createPanelInfoLoad(){
			if(panelInfo) closePanelInfo();
			
			panelInfo = new PanelInfoLoad(appWidth, appHeight, 400, 200);
			this.addChildAt(panelInfo, getChildIndex(panelMain));
			panelInfo.slideDown();
		}
		
		private function closePanelInfo(){
			if(panelInfo){
				panelInfo.remove();
				this.removeChild(panelInfo);
				panelInfo = null;
			}
		}
		
		public function addHomepage(){
			this.closeProject();
			
			if(homepage){
				this.removeHomepage();
			}
				
			this.homepage = new Homepage(appWidth, appHeight);
			this.addChildAt(homepage, 0);
		}
		
		public function addHomepagePrepared(){
			this.closeProject();
			
			if(homepage){
				this.removeHomepage();
			}
			
			this.homepage = new HomepagePrepared(appWidth, appHeight);
			this.addChildAt(homepage, 0);
		}
		
		private function removeHomepage(){
			if(homepage){
				homepage.remove();
				this.removeChild(homepage);
				homepage = null;
			}
		}
		
		public function createArtBoard(type:String):ArtBoard{
			this.removeArtBoard();
			switch(type){
				case "new":
					this.artBoard = new ArtBoardNew(appWidth, appHeight);
					break;
				case "load":
					this.artBoard = new ArtBoardLoad(appWidth, appHeight);
					break;
				case "prepared":
					this.artBoard = new ArtBoardPrepared(appWidth, appHeight);
					break;
				case "restored":
					this.artBoard = new ArtBoardRestored(appWidth, appHeight);
					break;
			}
			var depth = (panelInfo) ? getChildIndex(panelInfo) : getChildIndex(panelMain);
			this.addChildAt(artBoard, depth);
			return artBoard;
		}
		
		public function removeArtBoard(){
			if(artBoard){
				artBoard.remove();
				this.removeChild(artBoard);
				this.artBoard = null;
			}
		}
		
		public function createPreparedProject(prObject){
			if(project) this.closeProject();
			if(homepage) this.removeHomepage();
			if(panelInfo) this.closePanelInfo();
			
			this.project = new ProjectPrepared(prObject);
			this.project.loadPreparedProject();
		}
		
		public function createNewProject(byteData){
			if(project) this.closeProject();
			if(homepage) this.removeHomepage();
			if(panelInfo) this.closePanelInfo();
			
			this.project = new ProjectNew();
			this.project.loadImg(byteData);
		}
		
		public function createLoadProject(prId){
			if(project) this.closeProject();
			if(homepage) this.removeHomepage();
			
			this.createPanelInfoLoad();
			
			this.project = new ProjectNew();
			this.project.loadProject(prId);
		}
		
		public function createRestoredProject(prObject){
			if(project) this.closeProject();
			if(homepage) this.removeHomepage();
			if(panelInfo) this.closePanelInfo();
			
			if(prObject.type == "prepared")
				this.project = new ProjectPrepared(prObject);
			else
				this.project = new ProjectNew(prObject);
			
			this.project.restoreProject();
		}
		
		public function closeProject(){
			//if(panelInfo) closePanelInfo();
			if(project) this.project.closeProject();
			this.project = null;
			this.clearIdLabel();
			this.removeArtBoard();
			this.panelMain.disable();
			this.panelSave.disable();
			this.panelTools.disable();
			this.panelWalls.removeWallsControl();
		}
		
		public function openFileDialog(){
			fileRef = new FileReference();
			fileRef.browse([new FileFilter("Images", "*.jpg;*.gif;*.png")]);
			fileRef.addEventListener(Event.SELECT, onFileSelected);
		}
		
		private function onFileSelected(e:Event):void {
			trace("cs, file-size:", fileRef.size);
			//if(fileRef.size > ) ...bitmapdata limit okolo 4MB
			fileRef.addEventListener(Event.COMPLETE, onFileLoaded);
			fileRef.load();
			
		}
		
		private function onFileLoaded(e:Event):void {
			this.createNewProject(e.target.data);
		}
		
		public function addLoading(){
			preloader = new loading();
			preloader.x = appWidth/2;
			preloader.y = appHeight/2;
			this.addChild(preloader);
		}
		
		public function removeLoading(){
			if(preloader) this.removeChild(preloader);
			preloader = null;
		}
		
		public function setIdLabel(){
			if(!sessionIdField){
				sessionIdField = new TextField();
				sessionIdField.autoSize = "right";
				sessionIdField.multiline = false;
				sessionIdField.embedFonts = true;
				sessionIdField.antiAliasType = "advanced";
				sessionIdField.defaultTextFormat = this.getTextFormatCond(12, "right", 0x333333);
				sessionIdField.text = this.project.sessionId;
				sessionIdField.x = appWidth - sessionIdField.width - 15;
				sessionIdField.y = 10;
				this.addChild(sessionIdField);
			}else{
				sessionIdField.text = this.project.sessionId;
			}
			
			if(!sessionIdLabel){
				sessionIdLabel = new TextField();
				sessionIdLabel.autoSize = "left";
				sessionIdLabel.selectable = false;
				sessionIdLabel.text = Studio.rootStg.xmlDictionary.getTranslate("titleProjectID");
				sessionIdLabel.setTextFormat(this.getTextFormatBold(14, "left", 0x999999));
				sessionIdLabel.x = sessionIdField.x - sessionIdLabel.width - 10;
				sessionIdLabel.y = 10;
				this.addChild(sessionIdLabel);				
			}			
		}
		
		public function clearIdLabel(){
			if(sessionIdField) sessionIdField.text = "";
		}
		
		public function addTextFormat(tf:TextField, size:Number, color:uint){
			var valFormat = new TextFormat();
			valFormat.letterSpacing = 0.75;
			valFormat.size = size;
			valFormat.align = TextFormatAlign.LEFT;
			valFormat.color = color;
			valFormat.font = "HelveticaCE-Condensed-Light";
			tf.setTextFormat(valFormat);
			tf.embedFonts = true;
			tf.antiAliasType = "advanced";
		}
		
		public function addTextFormat2(tf:TextField, size:Number, color:uint){
			var valFormat = new TextFormat();
			valFormat.letterSpacing = 0.85;
			valFormat.size = size;
			valFormat.align = TextFormatAlign.LEFT;
			valFormat.color = color;
			valFormat.font = "HelveticaCE-Light";
			tf.setTextFormat(valFormat);
			tf.embedFonts = true;
			tf.antiAliasType = "advanced";
		}
		
		public function addTextFormat3(tf:TextField, size:Number, color:uint){
			var valFormat = new TextFormat();
			valFormat.letterSpacing = 0.85;
			valFormat.size = size;
			valFormat.align = "justify";
			valFormat.color = color;
			valFormat.font = "HelveticaCE-Light";
			tf.setTextFormat(valFormat);
			tf.embedFonts = true;
			tf.antiAliasType = "advanced";
		}
		
		public function addTextFormatObl(tf:TextField, size:Number, color:uint){
			var valFormat = new TextFormat();
			valFormat.letterSpacing = 0.85;
			valFormat.size = size;
			valFormat.align = TextFormatAlign.LEFT;
			valFormat.color = color;
			valFormat.font = "HelveticaCE-Condensed-LightObl";
			tf.setTextFormat(valFormat);
			tf.embedFonts = true;
			tf.antiAliasType = "advanced";
		}
		
		public function addTextFormatBold(tf:TextField, size:Number, color:uint){
			var valFormat = new TextFormat();
			valFormat.letterSpacing = 0.75;
			valFormat.size = size;
			valFormat.align = TextFormatAlign.LEFT;
			valFormat.color = color;
			valFormat.font = "HelveticaCE-Condensed-Bold";
			tf.setTextFormat(valFormat);
			tf.embedFonts = true;
			tf.antiAliasType = "advanced";
		}
		
		public function getTextFormatBold(size:int = 15, align:String = TextFormatAlign.CENTER, color:uint = 0x333333){
			var format = new TextFormat();
			format.size = size;
			format.align = align;
			format.color = color;
			format.letterSpacing = 0.75;
			format.font = "HelveticaCE-Condensed-Bold";
			return format;
		}
		
		public function getTextFormat2(size:int = 15, align:String = TextFormatAlign.LEFT, color:uint = 0x333333){
			var format = new TextFormat();
			format.size = size;
			format.align = align;
			format.color = color;
			format.letterSpacing = 0.85;
			format.font = "HelveticaCE-Light";
			return format;
		}
		
		public function getTextFormatCond(size:int = 15, align:String = TextFormatAlign.LEFT, color:uint = 0x333333){
			var format = new TextFormat();
			format.size = size;
			format.align = align;
			format.color = color;
			format.letterSpacing = 0.75;
			format.font = "HelveticaCE-Condensed-Light";
			return format;
		}
		
		public function getTextFormatRegular(size:int = 15, align:String = TextFormatAlign.LEFT, color:uint = 0x333333){
			var format = new TextFormat();
			format.size = size;
			format.align = align;
			format.color = color;
			format.letterSpacing = 0.75;
			format.font = "HelveticaCE-R";
			return format;
		}
		
	}
	
}
