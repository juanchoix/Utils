// Decompiled from Desktop\precompiled.rsblob by W3 Mod Workbench
// Compiled with REDkit build 1048625 (Release, x64)
// Comments, formatting and variable initialisers are not kept in compiled scripts.

@addField(CR4Player)
var sharedutils_glossary : SU_GlossaryManager;

@addField(CR4Player)
var sharedutils_mappins : SUMP_Manager;

@addField(CR4Player)
var sharedutilsNpcInteractionGlobalEventListener : SU_NpcInteraction_GlobalEventHandler;

@addMethod(CR4Player)
function getSharedutilsGlossaryManager() : SU_GlossaryManager
{
	if (!this.sharedutils_glossary)
	{
		this.sharedutils_glossary = new SU_GlossaryManager in this;
	}
	return this.sharedutils_glossary;
}

@addMethod(CR4Player)
function getSharedutilsMappinsManager() : SUMP_Manager
{
	if (!this.sharedutils_mappins)
	{
		SUMP_Logger("SUMP_getManager(), received null, instantiating instance");
		this.sharedutils_mappins = new SUMP_Manager in this;
	}

	return this.sharedutils_mappins;
}

@addMethod(CR4Player)
function SU_NpcInteraction_getGlobalEventListener() : SU_NpcInteraction_GlobalEventHandler
{
	if (!this.sharedutilsNpcInteractionGlobalEventListener)
	{
		this.sharedutilsNpcInteractionGlobalEventListener = (new SU_NpcInteraction_GlobalEventHandler in this).init();
	}

	return this.sharedutilsNpcInteractionGlobalEventListener;
}
