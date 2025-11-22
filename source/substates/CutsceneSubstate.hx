package substates;

import objects.DialogBox;
import flixel.util.FlxTimer;
using flixel.util.FlxSpriteUtil;

//TODO: documentation.

class Cutscene extends FlxSubState {
    public var sprites:Map<String, FlxSprite> = [];
    public var dialogue:{fullDialogue:{txt:Array<String>, lines:Array<Int>}, curLine:Int};

    override public function create() {
        super.create();
        trace('created cutscene!');
    }

    //object functions
    public function addToCutscene(spr:FlxSprite, name:String) {
        sprites.set(name, spr);
        add(spr);
    }
    inline public function addAnimationToSprite(name:String, anim:{name:String, fps:Int, frames:Array<Int>, loop:Bool, flip:{X:Bool, Y:Bool}})
        sprites.get(name).animation.add(anim.name, anim.frames, anim.fps, anim.loop, anim.flip.X, anim.flip.Y);
    
    inline public function spritePlayAnim(Sprite:String, anim:String)
        sprites.get(Sprite).animation.play(anim);
    
    inline public function setObjectProperty(SpritePointer:String, Property:String, value:Dynamic)
        Reflect.setProperty(sprites.get(SpritePointer), Property, value);

    inline public function tweenObject(SpritePointer:String, properties:Dynamic, time:Float, tweenProps:TweenOptions)
        FlxTween.tween(sprites.get(SpritePointer), properties, time, tweenProps);
    
    inline public function destroyObject(SpritePointer:String){
        sprites.get(SpritePointer).destroy();
        if(sprites.get(SpritePointer) == null)sprites.remove(SpritePointer);
    }
    
    //dialogue functions
    inline public function openDialogBox(?startline:Int = 0, ?size:{width:Int, height:Int}, ?ddlcfile:String) addToCutscene(new DialogBox(startline, size, ddlcfile), '_DIALOG');
    
    public function closeDialogBox(?closeState:Bool = true) {
        destroyObject('_DIALOG');
        if(closeState) close();
    }
}

class CutsceneReader {
    public static var toExecute:Map<Int, Array<Dynamic>> = [];
    static var Cutscene:Cutscene = new Cutscene();
    static final tweenTypes:Map<String, Int> = [
        "" => 8, //in-case a value is or is not set.
        "NONE" => 8,

        "PERSIST" => 1,
        "LOOPING" => 2,
        "PINGPONG" => 4,
        "ONESHOT" => 8,
        "BACKWARD" => 16
    ];
    public static function readFromCutsceneFile(path:String) {
        Cutscene = new Cutscene();
        FlxG.state.openSubState(Cutscene);

        var CutsceneData = Xml.parse(File.getContent(Paths.Cutscene(path))); //gives us our cutscene
        var root = CutsceneData.firstElement(); // <Cutscene>

        for(child in root.elements()) {
            switch(child.nodeName) {
                case 'Sprite': Cutscene.addToCutscene(new FlxSprite(Std.parseFloat(child.get('x')), Std.parseFloat(child.get('y'))).loadGraphic(Paths.image(child.get('image')), child.get('animated') == 'true', Std.parseInt(child.get('sizeX')), Std.parseInt(child.get('sizeY'))), child.get('name'));
                case 'Anim':
                    var frames:Array<Int> = [];
                    for(i in 0...child.get('frames').length) if(child.get('frames').charAt(i) != ',') frames.push(Std.parseInt(child.get('frames').charAt(i)));
                    Cutscene.addAnimationToSprite(child.get('pointer'), {name: child.get('name'), fps: Std.parseInt(child.get('fps')), frames: frames, loop: child.get('loop') == 'true', flip:{X: child.get('flipX') == 'true', Y: child.get('flipY') == 'true'}});
                case 'playAnim': Cutscene.spritePlayAnim(child.get('pointer'), child.get('anim'));
                case 'set':
                    switch(child.get('type')) {
                        case 'Float': Cutscene.setObjectProperty(child.get('pointer'), child.get('property'), Std.parseFloat(child.get('value')));
                        case 'Int': Cutscene.setObjectProperty(child.get('pointer'), child.get('property'), Std.parseInt(child.get('value')));
                        case 'String': Cutscene.setObjectProperty(child.get('pointer'), child.get('property'), child.get('value'));
                        default: trace('no type selected for set object.');
                    }
                case 'Tween':
                    switch(child.get('type')) {
                        case 'X': Cutscene.tweenObject(child.get('pointer'), {x: Std.parseFloat(child.get('x'))}, Std.parseFloat(child.get('time')), {startDelay: Std.parseFloat(child.get('startDelay')), ease: getEase(child.get('ease')), type: tweenTypes.get(child.get('tweentype'))});
                        case 'Y': Cutscene.tweenObject(child.get('pointer'), {y: Std.parseFloat(child.get('y'))}, Std.parseFloat(child.get('time')), {startDelay: Std.parseFloat(child.get('startDelay')), ease: getEase(child.get('ease')), type: tweenTypes.get(child.get('tweentype'))});
                        case 'Scale': Cutscene.tweenObject(child.get('pointer'), {"scale.x": Std.parseFloat(child.get('scaleX')), "scale.y": Std.parseFloat(child.get('scaleY'))}, Std.parseFloat(child.get('time')), {startDelay: Std.parseFloat(child.get('startDelay')), ease: getEase(child.get('ease')), type: tweenTypes.get(child.get('tweentype'))});
                        case 'Angle': Cutscene.tweenObject(child.get('pointer'), {angle: Std.parseFloat(child.get('angle'))}, Std.parseFloat(child.get('time')), {startDelay: Std.parseFloat(child.get('startDelay')), ease: getEase(child.get('ease')), type: tweenTypes.get(child.get('tweentype'))});
                        case 'Alpha': Cutscene.tweenObject(child.get('pointer'), {alpha: Std.parseFloat(child.get('alpha'))}, Std.parseFloat(child.get('time')), {startDelay: Std.parseFloat(child.get('startDelay')), ease: getEase(child.get('ease')), type: tweenTypes.get(child.get('tweentype'))});
                    }
                case 'startDialog': Cutscene.openDialogBox(); //TODO: make work
                case 'endDialog': Cutscene.closeDialogBox();
                case 'removeObject': Cutscene.destroyObject(child.get('pointer'));
                case 'endCutscene': Cutscene.close();
                case 'dialogueUpdate': trace(returnBlockAsArray(child));

                case 'timer':
                    new FlxTimer().start(Std.parseFloat(child.get('time')), (_)->{
                        trace('timer object finished with a time of ${child.get('time')}');
                        parseTimerBlock(child);
                        _.destroy();
                    });
            }
        }
    }

    private static function parseTimerBlock(timer:Xml) {
        for(action in timer.elements()) {
            switch(action.nodeName) {
                case 'Sprite': Cutscene.addToCutscene(new FlxSprite(Std.parseFloat(action.get('x')), Std.parseFloat(action.get('y'))).loadGraphic(Paths.image(action.get('image')), action.get('animated') == 'true', Std.parseInt(action.get('sizeX')), Std.parseInt(action.get('sizeY'))), action.get('name'));
                case 'Anim':
                    var frames:Array<Int> = [];
                    for(i in 0...action.get('frames').length) if(action.get('frames').charAt(i) != ',') frames.push(Std.parseInt(action.get('frames').charAt(i)));
                    Cutscene.addAnimationToSprite(action.get('pointer'), {name: action.get('name'), fps: Std.parseInt(action.get('fps')), frames: frames, loop: action.get('loop') == 'true', flip:{X: action.get('flipX') == 'true', Y: action.get('flipY') == 'true'}});
                case 'playAnim': Cutscene.spritePlayAnim(action.get('pointer'), action.get('anim'));
                case 'set':
                    switch(action.get('type')) {
                        case 'Float': Cutscene.setObjectProperty(action.get('pointer'), action.get('property'), Std.parseFloat(action.get('value')));
                        case 'Int': Cutscene.setObjectProperty(action.get('pointer'), action.get('property'), Std.parseInt(action.get('value')));
                        case 'String': Cutscene.setObjectProperty(action.get('pointer'), action.get('property'), action.get('value'));
                        default: trace('no type selected for set object.');
                    }
                case 'Tween':
                    switch(action.get('type')) {
                        case 'X': Cutscene.tweenObject(action.get('pointer'), {x: Std.parseFloat(action.get('x'))}, Std.parseFloat(action.get('time')), {startDelay: Std.parseFloat(action.get('startDelay')), ease: getEase(action.get('ease')), type: tweenTypes.get(action.get('tweentype'))});
                        case 'Y': Cutscene.tweenObject(action.get('pointer'), {y: Std.parseFloat(action.get('y'))}, Std.parseFloat(action.get('time')), {startDelay: Std.parseFloat(action.get('startDelay')), ease: getEase(action.get('ease')), type: tweenTypes.get(action.get('tweentype'))});
                        case 'Scale': Cutscene.tweenObject(action.get('pointer'), {"scale.x": Std.parseFloat(action.get('scaleX')), "scale.y": Std.parseFloat(action.get('scaleY'))}, Std.parseFloat(action.get('time')), {startDelay: Std.parseFloat(action.get('startDelay')), ease: getEase(action.get('ease')), type: tweenTypes.get(action.get('tweentype'))});
                        case 'Angle': Cutscene.tweenObject(action.get('pointer'), {angle: Std.parseFloat(action.get('angle'))}, Std.parseFloat(action.get('time')), {startDelay: Std.parseFloat(action.get('startDelay')), ease: getEase(action.get('ease')), type: tweenTypes.get(action.get('tweentype'))});
                        case 'Alpha': Cutscene.tweenObject(action.get('pointer'), {alpha: Std.parseFloat(action.get('alpha'))}, Std.parseFloat(action.get('time')), {startDelay: Std.parseFloat(action.get('startDelay')), ease: getEase(action.get('ease')), type: tweenTypes.get(action.get('tweentype'))});
                    }
                case 'startDialog': Cutscene.openDialogBox(); //TODO: make work
                case 'endDialog': Cutscene.closeDialogBox();
                case 'removeObject': Cutscene.destroyObject(action.get('pointer'));
                case 'endCutscene': Cutscene.close();
                case 'timer':
                    new FlxTimer().start(Std.parseFloat(action.get('time')), (_)->{
                        trace('timer object finished with a time of ${action.get('time')}');
                        parseTimerBlock(action);
                        _.destroy();
                    });
            }
        }
    }
    private static function returnBlockAsArray(diaLine:Xml):Array<Dynamic> {
        var toReturn:Array<Dynamic> = [];
        for(action in diaLine.elements()) {
            switch(action.nodeName) {
                case 'Sprite': toReturn.push('<Sprite name="${action.get('name')}" x="${action.get('x')}" y="${action.get('y')}" image="${action.get('image')}" animated="${action.get('animated')}" sizeX="${action.get('sizeX')}" sizeY="${action.get('sizeY')}"/>');
                case 'Anim': toReturn.push('<Anim pointer="${action.get('pointer')}" name="${action.get('name')}" fps="${action.get('fps')}" frames="${action.get('frames')}" loop="${action.get('loop')}" flipX="${action.get('flipX')}" flipY="${action.get('flipY')}"/>');
                case 'playAnim': toReturn.push('<playAnim pointer="${action.get('pointer')}" anim="${action.get('anim')}"/>');
                case 'set':
                    switch(action.get('type')) {
                        case 'Float': toReturn.push('<set type="Float" pointer="${action.get('pointer')}" property="${action.get('property')}" value="${action.get('value')}"/>');
                        case 'Int': toReturn.push('<set type="Int" pointer="${action.get('pointer')}" property="${action.get('property')}" value="${action.get('value')}"/>');
                        case 'String': toReturn.push('<set type="String" pointer="${action.get('pointer')}" property="${action.get('property')}" value="${action.get('value')}"/>');
                        default: trace('no type selected for set object.');
                    }
                case 'Tween':
                    switch(action.get('type')) {
                        case 'X': toReturn.push('<Tween type="X" pointer="${action.get('pointer')}" x="${action.get('x')}" time="${action.get('time')}" ease="${action.get('ease')}" tweentype="${action.get('tweentype')}" startDelay="${action.get('startDelay')}"/>');
                        case 'Y': toReturn.push('<Tween type="Y" pointer="${action.get('pointer')}" y="${action.get('y')}" time="${action.get('time')}" ease="${action.get('ease')}" tweentype="${action.get('tweentype')}" startDelay="${action.get('startDelay')}"/>');
                        case 'Scale': toReturn.push('<Tween type="Scale" pointer="${action.get('pointer')}" scaleX="${action.get('scaleX')}" scaleY="${action.get('scaleY')}" time="${action.get('time')}" ease="${action.get('ease')}" tweentype="${action.get('tweentype')}" startDelay="${action.get('startDelay')}"/>');
                        case 'Angle': toReturn.push('<Tween type="Angle" pointer="${action.get('pointer')}" angle="${action.get("angle")}" time="${action.get("time")}" ease="${action.get("ease")}" tweentype="${action.get("tweentype")}" startDelay="${action.get("startDelay")}"/>');
                        case 'Alpha': toReturn.push('<Tween type="Alpha" pointer="${action.get('pointer')}" alpha="${action.get("alpha")}" time="${action.get("time")}" ease="${action.get("ease")}" tweentype="${action.get("tweentype")}" startDelay="${action.get("startDelay")}"/>');
                    }
                case 'startDialog': toReturn.push('<startDialog/>');
                case 'endDialog': toReturn.push('<endDialog/>');
                case 'removeObject': toReturn.push('<removeObject pointer="${action.get('pointer')}"/>');
                case 'endCutscene': toReturn.push('<endCutscene/>');
                //case 'timer': //TODO: support for timers.
                //    var wholeBlock:String = '';
                //    
                //
                //toReturn.push('<timer time="${action.get('time')}"/>');
                //    new FlxTimer().start(Std.parseFloat(action.get('time')), (_)->{
                //        trace('timer object finished with a time of ${action.get('time')}');
                //        parseTimerBlock(action);
                //        _.destroy();
                //    });
            }
        }
        return toReturn;
    }
    private static function getEase(e:String):EaseFunction {
        return Reflect.getProperty(FlxEase, e);
    }
}