package backend;

import haxe.Json;
import flixel.input.keyboard.FlxKey;

using StringTools;

typedef UserPreferencesData = {
    controls:Array<{action:String, keys:Array<FlxKey>, type:String}>
} 

class UserPrefs {
    static final DefaultGamePreferences:UserPreferencesData = {
        controls: [
            {action: "moveLEFT", keys: [A, LEFT], type: "playerAction"},
            {action: "moveUP", keys: [W, UP], type: "playerAction"},
            {action: "moveDOWN", keys: [S, DOWN], type: "playerAction"},
            {action: "moveRIGHT", keys: [D, RIGHT], type: "playerAction"},
            {action: "pause", keys: [ESCAPE, BACKSPACE], type: "playerAction"},
            {action: "moveSPRINT", keys: [SHIFT], type: "playerAction"}
        ]
    }
    public static var currentGamePreferences:UserPreferencesData = DefaultGamePreferences; //for defaulting when the game is started

    public static function init() {
        currentGamePreferences = PrefsReader.readFromPrefsFile();
    }
}

class PrefsReader {
    public static function readFromPrefsFile():UserPreferencesData {
        @:privateAccess {
            if(!FileSystem.exists('assets/uPrefs.json')) {
                trace('couldnt find file');
                return UserPrefs.DefaultGamePreferences;
            }
        }
        var data:Dynamic = Json.parse(File.getContent('assets/uPrefs.json'));
        trace(data);

        var ctrls:Array<{action:String, keys:Array<FlxKey>, type:String}> = [];
        var actualKeys:Array<Array<FlxKey>> = [];
        for(i in 0...data.Preferences.Controls.length) {
            var entry:Dynamic = cast data.Preferences.Controls[i];
            actualKeys[i] = [];
            for(j in 0...entry.keys.length) {
                actualKeys[i].push(FlxKey.fromString(entry.keys[j]));
            }
            trace(actualKeys);
            ctrls.push({action: entry.action, keys: actualKeys[i], type: entry.type});
        }
        return {
            controls: ctrls
        };
    }
}

class PrefsWriter {
    public static function writeToPrefsFile(Prefs:UserPreferencesData) {
        var controls:String = '';
        var keyCodes:Array<Array<FlxKey>> = [];
        var keys:Array<Array<String>> = [];

        for(i in 0...Prefs.controls.length) {
            keyCodes.push(Prefs.controls[i].keys);
            keys[i] = []; //to prevent null access
            for(j in 0...keyCodes[i].length) keys[i].push('\"${keyCodes[i][j].toString()}\"');

            if(i != Prefs.controls.length - 1) controls += '           {\"action\": \"${Prefs.controls[i].action}\", \"keys\": ${keys[i]}, \"type\": \"${Prefs.controls[i].type}\"},\n';
            else controls += '           {\"action\": \"${Prefs.controls[i].action}\", \"keys\": ${keys[i]}, \"type\": \"${Prefs.controls[i].type}\"}';
        }
        var jsonStructure:String = '{
    \"Preferences\":{
        \"Controls\":[
${controls}
        ]
    }
}';
        File.saveContent('assets/uPrefs.json', jsonStructure);
    }
}