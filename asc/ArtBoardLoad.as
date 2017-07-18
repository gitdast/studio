package{
	import flash.display.MovieClip;
	
	public class ArtBoardLoad extends ArtBoardNew{
		public var preloader:MovieClip;
		
		public function ArtBoardLoad(stageW:Number, stageH:Number){
			super(stageW, stageH);
			this.addLoading();
		}
		
		public function addLoading(){
			preloader = new loading();
			preloader.x = boardWidth/2;
			preloader.y = boardHeight/2;
			this.addChild(preloader);
		}
		
		public function removeLoading(){
			if(preloader){
				this.removeChild(preloader);
				preloader = null;
			}
		}
		
		override public function removeAll(){
			super.removeAll();
			removeLoading();
		}
	}
}
