package{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class Homebuttons extends Sprite{
		public var butt_prepared;
		public var butt_photo;
		public var butt_load;
		public var butt_video;

		public function Homebuttons(stageW:Number, stageH:Number){
			this.x = stageW/2;
			this.y = stageH/2-this.height/2 > 60 ? stageH/2 : 60+this.height/2;
			
			this.addTexts();
			this.addListeners();
		}
		
		public function addListeners(){
			butt_prepared.butt_bgd.buttonMode = true;
			butt_photo.butt_bgd.buttonMode = true;
			butt_load.butt_bgd.buttonMode = true;
			butt_video.butt_bgd.buttonMode = true;
			
			butt_prepared.butt_bgd.mouseChildren = false;
			butt_photo.butt_bgd.mouseChildren = false;
			butt_load.butt_bgd.butt_send.visible = false;
			butt_video.butt_bgd.mouseChildren = false;
			
			butt_prepared.butt_bgd.addEventListener("click", clickHandlerPrepared);
			butt_photo.butt_bgd.addEventListener("click", clickHandlerPhoto);
			butt_load.butt_bgd.addEventListener("click", clickHandlerLoad);
			butt_load.butt_bgd.butt_send.addEventListener("click", clickHandlerLoadSend);
			butt_video.butt_bgd.addEventListener("click", clickHandlerVideo);
			
			butt_prepared.butt_bgd.addEventListener("mouseOver", overHandler);
			butt_photo.butt_bgd.addEventListener("mouseOver", overHandler);
			butt_load.butt_bgd.addEventListener("mouseOver", overHandler);
			butt_video.butt_bgd.addEventListener("mouseOver", overHandler);
			butt_prepared.butt_bgd.addEventListener("mouseOut", outHandler);
			butt_photo.butt_bgd.addEventListener("mouseOut", outHandler);
			butt_load.butt_bgd.addEventListener("mouseOut", outHandler);
			butt_video.butt_bgd.addEventListener("mouseOut", outHandler);
		}
		
		public function removeListeners(){
			butt_prepared.butt_bgd.removeEventListener("click", clickHandlerPrepared);
			butt_photo.butt_bgd.removeEventListener("click", clickHandlerPhoto);
			butt_load.butt_bgd.removeEventListener("click", clickHandlerLoad);
			butt_load.butt_bgd.butt_send.removeEventListener("click", clickHandlerLoadSend);
			butt_video.butt_bgd.removeEventListener("click", clickHandlerVideo);
			
			butt_prepared.butt_bgd.removeEventListener("mouseOver", overHandler);
			butt_photo.butt_bgd.removeEventListener("mouseOver", overHandler);
			butt_load.butt_bgd.removeEventListener("mouseOver", overHandler);
			butt_video.butt_bgd.removeEventListener("mouseOver", overHandler);
			butt_prepared.butt_bgd.removeEventListener("mouseOut", outHandler);
			butt_photo.butt_bgd.removeEventListener("mouseOut", outHandler);
			butt_load.butt_bgd.removeEventListener("mouseOut", outHandler);
			butt_video.butt_bgd.removeEventListener("mouseOut", outHandler);
		}
		
		private function overHandler(e:MouseEvent){
			if(e.currentTarget.currentFrame == 1) e.currentTarget.gotoAndStop(2);
		}
		private function outHandler(e:MouseEvent){
			if(e.currentTarget.currentFrame == 2) e.currentTarget.gotoAndStop(1);
		}
		
		private function clickHandlerPrepared(e:MouseEvent){
			Studio.rootStg.createProjectPreparedOpener();
		}
		
		private function clickHandlerPhoto(e:MouseEvent){
			Studio.rootStg.openFileDialog();
		}

		private function clickHandlerLoad(e:MouseEvent){
			trace("load clicked");
			butt_load.butt_bgd.gotoAndStop(3);
			butt_load.butt_bgd.butt_send.visible = true;
			butt_load.butt_bgd.dt_button.textColor = 0x000000;
			butt_load.butt_bgd.dt_button.text = "";
		}
		private function clickHandlerLoadSend(e:MouseEvent){
			trace("load - send id:",butt_load.butt_bgd.dt_button.text);
			e.stopPropagation();
			if(butt_load.butt_bgd.dt_button.text != "")
				Studio.rootStg.createLoadProject(butt_load.butt_bgd.dt_button.text);
		}
		
		private function clickHandlerVideo(e:MouseEvent){
			var infoUrl = Studio.rootStg.xmlConfig.getInfoUrl();
			navigateToURL(new URLRequest(infoUrl), "_blank");
		}

		
		private function addTexts(){
			butt_prepared.butt_bgd.dt_button.text = Studio.rootStg.xmlDictionary.getTranslate("homepageButtonPreparedLabel");
			butt_photo.butt_bgd.dt_button.text = Studio.rootStg.xmlDictionary.getTranslate("homepageButtonPhotoLabel");
			butt_load.butt_bgd.dt_button.text = Studio.rootStg.xmlDictionary.getTranslate("homepageButtonLoadLabel");
			butt_video.butt_bgd.dt_button.text = Studio.rootStg.xmlDictionary.getTranslate("homepageButtonVideoLabel");
			
			butt_prepared.dt_text.text = Studio.rootStg.xmlDictionary.getTranslate("homepageButtonPreparedText");
			butt_photo.dt_text.text = Studio.rootStg.xmlDictionary.getTranslate("homepageButtonPhotoText");
			butt_load.dt_text.text = Studio.rootStg.xmlDictionary.getTranslate("homepageButtonLoadText");
			butt_video.dt_text.text = Studio.rootStg.xmlDictionary.getTranslate("homepageButtonVideoText");
		}
		
	
		public function resizeHandler(stageW:Number, stageH:Number){
			this.x = stageW/2;
			this.y = stageH/2-this.height/2 > 60 ? stageH/2 : 60+this.height/2;
		}
		
		public function removeAll(){
			this.removeListeners();
		}

	}
	
}
