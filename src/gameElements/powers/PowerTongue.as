package gameElements.powers
{
	import gameElements.bugs.ICloudFlies;

	public class PowerTongue extends Power implements IPower
	{
		
		public function PowerTongue()
		{
			super();
			_impactPower = 30
			_type = 1
		}
		override public function usePower($Cloud:ICloudFlies):void{
			var cloudA:Array = $Cloud.getHitFlies(_impactPower)
			$Cloud.destroyFlies(cloudA.splice(0,1))
		}
		override public function get impactPower():int
		{
			return _impactPower;
		}
	}
}