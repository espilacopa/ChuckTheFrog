package gameElements.ennemies
{
	import flash.geom.Point;
	
	import gameElements.math.EuclideanVector;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;

	public class Flie extends Sprite implements IEnnemies
	{
		
		private var _flie:MovieClip;
		private var _vectorDir:EuclideanVector
		private var _id:int;
		private var _angle:Number
		private var _speed:int = 10
		
		public function Flie($id:int)
		{
			_id = $id
			_angle = (Math.random()*(Math.PI/100000))
			_vectorDir = new EuclideanVector(new Point(0.5,0.5),(Math.random()*4+Math.random()))
			_flie = new MovieClip(Assets.getAtlasTextures("fly"), 2);
			starling.core.Starling.juggler.add(_flie)
			this.addChild(_flie);
		}
		
		public function destroy():void
		{
			
		}
		public function get id():int
		{
			return _id;
		}

		public function get angle():Number
		{
			return _angle/2;
		}

		public function get vectorDir():EuclideanVector
		{
			return _vectorDir;
		}

		public function set vectorDir(value:EuclideanVector):void
		{
			_vectorDir = value;
		}

	}
}