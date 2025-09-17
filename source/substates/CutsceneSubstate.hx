package substates;

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
        if(sprites.get(SpritePointer) == null)
            sprites.remove(SpritePointer);
    }
    
    //dialogue functions
    public function openDialogBox(?startline:Int = 0, ?size:{width:Int, height:Int}) {
        size == null ? size = {width: 620, height: 150} : null;
        var box:FlxSprite = new FlxSprite(0, 0).makeGraphic(size.width, size.height, FlxColor.BLACK);
        box.drawRect(box.x, box.y, box.width, box.height, FlxColor.BLACK, {thickness: 4, color: FlxColor.WHITE});
        addToCutscene(box, '_DIALOG');
        box.setPosition(10, 480 - size.height - 10);
    }
    public function closeDialogBox(?closeState:Bool = true) {
        destroyObject('_DIALOG');
        if(closeState) close();
    }
}
class CutsceneReader {
    public static function readFromCutsceneFile(path:String) {
        var Cutscene:Cutscene = new Cutscene();
        FlxG.state.openSubState(Cutscene);

        var CutsceneData = Xml.parse(File.getContent(Paths.Cutscene(path))); //gives us our cutscene
        var root = CutsceneData.firstElement(); // <Cutscene>

        for(child in root.elements()) {
            switch(child.nodeName) {
                case 'Sprite':
                    Cutscene.addToCutscene(new FlxSprite(Std.parseFloat(child.get('x')), Std.parseFloat(child.get('y'))).loadGraphic(Paths.image(child.get('image')), child.get('animated') == 'true', Std.parseInt(child.get('sizeX')), Std.parseInt(child.get('sizeY'))), child.get('name'));

                case 'Anim':
                    var frames:Array<Int> = [];
                    for(i in 0...child.get('frames').length) if(child.get('frames').charAt(i) != ',') frames.push(Std.parseInt(child.get('frames').charAt(i)));
                    Cutscene.addAnimationToSprite(child.get('pointer'), {name: child.get('name'), fps: Std.parseInt(child.get('fps')), frames: frames, loop: child.get('loop') == 'true', flip:{X: child.get('flipX') == 'true', Y: child.get('flipY') == 'true'}});
                case 'playAnim':
                    Cutscene.spritePlayAnim(child.get('pointer'), child.get('anim'));

                case 'SetFloat':
                    Cutscene.setObjectProperty(child.get('pointer'), child.get('property'), Std.parseFloat(child.get('value')));
                case 'setInt':
                    Cutscene.setObjectProperty(child.get('pointer'), child.get('property'), Std.parseInt(child.get('value')));
                case 'setString':
                    Cutscene.setObjectProperty(child.get('pointer'), child.get('property'), child.get('value')); //TODO: find out how to make this work with both strings and numbers.

                //tweens //TODO: consolodate these into one function (solar please help.)
                case 'TweenX':
                    Cutscene.tweenObject(child.get('pointer'), {x: Std.parseFloat(child.get('x'))}, Std.parseFloat(child.get('time')), {startDelay: Std.parseFloat(child.get('startDelay')), ease: getEase(child.get('ease')), type: Std.parseInt(child.get('tweentype'))});
                case 'TweenY':
                    Cutscene.tweenObject(child.get('pointer'), {y: Std.parseFloat(child.get('y'))}, Std.parseFloat(child.get('time')), {startDelay: Std.parseFloat(child.get('startDelay')), ease: getEase(child.get('ease')), type: Std.parseInt(child.get('tweentype'))});
                case 'TweenScale':
                    Cutscene.tweenObject(child.get('pointer'), {"scale.x": Std.parseFloat(child.get('scaleX')), "scale.y": Std.parseFloat(child.get('scaleY'))}, Std.parseFloat(child.get('time')), {startDelay: Std.parseFloat(child.get('startDelay')), ease: getEase(child.get('ease')), type: Std.parseInt(child.get('tweentype'))});
                case 'TweenAngle':
                    Cutscene.tweenObject(child.get('pointer'), {angle: Std.parseFloat(child.get('angle'))}, Std.parseFloat(child.get('time')), {startDelay: Std.parseFloat(child.get('startDelay')), ease: getEase(child.get('ease')), type: Std.parseInt(child.get('tweentype'))});
                case 'TweenAlpha':
                    Cutscene.tweenObject(child.get('pointer'), {alpha: Std.parseFloat(child.get('alpha'))}, Std.parseFloat(child.get('time')), {startDelay: Std.parseFloat(child.get('startDelay')), ease: getEase(child.get('ease')), type: Std.parseInt(child.get('tweentype'))});
                
                case 'startDialog':
                    //TODO: make dialog work properly
                    Cutscene.openDialogBox();
                case 'endDialog':
                    Cutscene.closeDialogBox();

                case 'removeObject':
                    Cutscene.destroyObject(child.get('pointer'));
            }
        }
    }


    private static function getEase(e:String):EaseFunction {
        return Reflect.getProperty(FlxEase, e);
    }
}