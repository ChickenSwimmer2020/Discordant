package backend;

class Paths {
    public inline static function image(path:String):String return 'assets/images/$path.png';
    public inline static function json(path:String):String return 'assets/$path.json';
}