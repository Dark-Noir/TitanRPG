class RPGTotem extends ASVehicle abstract placeable
    config(TitanRPG);

var class<RPGTotemIcon> IconClass;

var Material TeamSkins[4];
var Material DeadSkin;

var float IconOffZ;
var vector IconLocation;
var RPGTotemIcon Icon;

replication {
    reliable if(Role == ROLE_Authority && bNetDirty)
        Icon;
}

simulated event PostBeginPlay() {
    Super.PostBeginPlay();
    
    IconLocation = Location + IconOffZ * vect(0, 0, 1);
    if(Role == ROLE_Authority && IconClass != None) {
        Icon = Spawn(IconClass, Self,, IconLocation);
    }
}

simulated event TeamChanged() {
    local int i;
    
    if(Team >= 0 && Team <= 3) {
        i = Team;
    } else {
        i = 0;
    }
    
    Skins[0] = TeamSkins[Team];
    RepSkin = TeamSkins[Team];
}

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation) {
    local Controller C;
    
    Skins[0] = DeadSkin;
    RepSkin = DeadSkin;
    
    if(Controller != None) {
        C = Controller;
        C.WasKilledBy(Killer);
        Level.Game.Killed(Killer, C, self, damageType);
        C.Destroy();
    }

	if(Killer != None) {
		TriggerEvent(Event, Self, Killer.Pawn);
	} else {
		TriggerEvent(Event, Self, None);
    }
    
    if(Icon != None) {
        Icon.Destroy();
    }
    
    PlayDying(DamageType, HitLocation);
    ClientDying(DamageType, HitLocation);
    
    GotoState('Dying');
}

defaultproperties {
    //Settings
    SightRadius=1024
    
	Health=250
	HealthMax=250
    
    IconOffZ=160
    
    //Custom
    Physics=PHYS_None
    
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'TitanRPG.Totem.TotemStatic'

    TeamSkins[0]=None //original is red
    TeamSkins[1]=Shader'TitanRPG.Totem.BlueShader'
    TeamSkins[2]=Shader'TitanRPG.Totem.GreenShader'
    TeamSkins[3]=Shader'TitanRPG.Totem.GoldShader'
    DeadSkin=Shader'cp_Evilmetal.plainmetal.cp_plainmet4_Shiny'
    
	bAutoTurret=true
	AutoTurretControllerClass=class'RPGTotemController'
    
    //From ASVehicle_Sentinel
	TransientSoundVolume=0.75
	TransientSoundRadius=512
	bNetNotify=true

	bSimulateGravity=false
	AirSpeed=0.0
	WaterSpeed=0.0
	AccelRate=0.0
	JumpZ=0.0
	MaxFallSpeed=0.0

	bIgnoreEncroachers=true
    bCollideWorld=false
    
	bIgnoreForces=true
	bShouldBaseAtStartup=false
	bNonHumanControl=true
	bDefensive=true
	bStationary=true
	VehicleNameString="Totem"
    
    bNoTeamBeacon=true

    //From ASTurret
	bPathColliding=true
    
    RemoteRole=ROLE_SimulatedProxy
    
	bSpecialCalcView=true
	bSpecialHUD=true

	FPCamPos=(X=0,Y=0,Z=40)
    
    AmbientGlow=64

	bUseCylinderCollision=false
    
    bRemoteControlled=true
    bDesiredBehindView=false
}