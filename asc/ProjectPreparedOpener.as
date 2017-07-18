package{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.filters.DropShadowFilter;
	import flash.events.MouseEvent;
	
	import flash.net.FileReference;
    import flash.net.URLRequest;
    import flash.net.FileFilter;
	import flash.display.Loader;
	import flash.display.SimpleButton;
	
	public class ProjectPreparedOpener extends Sprite{
		public var bgd:Shape;
		public var preloader:MovieClip;
		public var xmlProjects:XmlProjects;
		public var butt_close;
		
		public var lock:Boolean = false;
		
		public var pWidth:Number;
		public var pHeight:Number;
		
		public const imgW:Number = 158;
		public const imgH:Number = 100;
		
		public function ProjectPreparedOpener(w:Number, h:Number){
			//trace("ProjectPreparedOpener: init...");
			pWidth = w;
			pHeight = h;
			this.createBackground(pWidth,pHeight);
			this.addLoading();
			this.addButtonClose();
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
		
		private function addButtonClose(){
			butt_close = new buttonInfoClose();
			butt_close.x = pWidth - butt_close.width - 10;
			butt_close.y = 20;
			butt_close.addEventListener("click", closeHandler);
			this.addChild(butt_close);
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
		}
		
		private function closeHandler(e:MouseEvent){
			//Studio.rootStg.panelMain.butt_foto.gotoAndStop(1);
			Studio.rootStg.closeProjectOpener();
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

			var sh_filters:Array = new Array(new DropShadowFilter(3, 75, 0x000000, 0.5, 4, 4, 1, 1));
			bgd.filters = sh_filters;
		}
		
		public function removeAll(){
			if(xmlProjects) xmlProjects.removeEventListener(XmlProjects.XML_READY, this.projectsXmlReady);
			if(butt_close) butt_close.removeEventListener("click", closeHandler);
			
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
