﻿package{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	//import fl.controls.TextInput;
	import flash.filters.DropShadowFilter;
	import flash.events.MouseEvent;

	
	public class ProjectTempSaver extends Sprite{
		public var bgd:Shape;
		public var subtitle:TextField;
		
		public var category:ProjectThumbnailCategoryTemp;

		public var buttSaveTemp:ButtonIconArrow;
		//public var buttSave:ButtonIconEnve;
		
		public var lock:Boolean = false;
		
		public var pWidth:Number;
		public var pHeight:Number;
		
		public const imgW:Number = 158;
		public const imgH:Number = 100;
		
		public function ProjectTempSaver(w:Number, h:Number){
			//trace("ProjectTempSaver: init...");
			pWidth = w;
			pHeight = h;
			this.createBackground(pWidth,pHeight);
			this.addEventListener("rollOut", mouseOutHandler);
			
			this.createThumbnails();
			this.addButtons();
			/*
			if(Studio.rootStg.projectP)
				if(Studio.rootStg.projectP.type != "prepared")
					this.addButtons();
			*/
		}
		
		private function createThumbnails(){
			var preparedTitle:TextField = new TextField();
			preparedTitle.x = 20;
			preparedTitle.y = 30;
			preparedTitle.autoSize = "left";
			preparedTitle.text = Studio.rootStg.xmlDictionary.getTranslate("titleTemporaryProjects");
			this.addChild(preparedTitle);
			Studio.rootStg.addTextFormatBold(preparedTitle, 14, 0x000000);
			
			subtitle = new TextField();
			subtitle.x = 20;
			subtitle.y = 50;
			subtitle.autoSize = "left";
			subtitle.text = Studio.rootStg.xmlDictionary.getTranslate("subtitleTemporaryProjects");
			//subtitle.visible = false;
			this.addChild(subtitle);
			Studio.rootStg.addTextFormat(subtitle, 14, 0x000000);
			
			this.createCategoryVertical();
		}
		
		private function createCategoryVertical(){
			category = new ProjectThumbnailCategoryTemp(Studio.rootStg.temp, pWidth-40);
			category.x = 20;
			category.y = 170;
			this.addChild(category);
			
			//subtitle.visible = (Studio.rootStg.temp.length > 0);
		}
		
		private function addButtons(){
			buttSaveTemp = new ButtonIconArrow();
			var buttlabel:String = Studio.rootStg.xmlDictionary.getTranslate("buttonSaveTemporarily");
			buttSaveTemp.buttonMode = true;
			buttSaveTemp.mouseChildren = false;
			buttSaveTemp.x = 20;
			buttSaveTemp.y = 100;
			buttSaveTemp.dt_label.text = buttlabel.toUpperCase();
			buttSaveTemp.dt_label.autoSize = "left";
			buttSaveTemp.bgd.width = buttSaveTemp.dt_label.textWidth + 31;
			addChild(buttSaveTemp);
			buttSaveTemp.addEventListener("click", buttonSaveTempClickHandler);
		}
		
		private function buttonSaveTempClickHandler(e:MouseEvent){
			var prData;
			if(Studio.rootStg.projectP.type == "prepared"){
				prData =  Studio.rootStg.projectP.getTempDataPrepared();
			}else{
				prData =  Studio.rootStg.projectP.getTempData();
			}
			trace("saver: push id:", prData.prId);
			Studio.rootStg.temp.push(prData);
			
			//Studio.rootStg.projectP.getNewId();
			//idLabel.text = Studio.rootStg.projectP.prId;
			
			category.removeAll();
			this.removeChild(category);
			this.createCategoryVertical();
		}
		
		public function removeTempProject(prId:String){
			for(var i:int=0; i<Studio.rootStg.temp.length; i++){
				trace("Saver: ", prId, " <> ", Studio.rootStg.temp[i].prId);
				if(Studio.rootStg.temp[i].prId == prId){
					
					Studio.rootStg.temp.splice(i, 1);
					break;
				}
			}
			
			category.removeAll();
			this.removeChild(category);
			this.createCategoryVertical();
		}
		
		private function mouseOutHandler(e:MouseEvent){
			/*if(this.lock || Studio.rootStg.panelMain.butt_savetemp.hitTestPoint(e.stageX, e.stageY, true)){
				//trace("stay open");
			}else{
				//trace("closing");
				Studio.rootStg.panelMain.butt_savetemp.gotoAndStop(1);
				Studio.rootStg.panelMain.closeProjectTempSaver();
			}*/
		}
		
		public function createBackground(w:Number, h:Number){
			bgd = new Shape();
			this.addChild(bgd);

			bgd.graphics.beginFill(0xDDDDDD, 1);
			bgd.graphics.drawRoundRect(0, 0, w, h, 8, 8);
			bgd.graphics.endFill();
			bgd.graphics.beginFill(0x0066CC, 1);
			bgd.graphics.drawRoundRect(0, 0, w, 15, 8, 8);
			bgd.graphics.endFill();
			bgd.graphics.beginFill(0xDDDDDD, 1);
			bgd.graphics.drawRect(0, 10, w, 5);
			bgd.graphics.endFill();
			/*
			bgd.graphics.lineStyle(1, 0x999999, 1);
			bgd.graphics.beginFill(0xFFFFFF, 1);
			bgd.graphics.drawRect(10,20,w-20,h-30);
			bgd.graphics.endFill();
			*/
			var sh_filters:Array = new Array(new DropShadowFilter(3, 75, 0x000000, 0.5, 4, 4, 1, 1));
			bgd.filters = sh_filters;
		}
		
		public function removeAll(){
			this.removeEventListener("rollOut", mouseOutHandler);
			if(buttSaveTemp) buttSaveTemp.removeEventListener("click", buttonSaveTempClickHandler);
			//if(buttSave) buttSave.removeEventListener("click", buttonSaveClickHandler);
			//if(inputSprite) inputSprite.removeEventListener("click", inputFieldClickHandler);
			
			var child;
			for(var i:int=this.numChildren-1; i>=0; i--){
				child = this.getChildAt(i);
				if(child is ProjectThumbnailCategoryTemp){
					child.removeAll();
				}
			}
			bgd.graphics.clear();
		}

	}
	
}
