package{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
	import flash.display.Sprite;
	
	public class ColorsetsMenu extends MovieClip{
		public var activeId:String;
		public var headlines:Array = new Array();
		
		private var controlWidth:Number;
		
		public function ColorsetsMenu(w:Number){
			this.controlWidth = w;
			this.createGroups();

			//this.setActive(this.getChildAt(1) as MovieClip);
		}
		
		private function createGroups(){
			var colorGroups = Studio.rootStg.xmlConfig.getColorGroupsInfo(),			
				labelGroup:TextField,
				groupWidth:Number = this.controlWidth / colorGroups.length() - Studio.PANEL_PADDING;
				
			for(var i = 0; i < colorGroups.length(); i++){
				labelGroup = new TextField();
				labelGroup.autoSize = "center";
				labelGroup.mouseEnabled = false;
				labelGroup.cacheAsBitmap = true;
				labelGroup.selectable = false;
				labelGroup.text = Studio.rootStg.xmlDictionary.getTranslate(colorGroups[i]);
				labelGroup.setTextFormat(Studio.rootStg.getTextFormatBold(15, "center", 0x8e8e8e));
				labelGroup.embedFonts = true;
				labelGroup.antiAliasType = "advanced";
				labelGroup.y = 30;
				labelGroup.x = i * (this.controlWidth / colorGroups.length());
				
				this.addChild(labelGroup);
				
				this.addColorsets(labelGroup.x, groupWidth, colorGroups[i]);
			}
		}
		
		private function addColorsets(xPos:Number, w:Number, groupId:String){
			var butt:ButtonColorset,
				sets:Object = Studio.rootStg.panelColors.xmlColors.getColorsets(groupId);
			
			for(var i = 0; i < sets.length; i++){
				butt = new ButtonColorset(w, groupId, sets[i].id, sets[i].xml.maintype.@name);
				butt.x = xPos;
				butt.y = 70 + i * (ButtonColorset.BUTT_HEIGHT + 10);
				this.addChild(butt);
			}
		}
		
		public function switchButtons(id:String){
			if(this.activeId){
				var butt:ButtonColorset = getChildByName("colorset_" + activeId) as ButtonColorset;
				butt.setActive(false);
			}

			this.activeId = id;
			
			butt = getChildByName("colorset_" + activeId) as ButtonColorset;
			butt.setActive(true);
			
			Studio.rootStg.panelColors.changeColorset(id);
		}
		
	}
	
}
