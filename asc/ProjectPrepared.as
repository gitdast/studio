package{
	
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.utils.ByteArray;
	import flash.display.BitmapData;
	import adobe.PNGEncoder;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLVariables;
	import flash.net.URLRequestHeader;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.geom.Matrix;
	import prepared.Wall;
	
	public class ProjectPrepared extends Project{
		
		public function ProjectPrepared(prObj:Object = null){
			trace("ProjectPrepared: init...");
			super();
			this.prData = prObj;
		}
		
		public function loadPreparedProject(){
			loader = new Loader;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, swfLoaded);
			loader.load(new URLRequest(prData.link));
			
			Studio.rootStg.addLoading();
		}
		
		private function swfLoaded(e:Event){
			trace("Project: swf loaded");
			trace(prData.elements);
			Studio.rootStg.removeLoading();
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, swfLoaded);
			
			var wc = Studio.rootStg.panelWalls.addWallsControl("pasive");
			wc.addWalls(prData.elements);
			wc.selectedWall = wc.getChildAt(wc.numChildren-1);
			wc.selectedWall.setSelected(true);
			
			this.artBoard = Studio.rootStg.createArtBoard("prepared");
			this.artBoard.addPreparedProject(loader);
			this.artBoard.wallsControl = wc;
			
			this.type = "prepared";
			Studio.rootStg.panelMain.enable();
			Studio.rootStg.panelSave.enable();
		}
		
		public function getTempData(){
			var tempData:Object = new Object();
			tempData.prId = this.getSomeId();
			tempData.link = prData.link;
			tempData.type = this.type;
			//tempData.elements = prData.elements;
			tempData.elements = new Array();
			tempData.walls = new Array();
			var i:int;
			for(i=0; i<prData.elements.length; i++){
				tempData.elements.push(new XML(prData.elements[i]));
			}
			
			/* thumb generation - height 100px */
			var matrix:Matrix = new Matrix();
			var scaleH:Number = 100 / artBoard.projectMc.height * artBoard.projectMc.scaleY;
			var thumbBmd:BitmapData = new BitmapData(artBoard.projectMc.width/artBoard.projectMc.scaleY*scaleH, 100, true, 0);
           	matrix.scale(scaleH, scaleH);
			thumbBmd.draw(artBoard.projectMc, matrix);
			var thumb:Bitmap = new Bitmap(thumbBmd, "auto", true);
			tempData.thumb = thumb;
			/*
			var child:prepared.Wall;
			for(var i:int=artBoard.projectMc.numChildren-1; i>0; i--){
				child = artBoard.projectMc.getChildAt(i) as prepared.Wall;
				tempData.walls.push(child.color);
				if(child.isColorized){
					tempData.elements[i-1].color = child.color;
					//tempData.elements[i-1].label = child.label;
					trace(child.color);
				}else{
					trace(i);
				}
			}
			*/
			var wc = Studio.rootStg.panelWalls.wallsControl;
			var wall:WallsControlItem;
			for(i = 0; i < wc.numChildren; i++){
				wall = wc.getChildAt(i);
				if(wall.colorData.label){
					tempData.elements[i].color.hex = wall.colorData.color;
					tempData.elements[i].color.name = wall.colorData.label;
					trace(wall.colorData.label);
				}else{
					trace(i);
				}
			}
			
			return tempData;
		}
		
//*** RESTORE PROJECT ***//

		public function restoreProject(){
			loader = new Loader;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, swfLoadedForRestore);
			loader.load(new URLRequest(prData.link));
			
			Studio.rootStg.addLoading();
		}
		
		private function swfLoadedForRestore(e:Event){
			this.swfLoaded(e);
			
			var child:prepared.Wall;
			var chNum = artBoard.projectMc.numChildren;
			for(var i:int=1; i<chNum; i++){
				if(prData.elements[i-1].hasOwnProperty("color")){
					child = artBoard.projectMc.getChildAt(i) as prepared.Wall;
					child.setColor(prData.elements[i-1].color.hex);
				}
			}
		}
		
//*** CLOSE PROJECT ***//

		override public function closeProject(){
			super.closeProject();
			if(urlLoader){
			}
			if(loader){
				if(loader.contentLoaderInfo) loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, swfLoaded);
			}
		}
	}
}
