package{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.filters.DropShadowFilter;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.display.MovieClip;
	import flash.utils.getQualifiedClassName;
	
	public class PanelSlide extends Sprite{
		public var butt_close:MovieClip;
		public var labelText:String;
		public var labelField:TextField;
		public var header:Shape;
		public var gradient:Shape;
		
		public var panelWidth:Number;
		public var panelHeight:Number;
		public var customWidth:Boolean = false;
		public var customHeight:Boolean = false;
		private var posYinit:int;
		private var slideStep:Number;
		
		public var panelHeaderHeight:int = 70;
		
		public function PanelSlide(stageW:Number, stageH:Number, panelW:Number = 0, panelH:Number = 0){
			trace("PanelSlide: init");
			this.labelText = Studio.rootStg.xmlDictionary.getTranslate(this.name.substr(0,8) == "instance" ? getQualifiedClassName(this) : this.name);
			
			this.panelWidth = panelW ? panelW : stageW - Studio.PANEL_WIDTH - 2 * Studio.PANEL_PADDING;
			this.panelHeight = panelH ? panelH : stageH - 2 * Studio.PANEL_PADDING;
			this.customWidth = panelW > 0;
			this.customHeight = panelH > 0;
			
			this.visible = false;
			
			this.createBackground();
			this.addButtonClose();
		}
		
		public function slideDown(){
			trace("slideDown", this.height, this.panelHeight);
			this.posYinit = this.y;
			this.slideStep = this.height / 10;
			this.y = - this.height - 5;
			this.visible = true;
			this.addEventListener("enterFrame", doSlideDown);
		}
		
		private function doSlideDown(e:Event){
			this.y += this.slideStep;
			if(this.y >= posYinit){
				this.y = posYinit;
				this.removeEventListener("enterFrame", doSlideDown);
			}
		}
		
		public function slideUp(e:Event){
			this.slideStep = this.height / 10;
			this.addEventListener("enterFrame", doSlideUp);
		}
		
		protected function doSlideUp(e:Event){
			this.y -= this.slideStep;
			if(this.y < -this.height - 5){
				this.removeEventListener("enterFrame", doSlideUp);
				this.remove();
				this.parent.removeChild(this);
				this.publishPanelRemove();
			}
		}
		
		protected function publishPanelRemove(){
		}
		
		public function addButtonClose(){
			butt_close = new Button_close();
			butt_close.x = this.width - 10;
			butt_close.y = 10;
			butt_close.addEventListener("click", this.slideUp);
			butt_close.enable();
			this.addChild(butt_close);
		}
		
		protected function addLabel(){
			var format = Studio.rootStg.getTextFormatBold(16, "center", 0x8e8e8e);
			
			labelField = new TextField();
			labelField.width = this.width;
			labelField.height = panelHeaderHeight;
			labelField.autoSize = "center";
			labelField.selectable = false;
			labelField.text = this.labelText;
			labelField.setTextFormat(format);
			labelField.embedFonts = true;
			labelField.antiAliasType = "advanced";
			labelField.y -= Math.round(labelField.height / 2);
			
			this.addChild(labelField);
		}
		
		private function createBackground(){
			this.graphics.beginFill(0x333333, 0.9);
			this.graphics.drawRoundRect(0, 0, this.panelWidth, this.panelHeight, 16, 16);
			this.graphics.endFill();
			
			header = new Shape();
			header.graphics.beginFill(0x333333, 1);
			header.graphics.drawRoundRect(0, 0, this.panelWidth, panelHeaderHeight, 16, 16);
			header.graphics.endFill();
			this.addChild(header);
			
			var gradHeight:int = 45,
				matrix:Matrix = new Matrix();
				
			matrix.createGradientBox(this.width, gradHeight, Math.PI / 2, 0, 0);
			
			gradient = new Shape;
			gradient.y = panelHeaderHeight - gradHeight;
			gradient.graphics.beginGradientFill("linear", [0x333333, 0x000000], [0, 0.1], [0x00, 0xFF], matrix, "pad");
			gradient.graphics.drawRect(0, 0, this.panelWidth, gradHeight);
			gradient.graphics.endFill();
			
			this.addChild(gradient);
			
			var shadow:DropShadowFilter = new DropShadowFilter(2, 75, 0x000000, 0.5, 4, 4, 1, 1);
			this.filters = new Array(shadow);
		}
		
		public function resizeHandler(w:Number, h:Number, scrollRatio:Number = -1){
			if(!this.customWidth){
				this.panelWidth = w - Studio.PANEL_WIDTH - 2 * Studio.PANEL_PADDING;
			}
			if(!this.customHeight){
				this.panelHeight = h - 2 * Studio.PANEL_PADDING;
			}
			
			this.graphics.clear();
			this.graphics.beginFill(0x333333, 0.9);
			this.graphics.drawRoundRect(0, 0, this.panelWidth, this.panelHeight, 16, 16);
			this.graphics.endFill();
		}
		
		public function remove(){
			trace("panelSlide remove");
			butt_close.remove();
			butt_close.removeEventListener("click", this.slideUp);
			this.removeEventListener("enterFrame", doSlideUp);
			this.removeEventListener("enterFrame", doSlideDown);
		}
	}
	
}
