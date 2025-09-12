package backend;

/**
 * # Paths
 * this is how you get files easily.
 * ```haxe
 * var spr:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('filename'));
 * ```
 * it will automatically get images from the images folder.
 */
class Paths {
    public inline static function image(path:String):String return 'assets/images/$path.png';
    public inline static function json(path:String):String return 'assets/$path.json';
}