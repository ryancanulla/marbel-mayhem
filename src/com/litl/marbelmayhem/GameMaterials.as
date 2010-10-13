package com.litl.marbelmayhem
{
    import flash.display.Bitmap;

    public class GameMaterials
    {
        [Embed(source="/../assets/grass.jpg")]
        private var GrassImage:Class;
        public var grassBitmap:Bitmap = new GrassImage();

        [Embed(source="/../assets/abstractSky-back.png")]
        private var BitmapFront:Class;
        public var skyFront:Bitmap = new BitmapFront();

        [Embed(source="/../assets/abstractSky-left.png")]
        private var BitmapRight:Class;
        public var skyRight:Bitmap = new BitmapRight();

        [Embed(source="/../assets/abstractSky-front.png")]
        private var BitmapBack:Class;
        public var skyBack:Bitmap = new BitmapBack();

        [Embed(source="/../assets/abstractSky-right.png")]
        private var BitmapLeft:Class;
        public var skyLeft:Bitmap = new BitmapLeft();

        [Embed(source="/../assets/abstractSky-down.png")]
        private var BitmapDown:Class;
        public var skyDown:Bitmap = new BitmapDown();

        [Embed(source="/../assets/abstractSky-up.png")]
        private var BitmapUp:Class;
        public var skyUp:Bitmap = new BitmapUp();

        public function GameMaterials() {
        }
    }
}
