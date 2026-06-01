package entities;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import utils.GlobalState;

class Player extends FlxTypedGroup<FlxBasic>
{
	var globalState:GlobalState;

	var playerSprite:FlxSprite;
	var targetSprite:FlxSprite;

	var speed:Float = 200;
	var drag:Float = 600;

	var lastStickRightX:Float = 0;
	var lastStickRightY:Float = 0;


	public var position:FlxPoint = new FlxPoint();
	public var target:FlxPoint = new FlxPoint();
	public var activated:Bool = false;

	public function new(X:Float, Y:Float)
	{
		super();

		globalState = GlobalState.instance;

		// create a sprite for the player
		playerSprite = new FlxSprite(X, Y);
		playerSprite.makeGraphic(32, 32, 0xff00ff00); // Create a green square as a placeholder player sprite
		playerSprite.drag.set(drag, drag);
		add(playerSprite);

		// // create a sprite for the target
		// targetSprite = new FlxSprite();
		// targetSprite.makeGraphic(16, 16, 0xffff0000); // Create a red square as a placeholder target sprite
		// // targetSprite.alpha = 0;
		// add(targetSprite);
  }

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		updateMovement();

		// updateAim();

		// updateShooting();
	}

	function updateShooting()
	{
		if (globalState.usingController)
		{
			activated = FlxG.gamepads.firstActive.analog.value.RIGHT_TRIGGER >= 0.2;
		}
		else
		{
			activated = FlxG.mouse.pressed;
		}
	}

	function updateAim():Void
	{
		// Update target position
		if (globalState.usingController)
		{
			// Update target sprite position based on right analog stick
			var rightX:Float = FlxG.gamepads.firstActive.analog.value.RIGHT_STICK_X;
			var rightY:Float = FlxG.gamepads.firstActive.analog.value.RIGHT_STICK_Y;
			var length:Float = Math.sqrt(rightX * rightX + rightY * rightY);

			if (length > 0.4)
			{
				lastStickRightX = rightX;
				lastStickRightY = rightY;
			}
			else
			{
				rightX = lastStickRightX;
				rightY = lastStickRightY;
				length = Math.sqrt(rightX * rightX + rightY * rightY);
			}

			if (length != 0)
			{
				rightX /= length;
				rightY /= length;

				targetSprite.x = playerSprite.x + playerSprite.width / 2 + rightX * 100 - targetSprite.width / 2;
				targetSprite.y = playerSprite.y + playerSprite.height / 2 + rightY * 100 - targetSprite.height / 2;
			}
		}
		else
		{
			// Update target sprite position to follow the mouse, be 100 pixels away from the player, in the direction of the mouse
			var mouseX:Float = FlxG.mouse.viewX;
			var mouseY:Float = FlxG.mouse.viewY;

			var dirX:Float = mouseX - (playerSprite.x + playerSprite.width / 2);
			var dirY:Float = mouseY - (playerSprite.y + playerSprite.height / 2);
			var length:Float = Math.sqrt(dirX * dirX + dirY * dirY);
			if (length != 0)
			{
				dirX /= length;
				dirY /= length;

				targetSprite.x = playerSprite.x + playerSprite.width / 2 + dirX * 100 - targetSprite.width / 2;
				targetSprite.y = playerSprite.y + playerSprite.height / 2 + dirY * 100 - targetSprite.height / 2;
			}
		}

		target.set(targetSprite.x + targetSprite.width / 2, targetSprite.y + targetSprite.height / 2);
	}

	function updateMovement():Void
	{
		var up:Bool = false;
		var down:Bool = false;
		var left:Bool = false;
		var right:Bool = false;

		var isMoving:Bool = false;
		var newAngle:Float = 0;
		var magnitude:Float = 0;

		if (globalState.usingController)
		{
			// Handle controller input
			var leftX:Float = FlxG.gamepads.firstActive.analog.value.LEFT_STICK_X;
			var leftY:Float = FlxG.gamepads.firstActive.analog.value.LEFT_STICK_Y;

			if (Math.abs(leftX) > 0.1 || Math.abs(leftY) > 0.1)
			{
				newAngle = Math.atan2(leftY, leftX) * 180 / Math.PI;
				magnitude = Math.sqrt(leftX * leftX + leftY * leftY);
				isMoving = true;
			}
		}
		else
		{
			// Handle keyboard input

			if (FlxG.keys.anyPressed(globalState.settings.input.playerLeft))
			{
				left = true;
			}
			if (FlxG.keys.anyPressed(globalState.settings.input.playerRight))
			{
				right = true;
			}
			if (FlxG.keys.anyPressed(globalState.settings.input.playerUp))
			{
				up = true;
			}
			if (FlxG.keys.anyPressed(globalState.settings.input.playerDown))
			{
				down = true;
			}
			if (up || down || left || right)
			{
				if (up)
				{
					newAngle = -90;
					if (left)
						newAngle -= 45;
					else if (right)
						newAngle += 45;
					// facing = UP;
				}
				else if (down)
				{
					newAngle = 90;
					if (left)
						newAngle += 45;
					else if (right)
						newAngle -= 45;
					// facing = DOWN;
				}
				else if (left)
				{
					newAngle = 180;
					// facing = LEFT;
				}
				else if (right)
				{
					newAngle = 0;
					// facing = RIGHT;
				}
				isMoving = true;
				magnitude = 1;
			}
		}

		// determine our velocity based on angle and speed
		if (isMoving)
		{
			playerSprite.velocity.setPolarDegrees(speed * magnitude, newAngle);
		}

		position.set(playerSprite.x + playerSprite.width / 2, playerSprite.y + playerSprite.height / 2);
	}
}