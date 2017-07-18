package prepared{
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.ui.Mouse;
	
	public class ArtBoardPrepared extends ArtBoard{
		
		public function ArtBoardPrepared(stageW:Number, stageH:Number){
			super(stageW, stageH);
		}
		
		public function addPreparedProject(proj:Loader){
			this.addChild(proj);
			this.projectMc = proj.content as MovieClip;
			projWidth = proj.width;
			projHeight = proj.height;

			this.resizeProjectMc();
			
			this.createCursor();
			
			this.setMode(MODE_COLOR);
		}
		
		override public function setMode(pmode:String){
			super.setMode(pmode);
			
			this.actionMode = pmode;
			switch(pmode){
				case MODE_COLOR: //only for prepared projects
					this.changeCursor(new ico_bucket);
					projectMc.mouseChildren = true;
					projectMc.addEventListeners();
					projectMc.addEventListener("click", clickHandlerColor);
					break;
				
				default:
					cursor.visible = false;
					Mouse.show();
					break;
			}
		}

		private function clickHandlerColor(e:MouseEvent){
			if(Studio.rootStg.panelColors.colorHolder.isSet){
				projectMc.clickHandlerColor(Studio.rootStg.panelColors.colorHolder.colorData.color);
			}else{
				Studio.rootStg.panelColors.colorHolder.showEmptyWarning();
			}
		}
		
		public function signalWallOver(wallNum:int){
			trace("receivedWallOver "+wallNum);
		}
		
		public function signalWallOut(wallNum:int){
			trace("receivedWallOut "+wallNum);
		}
		
		public function signalWallClick(wallNum:int){
			trace("receivedWallClick "+wallNum);
			var wall = wallsControl.getChildAt(wallNum);
			wall.setColor(Studio.rootStg.panelColors.colorHolder.colorData);
		}
		
		override public function reposProjectMc(){
			//var projScale = Math.min(boardWidth / projWidth, boardHeight / projHeight);
			var downScale = 800 / projWidth; downScale = downScale > 1 ? 1 : downScale; //kvuli obrazu na vysku
			
			projectMc.scaleX = downScale;
			projectMc.scaleY = downScale;
			
			var px = boardWidth/2 - projectMc.width/2;
			var py = boardHeight/2 - projectMc.height/2;
			projectMc.x = px > 0 ? px : 0;
			projectMc.y = py > 0 ? py : 0;
		}
		
		override public function resizeProjectMc(){
			//trace("ArtBoard:resizeProjectMc:", boardWidth, projWidth, boardHeight, projHeight);
			var projScale = Math.min(boardWidth / projWidth, boardHeight / projHeight);
			var downScale = 800 / projWidth; downScale = downScale > 1 ? 1 : downScale; //kvuli obrazu na vysku
			var minScale = Math.min(projScale, downScale);
			
			projectMc.scaleX = minScale;
			projectMc.scaleY = minScale;
			//projectMc.scaleX = projScale > 1 ? 1 : projScale;
			//projectMc.scaleY = projScale > 1 ? 1 : projScale;
			
			var px = boardWidth/2 - projectMc.width/2;
			var py = boardHeight/2 - projectMc.height/2;
			projectMc.x = px > 0 ? px : 0;
			projectMc.y = py > 0 ? py : 0;
		}
		
		override public function removeAll(){
			super.removeAll();
			
			if(projectMc){
				projectMc.removeEventListener("click", clickHandlerColor);
			}
		}

	}
	
}
