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
		public var isColorized:Boolean = false;
		public var isOver:Boolean = false;
		
		private var animStep:Number;

		private const COLOR_TRANS_NORMAL = new ColorTransform();
		private const COLOR_TRANS_HIDDEN = new ColorTransform(0,0,0,0,0,0,0,0);
		private const COLOR_TRANS_OVER = new ColorTransform(0,0,0,1,50,100,150,1);

		public function Wall(){
			this.cacheAsBitmap = true;
			this.ink.cacheAsBitmap = true;
			this.alpha = 0;
			this.color = 0;
			this.colorTrans = COLOR_TRANS_NORMAL;
		}
	
		public function setOverState(){
			//this.ink.transform.colorTransform = COLOR_TRANS_OVER;
			
			var color = MovieClip(stage.getChildAt(0)).panelColors.colorHolder.colorData.color;
			var alphaValue:uint = color >> 24 & 0xFF;
			var red:uint = color >> 16 & 0xFF;
			var green:uint = color >> 8 & 0xFF;
			var blue:uint = color & 0xFF;
			var cTrans = new ColorTransform(0,0,0,0,red,green,blue,100);
			this.ink.transform.colorTransform = cTrans;
			
			if(!isOver) MovieClip(stage.getChildAt(0)).artBoard.signalWallOver(this.parent.getChildIndex(this)-1);
			this.isOver = true;
			this.addEventListener("enterFrame", alphaAnimate);
			// new over state
			/*
			this.alpha = 1;
			var color = MovieClip(stage.getChildAt(0)).panelColors.colorHolder.colorData.color;
			var alphaValue:uint = color >> 24 & 0xFF;
			var red:uint = color >> 16 & 0xFF;
			var green:uint = color >> 8 & 0xFF;
			var blue:uint = color & 0xFF;
			
			var cTrans = new ColorTransform(0,0,0,0,red,green,blue,100);
			this.ink.transform.colorTransform = cTrans;
			*/
		}
		
		private function alphaAnimate(e:Event){
			trace("wall: alpha="+this.alpha);
			if(this.alpha >= 1) animStep = -0.075;
			if(this.alpha <= 0) animStep = 0.075;
			this.alpha += animStep;
		}
		
		public function setOutState(){
			this.removeEventListener("enterFrame", alphaAnimate);
			this.ink.transform.colorTransform = colorTrans;
			this.alpha = isColorized ? 1 : 0;
			if(isOver) MovieClip(stage.getChildAt(0)).artBoard.signalWallOut(this.parent.getChildIndex(this)-1);
			this.isOver = false;
		}
		
		public function setColor(color:uint, signalBack:Boolean=true){
			trace("Wall "+this.name+ ": setColor: "+color);
			this.removeEventListener("enterFrame", alphaAnimate);
			
			this.color = color;
			this.isColorized = true;
			
			var alphaValue:uint = color >> 24 & 0xFF;
			var red:uint = color >> 16 & 0xFF;
			var green:uint = color >> 8 & 0xFF;
			var blue:uint = color & 0xFF;
			
			trace(red,green,blue,alphaValue);
			
			this.colorTrans = new ColorTransform(0,0,0,1,red,green,blue,1);
			this.ink.transform.colorTransform = colorTrans;
			this.alpha = 1;
			
			if(signalBack) MovieClip(stage.getChildAt(0)).artBoard.signalWallClick(this.parent.getChildIndex(this)-1);
		}
		
		public function clearWall(){
			this.ink.transform.colorTransform = this.colorTrans = COLOR_TRANS_NORMAL;
			this.alpha = 0;
			this.color = 0;
			this.isColorized = false;
		}
		
	}
	
}
