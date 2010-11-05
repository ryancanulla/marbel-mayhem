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
        private static const THREE_STATE:Number = 1;
        private static const TWO_STATE:Number = 2;
        private static const ONE_STATE:Number = 3;
        private static const PLAY_STATE:Number = 4;
        private static const OFF_STATE:Number = 0;

        private var _index:int = 0;
        private var model:GameManager = GameManager.getInstance();

        private var three:Loader;
        private var two:Loader;
        private var one:Loader;
        private var play:Loader;

        public function CountDown() {
            super();
            createChildren();
            model.countdown.addEventListener(TimerEvent.TIMER, changeCount);
            model.countdown.addEventListener(TimerEvent.TIMER_COMPLETE, turnCountdownOff);
        }

        private function createChildren():void {
            one = new Loader();
            one.load(new URLRequest("../assets/countdown/1.png"));
            addChild(one);

            two = new Loader();
            two.load(new URLRequest("../assets/countdown/2.png"));
            addChild(two);

            three = new Loader();
            three.load(new URLRequest("../assets/countdown/3.png"));
            addChild(three);

            play = new Loader();
            play.load(new URLRequest("../assets/countdown/play.png"));
            addChild(play);
            updateDisplay();
            updateLayout();
        }

        private function updateDisplay():void {
            switch (_index) {
                case THREE_STATE:
                    three.visible = true;
                    two.visible = false;
                    one.visible = false
                    play.visible = false;
                    break;
                case TWO_STATE:
                    three.visible = false;
                    two.visible = true;
                    one.visible = false
                    play.visible = false;
                    break;
                case ONE_STATE:
                    three.visible = false;
                    two.visible = false;
                    one.visible = true;
                    play.visible = false;
                    break;
                case PLAY_STATE:
                    three.visible = false;
                    two.visible = false;
                    one.visible = false
                    play.visible = true;
                    break;
                case OFF_STATE:
                    three.visible = false;
                    two.visible = false;
                    one.visible = false
                    play.visible = false;
                    break;
            }

        }

        private function changeCount(e:TimerEvent):void {
            switch (Timer(e.currentTarget).currentCount) {
                case THREE_STATE:
                    _index = THREE_STATE;
                    break;
                case TWO_STATE:
                    _index = TWO_STATE;
                    break;
                case ONE_STATE:
                    _index = ONE_STATE;
                    break;
                case PLAY_STATE:
                    _index = PLAY_STATE;
                    break;
                case OFF_STATE:
                    _index = OFF_STATE;
            }
            updateDisplay();
        }

        private function updateLayout():void {
            one.x = 550;
            one.y = 200;
            two.x = 550;
            two.y = 200;
            three.x = 550;
            three.y = 200;
            play.x = 300;
            play.y = 200;
        }

        public function turnCountdownOff(e:TimerEvent):void {
            _index = OFF_STATE;
            updateDisplay();
        }

    }
}
