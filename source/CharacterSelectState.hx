package;

import flixel.addons.transition.Transition;
import flixel.addons.transition.FlxTransitionableState;
import sys.io.File;
import lime.app.Application;
import haxe.Exception;
import Controls.Control;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.system.FlxSoundGroup;
import flixel.math.FlxPoint;
import openfl.geom.Point;
import flixel.*;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.math.FlxMath;
import flixel.util.FlxStringUtil;
import flixel.FlxSprite;
#if windows
import lime.app.Application;
import sys.FileSystem;
#end

 /**
	hey you fun commiting people, 
	i don't know about the rest of the mod but since this is basically 99% my code 
	i do not give you guys permission to grab this specific code and re-use it in your own mods without asking me first.
	the secondary dev, ben
*/

class CharacterInSelect
{
	public var name:String;
	public var noteMs:Array<Float>;
	public var forms:Array<CharacterForm>;

	public function new(name:String, noteMs:Array<Float>, forms:Array<CharacterForm>)
	{
		this.name = name;
		this.noteMs = noteMs;
		this.forms = forms;
	}
}
class CharacterForm
{
	public var name:String;
	public var polishedName:String;
	public var noteType:String;
	public var noteMs:Array<Float>;

	public function new(name:String, polishedName:String, noteMs:Array<Float>, noteType:String = 'normal')
	{
		this.name = name;
		this.polishedName = polishedName;
		this.noteType = noteType;
		this.noteMs = noteMs;
	}
}
class CharacterSelectState extends MusicBeatState
{
	public var char:Boyfriend;
	public var current:Int = 0;
	public var curForm:Int = 0;
	public var notemodtext:FlxText;
	public var characterText:FlxText;
	public var wasInFullscreen:Bool;
	
	public var funnyIconMan:HealthIcon;

	var strummies:FlxTypedGroup<FlxSprite>;

	var notestuffs:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];

	public var isDebug:Bool = false;

	public var PressedTheFunny:Bool = false;

	var selectedCharacter:Bool = false;

	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;
	private var camTransition:FlxCamera;

	var currentSelectedCharacter:CharacterInSelect;

	var noteMsTexts:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();

	var arrows:Array<FlxSprite> = [];
	var basePosition:FlxPoint;
	
	public var characters:Array<CharacterInSelect> = 
	[
		new CharacterInSelect('bf', [1, 1, 1, 1], [
			new CharacterForm('bf', 'Boyfriend', [1,1,1,1]),
			new CharacterForm('bf-pixel', 'Pixel Boyfriend', [1,1,1,1]),
			new CharacterForm('bf-3d', '3D Boyfriend', [1,1,1,1], '3D'),
		]),
		new CharacterInSelect('dave', [0.25, 0.25, 2, 2], [
			new CharacterForm('dave', 'Dave', [0.25, 0.25, 2, 2]),
			new CharacterForm('dave-2.5', 'Dave (2.5)', [0.25, 0.25, 2, 2]),
			new CharacterForm('dave-2.1', 'Dave (2.1)', [0.25, 0.25, 2, 2]),
			new CharacterForm('dave-2.0', 'Dave (2.0)', [0.25, 0.25, 2, 2]),
			new CharacterForm('dave-1.0', 'Dave (1.0)', [0.25, 0.25, 2, 2]),
			new CharacterForm('dave-alpha-4', 'Dave (Alpha 4)', [0.25, 0.25, 2, 2]),
			new CharacterForm('dave-alpha', 'Dave (Alpha)', [0.25, 0.25, 2, 2])
		]),
		new CharacterInSelect('dave-annoyed', [0.25, 0.25, 2, 2], [
			new CharacterForm('dave-annoyed', 'Insanity Dave', [0.25, 0.25, 2, 2]),
			new CharacterForm('dave-annoyed-2.5', 'Insanity Dave (2.5)', [0.25, 0.25, 2, 2]),
			new CharacterForm('dave-annoyed-2.1', 'Insanity Dave (2.1)', [0.25, 0.25, 2, 2]),
			new CharacterForm('dave-annoyed-2.0', 'Insanity Dave (2.0)', [0.25, 0.25, 2, 2])
		]),
		new CharacterInSelect('dave-splitathon', [0.25, 0.25, 2, 2], [
			new CharacterForm('dave-splitathon', 'Splitathon Dave', [0.25, 0.25, 2, 2]),
			new CharacterForm('dave-splitathon-2.5', 'Splitathon Dave (2.5)', [0.25, 0.25, 2, 2]),
			new CharacterForm('dave-splitathon-2.0', 'Splitathon Dave (2.0)', [0.25, 0.25, 2, 2]),
			new CharacterForm('dave-splitathon-1.0', 'Splitathon Dave (1.0)', [0.25, 0.25, 2, 2])
		]),
		new CharacterInSelect('old-dave cool', [0.25, 0.25, 2, 2], [
			new CharacterForm('old-dave-cool', 'Old Cool Dave', [0.25, 0.25, 2, 2]),
		]),
		new CharacterInSelect('dave-pre-alpha', [2, 0.25, 0.25, 2], [
			new CharacterForm('dave-pre-alpha', 'Dave Pre Alpha', [2, 0.25, 0.25, 2]),
			new CharacterForm('dave-pre-alpha-hd', 'Dave Pre Alpha HD', [2, 0.25, 0.25, 2]),
		]),
		new CharacterInSelect('bambi', [0, 0, 3, 0], [
			new CharacterForm('bambi-new', 'Bambi', [0, 0, 3, 0]),
			new CharacterForm('bambi-scrapped-3.0', 'Bambi (Scrapped 3.0)', [0, 0, 3, 0]),
			new CharacterForm('bambi-2.5', 'Bambi (2.5)', [0, 0, 3, 0]),
			new CharacterForm('bambi-2.0', 'Bambi (2.0)', [0, 0, 3, 0]),
			new CharacterForm('bambi-1.0', 'Bambi (1.0)', [0, 0, 3, 0]),
			new CharacterForm('bambi-beta-2', 'Bambi (Beta 2)', [0, 0, 3, 0])
		]),
		new CharacterInSelect('dan', [0, 0, 3, 0], [
			new CharacterForm('dan', 'Dan', [0, 0, 3, 0]),
		]),
		new CharacterInSelect('bambi-splitathon', [0, 0, 3, 0], [
			new CharacterForm('bambi-splitathon', 'Splitathon Bambi', [0, 0, 3, 0]),
			new CharacterForm('bambi-splitathon-2.5', 'Splitathon Bambi (2.5)', [0, 0, 3, 0]),
			new CharacterForm('bambi-splitathon-2.0', 'Splitathon Bambi (2.0)', [0, 0, 3, 0]),
			new CharacterForm('bambi-splitathon-1.0', 'Splitathon Bambi (1.0)', [0, 0, 3, 0]),
		]),
		new CharacterInSelect('bambi-angey', [0, 0, 3, 0], [
			new CharacterForm('bambi-angey', 'Bambi (Angey)', [0, 0, 3, 0]),
			new CharacterForm('bambi-angey-old', 'Old Bambi (Angey)', [0, 0, 3, 0]),
		]),
		new CharacterInSelect('bambi-mad', [0, 0, 3, 0], [
			new CharacterForm('bambi-mad', 'Bambi (Mad)', [0, 0, 3, 0]),
			new CharacterForm('bambi-angey-oldest', 'Old Bambi (Mad)', [0, 0, 3, 0])
		]),
		new CharacterInSelect('bambi-joke', [0, 0, 0, 3], [
			new CharacterForm('bambi-joke', 'Joke Bambi', [0, 0, 0, 3]),
			new CharacterForm('bambi-joke-mad', 'Joke Bambi Mad', [0, 0, 0, 3]),
			new CharacterForm('bambi-old', 'Old Joke Bambi', [0, 0, 0, 3])
		]),
		new CharacterInSelect('mr-bambi', [1, 1, 1, 1], [
			new CharacterForm('mr-bambi', 'Mr. Bambi', [1, 1, 1, 1]),
			new CharacterForm('mr-bambi-car', 'Mr. Bambi (Car)', [1, 1, 1, 1]),
			new CharacterForm('mr-bambi-christmas', 'Christmas Mr. Bambi', [1, 1, 1, 1]),
			new CharacterForm('mr-bambi-pixel', 'Pixel Mr. Bambi', [1, 1, 1, 1]),
			new CharacterForm('mr-bambi-v2', 'Mr. Bambi (V2)', [1, 1, 1, 1])
		]),
		new CharacterInSelect('tristan', [2, 0.5, 0.5, 0.5], [
			new CharacterForm('tristan', 'Tristan', [2, 0.5, 0.5, 0.5]),
			new CharacterForm('tristan-2.0', 'Tristan (2.0)', [2, 0.5, 0.5, 0.5]),
			new CharacterForm('tristan-beta', 'Tristan (beta 1)', [2, 0.5, 0.5, 0.5])
		]),
		new CharacterInSelect('tristan-golden', [0.25, 0.25, 0.25, 2], [
			new CharacterForm('tristan-golden', 'Golden Tristan', [0.25, 0.25, 0.25, 2]),
			new CharacterForm('tristan-golden-2.5', 'Golden Tristan (2.5)', [0.25, 0.25, 0.25, 2])
		]),
		new CharacterInSelect('dave-angey', [2, 2, 0.25, 0.25], [
			new CharacterForm('dave-angey', '3D Dave', [2, 2, 0.25, 0.25], '3D'),
			new CharacterForm('dave-angey-old', 'Old 3D Dave', [2, 2, 0.25, 0.25], '3D'),
			new CharacterForm('dave-insanity-3d', '3D Dave insanity', [2, 2, 0.25, 0.25], '3D'),
			new CharacterForm('dave-3d-standing-bruh-what', 'Dave WTF', [2, 2, 0.25, 0.25], '3D')
		]),
		new CharacterInSelect('furiosity-dave', [0.25, 2, 0.25, 2], [
			new CharacterForm('furiosity-dave', 'Furiosity Dave', [0.25, 2, 0.25, 2]),
			new CharacterForm('furiosity-dave-alpha-4', 'Furiosity Dave (Alpha 4)', [0.25, 2, 0.25, 2]),
		]),
		new CharacterInSelect('[Data_Expunged]', [0, 3, 0, 0], [
			new CharacterForm('bambi-3d', 'Expunged', [0, 3, 0, 0], '3D'),
			new CharacterForm('bambi-unfair', 'Expunged (Unfair From)', [0, 3, 0, 0], '3D'),
			new CharacterForm('expunged', 'Expunged (True Form)', [0, 3, 0, 0], '3D'),
			new CharacterForm('bambi-3d-scrapped', 'Expunged (Scrapped 3.0)', [0, 3, 0, 0], '3D'),
			new CharacterForm('bambi-3d-old', 'Old Expunged', [0, 3, 0, 0], '3D'),
			new CharacterForm('bambi-unfair-old', 'Old Expunged (Unfair From)', [0, 3, 0, 0], '3D'),
		]),
		new CharacterInSelect('cockey', [1, 1, 1, 1], [
			new CharacterForm('cockey', 'Cockey', [1, 1, 1, 1], '3D'),
			new CharacterForm('old-cockey', 'Old Cockey', [1, 1, 1, 1], '3D'),
			new CharacterForm('older-cockey', 'Oldest Cockey', [1, 1, 1, 1], '3D')
		]),
		new CharacterInSelect('pissey', [1, 1, 1, 1], [
			new CharacterForm('pissey', 'Pissey', [1, 1, 1, 1], '3D'),
			new CharacterForm('old-pissey', 'Old Pissey', [1, 1, 1, 1], '3D'),
		]),
		new CharacterInSelect('shartey', [1, 1, 1, 1], [
			new CharacterForm('shartey-playable', 'Shartey', [1, 1, 1, 1], '3D'),
		]),
		new CharacterInSelect('marcello-dave', [3, 3, 3, 3], [
			new CharacterForm('marcello-dave', 'Marcello Dave', [3, 3, 3, 3]),
		]),
		new CharacterInSelect('tb-funny-man', [0.5, 0.5, 2, 0.5], [
			new CharacterForm('tb-funny-man', 'TheBuilderXD', [0.5, 0.5, 2, 0.5]),
		]),
		new CharacterInSelect('long-nose-john', [1, 1, 1, 1], [
			new CharacterForm('longnosejohn', 'Long Nose John', [1, 1, 1, 1]),
		]),
		new CharacterInSelect('kapi', [1, 1, 1, 1], [
			new CharacterForm('kapi', 'Kapi', [1, 1, 1, 1]),
		]),
		new CharacterInSelect('question', [0, 0, 3, 0], [
			new CharacterForm('question-playable', 'Question Bambi', [0, 0, 3, 0]),
		]),
		new CharacterInSelect('shinx', [1, 1, 1, 1], [
			new CharacterForm('shinx', 'Shinx', [1, 1, 1, 1]),
		]),
		new CharacterInSelect('sprigatito', [1, 1, 1, 1], [
			new CharacterForm('sprigatito', 'Sprigatito', [1, 1, 1, 1]),
		]),
		new CharacterInSelect('xo', [1, 1, 1, 1], [		
			new CharacterForm('xo', 'XO', [1,1,1,1]),
		]),
		new CharacterInSelect('eevee', [1, 1, 1, 1], [		
			new CharacterForm('eevee', 'Eevee', [1,1,1,1]),
			new CharacterForm('eevee-shiny', 'Shiny Eevee', [1,1,1,1]),
		]),
		new CharacterInSelect('sticky', [1, 1, 1, 1], [
			new CharacterForm('sticky', 'StickyBM', [1,1,1,1]),
		]),
		new CharacterInSelect('tails', [1, 1, 1, 1], [
			new CharacterForm('tails', 'Tails', [1,1,1,1]),
		]),
		new CharacterInSelect('bf-chip', [1, 1, 1, 1], [
			new CharacterForm('bf-chip', 'ChipFlake', [1,1,1,1]),
		]),
		new CharacterInSelect('conner', [1, 1, 1, 1], [
			new CharacterForm('conner', 'Conner', [1,1,1,1]),
		]),
		new CharacterInSelect('kogre', [1, 1, 1, 1], [
			new CharacterForm('kogre', 'Kogre', [1,1,1,1]),
		]),
		new CharacterInSelect('hamu', [1, 1, 1, 1], [		
			new CharacterForm('hamu', 'Hamu', [1,1,1,1]),
		]),
		new CharacterInSelect('car', [1, 1, 1, 1], [
			new CharacterForm('car', 'Car (Garn47)', [1,1,1,1]),
		]),
		new CharacterInSelect('shaggy', [1, 1, 1, 1], [
			new CharacterForm('shaggy', 'Shaggy', [1, 1, 1, 1]),
			new CharacterForm('supershaggy', 'Shaggy (0.001%)', [1, 1, 1, 1]),
			new CharacterForm('godshaggy', 'Shaggy (0.002%)', [1, 1, 1, 1]),
			new CharacterForm('redshaggy', 'Red Shaggy', [1, 1, 1, 1]),
		]),
	];
	#if SHADERS_ENABLED
	var bgShader:Shaders.GlitchEffect;
	#end

	var legs:FlxSprite;

	public function new() 
	{
		super();
	}
	
	override public function create():Void 
	{
		unlockCharacter('shaggy');
		unlockCharacter('kogre');
		unlockCharacter('conner');
		unlockCharacter('bf-chip');
		unlockCharacter('tails');
		unlockCharacter('sticky');
		unlockCharacter('eevee');
		unlockCharacter('xo');
		unlockCharacter('hamu');
		unlockCharacter('bf-3d');
		unlockCharacter('sprigatito');
		unlockCharacter('eevee-shiny');
		unlockCharacter('shinx');
		unlockCharacter('question');
		unlockCharacter('question-playable');
		unlockCharacter('car');
		if (PlayState.SONG.song.toLowerCase() == 'exploitation' && !FlxG.save.data.modchart)
		{
			if (FlxG.fullscreen)
			{
				FlxG.fullscreen = false;
				wasInFullscreen = true;
			}
		}

		Conductor.changeBPM(110);

		camGame = new FlxCamera();
		camTransition = new FlxCamera();
		camTransition.bgColor.alpha = 0;
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(camTransition);
		FlxCamera.defaultCameras = [camGame];
		
		FlxG.camera.zoom = 1.2;
		camHUD.zoom = 0.75;

		if (FlxG.save.data.charactersUnlocked == null)
		{
			reset();
		}
		currentSelectedCharacter = characters[current];

		if (PlayState.SONG.song.toLowerCase() == "exploitation")
			FlxG.sound.playMusic(Paths.music("badEnding"), 1, true);
		else
			FlxG.sound.playMusic(Paths.music("goodEnding"), 1, true);

		//create BG

		var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('backgrounds/shared/sky_night'));
		bg.antialiasing = true;
		bg.scrollFactor.set(0.75, 0.75);
		bg.active = false;
		
		if (PlayState.SONG.song.toLowerCase() == "exploitation")
		{
			bg.loadGraphic(Paths.image('backgrounds/void/redsky', 'shared'));
			
			if(FlxG.save.data.waving){
				#if SHADERS_ENABLED
				bgShader = new Shaders.GlitchEffect();
				bgShader.waveAmplitude = 0.1;
				bgShader.waveFrequency = 5;
				bgShader.waveSpeed = 2;
			
				bg.shader = bgShader.shader;
				#end
			}
		}
		add(bg);

		var hills:BGSprite = new BGSprite('hills', -133, 52, Paths.image('backgrounds/charSelect/hills'), null, 1, 1);
		add(hills);

		var house:BGSprite = new BGSprite('house', 385, 78, Paths.image('backgrounds/charSelect/house'), null, 1, 1);
		add(house);

		var behindGrass:BGSprite = new BGSprite('behindGrass', -33, 468, Paths.image('backgrounds/charSelect/behindGrass'), null, 1, 1);
		add(behindGrass);

		var gateLeft:BGSprite = new BGSprite('gateLeft', -38, 464, Paths.image('backgrounds/charSelect/gateLeft'), null, 1, 1);
		add(gateLeft);

		var gateRight:BGSprite = new BGSprite('gateRight', 1014, 464, Paths.image('backgrounds/charSelect/gateRight'), null, 1, 1);
		add(gateRight);
		
		var grass:BGSprite = new BGSprite('grass', -80, 385, Paths.image('backgrounds/charSelect/grass'), null, 1, 1);
		add(grass);
		
		var frontGrass:BGSprite = new BGSprite('frontGrass', -185, 382, Paths.image('backgrounds/charSelect/frontGrass'), null, 1, 1);
		add(frontGrass);
		
		var varientColor = 0xFF878787;
		
		frontGrass.color = varientColor;
		hills.color = varientColor;
		house.color = varientColor;
		behindGrass.color = varientColor;
		gateLeft.color = varientColor;
		gateRight.color = varientColor;
		grass.color = varientColor;

		char = new Boyfriend(FlxG.width / 2, FlxG.height / 2, 'bf');
		char.cameras = [camHUD];
		char.screenCenter();

		legs = new FlxSprite(630, 330);
		legs.cameras = [camHUD];
		legs.frames = Paths.getSparrowAtlas('characters/shaggy_god', 'shared');
		legs.animation.addByPrefix('legs', "solo_legs", 30);
		legs.animation.play('legs');
		legs.antialiasing = true;
		legs.flipX = true;
		legs.updateHitbox();
		legs.offset.set(legs.frameWidth / 2, 10);
		legs.alpha = 0;

		add(legs);
		add(char);

		basePosition = char.getPosition();

		strummies = new FlxTypedGroup<FlxSprite>();
		strummies.cameras = [camHUD];
		
		add(strummies);
		generateStaticArrows(false);
		
		notemodtext = new FlxText((FlxG.width / 3.5) + 80, FlxG.height, 0, "1.00x       1.00x        1.00x       1.00x", 30);
		notemodtext.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		notemodtext.scrollFactor.set();
		notemodtext.alpha = 0;
		notemodtext.y -= 10;
		FlxTween.tween(notemodtext, {y: notemodtext.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * 0)});
		notemodtext.cameras = [camHUD];
		add(notemodtext);
		
		characterText = new FlxText((FlxG.width / 9) - 50, (FlxG.height / 8) - 225, "Boyfriend");
		characterText.font = 'Comic Sans MS Bold';
		characterText.setFormat(Paths.font("comic.ttf"), 90, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		characterText.autoSize = false;
		characterText.fieldWidth = 1080;
		characterText.borderSize = 5;
		characterText.screenCenter(X);
		characterText.cameras = [camHUD];
		characterText.antialiasing = true;
		characterText.y = FlxG.height - 180;
		add(characterText);
		
		var resetText = new FlxText(FlxG.width, FlxG.height, LanguageManager.getTextString('character_reset'));
		resetText.setFormat(Paths.font("comic.ttf"), 30, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		resetText.autoSize = false;
		resetText.fieldWidth = FlxG.height;
		resetText.x -= resetText.textField.textWidth;
		resetText.y -= resetText.textField.textHeight - 100;
		resetText.borderSize = 3;
		resetText.cameras = [camHUD];
		resetText.antialiasing = true;
		resetText.visible = false;
		add(resetText);

		funnyIconMan = new HealthIcon('bf', true);
		funnyIconMan.cameras = [camHUD];
		funnyIconMan.visible = false;
		funnyIconMan.antialiasing = true;
		updateIconPosition();
		add(funnyIconMan);

		var tutorialThing:FlxSprite = new FlxSprite(-110, -30).loadGraphic(Paths.image('ui/charSelectGuide'));
		tutorialThing.setGraphicSize(Std.int(tutorialThing.width * 1.5));
		tutorialThing.antialiasing = true;
		tutorialThing.cameras = [camHUD];
		add(tutorialThing);

		var arrowLeft:FlxSprite = new FlxSprite(10,0).loadGraphic(Paths.image("ui/ArrowLeft_Idle", "preload"));
		arrowLeft.screenCenter(Y);
		arrowLeft.antialiasing = true;
		arrowLeft.scrollFactor.set();
		arrowLeft.cameras = [camHUD];
		arrows[0] = arrowLeft;
		add(arrowLeft);

		var arrowRight:FlxSprite = new FlxSprite(-5,0).loadGraphic(Paths.image("ui/ArrowRight_Idle", "preload"));
		arrowRight.screenCenter(Y);
		arrowRight.antialiasing = true;
		arrowRight.x = 1280 - arrowRight.width - 5;
		arrowRight.scrollFactor.set();
		arrowRight.cameras = [camHUD];
		arrows[1] = arrowRight;
		add(arrowRight);

		super.create();
	}

	private function generateStaticArrows(noteType:String = 'normal', regenerated:Bool):Void
	{
		if (regenerated)
		{
			if (strummies.length > 0)
			{
				strummies.forEach(function(babyArrow:FlxSprite)
				{
					remove(babyArrow);
					strummies.remove(babyArrow);
				});
			}
		}
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, FlxG.height - 40);

			var noteAsset:String = 'notes/NOTE_assets';
			switch (noteType)
			{
				case '3D':
					noteAsset = 'notes/NOTE_assets_3D';
			}

			babyArrow.frames = Paths.getSparrowAtlas(noteAsset);
			babyArrow.animation.addByPrefix('green', 'arrowUP0');
			babyArrow.animation.addByPrefix('blue', 'arrowDOWN0');
			babyArrow.animation.addByPrefix('purple', 'arrowLEFT0');
			babyArrow.animation.addByPrefix('red', 'arrowRIGHT0');

			babyArrow.antialiasing = true;
			babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

			babyArrow.x += 160 * 0.7 * i;
			switch (Math.abs(i))
			{
				case 0:
					babyArrow.animation.addByPrefix('static', 'arrowLEFT0');
					babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
					babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
				case 1:
					babyArrow.animation.addByPrefix('static', 'arrowDOWN0');
					babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
					babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
				case 2:
					babyArrow.animation.addByPrefix('static', 'arrowUP0');
					babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
					babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
				case 3:
					babyArrow.animation.addByPrefix('static', 'arrowRIGHT0');
					babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
					babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
			}
			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();
			babyArrow.ID = i;
	
			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 3.5));
			babyArrow.y -= 10;
			babyArrow.alpha = 0;

			var baseDelay:Float = regenerated ? 0 : 0.5;
			FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: baseDelay + (0.2 * i)});
			babyArrow.cameras = [camHUD];
			strummies.add(babyArrow);
		}
	}
	override public function update(elapsed:Float):Void
	{
		if(FlxG.save.data.waving){
			#if SHADERS_ENABLED
			if (bgShader != null)
			{
				bgShader.shader.uTime.value[0] += elapsed;
			}
			#end
	    }
		Conductor.songPosition = FlxG.sound.music.time;
		
		var controlSet:Array<Bool> = [controls.LEFT_P, controls.DOWN_P, controls.UP_P, controls.RIGHT_P];

		super.update(elapsed);

		legs.alpha = char.animation.name == 'idle' && char.curCharacter == 'godshaggy' ? 1 : 0;

		if (FlxG.keys.justPressed.ESCAPE)
		{
			if (wasInFullscreen)
			{
				FlxG.fullscreen = true;
			}
			LoadingState.loadAndSwitchState(new FreeplayState());
		}

		for (i in 0...controlSet.length)
		{
			if (controlSet[i] && !PressedTheFunny)
			{
				switch (i)
				{
					case 0:
						char.playAnim(char.nativelyPlayable ? 'singLEFT' : 'singRIGHT', true);
					case 1:
						char.playAnim('singDOWN', true);
					case 2:
						char.playAnim('singUP', true);
					case 3:
						char.playAnim(char.nativelyPlayable ? 'singRIGHT' : 'singLEFT', true);
				}
			}
		}
		if (controls.ACCEPT)
		{
			if (isLocked(characters[current].forms[curForm].name) && !(char.curCharacter == 'godshaggy' && PlayState.SONG.song.toLowerCase() == "exploitation"))
			{
				FlxG.camera.shake(0.05, 0.1);
				FlxG.sound.play(Paths.sound('badnoise1'), 0.9);
				return;
			}
			if (PressedTheFunny)
			{
				return;
			}
			else
			{
				PressedTheFunny = true;
			}
			selectedCharacter = true;
			var heyAnimation:Bool = char.animation.getByName("hey") != null; 
			char.playAnim(heyAnimation ? 'hey' : 'singUP', true);
			FlxG.sound.music.fadeOut(1.9, 0);
			FlxG.sound.play(Paths.sound('confirmMenu', 'preload'));
			new FlxTimer().start(1.9, endIt);
		}
		if (FlxG.keys.justPressed.LEFT && !selectedCharacter)
		{
			curForm = 0;
			current--;
			if (current < 0)
			{
				current = characters.length - 1;
			}
			UpdateBF();
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
			arrows[0].loadGraphic(Paths.image("ui/ArrowLeft_Pressed", "preload"));
		}

		if (FlxG.keys.justPressed.RIGHT && !selectedCharacter)
		{
			curForm = 0;
			current++;
			if (current > characters.length - 1)
			{
				current = 0;
			}
			UpdateBF();
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
			arrows[1].loadGraphic(Paths.image("ui/ArrowRight_Pressed", "preload"));
		}
		
		if (FlxG.keys.justReleased.LEFT)
			arrows[0].loadGraphic(Paths.image("ui/ArrowLeft_Idle", "preload"));
		if (FlxG.keys.justReleased.RIGHT)
			arrows[1].loadGraphic(Paths.image("ui/ArrowRight_Idle", "preload"));

		if (FlxG.keys.justPressed.DOWN && !selectedCharacter)
		{
			curForm--;
			if (curForm < 0)
			{
				curForm = characters[current].forms.length - 1;
			}
			UpdateBF();
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}
		if (FlxG.keys.justPressed.UP && !selectedCharacter)
		{
			curForm++;
			if (curForm > characters[current].forms.length - 1)
			{
				curForm = 0;
			}
			UpdateBF();
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}
		#if debug
		if (FlxG.keys.justPressed.R && !selectedCharacter)
		{
			reset();
			FlxG.resetState();
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			for (character in characters)
			{
				for (form in character.forms)
				{
					unlockCharacter(form.name); // unlock everyone
				}
			}
		}
		#end
	}
	public static function unlockCharacter(character:String)
	{
		if (!FlxG.save.data.charactersUnlocked.contains(character))
		{
			FlxG.save.data.charactersUnlocked.push(character);
			FlxG.save.flush();
		}
	}
	public static function isLocked(character:String):Bool
	{
		return !FlxG.save.data.charactersUnlocked.contains(character);
	}
	public static function reset()
	{
		FlxG.save.data.charactersUnlocked = new Array<String>();
		unlockCharacter('bf');
		unlockCharacter('bf-pixel');
		unlockCharacter('bf-3d');
		FlxG.save.flush();
	}

	public function UpdateBF()
	{
		var newSelectedCharacter = characters[current];
		if (currentSelectedCharacter.forms[curForm].noteType != newSelectedCharacter.forms[curForm].noteType)
		{
			generateStaticArrows(newSelectedCharacter.forms[curForm].noteType, true);
		}
		
		currentSelectedCharacter = newSelectedCharacter;
		characterText.text = currentSelectedCharacter.forms[curForm].polishedName;
		char.destroy();
		char = new Boyfriend(basePosition.x, basePosition.y, currentSelectedCharacter.forms[curForm].name);
		char.cameras = [camHUD];

		char.x += char.globalOffset[0];
		char.y += char.globalOffset[1];
		
		switch (char.curCharacter)
		{
			case 'bambi-new':
				char.x -= 30;
			case 'bambi-3d':
				char.x -= 150;
				char.y += 100;
			case 'shaggy' | 'supershaggy' | 'redshaggy' | 'godshaggy':
				char.x += 30;
				char.y += 130;
		}
		
		if (char.curCharacter == 'godshaggy') {
		}

		insert(members.indexOf(strummies), char);
		funnyIconMan.changeIcon(char.curCharacter);
		funnyIconMan.color = FlxColor.WHITE;
		if (isLocked(characters[current].forms[curForm].name) && !(char.curCharacter == 'godshaggy' && PlayState.SONG.song.toLowerCase() == "exploitation"))
		{
			char.color = FlxColor.BLACK;
			funnyIconMan.color = FlxColor.BLACK;
			characterText.text = '???';
		}
		legs.color = char.color;
		characterText.screenCenter(X);
		updateIconPosition();
		notemodtext.text = FlxStringUtil.formatMoney(currentSelectedCharacter.forms[curForm].noteMs[0]) + "x       " + FlxStringUtil.formatMoney(currentSelectedCharacter.forms[curForm].noteMs[3]) + "x        " + FlxStringUtil.formatMoney(currentSelectedCharacter.forms[curForm].noteMs[2]) + "x       " + FlxStringUtil.formatMoney(currentSelectedCharacter.forms[curForm].noteMs[1]) + "x";
	}

	override function beatHit()
	{
		super.beatHit();
		if (char != null && !selectedCharacter && curBeat % 2 == 0)
		{
			char.dance();
		}
	}
	function updateIconPosition()
	{
		//var xValues = CoolUtil.getMinAndMax(funnyIconMan.width, characterText.width);
		var yValues = CoolUtil.getMinAndMax(funnyIconMan.height, characterText.height);
		
		funnyIconMan.x = characterText.x + characterText.width / 2;
		funnyIconMan.y = characterText.y + ((yValues[0] - yValues[1]) / 2);
	}
	
	public function endIt(e:FlxTimer = null)
	{
		PlayState.characteroverride = currentSelectedCharacter.name;
		PlayState.formoverride = currentSelectedCharacter.forms[curForm].name;
		PlayState.curmult = currentSelectedCharacter.forms[curForm].noteMs;

		if (PlayState.SONG.song.toLowerCase() == "exploitation" && !FlxG.save.data.modchart)
		{
			FlxG.fullscreen = false;
			FlxG.sound.play(Paths.sound('error'), 0.9);

			PlatformUtil.sendFakeMsgBox("Null Object Reference");
		}
		if (FlxTransitionableState.skipNextTransIn)
		{
			//nope
		}
		FlxG.sound.music.stop();
		LoadingState.loadAndSwitchState(new PlayState());
	}
}
