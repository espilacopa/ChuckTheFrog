package screens
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	public class Splash extends Sprite
	{
		public static const SCALE_MODE_NONE:String   = "none";
		public static const SCALE_MODE_ZOOM:String   = "zoom";
		public static const SCALE_MODE_LETTERBOX:String   = "letterbox";
		public static const SCALE_MODE_STRETCH:String   = "stretch";
		
		// Parameter Variables
		private var _listener:Function;
		private var _duration:int;
		private var _imageURL:String;
		private var _scaleMode:String;
		
		// loader, duh
		private var _imageLoader:Loader;
		
		// For scaling purposes
		private var _currentHeight:Number;
		private var _currentWidth:Number;
		private var _percent:Number;
		
		// _timer for our duration
		private var _timer:Timer;
		
		// Constructor
		public function Splash(imageURL:String, listener:Function, duration:int = 3000, scaleMode:String = Splash.SCALE_MODE_NONE)
		{
			// Set vars
			_imageURL = imageURL;
			_duration = duration;
			_scaleMode = scaleMode;
			_listener = listener;
			// Listen for when this is added
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		// Init
		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// Load the image
			_imageLoader = new Loader();
			_imageLoader.load(new URLRequest(_imageURL));
			_imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, addSplashImage)
			
			// Create a _timer for how long the Splash Screen stays on screen
			if(_duration>0){
				_timer = new Timer(_duration, 0);
				_timer.addEventListener(TimerEvent.TIMER, removeSplashScreen);
				_timer.start();
				
			}
		}
		
		// Add the image to the stage
		public function addSplashImage(e:Event):void
		{
			_imageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, addSplashImage);
			
			// Get and save the original width and height of the Image.
			_currentWidth = _imageLoader.width;
			_currentHeight = _imageLoader.height;
			
			// Run which function is set in the constructor
			switch (_scaleMode)
			{
				case SCALE_MODE_NONE:
					none();
					break;
				case SCALE_MODE_ZOOM:
					zoom();
					break;
				case SCALE_MODE_LETTERBOX:
					letterbox();
					break;
				case SCALE_MODE_STRETCH:
					stretch();
					break;
				
			}
			
			// Add the image to stage
			addChild(_imageLoader);
		}
		
		// None: doesn't scale the splash image
		private function none():void
		{
			imagePlacement();
		}
		
		// Zoom: scales the splash image based on the stage height
		private function zoom():void
		{
			_imageLoader.height = stage.stageHeight;
			_percent = _currentHeight / _imageLoader.height;
			_imageLoader.width = _currentWidth / _percent;
			imagePlacement();
			
		}
		
		// Letterbox: scales the splash image based on the stage width
		private function letterbox():void
		{
			_imageLoader.width = stage.stageWidth;
			_percent = _currentWidth / _imageLoader.width;
			_imageLoader.height = _currentHeight / _percent;
			imagePlacement();
		}
		
		// Stretch: scales both height and width to the stage width and height
		private function stretch():void
		{
			_imageLoader.width = stage.stageWidth;
			_imageLoader.height = stage.stageHeight;
			imagePlacement();
		}
		
		// Places the splash image in the center of the stage
		private function imagePlacement():void
		{
			_imageLoader.x = (stage.stageWidth - _imageLoader.width) * .5;
			_imageLoader.y = (stage.stageHeight - _imageLoader.height) * .5;
		}
		
		// Removes splash screen when _timer is done
		private function removeSplashScreen(e:TimerEvent):void
		{
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, removeSplashScreen);
			_listener.apply();
			_imageLoader.unloadAndStop();
			parent.removeChild(this);
		}
	}
}