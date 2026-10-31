// Decompiled from Desktop\precompiled.rsblob by W3 Mod Workbench
// Compiled with REDkit build 1048625 (Release, x64)
// Comments, formatting and variable initialisers are not kept in compiled scripts.

class SU_ExampleHoverListener extends SU_DialogHoverListener
{
	function onHover(scene_choice : SSceneChoice, index : int)
	{
		theGame.GetGuiManager().ShowNotification("description = " + scene_choice.description + " index = " + index);
	}
}
