package objects;

import objects.Level.LVL;
import substates.PauseSubstate.PauseMenu;
import flixel.util.FlxDirectionFlags;
import flixel.tile.FlxTilemap;

class Player extends FlxSprite {
    public function new(x:Float, y:Float) {
        super(x, y);
        makeGraphic(16, 32, FlxColor.RED);

        // Physics setup
        acceleration.y = 400; // Gravity strength
        maxVelocity.y = 200;  // Max fall speed
        drag.x = 600;         // Friction for horizontal movement
        maxVelocity.x = 80;   // Max running speed
    }
    public function updateControls(lvl:LVL) {
        // Horizontal movement
        velocity.x = 0;
        if (FlxG.keys.pressed.RIGHT) velocity.x = maxVelocity.x;
        else if (FlxG.keys.pressed.LEFT) velocity.x = -maxVelocity.x;
        if (FlxG.keys.pressed.ESCAPE) FlxG.state.openSubState(new PauseMenu());

        //TODO: slopes.
    
        FlxG.collide(this, lvl.level);
        
        FlxG.watch.addQuick('PLAYER BOUNDS: ', getBoundingBox(FlxG.camera));

        

        // Jump
        if (FlxG.keys.justPressed.SPACE && isTouching(FLOOR))
        {
            velocity.y = -200;
        }
    }
}