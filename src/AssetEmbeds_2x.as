package
{
    public class AssetEmbeds_2x
    {
		// Bitmaps
		[Embed(source="../media/textures/2x/gameBKG.png")]
		public static const BgLayer1:Class;
		
		[Embed(source="../media/textures/2x/gameBKG_layerTop.png")]
		public static const BgLayer2:Class;
		
		[Embed(source="../media/textures/2x/gameBKG_Front.png")]
		public static const BgLayer3:Class;
		
		[Embed(source = "../media/textures/2x/bgWelcome.jpg")]
		public static const Background:Class;
		
		[Embed(source = "../media/textures/2x/loading.png")]
		public static const Loading:Class;
		
		// Texture Atlas
		
		[Embed(source="../media/textures/2x/frog.xml", mimeType="application/octet-stream")]
		public static const AtlasGameXML:Class;
		
		[Embed(source="../media/textures/2x/frog.png")]
		public static const AtlasGameTexture:Class;
		
		// Bitmap Fonts
		
		[Embed(source="../media/fonts/1x/desyrel.fnt", mimeType="application/octet-stream")]
		public static const DesyrelXml:Class;
		
		[Embed(source = "../media/fonts/1x/desyrel.png")]
		public static const DesyrelTexture:Class;
    }
}