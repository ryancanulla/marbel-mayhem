package com.litl.marbelmayhem.views
{
    import com.litl.marbelmayhem.events.MarbleEvent;
    import com.litl.marbelmayhem.model.GameManager;
    import com.litl.marbelmayhem.utils.GameAssets;
    import com.litl.marbelmayhem.vo.Player;

    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.display.StageAlign;
    import flash.events.Event;
    import flash.net.URLRequest;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;

    public class Scoreboard extends ViewBase
    {
        private var _view:ViewBase;
        private var model:GameManager = GameManager.getInstance();
        private var gameAssets:GameAssets = new GameAssets();

        private var background:Sprite;
        private var timeBG:Bitmap;
        private var logo:Bitmap;
        private var timeDisplay:TextField;
        private var player1Icon:Bitmap;
        private var player2Icon:Bitmap;
        private var player1Score:TextField;
        private var player2Score:TextField;
        private var player1Life:PlayerOneLife;
        private var player2Life:PlayerTwoLife;

        public function Scoreboard(e:ViewBase) {
            super();
            _view = e;
            init();
        }

        private function init():void {
            createChildren();
            model.addEventListener(MarbleEvent.SCORE_CHANGED, updateProperties);
            model.addEventListener(MarbleEvent.TIMER_TICK, updateProperties);
            model.addEventListener(MarbleEvent.ADD_PLAYER, updateProperties);
            model.addEventListener(MarbleEvent.REMOVE_PLAYER, updateProperties);
        }

        private function createChildren():void {
            background = new Sprite();
            background.graphics.beginFill(0x333333);
            background.graphics.drawRect(0, 0, 1280, 800 * .15);
            addChild(background);

            logo = gameAssets.logoBitmap;
            logo.cacheAsBitmap = true;
            addChild(logo);

            timeBG = gameAssets.timeBGBitmap;
            timeBG.cacheAsBitmap = true;
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

            player1Icon = gameAssets.playerOneIconBitmap;
            player1Icon.cacheAsBitmap = true;
            addChild(player1Icon);

            player1Score = new TextField();
            player1Score.defaultTextFormat = scoreFormat;
            player1Score.autoSize = TextFieldAutoSize.LEFT;
            player1Score.setTextFormat(scoreFormat);
            addChild(player1Score);

            player1Life = new PlayerOneLife();
            addChild(player1Life);

            player2Icon = gameAssets.playerTwoIconBitmap;
            player2Icon.cacheAsBitmap = true;
            addChild(player2Icon);

            player2Score = new TextField();
            player1Score.autoSize = TextFieldAutoSize.LEFT;
            player2Score.defaultTextFormat = scoreFormat;
            player2Score.setTextFormat(scoreFormat);
            addChild(player2Score);

            player2Life = new PlayerTwoLife();
            addChild(player2Life);

            updateProperties();
        }

        private function updateProperties(e:Event = null):void {
            switch (model.playersInGame.length) {
                case 0:
                    player1Icon.visible = false;
                    player1Score.visible = false;
                    player1Life.visible = false;
                    player2Icon.visible = false;
                    player2Score.visible = false;
                    player2Life.visible = false;
                    break;
                case 1:
                    player2Icon.visible = false;
                    player2Life.visible = false;
                    player2Score.visible = false;

                    player1Icon.visible = true;
                    player1Life.visible = true;
                    player1Score.visible = true;
                    player1Score.text = Player(model.playersInGame[0]).score.toString();
                    break;
                case 2:
                    player1Icon.visible = true;
                    player1Life.visible = true;
                    player1Score.visible = true;
                    player1Score.text = Player(model.playersInGame[0]).score.toString();

                    player2Icon.visible = true;
                    player2Life.visible = true;
                    player2Score.visible = true;
                    player2Score.text = Player(model.playersInGame[1]).score.toString();
                    break
            }
            timeDisplay.text = model.time;
        }

        override protected function sizeUpdated():void {
            logo.x = this.width * .10;
            logo.y = (background.height / 2) - (logo.height / 2);

            timeBG.x = (this.width / 2) - (timeBG.width / 2);
            timeBG.y = (background.height / 2) - (timeBG.height / 2);

            timeDisplay.x = (timeBG.x + (timeBG.width / 2)) - (timeDisplay.width / 2);
            timeDisplay.y = (background.height / 2) - (timeBG.height / 2);

            player1Icon.x = timeBG.x + timeBG.width + 50;
            player1Icon.y = background.height * .20;

            player1Score.x = (player1Icon.x + player1Icon.width) + 25;
            player1Score.y = background.height * .20;

            player1Life.x = player1Icon.x;
            player1Life.y = background.height * .50;

            player2Icon.x = player1Score.x + player1Score.width + 50;
            player2Icon.y = background.height * .20;

            player2Score.x = 1145;
            player2Score.y = background.height * .20;

            player2Life.x = player2Icon.x;
            player2Life.y = background.height * .50;
        }
    }
}
