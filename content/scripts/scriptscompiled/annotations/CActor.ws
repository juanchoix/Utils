// Decompiled from Desktop\precompiled.rsblob by W3 Mod Workbench
// Compiled with REDkit build 1048625 (Release, x64)
// Comments, formatting and variable initialisers are not kept in compiled scripts.

@wrapMethod(CActor)
function ReduceDamage(out damageData : W3DamageAction)
{
	wrappedMethod(damageData);
	SU_damageModifier(damageData);
}
