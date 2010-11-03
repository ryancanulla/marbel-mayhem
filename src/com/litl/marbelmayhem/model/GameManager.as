package com.litl.marbelmayhem.model
{
    import com.litl.helpers.richinput.remotehandler.RemoteHandlerManager;
    import com.litl.marbelmayhem.controller.GameController;
    import com.litl.marbelmayhem.events.MarbleEvent;
    import com.litl.marbelmayhem.model.service.LitlViewManager;
    import com.litl.marbelmayhem.vo.Player;
    import com.litl.sdk.enum.View;
    import com.litl.sdk.richinput.IRemoteControl;
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
        private var _playersInGame:Array;

        //private var _controller:GameController;
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

            _playersInGame = new Array();
            _gameInProgress = true;

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

            for (var i:uint = 0; i < _playersInGame.length; i++) {
                var player:Player = _playersInGame[i] as Player;
                player.lives = maxLives;
                player.score = 0;
            }

            dispatchEvent(new MarbleEvent(MarbleEvent.SCORE_CHANGED));
        }

        private function checkForRemainingLives():void {
            for (var i:uint = 0; i < _playersInGame.length; i++) {
                var player:Player = _playersInGame[i] as Player;

                if (player.lives == 0) {
                    dispatchEvent(new MarbleEvent(MarbleEvent.GAME_OVER));
                }
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

        public function addToScores(player:Player, score:uint):void {
            for (var i:uint = 0; i < _playersInGame.length; i++) {

                if (player.remoteID == Player(_playersInGame[i]).remoteID) {
                    Player(_playersInGame[i]).score += score;
                }
            }

            dispatchEvent(new Event(MarbleEvent.SCORE_CHANGED, true));
        }

        public function addWinningCollision(player:Player):void {
            for (var i:uint = 0; i < _playersInGame.length; i++) {

                if (player.remoteID == Player(_playersInGame[i]).remoteID) {
                    Player(_playersInGame[i]).winningCollisions += 1;
                }
            }
        }

        public function playerDied(player:Player):void {
            for (var i:uint = 0; i < _playersInGame.length; i++) {

                if (player.remoteID == Player(_playersInGame[i]).remoteID) {
                    Player(_playersInGame[i]).lives -= 1;
                }
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

        public function get playersInGame():Array {
            return _playersInGame;
        }

        public function addPlayer(player:Player):void {
            _playersInGame.push(player);

            var event:MarbleEvent = new MarbleEvent(MarbleEvent.ADD_PLAYER);
            event.player = player;
            dispatchEvent(event);
        }

        public function removePlayer(remote:IRemoteControl):void {
            for (var i:uint = 0; i < _playersInGame.length; i++) {
                if (Player(_playersInGame[i]).remoteID == remote.id) {
                    var event:MarbleEvent = new MarbleEvent(MarbleEvent.REMOVE_PLAYER);
                    event.player = Player(_playersInGame[i]);
                    dispatchEvent(event);

                    _playersInGame.splice(i, 1);
                }
            }

        }

    }
}

class SingletonEnforcer
{
}
