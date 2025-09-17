package objects;

import flixel.input.keyboard.FlxKey;
import objects.Level.LVL;
import substates.PauseSubstate.PauseMenu;

using StringTools;

class Player extends FlxSprite {
    private var levelPointer:Level;
    private var controls:Array<{action:String, keys:Array<FlxKey>}> = []; //TODO: find way to consolodate this array and map into one map.
    private var controlCodes:Map<String, Int> = new Map<String, Int>();
    public function new(x:Float, y:Float, level:LVL) {
        super(x, y);
        levelPointer = level.level;
        makeGraphic(16, 32, FlxColor.RED);

        // Physics setup
        drag.x = 600;         // Friction for horizontal movement
        drag.y = 600;         // Friction for horizontal movement
        maxVelocity.x = 80;   // Max running speed
        maxVelocity.y = 80;   // Max running speed

        initControls();
    }
    public function updateControls() {
        // Horizontal movement
        velocity.x = 0;

        //TODO: find way to optimize ts
        if(FlxG.keys.anyPressed(controls[controlCodes.get('MS')].keys)) { //for sprinting since we have to re-work it.
            maxVelocity.x = 120;
        }else{
            maxVelocity.x = 80;
        }
        if (FlxG.keys.anyPressed(controls[controlCodes.get('MR')].keys))
            velocity.x = maxVelocity.x;

        if (FlxG.keys.anyPressed(controls[controlCodes.get('MU')].keys))
            velocity.y = -maxVelocity.y;

        if (FlxG.keys.anyPressed(controls[controlCodes.get('MD')].keys))
            velocity.y = maxVelocity.y;

        if (FlxG.keys.anyPressed(controls[controlCodes.get('ML')].keys))
            velocity.x = -maxVelocity.x;


        if (FlxG.keys.anyPressed(controls[controlCodes.get('P')].keys))
            FlxG.state.openSubState(new PauseMenu());

        //TODO: slopes.
        FlxG.collide(this, levelPointer);
        FlxG.watch.addQuick('PLAYER BOUNDS: ', getBoundingBox(FlxG.camera));
    }

    private function initControls() {
        var prefs:UserPreferencesData = UserPrefs.currentGamePreferences; //for easy access
        for(i in 0...prefs.controls.length) {
            if(prefs.controls[i].type == 'playerAction') {
                if(prefs.controls[i].action.startsWith('move')){
                    controls.push({action: prefs.controls[i].action.substr(4), keys: prefs.controls[i].keys});
                    controlCodes.set('${prefs.controls[i].action.charAt(0)}${prefs.controls[i].action.charAt(4)}'.toUpperCase(), i); //should work?
                }else{
                    controls.push({action: prefs.controls[i].action, keys: prefs.controls[i].keys});
                    controlCodes.set(prefs.controls[i].action.charAt(0).toUpperCase(), i); //should work?
                }
            }
        }
        trace(controls);
    }
}