package objects;

import flixel.input.keyboard.FlxKey;
import objects.Level.LVL;
import substates.PauseSubstate.PauseMenu;

using StringTools;

class Player extends FlxSprite {
    private var controls:Array<FlxKey> = []; //TODO: make this work and not crash
    //we have to force the way controls is laid out.
    //0 = left, 1 = up, 2 = down, 3 = right, 4 = pause
    public function new(x:Float, y:Float) {
        super(x, y);
        makeGraphic(16, 32, FlxColor.RED);

        // Physics setup
        drag.x = 600;         // Friction for horizontal movement
        drag.y = 600;         // Friction for horizontal movement
        maxVelocity.x = 80;   // Max running speed
        maxVelocity.y = 80;   // Max running speed

        initControls();
    }
    public function updateControls(lvl:LVL) {
        // Horizontal movement
        velocity.x = 0;
        //TODO: controls menus



        if (FlxG.keys.pressed.RIGHT)
            velocity.x = maxVelocity.x;

        if (FlxG.keys.anyPressed([controls[1]]))
            velocity.y = -maxVelocity.y;

        if (FlxG.keys.pressed.DOWN)
            velocity.y = maxVelocity.y;

        if (FlxG.keys.pressed.LEFT)
            velocity.x = -maxVelocity.x;


        if (FlxG.keys.pressed.ESCAPE)
            FlxG.state.openSubState(new PauseMenu());

        //TODO: slopes.
    
        FlxG.collide(this, lvl.level);
        FlxG.watch.addQuick('PLAYER BOUNDS: ', getBoundingBox(FlxG.camera));
    }

    private function initControls() {
        var prefs:UserPreferencesData = UserPrefs.currentGamePreferences; //for easy access

        for(key in 0...prefs.controls.length) {
            if(prefs.controls[key].type == 'playerAction') {
                trace('key: ${prefs.controls[key].key}, action: ${prefs.controls[key].action}');
                switch(prefs.controls[key].action) {
                    case 'moveUP':
                        controls.insert(1, prefs.controls[key].key);
                    default:
                        null;
                }
            }
        }
        controls = [];
    }
}