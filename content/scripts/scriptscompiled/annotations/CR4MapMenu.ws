// Decompiled from Desktop\precompiled.rsblob by W3 Mod Workbench
// Compiled with REDkit build 1048625 (Release, x64)
// Comments, formatting and variable initialisers are not kept in compiled scripts.

@wrapMethod(CR4MapMenu)
function UpdateUserMapPins(out flashArray : CScriptedFlashArray, indexToUpdate : int)
{
	wrappedMethod(flashArray, indexToUpdate);

	if (indexToUpdate <= -1)
	{
		SU_updateCustomMapPins(flashArray, GetMenuFlashValueStorage(), m_shownArea);
	}
}

@wrapMethod(CR4MapMenu)
function OnStaticMapPinUsed(pinTag : name, areaId : int)
{
	if (SUMP_onPinUsed(pinTag, areaId))
	{
		return true;
	}
	return wrappedMethod(pinTag, areaId);
}
