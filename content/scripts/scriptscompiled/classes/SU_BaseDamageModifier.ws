// Decompiled from Desktop\precompiled.rsblob by W3 Mod Workbench
// Compiled with REDkit build 1048625 (Release, x64)
// Comments, formatting and variable initialisers are not kept in compiled scripts.

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
