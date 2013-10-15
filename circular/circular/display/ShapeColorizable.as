package circular.display {
	import flash.display.Shape;
	import flash.geom.ColorTransform;

	public class ShapeColorizable extends Shape {

		private var __color:uint;

		public function ShapeColorizable(color:uint) {
			__color = color;
			applyColor();
		}

		//----------------------------------------------------------------------------------------------------
		// Getter/Setter Methods
		//----------------------------------------------------------------------------------------------------
		public function get color():uint {
			return __color;
		}

		public function set color(value:uint):void {
			__color = value;
			applyColor();
		}

		//----------------------------------------------------------------------------------------------------
		// Workflow
		//----------------------------------------------------------------------------------------------------
		private function applyColor():void {
			var colorTransform:ColorTransform = new ColorTransform();
			colorTransform.color = __color;
			colorTransform.alphaMultiplier = alpha;
			transform.colorTransform = colorTransform;
		}
	}
}