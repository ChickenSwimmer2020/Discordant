package substates;

import states.MenuState;
import states.MenuState;
import flixel.ui.FlxButton;
import flixel.math.FlxPoint;
using flixel.util.FlxSpriteUtil;

class PauseMenu extends FlxSubState {
    public function new() {
        super();
        var triangle:FlxSprite = new FlxSprite(-400, 0).makeGraphic(400, 480, FlxColor.TRANSPARENT);
        triangle.scrollFactor.set();
        add(triangle);
        var points:Array<FlxPoint> = [
            new FlxPoint(0, 0),
            new FlxPoint(0, 480),
            new FlxPoint(400, 480),
            new FlxPoint(200, 0),
            new FlxPoint(0, 0)
        ];
        triangle.drawPolygon(points, FlxColor.BLACK, {thickness: 8, color: FlxColor.WHITE});
        FlxTween.tween(triangle, {x: 0}, 0.786, {ease: FlxEase.circOut});

        for(i in 0...3){
            var btn:FlxButton = new FlxButton(50, 100 + (22 * i), ["resume", "options", "exit"][i], [
                ()->{close();}, //TODO: closing animation.
                ()->{}, //TODO: options menu.
                ()->{FlxG.switchState(()->new MenuState());}
            ][i]);
            add(btn);
        }
    }
}