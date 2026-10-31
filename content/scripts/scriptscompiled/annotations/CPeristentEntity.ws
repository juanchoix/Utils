// Decompiled from Desktop\precompiled.rsblob by W3 Mod Workbench
// Compiled with REDkit build 1048625 (Release, x64)
// Comments, formatting and variable initialisers are not kept in compiled scripts.

@addField(CPeristentEntity)
saved var onInteractionEventListeners : array<SU_InteractionEventListener>;

@addMethod(CPeristentEntity)
function addInteractionEventListener(event_listener : SU_InteractionEventListener)
{
	this.onInteractionEventListeners.PushBack(event_listener);
}
