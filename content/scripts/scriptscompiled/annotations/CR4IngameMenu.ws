// Decompiled from Desktop\precompiled.rsblob by W3 Mod Workbench
// Compiled with REDkit build 1048625 (Release, x64)
// Comments, formatting and variable initialisers are not kept in compiled scripts.

@addField(CR4IngameMenu)
var su_menu_descriptors : array<SU_MenuDescriptor>;

@addField(CR4IngameMenu)
var su_menu_stack : array<string>;

@addField(CR4IngameMenu)
var su_menu_message_cache : string;

@addField(CR4IngameMenu)
var su_menu_message_fallback_cache : string;

@addField(CR4IngameMenu)
var su_menu_hovered_option : name;

@addField(CR4IngameMenu)
var su_menu_hovered_out_count : int;

@addMethod(CR4IngameMenu)
function SUMD_displayMessage(message : string)
{
	var duration : float;

	duration = -1;

	if (message == "")
	{
		if (this.su_menu_message_fallback_cache != "")
		{
			message = this.su_menu_message_fallback_cache;
		}
	}

	if (message == this.su_menu_message_cache)
	{
		return;
	}

	this.su_menu_message_cache = message;

	if (message == "")
	{
		duration = 0;
	}

	theGame.GetGuiManager().ShowNotification(message, duration);
}

@addMethod(CR4IngameMenu)
function SU_onMenuEntered(menu : string, out descriptors : array<SU_MenuDescriptor>);

@wrapMethod(CR4IngameMenu)
function OnShowOptionSubmenu(actionType : int, menuTag : int, id : string)
{
	var descriptor : SU_MenuDescriptor;
	var message_fallback : string;
	var previous_size : int;

	LogChannel('SUMD', "OnShowOptionSubmenu(), id=" + id);

	previous_size = this.su_menu_descriptors.Size();
	this.SU_onMenuEntered(id, this.su_menu_descriptors);

	for (previous_size; previous_size < this.su_menu_descriptors.Size(); previous_size += 1)
	{
		descriptor = this.su_menu_descriptors[previous_size];

		if (descriptor)
		{
			descriptor.enteredAt(id);
			descriptor.build();
		}
	}

	this.su_menu_stack.PushBack(id);

	for (previous_size = 0; previous_size < this.su_menu_descriptors.Size(); previous_size += 1)
	{
		descriptor = this.su_menu_descriptors[previous_size];

		if (descriptor)
		{
			message_fallback += descriptor.getMessageFallback();
		}
	}

	this.su_menu_message_fallback_cache = message_fallback;
	this.SUMD_displayMessage(message_fallback);
	return wrappedMethod(actionType, menuTag, id);
}

@wrapMethod(CR4IngameMenu)
function OnOptionPanelNavigateBack()
{
	var descriptor : SU_MenuDescriptor;
	var should_remove : bool;
	var menu_left : string;
	var i : int;

	this.su_menu_hovered_out_count = 0;
	this.su_menu_hovered_option = '';

	this.su_menu_message_fallback_cache = "";
	this.SUMD_displayMessage("");

	menu_left = this.su_menu_stack.PopBack();
	LogChannel('SUMD', "OnOptionPanelNavigateBack(), menu_left=" + menu_left);

	for (i = 0; i < this.su_menu_descriptors.Size(); i += 1)
	{
		descriptor = this.su_menu_descriptors[i];

		should_remove = true;
		if (descriptor)
		{
			should_remove = descriptor.didEnterAt(menu_left);
		}

		if (should_remove)
		{
			LogChannel('SUMD', "OnOptionPanelNavigateBack(), descriptor removed at index=" + i);
			this.su_menu_descriptors.Erase(i);
			i -= 1;
		}
	}
	return wrappedMethod();
}

@wrapMethod(CR4IngameMenu)
function OnOptionSelectionChanged(optionName : name, value : bool)
{
	var descriptor : SU_MenuDescriptor;
	var current_menu : string;
	var message : string;
	var result : bool;
	var i : int;

	result = wrappedMethod(optionName, value);

	if (!value)
	{
		if (optionName == this.su_menu_hovered_option || this.su_menu_hovered_out_count > 15)
		{
			this.SUMD_displayMessage("");
			return result;
		}

		this.su_menu_hovered_out_count += 1;

		optionName = this.su_menu_hovered_option;
		value = true;
	}
	else
	{
		this.su_menu_hovered_out_count = 0;
		this.su_menu_hovered_option = optionName;
	}

	LogChannel('SUMD', "OnOptionSelectionChanged(), optionName=" + optionName);

	current_menu = this.su_menu_stack.Last();
	for (i = 0; i < this.su_menu_descriptors.Size(); i += 1)
	{
		descriptor = this.su_menu_descriptors[i];

		message += descriptor.onOptionHovered(current_menu, optionName);
	}

	this.SUMD_displayMessage(message);
	return result;
}

@wrapMethod(CR4IngameMenu)
function OnOptionValueChanged(groupId : int, optionName : name, optionValue : string)
{
	var descriptor : SU_MenuDescriptor;
	var current_menu : string;
	var message : string;
	var result : bool;
	var i : int;

	result = wrappedMethod(groupId, optionName, optionValue);
	LogChannel('SUMD', "OnOptionValueChanged(), optionName=" + optionName);

	current_menu = this.su_menu_stack.Last();
	for (i = 0; i < this.su_menu_descriptors.Size(); i += 1)
	{
		descriptor = this.su_menu_descriptors[i];

		message += descriptor.onOptionValueChanged(current_menu, optionName);
	}

	if (message != "")
	{
		this.SUMD_displayMessage(message);
	}
	return result;
}
