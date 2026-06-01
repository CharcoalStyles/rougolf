package states;

import entities.Player;
import flixel.FlxG;
import flixel.FlxState;
import states.subStates.PauseState;
import utils.GlobalState;

class PlayState extends FlxState
{
	var globalState:GlobalState;

  var player:Player;

	public function new()
	{
		super();
	}

	override public function create()
	{
		super.create();
		FlxG.mouse.visible = true;
		FlxG.camera.antialiasing = true;

		globalState = FlxG.plugins.get(GlobalState);

    player = new Player(0, 0);
    add(player);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE)
		{
			this.subState = new PauseState();
			this.subState.create();
			this.subState.closeCallback = () ->
			{
				this.subState = null;
			}
		}
	}
}
