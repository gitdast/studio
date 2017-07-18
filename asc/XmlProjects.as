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
		
	public class XmlProjects extends EventDispatcher{
		public var xml:XML;
		private var loader:URLLoader;
		public var colorsets:Array;
		public static const XML_READY:String = "xmlReadyEvent";
		
		public function XmlProjects(){
			loader = new URLLoader();
			//loader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			loader.addEventListener(Event.COMPLETE, loadCompleteHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		public function loadXml(link:String){
			//trace("XmlProjects: loadXml "+link);
			loader.load(new URLRequest(link));
		}

		/*** HANDLERS ***/
		
		function loadCompleteHandler(e:Event){
			//trace("XmlProjects: xml load completed");
			xml = new XML(e.target.data);
			xml.ignoreWhitespace = true;
			//trace(xml.toString());
			if(xml.children().length() == 0){
				trace("XmlProjects: xml is empty !");
			}else{
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
						//trace(o["name"]);
					}
				}
				
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
			trace("XmlConfig: progressHandler:" + e);
		}
		
		
		private function sortOnOrder(a:Object, b:Object):Number{
			if(a.order > b.order){
        		return 1;
    		}else{
				return -1;
			}
		}
		
		public function getColorsetSelected():Number{
			var found:int = -1;
			for(var i:int=0; i<colorsets.length; i++){
				if(colorsets[i].selected == 1){
					found = i;
					break;
				}
			}
			return found;
		}
		
		public function isFilterForSelected(sel:int):Boolean{
			return Boolean(colorsets[sel].xml.maintype.type.length() > 1);
		}
	}
}

