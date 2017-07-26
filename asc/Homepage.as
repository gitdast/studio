package{
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	
	public class Homepage extends Sprite{
		public var loadForm:MovieClip;
		public var loadFormTextDefault:String;
		public var thumbnailCategory:ProjectThumbnailCategoryTemp;
		public var scrollBar:ScrollBarVertical;
		
		private var controlWidth:int;
		private var controlHeight:int;


		public function Homepage(stageW:Number, stageH:Number){
			this.controlWidth = stageW - Studio.PANEL_WIDTH - 4 * Studio.PANEL_PADDING;
			this.controlHeight = stageH - 4 * Studio.PANEL_PADDING;
			this.x = Studio.PANEL_WIDTH + 2 * Studio.PANEL_PADDING;
			this.y = 0;			
			this.loadFormTextDefault = Studio.rootStg.xmlDictionary.getTranslate("homepageButtonLoadLabel");
			this.addLoadForm();
			
			this.createCategory();
			this.addScrollbar();
		}
		
		private function createCategory(){
			thumbnailCategory = new ProjectThumbnailCategoryTemp(controlWidth, Studio.rootStg.temp);
			thumbnailCategory.x = 0;
			thumbnailCategory.y = 105;
			this.addChild(thumbnailCategory);
		}
		
		private function addScrollbar(){
			scrollBar = new ScrollBarVertical(thumbnailCategory, controlWidth, controlHeight);
			scrollBar.x = controlWidth - Studio.PANEL_PADDING;
			scrollBar.y = thumbnailCategory.y;
			this.addChild(scrollBar);
		}
		
		public function removeTempProject(prId:String){
			var i:int;
			for(i = 0; i < Studio.rootStg.temp.length; i++){
				if(Studio.rootStg.temp[i].prId == prId){
					trace("removing");
					Studio.rootStg.temp.splice(i, 1);
					break;
				}
			}
			
			var child;
			for(i = 1; i < thumbnailCategory.numChildren; i++){
				child = thumbnailCategory.getChildAt(i);
				if(child.projData.prId == prId){
					child.remove();
					thumbnailCategory.removeChild(child);
					break;
				}
			}
			
			thumbnailCategory.resizeHandler(controlWidth);
		}
		
	//*** load form ***//
	
		private function addLoadForm(){
			this.loadForm = new load_form();
			loadForm.x = controlWidth / 2;
			loadForm.y = 30;
			this.addChild(loadForm);
			
			loadForm.dt_text.text = this.loadFormTextDefault;
			
			loadForm.dt_text.addEventListener("click", clickInputHandler);
			loadForm.dt_text.addEventListener("focusOut", focusOutInputHandler);
			
			loadForm.butt.addEventListener("click", clickLoadHandler);
			loadForm.butt.buttonMode = true;
		}
		
		private function clickInputHandler(e:MouseEvent){
			loadForm.dt_text.textColor = 0x000000;
			loadForm.dt_text.text = "";
		}
		
		private function focusOutInputHandler(e:Event){
			if(loadForm.dt_text.text == ""){
				loadForm.dt_text.textColor = 0xbababa;
				loadForm.dt_text.text = this.loadFormTextDefault;
			}
		}
		
		private function clickLoadHandler(e:MouseEvent){
			if(loadForm.dt_text.text != ""){
				Studio.rootStg.createLoadProject(loadForm.dt_text.text);
			}
		}
	
	//*** rest ***//
		
		public function resizeHandler(stageW:Number, stageH:Number){
			this.controlWidth = stageW - Studio.PANEL_WIDTH - 4 * Studio.PANEL_PADDING;
			this.controlHeight = stageH - 4 * Studio.PANEL_PADDING;
			this.loadForm.x = controlWidth / 2;
		}
		
		public function remove(){
			loadForm.dt_text.removeEventListener("click", clickInputHandler);
			loadForm.dt_text.removeEventListener("focusOut", focusOutInputHandler);
			loadForm.butt.removeEventListener("click", clickLoadHandler);
		}

	}
	
}
