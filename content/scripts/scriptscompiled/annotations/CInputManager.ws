// Decompiled from Desktop\precompiled.rsblob by W3 Mod Workbench
// Compiled with REDkit build 1048625 (Release, x64)
// Comments, formatting and variable initialisers are not kept in compiled scripts.

@addField(CInputManager)
var sharedutils_oneliners : SUOL_Manager;

@addMethod(CInputManager)
function getSharedutilsOnelinersManager() : SUOL_Manager
{
	if (!this.sharedutils_oneliners)
	{
		SUOL_Logger("SUOL_getManager(), received null, instantiating instance");

		this.sharedutils_oneliners = new SUOL_Manager in this;
	}

	return this.sharedutils_oneliners;
}

@addMethod(CInputManager)
function newSharedutilsOnelinersManager()
{
	if (this.sharedutils_oneliners)
	{
		this.sharedutils_oneliners.deleteAllOneliners();
	}

	this.sharedutils_oneliners = new SUOL_Manager in this;
}
