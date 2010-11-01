package com.litl.marbelmayhem.views
{
    import flash.display.Sprite;

    public class ViewBase extends Sprite
    {
        private var _width:Number;
        private var _height:Number;

        public function ViewBase() {
            super();
        }

        override public function get height():Number {
            return _height;
        }

        override public function set height(value:Number):void {
            _height = value;
        }

        override public function get width():Number {
            return _width;
        }

        override public function set width(value:Number):void {
            _width = value;
        }

        public function setSize(newWidth:Number, newHeight:Number):void {
            width = newWidth;
            height = newHeight;

            sizeUpdated();
        }

        protected function sizeUpdated():void {

        }

    }
}
