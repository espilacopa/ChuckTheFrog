package circular.container {

	public class CircularLetterIndexedOverlap {

		public var index:uint;
		public var overlap:CircularLetterOverlap;

		public function CircularLetterIndexedOverlap(index:uint, overlap:CircularLetterOverlap) {
			this.index = index;
			this.overlap = overlap;
		}
	}
}