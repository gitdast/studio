package{
	import flash.text.TextField;
	import fl.controls.TextInput;
	import flash.events.MouseEvent;

	public class PanelInfoSave extends PanelSlide{
		public var buttYes:ButtonPanel;
		public var buttNo:ButtonPanel;
		public var infoTextField:TextField;
		public var emailInputField:TextInput;
		
		public function PanelInfoSave(stageW:Number, stageH:Number, panelW:Number = 0, panelH:Number = 0, _name:String = null){
			trace("PanelInfoSave: init");
			super(stageW, stageH, panelW, panelH, _name);
			
			this.x = stageW / 2 - this.panelWidth / 2;
			this.y = Studio.PANEL_PADDING;
			
			this.addLabel();
			this.createTextField();
			
			switch(_name){
				case "panelInfoSaveRewrite":
					this.displayRewrite();
					this.addButtons("panelInfoSaveButtRewrite", "panelInfoSaveButtNew");
					buttYes.addEventListener("click", clickButtSaveNew);
					buttNo.addEventListener("click", clickButtSaveRewrite);
					break;
				default:
					this.displayEmailQuestion();
					this.addButtons();
					break;
			}			
		}
		
		public function signalProjectBitmapsSaved(prId){
			infoTextField.text = Studio.rootStg.xmlDictionary.getTranslate("panelInfoSaveProjectSending");
		}
		
		public function signalProjectSaved(prId){
			infoTextField.text =  Studio.rootStg.xmlDictionary.getTranslate("panelInfoSaveYourProjectId").replace("%%%projNumber%%%", prId);
		}
		
		public function signalProjectSaveError(errId){
			infoTextField.text = Studio.rootStg.xmlDictionary.getTranslate("infoSaveError-"+errId);
		}
		
		public function signalProjectSaveErrorMessage(message:String){
			infoTextField.text = message;
		}
		
		private function displayRewrite(){
			ico = new ico_warning();
			ico.x = this.panelWidth / 2;
			ico.y = this.panelHeaderHeight + 15 + ico.height / 2;
			this.addChild(ico);
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
		
		private function addButtons(bnameNo:String = null, bnameYes:String = null){
			var w = (this.panelWidth - 3 * Studio.PANEL_PADDING) / 2;
			
			if(bnameYes){
				buttYes = new ButtonPanel(w, bnameYes);
				buttYes.x = this.panelWidth - Studio.PANEL_PADDING - buttYes.width;
				buttYes.y = this.panelHeight - Studio.PANEL_PADDING - buttYes.height;
				this.addChild(buttYes);
			}
			if(bnameNo){
				buttNo = new ButtonPanel(w, bnameNo);
				buttNo.x = Studio.PANEL_PADDING;
				buttNo.y = this.panelHeight - Studio.PANEL_PADDING - buttNo.height;
				this.addChild(buttNo);
			}
		}
		
		public function displayEmailQuestion(){
			labelField.text = Studio.rootStg.xmlDictionary.getTranslate("panelInfoSaveSaving");
			infoTextField.text = Studio.rootStg.xmlDictionary.getTranslate("panelInfoSaveEmailText");
			
			emailInputField = new TextInput();
			emailInputField.width = 200;
			emailInputField.x = panelWidth / 2 - emailInputField.width / 2;
			emailInputField.y = panelHeaderHeight + 110;			
			emailInputField.textField.text = (Studio.rootStg.sessionEmail) ? Studio.rootStg.sessionEmail : '';
			emailInputField.textField.setTextFormat(Studio.rootStg.getTextFormatCond(18, "center", 0x8e8e8e));
			this.addChild(emailInputField);
			
			this.addButtons(null, "panelInfoSaveButtonEmailContinue");
			buttYes.addEventListener("click", clickContinue);
		}
		
		
		
		private function clickButtSaveRewrite(e:MouseEvent){
			this.clearContent();
			labelField.text = Studio.rootStg.xmlDictionary.getTranslate("panelInfoSaveSaving");
			
			Studio.rootStg.project.save();
		}
		
		private function clickButtSaveNew(e:MouseEvent){
			this.clearContent();
			this.displayEmailQuestion();
			
			Studio.rootStg.clearIdLabel();
			Studio.rootStg.project.createSessionId();
		}
		
		private function clickContinue(e:MouseEvent){
			Studio.rootStg.sessionEmail = emailInputField.textField.text;
			
			this.clearContent();
			labelField.text = Studio.rootStg.xmlDictionary.getTranslate("panelInfoSaveSaving");
			infoTextField.text = Studio.rootStg.xmlDictionary.getTranslate("panelInfoSaveProjectSendingBmp");
			
			Studio.rootStg.project.save();
		}
		
		public function clearContent(){
			if(this.ico){
				this.removeChild(ico);
				ico = null;
			}
			if(this.buttYes){
				buttYes.removeEventListener("click", clickButtSaveRewrite);
				buttYes.removeEventListener("click", clickContinue);
				this.removeChild(buttYes);
				buttYes = null;
			}
			if(this.buttNo){
				buttNo.removeEventListener("click", clickButtSaveNew);
				this.removeChild(buttNo);
				buttNo = null;
			}
			if(this.emailInputField){
				this.removeChild(emailInputField);
				emailInputField = null;
			}
			if(this.infoTextField){
				infoTextField.text = "";
			}
			
		}
		
		override public function resizeHandler(w:Number, h:Number, scrollRatio:Number = -1){
			super.resizeHandler(w, h);
			buttYes.x = Studio.PANEL_PADDING;
			buttNo.x = this.panelWidth - Studio.PANEL_PADDING - buttNo.width;
			buttYes.y = buttNo.y = this.panelHeight - Studio.PANEL_PADDING - buttYes.height;
		}
		
		override public function remove(){
			super.remove();
			if(this.buttNo){
				buttNo.removeEventListener("click", clickButtSaveNew);
				this.removeChild(buttNo);
				buttNo = null;
			}
			if(this.buttYes){
				buttYes.removeEventListener("click", clickButtSaveRewrite);
				buttYes.removeEventListener("click", clickContinue);
				this.removeChild(buttYes);
				buttYes = null;
			}
		}
	}
	
}
