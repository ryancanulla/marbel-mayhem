package
{
    import away3d.containers.View3D;
    import away3d.core.session.BitmapSession;
    import away3d.core.utils.Cast;
    import away3d.lights.DirectionalLight3D;
    import away3d.lights.PointLight3D;
    import away3d.loaders.utils.MaterialLibrary;
    import away3d.materials.BitmapMaterial;
    import away3d.materials.ColorMaterial;
    import away3d.materials.DepthBitmapMaterial;
    import away3d.materials.EnviroBitmapMaterial;
    import away3d.materials.GlassMaterial;
    import away3d.materials.PhongBitmapMaterial;
    import away3d.materials.PhongColorMaterial;
    import away3d.materials.ShadingColorMaterial;
    import away3d.materials.WhiteShadingBitmapMaterial;
    import away3d.materials.WireColorMaterial;
    import away3d.primitives.Cube;
    import away3d.primitives.Plane;
    import away3d.primitives.Skybox;
    import away3d.primitives.Sphere;

    import com.litl.marbelmayhem.FontManager;
    import com.litl.marbelmayhem.GameMaterials;
    import com.litl.marbelmayhem.Scoreboard;
    import com.litl.marbelmayhem.model.GameManager;
    import com.litl.marbelmayhem.views.CountDown;
    import com.litl.sdk.event.RemoteStatusEvent;
    import com.litl.sdk.message.UserInputMessage;
    import com.litl.sdk.richinput.Accelerometer;
    import com.litl.sdk.richinput.IRemoteControl;
    import com.litl.sdk.richinput.RemoteManager;
    import com.litl.sdk.service.LitlService;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.geom.Point;
    import flash.utils.Dictionary;

    import net.hires.debug.Stats;

    import org.osmf.events.TimeEvent;
    import org.osmf.net.StreamingURLResource;

    [SWF(width="1280", height="800", framerate="30")]
    public class Main extends Sprite
    {
        private var view:View3D;
        private var player0:Sphere;
        private var player1:Sphere;
        private var floor:Plane;
        private var world:Skybox;
        private var gameMaterials:GameMaterials;

        public var remoteIds:Array;
        public var models:Array;
        private var model:GameManager = GameManager.getInstance();
        public var players:Dictionary;

        private var scoreboard:Scoreboard;
        private var countdown:CountDown;

        private var service:LitlService;

        protected var remoteManager:RemoteManager;
        protected var remoteHandlers:Dictionary;

        private var player1AccX:Number = 0;
        private var player1AccZ:Number = 0;
        private var player1VX:Number = 0;
        private var player1VY:Number = 0;

        private var player2AccX:Number = 0;
        private var player2AccZ:Number = 0;
        private var player2VX:Number = 0;
        private var player2VY:Number = 0;

        private var rotate1:Number;
        private var rotate2:Number;

        private static const FRICTION:Number = .95;
        private static const SPEED:Number = 3;
        private static const GRAVITY:Number = 20;
        private static const SPRING:Number = .2;
        private static const MASS:Number = 1;

        public function Main() {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;

            var fonts:FontManager = new FontManager();

            init();
        }

        private function init():void {
            model.addEventListener("RenderMarbleEvent", renderScreen);
            countdown = new CountDown(this.stage);

            model.startNewGame();

            remoteIds = new Array();
            models = new Array();
            players = new Dictionary();
            gameMaterials = new GameMaterials();
            service = new LitlService(this);

            remoteManager = new RemoteManager(service);
            remoteHandlers = new Dictionary();
            remoteManager.addEventListener(RemoteStatusEvent.REMOTE_STATUS, handleRemoteStatus);

            service.connect("3d", "3d", "1.3d", false);
            service.addEventListener(UserInputMessage.GO_BUTTON_RELEASED, startNewGame);

            createView();
            createScene();
            createScoreboard();
            creatStatsMonitor();
        }

        private function createScoreboard():void {
            scoreboard = new Scoreboard(this.stage);
            addChild(scoreboard);
        }

        private function creatStatsMonitor():void {
            var stats:Stats = new Stats();
            stats.x = 0;
            stats.y = 80;
            addChild(stats);
        }

        protected function createView():void {
            view = new View3D();
            view.x = 640;
            view.y = 400;
            view.camera.y = 400;
            // view.camera.rotationY = 45;
            view.camera.z = -1500;
            view.camera.lookAt(view.scene.position);

            addChild(view);
        }

        protected function createScene():void {
            createObjects();
        }

        private function createObjects():void {
            createWorld();
            createFloor();
            createLighting();
            createPlayers();
        }

        private function createLighting():void {
            // create a new directional white light source with specific ambient, diffuse and specular parameters
            //var light:PointLight3D = new PointLight3D();
            //light.y = 300;
            //light.x = 500;
            //light.z = -500;
            //light.brightness = 5;
            //view.scene.addLight(light);
        }

        private function createPlayers():void {
            //var bmp:BitmapData = new BitmapData(200, 200);
            //bmp.perlinNoise(200, 200, 2, Math.random(), true, true);
            //var mat:BitmapMaterial = new BitmapMaterial(bmp);

            player0 = new Sphere();
            player0.material = new WireColorMaterial(0xBE1E2D);
            player0.segmentsH = 15;
            player0.segmentsW = 15;
            player0.radius = 40;

            player1 = new Sphere();
            player1.material = new WireColorMaterial(0x004518);
            player1.segmentsH = 15;
            player1.segmentsW = 15;
            player1.radius = 40;

            models.push({ model: player0 }, { model: player1 });
        }

        private function createFloor():void {
            //var floorMaterial:BitmapMaterial = new BitmapMaterial(Cast.bitmap(gameMaterials.grassBitmap));

            var bmp:BitmapData = new BitmapData(200, 200);
            bmp.perlinNoise(200, 200, 2, Math.random(), true, true);
            var mat:BitmapMaterial = new BitmapMaterial(bmp);

            floor = new Plane();
            floor.material = new ColorMaterial(0x2f241e);
            floor.y = 0;
            floor.x = 0;
            floor.z = -200;
            floor.width = 1100;
            floor.height = 1100;
            floor.segmentsH = 10;
            floor.segmentsW = 10;
            floor.yUp = true;
            //floor.ownCanvas = true;
            view.scene.addChild(floor);
        }

        private function createWorld():void {
            var front:BitmapMaterial = new BitmapMaterial(Cast.bitmap(gameMaterials.skyFront));
            var back:BitmapMaterial = new BitmapMaterial(Cast.bitmap(gameMaterials.skyBack));
            var left:BitmapMaterial = new BitmapMaterial(Cast.bitmap(gameMaterials.skyLeft));
            var right:BitmapMaterial = new BitmapMaterial(Cast.bitmap(gameMaterials.skyRight));
            var up:BitmapMaterial = new BitmapMaterial(Cast.bitmap(gameMaterials.skyUp));
            var down:BitmapMaterial = new BitmapMaterial(Cast.bitmap(gameMaterials.skyDown));

            world = new Skybox(front, right, back, left, up, down);
            view.scene.addChild(world);
        }

        private function startNewGame(e:UserInputMessage):void {
            if (model.gameInProgress) {
                //resetObjects(3);
                model.startNewGame();
            }
            else {
                model.startNewGame();
            }
        }

        private function resetObjects(player:Number = 0):void {
            if (player == 0) {
                player0.x = -150;
                player0.z = -400;
                player0.y = player0.radius + 5;
            }
            else if (player == 1) {
                player1.x = -50;
                player1.z = -400;
                player1.y = player1.radius + 5;
            }
            else {
                player0.x = 150;
                player0.z = -400;
                player0.y = player0.radius + 5;
                player1.x = -50;
                player1.z = -400;
                player1.y = player1.radius + 5;
            }
        }

        protected function renderScreen(e:Event):void {
            if (model.gameInProgress == false) {
                view.render();
                return;
            }

            calculateScores(false);

            player1VX *= FRICTION;
            player1VY *= FRICTION;
            player2VX *= FRICTION;
            player2VY *= FRICTION;

            var distX:Number = player1.x - player0.x;
            var distZ:Number = player1.z - player0.z;
            var dist:Number = Math.sqrt(distX * distX + distZ * distZ);

            if (dist < player0.radius * 2) {
                calculateScores(true);

                var tempX:Number = player1VX;
                var tempY:Number = player1VY;
                player1VX = player2VX * 1.5;
                player1VY = player2VY * 1.5;
                player2VX = tempX * 1.5;
                player2VY = tempY * 1.5;

//                var angle:Number = Math.atan2(distZ, distX);
//                var sin:Number = Math.sin(angle);
//                var cos:Number = Math.cos(angle);
//
//                // rotate player positions
//                var x0:Number = 0;
//                var y0:Number = 0;
//                var x1:Number = distX * cos + distZ * sin;
//                var y1:Number = distZ * cos - distX * sin;
//
//                // rotate velocities
//                var vx0:Number = player1VX * cos + player1VY * sin;
//                var vy0:Number = player1VY * cos - player1VX * sin;
//                var vx1:Number = player2VX * cos + player2VY * sin;
//                var vy1:Number = player2VY * cos - player2VX * sin;
//
//                // collision reaction
//                var vxTotal:Number = vx0 - vx1;
//                vx0 = ((MASS - MASS) * vx0 + 2 * MASS * vx1) / (MASS + MASS);
//                vx1 = vxTotal + vx0;
//
//                //seperate them
//                //x0 += vx0;
//                //x1 += vx1;
//
//                // seperate them advanced
//                var absV:Number = Math.abs(vx0) + Math.abs(vx1);
//                var overlap:Number = (player0.radius + player1.radius)
//                    - Math.abs(x0 - x1);
//
//                x0 += vx0 / absV * overlap;
//                x1 += vx1 / absV * overlap;
//
//                // rotate positions back
//                var x0Final:Number = x0 * cos - y0 * sin;
//                var y0Final:Number = y0 * cos + x0 * sin;
//                var x1Final:Number = x1 * cos - y1 * sin;
//                var y1Final:Number = y1 * cos + x1 * sin;
//
//                // adjust positions to actual screen positions
//                player1.x = player0.x + x1Final;
//                player1.z = player0.z + y1Final;
//                player0.x = player0.x + x0Final;
//                player0.z = player0.z + y0Final;
//
//                // rotate the velocities back
//                player1VX = vx0 * cos - vy0 * sin;
//                player1VY = vy0 * cos + vx0 * sin;
//                player2VX = vx1 * cos - vy1 * sin;
//                player2VY = vy1 * cos + vx1 * sin;

//                var angle:Number = Math.atan2(distZ, distX);
//                var sin:Number = Math.sin(angle);
//                var cos:Number = Math.cos(angle);
//
//                // rotate player positions
//                var pos0:Point = new Point(0, 0);
//                var pos1:Point = rotate(distX, distZ, sin, cos, true);
//
//                var x1:Number = distX * cos + distZ * sin;
//                var y1:Number = distZ * cos - distX * sin;
//
//                // rotate velocities
//                var vx0:Number = player1VX * cos + player1VY * sin;
//                var vy0:Number = player1VY * cos - player1VX * sin;
//                var vx1:Number = player2VX * cos + player2VY * sin;
//                var vy1:Number = player2VY * cos - player2VX * sin;
//
//                // collision reaction
//                var vxTotal:Number = vx0 - vx1;
//                vx0 = ((MASS - MASS) * vx0 + 2 * MASS * vx1) / (MASS + MASS);
//                vx1 = vxTotal + vx0;
//
//                //seperate them
//                //x0 += vx0;
//                //x1 += vx1;
//
//                // seperate them advanced
//                var absV:Number = Math.abs(vx0) + Math.abs(vx1);
//                var overlap:Number = (player0.radius + player1.radius)
//                    - Math.abs(x0 - x1);
//
//                x0 += vx0 / absV * overlap;
//                x1 += vx1 / absV * overlap;
//
//                // rotate positions back
//                var x0Final:Number = x0 * cos - y0 * sin;
//                var y0Final:Number = y0 * cos + x0 * sin;
//                var x1Final:Number = x1 * cos - y1 * sin;
//                var y1Final:Number = y1 * cos + x1 * sin;
//
//                // adjust positions to actual screen positions
//                player1.x = player0.x + x1Final;
//                player1.z = player0.z + y1Final;
//                player0.x = player0.x + x0Final;
//                player0.z = player0.z + y0Final;
//
//                // rotate the velocities back
//                player1VX = vx0 * cos - vy0 * sin;
//                player1VY = vy0 * cos + vx0 * sin;
//                player2VX = vx1 * cos - vy1 * sin;
//                player2VY = vy1 * cos + vx1 * sin;

            }

            player0.x += player1VX;
            player0.z -= player1VY;
            player0.roll(player1VX * -.5);
            player0.pitch(player1VY * -.5);

            player1.x += player2VX;
            player1.z -= player2VY;
            player1.roll(player2VX * -.5);
            player1.pitch(player2VY * -.5);

            if (player0.x < floor.x - floor.width / 2) {
                player0.y -= GRAVITY;
            }
            else if (player0.x > floor.x + floor.width / 2) {
                player0.y -= GRAVITY;
            }
            else if (player0.z > floor.z + floor.height / 2) {
                player0.y -= GRAVITY;
            }
            else if (player0.z < floor.z - floor.height / 2) {
                player0.y -= GRAVITY;
            }

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

            if (player0.y < floor.y) {
                player0.y -= GRAVITY;
            }

            if (player1.y < floor.y) {
                player1.y -= GRAVITY;
            }

            if (player1.y < -1000) {
                resetObjects(1);
                model.calculateScores(0, 200);
            }

            if (player0.y < -1000) {
                resetObjects(0);
                model.calculateScores(200, 0);
            }

            view.render();
        }

        private function rotate(x:Number, y:Number, sin:Number, cos:Number, reverse:Boolean):Point {
            var result:Point = new Point();

            if (reverse) {
                result.x = x * cos + y * sin;
                result.y = y * cos - x * sin;
            }
            else {
                result.x = y * cos - y * sin;
                result.y = y * cos + x * sin;
            }
            return result;
        }

        private function calculateScores(hit:Boolean):void {
            if (hit == true) {
                var p2:Number = Math.abs(Math.round((player1VX + player1VY) * 10));
                var p1:Number = Math.abs(Math.round((player2VX + player2VY) * 10));

                if (p1 > p2) {
                    model.calculateScores(p1 - p2, 0);
                }
                else if (p1 < p2) {
                    model.calculateScores(0, p2 - p1);
                }

            }
            else if (hit == false) {
//                var center:Point = new Point(floor.x / 2, floor.height / 2);
//
//                var dist0X:Number = player0.x - center.x;
//                var dist0Z:Number = player0.z - center.y;
//                var dist0:Number = Math.sqrt(dist0X * dist0X + dist0Z * dist0Z);
//
//                var dist1X:Number = player1.x - center.x;
//                var dist1Z:Number = player1.z - center.y;
//                var dist1:Number = Math.sqrt(dist1X * dist1X + dist1Z * dist1Z);
//
//                trace("player 1: " + dist0);
//                trace("player 2: " + dist1);
            }

        }

        private function handleRemoteStatus(e:RemoteStatusEvent):void {
            var remote:IRemoteControl = e.remote;

            if (remote != null && remote.hasAccelerometer) {
                var accelerometer:Accelerometer = remote.accelerometer;
                var handler:Function;

                if (e.remoteEnabled) {
                    handler = handleAccelerometerEventFactory(remote);
                    remoteHandlers[remote] = handler;
                    accelerometer.setXSmoothingLevel("medium");
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
                if (players[remote.id].model == player0) {
                    player1VX += e.accelerationY * SPEED;
                    player1VY += e.accelerationX * SPEED;
                }
                else if (players[remote.id].model == player1) {
                    player2VX += e.accelerationY * SPEED;
                    player2VY += e.accelerationX * SPEED;
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

