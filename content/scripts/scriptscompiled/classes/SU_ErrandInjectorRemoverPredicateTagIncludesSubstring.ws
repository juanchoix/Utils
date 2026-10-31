// Decompiled from Desktop\precompiled.rsblob by W3 Mod Workbench
// Compiled with REDkit build 1048625 (Release, x64)
// Comments, formatting and variable initialisers are not kept in compiled scripts.

class SU_ErrandInjectorRemoverPredicateTagIncludesSubstring extends SU_PredicateInterfaceRemoveErrandInjector
{
	var substring : string;

	function predicate(injector : SU_ErrandInjector) : bool
	{
		return StrContains(injector.tag, this.substring);
	}
}
