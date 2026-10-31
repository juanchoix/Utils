// Decompiled from Desktop\precompiled.rsblob by W3 Mod Workbench
// Compiled with REDkit build 1048625 (Release, x64)
// Comments, formatting and variable initialisers are not kept in compiled scripts.

class RandomNumberGenerator
{
	var previous_number : float;
	var seed : int;
	var use_seed : bool;
	default use_seed = true;

	function setSeed(seed : int) : RandomNumberGenerator
	{
		this.seed = seed;
		this.previous_number = 0;
		return this;
	}

	function useSeed(uses : bool) : RandomNumberGenerator
	{
		this.use_seed = uses;
		return this;
	}

	function next() : float
	{
		var number : float;

		if (!this.use_seed)
		{
			return RandF();
		}

		number = RandNoiseF(this.seed + (int)(this.previous_number * 10000000), 1);

		this.previous_number = number;
		return number;
	}

	function nextRange(max : float, min : float) : float
	{
		return this.next() * (max - min) + min;
	}
}
