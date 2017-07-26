package{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	
	public class WallsControl extends Sprite{
		public var selectedWall:WallsControlItem;
		
		private var moveDirection:int;
		private var controlHeight:int;
		
		public function WallsControl(h:Number){
			this.controlHeight = h;
		}
		
		public function addWall(wallData:XML = null):WallsControlItem{
			var wall = new WallsControlItem(Studio.PANEL_WIDTH, this.numChildren, wallData);
			wall.y = this.numChildren * WallsControlItem.CONTROL_HEIGHT;
			this.addChild(wall);
			
			Studio.rootStg.panelWalls.resizeHandler(Studio.rootStg.appHeight, 1);
			
			return wall;
		}
		
		public function addFirstWall(){
			var wall = this.addWall();
			wall.setSelected(true);
			this.selectedWall = wall;
		}
		
		public function addWalls(elems:Array){
			for(var i:int = 0; i < elems.length; i++){
				this.addWall(elems[i]);
			}
		}
		
		public function removeWall(num:int){
			if(this.numChildren == 1)
				return;
				
			if(selectedWall.wallNum == num){
				var changeNum = (num + 1 < this.numChildren) ? num + 1 : num - 1;
				this.changeWall(changeNum);
			}
			
			var wall = this.getChildAt(num) as WallsControlItem;
			wall.remove();
			this.removeChild(wall);
				
			for(var i:int = num; i < this.numChildren; i++){
				wall = this.getChildAt(i);
				wall.y -= WallsControlItem.CONTROL_HEIGHT;
				wall.wallNum--;
			}
			
			Studio.rootStg.panelWalls.resizeHandler(Studio.rootStg.appHeight);
			Studio.rootStg.artBoard.signalRemoveWall(num);
		}
		
		public function changeWall(num:int){
			this.selectedWall.setSelected(false);
			this.selectedWall = this.getChildAt(num) as WallsControlItem;
			this.selectedWall.setSelected(true);
		}
		
		public function changeColor(colorData:Object){
			this.selectedWall.setColor(colorData);
			Studio.rootStg.artBoard.changeColor(selectedWall);
		}
		
		public function deselectWall(){
			this.selectedWall.setSelected(false);
			Studio.rootStg.panelWalls.state = "deselected";
		}
		
		public function reselectWall(){
			this.selectedWall.setSelected(true);
			Studio.rootStg.panelWalls.state = "active";
		}
		
		public function resizeHandler(h:Number){
			this.controlHeight = h;
		}
		
		public function remove(){
			var wall;
			for(var i:int = this.numChildren-1; i >= 0; i--){
				wall = this.getChildAt(i);
				wall.remove();
				this.removeChild(wall);
			}
		}

	}
	
}
