package com.ryancanulla.marbelmayhem.views
{
    import com.ryancanulla.marbelmayhem.model.GameManager;
    import com.ryancanulla.marbelmayhem.vo.Player;

    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.text.TextField;

    public class PlayerInfo extends Sprite
    {
        protected var model:GameManager;
        private var _player:Player;
        private var _index:Number = 0;

        public function PlayerInfo() {
            super();
            model = GameManager.getInstance();
        }

        protected function createChildren():void {

            var playerIcon:Loader = new Loader;
            playerIcon.load(new URLRequest("../assets/scoreboard/playerOneIcon.png"));
            addChild(playerIcon);

            var playerScore:TextField = new TextField();
            playerScore.defaultTextFormat = scoreFormat;
            playerScore.setTextFormat(scoreFormat);
            addChild(playerScore);
        }
    }
}
