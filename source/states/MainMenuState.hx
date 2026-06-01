package states;

import csHxUtils.entities.CsMenu;
import csHxUtils.entities.SplitText;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import utils.GlobalState;

class MainMenuState extends FlxState
{
	var gameName:String = "Rogolf";
	var globalState:GlobalState;

	var showSplash:Bool = true;
	var controllerCaptureText:FlxText;
	var menu:CsMenu;

	override public function create()
	{
		super.create();
		globalState = new GlobalState();
		FlxG.plugins.addPlugin(globalState);
		FlxG.mouse.visible = true;

		var text = generateTitle();
		add(text);
		text.x = (FlxG.width - text.width) / 2;
		text.y = 96;

		menu = new CsMenu(FlxG.width / 2, FlxG.height / 2, FlxTextAlign.CENTER, {
			keyboard: true,
			mouse: true,
			gamepad: true,
			gamepadId: 0
		});
		var mainPage = menu.createPage("Main");

		mainPage.addItem("New Game", () ->
		{
			FlxG.switchState(PlayState.new);
		});
		mainPage.addItem("Toggle Fullscreen", () -> FlxG.fullscreen = !FlxG.fullscreen);

		// add(menu);

		controllerCaptureText = new FlxText(0, FlxG.height - 32, FlxG.width, "Press any button to start");
		controllerCaptureText.setFormat(null, 16, FlxColor.WHITE, FlxTextAlign.CENTER);
		add(controllerCaptureText);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (showSplash)
		{
			var gamepad = FlxG.gamepads.anyButton();
			if (FlxG.keys.firstJustPressed() != -1 || FlxG.mouse.justPressed || gamepad)
			{
				showSplash = false;
				remove(controllerCaptureText);
				add(menu);

				if (gamepad)
				{
					FlxG.log.add("Controller input detected in menu");
					globalState.usingController = true;
				}
			}
		}
		else
		{
			// Normal menu update logic
			super.update(elapsed);
		}
	}

	function generateTitle()
	{
		var text = new SplitText(0, 0, gameName, SplitText.naiieveScaleDefaultOptions(2.5));
		text.color = 0xff000000;
		text.borderColor = 0xffffffff;
		text.borderQuality = 4;
		text.borderSize = 4;
		text.borderStyle = OUTLINE;
		text.animateWave(5, 0.1, 1.5, false);
		text.animateColourByArray([0xffcbeb74, 0xff88ff88, 0xff11b864], 0.075, 0.6,);

		return text;
	}
}
