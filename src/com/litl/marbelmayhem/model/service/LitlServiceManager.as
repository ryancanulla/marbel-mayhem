package com.litl.marbelmayhem.model.service
{
    import com.litl.marbelmayhem.views.CardView;
    import com.litl.marbelmayhem.views.ChannelView;
    import com.litl.marbelmayhem.views.ViewBase;
    import com.litl.sdk.enum.View;
    import com.litl.sdk.message.InitializeMessage;
    import com.litl.sdk.message.UserInputMessage;
    import com.litl.sdk.message.ViewChangeMessage;
    import com.litl.sdk.richinput.RemoteManager;
    import com.litl.sdk.service.LitlService;

    import flash.display.Sprite;
    import flash.utils.Dictionary;

    public class LitlServiceManager extends Sprite
    {
        private var _service:LitlService;
        private var remoteManager:LitlRemoteManager;
        private static var _instance:LitlServiceManager;

        public function LitlServiceManager(enforcer:SingletonEnforcer) {

        }

        public static function getInstance():LitlServiceManager {
            if (LitlServiceManager._instance == null) {
                LitlServiceManager._instance = new LitlServiceManager(new SingletonEnforcer());
            }
            return LitlServiceManager._instance;
        }

        protected function connect():void {
            _service.connect("", "", "", false);
        }

        protected function createRemoteManager():void {
            remoteManager = new LitlRemoteManager(_service, new RemoteFactory());
        }

        public function get service():LitlService {
            return _service;
        }

        public function set view(view:Sprite):void {
            if (_service == null) {
                _service = new LitlService(view);
                connect();
                createRemoteManager();
            }

        }

    }
}

class SingletonEnforcer
{
}
