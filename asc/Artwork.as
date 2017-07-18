package{
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Artwork extends MovieClip{
		private var undoArray:Array;
		private var undoNum:int;
		public var foto:Bitmap;
		public var layers:Sprite;
		public var layerOver:Sprite;
		public var animStep;
		
		public const DEFAULT_COLOR:uint = 0x333333;
		private const COLOR_TRANS_OVER = new ColorTransform(0,0,0,1,50,100,150,1);

		public function Artwork(){
			this.undoArray = new Array();
			this.layers = new Sprite();
			this.addChild(layers);
		}
		
		public function undo(){
			trace("ArtWork: UNDO ", undoNum);
			if(undoArray[undoNum] != null){
				var layer = this.getLayer(undoNum);
				var maskB = layer.getChildAt(1);
				maskB.bitmapData = undoArray[undoNum];
			}
		}
		
		private function setUndo(num:int, bmd:BitmapData){
			if(bmd != null){
				this.undoNum = num;
				this.undoArray[num] = bmd.clone();
				Studio.rootStg.panelMain.butt_undo.enable();
			}
		}
		
		public function addFoto(pfoto:Bitmap){
			this.foto = pfoto;
			this.addChildAt(foto, 0);
		}
		
		public function appendPolygon(pcommands:Vector.<int>, pcoords:Vector.<Number>, selWall:WallsControlItem){
			var coords:Vector.<Number> = adaptCoordinates(pcoords);
			var num = selWall.wallNum;
			var color = selWall.colorData.color;

			var shape = new Shape();
			shape.graphics.beginFill(0, 1);
			shape.graphics.drawPath(pcommands, coords);
			shape.graphics.endFill();
			
			var layer = this.getLayer(num);
			var maskB = layer.getChildAt(1);
			this.setUndo(num, maskB.bitmapData);
			maskB.bitmapData.draw(shape);
			
			setColor(selWall); //* because of the first shape in the layer *//
		}
		
		public function removePolygon(pcommands:Vector.<int>, pcoords:Vector.<Number>, selWall:WallsControlItem){
			var coords:Vector.<Number> = adaptCoordinates(pcoords);
			var num = selWall.wallNum;
			var color = selWall.colorData.color;

			var shape = new Shape();
			shape.graphics.beginFill(0, 1);
			shape.graphics.drawPath(pcommands, coords);
			shape.graphics.endFill();
			
			var layer = this.getLayer(num);
			var maskB = layer.getChildAt(1);
			this.setUndo(num, maskB.bitmapData);
			maskB.bitmapData.draw(shape, null, null, "erase");
			
			setColor(selWall);
		}
		/*
		public function appendBrushLine(pcommands:Vector.<int>, pcoords:Vector.<Number>, selWall:WallsControlItem, pthick:int){
			var coords:Vector.<Number> = adaptCoordinates(pcoords);
			var num = selWall.wallNum;
			var color = selWall.colorData.color;
			var thick = pthick / this.scaleX;

			var shape = new Shape();
			shape.graphics.lineStyle(thick, color, 1);
			shape.graphics.drawPath(pcommands, coords);
			
			var layer = this.getLayer(num);
			var maskB = layer.getChildAt(1);
			maskB.bitmapData.draw(shape);
			
			setColor(selWall);
		}
		
		public function appendGumLine(pcommands:Vector.<int>, pcoords:Vector.<Number>, selWall:WallsControlItem, pthick:int){
			var coords:Vector.<Number> = adaptCoordinates(pcoords);
			var num = selWall.wallNum;
			var color = selWall.colorData.color;
			var thick = pthick / this.scaleX;

			var shape = new Shape();
			shape.graphics.lineStyle(thick, color, 1);
			shape.graphics.drawPath(pcommands, coords);
			
			var layer = this.getLayer(num);
			var maskB = layer.getChildAt(1);
			maskB.bitmapData.draw(shape, null, null, "erase");
			
			setColor(selWall);
		}
		*/
		public function appendLineMask(pcommands:Vector.<int>, pcoords:Vector.<Number>, selWall:WallsControlItem, pthick:int, blend:String = null){
			var coords:Vector.<Number> = adaptCoordinates(pcoords);
			var num = selWall.wallNum;
			var color = selWall.colorData.color;
			var thick = pthick / this.scaleX;

			var shape = new Shape();
			shape.graphics.lineStyle(thick, color, 1);
			shape.graphics.drawPath(pcommands, coords);
			
			var layer = this.getLayer(num);
			var maskB = layer.getChildAt(1);
			this.setUndo(num, maskB.bitmapData);
			maskB.bitmapData.draw(shape, null, null, blend);
			
			setColor(selWall);
		}
		
		public function appendMagicMask(mmask:BitmapData, selWall:WallsControlItem){
			var num = selWall.wallNum;
			var color = selWall.colorData.color;

			var layer = this.getLayer(num);
			var maskB = layer.getChildAt(1);
			this.setUndo(num, maskB.bitmapData);
			maskB.bitmapData.draw(mmask);
			setColor(selWall);
		}
		
		public function eraseMagicMask(mmask:BitmapData, selWall:WallsControlItem){
			var num = selWall.wallNum;
			var color = selWall.colorData.color;

			var layer = this.getLayer(num);
			var maskB = layer.getChildAt(1);
			this.setUndo(num, maskB.bitmapData);
			//var rect:Rectangle = new Rectangle(0, 0, w, h);
			var pnt:Point = new Point(0, 0);
			maskB.bitmapData.threshold(mmask, maskB.bitmapData.rect, pnt, ">", 0x33000000, 0x00FFFFFF, 0xFF000000);
			//maskB.bitmapData.draw(mmask);
			setColor(selWall);
		}
		
		public function setColor(wall:WallsControlItem){
			trace("Artwork: setColor");
			var num = wall.wallNum;
			var color = wall.colorData.color;
			var wAlpha = wall.wallAlpha;
			
			var count = layers.numChildren;
			if(count > num){ //* nelze barvit zatim neexistujici vrstvy
				var layer = this.getLayer(num);
				trace("Artwork: ...colorize layer "+num);
				var r:Number = ( ( color >> 16 ) & 0xff );
				var g:Number = ( ( color >> 8  ) & 0xff );
				var b:Number = (   color         & 0xff );
				layer.transform.colorTransform = new ColorTransform(0,0,0,0,r,g,b,255*wAlpha);
			}
		}
		
		public function removeLayer(num:int){
			var count = layers.numChildren;
			if(count > num){
				layers.removeChild(layers.getChildAt(num));
				undoArray.splice(num,1);
				if(undoNum == num) Studio.rootStg.panelMain.butt_undo.disable();
				if(undoNum < num) undoNum--;
			}
		}
		
		private function getLayer(num:int):Sprite{
			var count = layers.numChildren;
			var layer:Sprite;
			var layerShape:Shape;
			var layerMask:Sprite;
			var maskBmd:BitmapData;
			var maskB:Bitmap;
			for(var i:int=0; i<=num-count; i++){
				layerShape = new Shape();
				layerShape.graphics.beginFill(DEFAULT_COLOR, 1);
				layerShape.graphics.drawRect(0, 0, foto.width, foto.height);
				layerShape.graphics.endFill();
				
				maskBmd = new BitmapData(foto.width, foto.height, true, 0);
				maskB = new Bitmap(maskBmd, "auto", true);
				maskB.cacheAsBitmap = true;
				
				layer = new Sprite();
				layer.name = "layer"+num;
				layer.mouseChildren = false;
				layer.cacheAsBitmap = true;
				layer.addChild(layerShape);
				layer.addChild(maskB);
				layer.mask = maskB;
				this.layers.addChild(layer);
			}

			return layers.getChildAt(num) as Sprite;
		}
		
		public function checkLayersUnderPoint(pmouse:Point):int{
			var selected:Boolean = false;
			var layerNum:int = -1;
			var layer:Sprite;
			var maskB:Bitmap;
			var corner:Point = new Point(0, 0);
			
			for(var i:int=layers.numChildren-1; i>=0; i--){
				layer = layers.getChildAt(i) as Sprite;
				maskB = layer.getChildAt(1) as Bitmap;
				if(maskB.bitmapData.hitTest(corner, 0x05, pmouse) && !selected){
					//trace(layer.name);
					selected = true;
					layerNum = i;
					this.setOverState(layer);
				}else{
					this.setOutState(layer);
				}
			}
			return layerNum;
		}
		
		private function setOverState(layer:Sprite){
			if(layerOver != layer){
				var ct:ColorTransform = layer.transform.colorTransform;
				layerOver = layer;
				layerOver.alpha = ct.alphaOffset;
				layerOver.transform.colorTransform = COLOR_TRANS_OVER;
				layerOver.addEventListener("enterFrame", alphaAnimate);
			}
		}
		
		private function setOutState(layer:Sprite){
			if(layerOver == layer) layerOver = null;
			layer.removeEventListener("enterFrame", alphaAnimate);
			layer.alpha = 1;
			var num:int = this.layers.getChildIndex(layer);
			this.setColor(Studio.rootStg.panelWalls.wallsControl.getChildAt(num) as WallsControlItem);
		}

		private function alphaAnimate(e:Event){
			if(layerOver.alpha >= 1) animStep = -0.075;
			if(layerOver.alpha <= 0) animStep = 0.075;
			layerOver.alpha += animStep;
		}
		
		private function adaptCoordinates(pcoords:Vector.<Number>):Vector.<Number>{
			var px = this.x;
			var py = this.y;
			var scale = this.scaleX;
			for(var i:int=0; i<pcoords.length; i++){
				if(i%2 == 0){
					pcoords[i] -= px;
					pcoords[i] /= scale;
				}else{
					pcoords[i] -= py;
					pcoords[i] /= scale;
				}
			}
			return pcoords;
		}
		
		public function setOutStateToAll(e:MouseEvent){
			var layer;
			for(var i:int=0; i<layers.numChildren; i++){
				layer = layers.getChildAt(i);
				this.setOutState(layer);
			}
		}
		
		public function removeEventListeners(){
			var layer;
			for(var i:int=0; i<layers.numChildren; i++){
				layer = layers.getChildAt(i);
				layer.removeEventListener("enterFrame", alphaAnimate);
			}
		}

	}
}
