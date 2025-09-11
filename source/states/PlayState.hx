package states;

import flixel.math.FlxPoint;
import flixel.util.FlxDirectionFlags;
import flixel.FlxObject;
import flixel.tile.FlxTilemap;
import objects.Level;
import objects.Player;

/**
 * # PlayState
 * ## This is the main state of the game.
 * Where mostly EVERYTHING happens within the main player game interaction, minus menus.
 */
class PlayState extends FlxState {
    public var lvl:LVL;
    public var start:FlxPoint;
    public var level:String;

    /**
     * the new function. called once from MainMenuState
     * @param xy position for player start, defaults to 0, 0.
     * @param lvl the level input string for loading from a json.
     */
    public function new(xy:{x:Float, y:Float}, ?lvl:String = 'testLevel') {
        super();
        start = new FlxPoint(xy.x, xy.y);
        level = lvl;
    }

    override public function create() {
        super.create();
        lvl = new LVL(start, level);
        add(lvl);
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
        lvl.player.updateControls(lvl);
    }
}