package{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.display.MovieClip;
	import flash.utils.getQualifiedClassName;
	
	public class HomepagePrepared extends Sprite{
		protected var labelField:TextField;
		protected var labelText:String;
		protected var preloader:MovieClip;
		protected var xmlProjects:XmlProjects;
		protected var scrollBars:Array = [];
		protected var categories:Array = [];
		protected var labels:Array = [];
	
		public var lock:Boolean = false;
		
		private var controlWidth:int;
		private var controlHeight:int;
		
		private const labelPosition:int = 30;

		public function HomepagePrepared(stageW:Number, stageH:Number){
			this.controlWidth = stageW - Studio.PANEL_WIDTH - 4 * Studio.PANEL_PADDING;
			this.controlHeight = stageH - 4 * Studio.PANEL_PADDING;
			this.x = Studio.PANEL_WIDTH + 2 * Studio.PANEL_PADDING;
			this.y = 2 * Studio.PANEL_PADDING;			
			this.labelText = Studio.rootStg.xmlDictionary.getTranslate("ProjectsPreparedLabel");
			
			this.addLabel();
			this.addPreloader();
			this.loadProjects();
		}
		
		public function loadProjects(){
			xmlProjects = new XmlProjects();
			xmlProjects.addEventListener(XmlProjects.XML_READY, this.createThumbnails);
			xmlProjects.loadXml(Studio.rootStg.xmlConfig.getPreparedProjectsUrl());
		}
		
		private function createThumbnails(e:Event){
			var category: ProjectThumbnailCategoryPrepared,
				categoryNum:int = 0;
				
			for each(var categoryNode:XML in xmlProjects.xml.category){
				category = this.createCategory(categoryNum, categoryNode);
				this.addScrollbar(categoryNum, category);
				categoryNum++;
			}
		}
		
		private function createCategory(catNum:int, catNode:XML):ProjectThumbnailCategoryPrepared{
			var catLabel:TextField = new TextField(),
				margin:int = Studio.PANEL_PADDING,
				count:int = xmlProjects.xml.category.length(),
				w:int = Math.floor((controlWidth - (count - 1) * margin) / count);
			
			catLabel.x = catNum * (w + margin);
			catLabel.y = labelPosition;
			catLabel.autoSize = "left";
			catLabel.text = catNode.@name;
			catLabel.setTextFormat(Studio.rootStg.getTextFormat2(16, "left", 0x8e8e8e));
			this.addChild(catLabel);
			this.labels.push(catLabel);
			
			var category = new ProjectThumbnailCategoryPrepared(w, catNum, catNode);
			category.x = catNum * (w + margin);
			category.y = catLabel.y + 30;
			this.addChild(category);
			this.categories.push(category);
			
			return category;
		}
		
		private function addScrollbar(num:int, category:ProjectThumbnailCategoryPrepared){
			var scrollBar = new ScrollBarVertical(category, category.controlWidth, this.controlHeight - this.labelPosition);
			scrollBar.x = category.getScrollbarPosition();//category.x + category.controlWidth - Studio.PANEL_PADDING;
			scrollBar.y = category.y;
			this.addChild(scrollBar);
			this.scrollBars.push(scrollBar);
		}
		
		public function thumbnailsReady(num:int){
			trace(num, categories.length);
			if(num == categories.length - 1){
				this.removePreloader();
			}
			this.scrollBars[num].resizeHandler(categories[num].controlWidth, this.controlHeight - this.labelPosition, 0);			
		}
		
		private function addLabel(){
			var format = Studio.rootStg.getTextFormatBold(18, "left", 0x8e8e8e);
			
			labelField = new TextField();
			labelField.autoSize = "left";
			labelField.selectable = false;
			labelField.text = this.labelText;
			labelField.setTextFormat(format);
			labelField.embedFonts = true;
			labelField.antiAliasType = "advanced";
			labelField.y = 0 - labelField.height / 2;
			labelField.x = 0;
			this.addChild(labelField);
		}
		
		private function addPreloader(){
			preloader = new loading();
			preloader.x = controlWidth / 2;
			preloader.y = controlHeight / 2;
			this.addChild(preloader);
		}
		
		private function removePreloader(){
			if(preloader) this.removeChild(preloader);
			preloader = null;
		}		
		
		public function resizeHandler(stageW:Number, stageH:Number){
			this.controlWidth = stageW - Studio.PANEL_WIDTH - 4 * Studio.PANEL_PADDING;
			this.controlHeight = stageH - 4 * Studio.PANEL_PADDING;
			
			var margin:int = Studio.PANEL_PADDING,
				count:int = xmlProjects.xml.category.length(),
				w:int = Math.floor((controlWidth - (count - 1) * margin) / count);
			
			var child;
			for(var i:int = this.numChildren - 1; i > 0; i--){
				child = this.getChildAt(i);
				if(getQualifiedClassName(child) == "ProjectThumbnailCategoryPrepared"){
					child.x = child.num * (w + margin);
					child.resizeHandler(w);
					this.labels[child.num].x = child.x;
				}
				else if(getQualifiedClassName(child) == "ScrollBarVertical"){
					child.x = child.target.getScrollbarPosition();//child.target.x + child.target.controlWidth - Studio.PANEL_PADDING;
					child.resizeHandler(w, this.controlHeight - labelPosition, 0);
				}
			}
		}
		
		/**
		* scrollBar.remove odebira child ze sveho parent (masku), takze iterace pres numChildren nevhodna 
		*/
		public function remove(){
			var child, i:int;
			for(i = 0; i < scrollBars.length; i++){
				scrollBars[i].remove();
				this.removeChild(scrollBars[i]);
			}
			for(i = this.numChildren - 1; i > 0; i--){
				child = this.getChildAt(i);
				if(getQualifiedClassName(child) == "ProjectThumbnailCategoryPrepared"){
					child.remove();
					this.removeChild(child);
				}
			}
		}

	}
	
}
