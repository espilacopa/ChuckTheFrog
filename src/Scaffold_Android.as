package
{
    import flash.desktop.NativeApplication;
    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.geom.Rectangle;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.utils.ByteArray;
    
    import screens.Splash;
    
    import starling.core.Starling;
    
    [SWF(frameRate="60", backgroundColor="#000")]
    public class Scaffold_Android extends Sprite
    {
        private var _mStarling:Starling;
		private var _splash:Splash;
		private var stream:FileStream;
		private var file:File;
        public function Scaffold_Android()
        {
            // set general properties
            
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            
            Starling.multitouchEnabled = true;  // useful on mobile devices
            Starling.handleLostContext = true;  // required on Android
            
			
			// Add a _splash Screen
			/*
			parameters are ("image URL", listener function, duration in millisecond to display, scaleMode)
			image URL and listener function are required
			duration and scaleMode are optional
			duration options:
			defaults to 1000 milliseconds
			scaleMode options:
			SCALE_MODE_NONE = default and should be obvious
			SCALE_MODE_STRETCH = scale to full width and height
			SCALE_MODE_ZOOM = scale to height
			SCALE_MODE_LETTERBOX = scale to width
			*/
			
			_splash = new Splash("Default-Portrait.png", keepGoing, 5000, Splash.SCALE_MODE_NONE);
			addChild(_splash);
			
			
			
			var fileName:String="frog.png";
			var urlLoader:URLLoader;
			var url:String = "http://www.v-ro.com/cat.jpeg";
			
			var prefsFile:File = File.applicationStorageDirectory; 
			prefsFile = prefsFile.resolvePath("preferences.xml");
			trace(prefsFile.exists)

			file = File.applicationStorageDirectory;
			file = file.resolvePath(fileName);
			var ext:Boolean = file.exists
				trace(ext)
			
			
           	var screenWidth:int  = stage.fullScreenWidth;
			var screenHeight:int = stage.fullScreenHeight;
			var viewPort:Rectangle = new Rectangle();
			
			if (screenHeight / screenWidth < Constants.ASPECT_RATIO)
			{
				viewPort.height = screenHeight;
				viewPort.width  = int(viewPort.height / Constants.ASPECT_RATIO);
				viewPort.x = int((screenWidth - viewPort.width) / 2);
			}
			else
			{
				viewPort.width = screenWidth; 
				viewPort.height = int(viewPort.width * Constants.ASPECT_RATIO);
				viewPort.y = int((screenHeight - viewPort.height) / 2);
			}
			// Set up Starling
			
			_mStarling = new Starling(Game, stage, viewPort);
            
        }
		private function onLocal(event:Event):void {
			event.currentTarget.removeEventListener(Event.COMPLETE, onLocal);
			addChild(event.currentTarget.content);
		}
		private function onRemote(event:Event):void {
			event.target.removeEventListener(Event.COMPLETE, onRemote);
			var byteArray:ByteArray = event.target.data as ByteArray;
			stream.open(file, FileMode.WRITE);
			stream.writeBytes(byteArray, 0, byteArray.length);
			stream.close();
			var loader:Loader = new Loader();
			loader.loadBytes(byteArray);
			addChild(loader);
		}
		private function keepGoing():void
		{
			
			_mStarling.start();
			
			
			// When the game becomes inactive, we pause Starling; otherwise, the enter frame event
			// would report a very long 'passedTime' when the app is reactivated. 
			
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, 
				function (e:Event):void { _mStarling.start(); });
			
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, 
				function (e:Event):void { _mStarling.stop(); });
		}
    }
}





