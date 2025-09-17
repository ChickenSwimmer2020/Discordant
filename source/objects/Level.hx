package objects;

import flixel.tile.FlxTile;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import flixel.util.FlxDirectionFlags;
import haxe.Json;

import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;

using StringTools;
using Level.TileTools;

/**
 * # this is the actual level, THIS is the class you wanna use when making a level.
 */
class LVL extends FlxGroup {
    public var player:Player;
    public var level:Level;
    /**
     * init a new level
     * @param startPos player start position
     * @param lvl level json file
     */
    public function new(startPos:FlxPoint, lvl:String = 'testLevel') {
        super();
        level = start(lvl);
        player = createPlayer(startPos);
        add(level);
        add(player);
    }
    override public function update(elapsed:Float){
        super.update(elapsed);
        player.updateControls();
    }
    private function start(LVLS:String):Level return new Level(LVLS);
    private inline function createPlayer(PSP:FlxPoint):Player return new Player(PSP.x, PSP.y, this);
}

/**
 * # level
 * this is the inner workings of a level, as it does everything for creating and rendering a level
 * which includes tilemaps, collisions, exit points, and more.
 */
class Level extends FlxGroup {
    public function new(level:String) {
        super();
        loadLevel(level);
    }
    public var exits:FlxTypedGroup<ExitObject>;
    /**
     * this is the function that makes a level, very simple.
     * @param JSON path to the json file. just input the folders, you dont need `assets/`.
     */
    public function loadLevel(JSON:String) {
        var jsonData:String = File.getContent(Paths.json(JSON));
        var data:Dynamic = Json.parse(jsonData);

        //parse the CSV and create the map.
        //this is where we gotta do some indexing.
        var s:String = '';
        var areasnames:Array<{name:String, direction:String, index:Int}> = [];

        for(i in 0...data.indexies.length) {
            areasnames.push({name: data.indexies[i].name, direction: data.indexies[i].area, index: data.indexies[i].index});
        }

        for(i in 0...data.tiles.length) {
            if(data.tiles[i][0] == areasnames[i].name) {
                trace("found correct tiles...\nloading...");
                add(loadTiles(i, data.tiles[i], data, areasnames[i]).createExits(data));
            }
        }
    }
    private function loadTiles(index:Int, data:Dynamic, fullData:Dynamic, vars:{name:String, direction:String, index:Int}):FlxTilemap {
        trace('creating tilemap: $index...');
        //get the CSV data out of the json.
        var s:String = '';
        for(i in 0...data.length) {
            if(i > 0) {
                s += data[i];
            }
        }
        //get the offsets data out of that json as well.
        //vars.name is actually not really needed, but incase it is. (and to keep flixel happy) we pass it anyways.
        var offsetDirection:String = vars.direction;
        var offsetMulti:Int = vars.index;
        var posX:Float = 0;
        var posY:Float = 0;

        //set the offsets
        switch(offsetDirection) {
            case "left":
                posX = 640;
            case "right":
                posX = -640;
            case "up":
                posY = -480;
            case "down":
                posY = 480;
            case "main":
                posX = 0;
                posY = 0;
        }
        var map:FlxTilemap = new FlxTilemap();
        map.loadMapFromCSV(s, 'assets/images/TILESET_testing.png', 16, 16);
        
        var offsetsDirection:FlxPoint = new FlxPoint();
        offsetsDirection.set(posX * offsetMulti, posY * offsetMulti);
        map.setPosition(offsetsDirection.x, offsetsDirection.y);

        //finally, collisions
        for(i in 0...fullData.collisionTypes.length) {
            trace('setting tiletype: ${Std.string(fullData.collisionTypes[i].id)} to: ${Std.string(getDir(fullData.collisionTypes[i].type))}.');
            map.setTileProperties(fullData.collisionTypes[i].id, getDir(fullData.collisionTypes[i].type));
        }

        return map;
    }
    private static inline function getDir(s:String):FlxDirectionFlags
        switch(s) {case 'LEFT': return LEFT; case 'RIGHT': return RIGHT; case 'UP': return UP; case 'DOWN': return DOWN; case 'NONE': return NONE; case 'CEILING': return CEILING; case 'FLOOR': return FLOOR; case 'WALL': return WALL; case 'ANY': return ANY; default: return NONE;}
}

class ExitObject extends FlxObject {
    public function new(x:Float, y:Float, toLevel:String, startPos:Array<Float>, alignToGrid:Bool = true) {
        super(x, y);
        if(startPos.length > 2) throw haxe.io.Error.Custom("Stack overflow!! to many objects in start position array.");

        if(alignToGrid) setPosition(Math.floor((x + 8) / 16) * 16, Math.floor((y + 8) / 16) * 16); //force align to the grid.
        width = height = 16;
    }
}

class TileTools {
    static public function createExits(tiles:FlxTilemap, data:Dynamic) {
        var exits:Array<{xy:Array<Float>, to:String, startPos:Array<Float>}> = [];
        for(i in 0...data.exits.length) exits.push({xy: data.exits[i].tile, to: data.exits[i].to, startPos: data.exits[i].startPos});
        for(i in 0...exits.length) FlxG.state.add(new ExitObject(exits[i].xy[0], exits[i].xy[1], exits[i].to, exits[i].startPos));
        return tiles;
    }
}