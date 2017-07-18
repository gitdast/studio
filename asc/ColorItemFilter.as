package{
	import flash.events.MouseEvent;
	
	public class ColorItemFilter extends ColorItem{
		public var toneIndex:int;
		
		public function ColorItemFilter(index:int, _name:String, r:Number, g:Number, b:Number){
			this.displayLabel = false;
			super(_name, r, g, b);
			this.toneIndex = index;
		}

		public function setActive(active:Boolean){
			
		}
		
		override public function clickHandler(e:MouseEvent){
			Studio.rootStg.panelColors.sampler.setTone(toneIndex);
		}
	}
	
}
