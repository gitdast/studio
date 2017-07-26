package{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
		
	public class XmlProjects extends EventDispatcher{
		public var xml:XML;
		private var loader:URLLoader;

		public static const XML_READY:String = "xmlReadyEvent";
		
		public function XmlProjects(){
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, loadCompleteHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		public function loadXml(link:String){
			loader.load(new URLRequest(link));
		}

		/*** HANDLERS ***/
		
		function loadCompleteHandler(e:Event){
			xml = new XML(e.target.data);
			xml.ignoreWhitespace = true;
			if(xml.children().length() == 0){
				trace("XmlProjects: xml is empty !");
			}
			else{
				var categories:Array = new Array();
				var category:Array;
				var o:Object;
				var elems:Array;
				for each(var categoryNode:XML in xml.category){
					category = new Array();
					for each(var node:XML in categoryNode.project){
						o = new Object();
						elems = new Array(); 
						o["thumb"] = node.url_img;
						o["link"] = node.url_clip;
						o["name"] = node.name;
						for each(var el:XML in node.elements.el_wall){
							elems.push(el);
						}
						o["elements"] = elems;
					}
				}
				
				this.dispatchEvent(new Event(XML_READY, true));
			}
		}
		
		private function securityErrorHandler(e:SecurityErrorEvent){
			trace("securityErrorHandler: " + e);
		}
		
		private function ioErrorHandler(e:IOErrorEvent){
			trace("ioErrorHandler: " + e);
		}
		
		private function progressHandler(e:ProgressEvent){
			trace("XmlConfig: progressHandler:" + e);
		}
		
		private function sortOnOrder(a:Object, b:Object):Boolean{
			return a.order > b.order;
		}		
	}
}

