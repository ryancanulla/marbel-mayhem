package com.litl.marbelmayhem.views
{

    public class PlayerTwoLife extends PlayerLife
    {

        public function PlayerTwoLife() {
            super();
        }

        override protected function init():void {
            playerIconURL = "../assets/scoreboard/playerTwoLife.png";
            //player = model.player2;
            createChildren();
        }
    }
}
