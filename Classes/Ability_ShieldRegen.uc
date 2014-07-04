class Ability_ShieldRegen extends RPGAbility;

var config float ShieldRegenInterval;
var config int NoDamageDelay; //intervals that you must not have taken any damage
var config int MaxShieldPerLevel;
var config int RegenPerLevel;

var int LastHealth, LastShield, ElapsedNoDamage;

replication
{
	reliable if(Role == ROLE_Authority)
		ShieldRegenInterval, NoDamageDelay, MaxShieldPerLevel, RegenPerLevel;
}

function ModifyPawn(Pawn Other)
{
	Super.ModifyPawn(Other);

	SetTimer(ShieldRegenInterval, true);
}

function Timer()
{
	local int NewHealth, NewShield;
	local int AmountToAdd, RegenPossible;

	if(Instigator == None || Instigator.Health <= 0)
	{
		SetTimer(0.0f, false);
		return;
	}

	NewHealth = Instigator.Health;
	NewShield = Instigator.GetShieldStrength();
	
	if(LastHealth > NewHealth || LastShield > NewShield)
		ElapsedNoDamage = 0;
	else
		ElapsedNoDamage++;
	
	RegenPossible = MaxShieldPerLevel * AbilityLevel - NewShield;
	if(RegenPossible > 0 && ElapsedNoDamage > NoDamageDelay)
	{
		Instigator.AddShieldStrength(Min(1, RegenPossible));
	} 

	LastHealth = NewHealth;
}

simulated function string DescriptionText()
{
	return repl(
                repl(Super.DescriptionText(), "$1", BonusPerLevel),
            "$2", MaxShieldPerLevel);
}

defaultproperties
{
	ShieldRegenInterval=1.00
	MaxShieldPerLevel=10
	NoDamageDelay=1
	BonusPerLevel=1
	AbilityName="Shield Regeneration"
	Description="Regenerates 1 shield per second up to two times per level, provided you haven't suffered damage recently."
	MaxLevel=6
	StartingCost=5
	CostAddPerLevel=5
	Category=class'AbilityCategory_Health'
}
