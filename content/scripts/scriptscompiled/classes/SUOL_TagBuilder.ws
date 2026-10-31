// Decompiled from Desktop\precompiled.rsblob by W3 Mod Workbench
// Compiled with REDkit build 1048625 (Release, x64)
// Comments, formatting and variable initialisers are not kept in compiled scripts.

class SUOL_TagBuilder
{
	private var buffer : string;
	private var self_closing : bool;
	private var _tag : string;
	default self_closing = true;

	function tag(value : string) : SUOL_TagBuilder
	{
		this._tag = value;
		this.buffer = "<" + value;
		return this;
	}

	function attr(key : string, value : string) : SUOL_TagBuilder
	{
		this.buffer += " ";
		this.buffer += key;
		this.buffer += "=\"";
		this.buffer += value;
		this.buffer += "\"";
		return this;
	}

	function text(value : string) : string
	{
		this.buffer += ">" + value;
		return this.buffer + "</" + this._tag + ">";
	}

	function close() : string
	{
		return this.buffer + " />";
	}
}
