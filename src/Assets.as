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
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
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
		private static var _loader:URLLoader;
		private static var _xml:XML;
		private static var _png:Bitmap;
		private static var _BgLayer1:Bitmap;
		private static var _BgLayer2:Bitmap;
		private static var _BgLayer3:Bitmap;
		private static var _Background:Bitmap;
		private static var _Loading:Bitmap;
		
		
		public static function set BgLayer1(value:Bitmap):void
		{
			_BgLayer1 = value;
		}

		public static function set BgLayer2(value:Bitmap):void
		{
			_BgLayer2 = value;
		}

		public static function set BgLayer3(value:Bitmap):void
		{
			_BgLayer3 = value;
		}

		public static function set Background(value:Bitmap):void
		{
			_Background = value;
		}

		public static function set Loading(value:Bitmap):void
		{
			_Loading = value;
		}

		public static function set atlas(value:Bitmap):void
		{
			_png = value;
			
		}

		public static function set atlasXml(value:XML):void
		{
			_xml = value;
		}

		public static function get levels():XML
		{
			getLevels()
			return _levels;
		}
		private static function prepareAtlas():void
		{
			if (sTextureAtlas == null)
			{
				var texture:Texture =  Texture.fromBitmap(_png, true, false);
				sTextureAtlas = new TextureAtlas(texture, _xml);
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
					sTextures[name] = Texture.fromBitmap(data as Bitmap, true, false);
				else if (data is ByteArray)
					sTextures[name] = Texture.fromAtfData(data as ByteArray);
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
			var textureClass:Class
			trace("create "+name+" "+sContentScaleFactor)
			switch(sContentScaleFactor){
				case 1:
					textureClass =AssetEmbeds_1x
					break;
				case 2:
					textureClass =AssetEmbeds_2x
					break;
				case 3:
					textureClass =AssetEmbeds_3x
					break
			}
			return new textureClass[name];
		}
		public static function get contentScaleFactor():Number { return sContentScaleFactor; }
		public static function set contentScaleFactor(value:Number):void 
		{
			for each (var texture:Texture in sTextures)
			texture.dispose();
			sTextures = new Dictionary();
			trace('sContentScaleFactor '+value)
			sContentScaleFactor = value; // assets are available for factor 1 and 2 amd 3
		}
	}
}
