package{
	import flash.events.MouseEvent;

	public class ButtonSaveTemp extends ButtonRect{
		
		public function ButtonSaveTemp(){
			super(false, true);
		}
		
		override public function clickHandler(e:MouseEvent){
			Studio.rootStg.temp.push(Studio.rootStg.project.getTempData());
		}
	}
}
