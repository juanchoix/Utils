// Decompiled from Desktop\precompiled.rsblob by W3 Mod Workbench
// Compiled with REDkit build 1048625 (Release, x64)
// Comments, formatting and variable initialisers are not kept in compiled scripts.

class SU_MenuDescriptorInternal
{
	private var option_hover_listeners : array<SU_MenuDescriptor_OptionDescription>;
	private var menu_scope : string;
	private var message_fallback : string;

	final function enteredAt(menu : string)
	{
		this.menu_scope = menu;
		this.option_hover_listeners.Clear();
	}

	final function didEnterAt(menu : string) : bool
	{
		return this.menu_scope == menu;
	}

	final function onOptionHovered(menu : string, option : name) : string
	{
		var output : string;
		var dynamic : bool;
		var i : int;

		for (i = 0; i < this.option_hover_listeners.Size(); i += 1)
		{
			if (this.option_hover_listeners[i].option_id != option)
			{
				continue;
			}

			if (this.option_hover_listeners[i].description_loc_key != "")
			{
				output += GetLocStringByKey(this.option_hover_listeners[i].description_loc_key);
			}
			else
			{
				output += this.option_hover_listeners[i].description;
			}

			dynamic = dynamic || this.option_hover_listeners[i].dynamic_description;
		}

		if (dynamic)
		{
			output = this.dynamicDescription(menu, option, output);
		}

		return output;
	}

	final function onOptionValueChanged(menu : string, option : name) : string
	{
		var output : string;
		var i : int;

		for (i = 0; i < this.option_hover_listeners.Size(); i += 1)
		{
			if (this.option_hover_listeners[i].option_id != option)
			{
				continue;
			}

			if (!this.option_hover_listeners[i].dynamic_description)
			{
				continue;
			}

			if (this.option_hover_listeners[i].description_loc_key != "")
			{
				output += GetLocStringByKey(this.option_hover_listeners[i].description_loc_key);
				continue;
			}

			output += this.option_hover_listeners[i].description;
		}

		output = this.dynamicDescription(menu, option, output);
		return output;
	}

	final function getMessageFallback() : string
	{
		return this.message_fallback;
	}

	protected final function onHover(option_id : name, optional description : string, optional description_loc_key : string, optional dynamic_description : bool)
	{
		this.option_hover_listeners.PushBack(SU_MenuDescriptor_OptionDescription(option_id, description, description_loc_key, false));
	}

	protected final function onHoverDynamic(option_id : name, optional description : string, optional description_loc_key : string)
	{
		this.option_hover_listeners.PushBack(SU_MenuDescriptor_OptionDescription(option_id, description, description_loc_key, true));
	}

	protected final function withFallbackMessage(optional description : string, optional description_loc_key : string)
	{
		if (description_loc_key != "")
		{
			this.message_fallback = GetLocStringByKey(description_loc_key);
		}
		else
		{
			this.message_fallback = description;
		}
	}

	protected function dynamicDescription(menu : string, option : name, description : string) : string
	{
		return description;
	}
}
