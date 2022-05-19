package editors;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class MenuEditorState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warnText:FlxText;
	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		var storymode offsets;
		var freeplay offsets;
		var credits offsets;
		var mod offsets;

		warnText = new FlxText(0, 0, FlxG.width,
			"Menu Editor is in the Files menustuff.json in assets  \n
			Make the offsetts your self\n
			I think what you already know what todo \n
			If you want the Offsets for them i think you can tell but\n
			If you can't Press Enter to See the directions\n
			Thank you for using the Engine!",
			32);
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
		add(warnText);
	}

	override function update(elapsed:Float)
	{
		if(!leftState) {
			if (controls.ACCEPT) {
				CoolUtil.browserLoad("https://github.com/jamuelthegamer/FNF-Psych-Engine-Plus/wiki/Menu-Editor");
			}
			else if(controls.BACK) {
				MusicBeatState.switchState(new MainMenuState());
			// OpenState.assetsopen('images/menustuff.json');	
			}

			if(leftState)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxTween.tween(warnText, {alpha: 0}, 1, {
					onComplete: function (twn:FlxTween) {
						MusicBeatState.switchState(new MainMenuState());
					}
				});
			}
		}
		super.update(elapsed);
	}
}
