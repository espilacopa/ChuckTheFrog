/**
 *
 * Hungry Hero Game
 * http://www.hungryherogame.com
 * 
 * Copyright (c) 2012 Hemanth Sharma (www.hsharma.com). All rights reserved.
 * 
 * This ActionScript source code is free.
 * You can redistribute and/or modify it in accordance with the
 * terms of the accompanying Simplified BSD License Agreement.
 *  
 */

package 
{
	import flash.display.Bitmap;
	import flash.media.Sound;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * This class holds all embedded textures, fonts and sounds and other embedded files.  
	 * By using static access methods, only one instance of the asset file is instantiated. This 
	 * means that all Image types that use the same bitmap will use the same Texture on the video card.
	 * 
	 * @author hsharma
	 * 
	 */
	public class Assets
	{
		/**
		 * Texture Atlas 
		 */
		[Embed(source="../media/graphics/frog.png")]
		public static const AtlasGameTexture:Class;
		
		[Embed(source="../media/graphics/frog.xml", mimeType="application/octet-stream")]
		public static const AtlasGameXML:Class;
		/**
		 * Texture Atlas 
		 */
		[Embed(source="../media/levels.xml", mimeType="application/octet-stream")]
		public static const LevelsGameXML:Class;
		/**
		 * Background Assets 
		 */
		
		
		[Embed(source="../media/graphics/bgWelcome.jpg")]
		public static const BgWelcome:Class;
		
		// true type fonts
		
		[Embed(source="../media/fonts/Ubuntu-R.ttf", embedAsCFF="false", fontFamily="Ubuntu")]        
		private static const UbuntuRegular:Class;
		
		// sounds
		
		[Embed(source="../media/audio/click.mp3")]
		private static const Click:Class;
		
		private static var sContentScaleFactor:int = 1;
		/**
		 * Texture Cache 
		 */
		
		private static var sTextures:Dictionary = new Dictionary();
		private static var sTextureAtlas:TextureAtlas;
		private static var sSounds:Dictionary = new Dictionary();
		private static var _levels:XML;
		private static var sBitmapFontsLoaded:Boolean;
		
		public static function get levels():XML
		{
			getLevels()
			return _levels;
		}

		private static function prepareAtlas():void
		{
			if (sTextureAtlas == null)
			{
				var texture:Texture = getTexture("AtlasGameTexture");
				var xml:XML = XML(create("AtlasGameXML"));
				sTextureAtlas = new TextureAtlas(texture, xml);
			}
		}
		private static function getLevels():void
		{
			if (_levels == null)
			{
				var ba:ByteArray = (new LevelsGameXML()) as ByteArray;
				var s:String = ba.readUTFBytes( ba.length );
				_levels = new XML( s );
				
			}
		}
		
		public static function getSound(name:String):Sound
		{
			var sound:Sound = sSounds[name] as Sound;
			if (sound) return sound;
			else throw new ArgumentError("Sound not found: " + name);
		}
		
		public static function loadBitmapFonts():void
		{
			if (!sBitmapFontsLoaded)
			{
				var texture:Texture = getTexture("DesyrelTexture");
				var xml:XML = XML(create("DesyrelXml"));
				TextField.registerBitmapFont(new BitmapFont(texture, xml));
				sBitmapFontsLoaded = true;
			}
		}
		
		public static function prepareSounds():void
		{
			sSounds["Click"] = new Click();   
		}
		/**
		 * Returns a texture from this class based on a string key.
		 * 
		 * @param name A key that matches a static constant of Bitmap type.
		 * @return a starling texture.
		 */
		public static function getTexture(name:String):Texture
		{
			if (sTextures[name] == undefined)
			{
				var data:Object = create(name);
				
				if (data is Bitmap)
					sTextures[name] = Texture.fromBitmap(data as Bitmap, true, false, sContentScaleFactor);
				else if (data is ByteArray)
					sTextures[name] = Texture.fromAtfData(data as ByteArray, sContentScaleFactor);
			}
			
			return sTextures[name];
		}
		
		public static function getAtlasTexture(name:String):Texture
		{
			prepareAtlas();
			return sTextureAtlas.getTexture(name);
		}
		
		public static function getAtlasTextures(prefix:String):Vector.<Texture>
		{
			prepareAtlas();
			return sTextureAtlas.getTextures(prefix);
		}
		private static function create(name:String):Object
		{
			var textureClass:Class = sContentScaleFactor == 1 ? AssetEmbeds_1x : AssetEmbeds_2x;
			return new textureClass[name];
		}
		public static function get contentScaleFactor():Number { return sContentScaleFactor; }
		public static function set contentScaleFactor(value:Number):void 
		{
			for each (var texture:Texture in sTextures)
			texture.dispose();
			sTextures = new Dictionary();
			trace('sContentScaleFactor '+sContentScaleFactor)
			sContentScaleFactor = value < 1.5 ? 1 : 2; // assets are available for factor 1 and 2 
		}
	}
}
