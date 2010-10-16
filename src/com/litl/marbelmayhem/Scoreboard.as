package com.litl.marbelmayhem
{
    import flash.display.Loader;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.display.StageAlign;
    import flash.net.URLRequest;
    import flash.text.TextField;
    import flash.text.TextFormat;

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
            createScores();
        }

        private function createBackgroud():void {
            var background:Sprite = new Sprite();
            background.graphics.beginFill(0x333333);
            background.graphics.drawRect(0, 0, _stage.stageWidth, _stage.stageHeight * .1);
            addChild(background);
        }

        private function createLogo():void {
            var logo:Loader = new Loader;
            logo.load(new URLRequest("../assets/logo.gif"));
            logo.x = 50;
            logo.y = 2;
            addChild(logo);
        }

        private function createScores():void {
            var format:TextFormat = new TextFormat();
            format.font = "Calibri";
            format.size = 34;
            format.color = 0xffffff;

            var player1Score:TextField = new TextField();
            player1Score.text = "Player 1: 1296";
            player1Score.defaultTextFormat = format;
            player1Score.setTextFormat(format);
            player1Score.width = 300;
            player1Score.x = 750;
            player1Score.y = 5;
            addChild(player1Score);

            var player2Score:TextField = new TextField();
            player2Score.text = "Player 2: 596";
            player2Score.defaultTextFormat = format;
            player2Score.setTextFormat(format);
            player2Score.width = 300;
            player2Score.x = 1025;
            player2Score.y = 5;
            addChild(player2Score)
        }
    }
}
