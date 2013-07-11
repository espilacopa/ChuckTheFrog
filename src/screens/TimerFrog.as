package screens
{
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class TimerFrog extends Sprite
	{
		private var _bkg:Image;
		public function TimerFrog()
		{
			super();
			_bkg = new Image(Assets.getAtlasTexture("bkgTimer0000"))
			this.addChild(_bkg);
		}
	}
}