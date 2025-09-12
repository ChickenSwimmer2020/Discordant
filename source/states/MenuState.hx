package states;

import lime.app.Application;
import flixel.group.FlxSpriteGroup;
import flixel.ui.FlxButton;
import flixel.addons.display.FlxStarField.FlxStarField2D;

class MenuState extends FlxState {
    /**
     * options screen group.
     */
    private var options:FlxSpriteGroup; //should be able to hold everything?
    /**
     * achivements screen group
     */
    private var achivements:FlxSpriteGroup; //TODO: gamejolt integration
    /**
     * save creation/loading screen
     */
    private var game:FlxSpriteGroup; //screen for creating a new save/loading a save
    /**
     * main screen (title)
     */
    private var main:FlxSpriteGroup;

    override public function create() {
        //make the background first.
        var bg:FlxStarField2D = new FlxStarField2D(0, 0, FlxG.width, FlxG.height, 300);
        add(bg); //since we dont need to move the BG at all, we can just declare it here.

        //--------GROUPS--------//
        //we have to create these now so the background doesnt move between them all.
        //why did i choose to rewrite the entire main menu system,
        options = new FlxSpriteGroup();
        achivements = new FlxSpriteGroup();
        game = new FlxSpriteGroup();
        main = new FlxSpriteGroup();
        add(options);
        add(achivements);
        add(game);
        add(main);

        //force set the positions for the groups
        options.x = -640; //to the LEFT of the main menu
        achivements.x = 640; //to the RIGHT of the main menu
        game.y = -480; //ABOVE the main menu



        //--------MAIN MENU--------//
            for(i in 0...4) {
                var button:FlxButton = new FlxButton(0, 100 + (20 * i), ["play", "achivements", "options", "exit"][i], ()->{
                    transition(i);
                });
                main.add(button);
            }

        //--------GAME MENU--------//
            var button_backtomenu:FlxButton = new FlxButton(0, 0, 'back', ()->{
                transition(4);
            });
            game.add(button_backtomenu);

            var button_play:FlxButton = new FlxButton(0, 50, 'play', ()->{
                FlxG.switchState(()->new PlayState({x: 0, y: 0}, 'testLevel'));
            });
            game.add(button_play);
        //--------ACHIVEMENTS MENU--------//
            var button_backtomenu2:FlxButton = new FlxButton(0, 0, 'back', ()->{
                transition(5);
            });
            achivements.add(button_backtomenu2);
        //--------OPTIONS MENU--------//
            var button_backtomenu3:FlxButton = new FlxButton(0, 0, 'back', ()->{
                transition(6);
            });
            options.add(button_backtomenu3);
    }

    function transition(type:Int) {
        switch(type) {
            case 0: //to play menu
                FlxTween.tween(main, {y: 640}, 1, {ease: FlxEase.expoIn});
                FlxTween.tween(game, {y: 0}, 1, {ease: FlxEase.expoIn});
            case 1: //to awards menu
                FlxTween.tween(main, {x: -640}, 1, {ease: FlxEase.expoIn});
                FlxTween.tween(achivements, {x: 0}, 1, {ease: FlxEase.expoIn});
            case 2: //to options menu
                FlxTween.tween(main, {x: 640}, 1, {ease: FlxEase.expoIn});
                FlxTween.tween(options, {x: 0}, 1, {ease: FlxEase.expoIn});
            case 3: //exiting game
                FlxTween.tween(main, {y: -640}, 1, {ease: FlxEase.expoIn});
                FlxTween.tween(Application.current.window, {opacity: 0}, 1, {ease: FlxEase.expoIn, onComplete: (_)->{
                    Sys.exit(0);
                }});

            case 4: //back to main from play
                FlxTween.tween(main, {y: 0}, 1, {ease: FlxEase.expoIn});
                FlxTween.tween(game, {y: -640}, 1, {ease: FlxEase.expoIn});
            case 5: //back to main from awards
                FlxTween.tween(main, {x: 0}, 1, {ease: FlxEase.expoIn});
                FlxTween.tween(achivements, {x: 640}, 1, {ease: FlxEase.expoIn});
            case 6: //back to main from options
                FlxTween.tween(main, {x: 0}, 1, {ease: FlxEase.expoIn});
                FlxTween.tween(options, {x: -640}, 1, {ease: FlxEase.expoIn});
            //dont need a case 7.
            default:
                trace('Undefined transition: $type');
        }
    }
}