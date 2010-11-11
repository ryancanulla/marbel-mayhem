package com.litl.marbelmayhem.model.service
{
    import com.litl.marbelmayhem.controller.GameController;
    import com.litl.marbelmayhem.views.CardView;
    import com.litl.marbelmayhem.views.ChannelView;
    import com.litl.marbelmayhem.views.ViewBase;
    import com.litl.sdk.enum.View;
    import com.litl.sdk.message.InitializeMessage;
    import com.litl.sdk.message.ViewChangeMessage;
    import com.litl.sdk.service.LitlService;

    import flash.display.Sprite;
    import flash.utils.Dictionary;

    public class LitlViewManager extends Sprite
    {
        private var _service:LitlService;
        private var _currentViewState:String;

        protected var _view:Sprite;
        protected var controller:GameController = GameController.getInstance();
        protected var currentView:ViewBase;
        protected var views:Dictionary;

        public function LitlViewManager(view:Sprite) {
            _view = view;
            views = new Dictionary();
        }

        protected function setView(e:ViewChangeMessage):void {
            // Remove the current view from the display list.
            if (currentView && contains(currentView)) {
                removeChild(currentView);
            }

            if (views == null)
                views = new Dictionary(false);

            currentView = views[e.view] as ViewBase;

            switch (e.view) {
                default:
                    throw new Error("Unknown view state");
                    break;

                case View.CHANNEL:

                    if (currentView == null)
                        currentView = new ChannelView(_service);
                    _currentViewState = View.CHANNEL;
                    break;
                case View.FOCUS:

                    if (currentView == null)
                        currentView = new ChannelView(_service);
                    _currentViewState = View.CHANNEL;
                    break;
                case View.CARD:

                    if (currentView == null)
                        currentView = new CardView();
                    _currentViewState = View.CARD;
                    break;
            }

            views[e.view] = currentView;
            controller.currentView = currentView;

            currentView.setSize(e.width, e.height);

            if (!contains(currentView))
                addChild(currentView);
        }

        public function set service(value:LitlService):void {
            _service = value;
            _service.addEventListener(ViewChangeMessage.VIEW_CHANGE, setView);
        }

        public function get currentViewState():String {
            return _currentViewState;
        }

    }
}
