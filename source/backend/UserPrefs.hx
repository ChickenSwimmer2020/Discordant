package backend;

import flixel.input.keyboard.FlxKey;

//TODO: this, properly.
typedef UserPreferencesData = {
    controls:Array<{action:String, key:FlxKey, type:String}>
} 

class UserPrefs {
    public static var currentGamePreferences:UserPreferencesData = {
        controls: [
            {action: "moveUP", key: W, type: "playerAction"}
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