// Decompiled from Desktop\precompiled.rsblob by W3 Mod Workbench
// Compiled with REDkit build 1048625 (Release, x64)
// Comments, formatting and variable initialisers are not kept in compiled scripts.

class SU_CustomPinRemoverPredicatePositionEquals extends SU_PredicateInterfaceRemovePin
{
	var position : Vector;

	function predicate(pin : SU_MapPin) : bool
	{
		return pin.position == this.position;
	}

	function init(position : Vector) : SU_CustomPinRemoverPredicatePositionEquals
	{
		this.position = position;
		return this;
	}
}
