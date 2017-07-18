package{
	import flash.display.Sprite;
	
	public class ColorItemEmpty extends Sprite{
	
		public function ColorItemEmpty(){
			this.mouseEnabled = false;
			this.mouseChildren = false;
			this.width = ColorItem.COLOR_SIZE;
			this.height = ColorItem.COLOR_SIZE;
		}
	}
	
}
