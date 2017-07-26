package{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	
	public class ColorItemSampler extends ColorItem{
		public var colorData:Object;
		
		private const COLOR_TRANS_NORMAL = new ColorTransform();
		private const COLOR_TRANS_OVER = new ColorTransform(0,0,0,1,255,255,204,1);
		
		public function ColorItemSampler(setId:String, _name:String, r:Number, g:Number, b:Number){
			super(_name, r, g, b);
			colorData = new Object();
			colorData.color = colorInstance.color;
			colorData.setId = setId;
			colorData.label = _name;
			
			this.enable();
		}

		public function setActive(active:Boolean){
		}
		
		override public function clickHandler(e:MouseEvent){
			if(Studio.rootStg.panelWalls.wallsControl){
				Studio.rootStg.panelWalls.wallsControl.changeColor(this.colorData);
			}
		}
		
	}
	
}
