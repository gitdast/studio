package{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.events.MouseEvent;

	//import flash.display.MovieClip;
	
	public class PanelInfoClose extends PanelSlide{
		//public var labelField:TextField;
		public var butt_yes:ButtonFile;
		public var butt_no:ButtonFile;
		
		private var goHomepage:Boolean;
		private var goWhere:String;
		
		private const pH:Number = 100;
		
		public function PanelInfoClose(stageW:Number, goHome:Boolean, goWhere:String){
			trace("PanelInfoClose: init");
			super(stageW, pH);
			
			this.goHomepage = goHome;
			this.goWhere = goWhere;
			
			//this.addInfosign();
			//this.addLabel("infoProjectClose");
			//this.addQuestion();
		}
		
		public function addQuestion(){
			var buttlabel:String;
			
			butt_yes = new ButtonFile();
			buttlabel = Studio.rootStg.xmlDictionary.getTranslate("infoProjectAnswerYes");
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
			buttlabel = Studio.rootStg.xmlDictionary.getTranslate("infoProjectAnswerNo");
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
		
		private function buttonYesClickHandler(e:MouseEvent){
			butt_no.removeEventListener("click", buttonNoClickHandler);
			butt_yes.removeEventListener("click", buttonYesClickHandler);
			this.removeChild(butt_no);
			this.removeChild(butt_yes);
			this.slideUp(e);
			Studio.rootStg.closeProject();
			
			if(goHomepage) Studio.rootStg.addHomepage();
			if(goWhere=="pre") Studio.rootStg.createProjectPreparedOpener();
			if(goWhere=="own") Studio.rootStg.openFileDialog();
		}
		
		private function buttonNoClickHandler(e:MouseEvent){
			butt_no.removeEventListener("click", buttonNoClickHandler);
			butt_yes.removeEventListener("click", buttonYesClickHandler);
			this.removeChild(butt_no);
			this.removeChild(butt_yes);
			
			this.slideUp(e);
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
