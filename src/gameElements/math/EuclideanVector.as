package gameElements.math
{
	import flash.geom.Point;

	public class EuclideanVector
	{
		private var _position:Point;
		public var magnitude:Number;
		private var _angle:Number;
		private var _speed:Number=1;
		
		public function EuclideanVector($endPoint:Point,$speed:Number):void
		{
			position = $endPoint;
			speed($speed)
			
			
		}

		public function get position():Point
		{
			return _position;
		}

		public function set position(value:Point):void
		{
			_position = value;
			setAngle()
		}

		public function get angle():Number
		{
			return _angle;
		}

		public function inverse():EuclideanVector
		{
			return new EuclideanVector(new Point(-position.x, -position.y),_speed);
		}
		public function speed($number:Number):EuclideanVector
		{
			_speed = $number
			position.x *= $number;
			position.y *= $number;
			
			return this;
		}
		public function rotate(angleInRadians:Number):EuclideanVector
		{
			_angle = angleInRadians
			var newPosX:Number = (position.x * Math.cos(angleInRadians)) - (position.y * Math.sin(angleInRadians));
			var newPosY:Number = (position.x * Math.sin(angleInRadians)) + (position.y * Math.cos(angleInRadians));
			
			position.x = newPosX;
			position.y = newPosY;
			
			return this;
		}
		public function setSpeed($nb:Number):void
		{
			
		
		
		}
		private function setAngle():void
		{
			_angle = Math.atan2(position.y, position.x);
			
			if (_angle < 0)
			{
				_angle += Math.PI * 2;
			}
		
		
		}
	}
}