package flixel.input.gamepad.mappings;

import flixel.input.gamepad.FlxGamepad.FlxGamepadAttachment;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.gamepad.id.MayopenflWiiRemoteID;

class MayopenflWiiRemoteMapping extends FlxGamepadMapping
{
	#if FLX_JOYSTICK_API
	static inline var REMOTE_DPAD_X:Int = 16;
	static inline var REMOTE_DPAD_Y:Int = 17;

	static inline var LEFT_ANALOG_STICK_FAKE_X:Int = 18;
	static inline var LEFT_ANALOG_STICK_FAKE_Y:Int = 19;
	static inline var RIGHT_ANALOG_STICK_FAKE_X:Int = 20;
	static inline var RIGHT_ANALOG_STICK_FAKE_Y:Int = 21;
	#end

	override function initValues():Void
	{
		// but you'll only get non-zero values for it when the Nunchuk is attached
		supportsPointer = true;
	}

	override public function getID(rawID:Int):FlxGamepadInputID
	{
		return switch (attachment)
		{
			case WII_CLASSIC_CONTROLLER: getIDClassicController(rawID);
			case WII_NUNCHUCK: getIDNunchuk(rawID);
			case NONE: getIDDefault(rawID);
		}
	}

	function getIDClassicController(rawID:Int):FlxGamepadInputID
	{
		return switch (rawID)
		{
			case MayopenflWiiRemoteID.CLASSIC_A: B;
			case MayopenflWiiRemoteID.CLASSIC_B: A;
			case MayopenflWiiRemoteID.CLASSIC_X: Y;
			case MayopenflWiiRemoteID.CLASSIC_Y: X;
			case MayopenflWiiRemoteID.CLASSIC_SELECT: BACK;
			case MayopenflWiiRemoteID.CLASSIC_HOME: GUIDE;
			case MayopenflWiiRemoteID.CLASSIC_START: START;
			case MayopenflWiiRemoteID.CLASSIC_L: LEFT_TRIGGER;
			case MayopenflWiiRemoteID.CLASSIC_R: RIGHT_TRIGGER;
			case MayopenflWiiRemoteID.CLASSIC_ZL: LEFT_SHOULDER;
			case MayopenflWiiRemoteID.CLASSIC_ZR: RIGHT_SHOULDER;
			case MayopenflWiiRemoteID.CLASSIC_DPAD_UP: DPAD_UP;
			case MayopenflWiiRemoteID.CLASSIC_DPAD_DOWN: DPAD_DOWN;
			case MayopenflWiiRemoteID.CLASSIC_DPAD_LEFT: DPAD_LEFT;
			case MayopenflWiiRemoteID.CLASSIC_DPAD_RIGHT: DPAD_RIGHT;
			case id if (id == leftStick.rawUp): LEFT_STICK_DIGITAL_UP;
			case id if (id == leftStick.rawDown): LEFT_STICK_DIGITAL_DOWN;
			case id if (id == leftStick.rawLeft): LEFT_STICK_DIGITAL_LEFT;
			case id if (id == leftStick.rawRight): LEFT_STICK_DIGITAL_RIGHT;
			case id if (id == rightStick.rawUp): RIGHT_STICK_DIGITAL_UP;
			case id if (id == rightStick.rawDown): RIGHT_STICK_DIGITAL_DOWN;
			case id if (id == rightStick.rawLeft): RIGHT_STICK_DIGITAL_LEFT;
			case id if (id == rightStick.rawRight): RIGHT_STICK_DIGITAL_RIGHT;
			case _: NONE;
		}
	}

	function getIDNunchuk(rawID:Int):FlxGamepadInputID
	{
		return switch (rawID)
		{
			case MayopenflWiiRemoteID.NUNCHUK_A: A;
			case MayopenflWiiRemoteID.NUNCHUK_B: B;
			case MayopenflWiiRemoteID.NUNCHUK_ONE: X;
			case MayopenflWiiRemoteID.NUNCHUK_TWO: Y;
			case MayopenflWiiRemoteID.NUNCHUK_MINUS: BACK;
			case MayopenflWiiRemoteID.NUNCHUK_PLUS: START;
			case MayopenflWiiRemoteID.NUNCHUK_HOME: GUIDE;
			case MayopenflWiiRemoteID.NUNCHUK_C: LEFT_SHOULDER;
			case MayopenflWiiRemoteID.NUNCHUK_Z: LEFT_TRIGGER;
			case MayopenflWiiRemoteID.NUNCHUK_DPAD_UP: DPAD_UP;
			case MayopenflWiiRemoteID.NUNCHUK_DPAD_DOWN: DPAD_DOWN;
			case MayopenflWiiRemoteID.NUNCHUK_DPAD_LEFT: DPAD_LEFT;
			case MayopenflWiiRemoteID.NUNCHUK_DPAD_RIGHT: DPAD_RIGHT;
			default:
				if (rawID == MayopenflWiiRemoteID.LEFT_ANALOG_STICK.rawUp) LEFT_STICK_DIGITAL_UP;
				if (rawID == MayopenflWiiRemoteID.LEFT_ANALOG_STICK.rawDown) LEFT_STICK_DIGITAL_DOWN;
				if (rawID == MayopenflWiiRemoteID.LEFT_ANALOG_STICK.rawLeft) LEFT_STICK_DIGITAL_LEFT;
				if (rawID == MayopenflWiiRemoteID.LEFT_ANALOG_STICK.rawRight) LEFT_STICK_DIGITAL_RIGHT;
				NONE;
		}
	}

	function getIDDefault(rawID:Int):FlxGamepadInputID
	{
		return switch (rawID)
		{
			case MayopenflWiiRemoteID.REMOTE_A: A;
			case MayopenflWiiRemoteID.REMOTE_B: B;
			case MayopenflWiiRemoteID.REMOTE_ONE: X;
			case MayopenflWiiRemoteID.REMOTE_TWO: Y;
			case MayopenflWiiRemoteID.REMOTE_MINUS: BACK;
			case MayopenflWiiRemoteID.REMOTE_HOME: GUIDE;
			case MayopenflWiiRemoteID.REMOTE_PLUS: START;
			case MayopenflWiiRemoteID.REMOTE_DPAD_UP: DPAD_UP;
			case MayopenflWiiRemoteID.REMOTE_DPAD_DOWN: DPAD_DOWN;
			case MayopenflWiiRemoteID.REMOTE_DPAD_LEFT: DPAD_LEFT;
			case MayopenflWiiRemoteID.REMOTE_DPAD_RIGHT: DPAD_RIGHT;
			default: NONE;
		}
	}

	override public function getRawID(ID:FlxGamepadInputID):Int
	{
		return switch (attachment)
		{
			case WII_CLASSIC_CONTROLLER: getRawClassicController(ID);
			case WII_NUNCHUCK: getRawNunchuk(ID);
			case NONE: getRawDefault(ID);
		}
	}

	function getRawClassicController(ID:FlxGamepadInputID):Int
	{
		return switch (ID)
		{
			case A: MayopenflWiiRemoteID.CLASSIC_B;
			case B: MayopenflWiiRemoteID.CLASSIC_A;
			case X: MayopenflWiiRemoteID.CLASSIC_Y;
			case Y: MayopenflWiiRemoteID.CLASSIC_X;
			case DPAD_UP: MayopenflWiiRemoteID.CLASSIC_DPAD_UP;
			case DPAD_DOWN: MayopenflWiiRemoteID.CLASSIC_DPAD_DOWN;
			case DPAD_LEFT: MayopenflWiiRemoteID.CLASSIC_DPAD_LEFT;
			case DPAD_RIGHT: MayopenflWiiRemoteID.CLASSIC_DPAD_RIGHT;
			case BACK: MayopenflWiiRemoteID.CLASSIC_SELECT;
			case GUIDE: MayopenflWiiRemoteID.CLASSIC_HOME;
			case START: MayopenflWiiRemoteID.CLASSIC_START;
			case LEFT_SHOULDER: MayopenflWiiRemoteID.CLASSIC_ZL;
			case RIGHT_SHOULDER: MayopenflWiiRemoteID.CLASSIC_ZR;
			case LEFT_TRIGGER: MayopenflWiiRemoteID.CLASSIC_L;
			case RIGHT_TRIGGER: MayopenflWiiRemoteID.CLASSIC_R;
			case EXTRA_0: MayopenflWiiRemoteID.CLASSIC_ONE;
			case EXTRA_1: MayopenflWiiRemoteID.CLASSIC_TWO;
			case LEFT_STICK_DIGITAL_UP: MayopenflWiiRemoteID.LEFT_ANALOG_STICK.rawUp;
			case LEFT_STICK_DIGITAL_DOWN: MayopenflWiiRemoteID.LEFT_ANALOG_STICK.rawDown;
			case LEFT_STICK_DIGITAL_LEFT: MayopenflWiiRemoteID.LEFT_ANALOG_STICK.rawLeft;
			case LEFT_STICK_DIGITAL_RIGHT: MayopenflWiiRemoteID.LEFT_ANALOG_STICK.rawRight;
			case RIGHT_STICK_DIGITAL_UP: MayopenflWiiRemoteID.RIGHT_ANALOG_STICK.rawUp;
			case RIGHT_STICK_DIGITAL_DOWN: MayopenflWiiRemoteID.RIGHT_ANALOG_STICK.rawDown;
			case RIGHT_STICK_DIGITAL_LEFT: MayopenflWiiRemoteID.RIGHT_ANALOG_STICK.rawLeft;
			case RIGHT_STICK_DIGITAL_RIGHT: MayopenflWiiRemoteID.RIGHT_ANALOG_STICK.rawRight;
			default: getRawDefault(ID);
		}
	}

	function getRawNunchuk(ID:FlxGamepadInputID):Int
	{
		return switch (ID)
		{
			case A: MayopenflWiiRemoteID.NUNCHUK_A;
			case B: MayopenflWiiRemoteID.NUNCHUK_B;
			case X: MayopenflWiiRemoteID.NUNCHUK_ONE;
			case Y: MayopenflWiiRemoteID.NUNCHUK_TWO;
			case BACK: MayopenflWiiRemoteID.NUNCHUK_MINUS;
			case START: MayopenflWiiRemoteID.NUNCHUK_PLUS;
			case GUIDE: MayopenflWiiRemoteID.NUNCHUK_HOME;
			case LEFT_SHOULDER: MayopenflWiiRemoteID.NUNCHUK_C;
			case LEFT_TRIGGER: MayopenflWiiRemoteID.NUNCHUK_Z;
			case DPAD_UP: MayopenflWiiRemoteID.NUNCHUK_DPAD_UP;
			case DPAD_DOWN: MayopenflWiiRemoteID.NUNCHUK_DPAD_DOWN;
			case DPAD_LEFT: MayopenflWiiRemoteID.NUNCHUK_DPAD_LEFT;
			case DPAD_RIGHT: MayopenflWiiRemoteID.NUNCHUK_DPAD_RIGHT;
			case POINTER_X: MayopenflWiiRemoteID.NUNCHUK_POINTER_X;
			case POINTER_Y: MayopenflWiiRemoteID.NUNCHUK_POINTER_Y;
			case LEFT_STICK_DIGITAL_UP: MayopenflWiiRemoteID.LEFT_ANALOG_STICK.rawUp;
			case LEFT_STICK_DIGITAL_DOWN: MayopenflWiiRemoteID.LEFT_ANALOG_STICK.rawDown;
			case LEFT_STICK_DIGITAL_LEFT: MayopenflWiiRemoteID.LEFT_ANALOG_STICK.rawLeft;
			case LEFT_STICK_DIGITAL_RIGHT: MayopenflWiiRemoteID.LEFT_ANALOG_STICK.rawRight;
			default: -1;
		}
	}

	function getRawDefault(ID:FlxGamepadInputID):Int
	{
		return switch (ID)
		{
			case A: MayopenflWiiRemoteID.REMOTE_A;
			case B: MayopenflWiiRemoteID.REMOTE_B;
			case X: MayopenflWiiRemoteID.REMOTE_ONE;
			case Y: MayopenflWiiRemoteID.REMOTE_TWO;
			case DPAD_UP: MayopenflWiiRemoteID.REMOTE_DPAD_UP;
			case DPAD_DOWN: MayopenflWiiRemoteID.REMOTE_DPAD_DOWN;
			case DPAD_LEFT: MayopenflWiiRemoteID.REMOTE_DPAD_LEFT;
			case DPAD_RIGHT: MayopenflWiiRemoteID.REMOTE_DPAD_RIGHT;
			case BACK: MayopenflWiiRemoteID.REMOTE_MINUS;
			case GUIDE: MayopenflWiiRemoteID.REMOTE_HOME;
			case START: MayopenflWiiRemoteID.REMOTE_PLUS;
			default: -1;
		}
	}

	#if FLX_JOYSTICK_API
	override public function axisIndexToRawID(axisID:Int):Int
	{
		if (attachment == WII_NUNCHUCK || attachment == WII_CLASSIC_CONTROLLER)
		{
			if (axisID == leftStick.x)
				return LEFT_ANALOG_STICK_FAKE_X;
			else if (axisID == rightStick.y)
				return LEFT_ANALOG_STICK_FAKE_Y;
		}
		else
		{
			if (axisID == leftStick.x)
				return REMOTE_DPAD_X;
			else if (axisID == rightStick.y)
				return REMOTE_DPAD_Y;
		}

		if (axisID == leftStick.x)
			return RIGHT_ANALOG_STICK_FAKE_X;
		else if (axisID == rightStick.y)
			return RIGHT_ANALOG_STICK_FAKE_Y;

		return axisID;
	}

	override public function checkForFakeAxis(ID:FlxGamepadInputID):Int
	{
		if (attachment == WII_NUNCHUCK)
		{
			if (ID == LEFT_TRIGGER)
				return MayopenflWiiRemoteID.NUNCHUK_Z;
		}
		else if (attachment == WII_CLASSIC_CONTROLLER)
		{
			if (ID == LEFT_TRIGGER)
				return LEFT_TRIGGER_FAKE;
			if (ID == RIGHT_TRIGGER)
				return RIGHT_TRIGGER_FAKE;
		}
		return -1;
	}
	#end

	override function set_attachment(attachment:FlxGamepadAttachment):FlxGamepadAttachment
	{
		leftStick = switch (attachment)
		{
			case WII_NUNCHUCK, WII_CLASSIC_CONTROLLER: MayopenflWiiRemoteID.LEFT_ANALOG_STICK;
			case NONE: MayopenflWiiRemoteID.REMOTE_DPAD;
		}

		rightStick = switch (attachment)
		{
			case WII_CLASSIC_CONTROLLER: MayopenflWiiRemoteID.RIGHT_ANALOG_STICK;
			default: null;
		}

		return super.set_attachment(attachment);
	}
	
	override function getInputLabel(id:FlxGamepadInputID)
	{
		var label = WiiRemoteMapping.getWiiInputLabel(id, attachment);
		if (label == null)
			return super.getInputLabel(id);
		
		return label;
	}
}
