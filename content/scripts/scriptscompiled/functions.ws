// Decompiled from Desktop\precompiled.rsblob by W3 Mod Workbench
// Compiled with REDkit build 1048625 (Release, x64)
// Comments, formatting and variable initialisers are not kept in compiled scripts.

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
