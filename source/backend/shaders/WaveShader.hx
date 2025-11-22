package backend.shaders;

import flixel.system.FlxAssets.FlxShader;

class WaveShader extends FlxShader {

    @:glVertexSource('
        #pragma header

        uniform float uTime;       // animation time
        uniform float uAmplitude;  // max displacement in pixels
        uniform float uFrequency;  // number of waves along height
        uniform float uSpeed;      // wave speed

        void main() {
            vec4 pos = openfl_Position;

            // ----- Horizontal wave along X -----
            float wave = sin(pos.y * uFrequency + uTime * uSpeed) * uAmplitude;

            pos.x += wave;

            // ----- Snap VERTEX to pixel grid -----
            pos.xy = floor(pos.xy + 0.5);

            // ----- Apply projection -----
            gl_Position = openfl_Matrix * pos;

            // ----- Pass UV to fragment shader -----
            openfl_TextureCoordv = openfl_TextureCoord;

            // Optional: subtle UV distortion to match vertex wave
            openfl_TextureCoordv.x += wave * 0.01;
        }
    ')

    @:glFragmentSource('
        #pragma header

        void main() {
            vec2 uv = openfl_TextureCoordv;

            gl_FragColor = texture2D(bitmap, uv);
        }
    ')

    public function new() {
        super();
        uTime.value       = [0];
        uAmplitude.value  = [5.0];   // horizontal displacement in pixels
        uFrequency.value  = [10.0];  // number of waves along height
        uSpeed.value      = [2.0];   // wave speed
    }
}
