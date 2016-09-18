 package;

 import flixel.FlxSprite;
 import flixel.addons.util.FlxAsyncLoop;
 import flixel.system.FlxAssets.FlxGraphicAsset;
 import flixel.util.FlxColor;
 import flixel.FlxObject;
 import flixel.math.FlxPoint;
 import flixel.FlxG;
 import flash.display.BitmapData;

 class Player extends FlxSprite
 {

 	//Movement Varables
 	var left:Bool=false;
 	var right:Bool=false;
 	var dragC:Float=1000;
 	var gravity:Float=1000;
 	var walking:Bool;
	var jumping:Bool;
	var falling:Bool;

 	var speed:Float=200;
 	var jumpSpeed:Float=500;

 	//Used for Asyncronous color replacement
 	var rCRow:UInt;
 	var rCColumn:UInt;
 	//The color being replaced
 	var rCOrig:UInt;
 	//The new color
 	var rCNew:UInt;
 	public var rCLoop:FlxAsyncLoop;
 	var rCPixels:BitmapData;

 	public var bottle:Bottle;



	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset)
	{
		super(X, Y, SimpleGraphic);
		loadSprite();
		setGraphicSize(0,125);
		updateHitbox();
		animation.add("walk",[for (i in 1...24) i],30,true);
		animation.add("jump",[24,25,26,27,28],30,false);
		setFacingFlip(FlxObject.RIGHT,false,false);
		setFacingFlip(FlxObject.LEFT,true,false);
		drag.x=drag.y=dragC;
		acceleration.y=gravity;
		maxVelocity.x=speed;
	}

	function loadSprite(){
		loadGraphic("assets/images/player.png",true,122,200);
	}

	override public function update(elapsed:Float):Void{
		handleMovement();
		super.update(elapsed);
	}

	public function fillBottle(p:Potion){
		if (bottle==null) return;
		bottle.fill(p);
	}

	function handleMovement():Void
	{
		left=FlxG.keys.anyPressed([LEFT,A]);
		right=FlxG.keys.anyPressed([RIGHT,D]);

		if(left&&right){
			left=right=false;
		}
		if (left){
			acceleration.x=-dragC;
			facing=FlxObject.LEFT;
			walking=true;
		} else if (right){
			acceleration.x=dragC;
			facing=FlxObject.RIGHT;
			walking=true;
		} else {
			acceleration.x=0;
			if (velocity.x==0){
				walking=false;
			}
		}
		
		if ((FlxG.keys.justPressed.W || FlxG.keys.justPressed.UP) && isTouching(FlxObject.DOWN)){
			velocity.y=-jumpSpeed;
			jumping=true;
		}
		if (!isTouching(FlxObject.DOWN)){
			falling=true;
		} else {falling=false;}
		
		if (jumping){
			animation.play("jump");
			jumping=false;
		} else if (falling){
			if (animation.name != "jump" || animation.finished){
				animation.stop();
				animation.frameIndex=28;
			}
		} else if (walking){
			animation.play("walk");
		} else {
			animation.stop();
			animation.frameIndex=0;
		}
	}

	public function replaceColorDriver(Color:UInt,NewColor:UInt){
		trace("<");
		if (rCLoop != null && !rCLoop.finished) return;
		trace(">");
		rCRow=0;
		rCColumn=0;
		rCOrig=Color;
		rCNew=NewColor;
		rCPixels=get_pixels();
		trace(rCPixels.height);
		rCLoop=new FlxAsyncLoop(rCPixels.height, replaceColorAsync,2);
	}

	public function replaceColorAsync():Void
	{
		var columns:UInt = rCPixels.width;
		var column:UInt = 0;
		while(column < columns)
		{
			if(rCPixels.getPixel32(column,rCRow) == rCOrig)
			{
				rCPixels.setPixel32(column,rCRow,rCNew);
				//maybe do this at the end if its still slow
			}
			column++;
		}
		rCRow++;
	}

 }