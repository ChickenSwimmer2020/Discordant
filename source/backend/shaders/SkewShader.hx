package backend.shaders;

import flixel.system.FlxAssets.FlxShader;

class SkewShader extends FlxShader {

    @:glVertexSource('
        #pragma header

        uniform float uSkewX;
        uniform float uSkewY;

        void main() {
            // starting position (x, y)
            vec4 pos = vec4(openfl_Position.xy, 0.0, 1.0);

            // apply skew to geometry
            pos.x += pos.y * uSkewX;
            pos.y += pos.x * uSkewY;

            openfl_TextureCoordv = openfl_TextureCoord;
            gl_Position = openfl_Matrix * pos;
        }
    ')

    @:glFragmentSource('
        #pragma header

        uniform float uSkewX;   // horizontal skew amount
        uniform float uSkewY;   // vertical skew amount

        void main() {
            vec2 uv = openfl_TextureCoordv.xy;
            uv.x += uv.y * uSkewX;
            uv.y += uv.x * uSkewY;
            vec4 color = texture2D(bitmap, uv);
            gl_FragColor = color;
        }
    ')
    public function new(){
        super();

        // Set default skew values
        uSkewX.value = [0.0];
        uSkewY.value = [0.0];
    }

    public function setSkew(x:Float, y:Float):Void {
        uSkewX.value = [x];
        uSkewY.value = [y];
    }

    public function getSkew():{x:Float, y:Float} {
        return {x: uSkewX.value[0], y: uSkewY.value[0]};
    }
}