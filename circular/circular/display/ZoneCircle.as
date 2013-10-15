package circular.display {
	import flash.display.Sprite;

	public class ZoneCircle extends Sprite {

		private var __radius:Number;
		public static var COLOR:uint = 0xFF0000;
		public static var ALPHA:Number = 0;

		public function ZoneCircle(radius:Number) {
			__radius = radius;
			alpha = 0;
			mouseEnabled = false;
			draw();
		}

		private function draw():void {
			graphics.clear();
			graphics.beginFill(COLOR, ALPHA);
			graphics.drawCircle(x, y, __radius);
			graphics.endFill();
		}

		//----------------------------------------------------------------------------------------------------
		// Getter/Setter Methods
		//----------------------------------------------------------------------------------------------------
		public function get radius():Number {
			return __radius;
		}

		public function set radius(value:Number):void {
			__radius = value;
			draw();
		}

		//----------------------------------------------------------------------------------------------------
		// Public Methods
		//----------------------------------------------------------------------------------------------------
		public function activate(handCursor:Boolean = true):void {
			alpha = 1;
			mouseEnabled = true;
			buttonMode = handCursor;
		}

		public function deactivate():void {
			alpha = 0;
			mouseEnabled = false;
			buttonMode = false;
		}
	}
}