package com.litl.marbelmayhem.model.service
{
    import com.litl.helpers.richinput.remotehandler.AccelerometerRemoteHandler;
    import com.litl.helpers.richinput.remotehandler.IRemoteHandler;
    import com.litl.sdk.event.AccelerometerEvent;

    public class Remote extends AccelerometerRemoteHandler implements IRemoteHandler
    {
        protected var _id:int;

        public function Remote(id:int) {
            super();

            _id = id;
        }

        override protected function onAccelerometerEvent(e:AccelerometerEvent):void {
            trace("Accelerometer Event: " + _id);
        }
    }
}
