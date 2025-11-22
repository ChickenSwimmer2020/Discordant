package objects;

import haxe.Json;
import flixel.group.FlxSpriteContainer.FlxTypedSpriteContainer;

using flixel.util.FlxSpriteUtil;
using StringTools;

class DialogBox extends FlxTypedSpriteContainer<FlxSprite> {
    public var lineComplete:Void->Void;
    public var dialogComplete:Void->Void;
    public var onSkip:Void->Void;
    public var curLineSkipable:Bool = true;
    public var curLineComplete:Bool = false;
    public var dialogLines:Array<String> = [];
    public var curLineIndex:Int = 0;
    public var dialogText:FlxText;
    public var box:FlxSprite;
    /**
     * put one character in this at a time. done automatically. so ignore this.
     */
    public var dialogTextTypeEffect:Map<String, {p:Int, lines:Array<String>}> = [];

    public function new(?startline:Int = 0, ?size:{width:Int, height:Int}, diaFile:String = 'example') {
        super();
        size == null ? size = {width: 620, height: 150} : null;
        box = new FlxSprite(0, 0).makeGraphic(size.width, size.height, FlxColor.BLACK);
        box.drawRect(box.x, box.y, box.width, box.height, FlxColor.BLACK, {thickness: 4, color: FlxColor.WHITE});
        add(box);
        box.setPosition(10, 480 - size.height - 10);

        dialogText = new FlxText(box.x + 25, box.y + 25, box.width - 50, '', 24);
        dialogText.setFormat(null, 24, FlxColor.WHITE, 'left');
        add(dialogText);


        if(File.getContent(Paths.dialogue(diaFile)) != null) {
            var rawDiaData:Dynamic = Json.parse(File.getContent(Paths.dialogue(diaFile)));
            for(section in 0...rawDiaData.dialog.sections.length) {
                var sectionData = rawDiaData.dialog.sections[section];

                var typeTextString:String = sectionData.l.toString().substr(1, sectionData.l.toString().length - 2);
                var characters:Array<String> = [];
                for(char in typeTextString.split('')) {
                    characters.push(char);
                }
                dialogTextTypeEffect.set('section${section}', {p: Std.parseInt(sectionData.t), lines: characters});
            }
            trace(dialogTextTypeEffect);
        } else {
            dialogLines = ['Error: Dialogue file not found at path: ' + Paths.dialogue(diaFile)];
        }
    }
}