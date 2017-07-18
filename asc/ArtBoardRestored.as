package{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	
	public class ArtBoardRestored extends ArtBoardNew{
		
		public function ArtBoardRestored(stageW:Number, stageH:Number){
			super(stageW, stageH);
		}
		
		public function addRestoredProject(foto:Bitmap){
			this.projectMc = new Artwork();
			this.addChild(projectMc);
			projectMc.addFoto(foto);
			
			this.doubleClickEnabled = true;
			projectMc.doubleClickEnabled = true;
			projectMc.mouseChildren = false;
			
			projWidth = foto.width;
			projHeight = foto.height;

			this.resizeProjectMc();
			
			drawLayer = new Sprite();
			drawLayer.mouseEnabled = false;
			this.addChild(drawLayer);
			drawShowLayer = new Sprite();
			drawShowLayer.mouseEnabled = false;
			this.addChild(drawShowLayer);
			
			this.createCursor();
		}

	}
}
