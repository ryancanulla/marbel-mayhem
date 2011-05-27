package com.ryancanulla.marbelmayhem.views
{
    import com.ryancanulla.marbelmayhem.events.MarbleEvent;
    import com.ryancanulla.marbelmayhem.model.GameManager;
    import com.ryancanulla.marbelmayhem.vo.Player;

    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.net.URLRequest;
    import flash.utils.Dictionary;

    import org.osmf.utils.URL;

    public class PlayerLife extends Sprite
    {
        protected var model:GameManager = GameManager.getInstance();
        protected var playerIconURL:String;
        protected var player:Player;
        protected var playerLife:Loader;
        protected var lives:Dictionary;
        protected var _remoteID:String;
        private static const MAX_LIVES:Number = 5;

        private var _total:Number = 5;

        public function PlayerLife() {
            super();
            model.addEventListener(MarbleEvent.PLAYER_DIED, updateProperties);
            model.addEventListener(MarbleEvent.START_NEW_GAME, reset);
            lives = new Dictionary();
            init();
        }

        protected function init():void {
            createChildren();
        }

        protected function createChildren():void {
            for (var i:int = 0; i < MAX_LIVES; i++) {
                var playerLife:Loader = new Loader();
                playerLife.load(new URLRequest(playerIconURL));
                playerLife.x = i * 25;
                lives[i] = playerLife;
                addChild(playerLife);
            }
            updateLayout();
        }

        protected function updateLayout():void {

        }

        protected function updateProperties(e:MarbleEvent):void {
            for (var i:uint = 0; i < MAX_LIVES; i++) {
                if (i >= e.player.lives && _remoteID == e.player.remoteID) {
                    var playerLife:Loader = lives[i];
                    playerLife.visible = false;
                }
            }
        }

        private function reset(e:Event):void {
            for (var i:uint = 0; i < MAX_LIVES; i++) {
                var playerLife:Loader = lives[i];
                playerLife.visible = true;
            }
        }

        public function set remoteID(e:String):void {
            _remoteID = e;
        }
    }
}
