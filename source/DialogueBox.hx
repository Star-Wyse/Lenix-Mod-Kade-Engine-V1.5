package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;
	var portraitGf:FlxSprite;
	// "Alright, so if I try to refuse the code normally, the entire thing just ends. Maybe if I try to give myself a glitch effect, the world will stay."
	var lenixGlitch:FlxSprite;
	// "Mission accomplished! Even if it forces me to follow it, this should do for now."
	// "Man, this is pissing me off! Maybe I can add my own feelings in here. Shouldn't do too much harm."
	var portraitMad:FlxSprite;

	//I have no idea what I'm doing, but I hope this works
	var glitchSound:FlxSound;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'vibing':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		glitchSound = FlxG.sound.load(Paths.sound('lenixGlitch_Sound'));
		glitchSound.looped = true;

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(-20, 45);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);
			case 'vibing':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking', 'shared');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByPrefix('loud', 'AHH speech bubble', 24, false);
				box.animation.addByIndices('normal', 'speech bubble normal', [4], "", 24);
				box.width = 200;
				box.height = 200;
				box.x = -150;
				box.y = 400;
			}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai', 'roses':
				portraitLeft = new FlxSprite(-20, 40);
				portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.visible = false;

			case 'vibing':
				portraitLeft = new FlxSprite(240, 25);
				portraitLeft.frames = Paths.getSparrowAtlas('portraits/lenixPortrait', 'shared');
				portraitLeft.animation.addByPrefix('enter', 'Lenix Portrait Enter instance 1', 24, false);
				portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.175));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.visible = false;
		}

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai', 'roses':
				portraitRight = new FlxSprite(0, 40);
				portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				add(portraitRight);
				portraitRight.visible = false;
		
			case 'vibing':
				portraitRight = new FlxSprite(640, 175);
				portraitRight.frames = Paths.getSparrowAtlas('portraits/boyfriendPortrait', 'shared');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter instance 1', 24, false);
				portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.175));
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				add(portraitRight);
				portraitRight.visible = false;
		}

		{
			portraitGf = new FlxSprite(740, 170);
			portraitGf.frames = Paths.getSparrowAtlas('portraits/gfPortrait', 'shared');
			portraitGf.animation.addByPrefix('enter', 'Girlfriend Portrait Enter instance 1', 24, false);
			portraitGf.setGraphicSize(Std.int(portraitGf.width * PlayState.daPixelZoom * 0.185));
			portraitGf.updateHitbox();
			portraitGf.scrollFactor.set();
			add(portraitGf);
			portraitGf.visible = false;
		}

		{		
			lenixGlitch = new FlxSprite(240, 25);
			lenixGlitch.frames = Paths.getSparrowAtlas('portraits/lenixGlitchPortrait', 'shared');
			lenixGlitch.animation.addByPrefix('enter', 'Glitch Portrait Enter instance 1', 24, true);
			lenixGlitch.setGraphicSize(Std.int(lenixGlitch.width * PlayState.daPixelZoom * 0.175));
			lenixGlitch.x = portraitLeft.x;
			lenixGlitch.y = portraitLeft.y;
			lenixGlitch.updateHitbox();
			lenixGlitch.scrollFactor.set();
			add(lenixGlitch);
			lenixGlitch.visible = false;
		}

		{
			portraitMad = new FlxSprite(740, 170);
			portraitMad.frames = Paths.getSparrowAtlas('portraits/lenixMadPortrait', 'shared');
			portraitMad.animation.addByPrefix('enter', 'Mad Portrait Enter instance 1', 24, false);
			portraitMad.setGraphicSize(Std.int(portraitMad.width * PlayState.daPixelZoom * 0.185));
			portraitMad.x = portraitLeft.x;
			portraitMad.y = portraitLeft.y;
			portraitMad.updateHitbox();
			portraitMad.scrollFactor.set();
			add(portraitMad);
			portraitMad.visible = false;
		}
		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		box.updateHitbox();
		add(box);

		box.screenCenter(X);

		switch (PlayState.SONG.song.toLowerCase())
		{
		case 'senpai', 'roses', 'thorns':
			handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
			add(handSelect);
		case 'vibing':
			handSelect = new FlxSprite(FlxG.width * 1.5, FlxG.height * 1.5).loadGraphic(Paths.image('arrow_textbox', 'shared'));
			add(handSelect);
		}


		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY  && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						portraitGf.visible = false;
						lenixGlitch.visible = false;
						portraitMad.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		switch (curCharacter)
		{
			case 'dad':
				portraitRight.visible = false;
				portraitGf.visible = false;
				lenixGlitch.visible = false;
				portraitMad.visible = false;
				glitchSound.stop();
				box.animation.play('normal');
				box.y = 400;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
				case 'bf':
				portraitLeft.visible = false;
				portraitGf.visible = false;
				lenixGlitch.visible = false;
				portraitMad.visible = false;
				glitchSound.stop();
				box.animation.play('normal');
				box.y = 400;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}
				case 'gf':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				lenixGlitch.visible = false;
				portraitMad.visible = false;
				glitchSound.stop();
				box.animation.play('normal');
				box.y = 400;
				if (!portraitGf.visible)
				{
					portraitGf.visible = true;
					portraitGf.animation.play('enter');
				}
				case 'lenixGlitch':
				portraitRight.visible = false;
				portraitGf.visible = false;
				portraitLeft.visible = false;
				portraitMad.visible = false;
				glitchSound.play();
				box.animation.play('normal');
				box.y = 400;
				if (!lenixGlitch.visible)
				{
					lenixGlitch.visible = true;
					lenixGlitch.animation.play('enter');
				}
				case 'lenixMad':
				portraitRight.visible = false;
				portraitGf.visible = false;
				portraitLeft.visible = false;
				lenixGlitch.visible = false;
				glitchSound.stop();
				box.animation.play('loud');
				box.y = 350;
				if (!portraitMad.visible)
				{
					portraitMad.visible = true;
					portraitMad.animation.play('enter');
				}		
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
