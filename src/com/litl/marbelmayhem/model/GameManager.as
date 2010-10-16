package com.litl.marbelmayhem.model
{

    public class GameManager
    {
        private static var _instance:GameManager;

        public function GameManager(enforcer:SingletonEnforcer) {
        }

        public static function getInstance():GameManager {
            if (GameManager._instance == null) {
                GameManager._instance = new GameManager(new SingletonEnforcer());
            }
            return GameManager._instance;
        }

    }

}

class SingletonEnforcer
{
}
