package com.litl.marbelmayhem.utils
{
    import flash.display.Bitmap;

    public class GameMaterials
    {
        [Embed(source="/../assets/grass.jpg")]
        private var GrassImage:Class;
        public var grassBitmap:Bitmap = new GrassImage();

        [Embed(source="/../assets/red-marble.png")]
        private var MarbleImage:Class;
        public var marbleBitmap:Bitmap = new MarbleImage();

        [Embed(source="/../assets/blue-water/floor-texture.jpg")]
        private var FloorImage:Class;
        public var floorBitmap:Bitmap = new FloorImage();

        [Embed(source="/../assets/brushed-metal.jpg")]
        private var MetalImage:Class;
        public var metalBitmap:Bitmap = new MetalImage();

        [Embed(source="/../assets/blue-water/100000.png")]
        private var BitmapFront:Class;
        public var skyFront:Bitmap = new BitmapFront();

        [Embed(source="/../assets/blue-water/100001.png")]
        private var BitmapRight:Class;
        public var skyRight:Bitmap = new BitmapRight();

        [Embed(source="/../assets/blue-water/100002.png")]
        private var BitmapBack:Class;
        public var skyBack:Bitmap = new BitmapBack();

        [Embed(source="/../assets/blue-water/100003.png")]
        private var BitmapLeft:Class;
        public var skyLeft:Bitmap = new BitmapLeft();

        [Embed(source="/../assets/blue-water/100005.png")]
        private var BitmapDown:Class;
        public var skyDown:Bitmap = new BitmapDown();

        [Embed(source="/../assets/blue-water/100004.png")]
        private var BitmapUp:Class;
        public var skyUp:Bitmap = new BitmapUp();

        public function GameMaterials() {
        }
    }
}
