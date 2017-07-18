package{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	//import flash.system.Security;
		
	public class XmlDictionary extends EventDispatcher{
		public var xml:XML;
		public var lang:String;
		public var dictUrl:String;
		var loader:URLLoader;
		public static const XML_READY:String = "xmlReadyEvent";
		
		public function XmlDictionary(){
			this.lang = Studio.rootStg.xmlConfig.getLang();
			
			loader = new URLLoader();
			loader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			loader.addEventListener(Event.COMPLETE, loadCompleteHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		public function loadXml(link:String){
			trace("XmlDictionary: loadXml");
			if(link != null){
				dictUrl = link;
			}else{
				dictUrl = "dictionary.xml";
			}
			loader.load(new URLRequest(dictUrl));
		}
		

		/*** HANDLERS ***/
		
		function loadCompleteHandler(e:Event){
			trace("XmlDictionary: xml loaded completed");
			xml = new XML(e.target.data);
			xml.ignoreWhitespace = true;
			//trace(xml.toString());
			if(xml.children().length() == 0){
				trace("XmlDictionary: xml is empty !");
			}else{
				this.dispatchEvent(new Event(XML_READY, true));
			}
		}
		
		private function securityErrorHandler(e:SecurityErrorEvent){
			trace("securityErrorHandler: " + e);
			var error = true;
			//Graphs_RC.rootStg.dt_error.text = event.text;
		}
		
		private function ioErrorHandler(e:IOErrorEvent){
			trace("ioErrorHandler: " + e);
			var error = true;
			//Studio.rootStg.configNotReady();
			//Graphs_RC.rootStg.dt_error.text = event.text;
		}
		
		private function progressHandler(e:ProgressEvent){
			trace("XmlDictionary: progressHandler:" + e);
		}
		
		/*** GETTERS ***/
		
		public function getTranslate(key:String):String{
			return xml.item.(@key == key).translate.(@lang == lang);
		}
		
	}
}

