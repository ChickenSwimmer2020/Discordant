package substates.options;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.text.FlxInputText;
import flixel.input.keyboard.FlxKey;

class ControlsSubstate extends FlxSubState {
    var totalControls:Map<Int, {a:String, k:Array<FlxKey>}> = [];
    
    var prefs = UserPrefs.currentGamePreferences;
    //var controlsCurrent:Map<String, Array<FlxKey>>;
    override public function create() {
        super.create();

        for(i in 0...prefs.controls.length) {
            totalControls.set(i, {a: prefs.controls[i].action, k: prefs.controls[i].keys});
        }

        var i:Int = 0;
        for(reference => controlData in totalControls) {
            add(new ControlsObject(i, controlData.a, reference, controlData.k));
            i++;
        }
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        if(FlxG.keys.justPressed.ESCAPE) {
            onExit();
        }
    }

    private function onExit() {
        //write to prefs then close.
        trace(UserPrefs.currentGamePreferences.controls);
        PrefsWriter.writeToPrefsFile(UserPrefs.currentGamePreferences);
        close();
        trace(UserPrefs.currentGamePreferences);
    }
}

private class ControlsObject extends flixel.group.FlxSpriteGroup {
    private var c:String;
    public function new(iterator:Int, curControl:String, loc:Int, Controls:Array<FlxKey>) {
        super();
        c = curControl;

        var t:FlxText = new FlxText(50, 50 + (25 * iterator), 0, curControl, 24);
        add(t);
        var type1:FlxInputText = new FlxInputText(t.width + 50, t.y, 100, Controls[0], 8);
        var type2:FlxInputText = new FlxInputText(type1.x + 150, t.y, 100, Controls[1], 8);
        add(type1);
        add(type2);

        type1.onEnter.add((_)->{
            trace('changed control: ${curControl} [BIND ONE] to: ${type1.text}');
            changeKeybind(0, loc, type1.text);
        });

        type2.onEnter.add((_)->{
            trace('changed control: ${curControl} [BIND TWO] to: ${type2.text}');
            changeKeybind(1, loc, type2.text);
        });
    }

    private inline static function changeKeybind(loc:Int, control:Int, bind:String)
        UserPrefs.currentGamePreferences.controls[control].keys[loc] = FlxKey.fromString(bind.toUpperCase());    
}