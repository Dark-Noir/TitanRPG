class WeaponModifier_NullEntropy extends RPGWeaponModifier;

var localized string NullEntropyText;

function AdjustTargetDamage(out int Damage, int OriginalDamage, Pawn Injured, vector HitLocation, out vector Momentum, class<DamageType> DamageType)
{
	local RPGEffect Effect;

	Super.AdjustTargetDamage(Damage, OriginalDamage, Injured, HitLocation, Momentum, DamageType);
	
	if(Damage > 0)
	{
		Effect = class'Effect_NullEntropy'.static.Create(
			Injured,
			Instigator.Controller,
			FMax(1.0f, BonusPerLevel * float(Modifier)));
		
		if(Effect != None)
		{
			Identify();
			
			Momentum = vect(0, 0, 0);
			Effect.Start();
		}
	}
}

simulated function BuildDescription()
{
	Super.BuildDescription();
	AddToDescription(NullEntropyText);
}

defaultproperties
{
	BonusPerLevel=0.333333
	NullEntropyText="immobilizes human targets"
	DamageBonus=0.05
	MinModifier=3
	MaxModifier=6
	ModifierOverlay=Shader'MutantSkins.Shaders.MutantGlowShader'
	PatternPos="$W of Null Entropy"
	//AI
	AIRatingBonus=0.075
}
