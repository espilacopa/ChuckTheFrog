/**
 *
 * Chuck the Frog
 * http://www.espilacopa.com
 * 
 * Copyright (c) 2013 Ludovic Piquet. All rights reserved.
 * 
 *  
 */

package 
{
	import flash.display.Bitmap;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.Color;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
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
	//	[Embed(source="../media/fonts/1x/desyrel.fnt", mimeType="application/octet-stream")]
		//public static const DesyrelXml:Class;
		
		//[Embed(source = "../media/fonts/1x/desyrel.png")]
		//public static const DesyrelTexture:Class;
		
		[Embed(source="../media/levels.xml", mimeType="application/octet-stream")]
		public static const LevelsGameXML:Class;
		/**
		 * Background Assets 
		 */
		
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
		
		private static var _tabAssets:Array
		
		
		public static function get levels():XML
		{
			getLevels()
			return _levels;
		}
		private static function prepareAtlas():void
		{
			if (sTextureAtlas == null)
			{
				var texture:Texture =  Texture.fromBitmap(Bitmap(getAssets('atlas')), true, false);
				sTextureAtlas = new TextureAtlas(texture, XML(getAssets('atlasXml')));
				
			}
		}
		
		private static function getAssets($id:String):Object
		{
			var obj:Object
			var lg:int = _tabAssets.length
			for(var i:int=0;i<lg;i++){
				if(_tabAssets[i].id==$id) return _tabAssets[i].data
			}
			return null
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
		
		public static function setAsset($id:String,$obj:*):void{
			if(!_tabAssets)_tabAssets = new Array()
			_tabAssets.push({id:$id,data:$obj})
		}
		
		public static function getSound(name:String):Sound
		{
			
			var sound:Sound = sSounds[name] as Sound;
			if (sound) return sound;
			else throw new ArgumentError("Sound not found: " + name);
			
			return null
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
			
				var data:Object = getAssets(name);
				var tex:Texture
				if (data is Bitmap)
					tex = Texture.fromBitmap(data as Bitmap, true, false);
				else if (data is ByteArray)
					tex = Texture.fromAtfData(data as ByteArray);
			
			
			return tex;
			
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
			return [name];
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
		
		public static function factoryText($with:int, $heitgh:int, $text:String, $font:String, $size:int, $color:uint, $Halign:String,$VAlign:String):TextField
		{
			
			trace($with+"  "+$heitgh+"  "+$text+"  "+$font+"  "+$size+"  "+$color+"  "+$Halign+"  "+$VAlign)
			var textField:TextField = new TextField($with, $heitgh, $text, $font, $size, $color);
			
			textField.hAlign = HAlign.RIGHT;  // horizontal alignment
			//textField.border = true;
			var offset:int = 10;
			var ttFont:String = "Ubuntu";
			var ttFontSize:int = 19; 
			
			var colorTF:TextField = new TextField(300, 80, 
				"TextFields can have a border and a color. They can be aligned in different ways, ...", 
				ttFont, ttFontSize);
			colorTF.x = colorTF.y = offset;
			colorTF.border = true;
			colorTF.color = 0x333399;
			
			return textField
		}
	}
}
