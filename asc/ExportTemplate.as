package{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	
	public class ExportTemplate extends Sprite{
		public var mc_logo:MovieClip;
		public var slot_artwork:Sprite;
		public var dt_title:TextField;
		public var dt_subtitle:TextField;
		public var infoLabel:TextField;

		public var finalColorY:Number = 0;
		
		public const IMAGE_EXPORT_WIDTH:int = 979;
		
		public function ExportTemplate(){
			
			this.createTemplate();
			this.addBackground();
		}
		
		public function createTemplate(){
			/* add title and subtitle(pr.number) */
			var title = Studio.rootStg.xmlDictionary.getTranslate("printTitle");
			var subtitle = Studio.rootStg.xmlDictionary.getTranslate("printSubtitle");
			dt_title.htmlText = title;
			dt_subtitle.y = dt_title.y + dt_title.textHeight + 10;
			dt_subtitle.htmlText = subtitle + (Studio.rootStg.project.sessionId != null ? Studio.rootStg.project.sessionId : "–");
			
			/* add project bitmap */
			var artwork = Studio.rootStg.artBoard.projectMc;
			var scale = IMAGE_EXPORT_WIDTH / artwork.width;
			var bmd:BitmapData = new BitmapData(IMAGE_EXPORT_WIDTH, artwork.height*scale);
			var matrix:Matrix = new Matrix();
			matrix.scale(artwork.scaleX*scale, artwork.scaleX*scale);
			bmd.draw(artwork, matrix);
			var image:Bitmap = new Bitmap(bmd, 'auto', true);
			slot_artwork.addChild(image);

			/* add colors used on walls*/
			var colorY = slot_artwork.y + image.height + 20;
			var colorX1 = 38;
			var colorX2 = 326

			var wc = Studio.rootStg.panelWalls.wallsControl;
			var wall:WallsControlItem;
			var wLabel, cLabel, cSetid, cSet, cValue, r, g, b;
			var item;
			var row = 0;
			
			for(var i:int=0; i<wc.numChildren; i++){
				wall = wc.getChildAt(i);
				wLabel = wall.labelWall.text;
				item = new printColorSprite as Sprite;
				if(wall.colorData.label == undefined){
					cLabel = "  -  ";
					item.mc_coloritem.gotoAndStop(2);
				}else{
					cLabel = wall.colorData.label;
					//cSetid = wall.colorData.setId;
					cValue = wall.colorData.color;
					r = ( ( wall.colorData.color >> 16 ) & 0xff );
					g = ( ( wall.colorData.color >> 8  ) & 0xff );
					b = (   wall.colorData.color         & 0xff );
					item.mc_coloritem.transform.colorTransform = new ColorTransform(0,0,0,1,r,g,b,255);
				}
				item.dt_wall.text = wLabel;
				item.dt_color.text = cLabel;
				item.x = i%2==0 ? colorX1 : colorX2;
				item.y = colorY + row*42;
				trace("item.y = "+item.y);
				
				this.addChild(item);
				row = (i%2==0) ? row : row+1;
				this.finalColorY = item.y;
			}

			/* add footer text */
			infoLabel = new TextField();
			infoLabel.autoSize = "left";
			infoLabel.multiline = true;
			infoLabel.wordWrap = true;
			infoLabel.width = 555;
			infoLabel.htmlText = Studio.rootStg.xmlDictionary.getTranslate("printFooterText");
			infoLabel.x = 15;
			infoLabel.y = this.finalColorY + 60;
			this.addChild(infoLabel);
			Studio.rootStg.addTextFormat(infoLabel, 14, 0x000000);
		}
		
		private function addBackground(){
			this.graphics.beginFill(0xffffff, 1);
			this.graphics.drawRect(0, 0, this.width, this.height + 15);
			this.graphics.endFill();
		}
		
	}
}
