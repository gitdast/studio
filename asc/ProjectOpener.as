package{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import fl.controls.TextInput;
	import flash.filters.DropShadowFilter;
	import flash.events.MouseEvent;
	
	import flash.net.FileReference;
    import flash.net.URLRequest;
    import flash.net.FileFilter;
	import flash.display.Loader;
	import flash.display.SimpleButton;
	
	public class ProjectOpener extends Sprite{
		public var bgd:Shape;
		public var preloader:MovieClip;
		public var xmlProjects:XmlProjects;
		public var fileRef:FileReference;
		public var inputSprite:Sprite;
		public var inputField:TextInput;
		public var buttFileRef:ButtonFile;
		public var buttLoad:ButtonFile;
		
		public var lock:Boolean = false;
		
		public var pWidth:Number;
		public var pHeight:Number;
		
		public const imgW:Number = 158;
		public const imgH:Number = 100;
		
		public function ProjectOpener(w:Number, h:Number){
			//trace("ProjectOpener: init...");
			pWidth = w;
			pHeight = h;
			this.createBackground(pWidth,pHeight);
			this.addEventListener("rollOut", mouseOutHandler);
			this.addLoading();
			this.loadProjects();
		}
		
		public function loadProjects(){
			xmlProjects = new XmlProjects();
			xmlProjects.addEventListener(XmlProjects.XML_READY, this.projectsXmlReady);
			xmlProjects.loadXml(Studio.rootStg.xmlConfig.getPreparedProjectsUrl());
		}
		
		public function projectsXmlReady(e:Event){
			//trace("ProjectOpener: projectsXml ready");
			this.createThumbnails();
		}
		
		private function createThumbnails(){
			var preparedLabel:TextField = new TextField();
			preparedLabel.x = 20;
			preparedLabel.y = 25;
			preparedLabel.autoSize = "left";
			preparedLabel.text = Studio.rootStg.xmlDictionary.getTranslate("labelPreparedProjects");
			this.addChild(preparedLabel);
			Studio.rootStg.addTextFormatBold(preparedLabel, 14, 0x000000);
			
			var categoryNum:int = 0;
			for each(var categoryNode:XML in xmlProjects.xml.category){
				this.createCategoryVertical(categoryNum, categoryNode);
				categoryNum++;
			}
		}
		
		private function createCategoryVertical(catNum:int, catNode:XML){
			var catLabel:TextField = new TextField();
			catLabel.x = 20;
			catLabel.y = catNum*40 + catNum*imgH + 50;
			catLabel.autoSize = "left";
			catLabel.text = catNode.@name;
			this.addChild(catLabel);
			Studio.rootStg.addTextFormat(catLabel, 12, 0x000000);
			
			var category = new ProjectThumbnailCategoryPrepared(catNode, pWidth-40);
			category.x = 20;
			category.y = 70 + catNum*40 + catNum*imgH;
			this.addChild(category);
		}
		
		public function thumbnailsReady(){
			this.removeLoading();
			this.addFormNew();
			this.addFormLoad();
		}
		
		private function addFormNew(){
			var fy = xmlProjects.xml.category.length() * (imgH+40) + 70;
			
			var newProjectLabel:TextField = new TextField();
			newProjectLabel.x = 20;
			newProjectLabel.y = fy;
			newProjectLabel.autoSize = "left";
			newProjectLabel.text = Studio.rootStg.xmlDictionary.getTranslate("labelNewProjects");
			this.addChild(newProjectLabel);
			Studio.rootStg.addTextFormatBold(newProjectLabel, 14, 0x000000);
			
			var fileLabel:TextField = new TextField();
			fileLabel.x = 20;
			fileLabel.y = fy += 30;
			fileLabel.autoSize = "left";
			fileLabel.text = Studio.rootStg.xmlDictionary.getTranslate("labelChooseNewProject");
			this.addChild(fileLabel);
			Studio.rootStg.addTextFormat(fileLabel, 12, 0x000000);
			
			buttFileRef = new ButtonFile();
			var buttlabel:String = Studio.rootStg.xmlDictionary.getTranslate("buttonChooseNewProject");
			buttFileRef.buttonMode = true;
			buttFileRef.mouseChildren = false;
			buttFileRef.x = 20;
			buttFileRef.y = fy += 20;
			buttFileRef.dt_label.text = buttlabel.toUpperCase();
			buttFileRef.dt_label.autoSize = "left";
			buttFileRef.bgd.width = buttFileRef.dt_label.textWidth + 20;
			addChild(buttFileRef);
			buttFileRef.addEventListener("click", fileRefButtonClickHandler);
			/*
			bgd.graphics.lineStyle(1,0x666666,1);
			bgd.graphics.moveTo(20, fy+45);
			bgd.graphics.lineTo(pWidth-20, fy+45);
			*/
		}
		
		function fileRefButtonClickHandler(e:MouseEvent):void {
			this.lock = true;
			fileRef = new FileReference();
			fileRef.browse([new FileFilter("Images", "*.jpg;*.gif;*.png")]);
			fileRef.addEventListener(Event.SELECT, onFileSelected);
			fileRef.addEventListener(Event.CANCEL, onFileSelected);
		}

		function onFileSelected(e:Event):void {
			this.lock = false;
			trace("opener size:", fileRef.size);
			//if(fileRef.size > ) ...bitmapdata limit okolo 4MB
			fileRef.addEventListener(Event.COMPLETE, onFileLoaded);
			fileRef.load();
		}

		function onFileLoaded(e:Event):void {
			Studio.rootStg.closeProjectOpener();
			Studio.rootStg.createNewProject(e.target.data);
		}
		
		private function addFormLoad(){
			var lastChild = this.getChildAt(this.numChildren-1);
			var fy =  lastChild.y - 20;
			
			var inputLabel:TextField = new TextField();
			inputLabel.x = pWidth/2 - 30;
			inputLabel.y = fy;
			inputLabel.autoSize = "left";
			inputLabel.text = Studio.rootStg.xmlDictionary.getTranslate("labelOpenSavedProject");
			this.addChild(inputLabel);
			Studio.rootStg.addTextFormat(inputLabel, 12, 0x000000);

			inputField = new TextInput();
			inputField.x = pWidth/2 - 30;
			inputField.y = fy + 20;
			inputField.width = 120;
			Studio.rootStg.addTextFormat(inputField.textField, 14, 0x0099FF);
			this.addChild(inputField);

			buttLoad = new ButtonFile();
			var buttlabel:String = Studio.rootStg.xmlDictionary.getTranslate("buttonOpenSavedProject");
			buttLoad.buttonMode = true;
			buttLoad.mouseChildren = false;
			buttLoad.x = pWidth/2 - 30 + inputField.width + 10;
			buttLoad.y = fy + 20;
			buttLoad.dt_label.text = buttlabel.toUpperCase();
			buttLoad.dt_label.autoSize = "left";
			buttLoad.bgd.width = buttLoad.dt_label.textWidth + 20;
			addChild(buttLoad);
			buttLoad.addEventListener("click", buttonLoadClickHandler);
			//inputSprite.addEventListener("click", inputFieldClickHandler);
		}
		
		private function buttonLoadClickHandler(e:MouseEvent){
			//Studio.rootStg.panelMain.butt_home.gotoAndStop(1);
			Studio.rootStg.closeProjectOpener();
			var tf = inputField.textField;
			trace("ProjectOpener: clicked button load and id=",tf.text,"---");
			Studio.rootStg.createLoadProject(tf.text);
		}
		/*
		private function inputFieldClickHandler(e:MouseEvent){
			var tf = inputSprite.getChildAt(0) as TextField;
			stage.focus = tf;
			stage.focus = tf;
			tf.text = "";
		}*/
		
		
		private function mouseOutHandler(e:MouseEvent){
			/*if(this.lock || Studio.rootStg.panelMain.butt_home.hitTestPoint(e.stageX, e.stageY, true)){
				//trace("stay open");
			}else{
				//trace("closing");
				Studio.rootStg.panelMain.butt_home.gotoAndStop(1);
				Studio.rootStg.closeProjectOpener();
			}*/
		}
		
		private function addLoading(){
			preloader = new loading();
			preloader.x = pWidth/2;
			preloader.y = pHeight/2;
			this.addChild(preloader);
		}
		
		private function removeLoading(){
			if(preloader) this.removeChild(preloader);
			preloader = null;
		}
		
		public function createBackground(w:Number, h:Number){
			bgd = new Shape();
			this.addChild(bgd);

			bgd.graphics.beginFill(0xDDDDDD, 1);
			bgd.graphics.drawRoundRect(0, 0, w, h, 8, 8);
			bgd.graphics.endFill();
			bgd.graphics.beginFill(0x0066CC, 1);
			bgd.graphics.drawRoundRect(0, 0, w, 15, 8, 8);
			bgd.graphics.endFill();
			bgd.graphics.beginFill(0xDDDDDD, 1);
			bgd.graphics.drawRect(0, 10, w, 5);
			bgd.graphics.endFill();
			/*
			bgd.graphics.lineStyle(1, 0x999999, 1);
			bgd.graphics.beginFill(0xFFFFFF, 1);
			bgd.graphics.drawRect(10,20,w-20,h-30);
			bgd.graphics.endFill();
			*/
			var sh_filters:Array = new Array(new DropShadowFilter(3, 75, 0x000000, 0.5, 4, 4, 1, 1));
			bgd.filters = sh_filters;
		}
		
		public function removeAll(){
			if(xmlProjects) xmlProjects.removeEventListener(XmlProjects.XML_READY, this.projectsXmlReady);
			this.removeEventListener("rollOut", mouseOutHandler);
			if(buttFileRef) buttFileRef.removeEventListener("click", fileRefButtonClickHandler);
			if(buttLoad) buttLoad.removeEventListener("click", buttonLoadClickHandler);
			//if(inputSprite) inputSprite.removeEventListener("click", inputFieldClickHandler);
			
			var child;
			for(var i:int=this.numChildren-1; i>=0; i--){
				child = this.getChildAt(i);
				if(child is ProjectThumbnailCategory){
					child.removeAll();
				}
			}
			bgd.graphics.clear();
		}

	}
	
}
