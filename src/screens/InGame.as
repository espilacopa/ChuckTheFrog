package screens
{
	import events.GameEvent;
	import events.NavigationEvent;
	
	import gameElements.GameBackground;
	import gameElements.Hero;
	import gameElements.bugs.CloudFlies;
	import gameElements.powers.IPower;
	import gameElements.powers.PowerTongue;
	
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;

	public class InGame extends Sprite
	{
		private var _bg:GameBackground;
		private var _isHardwareRendering:Boolean;
		private var _hero:Hero;
		private var _fliesCloud:CloudFlies
		private var _currentPower:IPower
		
		private var _source:Quad
		private var _touch:Quad
		
		private var _level:XML
		public function InGame($level:XML)
		{
			_level = $level
			// Is hardware rendering?
			_isHardwareRendering = Starling.context.driverInfo.toLowerCase().indexOf("software") == -1;
			
			this.visible = false;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function set level(value:XML):void
		{
			_level = value;
		}

		/**
		 * On added to stage.  
		 * @param event
		 * 
		 */
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}
		private function drawGame():void
		{
			
			
			
			_currentPower = new PowerTongue()
			_bg = new GameBackground();
			this.addChild(_bg);
			
			_hero = new Hero();	
			this.addChild(_hero);
			
			var newHeight:Number =_hero.height
			if(_hero.height>(.4*stage.stageHeight)){
				newHeight = _hero.height = _hero.height/2
				_hero.width = _hero.width/2
			}
			_hero.y = stage.stageHeight -newHeight-10
		
			_hero.y = stage.stageHeight -_hero.height
			_fliesCloud = new CloudFlies(stage.stageWidth-300,stage.stageHeight,Number(_level.@nbFlies))
			_fliesCloud.x = 300;
			_fliesCloud.y =  stage.stageHeight/2 - _fliesCloud.height/2;
			_fliesCloud.active()
			addChild(_fliesCloud)
			_fliesCloud.addEventListener(GameEvent.HitFlie,tapFlie)
			_fliesCloud.addEventListener(GameEvent.AllFliesHit,endGame)
			
			_source = new Quad(3,3,0xff)
			_touch= new Quad(3,3,0xffff)
			addChild(_source)
			addChild(_touch)
		}
		
		private function tapFlie($event:Event):void
		{
			var px:Number = $event.data.globalX-(_hero.x+_hero.tongue.x ) ;
			var py:Number = $event.data.globalY-(_hero.y+_hero.tongue.y) ;
			_touch.x = $event.data.globalX
			_touch.y = $event.data.globalY	
				
			_source.x = 	_hero.x+_hero.tongue.x
			_source.y = 	_hero.y+_hero.tongue.y
			// rotation du trait vers la position de la souris
			var rad:Number = Math.atan2(py, px);// calcul de l'angle entre 2 points en radian
			var deg:Number = rad * (180 / Math.PI);// conversion en degrée
			// étirement du trait sur la position de la souris
			var dist:Number = Math.sqrt(px*px + py*py);// calcul de la distance entre 2 points
			_hero.shoot(dist,rad)
			_currentPower.usePower(_fliesCloud)
			
		}
		
		private function endGame($e:Event):void
		{
			trace("endGame")
			dispatchEventWith(NavigationEvent.CHANGE_SCREEN,true,{id:"score"})
		}
		public function initialize():void{
			
			drawGame();
		}
		public function disposeTemporarily():void
		{
			visible = false;
			if(_fliesCloud){
				_fliesCloud.unactive()
				_fliesCloud.removeEventListener(GameEvent.HitFlie,tapFlie)
			}
		}
		
		public function start():void
		{
			this.visible = true;
			_fliesCloud.active()
			_fliesCloud.addEventListener(GameEvent.HitFlie,tapFlie)
		}
		
		public function reset():void
		{
			init()
		}
		
		private function init():void
		{
			while (numChildren){
				removeChildAt(0)
			}
			_bg=null;
			_hero=null;
			_fliesCloud=null	
			_currentPower=null
			_source=null
			_touch=null
			drawGame()
		}
	}
}