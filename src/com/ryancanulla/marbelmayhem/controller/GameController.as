package com.ryancanulla.marbelmayhem.controller
{

    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.core.Object3DContainer;
    import alternativa.engine3d.core.Sorting;
    import alternativa.engine3d.objects.Sprite3D;
    import alternativa.engine3d.primitives.Plane;

    import com.ryancanulla.marbelmayhem.events.MarbleEvent;
    import com.ryancanulla.marbelmayhem.model.GameManager;
    import com.ryancanulla.marbelmayhem.service.RemoteManager;
    import com.ryancanulla.marbelmayhem.service.ServiceManager;
    import com.ryancanulla.marbelmayhem.views.ChannelView;
    import com.ryancanulla.marbelmayhem.views.ViewBase;
    import com.ryancanulla.marbelmayhem.vo.Player;

    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.geom.Vector3D;

    public class GameController
    {
        private static var _instance:GameController;
        private var _currentView:ViewBase;
        public var model:GameManager;
		private var _service:ServiceManager;
		private var _remoteManager:RemoteManager;

        private static const FRICTION:Number = .95;
        private static const SPEED:Number = 8;
        private static const GRAVITY:Number = 37;
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
            player.rotationX = player.vx * .05;
            player.rotationZ = player.vz * .05;
        }

        public function addPlayerToStage(e:MarbleEvent):void {
                ChannelView(_currentView).addPlayer(e.player);
        }

        public function removePlayerFromStage(e:MarbleEvent):void {
                ChannelView(_currentView).removePlayer(e.player);
        }

        protected function checkForCollision():Boolean {
            if (model.playersInGame.length > 1) {
                var player1:Player = model.playersInGame[0];
                var player2:Player = model.playersInGame[1];

                var dx:Number = player1.x - player2.x;
                var dy:Number = player1.y - player2.y;
                var dz:Number = player1.z - player2.z;
                var dist:Number = Math.sqrt(dx * dx + dy * dy + dz * dz);

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
            return false;
        }

        protected function swapVelovities():void {
            var tempX:Number = Player(model.playersInGame[0]).vx;
            var tempZ:Number = Player(model.playersInGame[0]).vz;

            Player(model.playersInGame[0]).vx = Player(model.playersInGame[1]).vx * 1.5;
            Player(model.playersInGame[0]).vz = Player(model.playersInGame[1]).vz * 1.5;
            Player(model.playersInGame[1]).vx = tempX * 1.5;
            Player(model.playersInGame[1]).vz = tempZ * 1.5;
        }

        protected function playerInBounds(player:Player):Boolean {
            var floor:Plane = ChannelView(_currentView).floor;

            if (player.x - 100 > floor.x + floor.boundMaxX) { // right
                return false;
            }
            else if (player.x + 100 < floor.x + floor.boundMinX) { // left
                return false;
            }
            else if (player.z - 20 < floor.z - floor.boundMaxX) { // front
                return false;
            }
            else if (player.z - 325 > floor.z + floor.boundMaxX) { // back
                return false;
            }

            if (player.y > floor.y) {
                return false;
            }
            return true;
        }

        protected function addGravity(player:Player):void {
            if (!playerInBounds(player)) {
                var channelView:ChannelView = _currentView as ChannelView;
                var container:Object3DContainer = channelView.container;
                var floor:Plane = channelView.floor;

                player.y += GRAVITY;

                if (!player.isFalling) {
                    player.isFalling = true;

                    container.setChildIndex(floor, container.numChildren);

                    for (var i:uint = 0; i < model.playersInGame.length; i++) {
                        var otherPlayer:Player = model.playersInGame[i];

                        if (otherPlayer !== player) {
                            container.setChildIndex(otherPlayer, container.numChildren);
                        }
                    }
                }

            }

            // you die after falling 1000 ft
            if (player.y > 1500) {
                if (model.gameInProgress) {
                    model.playerDied(player);
                }

                resetObject(player);
            }
        }

        protected function renderScreen(e:Event):void {

                if (checkForCollision() == true) {
                    swapVelovities();

                    if (model.gameInProgress)
                        calculateScores(true);
                }

                if (model.gameInProgress)
                    calculateScores(false);

                if (!model.gamePaused) {
                    for (var i:uint = 0; i < model.playersInGame.length; i++) {
                        var player:Player = model.playersInGame[i];
                        movePlayer(player);
                        addGravity(player);
                    }
//                    sortZ();
                }
        }

        protected function sortZ():void {
            var channelView:ChannelView = _currentView as ChannelView;
            var container:Object3DContainer = channelView.container;

            model.playersInGame.sortOn("z", Array.DESCENDING | Array.NUMERIC);

            for (var i:uint = 0; i < model.playersInGame.length; i++) {
                var player:Player = model.playersInGame[i];

                if (!player.isFalling) {
                    container.setChildIndex(player, container.numChildren);
                }
            }

        }

        private function startNewGame(e:Event):void {
            if (model.gameInProgress) {
                model.startNewGame();
            }
            else {
                model.startNewGame();
            }
        }

        private function resetObject(player:Player):void {
            var channelView:ChannelView = _currentView as ChannelView;
            var container:Object3DContainer = channelView.container;
            var floor:Plane = channelView.floor;

            player.x = floor.boundMinX + (Math.random() * floor.boundMaxX);
            player.y = floor.y;
            player.z = floor.z;
            player.isFalling = false;

            container.setChildIndex(player, container.numChildren);
        }

		private function remoteUpdate(e:MarbleEvent):void {
			model.myPlayer.vx -= e.accelerometerRemote.accX * SPEED;
			model.myPlayer.vz += e.accelerometerRemote.accY * SPEED;
		}

        private function calculateScores(hit:Boolean):void {
            if (hit == true) {
                var player1:Player;
                var player2:Player;

                var player1TotalVelocity:Number;
                var player2TotalVelocity:Number;

                for (var i:uint = 0; i < model.playersInGame.length; i++) {
                    var player:Player = model.playersInGame[i] as Player;

                    if (player.playerID == 1) {
                        player1 = player;
                        player1TotalVelocity = Math.abs(Math.round(player1.vx + player1.vz));
                    }
                    else if (player.playerID == 2) {
                        player2 = player;
                        player2TotalVelocity = Math.abs(Math.round(player2.vx + player2.vz));
                    }
                }

                if (player1TotalVelocity > player2TotalVelocity) {
                    model.addToScores(player2, player1TotalVelocity - player2TotalVelocity);
                    model.addWinningCollision(player2);
                }
                else if (player2TotalVelocity > player1TotalVelocity) {
                    model.addToScores(player1, player2TotalVelocity - player1TotalVelocity);
                    model.addWinningCollision(player1);
                }
            }
            else if (hit == false) {

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

		public function set remoteManager(e:RemoteManager):void {
			_remoteManager = e;
			_remoteManager.addEventListener(MarbleEvent.REMOTE_UPDATE, remoteUpdate);
		}

		public function set currentView(e:ViewBase):void {
			_currentView = e;
		}

		public function set service(value:ServiceManager):void	{
			_service = value;
		}

    }
}

class SingletonEnforcer
{
}
