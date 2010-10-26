package com.litl.marbelmayhem.views
{

    public class PlayerOneLife extends PlayerLife
    {

        public function PlayerOneLife() {
            super();
        }

        override protected function init():void {
            playerIconURL = "../assets/scoreboard/playerOneLife.png";
            player = model.player1;
            createChildren();
        }
    }
}
