package{
	import flash.events.Event;
	
	public class EventCustom extends Event{
		public var data:Object;
		
		public static const COLOR_CHANGE:String = "colorChange";

		public function EventCustom(data:Object, type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			this.data = data;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
			return new EventCustom(data, type, bubbles, cancelable);
		}
	}
	
}
