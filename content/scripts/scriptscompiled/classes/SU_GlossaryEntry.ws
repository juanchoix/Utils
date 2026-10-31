// Decompiled from Desktop\precompiled.rsblob by W3 Mod Workbench
// Compiled with REDkit build 1048625 (Release, x64)
// Comments, formatting and variable initialisers are not kept in compiled scripts.

class SU_GlossaryEntry
{
	var entry_unique_id : name;
	var sort_index : int;
	var drop_down_label : string;
	var drop_down_tag : name;
	var title : string;
	var description : string;
	var icon_path : string;
	var is_quest : bool;
	var is_painting : bool;
	var is_new : bool;
	default sort_index = 2000;
	default icon_path = "icons/inventory/books/book_1.png";

	function getDescription() : string
	{
		return this.description;
	}

	function getTitle() : string
	{
		return this.title;
	}

	function getIsNew() : bool
	{
		return this.is_new;
	}
}
