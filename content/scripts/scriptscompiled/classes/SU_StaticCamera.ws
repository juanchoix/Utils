// Decompiled from Desktop\precompiled.rsblob by W3 Mod Workbench
// Compiled with REDkit build 1048625 (Release, x64)
// Comments, formatting and variable initialisers are not kept in compiled scripts.

class SU_StaticCamera extends CStaticCamera
{
	function start()
	{
		this.Run();
	}

	function teleportAndLookAt(position : Vector, target : Vector)
	{
		var current_rotation : EulerAngles;

		current_rotation = VecToRotation(target - position);

		current_rotation.Pitch *= -1;

		this.TeleportWithRotation(position, current_rotation);
	}
}
