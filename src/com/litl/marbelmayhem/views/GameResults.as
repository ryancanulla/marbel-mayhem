package com.litl.marbelmayhem.views
{
    import flash.display.Loader;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.net.URLRequest;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;

    public class GameResults extends Sprite
    {
        private var winnerTitlePlayer1:Loader;
        private var winnerTitlePlayer2:Loader;
        private var timeBonus:TextField;
        private var livesBonus:TextField;
        private var score:TextField;
        private var finalScore:TextField;
        private var finalMessage:TextField;
        private var background:Shape;
        private var _stage:Stage;

        public function GameResults(e:Stage) {
            super();
            _stage = e;
            init();
        }

        private function init():void {
            background = new Shape();
            background.graphics.beginFill(0x000000, .8);
            background.graphics.drawRect(0, 0, 750, 225);
            background.graphics.endFill();
            _stage.addChild(background);

            winnerTitlePlayer1 = new Loader();
            winnerTitlePlayer1.load(new URLRequest("../assets/game-results/winner-player-1.png"));
            winnerTitlePlayer1.visible = false;
            _stage.addChild(winnerTitlePlayer1);

            winnerTitlePlayer2 = new Loader();
            winnerTitlePlayer2.load(new URLRequest("../assets/game-results/winner-player-1.png"));
            winnerTitlePlayer2.visible = false;
            _stage.addChild(winnerTitlePlayer2);

            var format:TextFormat = new TextFormat();
            format.font = "Calibri";
            format.size = 26;
            format.color = 0xffffff;

            finalMessage = new TextField();
            finalMessage.defaultTextFormat = format;
            finalMessage.setTextFormat(format);
            finalMessage.autoSize = TextFieldAutoSize.LEFT;
            _stage.addChild(finalMessage);

            createChildren();
        }

        private function createChildren():void {

            updateProperties();
            updateLayout();
        }

        private function updateProperties():void {
            winnerTitlePlayer1.visible = true;

            finalMessage.text = "Congratulations player 1!";
        }

        private function updateLayout():void {
            background.x = 275;
            background.y = 290;

            winnerTitlePlayer1.x = 250;
            winnerTitlePlayer1.y = 200;

            winnerTitlePlayer2.x = 250;
            winnerTitlePlayer2.y = 200;

            finalMessage.x = 300;
            finalMessage.y = 375;
        }
    }
}
