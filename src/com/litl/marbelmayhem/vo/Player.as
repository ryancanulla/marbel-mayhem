package com.litl.marbelmayhem.vo
{
    import away3d.primitives.Sphere;

    public class Player extends Sphere
    {
        public var remoteID:String;
        public var isPlaying:Boolean = false;
        public var playerName:String;
        public var score:Number = 0;
        public var maxVelocity:Number;
        public var winningCollisions:Number;
        public var lives:Number;
        public var accX:Number = 0;
        public var accZ:Number = 0;
        public var vx:Number = 0;
        public var vy:Number = 0;
    }
}
