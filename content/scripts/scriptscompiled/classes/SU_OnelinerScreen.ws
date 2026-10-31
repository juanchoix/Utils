// Decompiled from Desktop\precompiled.rsblob by W3 Mod Workbench
// Compiled with REDkit build 1048625 (Release, x64)
// Comments, formatting and variable initialisers are not kept in compiled scripts.

class SU_OnelinerScreen extends SU_Oneliner
{
	function getScreenPosition(hud : CR4ScriptedHud, out screen_position : Vector) : bool
	{
		var position : Vector;

		position = this.getPosition();
		screen_position = hud.GetScaleformPoint(position.X, position.Y);
		return true;
	}
}
