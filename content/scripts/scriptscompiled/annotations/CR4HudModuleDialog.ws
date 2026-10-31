// Decompiled from Desktop\precompiled.rsblob by W3 Mod Workbench
// Compiled with REDkit build 1048625 (Release, x64)
// Comments, formatting and variable initialisers are not kept in compiled scripts.

@addField(CR4HudModuleDialog)
var dialog_hover_listeners : array<SU_DialogHoverListener>;

@addField(CR4HudModuleDialog)
var lastAcceptedChoice : SSceneChoice;

@addField(CR4HudModuleDialog)
var isAcceptedChoiceAvailable : bool;

@addField(CR4HudModuleDialog)
var responseListener : SU_DialogChoiceResponseListener;

@wrapMethod(CR4HudModuleDialog)
function OnDialogOptionSelected(index : int)
{
	var result : bool;

	result = wrappedMethod(index);
	SU_triggerEventListeners(this, this.lastSetChoices[index], index);
	return result;
}

@wrapMethod(CR4HudModuleDialog)
function OnDialogOptionAccepted(index : int)
{
	var listener : SU_DialogChoiceResponseListener;
	var acceptedChoice : SSceneChoice;

	acceptedChoice = lastSetChoices[index];

	this.lastAcceptedChoice = acceptedChoice;
	this.isAcceptedChoiceAvailable = true;

	if (this.responseListener)
	{
		listener = this.responseListener;
		this.responseListener = NULL;

		listener.onResponse(acceptedChoice, this.lastSetChoices, this);
	}

	return wrappedMethod(index);
}
