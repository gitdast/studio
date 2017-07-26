package{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.geom.Rectangle;
	import flash.events.MouseEvent;
	
	public class PanelNew extends PanelSlide{
		public var buttFile:ButtonPanel;
		public var buttSimul:ButtonPanel;
		
		public function PanelNew(stageW:Number, stageH:Number, panelW:Number = 0, panelH:Number = 0){
			trace("PanelNew: init");
			super(stageW, stageH, panelW, panelH);

			this.x = stageW / 2 - this.panelWidth / 2;
			this.y = Studio.PANEL_PADDING;
			
			this.addLabel();
			this.addContent();
			this.addButtons();
		}
		
		private function addContent(){
			var ico = new ico_question();
			ico.x = this.panelWidth / 2;
			ico.y = this.panelHeaderHeight + 15 + ico.height / 2;
			
			var format = Studio.rootStg.getTextFormat2(16, "center", 0x8e8e8e);
			var contentField = new TextField();
			contentField.width = this.panelWidth - 2 * Studio.PANEL_PADDING;
			contentField.wordWrap = true;
			contentField.selectable = false;
			contentField.text = Studio.rootStg.xmlDictionary.getTranslate("panelNewText");
			contentField.setTextFormat(format);
			contentField.embedFonts = true;
			contentField.antiAliasType = "advanced";
			contentField.x = Studio.PANEL_PADDING;
			contentField.y = ico.y + ico.height / 2 + 15;
			
			this.addChild(contentField);
			this.addChild(ico);
		}
		
		private function addButtons(){
			var w = (this.panelWidth - 3 * Studio.PANEL_PADDING) / 2;
			
			buttFile = new ButtonPanel(w, "panelNewButtonNewProject");
			buttSimul = new ButtonPanel(w, "panelNewButtonPrepared");
			this.addChild(buttFile);
			this.addChild(buttSimul);
			
			buttFile.x = Studio.PANEL_PADDING;
			buttSimul.x = this.panelWidth - Studio.PANEL_PADDING - buttSimul.width;
			buttFile.y = buttSimul.y = this.panelHeight - Studio.PANEL_PADDING - buttFile.height;
			
			buttFile.addEventListener("click", clickButtFile);
			buttSimul.addEventListener("click", clickButtSimul);
		}
		
		private function clickButtFile(e:MouseEvent){
			this.slideUp(e);
			Studio.rootStg.openFileDialog();
		}
		
		private function clickButtSimul(e:MouseEvent){
			this.slideUp(e);
			Studio.rootStg.addHomepagePrepared();
			Studio.rootStg.panelSave.butt_home.enable();
		}
		
		override protected function publishPanelRemoved(){
			Studio.rootStg.panelInfo = null;
		}
		
		override public function resizeHandler(w:Number, h:Number, scrollRatio:Number = -1){
			super.resizeHandler(w, h);
		}
		
		override public function remove(){
			super.remove();
			
			buttFile.removeEventListener("click", clickButtFile);
			buttFile.remove();
			
			buttSimul.addEventListener("click", clickButtSimul);
			buttSimul.remove();
		}
	}
	
}
