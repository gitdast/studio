package{
	
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.utils.ByteArray;
	import flash.display.BitmapData;
	import adobe.PNGEncoder;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLVariables;
	import flash.net.URLRequestHeader;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.geom.Matrix;
	import prepared.Wall;
	
	public class Project{
		public var prData:Object;
		public var loader:Loader;
		public var bmpLoader:Loader;
		public var urlLoader:URLLoader;
		public var artBoard;
		public var prId:String;
		public var type:String;
		
		public function Project(prObj:Object = null){
			trace("Project: init...");
			this.prData = prObj;
		}
		
		public function getSomeId():String{
			var time:Date = new Date();
			var id = String(time.valueOf());
			trace("project: returns id = ", id);
			return id;
		}
		
		public function closeProject(){
			try{ loader.unloadAndStop(); }catch(e){}
			if(urlLoader){
				urlLoader.removeEventListener(Event.COMPLETE, uploadXmlComplete);
				urlLoader.removeEventListener(Event.COMPLETE, uploadBitmapComplete);
				urlLoader.removeEventListener(Event.COMPLETE, xmlLoadComplete);
				urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			}
			if(loader){
				if(loader.contentLoaderInfo) loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, swfLoaded);
				if(loader.contentLoaderInfo) loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imgLoaded);
				
				if(loader.contentLoaderInfo) loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, fotoLoaded);
				if(loader.contentLoaderInfo) loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorBitmapHandler);
			}
			if(bmpLoader){
				if(bmpLoader.contentLoaderInfo) bmpLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, maskLoaded);
				if(bmpLoader.contentLoaderInfo) bmpLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorBitmapHandler);
			}
		}
		
		//****** PreparedProject *****//
		
		public function loadPreparedProject(){
			loader = new Loader;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, swfLoaded);
			loader.load(new URLRequest(prData.link));
			
			Studio.rootStg.addLoading();
		}
		
		private function swfLoaded(e:Event){
			trace("Project: swf loaded");
			trace(prData.elements);
			Studio.rootStg.removeLoading();
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, swfLoaded);
			
			var wc = Studio.rootStg.panelWalls.addWallsControl("pasive");
			wc.addWalls(prData.elements);
			
			this.artBoard = Studio.rootStg.createArtBoard("prepared");
			this.artBoard.addPreparedProject(loader);
			this.artBoard.wallsControl = wc;
			
			this.type = "prepared";
			Studio.rootStg.panelMain.enable(false);
			Studio.rootStg.panelSave.butt_savetemp.enable();
		}
		
		public function getTempDataPrepared(){
			var tempData:Object = new Object();
			tempData.prId = this.getSomeId();
			tempData.link = prData.link;
			tempData.type = this.type;
			//tempData.elements = prData.elements;
			tempData.elements = new Array();
			tempData.walls = new Array();
			var i:int;
			for(i=0; i<prData.elements.length; i++){
				tempData.elements.push(new XML(prData.elements[i]));
			}
			
			/* thumb generation - height 100px */
			var matrix:Matrix = new Matrix();
			var scaleH:Number = 100 / artBoard.projectMc.height * artBoard.projectMc.scaleY;
			var thumbBmd:BitmapData = new BitmapData(artBoard.projectMc.width/artBoard.projectMc.scaleY*scaleH, 100, true, 0);
           	matrix.scale(scaleH, scaleH);
			thumbBmd.draw(artBoard.projectMc, matrix);
			var thumb:Bitmap = new Bitmap(thumbBmd, "auto", true);
			tempData.thumb = thumb;
			/*
			var child:prepared.Wall;
			for(var i:int=artBoard.projectMc.numChildren-1; i>0; i--){
				child = artBoard.projectMc.getChildAt(i) as prepared.Wall;
				tempData.walls.push(child.color);
				if(child.isColorized){
					tempData.elements[i-1].color = child.color;
					//tempData.elements[i-1].label = child.label;
					trace(child.color);
				}else{
					trace(i);
				}
			}
			*/
			var wc = Studio.rootStg.panelWalls.wallsControl;
			var wall:WallsControlItem;
			for(i = 0; i < wc.numChildren; i++){
				wall = wc.getChildAt(i);
				if(wall.colorData.label){
					tempData.elements[i].color.hex = wall.colorData.color;
					tempData.elements[i].color.name = wall.colorData.label;
					trace(wall.colorData.label);
				}else{
					trace(i);
				}
			}
			
			return tempData;
		}
		

		//****** New Project *****//
		
		/* choose image */
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
			Studio.rootStg.panelSave.enable();
			Studio.rootStg.panelTools.enable();
			var wc = Studio.rootStg.panelWalls.addWallsControl("active");
			wc.addFirstWall();
			
			this.artBoard = Studio.rootStg.createArtBoard("new");
			this.artBoard.addNewProject(loader);
			this.artBoard.wallsControl = wc;
			
			//Studio.rootStg.panelTools.setIdLabel();
		}
		
		/* save temporaily data */
		public function getTempData():Object{
			var tempData:Object = new Object();
			tempData.prId = this.getSomeId();
			tempData.type = "new";
			tempData.xml = this.generateXml(tempData.prId);
			tempData.fotoBmd = artBoard.projectMc.foto.bitmapData;
			tempData.masks = new Object();
			
			/* thumb generation - height 100px */
			var matrix:Matrix = new Matrix();
			var scaleH:Number = 100 / artBoard.projectMc.height * artBoard.projectMc.scaleY;
			var thumbBmd:BitmapData = new BitmapData(artBoard.projectMc.width/artBoard.projectMc.scaleY*scaleH, 100, true, 0);
           	matrix.scale(scaleH, scaleH);
			thumbBmd.draw(artBoard.projectMc, matrix);
			var thumb:Bitmap = new Bitmap(thumbBmd, "auto", true);
			tempData.thumb = thumb;
			
			var wall_filename:String;
			var wall_index:int;
			var layer:Sprite;
			var maskB:Bitmap;
			for each(var wall:XML in tempData.xml.elements.el_wall){
				wall_filename = wall.wall_mask.toString();
				wall_index = wall.childIndex();
				if(artBoard.projectMc.layers.numChildren <= wall_index){
					//* prazdne vrstvy na konci seznamu se neuploaduji, ale zaznamenaji jako prazdne *//
					tempData.xml = this.updateXmlNode(tempData.xml, wall_index);
				}else{
					layer = artBoard.projectMc.layers.getChildAt(wall_index);
					maskB = layer.getChildAt(1) as Bitmap;
					tempData.masks[wall_filename] = maskB.bitmapData;
				}
			}
			return tempData;
		}
		
		/* save permanently */
		public function exportWhenSessionId(){
			if(Studio.rootStg.sessionId)
				this.export();
			else
				Studio.rootStg.addEventListener("enterFrame", exportSessionIdCheck);
		}
		private function exportSessionIdCheck(e:Event){
			if(Studio.rootStg.sessionId){
				Studio.rootStg.removeEventListener("enterFrame", exportSessionIdCheck);
				this.export();
			}				
		}
		public function export(){
			this.prId = Studio.rootStg.sessionId;
			this.prData = new Object();
			this.prData.xml = this.generateXml(this.prId);
			this.prData.bmpToSend = 1;
			var bmd:BitmapData = artBoard.projectMc.foto.bitmapData;
			this.uploadBitmap(prId, bmd);
			
			var wall_filename:String;
			var wall_index:int;
			var layer:Sprite;
			var maskB:Bitmap;
			for each(var wall:XML in prData.xml.elements.el_wall){
				wall_filename = wall.wall_mask.toString();
				wall_filename = wall_filename.substr(0, wall_filename.length-4);
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
		
		private function ulpoadXml(xml:XML){
			var url:String = Studio.rootStg.xmlConfig.getSaveProjectXmlUrl();
			var req:URLRequest = new URLRequest(url + "?id=" + prId + "&email=" + Studio.rootStg.sessionEmail); 
			urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, uploadXmlComplete);
			urlLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
			req.requestHeaders.push(new URLRequestHeader('Cache-Control', 'no-cache'));
			req.contentType = "text/xml"; 
			req.data = xml.toXMLString(); 
			req.method = "post"; 
			
			try{ 
    			urlLoader.load(req); 
			}catch (error:ArgumentError){ 
    			trace("An ArgumentError has occurred."); 
			}catch (error:SecurityError){ 
    			trace("A SecurityError has occurred."); 
			}
		}
		
		private function uploadXmlComplete(e:Event){
			trace(urlLoader.data);
			urlLoader.removeEventListener(Event.COMPLETE, uploadXmlComplete);
			
			if(urlLoader.data.status == "OK"){
				Studio.rootStg.sessionIdSaved = true;
				if(Studio.rootStg.panelInfo)
					Studio.rootStg.panelInfo.signalProjectSaved(prId);
			}else if(Studio.rootStg.panelInfo){
				var errId = (urlLoader.data.errorId) ? urlLoader.data.errorId : 0;
				Studio.rootStg.panelInfo.signalProjectSaveError(errId);
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
        	urlLoader.load(req);
    	}
		
		private function uploadBitmapComplete(e:Event){
			trace("Project: uploadBitmapComplete - ", prData.bmpToSend);
			this.prData.bmpToSend--;
			if(prData.bmpToSend == 0){
				this.ulpoadXml(prData.xml);
				
				if(Studio.rootStg.panelInfo)
					Studio.rootStg.panelInfo.signalProjectBitmapsSaved(prId);
			}
		}
		
		private function updateXmlNode(xml:XML, wall_index:int):XML{
			xml.elements.el_wall[wall_index].wall_mask.replace('*',"none");
			return xml;
		}
		
		private function generateXml(pId:String):XML{
			var wc = Studio.rootStg.panelWalls.wallsControl;
			var wall:WallsControlItem;
			var r,g,b:Number;
			//var xml:XML = new XML('<?xml version="1.0" encoding="utf-8"?><project>'+prId+'</project>');
			var xmlstring = '<project>';
			xmlstring += '<url_img>'+pId+'.png</url_img>';
			xmlstring += '<elements>';
			
			for(var i:int = 0; i < wc.numChildren; i++){
				wall = wc.getChildAt(i);
				r = ( ( wall.colorData.color >> 16 ) & 0xff );
				g = ( ( wall.colorData.color >> 8  ) & 0xff );
				b = (   wall.colorData.color         & 0xff );
				
				xmlstring += '<el_wall>';
				xmlstring +=	 '<wall_name><![CDATA['+wall.labelWall.text+']]></wall_name>';
				xmlstring += 	'<wall_mask>'+pId+'_'+i+'.png</wall_mask>';
				xmlstring += 	'<color setid="'+wall.colorData.setId+'">';
				xmlstring += 		'<name><![CDATA['+wall.colorData.label+']]></name>';
				xmlstring += 		'<definitions r="'+r+'" g="'+g+'" b="'+b+'" />';
				xmlstring += 	'</color>';
				xmlstring += '</el_wall>';
			}
			xmlstring += '</elements></project>';

			return new XML(xmlstring);
		}
		
		//* ************* restore Project ************** *//
		public function restoreProject(pId:String){
			for(var i:int=0; i<Studio.rootStg.temp.length; i++){
				if(Studio.rootStg.temp[i].prId == pId){
					this.prData = Studio.rootStg.temp[i];
					break;
				}
			}
			trace("RESTORE: ...............");
			for(var p in this.prData){
				trace(p +": "+prData[p]);
			}
			
			if(prData.type == "prepared"){
				this.restorePreparedProject();
			}else{
				this.restoreNewProject();
			}
			
		}
		
		private function restorePreparedProject(){
			loader = new Loader;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, swfLoadedForRestore);
			loader.load(new URLRequest(prData.link));
			
			Studio.rootStg.addLoading();
		}
		
		private function swfLoadedForRestore(e:Event){
			this.swfLoaded(e);
			
			var child:prepared.Wall;
			var chNum = artBoard.projectMc.numChildren;
			for(var i:int=1; i<chNum; i++){
				if(prData.elements[i-1].hasOwnProperty("color")){
					child = artBoard.projectMc.getChildAt(i) as prepared.Wall;
					child.setColor(prData.elements[i-1].color.hex, false);
				}
			}
		}
		
		private function restoreNewProject(){
			var elems:Array = new Array();
			for each(var el:XML in this.prData.xml.elements.el_wall){
				elems.push(el);
			}
			
			var wc = Studio.rootStg.panelWalls.addWallsControl("active");
			wc.addWalls(elems);
			
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
			Studio.rootStg.panelSave.enable();
		}
		
		//* ************* loadProject ****************** *//
		
		public function loadProject(pId:String){
			trace("loadProject: ", pId,"---");
			this.prId = pId;
			var url:String = Studio.rootStg.xmlConfig.getLoadProjectXmlUrl();
        	var req:URLRequest = new URLRequest(url);
        	req.contentType = "application/x-www-form-urlencoded";
        	req.method = "post";
        	req.data = new URLVariables("id="+prId);
			
        	urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, xmlLoadComplete);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        	urlLoader.load(req);
		}
		
		private function ioErrorHandler(e:IOErrorEvent){
			trace("ioErrorHandler: " + e);
			e.target.removeEventListener(Event.COMPLETE, xmlLoadComplete);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			if(Studio.rootStg.panelInfo){
				Studio.rootStg.panelInfo.signalProjectNotFound(prId);
			}
			Studio.rootStg.closeProject();
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
				trace("el - ",el.name, el);
			}
			this.prData = new Object();
			prData.xml = xml;
			prData.url_img = xml.url_img;
			prData.elements = elems;
			
			this.trySignalProjectFound();
			
			var wc = Studio.rootStg.panelWalls.addWallsControl("active");
			wc.addWalls(elems);
			
			this.artBoard = Studio.rootStg.createArtBoard("load");
			this.artBoard.wallsControl = Studio.rootStg.panelWalls.wallsControl;
			
			this.loadFoto();
		}
		
		private function loadFoto(){
			loader = new Loader;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, fotoLoaded);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorBitmapHandler);
			loader.load(new URLRequest("bitmaps/"+prData.url_img));
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
			bmpLoader = new Loader;
			bmpLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, maskLoaded);
			bmpLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorBitmapHandler);
			bmpLoader.load(new URLRequest("bitmaps/"+prData.elements[num].wall_mask));
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
			artBoard.removeLoading();
			
			Studio.rootStg.panelTools.enable();
			Studio.rootStg.panelMain.enable(true);
			Studio.rootStg.panelSave.enable();
			
			Studio.rootStg.sessionId = this.prId;
			Studio.rootStg.sessionIdSaved = true;
			Studio.rootStg.panelTools.setIdLabel();
			
			this.trySignalProjectLoaded();
		}
		
		private function ioErrorBitmapHandler(e:IOErrorEvent){
			trace("ioErrorBitmapHandler: " + e);
			e.target.removeEventListener(Event.COMPLETE, maskLoaded);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorBitmapHandler);
			if(Studio.rootStg.panelInfo){
				Studio.rootStg.panelInfo.signalProjectLoadError(prId);
			}
			Studio.rootStg.closeProject();
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
		
		private function trySignalProjectFound(){
			if(Studio.rootStg.panelInfo){
				Studio.rootStg.panelInfo.signalProjectFound(prId);
			}
		}
		
		private function trySignalProjectLoaded(){
			if(Studio.rootStg.panelInfo){
				Studio.rootStg.panelInfo.signalProjectLoaded(prId);
			}
		}

	}
}
