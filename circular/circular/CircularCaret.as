package circular {
	import circular.display.ShapeColorizable;

	import flash.events.Event;

	public class CircularCaret extends ShapeColorizable {

		private var __height:Number;
		// Internal variables ---------------------------------------------------------------------------
		private var __count:uint;
		// Constants ------------------------------------------------------------------------------------
		private static const __MAX_COUNT:uint = 28;

		public function CircularCaret(height:Number, color:uint) {
			super(color);
			__height = height;
			visible = false;
			draw();
		}

		//----------------------------------------------------------------------------------------------------
		// Structure
		//----------------------------------------------------------------------------------------------------
		private function draw():void {
			graphics.clear();
			graphics.beginFill(0xFF0000);
			graphics.drawRect(0, 0, 1.6, -__height);
			graphics.endFill();
		}

		//----------------------------------------------------------------------------------------------------
		// Initialization
		//----------------------------------------------------------------------------------------------------
		private function initializeEnterFrame():void {
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}

		private function enterFrameHandler(event:Event):void {
			__count++;
			if (__count == __MAX_COUNT) {
				visible = !visible;
				__count = 0;
			}
		}

		private function desinitializeEnterFrame():void {
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}

		//----------------------------------------------------------------------------------------------------
		// Setter Methods
		//----------------------------------------------------------------------------------------------------
		override public function set height(value:Number):void {
			__height = value;
			draw();
		}

		//----------------------------------------------------------------------------------------------------
		// Public Methods
		//----------------------------------------------------------------------------------------------------
		public function display():void {
			__count = 0;
			visible = true;
			initializeEnterFrame();
		}

		public function hide():void {
			visible = false;
			desinitializeEnterFrame();
		}

		//----------------------------------------------------------------------------------------------------
		// Dispose
		//----------------------------------------------------------------------------------------------------
		public function dispose():void {
			desinitializeEnterFrame();
		}
	}
}