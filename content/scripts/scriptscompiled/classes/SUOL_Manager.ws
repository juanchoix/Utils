// Decompiled from Desktop\precompiled.rsblob by W3 Mod Workbench
// Compiled with REDkit build 1048625 (Release, x64)
// Comments, formatting and variable initialisers are not kept in compiled scripts.

statemachine class SUOL_Manager
{
	private var oneliner_counter : int;
	protected var oneliners : array<SU_Oneliner>;
	protected var module_oneliners : CR4HudModuleOneliners;
	protected var module_flash : CScriptedFlashSprite;
	protected var module_hud : CR4ScriptedHud;
	private var fxCreateOnelinerSFF : CScriptedFlashFunction;
	private var fxRemoveOnelinerSFF : CScriptedFlashFunction;

	private function initialize()
	{
		this.module_hud = (CR4ScriptedHud)theGame.GetHud();
		this.module_oneliners = (CR4HudModuleOneliners)this.module_hud.GetHudModule("OnelinersModule");
		this.module_flash = this.module_oneliners.GetModuleFlash();

		this.fxCreateOnelinerSFF = this.module_flash.GetMemberFlashFunction("CreateOneliner");
		this.fxRemoveOnelinerSFF = this.module_flash.GetMemberFlashFunction("RemoveOneliner");
	}

	private function getNewId() : int
	{
		var id : int;

		id = Max(this.oneliner_counter, theGame.GetLocalTimeAsMilliseconds());
		this.oneliner_counter = id + 1;
		return id;
	}

	function createOneliner(oneliner : SU_Oneliner)
	{
		var should_initialize_and_render : bool;

		should_initialize_and_render = this.GetCurrentStateName() != 'Render';

		if (should_initialize_and_render)
		{
			this.initialize();
		}

		if (oneliner.id < 0)
		{
			oneliner.id = this.getNewId();
		}

		if (!oneliner.is_registered)
		{
			this.fxCreateOnelinerSFF.InvokeSelfTwoArgs(FlashArgInt(oneliner.id), FlashArgString(oneliner.text));

			this.oneliners.PushBack(oneliner);
			oneliner.is_registered = true;
		}

		if (should_initialize_and_render)
		{
			this.GotoState('Render');
		}
	}

	function updateOneliner(oneliner : SU_Oneliner)
	{
		this.module_flash.GetChildFlashSprite("mcOneliner" + oneliner.id).GetChildFlashTextField("textField").SetTextHtml(oneliner.text);
	}

	function setOnelinerOpacity(oneliner : SU_Oneliner, opacity : float)
	{
		var sprite : CScriptedFlashSprite;

		sprite = this.module_flash.GetChildFlashSprite("mcOneliner" + oneliner.id);

		if (sprite)
		{
			sprite.SetAlpha(opacity * 100.0);
		}
	}

	function deleteOneliner(oneliner : SU_Oneliner)
	{
		this.oneliners.Remove(oneliner);
		this.fxRemoveOnelinerSFF.InvokeSelfOneArg(FlashArgInt(oneliner.id));
		oneliner.is_registered = false;
	}

	function findByTag(tag : string) : array<SU_Oneliner>
	{
		var output : array<SU_Oneliner>;
		var i : int;

		for (i = 0; i < this.oneliners.Size(); i += 1)
		{
			if (this.oneliners[i].tag == tag)
			{
				output.PushBack(this.oneliners[i]);
			}
		}
		return output;
	}

	function findByTagPrefix(tag : string) : array<SU_Oneliner>
	{
		var output : array<SU_Oneliner>;
		var i : int;

		for (i = 0; i < this.oneliners.Size(); i += 1)
		{
			if (StrStartsWith(this.oneliners[i].tag, tag))
			{
				output.PushBack(this.oneliners[i]);
			}
		}
		return output;
	}

	function deleteByTag(tag : string) : array<SU_Oneliner>
	{
		var output : array<SU_Oneliner>;
		var i : int;

		output = this.findByTag(tag);
		for (i = 0; i < output.Size(); i += 1)
		{
			this.deleteOneliner(output[i]);
		}
		return output;
	}

	function deleteByTagPrefix(tag : string) : array<SU_Oneliner>
	{
		var output : array<SU_Oneliner>;
		var i : int;

		output = this.findByTagPrefix(tag);
		for (i = 0; i < output.Size(); i += 1)
		{
			this.deleteOneliner(output[i]);
		}
		return output;
	}

	function deleteAllOneliners()
	{
		while (this.oneliners.Size() > 0)
		{
			this.deleteOneliner(this.oneliners[this.oneliners.Size() - 1]);
		}
	}
}

state SUOL_Idle in SUOL_Manager
{
	event OnEnterState(previous_state_name : name)
	{
		super.OnEnterState(previous_state_name);
	}
}

state Render in SUOL_Manager
{
	event OnEnterState(previous_state_name : name)
	{
		super.OnEnterState(previous_state_name);
		SUOL_Logger("Entering state [Render]");

		this.Render_main();
	}

	entry function Render_main()
	{
		this.renderingLoop();

		parent.GotoState('SUOL_Idle');
	}

	latent function renderingLoop()
	{
		var sprite : CScriptedFlashSprite;
		var oneliner : SU_Oneliner;
		var oneliners_count : int;
		var i : int;
		var player_position : Vector;
		var screen_position : Vector;

		screen_position = thePlayer.GetWorldPosition();
		player_position = thePlayer.GetWorldPosition();
		while (true)
		{
			oneliners_count = parent.oneliners.Size();

			if (oneliners_count <= 0)
			{
				break;
			}

			player_position = thePlayer.GetWorldPosition();

			for (i = 0; i < oneliners_count; i += 1)
			{
				oneliner = parent.oneliners[i];
				sprite = parent.module_flash.GetChildFlashSprite("mcOneliner" + oneliner.id);

				if (!oneliner.getVisible(player_position))
				{
					sprite.SetVisible(false);
					continue;
				}

				if (oneliner.getScreenPosition(parent.module_hud, screen_position))
				{
					sprite.SetPosition(screen_position.X, screen_position.Y);
					sprite.SetVisible(true);
					continue;
				}

				sprite.SetVisible(false);
			}

			SleepOneFrame();
		}
	}
}
