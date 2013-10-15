package circular {
	import circular.display.ShapeColorizable;

	public class CircularLetterSelection extends ShapeColorizable {

		private var __initialRadius:Number;
		private var __spiralRatio:Number;
		private var __beginAngle:Number;
		private var __height:Number;
		private var __endAngle:Number;
		// Variables (style) ----------------------------------------------------------------------------
		private var __selected:Boolean = false;
		// Internal variables ---------------------------------------------------------------------------
		private var __angles:Vector.<Number>;
		private var __radiuses:Vector.<Number>;
		private var __anglesDirty:Boolean = false;
		private var __radiusesDirty:Boolean = false;
		private var __dirty:Boolean = true;
		// Constants (calculation) -------------------------------------------------------------------
		private static const __STEP:Number = Math.PI / 180;

		public function CircularLetterSelection(color:uint) {
			super(color);
			visible = false;
		}

		//----------------------------------------------------------------------------------------------------
		// Structure
		//----------------------------------------------------------------------------------------------------
		private function draw():void {
			if (__anglesDirty) setAngles();
			if (__radiusesDirty) setRadiuses();
			graphics.clear();
			graphics.beginFill(0xFF0000);
			var length:uint = __angles.length;
			var angle:Number;
			var radius:Number;
			for (var i:int = 0;i < length;i++) {
				angle = __angles[i];
				radius = __radiuses[i];
				if (i == 0) {
					graphics.moveTo(Math.cos(angle) * radius, Math.sin(angle) * radius);
				} else {
					graphics.lineTo(Math.cos(angle) * radius, Math.sin(angle) * radius);
				}
			}
			for (i = length - 1;i >= 0;i--) {
				angle = __angles[i];
				radius = __radiuses[i];
				graphics.lineTo(Math.cos(angle) * (radius + __height), Math.sin(angle) * (radius + __height));
			}
			graphics.endFill();
		}

		private function setAngles():void {
			__angles = new Vector.<Number>();
			for (var i:Number = __beginAngle;i < __endAngle;i += __STEP) {
				__angles.push(i);
			}
			__angles.push(__endAngle);
		}

		private function setRadiuses():void {
			__radiuses = new Vector.<Number>();
			var length:uint = __angles.length;
			for (var i:uint = 0;i < length;i++) {
				__radiuses.push(getRadiusFromAngle(__angles[i]));
			}
		}

		//----------------------------------------------------------------------------------------------------
		// Setter Methods (style)
		//----------------------------------------------------------------------------------------------------
		public function set selected(value:Boolean):void {
			__selected = value;
			if (__selected) {
				checkDrawFromSelected();
				visible = true;
			} else {
				visible = false;
			}
		}

		//----------------------------------------------------------------------------------------------------
		// Public Methods
		//----------------------------------------------------------------------------------------------------
		public function reset(initialRadius:Number, spiralRatio:Number, beginAngle:Number, height:Number, endAngle:Number):void {
			if (__beginAngle != beginAngle || __endAngle != endAngle) __anglesDirty = true;
			if (__anglesDirty || __initialRadius != initialRadius || __spiralRatio != spiralRatio) __radiusesDirty = true;
			__initialRadius = initialRadius;
			__spiralRatio = spiralRatio;
			__beginAngle = beginAngle;
			__height = height;
			__endAngle = endAngle;
			checkDrawFromDirty();
		}

		//----------------------------------------------------------------------------------------------------
		// Workflow
		//----------------------------------------------------------------------------------------------------
		private function checkDrawFromDirty():void {
			if (__selected) {
				draw();
				__dirty = false;
			} else {
				__dirty = true;
			}
		}

		private function checkDrawFromSelected():void {
			if (__dirty) {
				draw();
				__dirty = false;
			}
		}

		//----------------------------------------------------------------------------------------------------
		// Utils
		//----------------------------------------------------------------------------------------------------
		private function getRadiusFromAngle(angle:Number):Number {
			return __initialRadius + angle * __spiralRatio;
		}
	}
}