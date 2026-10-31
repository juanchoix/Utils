// Decompiled from Desktop\precompiled.rsblob by W3 Mod Workbench
// Compiled with REDkit build 1048625 (Release, x64)
// Comments, formatting and variable initialisers are not kept in compiled scripts.

class SU_MapPin
{
	var tag : string;
	var pin_tag : name;
	var is_quest : bool;
	var position : Vector;
	var description : string;
	var label : string;
	var type : string;
	var filtered_type : string;
	var is_fast_travel : bool;
	var radius : float;
	var region : string;
	var appears_on_minimap : bool;
	var pointed_by_arrow : bool;
	var highlighted : bool;
	var visible_from_hour : int;
	var visible_to_hour : int;
	default pin_tag = 'User';
	default is_quest = false;
	default type = "MonsterQuest";
	default filtered_type = "QuestReturn";
	default appears_on_minimap = false;
	default pointed_by_arrow = true;
	default highlighted = true;
	default visible_from_hour = -1;
	default visible_to_hour = -1;

	function init(_tag : string, _position : Vector, _description : string, _label : string, _type : string, _filtered_type : string, _radius : float, _region : string, _appears_on_minimap : bool, _pointed_by_arrow : bool, _highlighted : bool, _is_quest : bool) : SU_MapPin
	{
		this.tag = _tag;
		this.position = _position;
		this.description = _description;
		this.label = _label;
		this.type = _type;
		this.filtered_type = _filtered_type;
		this.radius = _radius;
		this.region = _region;
		this.appears_on_minimap = _appears_on_minimap;
		this.pointed_by_arrow = _pointed_by_arrow;
		this.highlighted = _highlighted;
		this.is_quest = _is_quest;
		return this;
	}

	function isVisibleAtHour(hour : int) : bool
	{
		if (this.visible_from_hour < 0 || this.visible_to_hour < 0 || this.visible_from_hour == this.visible_to_hour)
		{
			return true;
		}

		if (this.visible_from_hour < this.visible_to_hour)
		{
			return hour >= this.visible_from_hour && hour < this.visible_to_hour;
		}
		return hour >= this.visible_from_hour || hour < this.visible_to_hour;
	}

	function onPinUsed()
	{
		var destination : Vector;

		if (this.is_fast_travel)
		{
			destination = this.position;

			thePlayer.DebugTeleportToPin(destination.X, destination.Y);
		}
	}
}
