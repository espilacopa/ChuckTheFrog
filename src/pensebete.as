package
{
	import flash.geom.Point;

	public class pensebete
	{
		public function pensebete()
		{
			
			
			
			
			
			
			
		}
		private var _maxWith:int = 2048
		private var _maxHeight:int = 2048
		private var _grid:Array = new Array()
		private var _nextFreePix:Point = new Point()
		private var _arrayImage:Array
		private var _currentBit:Point = new Point()
		private var _stop:Boolean = false;
		private function init():void
		{
			for(var i:int=0; i<_arrayImage.length; i++){
				
				while( !checkSpace(_currentBit,_arrayImage[i]) || _stop ) {
					_arrayImage[i].coord = _nextFreePix;
				}
			}
		}	
		private function checkSpace($start:Point,$size:Point):Boolean
		{
			if(($start.x+$size.x)>_maxWith){
				_currentBit.y++
				return false
			}
			if(($start.y+$size.y)>_maxHeight)_stop = true
			for (var i:int=$start.y; i<$size.y; i++){
				for (var j:int=$start.x; j<$size.x; j++){
					if(_grid[i][j]){
						_currentBit.x += j
						return false
					}
				}
			}
			return true
		}
	}
}