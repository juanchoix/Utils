// Decompiled from Desktop\precompiled.rsblob by W3 Mod Workbench
// Compiled with REDkit build 1048625 (Release, x64)
// Comments, formatting and variable initialisers are not kept in compiled scripts.

class SU_InteractivePoint extends W3MonsterClue
{
	default interactionAnim = PEA_None;

	event OnInteraction(actionName : string, activator : CEntity)
	{
		if (this.interactionAnim != PEA_None)
		{
			this.PlayInteractionAnimation();
		}
	}

	event OnFocusModeEnabled(enabled : bool)
	{
		if (enabled)
		{
			PlayEffect('remains_highlight');
		}
		else
		{
			StopEffect('remains_highlight');
		}
	}
}
