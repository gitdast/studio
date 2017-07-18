package{
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	//import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	public class ArtBoardNew extends ArtBoard{
		public var drawLayer:Sprite;
		public var drawShowLayer:Sprite;
		
		public var curve_commands:Vector.<int>;
		public var curve_coord:Vector.<Number>;
		
		public function ArtBoardNew(stageW:Number, stageH:Number){
			super(stageW, stageH);
		}
		
		public function addNewProject(proj:Loader){
			this.projectMc = new Artwork();
			this.addChild(projectMc);
			projectMc.addFoto(proj.content);
			
			this.doubleClickEnabled = true;
			projectMc.doubleClickEnabled = true;
			projectMc.mouseChildren = false;
			
			projWidth = proj.content.width;
			projHeight = proj.content.height;

			this.resizeProjectMc();
			
			drawLayer = new Sprite();
			drawLayer.mouseEnabled = false;
			this.addChild(drawLayer);
			drawShowLayer = new Sprite();
			drawShowLayer.mouseEnabled = false;
			this.addChild(drawShowLayer);
			
			this.createCursor();
		}
		
		override public function setMode(pmode:String){
			super.setMode(pmode);
			
			//* change from MODE_COLOR_ACTIVE >> *
			if(actionMode == MODE_COLOR_ACTIVE){
				wallsControl.reselectWall();
			}

			this.actionMode = pmode;
			switch(pmode){
				case MODE_MOVE:
					this.changeCursor(new ico_move);
					projectMc.addEventListener("mouseDown", moveMouseDownHandler);
					projectMc.addEventListener("mouseUp", moveMouseUpHandler);
					break;
				case MODE_COLOR_ACTIVE:
					this.changeCursor(new ico_bucket);
					projectMc.mouseChildren = true;
					projectMc.addEventListener("click", paintClickHandler);
					projectMc.addEventListener("mouseMove", paintMoveHandler);
					projectMc.addEventListener("rollOut", projectMc.setOutStateToAll);
					wallsControl.deselectWall(); //* change from * >> MODE_COLOR_ACTIVE
					break;
				case MODE_DRAW_CURVE:
					this.changeCursor(new ico_arrow);
					this.addEventListener("click", curveClickHandler);
					this.addEventListener("doubleClick", curveDoubleClickHandler);
					break;
				case MODE_DRAW_CURVE_NEG:
					this.changeCursor(new ico_arrow);
					this.addEventListener("click", curveClickHandler);
					this.addEventListener("doubleClick", curveDoubleClickHandler);
					break;
				case MODE_DRAW_BRUSH:
					this.changeCursor(new ico_brush);
					this.addEventListener("mouseDown", brushMouseDownHandler);
					this.addEventListener("mouseUp", brushMouseUpHandler);
					//projectMc.addEventListener("rollOut", brushMouseUpHandler);
					break;
				case MODE_DRAW_GUM:
					this.changeCursor(new ico_gum);
					this.addEventListener("mouseDown", brushMouseDownHandler);
					this.addEventListener("mouseUp", brushMouseUpHandler);
					//projectMc.addEventListener("rollOut", brushMouseUpHandler);
					break;
				case MODE_DRAW_WAND:
					this.changeCursor(new ico_wand);
					projectMc.addEventListener("click", magicClickHandler);
					break;
				case MODE_DRAW_WAND_NEG:
					this.changeCursor(new ico_wand);
					projectMc.addEventListener("click", magicMinusClickHandler);
					break;
				default:
					trace("ArtBoardNew: setMode default");
					this.removeEventListener("rollOver", cursorRollOverHandler);
					this.removeEventListener("rollOut", cursorRollOverHandler);
					this.removeEventListener("mouseMove", cursorMouseMoveHandler);
					cursor.visible = false;
					Mouse.show();
					break;
			}
		}

		private function paintClickHandler(e:MouseEvent){
			trace("ArtBoard: paintClickHandler ", e.target.name);
			wallsControl.selectedWall.setColor(Studio.rootStg.panelColors.colorHolder.colorData);
			this.signalColorChanged(wallsControl.selectedWall);
		}
		
		private function paintMoveHandler(e:MouseEvent){
			var layerOver = projectMc.checkLayersUnderPoint(new Point(e.localX, e.localY));
			if(layerOver >= 0){
				wallsControl.selectedWall = wallsControl.getChildAt(layerOver) as WallsControlItem;
			}
		}
		
		private function curveClickHandler(e:MouseEvent){
			trace("ArtBoard: curveClickHandler");
			if(curve_coord){
				curve_commands.push(2);
				curve_coord.push(mouseX);
				curve_coord.push(mouseY);
				drawLayer.graphics.clear();
				drawLayer.graphics.lineStyle(1, 0x0099FF, 1);
				drawLayer.graphics.drawPath(curve_commands, curve_coord);
			}else{
				this.addEventListener("mouseMove", curveMouseMoveHandler);
				drawLayer.graphics.clear();
				drawLayer.graphics.lineStyle(1, 0x0099FF, 1);
				drawLayer.graphics.moveTo(mouseX, mouseY);
				curve_commands = new Vector.<int>();
				curve_coord = new Vector.<Number>();
				curve_commands.push(1);
				curve_coord.push(mouseX);
				curve_coord.push(mouseY);
			}
		}
		
		private function curveDoubleClickHandler(e:MouseEvent){
			trace("ArtBoard: curveDoubleClickHandler");
			this.removeEventListener("mouseMove", curveMouseMoveHandler);
			if(curve_coord.length < 6){
				drawLayer.graphics.clear();
				drawShowLayer.graphics.clear();
				curve_commands = null;
				curve_coord = null;
				return;
			}
			//* uzavreni polygonu *//
			curve_commands.push(2);
			curve_coord.push(mouseX);
			curve_coord.push(mouseY);
			curve_commands.push(2);
			curve_coord.push(curve_coord[0]);
			curve_coord.push(curve_coord[1]);
			
			if(this.actionMode == MODE_DRAW_CURVE){
				this.projectMc.appendPolygon(curve_commands, curve_coord, wallsControl.selectedWall);
			}else{
				this.projectMc.removePolygon(curve_commands, curve_coord, wallsControl.selectedWall);
			}

			drawLayer.graphics.clear();
			drawShowLayer.graphics.clear();
			curve_commands = null;
			curve_coord = null;
		}
		
		private function curveMouseMoveHandler(e:MouseEvent){
			drawShowLayer.graphics.clear();
			drawShowLayer.graphics.lineStyle(1, 0x0099FF, 1);
			drawShowLayer.graphics.moveTo(curve_coord[curve_coord.length-2],curve_coord[curve_coord.length-1]);
			drawShowLayer.graphics.lineTo(mouseX, mouseY);
		}
		
		
		private function brushMouseDownHandler(e:MouseEvent){
			trace("ArtBoard: brushMouseDownHandler");
			this.addEventListener("mouseMove", brushMouseMoveHandler);
			var color = wallsControl.selectedWall.colorData.color;
			var thick:Number;
			if(this.actionMode == MODE_DRAW_BRUSH){
				thick = Studio.rootStg.panelTools.setting_brush * MAX_TOOL_SIZE;
			}else{
				thick = Studio.rootStg.panelTools.setting_gum * MAX_TOOL_SIZE;
			}
			drawLayer.graphics.clear();
			drawLayer.graphics.lineStyle(thick, color, 0.5);
			drawLayer.graphics.moveTo(mouseX, mouseY);
			curve_commands = new Vector.<int>();
			curve_coord = new Vector.<Number>();
			curve_commands.push(1);
			curve_coord.push(mouseX);
			curve_coord.push(mouseY);
		}
		
		private function brushMouseUpHandler(e:MouseEvent){
			this.removeEventListener("mouseMove", brushMouseMoveHandler);
			if(!curve_commands) return;

			var thick:Number;
			var blend:String = null;
			if(this.actionMode == MODE_DRAW_BRUSH){
				thick = Studio.rootStg.panelTools.setting_brush * MAX_TOOL_SIZE;
			}else{
				thick = Studio.rootStg.panelTools.setting_gum * MAX_TOOL_SIZE;
				blend = "erase";
			}
			this.projectMc.appendLineMask(curve_commands, curve_coord, wallsControl.selectedWall, thick, blend);
			
			drawLayer.graphics.clear();
			curve_commands = null;
			curve_coord = null;
		}
		
		private function brushMouseMoveHandler(e:MouseEvent){
			curve_commands.push(2);
			curve_coord.push(mouseX);
			curve_coord.push(mouseY);
			drawLayer.graphics.lineTo(mouseX, mouseY);
		}
		
		private function magicClickHandler(e:MouseEvent){
			trace("ArtBoard: magic click");
			var xm = Math.floor((mouseX - projectMc.x) / projectMc.scaleX);
			var ym = Math.floor((mouseY - projectMc.y) / projectMc.scaleX);
			var setting = Studio.rootStg.panelTools.setting_magic * MAX_WAND_TOLERANCE;

			var shapeBmd = Utils.floodFill(projectMc.foto.bitmapData, xm, ym, setting);
			this.projectMc.appendMagicMask(shapeBmd, wallsControl.selectedWall);
		}
		
		private function magicMinusClickHandler(e:MouseEvent){
			trace("ArtBoard: magic minus click");
			var xm = Math.floor((mouseX - projectMc.x) / projectMc.scaleX);
			var ym = Math.floor((mouseY - projectMc.y) / projectMc.scaleX);
			var setting = Studio.rootStg.panelTools.setting_magic * MAX_WAND_TOLERANCE;

			var shapeBmd = Utils.floodFill(projectMc.foto.bitmapData, xm, ym, setting);
			this.projectMc.eraseMagicMask(shapeBmd, wallsControl.selectedWall);
		}
		
		public function signalRemoveWall(num:int){
			projectMc.removeLayer(num);
		}
		
		public function signalColorChanged(wall:WallsControlItem){
			projectMc.setColor(wall);
		}
		
		override public function removeAll(){
			super.removeAll();
			
			if(projectMc){
				projectMc.removeEventListener("click", paintClickHandler);
				projectMc.removeEventListener("mouseMove", paintMoveHandler);
				if(actionMode == MODE_COLOR_ACTIVE) projectMc.removeEventListener("rollOut", projectMc.setOutStateToAll);
				this.removeEventListener("click", curveClickHandler);
				this.removeEventListener("mouseMove", curveMouseMoveHandler);
				this.removeEventListener("doubleClick", curveDoubleClickHandler);
				this.removeEventListener("mouseDown", brushMouseDownHandler);
				this.removeEventListener("mouseMove", brushMouseMoveHandler);
				this.removeEventListener("mouseUp", brushMouseUpHandler);
				projectMc.removeEventListener("click", magicClickHandler);
				projectMc.removeEventListener("click", magicMinusClickHandler);
			}
			if(drawLayer){
				drawLayer.graphics.clear();
				drawShowLayer.graphics.clear();
				curve_commands = null;
				curve_coord = null;
			}
		}

	}
	
}
