package{
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.net.FileReference;
	import adobe.PNGEncoder;
	
	public class ButtonOutput extends ButtonBase{

		public function ButtonOutput(){
			super();
		}
		
		override public function clickHandler(e:MouseEvent){
			var file:FileReference = new FileReference();
			var exportSprite = new ExportTemplate();
			var bmd:BitmapData = new BitmapData(exportSprite.width, exportSprite.height, true, 0x0);
			/*
			var matrix:Matrix = new Matrix();
			matrix.scale(2, 2);
			bmd.draw(exportSprite, matrix);
			*/
			bmd.draw(exportSprite);
			var byteArray:ByteArray = PNGEncoder.encode(bmd);
			file.save(byteArray, "Studio_export.png");
		}
		
	}
}

