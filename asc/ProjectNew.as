package{
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.utils.ByteArray;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import adobe.PNGEncoder;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLVariables;
	import flash.geom.Matrix;
	
	public class ProjectNew extends Project{
		
		public function ProjectNew(prObject:Object = null){
			trace("ProjectNew: init...");
			super();
			this.prData = prObject;
		}
		
	//*** open new image ***//
	
		public function loadImg(byteData){
			loader = new Loader;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imgLoaded);
			loader.loadBytes(byteData);
			
			Studio.rootStg.addLoading();
		}
		
		private function imgLoaded(e:Event){
			trace("Project: image loaded");
			Studio.rootStg.removeLoading();
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imgLoaded);
			
			Studio.rootStg.panelMain.enable(true);
			Studio.rootStg.panelSave.enable(true);
			Studio.rootStg.panelTools.enable();
			var wc = Studio.rootStg.panelWalls.addWallsControl("active");
			wc.addFirstWall();
			
			this.artBoard = Studio.rootStg.createArtBoard("new");
			this.artBoard.addNewProject(loader);
			this.artBoard.wallsControl = wc;
		}
		
	//*** save temp ***//
	
		public function getTempData():Object{
			var mc = artBoard.projectMc,
				matrix:Matrix = new Matrix(),
				scaleH:Number = 100 / mc.height * mc.scaleY,
				thumbBmd:BitmapData = new BitmapData(mc.width / mc.scaleY * scaleH, ProjectThumbnailCategoryTemp.THUMB_HEIGHT, true, 0);
           	matrix.scale(scaleH, scaleH);
			thumbBmd.draw(mc, matrix);
			
			var tempData:Object = new Object();
			tempData.prId = this.getSomeId();
			tempData.type = "new";
			tempData.xml = this.generateXml(tempData.prId);
			tempData.fotoBmd = mc.foto.bitmapData;
			tempData.masks = new Object();
			tempData.thumb = new Bitmap(thumbBmd, "auto", true);
			
			var wall_filename:String;
			var wall_index:int;
			var layer:Sprite;
			var maskB:Bitmap;
			for each(var wall:XML in tempData.xml.elements.el_wall){
				wall_filename = wall.wall_mask.toString();
				wall_index = wall.childIndex();
				if(mc.layers.numChildren <= wall_index){
					//* prazdne vrstvy na konci seznamu se neuploaduji, ale zaznamenaji jako prazdne *//
					tempData.xml = this.updateXmlNode(tempData.xml, wall_index);
				}else{
					layer = mc.layers.getChildAt(wall_index);
					maskB = layer.getChildAt(1) as Bitmap;
					tempData.masks[wall_filename] = maskB.bitmapData;
				}
			}
			return tempData;
		}
		
	//*** save permanently ***//

		public function save(){
			if(!this.sessionId){
				this.createSessionId();
			}
			
			this.prData = new Object();
			this.prData.xml = this.generateXml(this.sessionId);
			this.prData.bmpToSend = 1;
			
			this.uploadBitmap(this.sessionId + ".png", artBoard.projectMc.foto.bitmapData);
			
			var wall_filename:String;
			var wall_index:int;
			var layer:Sprite;
			var maskB:Bitmap;
			for each(var wall:XML in prData.xml.elements.el_wall){
				wall_filename = wall.wall_mask.toString();
				//wall_filename = wall_filename.substr(0, wall_filename.length-4);
				wall_index = wall.childIndex();
				if(artBoard.projectMc.layers.numChildren <= wall_index){
					//* prazdne vrstvy na konci seznamu se neuploaduji, ale zaznamenaji jako prazdne *//
					prData.xml = this.updateXmlNode(prData.xml, wall_index);
				}else{
					layer = artBoard.projectMc.layers.getChildAt(wall_index);
					maskB = layer.getChildAt(1) as Bitmap;
					this.prData.bmpToSend++;
					this.uploadBitmap(wall_filename, maskB.bitmapData);
				}
			}
		}
		
		public function uploadBitmap(fname:String, bmd:BitmapData){
			trace("uploadBitmap: ", fname);
			var url:String = Studio.rootStg.xmlConfig.getSaveProjectBitmapsUrl();
        	var byteArray:ByteArray = PNGEncoder.encode(bmd);
        	var req:URLRequest = new URLRequest(url + "?name=" + fname);
			req.requestHeaders.push(new URLRequestHeader('Cache-Control', 'no-cache'));
        	req.contentType = "application/octet-stream";
        	req.method = "post";
        	req.data = byteArray;
			
        	urlLoader = new URLLoader();			
			urlLoader.dataFormat = "binary";
			urlLoader.addEventListener(Event.COMPLETE, uploadBitmapComplete);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, uploadBitmapError);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, uploadBitmapError);
        	urlLoader.load(req);
    	}
		
		private function uploadBitmapComplete(e:Event){
			trace("Project: uploadBitmapComplete - ", prData.bmpToSend);
			this.prData.bmpToSend--;
			
			if(prData.bmpToSend == 0){
				this.ulpoadXml(prData.xml);
				
				if(Studio.rootStg.panelInfo){
					Studio.rootStg.panelInfo.signalProjectBitmapsSaved(sessionId);
				}
			}
		}
		
		private function uploadBitmapError(e:Event){
			if(Studio.rootStg.panelInfo){
				Studio.rootStg.panelInfo.signalProjectSaveErrorMessage("Upload error");
			}
		}
		
		private function ulpoadXml(xml:XML){
			urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, uploadXmlComplete);
			urlLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
			
			var url:String = Studio.rootStg.xmlConfig.getSaveProjectXmlUrl();
			var req:URLRequest = new URLRequest(url + "?id=" + sessionId + "&email=" + Studio.rootStg.sessionEmail); 
			req.requestHeaders.push(new URLRequestHeader('Cache-Control', 'no-cache'));
			req.contentType = "text/xml"; 
			req.data = xml.toXMLString(); 
			req.method = "post"; 
			
			try{ 
    			urlLoader.load(req); 
			}
			catch(error){ 
    			trace("An ---Error has occurred.");
				Studio.rootStg.panelInfo.signalProjectSaveError(0);
			}
		}
		
		private function uploadXmlComplete(e:Event){
			trace("uploadXmlComplete", urlLoader.data);
			urlLoader.removeEventListener(Event.COMPLETE, uploadXmlComplete);
			
			if(urlLoader.data.status == "OK"){
				this.projectSaved = true;
				if(Studio.rootStg.panelInfo){
					Studio.rootStg.panelInfo.signalProjectSaved(sessionId);
				}
			}
			else if(Studio.rootStg.panelInfo){
				var errId = (urlLoader.data.errorId) ? urlLoader.data.errorId : 0;
				Studio.rootStg.panelInfo.signalProjectSaveError(errId);
			}
		}
		
		private function generateXml(pId:String):XML{
			var wc = Studio.rootStg.panelWalls.wallsControl,
				wall:WallsControlItem,
				r, g, b:Number,
				xmlstring:String = '<project>'
					+ '<url_img>'+pId+'.png</url_img>'
					+ '<elements>';
			
			for(var i:int = 0; i < wc.numChildren; i++){
				wall = wc.getChildAt(i);
					
				r = ( ( wall.colorData.color >> 16 ) & 0xff );
				g = ( ( wall.colorData.color >> 8  ) & 0xff );
				b = (   wall.colorData.color         & 0xff );
				
				xmlstring += '<el_wall>';
				xmlstring +=	 '<wall_name><![CDATA[' + wall.labelWall.text + ']]></wall_name>';
				xmlstring += 	'<wall_mask>' + pId + '_' + i + '.png</wall_mask>';
				if(wall.colorData.color){
					xmlstring += 	'<color setid="' + wall.colorData.setId + '">';
					xmlstring += 		'<name><![CDATA[' + wall.colorData.label + ']]></name>';
					xmlstring += 		'<definitions r="' + r + '" g="' + g + '" b="' + b + '" />';
					xmlstring += 	'</color>';
				}
				xmlstring += '</el_wall>';
			}
			xmlstring += '</elements></project>';

			return new XML(xmlstring);
		}
		
		private function updateXmlNode(xml:XML, wall_index:int):XML{
			xml.elements.el_wall[wall_index].wall_mask.replace('*', "none");
			return xml;
		}
		
	//*** restore Project ***//

		public function restoreProject(){
			var elems:Array = new Array();
			for each(var el:XML in this.prData.xml.elements.el_wall){
				elems.push(el);
			}
			
			var wc = Studio.rootStg.panelWalls.addWallsControl("active");
			wc.addWalls(elems);
			wc.selectedWall = wc.getChildAt(wc.numChildren-1);
			wc.selectedWall.setSelected(true);
			
			this.artBoard = Studio.rootStg.createArtBoard("restored");
			this.artBoard.wallsControl = Studio.rootStg.panelWalls.wallsControl;

			var foto:Bitmap = new Bitmap(this.prData.fotoBmd, "auto", true);
			this.artBoard.addRestoredProject(foto);

			var numWalls = this.getNotEmptyWallsCount();
			var wall;
			for(var i=0; i<numWalls; i++){
				wall = wc.getChildAt(i) as WallsControlItem;
				artBoard.projectMc.appendMagicMask(this.prData.masks[elems[i].wall_mask], wall);
			}
			Studio.rootStg.panelTools.enable();
			Studio.rootStg.panelMain.enable(true);
			Studio.rootStg.panelSave.enable(true);
		}
		
//* ************* loadProject ****************** *//
		
		public function loadProject(pId:String){
			trace("loadProject: ", pId,"---");
			this.sessionId = pId;
			
			var url:String = Studio.rootStg.xmlConfig.getLoadProjectXmlUrl();
        	var req:URLRequest = new URLRequest(url);
        	req.contentType = "application/x-www-form-urlencoded";
        	req.method = "post";
        	req.data = new URLVariables("id="+pId);
			
        	urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, xmlLoadComplete);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        	urlLoader.load(req);
		}
		
		private function ioErrorHandler(e:IOErrorEvent){
			trace("ioErrorHandler: " + e);
			
			if(Studio.rootStg.panelInfo){
				Studio.rootStg.panelInfo.signalProjectNotFound(sessionId);
			}
			
			this.sessionId = null;
			
			e.target.removeEventListener(Event.COMPLETE, xmlLoadComplete);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			Studio.rootStg.addHomepage();
		}
		
		private function xmlLoadComplete(e:Event){
			trace("project xml loaded");
			if(e.target.data == "notFound"){
				e.target.dispatchEvent(new IOErrorEvent("ioError", true));
				return;
			}
			e.target.removeEventListener(Event.COMPLETE, xmlLoadComplete);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			var xml:XML = new XML(e.target.data);
			xml.ignoreWhitespace = true;
			trace(xml.toString());
						
			var elems:Array = new Array();
			for each(var el:XML in xml.elements.el_wall){
				elems.push(el);
			}
			this.prData = new Object();
			prData.xml = xml;
			prData.url_img = xml.url_img;
			prData.elements = elems;
			
			this.signalProjectFound();
			
			var wc = Studio.rootStg.panelWalls.addWallsControl("active");
			wc.addWalls(elems);
			wc.selectedWall = wc.getChildAt(wc.numChildren-1);
			wc.selectedWall.setSelected(true);
			
			this.artBoard = Studio.rootStg.createArtBoard("load");
			this.artBoard.wallsControl = wc;
			
			this.loadFoto();
		}
		
		private function loadFoto(){
			var url:String = Studio.rootStg.xmlConfig.getLoadProjectBitmapsUrl();
			
			loader = new Loader;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, fotoLoaded);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorBitmapHandler);
			loader.load(new URLRequest(url + prData.url_img));
		}
		
		private function fotoLoaded(e:Event){
			trace("Project: fotoLoaded");
			e.target.removeEventListener(Event.COMPLETE, fotoLoaded);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorBitmapHandler);
			
			this.artBoard.addNewProject(loader);
			
			var numLoaded = artBoard.projectMc.layers.numChildren;
			var numLoad = this.getNotEmptyWallsCount();
			if(numLoad > numLoaded){
				this.loadBitmapMask(numLoaded);
			}else{
				this.loadFinished();
			}
		}
		
		private function loadBitmapMask(num:int){
			var url:String = Studio.rootStg.xmlConfig.getLoadProjectBitmapsUrl();
			
			bmpLoader = new Loader;
			bmpLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, maskLoaded);
			bmpLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorBitmapHandler);
			bmpLoader.load(new URLRequest(url + prData.elements[num].wall_mask));
		}
		
		private function maskLoaded(e:Event){
			trace("Project: maskLoaded");
			e.target.removeEventListener(Event.COMPLETE, maskLoaded);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorBitmapHandler);
			
			var numLoaded = artBoard.projectMc.layers.numChildren;
			var numLoad = this.getNotEmptyWallsCount();
			var wall = Studio.rootStg.panelWalls.wallsControl.getChildAt(numLoaded) as WallsControlItem;

			artBoard.projectMc.appendMagicMask(e.target.content.bitmapData, wall);
			
			if(numLoad > numLoaded+1){
				this.loadBitmapMask(numLoaded+1);
			}else{
				this.loadFinished();
			}
		}
		
		private function loadFinished(){
			this.projectSaved = true;
			
			artBoard.removeLoading();
			
			Studio.rootStg.panelMain.enable(true);
			Studio.rootStg.panelSave.enable(true);
			Studio.rootStg.panelTools.enable();
			Studio.rootStg.setIdLabel();
			
			this.signalProjectLoaded();
		}
		
		private function ioErrorBitmapHandler(e:IOErrorEvent){
			trace("ioErrorBitmapHandler: " + e);
			e.target.removeEventListener(Event.COMPLETE, maskLoaded);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorBitmapHandler);
			if(Studio.rootStg.panelInfo){
				Studio.rootStg.panelInfo.signalProjectLoadError(sessionId);
			}
			Studio.rootStg.closeProject();
			Studio.rootStg.addHomepage();
		}
		
		private function getNotEmptyWallsCount():int{
			var count = prData.xml.elements.el_wall.length(); //prData.elements.length;
			trace("Project: getNotEmptyWallsCount: start=",count);
			for each(var el in prData.xml.elements.el_wall){
				if(el.wall_mask == "none") count--;
			}
			trace("Project: getNotEmptyWallsCount: return=",count);
			return count;
		}
		
		private function signalProjectFound(){
			if(Studio.rootStg.panelInfo){
				Studio.rootStg.panelInfo.signalProjectFound(sessionId);
			}
		}
		
		private function signalProjectLoaded(){
			if(Studio.rootStg.panelInfo){
				Studio.rootStg.panelInfo.signalProjectLoaded(sessionId);
			}
		}

//*** CLOSE PROJECT and rest ***//

		function generateRandomString(strlen:Number):String{
			var chars:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
			var num_chars:Number = chars.length - 1;
			var randomChar:String = "";
			
			for (var i:Number = 0; i < strlen; i++){
				randomChar += chars.charAt(Math.floor(Math.random() * num_chars));
			}
			return randomChar;
		}
		
		override public function closeProject(){
			super.closeProject();
			if(urlLoader){
				urlLoader.removeEventListener(Event.COMPLETE, uploadXmlComplete);
				urlLoader.removeEventListener(Event.COMPLETE, uploadBitmapComplete);
				urlLoader.removeEventListener(Event.COMPLETE, xmlLoadComplete);
				urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			}
			
			if(loader){
				if(loader.contentLoaderInfo) loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imgLoaded);
				if(loader.contentLoaderInfo) loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, fotoLoaded);
				if(loader.contentLoaderInfo) loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorBitmapHandler);
			}
			
			if(bmpLoader){
				if(bmpLoader.contentLoaderInfo) bmpLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, maskLoaded);
				if(bmpLoader.contentLoaderInfo) bmpLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorBitmapHandler);
			}
		}

	}
}
