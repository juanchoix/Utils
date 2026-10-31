// Decompiled from Desktop\precompiled.rsblob by W3 Mod Workbench
// Compiled with REDkit build 1048625 (Release, x64)
// Comments, formatting and variable initialisers are not kept in compiled scripts.

@addField(CR4GlossaryBooksMenu)
var sharedutils_glossary_can_inject : bool;

@wrapMethod(CR4GlossaryBooksMenu)
function PopulateData()
{
	this.sharedutils_glossary_can_inject = true;
	wrappedMethod();
}

@wrapMethod(CR4GlossaryBooksMenu)
function PopulateListData(booksList : array<name>, out flashDataList : CScriptedFlashArray)
{
	wrappedMethod(booksList, flashDataList);

	if (this.sharedutils_glossary_can_inject)
	{
		SUG_populateListData(flashDataList, this.m_flashValueStorage);
		this.sharedutils_glossary_can_inject = false;
	}
}
