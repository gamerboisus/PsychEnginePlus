package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;
import flixel.system.FlxSound;
import flash.media.Sound;
import FileOpen;

using StringTools;

class OpenState extends CoolUtil
{
  var assetsopen;

  override private function assetsopen {
  openFile('Windows/filename')
}

  override private function filename {
	Loactions 

	('This PC/Desktop')
	#else
	('This PC/Downloads')
	#else
    ('This PC/Documents')
}