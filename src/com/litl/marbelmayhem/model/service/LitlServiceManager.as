package com.litl.marbelmayhem.model.service
{
    import com.litl.marbelmayhem.views.CardView;
    import com.litl.marbelmayhem.views.ChannelView;
    import com.litl.marbelmayhem.views.ViewBase;
    import com.litl.sdk.enum.View;
    import com.litl.sdk.message.InitializeMessage;
    import com.litl.sdk.message.ViewChangeMessage;
    import com.litl.sdk.service.LitlService;

    import flash.display.Sprite;
    import flash.utils.Dictionary;

    public class LitlServiceManager extends Sprite
    {
        private var _service:LitlService;

        public function LitlServiceManager(view:Sprite) {
            _service = new LitlService(view);
            addServiceListeners();
            connect();
        }

        protected function connect():void {
            _service.connect("", "", "", false);
        }

        protected function addServiceListeners():void {
            //service.addEventListener(InitializeMessage.INITIALIZE,
        }

        public function get service():LitlService {
            return _service;
        }

    }
}
