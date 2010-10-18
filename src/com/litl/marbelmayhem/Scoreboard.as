package com.litl.marbelmayhem
{
    import com.litl.marbelmayhem.model.GameManager;

    import flash.display.Loader;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.display.StageAlign;
    import flash.events.Event;
    import flash.net.URLRequest;
    import flash.text.TextField;
    import flash.text.TextFormat;

    public class Scoreboard extends Sprite
    {
        private var _stage:Stage;
        private var model:GameManager = GameManager.getInstance();

        private var background:Sprite;
        private var timeBG:Loader;
        private var logo:Loader;
        private var timeDisplay:TextField;
        private var player1Icon:Loader;
        private var player2Icon:Loader;
        private var player1Score:TextField;
        private var player2Score:TextField;

        public function Scoreboard(e:Stage) {
            super();
            _stage = e;
            init();
        }

        private function init():void {
            createChildren();
            model.addEventListener("ScoreChangedMarbleEvent", updateProperties);
            model.addEventListener("TimerTickMarbleEvent", updateProperties);
        }

        private function createChildren():void {
            background = new Sprite();
            background.graphics.beginFill(0x333333);
            background.graphics.drawRect(0, 0, _stage.stageWidth, _stage.stageHeight * .1);
            addChild(background);

            logo = new Loader;
            logo.load(new URLRequest("../assets/logo.gif"));
            addChild(logo);

            timeBG = new Loader;
            timeBG.load(new URLRequest("../assets/time-bg.gif"));
            addChild(timeBG);

            var timeFormat:TextFormat = new TextFormat();
            timeFormat.font = "Calibri";
            timeFormat.size = 34;
            timeFormat.color = 0x000000;

            timeDisplay = new TextField();
            timeDisplay.text = "3:33";
            timeDisplay.defaultTextFormat = timeFormat;
            timeDisplay.setTextFormat(timeFormat);
            addChild(timeDisplay);

            var scoreFormat:TextFormat = new TextFormat();
            scoreFormat.font = "Calibri";
            scoreFormat.size = 26;
            scoreFormat.color = 0xffffff;

            player1Icon = new Loader;
            player1Icon.load(new URLRequest("../assets/scoreboard/playerOneIcon.png"));
            addChild(player1Icon);

            player1Score = new TextField();
            player1Score.defaultTextFormat = scoreFormat;
            player1Score.setTextFormat(scoreFormat);
            addChild(player1Score);

            player2Icon = new Loader;
            player2Icon.load(new URLRequest("../assets/scoreboard/playerTwoIcon.png"));
            addChild(player2Icon);

            player2Score = new TextField();
            player2Score.defaultTextFormat = scoreFormat;
            player2Score.setTextFormat(scoreFormat);
            addChild(player2Score)

            updateLayout();
            updateProperties();
        }

        private function updateProperties(e:Event = null):void {
            player1Score.text = model.player1Score.toString();
            player2Score.text = model.player2Score.toString();

            timeDisplay.text = model.time;
        }

        private function updateLayout():void {
            logo.x = 50;
            logo.y = 2;

            timeBG.x = 525;
            timeBG.y = 10;
            timeDisplay.x = 590;
            timeDisplay.y = 15;

            player1Icon.x = 750;
            player1Icon.y = 10;

            player1Score.width = 300;
            player1Score.x = 890;
            player1Score.y = 7;

            player2Icon.x = 1000;
            player2Icon.y = 10;

            player2Score.width = 300;
            player2Score.x = 1145;
            player2Score.y = 7;
        }
    }
}
