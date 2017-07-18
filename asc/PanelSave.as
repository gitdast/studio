package{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class PanelSave extends Sprite{
		public var butt_savetemp:ButtonSaveTemp;
		public var butt_save:ButtonSave;
		public var butt_home:ButtonHome;
		
		//public var saver:ProjectTempSaver;
		public var mc_bgd:MovieClip;
		
		public static const PANEL_HEIGHT = 65;
		
		public function PanelSave(){
			trace("PanelSave: init");
			this.x = 0;
			this.y = Logo.PANEL_HEIGHT + PanelMain.PANEL_HEIGHT;
			this.createBackground();
			this.addButtons();
		}
		
		private function addButtons(){
			butt_save = new ButtonSave();
			butt_save.x = Studio.PANEL_PADDING;
			butt_home = new ButtonHome();
			butt_home.x = butt_save.x + butt_save.width;
			butt_savetemp = new ButtonSaveTemp();
			butt_savetemp.x = butt_home.x + butt_home.width;
			
			butt_save.y = butt_home.y = butt_savetemp.y = PanelSave.PANEL_HEIGHT / 2;

			this.addChild(butt_save);
			this.addChild(butt_home);
			this.addChild(butt_savetemp);
		}
		
		public function enable(isNewProject:Boolean = false){
			butt_save.enable();
			butt_home.enable();
			butt_savetemp.enable();
		}
		
		public function disable(){
			butt_save.disable();
			butt_home.disable();
			if(Studio.rootStg.temp.length == 0) butt_savetemp.disable(); //??
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
