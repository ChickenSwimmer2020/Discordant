package objects;

import flixel.input.keyboard.FlxKey;
import objects.Level.LVL;
import substates.PauseSubstate.PauseMenu;

using StringTools;

class Player extends FlxSprite {
    private var levelPointer:Level;
    private var controls:Array<{action:String, keys:Array<FlxKey>}> = [];
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
        //TODO: controls menus

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
            if(prefs.controls[i].type == 'playerAction') { //only pull the player action controls.
                switch(prefs.controls[i].action) {
                    case "moveLEFT":
                        controls.push({action: "LEFT", keys: prefs.controls[i].keys});
                        controlCodes.set("ML", 0);
                    case "moveUP":
                        controls.push({action: "UP", keys: prefs.controls[i].keys});
                        controlCodes.set("MU", 1);
                    case "moveDOWN":
                        controls.push({action: "DOWN", keys: prefs.controls[i].keys});
                        controlCodes.set("MD", 2);
                    case "moveRIGHT":
                        controls.push({action: "RIGHT", keys: prefs.controls[i].keys});
                        controlCodes.set("MR", 3);
                    case "pause":
                        controls.push({action: "pause", keys: prefs.controls[i].keys});
                        controlCodes.set("P", 4);
                }
            }
        }
        trace(controls);
    }
}