// Decompiled from Desktop\precompiled.rsblob by W3 Mod Workbench
// Compiled with REDkit build 1048625 (Release, x64)
// Comments, formatting and variable initialisers are not kept in compiled scripts.

class SU_StoreIfInteractedWith extends SU_InteractionEventListener
{
	var was_activated : bool;
	default tag = SU_StoreIfInteractedWith;

	function run(actionName : string, activator : CEntity, receptor : CPeristentEntity) : bool
	{
		this.was_activated = true;

		SU_removeInteractionEventListenerByTag(receptor, this.tag);
		return true;
	}

	latent function waitUntilActivated()
	{
		while (!this.was_activated)
		{
			SleepOneFrame();
		}
	}
}
