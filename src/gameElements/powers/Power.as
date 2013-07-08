package gameElements.powers
{
	import gameElements.bugs.ICloudFlies;

	public class Power implements IPower
	{
		protected var _impactPower:int
		protected var _type:int
		public function Power()
		{
		}
		
		public function get type():int
		{
			return _type;
		}

		public function get impactPower():int
		{
			return _impactPower;
		}

		public function usePower($Cloud:ICloudFlies):void
		{
		}
	}
}