package gameElements.bugs
{
	import events.GameEvent;
	
	import gameElements.ennemies.Flie;
	import gameElements.ennemies.IEnnemies;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class CloudFlies extends Sprite implements ICloudFlies
	{
		private var _tabFlies:Array 
		private var _tabEnemies:Array 
		private var _width:int;
		private var _height:int;
		private var _touchTest:Quad
		private var _hitZone:Number = 5
		private var _touch: Touch
		
		protected var _enable: Boolean = true;
		protected var _isPressed: Boolean;
		protected var _isRolledOver: Boolean;
		
		public function CloudFlies($with:int,$height:int,$nbFlies:int = 0)
		{
			
			super();
			_width = $with - $with*.08
			_height = $height-$height*.08
			_tabFlies = new Array()
			if ($nbFlies)addFlies($nbFlies)
			_touchTest = new Quad(_width,_height)
			_touchTest.alpha =0.1
			addChild(_touchTest)
			
		}

		public function get touch():Touch
		{
			return _touch;
		}

		public function destroyEnnemies($array:Array):void{
			var flie:IEnnemies
			
		}
		
		public function destroyFlies($array:Array):void{
			var flie:Sprite
			var indx:int
			for(var i:int=0;i<$array.length;i++){
				indx = _tabFlies.lastIndexOf($array[i])
				flie = (_tabFlies[indx] as Sprite)
				removeChild(flie)
				_tabFlies.splice(indx,1)
			}
			if(!_tabFlies.length)dispatchEventWith(GameEvent.AllFliesHit)
		}
		public function getHitFlies($impactPower:int):Array
		{
			var tab:Array = new Array()
			var flie:Sprite
			for(var i:int=0;i<_tabFlies.length;i++){			
				flie = (_tabFlies[i] as Sprite)
				if(flie.x>(_touch.getLocation(this).x-$impactPower) && flie.x<(_touch.getLocation(this).x+$impactPower) && flie.y>(_touch.getLocation(this).y-$impactPower) && flie.y<(_touch.getLocation(this).y+$impactPower)){
					tab.push(flie)
				}
			}
			return tab
		}
		
		public function getHitEnemie($impactPower:int):Array
		{
			var tab:Array = new Array()
			var ennemie:Sprite
			for(var i:int=0;i<_tabFlies.length;i++){	
				ennemie = (_tabEnemies[i] as Sprite)
				if(ennemie.x>(_touch.getLocation(this).x-$impactPower) && ennemie.x<(_touch.getLocation(this).x+$impactPower) && ennemie.y>(_touch.getLocation(this).y-$impactPower) && ennemie.y<(_touch.getLocation(this).y+$impactPower)){
					tab.push(ennemie)
				}
			}
			return tab
		}

		public function active():void
		{		
			addEventListener(Event.ENTER_FRAME,move)
			_touchTest.addEventListener(TouchEvent.TOUCH,onTouchHandler)
		}
		public function unactive():void
		{		
			removeEventListener(Event.ENTER_FRAME,move)
			_touchTest.removeEventListener(TouchEvent.TOUCH,onTouchHandler)
		}
		private function move($e:Event):void
		{
			var flie:Flie 
			for(var i:int=0;i<_tabFlies.length;i++){
				flie = (_tabFlies[i] as Flie)
				if(Math.random()*2>Math.random()*7)flie.vectorDir.rotate( (Math.random()*(flie.vectorDir.angle+flie.angle))+(flie.vectorDir.angle-flie.angle))
				flie.x += flie.vectorDir.position.x
				flie.y += flie.vectorDir.position.y
				var test:Boolean = false
				if(flie.x<0){flie.x=0;
					flie.vectorDir.inverse()} 
				if(flie.x>_width){flie.x=_width;
					flie.vectorDir.inverse()}
				if(flie.y>_height){flie.y=_height;
					flie.vectorDir.inverse()}
				if(flie.y<0){flie.y=0;
					flie.vectorDir.inverse()}
				
			}
			
		}
		protected function onTouchHandler(event: TouchEvent): void {
			_touch = event.getTouch(this);
			if (_touch) {
				switch (_touch.phase) {
					case TouchPhase.HOVER:                                      // roll over
					{
						if (_isRolledOver) {
							return;
						}
						_isRolledOver = true;
						
						break;
					}
						
					case TouchPhase.BEGAN:                                      // press
					{
						if (_isPressed) {
							return;
						}
						_isPressed = true;
						break;
					}
						
					case TouchPhase.ENDED:                                      // click
					{
						_isPressed = false;
						dispatchEventWith(GameEvent.HitFlie,true,_touch)
						
						break;
					}
						
					default :
					{
						
					}
				}
			} else {
				_isRolledOver = false;
			}
		}
		
		
		public function addFlies($nbFlies:int):void
		{
			var flie : Flie 
			for(var i:int=0;i<$nbFlies;i++){
				flie = new Flie((_tabFlies.length + 1))
				flie.x = Math.random()*_width
				flie.y = Math.random()*_height
				_tabFlies.push(flie)
				addChild(flie)
			}
		}
	}
}