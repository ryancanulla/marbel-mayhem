package com.ryancanulla.marbelmayhem.utils
{
    import flash.display.Bitmap;

    public class CountdownAssets
    {
        [Embed(source="../assets/countdown/1.png")]
        private var OneImage:Class;
        public var OneBitmap:Bitmap = new OneImage();

        [Embed(source="../assets/countdown/2.png")]
        private var TwoImage:Class;
        public var TwoBitmap:Bitmap = new TwoImage();

        [Embed(source="../assets/countdown/3.png")]
        private var ThreeImage:Class;
        public var ThreeBitmap:Bitmap = new ThreeImage();

        [Embed(source="../assets/countdown/play.png")]
        private var PlayImage:Class;
        public var PlayBitmap:Bitmap = new PlayImage();

        public function CountdownAssets() {
        }
    }
}
