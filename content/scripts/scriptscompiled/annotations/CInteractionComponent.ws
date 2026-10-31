// Decompiled from Desktop\precompiled.rsblob by W3 Mod Workbench
// Compiled with REDkit build 1048625 (Release, x64)
// Comments, formatting and variable initialisers are not kept in compiled scripts.

@wrapMethod(CInteractionComponent)
function OnInteraction(actionName : string, activator : CEntity)
{
	if (SU_NpcInteraction_runAllInteractionListeners(actionName, activator, this.GetEntity()))
	{
		return wrappedMethod(actionName, activator);
	}
	return false;
}
