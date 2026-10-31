// Decompiled from Desktop\precompiled.rsblob by W3 Mod Workbench
// Compiled with REDkit build 1048625 (Release, x64)
// Comments, formatting and variable initialisers are not kept in compiled scripts.

statemachine class SU_NpcInteraction_GlobalEventHandler
{
	protected var states_to_process : array<name>;
	var actionName : string;
	var activator : CEntity;
	var receptor : CEntity;

	function init() : SU_NpcInteraction_GlobalEventHandler
	{
		this.GotoState('Empty');
		return this;
	}

	function onInteraction(actionName : string, activator : CEntity, receptor : CEntity)
	{
		var states_to_process : array<name>;
		var i : int;

		this.actionName = actionName;
		this.activator = activator;
		this.receptor = receptor;

		states_to_process = theGame.GetDefinitionsManager().GetItemsWithTag('SU_NpcInteraction_GlobalEventListener');

		for (i = 0; i < states_to_process.Size(); i += 1)
		{
			this.states_to_process.PushBack(states_to_process[i]);
		}

		if (this.GetCurrentStateName() == 'Empty')
		{
			this.GotoState('Waiting');
		}
	}
}

state GlobalEventListener in SU_NpcInteraction_GlobalEventHandler
{
	event OnEnterState(previous_state_name : name)
	{
		super.OnEnterState(previous_state_name);
	}

	function finish()
	{
		parent.GotoState('Waiting');
	}
}

state Empty in SU_NpcInteraction_GlobalEventHandler
{
}

state Waiting in SU_NpcInteraction_GlobalEventHandler
{
	event OnEnterState(previous_state_name : name)
	{
		super.OnEnterState(previous_state_name);
		this.Waiting_main(previous_state_name);
	}

	entry function Waiting_main(previous_state_name : name)
	{
		this.startProcessingLastState();
	}

	function startProcessingLastState()
	{
		var last_state : name;

		if (parent.states_to_process.Size() <= 0)
		{
			parent.GotoState('Empty');
			return;
		}

		last_state = parent.states_to_process.PopBack();
		parent.GotoState(last_state);
	}
}
