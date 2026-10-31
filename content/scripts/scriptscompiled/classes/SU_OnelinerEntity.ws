// Decompiled from Desktop\precompiled.rsblob by W3 Mod Workbench
// Compiled with REDkit build 1048625 (Release, x64)
// Comments, formatting and variable initialisers are not kept in compiled scripts.

class SU_OnelinerEntity extends SU_Oneliner
{
	var entity : CEntity;

	function getPosition() : Vector
	{
		return this.entity.GetWorldPosition() + this.offset;
	}
}
