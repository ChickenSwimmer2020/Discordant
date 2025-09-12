package backend;

import flixel.input.keyboard.FlxKey;

//TODO: this, properly.
typedef UserPreferencesData = {
    controls:Array<{action:String, keys:Array<FlxKey>, type:String}>
} 

class UserPrefs {
    public static var currentGamePreferences:UserPreferencesData = {
        controls: [
            {action: "moveLEFT", keys: [A, LEFT], type: "playerAction"},
            {action: "moveUP", keys: [W, UP], type: "playerAction"},
            {action: "moveDOWN", keys: [S, DOWN], type: "playerAction"},
            {action: "moveRIGHT", keys: [D, RIGHT], type: "playerAction"},
            {action: "pause", keys: [ESCAPE, BACKSPACE], type: "playerAction"}
        ]
    }
}

class PrefsReader {
    public function readFromPrefsFile(file:String):UserPreferencesData {
        return {
            controls: []
        };
    }
}

class PrefsWriter {
    public function writeToPrefsFile(Prefs:UserPreferencesData) {

    }
}