// Decompiled from Desktop\precompiled.rsblob by W3 Mod Workbench
// Compiled with REDkit build 1048625 (Release, x64)
// Comments, formatting and variable initialisers are not kept in compiled scripts.

class SU_MapPinsBuilder
{
	private var tag_prefix : string;
	private var tag : string;
	private var pins : array<SU_MapPin>;

	function tag_prefix(prefix : string) : SU_MapPinsBuilder
	{
		this.tag_prefix = prefix;
		return this;
	}

	function tag(tag : string) : SU_MapPinsBuilder
	{
		this.tag = tag;
		return this;
	}

	function pin() : SU_MapPinBuilder
	{
		if (this.tag != "")
		{
			return (new SU_MapPinBuilder in this).consume_pins_builder(this).tag(this.tag);
		}
		return (new SU_MapPinBuilder in this).consume_pins_builder(this);
	}

	function consume_pin_builder(builder : SU_MapPinBuilder) : SU_MapPinsBuilder
	{
		this.pins.PushBack(builder.tag_prefix(this.tag_prefix).build());
		return this;
	}

	function build()
	{
		var i : int;

		if (this.tag_prefix != "")
		{
			SU_removeCustomPinByTagPrefix(this.tag_prefix);
		}

		if (this.tag != "")
		{
			SU_removeCustomPinByTag(this.tag);
		}

		for (i = 0; i < this.pins.Size(); i += 1)
		{
			SULOG("Adding pin, " + this.pins[i].tag + " - " + VecToString(this.pins[i].position));

			SUMP_addCustomPin(this.pins[i]);
		}

		SU_updateMinimapPins();
	}
}
