package prepared{
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class Wall extends MovieClip{
		public var ink:MovieClip;
		public var shadow:MovieClip;

		public var color:uint;
		public var colorTrans:ColorTransform;
		
		private var animStep:Number;

		private const COLOR_TRANS_NORMAL = new ColorTransform();
		private const COLOR_TRANS_HIDDEN = new ColorTransform(0,0,0,0,0,0,0,0);
		private const COLOR_TRANS_OVER = new ColorTransform(0,0,0,1,50,100,150,1);

		public function Wall(){
			this.cacheAsBitmap = true;
			this.ink.cacheAsBitmap = true;

			this.color = 0;
			this.colorTrans = COLOR_TRANS_NORMAL;
		}
	
		public function setOverState(){
			trace("Wall setOverState "+this.name);
			var studio = MovieClip(stage.getChildAt(0));
			if(!studio.panelWalls.wallsControl.selectedWall.colorData.hasOwnProperty("color")){
				this.ink.transform.colorTransform = COLOR_TRANS_OVER;
			}
						
			this.addEventListener("enterFrame", alphaAnimate);
		}
		
		private function alphaAnimate(e:Event){
			if(this.alpha >= 1) animStep = -0.075;
			if(this.alpha <= 0) animStep = 0.075;
			this.alpha += animStep;
		}
		
		public function setOutState(){
			this.removeEventListener("enterFrame", alphaAnimate);
			this.ink.transform.colorTransform = this.colorTrans;
			this.alpha = 1;
		}
		
		public function setColor(color:uint){
			trace("Wall "+this.name+ ": setColor: "+color);
			this.removeEventListener("enterFrame", alphaAnimate);
			
			var alphaValue:uint = color >> 24 & 0xFF,
				red:uint = color >> 16 & 0xFF,
				green:uint = color >> 8 & 0xFF,
				blue:uint = color & 0xFF;
				
			this.color = color;
			this.colorTrans = this.ink.transform.colorTransform = new ColorTransform(0, 0, 0, 1, red, green, blue, alphaValue);
		}
		
		public function clearWall(){
			this.colorTrans = this.ink.transform.colorTransform = COLOR_TRANS_NORMAL;
			this.color = 0;
		}
		
		public function remove(){
			this.removeEventListener("enterFrame", alphaAnimate);
		}
		
	}
	
}
