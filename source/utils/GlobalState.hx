package utils;

import flixel.FlxBasic;

class GlobalState extends FlxBasic
{
	public static var instance:GlobalState = new GlobalState();

	public var usingController:Bool = false;

	public var settingsEditable:Bool = false;

	private var _settings:Settings = {
		input: {
			playerUp: ["W", "UP"],
			playerDown: ["S", "DOWN"],
			playerLeft: ["A", "LEFT"],
			playerRight: ["D", "RIGHT"],
		}
	};

	public var settings(get, set):Settings;

	private function get_settings():Settings
	{
		return _settings;
	}

	private function set_settings(value:Settings):Settings
	{
		if (settingsEditable)
		{
			_settings = value;
		}
		return _settings;
	}


	public function new()
	{
		super();
	}
}