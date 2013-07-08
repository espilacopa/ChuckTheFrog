// Copyright (C) 2012 Blue Pichu
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is furnished
// to do so, subject to the following conditions:  
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
// PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
// FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.
//
// Last edited Aug 21 2012

package utils{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	/**
	 * The <code>Scale9Sprte</code> class allows for an image
	 * to be scaled without scaling the corners; this is helpful
	 * when scaling rounded rectangles in order to keep the radius
	 * on the corners square and constant size.
	 * */
	public class Scale9Sprite extends Sprite{
		/**
		 * An array of <code>BitmapData</code> objects that are the
		 * nine _slices of the image.
		 *
		 * @private
		 * */
		private var _slices:Array;
		
		/**
		 * The width of the image.
		 *
		 * @private
		 * */
		private var _mWidth:Number;
		
		/**
		 * The height of the image.
		 *
		 * @private
		 * */
		private var _mHeight:Number;
		
		/**
		 * Creates a new <code>Scale9Sprite</code> instance whose image
		 * is contained in <code>data</code> and whose center slice is
		 * <code>rect</code>.
		 *
		 * @param data The image to display
		 * @param rect The center slice
		 * */
		public function Scale9Sprite(data:BitmapData, rect:Rectangle){
			super();
			_slices = new Array();
			//set initial width and height
			_mWidth = data.width;
			_mHeight = data.height;
			var bd:BitmapData;
			//create the nine _slices, and store in the array
			bd = new BitmapData(rect.x, rect.y, true, 0x00000000);//top left
			bd.copyPixels(data, new Rectangle(0, 0, rect.x, rect.y), new Point(0, 0));
			_slices.push(bd);
			bd = new BitmapData(rect.width, rect.y, true, 0x00000000);//top center
			bd.copyPixels(data, new Rectangle(rect.x, 0, rect.width, rect.y), new Point(0, 0));
			_slices.push(bd);
			bd = new BitmapData(data.width - rect.right, rect.y, true, 0x00000000);//top right
			bd.copyPixels(data, new Rectangle(rect.right, 0, data.width - rect.right, rect.y), new Point(0, 0));
			_slices.push(bd);
			bd = new BitmapData(rect.x, rect.height, true, 0x00000000);//middle left
			bd.copyPixels(data, new Rectangle(0, rect.y, rect.x, rect.height), new Point(0, 0));
			_slices.push(bd);
			bd = new BitmapData(rect.width, rect.height, true, 0x00000000);//center
			bd.copyPixels(data, new Rectangle(rect.x, rect.y, rect.width, rect.height), new Point(0, 0));
			_slices.push(bd);
			bd = new BitmapData(data.width - rect.width, rect.height, true, 0x00000000);//middle right
			bd.copyPixels(data, new Rectangle(rect.right, rect.y, data.width - rect.right, rect.height), new Point(0, 0));
			_slices.push(bd);
			bd = new BitmapData(rect.x, data.height - rect.bottom, true, 0x00000000);//bottom left
			bd.copyPixels(data, new Rectangle(0, rect.bottom, rect.x, data.height - rect.bottom), new Point(0, 0));
			_slices.push(bd);
			bd = new BitmapData(rect.width, data.height - rect.bottom, true, 0x00000000);//bottom center
			bd.copyPixels(data, new Rectangle(rect.x, rect.bottom, rect.width, data.height - rect.bottom), new Point(0, 0));
			_slices.push(bd);
			bd = new BitmapData(data.width - rect.right, data.height - rect.bottom, true, 0x00000000);//bottom right
			bd.copyPixels(data, new Rectangle(rect.right, rect.bottom, data.width - rect.right, data.height - rect.bottom), new Point(0, 0));
			_slices.push(bd);
			//position the _slices, and add them to the image
			for(var i:int = 0; i < 9; i++){
				var img:Image = new Image(Texture.fromBitmapData(_slices[i]));
				switch(i % 3){
					case 1:
						img.x = rect.x;
						break;
					case 2:
						img.x = rect.right;
						break;
				}
				switch(Math.floor(i / 3)){
					case 1:
						img.y = rect.y;
						break;
					case 2:
						img.y = rect.bottom;
						break;
				}
				_slices[i] = img;
				this.addChild(img);
			}
		}
		
		/**
		 * The width of the image.
		 * */
		public override function set width(value:Number):void{
			if(value < _slices[0].width + _slices[2].width){
				throw new Error("Invalid Argument.");
			}
			_slices[1].width = _slices[4].width = _slices[7].width = value - _slices[0].width - _slices[2].width + 1;
			_slices[2].x = _slices[5].x = _slices[8].x = value - _slices[2].width;
			_mWidth = value;
		}
		
		public override function get width():Number{
			return _mWidth;
		}
		
		/**
		 * The height of the image.
		 * */
		public override function set height(value:Number):void{
			if(value < _slices[0].height + _slices[6].width){
				throw new Error("Invalid Argument.");
			}
			_slices[3].height = _slices[4].height = _slices[5].height = value - _slices[0].height - _slices[6].height + 2;
			_slices[6].y = _slices[7].y = _slices[8].y = value - _slices[6].height;
			_mHeight = value;
		}
		
		public override function get height():Number{
			return _mHeight;
		}
	}
}