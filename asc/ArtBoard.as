package{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.ui.Mouse;
	
	public class ArtBoard extends Sprite{
		public var wallsControl:WallsControl;
		
		public var hitSprite:Sprite;
		public var maskSprite:Sprite;
		public var projectMc:MovieClip;
		public var cursor:Sprite;
		
		public var boardWidth:Number;
		public var boardHeight:Number;
		public var projWidth:Number;
		public var projHeight:Number;
		
		public var actionMode:String;
		public var viewMode:String = "start";
		
		public const MODE_COLOR = "coloring";
		public const MODE_MOVE = "move";
		public const MODE_DRAW_CURVE = "curvePlus";
		public const MODE_DRAW_CURVE_NEG = "curveMinus";
		public const MODE_DRAW_BRUSH = "brush";
		public const MODE_DRAW_GUM = "gum";
		public const MODE_DRAW_WAND = "magicPlus";
		public const MODE_DRAW_WAND_NEG = "magicMinus";
		
		public const MAX_TOOL_SIZE = 20;
		public const MAX_WAND_TOLERANCE = 100;

		public function ArtBoard(stageW:Number, stageH:Number){
			trace("ArtBoard: init",stageW, stageH);
			this.boardWidth = stageW - Studio.PANEL_WIDTH - 10;
			this.boardHeight = stageH - 30 - 15;
			this.x = Studio.PANEL_WIDTH + 5;
			this.y = 30;
			this.addHitArea();
		}
		
		public function setMode(pmode:String){
			trace("ArtBoard - setMode:", pmode);
			this.remove();
			this.addEventListener("rollOver", cursorRollOverHandler);
			this.addEventListener("rollOut", cursorRollOutHandler);
			projectMc.mouseChildren = false;
			
			this.actionMode = pmode;
		}
		
		public function changeColor(wall:WallsControlItem){
			projectMc.setColor(wall);
		}
		
		public function moveMouseDownHandler(e:MouseEvent){
			trace("ArtBoard: moveMouseDownHandler ");
			this.addEventListener("rollOut", moveMouseUpHandler);
			projectMc.startDrag(false,null);
		}
		
		public function moveMouseUpHandler(e:MouseEvent){
			trace("ArtBoard: moveMouseUpHandler ");
			this.removeEventListener("rollOut", moveMouseUpHandler);
			projectMc.stopDrag();
		}

		public function cursorRollOverHandler(e:MouseEvent){
			//trace("Artboard: rollOVER");
			this.addEventListener("mouseMove", cursorMouseMoveHandler);
			cursor.visible = true;
			cursor.x = mouseX;
			cursor.y = mouseY;
			Mouse.hide();
		}
		
		public function cursorRollOutHandler(e:MouseEvent){
			//trace("Artboard: rollOUT");
			this.removeEventListener("mouseMove", cursorMouseMoveHandler);
			cursor.visible = false;
			Mouse.show();
		}
		
		public function cursorMouseMoveHandler(e:MouseEvent){
			cursor.x = mouseX;
			cursor.y = mouseY;
			e.updateAfterEvent();
		}
		
		public function changeCursor(c:MovieClip){
			if(this.cursor.numChildren > 0){
				cursor.removeChild(cursor.getChildAt(0));
			}
			
			this.cursor.addChild(c);
			
			this.updateCursor();
		}
		
		public function updateCursor(){
			var c = this.cursor.getChildAt(0);
			if(actionMode == MODE_DRAW_GUM){
				c.width = 1 + Studio.rootStg.panelTools.setting_gum * MAX_TOOL_SIZE;
				c.height = 1 + Studio.rootStg.panelTools.setting_gum * MAX_TOOL_SIZE;
			}
			else if(actionMode == MODE_DRAW_BRUSH){
				c.scaleX = 1 + Studio.rootStg.panelTools.setting_brush * MAX_TOOL_SIZE / 10;
				c.scaleY = 1 + Studio.rootStg.panelTools.setting_brush * MAX_TOOL_SIZE / 10;
			}
		}
		
		public function createCursor(){
			cursor = new Sprite; 
			cursor.visible = false;
			cursor.mouseChildren = false;
			cursor.mouseEnabled = false;
			this.addChild(cursor);
		}
		
		public function zoomUp(){
			this.viewMode = "zoom";
			
			var scale = projectMc.scaleX;
			var step = scale < 1 ? 0.1 : 0.5;
			var newScale = scale + step;
			trace("ArtBoard: zoom ", step, scale, newScale);
			projectMc.scaleX = newScale;
			projectMc.scaleY = newScale;
		}
		
		public function zoomDown(){
			this.viewMode = "zoom";
			
			if(projectMc.width < 150) return;
			
			var scale = projectMc.scaleX;
			var step = scale > 1 ? 0.5 : 0.1;
			var newScale = scale - step;
			if((scale > 1) && (newScale < 1)){
				newScale = scale > 1.05 ? 1 : 0.9;
			}
			
			trace("ArtBoard: zoom ", step, scale, newScale);
			projectMc.scaleX = newScale;
			projectMc.scaleY = newScale;
		}
		
		public function zoomActual(){
			this.viewMode = "actual";
			this.reposProjectMc();
		}
		
		public function zoomFit(){
			this.viewMode = "fit";
			this.fitProjectMc();
		}
		
		public function fitProjectMc(){
			var projScale = Math.min(boardWidth / projWidth, boardHeight / projHeight);
			projectMc.scaleX = projScale; //projScale > 1 ? 1 : projScale;
			projectMc.scaleY = projScale; //projScale > 1 ? 1 : projScale;
			
			var px = boardWidth/2 - projectMc.width/2;
			var py = boardHeight/2 - projectMc.height/2;
			projectMc.x = px > 0 ? px : 0;
			projectMc.y = py > 0 ? py : 0;
		}
		
		public function reposProjectMc(){
			var projScale = Math.min(boardWidth / projWidth, boardHeight / projHeight);
			projectMc.scaleX = 1;
			projectMc.scaleY = 1;
			
			var px = boardWidth/2 - projectMc.width/2;
			var py = boardHeight/2 - projectMc.height/2;
			projectMc.x = px > 0 ? px : 0;
			projectMc.y = py > 0 ? py : 0;
		}
		
		public function resizeProjectMc(){
			//trace("ArtBoard:resizeProjectMc:", boardWidth, projWidth, boardHeight, projHeight);
			var projScale = Math.min(boardWidth / projWidth, boardHeight / projHeight);
			projectMc.scaleX = projScale > 1 ? 1 : projScale;
			projectMc.scaleY = projScale > 1 ? 1 : projScale;
			
			var px = boardWidth/2 - projectMc.width/2;
			var py = boardHeight/2 - projectMc.height/2;
			projectMc.x = px > 0 ? px : 0;
			projectMc.y = py > 0 ? py : 0;
		}
				
		public function setDimensions(stageW:Number, stageH:Number){
			this.boardWidth = stageW - Studio.PANEL_WIDTH - 10;
			this.boardHeight = stageH - 50 - 15 - 15;
		}
		
		public function resizeHandler(stageW:Number, stageH:Number){
			this.setDimensions(stageW, stageH);
			if(viewMode == "start") this.resizeProjectMc();
			if(viewMode == "fit") this.fitProjectMc();
			if(viewMode == "actual") this.reposProjectMc();
			this.resizeHitArea();
		}
		
		public function resizeHitArea(){
			hitSprite.graphics.clear();
			hitSprite.graphics.beginFill(0,1);
			hitSprite.graphics.drawRect(0,0,boardWidth,boardHeight);
			hitSprite.graphics.endFill();
			
			maskSprite.graphics.clear();
			maskSprite.graphics.beginFill(0,1);
			maskSprite.graphics.drawRect(0,0,boardWidth,boardHeight);
			maskSprite.graphics.endFill();
		}
		
		public function addHitArea(){
			hitSprite = new Sprite();
			hitSprite.mouseEnabled = false;
			hitSprite.visible = false;
			hitSprite.graphics.beginFill(0,1);
			hitSprite.graphics.drawRect(0,0,boardWidth,boardHeight);
			hitSprite.graphics.endFill();
			this.addChild(hitSprite);
			this.hitArea = hitSprite;
			
			maskSprite = new Sprite();
			maskSprite.mouseEnabled = false;
			maskSprite.visible = false;
			maskSprite.graphics.beginFill(0,1);
			maskSprite.graphics.drawRect(0,0,boardWidth,boardHeight);
			maskSprite.graphics.endFill();
			this.addChild(maskSprite);
			this.mask = maskSprite;
		}
		
		public function remove(){
			if(projectMc){
				projectMc.removeEventListener("mouseDown", moveMouseDownHandler);
				projectMc.removeEventListener("mouseUp", moveMouseUpHandler);
				this.removeEventListener("rollOut", moveMouseUpHandler);
				projectMc.remove();
			}
			this.removeEventListener("rollOver", cursorRollOverHandler);
			this.removeEventListener("rollOut", cursorRollOverHandler);
			this.removeEventListener("mouseMove", cursorMouseMoveHandler);
		}

	}
}
