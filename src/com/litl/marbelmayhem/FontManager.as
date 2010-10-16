package com.litl.marbelmayhem
{

    public class FontManager
    {
        [Embed(source="assets/fonts/CalibriBold.ttf", fontFamily="Calibri", fontWeight="normal", mimeType='application/x-font', embedAsCFF='false')]
        private var CalibriBold:Class;

        [Embed(source="assets/fonts/Calibri.ttf", fontFamily="Calibri", fontWeight="normal", mimeType='application/x-font', embedAsCFF='false')]
        private var Calibri:Class;

        public function FontManager() {
        }
    }
}
