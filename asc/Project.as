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
		public var type:String;
		
		public var sessionId:String;
		public var projectSaved:Boolean = false;
		
		public function Project(){
		}
		
		public function getSomeId():String{
			var time:Date = new Date();
			var id = String(time.valueOf());
			trace("project: returns id = ", id);
			return id;
		}
		
		public function createSessionId(){
			trace("Project: createSessionId");
			this.sessionId = this.createRandomString(8);
			this.projectSaved = false;
			
			Studio.rootStg.setIdLabel();
		}
		
		public function closeProject(){
			this.sessionId = null;
			this.projectSaved = false;
			
			if(urlLoader){}
			if(loader){
				try{ loader.unloadAndStop(); }
				catch(e){}
			}
			if(bmpLoader){}
		}
		
		
		public function createRandomString(strlen:Number):String{
			var chars:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789",
				num_chars:Number = chars.length - 1,
				randomChar:String = "";
			
			for(var i:Number = 0; i < strlen; i++){
				randomChar += chars.charAt(Math.floor(Math.random() * num_chars));
			}
			return randomChar;
		}
	}
}
