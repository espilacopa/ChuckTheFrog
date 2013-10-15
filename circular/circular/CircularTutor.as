package circular {
	import circular.display.ShapeColorizable;

	public class CircularTutor extends ShapeColorizable {

		private var __initialRadius:Number;
		private var __spiralRatio:Number;
		// Constants ------------------------------------------------------------------------------------
		private static const __END_ANGLE:Number = Math.PI * 3 / 2;
		private static const __NUM_DOTS:uint = 100;

		public function CircularTutor(initialRadius:Number, spiralRatio:Number, color:uint) {
			super(color);
			__initialRadius = initialRadius;
			__spiralRatio = spiralRatio;
			draw();
		}

		//----------------------------------------------------------------------------------------------------
		// Structure
		//----------------------------------------------------------------------------------------------------
		private function draw():void {
			graphics.clear();
			var stepAngle:Number = __END_ANGLE / __NUM_DOTS;
			var stepAlpha:Number = 1 / __NUM_DOTS;
			var alpha:Number = 1;
			var radius:Number;
			for (var i:Number = 0;i < __END_ANGLE;i += stepAngle) {
				radius = getRadiusFromAngle(i);
				graphics.beginFill(0xFF0000, alpha);
				graphics.drawCircle(Math.cos(i) * radius, Math.sin(i) * radius, .6);
				alpha -= stepAlpha;
			}
			graphics.endFill();
		}	

		//----------------------------------------------------------------------------------------------------
		// Setter Methods
		//----------------------------------------------------------------------------------------------------
		public function set initialRadius(value:Number):void {
			__initialRadius = value;
			draw();
		}

		public function set spiralRatio(value:Number):void {
			__spiralRatio = value;
			draw();
		}

		//----------------------------------------------------------------------------------------------------
		// Utils
		//----------------------------------------------------------------------------------------------------
		private function getRadiusFromAngle(angle:Number):Number {
			return __initialRadius + angle * __spiralRatio;
		}
	}
}