package com.litl.marbelmayhem.events
{
    import flash.events.Event;

    public static const SCORE_CHANGED:String = "ScoreChangedMarbleEvent";
    public static const TIMER_TICK:String = "TimerTickMarbleEvent";
    public static const START_NEW_GAME = "StartNewGameMarbleEvent";
    public static const RENDER:String = "RenderMarbleEvent";

    public class MarbleEvent extends Event
    {
        public function MarbleEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false) {
            super(type, bubbles, cancelable);
        }
    }
}
