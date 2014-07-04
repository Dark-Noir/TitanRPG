class Ability_Regen extends RPGAbility;

var config float RegenInterval;

function ModifyPawn(Pawn Other)
{
	Super.ModifyPawn(Other);
	SetTimer(25 - (AbilityLevel / 4), true);
}

function Timer()
{
	if(Instigator == None || Instigator.Health <= 0)
	{
		SetTimer(0.0f, false);
		return;
	}
	
	Instigator.GiveHealth(int(BonusPerLevel), Instigator.HealthMax);
}

//TODO: Dynamic description

defaultproperties
{
	BonusPerLevel=1
	RegenInterval=1.000000

	AbilityName="Regeneration"
	Description="Heals 1 health every 25 seconds, per level it regenerates 0.25 seconds faster.|Does not heal past starting health amount."
	StartingCost=5
	CostAddPerLevel=5
	MaxLevel=6
	Category=class'AbilityCategory_Health'
}
