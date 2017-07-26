package{
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.filters.DropShadowFilter;
	import fl.controls.ComboBox;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class PanelColors extends PanelSlide{
		public var xmlColors:XmlColors;
		public var colorsetsMenu:ColorsetsMenu;
		public var filter:ColorFilter;
		public var filterActive:Boolean;
		public var sampler:ColorSampler;
		public var labelSampler:TextField;
		public var scrollBar:ScrollBarVertical;

		public function PanelColors(stageW:Number, stageH:Number, panelW:Number = 0, panelH:Number = 0){
			trace("PanelColors: init");
			super(stageW, stageH, panelW, panelH);

			this.x = Studio.PANEL_WIDTH + Studio.PANEL_PADDING;
			this.y = Studio.PANEL_PADDING;
			
			xmlColors = new XmlColors();
			xmlColors.addEventListener(XmlColors.XML_READY, this.colorsXmlReady);
			xmlColors.loadAll();
		}
		
		private function colorsXmlReady(e:Event){
			trace("PanelColors: colorsXmlReady...");
			
			this.createColorsetsMenu();

			var selectedSet:String = xmlColors.getColorsetSelected();
			this.changeColorset(selectedSet);
			this.colorsetsMenu.switchButtons(selectedSet);
			
			this.slideDown();
			
			this.addDragDrop();
		}
		
		public function createColorsetsMenu(){
			this.colorsetsMenu = new ColorsetsMenu(this.panelWidth - Studio.PANEL_PADDING);
			this.colorsetsMenu.x = Studio.PANEL_PADDING;
			this.addChild(colorsetsMenu);
			
			this.header.height = colorsetsMenu.height + 2 * Studio.PANEL_PADDING;
			this.gradient.y = this.header.height - gradient.height;
		}
		
		public function changeColorset(id:String){
			this.filterActive = xmlColors.hasColorsetFilter(id);
			
			Studio.rootStg.panelColors.createFilter(id);
			Studio.rootStg.panelColors.createSampler(id);
		}
		
		public function createFilter(id:String){
			if(filter){
				filter.remove();
				this.removeChild(filter);
				filter = null;
			}
			
			if(!this.filterActive){
				return;
			}
			
			filter = new ColorFilter(xmlColors.getColorset(id), id, this.panelWidth - 2 * Studio.PANEL_PADDING);
			filter.x = Studio.PANEL_PADDING;
			filter.y = this.header.height + Studio.PANEL_PADDING;
			this.addChild(filter);			
		}
		
		public function createSampler(id:String){
			if(scrollBar){
				scrollBar.remove();
				this.removeChild(scrollBar);
				scrollBar = null;
			}
			if(sampler){
				sampler.remove();
				this.removeChild(sampler);
				sampler = null;
				this.removeChild(labelSampler);
			}			
			
			var posY = this.filterActive ? filter.y + filter.height + Studio.PANEL_PADDING : this.header.height + Studio.PANEL_PADDING,
				conWidth = this.panelWidth - 2 * Studio.PANEL_PADDING;
				
			this.addLabelSampler(posY);
			posY += 20;
				
			sampler = new ColorSampler(xmlColors.getColorset(id), id, conWidth);
			sampler.x = Studio.PANEL_PADDING;
			sampler.y = posY;
			this.addChild(sampler);
			
			scrollBar = new ScrollBarVertical(sampler, this.panelWidth, this.panelHeight - Studio.PANEL_PADDING - sampler.y);
			scrollBar.x = this.panelWidth - Studio.PANEL_PADDING;
			scrollBar.y = posY;
			this.addChild(scrollBar);
		}
		
		private function addLabelSampler(posY:int){
			var format = Studio.rootStg.getTextFormat2(10, "center", 0xCCCCCC);
			
			labelSampler = new TextField();
			labelSampler.autoSize = "left";
			labelSampler.selectable = false;
			labelSampler.text = Studio.rootStg.xmlDictionary.getTranslate("colorSamplerLabel");
			labelSampler.setTextFormat(format);
			labelSampler.embedFonts = true;
			labelSampler.antiAliasType = "advanced";
			labelSampler.x = Studio.PANEL_PADDING;
			labelSampler.y = posY;

			this.addChild(labelSampler);
		}
		
		override protected function publishPanelRemoved(){
			Studio.rootStg.panelColors = null;
		}
		
		override public function resizeHandler(w:Number, h:Number, scrollRatio:Number = -1){
			super.resizeHandler(w, h);
			if(this.filter){
				filter.resizeHandler(this.panelWidth - 2 * Studio.PANEL_PADDING);
			}
			if(this.sampler){
				sampler.resizeHandler(this.panelWidth - 2 * Studio.PANEL_PADDING);
			}
			if(this.scrollBar){
				this.scrollBar.resizeHandler(this.panelWidth, this.panelHeight - Studio.PANEL_PADDING - sampler.y, scrollRatio);
			}
		}
		
		override public function remove(){
			super.remove();
			if(filter){
				filter.remove();
			}
			if(sampler){
				sampler.remove();
			}
			if(scrollBar){
				scrollBar.remove();
			}
		}
	}
	
}
