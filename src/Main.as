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

    import com.litl.marbelmayhem.utils.FontManager;
    import com.litl.marbelmayhem.utils.GameMaterials;
    import com.litl.marbelmayhem.views.Scoreboard;
    import com.litl.marbelmayhem.controller.GameController;
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
        public var view:View3D;
        public var player0:Sphere;
        public var player1:Sphere;
        public var floor:Plane;
        public var world:Skybox;
        public var gameMaterials:GameMaterials;

        private var scoreboard:Scoreboard;
        private var countdown:CountDown;

        private var controller:GameController;

        public function Main() {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            var fonts:FontManager = new FontManager();

            addEventListener(Event.ADDED_TO_STAGE, init);
        }

        private function init(e:Event):void {
            controller = GameController.getInstance();
            controller.view = this;

            countdown = new CountDown(this.stage);
            gameMaterials = new GameMaterials();

            createView();
            createScene();
            createScoreboard();
            creatStatsMonitor();
        }

        private function creatStatsMonitor():void {
            var stats:Stats = new Stats();
            stats.x = 0;
            stats.y = 80;
            addChild(stats);
        }

        private function createScoreboard():void {
            scoreboard = new Scoreboard(this.stage);
            addChild(scoreboard);
        }

        protected function createView():void {
            view = new View3D();
            view.x = 640;
            view.y = 400;
            view.camera.y = 425;
            // view.camera.rotationY = 45;
            view.camera.z = -5500;
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

            controller.models.push({ model: player0 }, { model: player1 });
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
            floor.z = -4100;
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
    }
}

