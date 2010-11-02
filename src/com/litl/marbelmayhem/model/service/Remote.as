package com.litl.marbelmayhem.model.service
{
    import com.litl.helpers.richinput.remotehandler.AccelerometerRemoteHandler;
    import com.litl.helpers.richinput.remotehandler.IRemoteHandler;
    import com.litl.marbelmayhem.model.GameManager;
    import com.litl.marbelmayhem.vo.Player;
    import com.litl.sdk.event.AccelerometerEvent;

    public class Remote extends AccelerometerRemoteHandler implements IRemoteHandler
    {
        protected var _id:int;
        private var model:GameManager;

        public function Remote(id:int) {
            super();
            model = GameManager.getInstance();
            _id = id;
        }

        override protected function onAccelerometerEvent(e:AccelerometerEvent):void {
            Player(model.playersInGame[_id]).vx += e.accelerationX * 2;
            Player(model.playersInGame[_id]).vy += e.accelerationY * 2;
        }
    }
}
