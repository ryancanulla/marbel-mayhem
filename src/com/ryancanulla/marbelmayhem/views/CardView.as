package com.litl.marbelmayhem.views
{
    import com.litl.marbelmayhem.views.ViewBase;
    import com.litl.marbelmayhem.events.MarbleEvent;
    import com.litl.marbelmayhem.model.GameManager;

    import flash.display.DisplayObject;
    import flash.display.Loader;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.Event;
    import flash.net.URLRequest;

    public class CardView extends ViewBase
    {
        private var _stage:Stage;
        private var background:Shape;
        private var logo:Loader;
        private var model:GameManager = GameManager.getInstance();

        public function CardView() {
            super();
            model.addEventListener(MarbleEvent.RESET_LAYOUT, updateLayout);
            init();
        }

        private function init():void {
            createChildren();
        }

        private function createChildren():void {
            background = new Shape();
            background.graphics.beginFill(0x333333);
            background.graphics.drawRect(0, 0, 300, 166);
            addChild(background);

            logo = new Loader;
            logo.load(new URLRequest("../assets/logo.gif"));
            addChild(logo);

            updateLayout();
            updateProperties();
        }

        private function updateProperties():void {

        }

        private function updateLayout(e:Event = null):void {
            background.x = 0;
            background.y = 0;
            background.width = this.width;
            background.height = this.height;

            logo.x = 45;
            logo.y = 25;

        }

        override protected function sizeUpdated():void {
            updateLayout();
        }
    }
}
