package com.litl.marbelmayhem.model.service
{
    import com.litl.helpers.richinput.remotehandler.IRemoteHandler;
    import com.litl.helpers.richinput.remotehandler.IRemoteHandlerFactory;
    import com.litl.helpers.richinput.remotehandler.RemoteHandlerManager;
    import com.litl.sdk.richinput.IRemoteControl;
    import com.litl.sdk.service.LitlService;

    import flash.events.IEventDispatcher;

    public class LitlRemoteManager extends RemoteHandlerManager
    {
        public function LitlRemoteManager(service:LitlService, factory:IRemoteHandlerFactory, target:IEventDispatcher = null) {
            super(service, factory, target);

            start();
        }

        override protected function onRemoteConnected(remote:IRemoteControl, handler:IRemoteHandler):void {
            trace("Remote Connected");
        }

        override protected function onRemoteDisconnected(remote:IRemoteControl, handler:IRemoteHandler):void {
            trace("Remote Disconnected");
        }

    }
}
