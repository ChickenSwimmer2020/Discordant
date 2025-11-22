package objects;

import backend.shaders.SkewShader;
import flixel.util.FlxTimer;
import flixel.group.FlxSpriteContainer.FlxTypedSpriteContainer;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

class ChapterPopup extends FlxTypedSpriteContainer<FlxSprite> {
    public var onAnimComplete:Void->Void;
    var line:FlxSprite;
    var chap:FlxText;
    var title:FlxText;
    public function playAnimation(chapter:String, name:String) {
        var titleSkew:SkewShader = new SkewShader();
        line = new FlxSprite().makeGraphic(500, 4, FlxColor.WHITE);
    
        chap = new FlxText(0, FlxG.height / 2 - 20, FlxG.width, chapter, 48);
        chap.setFormat(null, 48, FlxColor.WHITE, "center");

        title = new FlxText(1280, FlxG.height / 2 + 20, FlxG.width, name, 32);
        title.setFormat(null, 32, FlxColor.WHITE, "center");

        title.shader = titleSkew;

    

        add(line);
        add(chap);
        add(title);

        line.screenCenter();
        chap.y = 720;
        title.y = line.y + 5;

        line.x = -1000;
        line.scale.x = 2;
        FlxTween.tween(line, {"scale.x": 1, x: (FlxG.width-500)/2}, 0.5, {ease: FlxEase.expoOut, onComplete: (_)->{
             new FlxTimer().start(0.75, (_) -> {
                FlxTween.tween(line, {"scale.x": 5, x: 1280 * 5}, 0.5, {ease: FlxEase.expoIn, onComplete: (_)->{
                    line.destroy();
                    _.destroy();
                }});
                _.destroy();
            });
            _.destroy();
        }});

        title.shader.data.uSkewX.value = [0.04];
        FlxTween.tween(title, {x: 0}, 0.5, {ease: FlxEase.expoOut, onComplete: (_)->{
            new FlxTimer().start(0.75, (_) -> {
                FlxTween.tween(title, {x: -1280}, 0.5, {ease: FlxEase.expoIn, onComplete: (_)->{
                    title.destroy();
                    _.destroy();
                }});
                _.destroy();
            });
            _.destroy();
        }});

        FlxTween.tween(chap, {y: line.y - chap.height, alpha: 1}, 0.5, {ease: FlxEase.expoOut, onComplete: (_)->{
           new FlxTimer().start(0.75, (_) -> {
                FlxTween.tween(chap, {y: -150, alpha: 0}, 0.5, {ease: FlxEase.expoIn, onComplete: (_)->{
                    chap.destroy();
                    if(onAnimComplete != null) onAnimComplete();
                    _.destroy();
                }});
                _.destroy();
            });
            _.destroy();
        }});
    }
}