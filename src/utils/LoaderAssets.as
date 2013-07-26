package utils
{
	import com.adobe.images.JPGEncoder;
	import com.adobe.images.PNGEncoder;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.CompressionAlgorithm;
	
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	
	import org.bytearray.decoder.JPEGDecoder;
	
	
	public class LoaderAssets extends Sprite
	{
		[Embed(source="../../media/graphics/assets.xml", mimeType="application/octet-stream")]
		public static const AssetsXML:Class;
		
		public static const COMPLETE:String = "Complite";
		private static var _i:int;
		private var _loaderS:BulkLoader;
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
		
				var bitArray:ByteArray
				var loader:Loader;
				var bitmapData:BitmapData
				if(!_loaderS){
							_loaderS = new BulkLoader("main-site");
							_loaderS.logLevel = BulkLoader.LOG_INFO;
							_loaderS.addEventListener(BulkLoader.COMPLETE, onAllItemsLoaded);
							_loaderS.addEventListener(BulkLoader.PROGRESS, onAllItemsProgress);
						}
				for each (var asset:XML in _xml.asset) {
					file =  File.applicationStorageDirectory.resolvePath( "atlas/"+asset.@name );
					
					try {
						fileStream.open(file, FileMode.READ);
						_loaderS.add(file.url, {id:asset.@id, data:false});
							
					}
					catch(e:Error){
						trace("no file "+e)
						_loaderS.add("http://www.espilacopa.com/"+Assets.contentScaleFactor+"x/"+asset.@name, {id:asset.@id, data:true});
					}
				}
				
				fileStream.close();
				if(_loaderS){
					_loaderS.start()
				}else {
					this.dispatchEvent(new Event(COMPLETE));
				}
				
				
			}
			else {
				imageDirectory.createDirectory();
				checkAsset()
			}	
		}
		public function onAllItemsLoaded(evt : Event) : void{
			var byteA:ByteArray
			for each (var asset:XML in _xml.asset) {
				trace("data "+_loaderS.getData(asset.@id))
				switch(String(asset.@type)){
					case "png": 					
						byteA = PNGEncoder.encode(_loaderS.getBitmap(asset.@id).bitmapData);
						if(_loaderS.getData(asset.@id))recordAssets(asset.@name,byteA)
						Assets.setAsset(asset.@id,_loaderS.getBitmap(asset.@id))
						break
					case "jpg":
						var encoder:JPGEncoder = new JPGEncoder();
						byteA = encoder.encode(_loaderS.getBitmap(asset.@id).bitmapData)
						if(_loaderS.getData(asset.@id))recordAssets(asset.@name,byteA)
						Assets.setAsset(asset.@id,_loaderS.getBitmap(asset.@id))
						break
					case "xml": 
						Assets.setAsset(asset.@id,_loaderS.getXML(asset.@id))
						if(_loaderS.getData(asset.@id))recordAssets(asset.@name,null,_loaderS.getXML(asset.@id).toXMLString())
						break
				}
			}
			dispatchEvent(new Event(COMPLETE));
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
		
		private function recordAssets($name:String, $file:ByteArray,$dataText:String=null ):void
		{
			var file:File = File.applicationStorageDirectory.resolvePath( "atlas/"+$name );
			var wr:File = new File( file.nativePath );
			var stream:FileStream = new FileStream();
			stream.open( wr , FileMode.WRITE);
			try {
				if($dataText){
					stream.writeUTFBytes($dataText) ;
				}else  stream.writeBytes ( $file, 0,$file.length )
			}
			catch(e:Error){
				trace("no recording"+e)
			}
			stream.close();
		}
		private function getAssets(fileName:String, data:ByteArray):void 
		{ 
			var inFile:File = File.applicationStorageDirectory.resolvePath("atlas/"+fileName);
			var inStream:FileStream = new FileStream(); 
			inStream.open(inFile, FileMode.READ); 
			inStream.readBytes(data); 
			inStream.close(); 
		} 
		
	}
}