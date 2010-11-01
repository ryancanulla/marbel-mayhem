package com.litl.marbelmayhem.model
{
    import com.litl.helpers.richinput.remotehandler.RemoteHandlerManager;
    import com.litl.marbelmayhem.events.MarbleEvent;
    import com.litl.marbelmayhem.model.service.LitlViewManager;
    import com.litl.marbelmayhem.vo.Player;
    import com.litl.sdk.enum.View;
    import com.litl.sdk.service.LitlService;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    public class GameManager extends EventDispatcher
    {
        private static var _instance:GameManager;
        private var _player1:Player;
        private var _player2:Player;
        private var _gameInProgress:Boolean;
        private var _gameViewState:String;
        private var gameTimer:Timer;
        private var gameRenderClock:Timer;
        private var timeLeft:Number;
        private var service:LitlViewManager;
        public var maxLives:Number = 5;

        public var countdown:Timer;

        public function GameManager(enforcer:SingletonEnforcer) {
            super();
            init();
        }

        public static function getInstance():GameManager {
            if (GameManager._instance == null) {
                GameManager._instance = new GameManager(new SingletonEnforcer());
            }
            return GameManager._instance;
        }

        private function init():void {
            _player1 = new Player();
            _player2 = new Player();
            _player1.lives = maxLives;
            _player2.lives = maxLives;

            _gameInProgress = false;

            countdown = new Timer(1000, 5);
            countdown.addEventListener(TimerEvent.TIMER_COMPLETE, resumeGame);

            gameTimer = new Timer(1000, 60 * 2);
            gameTimer.addEventListener(TimerEvent.TIMER, secondTimer);
            gameTimer.addEventListener(TimerEvent.TIMER_COMPLETE, gameOver);

            timeLeft = gameTimer.repeatCount;

            gameRenderClock = new Timer(33.3, int.MAX_VALUE);
            gameRenderClock.addEventListener(TimerEvent.TIMER, renderTimer);
            gameRenderClock.start();
        }

        private function secondTimer(e:TimerEvent):void {
            timeLeft--;
            dispatchEvent(new Event(MarbleEvent.TIMER_TICK, true));
        }

        private function renderTimer(e:TimerEvent):void {
            dispatchEvent(new Event(MarbleEvent.RENDER, true));
        }

        private function resetPlayers():void {
            player1.lives = maxLives;
            player2.lives = maxLives;

            player1.score = 0;
            player2.score = 0;

            dispatchEvent(new MarbleEvent(MarbleEvent.SCORE_CHANGED));
        }

        private function checkForRemainingLives():void {
            if (_player1.lives == 0 || _player2.lives == 0) {
                dispatchEvent(new MarbleEvent(MarbleEvent.GAME_OVER));
            }
        }

        public function startNewGame():void {
            _gameInProgress = false;
            dispatchEvent(new Event(MarbleEvent.START_NEW_GAME, true));
            countdown.reset();
            countdown.start();
            gameTimer.reset();
            resetPlayers();
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

        public function gameOver(e:TimerEvent = null):void {
            pauseGame();
        }

        public function addToScores(player1:Number, player2:Number):void {
            _player1.score += player1;
            _player2.score += player2;

            dispatchEvent(new Event(MarbleEvent.SCORE_CHANGED, true));
        }

        public function addWinningCollision(player:Number):void {
            if (player == 1) {
                _player1.winningCollisions += 1;
            }
            else if (player == 2) {
                _player2.winningCollisions += 1;
            }
        }

        public function playerDied(player:Number):void {
            if (player == 1) {
                _player1.lives -= 1;
            }
            else if (player == 2) {
                _player2.lives -= 1;
            }
            checkForRemainingLives();
            dispatchEvent(new MarbleEvent(MarbleEvent.PLAYER_DIED));
        }

        public function get player1():Player {
            return _player1;
        }

        public function get player2():Player {
            return _player2;
        }

        public function get gameInProgress():Boolean {
            return _gameInProgress;
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

        public function get gameViewState():String {
            return _gameViewState;
        }

        public function set gameViewState(value:String):void {
            _gameViewState = value;
            dispatchEvent(new MarbleEvent(MarbleEvent.RESET_LAYOUT));
        }

    }
}

class SingletonEnforcer
{
}
