// Decompiled from Desktop\precompiled.rsblob by W3 Mod Workbench
// Compiled with REDkit build 1048625 (Release, x64)
// Comments, formatting and variable initialisers are not kept in compiled scripts.

struct SU_MenuDescriptor_OptionDescription
{
	var option_id : name;
	var description : string;
	var description_loc_key : string;
	var dynamic_description : bool;
}

class SU_InteractivePoint extends W3MonsterClue
{
	default interactionAnim = PEA_None;

	event OnInteraction(actionName : string, activator : CEntity)
	{
		if (this.interactionAnim != PEA_None)
		{
			this.PlayInteractionAnimation();
		}
	}

	event OnFocusModeEnabled(enabled : bool)
	{
		if (enabled)
		{
			PlayEffect('remains_highlight');
		}
		else
		{
			StopEffect('remains_highlight');
		}
	}
}

class SU_StaticCamera extends CStaticCamera
{
	function start()
	{
		this.Run();
	}

	function teleportAndLookAt(position : Vector, target : Vector)
	{
		var current_rotation : EulerAngles;

		current_rotation = VecToRotation(target - position);

		current_rotation.Pitch *= -1;

		this.TeleportWithRotation(position, current_rotation);
	}
}

class SU_BaseDamageModifier
{
	var damage_dealt_modifier : float;
	var damage_received_modifier : float;
	default damage_dealt_modifier = 1.0;
	default damage_received_modifier = 1.0;

	function modifyActionAsVictim(out action : W3DamageAction)
	{
		action.processedDmg.vitalityDamage *= this.damage_received_modifier;
		action.processedDmg.essenceDamage *= this.damage_received_modifier;
	}

	function modifyActionAsAttacker(out action : W3DamageAction)
	{
		action.processedDmg.vitalityDamage *= this.damage_dealt_modifier;
		action.processedDmg.essenceDamage *= this.damage_dealt_modifier;
	}
}

class SU_DialogChoiceResponseListener
{
	function onResponse(choice : SSceneChoice, available_choices : array<SSceneChoice>, module_dialog : CR4HudModuleDialog);
}

class SU_DialogHoverListener
{
	function onHover(scene_choice : SSceneChoice, index : int);
}

class SU_ExampleHoverListener extends SU_DialogHoverListener
{
	function onHover(scene_choice : SSceneChoice, index : int)
	{
		theGame.GetGuiManager().ShowNotification("description = " + scene_choice.description + " index = " + index);
	}
}

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

class SU_GlossaryManager
{
	var entries : array<SU_GlossaryEntry>;

	private function isTitleValid(title : string) : bool
	{
		return title != "";
	}

	private function isTagValid(tag : name) : bool
	{
		return tag != '';
	}

	private function isEntryValid(item : SU_GlossaryEntry) : bool
	{
		if (!item)
		{
			return false;
		}
		return this.isTitleValid(item.getTitle()) && this.isTagValid(item.entry_unique_id);
	}

	function getEntry(tag : name) : SU_GlossaryEntry
	{
		var i : int;

		if (!this.isTagValid(tag))
		{
			return NULL;
		}

		for (i = 0; i < this.entries.Size(); i += 1)
		{
			if (this.entries[i].entry_unique_id == tag)
			{
				return this.entries[i];
			}
		}
		return NULL;
	}

	function indexOfEntry(tag : name) : int
	{
		var i : int;

		if (!this.isTagValid(tag))
		{
			return -1;
		}

		for (i = 0; i < this.entries.Size(); i += 1)
		{
			if (this.entries[i].entry_unique_id == tag)
			{
				return i;
			}
		}
		return -1;
	}

	function hasEntry(tag : name) : bool
	{
		return this.indexOfEntry(tag) >= 0;
	}

	function setEntry(item : SU_GlossaryEntry) : bool
	{
		var i : int;

		if (!this.isEntryValid(item))
		{
			return false;
		}

		if (!this.setEntryAt(this.indexOfEntry(item.entry_unique_id), item))
		{
			this.entries.PushBack(item);
		}

		return true;
	}

	function removeEntry(item : SU_GlossaryEntry)
	{
		this.entries.Remove(item);
	}

	private function setEntryAt(index : int, item : SU_GlossaryEntry) : bool
	{
		if (index < 0 || index >= this.entries.Size())
		{
			return false;
		}

		if (!this.isEntryValid(item))
		{
			return false;
		}

		this.entries[index] = item;
		return true;
	}
}

class SU_ArraySorterData
{
	var value : float;

	function isGreaterThan(other : SU_ArraySorterData) : bool
	{
		return this.value > other.value;
	}
}

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

class SUMP_Manager
{
	var mappins : array<SU_MapPin>;
}

class SU_MapPin
{
	var tag : string;
	var pin_tag : name;
	var is_quest : bool;
	var position : Vector;
	var description : string;
	var label : string;
	var type : string;
	var filtered_type : string;
	var is_fast_travel : bool;
	var radius : float;
	var region : string;
	var appears_on_minimap : bool;
	var pointed_by_arrow : bool;
	var highlighted : bool;
	var visible_from_hour : int;
	var visible_to_hour : int;
	default pin_tag = 'User';
	default is_quest = false;
	default type = "MonsterQuest";
	default filtered_type = "QuestReturn";
	default appears_on_minimap = false;
	default pointed_by_arrow = true;
	default highlighted = true;
	default visible_from_hour = -1;
	default visible_to_hour = -1;

	function init(_tag : string, _position : Vector, _description : string, _label : string, _type : string, _filtered_type : string, _radius : float, _region : string, _appears_on_minimap : bool, _pointed_by_arrow : bool, _highlighted : bool, _is_quest : bool) : SU_MapPin
	{
		this.tag = _tag;
		this.position = _position;
		this.description = _description;
		this.label = _label;
		this.type = _type;
		this.filtered_type = _filtered_type;
		this.radius = _radius;
		this.region = _region;
		this.appears_on_minimap = _appears_on_minimap;
		this.pointed_by_arrow = _pointed_by_arrow;
		this.highlighted = _highlighted;
		this.is_quest = _is_quest;
		return this;
	}

	function isVisibleAtHour(hour : int) : bool
	{
		if (this.visible_from_hour < 0 || this.visible_to_hour < 0 || this.visible_from_hour == this.visible_to_hour)
		{
			return true;
		}

		if (this.visible_from_hour < this.visible_to_hour)
		{
			return hour >= this.visible_from_hour && hour < this.visible_to_hour;
		}
		return hour >= this.visible_from_hour || hour < this.visible_to_hour;
	}

	function onPinUsed()
	{
		var destination : Vector;

		if (this.is_fast_travel)
		{
			destination = this.position;

			thePlayer.DebugTeleportToPin(destination.X, destination.Y);
		}
	}
}

class SU_MapPinsBuilder
{
	private var tag_prefix : string;
	private var tag : string;
	private var pins : array<SU_MapPin>;

	function tag_prefix(prefix : string) : SU_MapPinsBuilder
	{
		this.tag_prefix = prefix;
		return this;
	}

	function tag(tag : string) : SU_MapPinsBuilder
	{
		this.tag = tag;
		return this;
	}

	function pin() : SU_MapPinBuilder
	{
		if (this.tag != "")
		{
			return (new SU_MapPinBuilder in this).consume_pins_builder(this).tag(this.tag);
		}
		return (new SU_MapPinBuilder in this).consume_pins_builder(this);
	}

	function consume_pin_builder(builder : SU_MapPinBuilder) : SU_MapPinsBuilder
	{
		this.pins.PushBack(builder.tag_prefix(this.tag_prefix).build());
		return this;
	}

	function build()
	{
		var i : int;

		if (this.tag_prefix != "")
		{
			SU_removeCustomPinByTagPrefix(this.tag_prefix);
		}

		if (this.tag != "")
		{
			SU_removeCustomPinByTag(this.tag);
		}

		for (i = 0; i < this.pins.Size(); i += 1)
		{
			SULOG("Adding pin, " + this.pins[i].tag + " - " + VecToString(this.pins[i].position));

			SUMP_addCustomPin(this.pins[i]);
		}

		SU_updateMinimapPins();
	}
}

class SU_MapPinBuilder
{
	private var pins_builder : SU_MapPinsBuilder;
	private var pin : SU_MapPin;

	function init() : SU_MapPinBuilder
	{
		this.pin = new SU_MapPin in thePlayer;
		return this.region(SUH_getCurrentRegion());
	}

	function consume_pins_builder(pins_builder : SU_MapPinsBuilder) : SU_MapPinBuilder
	{
		this.pins_builder = pins_builder;
		return this.init();
	}

	function tag(tag : string) : SU_MapPinBuilder
	{
		this.pin.tag = tag;
		return this;
	}

	function tag_prefix(prefix : string) : SU_MapPinBuilder
	{
		this.pin.tag = prefix + this.pin.tag;
		return this;
	}

	function is_quest(is_quest : bool) : SU_MapPinBuilder
	{
		this.pin.is_quest = is_quest;
		return this;
	}

	function position(position : Vector) : SU_MapPinBuilder
	{
		this.pin.position = position;
		return this;
	}

	function description(description : string) : SU_MapPinBuilder
	{
		this.pin.description = description;
		return this;
	}

	function label(label : string) : SU_MapPinBuilder
	{
		this.pin.label = label;
		return this;
	}

	function type(type : string) : SU_MapPinBuilder
	{
		this.pin.type = type;
		return this;
	}

	function filtered_type(filtered_type : string) : SU_MapPinBuilder
	{
		this.pin.filtered_type = filtered_type;
		return this;
	}

	function radius(radius : float) : SU_MapPinBuilder
	{
		this.pin.radius = radius;
		return this;
	}

	function region(region : string) : SU_MapPinBuilder
	{
		this.pin.region = region;
		return this;
	}

	function appears_on_minimap(appears_on_minimap : bool) : SU_MapPinBuilder
	{
		this.pin.appears_on_minimap = appears_on_minimap;
		return this;
	}

	function pointed_by_arrow(pointed_by_arrow : bool) : SU_MapPinBuilder
	{
		this.pin.pointed_by_arrow = pointed_by_arrow;
		return this;
	}

	function highlighted(highlighted : bool) : SU_MapPinBuilder
	{
		this.pin.highlighted = highlighted;
		return this;
	}

	function fast_travel(fast_travel : bool) : SU_MapPinBuilder
	{
		this.pin.is_fast_travel = fast_travel;
		return this;
	}

	function visible_between(from_hour : int, to_hour : int) : SU_MapPinBuilder
	{
		this.pin.visible_from_hour = from_hour;
		this.pin.visible_to_hour = to_hour;
		return this;
	}

	function add() : SU_MapPinsBuilder
	{
		return this.pins_builder.consume_pin_builder(this);
	}

	function build() : SU_MapPin
	{
		return this.pin;
	}
}

class SU_PredicateInterfaceRemovePin
{
	function predicate(pin : SU_MapPin) : bool
	{
		return false;
	}
}

class SU_CustomPinRemoverPredicateTagIncludesSubstring extends SU_PredicateInterfaceRemovePin
{
	var substring : string;

	function predicate(pin : SU_MapPin) : bool
	{
		return StrContains(pin.tag, this.substring);
	}
}

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

class SU_MenuDescriptorInternal
{
	private var option_hover_listeners : array<SU_MenuDescriptor_OptionDescription>;
	private var menu_scope : string;
	private var message_fallback : string;

	final function enteredAt(menu : string)
	{
		this.menu_scope = menu;
		this.option_hover_listeners.Clear();
	}

	final function didEnterAt(menu : string) : bool
	{
		return this.menu_scope == menu;
	}

	final function onOptionHovered(menu : string, option : name) : string
	{
		var output : string;
		var dynamic : bool;
		var i : int;

		for (i = 0; i < this.option_hover_listeners.Size(); i += 1)
		{
			if (this.option_hover_listeners[i].option_id != option)
			{
				continue;
			}

			if (this.option_hover_listeners[i].description_loc_key != "")
			{
				output += GetLocStringByKey(this.option_hover_listeners[i].description_loc_key);
			}
			else
			{
				output += this.option_hover_listeners[i].description;
			}

			dynamic = dynamic || this.option_hover_listeners[i].dynamic_description;
		}

		if (dynamic)
		{
			output = this.dynamicDescription(menu, option, output);
		}

		return output;
	}

	final function onOptionValueChanged(menu : string, option : name) : string
	{
		var output : string;
		var i : int;

		for (i = 0; i < this.option_hover_listeners.Size(); i += 1)
		{
			if (this.option_hover_listeners[i].option_id != option)
			{
				continue;
			}

			if (!this.option_hover_listeners[i].dynamic_description)
			{
				continue;
			}

			if (this.option_hover_listeners[i].description_loc_key != "")
			{
				output += GetLocStringByKey(this.option_hover_listeners[i].description_loc_key);
				continue;
			}

			output += this.option_hover_listeners[i].description;
		}

		output = this.dynamicDescription(menu, option, output);
		return output;
	}

	final function getMessageFallback() : string
	{
		return this.message_fallback;
	}

	protected final function onHover(option_id : name, optional description : string, optional description_loc_key : string, optional dynamic_description : bool)
	{
		this.option_hover_listeners.PushBack(SU_MenuDescriptor_OptionDescription(option_id, description, description_loc_key, false));
	}

	protected final function onHoverDynamic(option_id : name, optional description : string, optional description_loc_key : string)
	{
		this.option_hover_listeners.PushBack(SU_MenuDescriptor_OptionDescription(option_id, description, description_loc_key, true));
	}

	protected final function withFallbackMessage(optional description : string, optional description_loc_key : string)
	{
		if (description_loc_key != "")
		{
			this.message_fallback = GetLocStringByKey(description_loc_key);
		}
		else
		{
			this.message_fallback = description;
		}
	}

	protected function dynamicDescription(menu : string, option : name, description : string) : string
	{
		return description;
	}
}

class SU_MenuDescriptor extends SU_MenuDescriptorInternal
{
	function build();
}

class SU_ErrandInjector
{
	var tag : string;

	function run(out board : W3NoticeBoard);

	function accepted(out board : W3NoticeBoard, errand_name : string);
}

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

class SU_PredicateInterfaceRemoveErrandInjector
{
	function predicate(injector : SU_ErrandInjector) : bool
	{
		return false;
	}
}

class SU_ErrandInjectorRemoverPredicateTagIncludesSubstring extends SU_PredicateInterfaceRemoveErrandInjector
{
	var substring : string;

	function predicate(injector : SU_ErrandInjector) : bool
	{
		return StrContains(injector.tag, this.substring);
	}
}

class SU_InteractionEventListener
{
	var tag : string;
	default tag = "None";

	function run(actionName : string, activator : CEntity, receptor : CPeristentEntity) : bool
	{
		return true;
	}
}

class SU_StoreIfInteractedWith extends SU_InteractionEventListener
{
	var was_activated : bool;
	default tag = SU_StoreIfInteractedWith;

	function run(actionName : string, activator : CEntity, receptor : CPeristentEntity) : bool
	{
		this.was_activated = true;

		SU_removeInteractionEventListenerByTag(receptor, this.tag);
		return true;
	}

	latent function waitUntilActivated()
	{
		while (!this.was_activated)
		{
			SleepOneFrame();
		}
	}
}

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

statemachine class SUOL_Manager
{
	private var oneliner_counter : int;
	protected var oneliners : array<SU_Oneliner>;
	protected var module_oneliners : CR4HudModuleOneliners;
	protected var module_flash : CScriptedFlashSprite;
	protected var module_hud : CR4ScriptedHud;
	private var fxCreateOnelinerSFF : CScriptedFlashFunction;
	private var fxRemoveOnelinerSFF : CScriptedFlashFunction;

	private function initialize()
	{
		this.module_hud = (CR4ScriptedHud)theGame.GetHud();
		this.module_oneliners = (CR4HudModuleOneliners)this.module_hud.GetHudModule("OnelinersModule");
		this.module_flash = this.module_oneliners.GetModuleFlash();

		this.fxCreateOnelinerSFF = this.module_flash.GetMemberFlashFunction("CreateOneliner");
		this.fxRemoveOnelinerSFF = this.module_flash.GetMemberFlashFunction("RemoveOneliner");
	}

	private function getNewId() : int
	{
		var id : int;

		id = Max(this.oneliner_counter, theGame.GetLocalTimeAsMilliseconds());
		this.oneliner_counter = id + 1;
		return id;
	}

	function createOneliner(oneliner : SU_Oneliner)
	{
		var should_initialize_and_render : bool;

		should_initialize_and_render = this.GetCurrentStateName() != 'Render';

		if (should_initialize_and_render)
		{
			this.initialize();
		}

		if (oneliner.id < 0)
		{
			oneliner.id = this.getNewId();
		}

		if (!oneliner.is_registered)
		{
			this.fxCreateOnelinerSFF.InvokeSelfTwoArgs(FlashArgInt(oneliner.id), FlashArgString(oneliner.text));

			this.oneliners.PushBack(oneliner);
			oneliner.is_registered = true;
		}

		if (should_initialize_and_render)
		{
			this.GotoState('Render');
		}
	}

	function updateOneliner(oneliner : SU_Oneliner)
	{
		this.module_flash.GetChildFlashSprite("mcOneliner" + oneliner.id).GetChildFlashTextField("textField").SetTextHtml(oneliner.text);
	}

	function setOnelinerOpacity(oneliner : SU_Oneliner, opacity : float)
	{
		var sprite : CScriptedFlashSprite;

		sprite = this.module_flash.GetChildFlashSprite("mcOneliner" + oneliner.id);

		if (sprite)
		{
			sprite.SetAlpha(opacity * 100.0);
		}
	}

	function deleteOneliner(oneliner : SU_Oneliner)
	{
		this.oneliners.Remove(oneliner);
		this.fxRemoveOnelinerSFF.InvokeSelfOneArg(FlashArgInt(oneliner.id));
		oneliner.is_registered = false;
	}

	function findByTag(tag : string) : array<SU_Oneliner>
	{
		var output : array<SU_Oneliner>;
		var i : int;

		for (i = 0; i < this.oneliners.Size(); i += 1)
		{
			if (this.oneliners[i].tag == tag)
			{
				output.PushBack(this.oneliners[i]);
			}
		}
		return output;
	}

	function findByTagPrefix(tag : string) : array<SU_Oneliner>
	{
		var output : array<SU_Oneliner>;
		var i : int;

		for (i = 0; i < this.oneliners.Size(); i += 1)
		{
			if (StrStartsWith(this.oneliners[i].tag, tag))
			{
				output.PushBack(this.oneliners[i]);
			}
		}
		return output;
	}

	function deleteByTag(tag : string) : array<SU_Oneliner>
	{
		var output : array<SU_Oneliner>;
		var i : int;

		output = this.findByTag(tag);
		for (i = 0; i < output.Size(); i += 1)
		{
			this.deleteOneliner(output[i]);
		}
		return output;
	}

	function deleteByTagPrefix(tag : string) : array<SU_Oneliner>
	{
		var output : array<SU_Oneliner>;
		var i : int;

		output = this.findByTagPrefix(tag);
		for (i = 0; i < output.Size(); i += 1)
		{
			this.deleteOneliner(output[i]);
		}
		return output;
	}

	function deleteAllOneliners()
	{
		while (this.oneliners.Size() > 0)
		{
			this.deleteOneliner(this.oneliners[this.oneliners.Size() - 1]);
		}
	}
}

state SUOL_Idle in SUOL_Manager
{
	event OnEnterState(previous_state_name : name)
	{
		super.OnEnterState(previous_state_name);
	}
}

state Render in SUOL_Manager
{
	event OnEnterState(previous_state_name : name)
	{
		super.OnEnterState(previous_state_name);
		SUOL_Logger("Entering state [Render]");

		this.Render_main();
	}

	entry function Render_main()
	{
		this.renderingLoop();

		parent.GotoState('SUOL_Idle');
	}

	latent function renderingLoop()
	{
		var sprite : CScriptedFlashSprite;
		var oneliner : SU_Oneliner;
		var oneliners_count : int;
		var i : int;
		var player_position : Vector;
		var screen_position : Vector;

		screen_position = thePlayer.GetWorldPosition();
		player_position = thePlayer.GetWorldPosition();
		while (true)
		{
			oneliners_count = parent.oneliners.Size();

			if (oneliners_count <= 0)
			{
				break;
			}

			player_position = thePlayer.GetWorldPosition();

			for (i = 0; i < oneliners_count; i += 1)
			{
				oneliner = parent.oneliners[i];
				sprite = parent.module_flash.GetChildFlashSprite("mcOneliner" + oneliner.id);

				if (!oneliner.getVisible(player_position))
				{
					sprite.SetVisible(false);
					continue;
				}

				if (oneliner.getScreenPosition(parent.module_hud, screen_position))
				{
					sprite.SetPosition(screen_position.X, screen_position.Y);
					sprite.SetVisible(true);
					continue;
				}

				sprite.SetVisible(false);
			}

			SleepOneFrame();
		}
	}
}

class SU_Oneliner
{
	var tag : string;
	var id : int;
	var text : string;
	var visible : bool;
	var position : Vector;
	var offset : Vector;
	var render_distance : int;
	var is_registered : bool;
	private var cached_manager : SUOL_Manager;
	var opacity : float;
	var cached_screen_position : Vector;
	default id = -1;
	default visible = true;

	function getManager() : SUOL_Manager
	{
		if (!this.cached_manager)
		{
			this.cached_manager = SUOL_getManager();
		}
		return this.cached_manager;
	}

	function register()
	{
		this.getManager().createOneliner(this);
	}

	function unregister()
	{
		this.getManager().deleteOneliner(this);
	}

	function update()
	{
		this.getManager().updateOneliner(this);
	}

	function setRenderDistance(value : int) : SU_Oneliner
	{
		this.render_distance = value;
		return this;
	}

	function setText(value : string) : SU_Oneliner
	{
		this.text = value;
		return this;
	}

	function setOffset(value : Vector) : SU_Oneliner
	{
		this.offset = value;
		return this;
	}

	function setTag(value : string) : SU_Oneliner
	{
		this.tag = value;
		return this;
	}

	function setOpacity(value : float) : SU_Oneliner
	{
		if (value == this.opacity)
		{
			return this;
		}

		this.opacity = value;
		this.getManager().setOnelinerOpacity(this, value);
		return this;
	}

	function getVisible(player_position : Vector) : bool
	{
		if (this.render_distance <= 0)
		{
			return this.visible;
		}
		return VecDistanceSquared2D(player_position, this.getPosition()) <= this.render_distance * this.render_distance;
	}

	function getPosition() : Vector
	{
		return this.position + this.offset;
	}

	function getScreenPosition(hud : CR4ScriptedHud, out screen_position : Vector) : bool
	{
		var world_position : Vector;
		var result : bool;

		world_position = this.getPosition();

		result = SUOL_worldToScreenPosition(hud, world_position, screen_position, this.cached_screen_position);
		return result;
	}
}

class SU_OnelinerEntity extends SU_Oneliner
{
	var entity : CEntity;

	function getPosition() : Vector
	{
		return this.entity.GetWorldPosition() + this.offset;
	}
}

class SU_OnelinerScreen extends SU_Oneliner
{
	function getScreenPosition(hud : CR4ScriptedHud, out screen_position : Vector) : bool
	{
		var position : Vector;

		position = this.getPosition();
		screen_position = hud.GetScaleformPoint(position.X, position.Y);
		return true;
	}
}

function SU_damageModifier(out action : W3DamageAction)
{
	var damage_modifier : SU_BaseDamageModifier;
	var attacker : CNewNPC;
	var victim : CNewNPC;
	var i : int;

	attacker = (CNewNPC)action.attacker;
	if (attacker)
	{
		for (i = 0; i < attacker.sharedutils_damage_modifiers.Size(); i += 1)
		{
			damage_modifier = attacker.sharedutils_damage_modifiers[i];

			damage_modifier.modifyActionAsAttacker(action);
		}
	}

	victim = (CNewNPC)action.victim;
	if (victim)
	{
		for (i = 0; i < victim.sharedutils_damage_modifiers.Size(); i += 1)
		{
			damage_modifier = victim.sharedutils_damage_modifiers[i];

			damage_modifier.modifyActionAsVictim(action);
		}
	}
}

exec function SU_addExampleHoverListener()
{
	SU_addDialogHoverListener(new SU_ExampleHoverListener in thePlayer);
}

function SU_addDialogHoverListener(listener : SU_DialogHoverListener) : bool
{
	var hud : CR4ScriptedHud;
	var dialogueModule : CR4HudModuleDialog;

	hud = (CR4ScriptedHud)theGame.GetHud();

	if (!hud)
	{
		LogChannel('SharedUtils', "SU_addDialogHoverListener - could not get HUD");
		return false;
	}

	dialogueModule = (CR4HudModuleDialog)hud.GetHudModule("DialogModule");
	dialogueModule.dialog_hover_listeners.PushBack(listener);
	return true;
}

function SU_removeDialogHoverListener(listener : SU_DialogHoverListener) : bool
{
	var hud : CR4ScriptedHud;
	var dialogueModule : CR4HudModuleDialog;

	hud = (CR4ScriptedHud)theGame.GetHud();

	if (!hud)
	{
		LogChannel('SharedUtils', "SU_setDialogChoicesAndWaitForResponse - could not get HUD");
		return false;
	}

	dialogueModule = (CR4HudModuleDialog)hud.GetHudModule("DialogModule");
	dialogueModule.dialog_hover_listeners.Remove(listener);
	return true;
}

function SU_clearDialogHoverListeners() : bool
{
	var hud : CR4ScriptedHud;
	var dialogueModule : CR4HudModuleDialog;

	hud = (CR4ScriptedHud)theGame.GetHud();

	if (!hud)
	{
		LogChannel('SharedUtils', "SU_setDialogChoicesAndWaitForResponse - could not get HUD");
		return false;
	}

	dialogueModule = (CR4HudModuleDialog)hud.GetHudModule("DialogModule");
	dialogueModule.dialog_hover_listeners.Clear();
	return true;
}

function SU_triggerEventListeners(module : CR4HudModuleDialog, choice : SSceneChoice, index : int)
{
	var i : int;

	for (i = 0; i < module.dialog_hover_listeners.Size(); i += 1)
	{
		module.dialog_hover_listeners[i].onHover(choice, index);
	}
}

latent function SU_setDialogChoicesAndWaitForResponse(choices : array<SSceneChoice>) : SSceneChoice
{
	var dialogueModule : CR4HudModuleDialog;

	Sleep(0.25);

	dialogueModule = SU_setDialogChoices(choices);
	while (SU_isDialogChoiceCurrentlyPlaying(dialogueModule))
	{
		SleepOneFrame();
	}

	SleepOneFrame();
	return SU_getLastAcceptedChoiceAndFlushDialog(dialogueModule);
}

function SU_setDialogChoices(choices : array<SSceneChoice>) : CR4HudModuleDialog
{
	var dialogueModule : CR4HudModuleDialog;
	var null : CR4HudModuleDialog;
	var hud : CR4ScriptedHud;

	hud = (CR4ScriptedHud)theGame.GetHud();

	if (!hud)
	{
		LogChannel('SharedUtils', "SU_setDialogChoicesAndWaitForResponse - could not get HUD");
		return null;
	}

	dialogueModule = (CR4HudModuleDialog)hud.GetHudModule("DialogModule");
	dialogueModule.OnDialogChoicesSet(choices, false);

	dialogueModule.isAcceptedChoiceAvailable = false;

	theInput.SetContext('Scene');
	theGame.SetIsDialogOrCutscenePlaying(true);
	hud.OnCutsceneStarted();
	return dialogueModule;
}

function SU_isDialogChoiceCurrentlyPlaying(dialogueModule : CR4HudModuleDialog) : bool
{
	return !dialogueModule.isAcceptedChoiceAvailable && theInput.GetContext() == 'Scene' && theGame.IsDialogOrCutscenePlaying();
}

function SU_getLastAcceptedChoiceAndFlushDialog(dialogueModule : CR4HudModuleDialog) : SSceneChoice
{
	var accepted_choice : SSceneChoice;
	var empty_array : array<SSceneChoice>;
	var null : SSceneChoice;

	accepted_choice = dialogueModule.lastAcceptedChoice;

	dialogueModule.lastAcceptedChoice = null;

	if (!dialogueModule.isAcceptedChoiceAvailable)
	{
		accepted_choice = null;
	}

	dialogueModule.isAcceptedChoiceAvailable = false;

	dialogueModule.OnDialogChoicesSet(empty_array, false);
	return accepted_choice;
}

function SU_setDialogChoicesAndResponseListener(choices : array<SSceneChoice>, response_listener : SU_DialogChoiceResponseListener) : bool
{
	var hud : CR4ScriptedHud;
	var dialogueModule : CR4HudModuleDialog;
	var accepted_choice : SSceneChoice;
	var null : SSceneChoice;

	dialogueModule = SU_setDialogChoices(choices);
	dialogueModule.responseListener = response_listener;
	return true;
}

function SU_closeDialogChoiceInterface()
{
	var hud : CR4ScriptedHud;

	theInput.SetContext(thePlayer.GetExplorationInputContext());
	theGame.SetIsDialogOrCutscenePlaying(false);
	theGame.GetGuiManager().RequestMouseCursor(false);

	hud = (CR4ScriptedHud)theGame.GetHud();
	if (hud)
	{
		hud.OnCutsceneEnded();
	}
}

exec function SUG_example()
{
	var book : SU_GlossaryEntry;

	book = new SU_GlossaryEntry in thePlayer;
	book.entry_unique_id = 'SUGentryUniqueIdExample';

	book.drop_down_label = "Sharedutils - Custom Glossary Entries";
	book.drop_down_tag = 'SharedutilsCustomGlossaryEntries';

	book.title = "Custom glossary entry example";
	book.description = "Lorem ipsum dolor sit amet consectitur";

	LogChannel('SUG', "added = " + SU_addGlossaryEntry(book));
}

exec function SUG_exampleRemove()
{
	var book : SU_GlossaryEntry;

	book = SUG_getManager().getEntry('SUGentryUniqueIdExample');

	if (book)
	{
		SU_removeGlossaryEntry(book);
	}
}

exec function SUG_exampleChangeIcon()
{
	var book : SU_GlossaryEntry;

	book = SUG_getManager().getEntry('SUGentryUniqueIdExample');

	if (book)
	{
		book.icon_path = "icons/inventory/scrolls/scroll1.dds";
	}
}

function SU_addGlossaryEntry(glossary_entry : SU_GlossaryEntry) : bool
{
	return SUG_getManager().setEntry(glossary_entry);
}

function SU_removeGlossaryEntry(glossary_entry : SU_GlossaryEntry)
{
	SUG_getManager().removeEntry(glossary_entry);
}

function SUG_getManager() : SU_GlossaryManager
{
	return thePlayer.getSharedutilsGlossaryManager();
}

function SUG_populateListData(out flashDataList : CScriptedFlashArray, out m_flashValueStorage : CScriptedFlashValueStorage)
{
	var dataObject : CScriptedFlashObject;
	var glossary_entry : SU_GlossaryEntry;
	var manager : SU_GlossaryManager;
	var i : int;

	manager = SUG_getManager();
	LogChannel('SUG', "entries count = " + manager.entries.Size());

	for (i = 0; i < manager.entries.Size(); i += 1)
	{
		glossary_entry = manager.entries[i];

		if (!manager.entries[i])
		{
			LogChannel('SU Glossary', "Array Position [" + i + "] Is Empty");
			manager.entries.Erase(i);
			i -= 1;
			continue;
		}

		LogChannel('SU Glossary', "Array Position [" + i + "] = Book Tag [" + glossary_entry.entry_unique_id + "]");

		dataObject = m_flashValueStorage.CreateTempFlashObject();
		dataObject.SetMemberFlashUInt("sortIdx", glossary_entry.sort_index);
		dataObject.SetMemberFlashUInt("itemId", NameToFlashUInt(glossary_entry.entry_unique_id));
		dataObject.SetMemberFlashUInt("tag", NameToFlashUInt(glossary_entry.entry_unique_id));
		dataObject.SetMemberFlashUInt("dropDownTag", NameToFlashUInt(glossary_entry.drop_down_tag));
		dataObject.SetMemberFlashBool("dropDownOpened", false);
		dataObject.SetMemberFlashString("dropDownLabel", glossary_entry.drop_down_label);
		dataObject.SetMemberFlashString("label", glossary_entry.getTitle());
		dataObject.SetMemberFlashString("text", glossary_entry.getDescription());
		dataObject.SetMemberFlashString("iconPath", glossary_entry.icon_path);
		dataObject.SetMemberFlashBool("isQuest", glossary_entry.is_quest);
		dataObject.SetMemberFlashBool("isPainting", glossary_entry.is_painting);
		dataObject.SetMemberFlashBool("isNew", glossary_entry.getIsNew());

		flashDataList.PushBackFlashObject(dataObject);
	}
}

function SU_sortArray(arr : array<SU_ArraySorterData>) : array<SU_ArraySorterData>
{
	var output : array<SU_ArraySorterData>;
	var current : SU_ArraySorterData;
	var other : SU_ArraySorterData;
	var last : SU_ArraySorterData;
	var was_inserted : bool;
	var i : int;
	var k : int;

	if (arr.Size() <= 1)
	{
		return arr;
	}

	current = arr[0];
	output.PushBack(current);
	last = current;

	for (i = 1; i < arr.Size(); i += 1)
	{
		current = arr[i];
		was_inserted = false;

		if (!last.isGreaterThan(current))
		{
			output.PushBack(current);
			last = current;

			continue;
		}

		for (k = 0; k < output.Size(); k += 1)
		{
			other = output[k];

			if (other.isGreaterThan(current))
			{
				output.Insert(k, current);
				was_inserted = true;

				break;
			}
		}

		if (!was_inserted)
		{
			output.PushBack(current);

			last = current;
		}
	}
	return output;
}

latent function SU_getStaticCamera() : SU_StaticCamera
{
	var template : CEntityTemplate;
	var camera : SU_StaticCamera;

	template = (CEntityTemplate)LoadResourceAsync("dlc\\dlcsharedutils\\data\\su_static_camera.w2ent", true);

	camera = (SU_StaticCamera)theGame.CreateEntity(template, thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation());
	return camera;
}

function SUH_makeEntitiesTargetPlayer(entities : array<CEntity>)
{
	var i : int;

	for (i = 0; i < entities.Size(); i += 1)
	{
		if (((CActor)entities[i]).GetTarget() != thePlayer && !((CActor)entities[i]).HasAttitudeTowards(thePlayer))
		{
			((CNewNPC)entities[i]).NoticeActor(thePlayer);
			((CActor)entities[i]).SetAttitude(thePlayer, 2);
		}
	}
}

function SUH_makeEntitiesAlliedWith(entities : array<CEntity>, entity : CEntity)
{
	var i : int;

	for (i = 0; i < entities.Size(); i += 1)
	{
		((CActor)entities[i]).SetAttitude((CActor)entity, 0);
	}
}

function SUH_makeEntitiesAlliedWithEachother(entities : array<CEntity>)
{
	var i : int;

	for (i = 0; i < entities.Size(); i += 1)
	{
		SUH_makeEntitiesAlliedWith(entities, entities[i]);
	}
}

function SUH_getEntitiesInRange(position : Vector, radius : float) : array<CEntity>
{
	var gameplay_entities : array<CGameplayEntity>;
	var output : array<CEntity>;
	var entity : CEntity;
	var i : int;

	FindGameplayEntitiesInCylinder(gameplay_entities, position, radius, radius, 100, , (EScriptQueryFlags)4 + (EScriptQueryFlags)1, , 'CEntity');

	for (i = 0; i < gameplay_entities.Size(); i += 1)
	{
		entity = gameplay_entities[i];

		if (entity)
		{
			output.PushBack(gameplay_entities[i]);
		}
	}
	return output;
}

function SUH_areAllEntitiesFarFromPlayer(entities : array<CEntity>) : bool
{
	var player_position : Vector;
	var i : int;

	player_position = thePlayer.GetWorldPosition();

	for (i = 0; i < entities.Size(); i += 1)
	{
		if (VecDistanceSquared2D(entities[i].GetWorldPosition(), player_position) < 20 * 20 * ((int)((CNewNPC)entities[i]).IsFlying() * 5 + 1))
		{
			return false;
		}
	}
	return true;
}

function SUH_slideEntityToPosition(entity : CEntity, position : Vector, optional duration : float)
{
	var movement_adjustor : CMovementAdjustor;
	var slide_ticket : SMovementAdjustmentRequestTicket;
	var translation : Vector;

	if (duration <= 0)
	{
		duration = 2;
	}

	translation = position - entity.GetWorldPosition();

	movement_adjustor = ((CActor)entity).GetMovingAgentComponent().GetMovementAdjustor();

	movement_adjustor.CancelByName('SharedUtilsSlideToPosition');

	slide_ticket = movement_adjustor.CreateNewRequest('SharedUtilsSlideToPosition');

	movement_adjustor.AdjustmentDuration(slide_ticket, duration);

	movement_adjustor.SlideTo(slide_ticket, position);

	movement_adjustor.RotateTo(slide_ticket, VecHeading(translation));
}

function SUH_keepCreaturesOutsidePoint(position : Vector, radius : float, optional entities : array<CEntity>)
{
	var distance_from_point : float;
	var old_position : Vector;
	var new_position : Vector;
	var i : int;

	if (entities.Size() == 0)
	{
		entities = SUH_getEntitiesInRange(position, radius);
	}

	for (i = 0; i < entities.Size(); i += 1)
	{
		old_position = entities[i].GetWorldPosition();

		distance_from_point = VecDistanceSquared(old_position, position);

		if (distance_from_point <= radius)
		{
			new_position = VecInterpolate(position, old_position, 1);

			SUH_groundPosition(new_position);

			if (new_position.Z < old_position.Z)
			{
				new_position.Z = old_position.Z;
			}

			SUH_slideEntityToPosition(entities[i], new_position);
		}
	}
}

function SUH_keepCreaturesOnPoint(position : Vector, radius : float, entities : array<CEntity>)
{
	var distance_from_point : float;
	var old_position : Vector;
	var new_position : Vector;
	var is_flying : bool;
	var i : int;

	for (i = 0; i < entities.Size(); i += 1)
	{
		old_position = entities[i].GetWorldPosition();

		distance_from_point = VecDistanceSquared(old_position, position);

		if (distance_from_point > radius)
		{
			new_position = VecInterpolate(old_position, position, 1 / radius);

			SUH_groundPosition(new_position);

			if (new_position.Z < old_position.Z)
			{
				new_position.Z = old_position.Z;
			}

			is_flying = ((CNewNPC)entities[i]).IsFlying();

			SUH_slideEntityToPosition(entities[i], new_position, (int)is_flying * 3 + 1);
		}
	}
}

function SUH_areAllEntitiesDead(entities : array<CEntity>) : bool
{
	var i : int;

	for (i = 0; i < entities.Size(); i += 1)
	{
		if (((CActor)entities[i]).GetHealthPercents() >= 0.01)
		{
			return false;
		}
	}
	return true;
}

latent function SUH_resetEntitiesAttitudes(entities : array<CEntity>)
{
	var i : int;

	for (i = 0; i < entities.Size(); i += 1)
	{
		((CActor)entities[i]).ResetTemporaryAttitudeGroup(0);
	}
}

function SUH_removeDeadEntities(out entities : array<CEntity>) : int
{
	var i : int;
	var max : int;
	var removed_count : int;

	max = entities.Size();

	for (i = 0; i < max; i += 1)
	{
		if (!entities[i] || !((CActor)entities[i]).IsAlive() || ((CActor)entities[i]).GetHealthPercents() <= 0.01)
		{
			entities.Remove(entities[i]);

			max -= 1;
			i -= 1;
			removed_count += 1;
		}
	}
	return removed_count;
}

latent function SUH_waitUntilPlayerFinishesCombat(out entities : array<CEntity>)
{
	Sleep(3);
	while (SUH_waitUntilPlayerFinishesCombatStep(entities))
	{
		Sleep(1);
	}
}

function SUH_waitUntilPlayerFinishesCombatStep(out entities : array<CEntity>) : bool
{
	if (SUH_areAllEntitiesDead(entities) || SUH_areAllEntitiesFarFromPlayer(entities))
	{
		return false;
	}

	SUH_makeEntitiesTargetPlayer(entities);
	SUH_removeDeadEntities(entities);
	return true;
}

function SULOG(message : string)
{
	LogChannel('SU', message);
}

latent function SUH_waitForPlayerToReachPoint(position : Vector, radius : float)
{
	var distance_from_player : float;

	radius *= radius;
	distance_from_player = VecDistanceSquared2D(thePlayer.GetWorldPosition(), position);
	while (distance_from_player > radius)
	{
		SleepOneFrame();

		distance_from_player = VecDistanceSquared2D(thePlayer.GetWorldPosition(), position);
	}
}

function SUH_getCurrentRegion() : string
{
	return SUH_normalizeRegion(theGame.GetCommonMapManager().GetCurrentArea());
}

function SUH_isPlayerInRegion(region : string) : bool
{
	return SUH_getCurrentRegion() == region;
}

function SUH_normalizeRegion(region : string) : string
{
	switch (region)
	{
		case "AN_NMLandNovigrad":
		case "AN_Velen":
		case "novigrad":
			return "no_mans_land";

			break;
		case "AN_Prologue_Village":
		case "AN_Prologue_Village_Winter":
		case "prolog_village_winter":
			return "prolog_village";

			break;
		case "AN_Skellige_ArdSkellig":
		case "skellige":
			return "skellige";

			break;
		case "AN_Bob":
		case "bob":
			return "bob";

			break;
		case "AN_Kaer_Morhen":
		case "kaer_morhen":
			return "kaer_morhen";

			break;
	}

	return region;
}

function SUH_now() : float
{
	return theGame.GetEngineTimeAsSeconds();
}

function SUH_elapsed(since : float) : float
{
	return SUH_now() - since;
}

function SUH_hasElapsed(since : float, duration : float) : bool
{
	return SUH_elapsed(since) >= duration;
}

function SUH_getPercentValuesFromCoordinates(point : Vector) : Vector
{
	var output : Vector;
	var min_x : float;
	var max_x : float;
	var min_y : float;
	var max_y : float;

	SUH_setMinAndMaxFromRegion(min_x, max_x, min_y, max_y);

	output.X = (point.X - min_x) / (max_x - min_x);
	output.Y = (point.Y - min_y) / (max_y - min_y);
	return output;
}

function SUH_getSafeCoordinatesFromPoint(point : Vector) : Vector
{
	var water_depth : float;
	var signposts : array<CGameplayEntity>;
	var array_of_nodes : array<CNode>;
	var closest_signpost_node : CNode;
	var closest_signpost_position : Vector;
	var distance_in_z_level : float;
	var i : int;
	var output : Vector;

	return point;
	water_depth = theGame.GetWorld().GetWaterDepth(point);

	if (water_depth >= 5000)
	{
		return point;
	}

	FindGameplayEntitiesInRange(signposts, thePlayer, 5000, 100, , (EScriptQueryFlags)1, , 'W3FastTravelEntity');

	for (i = 0; i < signposts.Size(); i += 1)
	{
		array_of_nodes.PushBack(signposts[i]);
	}

	closest_signpost_node = FindClosestNode(point, array_of_nodes);
	closest_signpost_position = closest_signpost_node.GetWorldPosition();

	output = point;

	i = 0;
	do
	{
		i += 1;

		output = VecInterpolate(output, closest_signpost_position, 0.05 * i);

		water_depth = theGame.GetWorld().GetWaterDepth(Vector(output, output, 2), true);

		distance_in_z_level = closest_signpost_position.Z - output.Z;
	} while ((water_depth < 5000 || distance_in_z_level > closest_signpost_position.Z * 0.05) && VecDistanceSquared2D(output, closest_signpost_position) > 5 * 5);

	output = VecInterpolate(output, closest_signpost_position, 0.2);
	return output;
}

function SUH_moveCoordinatesAwayFromSafeAreas(point : Vector, optional exception_areas : array<Vector>) : Vector
{
	var current_distance_percentage : float;
	var distance_from_center : float;
	var displacement_vector : Vector;
	var safe_areas : array<Vector>;
	var squared_radius : float;
	var i : int;

	for (i = 0; i < exception_areas.Size(); i += 1)
	{
		if (SUH_isPositionInsideArea(point, exception_areas[i]))
		{
			return point;
		}
	}

	safe_areas = SUH_getSafeAreasByRegion(SUH_getCurrentRegion());

	for (i = 0; i < safe_areas.Size(); i += 1)
	{
		squared_radius = safe_areas[i].Z * safe_areas[i].Z;
		distance_from_center = VecDistanceSquared2D(safe_areas[i], point);

		if (distance_from_center > squared_radius)
		{
			continue;
		}

		current_distance_percentage = distance_from_center / squared_radius;

		displacement_vector += (point - Vector(safe_areas[i], safe_areas[i], point)) * (1 - current_distance_percentage);
	}
	return point + displacement_vector;
}

function SUH_moveCoordinatesInsideValidAreas(point : Vector) : Vector
{
	var areas : array<Vector>;
	var closest_area : Vector;
	var distance_from_area : float;
	var distance_from_closest_area : float;
	var region : string;
	var output : Vector;
	var i : int;

	region = SUH_getCurrentRegion();

	if (region != "skellige")
	{
		return point;
	}

	areas.PushBack(Vector(-1828, 1190, 58));
	areas.PushBack(Vector(-1758, 1239, 56));
	areas.PushBack(Vector(-1641, 1284, 85));
	areas.PushBack(Vector(-1637, 1434, 61));
	areas.PushBack(Vector(-1555, 1543, 88));
	areas.PushBack(Vector(-1439, 1486, 60));
	areas.PushBack(Vector(-1355, 1411, 52));
	areas.PushBack(Vector(340, 1544, 32));
	areas.PushBack(Vector(313, 1591, 22));
	areas.PushBack(Vector(274, 1602, 19));
	areas.PushBack(Vector(1600, 1896, 74));
	areas.PushBack(Vector(1493, 1917, 60));
	areas.PushBack(Vector(1358, 1933, 94));
	areas.PushBack(Vector(1339, 1960, 85));
	areas.PushBack(Vector(2752, -116, 84));
	areas.PushBack(Vector(2759, 42, 89));
	areas.PushBack(Vector(2535, 203, 103));
	areas.PushBack(Vector(2541, 306, 47));
	areas.PushBack(Vector(2402, 155, 59));
	areas.PushBack(Vector(2212, 82, 26));
	areas.PushBack(Vector(2267, 35, 27));
	areas.PushBack(Vector(2419, 34, 27));
	areas.PushBack(Vector(2443, -16, 35));
	areas.PushBack(Vector(2491, -83, 36));
	areas.PushBack(Vector(2602, -132, 47));
	areas.PushBack(Vector(1536, -1921, 35));
	areas.PushBack(Vector(1709, -1925, 50));
	areas.PushBack(Vector(1675, -1804, 20));
	areas.PushBack(Vector(1592, -1809, 23));
	areas.PushBack(Vector(1863, -1942, 56));
	areas.PushBack(Vector(1936, -1902, 42));
	areas.PushBack(Vector(1999, -1982, 39));
	areas.PushBack(Vector(2130, -1946, 28));
	areas.PushBack(Vector(2201, -1944, 38));
	areas.PushBack(Vector(2302, -1977, 73));
	areas.PushBack(Vector(-1575, -758, 75));
	areas.PushBack(Vector(-1676, -632, 113));
	areas.PushBack(Vector(-1816, -619, 75));
	areas.PushBack(Vector(-1954, -638, 83));
	areas.PushBack(Vector(-2118, -655, 46));
	areas.PushBack(Vector(-1947, -820, 44));
	areas.PushBack(Vector(-1744, -824, 76));
	areas.PushBack(Vector(420, -1352, 54));
	areas.PushBack(Vector(172, -1322, 49));
	areas.PushBack(Vector(88, -1230, 53));
	areas.PushBack(Vector(-41, -1209, 54));
	areas.PushBack(Vector(-353, -940, 71));
	areas.PushBack(Vector(-429, -785, 78));
	areas.PushBack(Vector(-520, -566, 86));
	areas.PushBack(Vector(-520, -303, 182));
	areas.PushBack(Vector(-406, -206, 155));
	areas.PushBack(Vector(-200, -297, 175));
	areas.PushBack(Vector(-192, -537, 63));
	areas.PushBack(Vector(-124, -448, 53));
	areas.PushBack(Vector(31, -229, 132));
	areas.PushBack(Vector(237, -249, 198));
	areas.PushBack(Vector(188, -40, 103));
	areas.PushBack(Vector(310, -501, 143));
	areas.PushBack(Vector(436, -485, 90));
	areas.PushBack(Vector(361, -685, 66));
	areas.PushBack(Vector(254, -815, 78));
	areas.PushBack(Vector(298, -971, 80));
	areas.PushBack(Vector(543, -795, 59));
	areas.PushBack(Vector(631, -805, 31));
	areas.PushBack(Vector(380, -24, 123));
	areas.PushBack(Vector(203, 92, 64));
	areas.PushBack(Vector(223, 244, 77));
	areas.PushBack(Vector(-10, 419, 122));
	areas.PushBack(Vector(319, 555, 69));
	areas.PushBack(Vector(365, 298, 84));
	areas.PushBack(Vector(514, 184, 121));
	areas.PushBack(Vector(497, 357, 72));
	areas.PushBack(Vector(553, 588, 73));
	areas.PushBack(Vector(490, 629, 41));
	areas.PushBack(Vector(357, 738, 29));
	areas.PushBack(Vector(324, 795, 30));
	areas.PushBack(Vector(649, 694, 42));
	areas.PushBack(Vector(756, 706, 47));
	areas.PushBack(Vector(982, 627, 94));
	areas.PushBack(Vector(1092, 492, 34));
	areas.PushBack(Vector(1107, 404, 50));
	areas.PushBack(Vector(1164, 415, 38));
	areas.PushBack(Vector(1234, 373, 45));
	areas.PushBack(Vector(1307, 367, 31));
	areas.PushBack(Vector(1013, 213, 177));
	areas.PushBack(Vector(834, -89, 165));
	areas.PushBack(Vector(570, 13, 84));
	areas.PushBack(Vector(803, -310, 274));

	distance_from_closest_area = 10000000;

	for (i = 0; i < areas.Size(); i += 1)
	{
		distance_from_area = VecDistanceSquared2D(point, areas[i]);

		if (distance_from_area < distance_from_closest_area)
		{
			distance_from_closest_area = distance_from_area;
			closest_area = areas[i];
		}
	}
	return SUH_placeCircleCoordinatesAroundPoint(SUH_mapSquareToCircleCoordinates(SUH_getPercentValuesFromCoordinates(point)), closest_area);
}

function SUH_isPositionInsideSafeAreas(position : Vector) : bool
{
	var distance_from_center : float;
	var safe_areas : array<Vector>;
	var squared_radius : float;
	var i : int;

	safe_areas = SUH_getSafeAreasByRegion(SUH_getCurrentRegion());

	for (i = 0; i < safe_areas.Size(); i += 1)
	{
		if (SUH_isPositionInsideArea(position, safe_areas[i]))
		{
			return true;
		}
	}
	return false;
}

function SUH_isPositionInsideArea(point : Vector, area : Vector) : bool
{
	return VecDistanceSquared2D(Vector(point, point, 0), Vector(area, area, 0)) <= area.Z * area.Z;
}

function SUH_getSafeAreasByRegion(region : string) : array<Vector>
{
	var areas : array<Vector>;

	switch (region)
	{
		case "prolog_village_winter":
		case "prolog_village":
			break;
		case "novigrad":
		case "no_mans_land":
			areas.PushBack(Vector(340, 1980, 502));
			areas.PushBack(Vector(1760, 900, 215));

			areas.PushBack(Vector(2854, 1001, 529));
			areas.PushBack(Vector(193, -790, 362));

			areas.PushBack(Vector(-1368, 2139, 1778));

			areas.PushBack(Vector(240, 2760, 574));

			areas.PushBack(Vector(2271, 2512, 53));

			areas.PushBack(Vector(2369, -235, 310));

			areas.PushBack(Vector(207, 136, 149));

			break;
		case "skellige":
			areas.PushBack(Vector(-100, -636, 110));
			areas.PushBack(Vector(-90, -800, 162));
			areas.PushBack(Vector(-1700, -1000, 304));

			areas.PushBack(Vector(62, -149, 56));
			areas.PushBack(Vector(81, 68, 77));
			areas.PushBack(Vector(632, 39, 58));
			areas.PushBack(Vector(388, -720, 57));
			areas.PushBack(Vector(-201, -1000, 143));
			break;
		case "kaer_morhen":
			areas.PushBack(Vector(-11, 19, 95));
			areas.PushBack(Vector(130, 210, 183));
			areas.PushBack(Vector(-500, -700, 330));
			areas.PushBack(Vector(-340, -450, 239));
			areas.PushBack(Vector(-620, 500, 330));
			areas.PushBack(Vector(-100, -106, 30));
			break;
		case "bob":
			areas.PushBack(Vector(-2430, 1230, 2077));
			areas.PushBack(Vector(1840, 1070, 1729));
			areas.PushBack(Vector(1920, -2700, 1809));
			areas.PushBack(Vector(-1700, -2700, 1294));

			areas.PushBack(Vector(-750, -1230, 158));
			areas.PushBack(Vector(-490, -1415, 169));
			areas.PushBack(Vector(-440, -1260, 311));
			break;
	}

	return areas;
}

function SUH_mapSquareToCircleCoordinates(point : Vector) : Vector
{
	var x : float;
	var y : float;
	var output : Vector;

	output = point;

	x = point.X * 2 - 1;
	y = point.Y * 2 - 1;

	output.X = x * SqrtF(1 - y * y / 2);
	output.Y = y * SqrtF(1 - x * x / 2);
	return output;
}

function SUH_placeCircleCoordinatesAroundPoint(circle_coordinates : Vector, circle_center : Vector) : Vector
{
	return Vector(circle_center.X + circle_center.Z * circle_coordinates.X, circle_center.Y + circle_center.Z * circle_coordinates.Y);
}

function SUH_setMinAndMaxFromRegion(out min_x : float, out max_x : float, out min_y : float, out max_y : float)
{
	var area : string;

	area = SUH_getCurrentRegion();

	switch (area)
	{
		case "prolog_village":
			min_x = -350;
			max_x = 375;
			min_y = -150;
			max_y = 235;
			break;
		case "skellige":
			min_x = -1750;
			max_x = 1750;
			min_y = -1750;
			max_y = 1750;
			break;
		case "kaer_morhen":
			min_x = -180;
			max_x = 50;
			min_y = -500;
			max_y = 900;
			break;
		case "no_mans_land":
			min_x = -350;
			max_x = 2500;
			min_y = -1000;
			max_y = 2500;
			break;
		case "bob":
			min_x = -1100;
			max_x = 1100;
			min_y = -1800;
			max_y = 800;
			break;
		default:
			min_x = -300;
			max_x = 300;
			min_y = -300;
			max_y = 300;
	}
}

function SUH_getCoordinatesFromPercentValues(percent_x : float, percent_y : float) : Vector
{
	var output : Vector;
	var min_x : float;
	var max_x : float;
	var min_y : float;
	var max_y : float;

	SUH_setMinAndMaxFromRegion(min_x, max_x, min_y, max_y);

	output.X = min_x + (max_x - min_x) * percent_x;
	output.Y = min_y + (max_y - min_y) * percent_y;
	return output;
}

function SUH_groundPosition(out position : Vector)
{
	var world : CWorld;
	var z : float;

	world = theGame.GetWorld();

	if (world.NavigationComputeZ(position, position.Z - 128, position.Z + 128, z))
	{
		position.Z = z;
	}
	else if (world.PhysicsCorrectZ(position, z))
	{
		position.Z = z;
	}
}

function SU_updateCustomMapPins(out flash_array : CScriptedFlashArray, value_storage : CScriptedFlashValueStorage, shown_area : name)
{
	var flash_object : CScriptedFlashObject;
	var custom_pins : array<SU_MapPin>;
	var current_pin : SU_MapPin;
	var region : string;
	var shown_region : string;
	var journal_area : name;
	var hour : int;
	var i : int;

	custom_pins = SUMP_getCustomPins();

	region = SUH_getCurrentRegion();
	shown_region = SUH_normalizeRegion(shown_area);
	theGame.GetCommonMapManager().GetCurrentJournalArea(journal_area);
	hour = GameTimeHours(theGame.GetGameTime());

	for (i = 0; i < custom_pins.Size(); i += 1)
	{
		current_pin = custom_pins[i];

		if (current_pin.region != shown_region)
		{
			continue;
		}

		if (!current_pin.isVisibleAtHour(hour))
		{
			continue;
		}

		flash_object = value_storage.CreateTempFlashObject("red.game.witcher3.data.StaticMapPinData");
		flash_object.SetMemberFlashString("type", current_pin.type);
		flash_object.SetMemberFlashString("filteredType", current_pin.filtered_type);
		flash_object.SetMemberFlashString("label", current_pin.label);
		flash_object.SetMemberFlashString("description", current_pin.description);
		flash_object.SetMemberFlashNumber("posX", current_pin.position.X);
		flash_object.SetMemberFlashNumber("posY", current_pin.position.Y);
		flash_object.SetMemberFlashNumber("radius", RoundF(current_pin.radius));
		flash_object.SetMemberFlashBool("isQuest", current_pin.is_quest);
		flash_object.SetMemberFlashBool("isFastTravel", current_pin.is_fast_travel);
		flash_object.SetMemberFlashUInt("id", NameToFlashUInt(current_pin.pin_tag));

		flash_object.SetMemberFlashUInt("journalAreaId", NameToFlashUInt(journal_area));
		flash_object.SetMemberFlashNumber("rotation", 0);
		flash_object.SetMemberFlashBool("isPlayer", false);
		flash_object.SetMemberFlashBool("isUserPin", false);
		flash_object.SetMemberFlashBool("highlighted", false);
		flash_object.SetMemberFlashBool("tracked", false);
		flash_object.SetMemberFlashBool("hidden", false);
		flash_array.PushBackFlashObject(flash_object);
	}
}

function SU_updateMinimapPins()
{
	var minimapModule : CR4HudModuleMinimap2;
	var m_AddMapPin : CScriptedFlashFunction;
	var m_MovePin : CScriptedFlashFunction;
	var flashModule : CScriptedFlashSprite;
	var custom_pins : array<SU_MapPin>;
	var hud : CR4ScriptedHud;
	var pin : SU_MapPin;
	var i : int;

	hud = (CR4ScriptedHud)theGame.GetHud();
	if (hud)
	{
		minimapModule = (CR4HudModuleMinimap2)hud.GetHudModule("Minimap2Module");

		if (minimapModule)
		{
			flashModule = minimapModule.GetModuleFlash();
			m_AddMapPin = flashModule.GetMemberFlashFunction("AddMapPin");
			m_MovePin = flashModule.GetMemberFlashFunction("MoveMapPin");

			custom_pins = SUMP_getCustomPins();

			for (i = 0; i < custom_pins.Size(); i += 1)
			{
				pin = custom_pins[i];

				if (!pin.appears_on_minimap)
				{
					continue;
				}

				m_AddMapPin.InvokeSelfNineArgs(FlashArgInt(i), FlashArgString("Enemy"), FlashArgString("Enemy"), FlashArgNumber(pin.radius), FlashArgBool(pin.pointed_by_arrow), FlashArgInt(0), FlashArgBool(true), FlashArgBool(false), FlashArgBool(pin.highlighted));

				m_MovePin.InvokeSelfFourArgs(FlashArgInt(i), FlashArgNumber(pin.position.X), FlashArgNumber(pin.position.Y), FlashArgNumber(pin.radius));
			}
		}
	}
}

function SUMP_onPinUsed(pin_tag : name, area_id : int) : bool
{
	var custom_pins : array<SU_MapPin>;
	var current_pin : SU_MapPin;
	var i : int;

	custom_pins = SUMP_getCustomPins();

	for (i = 0; i < custom_pins.Size(); i += 1)
	{
		current_pin = custom_pins[i];

		if (current_pin.pin_tag == pin_tag)
		{
			current_pin.onPinUsed();
			return true;
		}
	}
	return false;
}

function SUMP_addCustomPin(pin : SU_MapPin)
{
	var manager : SUMP_Manager;

	manager = SUMP_getManager();
	manager.mappins.PushBack(pin);
}

function SUMP_getCustomPins() : array<SU_MapPin>
{
	return SUMP_getManager().mappins;
}

function SUMP_updateCustomPinsLabel(tag : string, label : string)
{
	var custom_pins : array<SU_MapPin>;
	var i : int;

	custom_pins = SUMP_getManager().mappins;

	for (i = 0; i < custom_pins.Size(); i += 1)
	{
		if (custom_pins[i].tag == tag)
		{
			custom_pins[i].label = label;
			return;
		}
	}

	SUMP_Logger("Unable to update label for map pin: " + tag);
}

function SUMP_Logger(message : string, optional informGUI : bool)
{
	LogChannel('SUMP', message);

	if (informGUI)
	{
		theGame.GetGuiManager().ShowNotification("SUMP: " + message, 5, true);
	}
}

function SU_removeCustomPinByIndex(index : int)
{
	var manager : SUMP_Manager;

	manager = SUMP_getManager();
	manager.mappins.Erase(index);

	SU_removeMinimapPin(index);
}

function SU_removeMinimapPin(old_index : int)
{
	var minimapModule : CR4HudModuleMinimap2;
	var m_DeleteMapPin : CScriptedFlashFunction;
	var flashModule : CScriptedFlashSprite;
	var hud : CR4ScriptedHud;
	var pin : SU_MapPin;
	var i : int;

	hud = (CR4ScriptedHud)theGame.GetHud();
	if (hud)
	{
		minimapModule = (CR4HudModuleMinimap2)hud.GetHudModule("Minimap2Module");

		if (minimapModule)
		{
			flashModule = minimapModule.GetModuleFlash();
			m_DeleteMapPin = flashModule.GetMemberFlashFunction("DeleteMapPin");

			m_DeleteMapPin.InvokeSelfOneArg(FlashArgInt(old_index));
		}
	}
}

function SU_removeCustomPinByPredicate(predicate_runner : SU_PredicateInterfaceRemovePin)
{
	var custom_pins : array<SU_MapPin>;
	var current_pin : SU_MapPin;
	var i : int;

	custom_pins = SUMP_getCustomPins();
	i = custom_pins.Size();
	while (i >= 0)
	{
		current_pin = custom_pins[i];

		if (predicate_runner.predicate(current_pin))
		{
			SU_removeCustomPinByIndex(i);
		}

		i -= 1;
	}
}

exec function SU_MapPinTests()
{
	SU_MapPinTest_0();
	SU_MapPinTest_1();
}

function SU_MapPinTest_0()
{
	(new SU_MapPinsBuilder in thePlayer).tag_prefix("SU_PinTest").pin().tag("first").position(thePlayer.GetWorldPosition()).radius(20).label("SU_PinTest label").description("SU_PinTest description").type("QuestAvailableBaW").filtered_type("QuestAvailableBaW").add().pin().tag("second").position(thePlayer.GetWorldPosition() + Vector(10, 10, 0)).radius(5).label("SU_PinTest label 2").description("SU_PinTest description 2").type("MonsterQuest").filtered_type("MonsterQuest").add().build();
}

function SU_MapPinTest_1()
{
	(new SU_MapPinsBuilder in thePlayer).tag_prefix("SU_PinTestNight").pin().tag("night").position(thePlayer.GetWorldPosition() + Vector(-10, 10, 0)).radius(10).label("SU_PinTest night label").description("SU_PinTest night description, only shown from 20:00 to 06:00").type("QuestAvailable").filtered_type("QuestAvailable").visible_between(20, 6).add().build();
}

function SU_removeCustomPin(pin : SU_MapPin, optional manager : SUMP_Manager) : bool
{
	var i : int;

	if (!manager)
	{
		manager = SUMP_getManager();
	}

	if (!manager)
	{
		SUMP_Logger("SU_removeCustomPin(), manager not found");
		return false;
	}

	i = manager.mappins.FindFirst(pin);
	if (i < 0)
	{
		return false;
	}

	manager.mappins.Erase(i);
	return true;
}

function SU_removeCustomPinByTagPrefix(prefix : string)
{
	SU_removeCustomPinByPredicate((new SU_CustomPinRemoverPredicateTagStartsWith in thePlayer).init(prefix));
}

function SU_removeCustomPinByTag(tag : string)
{
	SU_removeCustomPinByPredicate((new SU_CustomPinRemoverPredicateTagEquals in thePlayer).init(tag));
}

function SU_removeCustomPinByPosition(position : Vector)
{
	SU_removeCustomPinByPredicate((new SU_CustomPinRemoverPredicatePositionEquals in thePlayer).init(position));
}

function SUMP_getManager() : SUMP_Manager
{
	SUMP_Logger("SUMP_getManager()");
	return thePlayer.getSharedutilsMappinsManager();
}

function SUMP_getGroundPosition(out input_position : Vector, optional personal_space : float, optional radius : float) : bool
{
	var found_viable_position : bool;
	var collision_normal : Vector;
	var max_height_check : float;
	var output_position : Vector;
	var point_z : float;
	var attempts : int;

	attempts = 10;
	output_position = input_position;
	personal_space = MaxF(personal_space, 1.0);
	max_height_check = 30.0;

	if (radius == 0)
	{
		radius = 10.0;
	}
	do
	{
		attempts -= 1;

		theGame.GetWorld().NavigationComputeZ(output_position, output_position.Z - max_height_check, output_position.Z + max_height_check, point_z);

		output_position.Z = point_z;

		if (!theGame.GetWorld().NavigationFindSafeSpot(output_position, personal_space, radius, output_position))
		{
			continue;
		}

		if (output_position.Z < theGame.GetWorld().GetWaterLevel(output_position, true))
		{
			continue;
		}

		found_viable_position = true;
		break;
	} while (attempts > 0);

	if (found_viable_position)
	{
		input_position = output_position;
		return true;
	}
	return false;
}

function SU_notifyAcceptedErrandToInjectors(errand_name : string, board : W3NoticeBoard) : bool
{
	var injector : SU_ErrandInjector;
	var i : int;

	for (i = 0; i < board.errandInjectors.Size(); i += 1)
	{
		injector = board.errandInjectors[i];

		injector.accepted(board, errand_name);
	}
	return i > 0;
}

function SU_replaceFlawWithErrand(out board : W3NoticeBoard, errand_string : string) : bool
{
	var current_errand : ErrandDetailsList;
	var i : int;

	for (i = 0; i < board.activeErrands.Size(); i += 1)
	{
		current_errand = board.activeErrands[i];

		if (current_errand.errandStringKey == errand_string)
		{
			return false;
		}
	}

	for (i = 0; i < board.activeErrands.Size(); i += 1)
	{
		current_errand = board.activeErrands[i];

		if (current_errand.newQuestFact == "flaw")
		{
			board.activeErrands[i].errandStringKey = errand_string;
			board.activeErrands[i].newQuestFact = "injected_errand";
			return true;
		}
	}
	return false;
}

function SU_runAllErrandInjectors(board : W3NoticeBoard)
{
	var injector : SU_ErrandInjector;
	var i : int;

	for (i = 0; i < board.errandInjectors.Size(); i += 1)
	{
		injector = board.errandInjectors[i];

		injector.run(board);
	}
}

function SU_hasErrandInjectorWithTag(board : W3NoticeBoard, tag : string) : bool
{
	var i : int;
	var current_injector : SU_ErrandInjector;

	for (i = 0; i < board.errandInjectors.Size(); i += 1)
	{
		current_injector = board.errandInjectors[i];

		if (current_injector.tag == tag)
		{
			return true;
		}
	}
	return false;
}

function SU_removeErrandInjectorByTag(board : W3NoticeBoard, tag : string)
{
	var i : int;
	var current_injector : SU_ErrandInjector;

	for (i = 0; i < board.errandInjectors.Size(); i += 1)
	{
		current_injector = board.errandInjectors[i];

		if (current_injector.tag != tag)
		{
			continue;
		}

		if (i == board.errandInjectors.Size() - 1)
		{
			board.errandInjectors.PopBack();
			continue;
		}

		board.errandInjectors.Erase(i);
		i -= 1;
	}
}

exec function suadderrandinjector()
{
	var entities : array<CGameplayEntity>;
	var board : W3NoticeBoard;

	FindGameplayEntitiesInRange(entities, thePlayer, 10, 1, , (EScriptQueryFlags)1, , 'W3NoticeBoard');

	if (entities.Size() < 1)
	{
		theGame.GetGuiManager().ShowNotification("Could not find any noticeboard nearby");
	}

	board = (W3NoticeBoard)entities[0];

	if (board)
	{
		board.addErrandInjector(new SU_ErrandInjectorExample in board);

		theGame.GetGuiManager().ShowNotification("added example injector");
	}
	else
	{
		theGame.GetGuiManager().ShowNotification("Could not find any noticeboard nearby (cast fail)");
	}
}

function SU_NpcInteraction_runAllInteractionListeners(actionName : string, activator : CEntity, receptor : CEntity) : bool
{
	var current_event_listener : SU_InteractionEventListener;
	var handler : SU_NpcInteraction_GlobalEventHandler;
	var persistent_entity : CPeristentEntity;
	var should_event_continue : bool;
	var player_input : CPlayerInput;
	var i : int;

	handler = thePlayer.SU_NpcInteraction_getGlobalEventListener();

	handler.onInteraction(actionName, activator, receptor);

	should_event_continue = true;

	if ((CPeristentEntity)receptor)
	{
		persistent_entity = (CPeristentEntity)receptor;

		for (i = 0; i < persistent_entity.onInteractionEventListeners.Size(); i += 1)
		{
			current_event_listener = persistent_entity.onInteractionEventListeners[i];

			should_event_continue = should_event_continue && current_event_listener.run(actionName, activator, persistent_entity);
		}
	}

	return should_event_continue;
}

function SU_NpcInteraction_hasEventListenerWithTag(npc : CPeristentEntity, tag : string) : bool
{
	var current_event_listener : SU_InteractionEventListener;
	var i : int;

	for (i = 0; i < npc.onInteractionEventListeners.Size(); i += 1)
	{
		current_event_listener = npc.onInteractionEventListeners[i];

		if (current_event_listener.tag == tag)
		{
			return true;
		}
	}
	return false;
}

function SU_removeInteractionEventListenerByTag(npc : CPeristentEntity, tag : string)
{
	var current_event_listener : SU_InteractionEventListener;
	var i : int;

	for (i = 0; i < npc.onInteractionEventListeners.Size(); i += 1)
	{
		current_event_listener = npc.onInteractionEventListeners[i];

		if (current_event_listener.tag != tag)
		{
			continue;
		}

		if (i == npc.onInteractionEventListeners.Size() - 1)
		{
			npc.onInteractionEventListeners.PopBack();
			continue;
		}

		npc.onInteractionEventListeners.Erase(i);
		i -= 1;
	}
}

latent function SUH_waitUntilInteraction(entity : CPeristentEntity)
{
	var listener : SU_StoreIfInteractedWith;

	listener = new SU_StoreIfInteractedWith in entity;

	entity.addInteractionEventListener(listener);

	listener.waitUntilActivated();
}

function SUOL_getManager() : SUOL_Manager
{
	SUOL_Logger("SUOL_getManager()");
	return theInput.getSharedutilsOnelinersManager();
}

function SUOL_Logger(message : string, optional informGUI : bool)
{
	LogChannel('SUOL', message);

	if (informGUI)
	{
		theGame.GetGuiManager().ShowNotification("SUOL: " + message, 5, true);
	}
}

exec function SUOL_deleteByTagPrefix(prefix : string)
{
	var output : array<SU_Oneliner>;

	output = SUOL_getManager().deleteByTagPrefix(prefix);
	SUOL_Logger("removed " + output.Size() + " oneliners");
}

exec function suol_example()
{
	SU_oneliner((new SUOL_TagBuilder in thePlayer).tag("font").attr("size", "32").attr("color", "#ff6655").text("Static OL"), thePlayer.GetWorldPosition() + Vector(0, 0, 1)).setRenderDistance(5);

	SU_onelinerScreen("Screen OL", Vector(0.5, 0.5));

	SU_onelinerEntity("Entity OL", thePlayer.GetHorseWithInventory());
}

function SUOL_worldToScreenPosition(hud : CR4ScriptedHud, world_position : Vector, out screen_position : Vector, out normalized_screen_position : Vector) : bool
{
	if (!theCamera.WorldVectorToViewRatio(world_position, normalized_screen_position.X, normalized_screen_position.Y))
	{
		return false;
	}

	normalized_screen_position.X = (normalized_screen_position.X + 1) / 2;
	normalized_screen_position.Y = (normalized_screen_position.Y + 1) / 2;

	screen_position = hud.GetScaleformPoint(normalized_screen_position.X, normalized_screen_position.Y);
	return true;
}

function SU_oneliner(text : string, position : Vector) : SU_Oneliner
{
	var oneliner : SU_Oneliner;

	oneliner = new SU_Oneliner in theInput;
	oneliner.text = text;
	oneliner.position = position;
	oneliner.register();
	return oneliner;
}

function SU_onelinerScreen(text : string, position : Vector) : SU_OnelinerScreen
{
	var oneliner : SU_OnelinerScreen;

	oneliner = new SU_OnelinerScreen in theInput;
	oneliner.text = text;
	oneliner.position = position;
	oneliner.register();
	return oneliner;
}

function SU_onelinerEntity(text : string, entity : CEntity) : SU_OnelinerEntity
{
	var oneliner : SU_OnelinerEntity;

	oneliner = new SU_OnelinerEntity in theInput;
	oneliner.text = text;
	oneliner.entity = entity;
	oneliner.register();
	return oneliner;
}

@wrapMethod(CActor)
function ReduceDamage(out damageData : W3DamageAction)
{
	wrappedMethod(damageData);
	SU_damageModifier(damageData);
}

@addField(CInputManager)
var sharedutils_oneliners : SUOL_Manager;

@addMethod(CInputManager)
function getSharedutilsOnelinersManager() : SUOL_Manager
{
	if (!this.sharedutils_oneliners)
	{
		SUOL_Logger("SUOL_getManager(), received null, instantiating instance");

		this.sharedutils_oneliners = new SUOL_Manager in this;
	}

	return this.sharedutils_oneliners;
}

@addMethod(CInputManager)
function newSharedutilsOnelinersManager()
{
	if (this.sharedutils_oneliners)
	{
		this.sharedutils_oneliners.deleteAllOneliners();
	}

	this.sharedutils_oneliners = new SUOL_Manager in this;
}

@wrapMethod(CInteractionComponent)
function OnInteraction(actionName : string, activator : CEntity)
{
	if (SU_NpcInteraction_runAllInteractionListeners(actionName, activator, this.GetEntity()))
	{
		return wrappedMethod(actionName, activator);
	}
	return false;
}

@addField(CNewNPC)
var sharedutils_damage_modifiers : array<SU_BaseDamageModifier>;

@addField(CPeristentEntity)
saved var onInteractionEventListeners : array<SU_InteractionEventListener>;

@addMethod(CPeristentEntity)
function addInteractionEventListener(event_listener : SU_InteractionEventListener)
{
	this.onInteractionEventListeners.PushBack(event_listener);
}

@wrapMethod(CR4Game)
function OnAfterLoadingScreenGameStart()
{
	wrappedMethod();
	theInput.newSharedutilsOnelinersManager();
}

@addField(CR4GlossaryBooksMenu)
var sharedutils_glossary_can_inject : bool;

@wrapMethod(CR4GlossaryBooksMenu)
function PopulateData()
{
	this.sharedutils_glossary_can_inject = true;
	wrappedMethod();
}

@wrapMethod(CR4GlossaryBooksMenu)
function PopulateListData(booksList : array<name>, out flashDataList : CScriptedFlashArray)
{
	wrappedMethod(booksList, flashDataList);

	if (this.sharedutils_glossary_can_inject)
	{
		SUG_populateListData(flashDataList, this.m_flashValueStorage);
		this.sharedutils_glossary_can_inject = false;
	}
}

@addField(CR4HudModuleDialog)
var dialog_hover_listeners : array<SU_DialogHoverListener>;

@addField(CR4HudModuleDialog)
var lastAcceptedChoice : SSceneChoice;

@addField(CR4HudModuleDialog)
var isAcceptedChoiceAvailable : bool;

@addField(CR4HudModuleDialog)
var responseListener : SU_DialogChoiceResponseListener;

@wrapMethod(CR4HudModuleDialog)
function OnDialogOptionSelected(index : int)
{
	var result : bool;

	result = wrappedMethod(index);
	SU_triggerEventListeners(this, this.lastSetChoices[index], index);
	return result;
}

@wrapMethod(CR4HudModuleDialog)
function OnDialogOptionAccepted(index : int)
{
	var listener : SU_DialogChoiceResponseListener;
	var acceptedChoice : SSceneChoice;

	acceptedChoice = lastSetChoices[index];

	this.lastAcceptedChoice = acceptedChoice;
	this.isAcceptedChoiceAvailable = true;

	if (this.responseListener)
	{
		listener = this.responseListener;
		this.responseListener = NULL;

		listener.onResponse(acceptedChoice, this.lastSetChoices, this);
	}

	return wrappedMethod(index);
}

@wrapMethod(CR4HudModuleMinimap2)
function OnConfigUI()
{
	SU_updateMinimapPins();
	return wrappedMethod();
}

@addField(CR4IngameMenu)
var su_menu_descriptors : array<SU_MenuDescriptor>;

@addField(CR4IngameMenu)
var su_menu_stack : array<string>;

@addField(CR4IngameMenu)
var su_menu_message_cache : string;

@addField(CR4IngameMenu)
var su_menu_message_fallback_cache : string;

@addField(CR4IngameMenu)
var su_menu_hovered_option : name;

@addField(CR4IngameMenu)
var su_menu_hovered_out_count : int;

@addMethod(CR4IngameMenu)
function SUMD_displayMessage(message : string)
{
	var duration : float;

	duration = -1;

	if (message == "")
	{
		if (this.su_menu_message_fallback_cache != "")
		{
			message = this.su_menu_message_fallback_cache;
		}
	}

	if (message == this.su_menu_message_cache)
	{
		return;
	}

	this.su_menu_message_cache = message;

	if (message == "")
	{
		duration = 0;
	}

	theGame.GetGuiManager().ShowNotification(message, duration);
}

@addMethod(CR4IngameMenu)
function SU_onMenuEntered(menu : string, out descriptors : array<SU_MenuDescriptor>);

@wrapMethod(CR4IngameMenu)
function OnShowOptionSubmenu(actionType : int, menuTag : int, id : string)
{
	var descriptor : SU_MenuDescriptor;
	var message_fallback : string;
	var previous_size : int;

	LogChannel('SUMD', "OnShowOptionSubmenu(), id=" + id);

	previous_size = this.su_menu_descriptors.Size();
	this.SU_onMenuEntered(id, this.su_menu_descriptors);

	for (previous_size; previous_size < this.su_menu_descriptors.Size(); previous_size += 1)
	{
		descriptor = this.su_menu_descriptors[previous_size];

		if (descriptor)
		{
			descriptor.enteredAt(id);
			descriptor.build();
		}
	}

	this.su_menu_stack.PushBack(id);

	for (previous_size = 0; previous_size < this.su_menu_descriptors.Size(); previous_size += 1)
	{
		descriptor = this.su_menu_descriptors[previous_size];

		if (descriptor)
		{
			message_fallback += descriptor.getMessageFallback();
		}
	}

	this.su_menu_message_fallback_cache = message_fallback;
	this.SUMD_displayMessage(message_fallback);
	return wrappedMethod(actionType, menuTag, id);
}

@wrapMethod(CR4IngameMenu)
function OnOptionPanelNavigateBack()
{
	var descriptor : SU_MenuDescriptor;
	var should_remove : bool;
	var menu_left : string;
	var i : int;

	this.su_menu_hovered_out_count = 0;
	this.su_menu_hovered_option = '';

	this.su_menu_message_fallback_cache = "";
	this.SUMD_displayMessage("");

	menu_left = this.su_menu_stack.PopBack();
	LogChannel('SUMD', "OnOptionPanelNavigateBack(), menu_left=" + menu_left);

	for (i = 0; i < this.su_menu_descriptors.Size(); i += 1)
	{
		descriptor = this.su_menu_descriptors[i];

		should_remove = true;
		if (descriptor)
		{
			should_remove = descriptor.didEnterAt(menu_left);
		}

		if (should_remove)
		{
			LogChannel('SUMD', "OnOptionPanelNavigateBack(), descriptor removed at index=" + i);
			this.su_menu_descriptors.Erase(i);
			i -= 1;
		}
	}
	return wrappedMethod();
}

@wrapMethod(CR4IngameMenu)
function OnOptionSelectionChanged(optionName : name, value : bool)
{
	var descriptor : SU_MenuDescriptor;
	var current_menu : string;
	var message : string;
	var result : bool;
	var i : int;

	result = wrappedMethod(optionName, value);

	if (!value)
	{
		if (optionName == this.su_menu_hovered_option || this.su_menu_hovered_out_count > 15)
		{
			this.SUMD_displayMessage("");
			return result;
		}

		this.su_menu_hovered_out_count += 1;

		optionName = this.su_menu_hovered_option;
		value = true;
	}
	else
	{
		this.su_menu_hovered_out_count = 0;
		this.su_menu_hovered_option = optionName;
	}

	LogChannel('SUMD', "OnOptionSelectionChanged(), optionName=" + optionName);

	current_menu = this.su_menu_stack.Last();
	for (i = 0; i < this.su_menu_descriptors.Size(); i += 1)
	{
		descriptor = this.su_menu_descriptors[i];

		message += descriptor.onOptionHovered(current_menu, optionName);
	}

	this.SUMD_displayMessage(message);
	return result;
}

@wrapMethod(CR4IngameMenu)
function OnOptionValueChanged(groupId : int, optionName : name, optionValue : string)
{
	var descriptor : SU_MenuDescriptor;
	var current_menu : string;
	var message : string;
	var result : bool;
	var i : int;

	result = wrappedMethod(groupId, optionName, optionValue);
	LogChannel('SUMD', "OnOptionValueChanged(), optionName=" + optionName);

	current_menu = this.su_menu_stack.Last();
	for (i = 0; i < this.su_menu_descriptors.Size(); i += 1)
	{
		descriptor = this.su_menu_descriptors[i];

		message += descriptor.onOptionValueChanged(current_menu, optionName);
	}

	if (message != "")
	{
		this.SUMD_displayMessage(message);
	}
	return result;
}

@wrapMethod(CR4MapMenu)
function UpdateUserMapPins(out flashArray : CScriptedFlashArray, indexToUpdate : int)
{
	wrappedMethod(flashArray, indexToUpdate);

	if (indexToUpdate <= -1)
	{
		SU_updateCustomMapPins(flashArray, GetMenuFlashValueStorage(), m_shownArea);
	}
}

@wrapMethod(CR4MapMenu)
function OnStaticMapPinUsed(pinTag : name, areaId : int)
{
	if (SUMP_onPinUsed(pinTag, areaId))
	{
		return true;
	}
	return wrappedMethod(pinTag, areaId);
}

@addField(CR4Player)
var sharedutils_glossary : SU_GlossaryManager;

@addField(CR4Player)
var sharedutils_mappins : SUMP_Manager;

@addField(CR4Player)
var sharedutilsNpcInteractionGlobalEventListener : SU_NpcInteraction_GlobalEventHandler;

@addMethod(CR4Player)
function getSharedutilsGlossaryManager() : SU_GlossaryManager
{
	if (!this.sharedutils_glossary)
	{
		this.sharedutils_glossary = new SU_GlossaryManager in this;
	}
	return this.sharedutils_glossary;
}

@addMethod(CR4Player)
function getSharedutilsMappinsManager() : SUMP_Manager
{
	if (!this.sharedutils_mappins)
	{
		SUMP_Logger("SUMP_getManager(), received null, instantiating instance");
		this.sharedutils_mappins = new SUMP_Manager in this;
	}

	return this.sharedutils_mappins;
}

@addMethod(CR4Player)
function SU_NpcInteraction_getGlobalEventListener() : SU_NpcInteraction_GlobalEventHandler
{
	if (!this.sharedutilsNpcInteractionGlobalEventListener)
	{
		this.sharedutilsNpcInteractionGlobalEventListener = (new SU_NpcInteraction_GlobalEventHandler in this).init();
	}

	return this.sharedutilsNpcInteractionGlobalEventListener;
}

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
