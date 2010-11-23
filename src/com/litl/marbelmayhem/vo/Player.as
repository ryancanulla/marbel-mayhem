package com.litl.marbelmayhem.vo
{
    import alternativa.engine3d.materials.Material;
    import alternativa.engine3d.primitives.Sphere;

    public class Player extends Sphere
    {
        public var remoteID:String;
        public var playerID:uint;
        public var isPlaying:Boolean = false;
        public var playerName:String;
        public var score:Number = 0;
        public var maxVelocity:Number;
        public var winningCollisions:Number;
        public var lives:Number;
        public var accX:Number = 0;
        public var accZ:Number = 0;
        public var vx:Number = 0;
        public var vz:Number = 0;
        public var radius:Number;
        public var isFalling:Boolean;

        public function Player(radius:Number = 60, radialSegments:uint = 15, heightSegments:uint = 15, reverse:Boolean = false, material:Material = null) {
            super(radius, radialSegments, heightSegments, reverse, material);
            this.radius = radius;
        }
    }
}
