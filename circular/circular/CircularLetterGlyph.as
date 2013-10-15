package circular {
	import circular.display.ShapeColorizable;

	public class CircularLetterGlyph extends ShapeColorizable {

		private var __scaleFactor:Number;
		private var __motif:Array;
		// Variables (style) ----------------------------------------------------------------------------
		private var __normalColor:uint;
		private var __selectedColor:uint;
		private var __selected:Boolean = false;

		public function CircularLetterGlyph(normalColor:uint, selectedColor:uint) {
			super(normalColor);
			__normalColor = normalColor;
			__selectedColor = selectedColor;
		}

		//----------------------------------------------------------------------------------------------------
		// Structure
		//----------------------------------------------------------------------------------------------------
		private function draw():void {
			graphics.clear();
			graphics.beginFill(0xFF0000);
			var length:uint = __motif.length;
			var action:Array;
			var parameters:Array;
			for (var i:uint = 0;i < length;i++) {
				action = __motif[i];
				parameters = action[1];
				switch (action[0]) {
					case "M":
						graphics.moveTo(Number(parameters[0]) * __scaleFactor, Number(parameters[1]) * __scaleFactor);
						break;
					case "L":
						graphics.lineTo(Number(parameters[0]) * __scaleFactor, Number(parameters[1]) * __scaleFactor);
						break;
					case "C":
						graphics.curveTo(Number(parameters[0]) * __scaleFactor, Number(parameters[1]) * __scaleFactor, Number(parameters[2]) * __scaleFactor, Number(parameters[3]) * __scaleFactor);
						break;
				}
			}
			graphics.endFill();
		}

		//----------------------------------------------------------------------------------------------------
		// Setter Methods (style)
		//----------------------------------------------------------------------------------------------------
		public function set normalColor(value:uint):void {
			__normalColor = value;
			if (!__selected) color = __normalColor;
		}

		public function set selectedColor(value:uint):void {
			__selectedColor = value;
			if (__selected) color = __selectedColor;
		}

		public function set selected(value:Boolean):void {
			__selected = value;
			color = (__selected) ? __selectedColor : __normalColor;
		}

		//----------------------------------------------------------------------------------------------------
		// Public Methods
		//----------------------------------------------------------------------------------------------------
		public function reset(scaleFactor:Number, motif:Array):void {
			__scaleFactor = scaleFactor;
			__motif = motif;
			draw();
		}
	}
}