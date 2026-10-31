// Decompiled from Desktop\precompiled.rsblob by W3 Mod Workbench
// Compiled with REDkit build 1048625 (Release, x64)
// Comments, formatting and variable initialisers are not kept in compiled scripts.

class SU_Oneliner
{
	var tag : string;
	var id : int;
	var text : string;
	var visible : bool;
	var position : Vector;
	var offset : Vector;
	var render_distance : int;
	var is_registered : bool;
	private var cached_manager : SUOL_Manager;
	var opacity : float;
	var cached_screen_position : Vector;
	default id = -1;
	default visible = true;

	function getManager() : SUOL_Manager
	{
		if (!this.cached_manager)
		{
			this.cached_manager = SUOL_getManager();
		}
		return this.cached_manager;
	}

	function register()
	{
		this.getManager().createOneliner(this);
	}

	function unregister()
	{
		this.getManager().deleteOneliner(this);
	}

	function update()
	{
		this.getManager().updateOneliner(this);
	}

	function setRenderDistance(value : int) : SU_Oneliner
	{
		this.render_distance = value;
		return this;
	}

	function setText(value : string) : SU_Oneliner
	{
		this.text = value;
		return this;
	}

	function setOffset(value : Vector) : SU_Oneliner
	{
		this.offset = value;
		return this;
	}

	function setTag(value : string) : SU_Oneliner
	{
		this.tag = value;
		return this;
	}

	function setOpacity(value : float) : SU_Oneliner
	{
		if (value == this.opacity)
		{
			return this;
		}

		this.opacity = value;
		this.getManager().setOnelinerOpacity(this, value);
		return this;
	}

	function getVisible(player_position : Vector) : bool
	{
		if (this.render_distance <= 0)
		{
			return this.visible;
		}
		return VecDistanceSquared2D(player_position, this.getPosition()) <= this.render_distance * this.render_distance;
	}

	function getPosition() : Vector
	{
		return this.position + this.offset;
	}

	function getScreenPosition(hud : CR4ScriptedHud, out screen_position : Vector) : bool
	{
		var world_position : Vector;
		var result : bool;

		world_position = this.getPosition();

		result = SUOL_worldToScreenPosition(hud, world_position, screen_position, this.cached_screen_position);
		return result;
	}
}
