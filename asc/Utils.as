package{
	import flash.geom.Rectangle;
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	public class Utils{
		private static var r_lum:Number = 0.212671;
		private static var g_lum:Number = 0.715160;
		private static var b_lum:Number = 0.072169;
		
		private static var IDENTITY:Array = [1,0,0,0,0,
											 0,1,0,0,0,
											 0,0,1,0,0,
											 0,0,0,1,0];

		public static function colorize(rgb:Number, amount:Number = 1):Array{
			var r:Number = ( ( rgb >> 16 ) & 0xff ) / 255;
			var g:Number = ( ( rgb >> 8  ) & 0xff ) / 255;
			var b:Number = (   rgb         & 0xff ) / 255;
		
			var inv_amount:Number = 1 - amount;
		
			var mat:Array = new Array(inv_amount + amount*r*r_lum, amount*r*g_lum,  amount*r*b_lum, 0, 0,
						  			 amount*g*r_lum, inv_amount + amount*g*g_lum, amount*g*b_lum, 0, 0,
					   				 amount*b*r_lum,amount*b*g_lum, inv_amount + amount*b*b_lum, 0, 0,
					    			 0 , 0 , 0 , 1, 0);
			return concat(mat);
		}
		
		public static function concat(mat:Array):Array{
			var temp:Array = new Array();
			var i:Number = 0;
			var matrix = IDENTITY.concat();
		
			for(var y:Number = 0; y < 4; y++ ){
				for(var x:Number = 0; x < 5; x++ ){
					temp[i + x] = mat[i] * matrix[x] + 
								mat[i+1] * matrix[x +  5] + 
								mat[i+2] * matrix[x + 10] + 
								mat[i+3] * matrix[x + 15] +
								(x == 4 ? mat[i+4] : 0);
				}
				i+=5;
			}
			return temp;
		}
		
		public static function floodFill(bd:BitmapData, xm:uint, ym:uint, ptolerance:uint=0):BitmapData{
			//* Validates the tolerance *//
			var tolerance = Math.max(0, Math.min(255, ptolerance));
			
			var targetColor:uint = bd.getPixel32(xm, ym);
			var w:uint = bd.width;
			var h:uint = bd.height;
			var temp_bd:BitmapData = new BitmapData(w, h, true, 0x00);
				
			//* fills similar pixels with gray *//
			temp_bd.lock();
			for(var i:uint=0; i<w; i++){
				for(var k:uint=0; k<h; k++){
					var d:int = getColorDifference32(targetColor, bd.getPixel32(i, k));
					if(d <= tolerance){
						temp_bd.setPixel32(i, k, 0xFF666666);
					}
				}
			}
			temp_bd.unlock();
				
			//* fills the target area with black *//
			temp_bd.floodFill(xm, ym, 0xFF000000);
				
			//* use threshold() to get the white pixels only *//
			var rect:Rectangle = new Rectangle(0, 0, w, h);
			var pnt:Point = new Point(0, 0);
			temp_bd.threshold(temp_bd, rect, pnt, ">", 0xFF333333, 0x00FFFFFF);
			
			return temp_bd;
		}
		
		public static function getColorDifference32(c1:uint, c2:uint):int{
			var a1:int = (c1 & 0xFF000000) >>> 24;
			var r1:int = (c1 & 0x00FF0000) >>> 16;
			var g1:int = (c1 & 0x0000FF00) >>> 8;
			var b1:int = (c1 & 0x0000FF);
			
			var a2:int = (c2 & 0xFF000000) >>> 24;
			var r2:int = (c2 & 0x00FF0000) >>> 16;
			var g2:int = (c2 & 0x0000FF00) >>> 8;
			var b2:int = (c2 & 0x0000FF);
			
			var a:int = Math.pow((a1-a2), 2);
			var r:int = Math.pow((r1-r2), 2);
			var g:int = Math.pow((g1-g2), 2);
			var b:int = Math.pow((b1-b2), 2);
			
			var d:int = Math.sqrt(a + r + g + b);
			
			// Adjusts the range to 0-255.
			d = Math.floor(d / 510 * 255);
			return d;
		}

	}
}
