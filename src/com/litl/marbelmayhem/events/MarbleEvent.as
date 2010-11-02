package com.litl.marbelmayhem.events
{
    import flash.events.Event;

    public class MarbleEvent extends Event
    {
        public static const START_NEW_GAME:String = "StartNewGameMarbleEvent";
        public static const GAME_PAUSED:String = "GamePausedMarbelEvent";
        public static const GAME_OVER:String = "GamePausedMarbelEvent";
        public static const PLAYER_DIED:String = "PlayerDiedMarbelEvent";
        public static const SCORE_CHANGED:String = "ScoreChangedMarbleEvent";
        public static const TIMER_TICK:String = "TimerTickMarbleEvent";
        public static const RENDER:String = "RenderMarbleEvent";
        public static const RESET_LAYOUT:String = "ResetLayoutMarbleEvent";
        public static const TOTAL_PLAYERS_CHANGED:String = "TotalPlayersChangedMarbleEvent";

        public function MarbleEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false) {
            super(type, bubbles, cancelable);
        }
    }
}
