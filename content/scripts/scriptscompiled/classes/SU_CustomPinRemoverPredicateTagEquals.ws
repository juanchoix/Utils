// Decompiled from Desktop\precompiled.rsblob by W3 Mod Workbench
// Compiled with REDkit build 1048625 (Release, x64)
// Comments, formatting and variable initialisers are not kept in compiled scripts.

class SU_CustomPinRemoverPredicateTagEquals extends SU_PredicateInterfaceRemovePin
{
	var tag : string;

	function predicate(pin : SU_MapPin) : bool
	{
		return pin.tag == this.tag;
	}

	function init(tag : string) : SU_CustomPinRemoverPredicateTagEquals
	{
		this.tag = tag;
		return this;
	}
}
