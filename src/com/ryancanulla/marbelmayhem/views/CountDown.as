package com.ryancanulla.marbelmayhem.views
{
    import com.ryancanulla.marbelmayhem.model.GameManager;
    import com.ryancanulla.marbelmayhem.utils.CountdownAssets;

    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.TimerEvent;
    import flash.net.URLRequest;
    import flash.utils.Dictionary;
    import flash.utils.Timer;

    import org.osmf.events.TimeEvent;

    public class CountDown extends ViewBase
    {
        private static const THREE_STATE:Number = 1;
        private static const TWO_STATE:Number = 2;
        private static const ONE_STATE:Number = 3;
        private static const PLAY_STATE:Number = 4;
        private static const OFF_STATE:Number = 0;

        private var _index:int = 0;
        private var model:GameManager = GameManager.getInstance();
        private var gameAssets:CountdownAssets = new CountdownAssets();

        private var three:Bitmap;
        private var two:Bitmap;
        private var one:Bitmap;
        private var play:Bitmap;

        protected var currentView:Bitmap;
        protected var views:Dictionary;

        public function CountDown() {
            super();
            createChildren();
            views = new Dictionary();
            model.countdown.addEventListener(TimerEvent.TIMER, changeCount);
            model.countdown.addEventListener(TimerEvent.TIMER_COMPLETE, turnCountdownOff);
        }

        private function createChildren():void {

            one = gameAssets.OneBitmap;
            one.cacheAsBitmap = true;
            //addChild(one);

            two = gameAssets.TwoBitmap;
            two.cacheAsBitmap = true;
            //addChild(two);

            three = gameAssets.ThreeBitmap;
            three.cacheAsBitmap = true;
            //addChild(three);

            play = gameAssets.PlayBitmap;
            play.cacheAsBitmap = true;
            //addChild(play);
        }

        private function updateDisplay():void {
            if (currentView && contains(currentView)) {
                removeChild(currentView);
            }

            if (views == null)
                views = new Dictionary(false);

            currentView = views[_index.toString()] as Bitmap;

            switch (_index) {
                default:
                    throw new Error("Unknown view state");
                    break;

                case OFF_STATE:
                    currentView = new Bitmap();
                    break;
                case ONE_STATE:
                    currentView = one;
                    break;
                case TWO_STATE:
                    currentView = two;
                    break;
                case THREE_STATE:
                    currentView = three;
                    break;
                case PLAY_STATE:
                    currentView = play;
                    break;
            }

            views[_index.toString()] = currentView;

            if (!contains(currentView)) {
                addChild(currentView);
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

        override protected function sizeUpdated():void {
            one.x = this.width / 2 - one.width / 2;
            one.y = this.height / 2 - one.height / 2;

            two.x = this.width / 2 - two.width / 2;
            two.y = this.height / 2 - two.height / 2;

            three.x = this.width / 2 - three.width / 2;
            three.y = this.height / 2 - three.height / 2;

            play.x = this.width / 2 - play.width / 2;
            play.y = this.height / 2 - play.height / 2;
        }

        public function turnCountdownOff(e:TimerEvent):void {
            _index = OFF_STATE;
            updateDisplay();
        }
    }
}
