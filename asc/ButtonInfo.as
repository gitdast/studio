package{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	public class ButtonInfo extends ButtonBase{
		public var mc_ico:MovieClip;
		
		public function ButtonInfo(){
			super();
			this.y = 6;
		}
		
		override public function clickHandler(e:MouseEvent){
			var infoUrl = Studio.rootStg.xmlConfig.getInfoUrl();
			navigateToURL(new URLRequest(infoUrl), "_blank");
		}

	}
}
