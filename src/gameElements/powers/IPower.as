package gameElements.powers
{
	import gameElements.bugs.ICloudFlies;

	public interface IPower
	{
		function get type():int;
		function get impactPower():int;
		function usePower($Cloud:ICloudFlies):void;
	}
}