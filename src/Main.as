package
{
    import com.litl.marbelmayhem.controller.GameController;
    import com.litl.marbelmayhem.model.service.LitlServiceManager;
    import com.litl.marbelmayhem.model.service.LitlViewManager;
    import com.litl.marbelmayhem.utils.FontManager;
    import com.litl.marbelmayhem.views.CountDown;
    import com.litl.marbelmayhem.views.GameResults;

    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;

    import net.hires.debug.Stats;

    [SWF(width="1280", height="800", framerate="30")]
    public class Main extends Sprite
    {

        public var countdown:CountDown;
        public var gameResults:GameResults;
        private var viewManager:LitlViewManager;
        private var serviceManager:LitlServiceManager;
        private var controller:GameController;

        public function Main() {
            var fonts:FontManager = new FontManager();

            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;

            addEventListener(Event.ADDED_TO_STAGE, init);
        }

        private function init(e:Event):void {

            serviceManager = new LitlServiceManager(this);

            viewManager = new LitlViewManager(this);
            viewManager.service = serviceManager.service;
            addChild(viewManager);

            controller = GameController.getInstance();
            controller.view = this;

            //countdown = new CountDown(this.stage);
            //gameResults = new GameResults(this.stage);

            //creatStatsMonitor();
        }

        private function creatStatsMonitor():void {
            var stats:Stats = new Stats();
            stats.x = 0;
            stats.y = 80;
            addChild(stats);
        }
    }
}

