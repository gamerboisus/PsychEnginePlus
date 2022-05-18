#if cpp
package;

import lime.app.Application;
#if desktop
import Discord.DiscordClient;
#end
import openfl.utils.Assets as OpenFlAssets;
import flixel.ui.FlxBar;
import haxe.Exception;
import openfl.utils.AssetType;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
#if cpp
import sys.FileSystem;
import sys.io.File;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.input.keyboard.FlxKey;

using StringTools;

class Caching extends MusicBeatState
{
	var toBeDone = 0;
	var done = 0;

	var loaded = false;

	var text:FlxText;
	var psychLogo:FlxSprite;

	var images = [];
	var music = [];
	var charts = [];

	static public function listSongsToCache()
	{
		// We need to query OpenFlAssets, not the file system, because of Polymod.
		var soundAssets = OpenFlAssets.list(AssetType.MUSIC).concat(OpenFlAssets.list(AssetType.SOUND));
	
		// TODO: Maybe rework this to pull from a text file rather than scan the list of assets.
		var songNames = [];
	
		for (sound in soundAssets)
		{
			// Parse end-to-beginning to support mods.
			var path = sound.split('/');
			path.reverse();
	
			var fileName = path[0];
			var songName = path[1];
	
			if (path[2] != 'songs')
				continue;
	
			// Remove duplicates.
			if (songNames.indexOf(songName) != -1)
				continue;
	
			songNames.push(songName);
		}
	
		return songNames;
	}

	override function create()
	{
		FlxG.save.bind('funkin', 'ninjamuffin99');

		PlayerSettings.init();

		FlxG.mouse.visible = false;

		FlxG.worldBounds.set(0, 0);

		text = new FlxText(FlxG.width / 2, FlxG.height / 2 + 300, 0, "Loading...");
		text.size = 34;
		text.alignment = FlxTextAlign.CENTER;
		text.alpha = 0;

		psychLogo = new FlxSprite(FlxG.width / 2, FlxG.height / 2).loadGraphic(Paths.image('PsychEngineLogo'));
		psychLogo.x -= psychLogo.width / 2;
		psychLogo.y -= psychLogo.height / 2 + 100;
		text.y -= psychLogo.height / 2 - 125;
		text.x -= 170;
		psychLogo.setGraphicSize(Std.int(psychLogo.width * 0.6));
		if (FlxG.save.data.antialiasing != null)
			psychLogo.antialiasing = FlxG.save.data.antialiasing;
		else
			psychLogo.antialiasing = true;

		psychLogo.alpha = 0;

		add(psychLogo);
		add(text);


		#if cpp
		if (FlxG.save.data.cacheImages)
		{
			// TODO: Refactor this to use OpenFlAssets.
			for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/characters")))
			{
				if (!i.endsWith(".png"))
					continue;
				images.push(i);
			}

			for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/noteskins")))
			{
				if (!i.endsWith(".png"))
					continue;
				images.push(i);
			}
		}

		trace("caching music...");

		// TODO: Get the song list from OpenFlAssets.
		music = listSongsToCache();
		#end

		toBeDone = Lambda.count(images) + Lambda.count(music);

		trace('starting caching..');

		// update thread

		// cache thread
		sys.thread.Thread.create(() ->
		{
			cache();
		});

		super.create();
	}

	var calledDone = false;

	override function update(elapsed)
	{
		super.update(elapsed);
	}

	function cache()
	{
		#if cpp
		trace("LOADING: " + toBeDone + " OBJECTS.");

		for (i in music)
		{
			var inst = Paths.inst(i);
			if (OpenFlAssets.exists(inst, AssetType.MUSIC))
			{
				FlxG.sound.cache(inst);
			}

			var voices = Paths.voices(i);
			if (OpenFlAssets.exists(voices, AssetType.MUSIC))
			{
				FlxG.sound.cache(voices);
			}

			done++;
		}

		trace("Finished caching...");

		loaded = true;
		#end
		FlxG.switchState(new TitleState());
	}
}
#end
