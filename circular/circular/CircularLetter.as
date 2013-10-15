package circular {
	import circular.container.CircularLetterOverlap;

	import typography.Typography3D;

	import flash.display.Sprite;

	public class CircularLetter extends Sprite {

		private var __selection:CircularLetterSelection;
		private var __pivot:Sprite;
		private var __glyph:CircularLetterGlyph;
		// Variables -------------------------------------------------------------------------------------
		private var __selectionContainer:Sprite;
		private var __char:String;
		private var __typography:Typography3D;
		private var __spacingRatio:Number;
		private var __openingRatio:Number;
		private var __scaleFactor:Number;
		private var __initialRadius:Number;
		private var __spiralRatio:Number;
		// Variables (style) ----------------------------------------------------------------------------
		private var __textNormalColor:uint;
		private var __textSelectedColor:uint;
		private var __selectionColor:uint;
		private var __selected:Boolean = false;
		// Internal variables (primary indicators) ------------------------------------------------
		private var __charChanged:Boolean = true;
		private var __typographyChanged:Boolean = true;
		private var __spacingRatioChanged:Boolean = true;
		private var __openingRatioChanged:Boolean = true;
		private var __scaleFactorChanged:Boolean = true;
		private var __initialRadiusChanged:Boolean = true;
		private var __spiralRatioChanged:Boolean = true;
		// Internal variables (secondary indicators) --------------------------------------------
		private var __beginAngleChanged:Boolean = true;
		private var __heightChanged:Boolean = true;
		private var __widthChanged:Boolean = true;
		private var __glyphMotifChanged:Boolean = true;
		private var __beginRadiusChanged:Boolean = true;
		private var __widthAngleChanged:Boolean = true;
		private var __endAngleChanged:Boolean = true;
		// Internal variables (values) ---------------------------------------------------------------
		private var __beginAngle:Number;
		private var __height:Number;
		private var __width:Number;
		private var __glyphMotif:Array;
		private var __beginRadius:Number;
		private var __widthAngle:Number;
		private var __endAngle:Number;
		// Constants (calculation) -------------------------------------------------------------------
		private static const __RAD_TO_DEG:Number = 180 / Math.PI;
		private static const __PI2:Number = Math.PI * 2;

		public function CircularLetter(selectionContainer:Sprite, char:String, typography:Typography3D, spacingRatio:Number, openingRatio:Number, scaleFactor:Number, initialRadius:Number, spiralRatioRatio:Number, textNormalColor:uint, textSelectedColor:uint, selectionColor:uint) {
			__selectionContainer = selectionContainer;
			__char = char;
			__typography = typography;
			__spacingRatio = spacingRatio;
			__openingRatio = openingRatio;
			__scaleFactor = scaleFactor;
			__initialRadius = initialRadius;
			__spiralRatio = spiralRatioRatio;
			__textNormalColor = textNormalColor;
			__textSelectedColor = textSelectedColor;
			__selectionColor = selectionColor;
			setProperties();
			createSelection();
			createPivot();
			createGlyph();
		}

		private function setProperties():void {
			mouseEnabled = false;
		}

		//----------------------------------------------------------------------------------------------------
		// Structure
		//----------------------------------------------------------------------------------------------------
		private function createSelection():void {
			__selection = new CircularLetterSelection(__selectionColor);
			__selection.rotation = -90;
			__selectionContainer.addChild(__selection);
		}		

		private function createPivot():void {
			__pivot = new Sprite();
			__pivot.mouseEnabled = false;
			addChild(__pivot);
		}

		private function createGlyph():void {
			__glyph = new CircularLetterGlyph(__textNormalColor, __textSelectedColor);
			__pivot.addChild(__glyph);
		}

		// Dynamic --------------------------------------------------------------------------------------
		private function removeSelection():void {
			__selectionContainer.removeChild(__selection);
			__selection = null;
		}

		//----------------------------------------------------------------------------------------------------
		// Getter Methods
		//----------------------------------------------------------------------------------------------------
		public function get endAngle():Number {
			return __endAngle;
		}

		public function get peakRadius():Number {
			return getRadiusFromAngle(__endAngle) + __height;
		}

		//----------------------------------------------------------------------------------------------------
		// Getter/Setter Methods
		//----------------------------------------------------------------------------------------------------
		public function get char():String {
			return __char;
		}

		public function set char(value:String):void {
			__char = value;
			__charChanged = true;
		}

		//----------------------------------------------------------------------------------------------------
		// Setter Methods
		//----------------------------------------------------------------------------------------------------
		public function set typography(value:Typography3D):void {
			__typography = value;
			__typographyChanged = true;
		}

		public function set spacingRatio(value:Number):void {
			__spacingRatio = value;
			__spacingRatioChanged = true;
		}

		public function set openingRatio(value:Number):void {
			__openingRatio = value;
			__openingRatioChanged = true;
		}

		public function set scaleFactor(value:Number):void {
			__scaleFactor = value;
			__scaleFactorChanged = true;
		}

		public function set initialRadius(value:Number):void {
			__initialRadius = value;
			__initialRadiusChanged = true;
		}

		public function set spiralRatio(value:Number):void {
			__spiralRatio = value;
			__spiralRatioChanged = true;
		}

		//----------------------------------------------------------------------------------------------------
		// Setter Methods (style)
		//----------------------------------------------------------------------------------------------------
		public function set textNormalColor(value:uint):void {
			__textNormalColor = value;
			__glyph.normalColor = __textNormalColor;
		}

		public function set textSelectedColor(value:uint):void {
			__textSelectedColor = value;
			__glyph.selectedColor = __textSelectedColor;
		}

		public function set selectionColor(value:uint):void {
			__selectionColor = value;
			__selection.color = __selectionColor;
		}

		//----------------------------------------------------------------------------------------------------
		// Getter/Setter Methods (style)
		//----------------------------------------------------------------------------------------------------
		public function get selected():Boolean {
			return __selected;
		}

		public function set selected(value:Boolean):void {
			__selected = value;
			__selection.selected = __selected;
			__glyph.selected = __selected;
		}

		//----------------------------------------------------------------------------------------------------
		// Public Methods
		//----------------------------------------------------------------------------------------------------
		public function render(beginAngle:Number):Number {
			
			// Variables
			setBeginAngle(beginAngle);
			if (__typographyChanged || __scaleFactorChanged) setHeight();
			if (__charChanged || __typographyChanged || __scaleFactorChanged) setWidth();
			if (__charChanged || __typographyChanged) setGlyphMotif();
			if (__beginAngleChanged || __initialRadiusChanged || __spiralRatioChanged) setBeginRadius();
			if (__widthChanged || __beginRadiusChanged) setWidthAngle();
			if (__spacingRatioChanged || __beginAngleChanged || __widthAngleChanged) setEndAngle();
			if (__openingRatioChanged || __beginAngleChanged || __widthAngleChanged) setPivotRotation();
			if (__openingRatioChanged || __widthChanged) setGlyphX();
			if (__heightChanged || __beginRadiusChanged) setGlyphY();
			
			// Selection
			if (__initialRadiusChanged || __spiralRatioChanged || __beginAngleChanged || __heightChanged || __endAngleChanged) __selection.reset(__initialRadius, __spiralRatio, __beginAngle, __height, __endAngle);
			
			// Glyph
			if (__scaleFactorChanged || __glyphMotifChanged) __glyph.reset(__scaleFactor, __glyphMotif);
			
			// Reset
			resetIndicators();
			
			// Return
			return __endAngle;
		}

		public function overlap(angle:Number, radius:Number):CircularLetterOverlap {
			var virtualAngle:Number = angle + __beginAngle - __beginAngle % __PI2;
			if (virtualAngle < __beginAngle || virtualAngle >= __endAngle) {
				return new CircularLetterOverlap(false);
			} else {
				var virtualRadius:Number = getRadiusFromAngle(virtualAngle);
				var portion:String = (radius >= virtualRadius + __height) ? CircularLetterOverlap.PORTION_TOP : ((radius < virtualRadius) ? CircularLetterOverlap.PORTION_BOTTOM : CircularLetterOverlap.PORTION_MIDDLE);
				var side:String = (virtualAngle < (__beginAngle + __endAngle) / 2) ? CircularLetterOverlap.SIDE_LEFT : CircularLetterOverlap.SIDE_RIGHT;
				return new CircularLetterOverlap(true, portion, side);
			}
		}

		//----------------------------------------------------------------------------------------------------
		// Workflow
		//----------------------------------------------------------------------------------------------------
		private function setBeginAngle(beginAngle:Number):void {
			if (__beginAngle != beginAngle) __beginAngleChanged = true;
			__beginAngle = beginAngle;
		}

		private function setHeight():void {
			var height:Number = __typography.getHeight() * __scaleFactor;
			if (__height != height) __heightChanged = true;
			__height = height;
		}

		private function setWidth():void {
			var width:Number = __typography.getWidth(__char) * __scaleFactor;
			if (__width != width) __widthChanged = true;
			__width = width;
		}

		private function setGlyphMotif():void {
			var glyphMotif:Array = __typography.getMotif(__char);
			__glyphMotifChanged = true;
			__glyphMotif = glyphMotif;
		}

		private function setBeginRadius():void {
			var beginRadius:Number = getRadiusFromAngle(__beginAngle);
			if (__beginRadius != beginRadius) __beginRadiusChanged = true;
			__beginRadius = beginRadius;
		}

		private function setWidthAngle():void {
			var widthAngle:Number = __width / __beginRadius;
			if (__widthAngle != widthAngle) __widthAngleChanged = true;
			__widthAngle = widthAngle;
		}

		private function setEndAngle():void {
			var endAngle:Number = __beginAngle + __widthAngle * __spacingRatio;
			if (__endAngle != endAngle) __endAngleChanged = true;
			__endAngle = endAngle;
		}

		private function setPivotRotation():void {
			__pivot.rotation = (__beginAngle + __widthAngle / 2 * __openingRatio) * __RAD_TO_DEG;
		}

		private function setGlyphX():void {
			__glyph.x = -__width / 2 * __openingRatio;
		}

		private function setGlyphY():void {
			__glyph.y = -__beginRadius - __height;
		}

		private function resetIndicators():void {
			
			// Primary indicators
			__charChanged = false;
			__typographyChanged = false;
			__spacingRatioChanged = false;
			__openingRatioChanged = false;
			__scaleFactorChanged = false;
			__initialRadiusChanged = false;
			__spiralRatioChanged = false;
			
			// Secondary indicators
			__beginAngleChanged = false;
			__heightChanged = false;
			__widthChanged = false;
			__glyphMotifChanged = false;
			__beginRadiusChanged = false;
			__widthAngleChanged = false;
			__endAngleChanged = false;
		}

		//----------------------------------------------------------------------------------------------------
		// Utils
		//----------------------------------------------------------------------------------------------------
		private function getRadiusFromAngle(angle:Number):Number {
			return __initialRadius + angle * __spiralRatio;
		}

		//----------------------------------------------------------------------------------------------------
		// Dispose
		//----------------------------------------------------------------------------------------------------
		public function dispose():void {
			removeSelection();
		}
	}
}