/**
 *
 * Frog Game
 * http://www.hungryherogame.com
 * 
 * Copyright (c) 2013 Espilacopa (www.espilacopa.com). All rights reserved.
 * 
 * This ActionScript source code is free.
 * You can redistribute and/or modify it in accordance with the
 * terms of the accompanying Simplified BSD License Agreement.
 *  
 */

package gameElements
{
	import flash.geom.Rectangle;
	
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	
	
	/**
	 * This class is the hero character.
	 *  
	 * @author ludo
	 * 
	 */
	public class Hero extends Sprite
	{
		/** Hero character animation. */
		private var heroArt:MovieClip;
		
		private var _tongue:Scale9Image;
		
		
		/** State of the hero. */
		private var _state:int;
		private var _speedTongue:Number = 50
		private var _bkg:Image;
		private var _initT:Number;
		private var _distT:Number;
		
		public function Hero()
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function get tongue():Scale9Image
		{
			return _tongue;
		}

		/**
		 * On added to stage. 
		 * @param event
		 * 
		 */
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			
			// Initialize hero art and hit area.
			createHeroArt();
		}
		
		/**
		 * Create hero art/visuals. 
		 * 
		 */
		private function createHeroArt():void
		{
			_bkg = new Image(Assets.getAtlasTexture("nenuphare0000"))
			this.addChild(_bkg);
			_tongue = new Scale9Image(new Scale9Textures(Assets.getAtlasTexture("tongue0000"),new Rectangle(40,0,1,43)));
			_tongue.alpha =0
			_initT = _tongue.width
			_tongue.pivotX=40
			this.addChild(_tongue);
			
			heroArt = new MovieClip(Assets.getAtlasTextures("FrogGame"), 2);
			starling.core.Starling.juggler.add(heroArt);
			heroArt.stop()
			_bkg.x =-_bkg.width*.2	
			_bkg.y=heroArt.height-_bkg.height*.8
			this.addChild(heroArt);
			_tongue.x = heroArt.width*.75;
			_tongue.y = heroArt.height*.35;
		}
		
		/**
		 * State of the hero. 
		 * @return 
		 * 
		 */
		public function get state():int { return _state; }
		
		public function shoot($dist:Number,$ang:Number):void{
			_tongue.visible = true
			_distT = $dist+_tongue.pivotX+_tongue.x
			_tongue.width = _distT
			_tongue.rotation = $ang
			heroArt.currentFrame = 1		
			addEventListener(Event.ENTER_FRAME,moveTongue)
		}
		
		private function moveTongue($e:Event):void
		{
			_tongue.width -= _speedTongue
			_tongue.alpha =	_tongue.width/_distT+.1	
				if(_tongue.width<20){
					_tongue.visible = false
					heroArt.currentFrame = 0
					removeEventListener(Event.ENTER_FRAME,moveTongue)	
				
				}
		}
		
		/**
		 * Set hero animation speed. 
		 * @param speed
		 * 
		 */
		public function setHeroAnimationSpeed(speed:int):void {
			if (speed == 0) heroArt.fps = 20;
			else heroArt.fps = 60;
		}

		override public function get width():Number
		{
			if (heroArt) return heroArt.texture.width;
			else return NaN;
		}

		override public function get height():Number
		{
			if (heroArt) return heroArt.texture.height;
			else return NaN;
		}
	}
}