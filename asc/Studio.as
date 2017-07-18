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
		
		public var projectP:Project;
		public var sessionId:String;
		public var sessionIdRequested:Boolean = false;
		public var sessionIdSaved:Boolean = false;
		public var sessionEmail:String;
		public var temp:Array = new Array();
		public var homepage:Homepage;
		
		public var panelLogo:Logo;
		public var panelMain:PanelMain;
		public var panelSave:PanelSave;
		public var panelTools:PanelTools;
		public var panelWalls:PanelWalls;
		public var panelColors:PanelColors;
		//public var panelBottom:PanelBottom;
		public var panelInfo;
		public var artBoard;
		public var opener;//:ProjectOpener/ProjectPreparedOpener;
		public var fileRef:FileReference;
		public var preloader;
		//public var saver:projectSaver;
		//public var submenu:PrintSubmenu;
		
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
			if(panelInfo) panelInfo.resizeHandler(appWidth);
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
			if(panelColors)
				return;
			panelColors = new PanelColors(appWidth, appHeight, 500);
			this.addChildAt(panelColors, this.numChildren);
		}
		/*
		private function createPanelBottom(){
			panelBottom = new PanelBottom(appWidth, appHeight);
			this.addChild(panelBottom);
		}
		*/
		public function createPanelInfoSave(){
			if(panelInfo) closePanelInfo();
			
			panelInfo = new PanelInfoSave(appWidth);
			this.addChildAt(panelInfo, getChildIndex(panelMain));
			panelInfo.slideDown();
		}
		
		public function createPanelInfoLoad(){
			if(panelInfo) closePanelInfo();
			
			panelInfo = new PanelInfoLoad(appWidth);
			this.addChildAt(panelInfo, getChildIndex(panelMain));
			panelInfo.slideDown();
		}
		
		public function createPanelInfoClose(goHome:Boolean=false, goWhere:String=""){
			if(panelInfo) closePanelInfo();
			
			panelInfo = new PanelInfoClose(appWidth, goHome, goWhere);
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
			if(!homepage){
				this.homepage = new Homepage(appWidth, appHeight);
				this.addChildAt(homepage, 0);
			}
		}
		
		private function removeHomepage(){
			if(homepage){
				homepage.remove();
				this.removeChild(homepage);
				homepage = null;
			}
		}
		
		public function createProjectOpener(){
			/* kvuli duplicite openeru docasne */
			if(opener) closeProjectOpener();
			
			var w = appWidth - 450;
			var h = 475;
			opener = new ProjectOpener(w,h);
			opener.x = 210;
			opener.y = 58;
			this.addChildAt(opener, this.numChildren);
		}
		
		public function tryCloseProjectOpener(e:MouseEvent):Boolean{
			if(opener.hitTestPoint(e.stageX, e.stageY, true)){
				//trace("cs: opener - stay open");
				return false;
			}else{
				this.closeProjectOpener();
				return true;
			}
		}
		
		public function closeProjectOpener(){
			opener.removeAll();
			this.removeChild(opener);
			opener = null;
			//panelMain.butt_home.gotoAndStop(1);
		}
		
		public function createProjectPreparedOpener(){
			/* kvuli duplicite openeru docasne */
			if(opener) closeProjectOpener();
			
			var w = appWidth - 450;
			var h = 350;
			opener = new ProjectPreparedOpener(w,h);
			opener.x = 210;
			opener.y = 58;
			this.addChildAt(opener, this.numChildren);
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
				artBoard.removeAll();
				this.removeChild(artBoard);
				this.artBoard = null;
			}
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
		
		public function createPreparedProject(prObject){
			if(projectP) this.closeProject();
			if(homepage) this.removeHomepage();
			if(panelInfo) this.closePanelInfo();
			
			this.projectP = new Project(prObject);
			this.projectP.loadPreparedProject();
		}
		
		public function createNewProject(byteData){
			if(projectP) this.closeProject();
			if(homepage) this.removeHomepage();
			if(panelInfo) this.closePanelInfo();
			
			this.projectP = new Project();
			this.projectP.loadImg(byteData);
		}
		
		public function createLoadProject(prId){
			if(projectP) this.closeProject();
			if(homepage) this.removeHomepage();
			
			this.createPanelInfoLoad();
			
			this.projectP = new Project();
			this.projectP.loadProject(prId);
		}
		
		public function createRestoredProject(prId){
			if(projectP) this.closeProject();
			if(homepage) this.removeHomepage();
			if(panelInfo) this.closePanelInfo();
			
			this.projectP = new Project();
			this.projectP.restoreProject(prId);
		}
		
		public function closeProject(){
			//if(panelInfo) closePanelInfo();
			if(projectP) this.projectP.closeProject();
			this.projectP = null;
			this.sessionId = null;
			this.sessionIdSaved = false;
			this.removeArtBoard();
			this.panelTools.disable();
			this.panelWalls.removeWallsControl();
			this.panelTools.clearIdLabel();
			this.panelMain.disable();
		}
		
		public function createSessionId(){
			if(!sessionIdRequested){
				this.sessionId = null;
				this.sessionIdSaved = false;
				this.sessionIdRequested = true;
				trace("cs: createSessionId = ...request");
			
				var url:String = Studio.rootStg.xmlConfig.getGetIdUrl();
				var req:URLRequest = new URLRequest(url);
				var loader = new URLLoader(req);
				loader.dataFormat = URLLoaderDataFormat.TEXT;
				loader.addEventListener(Event.COMPLETE, setSessionIdLoaded);
			}
		}
		
		public function setSessionIdLoaded(e:Event){
			trace(e.target.data);
			this.sessionId = e.target.data;
			this.sessionIdRequested = false;
			trace("cs: setSessionIdLoaded = ", this.sessionId);
			this.panelTools.setIdLabel();
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
