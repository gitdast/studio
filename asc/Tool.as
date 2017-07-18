package{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	import flash.text.TextField;
	import flash.geom.ColorTransform;
	
	public class Tool extends ButtonRect {
		public var mc_slot_ico:MovieClip;
		public var toolLabel:TextField;
		public var isActive:Boolean = false;
		
		public function Tool(_name:String){
			trace("Tool: init..."+_name);
			this.name = _name;
			super();		
			
			this.addIcon();
		}
		
		private function addIcon(){
			var icoClassRef:Class = getDefinitionByName("ico_tool_"+name) as Class,
				ico = new icoClassRef();
			ico.scaleX = ico.scaleY = .6;
			this.mc_slot_ico.addChild(ico);
		}
		
		public function setActive(active:Boolean){
			this.isActive = active;
			if(active){
				this.gotoAndStop(3);
				this.mc_slot_ico.transform.colorTransform = COLOR_TRANS_WACTIVE;
			}else{
				this.gotoAndStop(1);
				this.mc_slot_ico.transform.colorTransform = COLOR_TRANS_NORMAL;
			}
		}
		
		override public function enable(){
			super.enable();
			this.mc_slot_ico.transform.colorTransform = COLOR_TRANS_NORMAL;
		}
		
		override public function disable(){
			this.setActive(false);
			super.disable();
			this.mc_slot_ico.transform.colorTransform = COLOR_TRANS_DISABLED2;			
		}
		
		override public function outHandler(e:MouseEvent){
			if(this.isActive){
				this.gotoAndStop(3);
				//this.mc_ico.transform.colorTransform = COLOR_TRANS_WACTIVE;
			}else{
				this.gotoAndStop(1);
				//this.mc_ico.transform.colorTransform = COLOR_TRANS_NORMAL;
			}
			
		}
		
		override public function clickHandler(e:MouseEvent){
			if(!isActive){
				Studio.rootStg.panelTools.changeToolHandler(this);
				this.setActive(!isActive);
				Studio.rootStg.artBoard.setMode(this.name);
			}
		}
	}
	
}
