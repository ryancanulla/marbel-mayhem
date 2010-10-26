package com.litl.marbelmayhem.views
{
    import com.litl.marbelmayhem.events.MarbleEvent;
    import com.litl.marbelmayhem.model.GameManager;
    import com.litl.marbelmayhem.vo.Player;

    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.net.URLRequest;
    import flash.utils.Dictionary;

    import org.osmf.utils.URL;

    public class PlayerLife extends Sprite
    {
        protected var playerIconURL:String;
        protected var player:Player;
        protected var model:GameManager = GameManager.getInstance();
        private var playerLifeOne:Loader;
        private var playerLifeTwo:Loader;
        private var playerLifeThree:Loader;
        private var playerLifeFour:Loader;
        private var playerLifeFive:Loader;

        public function PlayerLife() {
            super();
            model.addEventListener(MarbleEvent.PLAYER_DIED, updateProperties);
            model.addEventListener(MarbleEvent.START_NEW_GAME, reset);
            init();
        }

        protected function init():void {
            createChildren();
        }

        protected function createChildren():void {

            playerLifeOne = new Loader();
            playerLifeOne.load(new URLRequest(playerIconURL));
            addChild(playerLifeOne);

            playerLifeTwo = new Loader();
            playerLifeTwo.load(new URLRequest(playerIconURL));
            addChild(playerLifeTwo);

            playerLifeThree = new Loader();
            playerLifeThree.load(new URLRequest(playerIconURL));
            addChild(playerLifeThree);

            playerLifeFour = new Loader();
            playerLifeFour.load(new URLRequest(playerIconURL));
            addChild(playerLifeFour);

            playerLifeFive = new Loader();
            playerLifeFive.load(new URLRequest(playerIconURL));
            addChild(playerLifeFive);

            updateLayout();
            updateProperties();
        }

        protected function updateLayout():void {
            playerLifeOne.x = 0;
            playerLifeTwo.x = 25;
            playerLifeThree.x = 50;
            playerLifeFour.x = 75;
            playerLifeFive.x = 100;
        }

        protected function updateProperties(e:Event = null):void {
            switch (player.lives) {
                case 5:
                    playerLifeFive.visible = true;
                    playerLifeFour.visible = true;
                    playerLifeThree.visible = true;
                    playerLifeTwo.visible = true;
                    playerLifeOne.visible = true;
                    break;
                case 4:
                    playerLifeFive.visible = false;
                    playerLifeFour.visible = true;
                    playerLifeThree.visible = true;
                    playerLifeTwo.visible = true;
                    playerLifeOne.visible = true;
                    break;
                case 3:
                    playerLifeFive.visible = false;
                    playerLifeFour.visible = false;
                    playerLifeThree.visible = true;
                    playerLifeTwo.visible = true;
                    playerLifeOne.visible = true;
                    break;
                case 2:
                    playerLifeFive.visible = false;
                    playerLifeFour.visible = false;
                    playerLifeThree.visible = false;
                    playerLifeTwo.visible = true;
                    playerLifeOne.visible = true;
                    break;
                case 1:
                    playerLifeFive.visible = false;
                    playerLifeFour.visible = false;
                    playerLifeThree.visible = false;
                    playerLifeTwo.visible = false;
                    playerLifeOne.visible = true;
                    break;
                case 0:
                    playerLifeFive.visible = false;
                    playerLifeFour.visible = false;
                    playerLifeThree.visible = false;
                    playerLifeTwo.visible = false;
                    playerLifeOne.visible = false;
                    break;
            }
        }

        private function reset(e:Event):void {
            playerLifeFive.visible = true;
            playerLifeFour.visible = true;
            playerLifeThree.visible = true;
            playerLifeTwo.visible = true;
            playerLifeOne.visible = true;
        }
    }
}
