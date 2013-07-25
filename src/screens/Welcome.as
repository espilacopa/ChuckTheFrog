package screens
{
	import flash.media.SoundMixer;
	
	import events.NavigationEvent;
	
	import gameElements.bugs.CloudFlies;
	
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Welcome extends Sprite
	{
		private var _bg:Image;
		private var _playBtn:Button;
		private var _screnMode:String;
		private var _fly:MovieClip;
		public function Welcome()
		{
			super();
			this.visible = false;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		/**
		 * On added to stage. 
		 * @param event
		 * 
		 */
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			drawScreen();
		}
		
		/**
		 * Draw all the screen elements. 
		 * 
		 */
		private function drawScreen():void
		{
			
			_bg = new Image(Assets.getTexture("Background"));
			
			
			_bg.blendMode = BlendMode.NONE;
			this.addChild(_bg);
			_bg.width = stage.stageWidth
			
			_bg.height = stage.stageHeight			
			_playBtn = new Button(Assets.getAtlasTexture("FrogStart0000"));
			trace(_playBtn.height)
			//ratio = _playBtn.width/_playBtn.height
			//_playBtn.width = _bg.width/3
			//_playBtn.height = _playBtn.width /ratio
			_playBtn.x = stage.stageWidth/2 - _playBtn.width/2;
			_playBtn.y =  stage.stageHeight/2 - _playBtn.height/2;
			_playBtn.addEventListener(Event.TRIGGERED, onPlayClick);
			this.addChild(_playBtn);
			
			var fliesCloud:CloudFlies = new CloudFlies(100,100,3)
			
			fliesCloud.x = stage.stageWidth/2 - fliesCloud.width/2;
			fliesCloud.y =  stage.stageHeight/2 - fliesCloud.height/2;

				fliesCloud.active()
			addChild(fliesCloud)
			
			dispatchEventWith(NavigationEvent.WELCOMREADY,true)
			
		}
		private function onPlayClick(event:Event):void
		{
			dispatchEventWith(NavigationEvent.CHANGE_SCREEN, true,{id: "play"});
		}
		public function initialize():void{
			disposeTemporarily();
			visible = true;
			_screnMode = "welcome";
			this.addEventListener(Event.ENTER_FRAME, floatingAnimation);
		}
		public function disposeTemporarily():void
		{
			visible = false;
			
			if (this.hasEventListener(Event.ENTER_FRAME)) this.removeEventListener(Event.ENTER_FRAME, floatingAnimation);
			
			//if (screenMode != "about") SoundMixer.stopAll();
		}
		private function floatingAnimation(event:Event):void
		{
			
			
		}
	}
}