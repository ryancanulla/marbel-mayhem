package com.litl.marbelmayhem.views
{
    import alternativa.engine3d.controllers.SimpleObjectController;
    import alternativa.engine3d.core.Camera3D;
    import alternativa.engine3d.core.Object3DContainer;
    import alternativa.engine3d.core.View;
    import alternativa.engine3d.materials.FillMaterial;
    import alternativa.engine3d.materials.Material;
    import alternativa.engine3d.materials.TextureMaterial;
    import alternativa.engine3d.primitives.Plane;

    import com.litl.marbelmayhem.controller.GameController;
    import com.litl.marbelmayhem.events.MarbleEvent;
    import com.litl.marbelmayhem.model.GameManager;
    import com.litl.marbelmayhem.utils.GameMaterials;
    import com.litl.marbelmayhem.vo.Player;

    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.ColorTransform;
    import flash.geom.Point;
    import flash.geom.Vector3D;


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
        public var scoreboard:Scoreboard;
        public var countdown:CountDown;
        public var background1:Bitmap;
        public var background2:Bitmap;

        public function ChannelView() {
            super();

            controller = GameController.getInstance();
            model = GameManager.getInstance();
            gameMaterials = new GameMaterials();

            createView();
            createScoreboard();
            createCountdown();

            model.addEventListener(MarbleEvent.RENDER, renderScene);
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
            addChild(camera.view);

            container.addChild(camera);
            createFloor();

        }

        protected function createScoreboard():void {
            scoreboard = new Scoreboard(this);
            addChild(scoreboard);
        }

        private function createWorld():void {
            background1 = gameMaterials.backgroundBitmapOne;
            background1.cacheAsBitmap = true;
            addChild(background1);

            background2 = gameMaterials.backgroundBitmapTwo;
            background2.cacheAsBitmap = true;
            addChild(background2);
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
            player.x = floor.boundMinX + (Math.random() * floor.boundMaxX);
            player.y = floor.y;
            player.z = floor.z;

            var texture:TextureMaterial;
            if (player.playerID == 1) {
                texture = new TextureMaterial(gameMaterials.playerOneMarbleBitmap.bitmapData);
            } else if(player.playerID == 2) {
                texture = new TextureMaterial(gameMaterials.playerTwoMarbleBitmap.bitmapData);
            }

            player.setMaterialToAllFaces(texture);
            container.addChild(player);
        }

        public function removePlayer(player:Player):void {
            container.removeChild(player);
        }

        override protected function sizeUpdated():void {
            scoreboard.setSize(this.width, this.height);
            countdown.setSize(this.width, this.height);

            background1.x = 0;
            background1.y = -500;

            background2.x = (background2.width - 6) * -1;
            background2.y = -500;

            camera.view.width = this.width;
            camera.view.height = this.height;

            floor.y = this.height * .3;
        }

        protected function renderScene(e:Event):void {
            floor.rotationY += .4 * Math.PI / 180;
            background1.x += .4;
            background2.x += .4;

            if (background1.x > this.width) {
                background1.x = (background2.x + 10) - (background1.width * -1);
            }

            if (background2.x > this.width) {
                background2.x = (background1.x + 10) - (background2.width * -1);
            }
            camera.render();
        }

    }
}
