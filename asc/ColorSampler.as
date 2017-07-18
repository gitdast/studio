package{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
	import flash.display.Shape;
	
	public class ColorSampler extends Sprite{
		public var labelField:TextField;
		public var colorset:Object;
		public var activeTone:int;
		public var bottomMargin:Shape;
		public var topMargin:Shape;
		
		private var controlWidth:int;
			
		public function ColorSampler(colorset:Object, id:String, w:int){
			trace("ColorSampler: init...");
			this.controlWidth = w;
			this.colorset = colorset;
			
			this.createColorItems(0);
		}
		
		public function setTone(toneNum:int){
			this.removeColorItems();
			this.createColorItems(toneNum);
			Studio.rootStg.panelColors.resizeHandler(Studio.rootStg.appWidth, Studio.rootStg.appHeight, 0);
		}
		
		/**
		 * @note - v het verzi jeste byla funkce validateToneNum kvuli "kvuli tem prazdnym skupinam barev" a taky trida ColorItemEmpty() pro vlozeni prazdneho policka,
		 * pravdepodobne na zacatek, kvuli zarovnani. zde to neni, zatim neni potreba. pripadne zisat z puvodniho kodu
		 */
		public function createColorItems(toneNum:int = 0){
			this.activeTone = toneNum;
			
			var colorItem,
				xml:XML = this.colorset.xml,
				colMax:int = Math.min(xml.maintype.@cols, 7),
				counter:int = 0,
				hoverMargin:Number = ColorItem.COLOR_SIZE * (ColorItem.COLOR_SCALE_HOVER - 1); //* for scaling items on hover to fit to scrollmask
			
			topMargin = new Shape();
			topMargin.graphics.drawRect(0, 0, 1, hoverMargin);
			this.addChild(topMargin);
			
			var yPos:Number = ColorItem.COLOR_SIZE / 2 + topMargin.height,
				xPos:Number = ColorItem.COLOR_SIZE / 2 + 2;
			
			for each(var node:XML in xml.maintype.type[toneNum].color){
				if(node.@type == "empty"){
					colorItem = new ColorItemEmpty();
				}
				else{
					colorItem = new ColorItemSampler(colorset.id, node.name, node.definitions.@r, node.definitions.@g, node.definitions.@b);
				}
				colorItem.x = xPos + Math.floor(counter % colMax) * ColorItem.COLOR_SIZE;
				colorItem.y = yPos + Math.floor(counter / colMax) * ColorItem.COLOR_SIZE;
				this.addChild(colorItem);
				counter++;
			}

			bottomMargin = new Shape();
			bottomMargin.graphics.drawRect(0, colorItem.y + colorItem.height / 2, 1, hoverMargin);
			this.addChild(bottomMargin);
		}
		
		public function removeColorItems(){
			var child;
			for(var i:int = this.numChildren - 1; i > 0; i--){
				child = this.getChildAt(i);
				if(getQualifiedClassName(child) == "ColorItemSampler"){
					child.remove();
					this.removeChild(child);
				}
				else if(child == bottomMargin || child == topMargin){
					this.removeChild(child);
				}
			}
		}
		
		public function resizeHandler(w:Number){
			this.controlWidth = w;
		}
		
		public function remove(){
			this.removeColorItems();
		}
		
	}
}

