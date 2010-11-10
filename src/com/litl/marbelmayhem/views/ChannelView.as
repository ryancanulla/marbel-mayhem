package com.litl.marbelmayhem.views
{
    import alternativa.engine3d.containers.ConflictContainer;
    import alternativa.engine3d.containers.DistanceSortContainer;
    import alternativa.engine3d.controllers.SimpleObjectController;
    import alternativa.engine3d.core.Camera3D;
    import alternativa.engine3d.core.Object3DContainer;
    import alternativa.engine3d.core.View;
    import alternativa.engine3d.materials.FillMaterial;
    import alternativa.engine3d.materials.Material;
    import alternativa.engine3d.materials.TextureMaterial;
    import alternativa.engine3d.objects.SkyBox;
    import alternativa.engine3d.objects.Sprite3D;
    import alternativa.engine3d.primitives.Box;
    import alternativa.engine3d.primitives.Plane;

    import com.litl.marbelmayhem.controller.GameController;
    import com.litl.marbelmayhem.events.MarbleEvent;
    import com.litl.marbelmayhem.model.GameManager;
    import com.litl.marbelmayhem.utils.GameMaterials;
    import com.litl.marbelmayhem.vo.Player;
    import com.litl.sdk.service.LitlService;

    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.geom.Vector3D;

    import net.hires.debug.DoobStats;

    public class ChannelView extends ViewBase
    {
        private var controller:GameController;
        private var model:GameManager;

        public var gameMaterials:GameMaterials;
        public var camera:Camera3D;
        public var container:Object3DContainer;
        public var rotationalContainer:Object3DContainer;
        public var objectController:SimpleObjectController;
        public var floor:Plane;
        public var world:SkyBox;
        public var scoreboard:Scoreboard;
        public var countdown:CountDown;

        public function ChannelView(service:LitlService) {
            super();

            controller = GameController.getInstance();
            model = GameManager.getInstance();
            gameMaterials = new GameMaterials();

            createView();
            //createScene();
            createScoreboard();
            createStats(service);
            //createCountdown();

            updateLayout();
            model.addEventListener(MarbleEvent.RENDER, renderScene);
        }

        private function createStats(service:LitlService):void {
            var stats:DoobStats = new DoobStats(service);
            stats.x = 0;
            stats.y = 80;
            addChild(stats);

        }

        private function createCountdown():void {
            countdown = new CountDown();
            addChild(countdown);
        }

        protected function createView():void {
            createWorld();
            container = new Object3DContainer();

            camera = new Camera3D();
            camera.view = new View(1280, 1024);
            camera.y -= 20;
            camera.rotationZ += 0 * Math.PI / 180;
            camera.z = -700;
            //camera.fov = 500;
            addChild(camera.view);

            container.addChild(camera);
            createFloor();

        }

        protected function createScoreboard():void {
            scoreboard = new Scoreboard(this);
            addChild(scoreboard);
        }

        private function createWorld():void {
            var background:Bitmap = gameMaterials.skyFront;
            background.cacheAsBitmap = true;
            background.scaleX = 1;
            background.scaleY = 1;
            background.x = 10;
            background.y = 0;
            addChild(background);
        }

        private function createFloor():void {
            floor = new Plane(1450, 1450, 1, 1, false);
            floor.rotationX += 90 * Math.PI / 180;
            floor.z = 1000;
            floor.y += 225;
            floor.setMaterialToAllFaces(new TextureMaterial(gameMaterials.floorBitmap.bitmapData, false, true));
            container.addChild(floor);
        }

        public function addPlayer(player:Player):void {
            var material:FillMaterial = new FillMaterial(0xFF7700, 1, 1);

            player.setMaterialToAllFaces(material);
            player.x = floor.boundMinX + (Math.random() * floor.boundMaxX);
            player.y = floor.y;
            player.z = floor.z;
            player.setMaterialToAllFaces(new TextureMaterial(gameMaterials.marbleBitmap.bitmapData, false, true));

            container.addChild(player);
        }

        public function removePlayer(player:Player):void {
            container.removeChild(player);
        }

        public function updateLayout():void {

        }

        override protected function sizeUpdated():void {
            updateLayout();
        }

        protected function renderScene(e:Event):void {
            //world.rotationY += .04 * Math.PI / 180;
            //floor.rotationY += .04 * Math.PI / 180;
            camera.render();
            //objectController.lookAt(world.localToGlobal(new Vector3D(0, 0, 0)));
            //objectController.moveForward(true);

            //objectController.update();
        }

    }
}
