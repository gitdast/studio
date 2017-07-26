package{
	import flash.text.TextField;
	import flash.events.MouseEvent;

	public class PanelInfoClose extends PanelSlide{
		public var buttYes:ButtonPanel;
		public var buttNo:ButtonPanel;
		
		private var callback:Function;
		
		public function PanelInfoClose(stageW:Number, stageH:Number, panelW:Number = 0, panelH:Number = 0, callback:Function = null){
			trace("PanelInfoClose: init");
			super(stageW, stageH, panelW, panelH);
			
			this.x = stageW / 2 - this.panelWidth / 2;
			this.y = Studio.PANEL_PADDING;
			
			this.callback = callback;
			
			this.addLabel();
			this.addContent();
			this.addButtons();
		}
		
		private function addContent(){
			ico = new ico_warning();
			ico.x = this.panelWidth / 2;
			ico.y = this.panelHeaderHeight + 15 + ico.height / 2;
			
			var format = Studio.rootStg.getTextFormat2(16, "center", 0x8e8e8e);
			var contentField = new TextField();
			contentField.width = this.panelWidth - 2 * Studio.PANEL_PADDING;
			contentField.wordWrap = true;
			contentField.selectable = false;
			contentField.text = Studio.rootStg.xmlDictionary.getTranslate("panelInfoCloseText");
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
			
			buttYes = new ButtonPanel(w, "panelInfoCloseYes");
			buttNo = new ButtonPanel(w, "panelInfoCloseNo");
			this.addChild(buttYes);
			this.addChild(buttNo);
			
			buttYes.x = Studio.PANEL_PADDING;
			buttNo.x = this.panelWidth - Studio.PANEL_PADDING - buttNo.width;
			buttYes.y = buttNo.y = this.panelHeight - Studio.PANEL_PADDING - buttYes.height;
			
			buttYes.addEventListener("click", clickButtYes);
			buttNo.addEventListener("click", clickButtNo);
		}
		
		private function clickButtYes(e:MouseEvent){
			this.slideUp(e);
			//Studio.rootStg.closeProject();
			
			/*
			if(goHomepage) Studio.rootStg.addHomepage();
			if(goWhere=="pre") Studio.rootStg.createProjectPreparedOpener();
			if(goWhere=="own") Studio.rootStg.openFileDialog();
			*/
			callback();
		}
		
		private function clickButtNo(e:MouseEvent){
			this.slideUp(e);
		}
		
		override protected function publishPanelRemoved(){
			Studio.rootStg.panelInfo = null;
		}
		
		override public function resizeHandler(w:Number, h:Number, scrollRatio:Number = -1){
			super.resizeHandler(w, h);
			buttYes.x = Studio.PANEL_PADDING;
			buttNo.x = this.panelWidth - Studio.PANEL_PADDING - buttNo.width;
			buttYes.y = buttNo.y = this.panelHeight - Studio.PANEL_PADDING - buttYes.height;
		}
		
		override public function remove(){
			super.remove();
			buttYes.removeEventListener("click", clickButtYes);
			buttNo.removeEventListener("click", clickButtNo);
		}
	}
	
}
