// Decompiled from Desktop\precompiled.rsblob by W3 Mod Workbench
// Compiled with REDkit build 1048625 (Release, x64)
// Comments, formatting and variable initialisers are not kept in compiled scripts.

class SU_CustomPinRemoverPredicateTagStartsWith extends SU_PredicateInterfaceRemovePin
{
	var prefix : string;

	function predicate(pin : SU_MapPin) : bool
	{
		return StrContains(pin.tag, this.prefix);
	}

	function init(prefix : string) : SU_CustomPinRemoverPredicateTagStartsWith
	{
		this.prefix = prefix;
		return this;
	}
}
