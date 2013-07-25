package utils
{
	import com.adobe.images.JPGEncoder;
	import com.adobe.images.PNGEncoder;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.CompressionAlgorithm;
	
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	
	
	public class LoaderAssets extends Sprite
	{
		[Embed(source="../../media/graphics/assets.xml", mimeType="application/octet-stream")]
		public static const AssetsXML:Class;
		
		public static const COMPLETE:String = "Complite";
		private static var _i:int;
		private var _loaderS:Object;
		private var _xml:XML;
		public function LoaderAssets()
		{
			super()
			checkAsset()
			
			
		}
		private function checkAsset():void
		{
			var imageDirectory:File = File.applicationStorageDirectory.resolvePath("atlas");
			var ba:ByteArray = (new AssetsXML()) as ByteArray;
			var s:String = ba.readUTFBytes( ba.length );
			_xml = new XML( s );
			
			if (imageDirectory.exists)
			{
				trace("Directory Already Exists "+imageDirectory.url);
				var file:File = File.documentsDirectory;
				var fileStream:FileStream = new FileStream();
				
				
				for each (var asset:XML in _xml.asset) {
					trace(asset.toXMLString()); 
					file =  File.applicationStorageDirectory.resolvePath( "atlas/"+asset.@name );
					
					try {
						fileStream.open(file, FileMode.READ);
						trace("ok")
						switch(String(asset.@type)){
							case "png": 
							case "jpg":
								trace("img")
								var bitArray:ByteArray = new ByteArray()
								Assets[asset.@id]=getAssets(asset.@name,bitArray)
								break
							case "xml": 
								var str:String = fileStream.readMultiByte(file.size, File.systemCharset);
								Assets[asset.@id]=new XML(str);
								break
						}
						trace("done")
					}
					catch(e:Error){
						trace("no file "+e)
						if(!_loaderS){
							_loaderS = new BulkLoader("main-site");
							_loaderS.addEventListener(BulkLoader.COMPLETE, onAllItemsLoaded);
							_loaderS.addEventListener(BulkLoader.PROGRESS, onAllItemsProgress);
						}
						_loaderS.add("http://www.espilacopa.com/"+Assets.contentScaleFactor+"x/"+asset.@name, {id:asset.@id});
					}
				}
				
				
				if(_loaderS)_loaderS.start()
				
				
				fileStream.close();
			}
			else {
				imageDirectory.createDirectory();
				trace("no directory "+imageDirectory.nativePath);
				checkAsset()
			}	
		}
		public function onAllItemsLoaded(evt : Event) : void{
			trace("every thing is loaded!");
			var byteA:ByteArray
			for each (var asset:XML in _xml.asset) {
				trace(_loaderS.getBitmap(asset.@id))
				switch(String(asset.@type)){
					case "png": 
						byteA = PNGEncoder.encode(_loaderS.getBitmap(asset.@id).bitmapData);
						recordAssets(asset.@name,byteA)
						break
					case "jpg":
						var encoder:JPGEncoder = new JPGEncoder();
						byteA = encoder.encode(_loaderS.getBitmap(asset.@id).bitmapData)
						recordAssets(asset.@name,byteA)
						break
					case "xml": 
						byteA.writeObject(_loaderS.getXML(asset.@id)); 
						byteA.position = 0;        //reset position to beginning 
						byteA.compress(CompressionAlgorithm.DEFLATE); 
						recordAssets(asset.@name,byteA)
						break
				}
			}
			
			checkAsset()
			//dispatchEvent(new Event(COMPLETE));
		}
		
		
		private function onAllItemsProgress(evt : BulkProgressEvent) : void{
			trace(evt.loadingStatus());
		}
		private function getBitmap(data:ByteArray):Bitmap
		{
			var converter:Loader = new Loader(); 
			converter.loadBytes(data);
			var bmp:Bitmap = converter.content as Bitmap;
			return bmp;
		}
		
		
		private function ioErrorHandlerPng($e:Event):void
		{
			trace($e)
		}
		
		
		
		private function arrived():void
		{
			_i ++
				if(_i>1){
				//	dispatchEvent(new Event(COMPLETE));
				}
		}
		private function recordAssets($name:String, $file:ByteArray):void
		{
			trace($name)
			var file:File = File.applicationStorageDirectory.resolvePath( "atlas/"+$name );
			var wr:File = new File( file.nativePath );
			trace("rec "+file.nativePath)
			var stream:FileStream = new FileStream();
			stream.open( wr , FileMode.WRITE);
			try {
				stream.writeBytes ( $file, 0,$file.length );
			}
			catch(e:Error){
				trace("no recording")
			}
			stream.writeBytes ( $file, 0,$file.length );
			stream.close();
		}
		private function getAssets(fileName:String, data:ByteArray):void 
		{ 
			trace("get "+fileName)
			var inFile:File = File.applicationStorageDirectory.resolvePath("atlas/"+fileName);
			var inStream:FileStream = new FileStream(); 
			inStream.open(inFile, FileMode.READ); 
			inStream.readBytes(data); 
			inStream.close(); 
		} 
		
	}
}