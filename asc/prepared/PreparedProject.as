package prepared{
	import flash.display.MovieClip;
	
	public class PreparedProject extends MovieClip{
		
		public function PreparedProject(){
			trace("PreparedProject: init...");
		}
		
		public function setColor(wallControlItem){
			//trace("PreparedProject: setColor");
			var wall = this.getChildAt(wallControlItem.wallNum + 1);
			wall.setColor(wallControlItem.colorData.color);			
		}
		
		public function signalWallOver(num:int){
			//trace("PreparedProject: signal over "+num);
			var child = this.getChildAt(num) as prepared.Wall;
			child.setOverState();
		}
		
		public function signalWallOut(num:int){
			//trace("PreparedProject: signal out");
			var child = this.getChildAt(num) as prepared.Wall;
			child.setOutState();
		}
		
		public function remove(){
			var child;
			for(var i:int = this.numChildren - 1; i > 0; i--){
				child = this.getChildAt(i);
				if(child.hasOwnProperty("remove")){
					child.remove();
				}
			}
		}
	}
	
}
