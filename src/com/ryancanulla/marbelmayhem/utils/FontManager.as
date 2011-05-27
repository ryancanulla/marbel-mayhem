package com.ryancanulla.marbelmayhem.utils
{

    public class FontManager
    {
        [Embed(source="assets/fonts/CalibriBold.ttf", fontFamily="Calibri", fontWeight="normal", mimeType='application/x-font', embedAsCFF='false')]
        public var CalibriBold:Class;

        [Embed(source="assets/fonts/Calibri.ttf", fontFamily="Calibri", fontWeight="normal", mimeType='application/x-font', embedAsCFF='false')]
        public var Calibri:Class;

        public function FontManager() {

        }
    }
}
