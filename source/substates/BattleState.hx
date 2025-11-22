package substates;

import flixel.math.FlxMath;
import backend.BeatState;

class BattleState extends BeatState {
    var tester:FlxSprite;
    public function new(song:String) {
        super(song);

        tester = new FlxSprite().makeGraphic(100, 100, FlxColor.WHITE);
        tester.screenCenter();
        add(tester);
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
        tester.scale.x = FlxMath.lerp(1, tester.scale.x, Math.exp(-elapsed * 3.125 * 1 * 1));
        tester.scale.y = FlxMath.lerp(1, tester.scale.y, Math.exp(-elapsed * 3.125 * 1 * 1));
    }
 
    override public function beatHit(curBeat:Int){
        super.beatHit(curBeat);
        tester.scale.x += 0.2;
        tester.scale.y += 0.2;
    }
}