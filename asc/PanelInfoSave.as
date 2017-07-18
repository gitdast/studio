package{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	import fl.controls.TextInput;
	import flash.events.MouseEvent;

	//import flash.display.MovieClip;
	
	public class PanelInfoSave extends PanelSlide{
		//public var labelField:TextField;
		public var inputField:TextInput;
		public var butt_yes:ButtonFile;
		public var butt_no:ButtonFile;
		
		public function PanelInfoSave(stageW:Number, pH:Number = 100){
			trace("PanelInfoSave: init");
			super(stageW, pH);
			
			//this.addInfosign();
			//this.addLabel("infoProjectSendingBmp");
		}
		
		public function signalProjectBitmapsSaved(prId){
			var ptext = Studio.rootStg.xmlDictionary.getTranslate("infoProjectSending");
			labelField.text = ptext;
			Studio.rootStg.addTextFormat(labelField, 14, 0x333333);
			labelField.y = panelHeight/2-labelField.height/2;
		}
		
		public function signalProjectSaved(prId){
			var ptext = Studio.rootStg.xmlDictionary.getTranslate("infoYourProjectId");
			labelField.text = ptext.replace("%%%projNumber%%%", prId);
			Studio.rootStg.addTextFormat(labelField, 14, 0x333333);
			labelField.y = panelHeight/2-labelField.height/2;
		}
		
		public function signalProjectSaveError(errId){
			var ptext = Studio.rootStg.xmlDictionary.getTranslate("infoSaveError-"+errId);
			labelField.text = ptext;
			Studio.rootStg.addTextFormat(labelField, 14, 0x333333);
			labelField.y = panelHeight/2-labelField.height/2;
		}
		   
		public function addQuestion(){
			var ptext = Studio.rootStg.xmlDictionary.getTranslate("infoProjectReplace");
			labelField.text = ptext;
			Studio.rootStg.addTextFormat(labelField, 14, 0x333333);
			labelField.y = panelHeight/2-labelField.height/2 - 10;
			var buttlabel:String;
			
			butt_yes = new ButtonFile();
			buttlabel = Studio.rootStg.xmlDictionary.getTranslate("infoProjectAnswerYes-rewrite");
			butt_yes.buttonMode = true;
			butt_yes.mouseChildren = false;
			butt_yes.dt_label.text = buttlabel.toUpperCase();
			butt_yes.bgd.width = butt_yes.dt_label.textWidth + 19;
			butt_yes.x = labelField.x + labelField.width/2 - butt_yes.bgd.width - 20;
			butt_yes.y = labelField.y + labelField.height + 10;
			butt_yes.hitArea = butt_yes.bgd;
			addChild(butt_yes);
			butt_yes.addEventListener("click", buttonYesClickHandler);
			
			butt_no = new ButtonFile();
			buttlabel = Studio.rootStg.xmlDictionary.getTranslate("infoProjectAnswerNo-new");
			butt_no.buttonMode = true;
			butt_no.mouseChildren = false;
			butt_no.dt_label.text = buttlabel.toUpperCase();
			butt_no.bgd.width = butt_no.dt_label.textWidth + 19;
			butt_no.x = labelField.x + labelField.width/2 + 20;
			butt_no.y = labelField.y + labelField.height + 10;
			butt_no.hitArea = butt_no.bgd;
			addChild(butt_no);
			butt_no.addEventListener("click", buttonNoClickHandler);
		}
		
		public function addEmailQuestion(){
			var ptext = Studio.rootStg.xmlDictionary.getTranslate("infoProjectEmail");
			labelField.text = ptext;
			Studio.rootStg.addTextFormat(labelField, 14, 0x333333);
			labelField.y = panelHeight/2-labelField.height/2 - 10;
			var buttlabel:String;
			
			inputField = new TextInput();
			inputField.x = labelField.x + labelField.width/2 - 200 - 20;
			inputField.y = labelField.y + labelField.height + 10;
			inputField.width = 200;
			inputField.textField.text = (Studio.rootStg.sessionEmail) ? Studio.rootStg.sessionEmail : '';
			Studio.rootStg.addTextFormat(inputField.textField, 14, 0x0099FF);
			this.addChild(inputField);			
			
			butt_yes = new ButtonFile();
			buttlabel = Studio.rootStg.xmlDictionary.getTranslate("infoProjectEmailContinue");
			butt_yes.buttonMode = true;
			butt_yes.mouseChildren = false;
			butt_yes.dt_label.text = buttlabel.toUpperCase();
			butt_yes.bgd.width = butt_yes.dt_label.textWidth + 19;
			butt_yes.x = labelField.x + labelField.width/2 + 20;
			butt_yes.y = labelField.y + labelField.height + 10;
			butt_yes.hitArea = butt_yes.bgd;
			addChild(butt_yes);
			butt_yes.addEventListener("click", continueHandler);
		}
		
		private function buttonYesClickHandler(e:MouseEvent){
			butt_no.removeEventListener("click", buttonNoClickHandler);
			butt_yes.removeEventListener("click", buttonYesClickHandler);
			this.removeChild(butt_no);
			this.removeChild(butt_yes);
			
			addEmailQuestion();
		}
		
		private function buttonNoClickHandler(e:MouseEvent){
			butt_no.removeEventListener("click", buttonNoClickHandler);
			butt_yes.removeEventListener("click", buttonYesClickHandler);
			this.removeChild(butt_no);
			this.removeChild(butt_yes);
			
			Studio.rootStg.createSessionId();
			addEmailQuestion();
		}
		
		private function continueHandler(e:MouseEvent){
			var ptext = Studio.rootStg.xmlDictionary.getTranslate("infoProjectSendingBmp");
			labelField.text = ptext;
			Studio.rootStg.addTextFormat(labelField, 14, 0x333333);
			labelField.y = panelHeight/2-labelField.height/2;
			
			Studio.rootStg.sessionEmail = inputField.textField.text;
			
			butt_yes.removeEventListener("click", buttonYesClickHandler);
			this.removeChild(inputField);
			this.removeChild(butt_yes);
			
			/* pro prvni ulozeni, kdy jeste neni sessionId */
			if(!Studio.rootStg.sessionId) Studio.rootStg.createSessionId();
			
			Studio.rootStg.projectP.exportWhenSessionId();
		}
		
		override public function resizeHandler(w:Number, h:Number, scrollRatio:Number = -1){
			super.resizeHandler(w, h);
			if(butt_yes) butt_yes.x = labelField.x + labelField.width/2 - butt_yes.bgd.width - 20;
			if(butt_no) butt_no.x = labelField.x + labelField.width/2 + 20;
		}
		
		override public function remove(){
			super.remove();
			if(butt_no) butt_no.removeEventListener("click", buttonNoClickHandler);
			if(butt_yes) butt_yes.removeEventListener("click", buttonYesClickHandler);
		}
	}
	
}
