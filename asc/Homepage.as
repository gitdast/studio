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
		public var butt_new:ButtonNewProject;
		
		private var controlWidth:int;
		private var controlHeight:int;


		public function Homepage(stageW:Number, stageH:Number){
			this.controlWidth = stageW - Studio.PANEL_WIDTH - 4 * Studio.PANEL_PADDING;
			this.controlHeight = stageH - 4 * Studio.PANEL_PADDING;
			this.x = Studio.PANEL_WIDTH + 2 * Studio.PANEL_PADDING;
			this.y = 0;			
			this.loadFormTextDefault = Studio.rootStg.xmlDictionary.getTranslate("homepageButtonLoadLabel");
			this.addLoadForm();
			this.addNewButton();
		}
		
		private function addNewButton(){
			butt_new = new ButtonNewProject();
			butt_new.x = 0;
			butt_new.y = 120;
			this.addChild(butt_new);
		}
		
		private function clickNewProjectHandler(e:MouseEvent){
			Studio.rootStg.openFileDialog();
		}
		
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
			//e.stopPropagation();
			if(loadForm.dt_text.text != ""){
				Studio.rootStg.createLoadProject(loadForm.dt_text.text);
			}
		}
		
		public function resizeHandler(stageW:Number, stageH:Number){
			this.controlWidth = stageW - Studio.PANEL_WIDTH - 2 * Studio.PANEL_PADDING;
			this.controlHeight = stageH - 2 * Studio.PANEL_PADDING;
		}
		
		public function remove(){
			loadForm.dt_text.removeEventListener("click", clickInputHandler);
			loadForm.dt_text.removeEventListener("focusOut", focusOutInputHandler);
			loadForm.butt.removeEventListener("click", clickLoadHandler);
			
			butt_new.remove();
		}

	}
	
}
