package com.litl.marbelmayhem.model.service
{
    import com.litl.helpers.richinput.remotehandler.AccelerometerRemoteHandler;
    import com.litl.helpers.richinput.remotehandler.IRemoteHandler;
    import com.litl.marbelmayhem.model.GameManager;
    import com.litl.marbelmayhem.vo.Player;
    import com.litl.sdk.event.AccelerometerEvent;
    import com.litl.sdk.richinput.Accelerometer;
    import com.litl.sdk.richinput.AccelerometerSmoothingLevel;
    import com.litl.sdk.richinput.IRemoteControl;

    public class Remote extends AccelerometerRemoteHandler implements IRemoteHandler
    {
        protected var _id:int;
        protected var remoteID:String;
        private var model:GameManager;

        public function Remote(id:int) {
            super();
            model = GameManager.getInstance();
            _id = id;
        }

        override protected function onAccelerometerEvent(e:AccelerometerEvent):void {
            for (var i:uint = 0; i < model.playersInGame.length; i++) {
                if (Player(model.playersInGame[i]).remoteID == remoteID) {
                    Player(model.playersInGame[i]).vx += e.accelerationY * 3;
                    Player(model.playersInGame[i]).vz += e.accelerationX * 3;
                }
            }
        }

        override public function pair(remote:IRemoteControl):void {
            remoteID = remote.id;

            if (remote.hasAccelerometer) {
                remote.accelerometer.setXSmoothingLevel(AccelerometerSmoothingLevel.OFF);
                remote.accelerometer.setYSmoothingLevel(AccelerometerSmoothingLevel.OFF);
                remote.accelerometer.addEventListener(AccelerometerEvent.UPDATE,
                                                      onAccelerometerEvent, false, 0, true);
            }
        }
    }
}
