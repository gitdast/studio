package{
	import flash.display.MovieClip;
	
	public class Window extends MovieClip{
		public var mc_panel;
		public var mc_toggle;
		public var mc_border;
		public var slot_content;
		
		public function Window(){
			
		}
		
		public function setWidth(w:Number){
			mc_border.width = w;
			mc_panel.mc_rec.width = w;
			mc_panel.mc_bevel.width = w-2;
			mc_panel.mc_bevel.x = 1;
			mc_toggle.x = w;
		}
		
		public function getWidth():Number{
			return this.width;
		}
		
		public function setHeight(h:Number){
			mc_border.height = h;
		}
		
		public function getHeight():Number{
			return this.height;
		}
	}
	
}
