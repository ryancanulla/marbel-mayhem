package com.litl.marbelmayhem.controller
{

    import com.litl.marbelmayhem.events.MarbleEvent;
    import com.litl.marbelmayhem.model.GameManager;
    import com.litl.marbelmayhem.model.service.LitlViewManager;
    import com.litl.marbelmayhem.views.ChannelView;
    import com.litl.marbelmayhem.views.ViewBase;
    import com.litl.marbelmayhem.vo.Player;
    import com.litl.sdk.enum.View;
    import com.litl.sdk.message.UserInputMessage;

    import flash.events.Event;
    import flash.geom.Point;

    public class GameController
    {
        private static var _instance:GameController;
        private var _currentView:ViewBase;
        private var _viewManager:LitlViewManager;
        public var model:GameManager;

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
            model.addEventListener(MarbleEvent.ADD_PLAYER, addPlayerToStage);
            model.addEventListener(MarbleEvent.REMOVE_PLAYER, removePlayerFromStage);
        }

        protected function movePlayer(player:Player):void {
            player.vx *= FRICTION;
            player.vz *= FRICTION;

            player.x += player.vx;
            player.z -= player.vz;
            player.roll(player.vx * -.5);
            player.pitch(player.vz * -.5);
        }

        public function addPlayerToStage(e:MarbleEvent):void {
            if (_viewManager.currentViewState == View.CHANNEL) {
                ChannelView(_currentView).addPlayer(e.player);
            }
        }

        public function removePlayerFromStage(e:MarbleEvent):void {
            if (_viewManager.currentViewState == View.CHANNEL) {
                ChannelView(_currentView).removePlayer(e.player);
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
            var tempZ:Number = Player(model.playersInGame[0]).vz;
            Player(model.playersInGame[0]).vx = Player(model.playersInGame[1]).vx * 1.5;
            Player(model.playersInGame[0]).vz = Player(model.playersInGame[1]).vz * 1.5;
            Player(model.playersInGame[1]).vx = tempX * 1.5;
            Player(model.playersInGame[1]).vz = tempZ * 1.5;
        }

        protected function addGravity(player:Player):void {
            if (player.x < ChannelView(_currentView).floor.x - ChannelView(_currentView).floor.width / 2) {
                player.y -= GRAVITY;
            }
            else if (player.x > ChannelView(_currentView).floor.x + ChannelView(_currentView).floor.width / 2) {
                player.y -= GRAVITY;
            }
            else if (player.z > ChannelView(_currentView).floor.z + ChannelView(_currentView).floor.height / 2) {
                player.y -= GRAVITY;
            }
            else if (player.z < ChannelView(_currentView).floor.z - ChannelView(_currentView).floor.height / 2) {
                player.y -= GRAVITY;
            }

            // if under the floor then keep falling
            if (player.y < ChannelView(_currentView).floor.y) {
                player.y -= GRAVITY;
            }

            // you die after falling 1000 ft
            if (player.y < -1000) {
                model.playerDied(player);
            }
        }

        protected function renderScreen(e:Event):void {
            if (_viewManager.currentViewState == View.CHANNEL && model.gameInProgress == true) {

                if (checkForCollision() == true) {
                    //calculateScores(true);
                    swapVelovities();
                }

                //calculateScores(false);

                for (var i:uint = 0; i < model.playersInGame.length; i++) {
                    movePlayer(model.playersInGame[i] as Player);
                    addGravity(model.playersInGame[i] as Player);
                }

                // render the 3d scene
                ChannelView(_currentView).awayWorld.render();
            }
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

        private function calculateScores(hit:Boolean):void {
            if (hit == true) {
                var player1:Player = model.playersInGame[0]
                var player2:Player = model.playersInGame[1];

                var player1TotalVelocity:Number = Math.abs(Math.round(Player(model.playersInGame[0]).vx + Player(model.playersInGame[0]).vz));
                var player2TotalVelocity:Number = Math.abs(Math.round(Player(model.playersInGame[1]).vx + Player(model.playersInGame[1]).vz));

                if (player1TotalVelocity > player2TotalVelocity) {
                    model.addToScores(player1, player1TotalVelocity - player2TotalVelocity);
                    model.addWinningCollision(player1);
                }
                else if (player2TotalVelocity > player1TotalVelocity) {
                    model.addToScores(player2, player2TotalVelocity - player1TotalVelocity);
                    model.addWinningCollision(player2);
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
        }

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
