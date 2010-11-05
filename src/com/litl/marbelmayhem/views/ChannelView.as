package com.litl.marbelmayhem.views
{
    import away3d.containers.View3D;
    import away3d.core.utils.Cast;
    import away3d.materials.BitmapMaterial;
    import away3d.materials.ColorMaterial;
    import away3d.materials.WireColorMaterial;
    import away3d.primitives.Plane;
    import away3d.primitives.Skybox;
    import away3d.primitives.Sphere;

    import com.litl.marbelmayhem.controller.GameController;
    import com.litl.marbelmayhem.model.GameManager;
    import com.litl.marbelmayhem.utils.GameMaterials;
    import com.litl.marbelmayhem.vo.Player;
    import com.litl.sdk.service.LitlService;

    import flash.display.Sprite;
    import flash.events.Event;

    public class ChannelView extends ViewBase
    {
        private var controller:GameController;
        private var model:GameManager;
        public var gameMaterials:GameMaterials;
        public var awayWorld:View3D;
        public var player0:Sphere;
        public var player1:Sphere;
        public var floor:Plane;
        public var world:Skybox;
        public var scoreboard:Scoreboard;
        public var countdown:CountDown;

        public function ChannelView(service:LitlService) {
            super();

            controller = GameController.getInstance();
            model = GameManager.getInstance();
            gameMaterials = new GameMaterials();

            createView();
            createScene();
            createScoreboard();
            createStats(service);
            createCountdown();

            updateLayout();
            addEventListener(Event.ENTER_FRAME, renderScene);
        }

        private function createStats(service:LitlService):void {
            //var stats:Stats = new Stats(service);
            //addChild(stats);
        }

        private function createCountdown():void {
            countdown = new CountDown();
            addChild(countdown);
        }

        protected function createView():void {
            awayWorld = new View3D();
            awayWorld.camera.lookAt(awayWorld.scene.position);
            awayWorld.x = 640;
            awayWorld.y = 400;
            awayWorld.camera.y = 425;
            awayWorld.camera.z = -5500;

            addChild(awayWorld);
        }

        protected function createScene():void {
            createObjects();
        }

        protected function createObjects():void {
            createWorld();
            createFloor();
        }

        protected function createScoreboard():void {
            scoreboard = new Scoreboard(this);
            addChild(scoreboard);
        }

        private function createFloor():void {
            floor = new Plane();
            floor.material = new ColorMaterial(0x2f241e);
            floor.segmentsH = 10;
            floor.segmentsW = 10;
            floor.yUp = true;

            updateLayout();
            awayWorld.scene.addChild(floor);
        }

        private function createWorld():void {
            var front:BitmapMaterial = new BitmapMaterial(Cast.bitmap(gameMaterials.skyFront));
            var back:BitmapMaterial = new BitmapMaterial(Cast.bitmap(gameMaterials.skyBack));
            var left:BitmapMaterial = new BitmapMaterial(Cast.bitmap(gameMaterials.skyLeft));
            var right:BitmapMaterial = new BitmapMaterial(Cast.bitmap(gameMaterials.skyRight));
            var up:BitmapMaterial = new BitmapMaterial(Cast.bitmap(gameMaterials.skyUp));
            var down:BitmapMaterial = new BitmapMaterial(Cast.bitmap(gameMaterials.skyDown));

            world = new Skybox(front, right, back, left, up, down);
            awayWorld.scene.addChild(world);
        }

        public function addPlayer(player:Player):void {
            player.material = new WireColorMaterial(0x004518 * Math.random()); // WireColorMaterial(0xBE1E2D);
            player.segmentsH = 15;
            player.segmentsW = 15;
            player.x = floor.x + (Math.random() * 400);
            player.y = floor.y + 50;
            player.z = floor.z;
            player.radius = 40;

            awayWorld.scene.addChild(player);
        }

        public function removePlayer(player:Player):void {
            awayWorld.scene.removeChild(player);
        }

        public function updateLayout():void {
            floor.y = 0;
            floor.x = 0;
            floor.z = -3875;
            floor.width = 1100;
            floor.height = 1100;
        }

        override protected function sizeUpdated():void {
            updateLayout();
        }

        protected function renderScene(e:Event):void {
            awayWorld.render();
        }

    }
}
