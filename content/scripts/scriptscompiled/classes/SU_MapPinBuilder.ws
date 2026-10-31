// Decompiled from Desktop\precompiled.rsblob by W3 Mod Workbench
// Compiled with REDkit build 1048625 (Release, x64)
// Comments, formatting and variable initialisers are not kept in compiled scripts.

class SU_MapPinBuilder
{
	private var pins_builder : SU_MapPinsBuilder;
	private var pin : SU_MapPin;

	function init() : SU_MapPinBuilder
	{
		this.pin = new SU_MapPin in thePlayer;
		return this.region(SUH_getCurrentRegion());
	}

	function consume_pins_builder(pins_builder : SU_MapPinsBuilder) : SU_MapPinBuilder
	{
		this.pins_builder = pins_builder;
		return this.init();
	}

	function tag(tag : string) : SU_MapPinBuilder
	{
		this.pin.tag = tag;
		return this;
	}

	function tag_prefix(prefix : string) : SU_MapPinBuilder
	{
		this.pin.tag = prefix + this.pin.tag;
		return this;
	}

	function is_quest(is_quest : bool) : SU_MapPinBuilder
	{
		this.pin.is_quest = is_quest;
		return this;
	}

	function position(position : Vector) : SU_MapPinBuilder
	{
		this.pin.position = position;
		return this;
	}

	function description(description : string) : SU_MapPinBuilder
	{
		this.pin.description = description;
		return this;
	}

	function label(label : string) : SU_MapPinBuilder
	{
		this.pin.label = label;
		return this;
	}

	function type(type : string) : SU_MapPinBuilder
	{
		this.pin.type = type;
		return this;
	}

	function filtered_type(filtered_type : string) : SU_MapPinBuilder
	{
		this.pin.filtered_type = filtered_type;
		return this;
	}

	function radius(radius : float) : SU_MapPinBuilder
	{
		this.pin.radius = radius;
		return this;
	}

	function region(region : string) : SU_MapPinBuilder
	{
		this.pin.region = region;
		return this;
	}

	function appears_on_minimap(appears_on_minimap : bool) : SU_MapPinBuilder
	{
		this.pin.appears_on_minimap = appears_on_minimap;
		return this;
	}

	function pointed_by_arrow(pointed_by_arrow : bool) : SU_MapPinBuilder
	{
		this.pin.pointed_by_arrow = pointed_by_arrow;
		return this;
	}

	function highlighted(highlighted : bool) : SU_MapPinBuilder
	{
		this.pin.highlighted = highlighted;
		return this;
	}

	function fast_travel(fast_travel : bool) : SU_MapPinBuilder
	{
		this.pin.is_fast_travel = fast_travel;
		return this;
	}

	function visible_between(from_hour : int, to_hour : int) : SU_MapPinBuilder
	{
		this.pin.visible_from_hour = from_hour;
		this.pin.visible_to_hour = to_hour;
		return this;
	}

	function add() : SU_MapPinsBuilder
	{
		return this.pins_builder.consume_pin_builder(this);
	}

	function build() : SU_MapPin
	{
		return this.pin;
	}
}
