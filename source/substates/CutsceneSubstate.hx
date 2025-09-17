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
        FlxTween.tween(sprites.get(Sprite), properties, time, tweenProps);
    
    inline public function destroyObject(SpritePointer:String){
        sprites.get(SpritePointer).destroy();
        if(sprites.set(SpritePointer) == null)
            sprites.remove(SpritePointer);
    }
    
    //dialogue functions
    public function openDialogueBox(?startline:Int = 0, ?size:{width:Int, height:Int}) {
        size == null ? size = {width: 620, height: 150} : null;
        var box:FlxSprite = new FlxSprite(0, 0).makeGraphic(size.width, size.height, FlxColor.BLACK);
        box.drawRect(box.x, box.y, box.width, box.height, FlxColor.BLACK, {thickness: 4, color: FlxColor.WHITE});
        addToCutscene(box, '_DIALOUGE');
        box.setPosition(10, 480 - size.height - 10);
    }
    public function closeDialogueBox(?closeState:Bool = true) {
        destroyObject('_DIALOUGE');
        if(closeState) close();
    }
}