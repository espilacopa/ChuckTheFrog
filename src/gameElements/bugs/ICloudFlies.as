package gameElements.bugs
{
	import starling.events.Touch;

	public interface ICloudFlies
	{
		function getHitFlies($impactPower:int):Array
		function destroyEnnemies($array:Array):void
		function destroyFlies($array:Array):void
	}
}