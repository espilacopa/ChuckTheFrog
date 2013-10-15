package circular.container {

	public class CircularLetterOverlap {

		public var cone:Boolean;
		public var portion:String;
		public var side:String;
		// Constants (portion) ------------------------------------------------------------------------
		public static const PORTION_TOP:String = "portionTop";
		public static const PORTION_MIDDLE:String = "portionMiddle";
		public static const PORTION_BOTTOM:String = "portionBottom";
		// Constants (side) ---------------------------------------------------------------------------
		public static const SIDE_LEFT:String = "sideLeft";
		public static const SIDE_RIGHT:String = "sideRight";

		public function CircularLetterOverlap(cone:Boolean, portion:String = null, side:String = null) {
			this.cone = cone;
			this.portion = portion;
			this.side = side;
		}
	}
}