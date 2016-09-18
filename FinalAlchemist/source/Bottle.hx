 package;

 import flixel.FlxSprite;
 import flixel.system.FlxAssets.FlxGraphicAsset;
 import flixel.util.FlxColor;
 import flixel.FlxObject;
 import flixel.math.FlxPoint;
 import flixel.FlxG;

 class Bottle extends Player 
 {

 	public var attached=false;

 	public function new(X:Float, Y:Float, ?SimpleGraphic:FlxGraphicAsset){
 		super(X,Y,SimpleGraphic);
 	}

 	public function config(velocityX:Float, velocityY:Float, animationFrame:Int, animationName:String, direction:Int):Void{
 		velocity.x=velocityX;
 		velocity.y=velocityY;
 		animation.play(animationName,false,false,animationFrame);
 		facing=direction;
 	}

 	override function loadSprite(){
		loadGraphic("assets/images/bottle.png",true,122,200);
	}

	override public function update(elapsed:Float){
		if (attached){
			super.update(elapsed);
		}
		
	}
 }