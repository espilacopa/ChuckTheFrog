package circular {
	import circular.container.CircularLetterIndexedOverlap;
	import circular.container.CircularLetterOverlap;
	import circular.display.ZoneCircle;

	import typography.Typography3D;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.Timer;

	public class CircularField extends Sprite {

		private var __field:TextField;
		private var __tutor:CircularTutor;
		private var __selectionContainer:Sprite;
		private var __lettersContainer:Sprite;
		private var __letters:Vector.<CircularLetter>;
		private var __caret:CircularCaret;
		private var __zone:ZoneCircle;
		private var __timer:Timer;
		// Variables -------------------------------------------------------------------------------------
		private var __text:String;
		private var __typography:Typography3D;
		private var __spacingRatio:Number;
		private var __openingRatio:Number;
		private var __size:Number;
		private var __initialRadius:Number;
		private var __spiralRatio:Number;
		// Variables (style) ----------------------------------------------------------------------------
		private var __textNormalColor:uint;
		private var __textSelectedColor:uint;
		private var __selectionColor:uint;
		private var __caretColor:uint;
		private var __tutorColor:uint;
		// Internal variables (primary indicators) ------------------------------------------------
		private var __textChanged:Boolean = false;
		private var __typographyChanged:Boolean = false;
		private var __spacingRatioChanged:Boolean = false;
		private var __openingRatioChanged:Boolean = false;
		private var __sizeChanged:Boolean = false;
		private var __initialRadiusChanged:Boolean = false;
		private var __spiralRatioChanged:Boolean = false;
		// Internal variables (values) ---------------------------------------------------------------
		private var __scaleFactor:Number;
		private var __height:Number;
		private var __beginIndex:uint;
		private var __selectionBeginIndex:uint;
		private var __selectionEndIndex:uint;
		// Constants (calculation) -------------------------------------------------------------------
		private static const __RAD_TO_DEG:Number = 180 / Math.PI;
		private static const __PI_2:Number = Math.PI / 2;
		private static const __PI2:Number = Math.PI * 2;
		private static const __PI25:Number = Math.PI * 2.5;
		private static const __ZONE_ADDITION:Number = 40;

		public function CircularField(text:String, typography:Typography3D, spacingRatio:Number, openingRatio:Number, size:Number, initialRadius:Number, spiralRatio:Number, textNormalColor:uint, textSelectedColor:uint, selectionColor:uint, caretColor:uint, tutorColor:uint) {
			__text = text;
			__typography = typography;
			__spacingRatio = spacingRatio;
			__openingRatio = openingRatio;
			__size = size;
			__initialRadius = initialRadius;
			__spiralRatio = spiralRatio * __RAD_TO_DEG;
			__textNormalColor = textNormalColor;
			__textSelectedColor = textSelectedColor;
			__selectionColor = selectionColor;
			__caretColor = caretColor;
			__tutorColor = tutorColor;
			setProperties();
			setScaleFactor();
			setHeight();
			createField();
			createTutor();
			createSelectionContainer();
			createLettersContainer();
			createLetters();
			createCaret();
			renderLetters();
			createZone();
			createTimer();
		}

		private function setProperties():void {
			mouseEnabled = false;
		}

		private function setScaleFactor():void {
			__scaleFactor = __size / 100;
		}

		private function setHeight():void {
			__height = __typography.getHeight() * __scaleFactor;
		}

		//----------------------------------------------------------------------------------------------------
		// Structure
		//----------------------------------------------------------------------------------------------------
		private function createField():void {
			__field = new TextField();
			__field.type = TextFieldType.INPUT;
			__field.maxChars = 4000;
			__field.text = __text;
		}

		private function createTutor():void {
			__tutor = new CircularTutor(__initialRadius, __spiralRatio, __tutorColor);
			__tutor.rotation = -90;
			addChild(__tutor);
		}

		private function createSelectionContainer():void {
			__selectionContainer = new Sprite();
			__selectionContainer.mouseEnabled = false;
			addChild(__selectionContainer);
		}

		private function createLettersContainer():void {
			__lettersContainer = new Sprite();
			__lettersContainer.mouseEnabled = false;
			addChild(__lettersContainer);
		}

		private function createLetters():void {
			__letters = new Vector.<CircularLetter>();
			createAdditionalLetters(0, __text.length);
		}

		private function createCaret():void {
			__caret = new CircularCaret(__height, __caretColor);
			addChild(__caret);
		}

		private function createZone():void {
			__zone = new ZoneCircle(getPeakRadius() + __ZONE_ADDITION);
			addChild(__zone);
		}

		private function createTimer():void {
			__timer = new Timer(10);
		}

		// Dynamic --------------------------------------------------------------------------------------
		private function createLetter(char:String):void {
			var letter:CircularLetter = new CircularLetter(__selectionContainer, char, __typography, __spacingRatio, __openingRatio, __scaleFactor, __initialRadius, __spiralRatio, __textNormalColor, __textSelectedColor, __selectionColor);
			__lettersContainer.addChild(letter);
			__letters.push(letter);
		}

		private function removeLetter(index:uint):void {
			var letter:CircularLetter = __letters[index];
			__letters.splice(index, 1);
			__lettersContainer.removeChild(letter);
			letter.dispose();
		}

		//----------------------------------------------------------------------------------------------------
		// Behavior
		//----------------------------------------------------------------------------------------------------
		public function initializeBehavior():void {
			initializeBehaviorField();
			initializeBehaviorZone();
			initializeBehaviorTimer();
		}

		public function desinitializeBehavior():void {
			desinitializeBehaviorField();
			desinitializeBehaviorZone();
			desinitializeBehaviorTimer();
		}

		// Field --------------------------------------------------------------------------------------------
		private function initializeBehaviorField():void {
			__field.addEventListener(FocusEvent.FOCUS_IN, fieldFocusInHandler);
			__field.addEventListener(FocusEvent.FOCUS_OUT, fieldFocusOutHandler);
			__field.addEventListener(Event.CHANGE, fieldChangeHandler);
		}

		private function fieldFocusInHandler(event:FocusEvent):void {
			__timer.start();
		}

		private function fieldFocusOutHandler(event:FocusEvent):void {
			__timer.stop();
			setSelectionFocusOut();
		}

		private function fieldChangeHandler(event:Event):void {
			__text = __field.text;
			__textChanged = true;
			render();
			reflectSelection();
			setZoneRadius();
			dispatchEvent(new CircularFieldEvent(CircularFieldEvent.CHANGED));
		}

		private function desinitializeBehaviorField():void {
			__field.removeEventListener(FocusEvent.FOCUS_IN, fieldFocusInHandler);
			__field.removeEventListener(FocusEvent.FOCUS_OUT, fieldFocusOutHandler);
			__field.removeEventListener(Event.CHANGE, fieldChangeHandler);
		}

		// Zone -------------------------------------------------------------------------------------------
		private function initializeBehaviorZone():void {
			__zone.activate();
			__zone.addEventListener(MouseEvent.MOUSE_DOWN, zoneMouseDownHandler);
		}

		private function zoneMouseDownHandler(event:MouseEvent):void {
			stage.mouseChildren = false;
			stage.focus = __field;
			setSelectionMouseDown();
			stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
		}

		private function stageMouseMoveHandler(event:MouseEvent):void {
			setSelectionMouseMove();
		}

		private function stageMouseUpHandler(event:MouseEvent):void {
			stage.mouseChildren = true;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
		}

		private function desinitializeBehaviorZone():void {
			__zone.deactivate();
			__zone.removeEventListener(MouseEvent.MOUSE_DOWN, zoneMouseDownHandler);
		}

		// Timer ------------------------------------------------------------------------------------------
		private function initializeBehaviorTimer():void {
			__timer.addEventListener(TimerEvent.TIMER, timerTimerHandler);
		}

		private function timerTimerHandler(event:TimerEvent):void {
			reflectSelection();
		}

		private function desinitializeBehaviorTimer():void {
			__timer.removeEventListener(TimerEvent.TIMER, timerTimerHandler);
		}

		//----------------------------------------------------------------------------------------------------
		// Getter/Setter Methods
		//----------------------------------------------------------------------------------------------------
		public function get text():String {
			return __text;
		}

		public function set text(value:String):void {
			__text = value;
			__textChanged = true;
			render();
		}

		public function get typography():Typography3D {
			return __typography;
		}

		public function set typography(value:Typography3D):void {
			__typography = value;
			__typographyChanged = true;
			render();
		}

		public function get spacingRatio():Number {
			return __spacingRatio;
		}

		public function set spacingRatio(value:Number):void {
			__spacingRatio = value;
			__spacingRatioChanged = true;
			render();
		}

		public function get openingRatio():Number {
			return __openingRatio;
		}

		public function set openingRatio(value:Number):void {
			__openingRatio = value;
			__openingRatioChanged = true;
			render();
		}

		public function get size():Number {
			return __size;
		}

		public function set size(value:Number):void {
			__size = value;
			__sizeChanged = true;
			render();
		}

		public function get initialRadius():Number {
			return __initialRadius;
		}

		public function set initialRadius(value:Number):void {
			__initialRadius = value;
			__initialRadiusChanged = true;
			render();
		}

		public function get spiralRatio():Number {
			return __spiralRatio;
		}

		public function set spiralRatio(value:Number):void {
			__spiralRatio = value * __RAD_TO_DEG;
			__spiralRatioChanged = true;
			render();
		}

		//----------------------------------------------------------------------------------------------------
		// Getter/Setter Methods (style)
		//----------------------------------------------------------------------------------------------------
		public function get textNormalColor():uint {
			return __textNormalColor;
		}

		public function set textNormalColor(value:uint):void {
			__textNormalColor = value;
			setLettersTextNormalColor();
		}

		public function get textSelectedColor():uint {
			return __textSelectedColor;
		}

		public function set textSelectedColor(value:uint):void {
			__textSelectedColor = value;
			setLettersTextSelectedColor();
		}

		public function get selectionColor():uint {
			return __selectionColor;
		}

		public function set selectionColor(value:uint):void {
			__selectionColor = value;
			setLettersSelectionColor();
		}

		public function get caretColor():uint {
			return __caretColor;
		}

		public function set caretColor(value:uint):void {
			__caretColor = value;
			__caret.color = __caretColor;
		}

		public function get tutorColor():uint {
			return __tutorColor;
		}

		public function set tutorColor(value:uint):void {
			__tutorColor = value;
			__tutor.color = __tutorColor;
		}

		//----------------------------------------------------------------------------------------------------
		// Public Methods
		//----------------------------------------------------------------------------------------------------
		public function reset(text:String, typography:Typography3D, spacingRatio:Number, openingRatio:Number, size:Number, initialRadius:Number, spiralRatio:Number):void {
			__text = text;
			__typography = typography;
			__spacingRatio = spacingRatio;
			__openingRatio = openingRatio;
			__size = size;
			__initialRadius = initialRadius;
			__spiralRatio = spiralRatio * __RAD_TO_DEG;
			__textChanged = true;
			__typographyChanged = true;
			__spacingRatioChanged = true;
			__openingRatioChanged = true;
			__sizeChanged = true;
			__initialRadiusChanged = true;
			__spiralRatioChanged = true;
			render();
		}

		//----------------------------------------------------------------------------------------------------
		// Workflow
		//----------------------------------------------------------------------------------------------------
		private function render():void {
			
			// variables
			if (__textChanged) setText();
			if (__typographyChanged) setTypography();
			if (__spacingRatioChanged) setSpacingRatio();
			if (__openingRatioChanged) setOpeningRatio();
			if (__sizeChanged) setSize();
			if (__initialRadiusChanged) setInitialRadius();
			if (__spiralRatioChanged) setSpiralRatio();
			
			// Letters
			renderLetters();
			
			// Zone
			if (__textChanged || __typographyChanged || __spacingRatioChanged || __sizeChanged || __initialRadiusChanged || __spiralRatioChanged) setZoneRadius();
			
			// Reset
			resetIndicators();
		}

		// Text ---------------------------------------------------------------------------------------------
		private function setText():void {
			var oldLength:uint = __letters.length;
			var newLength:uint = __text.length;
			if (oldLength == newLength) {
				setLettersChar(oldLength);
			} else {
				if (oldLength < newLength) {
					setLettersChar(oldLength);
					createAdditionalLetters(oldLength, newLength);
				} else {
					setLettersChar(newLength);
					removeAdditionalLetters(oldLength, newLength);
				}
			}
			__field.text = __text;
		}

		private function setLettersChar(length:uint):void {
			var letter:CircularLetter;
			var char:String;
			for (var i:uint = 0;i < length;i++) {
				letter = __letters[i];
				char = __text.charAt(i);
				if (letter.char != char) letter.char = char;
			}
		}

		private function createAdditionalLetters(oldLength:uint, newLength:uint):void {
			var char:String;
			for (var i:uint = oldLength;i < newLength;i++) {
				char = __text.charAt(i);
				createLetter(char);
			}
		}

		private function removeAdditionalLetters(oldLength:uint, newLength:uint):void {
			for (var i:int = oldLength - 1;i >= newLength;i--) {
				removeLetter(i);
			}
		}

		// Typography -----------------------------------------------------------------------------------
		private function setTypography():void {
			setLettersTypography();
		}

		private function setLettersTypography():void {
			var length:uint = __letters.length;
			var letter:CircularLetter;
			for (var i:uint = 0;i < length;i++) {
				letter = __letters[i];
				letter.typography = __typography;
			}
		}

		// Spacing Ratio -------------------------------------------------------------------------------
		private function setSpacingRatio():void {
			setLettersSpacingRatio();
		}

		private function setLettersSpacingRatio():void {
			var length:uint = __letters.length;
			var letter:CircularLetter;
			for (var i:uint = 0;i < length;i++) {
				letter = __letters[i];
				letter.spacingRatio = __spacingRatio;
			}
		}

		// Opening Ratio -------------------------------------------------------------------------------
		private function setOpeningRatio():void {
			setLettersOpeningRatio();
		}

		private function setLettersOpeningRatio():void {
			var length:uint = __letters.length;
			var letter:CircularLetter;
			for (var i:uint = 0;i < length;i++) {
				letter = __letters[i];
				letter.openingRatio = __openingRatio;
			}
		}

		// Size ---------------------------------------------------------------------------------------------
		private function setSize():void {
			setScaleFactor();
			setHeight();
			setLettersScaleFactor();
			__caret.height = __height;
		}

		private function setLettersScaleFactor():void {
			var length:uint = __letters.length;
			var letter:CircularLetter;
			for (var i:uint = 0;i < length;i++) {
				letter = __letters[i];
				letter.scaleFactor = __scaleFactor;
			}
		}

		// Initial Radius --------------------------------------------------------------------------------
		private function setInitialRadius():void {
			setLettersInitialRadius();
			__tutor.initialRadius = __initialRadius;
		}

		private function setLettersInitialRadius():void {
			var length:uint = __letters.length;
			var letter:CircularLetter;
			for (var i:uint = 0;i < length;i++) {
				letter = __letters[i];
				letter.initialRadius = __initialRadius;
			}
		}

		// Spiral Ratio ----------------------------------------------------------------------------------
		private function setSpiralRatio():void {
			setLettersSpiralRatio();
			__tutor.spiralRatio = __spiralRatio;
		}

		private function setLettersSpiralRatio():void {
			var length:uint = __letters.length;
			var letter:CircularLetter;
			for (var i:uint = 0;i < length;i++) {
				letter = __letters[i];
				letter.spiralRatio = __spiralRatio;
			}
		}

		// Render ----------------------------------------------------------------------------------------
		private function renderLetters():void {
			var beginAngle:Number = 0;
			var length:uint = __letters.length;
			var letter:CircularLetter;
			for (var i:uint = 0;i < length;i++) {
				letter = __letters[i];
				beginAngle = letter.render(beginAngle);
			}
		}

		// Reset ------------------------------------------------------------------------------------------
		private function resetIndicators():void {
			
			// Primary indicators
			__textChanged = false;
			__typographyChanged = false;
			__spacingRatioChanged = false;
			__openingRatioChanged = false;
			__sizeChanged = false;
			__initialRadiusChanged = false;
			__spiralRatioChanged = false;
		}

		//----------------------------------------------------------------------------------------------------
		// Workflow (style)
		//----------------------------------------------------------------------------------------------------
		private function setLettersTextNormalColor():void {
			var length:uint = __letters.length;
			var letter:CircularLetter;
			for (var i:uint = 0;i < length;i++) {
				letter = __letters[i];
				letter.textNormalColor = __textNormalColor;
			}
		}

		private function setLettersTextSelectedColor():void {
			var length:uint = __letters.length;
			var letter:CircularLetter;
			for (var i:uint = 0;i < length;i++) {
				letter = __letters[i];
				letter.textSelectedColor = __textSelectedColor;
			}
		}

		private function setLettersSelectionColor():void {
			var length:uint = __letters.length;
			var letter:CircularLetter;
			for (var i:uint = 0;i < length;i++) {
				letter = __letters[i];
				letter.selectionColor = __selectionColor;
			}
		}

		//----------------------------------------------------------------------------------------------------
		// Workflow (selection)
		//----------------------------------------------------------------------------------------------------
		private function setSelectionMouseDown():void {
			__beginIndex = getIndex();
			__selectionBeginIndex = __beginIndex;
			__selectionEndIndex = __beginIndex;
			__field.setSelection(__beginIndex, __beginIndex);
			setCaretPlacement(__beginIndex);
			__caret.display();
		}

		private function setSelectionMouseMove():void {
			var index:uint = getIndex();
			var beginIndex:uint = Math.min(__beginIndex, index);
			var endIndex:uint = Math.max(__beginIndex, index);
			__field.setSelection(beginIndex, endIndex);
			reflectSelection();
		}

		private function setSelectionFocusOut():void {
			if (__selectionBeginIndex == __selectionEndIndex) {
				__caret.hide();
			} else {
				clearLettersSelection();
			}
		}

		private function reflectSelection():void {
			var selectionBeginIndex:uint = __field.selectionBeginIndex;
			var selectionEndIndex:uint = __field.selectionEndIndex;
			if (selectionBeginIndex != __selectionBeginIndex || selectionEndIndex != __selectionEndIndex) {
				if (selectionBeginIndex == selectionEndIndex) {
					setCaretPlacement(selectionBeginIndex);
					if (__selectionBeginIndex != __selectionEndIndex) {
						clearLettersSelection();
						__caret.display();
					}
				} else {
					setLettersSelection(selectionBeginIndex, selectionEndIndex);
					if (__selectionBeginIndex == __selectionEndIndex) {
						__caret.hide();
					}
				}
				__selectionBeginIndex = selectionBeginIndex;
				__selectionEndIndex = selectionEndIndex;
			}
		}

		private function clearLettersSelection():void {
			var length:uint = __letters.length;
			var letter:CircularLetter;
			for (var i:uint = 0;i < length;i++) {
				letter = __letters[i];
				if (letter.selected) letter.selected = false;
			}
		}

		private function setLettersSelection(selectionBeginIndex:uint, selectionEndIndex:uint):void {
			var length:uint = __letters.length;
			var letter:CircularLetter;
			for (var i:uint = 0;i < length;i++) {
				letter = __letters[i];
				if (i >= selectionBeginIndex && i < selectionEndIndex) {
					if (!letter.selected) letter.selected = true;
				} else {
					if (letter.selected) letter.selected = false;
				}
			}
		}

		// Index -------------------------------------------------------------------------------------------
		private function getIndex():uint {
			var length:uint = __letters.length;
			if (length == 0) {
				return 0;
			} else {
				var mouseX:Number = __lettersContainer.mouseX;
				var mouseY:Number = __lettersContainer.mouseY;
				var angle:Number = (Math.atan2(mouseY, mouseX) + __PI25) % __PI2;
				var radius:Number = Math.sqrt(mouseX * mouseX + mouseY * mouseY);
				var lastLetter:CircularLetter = __letters[length - 1];
				var lastEndAngle:Number = lastLetter.endAngle;
				if (angle >= lastEndAngle && lastEndAngle < __PI2) {
					return (angle < lastEndAngle + (__PI2 - lastEndAngle) / 2) ? __letters.length : 0;
				} else {
					var indexedOverlaps:Vector.<CircularLetterIndexedOverlap> = new Vector.<CircularLetterIndexedOverlap>();
					var letter:CircularLetter;
					var overlap:CircularLetterOverlap;
					for (var i:int = length - 1;i >= 0;i--) {
						letter = __letters[i];
						overlap = letter.overlap(angle, radius);
						if (overlap.portion == CircularLetterOverlap.PORTION_MIDDLE) {
							return (overlap.side == CircularLetterOverlap.SIDE_LEFT) ? i : i + 1;
						} else {
							if (overlap.cone) {
								indexedOverlaps.push(new CircularLetterIndexedOverlap(i, overlap));
							}
						}
					}
					return getIndexFromIndexedOverlaps(indexedOverlaps);
				}
			}
		}

		private function getIndexFromIndexedOverlaps(indexedOverlaps:Vector.<CircularLetterIndexedOverlap>):uint {
			var length:uint = indexedOverlaps.length;
			var indexedOverlap:CircularLetterIndexedOverlap;
			var overlap:CircularLetterOverlap;
			for (var i:uint = 0;i < length;i++) {
				indexedOverlap = indexedOverlaps[i];
				overlap = indexedOverlap.overlap;
				if (overlap.portion == CircularLetterOverlap.PORTION_TOP || i == length - 1) {
					return (overlap.side == CircularLetterOverlap.SIDE_LEFT) ? indexedOverlap.index : indexedOverlap.index + 1;
				}
			}
			return 0;
		}

		// Caret -------------------------------------------------------------------------------------------
		private function setCaretPlacement(index:uint):void {
			var angle:Number = getEndAngleFromIndex(index);
			var radius:Number = getRadiusFromAngle(angle);
			__caret.x = Math.cos(angle - __PI_2) * radius;
			__caret.y = Math.sin(angle - __PI_2) * radius;
			__caret.rotation = angle * __RAD_TO_DEG;
		}

		// Zone -------------------------------------------------------------------------------------------
		private function setZoneRadius():void {
			__zone.radius = getPeakRadius() + __ZONE_ADDITION;
		}

		//----------------------------------------------------------------------------------------------------
		// Utils
		//----------------------------------------------------------------------------------------------------
		private function getPeakRadius():Number {
			if (__letters.length == 0) {
				return __initialRadius + __typography.getHeight() * __scaleFactor;
			} else {
				var letter:CircularLetter = __letters[__letters.length - 1];
				return letter.peakRadius;
			}
		}

		private function getEndAngleFromIndex(index:uint):Number {
			if (index == 0) {
				return 0;
			} else {
				var letter:CircularLetter = __letters[index - 1];
				return letter.endAngle;
			}
		}

		private function getRadiusFromAngle(angle:Number):Number {
			return __initialRadius + angle * __spiralRatio;
		}

		//----------------------------------------------------------------------------------------------------
		// Dispose
		//----------------------------------------------------------------------------------------------------
		public function dispose():void {
			disposeLetters();
			disposeElements();
		}

		private function disposeLetters():void {
			var length:uint = __letters.length;
			var letter:CircularLetter;
			for (var i:uint = 0;i < length;i++) {
				letter = __letters[i];
				letter.dispose();
			}
		}

		private function disposeElements():void {
			__caret.dispose();
		}
	}
}