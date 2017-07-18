package prepared{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	public class PreparedProject extends MovieClip{
		public var selectedWall:prepared.Wall;
		private var mouseSkiper:Number;
		
		public function PreparedProject(){
			trace("PreparedProject: init...");
			//this.cacheAsBitmap = true;
			this.addEventListeners();
		}
		
		public function addEventListeners(){
			//this.buttonMode = true;
			this.addEventListener("mouseOver", overHandler);
			this.addEventListener("mouseOut", outHandler);
			//this.addEventListener("click", clickHandler);
		}
		
		public function removeEventListeners(){
			//this.buttonMode = false;
			this.removeEventListener("mouseOver", overHandler);
			this.removeEventListener("mouseOut", outHandler);
			//this.removeEventListener("click", clickHandler);
		}
		
		private function overHandler(e:MouseEvent){
			trace("Project over");
			mouseSkiper = -1;
			this.addEventListener("mouseMove", moveHandler);
		}
		
		private function moveHandler(e:MouseEvent){
			if(mouseSkiper < 0){
				var selected:Boolean = false;
				var child:prepared.Wall;
				for(var i:int=this.numChildren-1; i>0; i--){
					var bmd:BitmapData = new BitmapData(this.width, this.height,true,0);
					child = this.getChildAt(i) as prepared.Wall;
					//* because of resizing
					var matrix:Matrix = new Matrix();
					var scale:Number = this.width / child.width;
    	        	matrix.scale(scale, scale);
				
					bmd.draw(child.ink, matrix);
					var pixelValue:uint = bmd.getPixel32(e.localX*scale, e.localY*scale); //* resizing needed as well
					var alphaValue:uint = pixelValue >> 24 & 0xFF;
					if(alphaValue > 150 && !selected){
						this.selectedWall = child;
						child.setOverState();
						selected = true;
					}else{
						//trace("out state");
						child.setOutState();
					}
				}
			}
			mouseSkiper *= -1;
		}
		
		private function outHandler(e:MouseEvent){
			trace("Project out");
			var child:prepared.Wall;
			for(var i:int=this.numChildren-1; i>0; i--){
				child = this.getChildAt(i) as prepared.Wall;
				child.setOutState();
			}
			this.removeEventListener("mouseMove", moveHandler);
		}
		
		public function clickHandlerColor(color:uint){
			trace("prepared >> click progress with color=" + color);
			selectedWall.setColor(color);
		}
		
		public function signalWallOver(num:int){
			trace("PreparedProject: signal over "+num);
			var child = this.getChildAt(num) as prepared.Wall;
			child.setOverState();
		}
		
		public function signalWallOut(num:int){
			trace("PreparedProject: signal out");
			var child = this.getChildAt(num) as prepared.Wall;
			child.setOutState();
		}
		
		public function clearAll(){
			var child:prepared.Wall;
			for(var i:int=this.numChildren-1; i>0; i--){
				child.clearWall();
			}
		}
	}
	
}
