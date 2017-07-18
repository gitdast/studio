package{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class PanelMain extends Sprite{
		public var butt_undo;
		public var butt_zoomup;
		public var butt_zoomdown;
		public var butt_zoomfit;
		public var butt_zoommove;
		public var butt_print;
		public var butt_output;
		
		public var submenu;
		public var saver:ProjectTempSaver;
		public var mc_bgd:MovieClip;
		
		public static const PANEL_HEIGHT = 60;
		
		public function PanelMain(){
			trace("PanelMain: init");
			this.x = 0;
			this.y = Logo.PANEL_HEIGHT;
			this.createBackground();
			this.addButtons();
		}
		
		private function addButtons(){
			butt_undo = new ButtonUndo();
			butt_zoomup = new ButtonZoomUp();
			butt_zoomdown = new ButtonZoomDown();
			butt_zoomfit = new ButtonZoomFit();
			butt_zoommove = new ButtonZoomMove();
			butt_print = new ButtonPrint();
			butt_output = new ButtonOutput;
			
			var activeButtons:Array = ["butt_undo", "butt_zoomup", "butt_zoomdown", "butt_zoomfit", "butt_zoommove", "butt_print", "butt_output"],
				xPos:int = Studio.PANEL_PADDING,
				mx:int = 15,
				propId:String,
				butt;
			
			for(var i in activeButtons){
				propId = activeButtons[i];
				butt = this[propId];
				butt.x = propId == "butt_zoomup" ? xPos+3 : xPos; //* zoom icons move a little closer
				xPos += butt.width + mx;
			}

			this.addChild(butt_undo);
			this.addChild(butt_zoomup);
			this.addChild(butt_zoomdown);
			this.addChild(butt_zoomfit);
			this.addChild(butt_zoommove);
			this.addChild(butt_print);
			this.addChild(butt_output);
		}
		
		public function enable(isNewProject:Boolean = false){
			butt_print.enable();
			butt_output.enable();
			butt_zoomfit.enable();
			butt_zoomup.enable();
			butt_zoomdown.enable();
			butt_zoommove.enable();
			
			
			if(isNewProject){				
				
			}			
		}
		
		public function disable(){
			butt_undo.disable();
			butt_zoomup.disable();
			butt_zoomdown.disable();
			butt_zoommove.disable();
			butt_zoomfit.disable();
			butt_print.disable();
			butt_output.disable();
			//if(Studio.rootStg.temp.length == 0) butt_savetemp.disable();
		}
		
		/*
		public function openOutputSubmenu(){
			if(submenu) closeSubmenu();
			
			submenu = new OutputSubmenu();
			submenu.x = butt_output.x;
			submenu.y = 58;
			this.addChild(submenu);
		}
		
		public function openHomeSubmenu(){
			if(submenu) closeSubmenu();
			
			submenu = new HomeSubmenu();
			submenu.x = butt_home.x;
			submenu.y = 58;
			this.addChild(submenu);
		}
		
		public function tryCloseSubmenu(e:MouseEvent):Boolean{
			if(submenu.hitTestPoint(e.stageX, e.stageY, true)){
				trace("PM:submenu - let stay open");
				return false;
			}else{
				this.closeSubmenu();
				return true;
			}
		}
		
		public function closeSubmenu(){
			if(submenu){
				submenu.removeAll();
				this.removeChild(submenu);
				submenu = null;
			}
			butt_output.gotoAndStop(1);
			butt_home.gotoAndStop(1);
		}
		*/
		
		/*
		public function createProjectSaver(){
			var w = Studio.rootStg.appWidth - 450;
			var h = 300;
			saver = new ProjectSaver(w,h);
			saver.x = 210;
			saver.y = 58;
			this.addChild(saver);
		}
		
		public function tryCloseProjectSaver(e:MouseEvent):Boolean{
			if(saver.hitTestPoint(e.stageX, e.stageY, true)){
				trace("let stay open");
				return false;
			}else{
				this.closeProjectSaver();
				return true;
			}
		}
		
		public function closeProjectSaver(){
			saver.removeAll();
			this.removeChild(saver);
			butt_save.gotoAndStop(1);
		}
		*/
		
		public function createProjectTempSaver(){
			/*var w = Studio.rootStg.appWidth - 450;
			var h = 300;
			saver = new ProjectTempSaver(w,h);
			saver.x = 210;
			saver.y = 58;
			this.addChild(saver);*/
		}
		
		public function tryCloseProjectTempSaver(e:MouseEvent):Boolean{
			/*if(saver.hitTestPoint(e.stageX, e.stageY, true)){
				trace("let stay open");
				return false;
			}else{
				this.closeProjectTempSaver();
				return true;
			}*/
			return true;
		}
		
		public function closeProjectTempSaver(){
			/*saver.removeAll();
			this.removeChild(saver);
			butt_savetemp.gotoAndStop(1);*/
		}
		
		private function createBackground(){
			mc_bgd = new background_panel();
			mc_bgd.width = Studio.PANEL_WIDTH;
			mc_bgd.height = PANEL_HEIGHT;
			this.addChild(mc_bgd);
		}
		
	}
	
}
