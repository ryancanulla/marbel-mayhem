package com.litl.marbelmayhem.model
{
    import com.litl.marbelmayhem.events.MarbleEvent;

    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    public class GameManager extends EventDispatcher
    {
        private static var _instance:GameManager;

        private var _players:Array;
        private var _player1Score:Number;
        private var _player2Score:Number;
        private var gameTimer:Timer;
        private var gameRenderClock:Timer;
        private var _gameInProgress:Boolean;
        private var timeLeft:Number;
        public var countdown:Timer;

        public function GameManager(enforcer:SingletonEnforcer) {
            init();
        }

        public static function getInstance():GameManager {
            if (GameManager._instance == null) {
                GameManager._instance = new GameManager(new SingletonEnforcer());
            }
            return GameManager._instance;
        }

        private function init():void {
            _player1Score = 0;
            _player2Score = 0;
            _gameInProgress = false;

            countdown = new Timer(1000, 4);
            countdown.addEventListener(TimerEvent.TIMER_COMPLETE, resumeGame);

            gameTimer = new Timer(1000, 60 * 3);
            timeLeft = gameTimer.repeatCount;
            gameTimer.addEventListener(TimerEvent.TIMER, secondTimer);

            gameRenderClock = new Timer(33.3, int.MAX_VALUE);
            gameRenderClock.addEventListener(TimerEvent.TIMER, renderTimer);
            gameRenderClock.start();

        }

        public function startNewGame():void {
            dispatchEvent(new Event("StartNewGameMarbleEvent", true));
            countdown.reset();
            countdown.start();

            gameTimer.reset();
            timeLeft = gameTimer.repeatCount;
        }

        public function pauseGame():void {
            _gameInProgress = false;
            gameTimer.stop();
        }

        public function resumeGame(e:TimerEvent = null):void {
            _gameInProgress = true;
            gameTimer.start();
        }

        private function secondTimer(e:TimerEvent):void {
            timeLeft--;
            dispatchEvent(new Event("TimerTickMarbleEvent", true));
        }

        private function renderTimer(e:TimerEvent):void {
            dispatchEvent(new Event("RenderMarbleEvent", true));
        }

        public function calculateScores(player1:Number, player2:Number):void {
            _player1Score += player1;
            _player2Score += player2;

            dispatchEvent(new Event("ScoreChangedMarbleEvent", true));
        }

        public function get player1Score():Number {
            return Math.round(_player1Score);
        }

        public function get player2Score():Number {
            return Math.round(_player2Score);
        }

        public function get time():String {
            var minute:Number = Math.floor(Number(timeLeft) / 60);
            var seconds:Number = Number(timeLeft) % 60;
            var time:String;

            if (Number(timeLeft) % 60 < 10) {
                return minute + ":0" + seconds;
            }
            else {
                return minute + ":" + seconds;
            }
        }

        public function get gameInProgress():Boolean {
            return _gameInProgress;
        }

    }

}

class SingletonEnforcer
{
}
