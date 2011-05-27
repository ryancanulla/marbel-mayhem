package com.ryancanulla.marbelmayhem.utils
{
    import flash.display.Bitmap;

    public class GameAssets
    {
        [Embed(source="../assets/logo.gif")]
        private var LogoImage:Class;
        public var logoBitmap:Bitmap = new LogoImage();

        [Embed(source="../assets/time-bg.gif")]
        private var timeBgImage:Class;
        public var timeBGBitmap:Bitmap = new timeBgImage();

        [Embed(source="../assets/scoreboard/playerOneIcon.png")]
        private var playerOneIconImage:Class;
        public var playerOneIconBitmap:Bitmap = new playerOneIconImage();

        [Embed(source="../assets/scoreboard/playerTwoIcon.png")]
        private var playerTwoIconImage:Class;
        public var playerTwoIconBitmap:Bitmap = new playerTwoIconImage();

        public function GameAssets() {
        }
    }
}
