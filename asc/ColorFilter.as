package{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
	
	public class ColorFilter extends Sprite{
		public var colorset:Object;
		public var labelField:TextField;
		
		private var controlWidth:int;
		
		public function ColorFilter(colorset:Object, id:String, w:int){
			trace("ColorFilter: init...");
			this.controlWidth = w;
			this.colorset = colorset;
			
			this.addLabel();
			this.createColorItems();
		}
		
		public function createColorItems():int{
			var counter:int = 0;
			var yPos:int = 40;
			var xPos = ColorItem.COLOR_SIZE / 2 + 2;
			var colorItem:ColorItemFilter;
			var xml:XML = colorset.xml;
			var colMax:int = Math.floor(controlWidth / ColorItem.COLOR_SIZE);
			var node:XML;
			
			for each(var typenode:XML in xml.maintype.type){
				if(typenode.hasOwnProperty("color")){
					node = typenode.color[0];
					colorItem = new ColorItemFilter(counter, node.name, node.definitions.@r, node.definitions.@g, node.definitions.@b);
					colorItem.x = xPos + Math.floor(counter % colMax) * ColorItem.COLOR_SIZE;
					colorItem.y = yPos + Math.floor(counter / colMax) * ColorItem.COLOR_SIZE;
					this.addChild(colorItem);
					counter++;
				}
			}
			return Math.ceil(counter/colMax);
		}
		
		public function removeColorItems(){
			var child;
			for(var i:int = this.numChildren - 1; i > 0; i--){
				child = this.getChildAt(i);
				if(getQualifiedClassName(child) == "ColorItemFilter"){
					child.remove();
					this.removeChild(child);
				}
			}
		}
		
		private function addLabel(){
			var format = Studio.rootStg.getTextFormat2(10, "center", 0xCCCCCC);
			
			labelField = new TextField();
			labelField.autoSize = "left";
			labelField.selectable = false;
			labelField.text = Studio.rootStg.xmlDictionary.getTranslate("colorFilterLabel");
			labelField.setTextFormat(format);
			labelField.embedFonts = true;
			labelField.antiAliasType = "advanced";

			this.addChild(labelField);
		}
		
		public function resizeHandler(w:Number){
			this.controlWidth = w;
		}
		
		public function remove(){
			this.removeColorItems();
		}
		
	}
}

