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
		
	public class XmlConfig extends EventDispatcher{
		public var xml:XML;
		public var lang:String;
		public var configUrl:String;
		var loader:URLLoader;
		public static const XML_READY:String = "xmlReadyEvent";
		
		public function XmlConfig(){
			loader = new URLLoader();
			//loader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			loader.addEventListener(Event.COMPLETE, loadCompleteHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		public function loadXml(link:String){
			trace("XmlConfig: loadXml");
			if(link != null){
				configUrl = link;
			}else{
				configUrl = "config.xml";
			}
			loader.load(new URLRequest(configUrl));
		}

		/*** HANDLERS ***/
		
		function loadCompleteHandler(e:Event){
			trace("XmlConfig: xml loaded completed");
			xml = new XML(e.target.data);
			xml.ignoreWhitespace = true;
			//trace(xml.toString());
			if(xml.children().length() == 0){
				trace("XmlLoader: xml is empty !");
			}else{
				//var o:Object = new Object();
				for each(var node:XML in xml.*){
					//o[node.name()] = node;
					//trace(node.name()+": "+ node);
	            }
				
				this.lang = xml.application.lang;
				this.dispatchEvent(new Event(XML_READY, true));
			}
		}
		
		private function securityErrorHandler(e:SecurityErrorEvent){
			trace("securityErrorHandler: " + e);
			var error = true;
		}
		
		private function ioErrorHandler(e:IOErrorEvent){
			trace("ioErrorHandler: " + e);
			var error = true;
		}
		
		private function progressHandler(e:ProgressEvent){
			trace("XmlConfig: progressHandler:" + e);
		}
		
		/*** GETTERS ***/
		
		public function getLang():String{
			return this.lang;
		}
		
		public function getConfigResizable():Boolean{
			return Boolean(xml.application.isResizable == "true");
		}
		
		public function getConfigWidth():Number{
			return xml.application.width;
		}
		
		public function getConfigHeight():Number{
			return xml.application.height;
		}
		
		public function getDictUrl():String{
			return xml.application.dictionaryUrl;
		}
		
		public function getGetIdUrl():String{
			return xml.application.exportProjectGetIdUrl;
		}
		
		public function getSaveProjectXmlUrl():String{
			return xml.application.exportProjectXmlUrl;
		}
		
		public function getSaveProjectBitmapsUrl():String{
			return xml.application.exportProjectBitmapsUrl;
		}
		
		public function getLoadProjectXmlUrl():String{
			return xml.application.loadProjectXmlUrl;
		}
		
		public function getPreparedProjectsUrl():String{
			return xml.application.projectsUrl;
		}
		
		public function getHomepageImageUrl():String{
			return xml.application.homepageImageUrl;
		}
		
		public function getAutofillUrl():String{
			return xml.application.autofillProjectUrl;
		}
		
		public function getInfoUrl():String{
			return xml.application.infoUrl;
		}
		
		public function getAutofillWidth():int{
			return xml.application.autofillWidth;
		}
		
		public function getColorGroupsCount(){
			return xml.colors.group.length();
		}
		
		public function getColorGroupsInfo(){
			return xml.colors.group.@id;
		}
		
		public function getColorsets():Array{
			var colorsets:Array = new Array();
			var colset:Object;
			for each(var node:XML in xml.colors.group.colorset.(@display == "1")){
				colset = new Object();
				colset["id"] = node.@id;
				colset["order"] = node.@order;
				colset["groupId"] = node.parent().@id;
				colset["selected"] = node.@selected;
				colset["url"] = node;

				colorsets.push(colset);
            }
			return colorsets;
		}
	}
}