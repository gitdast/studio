package{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	
	public class PanelInfoLoad extends PanelSlide{
		//public var labelField:TextField;
		
		public function PanelInfoLoad(stageW:Number, pH:Number = 100){
			trace("PanelInfoLoad: init");
			super(stageW, pH);
			
			//this.addInfosign();
			//this.addLabel("infoProjectSearching");
		}
		
		public function signalProjectFound(prId){
			var ptext = Studio.rootStg.xmlDictionary.getTranslate("infoProjectLoading");
			labelField.text = ptext;
			Studio.rootStg.addTextFormat(labelField, 14, 0x333333);
			labelField.y = panelHeight/2-labelField.height/2;
		}
		
		public function signalProjectNotFound(prId){
			var ptext = Studio.rootStg.xmlDictionary.getTranslate("infoProjectNotFound");
			labelField.text = ptext.replace("%%%projNumber%%%", prId);
			Studio.rootStg.addTextFormat(labelField, 14, 0x333333);
			labelField.y = panelHeight/2-labelField.height/2;
		}
		
		public function signalProjectLoadError(prId){
			var ptext = Studio.rootStg.xmlDictionary.getTranslate("infoProjectLoadError");
			labelField.text = ptext;
			Studio.rootStg.addTextFormat(labelField, 14, 0x333333);
			labelField.y = panelHeight/2-labelField.height/2;
		}
		
		public function signalProjectLoaded(prId){
			var ptext = Studio.rootStg.xmlDictionary.getTranslate("infoProjectLoaded");
			labelField.text = ptext;
			Studio.rootStg.addTextFormat(labelField, 14, 0x333333);
			labelField.y = panelHeight/2-labelField.height/2;
		}
		
		override public function resizeHandler(w:Number, h:Number, scrollRatio:Number = -1){
			super.resizeHandler(w, h);
		}
		
		override public function remove(){
			super.remove();
		}
	}
	
}
