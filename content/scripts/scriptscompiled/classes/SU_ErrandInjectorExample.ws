// Decompiled from Desktop\precompiled.rsblob by W3 Mod Workbench
// Compiled with REDkit build 1048625 (Release, x64)
// Comments, formatting and variable initialisers are not kept in compiled scripts.

class SU_ErrandInjectorExample extends SU_ErrandInjector
{
	function run(board : W3NoticeBoard)
	{
		SU_replaceFlawWithErrand(board, "hello world!");
	}

	function accepted(board : W3NoticeBoard, errand_name : string)
	{
		theGame.GetGuiManager().ShowNotification("accepted errand with name = " + errand_name);

		this.logErrandWithName(board, errand_name);
	}

	private function logErrandWithName(board : W3NoticeBoard, errand_name : string)
	{
		var i : int;

		for (i = 0; i < board.activeErrands.Size(); i += 1)
		{
			if (board.activeErrands[i].errandStringKey == errand_name)
			{
				LogChannel('SUTEST', "accepted errand with name = " + errand_name);
				LogChannel('SUTEST', "accepted errand with title = " + GetLocStringByKey(errand_name));
				LogChannel('SUTEST', "accepted errand with body = " + GetLocStringByKey(errand_name + "_text"));
			}
		}
	}
}
