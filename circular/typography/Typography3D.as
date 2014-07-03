package typography {

	/**
	 * The Typography3D class is the base class for all typography 3D objects that can be used to display text.
	 */
	public class Typography3D {

		protected var motifs:Object = {};
		protected var widths:Object = {};
		protected var height:Number;

		/**
		 * Returns the motif (drawing instructions) of a character.
		 * 
		 * @param char	The character of which the motif will be returned.
		 */
		public function getMotif(char:String):Array {
			return motifs[char];
		}

		/**
		 * Returns the width of a character.
		 * 
		 * @param char	The character of which the width will be returned.
		 */
		public function getWidth(char:String):Number {
			return widths[char];
		}

		/**
		 * Returns the Typography3D instance line height.
		 */
		public function getHeight():Number {
			return height;
		}
	}
}