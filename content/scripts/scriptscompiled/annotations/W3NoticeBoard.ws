// Decompiled from Desktop\precompiled.rsblob by W3 Mod Workbench
// Compiled with REDkit build 1048625 (Release, x64)
// Comments, formatting and variable initialisers are not kept in compiled scripts.

@addField(W3NoticeBoard)
saved var errandInjectors : array<SU_ErrandInjector>;

@addMethod(W3NoticeBoard)
function addErrandInjector(injector : SU_ErrandInjector)
{
	this.errandInjectors.PushBack(injector);
}

@wrapMethod(W3NoticeBoard)
function UpdateBoard(optional bSilent : bool)
{
	wrappedMethod(bSilent);

	SU_runAllErrandInjectors(this);
}

@wrapMethod(W3NoticeBoard)
function AcceptNewQuest(errandName : string) : bool
{
	SU_notifyAcceptedErrandToInjectors(errandName, this);
	return wrappedMethod(errandName);
}
