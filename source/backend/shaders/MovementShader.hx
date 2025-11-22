package backend.shaders;

import flixel.system.FlxAssets.FlxShader;

class MovementShader3D extends FlxShader {

    @:glVertexSource('
        #pragma header

        uniform float uTime;
        uniform float uWaveAmount;
        uniform float uFrequency;
        uniform float uSpeed;

        void main() {
            vec4 pos = openfl_Position;

            // True wave: combine X and Y to get 2D wave motion
            float wave = sin(pos.x * uFrequency + pos.y * uFrequency + uTime * uSpeed) * uWaveAmount;
            float waveY = cos(pos.x * uFrequency + pos.y * uFrequency + uTime * uSpeed) * uWaveAmount * 0.5;

            pos.x += wave;
            pos.y += waveY;

            gl_Position = openfl_Matrix * pos;

            // Pass UV down for fragment shader
            openfl_TextureCoordv = openfl_TextureCoord;
        }
    ')


    @:glFragmentSource('
        #pragma header

        uniform float uTime;
        uniform float uWaveAmount;
        uniform float uFrequency;
        uniform float uSpeed;

        void main() {
            vec2 uv = openfl_TextureCoordv;

            // UV wave (scaled for 0–1 range)
            uv.x += sin(uv.y * uFrequency + uTime * uSpeed) * (uWaveAmount * 0.01);

            gl_FragColor = texture2D(bitmap, uv);
        }
    ')

    public function new() {
        super();
        uTime.value       = [0];
        uWaveAmount.value = [5.0];
        uFrequency.value  = [0.05];
        uSpeed.value      = [2.0];
    }
}
