package substates;

using flixel.util.FlxSpriteUtil;

class Cutscene extends FlxSubState {
    public var sprites:Array<{sprite:FlxSprite, name:String}> = [];
    public var dialogue:{fullDialogue:{txt:Array<String>, lines:Array<Int>}, curLine:Int};

    override public function create() {
        super.create();
        trace('created cutscene!');
    }

    //object functions
    public function addToCutscene(spr:FlxSprite, name:String) {
        sprites.push({sprite: spr, name: name});
        add(spr);
    }
    public function addAnimationToSprite(name:String, anim:{name:String, fps:Int, frames:Array<Int>, loop:Bool, flip:{X:Bool, Y:Bool}}) {
        for(i in 0...sprites.length){
            if(sprites[i].name == name) {
                var a:FlxSprite = sprites[i].sprite;
                a.animation.add(anim.name, anim.frames, anim.fps, anim.loop, anim.flip.X, anim.flip.Y);
            }
        }
    }
    public function spritePlayAnim(Sprite:String, anim:String) {
        for(i in 0...sprites.length){
            if(sprites[i].name == Sprite) {
                sprites[i].sprite.animation.play(anim);
            }
        }
    }
    public function setObjectProperty(SpritePointer:String, Property:String, value:Dynamic) {
        for(i in 0...sprites.length){
            if(sprites[i].name == SpritePointer) {
                Reflect.setProperty(sprites[i].sprite, Property, value);
            }
        }
    }
    public function tweenObject(SpritePointer:String, properties:Dynamic, time:Float, tweenProps:TweenOptions) {
        for(i in 0...sprites.length){
            if(sprites[i].name == SpritePointer) {
                FlxTween.tween(sprites[i].sprite, properties, time, tweenProps);
            }
        }
    }
    public function destroyObject(SpritePointer:String){
        for(i in 0...sprites.length){
            if(sprites[i].name == SpritePointer) {
                sprites[i].sprite.destroy();
            }
            sprites[i] = null;

            sprites[i] == null ? trace('object was destroyed successfully') : trace("failed to destroy item... why?");
        }
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