package com.litl.marbelmayhem.model.service
{
    import com.litl.helpers.richinput.remotehandler.IRemoteHandler;
    import com.litl.helpers.richinput.remotehandler.IRemoteHandlerFactory;

    public class RemoteFactory implements IRemoteHandlerFactory
    {
        public static const INVALID_PLAYER_ID:int = -1;

        private var nextPlayerId:int = INVALID_PLAYER_ID;

        public function RemoteFactory() {
        }

        public function createHandler():IRemoteHandler {
            return new Remote(++nextPlayerId);
        }

        public function get klass():Class {
            return Remote;
        }
    }
}
