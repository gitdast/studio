package{
	import flash.text.TextField;
	import flash.events.MouseEvent;
	
	public class PanelInfoLoad extends PanelSlide{
		public var infoTextField:TextField;
		
		public function PanelInfoLoad(stageW:Number, stageH:Number, panelW:Number = 0, panelH:Number = 0, _name:String = null){
			trace("PanelInfoLoad: init");
			super(stageW, stageH, panelW, panelH, _name);
			
			this.x = stageW / 2 - this.panelWidth / 2;
			this.y = Studio.PANEL_PADDING;
			
			this.addLabel();
			this.createTextField();
		}
		
		public function signalProjectFound(prId){
			infoTextField.text = Studio.rootStg.xmlDictionary.getTranslate("panelInfoProjectLoading");
		}
		
		public function signalProjectNotFound(prId){
			var ptext = Studio.rootStg.xmlDictionary.getTranslate("panelInfoProjectNotFound");
			infoTextField.text = ptext.replace("%%%projNumber%%%", prId);
		}
		
		public function signalProjectLoadError(prId){
			infoTextField.text = Studio.rootStg.xmlDictionary.getTranslate("panelInfoProjectLoadError");
		}
		
		public function signalProjectLoaded(prId){
			infoTextField.text = Studio.rootStg.xmlDictionary.getTranslate("panelInfoProjectLoaded");
		}
		
		private function createTextField(){
			infoTextField = new TextField();
			infoTextField.autoSize = "center";
			infoTextField.selectable = true;
			infoTextField.defaultTextFormat = Studio.rootStg.getTextFormatCond(18, "center", 0x8e8e8e);
			infoTextField.embedFonts = true;
			infoTextField.antiAliasType = "advanced";
			infoTextField.width = panelWidth - 60;
			infoTextField.wordWrap = true;
			infoTextField.x = 30;			
			infoTextField.y = panelHeaderHeight + 30;
			this.addChild(infoTextField);
		}
		
		override public function resizeHandler(w:Number, h:Number, scrollRatio:Number = -1){
			super.resizeHandler(w, h);
		}
		
		override public function remove(){
			super.remove();
		}
	}
	
}
