package com.litl.marbelmayhem
{
    import flash.display.Loader;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.display.StageAlign;
    import flash.net.URLRequest;
    import flash.text.TextField;

    public class Scoreboard extends Sprite
    {
        private var _stage:Stage;

        public function Scoreboard(e:Stage) {
            super();
            _stage = e;
            init();
        }

        private function init():void {
            createBackgroud();
            createLogo();
        }

        private function createBackgroud():void {
            var background:Sprite = new Sprite();
            background.graphics.beginFill(0x333333);
            background.graphics.drawRect(0, 0, _stage.stageWidth, _stage.stageHeight * .1);
            addChild(background);
        }

        private function createLogo():void {
            //var logo:Shape = new Shape();
            //logo.graphics.beginFill(0xffffff);
            //logo.graphics.drawCircle(100, 35, 25);
            //logo.graphics.endFill();
            //addChild(logo);

            var logo:Loader = new Loader;
            logo.load(new URLRequest("../assets/logo.gif"));
            logo.x = 75;
            logo.y = 2;
            addChild(logo);
        }

        private function createScores():void {
            var player1Score:TextField = new TextField();
            player1Score.text = "1023";
            addChild(player1Score);
        }
    }
}
