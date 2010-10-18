package com.litl.marbelmayhem.views
{
    import com.litl.marbelmayhem.model.GameManager;

    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.TimerEvent;
    import flash.net.URLRequest;
    import flash.utils.Timer;

    import org.osmf.events.TimeEvent;

    public class CountDown extends Sprite
    {
        private var _stage:Stage;
        private var _index:int = 4;
        private var model:GameManager = GameManager.getInstance();

        private var three:Loader;
        private var two:Loader;
        private var one:Loader;
        private var play:Loader;

        public function CountDown(e:Stage) {
            super();
            _stage = e;
            createChildren();
            model.countdown.addEventListener(TimerEvent.TIMER, changeCount);
        }

        private function createChildren():void {
            one = new Loader();
            one.x = 0;
            one.load(new URLRequest("../assets/countdown/1.png"));
            addChild(one);

            two = new Loader();
            two.load(new URLRequest("../assets/countdown/2.png"));
            addChild(two);

            three = new Loader();
            three.load(new URLRequest("../assets/countdown/3.png"));
            addChild(three);

            play = new Loader();
            play.load(new URLRequest("../assets/countdown/3.png"));
            addChild(play);
            updateDisplay();
        }

        private function updateDisplay():void {
            switch (_index) {
                case 4:
                    three.visible = true;
                    two.visible = false;
                    one.visible = false
                    play.visible = false;
                    break;
                case 3:
                    three.visible = false;
                    two.visible = true;
                    one.visible = false
                    play.visible = false;
                    break;
                case 2:
                    three.visible = false;
                    two.visible = false;
                    one.visible = true;
                    play.visible = false;
                    break;
                case 1:
                    three.visible = false;
                    two.visible = false;
                    one.visible = false
                    play.visible = true;
                    break;
            }

        }

        private function changeCount(e:TimerEvent):void {
            trace(_index);
            _index = _index - 1;
            //updateDisplay();
        }

    }
}
