package{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

		
	public class XmlColors extends EventDispatcher{
		public var loadingSet:Object;
		private var loader:URLLoader;
		private var colorsetsSettings:Array;
		public var colorsets:Object;
		public static const XML_READY:String = "xmlReadyEvent";
		
		public function XmlColors(){
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, loadCompleteHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
		public function loadAll(){
			colorsets = new Object();
			colorsetsSettings = Studio.rootStg.xmlConfig.getColorsets();
			loadingSet = colorsetsSettings.shift();
			this.loadXml(loadingSet.url);
		}
		
		public function loadXml(link:String){
			trace("XmlColors: loadXml "+link);
			loader.load(new URLRequest(link));
		}
		
		private function loadCompleteHandler(e:Event){
			trace("XmlConfig: xml loaded completed");
			var xml = new XML(e.target.data);
			xml.ignoreWhitespace = true;
			if(xml.children().length() == 0){
				trace("XmlLoader: xml is empty !");
			}
			else{
				loadingSet.xml = xml;
				colorsets[loadingSet.id] = loadingSet;
			}
			
			if(colorsetsSettings.length == 0){
				this.dispatchEvent(new Event(XML_READY, true));
			}
			else{
				loadingSet = colorsetsSettings.shift();
				this.loadXml(loadingSet.url);
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
		
		/*
		 * @return array - pole vzorniku pro dannou skupinu
		 */
		public function getColorsets(gid:String):Array{
			var sets:Array = new Array();
			for(var id:String in colorsets){
				if(colorsets[id].groupId == gid){
					sets.push(colorsets[id]);
				}
			}
			sets.sort(sortOnOrder);
			return sets;
		}
		
		/*
		 * @return Object - vzornik
		 */
		public function getColorset(id:String):Object{
			return colorsets[id];
		}
		
		/*
		 * return array - pole nazvu vzorniku pro dannou skupinu
		 NOT IN USE
		 */
		public function getColorsetsNames(gid:String){
			trace("XmlColors: getColorsetGroups");
			var sets:Array = new Array();
			for(var id:String in colorsets){
				if(colorsets[id].groupId == gid){
					sets.push(colorsets[id].xml.maintype.@name);
				}
			}
			return sets;
		}
		
		/*
		 * return String - id defaultniho vzorniku, oznaceneho v configu jako 'selected'
		 */
		public function getColorsetSelected(gid:String = null):String{
			var selId:String;
			for(var id:String in colorsets){
				if(gid == null && colorsets[id].selected == 1){
					selId = id;
					break;
				}
				else if(gid == colorsets[id].groupId && colorsets[id].selected == 1){
					selId = id;
					break;
				}
			}
			if(!selId && gid){
				var sets = this.getColorsets(gid);
				selId = sets[0].id;
			}
			else{
				for(var id:String in colorsets){
					selId = id;
					break;
				}
			}
			return selId;
		}
		
		/*
		 * return object - prvni barva v defaultnim vzorniku
		 NOT IN USE
		 */
		public function getInitColor(selSetId:String):Object{
			var colorsetSelected = this.getColorsetSelected();
			var xml:XML = colorsets[colorsetSelected].xml;
			
			var foundNode:XML = xml.maintype.type.color[0];
			for each(var node:XML in xml.maintype.type.color){
				if(node.@selected == 1){
					foundNode = node;
					break;
				}
			}
			var rgbcolor:Number = ((foundNode.definitions.@r << 16)& 0xff0000)  + ((foundNode.definitions.@g << 8)& 0x00ff00) + ((foundNode.definitions.@b)& 0xff);
			return {color:rgbcolor, setId:selSetId, label:foundNode.name};
		}
		
		/*
		 * @return Boolean - has more filter groups
		 */
		public function hasColorsetFilter(id:String){
			return Boolean(colorsets[id].xml.maintype.type.length() > 1);
		}
		
		/*
		 * @return Number
		 */
		private function sortOnOrder(a:Object, b:Object):Number{
       		return a.order > b.order ? 1 : -1;
		}
	}
}

