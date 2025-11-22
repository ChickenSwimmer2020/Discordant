package backend;

import flixel.sound.FlxSound;

class BeatState extends FlxState {
    public static var BPM:Int = 0;
    public static var AUDIONAME:String = '';
    public static var curBeat:Int = 0;
    public static var interval:Float = 0;
    public static var nextTriggerTime:Float = 0;
    public function new(songName:String) {
        super();
        loadAudioData(songName);
    }


    private function loadAudioData(name:String) {
        if(FileSystem.exists(Paths.music(name))) {
            var data = readHeader('${Paths.music(name)}');
            BPM = data[0];
            AUDIONAME = data[1];

            trace(data);
            trace(BPM);
            trace(AUDIONAME);

            FlxG.sound.playMusic('${Paths.music(name)}/$AUDIONAME.ogg');
            curBeat = 0;
            interval = (60 / BPM * 1000);
        }else{
            trace('uh oh!');
        }
    }

    private function readHeader(path:String):Array<Dynamic> {
        var file:String = File.getContent('$path/data.shf'); 
        var dataLines:Array<String> = file.split('\n');
        return [Std.parseInt(dataLines[0]), dataLines[1]];
    }

    public function beatHit(curBeat:Int):Void {
        trace('Base beat hit: $curBeat');
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
        if (FlxG.sound.music != null) {
            FlxG.sound.music.onComplete = () -> {
                nextTriggerTime = 0;
            };
            if (FlxG.sound.music.time >= nextTriggerTime) {
                curBeat++;
                beatHit(curBeat);
                nextTriggerTime += interval;
            }
        }
    }
}