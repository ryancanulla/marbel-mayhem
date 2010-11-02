package com.litl.marbelmayhem.controller
{
    import com.litl.helpers.richinput.remotehandler.RemoteHandlerManager;
    import com.litl.marbelmayhem.events.MarbleEvent;
    import com.litl.marbelmayhem.model.GameManager;
    import com.litl.marbelmayhem.model.service.LitlViewManager;
    import com.litl.marbelmayhem.views.ChannelView;
    import com.litl.marbelmayhem.views.ViewBase;
    import com.litl.marbelmayhem.vo.Player;
    import com.litl.sdk.enum.View;
    import com.litl.sdk.event.RemoteStatusEvent;
    import com.litl.sdk.message.UserInputMessage;
    import com.litl.sdk.message.ViewChangeMessage;
    import com.litl.sdk.richinput.Accelerometer;
    import com.litl.sdk.richinput.IRemoteControl;
    import com.litl.sdk.richinput.RemoteManager;
    import com.litl.sdk.service.LitlService;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.utils.Dictionary;

    public class GameController
    {
        private static var _instance:GameController;
        private var _currentView:ViewBase;
        private var _viewManager:LitlViewManager;
        public var remoteIds:Array;
        public var models:Array;
        public var model:GameManager;
        private var players:Dictionary;
        private var service:LitlService;
        protected var remoteManager:RemoteManager;
        protected var remoteHandlers:Dictionary;

        private var player1AccX:Number = 0;
        private var player1AccZ:Number = 0;
        private var player1VX:Number = 0;
        private var player1VY:Number = 0;

        private var player2AccX:Number = 0;
        private var player2AccZ:Number = 0;
        private var player2VX:Number = 0;
        private var player2VY:Number = 0;

        private var rotate1:Number;
        private var rotate2:Number;

        private static const FRICTION:Number = .95;
        private static const SPEED:Number = 3;
        private static const GRAVITY:Number = 17;
        private static const SPRING:Number = .2;
        private static const MASS:Number = 1;

        public function GameController(enforcer:SingletonEnforcer) {
            init();
        }

        public static function getInstance():GameController {
            if (GameController._instance == null) {
                GameController._instance = new GameController(new SingletonEnforcer());
            }
            return GameController._instance;
        }

        private function init():void {
            model = GameManager.getInstance();
            model.addEventListener(MarbleEvent.RENDER, renderScreen);
            model.addEventListener(MarbleEvent.GAME_OVER, showGameResults);
            model.addEventListener(MarbleEvent.TOTAL_PLAYERS_CHANGED, updateTotalPlayersOnStage);
            models = new Array();
            //players = new Dictionary();
        }

        protected function movePlayer(player:Player):void {
            player.vx *= FRICTION;
            player.vy *= FRICTION;

            player.x += player.vx;
            player.z -= player.vy;
            player.roll(player.vx * -.5);
            player.pitch(player.vy * -.5);
        }

        protected function updateTotalPlayersOnStage(e:Event):void {

            if (_viewManager.currentViewState == View.CARD) {
                return;
            }
            else {
                for (var i:uint = 0; i < model.playersInGame.length; i++) {
                    var player:Player = model.playersInGame[i] as Player;

                    if (player.isPlaying) {
                    }
                    else {
                        ChannelView(_currentView).awayWorld.scene.addChild(player);
                    }
                }
            }

        }

        protected function checkForCollision():Boolean {
            if (model.playersInGame.length > 1) {
                var distX:Number = Player(model.playersInGame[1]).x - Player(model.playersInGame[0]).x;
                var distZ:Number = Player(model.playersInGame[1]).z - Player(model.playersInGame[0]).z;
                var dist:Number = Math.sqrt(distX * distX + distZ * distZ);

                if (dist < Player(model.playersInGame[1]).radius * 2) {
                    return true;
                }
                else {
                    return false;
                }
            }
            else {
                return false;
            }
        }

        protected function swapVelovities():void {
            var tempX:Number = Player(model.playersInGame[0]).vx;
            var tempY:Number = Player(model.playersInGame[0]).vy;
            Player(model.playersInGame[0]).vx = Player(model.playersInGame[1]).vx * 1.5;
            Player(model.playersInGame[0]).vy = Player(model.playersInGame[1]).vy * 1.5;
            Player(model.playersInGame[1]).vx = tempX * 1.5;
            Player(model.playersInGame[1]).vy = tempY * 1.5;
        }

        protected function renderScreen(e:Event):void {
            if (_viewManager.currentViewState == View.CHANNEL && model.gameInProgress == true) {
                trace(checkForCollision());

                if (checkForCollision() == true) {
                    //calculateScores(true);
                    swapVelovities();
                }

                //calculateScores(false);

                for (var i:uint = 0; i < model.playersInGame.length; i++) {
                    movePlayer(model.playersInGame[i] as Player);
                }

                // render the 3d scene
                ChannelView(_currentView).awayWorld.render();
            }

        /*if (_view.player0.x < _view.floor.x - _view.floor.width / 2) {
           _view.player0.y -= GRAVITY;
           }
           else if (_view.player0.x > _view.floor.x + _view.floor.width / 2) {
           _view.player0.y -= GRAVITY;
           }
           else if (_view.player0.z > _view.floor.z + _view.floor.height / 2) {
           _view.player0.y -= GRAVITY;
           }
           else if (_view.player0.z < _view.floor.z - _view.floor.height / 2) {
           _view.player0.y -= GRAVITY;
           }

           if (_view.player1.x < _view.floor.x - _view.floor.width / 2) {
           _view.player1.y -= GRAVITY;
           }
           else if (_view.player1.x > _view.floor.x + _view.floor.width / 2) {
           _view.player1.y -= GRAVITY;
           }
           else if (_view.player1.z > _view.floor.z + _view.floor.height / 2) {
           _view.player1.y -= GRAVITY;
           }
           else if (_view.player1.z < _view.floor.z - _view.floor.height / 2) {
           _view.player1.y -= GRAVITY;
           }

           if (_view.player0.y < _view.floor.y) {
           _view.player0.y -= GRAVITY;
           }

           if (_view.player1.y < _view.floor.y) {
           _view.player1.y -= GRAVITY;
           }

           if (_view.player1.y < -1000) {
           resetObjects(1);
           model.addToScores(0, 200);
           model.playerDied(1);
           }

           if (_view.player0.y < -1000) {
           resetObjects(0);
           model.addToScores(200, 0);
           model.playerDied(2);
           }

         _view.view.render();*/
        }

        private function startNewGame(e:UserInputMessage):void {
            if (model.gameInProgress) {
                model.startNewGame();
            }
            else {
                model.startNewGame();
            }
        }

        /*private function resetObjects(player:Number = 0):void {
           if (player == 0) {
           _view.player0.x = -150;
           _view.player0.z = -4100;
           _view.player0.y = _view.player0.radius + 5;
           }
           else if (player == 1) {
           _view.player1.x = -50;
           _view.player1.z = -4000;
           _view.player1.y = _view.player1.radius + 5;
           }
           else {
           _view.player0.x = 150;
           _view.player0.z = -4100;
           _view.player0.y = _view.player0.radius + 5;
           _view.player1.x = -50;
           _view.player1.z = -4000;
           _view.player1.y = _view.player1.radius + 5;
           }
         }*/

        /*private function calculateScores(hit:Boolean):void {
           if (hit == true) {
           var p2:Number = Math.abs(Math.round((player1VX + player1VY) * 10));
           var p1:Number = Math.abs(Math.round((player2VX + player2VY) * 10));

           if (p1 > p2) {
           model.addToScores(p1 - p2, 0);
           model.addWinningCollision(1);
           }
           else if (p1 < p2) {
           model.addToScores(0, p2 - p1);
           model.addWinningCollision(2);
           }
           }
           else if (hit == false) {
           //                var center:Point = new Point(floor.x / 2, floor.height / 2);
           //
           //                var dist0X:Number = player0.x - center.x;
           //                var dist0Z:Number = player0.z - center.y;
           //                var dist0:Number = Math.sqrt(dist0X * dist0X + dist0Z * dist0Z);
           //
           //                var dist1X:Number = player1.x - center.x;
           //                var dist1Z:Number = player1.z - center.y;
           //                var dist1:Number = Math.sqrt(dist1X * dist1X + dist1Z * dist1Z);
           //
           //                trace("player 1: " + dist0);
           //                trace("player 2: " + dist1);
           }
         }*/

        private function showGameResults(e:Event):void {
            model.pauseGame();
        }

        private function rotate(x:Number, y:Number, sin:Number, cos:Number, reverse:Boolean):Point {
            var result:Point = new Point();

            if (reverse) {
                result.x = x * cos + y * sin;
                result.y = y * cos - x * sin;
            }
            else {
                result.x = y * cos - y * sin;
                result.y = y * cos + x * sin;
            }
            return result;
        }

        public function set currentView(value:ViewBase):void {
            _currentView = value;
        }

        public function set viewManager(value:LitlViewManager):void {
            _viewManager = value;
        }

    }
}

class SingletonEnforcer
{
}
