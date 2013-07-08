package 
{
    import events.NavigationEvent;
    
    import screens.InGame;
    import screens.Welcome;
    
    import starling.core.Starling;
    import starling.display.Sprite;
    import starling.events.Event;

    public class Game extends Sprite
    {
		private var _screenWelcome:Welcome;
		private var _screenInGame:InGame;
		private var _levelId:int=0
			
        
        public function Game()
        {
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        }
        
        private function onAddedToStage(event:Event):void
        {
            init();
        }
		
        private function init():void
        {
            // we create the game with a fixed stage size -- only the viewPort is variable.
            stage.stageWidth  = Constants.STAGE_WIDTH;
            stage.stageHeight = Constants.STAGE_HEIGHT;
            
            // the contentScaleFactor is calculated from stage size and viewport size
            Assets.contentScaleFactor = Starling.current.contentScaleFactor;
			// InGame screen.
			
			_screenInGame = new InGame((Assets.levels.level.(id=="0") as XML));
			this.addChild(_screenInGame);
			// Welcome screen.
			addEventListener(NavigationEvent.WELCOMREADY, chargeNext)
			_screenWelcome = new Welcome();
			this.addChild(_screenWelcome);
			_screenWelcome.initialize();
		}
		
		private function chargeNext($e:Event):void
		{
			addEventListener(NavigationEvent.CHANGE_SCREEN, onInGameNavigation);
			removeEventListener(NavigationEvent.WELCOMREADY, chargeNext)
			_screenInGame.initialize();
			// TODO Auto Generated method stub
			
		}
		private function onInGameNavigation($event:Event):void
		{
			trace("onInGameNavigation"+$event.data.id)
			switch ($event.data.id){
				case "play":{
					_screenWelcome.disposeTemporarily();
					_screenInGame.start();
					break
				}
				case "score":{				
					_screenInGame.disposeTemporarily();
					_screenInGame.level = Assets.levels.level.(id=="0")[0]
					_screenInGame.reset()
					_screenWelcome.initialize();
					break
				}
				
			}
			
		}
		
        
    }
}