package circular {
	import flash.events.Event;

	public class CircularFieldEvent extends Event {

		public static const CHANGED:String = "CircularFieldEvent.CHANGED";

		public function CircularFieldEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}

		override public function clone():Event {
			return new CircularFieldEvent(type, bubbles, cancelable);
		}
	}
}