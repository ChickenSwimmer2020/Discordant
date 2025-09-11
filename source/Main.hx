package;

class Main extends Sprite {
    public function new() {
        super();
        addChild(new FlxGame(0, 0, states.MenuState, 60, 60, false, false));
    }
}