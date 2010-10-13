package
{
    import away3d.containers.View3D;
    import away3d.core.utils.Cast;
    import away3d.loaders.utils.MaterialLibrary;
    import away3d.materials.BitmapMaterial;
    import away3d.materials.GlassMaterial;
    import away3d.materials.WireColorMaterial;
    import away3d.primitives.Cube;
    import away3d.primitives.Plane;
    import away3d.primitives.Skybox;
    import away3d.primitives.Sphere;

    import com.litl.marbelmayhem.GameMaterials;
    import com.litl.sdk.event.RemoteStatusEvent;
    import com.litl.sdk.richinput.Accelerometer;
    import com.litl.sdk.richinput.IRemoteControl;
    import com.litl.sdk.richinput.RemoteManager;
    import com.litl.sdk.service.LitlService;

    import flash.display.Bitmap;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.utils.Dictionary;

    [SWF(backgroundColor="000000", width="1920", height="1080", framerate="30")]
    public class Main extends Sprite
    {
        private var view:View3D;
        private var player1:Sphere;
        private var player2:Sphere;
        private var floor:Plane;
        private var world:Skybox;
        private var gameMaterials:GameMaterials;

        public var remoteIds:Array;
        public var models:Array;
        public var players:Dictionary;

        private var service:LitlService;

        protected var remoteManager:RemoteManager;
        protected var remoteHandlers:Dictionary;

        private var player1AccX:Number = 0;
        private var player1AccZ:Number = 0;

        private var player2AccX:Number = 0;
        private var player2AccZ:Number = 0;

        private var rotate1:Number;
        private var rotate2:Number;

        private static const FRICTION:Number = .98;
        private static const SPEED:Number = 75;
        private static const GRAVITY:Number = 25;

        public function Main() {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;

            init();
        }

        private function init():void {
            remoteIds = new Array();
            models = new Array();
            players = new Dictionary();
            gameMaterials = new GameMaterials();
            service = new LitlService(this);

            remoteManager = new RemoteManager(service);
            remoteHandlers = new Dictionary();
            remoteManager.addEventListener(RemoteStatusEvent.REMOTE_STATUS, handleRemoteStatus);

            service.connect("3d", "3d", "1.3d", false);

            createView();
            createScene();
        }

        protected function createView():void {
            view = new View3D();
            view.x = 960;
            view.y = 540;
            view.camera.y = 500;
            view.camera.z = -1000;
            view.camera.lookAt(view.scene.position);

            addChild(view);
            addEventListener(Event.ENTER_FRAME, _onEnterFrame);
        }

        protected function createScene():void {
            createObjects();
        }

        private function createObjects():void {
            player1 = new Sphere();
            player1.material = new WireColorMaterial(0xffffff);
            player1.radius = 20;
            player1.y = player1.radius;

            player2 = new Sphere();
            player2.material = new WireColorMaterial(0xffffff);
            player2.radius = 20;
            player2.y = player2.radius;

            var floorMaterial:BitmapMaterial = new BitmapMaterial(Cast.bitmap(gameMaterials.grassBitmap));

            floor = new Plane({ material: floorMaterial });
            floor.y = 0;
            floor.x = 0;
            floor.z = 0;
            floor.width = 600;
            floor.height = 600;
            floor.segmentsH = 10;
            floor.segmentsW = 10;
            floor.yUp = true;
            view.scene.addChild(floor);

            var front:BitmapMaterial = new BitmapMaterial(Cast.bitmap(gameMaterials.skyFront));
            var back:BitmapMaterial = new BitmapMaterial(Cast.bitmap(gameMaterials.skyBack));
            var left:BitmapMaterial = new BitmapMaterial(Cast.bitmap(gameMaterials.skyLeft));
            var right:BitmapMaterial = new BitmapMaterial(Cast.bitmap(gameMaterials.skyRight));
            var up:BitmapMaterial = new BitmapMaterial(Cast.bitmap(gameMaterials.skyUp));
            var down:BitmapMaterial = new BitmapMaterial(Cast.bitmap(gameMaterials.skyDown));

            world = new Skybox(front, left, back, right, up, down);

            view.scene.addChild(world);

            models.push({ model: player1 }, { model: player2 });
            resetObjects();
        }

        private function resetObjects():void {
            player1.x = 150;
            player1.z = 200;

            player2.x = -150;
            player2.z = -200;
        }

        protected function _onEnterFrame(ev:Event):void {
            player1.x += player1AccX;
            player1.z -= player1AccZ;
            player1.roll(player1AccX * -1);
            player1.pitch(player1AccZ * -1);

            player2.x += player2AccX;
            player2.z -= player2AccZ;
            player2.roll(player2AccX * -1);
            player2.pitch(player2AccZ * -1);

            if (player1.x < floor.x - floor.width / 2) {
                player1.y -= GRAVITY;
            }
            else if (player1.x > floor.x + floor.width / 2) {
                player1.y -= GRAVITY;
            }
            else if (player1.z > floor.z + floor.height / 2) {
                player1.y -= GRAVITY;
            }
            else if (player1.z < floor.z - floor.height / 2) {
                player1.y -= GRAVITY;
            }

            if (player2.x < floor.x - floor.width / 2) {
                player2.y -= GRAVITY;
            }
            else if (player2.x > floor.x + floor.width / 2) {
                player2.y -= GRAVITY;
            }
            else if (player2.z > floor.z + floor.height / 2) {
                player2.y -= GRAVITY;
            }
            else if (player2.z < floor.z - floor.height / 2) {
                player2.y -= GRAVITY;
            }

            if (player1.distanceTo(player2) < player1.radius) {
                trace("hit");
            }
            view.render();
        }

        private function handleRemoteStatus(e:RemoteStatusEvent):void {
            var remote:IRemoteControl = e.remote;

            if (remote != null && remote.hasAccelerometer) {
                var accelerometer:Accelerometer = remote.accelerometer;
                var handler:Function;

                if (e.remoteEnabled) {
                    handler = handleAccelerometerEventFactory(remote);
                    remoteHandlers[remote] = handler;
                    accelerometer.addEventListener(com.litl.sdk.event.AccelerometerEvent.UPDATE, handler);
                    addPlayer(remote.id);
                }
                else {
                    handler = remoteHandlers[remote];
                    delete remoteHandlers[remote];
                    accelerometer.removeEventListener(com.litl.sdk.event.AccelerometerEvent.UPDATE, handler);
                    handler = null;
                    removePlayer(remote.id);
                }
            }
        }

        private function handleAccelerometerEventFactory(remote:IRemoteControl):Function {
            return function(e:com.litl.sdk.event.AccelerometerEvent):void {
                if (players[remote.id].model == player1) {
                    player1AccX = e.accelerationY * SPEED;
                    player1AccZ = e.accelerationX * SPEED;
                }
                else if (players[remote.id].model == player2) {
                    player2AccX = e.accelerationY * SPEED;
                    player2AccZ = e.accelerationX * SPEED;
                }
            }
        }

        public function addPlayer(remoteId:String):void {
            var position:Number = remoteIds.push(remoteId);
            players[remoteId] = models[position % models.length];
            view.scene.addChild(players[remoteId].model);

            resetObjects();
        }

        public function removePlayer(remoteId:String):void {
            view.scene.removeChild(players[remoteId].model);
            //remove remote ID from list
            remoteIds.splice(remoteIds.indexOf(remoteId), 1);
            delete players[remoteId];

            resetObjects();
        }
    }
}
