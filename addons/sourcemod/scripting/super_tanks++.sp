#include <super_tanks++>
#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo =
{
	name = ST_NAME,
	author = ST_AUTHOR,
	description = ST_DESCRIPTION,
	version = ST_VERSION,
	url = ST_URL
};

bool g_bAFK[MAXPLAYERS + 1];
bool g_bBlind[MAXPLAYERS + 1];
bool g_bBury[MAXPLAYERS + 1];
bool g_bCmdUsed;
bool g_bDrug[MAXPLAYERS + 1];
bool g_bFlash[MAXPLAYERS + 1];
bool g_bGeneralConfig;
bool g_bGhost[MAXPLAYERS + 1];
bool g_bGravity[MAXPLAYERS + 1];
bool g_bGravity2[MAXPLAYERS + 1];
bool g_bHeal[MAXPLAYERS + 1];
bool g_bHurt[MAXPLAYERS + 1];
bool g_bHypno[MAXPLAYERS + 1];
bool g_bIce[MAXPLAYERS + 1];
bool g_bIdle[MAXPLAYERS + 1];
bool g_bInvert[MAXPLAYERS + 1];
bool g_bLateLoad;
bool g_bMeteor[MAXPLAYERS + 1];
bool g_bNullify[MAXPLAYERS + 1];
bool g_bPyro[MAXPLAYERS + 1];
bool g_bRestartValid;
bool g_bShake[MAXPLAYERS + 1];
bool g_bShielded[MAXPLAYERS + 1];
bool g_bShove[MAXPLAYERS + 1];
bool g_bSpam[MAXPLAYERS + 1];
bool g_bStun[MAXPLAYERS + 1];
bool g_bTankConfig[MAXTYPES + 1];
bool g_bVision[MAXPLAYERS + 1];
bool g_bWarp[MAXPLAYERS + 1];
char g_sConfigCreate[6];
char g_sConfigExecute[6];
char g_sCustomName[MAXTYPES + 1][33];
char g_sCustomName2[MAXTYPES + 1][33];
char g_sDisabledGameModes[2112];
char g_sEnabledGameModes[2112];
char g_sInfectedOptions[MAXTYPES + 1][15];
char g_sLoadout[MAXTYPES + 1][325];
char g_sParticleEffects[MAXTYPES + 1][8];
char g_sPropsAttached[MAXTYPES + 1][6];
char g_sPropsChance[MAXTYPES + 1][10];
char g_sPropsColors[MAXTYPES + 1][80];
char g_sInfectedOptions2[MAXTYPES + 1][15];
char g_sLoadout2[MAXTYPES + 1][325];
char g_sParticleEffects2[MAXTYPES + 1][8];
char g_sPropsAttached2[MAXTYPES + 1][6];
char g_sPropsChance2[MAXTYPES + 1][10];
char g_sPropsColors2[MAXTYPES + 1][80];
char g_sSavePath[255];
char g_sShieldColor[MAXTYPES + 1][12];
char g_sTankColors[MAXTYPES + 1][28];
char g_sTankWaves[12];
char g_sShieldColor2[MAXTYPES + 1][12];
char g_sTankColors2[MAXTYPES + 1][28];
char g_sTankWaves2[12];
char g_sWeaponSlot[MAXTYPES + 1][6];
char g_sWeaponSlot2[MAXTYPES + 1][6];
ConVar g_cvSTFindConVar[12];
float g_flBlindDuration[MAXTYPES + 1];
float g_flBuryDuration[MAXTYPES + 1];
float g_flBuryHeight[MAXTYPES + 1];
float g_flBlindDuration2[MAXTYPES + 1];
float g_flBuryDuration2[MAXTYPES + 1];
float g_flBuryHeight2[MAXTYPES + 1];
float g_flDrugAngles[20] = {0.0, 5.0, 10.0, 15.0, 20.0, 25.0, 20.0, 15.0, 10.0, 5.0, 0.0, -5.0, -10.0, -15.0, -20.0, -25.0, -20.0, -15.0, -10.0, -5.0};
float g_flDrugDuration[MAXTYPES + 1];
float g_flFlashSpeed[MAXTYPES + 1];
float g_flGravityDuration[MAXTYPES + 1];
float g_flGravityForce[MAXTYPES + 1];
float g_flGravityValue[MAXTYPES + 1];
float g_flHealInterval[MAXTYPES + 1];
float g_flHurtDuration[MAXTYPES + 1];
float g_flHypnoDuration[MAXTYPES + 1];
float g_flDrugDuration2[MAXTYPES + 1];
float g_flFlashSpeed2[MAXTYPES + 1];
float g_flGravityDuration2[MAXTYPES + 1];
float g_flGravityForce2[MAXTYPES + 1];
float g_flGravityValue2[MAXTYPES + 1];
float g_flHealInterval2[MAXTYPES + 1];
float g_flHurtDuration2[MAXTYPES + 1];
float g_flHypnoDuration2[MAXTYPES + 1];
float g_flInvertDuration[MAXTYPES + 1];
float g_flMeteorDamage[MAXTYPES + 1];
float g_flNullifyDuration[MAXTYPES + 1];
float g_flPyroBoost[MAXTYPES + 1];
float g_flRunSpeed[MAXTYPES + 1];
float g_flShakeDuration[MAXTYPES + 1];
float g_flShieldDelay[MAXTYPES + 1];
float g_flShoveDuration[MAXTYPES + 1];
float g_flSpamInterval[MAXTYPES + 1];
float g_flInvertDuration2[MAXTYPES + 1];
float g_flMeteorDamage2[MAXTYPES + 1];
float g_flNullifyDuration2[MAXTYPES + 1];
float g_flPyroBoost2[MAXTYPES + 1];
float g_flRunSpeed2[MAXTYPES + 1];
float g_flShakeDuration2[MAXTYPES + 1];
float g_flShieldDelay2[MAXTYPES + 1];
float g_flShoveDuration2[MAXTYPES + 1];
float g_flSpamInterval2[MAXTYPES + 1];
float g_flSpawnPosition[3];
float g_flStunDuration[MAXTYPES + 1];
float g_flStunSpeed[MAXTYPES + 1];
float g_flThrowInterval[MAXTYPES + 1];
float g_flVisionDuration[MAXTYPES + 1];
float g_flWarpInterval[MAXTYPES + 1];
float g_flWitchDamage[MAXTYPES + 1];
float g_flStunDuration2[MAXTYPES + 1];
float g_flStunSpeed2[MAXTYPES + 1];
float g_flThrowInterval2[MAXTYPES + 1];
float g_flVisionDuration2[MAXTYPES + 1];
float g_flWarpInterval2[MAXTYPES + 1];
float g_flWitchDamage2[MAXTYPES + 1];
Handle g_hSDKAcidPlayer;
Handle g_hSDKFlingPlayer;
Handle g_hSDKHealPlayer;
Handle g_hSDKIdlePlayer;
Handle g_hSDKPukePlayer;
Handle g_hSDKRespawnPlayer;
Handle g_hSDKRevivePlayer;
Handle g_hSDKShovePlayer;
Handle g_hSDKSpecPlayer;
int g_iAbsorbAbility[MAXTYPES + 1];
int g_iAcidChance[MAXTYPES + 1];
int g_iAcidHit[MAXTYPES + 1];
int g_iAcidRock[MAXTYPES + 1];
int g_iAlpha[MAXPLAYERS + 1];
int g_iAmmoChance[MAXTYPES + 1];
int g_iAmmoCount[MAXTYPES + 1];
int g_iAmmoHit[MAXTYPES + 1];
int g_iAnnounceArrival;
int g_iBlindChance[MAXTYPES + 1];
int g_iBlindHit[MAXTYPES + 1];
int g_iBlindIntensity[MAXTYPES + 1];
int g_iBombChance[MAXTYPES + 1];
int g_iBombHit[MAXTYPES + 1];
int g_iBombRock[MAXTYPES + 1];
int g_iBulletImmunity[MAXTYPES + 1];
int g_iBuryChance[MAXTYPES + 1];
int g_iBuryHit[MAXTYPES + 1];
int g_iCarThrow[MAXTYPES + 1];
int g_iCommonAbility[MAXTYPES + 1];
int g_iCommonAmount[MAXTYPES + 1];
int g_iAbsorbAbility2[MAXTYPES + 1];
int g_iAcidChance2[MAXTYPES + 1];
int g_iAcidHit2[MAXTYPES + 1];
int g_iAcidRock2[MAXTYPES + 1];
int g_iAmmoChance2[MAXTYPES + 1];
int g_iAmmoCount2[MAXTYPES + 1];
int g_iAmmoHit2[MAXTYPES + 1];
int g_iAnnounceArrival2;
int g_iBlindChance2[MAXTYPES + 1];
int g_iBlindHit2[MAXTYPES + 1];
int g_iBlindIntensity2[MAXTYPES + 1];
int g_iBombChance2[MAXTYPES + 1];
int g_iBombHit2[MAXTYPES + 1];
int g_iBombRock2[MAXTYPES + 1];
int g_iBulletImmunity2[MAXTYPES + 1];
int g_iBuryChance2[MAXTYPES + 1];
int g_iBuryHit2[MAXTYPES + 1];
int g_iCarThrow2[MAXTYPES + 1];
int g_iCommonAbility2[MAXTYPES + 1];
int g_iCommonAmount2[MAXTYPES + 1];
int g_iConfigEnable;
int g_iDisplayHealth;
int g_iDrugChance[MAXTYPES + 1];
int g_iDrugHit[MAXTYPES + 1];
int g_iDisplayHealth2;
int g_iDrugChance2[MAXTYPES + 1];
int g_iDrugHit2[MAXTYPES + 1];
int g_iExplosionSprite = -1;
int g_iExplosiveImmunity[MAXTYPES + 1];
int g_iExtraHealth[MAXTYPES + 1];
int g_iFinalesOnly;
int g_iFireChance[MAXTYPES + 1];
int g_iFireHit[MAXTYPES + 1];
int g_iFireImmunity[MAXTYPES + 1];
int g_iFireRock[MAXTYPES + 1];
int g_iFlashAbility[MAXTYPES + 1];
int g_iFlashChance[MAXTYPES + 1];
int g_iFlingChance[MAXTYPES + 1];
int g_iFlingHit[MAXTYPES + 1];
int g_iGhostAbility[MAXTYPES + 1];
int g_iGhostChance[MAXTYPES + 1];
int g_iGhostFade[MAXTYPES + 1];
int g_iGhostHit[MAXTYPES + 1];
int g_iGlowEffect[MAXTYPES + 1];
int g_iGravityAbility[MAXTYPES + 1];
int g_iGravityChance[MAXTYPES + 1];
int g_iGravityHit[MAXTYPES + 1];
int g_iHealAbility[MAXTYPES + 1];
int g_iHealChance[MAXTYPES + 1];
int g_iHealCommon[MAXTYPES + 1];
int g_iHealHit[MAXTYPES + 1];
int g_iHealSpecial[MAXTYPES + 1];
int g_iHealTank[MAXTYPES + 1];
int g_iHumanSupport;
int g_iHurtAbility[MAXTYPES + 1];
int g_iHurtChance[MAXTYPES + 1];
int g_iHurtDamage[MAXTYPES + 1];
int g_iHypnoChance[MAXTYPES + 1];
int g_iHypnoHit[MAXTYPES + 1];
int g_iHypnoMode[MAXTYPES + 1];
int g_iIceChance[MAXTYPES + 1];
int g_iIceHit[MAXTYPES + 1];
int g_iIdleChance[MAXTYPES + 1];
int g_iIdleHit[MAXTYPES + 1];
int g_iInfectedThrow[MAXTYPES + 1];
int g_iInvertChance[MAXTYPES + 1];
int g_iInvertHit[MAXTYPES + 1];
int g_iJumperAbility[MAXTYPES + 1];
int g_iJumperChance[MAXTYPES + 1];
int g_iMaxTypes;
int g_iMeleeImmunity[MAXTYPES + 1];
int g_iMeteorAbility[MAXTYPES + 1];
int g_iMeteorChance[MAXTYPES + 1];
int g_iMultiHealth;
int g_iNullifyChance[MAXTYPES + 1];
int g_iNullifyHit[MAXTYPES + 1];
int g_iPanicChance[MAXTYPES + 1];
int g_iPanicHit[MAXTYPES + 1];
int g_iParticleEffect[MAXTYPES + 1];
int g_iPluginEnabled;
int g_iPukeChance[MAXTYPES + 1];
int g_iPukeHit[MAXTYPES + 1];
int g_iPyroAbility[MAXTYPES + 1];
int g_iRestartChance[MAXTYPES + 1];
int g_iRestartHit[MAXTYPES + 1];
int g_iRocket[MAXTYPES + 1];
int g_iRocketChance[MAXTYPES + 1];
int g_iRocketHit[MAXTYPES + 1];
int g_iSelfThrow[MAXTYPES + 1];
int g_iShakeChance[MAXTYPES + 1];
int g_iShakeHit[MAXTYPES + 1];
int g_iShieldAbility[MAXTYPES + 1];
int g_iShoveChance[MAXTYPES + 1];
int g_iShoveHit[MAXTYPES + 1];
int g_iSlugChance[MAXTYPES + 1];
int g_iSlugHit[MAXTYPES + 1];
int g_iExplosiveImmunity2[MAXTYPES + 1];
int g_iExtraHealth2[MAXTYPES + 1];
int g_iFinalesOnly2;
int g_iFireChance2[MAXTYPES + 1];
int g_iFireHit2[MAXTYPES + 1];
int g_iFireImmunity2[MAXTYPES + 1];
int g_iFireRock2[MAXTYPES + 1];
int g_iFlashAbility2[MAXTYPES + 1];
int g_iFlashChance2[MAXTYPES + 1];
int g_iFlingChance2[MAXTYPES + 1];
int g_iFlingHit2[MAXTYPES + 1];
int g_iGhostAbility2[MAXTYPES + 1];
int g_iGhostChance2[MAXTYPES + 1];
int g_iGhostFade2[MAXTYPES + 1];
int g_iGhostHit2[MAXTYPES + 1];
int g_iGlowEffect2[MAXTYPES + 1];
int g_iGravityAbility2[MAXTYPES + 1];
int g_iGravityChance2[MAXTYPES + 1];
int g_iGravityHit2[MAXTYPES + 1];
int g_iHealAbility2[MAXTYPES + 1];
int g_iHealChance2[MAXTYPES + 1];
int g_iHealCommon2[MAXTYPES + 1];
int g_iHealHit2[MAXTYPES + 1];
int g_iHealSpecial2[MAXTYPES + 1];
int g_iHealTank2[MAXTYPES + 1];
int g_iHumanSupport2;
int g_iHurtAbility2[MAXTYPES + 1];
int g_iHurtChance2[MAXTYPES + 1];
int g_iHurtDamage2[MAXTYPES + 1];
int g_iHypnoChance2[MAXTYPES + 1];
int g_iHypnoHit2[MAXTYPES + 1];
int g_iHypnoMode2[MAXTYPES + 1];
int g_iIceChance2[MAXTYPES + 1];
int g_iIceHit2[MAXTYPES + 1];
int g_iIdleChance2[MAXTYPES + 1];
int g_iIdleHit2[MAXTYPES + 1];
int g_iInfectedThrow2[MAXTYPES + 1];
int g_iInvertChance2[MAXTYPES + 1];
int g_iInvertHit2[MAXTYPES + 1];
int g_iJumperAbility2[MAXTYPES + 1];
int g_iJumperChance2[MAXTYPES + 1];
int g_iMaxTypes2;
int g_iMeleeImmunity2[MAXTYPES + 1];
int g_iMeteorAbility2[MAXTYPES + 1];
int g_iMeteorChance2[MAXTYPES + 1];
int g_iMultiHealth2;
int g_iNullifyChance2[MAXTYPES + 1];
int g_iNullifyHit2[MAXTYPES + 1];
int g_iPanicChance2[MAXTYPES + 1];
int g_iPanicHit2[MAXTYPES + 1];
int g_iParticleEffect2[MAXTYPES + 1];
int g_iPluginEnabled2;
int g_iPukeChance2[MAXTYPES + 1];
int g_iPukeHit2[MAXTYPES + 1];
int g_iPyroAbility2[MAXTYPES + 1];
int g_iRestartChance2[MAXTYPES + 1];
int g_iRestartHit2[MAXTYPES + 1];
int g_iRocketChance2[MAXTYPES + 1];
int g_iRocketHit2[MAXTYPES + 1];
int g_iSelfThrow2[MAXTYPES + 1];
int g_iShakeChance2[MAXTYPES + 1];
int g_iShakeHit2[MAXTYPES + 1];
int g_iShieldAbility2[MAXTYPES + 1];
int g_iShoveChance2[MAXTYPES + 1];
int g_iShoveHit2[MAXTYPES + 1];
int g_iSlugChance2[MAXTYPES + 1];
int g_iSlugHit2[MAXTYPES + 1];
int g_iSlugSprite = -1;
int g_iSpamAbility[MAXTYPES + 1];
int g_iSpamAmount[MAXTYPES + 1];
int g_iSpamCount[MAXPLAYERS + 1];
int g_iSpamDamage[MAXTYPES + 1];
int g_iSpawnInterval[MAXPLAYERS + 1];
int g_iStunChance[MAXTYPES + 1];
int g_iStunHit[MAXTYPES + 1];
int g_iTankEnabled[MAXTYPES + 1];
int g_iTankType[MAXTYPES + 1];
int g_iSpamAbility2[MAXTYPES + 1];
int g_iSpamAmount2[MAXTYPES + 1];
int g_iSpamDamage2[MAXTYPES + 1];
int g_iStunChance2[MAXTYPES + 1];
int g_iStunHit2[MAXTYPES + 1];
int g_iTankEnabled2[MAXTYPES + 1];
int g_iTankWave;
int g_iType;
int g_iVampireChance[MAXTYPES + 1];
int g_iVampireHealth[MAXTYPES + 1];
int g_iVampireHit[MAXTYPES + 1];
int g_iVisionChance[MAXTYPES + 1];
int g_iVisionFOV[MAXTYPES + 1];
int g_iVisionHit[MAXTYPES + 1];
int g_iWarpAbility[MAXTYPES + 1];
int g_iWitchAbility[MAXTYPES + 1];
int g_iWitchAmount[MAXTYPES + 1];
int g_iVampireChance2[MAXTYPES + 1];
int g_iVampireHealth2[MAXTYPES + 1];
int g_iVampireHit2[MAXTYPES + 1];
int g_iVisionChance2[MAXTYPES + 1];
int g_iVisionFOV2[MAXTYPES + 1];
int g_iVisionHit2[MAXTYPES + 1];
int g_iWarpAbility2[MAXTYPES + 1];
int g_iWitchAbility2[MAXTYPES + 1];
int g_iWitchAmount2[MAXTYPES + 1];
TopMenu g_tmSTMenu;
UserMsg g_umFadeUserMsgId;

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	EngineVersion evEngine = GetEngineVersion();
	if (evEngine != Engine_Left4Dead && evEngine != Engine_Left4Dead2)
	{
		strcopy(error, err_max, "Super Tanks++ only supports Left 4 Dead 1 & 2.");
		return APLRes_SilentFailure;
	}
	g_bLateLoad = late;
	return APLRes_Success;
}

public void OnPluginStart()
{
	CreateDirectory("cfg/sourcemod/super_tanks++/", 511);
	vCreateConfigFile("cfg/sourcemod/", "super_tanks++/", "super_tanks++", "super_tanks++", true);
	Format(g_sSavePath, sizeof(g_sSavePath), "cfg/sourcemod/super_tanks++/super_tanks++.cfg");
	vLoadConfigs(g_sSavePath, true);
	vMultiTargetFilters(1);
	RegAdminCmd("sm_tank", cmdTank, ADMFLAG_ROOT, "Spawn a Super Tank.");
	CreateConVar("st_pluginversion", ST_VERSION, "Super Tanks++ Version", FCVAR_NOTIFY|FCVAR_DONTRECORD);
	g_cvSTFindConVar[0] = FindConVar("z_difficulty");
	g_cvSTFindConVar[1] = FindConVar("mp_gamemode");
	g_cvSTFindConVar[2] = FindConVar("sv_gametypes");
	g_cvSTFindConVar[3] = FindConVar("survivor_max_incapacitated_count");
	bIsL4D2Game() ? (g_cvSTFindConVar[4] = FindConVar("z_smoker_limit")) : (g_cvSTFindConVar[4] = FindConVar("z_gas_limit"));
	bIsL4D2Game() ? (g_cvSTFindConVar[5] = FindConVar("z_boomer_limit")) : (g_cvSTFindConVar[5] = FindConVar("z_exploding_limit"));
	g_cvSTFindConVar[6] = FindConVar("z_hunter_limit");
	if (bIsL4D2Game())
	{
		g_cvSTFindConVar[7] = FindConVar("z_spitter_limit");
		g_cvSTFindConVar[8] = FindConVar("z_jockey_limit");
		g_cvSTFindConVar[9] = FindConVar("z_charger_limit");
	}
	g_cvSTFindConVar[10] = FindConVar("z_max_player_zombies");
	g_cvSTFindConVar[11] = FindConVar("z_tank_throw_force");
	g_cvSTFindConVar[0].AddChangeHook(vSTGameDifficultyCvar);
	HookEvent("ability_use", eEventAbilityUse);
	HookEvent("finale_escape_start", eEventFinaleEscapeStart);
	HookEvent("finale_start", eEventFinaleStart, EventHookMode_Pre);
	HookEvent("finale_vehicle_leaving", eEventFinaleVehicleLeaving);
	HookEvent("finale_vehicle_ready", eEventFinaleVehicleReady);
	HookEvent("player_afk", eEventPlayerAFK, EventHookMode_Pre);
	HookEvent("player_bot_replace", eEventPlayerBotReplace);
	HookEvent("player_death", eEventPlayerDeath);
	HookEvent("round_start", eEventRoundStart);
	HookEvent("tank_spawn", eEventTankSpawn);
	Handle hGameData = LoadGameConfigFile("super_tanks++");
	if (bIsL4D2Game())
	{
		StartPrepSDKCall(SDKCall_Static);
		PrepSDKCall_SetFromConf(hGameData, SDKConf_Signature, "CSpitterProjectile_Create");
		PrepSDKCall_AddParameter(SDKType_Vector, SDKPass_ByRef);
		PrepSDKCall_AddParameter(SDKType_Vector, SDKPass_ByRef);
		PrepSDKCall_AddParameter(SDKType_Vector, SDKPass_ByRef);
		PrepSDKCall_AddParameter(SDKType_Vector, SDKPass_ByRef);
		PrepSDKCall_AddParameter(SDKType_CBasePlayer, SDKPass_Pointer);
		PrepSDKCall_AddParameter(SDKType_Float, SDKPass_Plain);
		PrepSDKCall_SetReturnInfo(SDKType_CBaseEntity, SDKPass_Pointer);
		g_hSDKAcidPlayer = EndPrepSDKCall();
		if (g_hSDKAcidPlayer == null)
		{
			PrintToServer("%s Your \"CSpitterProjectile_Create\" signature is outdated.", ST_PREFIX);
		}
		StartPrepSDKCall(SDKCall_Player);
		PrepSDKCall_SetFromConf(hGameData, SDKConf_Signature, "CTerrorPlayer_Fling");
		PrepSDKCall_AddParameter(SDKType_Vector, SDKPass_ByRef);
		PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
		PrepSDKCall_AddParameter(SDKType_CBasePlayer, SDKPass_Pointer);
		PrepSDKCall_AddParameter(SDKType_Float, SDKPass_Plain);
		g_hSDKFlingPlayer = EndPrepSDKCall();
		if (g_hSDKFlingPlayer == null)
		{
			PrintToServer("%s Your \"CTerrorPlayer_Fling\" signature is outdated.", ST_PREFIX);
		}
	}
	StartPrepSDKCall(SDKCall_Player);
	PrepSDKCall_SetFromConf(hGameData, SDKConf_Signature, "CTerrorPlayer_SetHealthBuffer");
	PrepSDKCall_AddParameter(SDKType_Float, SDKPass_Plain);
	g_hSDKHealPlayer = EndPrepSDKCall();
	if (g_hSDKHealPlayer == null)
	{
		PrintToServer("%s Your \"CTerrorPlayer_SetHealthBuffer\" signature is outdated.", ST_PREFIX);
	}
	StartPrepSDKCall(SDKCall_Player);
	PrepSDKCall_SetFromConf(hGameData, SDKConf_Signature, "CTerrorPlayer_OnRevived");
	g_hSDKRevivePlayer = EndPrepSDKCall();
	if (g_hSDKRevivePlayer == null)
	{
		PrintToServer("%s Your \"CTerrorPlayer_OnRevived\" signature is outdated.", ST_PREFIX);
	}
	StartPrepSDKCall(SDKCall_Player);
	PrepSDKCall_SetFromConf(hGameData, SDKConf_Signature, "CTerrorPlayer::GoAwayFromKeyboard");
	g_hSDKIdlePlayer = EndPrepSDKCall();
	if (g_hSDKIdlePlayer == null)
	{
		PrintToServer("%s Your \"CTerrorPlayer::GoAwayFromKeyboard\" signature is outdated.", ST_PREFIX);
	}
	StartPrepSDKCall(SDKCall_Player);
	PrepSDKCall_SetFromConf(hGameData, SDKConf_Signature, "SetHumanSpec");
	PrepSDKCall_AddParameter(SDKType_CBasePlayer, SDKPass_Pointer);
	g_hSDKSpecPlayer = EndPrepSDKCall();
	if (g_hSDKSpecPlayer == null)
	{
		PrintToServer("%s Your \"SetHumanSpec\" signature is outdated.", ST_PREFIX);
	}
	StartPrepSDKCall(SDKCall_Player);
	PrepSDKCall_SetFromConf(hGameData, SDKConf_Signature, "CTerrorPlayer_OnVomitedUpon");
	PrepSDKCall_AddParameter(SDKType_CBasePlayer, SDKPass_Pointer);
	PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
	g_hSDKPukePlayer = EndPrepSDKCall();
	if (g_hSDKPukePlayer == null)
	{
		PrintToServer("%s Your \"CTerrorPlayer_OnVomitedUpon\" signature is outdated.", ST_PREFIX);
	}
	StartPrepSDKCall(SDKCall_Player);
	PrepSDKCall_SetFromConf(hGameData, SDKConf_Signature, "RoundRespawn");
	g_hSDKRespawnPlayer = EndPrepSDKCall();
	if (g_hSDKRespawnPlayer == null)
	{
		PrintToServer("%s Your \"RoundRespawn\" signature is outdated.", ST_PREFIX);
	}
	StartPrepSDKCall(SDKCall_Player);
	PrepSDKCall_SetFromConf(hGameData, SDKConf_Signature, "CTerrorPlayer_OnStaggered");
	PrepSDKCall_AddParameter(SDKType_CBaseEntity, SDKPass_Pointer);
	PrepSDKCall_AddParameter(SDKType_Vector, SDKPass_Pointer);
	g_hSDKShovePlayer = EndPrepSDKCall();
	if (g_hSDKShovePlayer == null)
	{
		PrintToServer("%s Your \"CTerrorPlayer_OnStaggered\" signature is outdated.", ST_PREFIX);
	}
	delete hGameData;
	TopMenu tmAdminMenu;
	if (LibraryExists("adminmenu") && ((tmAdminMenu = GetAdminTopMenu()) != null))
	{
		OnAdminMenuReady(tmAdminMenu);
	}
	g_umFadeUserMsgId = GetUserMessageId("Fade");
}

public void OnMapStart()
{
	PrecacheModel(MODEL_CAR, true);
	PrecacheModel(MODEL_CAR2, true);
	PrecacheModel(MODEL_CAR3, true);
	PrecacheModel(MODEL_GASCAN, true);
	PrecacheModel(MODEL_PROPANETANK, true);
	PrecacheModel(MODEL_WITCH, true);
	PrecacheModel(MODEL_WITCHBRIDE, true);
	PrecacheModel(MODEL_TIRES, true);
	PrecacheModel(MODEL_SHIELD, true);
	PrecacheModel(MODEL_JETPACK, true);
	PrecacheModel(MODEL_CONCRETE, true);
	g_iExplosionSprite = PrecacheModel(SPRITE_FIRE, true);
	g_iSlugSprite = PrecacheModel(SPRITE_GLOW, true);
	vPrecacheParticle(PARTICLE_BLOOD);
	vPrecacheParticle(PARTICLE_SMOKE);
	vPrecacheParticle(PARTICLE_ELECTRICITY);
	vPrecacheParticle(PARTICLE_FIRE);
	vPrecacheParticle(PARTICLE_ICE);
	vPrecacheParticle(PARTICLE_METEOR);
	vPrecacheParticle(PARTICLE_SPIT);
	PrecacheSound(SOUND_INFECTED, true);
	PrecacheSound(SOUND_INFECTED2, true);
	PrecacheSound(SOUND_EXPLOSION, true);
	PrecacheSound(SOUND_LAUNCH, true);
	PrecacheSound(SOUND_FIRE, true);
	PrecacheSound(SOUND_EXPLOSION2, true);
	PrecacheSound(SOUND_EXPLOSION3, true);
	PrecacheSound(SOUND_EXPLOSION4, true);
	PrecacheSound(SOUND_DEBRIS, true);
	PrecacheSound(SOUND_BULLET, true);
	if (g_bLateLoad)
	{
		vLoadConfigs(g_sSavePath, true);
		for (int iPlayer = 1; iPlayer <= MaxClients; iPlayer++)
		{
			if (bIsValidClient(iPlayer))
			{
				SDKHook(iPlayer, SDKHook_OnTakeDamage, OnTakeDamage);
			}
		}
	}
}

public void OnClientPostAdminCheck(int client)
{
	SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);
	vStopTimers(client);
}

public void OnClientDisconnect(int client)
{
	SDKUnhook(client, SDKHook_OnTakeDamage, OnTakeDamage);
	vStopTimers(client);
}

public void OnConfigsExecuted()
{
	vLoadConfigs(g_sSavePath, true);
	g_bCmdUsed = false;
	g_bRestartValid = false;
	CreateTimer(0.1, tTimerTankHealthUpdate, _, TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
	CreateTimer(1.0, tTimerTankTypeUpdate, _, TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
	CreateTimer(1.0, tTimerUpdatePlayerCount, _, TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
	if (StrContains(g_sConfigCreate, "1") != -1 && g_iConfigEnable == 1)
	{
		CreateDirectory("cfg/sourcemod/super_tanks++/difficulty_configs/", 511);
		char sDifficulty[32];
		for (int iDifficulty = 0; iDifficulty <= 3; iDifficulty++)
		{
			switch (iDifficulty)
			{
				case 0: sDifficulty = "easy";
				case 1: sDifficulty = "normal";
				case 2: sDifficulty = "hard";
				case 3: sDifficulty = "impossible";
			}
			vCreateConfigFile("cfg/sourcemod/super_tanks++/", "difficulty_configs/", sDifficulty, sDifficulty);
		}
	}
	if (StrContains(g_sConfigCreate, "2") != -1 && g_iConfigEnable == 1)
	{
		CreateDirectory((bIsL4D2Game() ? "cfg/sourcemod/super_tanks++/l4d2_map_configs/" : "cfg/sourcemod/super_tanks++/l4d_map_configs/"), 511);
		char sMapNames[128];
		ArrayList alADTMaps = new ArrayList(16, 0);
		int iSerial = -1;
		ReadMapList(alADTMaps, iSerial, "default", MAPLIST_FLAG_MAPSFOLDER);
		ReadMapList(alADTMaps, iSerial, "allexistingmaps__", MAPLIST_FLAG_MAPSFOLDER|MAPLIST_FLAG_NO_DEFAULT);
		int iMapCount = GetArraySize(alADTMaps);
		if (iMapCount > 0)
		{
			for (int iMap = 0; iMap < iMapCount; iMap++)
			{
				alADTMaps.GetString(iMap, sMapNames, sizeof(sMapNames));
				vCreateConfigFile("cfg/sourcemod/super_tanks++/", (bIsL4D2Game() ? "l4d2_map_configs/" : "l4d_map_configs/"), sMapNames, sMapNames);
			}
		}
		delete alADTMaps;
	}
	if (StrContains(g_sConfigCreate, "3") != -1 && g_iConfigEnable == 1)
	{
		CreateDirectory((bIsL4D2Game() ? "cfg/sourcemod/super_tanks++/l4d2_gamemode_configs/" : "cfg/sourcemod/super_tanks++/l4d_gamemode_configs/"), 511);
		char sGameType[2049];
		char sTypes[64][32];
		g_cvSTFindConVar[2].GetString(sGameType, sizeof(sGameType));
		ExplodeString(sGameType, ",", sTypes, sizeof(sTypes), sizeof(sTypes[]));
		for (int iMode = 0; iMode < sizeof(sTypes); iMode++)
		{
			if (StrContains(sGameType, sTypes[iMode]) != -1 && sTypes[iMode][0] != '\0')
			{
				vCreateConfigFile("cfg/sourcemod/super_tanks++/", (bIsL4D2Game() ? "l4d2_gamemode_configs/" : "l4d_gamemode_configs/"), sTypes[iMode], sTypes[iMode]);
			}
		}
	}
	if (StrContains(g_sConfigCreate, "4") != -1 && g_iConfigEnable == 1)
	{
		CreateDirectory("cfg/sourcemod/super_tanks++/daily_configs/", 511);
		char sWeekday[32];
		for (int iDay = 0; iDay <= 6; iDay++)
		{
			switch (iDay)
			{
				case 6: sWeekday = "saturday";
				case 5: sWeekday = "friday";
				case 4: sWeekday = "thursday";
				case 3: sWeekday = "wednesday";
				case 2: sWeekday = "tuesday";
				case 1: sWeekday = "monday";
				default: sWeekday = "sunday";
			}
			vCreateConfigFile("cfg/sourcemod/super_tanks++/", "daily_configs/", sWeekday, sWeekday);
		}
	}
	if (StrContains(g_sConfigCreate, "5") != -1 && g_iConfigEnable == 1)
	{
		CreateDirectory("cfg/sourcemod/super_tanks++/playercount_configs/", 511);
		char sPlayerCount[32];
		for (int iCount = 0; iCount <= MAXPLAYERS + 1; iCount++)
		{
			IntToString(iCount, sPlayerCount, sizeof(sPlayerCount));
			vCreateConfigFile("cfg/sourcemod/super_tanks++/", "playercount_configs/", sPlayerCount, sPlayerCount);
		}
	}
	if (StrContains(g_sConfigExecute, "1") != -1 && g_iConfigEnable == 1 && g_cvSTFindConVar[0] != null)
	{
		char sDifficulty[11];
		char sDifficultyConfig[512];
		g_cvSTFindConVar[0].GetString(sDifficulty, sizeof(sDifficulty));
		Format(sDifficultyConfig, sizeof(sDifficultyConfig), "cfg/sourcemod/super_tanks++/difficulty_configs/%s.cfg", sDifficulty);
		vLoadConfigs(sDifficultyConfig);
	}
	if (StrContains(g_sConfigExecute, "2") != -1 && g_iConfigEnable == 1)
	{
		char sMap[64];
		char sMapConfig[512];
		GetCurrentMap(sMap, sizeof(sMap));
		Format(sMapConfig, sizeof(sMapConfig), (bIsL4D2Game() ? "cfg/sourcemod/super_tanks++/l4d2_map_configs/%s.cfg" : "cfg/sourcemod/super_tanks++/l4d_map_configs/%s.cfg"), sMap);
		vLoadConfigs(sMapConfig);
	}
	if (StrContains(g_sConfigExecute, "3") != -1 && g_iConfigEnable == 1)
	{
		char sMode[64];
		char sModeConfig[512];
		g_cvSTFindConVar[1].GetString(sMode, sizeof(sMode));
		Format(sModeConfig, sizeof(sModeConfig), (bIsL4D2Game() ? "cfg/sourcemod/super_tanks++/l4d2_gamemode_configs/%s.cfg" : "cfg/sourcemod/super_tanks++/l4d_gamemode_configs/%s.cfg"), sMode);
		vLoadConfigs(sModeConfig);
	}
	if (StrContains(g_sConfigExecute, "4") != -1 && g_iConfigEnable == 1)
	{
		char sDay[9];
		char sDayConfig[512];
		char sDayNumber[2];
		FormatTime(sDayNumber, sizeof(sDayNumber), "%w", GetTime());
		int iDayNumber = StringToInt(sDayNumber);
		switch (iDayNumber)
		{
			case 6: sDay = "saturday";
			case 5: sDay = "friday";
			case 4: sDay = "thursday";
			case 3: sDay = "wednesday";
			case 2: sDay = "tuesday";
			case 1: sDay = "monday";
			default: sDay = "sunday";
		}
		Format(sDayConfig, sizeof(sDayConfig), "cfg/sourcemod/super_tanks++/daily_configs/%s.cfg", sDay);
		vLoadConfigs(sDayConfig);
	}
	if (StrContains(g_sConfigExecute, "5") != -1 && g_iConfigEnable == 1)
	{
		char sCountConfig[512];
		Format(sCountConfig, sizeof(sCountConfig), "cfg/sourcemod/super_tanks++/playercount_configs/%d.cfg", iGetPlayerCount());
		vLoadConfigs(sCountConfig);
	}
}

public void OnMapEnd()
{
	g_bCmdUsed = false;
	g_bRestartValid = false;
	for (int iPlayer = 1; iPlayer <= MaxClients; iPlayer++)
	{
		vStopTimers(iPlayer);
	}
}

public void OnPluginEnd()
{
	vMultiTargetFilters(0);
}

public void OnAdminMenuReady(Handle topmenu)
{
	if (topmenu == g_tmSTMenu)
	{
		return;
	}
	g_tmSTMenu = view_as<TopMenu>(topmenu);
	TopMenuObject st_commands = g_tmSTMenu.AddCategory("SuperTanks++", iAdminMenuHandler);
	if (st_commands != INVALID_TOPMENUOBJECT)
	{
		g_tmSTMenu.AddItem("sm_tank", vSuperTankMenu, st_commands, "sm_tank", ADMFLAG_ROOT);
	}
}

public int iAdminMenuHandler(TopMenu topmenu, TopMenuAction action, TopMenuObject object_id, int param, char[] buffer, int maxlength)
{
	switch (action)
	{
		case TopMenuAction_DisplayTitle, TopMenuAction_DisplayOption: Format(buffer, maxlength, "Super Tanks++");
	}
}

public void vSuperTankMenu(TopMenu topmenu, TopMenuAction action, TopMenuObject object_id, int param, char[] buffer, int maxlength)
{
	switch (action)
	{
		case TopMenuAction_DisplayOption: Format(buffer, maxlength, "Super Tank Menu");
		case TopMenuAction_SelectOption: vTankMenu(param, 0);
	}
}

public void OnLibraryRemoved(const char[] name)
{
	if (StrEqual(name, "adminmenu", false))
	{
		g_tmSTMenu = null;
	}
}

public void OnEntityCreated(int entity, const char[] classname)
{
	int iEnable = !g_bGeneralConfig ? g_iPluginEnabled : g_iPluginEnabled2;
	if (iEnable == 1 && bIsSystemValid(g_cvSTFindConVar[1], g_sEnabledGameModes, g_sDisabledGameModes))
	{
		if (strcmp(classname, "tank_rock") == 0)
		{
			CreateTimer(0.1, tTimerRockThrow, EntIndexToEntRef(entity), TIMER_FLAG_NO_MAPCHANGE);
		}
	}
}

public void OnEntityDestroyed(int entity)
{
	int iEnable = !g_bGeneralConfig ? g_iPluginEnabled : g_iPluginEnabled2;
	if (iEnable == 1 && bIsSystemValid(g_cvSTFindConVar[1], g_sEnabledGameModes, g_sDisabledGameModes))
	{
		if (IsValidEntity(entity))
		{
			char sClassname[32];
			GetEntityClassname(entity, sClassname, sizeof(sClassname));
			if (strcmp(sClassname, "tank_rock") == 0)
			{
				int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
				int iThrower = GetEntPropEnt(entity, Prop_Data, "m_hThrower");
				if (iThrower > 0 && bIsTank(iThrower) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(iThrower))))
				{
					int iAcidToggle = !g_bTankConfig[g_iTankType[iThrower]] ? g_iAcidRock[g_iTankType[iThrower]] : g_iAcidRock2[g_iTankType[iThrower]];
					int iBombToggle = !g_bTankConfig[g_iTankType[iThrower]] ? g_iBombRock[g_iTankType[iThrower]] : g_iBombRock2[g_iTankType[iThrower]];
					int iFireToggle = !g_bTankConfig[g_iTankType[iThrower]] ? g_iFireRock[g_iTankType[iThrower]] : g_iFireRock2[g_iTankType[iThrower]];
					vAcidRock(entity, iThrower, iAcidToggle);
					vBombRock(entity, iThrower, iBombToggle);
					vFireRock(entity, iThrower, iFireToggle);
				}
			}
		}
	}
}

public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon)
{
	int iEnable = !g_bGeneralConfig ? g_iPluginEnabled : g_iPluginEnabled2;
	if (iEnable == 0 || !bIsSystemValid(g_cvSTFindConVar[1], g_sEnabledGameModes, g_sDisabledGameModes))
	{
		return Plugin_Continue;
	}
	if (g_bInvert[client])
	{
		vel[1] = -vel[1];
		if (buttons & IN_MOVELEFT)
		{
			buttons &= ~IN_MOVELEFT;
			buttons |= IN_MOVERIGHT;
		}
		else if (buttons & IN_MOVERIGHT)
		{
			buttons &= ~IN_MOVERIGHT;
			buttons |= IN_MOVELEFT;
		}
		vel[0] = -vel[0];
		if (buttons & IN_FORWARD)
		{
			buttons &= ~IN_FORWARD;
			buttons |= IN_BACK;
		}
		else if (buttons & IN_BACK)
		{
			buttons &= ~IN_BACK;
			buttons |= IN_FORWARD;
		}
		return Plugin_Changed;
	}
	return Plugin_Continue;
}

public Action OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype)
{
	int iEnable = !g_bGeneralConfig ? g_iPluginEnabled : g_iPluginEnabled2;
	if (iEnable == 1 && bIsSystemValid(g_cvSTFindConVar[1], g_sEnabledGameModes, g_sDisabledGameModes))
	{
		if (damage > 0.0 && bIsValidClient(victim))
		{
			char sClassname[32];
			GetEntityClassname(inflictor, sClassname, sizeof(sClassname));
			if (bIsSurvivor(victim))
			{
				int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
				if (bIsWitch(attacker))
				{
					int iOwner = GetEntPropEnt(attacker, Prop_Send, "m_hOwnerEntity");
					if (bIsTank(iOwner))
					{
						float flWitchDamage = !g_bTankConfig[g_iTankType[iOwner]] ? g_flWitchDamage[g_iTankType[iOwner]] : g_flWitchDamage2[g_iTankType[iOwner]];
						damage = flWitchDamage;
					}
				}
				else if (bIsTank(attacker) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(attacker))))
				{
					if (strcmp(sClassname, "weapon_tank_claw") == 0 || strcmp(sClassname, "tank_rock") == 0)
					{
						int iAcidHit = !g_bTankConfig[g_iTankType[attacker]] ? g_iAcidHit[g_iTankType[attacker]] : g_iAcidHit2[g_iTankType[attacker]];
						int iAmmoHit = !g_bTankConfig[g_iTankType[attacker]] ? g_iAmmoHit[g_iTankType[attacker]] : g_iAmmoHit2[g_iTankType[attacker]];
						int iBlindHit = !g_bTankConfig[g_iTankType[attacker]] ? g_iBlindHit[g_iTankType[attacker]] : g_iBlindHit2[g_iTankType[attacker]];
						int iBombHit = !g_bTankConfig[g_iTankType[attacker]] ? g_iBombHit[g_iTankType[attacker]] : g_iBombHit2[g_iTankType[attacker]];
						int iBuryHit = !g_bTankConfig[g_iTankType[attacker]] ? g_iBuryHit[g_iTankType[attacker]] : g_iBuryHit2[g_iTankType[attacker]];
						int iCommonAbility = !g_bTankConfig[g_iTankType[attacker]] ? g_iCommonAbility[g_iTankType[attacker]] : g_iCommonAbility2[g_iTankType[attacker]];
						int iDrugHit = !g_bTankConfig[g_iTankType[attacker]] ? g_iDrugHit[g_iTankType[attacker]] : g_iDrugHit2[g_iTankType[attacker]];
						int iFireHit = !g_bTankConfig[g_iTankType[attacker]] ? g_iFireHit[g_iTankType[attacker]] : g_iFireHit2[g_iTankType[attacker]];
						int iFlingHit = !g_bTankConfig[g_iTankType[attacker]] ? g_iFlingHit[g_iTankType[attacker]] : g_iFlingHit2[g_iTankType[attacker]];
						int iGhostHit = !g_bTankConfig[g_iTankType[attacker]] ? g_iGhostHit[g_iTankType[attacker]] : g_iGhostHit2[g_iTankType[attacker]];
						int iGravityHit = !g_bTankConfig[g_iTankType[attacker]] ? g_iGravityHit[g_iTankType[attacker]] : g_iGravityHit2[g_iTankType[attacker]];
						int iHealHit = !g_bTankConfig[g_iTankType[attacker]] ? g_iHealHit[g_iTankType[attacker]] : g_iHealHit2[g_iTankType[attacker]];
						int iHurtAbility = !g_bTankConfig[g_iTankType[attacker]] ? g_iHurtAbility[g_iTankType[attacker]] : g_iHurtAbility2[g_iTankType[attacker]];
						int iHypnoHit = !g_bTankConfig[g_iTankType[attacker]] ? g_iHypnoHit[g_iTankType[attacker]] : g_iHypnoHit2[g_iTankType[attacker]];
						int iIceHit = !g_bTankConfig[g_iTankType[attacker]] ? g_iIceHit[g_iTankType[attacker]] : g_iIceHit2[g_iTankType[attacker]];
						int iIdleHit = !g_bTankConfig[g_iTankType[attacker]] ? g_iIdleHit[g_iTankType[attacker]] : g_iIdleHit2[g_iTankType[attacker]];
						int iInvertHit = !g_bTankConfig[g_iTankType[attacker]] ? g_iInvertHit[g_iTankType[attacker]] : g_iInvertHit2[g_iTankType[attacker]];
						int iNullifyHit = !g_bTankConfig[g_iTankType[attacker]] ? g_iNullifyHit[g_iTankType[attacker]] : g_iNullifyHit2[g_iTankType[attacker]];
						int iPanicHit = !g_bTankConfig[g_iTankType[attacker]] ? g_iPanicHit[g_iTankType[attacker]] : g_iPanicHit2[g_iTankType[attacker]];
						int iPukeHit = !g_bTankConfig[g_iTankType[attacker]] ? g_iPukeHit[g_iTankType[attacker]] : g_iPukeHit2[g_iTankType[attacker]];
						int iRestartHit = !g_bTankConfig[g_iTankType[attacker]] ? g_iRestartHit[g_iTankType[attacker]] : g_iRestartHit2[g_iTankType[attacker]];
						int iRocketHit = !g_bTankConfig[g_iTankType[attacker]] ? g_iRocketHit[g_iTankType[attacker]] : g_iRocketHit2[g_iTankType[attacker]];
						int iShakeHit = !g_bTankConfig[g_iTankType[attacker]] ? g_iShakeHit[g_iTankType[attacker]] : g_iShakeHit2[g_iTankType[attacker]];
						int iShoveHit = !g_bTankConfig[g_iTankType[attacker]] ? g_iShoveHit[g_iTankType[attacker]] : g_iShoveHit2[g_iTankType[attacker]];
						int iSlugHit = !g_bTankConfig[g_iTankType[attacker]] ? g_iSlugHit[g_iTankType[attacker]] : g_iSlugHit2[g_iTankType[attacker]];
						int iStunHit = !g_bTankConfig[g_iTankType[attacker]] ? g_iStunHit[g_iTankType[attacker]] : g_iStunHit2[g_iTankType[attacker]];
						int iVampireHit = !g_bTankConfig[g_iTankType[attacker]] ? g_iVampireHit[g_iTankType[attacker]] : g_iVampireHit2[g_iTankType[attacker]];
						int iVisionHit = !g_bTankConfig[g_iTankType[attacker]] ? g_iVisionHit[g_iTankType[attacker]] : g_iVisionHit2[g_iTankType[attacker]];
						vAcidHit(victim, attacker, iAcidHit);
						vAmmoHit(victim, attacker, iAmmoHit);
						vBlindHit(victim, attacker, iBlindHit);
						vBombHit(victim, attacker, iBombHit);
						vBuryHit(victim, attacker, iBuryHit);
						vCommonAbility(attacker, iCommonAbility);
						vDrugHit(victim, attacker, iDrugHit);
						vFireHit(victim, attacker, iFireHit);
						vFlingHit(victim, attacker, iFlingHit);
						vGhostHit(victim, attacker, iGhostHit);
						vGravityHit(victim, attacker, iGravityHit);
						vHealHit(victim, attacker, iHealHit);
						vHurtAbility(victim, attacker, iHurtAbility);
						vHypnoHit(victim, attacker, iHypnoHit);
						vIceHit(victim, attacker, iIceHit);
						vIdleHit(victim, attacker, iIdleHit);
						vInvertHit(victim, attacker, iInvertHit);
						vNullifyHit(victim, attacker, iNullifyHit);
						vPanicHit(attacker, iPanicHit);
						vPukeHit(victim, attacker, iPukeHit);
						vRestartHit(victim, attacker, iRestartHit);
						vRocketHit(victim, attacker, iRocketHit);
						vShakeHit(victim, attacker, iShakeHit);
						vShoveHit(victim, attacker, iShoveHit);
						vSlugHit(victim, attacker, iSlugHit);
						vStunHit(victim, attacker, iStunHit);
						vVampireHit(attacker, iVampireHit);
						vVisualHit(victim, attacker, iVisionHit);
					}
				}
			}
			else if (bIsInfected(victim))
			{
				int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
				if (bIsTank(victim) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(victim))))
				{
					int iBulletImmunity = !g_bTankConfig[g_iTankType[victim]] ? g_iBulletImmunity[g_iTankType[victim]] : g_iBulletImmunity2[g_iTankType[victim]];
					int iExplosiveImmunity = !g_bTankConfig[g_iTankType[victim]] ? g_iExplosiveImmunity[g_iTankType[victim]] : g_iExplosiveImmunity2[g_iTankType[victim]];
					int iFireImmunity = !g_bTankConfig[g_iTankType[victim]] ? g_iFireImmunity[g_iTankType[victim]] : g_iFireImmunity2[g_iTankType[victim]];
					int iMeleeImmunity = !g_bTankConfig[g_iTankType[victim]] ? g_iMeleeImmunity[g_iTankType[victim]] : g_iMeleeImmunity2[g_iTankType[victim]];
					if ((damagetype & DMG_BULLET && iBulletImmunity == 1) || ((damagetype & DMG_BLAST || damagetype & DMG_BLAST_SURFACE || damagetype & DMG_AIRBOAT || damagetype & DMG_PLASMA) && iExplosiveImmunity == 1) || (damagetype & DMG_BURN && iFireImmunity == 1) || ((damagetype & DMG_SLASH || damagetype & DMG_CLUB) && iMeleeImmunity == 1))
					{
						damage = 0.0;
						return Plugin_Handled;
					}
					if (bIsSurvivor(attacker))
					{
						if (g_bNullify[attacker])
						{
							damage = 0.0;
							return Plugin_Handled;
						}
						if (strcmp(sClassname, "weapon_melee") == 0)
						{
							int iAcidHit = !g_bTankConfig[g_iTankType[victim]] ? g_iAcidHit[g_iTankType[victim]] : g_iAcidHit2[g_iTankType[victim]];
							int iFireHit = !g_bTankConfig[g_iTankType[victim]] ? g_iFireHit[g_iTankType[victim]] : g_iFireHit2[g_iTankType[victim]];
							int iGhostHit = !g_bTankConfig[g_iTankType[victim]] ? g_iGhostHit[g_iTankType[victim]] : g_iGhostHit2[g_iTankType[victim]];
							int iHurtAbility = !g_bTankConfig[g_iTankType[victim]] ? g_iHurtAbility[g_iTankType[victim]] : g_iHurtAbility2[g_iTankType[victim]];
							int iMeteorAbility = !g_bTankConfig[g_iTankType[victim]] ? g_iMeteorAbility[g_iTankType[victim]] : g_iMeteorAbility2[g_iTankType[victim]];
							vAcidHit(attacker, victim, iAcidHit);
							vFireHit(attacker, victim, iFireHit);
							vGhostHit(attacker, victim, iGhostHit);
							vHurtAbility(attacker, victim, iHurtAbility);
							vMeteorAbility(victim, iMeteorAbility);
						}
						int iAbsorbAbility = !g_bTankConfig[g_iTankType[victim]] ? g_iAbsorbAbility[g_iTankType[victim]] : g_iAbsorbAbility2[g_iTankType[victim]];
						if (iAbsorbAbility == 1)
						{
							int iDamage;
							if (damagetype & DMG_BULLET || damagetype & DMG_BURN || damagetype & DMG_BLAST || damagetype & DMG_BLAST_SURFACE || damagetype & DMG_AIRBOAT || damagetype & DMG_PLASMA)
							{
								iDamage = RoundFloat(damage) / 10;
							}
							else if (damagetype & DMG_SLASH || damagetype & DMG_CLUB)
							{
								iDamage = RoundFloat(damage) / 1000;
							}
							int iHealth = GetClientHealth(victim);
							SetEntityHealth(victim, iHealth - iDamage);
							damage = 0.0;
							return Plugin_Changed;
						}
						if (g_bHypno[attacker])
						{
							int iHypnoMode = !g_bTankConfig[g_iTankType[victim]] ? g_iHypnoMode[g_iTankType[victim]] : g_iHypnoMode2[g_iTankType[victim]];
							int iDamage;
							int iHealth = GetClientHealth(attacker);
							int iTarget = iGetRandomSurvivor(attacker, false);
							if (damagetype & DMG_BULLET)
							{
								iDamage = RoundFloat(damage) / 10;
								(iHealth > iDamage) ? ((iHypnoMode == 1 && iTarget > 0) ? SetEntityHealth(iTarget, iHealth - iDamage) : SetEntityHealth(attacker, iHealth - iDamage)) : ((iHypnoMode == 1 && iTarget > 0) ? SetEntProp(iTarget, Prop_Send, "m_isIncapacitated", 1) : SetEntProp(attacker, Prop_Send, "m_isIncapacitated", 1));
							}
							else if (damagetype & DMG_SLASH)
							{
								iDamage = RoundFloat(damage) / 1000;
								(iHealth > iDamage) ? ((iHypnoMode == 1 && iTarget > 0) ? SetEntityHealth(iTarget, iHealth - iDamage) : SetEntityHealth(attacker, iHealth - iDamage)) : ((iHypnoMode == 1 && iTarget > 0) ? SetEntProp(iTarget, Prop_Send, "m_isIncapacitated", 1) : SetEntProp(attacker, Prop_Send, "m_isIncapacitated", 1));
							}
							damage = 0.0;
							return Plugin_Changed;
						}
					}
				}
				if (damagetype & DMG_BLAST || damagetype & DMG_BLAST_SURFACE || damagetype & DMG_AIRBOAT || damagetype & DMG_PLASMA)
				{
					if (g_bShielded[victim])
					{
						int iShieldAbility = !g_bTankConfig[g_iTankType[victim]] ? g_iShieldAbility[g_iTankType[victim]] : g_iShieldAbility2[g_iTankType[victim]];
						vShieldAbility(victim, false, iShieldAbility);
					}
				}
				else
				{
					if (g_bShielded[victim])
					{
						return Plugin_Handled;
					}
				}
				if ((damagetype & DMG_BURN || damagetype & DMG_BLAST) && (attacker == victim || bIsInfected(attacker)))
				{
					damage = 0.0;
					return Plugin_Handled;
				}
				if (inflictor != -1)
				{
					int iOwner = GetEntPropEnt(inflictor, Prop_Send, "m_hOwnerEntity");
					if (iOwner == victim || bIsTank(iOwner) || strcmp(sClassname, "tank_rock") == 0)
					{
						damage = 0.0;
						return Plugin_Changed;
					}
				}
			}
		}
	}
	return Plugin_Continue;
}

public Action SetTransmit(int entity, int client)
{
	int iOwner = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
	if (iOwner == client)
	{
		return Plugin_Handled;
	}
	return Plugin_Continue;
}

public Action eEventAbilityUse(Event event, const char[] name, bool dontBroadcast)
{
	int iUserId = event.GetInt("userid");
	int iTank = GetClientOfUserId(iUserId);
	int iEnable = !g_bGeneralConfig ? g_iPluginEnabled : g_iPluginEnabled2;
	if (iEnable == 1 && bIsSystemValid(g_cvSTFindConVar[1], g_sEnabledGameModes, g_sDisabledGameModes))
	{
		if (bIsTank(iTank))
		{
			int iEntity = -1;
			while ((iEntity = FindEntityByClassname(iEntity, "prop_dynamic")) != INVALID_ENT_REFERENCE)
			{
				char sModel[128];
				GetEntPropString(iEntity, Prop_Data, "m_ModelName", sModel, sizeof(sModel));
				if (strcmp(sModel, MODEL_JETPACK) == 0 || strcmp(sModel, MODEL_CONCRETE) == 0 || strcmp(sModel, MODEL_SHIELD) == 0 || strcmp(sModel, MODEL_TIRES) == 0 || strcmp(sModel, MODEL_TANK) == 0)
				{
					int iOwner = GetEntPropEnt(iEntity, Prop_Send, "m_hOwnerEntity");
					if (iOwner == iTank)
					{
						SDKUnhook(iEntity, SDKHook_SetTransmit, SetTransmit);
						CreateTimer(3.5, tTimerSetTransmit, EntIndexToEntRef(iEntity), TIMER_FLAG_NO_MAPCHANGE);
					}
				}
			}
			while ((iEntity = FindEntityByClassname(iEntity, "beam_spotlight")) != INVALID_ENT_REFERENCE)
			{
				int iOwner = GetEntPropEnt(iEntity, Prop_Send, "m_hOwnerEntity");
				if (iOwner == iTank)
				{
					SDKUnhook(iEntity, SDKHook_SetTransmit, SetTransmit);
					CreateTimer(3.5, tTimerSetTransmit, EntIndexToEntRef(iEntity), TIMER_FLAG_NO_MAPCHANGE);
				}
			}
			while ((iEntity = FindEntityByClassname(iEntity, "env_steam")) != INVALID_ENT_REFERENCE)
			{
				int iOwner = GetEntPropEnt(iEntity, Prop_Send, "m_hOwnerEntity");
				if (iOwner == iTank)
				{
					SDKUnhook(iEntity, SDKHook_SetTransmit, SetTransmit);
					CreateTimer(3.5, tTimerSetTransmit, EntIndexToEntRef(iEntity), TIMER_FLAG_NO_MAPCHANGE);
				}
			}
			float flThrowInterval = !g_bTankConfig[g_iTankType[iTank]] ? g_flThrowInterval[g_iTankType[iTank]] : g_flThrowInterval2[g_iTankType[iTank]];
			vThrowInterval(iTank, flThrowInterval);
		}
	}
}

public Action eEventFinaleEscapeStart(Event event, const char[] name, bool dontBroadcast)
{
	g_iTankWave = 3;
}

public Action eEventFinaleStart(Event event, const char[] name, bool dontBroadcast)
{
	g_iTankWave = 1;
}

public Action eEventFinaleVehicleLeaving(Event event, const char[] name, bool dontBroadcast)
{
	g_iTankWave = 4;
}

public Action eEventFinaleVehicleReady(Event event, const char[] name, bool dontBroadcast)
{
	g_iTankWave = 3;
}

public Action eEventPlayerAFK(Event event, const char[] name, bool dontBroadcast)
{
	int iIdler = GetClientOfUserId(event.GetInt("player"));
	g_bAFK[iIdler] = true;
}

public Action eEventPlayerBotReplace(Event event, const char[] name, bool dontBroadcast)
{
	int iSurvivorId = event.GetInt("player");
	int iSurvivor = GetClientOfUserId(iSurvivorId);
	int iBotId = event.GetInt("bot");
	int iBot = GetClientOfUserId(iBotId);
	int iEnable = !g_bGeneralConfig ? g_iPluginEnabled : g_iPluginEnabled2;
	if (iEnable == 1 && bIsSystemValid(g_cvSTFindConVar[1], g_sEnabledGameModes, g_sDisabledGameModes) && bIsIdlePlayer(iBot, iSurvivor)) 
	{
		DataPack dpDataPack;
		CreateDataTimer(0.2, tTimerIdleFix, dpDataPack, TIMER_FLAG_NO_MAPCHANGE);
		dpDataPack.WriteCell(iSurvivorId);
		dpDataPack.WriteCell(iBotId);
		if (g_bIdle[iSurvivor])
		{
			g_bIdle[iSurvivor] = false;
			vIdleWarp(iBot);
		}
	}
}

public Action eEventPlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
	int iUserId = event.GetInt("userid");
	int iTank = GetClientOfUserId(iUserId);
	int iEnable = !g_bGeneralConfig ? g_iPluginEnabled : g_iPluginEnabled2;
	if (iEnable == 1 && bIsSystemValid(g_cvSTFindConVar[1], g_sEnabledGameModes, g_sDisabledGameModes))
	{
		if (bIsValidClient(iTank))
		{
			SetEntityGravity(iTank, 1.0);
			int iGlowEffect = !g_bTankConfig[g_iTankType[iTank]] ? g_iGlowEffect[g_iTankType[iTank]] : g_iGlowEffect2[g_iTankType[iTank]];
			if (iGlowEffect == 1 && bIsL4D2Game())
			{
				SetEntProp(iTank, Prop_Send, "m_iGlowType", 0);
				SetEntProp(iTank, Prop_Send, "m_glowColorOverride", 0);
			}
			int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
			if (bIsTank(iTank, false) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(iTank))))
			{
				int iBlindHit = !g_bTankConfig[g_iTankType[iTank]] ? g_iBlindHit[g_iTankType[iTank]] : g_iBlindHit2[g_iTankType[iTank]];
				if (iBlindHit == 1)
				{
					for (int iSurvivor = 1; iSurvivor <= MaxClients; iSurvivor++)
					{
						if (bIsSurvivor(iSurvivor) && g_bBlind[iSurvivor])
						{
							tTimerStopBlindness(null, GetClientUserId(iSurvivor));
						}
					}
				}
				int iBuryHit = !g_bTankConfig[g_iTankType[iTank]] ? g_iBuryHit[g_iTankType[iTank]] : g_iBuryHit2[g_iTankType[iTank]];
				if (iBuryHit == 1)
				{
					for (int iSurvivor = 1; iSurvivor <= MaxClients; iSurvivor++)
					{
						if (bIsSurvivor(iSurvivor) && g_bBury[iSurvivor])
						{
							DataPack dpDataPack;
							tTimerStopBury(null, dpDataPack);
							dpDataPack.WriteCell(GetClientUserId(iSurvivor));
							dpDataPack.WriteCell(GetClientUserId(iTank));
						}
					}
				}
				int iGravityHit = !g_bTankConfig[g_iTankType[iTank]] ? g_iGravityHit[g_iTankType[iTank]] : g_iGravityHit2[g_iTankType[iTank]];
				if (iGravityHit == 1)
				{
					for (int iSurvivor = 1; iSurvivor <= MaxClients; iSurvivor++)
					{
						if (bIsSurvivor(iSurvivor) && g_bGravity2[iSurvivor])
						{
							tTimerStopGravity(null, GetClientUserId(iSurvivor));
						}
					}
				}
				g_bGhost[iTank] = false;
				g_iAlpha[iTank] = 255;
				int iHypnoHit = !g_bTankConfig[g_iTankType[iTank]] ? g_iHypnoHit[g_iTankType[iTank]] : g_iHypnoHit2[g_iTankType[iTank]];
				if (iHypnoHit == 1)
				{
					for (int iSurvivor = 1; iSurvivor <= MaxClients; iSurvivor++)
					{
						if (bIsSurvivor(iSurvivor) && g_bHypno[iSurvivor])
						{
							g_bHypno[iSurvivor] = false;
						}
					}
				}
				int iIceHit = !g_bTankConfig[g_iTankType[iTank]] ? g_iIceHit[g_iTankType[iTank]] : g_iIceHit2[g_iTankType[iTank]];
				if (iIceHit == 1)
				{
					for (int iSurvivor = 1; iSurvivor <= MaxClients; iSurvivor++)
					{
						if (bIsSurvivor(iSurvivor) && g_bIce[iSurvivor])
						{
							tTimerStopIce(null, GetClientUserId(iSurvivor));
						}
					}
				}
				int iInvertHit = !g_bTankConfig[g_iTankType[iTank]] ? g_iInvertHit[g_iTankType[iTank]] : g_iInvertHit2[g_iTankType[iTank]];
				if (iInvertHit == 1)
				{
					for (int iSurvivor = 1; iSurvivor <= MaxClients; iSurvivor++)
					{
						if (bIsSurvivor(iSurvivor) && g_bInvert[iSurvivor])
						{
							g_bInvert[iSurvivor] = false;
						}
					}
				}
				int iNullifyHit = !g_bTankConfig[g_iTankType[iTank]] ? g_iNullifyHit[g_iTankType[iTank]] : g_iNullifyHit2[g_iTankType[iTank]];
				if (iNullifyHit == 1)
				{
					for (int iSurvivor = 1; iSurvivor <= MaxClients; iSurvivor++)
					{
						if (bIsSurvivor(iSurvivor) && g_bNullify[iSurvivor])
						{
							g_bNullify[iSurvivor] = false;
						}
					}
				}
				int iStunHit = !g_bTankConfig[g_iTankType[iTank]] ? g_iStunHit[g_iTankType[iTank]] : g_iStunHit2[g_iTankType[iTank]];
				if (iStunHit == 1)
				{
					for (int iSurvivor = 1; iSurvivor <= MaxClients; iSurvivor++)
					{
						if (bIsSurvivor(iSurvivor) && g_bStun[iSurvivor])
						{
							tTimerStopStun(null, GetClientUserId(iSurvivor));
						}
					}
				}
				int iEntity = -1;
				while ((iEntity = FindEntityByClassname(iEntity, "prop_dynamic")) != INVALID_ENT_REFERENCE)
				{
					char sModel[128];
					GetEntPropString(iEntity, Prop_Data, "m_ModelName", sModel, sizeof(sModel));
					if (strcmp(sModel, MODEL_JETPACK) == 0 || strcmp(sModel, MODEL_CONCRETE) == 0 || strcmp(sModel, MODEL_SHIELD) == 0 || strcmp(sModel, MODEL_TIRES) == 0 || strcmp(sModel, MODEL_TANK) == 0)
					{
						int iOwner = GetEntPropEnt(iEntity, Prop_Send, "m_hOwnerEntity");
						if (iOwner == iTank)
						{
							AcceptEntityInput(iEntity, "Kill");
							SDKUnhook(iEntity, SDKHook_SetTransmit, SetTransmit);
						}
					}
				}
				while ((iEntity = FindEntityByClassname(iEntity, "beam_spotlight")) != INVALID_ENT_REFERENCE)
				{
					int iOwner = GetEntPropEnt(iEntity, Prop_Send, "m_hOwnerEntity");
					if (iOwner == iTank)
					{
						AcceptEntityInput(iEntity, "Kill");
						SDKUnhook(iEntity, SDKHook_SetTransmit, SetTransmit);
					}
				}
				while ((iEntity = FindEntityByClassname(iEntity, "point_push")) != INVALID_ENT_REFERENCE)
				{
					if (bIsL4D2Game())
					{
						int iOwner = GetEntProp(iEntity, Prop_Send, "m_glowColorOverride");
						if (iOwner == iTank)
						{
							AcceptEntityInput(iEntity, "Kill");
						}
					}
					int iOwner = GetEntPropEnt(iEntity, Prop_Send, "m_hOwnerEntity");
					if (iOwner == iTank)
					{
						AcceptEntityInput(iEntity, "Kill");
					}
				}
				CreateTimer(5.0, tTimerTankWave, g_iTankWave, TIMER_FLAG_NO_MAPCHANGE);
			}
		}
	}
}

public Action eEventRoundStart(Event event, const char[] name, bool dontBroadcast)
{
	int iEnable = !g_bGeneralConfig ? g_iPluginEnabled : g_iPluginEnabled2;
	if (iEnable == 1 && bIsSystemValid(g_cvSTFindConVar[1], g_sEnabledGameModes, g_sDisabledGameModes))
	{
		g_iTankWave = 0;
		CreateTimer(10.0, tTimerRestartCoordinates, _, TIMER_FLAG_NO_MAPCHANGE);
		g_cvSTFindConVar[4].SetString("32");
		g_cvSTFindConVar[5].SetString("32");
		g_cvSTFindConVar[6].SetString("32");
		if (bIsL4D2Game())
		{
			g_cvSTFindConVar[7].SetString("32");
			g_cvSTFindConVar[8].SetString("32");
			g_cvSTFindConVar[9].SetString("32");
		}
	}
}

public Action eEventTankSpawn(Event event, const char[] name, bool dontBroadcast)
{
	int iUserId = event.GetInt("userid");
	int iTank = GetClientOfUserId(iUserId);
	int iEnable = !g_bGeneralConfig ? g_iPluginEnabled : g_iPluginEnabled2;
	if (iEnable == 1 && bIsSystemValid(g_cvSTFindConVar[1], g_sEnabledGameModes, g_sDisabledGameModes))
	{
		int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
		if (bIsTank(iTank) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(iTank))))
		{
			if (g_bCmdUsed)
			{
				vSetColor(iTank, g_iType);
				g_bCmdUsed = false;
			}
			else
			{
				g_iTankType[iTank] = 0;
				int iFinalesOnly = !g_bGeneralConfig ? g_iFinalesOnly : g_iFinalesOnly2;
				if (iFinalesOnly == 0 || (iFinalesOnly == 1 && (bIsFinaleMap() || g_iTankWave > 0)))
				{
					int iTypeCount;
					int iLimit = !g_bGeneralConfig ? g_iMaxTypes : g_iMaxTypes2;
					int iTankTypes[MAXTYPES + 1];
					for (int iIndex = 1; iIndex <= iLimit; iIndex++)
					{
						int iTankEnabled = !g_bTankConfig[iIndex] ? g_iTankEnabled[iIndex] : g_iTankEnabled2[iIndex];
						if (iTankEnabled == 1)
						{
							iTankTypes[iTypeCount + 1] = iIndex;
							iTypeCount++;
						}
					}
					if (iTypeCount > 0)
					{
						int iChosen = iTankTypes[GetRandomInt(1, iTypeCount)];
						vSetColor(iTank, iChosen);
					}
					char sNumbers[3][4];
					!g_bTankConfig[g_iTankType[iTank]] ? ExplodeString(g_sTankWaves, ",", sNumbers, sizeof(sNumbers), sizeof(sNumbers[])) : ExplodeString(g_sTankWaves2, ",", sNumbers, sizeof(sNumbers), sizeof(sNumbers[]));
					int iWave1 = StringToInt(sNumbers[0]);
					int iWave2 = StringToInt(sNumbers[1]);
					int iWave3 = StringToInt(sNumbers[2]);
					switch (g_iTankWave)
					{
						case 1: vTankCountCheck(iTank, iWave1);
						case 2: vTankCountCheck(iTank, iWave2);
						case 3: vTankCountCheck(iTank, iWave3);
					}
				}
			}
			CreateTimer(0.1, tTimerTankSpawn, GetClientUserId(iTank), TIMER_FLAG_NO_MAPCHANGE);
		}
	}
}

public Action cmdTank(int client, int args)
{
	int iEnable = !g_bGeneralConfig ? g_iPluginEnabled : g_iPluginEnabled2;
	if (iEnable == 0)
	{
		ReplyToCommand(client, "\x04%s\x01 Super Tanks++ is disabled.", ST_PREFIX);
		return Plugin_Handled;
	}
	if (!bIsValidHumanClient(client))
	{
		ReplyToCommand(client, "%s This command is to be used only in-game.", ST_PREFIX);
		return Plugin_Handled;
	}
	if (!bIsSystemValid(g_cvSTFindConVar[1], g_sEnabledGameModes, g_sDisabledGameModes))
	{
		ReplyToCommand(client, "\x04%s\x01 Game mode not supported.", ST_PREFIX);
		return Plugin_Handled;
	}
	char sTank[32];
	GetCmdArg(1, sTank, sizeof(sTank));
	int iType = StringToInt(sTank);
	int iMaxTypes = !g_bGeneralConfig ? g_iMaxTypes : g_iMaxTypes2;
	if (args < 1)
	{
		IsVoteInProgress() ? ReplyToCommand(client, "\x04%s\x01 %t", ST_PREFIX, "Vote in Progress") : vTankMenu(client, 0);
		return Plugin_Handled;
	}
	else if (iType < 1 || iType > iMaxTypes || args > 1)
	{
		int iLimit = !g_bGeneralConfig ? g_iMaxTypes : g_iMaxTypes2;
		ReplyToCommand(client, "\x04%s\x01 Usage: sm_tank <type 1-%d>", ST_PREFIX, iLimit);
		return Plugin_Handled;
	}
	int iTankEnabled = !g_bTankConfig[iType] ? g_iTankEnabled[iType] : g_iTankEnabled2[iType];
	if (iTankEnabled == 0)
	{
		char sName[33];
		sName = !g_bTankConfig[iType] ? g_sCustomName[iType] : g_sCustomName2[iType];
		ReplyToCommand(client, "\x04%s\x05 %s\x04 (Tank #%d)\x01 is disabled.", ST_PREFIX, sName, iType);
		return Plugin_Handled;
	}
	vTank(client, iType);
	return Plugin_Handled;
}

void vTank(int client, int type)
{
	g_bCmdUsed = true;
	g_iType = type;
	bIsL4D2Game() ? vCheatCommand(client, "z_spawn_old", "tank") : vCheatCommand(client, "z_spawn", "tank");
}

void vTankMenu(int client, int item)
{
	Menu mTankMenu = new Menu(iTankMenuHandler);
	mTankMenu.SetTitle("Super Tanks++ Menu");
	int iLimit = !g_bGeneralConfig ? g_iMaxTypes : g_iMaxTypes2;
	for (int iIndex = 1; iIndex <= iLimit; iIndex++)
	{
		int iTankEnabled = !g_bTankConfig[iIndex] ? g_iTankEnabled[iIndex] : g_iTankEnabled2[iIndex];
		if (iTankEnabled == 1)
		{
			!g_bTankConfig[iIndex] ? mTankMenu.AddItem(g_sCustomName[iIndex], g_sCustomName[iIndex]) : mTankMenu.AddItem(g_sCustomName2[iIndex], g_sCustomName2[iIndex]);
		}
	}
	mTankMenu.DisplayAt(client, item, MENU_TIME_FOREVER);
}

public int iTankMenuHandler(Menu menu, MenuAction action, int param1, int param2)
{
	switch (action)
	{
		case MenuAction_End: delete menu;
		case MenuAction_Select:
		{
			char sInfo[33];
			menu.GetItem(param2, sInfo, sizeof(sInfo));
			int iLimit = !g_bGeneralConfig ? g_iMaxTypes : g_iMaxTypes2;
			for (int iIndex = 1; iIndex <= iLimit; iIndex++)
			{
				char sName[33];
				sName = !g_bTankConfig[iIndex] ? g_sCustomName[iIndex] : g_sCustomName2[iIndex];
				if (strcmp(sInfo, sName) == 0)
				{
					vTank(param1, iIndex);
				}
			}
			if (IsClientInGame(param1) && !IsClientInKickQueue(param1))
			{
				vTankMenu(param1, menu.Selection);
			}
		}
	}
}

void vLoadConfigs(char[] savepath, bool main = false)
{
	if (!FileExists(savepath))
	{
		main ? SetFailState("Missing \"%s\" config file.", savepath) : PrintToServer("Missing \"%s\" config file.", savepath);
		return;
	}
	KeyValues kvSuperTanks = new KeyValues("Super Tanks++");
	if (!kvSuperTanks.ImportFromFile(savepath))
	{
		main ? SetFailState("Error reading from \"%s\" config file.", savepath) : PrintToServer("Error reading from \"%s\" config file.", savepath);
		delete kvSuperTanks;
		return;
	}
	if (kvSuperTanks.JumpToKey("General"))
	{
		main ? (g_bGeneralConfig = false) : (g_bGeneralConfig = true);
		main ? (g_iPluginEnabled = kvSuperTanks.GetNum("Plugin Enabled", 1)) : (g_iPluginEnabled2 = kvSuperTanks.GetNum("Plugin Enabled", g_iPluginEnabled));
		main ? (g_iPluginEnabled = iSetCellLimit(g_iPluginEnabled, 0, 1)) : (g_iPluginEnabled2 = iSetCellLimit(g_iPluginEnabled2, 0, 1));
		if (main)
		{
			kvSuperTanks.GetString("Enabled Game Modes", g_sEnabledGameModes, sizeof(g_sEnabledGameModes), "coop");
			kvSuperTanks.GetString("Disabled Game Modes", g_sDisabledGameModes, sizeof(g_sDisabledGameModes), "mutation1");
			g_iConfigEnable = kvSuperTanks.GetNum("Enable Custom Configs", 0);
			g_iConfigEnable = iSetCellLimit(g_iConfigEnable, 0, 1);
			kvSuperTanks.GetString("Create Config Types", g_sConfigCreate, sizeof(g_sConfigCreate), "12345");
			kvSuperTanks.GetString("Execute Config Types", g_sConfigExecute, sizeof(g_sConfigExecute), "1");
		}
		main ? (g_iAnnounceArrival = kvSuperTanks.GetNum("Announce Arrival", 1)) : (g_iAnnounceArrival2 = kvSuperTanks.GetNum("Announce Arrival", g_iAnnounceArrival));
		main ? (g_iAnnounceArrival = iSetCellLimit(g_iAnnounceArrival, 0, 1)) : (g_iAnnounceArrival2 = iSetCellLimit(g_iAnnounceArrival2, 0, 1));
		main ? (g_iDisplayHealth = kvSuperTanks.GetNum("Display Health", 3)) : (g_iDisplayHealth2 = kvSuperTanks.GetNum("Display Health", g_iDisplayHealth));
		main ? (g_iDisplayHealth = iSetCellLimit(g_iDisplayHealth, 0, 3)) : (g_iDisplayHealth2 = iSetCellLimit(g_iDisplayHealth2, 0, 3));
		main ? (g_iFinalesOnly = kvSuperTanks.GetNum("Finales Only", 0)) : (g_iFinalesOnly2 = kvSuperTanks.GetNum("Finales Only", g_iFinalesOnly));
		main ? (g_iFinalesOnly = iSetCellLimit(g_iFinalesOnly, 0, 1)) : (g_iFinalesOnly2 = iSetCellLimit(g_iFinalesOnly2, 0, 1));
		main ? (g_iHumanSupport = kvSuperTanks.GetNum("Human Super Tanks", 1)) : (g_iHumanSupport2 = kvSuperTanks.GetNum("Human Super Tanks", g_iHumanSupport));
		main ? (g_iHumanSupport = iSetCellLimit(g_iHumanSupport, 0, 1)) : (g_iHumanSupport2 = iSetCellLimit(g_iHumanSupport2, 0, 1));
		main ? (g_iMaxTypes = kvSuperTanks.GetNum("Maximum Types", MAXTYPES)) : (g_iMaxTypes2 = kvSuperTanks.GetNum("Maximum Types", g_iMaxTypes));
		main ? (g_iMaxTypes = iSetCellLimit(g_iMaxTypes, 1, MAXTYPES)) : (g_iMaxTypes2 = iSetCellLimit(g_iMaxTypes2, 1, MAXTYPES));
		main ? (g_iMultiHealth = kvSuperTanks.GetNum("Multiply Health", 0)) : (g_iMultiHealth2 = kvSuperTanks.GetNum("Multiply Health", g_iMultiHealth));
		main ? (g_iMultiHealth = iSetCellLimit(g_iMultiHealth, 0, 3)) : (g_iMultiHealth2 = iSetCellLimit(g_iMultiHealth2, 0, 3));
		main ? (kvSuperTanks.GetString("Tank Waves", g_sTankWaves, sizeof(g_sTankWaves), "1,2,3")) : (kvSuperTanks.GetString("Tank Waves", g_sTankWaves2, sizeof(g_sTankWaves2), g_sTankWaves));
		kvSuperTanks.Rewind();
	}
	int iLimit = main ? g_iMaxTypes : g_iMaxTypes2;
	for (int iIndex = 1; iIndex <= iLimit; iIndex++)
	{
		char sName[33];
		Format(sName, sizeof(sName), "Tank %d", iIndex);
		if (kvSuperTanks.JumpToKey(sName))
		{
			main ? (g_bTankConfig[iIndex] = false) : (g_bTankConfig[iIndex] = true);
			main ? (kvSuperTanks.GetString("Tank Name", g_sCustomName[iIndex], sizeof(g_sCustomName[]), sName)) : (kvSuperTanks.GetString("Tank Name", g_sCustomName2[iIndex], sizeof(g_sCustomName2[]), g_sCustomName[iIndex]));
			main ? (g_iTankEnabled[iIndex] = kvSuperTanks.GetNum("Tank Enabled", 0)) : (g_iTankEnabled2[iIndex] = kvSuperTanks.GetNum("Tank Enabled", g_iTankEnabled[iIndex]));
			main ? (g_iTankEnabled[iIndex] = iSetCellLimit(g_iTankEnabled[iIndex], 0, 1)) : (g_iTankEnabled2[iIndex] = iSetCellLimit(g_iTankEnabled2[iIndex], 0, 1));
			main ? (kvSuperTanks.GetString("Skin-Glow Colors", g_sTankColors[iIndex], sizeof(g_sTankColors[]), "255,255,255,255|255,255,255")) : (kvSuperTanks.GetString("Skin-Glow Colors", g_sTankColors2[iIndex], sizeof(g_sTankColors2[]), g_sTankColors[iIndex]));
			main ? (kvSuperTanks.GetString("Props Attached", g_sPropsAttached[iIndex], sizeof(g_sPropsAttached[]), "12345")) : (kvSuperTanks.GetString("Props Attached", g_sPropsAttached2[iIndex], sizeof(g_sPropsAttached2[]), g_sPropsAttached[iIndex]));
			main ? (kvSuperTanks.GetString("Props Chance", g_sPropsChance[iIndex], sizeof(g_sPropsChance[]), "3,3,3,3,3")) : (kvSuperTanks.GetString("Props Chance", g_sPropsChance2[iIndex], sizeof(g_sPropsChance2[]), g_sPropsChance[iIndex]));
			main ? (kvSuperTanks.GetString("Props Colors", g_sPropsColors[iIndex], sizeof(g_sPropsColors[]), "255,255,255,255|255,255,255,255|255,255,255,125|255,255,255,255|255,255,255,255")) : (kvSuperTanks.GetString("Props Colors", g_sPropsColors2[iIndex], sizeof(g_sPropsColors2[]), g_sPropsColors[iIndex]));
			main ? (g_iGlowEffect[iIndex] = kvSuperTanks.GetNum("Glow Effect", 1)) : (g_iGlowEffect2[iIndex] = kvSuperTanks.GetNum("Glow Effect", g_iGlowEffect[iIndex]));
			main ? (g_iGlowEffect[iIndex] = iSetCellLimit(g_iGlowEffect[iIndex], 0, 1)) : (g_iGlowEffect2[iIndex] = iSetCellLimit(g_iGlowEffect2[iIndex], 0, 1));
			main ? (g_iParticleEffect[iIndex] = kvSuperTanks.GetNum("Particle Effect", 0)) : (g_iParticleEffect2[iIndex] = kvSuperTanks.GetNum("Particle Effect", g_iParticleEffect[iIndex]));
			main ? (g_iParticleEffect[iIndex] = iSetCellLimit(g_iParticleEffect[iIndex], 0, 1)) : (g_iParticleEffect2[iIndex] = iSetCellLimit(g_iParticleEffect2[iIndex], 0, 1));
			main ? (kvSuperTanks.GetString("Particle Effects", g_sParticleEffects[iIndex], sizeof(g_sParticleEffects[]), "1234567")) : (kvSuperTanks.GetString("Particle Effects", g_sParticleEffects2[iIndex], sizeof(g_sParticleEffects2[]), g_sParticleEffects[iIndex]));
			main ? (g_iAbsorbAbility[iIndex] = kvSuperTanks.GetNum("Absorb Ability", 0)) : (g_iAbsorbAbility2[iIndex] = kvSuperTanks.GetNum("Absorb Ability", g_iAbsorbAbility[iIndex]));
			main ? (g_iAbsorbAbility[iIndex] = iSetCellLimit(g_iAbsorbAbility[iIndex], 0, 1)) : (g_iAbsorbAbility2[iIndex] = iSetCellLimit(g_iAbsorbAbility2[iIndex], 0, 1));
			main ? (g_iAcidChance[iIndex] = kvSuperTanks.GetNum("Acid Chance", 4)) : (g_iAcidChance2[iIndex] = kvSuperTanks.GetNum("Acid Chance", g_iAcidChance[iIndex]));
			main ? (g_iAcidChance[iIndex] = iSetCellLimit(g_iAcidChance[iIndex], 1, 99999)) : (g_iAcidChance2[iIndex] = iSetCellLimit(g_iAcidChance2[iIndex], 1, 99999));
			main ? (g_iAcidHit[iIndex] = kvSuperTanks.GetNum("Acid Claw-Rock", 0)) : (g_iAcidHit2[iIndex] = kvSuperTanks.GetNum("Acid Claw-Rock", g_iAcidHit[iIndex]));
			main ? (g_iAcidHit[iIndex] = iSetCellLimit(g_iAcidHit[iIndex], 0, 1)) : (g_iAcidHit2[iIndex] = iSetCellLimit(g_iAcidHit2[iIndex], 0, 1));
			main ? (g_iAcidRock[iIndex] = kvSuperTanks.GetNum("Acid Rock Break", 0)) : (g_iAcidRock2[iIndex] = kvSuperTanks.GetNum("Acid Rock Break", g_iAcidRock[iIndex]));
			main ? (g_iAcidRock[iIndex] = iSetCellLimit(g_iAcidRock[iIndex], 0, 1)) : (g_iAcidRock2[iIndex] = iSetCellLimit(g_iAcidRock2[iIndex], 0, 1));
			main ? (g_iAmmoChance[iIndex] = kvSuperTanks.GetNum("Ammo Chance", 4)) : (g_iAmmoChance2[iIndex] = kvSuperTanks.GetNum("Ammo Chance", g_iAmmoChance[iIndex]));
			main ? (g_iAmmoChance[iIndex] = iSetCellLimit(g_iAmmoChance[iIndex], 1, 99999)) : (g_iAmmoChance2[iIndex] = iSetCellLimit(g_iAmmoChance2[iIndex], 1, 99999));
			main ? (g_iAmmoCount[iIndex] = kvSuperTanks.GetNum("Ammo Count", 0)) : (g_iAmmoCount2[iIndex] = kvSuperTanks.GetNum("Ammo Count", g_iAmmoCount[iIndex]));
			main ? (g_iAmmoCount[iIndex] = iSetCellLimit(g_iAmmoCount[iIndex], 0, 25)) : (g_iAmmoCount2[iIndex] = iSetCellLimit(g_iAmmoCount2[iIndex], 0, 25));
			main ? (g_iAmmoHit[iIndex] = kvSuperTanks.GetNum("Ammo Claw-Rock", 0)) : (g_iAmmoHit2[iIndex] = kvSuperTanks.GetNum("Ammo Claw-Rock", g_iAmmoHit[iIndex]));
			main ? (g_iAmmoHit[iIndex] = iSetCellLimit(g_iAmmoHit[iIndex], 0, 1)) : (g_iAmmoHit2[iIndex] = iSetCellLimit(g_iAmmoHit2[iIndex], 0, 1));
			main ? (g_iBlindChance[iIndex] = kvSuperTanks.GetNum("Blind Chance", 4)) : (g_iBlindChance2[iIndex] = kvSuperTanks.GetNum("Blind Chance", g_iBlindChance[iIndex]));
			main ? (g_iBlindChance[iIndex] = iSetCellLimit(g_iBlindChance[iIndex], 1, 99999)) : (g_iBlindChance2[iIndex] = iSetCellLimit(g_iBlindChance2[iIndex], 1, 99999));
			main ? (g_flBlindDuration[iIndex] = kvSuperTanks.GetFloat("Blind Duration", 5.0)) : (g_flBlindDuration2[iIndex] = kvSuperTanks.GetFloat("Blind Duration", g_flBlindDuration[iIndex]));
			main ? (g_flBlindDuration[iIndex] = flSetFloatLimit(g_flBlindDuration[iIndex], 0.1, 99999.0)) : (g_flBlindDuration2[iIndex] = flSetFloatLimit(g_flBlindDuration2[iIndex], 0.1, 99999.0));
			main ? (g_iBlindHit[iIndex] = kvSuperTanks.GetNum("Blind Claw-Rock", 0)) : (g_iBlindHit2[iIndex] = kvSuperTanks.GetNum("Blind Claw-Rock", g_iBlindHit[iIndex]));
			main ? (g_iBlindHit[iIndex] = iSetCellLimit(g_iBlindHit[iIndex], 0, 1)) : (g_iBlindHit2[iIndex] = iSetCellLimit(g_iBlindHit2[iIndex], 0, 1));
			main ? (g_iBlindIntensity[iIndex] = kvSuperTanks.GetNum("Blind Intensity", 255)) : (g_iBlindIntensity2[iIndex] = kvSuperTanks.GetNum("Blind Intensity", g_iBlindIntensity[iIndex]));
			main ? (g_iBlindIntensity[iIndex] = iSetCellLimit(g_iBlindIntensity[iIndex], 0, 255)) : (g_iBlindIntensity2[iIndex] = iSetCellLimit(g_iBlindIntensity2[iIndex], 0, 255));
			main ? (g_iBombChance[iIndex] = kvSuperTanks.GetNum("Bomb Chance", 4)) : (g_iBombChance2[iIndex] = kvSuperTanks.GetNum("Bomb Chance", g_iBombChance[iIndex]));
			main ? (g_iBombChance[iIndex] = iSetCellLimit(g_iBombChance[iIndex], 1, 99999)) : (g_iBombChance2[iIndex] = iSetCellLimit(g_iBombChance2[iIndex], 1, 99999));
			main ? (g_iBombHit[iIndex] = kvSuperTanks.GetNum("Bomb Claw-Rock", 0)) : (g_iBombHit2[iIndex] = kvSuperTanks.GetNum("Bomb Claw-Rock", g_iBombHit[iIndex]));
			main ? (g_iBombHit[iIndex] = iSetCellLimit(g_iBombHit[iIndex], 0, 1)) : (g_iBombHit2[iIndex] = iSetCellLimit(g_iBombHit2[iIndex], 0, 1));
			main ? (g_iBombRock[iIndex] = kvSuperTanks.GetNum("Bomb Rock Break", 0)) : (g_iBombRock2[iIndex] = kvSuperTanks.GetNum("Bomb Rock Break", g_iBombRock[iIndex]));
			main ? (g_iBombRock[iIndex] = iSetCellLimit(g_iBombRock[iIndex], 0, 1)) : (g_iBombRock2[iIndex] = iSetCellLimit(g_iBombRock2[iIndex], 0, 1));
			main ? (g_iBulletImmunity[iIndex] = kvSuperTanks.GetNum("Bullet Immunity", 0)) : (g_iBulletImmunity2[iIndex] = kvSuperTanks.GetNum("Bullet Immunity", g_iBulletImmunity[iIndex]));
			main ? (g_iBulletImmunity[iIndex] = iSetCellLimit(g_iBulletImmunity[iIndex], 0, 1)) : (g_iBulletImmunity2[iIndex] = iSetCellLimit(g_iBulletImmunity2[iIndex], 0, 1));
			main ? (g_iBuryChance[iIndex] = kvSuperTanks.GetNum("Bury Chance", 4)) : (g_iBuryChance2[iIndex] = kvSuperTanks.GetNum("Bury Chance", g_iBuryChance[iIndex]));
			main ? (g_iBuryChance[iIndex] = iSetCellLimit(g_iBuryChance[iIndex], 1, 99999)) : (g_iBuryChance2[iIndex] = iSetCellLimit(g_iBuryChance2[iIndex], 1, 99999));
			main ? (g_flBuryDuration[iIndex] = kvSuperTanks.GetFloat("Bury Duration", 5.0)) : (g_flBuryDuration2[iIndex] = kvSuperTanks.GetFloat("Bury Duration", g_flBuryDuration[iIndex]));
			main ? (g_flBuryDuration[iIndex] = flSetFloatLimit(g_flBuryDuration[iIndex], 0.1, 99999.0)) : (g_flBuryDuration2[iIndex] = flSetFloatLimit(g_flBuryDuration2[iIndex], 0.1, 99999.0));
			main ? (g_flBuryHeight[iIndex] = kvSuperTanks.GetFloat("Bury Height", 50.0)) : (g_flBuryHeight2[iIndex] = kvSuperTanks.GetFloat("Bury Height", g_flBuryHeight[iIndex]));
			main ? (g_flBuryHeight[iIndex] = flSetFloatLimit(g_flBuryHeight[iIndex], 0.1, 99999.0)) : (g_flBuryHeight2[iIndex] = flSetFloatLimit(g_flBuryHeight2[iIndex], 0.1, 99999.0));
			main ? (g_iBuryHit[iIndex] = kvSuperTanks.GetNum("Bury Claw-Rock", 0)) : (g_iBuryHit2[iIndex] = kvSuperTanks.GetNum("Bury Claw-Rock", g_iBuryHit[iIndex]));
			main ? (g_iBuryHit[iIndex] = iSetCellLimit(g_iBuryHit[iIndex], 0, 1)) : (g_iBuryHit2[iIndex] = iSetCellLimit(g_iBuryHit2[iIndex], 0, 1));
			main ? (g_iCarThrow[iIndex] = kvSuperTanks.GetNum("Car Throw Ability", 0)) : (g_iCarThrow2[iIndex] = kvSuperTanks.GetNum("Car Throw Ability", g_iCarThrow[iIndex]));
			main ? (g_iCarThrow[iIndex] = iSetCellLimit(g_iCarThrow[iIndex], 0, 1)) : (g_iCarThrow2[iIndex] = iSetCellLimit(g_iCarThrow2[iIndex], 0, 1));
			main ? (g_iCommonAbility[iIndex] = kvSuperTanks.GetNum("Common Ability", 0)) : (g_iCommonAbility2[iIndex] = kvSuperTanks.GetNum("Common Ability", g_iCommonAbility[iIndex]));
			main ? (g_iCommonAbility[iIndex] = iSetCellLimit(g_iCommonAbility[iIndex], 0, 1)) : (g_iCommonAbility2[iIndex] = iSetCellLimit(g_iCommonAbility2[iIndex], 0, 1));
			main ? (g_iCommonAmount[iIndex] = kvSuperTanks.GetNum("Common Amount", 10)) : (g_iCommonAmount2[iIndex] = kvSuperTanks.GetNum("Common Amount", g_iCommonAmount[iIndex]));
			main ? (g_iCommonAmount[iIndex] = iSetCellLimit(g_iCommonAmount[iIndex], 1, 100)) : (g_iCommonAmount2[iIndex] = iSetCellLimit(g_iCommonAmount2[iIndex], 1, 100));
			main ? (g_iDrugChance[iIndex] = kvSuperTanks.GetNum("Drug Chance", 4)) : (g_iDrugChance2[iIndex] = kvSuperTanks.GetNum("Drug Chance", g_iDrugChance[iIndex]));
			main ? (g_iDrugChance[iIndex] = iSetCellLimit(g_iDrugChance[iIndex], 1, 99999)) : (g_iDrugChance2[iIndex] = iSetCellLimit(g_iDrugChance2[iIndex], 1, 99999));
			main ? (g_flDrugDuration[iIndex] = kvSuperTanks.GetFloat("Drug Duration", 5.0)) : (g_flDrugDuration2[iIndex] = kvSuperTanks.GetFloat("Drug Duration", g_flDrugDuration[iIndex]));
			main ? (g_flDrugDuration[iIndex] = flSetFloatLimit(g_flDrugDuration[iIndex], 0.1, 99999.0)) : (g_flDrugDuration2[iIndex] = flSetFloatLimit(g_flDrugDuration2[iIndex], 0.1, 99999.0));
			main ? (g_iDrugHit[iIndex] = kvSuperTanks.GetNum("Drug Claw-Rock", 0)) : (g_iDrugHit2[iIndex] = kvSuperTanks.GetNum("Drug Claw-Rock", g_iDrugHit[iIndex]));
			main ? (g_iDrugHit[iIndex] = iSetCellLimit(g_iDrugHit[iIndex], 0, 1)) : (g_iDrugHit2[iIndex] = iSetCellLimit(g_iDrugHit2[iIndex], 0, 1));
			main ? (g_iExplosiveImmunity[iIndex] = kvSuperTanks.GetNum("Explosive Immunity", 0)) : (g_iExplosiveImmunity2[iIndex] = kvSuperTanks.GetNum("Explosive Immunity", g_iExplosiveImmunity[iIndex]));
			main ? (g_iExplosiveImmunity[iIndex] = iSetCellLimit(g_iExplosiveImmunity[iIndex], 0, 1)) : (g_iExplosiveImmunity2[iIndex] = iSetCellLimit(g_iExplosiveImmunity2[iIndex], 0, 1));
			main ? (g_iExtraHealth[iIndex] = kvSuperTanks.GetNum("Extra Health", 0)) : (g_iExtraHealth2[iIndex] = kvSuperTanks.GetNum("Extra Health", g_iExtraHealth[iIndex]));
			main ? (g_iExtraHealth[iIndex] = iSetCellLimit(g_iExtraHealth[iIndex], 0, 62400)) : (g_iExtraHealth2[iIndex] = iSetCellLimit(g_iExtraHealth2[iIndex], 0, 62400));
			main ? (g_iFireChance[iIndex] = kvSuperTanks.GetNum("Fire Chance", 4)) : (g_iFireChance2[iIndex] = kvSuperTanks.GetNum("Fire Chance", g_iFireChance[iIndex]));
			main ? (g_iFireChance[iIndex] = iSetCellLimit(g_iFireChance[iIndex], 1, 99999)) : (g_iFireChance2[iIndex] = iSetCellLimit(g_iFireChance2[iIndex], 1, 99999));
			main ? (g_iFireHit[iIndex] = kvSuperTanks.GetNum("Fire Claw-Rock", 0)) : (g_iFireHit2[iIndex] = kvSuperTanks.GetNum("Fire Claw-Rock", g_iFireHit[iIndex]));
			main ? (g_iFireHit[iIndex] = iSetCellLimit(g_iFireHit[iIndex], 0, 1)) : (g_iFireHit2[iIndex] = iSetCellLimit(g_iFireHit2[iIndex], 0, 1));
			main ? (g_iFireImmunity[iIndex] = kvSuperTanks.GetNum("Fire Immunity", 0)) : (g_iFireImmunity2[iIndex] = kvSuperTanks.GetNum("Fire Immunity", g_iFireImmunity[iIndex]));
			main ? (g_iFireImmunity[iIndex] = iSetCellLimit(g_iFireImmunity[iIndex], 0, 1)) : (g_iFireImmunity2[iIndex] = iSetCellLimit(g_iFireImmunity2[iIndex], 0, 1));
			main ? (g_iFireRock[iIndex] = kvSuperTanks.GetNum("Fire Rock Break", 0)) : (g_iFireRock2[iIndex] = kvSuperTanks.GetNum("Fire Rock Break", g_iFireRock[iIndex]));
			main ? (g_iFireRock[iIndex] = iSetCellLimit(g_iFireRock[iIndex], 0, 1)) : (g_iFireRock2[iIndex] = iSetCellLimit(g_iFireRock2[iIndex], 0, 1));
			main ? (g_iFlashAbility[iIndex] = kvSuperTanks.GetNum("Flash Ability", 0)) : (g_iFlashAbility2[iIndex] = kvSuperTanks.GetNum("Flash Ability", g_iFlashAbility[iIndex]));
			main ? (g_iFlashAbility[iIndex] = iSetCellLimit(g_iFlashAbility[iIndex], 0, 1)) : (g_iFlashAbility2[iIndex] = iSetCellLimit(g_iFlashAbility2[iIndex], 0, 1));
			main ? (g_iFlashChance[iIndex] = kvSuperTanks.GetNum("Flash Chance", 4)) : (g_iFlashChance2[iIndex] = kvSuperTanks.GetNum("Flash Chance", g_iFlashChance[iIndex]));
			main ? (g_iFlashChance[iIndex] = iSetCellLimit(g_iFlashChance[iIndex], 1, 99999)) : (g_iFlashChance2[iIndex] = iSetCellLimit(g_iFlashChance2[iIndex], 1, 99999));
			main ? (g_flFlashSpeed[iIndex] = kvSuperTanks.GetFloat("Flash Speed", 5.0)) : (g_flFlashSpeed2[iIndex] = kvSuperTanks.GetFloat("Flash Speed", g_flFlashSpeed[iIndex]));
			main ? (g_flFlashSpeed[iIndex] = flSetFloatLimit(g_flFlashSpeed[iIndex], 3.0, 8.0)) : (g_flFlashSpeed2[iIndex] = flSetFloatLimit(g_flFlashSpeed2[iIndex], 3.0, 8.0));
			main ? (g_iFlingChance[iIndex] = kvSuperTanks.GetNum("Fling Chance", 4)) : (g_iFlingChance2[iIndex] = kvSuperTanks.GetNum("Fling Chance", g_iFlingChance[iIndex]));
			main ? (g_iFlingChance[iIndex] = iSetCellLimit(g_iFlingChance[iIndex], 1, 99999)) : (g_iFlingChance2[iIndex] = iSetCellLimit(g_iFlingChance2[iIndex], 1, 99999));
			main ? (g_iFlingHit[iIndex] = kvSuperTanks.GetNum("Fling Claw-Rock", 0)) : (g_iFlingHit2[iIndex] = kvSuperTanks.GetNum("Fling Claw-Rock", g_iFlingHit[iIndex]));
			main ? (g_iFlingHit[iIndex] = iSetCellLimit(g_iFlingHit[iIndex], 0, 1)) : (g_iFlingHit2[iIndex] = iSetCellLimit(g_iFlingHit2[iIndex], 0, 1));
			main ? (g_iGhostAbility[iIndex] = kvSuperTanks.GetNum("Ghost Ability", 0)) : (g_iGhostAbility2[iIndex] = kvSuperTanks.GetNum("Ghost Ability", g_iGhostAbility[iIndex]));
			main ? (g_iGhostAbility[iIndex] = iSetCellLimit(g_iGhostAbility[iIndex], 0, 1)) : (g_iGhostAbility2[iIndex] = iSetCellLimit(g_iGhostAbility2[iIndex], 0, 1));
			main ? (g_iGhostChance[iIndex] = kvSuperTanks.GetNum("Ghost Chance", 4)) : (g_iGhostChance2[iIndex] = kvSuperTanks.GetNum("Ghost Chance", g_iGhostChance[iIndex]));
			main ? (g_iGhostChance[iIndex] = iSetCellLimit(g_iGhostChance[iIndex], 1, 99999)) : (g_iGhostChance2[iIndex] = iSetCellLimit(g_iGhostChance2[iIndex], 1, 99999));
			main ? (g_iGhostFade[iIndex] = kvSuperTanks.GetNum("Ghost Fade Limit", 255)) : (g_iGhostFade2[iIndex] = kvSuperTanks.GetNum("Ghost Fade Limit", g_iGhostFade[iIndex]));
			main ? (g_iGhostFade[iIndex] = iSetCellLimit(g_iGhostFade[iIndex], 0, 255)) : (g_iGhostFade2[iIndex] = iSetCellLimit(g_iGhostFade2[iIndex], 0, 255));
			main ? (g_iGhostHit[iIndex] = kvSuperTanks.GetNum("Ghost Claw-Rock", 0)) : (g_iGhostHit2[iIndex] = kvSuperTanks.GetNum("Ghost Claw-Rock", g_iGhostHit[iIndex]));
			main ? (g_iGhostHit[iIndex] = iSetCellLimit(g_iGhostHit[iIndex], 0, 1)) : (g_iGhostHit2[iIndex] = iSetCellLimit(g_iGhostHit2[iIndex], 0, 1));
			main ? (kvSuperTanks.GetString("Ghost Weapon Slots", g_sWeaponSlot[iIndex], sizeof(g_sWeaponSlot[]), "12345")) : (kvSuperTanks.GetString("Ghost Weapon Slots", g_sWeaponSlot2[iIndex], sizeof(g_sWeaponSlot2[]), g_sWeaponSlot[iIndex]));
			main ? (g_iGravityAbility[iIndex] = kvSuperTanks.GetNum("Gravity Ability", 0)) : (g_iGravityAbility2[iIndex] = kvSuperTanks.GetNum("Gravity Ability", g_iGravityAbility[iIndex]));
			main ? (g_iGravityAbility[iIndex] = iSetCellLimit(g_iGravityAbility[iIndex], 0, 1)) : (g_iGravityAbility2[iIndex] = iSetCellLimit(g_iGravityAbility2[iIndex], 0, 1));
			main ? (g_iGravityChance[iIndex] = kvSuperTanks.GetNum("Gravity Chance", 4)) : (g_iGravityChance2[iIndex] = kvSuperTanks.GetNum("Gravity Chance", g_iGravityChance[iIndex]));
			main ? (g_iGravityChance[iIndex] = iSetCellLimit(g_iGravityChance[iIndex], 1, 99999)) : (g_iGravityChance2[iIndex] = iSetCellLimit(g_iGravityChance2[iIndex], 1, 99999));
			main ? (g_flGravityDuration[iIndex] = kvSuperTanks.GetFloat("Gravity Duration", 5.0)) : (g_flGravityDuration2[iIndex] = kvSuperTanks.GetFloat("Gravity Duration", g_flGravityDuration[iIndex]));
			main ? (g_flGravityDuration[iIndex] = flSetFloatLimit(g_flGravityDuration[iIndex], 0.1, 99999.0)) : (g_flGravityDuration2[iIndex] = flSetFloatLimit(g_flGravityDuration2[iIndex], 0.1, 99999.0));
			main ? (g_flGravityForce[iIndex] = kvSuperTanks.GetFloat("Gravity Force", -50.0)) : (g_flGravityForce2[iIndex] = kvSuperTanks.GetFloat("Gravity Force", g_flGravityForce[iIndex]));
			main ? (g_flGravityForce[iIndex] = flSetFloatLimit(g_flGravityForce[iIndex], -100.0, 100.0)) : (g_flGravityForce2[iIndex] = flSetFloatLimit(g_flGravityForce2[iIndex], -100.0, 100.0));
			main ? (g_iGravityHit[iIndex] = kvSuperTanks.GetNum("Gravity Claw-Rock", 0)) : (g_iGravityHit2[iIndex] = kvSuperTanks.GetNum("Gravity Claw-Rock", g_iGravityHit[iIndex]));
			main ? (g_iGravityHit[iIndex] = iSetCellLimit(g_iGravityHit[iIndex], 0, 1)) : (g_iGravityHit2[iIndex] = iSetCellLimit(g_iGravityHit2[iIndex], 0, 1));
			main ? (g_flGravityValue[iIndex] = kvSuperTanks.GetFloat("Gravity Value", 0.3)) : (g_flGravityValue2[iIndex] = kvSuperTanks.GetFloat("Gravity Value", g_flGravityValue[iIndex]));
			main ? (g_flGravityValue[iIndex] = flSetFloatLimit(g_flGravityValue[iIndex], 0.1, 0.99)) : (g_flGravityValue2[iIndex] = flSetFloatLimit(g_flGravityValue2[iIndex], 0.1, 0.99));
			main ? (g_iHealAbility[iIndex] = kvSuperTanks.GetNum("Heal Ability", 0)) : (g_iHealAbility2[iIndex] = kvSuperTanks.GetNum("Heal Ability", g_iHealAbility[iIndex]));
			main ? (g_iHealAbility[iIndex] = iSetCellLimit(g_iHealAbility[iIndex], 0, 1)) : (g_iHealAbility2[iIndex] = iSetCellLimit(g_iHealAbility2[iIndex], 0, 1));
			main ? (g_iHealChance[iIndex] = kvSuperTanks.GetNum("Heal Chance", 4)) : (g_iHealChance2[iIndex] = kvSuperTanks.GetNum("Heal Chance", g_iHealChance[iIndex]));
			main ? (g_iHealChance[iIndex] = iSetCellLimit(g_iHealChance[iIndex], 1, 99999)) : (g_iHealChance2[iIndex] = iSetCellLimit(g_iHealChance2[iIndex], 1, 99999));
			main ? (g_iHealCommon[iIndex] = kvSuperTanks.GetNum("Health From Commons", 50)) : (g_iHealCommon2[iIndex] = kvSuperTanks.GetNum("Health From Commons", g_iHealCommon[iIndex]));
			main ? (g_iHealCommon[iIndex] = iSetCellLimit(g_iHealCommon[iIndex], 0, 62400)) : (g_iHealCommon2[iIndex] = iSetCellLimit(g_iHealCommon2[iIndex], 0, 62400));
			main ? (g_iHealHit[iIndex] = kvSuperTanks.GetNum("Heal Claw-Rock", 0)) : (g_iHealHit2[iIndex] = kvSuperTanks.GetNum("Heal Claw-Rock", g_iHealHit[iIndex]));
			main ? (g_iHealHit[iIndex] = iSetCellLimit(g_iHealHit[iIndex], 0, 1)) : (g_iHealHit2[iIndex] = iSetCellLimit(g_iHealHit2[iIndex], 0, 1));
			main ? (g_flHealInterval[iIndex] = kvSuperTanks.GetFloat("Heal Interval", 5.0)) : (g_flHealInterval2[iIndex] = kvSuperTanks.GetFloat("Heal Interval", g_flHealInterval[iIndex]));
			main ? (g_flHealInterval[iIndex] = flSetFloatLimit(g_flHealInterval[iIndex], 0.1, 99999.0)) : (g_flHealInterval2[iIndex] = flSetFloatLimit(g_flHealInterval2[iIndex], 0.1, 99999.0));
			main ? (g_iHealSpecial[iIndex] = kvSuperTanks.GetNum("Health From Specials", 100)) : (g_iHealSpecial2[iIndex] = kvSuperTanks.GetNum("Health From Specials", g_iHealSpecial[iIndex]));
			main ? (g_iHealSpecial[iIndex] = iSetCellLimit(g_iHealSpecial[iIndex], 0, 62400)) : (g_iHealSpecial2[iIndex] = iSetCellLimit(g_iHealSpecial2[iIndex], 0, 62400));
			main ? (g_iHealTank[iIndex] = kvSuperTanks.GetNum("Health From Tanks", 500)) : (g_iHealTank2[iIndex] = kvSuperTanks.GetNum("Health From Tanks", g_iHealTank[iIndex]));
			main ? (g_iHealTank[iIndex] = iSetCellLimit(g_iHealTank[iIndex], 0, 62400)) : (g_iHealTank2[iIndex] = iSetCellLimit(g_iHealTank2[iIndex], 0, 62400));
			main ? (g_iHurtAbility[iIndex] = kvSuperTanks.GetNum("Hurt Ability", 0)) : (g_iHurtAbility2[iIndex] = kvSuperTanks.GetNum("Hurt Ability", g_iHurtAbility[iIndex]));
			main ? (g_iHurtAbility[iIndex] = iSetCellLimit(g_iHurtAbility[iIndex], 0, 1)) : (g_iHurtAbility2[iIndex] = iSetCellLimit(g_iHurtAbility2[iIndex], 0, 1));
			main ? (g_iHurtChance[iIndex] = kvSuperTanks.GetNum("Hurt Chance", 4)) : (g_iHurtChance2[iIndex] = kvSuperTanks.GetNum("Hurt Chance", g_iHurtChance[iIndex]));
			main ? (g_iHurtChance[iIndex] = iSetCellLimit(g_iHurtChance[iIndex], 1, 99999)) : (g_iHurtChance2[iIndex] = iSetCellLimit(g_iHurtChance2[iIndex], 1, 99999));
			main ? (g_iHurtDamage[iIndex] = kvSuperTanks.GetNum("Hurt Damage", 1)) : (g_iHurtDamage2[iIndex] = kvSuperTanks.GetNum("Hurt Damage", g_iHurtDamage[iIndex]));
			main ? (g_iHurtDamage[iIndex] = iSetCellLimit(g_iHurtDamage[iIndex], 1, 99999)) : (g_iHurtDamage2[iIndex] = iSetCellLimit(g_iHurtDamage2[iIndex], 1, 99999));
			main ? (g_flHurtDuration[iIndex] = kvSuperTanks.GetFloat("Hurt Duration", 5.0)) : (g_flHurtDuration2[iIndex] = kvSuperTanks.GetFloat("Hurt Duration", g_flHurtDuration[iIndex]));
			main ? (g_flHurtDuration[iIndex] = flSetFloatLimit(g_flHurtDuration[iIndex], 0.1, 99999.0)) : (g_flHurtDuration2[iIndex] = flSetFloatLimit(g_flHurtDuration2[iIndex], 0.1, 99999.0));
			main ? (g_iHypnoChance[iIndex] = kvSuperTanks.GetNum("Hypno Chance", 4)) : (g_iHypnoChance2[iIndex] = kvSuperTanks.GetNum("Hypno Chance", g_iHypnoChance[iIndex]));
			main ? (g_iHypnoChance[iIndex] = iSetCellLimit(g_iHypnoChance[iIndex], 1, 99999)) : (g_iHypnoChance2[iIndex] = iSetCellLimit(g_iHypnoChance2[iIndex], 1, 99999));
			main ? (g_flHypnoDuration[iIndex] = kvSuperTanks.GetFloat("Hypno Duration", 5.0)) : (g_flHypnoDuration2[iIndex] = kvSuperTanks.GetFloat("Hypno Duration", g_flHypnoDuration[iIndex]));
			main ? (g_flHypnoDuration[iIndex] = flSetFloatLimit(g_flHypnoDuration[iIndex], 0.1, 99999.0)) : (g_flHypnoDuration2[iIndex] = flSetFloatLimit(g_flHypnoDuration2[iIndex], 0.1, 99999.0));
			main ? (g_iHypnoHit[iIndex] = kvSuperTanks.GetNum("Hypno Claw-Rock", 0)) : (g_iHypnoHit2[iIndex] = kvSuperTanks.GetNum("Hypno Claw-Rock", g_iHypnoHit[iIndex]));
			main ? (g_iHypnoHit[iIndex] = iSetCellLimit(g_iHypnoHit[iIndex], 0, 1)) : (g_iHypnoHit2[iIndex] = iSetCellLimit(g_iHypnoHit2[iIndex], 0, 1));
			main ? (g_iHypnoMode[iIndex] = kvSuperTanks.GetNum("Hypno Mode", 0)) : (g_iHypnoMode2[iIndex] = kvSuperTanks.GetNum("Hypno Mode", g_iHypnoMode[iIndex]));
			main ? (g_iHypnoMode[iIndex] = iSetCellLimit(g_iHypnoMode[iIndex], 0, 1)) : (g_iHypnoMode2[iIndex] = iSetCellLimit(g_iHypnoMode2[iIndex], 0, 1));
			main ? (g_iIceChance[iIndex] = kvSuperTanks.GetNum("Ice Chance", 4)) : (g_iIceChance2[iIndex] = kvSuperTanks.GetNum("Ice Chance", g_iIceChance[iIndex]));
			main ? (g_iIceChance[iIndex] = iSetCellLimit(g_iIceChance[iIndex], 1, 99999)) : (g_iIceChance2[iIndex] = iSetCellLimit(g_iIceChance2[iIndex], 1, 99999));
			main ? (g_iIceHit[iIndex] = kvSuperTanks.GetNum("Ice Claw-Rock", 0)) : (g_iIceHit2[iIndex] = kvSuperTanks.GetNum("Ice Claw-Rock", g_iIceHit[iIndex]));
			main ? (g_iIceHit[iIndex] = iSetCellLimit(g_iIceHit[iIndex], 0, 1)) : (g_iIceHit2[iIndex] = iSetCellLimit(g_iIceHit2[iIndex], 0, 1));
			main ? (g_iIdleChance[iIndex] = kvSuperTanks.GetNum("Idle Chance", 4)) : (g_iIdleChance2[iIndex] = kvSuperTanks.GetNum("Idle Chance", g_iIdleChance[iIndex]));
			main ? (g_iIdleChance[iIndex] = iSetCellLimit(g_iIdleChance[iIndex], 1, 99999)) : (g_iIdleChance2[iIndex] = iSetCellLimit(g_iIdleChance2[iIndex], 1, 99999));
			main ? (g_iIdleHit[iIndex] = kvSuperTanks.GetNum("Idle Claw-Rock", 0)) : (g_iIdleHit2[iIndex] = kvSuperTanks.GetNum("Idle Claw-Rock", g_iIdleHit[iIndex]));
			main ? (g_iIdleHit[iIndex] = iSetCellLimit(g_iIdleHit[iIndex], 0, 1)) : (g_iIdleHit2[iIndex] = iSetCellLimit(g_iIdleHit2[iIndex], 0, 1));
			main ? (kvSuperTanks.GetString("Infected Options", g_sInfectedOptions[iIndex], sizeof(g_sInfectedOptions[]), "1234567")) : (kvSuperTanks.GetString("Infected Options", g_sInfectedOptions2[iIndex], sizeof(g_sInfectedOptions2[]), g_sInfectedOptions[iIndex]));
			main ? (g_iInfectedThrow[iIndex] = kvSuperTanks.GetNum("Infected Throw Ability", 0)) : (g_iInfectedThrow2[iIndex] = kvSuperTanks.GetNum("Infected Throw Ability", g_iInfectedThrow[iIndex]));
			main ? (g_iInfectedThrow[iIndex] = iSetCellLimit(g_iInfectedThrow[iIndex], 0, 1)) : (g_iInfectedThrow2[iIndex] = iSetCellLimit(g_iInfectedThrow2[iIndex], 0, 1));
			main ? (g_iInvertChance[iIndex] = kvSuperTanks.GetNum("Invert Chance", 4)) : (g_iInvertChance2[iIndex] = kvSuperTanks.GetNum("Invert Chance", g_iInvertChance[iIndex]));
			main ? (g_iInvertChance[iIndex] = iSetCellLimit(g_iInvertChance[iIndex], 1, 99999)) : (g_iInvertChance2[iIndex] = iSetCellLimit(g_iInvertChance2[iIndex], 1, 99999));
			main ? (g_flInvertDuration[iIndex] = kvSuperTanks.GetFloat("Invert Duration", 5.0)) : (g_flInvertDuration2[iIndex] = kvSuperTanks.GetFloat("Invert Duration", g_flInvertDuration[iIndex]));
			main ? (g_flInvertDuration[iIndex] = flSetFloatLimit(g_flInvertDuration[iIndex], 0.1, 99999.0)) : (g_flInvertDuration2[iIndex] = flSetFloatLimit(g_flInvertDuration2[iIndex], 0.1, 99999.0));
			main ? (g_iInvertHit[iIndex] = kvSuperTanks.GetNum("Invert Claw-Rock", 0)) : (g_iInvertHit2[iIndex] = kvSuperTanks.GetNum("Invert Claw-Rock", g_iInvertHit[iIndex]));
			main ? (g_iInvertHit[iIndex] = iSetCellLimit(g_iInvertHit[iIndex], 0, 1)) : (g_iInvertHit2[iIndex] = iSetCellLimit(g_iInvertHit2[iIndex], 0, 1));
			main ? (g_iJumperAbility[iIndex] = kvSuperTanks.GetNum("Jump Ability", 0)) : (g_iJumperAbility2[iIndex] = kvSuperTanks.GetNum("Jump Ability", g_iJumperAbility[iIndex]));
			main ? (g_iJumperAbility[iIndex] = iSetCellLimit(g_iJumperAbility[iIndex], 0, 1)) : (g_iJumperAbility2[iIndex] = iSetCellLimit(g_iJumperAbility2[iIndex], 0, 1));
			main ? (g_iJumperChance[iIndex] = kvSuperTanks.GetNum("Jump Chance", 4)) : (g_iJumperChance2[iIndex] = kvSuperTanks.GetNum("Jump Chance", g_iJumperChance[iIndex]));
			main ? (g_iJumperChance[iIndex] = iSetCellLimit(g_iJumperChance[iIndex], 1, 99999)) : (g_iJumperChance2[iIndex] = iSetCellLimit(g_iJumperChance2[iIndex], 1, 99999));
			main ? (g_iMeleeImmunity[iIndex] = kvSuperTanks.GetNum("Melee Immunity", 0)) : (g_iMeleeImmunity2[iIndex] = kvSuperTanks.GetNum("Melee Immunity", g_iMeleeImmunity[iIndex]));
			main ? (g_iMeleeImmunity[iIndex] = iSetCellLimit(g_iMeleeImmunity[iIndex], 0, 1)) : (g_iMeleeImmunity2[iIndex] = iSetCellLimit(g_iMeleeImmunity2[iIndex], 0, 1));
			main ? (g_iMeteorAbility[iIndex] = kvSuperTanks.GetNum("Meteor Ability", 0)) : (g_iMeteorAbility2[iIndex] = kvSuperTanks.GetNum("Meteor Ability", g_iMeteorAbility[iIndex]));
			main ? (g_iMeteorAbility[iIndex] = iSetCellLimit(g_iMeteorAbility[iIndex], 0, 1)) : (g_iMeteorAbility2[iIndex] = iSetCellLimit(g_iMeteorAbility2[iIndex], 0, 1));
			main ? (g_iMeteorChance[iIndex] = kvSuperTanks.GetNum("Meteor Chance", 4)) : (g_iMeteorChance2[iIndex] = kvSuperTanks.GetNum("Meteor Chance", g_iMeteorChance[iIndex]));
			main ? (g_iMeteorChance[iIndex] = iSetCellLimit(g_iMeteorChance[iIndex], 1, 99999)) : (g_iMeteorChance2[iIndex] = iSetCellLimit(g_iMeteorChance2[iIndex], 1, 99999));
			main ? (g_flMeteorDamage[iIndex] = kvSuperTanks.GetFloat("Meteor Damage", 25.0)) : (g_flMeteorDamage2[iIndex] = kvSuperTanks.GetFloat("Meteor Damage", g_flMeteorDamage[iIndex]));
			main ? (g_flMeteorDamage[iIndex] = flSetFloatLimit(g_flMeteorDamage[iIndex], 1.0, 99999.0)) : (g_flMeteorDamage2[iIndex] = flSetFloatLimit(g_flMeteorDamage2[iIndex], 1.0, 99999.0));
			main ? (g_iNullifyChance[iIndex] = kvSuperTanks.GetNum("Nullify Chance", 4)) : (g_iNullifyChance2[iIndex] = kvSuperTanks.GetNum("Nullify Chance", g_iNullifyChance[iIndex]));
			main ? (g_iNullifyChance[iIndex] = iSetCellLimit(g_iNullifyChance[iIndex], 1, 99999)) : (g_iNullifyChance2[iIndex] = iSetCellLimit(g_iNullifyChance2[iIndex], 1, 99999));
			main ? (g_flNullifyDuration[iIndex] = kvSuperTanks.GetFloat("Nullify Duration", 5.0)) : (g_flNullifyDuration2[iIndex] = kvSuperTanks.GetFloat("Nullify Duration", g_flNullifyDuration[iIndex]));
			main ? (g_flNullifyDuration[iIndex] = flSetFloatLimit(g_flNullifyDuration[iIndex], 0.1, 99999.0)) : (g_flNullifyDuration2[iIndex] = flSetFloatLimit(g_flNullifyDuration2[iIndex], 0.1, 99999.0));
			main ? (g_iNullifyHit[iIndex] = kvSuperTanks.GetNum("Nullify Claw-Rock", 0)) : (g_iNullifyHit2[iIndex] = kvSuperTanks.GetNum("Nullify Claw-Rock", g_iNullifyHit[iIndex]));
			main ? (g_iNullifyHit[iIndex] = iSetCellLimit(g_iNullifyHit[iIndex], 0, 1)) : (g_iNullifyHit2[iIndex] = iSetCellLimit(g_iNullifyHit2[iIndex], 0, 1));
			main ? (g_iPanicChance[iIndex] = kvSuperTanks.GetNum("Panic Chance", 4)) : (g_iPanicChance2[iIndex] = kvSuperTanks.GetNum("Panic Chance", g_iPanicChance[iIndex]));
			main ? (g_iPanicChance[iIndex] = iSetCellLimit(g_iPanicChance[iIndex], 1, 99999)) : (g_iPanicChance2[iIndex] = iSetCellLimit(g_iPanicChance2[iIndex], 1, 99999));
			main ? (g_iPanicHit[iIndex] = kvSuperTanks.GetNum("Panic Claw-Rock", 0)) : (g_iPanicHit2[iIndex] = kvSuperTanks.GetNum("Panic Claw-Rock", g_iPanicHit[iIndex]));
			main ? (g_iPanicHit[iIndex] = iSetCellLimit(g_iPanicHit[iIndex], 0, 1)) : (g_iPanicHit2[iIndex] = iSetCellLimit(g_iPanicHit2[iIndex], 0, 1));
			main ? (g_iPukeChance[iIndex] = kvSuperTanks.GetNum("Puke Chance", 4)) : (g_iPukeChance2[iIndex] = kvSuperTanks.GetNum("Puke Chance", g_iPukeChance[iIndex]));
			main ? (g_iPukeChance[iIndex] = iSetCellLimit(g_iPukeChance[iIndex], 1, 99999)) : (g_iPukeChance2[iIndex] = iSetCellLimit(g_iPukeChance2[iIndex], 1, 99999));
			main ? (g_iPukeHit[iIndex] = kvSuperTanks.GetNum("Puke Claw-Rock", 0)) : (g_iPukeHit2[iIndex] = kvSuperTanks.GetNum("Puke Claw-Rock", g_iPukeHit[iIndex]));
			main ? (g_iPukeHit[iIndex] = iSetCellLimit(g_iPukeHit[iIndex], 0, 1)) : (g_iPukeHit2[iIndex] = iSetCellLimit(g_iPukeHit2[iIndex], 0, 1));
			main ? (g_iPyroAbility[iIndex] = kvSuperTanks.GetNum("Pyro Ability", 0)) : (g_iPyroAbility2[iIndex] = kvSuperTanks.GetNum("Pyro Ability", g_iPyroAbility[iIndex]));
			main ? (g_iPyroAbility[iIndex] = iSetCellLimit(g_iPyroAbility[iIndex], 0, 1)) : (g_iPyroAbility2[iIndex] = iSetCellLimit(g_iPyroAbility2[iIndex], 0, 1));
			main ? (g_flPyroBoost[iIndex] = kvSuperTanks.GetFloat("Pyro Boost", 1.0)) : (g_flPyroBoost2[iIndex] = kvSuperTanks.GetFloat("Pyro Boost", g_flPyroBoost[iIndex]));
			main ? (g_flPyroBoost[iIndex] = flSetFloatLimit(g_flPyroBoost[iIndex], 0.1, 3.0)) : (g_flPyroBoost2[iIndex] = flSetFloatLimit(g_flPyroBoost2[iIndex], 0.1, 3.0));
			main ? (g_iRestartChance[iIndex] = kvSuperTanks.GetNum("Restart Chance", 4)) : (g_iRestartChance2[iIndex] = kvSuperTanks.GetNum("Restart Chance", g_iRestartChance[iIndex]));
			main ? (g_iRestartChance[iIndex] = iSetCellLimit(g_iRestartChance[iIndex], 1, 99999)) : (g_iRestartChance2[iIndex] = iSetCellLimit(g_iRestartChance2[iIndex], 1, 99999));
			main ? (g_iRestartHit[iIndex] = kvSuperTanks.GetNum("Restart Claw-Rock", 0)) : (g_iRestartHit2[iIndex] = kvSuperTanks.GetNum("Restart Claw-Rock", g_iRestartHit[iIndex]));
			main ? (g_iRestartHit[iIndex] = iSetCellLimit(g_iRestartHit[iIndex], 0, 1)) : (g_iRestartHit2[iIndex] = iSetCellLimit(g_iRestartHit2[iIndex], 0, 1));
			main ? (kvSuperTanks.GetString("Restart Loadout", g_sLoadout[iIndex], sizeof(g_sLoadout[]), "smg,pistol,pain_pills")) : (kvSuperTanks.GetString("Restart Loadout", g_sLoadout2[iIndex], sizeof(g_sLoadout2[]), g_sLoadout[iIndex]));
			main ? (g_iRocketChance[iIndex] = kvSuperTanks.GetNum("Rocket Chance", 4)) : (g_iRocketChance2[iIndex] = kvSuperTanks.GetNum("Rocket Chance", g_iRocketChance[iIndex]));
			main ? (g_iRocketChance[iIndex] = iSetCellLimit(g_iRocketChance[iIndex], 1, 99999)) : (g_iRocketChance2[iIndex] = iSetCellLimit(g_iRocketChance2[iIndex], 1, 99999));
			main ? (g_iRocketHit[iIndex] = kvSuperTanks.GetNum("Rocket Claw-Rock", 0)) : (g_iRocketHit2[iIndex] = kvSuperTanks.GetNum("Rocket Claw-Rock", g_iRocketHit[iIndex]));
			main ? (g_iRocketHit[iIndex] = iSetCellLimit(g_iRocketHit[iIndex], 0, 1)) : (g_iRocketHit2[iIndex] = iSetCellLimit(g_iRocketHit2[iIndex], 0, 1));
			main ? (g_flRunSpeed[iIndex] = kvSuperTanks.GetFloat("Run Speed", 1.0)) : (g_flRunSpeed2[iIndex] = kvSuperTanks.GetFloat("Run Speed", g_flRunSpeed[iIndex]));
			main ? (g_flRunSpeed[iIndex] = flSetFloatLimit(g_flRunSpeed[iIndex], 0.1, 3.0)) : (g_flRunSpeed2[iIndex] = flSetFloatLimit(g_flRunSpeed2[iIndex], 0.1, 3.0));
			main ? (g_iSelfThrow[iIndex] = kvSuperTanks.GetNum("Self Throw Ability", 0)) : (g_iSelfThrow2[iIndex] = kvSuperTanks.GetNum("Self Throw Ability", g_iSelfThrow[iIndex]));
			main ? (g_iSelfThrow[iIndex] = iSetCellLimit(g_iSelfThrow[iIndex], 0, 1)) : (g_iSelfThrow2[iIndex] = iSetCellLimit(g_iSelfThrow2[iIndex], 0, 1));
			main ? (g_iShakeChance[iIndex] = kvSuperTanks.GetNum("Shake Chance", 4)) : (g_iShakeChance2[iIndex] = kvSuperTanks.GetNum("Shake Chance", g_iShakeChance[iIndex]));
			main ? (g_iShakeChance[iIndex] = iSetCellLimit(g_iShakeChance[iIndex], 1, 99999)) : (g_iShakeChance2[iIndex] = iSetCellLimit(g_iShakeChance2[iIndex], 1, 99999));
			main ? (g_flShakeDuration[iIndex] = kvSuperTanks.GetFloat("Shake Duration", 5.0)) : (g_flShakeDuration2[iIndex] = kvSuperTanks.GetFloat("Shake Duration", g_flShakeDuration[iIndex]));
			main ? (g_flShakeDuration[iIndex] = flSetFloatLimit(g_flShakeDuration[iIndex], 0.1, 99999.0)) : (g_flShakeDuration2[iIndex] = flSetFloatLimit(g_flShakeDuration2[iIndex], 0.1, 99999.0));
			main ? (g_iShakeHit[iIndex] = kvSuperTanks.GetNum("Shake Claw-Rock", 0)) : (g_iShakeHit2[iIndex] = kvSuperTanks.GetNum("Shake Claw-Rock", g_iShakeHit[iIndex]));
			main ? (g_iShakeHit[iIndex] = iSetCellLimit(g_iShakeHit[iIndex], 0, 1)) : (g_iShakeHit2[iIndex] = iSetCellLimit(g_iShakeHit2[iIndex], 0, 1));
			main ? (g_iShieldAbility[iIndex] = kvSuperTanks.GetNum("Shield Ability", 0)) : (g_iShieldAbility2[iIndex] = kvSuperTanks.GetNum("Shield Ability", g_iShieldAbility[iIndex]));
			main ? (g_iShieldAbility[iIndex] = iSetCellLimit(g_iShieldAbility[iIndex], 0, 1)) : (g_iShieldAbility2[iIndex] = iSetCellLimit(g_iShieldAbility2[iIndex], 0, 1));
			main ? (kvSuperTanks.GetString("Shield Color", g_sShieldColor[iIndex], sizeof(g_sShieldColor[]), "255,255,255")) : (kvSuperTanks.GetString("Shield Color", g_sShieldColor2[iIndex], sizeof(g_sShieldColor2[]), g_sShieldColor[iIndex]));
			main ? (g_flShieldDelay[iIndex] = kvSuperTanks.GetFloat("Shield Delay", 5.0)) : (g_flShieldDelay2[iIndex] = kvSuperTanks.GetFloat("Shield Delay", g_flShieldDelay[iIndex]));
			main ? (g_flShieldDelay[iIndex] = flSetFloatLimit(g_flShieldDelay[iIndex], 1.0, 99999.0)) : (g_flShieldDelay2[iIndex] = flSetFloatLimit(g_flShieldDelay2[iIndex], 1.0, 99999.0));
			main ? (g_iShoveChance[iIndex] = kvSuperTanks.GetNum("Shove Chance", 4)) : (g_iShoveChance2[iIndex] = kvSuperTanks.GetNum("Shove Chance", g_iShoveChance[iIndex]));
			main ? (g_iShoveChance[iIndex] = iSetCellLimit(g_iShoveChance[iIndex], 1, 99999)) : (g_iShoveChance2[iIndex] = iSetCellLimit(g_iShoveChance2[iIndex], 1, 99999));
			main ? (g_flShoveDuration[iIndex] = kvSuperTanks.GetFloat("Shove Duration", 5.0)) : (g_flShoveDuration2[iIndex] = kvSuperTanks.GetFloat("Shove Duration", g_flShoveDuration[iIndex]));
			main ? (g_flShoveDuration[iIndex] = flSetFloatLimit(g_flShoveDuration[iIndex], 0.1, 99999.0)) : (g_flShoveDuration2[iIndex] = flSetFloatLimit(g_flShoveDuration2[iIndex], 0.1, 99999.0));
			main ? (g_iShoveHit[iIndex] = kvSuperTanks.GetNum("Shove Claw-Rock", 0)) : (g_iShoveHit2[iIndex] = kvSuperTanks.GetNum("Shove Claw-Rock", g_iShoveHit[iIndex]));
			main ? (g_iShoveHit[iIndex] = iSetCellLimit(g_iShoveHit[iIndex], 0, 1)) : (g_iShoveHit2[iIndex] = iSetCellLimit(g_iShoveHit2[iIndex], 0, 1));
			main ? (g_iSlugChance[iIndex] = kvSuperTanks.GetNum("Slug Chance", 4)) : (g_iSlugChance2[iIndex] = kvSuperTanks.GetNum("Slug Chance", g_iSlugChance[iIndex]));
			main ? (g_iSlugChance[iIndex] = iSetCellLimit(g_iSlugChance[iIndex], 1, 99999)) : (g_iSlugChance2[iIndex] = iSetCellLimit(g_iSlugChance2[iIndex], 1, 99999));
			main ? (g_iSlugHit[iIndex] = kvSuperTanks.GetNum("Slug Claw-Rock", 0)) : (g_iSlugHit2[iIndex] = kvSuperTanks.GetNum("Slug Claw-Rock", g_iSlugHit[iIndex]));
			main ? (g_iSlugHit[iIndex] = iSetCellLimit(g_iSlugHit[iIndex], 0, 1)) : (g_iSlugHit2[iIndex] = iSetCellLimit(g_iSlugHit2[iIndex], 0, 1));
			main ? (g_iSpamAbility[iIndex] = kvSuperTanks.GetNum("Spam Ability", 0)) : (g_iSpamAbility2[iIndex] = kvSuperTanks.GetNum("Spam Ability", g_iSpamAbility[iIndex]));
			main ? (g_iSpamAbility[iIndex] = iSetCellLimit(g_iSpamAbility[iIndex], 0, 1)) : (g_iSpamAbility2[iIndex] = iSetCellLimit(g_iSpamAbility2[iIndex], 0, 1));
			main ? (g_iSpamAmount[iIndex] = kvSuperTanks.GetNum("Spam Amount", 5)) : (g_iSpamAmount2[iIndex] = kvSuperTanks.GetNum("Spam Amount", g_iSpamAmount[iIndex]));
			main ? (g_iSpamAmount[iIndex] = iSetCellLimit(g_iSpamAmount[iIndex], 1, 99999)) : (g_iSpamAmount2[iIndex] = iSetCellLimit(g_iSpamAmount2[iIndex], 1, 99999));
			main ? (g_iSpamDamage[iIndex] = kvSuperTanks.GetNum("Spam Damage", 5)) : (g_iSpamDamage2[iIndex] = kvSuperTanks.GetNum("Spam Damage", g_iSpamDamage[iIndex]));
			main ? (g_iSpamDamage[iIndex] = iSetCellLimit(g_iSpamDamage[iIndex], 1, 99999)) : (g_iSpamDamage2[iIndex] = iSetCellLimit(g_iSpamDamage2[iIndex], 1, 99999));
			main ? (g_flSpamInterval[iIndex] = kvSuperTanks.GetFloat("Spam Interval", 5.0)) : (g_flSpamInterval2[iIndex] = kvSuperTanks.GetFloat("Spam Interval", g_flSpamInterval[iIndex]));
			main ? (g_flSpamInterval[iIndex] = flSetFloatLimit(g_flSpamInterval[iIndex], 0.1, 99999.0)) : (g_flSpamInterval2[iIndex] = flSetFloatLimit(g_flSpamInterval2[iIndex], 0.1, 99999.0));
			main ? (g_iStunChance[iIndex] = kvSuperTanks.GetNum("Stun Chance", 4)) : (g_iStunChance2[iIndex] = kvSuperTanks.GetNum("Stun Chance", g_iStunChance[iIndex]));
			main ? (g_iStunChance[iIndex] = iSetCellLimit(g_iStunChance[iIndex], 1, 99999)) : (g_iStunChance2[iIndex] = iSetCellLimit(g_iStunChance2[iIndex], 1, 99999));
			main ? (g_flStunDuration[iIndex] = kvSuperTanks.GetFloat("Stun Duration", 5.0)) : (g_flStunDuration2[iIndex] = kvSuperTanks.GetFloat("Stun Duration", g_flStunDuration[iIndex]));
			main ? (g_flStunDuration[iIndex] = flSetFloatLimit(g_flStunDuration[iIndex], 0.1, 99999.0)) : (g_flStunDuration2[iIndex] = flSetFloatLimit(g_flStunDuration2[iIndex], 0.1, 99999.0));
			main ? (g_iStunHit[iIndex] = kvSuperTanks.GetNum("Stun Claw-Rock", 0)) : (g_iStunHit2[iIndex] = kvSuperTanks.GetNum("Stun Claw-Rock", g_iStunHit[iIndex]));
			main ? (g_iStunHit[iIndex] = iSetCellLimit(g_iStunHit[iIndex], 0, 1)) : (g_iStunHit2[iIndex] = iSetCellLimit(g_iStunHit2[iIndex], 0, 1));
			main ? (g_flStunSpeed[iIndex] = kvSuperTanks.GetFloat("Stun Speed", 0.25)) : (g_flStunSpeed2[iIndex] = kvSuperTanks.GetFloat("Stun Speed", g_flStunSpeed[iIndex]));
			main ? (g_flStunSpeed[iIndex] = flSetFloatLimit(g_flStunSpeed[iIndex], 0.1, 0.9)) : (g_flStunSpeed2[iIndex] = flSetFloatLimit(g_flStunSpeed2[iIndex], 0.1, 0.9));
			main ? (g_flThrowInterval[iIndex] = kvSuperTanks.GetFloat("Throw Interval", 5.0)) : (g_flThrowInterval2[iIndex] = kvSuperTanks.GetFloat("Throw Interval", g_flThrowInterval[iIndex]));
			main ? (g_flThrowInterval[iIndex] = flSetFloatLimit(g_flThrowInterval[iIndex], 0.1, 99999.0)) : (g_flThrowInterval2[iIndex] = flSetFloatLimit(g_flThrowInterval2[iIndex], 0.1, 99999.0));
			main ? (g_iVampireChance[iIndex] = kvSuperTanks.GetNum("Vampire Chance", 4)) : (g_iVampireChance2[iIndex] = kvSuperTanks.GetNum("Vampire Chance", g_iVampireChance[iIndex]));
			main ? (g_iVampireChance[iIndex] = iSetCellLimit(g_iVampireChance[iIndex], 1, 99999)) : (g_iVampireChance2[iIndex] = iSetCellLimit(g_iVampireChance2[iIndex], 1, 99999));
			main ? (g_iVampireHealth[iIndex] = kvSuperTanks.GetNum("Vampire Health", 100)) : (g_iVampireHealth2[iIndex] = kvSuperTanks.GetNum("Vampire Health", g_iVampireHealth[iIndex]));
			main ? (g_iVampireHealth[iIndex] = iSetCellLimit(g_iVampireHealth[iIndex], 0, 62400)) : (g_iVampireHealth2[iIndex] = iSetCellLimit(g_iVampireHealth2[iIndex], 0, 62400));
			main ? (g_iVampireHit[iIndex] = kvSuperTanks.GetNum("Vampire Claw-Rock", 0)) : (g_iVampireHit2[iIndex] = kvSuperTanks.GetNum("Vampire Claw-Rock", g_iVampireHit[iIndex]));
			main ? (g_iVampireHit[iIndex] = iSetCellLimit(g_iVampireHit[iIndex], 0, 1)) : (g_iVampireHit2[iIndex] = iSetCellLimit(g_iVampireHit2[iIndex], 0, 1));
			main ? (g_iVisionChance[iIndex] = kvSuperTanks.GetNum("Vision Chance", 4)) : (g_iVisionChance2[iIndex] = kvSuperTanks.GetNum("Vision Chance", g_iVisionChance[iIndex]));
			main ? (g_iVisionChance[iIndex] = iSetCellLimit(g_iVisionChance[iIndex], 1, 99999)) : (g_iVisionChance2[iIndex] = iSetCellLimit(g_iVisionChance2[iIndex], 1, 99999));
			main ? (g_flVisionDuration[iIndex] = kvSuperTanks.GetFloat("Vision Duration", 5.0)) : (g_flVisionDuration2[iIndex] = kvSuperTanks.GetFloat("Vision Duration", g_flVisionDuration[iIndex]));
			main ? (g_flVisionDuration[iIndex] = flSetFloatLimit(g_flVisionDuration[iIndex], 0.1, 99999.0)) : (g_flVisionDuration2[iIndex] = flSetFloatLimit(g_flVisionDuration2[iIndex], 0.1, 99999.0));
			main ? (g_iVisionFOV[iIndex] = kvSuperTanks.GetNum("Vision FOV", 160)) : (g_iVisionFOV2[iIndex] = kvSuperTanks.GetNum("Vision FOV", g_iVisionFOV[iIndex]));
			main ? (g_iVisionFOV[iIndex] = iSetCellLimit(g_iVisionHit[iIndex], 1, 160)) : (g_iVisionFOV2[iIndex] = iSetCellLimit(g_iVisionHit2[iIndex], 1, 160));
			main ? (g_iVisionHit[iIndex] = kvSuperTanks.GetNum("Vision Claw-Rock", 0)) : (g_iVisionHit2[iIndex] = kvSuperTanks.GetNum("Vision Claw-Rock", g_iVisionHit[iIndex]));
			main ? (g_iVisionHit[iIndex] = iSetCellLimit(g_iVisionHit[iIndex], 0, 1)) : (g_iVisionHit2[iIndex] = iSetCellLimit(g_iVisionHit2[iIndex], 0, 1));
			main ? (g_iWarpAbility[iIndex] = kvSuperTanks.GetNum("Warp Ability", 0)) : (g_iWarpAbility2[iIndex] = kvSuperTanks.GetNum("Warp Ability", g_iWarpAbility[iIndex]));
			main ? (g_iWarpAbility[iIndex] = iSetCellLimit(g_iWarpAbility[iIndex], 0, 1)) : (g_iWarpAbility2[iIndex] = iSetCellLimit(g_iWarpAbility2[iIndex], 0, 1));
			main ? (g_flWarpInterval[iIndex] = kvSuperTanks.GetFloat("Warp Interval", 5.0)) : (g_flWarpInterval2[iIndex] = kvSuperTanks.GetFloat("Warp Interval", g_flWarpInterval[iIndex]));
			main ? (g_flWarpInterval[iIndex] = flSetFloatLimit(g_flWarpInterval[iIndex], 0.1, 99999.0)) : (g_flWarpInterval2[iIndex] = flSetFloatLimit(g_flWarpInterval2[iIndex], 0.1, 99999.0));
			main ? (g_iWitchAbility[iIndex] = kvSuperTanks.GetNum("Witch Ability", 0)) : (g_iWitchAbility2[iIndex] = kvSuperTanks.GetNum("Witch Ability", g_iWitchAbility[iIndex]));
			main ? (g_iWitchAbility[iIndex] = iSetCellLimit(g_iWitchAbility[iIndex], 0, 1)) : (g_iWitchAbility2[iIndex] = iSetCellLimit(g_iWitchAbility2[iIndex], 0, 1));
			main ? (g_iWitchAmount[iIndex] = kvSuperTanks.GetNum("Witch Amount", 3)) : (g_iWitchAmount2[iIndex] = kvSuperTanks.GetNum("Witch Amount", g_iWitchAmount[iIndex]));
			main ? (g_iWitchAmount[iIndex] = iSetCellLimit(g_iWitchAmount[iIndex], 1, 25)) : (g_iWitchAmount2[iIndex] = iSetCellLimit(g_iWitchAmount2[iIndex], 1, 25));
			main ? (g_flWitchDamage[iIndex] = kvSuperTanks.GetFloat("Witch Minion Damage", 10.0)) : (g_flWitchDamage2[iIndex] = kvSuperTanks.GetFloat("Witch Minion Damage", g_flWitchDamage[iIndex]));
			main ? (g_flWitchDamage[iIndex] = flSetFloatLimit(g_flWitchDamage[iIndex], 1.0, 99999.0)) : (g_flWitchDamage2[iIndex] = flSetFloatLimit(g_flWitchDamage2[iIndex], 1.0, 99999.0));
			kvSuperTanks.Rewind();
		}
	}
	delete kvSuperTanks;
}

void vAcidHit(int client, int owner, int enabled)
{
	int iAcidChance = !g_bTankConfig[g_iTankType[owner]] ? g_iAcidChance[g_iTankType[owner]] : g_iAcidChance2[g_iTankType[owner]];
	if (enabled == 1 && GetRandomInt(1, iAcidChance) == 1 && bIsSurvivor(client) && bIsL4D2Game())
	{
		float flOrigin[3];
		float flAngles[3];
		GetClientAbsOrigin(client, flOrigin);
		GetClientAbsAngles(client, flAngles);
		SDKCall(g_hSDKAcidPlayer, flOrigin, flAngles, flAngles, flAngles, owner, 2.0);
	}
}

void vAcidRock(int entity, int client, int enabled)
{
	if (bIsL4D2Game() && enabled == 1)
	{
		float flOrigin[3];
		float flAngles[3];
		GetEntPropVector(entity, Prop_Send, "m_vecOrigin", flOrigin);
		flOrigin[2] += 40.0;
		SDKCall(g_hSDKAcidPlayer, flOrigin, flAngles, flAngles, flAngles, client, 2.0);
	}
}

void vAmmoHit(int client, int owner, int enabled)
{
	int iAmmoChance = !g_bTankConfig[g_iTankType[owner]] ? g_iAmmoChance[g_iTankType[owner]] : g_iAmmoChance2[g_iTankType[owner]];
	if (enabled == 1 && GetRandomInt(1, iAmmoChance) == 1 && bIsSurvivor(client) && GetPlayerWeaponSlot(client, 0) > 0)
	{
		char sWeapon[32];
		int iActiveWeapon = GetEntPropEnt(client, Prop_Data, "m_hActiveWeapon");
		int iAmmo = !g_bTankConfig[g_iTankType[owner]] ? g_iAmmoCount[g_iTankType[owner]] : g_iAmmoCount2[g_iTankType[owner]];
		GetEntityClassname(iActiveWeapon, sWeapon, sizeof(sWeapon));
		if (IsValidEntity(iActiveWeapon))
		{
			if (strcmp(sWeapon, "weapon_rifle") == 0 || strcmp(sWeapon, "weapon_rifle_desert") == 0 || strcmp(sWeapon, "weapon_rifle_ak47") == 0 || strcmp(sWeapon, "weapon_rifle_sg552") == 0)
			{
				SetEntProp(client, Prop_Data, "m_iAmmo", iAmmo, _, 3);
			}
			else if (strcmp(sWeapon, "weapon_smg") == 0 || strcmp(sWeapon, "weapon_smg_silenced") == 0 || strcmp(sWeapon, "weapon_smg_mp5") == 0)
			{
				SetEntProp(client, Prop_Data, "m_iAmmo", iAmmo, _, 5);
			}
			else if (strcmp(sWeapon, "weapon_pumpshotgun") == 0)
			{
				bIsL4D2Game() ? SetEntProp(client, Prop_Data, "m_iAmmo", iAmmo, _, 7) : SetEntProp(client, Prop_Data, "m_iAmmo", iAmmo, _, 6);
			}
			else if (strcmp(sWeapon, "weapon_shotgun_chrome") == 0)
			{
				SetEntProp(client, Prop_Data, "m_iAmmo", iAmmo, _, 7);
			}
			else if (strcmp(sWeapon, "weapon_autoshotgun") == 0)
			{
				bIsL4D2Game() ? SetEntProp(client, Prop_Data, "m_iAmmo", iAmmo, _, 8) : SetEntProp(client, Prop_Data, "m_iAmmo", iAmmo, _, 6);
			}
			else if (strcmp(sWeapon, "weapon_shotgun_spas") == 0)
			{
				SetEntProp(client, Prop_Data, "m_iAmmo", iAmmo, _, 8);
			}
			else if (strcmp(sWeapon, "weapon_hunting_rifle") == 0)
			{
				bIsL4D2Game() ? SetEntProp(client, Prop_Data, "m_iAmmo", iAmmo, _, 9) : SetEntProp(client, Prop_Data, "m_iAmmo", iAmmo, _, 2);
			}
			else if (strcmp(sWeapon, "weapon_sniper_scout") == 0 || strcmp(sWeapon, "weapon_sniper_military") == 0 || strcmp(sWeapon, "weapon_sniper_awp") == 0)
			{
				SetEntProp(client, Prop_Data, "m_iAmmo", iAmmo, _, 10);
			}
			else if (strcmp(sWeapon, "weapon_grenade_launcher") == 0)
			{
				SetEntProp(client, Prop_Data, "m_iAmmo", iAmmo, _, 17);
			}
		}
		SetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Data, "m_iClip1", iAmmo, 1);
	}
}

void vBlindHit(int client, int owner, int enabled)
{
	int iBlindChance = !g_bTankConfig[g_iTankType[owner]] ? g_iBlindChance[g_iTankType[owner]] : g_iBlindChance2[g_iTankType[owner]];
	if (enabled == 1 && GetRandomInt(1, iBlindChance) == 1 && bIsSurvivor(client))
	{
		if (!g_bBlind[client])
		{
			g_bBlind[client] = true;
			int iBlindToggle = !g_bTankConfig[g_iTankType[owner]] ? g_iBlindIntensity[g_iTankType[owner]] : g_iBlindIntensity2[g_iTankType[owner]];
			vApplyBlindness(client, iBlindToggle, g_umFadeUserMsgId);
			float flBlindDuration = !g_bTankConfig[g_iTankType[owner]] ? g_flBlindDuration[g_iTankType[owner]] : g_flBlindDuration2[g_iTankType[owner]];
			CreateTimer(flBlindDuration, tTimerStopBlindness, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
		}
	}
}

void vBombHit(int client, int owner, int enabled)
{
	int iBombChance = !g_bTankConfig[g_iTankType[owner]] ? g_iBombChance[g_iTankType[owner]] : g_iBombChance2[g_iTankType[owner]];
	if (enabled == 1 && GetRandomInt(1, iBombChance) == 1 && bIsSurvivor(client))
	{
		float flPosition[3];
		GetClientAbsOrigin(client, flPosition);
		vBomb(owner, flPosition);
	}
}

void vBombRock(int entity, int client, int enabled)
{
	if (enabled == 1)
	{
		float flPosition[3];
		GetEntPropVector(entity, Prop_Send, "m_vecOrigin", flPosition);
		vBomb(client, flPosition);
	}
}

void vBuryHit(int client, int owner, int enabled)
{
	int iBuryChance = !g_bTankConfig[g_iTankType[owner]] ? g_iBuryChance[g_iTankType[owner]] : g_iBuryChance2[g_iTankType[owner]];
	if (enabled == 1 && GetRandomInt(1, iBuryChance) == 1 && bIsSurvivor(client) && bIsPlayerGrounded(client))
	{
		if (!g_bBury[client])
		{
			g_bBury[client] = true;
			float flOrigin[3];
			float flBuryHeight = !g_bTankConfig[g_iTankType[owner]] ? g_flBuryHeight[g_iTankType[owner]] : g_flBuryHeight2[g_iTankType[owner]];
			GetEntPropVector(client, Prop_Send, "m_vecOrigin", flOrigin);
			flOrigin[2] = flOrigin[2] - flBuryHeight;
			SetEntPropVector(client, Prop_Send, "m_vecOrigin", flOrigin);
			if (!bIsPlayerIncapacitated(client))
			{
				SetEntProp(client, Prop_Send, "m_isIncapacitated", 1);
			}
			float flPos[3];
			GetClientEyePosition(client, flPos);
			if (GetEntityMoveType(client) != MOVETYPE_NONE)
			{
				SetEntityMoveType(client, MOVETYPE_NONE);
			}
			float flBuryDuration = !g_bTankConfig[g_iTankType[owner]] ? g_flBuryDuration[g_iTankType[owner]] : g_flBuryDuration2[g_iTankType[owner]];
			DataPack dpDataPack;
			CreateDataTimer(flBuryDuration, tTimerStopBury, dpDataPack, TIMER_FLAG_NO_MAPCHANGE);
			dpDataPack.WriteCell(GetClientUserId(client));
			dpDataPack.WriteCell(GetClientUserId(owner));
		}
	}
}

void vCommonAbility(int client, int enabled)
{
	int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
	if (enabled == 1 && bIsTank(client) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(client))))
	{
		g_iSpawnInterval[client]++;
		int iCommonAmount = !g_bTankConfig[g_iTankType[client]] ? g_iCommonAmount[g_iTankType[client]] : g_iCommonAmount2[g_iTankType[client]];
		if (g_iSpawnInterval[client] >= iCommonAmount)
		{
			for (int iCommon = 1; iCommon <= iCommonAmount; iCommon++)
			{
				bIsL4D2Game() ? vCheatCommand(client, "z_spawn_old", "zombie area") : vCheatCommand(client, "z_spawn", "zombie area");
			}
			g_iSpawnInterval[client] = 0;
		}
	}
}

void vDrugHit(int client, int owner, int enabled)
{
	int iDrugChance = !g_bTankConfig[g_iTankType[owner]] ? g_iDrugChance[g_iTankType[owner]] : g_iDrugChance2[g_iTankType[owner]];
	if (enabled == 1 && GetRandomInt(1, iDrugChance) == 1 && bIsSurvivor(client))
	{
		if (!g_bDrug[client])
		{
			g_bDrug[client] = true;
			DataPack dpDataPack;
			CreateDataTimer(1.0, tTimerDrug, dpDataPack, TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
			dpDataPack.WriteCell(GetClientUserId(client));
			dpDataPack.WriteCell(GetClientUserId(owner));
			dpDataPack.WriteFloat(GetEngineTime());
		}
	}
}

void vFireHit(int client, int owner, int enabled)
{
	int iFireChance = !g_bTankConfig[g_iTankType[owner]] ? g_iFireChance[g_iTankType[owner]] : g_iFireChance2[g_iTankType[owner]];
	if (enabled == 1 && GetRandomInt(1, iFireChance) == 1 && bIsSurvivor(client))
	{
		float flPos[3];
		GetClientAbsOrigin(client, flPos);
		vFire(owner, flPos);
	}
}

void vFireRock(int entity, int client, int enabled)
{
	if (enabled == 1)
	{
		float flPos[3];
		GetEntPropVector(entity, Prop_Send, "m_vecOrigin", flPos);
		vFire(client, flPos);
	}
}

void vFlashAbility(int client, int enabled)
{
	int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
	if (enabled == 1 && bIsTank(client) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(client))))
	{
		if (!g_bFlash[client])
		{
			float flRunSpeed = !g_bTankConfig[g_iTankType[client]] ? g_flRunSpeed[g_iTankType[client]] : g_flRunSpeed2[g_iTankType[client]];
			SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", flRunSpeed);
			int iFlashChance = !g_bTankConfig[g_iTankType[client]] ? g_iFlashChance[g_iTankType[client]] : g_iFlashChance2[g_iTankType[client]];
			if (GetRandomInt(1, iFlashChance) == 1)
			{
				g_bFlash[client] = true;
				CreateTimer(0.25, tTimerFlashEffect, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
			}
		}
		else
		{
			float flFlashSpeed = !g_bTankConfig[g_iTankType[client]] ? g_flFlashSpeed[g_iTankType[client]] : g_flFlashSpeed2[g_iTankType[client]];
			SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", flFlashSpeed);
		}
	}
}

void vFlingHit(int client, int owner, int enabled)
{
	int iFlingChance = !g_bTankConfig[g_iTankType[owner]] ? g_iFlingChance[g_iTankType[owner]] : g_iFlingChance2[g_iTankType[owner]];
	if (enabled == 1 && GetRandomInt(1, iFlingChance) == 1 && bIsSurvivor(client) && bIsL4D2Game())
	{
		float flTpos[3];
		float flSpos[3];
		float flDistance[3];
		float flRatio[3];
		float flAddVel[3];
		float flTvec[3];
		GetClientAbsOrigin(client, flTpos);
		GetClientAbsOrigin(owner, flSpos);
		flDistance[0] = (flSpos[0] - flTpos[0]);
		flDistance[1] = (flSpos[1] - flTpos[1]);
		flDistance[2] = (flSpos[2] - flTpos[2]);
		GetEntPropVector(client, Prop_Data, "m_vecVelocity", flTvec);
		flRatio[0] =  FloatDiv(flDistance[0], SquareRoot(flDistance[1] * flDistance[1] + flDistance[0] * flDistance[0]));
		flRatio[1] =  FloatDiv(flDistance[1], SquareRoot(flDistance[1] * flDistance[1] + flDistance[0] * flDistance[0]));
		flAddVel[0] = FloatMul(flRatio[0] * -1, 500.0);
		flAddVel[1] = FloatMul(flRatio[1] * -1, 500.0);
		flAddVel[2] = 500.0;
		SDKCall(g_hSDKFlingPlayer, client, flAddVel, 76, owner, 7.0);
	}
}

void vGhostAbility(int client, int enabled)
{
	char sSet[2][16];
	!g_bTankConfig[g_iTankType[client]] ? ExplodeString(g_sTankColors[g_iTankType[client]], "|", sSet, sizeof(sSet), sizeof(sSet[])) : ExplodeString(g_sTankColors2[g_iTankType[client]], "|", sSet, sizeof(sSet), sizeof(sSet[]));
	char sRGB[4][4];
	ExplodeString(sSet[0], ",", sRGB, sizeof(sRGB), sizeof(sRGB[]));
	int iRed = StringToInt(sRGB[0]);
	int iGreen = StringToInt(sRGB[1]);
	int iBlue = StringToInt(sRGB[2]);
	char sSet2[5][16];
	ExplodeString(g_sPropsColors[g_iTankType[client]], "|", sSet2, sizeof(sSet2), sizeof(sSet2[]));
	char sProps[4][4];
	ExplodeString(sSet2[0], ",", sProps, sizeof(sProps), sizeof(sProps[]));
	int iRed2 = StringToInt(sProps[0]);
	int iGreen2 = StringToInt(sProps[1]);
	int iBlue2 = StringToInt(sProps[2]);
	char sProps2[4][4];
	ExplodeString(sSet2[1], ",", sProps2, sizeof(sProps2), sizeof(sProps2[]));
	int iRed3 = StringToInt(sProps2[0]);
	int iGreen3 = StringToInt(sProps2[1]);
	int iBlue3 = StringToInt(sProps2[2]);
	char sProps3[4][4];
	ExplodeString(sSet2[2], ",", sProps3, sizeof(sProps3), sizeof(sProps3[]));
	int iRed4 = StringToInt(sProps3[0]);
	int iGreen4 = StringToInt(sProps3[1]);
	int iBlue4 = StringToInt(sProps3[2]);
	char sProps4[4][4];
	ExplodeString(sSet2[3], ",", sProps4, sizeof(sProps4), sizeof(sProps4[]));
	int iRed5 = StringToInt(sProps4[0]);
	int iGreen5 = StringToInt(sProps4[1]);
	int iBlue5 = StringToInt(sProps4[2]);
	char sProps5[4][4];
	ExplodeString(sSet2[4], ",", sProps5, sizeof(sProps5), sizeof(sProps5[]));
	int iRed6 = StringToInt(sProps5[0]);
	int iGreen6 = StringToInt(sProps5[1]);
	int iBlue6 = StringToInt(sProps5[2]);
	int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
	if (enabled == 1 && bIsTank(client) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(client))))
	{
		for (int iInfected = 1; iInfected <= MaxClients; iInfected++)
		{
			if (bIsSpecialInfected(iInfected))
			{
				float flTankPos[3];
				float flInfectedPos[3];
				GetClientAbsOrigin(client, flTankPos);
				GetClientAbsOrigin(iInfected, flInfectedPos);
				float flDistance = GetVectorDistance(flTankPos, flInfectedPos);
				if (flDistance < 500.0)
				{
					SetEntityRenderMode(iInfected, RENDER_TRANSCOLOR);
					SetEntityRenderColor(iInfected, 255, 255, 255, 50);
				}
				else
				{
					SetEntityRenderMode(iInfected, RENDER_TRANSCOLOR);
					SetEntityRenderColor(iInfected, 255, 255, 255, 255);
				}
			}
		}
		if (!g_bGhost[client])
		{
			g_iAlpha[client] = 255;
			g_bGhost[client] = true;
			DataPack dpDataPack;
			CreateDataTimer(0.1, tTimerGhost, dpDataPack, TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
			dpDataPack.WriteCell(GetClientUserId(client));
			dpDataPack.WriteCell(iRed);
			dpDataPack.WriteCell(iGreen);
			dpDataPack.WriteCell(iBlue);
			dpDataPack.WriteCell(iRed2);
			dpDataPack.WriteCell(iGreen2);
			dpDataPack.WriteCell(iBlue2);
			dpDataPack.WriteCell(iRed3);
			dpDataPack.WriteCell(iGreen3);
			dpDataPack.WriteCell(iBlue3);
			dpDataPack.WriteCell(iRed4);
			dpDataPack.WriteCell(iGreen4);
			dpDataPack.WriteCell(iBlue4);
			dpDataPack.WriteCell(iRed5);
			dpDataPack.WriteCell(iGreen5);
			dpDataPack.WriteCell(iBlue5);
			dpDataPack.WriteCell(iRed6);
			dpDataPack.WriteCell(iGreen6);
			dpDataPack.WriteCell(iBlue6);
			SetEntityRenderMode(client, RENDER_TRANSCOLOR);
		}
	}
}

void vGhostDrop(int client, int owner, char[] number, int slot)
{
	char sSlot[6];
	sSlot = !g_bTankConfig[g_iTankType[owner]] ? g_sWeaponSlot[g_iTankType[owner]] : g_sWeaponSlot2[g_iTankType[owner]];
	if (StrContains(sSlot, number) != -1)
	{
		vDropWeapon(client, slot);
	}
}

void vGhostHit(int client, int owner, int enabled)
{
	int iGhostChance = !g_bTankConfig[g_iTankType[owner]] ? g_iGhostChance[g_iTankType[owner]] : g_iGhostChance2[g_iTankType[owner]];
	int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
	if (enabled == 1 && GetRandomInt(1, iGhostChance) == 1 && bIsSurvivor(client) && bIsTank(owner) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(owner))))
	{
		vGhostDrop(client, owner, "1", 0);
		vGhostDrop(client, owner, "2", 1);
		vGhostDrop(client, owner, "3", 2);
		vGhostDrop(client, owner, "4", 3);
		vGhostDrop(client, owner, "5", 4);
		EmitSoundToClient(client, SOUND_INFECTED, owner);
	}
}

void vGravityAbility(int client, int enabled)
{
	int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
	if (enabled == 1 && bIsTank(client) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(client))))
	{
		if (!g_bGravity[client])
		{
			g_bGravity[client] = true;
			int iBlackhole = CreateEntityByName("point_push");
			float flGravityForce = !g_bTankConfig[g_iTankType[client]] ? g_flGravityForce[g_iTankType[client]] : g_flGravityForce2[g_iTankType[client]];
			if (IsValidEntity(iBlackhole))
			{
				float flOrigin[3];
				float flAngles[3];
				GetEntPropVector(client, Prop_Send, "m_vecOrigin", flOrigin);
				GetEntPropVector(client, Prop_Send, "m_angRotation", flAngles);
				flAngles[0] += -90.0;
				DispatchKeyValueVector(iBlackhole, "origin", flOrigin);
				DispatchKeyValueVector(iBlackhole, "angles", flAngles);
				DispatchKeyValue(iBlackhole, "radius", "750");
				DispatchKeyValueFloat(iBlackhole, "magnitude", flGravityForce);
				DispatchKeyValue(iBlackhole, "spawnflags", "8");
				SetVariantString("!activator");
				AcceptEntityInput(iBlackhole, "SetParent", client);
				AcceptEntityInput(iBlackhole, "Enable");
				SetEntPropEnt(iBlackhole, Prop_Send, "m_hOwnerEntity", client);
				if (bIsL4D2Game())
				{
					SetEntProp(iBlackhole, Prop_Send, "m_glowColorOverride", client);
				}
			}
		}
	}
}

void vGravityHit(int client, int owner, int enabled)
{
	int iGravityChance = !g_bTankConfig[g_iTankType[owner]] ? g_iGravityChance[g_iTankType[owner]] : g_iGravityChance2[g_iTankType[owner]];
	if (enabled == 1 && GetRandomInt(1, iGravityChance) == 1 && bIsSurvivor(client))
	{
		if (!g_bGravity2[client])
		{
			g_bGravity2[client] = true;
			float flGravityValue = !g_bTankConfig[g_iTankType[owner]] ? g_flGravityValue[g_iTankType[owner]] : g_flGravityValue2[g_iTankType[owner]];
			SetEntityGravity(client, flGravityValue);
			float flGravityDuration = !g_bTankConfig[g_iTankType[owner]] ? g_flGravityDuration[g_iTankType[owner]] : g_flGravityDuration2[g_iTankType[owner]];
			CreateTimer(flGravityDuration, tTimerStopGravity, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
		}
	}
}

void vHealAbility(int client, int enabled)
{
	int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
	if (enabled == 1 && bIsTank(client) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(client))))
	{
		if (!g_bHeal[client])
		{
			g_bHeal[client] = true;
			float flHealInterval = !g_bTankConfig[g_iTankType[client]] ? g_flHealInterval[g_iTankType[client]] : g_flHealInterval2[g_iTankType[client]];
			CreateTimer(flHealInterval, tTimerHeal, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
		}
	}
}

void vHealHit(int client, int owner, int enabled)
{
	int iHealChance = !g_bTankConfig[g_iTankType[owner]] ? g_iHealChance[g_iTankType[owner]] : g_iHealChance2[g_iTankType[owner]];
	if (enabled == 1 && GetRandomInt(1, iHealChance) == 1 && bIsSurvivor(client))
	{
		SetEntProp(client, Prop_Send, "m_currentReviveCount", g_cvSTFindConVar[3].IntValue - 1);
		SetEntProp(client, Prop_Send, "m_isIncapacitated", 1);
		SDKCall(g_hSDKRevivePlayer, client);
		SetEntityHealth(client, 1);
		SDKCall(g_hSDKHealPlayer, client, 50.0);
	}
}

void vHurtAbility(int client, int owner, int enabled)
{
	int iHurtChance = !g_bTankConfig[g_iTankType[owner]] ? g_iHurtChance[g_iTankType[owner]] : g_iHurtChance2[g_iTankType[owner]];
	if (enabled == 1 && GetRandomInt(1, iHurtChance) == 1 && bIsSurvivor(client))
	{
		if (!g_bHurt[client])
		{
			g_bHurt[client] = true;
			DataPack dpDataPack;
			CreateDataTimer(1.0, tTimerHurt, dpDataPack, TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
			dpDataPack.WriteCell(GetClientUserId(client));
			dpDataPack.WriteCell(GetClientUserId(owner));
			dpDataPack.WriteFloat(GetEngineTime());
		}
	}
}

void vHypnoHit(int client, int owner, int enabled)
{
	int iHypnoChance = !g_bTankConfig[g_iTankType[owner]] ? g_iHypnoChance[g_iTankType[owner]] : g_iHypnoChance2[g_iTankType[owner]];
	if (enabled == 1 && GetRandomInt(1, iHypnoChance) == 1 && bIsSurvivor(client))
	{
		if (!g_bHypno[client])
		{
			g_bHypno[client] = true;
			float flHypnoDuration = !g_bTankConfig[g_iTankType[owner]] ? g_flHypnoDuration[g_iTankType[owner]] : g_flHypnoDuration2[g_iTankType[owner]];
			CreateTimer(flHypnoDuration, tTimerStopHypnosis, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
		}
	}
}

void vIceHit(int client, int owner, int enabled)
{
	int iIceChance = !g_bTankConfig[g_iTankType[owner]] ? g_iIceChance[g_iTankType[owner]] : g_iIceChance2[g_iTankType[owner]];
	if (enabled == 1 && GetRandomInt(1, iIceChance) == 1 && bIsSurvivor(client))
	{
		if (!g_bIce[client])
		{
			g_bIce[client] = true;
			float flPos[3];
			GetClientEyePosition(client, flPos);
			if (GetEntityMoveType(client) != MOVETYPE_NONE)
			{
				SetEntityMoveType(client, MOVETYPE_NONE);
				SetEntityRenderColor(client, 0, 130, 255, 190);
				EmitAmbientSound(SOUND_BULLET, flPos, client, SNDLEVEL_RAIDSIREN);
			}
			CreateTimer(5.0, tTimerStopIce, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
		}
	}
}

void vIdleHit(int client, int owner, int enabled)
{
	int iIdleChance = !g_bTankConfig[g_iTankType[owner]] ? g_iIdleChance[g_iTankType[owner]] : g_iIdleChance2[g_iTankType[owner]];
	if (enabled == 1 && GetRandomInt(1, iIdleChance) == 1 && bIsHumanSurvivor(client))
	{
		if (!g_bIdle[client])
		{
			if (iGetHumanCount() > 1)
			{
				FakeClientCommand(client, "go_away_from_keyboard");
			}
			else
			{
				vIdleWarp(client);
				SDKCall(g_hSDKIdlePlayer, client);
			}
			if (bIsBotIdle(client))
			{
				g_bAFK[client] = true;
				g_bIdle[client] = true;
			}
		}
	}
}

void vInvertHit(int client, int owner, int enabled)
{
	int iInvertChance = !g_bTankConfig[g_iTankType[owner]] ? g_iInvertChance[g_iTankType[owner]] : g_iInvertChance2[g_iTankType[owner]];
	if (enabled == 1 && GetRandomInt(1, iInvertChance) == 1 && bIsSurvivor(client))
	{
		if (!g_bInvert[client])
		{
			g_bInvert[client] = true;
			float flInvertDuration = !g_bTankConfig[g_iTankType[owner]] ? g_flInvertDuration[g_iTankType[owner]] : g_flInvertDuration2[g_iTankType[owner]];
			CreateTimer(flInvertDuration, tTimerStopInversion, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
		}
	}
}

void vJumperAbility(int client, int enabled)
{
	int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
	if (enabled == 1 && bIsTank(client) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(client))))
	{
		CreateTimer(1.0, tTimerJump, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
	}
}

void vMeteor(int entity, int client)
{
	if (IsValidEntity(entity))
	{
		char sClassname[16];
		GetEntityClassname(entity, sClassname, sizeof(sClassname));
		if (strcmp(sClassname, "tank_rock") == 0)
		{
			RemoveEntity(entity);
			int iEntity = CreateEntityByName("prop_physics");
			float flMeteorDamage = !g_bTankConfig[g_iTankType[client]] ? g_flMeteorDamage[g_iTankType[client]] : g_flMeteorDamage2[g_iTankType[client]];
			SetEntityModel(iEntity, MODEL_PROPANETANK);
			float flPos[3];
			GetEntPropVector(entity, Prop_Send, "m_vecOrigin", flPos);
			flPos[2] += 50.0;
			TeleportEntity(iEntity, flPos, NULL_VECTOR, NULL_VECTOR);
			DispatchSpawn(iEntity);
			ActivateEntity(iEntity);
			SetEntPropEnt(iEntity, Prop_Data, "m_hPhysicsAttacker", client);
			SetEntPropFloat(iEntity, Prop_Data, "m_flLastPhysicsInfluenceTime", GetGameTime());
			SetEntProp(iEntity, Prop_Send, "m_CollisionGroup", 1);
			SetEntityRenderMode(iEntity, RENDER_TRANSCOLOR);
			SetEntityRenderColor(iEntity, 0, 0, 0, 0);
			AcceptEntityInput(iEntity, "Break");
			int iPointHurt = CreateEntityByName("point_hurt");
			SetEntPropEnt(iPointHurt, Prop_Send, "m_hOwnerEntity", client);
			DispatchKeyValueFloat(iPointHurt, "Damage", flMeteorDamage);
			DispatchKeyValue(iPointHurt, "DamageType", "2");
			DispatchKeyValue(iPointHurt, "DamageDelay", "0.0");
			DispatchKeyValueFloat(iPointHurt, "DamageRadius", 200.0);
			TeleportEntity(iPointHurt, flPos, NULL_VECTOR, NULL_VECTOR);
			DispatchSpawn(iPointHurt);
			int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
			if (IsValidEntity(client) && bIsTank(client) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(client))))
			{
				AcceptEntityInput(iPointHurt, "Hurt", client);
			}
			iPointHurt = EntIndexToEntRef(iPointHurt);
			vDeleteEntity(iPointHurt, 0.1);
			int iPointPush = CreateEntityByName("point_push");
			SetEntPropEnt(iPointPush, Prop_Send, "m_hOwnerEntity", client);
			DispatchKeyValueFloat(iPointPush, "magnitude", 600.0);
			DispatchKeyValueFloat(iPointPush, "radius", 200.0 * 1.0);
	  		DispatchKeyValue(iPointPush, "spawnflags", "8");
			TeleportEntity(iPointPush, flPos, NULL_VECTOR, NULL_VECTOR);
	 		DispatchSpawn(iPointPush);
	 		AcceptEntityInput(iPointPush, "Enable", -1, -1);
			iPointPush = EntIndexToEntRef(iPointPush);
			vDeleteEntity(iPointPush, 0.5);
		}
	}
}

void vMeteorAbility(int client, int enabled)
{
	int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
	int iMeteorChance = !g_bTankConfig[g_iTankType[client]] ? g_iMeteorChance[g_iTankType[client]] : g_iMeteorChance2[g_iTankType[client]];
	if (enabled == 1 && GetRandomInt(1, iMeteorChance) == 1 && bIsTank(client) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(client))) && !g_bMeteor[client])
	{
		g_bMeteor[client] = true;
		float flPos[3];
		GetClientEyePosition(client, flPos);
		DataPack dpDataPack;
		CreateDataTimer(0.6, tTimerMeteorEffectUpdate, dpDataPack, TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
		dpDataPack.WriteCell(GetClientUserId(client));
		dpDataPack.WriteFloat(flPos[0]);
		dpDataPack.WriteFloat(flPos[1]);
		dpDataPack.WriteFloat(flPos[2]);
		dpDataPack.WriteFloat(GetEngineTime());
	}
}

void vNullifyHit(int client, int owner, int enabled)
{
	int iNullifyChance = !g_bTankConfig[g_iTankType[owner]] ? g_iNullifyChance[g_iTankType[owner]] : g_iNullifyChance2[g_iTankType[owner]];
	if (enabled == 1 && GetRandomInt(1, iNullifyChance) == 1 && bIsSurvivor(client))
	{
		if (!g_bNullify[client])
		{
			g_bNullify[client] = true;
			float flNullifyDuration = !g_bTankConfig[g_iTankType[owner]] ? g_flNullifyDuration[g_iTankType[owner]] : g_flNullifyDuration2[g_iTankType[owner]];
			CreateTimer(flNullifyDuration, tTimerStopNullify, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
		}
	}
}

void vPanicHit(int client, int enabled)
{
	int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
	int iPanicChance = !g_bTankConfig[g_iTankType[client]] ? g_iPanicChance[g_iTankType[client]] : g_iPanicChance2[g_iTankType[client]];
	if (enabled == 1 && GetRandomInt(1, iPanicChance) == 1 && bIsTank(client) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(client))))
	{
		int iDirector = CreateEntityByName("info_director");
		if (IsValidEntity(iDirector))
		{
			DispatchSpawn(iDirector);
			AcceptEntityInput(iDirector, "ForcePanicEvent");
			RemoveEntity(iDirector);
		}
	}
}

void vParticleEffects(int client, int enabled)
{
	int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
	char sEffect[8];
	sEffect = !g_bTankConfig[g_iTankType[client]] ? g_sParticleEffects[g_iTankType[client]] : g_sParticleEffects2[g_iTankType[client]];
	if (enabled == 1 && bIsTank(client) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(client))))
	{
		if (StrContains(sEffect, "1") != -1)
		{
			CreateTimer(0.75, tTimerBloodEffect, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
		}
		if (StrContains(sEffect, "2") != -1)
		{
			CreateTimer(0.75, tTimerElectricEffect, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
		}
		if (StrContains(sEffect, "3") != -1)
		{
			CreateTimer(0.75, tTimerFireEffect, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
		}
		if (StrContains(sEffect, "4") != -1)
		{
			CreateTimer(2.0, tTimerIceEffect, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
		}
		if (StrContains(sEffect, "5") != -1)
		{
			CreateTimer(6.0, tTimerMeteorEffect, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
		}
		if (StrContains(sEffect, "6") != -1)
		{
			CreateTimer(1.5, tTimerSmokeEffect, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
		}
		if (StrContains(sEffect, "7") != -1 && bIsL4D2Game())
		{
			CreateTimer(2.0, tTimerSpitEffect, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
		}
	}
}

void vProps(int client, int red, int green, int blue, int alpha, int red2, int green2, int blue2, int alpha2, int red3, int green3, int blue3, int alpha3, int red4, int green4, int blue4, int alpha4, int red5, int green5, int blue5, int alpha5)
{
	char sSet[5][4];
	!g_bTankConfig[g_iTankType[client]] ? ExplodeString(g_sPropsChance[g_iTankType[client]], ",", sSet, sizeof(sSet), sizeof(sSet[])) : ExplodeString(g_sPropsChance2[g_iTankType[client]], ",", sSet, sizeof(sSet), sizeof(sSet[]));
	int iChance1 = StringToInt(sSet[0]);
	int iChance2 = StringToInt(sSet[1]);
	int iChance3 = StringToInt(sSet[2]);
	int iChance4 = StringToInt(sSet[3]);
	int iChance5 = StringToInt(sSet[4]);
	char sPropsAttached[6];
	sPropsAttached = !g_bTankConfig[g_iTankType[client]] ? g_sPropsAttached[g_iTankType[client]] : g_sPropsAttached2[g_iTankType[client]];
	if (GetRandomInt(1, iChance1) == 1 && StrContains(sPropsAttached, "1") != -1)
	{
		float flOrigin[3];
		float flAngles[3];
		GetEntPropVector(client, Prop_Send, "m_vecOrigin", flOrigin);
		GetEntPropVector(client, Prop_Send, "m_angRotation", flAngles);
		flAngles[0] += -90.0;
		int iEntity = CreateEntityByName("beam_spotlight");
		if (IsValidEntity(iEntity))
		{
			DispatchKeyValueVector(iEntity, "origin", flOrigin);
			DispatchKeyValueVector(iEntity, "angles", flAngles);
			DispatchKeyValue(iEntity, "spotlightwidth", "10");
			DispatchKeyValue(iEntity, "spotlightlength", "60");
			DispatchKeyValue(iEntity, "spawnflags", "3");
			SetEntityRenderColor(iEntity, red, green, blue, alpha);
			DispatchKeyValue(iEntity, "maxspeed", "100");
			DispatchKeyValue(iEntity, "HDRColorScale", "0.7");
			DispatchKeyValue(iEntity, "fadescale", "1");
			DispatchKeyValue(iEntity, "fademindist", "-1");
			SetVariantString("!activator");
			AcceptEntityInput(iEntity, "SetParent", client);
			SetVariantString("mouth");
			AcceptEntityInput(iEntity, "SetParentAttachment");
			AcceptEntityInput(iEntity, "Enable");
			AcceptEntityInput(iEntity, "DisableCollision");
			SetEntPropEnt(iEntity, Prop_Send, "m_hOwnerEntity", client);
			TeleportEntity(iEntity, NULL_VECTOR, flAngles, NULL_VECTOR);
			DispatchSpawn(iEntity);
			SDKHook(iEntity, SDKHook_SetTransmit, SetTransmit);
		}
	}
	if (GetRandomInt(1, iChance2) == 1 && StrContains(sPropsAttached, "2") != -1)
	{
		float flOrigin[3];
		float flAngles[3];
		GetClientEyePosition(client, flOrigin);
		GetClientAbsAngles(client, flAngles);
		int iEntity[5];
		for (int iOzTank = 1; iOzTank <= 4; iOzTank++)
		{
			iEntity[iOzTank] = CreateEntityByName("prop_dynamic_override");
			if (IsValidEntity(iEntity[iOzTank]))
			{
				SetEntityModel(iEntity[iOzTank], MODEL_JETPACK);
				SetEntityRenderColor(iEntity[iOzTank], red2, green2, blue2, alpha2);
				SetEntProp(iEntity[iOzTank], Prop_Data, "m_takedamage", 0, 1);
				SetEntProp(iEntity[iOzTank], Prop_Data, "m_CollisionGroup", 2);
				SetVariantString("!activator");
				AcceptEntityInput(iEntity[iOzTank], "SetParent", client);
				switch (iOzTank)
				{
					case 1:
					{
						SetVariantString("rfoot");
						vSetVector(flOrigin, 0.0, 30.0, 8.0);
					}
					case 2:
					{
						SetVariantString("lfoot");
						vSetVector(flOrigin, 0.0, 30.0, -8.0);
					}
					case 3:
					{
						SetVariantString("rshoulder");
						vSetVector(flOrigin, 0.0, 30.0, 8.0);
					}
					case 4:
					{
						SetVariantString("lshoulder");
						vSetVector(flOrigin, 0.0, 30.0, -8.0);
					}
				}
				AcceptEntityInput(iEntity[iOzTank], "SetParentAttachment");
				float flAngles2[3];
				vSetVector(flAngles2, 0.0, 0.0, 1.0);
				GetVectorAngles(flAngles2, flAngles2);
				vCopyVector(flAngles, flAngles2);
				flAngles2[2] += 90.0;
				DispatchKeyValueVector(iEntity[iOzTank], "origin", flOrigin);
				DispatchKeyValueVector(iEntity[iOzTank], "angles", flAngles2);
				AcceptEntityInput(iEntity[iOzTank], "Enable");
				AcceptEntityInput(iEntity[iOzTank], "DisableCollision");
				SetEntPropEnt(iEntity[iOzTank], Prop_Send, "m_hOwnerEntity", client);
				TeleportEntity(iEntity[iOzTank], flOrigin, NULL_VECTOR, flAngles2);
				DispatchSpawn(iEntity[iOzTank]);
				if (GetRandomInt(1, iChance3) == 1 && StrContains(sPropsAttached, "3") != -1)
				{
					int iFlame = CreateEntityByName("env_steam");
					if (IsValidEntity(iFlame))
					{
						SetEntityRenderColor(iFlame, red3, green3, blue3, alpha3);
						DispatchKeyValue(iFlame, "spawnflags", "1");
						DispatchKeyValue(iFlame, "Type", "0");
						DispatchKeyValue(iFlame, "InitialState", "1");
						DispatchKeyValue(iFlame, "Spreadspeed", "1");
						DispatchKeyValue(iFlame, "Speed", "250");
						DispatchKeyValue(iFlame, "Startsize", "6");
						DispatchKeyValue(iFlame, "EndSize", "8");
						DispatchKeyValue(iFlame, "Rate", "555");
						DispatchKeyValue(iFlame, "JetLength", "40");
						SetVariantString("!activator");
						AcceptEntityInput(iFlame, "SetParent", iEntity[iOzTank]);
						SetEntPropEnt(iFlame, Prop_Send, "m_hOwnerEntity", client);
						float flOrigin2[3];
						float flAngles3[3];
						vSetVector(flOrigin2, -2.0, 0.0, 26.0);
						vSetVector(flAngles3, 0.0, 0.0, 1.0);
						GetVectorAngles(flAngles3, flAngles3);
						TeleportEntity(iFlame, flOrigin2, flAngles3, NULL_VECTOR);
						DispatchSpawn(iFlame);
						AcceptEntityInput(iFlame, "TurnOn");
						SDKHook(iFlame, SDKHook_SetTransmit, SetTransmit);
					}
				}
				SDKHook(iEntity[iOzTank], SDKHook_SetTransmit, SetTransmit);
			}
		}
	}
	if (GetRandomInt(1, iChance4) == 1 && StrContains(sPropsAttached, "4") != -1)
	{
		float flOrigin[3];
		float flAngles[3];
		GetEntPropVector(client, Prop_Send, "m_vecOrigin", flOrigin);
		GetEntPropVector(client, Prop_Send, "m_angRotation", flAngles);
		int iEntity[5];
		for (int iRock = 1; iRock <= 4; iRock++)
		{
			iEntity[iRock] = CreateEntityByName("prop_dynamic_override");
			if (IsValidEntity(iEntity[iRock]))
			{
				SetEntityModel(iEntity[iRock], MODEL_CONCRETE);
				SetEntityRenderColor(iEntity[iRock], red4, green4, blue4, alpha4);
				DispatchKeyValueVector(iEntity[iRock], "origin", flOrigin);
				DispatchKeyValueVector(iEntity[iRock], "angles", flAngles);
				SetVariantString("!activator");
				AcceptEntityInput(iEntity[iRock], "SetParent", client);
				switch (iRock)
				{
					case 1: SetVariantString("relbow");
					case 2: SetVariantString("lelbow");
					case 3: SetVariantString("rshoulder");
					case 4: SetVariantString("lshoulder");
				}
				AcceptEntityInput(iEntity[iRock], "SetParentAttachment");
				AcceptEntityInput(iEntity[iRock], "Enable");
				AcceptEntityInput(iEntity[iRock], "DisableCollision");
				if (bIsL4D2Game())
				{
					switch (iRock)
					{
						case 1, 2: SetEntPropFloat(iEntity[iRock], Prop_Data, "m_flModelScale", 0.4);
						case 3, 4: SetEntPropFloat(iEntity[iRock], Prop_Data, "m_flModelScale", 0.5);
					}
				}
				SetEntPropEnt(iEntity[iRock], Prop_Send, "m_hOwnerEntity", client);
				flAngles[0] = flAngles[0] + GetRandomFloat(-90.0, 90.0);
				flAngles[1] = flAngles[1] + GetRandomFloat(-90.0, 90.0);
				flAngles[2] = flAngles[2] + GetRandomFloat(-90.0, 90.0);
				TeleportEntity(iEntity[iRock], NULL_VECTOR, flAngles, NULL_VECTOR);
				DispatchSpawn(iEntity[iRock]);
				SDKHook(iEntity[iRock], SDKHook_SetTransmit, SetTransmit);
			}
		}
	}
	if (GetRandomInt(1, iChance5) == 1 && StrContains(sPropsAttached, "5") != -1)
	{
		float flOrigin[3];
		float flAngles[3];
		GetEntPropVector(client, Prop_Send, "m_vecOrigin", flOrigin);
		GetEntPropVector(client, Prop_Send, "m_angRotation", flAngles);
		flAngles[0] += 90.0;
		int iEntity[3];
		for (int iTire = 1; iTire <= 2; iTire++)
		{
			iEntity[iTire] = CreateEntityByName("prop_dynamic_override");
			if (IsValidEntity(iEntity[iTire]))
			{
				SetEntityModel(iEntity[iTire], MODEL_TIRES);
				SetEntityRenderColor(iEntity[iTire], red5, green5, blue5, alpha5);
				DispatchKeyValueVector(iEntity[iTire], "origin", flOrigin);
				DispatchKeyValueVector(iEntity[iTire], "angles", flAngles);
				SetVariantString("!activator");
				AcceptEntityInput(iEntity[iTire], "SetParent", client);
				switch (iTire)
				{
					case 1: SetVariantString("rfoot");
					case 2: SetVariantString("lfoot");
				}
				AcceptEntityInput(iEntity[iTire], "SetParentAttachment");
				AcceptEntityInput(iEntity[iTire], "Enable");
				AcceptEntityInput(iEntity[iTire], "DisableCollision");
				if (bIsL4D2Game())
				{
					SetEntPropFloat(iEntity[iTire], Prop_Data, "m_flModelScale", 1.5);
				}
				SetEntPropEnt(iEntity[iTire], Prop_Send, "m_hOwnerEntity", client);
				TeleportEntity(iEntity[iTire], NULL_VECTOR, flAngles, NULL_VECTOR);
				DispatchSpawn(iEntity[iTire]);
				SDKHook(iEntity[iTire], SDKHook_SetTransmit, SetTransmit);
			}
		}
	}
}

void vPukeHit(int client, int owner, int enabled)
{
	int iPukeChance = !g_bTankConfig[g_iTankType[owner]] ? g_iPukeChance[g_iTankType[owner]] : g_iPukeChance2[g_iTankType[owner]];
	if (enabled == 1 && GetRandomInt(1, iPukeChance) == 1 && bIsSurvivor(client))
	{
		SDKCall(g_hSDKPukePlayer, client, owner, true);
	}
}

void vRestartHit(int client, int owner, int enabled)
{
	int iRestartChance = !g_bTankConfig[g_iTankType[owner]] ? g_iRestartChance[g_iTankType[owner]] : g_iRestartChance2[g_iTankType[owner]];
	if (enabled == 1 && GetRandomInt(1, iRestartChance) == 1 && bIsSurvivor(client))
	{
		SDKCall(g_hSDKRespawnPlayer, client);
		char sItems[5][64];
		!g_bTankConfig[g_iTankType[owner]] ? ExplodeString(g_sLoadout[g_iTankType[owner]], ",", sItems, sizeof(sItems), sizeof(sItems[])) : ExplodeString(g_sLoadout2[g_iTankType[owner]], ",", sItems, sizeof(sItems), sizeof(sItems[]));
		for (int iItem = 0; iItem < sizeof(sItems); iItem++)
		{
			char sLoadout[325];
			sLoadout = !g_bTankConfig[g_iTankType[owner]] ? g_sLoadout[g_iTankType[owner]] : g_sLoadout2[g_iTankType[owner]];
			if (StrContains(sLoadout, sItems[iItem]) != -1 && sItems[iItem][0] != '\0')
			{
				vCheatCommand(client, "give", sItems[iItem]);
			}
		}
		if (g_bRestartValid)
		{
			TeleportEntity(client, g_flSpawnPosition, NULL_VECTOR, NULL_VECTOR);
		}
		else
		{
			float flCurrentOrigin[3] = {0.0, 0.0, 0.0};
			for (int iPlayer = 1; iPlayer <= MaxClients; iPlayer++)
			{
				if (bIsSurvivor(iPlayer) && iPlayer != client)
				{
					GetClientAbsOrigin(iPlayer, flCurrentOrigin);
					TeleportEntity(client, flCurrentOrigin, NULL_VECTOR, NULL_VECTOR);
					break;
				}
			}
		}
	}
}

void vRocketHit(int client, int owner, int enabled)
{
	int iRocketChance = !g_bTankConfig[g_iTankType[owner]] ? g_iRocketChance[g_iTankType[owner]] : g_iRocketChance2[g_iTankType[owner]];
	if (enabled == 1 && GetRandomInt(1, iRocketChance) == 1 && bIsSurvivor(client))
	{
		int iFlame = CreateEntityByName("env_steam");
		if (IsValidEntity(iFlame))
		{
			float flPosition[3];
			GetEntPropVector(client, Prop_Send, "m_vecOrigin", flPosition);
			flPosition[2] += 30.0;
			float flAngles[3];
			flAngles[0] = 90.0;
			flAngles[1] = 0.0;
			flAngles[2] = 0.0;
			DispatchKeyValue(iFlame, "spawnflags", "1");
			DispatchKeyValue(iFlame, "Type", "0");
			DispatchKeyValue(iFlame, "InitialState", "1");
			DispatchKeyValue(iFlame, "Spreadspeed", "10");
			DispatchKeyValue(iFlame, "Speed", "800");
			DispatchKeyValue(iFlame, "Startsize", "10");
			DispatchKeyValue(iFlame, "EndSize", "250");
			DispatchKeyValue(iFlame, "Rate", "15");
			DispatchKeyValue(iFlame, "JetLength", "400");
			SetEntityRenderColor(iFlame, 180, 70, 10, 180);
			TeleportEntity(iFlame, flPosition, flAngles, NULL_VECTOR);
			DispatchSpawn(iFlame);
			SetVariantString("!activator");
			AcceptEntityInput(iFlame, "SetParent", client);
			iFlame = EntIndexToEntRef(iFlame);
			vDeleteEntity(iFlame, 3.0);
			g_iRocket[client] = iFlame;
		}
		EmitSoundToAll(SOUND_FIRE, client, _, _, _, 1.0);
		CreateTimer(2.0, tTimerRocketLaunch, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
		CreateTimer(3.5, tTimerRocketDetonate, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
	}
}

void vSetColor(int client, int value)
{
	char sSet[2][16];
	!g_bTankConfig[value] ? ExplodeString(g_sTankColors[value], "|", sSet, sizeof(sSet), sizeof(sSet[])) : ExplodeString(g_sTankColors2[value], "|", sSet, sizeof(sSet), sizeof(sSet[]));
	char sRGB[4][4];
	ExplodeString(sSet[0], ",", sRGB, sizeof(sRGB), sizeof(sRGB[]));
	int iRed = StringToInt(sRGB[0]);
	int iGreen = StringToInt(sRGB[1]);
	int iBlue = StringToInt(sRGB[2]);
	int iAlpha = StringToInt(sRGB[3]);
	char sGlow[3][4];
	ExplodeString(sSet[1], ",", sGlow, sizeof(sGlow), sizeof(sGlow[]));
	int iRed2 = StringToInt(sGlow[0]);
	int iGreen2 = StringToInt(sGlow[1]);
	int iBlue2 = StringToInt(sGlow[2]);
	int iGlowEffect = !g_bTankConfig[value] ? g_iGlowEffect[value] : g_iGlowEffect2[value];
	if (iGlowEffect == 1 && bIsL4D2Game())
	{
		SetEntProp(client, Prop_Send, "m_iGlowType", 3);
		SetEntProp(client, Prop_Send, "m_glowColorOverride", iGetRGBColor(iRed2, iGreen2, iBlue2));
	}
	SetEntityRenderMode(client, RENDER_NORMAL);
	SetEntityRenderColor(client, iRed, iGreen, iBlue, iAlpha);
	g_iTankType[client] = value;
}

void vSetName(int client, char[] name)
{
	char sSet[5][16];
	!g_bTankConfig[g_iTankType[client]] ? ExplodeString(g_sPropsColors[g_iTankType[client]], "|", sSet, sizeof(sSet), sizeof(sSet[])) : ExplodeString(g_sPropsColors2[g_iTankType[client]], "|", sSet, sizeof(sSet), sizeof(sSet[]));
	char sRGB[4][4];
	ExplodeString(sSet[0], ",", sRGB, sizeof(sRGB), sizeof(sRGB[]));
	int iRed = StringToInt(sRGB[0]);
	int iGreen = StringToInt(sRGB[1]);
	int iBlue = StringToInt(sRGB[2]);
	int iAlpha = StringToInt(sRGB[3]);
	char sRGB2[4][4];
	ExplodeString(sSet[1], ",", sRGB2, sizeof(sRGB2), sizeof(sRGB2[]));
	int iRed2 = StringToInt(sRGB2[0]);
	int iGreen2 = StringToInt(sRGB2[1]);
	int iBlue2 = StringToInt(sRGB2[2]);
	int iAlpha2 = StringToInt(sRGB2[3]);
	char sRGB3[4][4];
	ExplodeString(sSet[2], ",", sRGB3, sizeof(sRGB3), sizeof(sRGB3[]));
	int iRed3 = StringToInt(sRGB3[0]);
	int iGreen3 = StringToInt(sRGB3[1]);
	int iBlue3 = StringToInt(sRGB3[2]);
	int iAlpha3 = StringToInt(sRGB3[3]);
	char sRGB4[4][4];
	ExplodeString(sSet[3], ",", sRGB4, sizeof(sRGB4), sizeof(sRGB4[]));
	int iRed4 = StringToInt(sRGB4[0]);
	int iGreen4 = StringToInt(sRGB4[1]);
	int iBlue4 = StringToInt(sRGB4[2]);
	int iAlpha4 = StringToInt(sRGB4[3]);
	char sRGB5[4][4];
	ExplodeString(sSet[4], ",", sRGB5, sizeof(sRGB5), sizeof(sRGB5[]));
	int iRed5 = StringToInt(sRGB5[0]);
	int iGreen5 = StringToInt(sRGB5[1]);
	int iBlue5 = StringToInt(sRGB5[2]);
	int iAlpha5 = StringToInt(sRGB5[3]);
	int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
	if (bIsTank(client) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(client))))
	{
		vSetProps(client, iRed, iGreen, iBlue, iAlpha, iRed2, iGreen2, iBlue2, iAlpha2, iRed3, iGreen3, iBlue3, iAlpha3, iRed4, iGreen4, iBlue4, iAlpha4, iRed5, iGreen5, iBlue5, iAlpha5);
		if (IsFakeClient(client))
		{
			SetClientInfo(client, "name", name);
			int iAnnounceArrival = !g_bGeneralConfig ? g_iAnnounceArrival : g_iAnnounceArrival2;
			if (iAnnounceArrival == 1)
			{
				switch (GetRandomInt(1, 5))
				{
					case 1: PrintToChatAll("\x04%s\x05 %s\x01 has appeared!", ST_PREFIX, name);
					case 2: PrintToChatAll("\x04%s\x05 %s\x01 is ready to kill!", ST_PREFIX, name);
					case 3: PrintToChatAll("\x04%s\x05 %s\x01 came for a challenge!", ST_PREFIX, name);
					case 4: PrintToChatAll("\x04%s\x05 %s\x01 is here!", ST_PREFIX, name);
					case 5: PrintToChatAll("\x04%s\x05 %s\x01 joined the game!", ST_PREFIX, name);
				}
			}
		}
	}
}

void vSetProps(int client, int red, int green, int blue, int alpha, int red2, int green2, int blue2, int alpha2, int red3, int green3, int blue3, int alpha3, int red4, int green4, int blue4, int alpha4, int red5, int green5, int blue5, int alpha5)
{
	int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
	if (bIsTank(client) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(client))))
	{
		vProps(client, red, green, blue, alpha, red2, green2, blue2, alpha2, red3, green3, blue3, alpha3, red4, green4, blue4, alpha4, red5, green5, blue5, alpha5);
	}
}

void vShakeHit(int client, int owner, int enabled)
{
	int iShakeChance = !g_bTankConfig[g_iTankType[owner]] ? g_iShakeChance[g_iTankType[owner]] : g_iShakeChance2[g_iTankType[owner]];
	if (enabled == 1 && GetRandomInt(1, iShakeChance) == 1 && bIsSurvivor(client))
	{
		if (!g_bShake[client])
		{
			g_bShake[client] = true;
			DataPack dpDataPack;
			CreateDataTimer(1.0, tTimerShake, dpDataPack, TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
			dpDataPack.WriteCell(GetClientUserId(client));
			dpDataPack.WriteCell(GetClientUserId(owner));
			dpDataPack.WriteFloat(GetEngineTime());
		}
	}
}

void vShieldAbility(int client, bool shield, int enabled)
{
	int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
	if (enabled == 1 && bIsTank(client) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(client))))
	{
		if (shield)
		{
			char sSet[3][4];
			!g_bTankConfig[g_iTankType[client]] ? ExplodeString(g_sShieldColor[g_iTankType[client]], ",", sSet, sizeof(sSet), sizeof(sSet[])) : ExplodeString(g_sShieldColor2[g_iTankType[client]], ",", sSet, sizeof(sSet), sizeof(sSet[]));
			int iRed = StringToInt(sSet[0]);
			int iGreen = StringToInt(sSet[1]);
			int iBlue = StringToInt(sSet[2]);
			float flOrigin[3];
			GetClientAbsOrigin(client, flOrigin);
			flOrigin[2] -= 120.0;
			int iEntity = CreateEntityByName("prop_dynamic");
			if (IsValidEntity(iEntity))
			{
				SetEntityModel(iEntity, MODEL_SHIELD);
				DispatchKeyValueVector(iEntity, "origin", flOrigin);
				DispatchSpawn(iEntity);
				SetVariantString("!activator");
				AcceptEntityInput(iEntity, "SetParent", client);
				SetEntityRenderMode(iEntity, RENDER_TRANSTEXTURE);
				SetEntityRenderColor(iEntity, iRed, iGreen, iBlue, 50);
				SetEntProp(iEntity, Prop_Send, "m_CollisionGroup", 1);
				SetEntPropEnt(iEntity, Prop_Send, "m_hOwnerEntity", client);
			}
			g_bShielded[client] = true;
		}
		else
		{
			int iEntity = -1;
			while ((iEntity = FindEntityByClassname(iEntity, "prop_dynamic")) != INVALID_ENT_REFERENCE)
			{
				char sModel[128];
				GetEntPropString(iEntity, Prop_Data, "m_ModelName", sModel, sizeof(sModel));
				if (strcmp(sModel, MODEL_SHIELD) == 0)
				{
					int iOwner = GetEntPropEnt(iEntity, Prop_Send, "m_hOwnerEntity");
					if (iOwner == client)
					{
						AcceptEntityInput(iEntity, "Kill");
					}
				}
			}
			float flShieldDelay = !g_bTankConfig[g_iTankType[client]] ? g_flShieldDelay[g_iTankType[client]] : g_flShieldDelay2[g_iTankType[client]];
			CreateTimer(flShieldDelay, tTimerShield, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
			g_bShielded[client] = false;
		}
	}
}

void vShoveHit(int client, int owner, int enabled)
{
	int iShoveChance = !g_bTankConfig[g_iTankType[owner]] ? g_iShoveChance[g_iTankType[owner]] : g_iShoveChance2[g_iTankType[owner]];
	if (enabled == 1 && GetRandomInt(1, iShoveChance) == 1 && bIsSurvivor(client))
	{
		if (!g_bShove[client])
		{
			g_bShove[client] = true;
			DataPack dpDataPack;
			CreateDataTimer(1.0, tTimerShove, dpDataPack, TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
			dpDataPack.WriteCell(GetClientUserId(client));
			dpDataPack.WriteCell(GetClientUserId(owner));
			dpDataPack.WriteFloat(GetEngineTime());
		}
	}
}

void vSlugHit(int client, int owner, int enabled)
{
	int iSlugChance = !g_bTankConfig[g_iTankType[owner]] ? g_iSlugChance[g_iTankType[owner]] : g_iSlugChance2[g_iTankType[owner]];
	if (enabled == 1 && GetRandomInt(1, iSlugChance) == 1 && bIsSurvivor(client))
	{
		float flPosition[3];
		GetClientAbsOrigin(client, flPosition);
		flPosition[2] -= 26;
		float flStartPosition[3];
		flStartPosition[0] = flPosition[0] + GetRandomInt(-500, 500);
		flStartPosition[1] = flPosition[1] + GetRandomInt(-500, 500);
		flStartPosition[2] = flPosition[2] + 800;
		int iColor[4] = {255, 255, 255, 255};
		float flDirection[3] = {0.0, 0.0, 0.0};
		TE_SetupBeamPoints(flStartPosition, flPosition, g_iSlugSprite, 0, 0, 0, 0.2, 20.0, 10.0, 0, 1.0, iColor, 3);
		TE_SendToAll();
		TE_SetupSparks(flPosition, flDirection, 5000, 1000);
		TE_SendToAll();
		TE_SetupEnergySplash(flPosition, flDirection, false);
		TE_SendToAll();
		EmitAmbientSound(SOUND_EXPLOSION3, flStartPosition, client, SNDLEVEL_RAIDSIREN);
		ForcePlayerSuicide(client);
	}
}

void vSpamAbility(int client, int enabled)
{
	int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
	if (enabled == 1 && bIsTank(client) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(client))))
	{
		if (!g_bSpam[client])
		{
			g_bSpam[client] = true;
			float flSpamInterval = !g_bTankConfig[g_iTankType[client]] ? g_flSpamInterval[g_iTankType[client]] : g_flSpamInterval2[g_iTankType[client]];
			CreateTimer(flSpamInterval, tTimerSpam, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
		}
	}
}

void vStopTimers(int client)
{
	if (bIsValidClient(client))
	{
		g_bAFK[client] = false;
		g_bBlind[client] = false;
		g_bBury[client] = false;
		g_bFlash[client] = false;
		g_bGhost[client] = false;
		g_bGravity[client] = false;
		g_bGravity2[client] = false;
		g_bHeal[client] = false;
		g_bHurt[client] = false;
		g_bHypno[client] = false;
		g_bIce[client] = false;
		g_bIdle[client] = false;
		g_bInvert[client] = false;
		g_bMeteor[client] = false;
		g_bNullify[client] = false;
		g_bPyro[client] = false;
		g_bShake[client] = false;
		g_bShielded[client] = false;
		g_bShove[client] = false;
		g_bSpam[client] = false;
		g_bStun[client] = false;
		g_bVision[client] = false;
		g_bWarp[client] = false;
		g_iAlpha[client] = 255;
		g_iSpawnInterval[client] = 0;
		g_iTankType[client] = 0;
	}
}

void vStunHit(int client, int owner, int enabled)
{
	int iStunChance = !g_bTankConfig[g_iTankType[owner]] ? g_iStunChance[g_iTankType[owner]] : g_iStunChance2[g_iTankType[owner]];
	if (enabled == 1 && GetRandomInt(1, iStunChance) == 1 && bIsSurvivor(client))
	{
		if (!g_bStun[client])
		{
			g_bStun[client] = true;
			float flStunSpeed = !g_bTankConfig[g_iTankType[owner]] ? g_flStunSpeed[g_iTankType[owner]] : g_flStunSpeed2[g_iTankType[owner]];
			SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", flStunSpeed);
			float flStunDuration = !g_bTankConfig[g_iTankType[owner]] ? g_flStunDuration[g_iTankType[owner]] : g_flStunDuration2[g_iTankType[owner]];
			CreateTimer(flStunDuration, tTimerStopStun, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
		}
	}
}

void vTankCountCheck(int client, int wave)
{
	int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
	if (iGetTankCount() < wave)
	{
		CreateTimer(5.0, tTimerSpawnTanks, wave, TIMER_FLAG_NO_MAPCHANGE);
	}
	else if (iGetTankCount() > wave && bIsTank(client) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(client))))
	{
		vKickFakeClient(client);
	}
}

void vThrowInterval(int client, float time)
{
	int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
	if (bIsTank(client) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(client))))
	{
		int iAbility = GetEntPropEnt(client, Prop_Send, "m_customAbility");
		if (iAbility > 0)
		{
			SetEntPropFloat(iAbility, Prop_Send, "m_duration", time);
			SetEntPropFloat(iAbility, Prop_Send, "m_timestamp", GetGameTime() + time);
		}
	}
}

void vVampireHit(int client, int enabled)
{
	int iVampireChance = !g_bTankConfig[g_iTankType[client]] ? g_iVampireChance[g_iTankType[client]] : g_iVampireChance2[g_iTankType[client]];
	if (enabled == 1 && GetRandomInt(1, iVampireChance) == 1 && bIsTank(client))
	{
		int iHealth = GetClientHealth(client);
		int iExtraHealth = !g_bTankConfig[g_iTankType[client]] ? (iHealth + g_iVampireHealth[g_iTankType[client]]) : (iHealth + g_iVampireHealth2[g_iTankType[client]]);
		SetEntityHealth(client, (iExtraHealth > 62400) ? 62400 : iExtraHealth);
	}
}

void vVisualHit(int client, int owner, int enabled)
{
	int iVisionChance = !g_bTankConfig[g_iTankType[owner]] ? g_iVisionChance[g_iTankType[owner]] : g_iVisionChance2[g_iTankType[owner]];
	if (enabled == 1 && GetRandomInt(1, iVisionChance) == 1 && bIsSurvivor(client))
	{
		if (!g_bVision[client])
		{
			g_bVision[client] = true;
			DataPack dpDataPack;
			CreateDataTimer(0.1, tTimerVision, dpDataPack, TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
			dpDataPack.WriteCell(GetClientUserId(client));
			dpDataPack.WriteCell(GetClientUserId(owner));
			dpDataPack.WriteFloat(GetEngineTime());
		}
	}
}

void vWarpAbility(int client, int enabled)
{
	int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
	if (enabled == 1 && bIsTank(client) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(client))))
	{
		if (!g_bWarp[client])
		{
			g_bWarp[client] = true;
			float flWarpInterval = !g_bTankConfig[g_iTankType[client]] ? g_flWarpInterval[g_iTankType[client]] : g_flWarpInterval2[g_iTankType[client]];
			CreateTimer(flWarpInterval, tTimerWarp, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
		}
	}
}

void vWitchAbility(int client, int enabled)
{
	int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
	if (enabled == 1 && bIsTank(client) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(client))))
	{
		int iWitchCount;
		int iEntity = -1;
		while ((iEntity = FindEntityByClassname(iEntity, "infected")) != INVALID_ENT_REFERENCE)
		{
			int iWitchAmount = !g_bTankConfig[g_iTankType[client]] ? g_iWitchAmount[g_iTankType[client]] : g_iWitchAmount2[g_iTankType[client]];
			if (iWitchCount < 4 && iGetWitchCount() < iWitchAmount)
			{
				float flTankPos[3];
				float flInfectedPos[3];
				float flInfectedAng[3];
				GetClientAbsOrigin(client, flTankPos);
				GetEntPropVector(iEntity, Prop_Send, "m_vecOrigin", flInfectedPos);
				GetEntPropVector(iEntity, Prop_Send, "m_angRotation", flInfectedAng);
				float flDistance = GetVectorDistance(flInfectedPos, flTankPos);
				if (flDistance < 100.0)
				{
					RemoveEntity(iEntity);
					int iWitch = CreateEntityByName("witch");
					if (IsValidEntity(iWitch))
					{
						TeleportEntity(iWitch, flInfectedPos, flInfectedAng, NULL_VECTOR);
						DispatchSpawn(iWitch);
						ActivateEntity(iWitch);
						SetEntProp(iWitch, Prop_Send, "m_hOwnerEntity", client);
					}
					iWitchCount++;
				}
			}
		}
	}
}

public void vSTGameDifficultyCvar(ConVar convar, const char[] oldValue, const char[] newValue)
{
	if (StrContains(g_sConfigExecute, "1") != -1)
	{
		char sDifficultyConfig[512];
		g_cvSTFindConVar[0].GetString(sDifficultyConfig, sizeof(sDifficultyConfig));
		Format(sDifficultyConfig, sizeof(sDifficultyConfig), "cfg/sourcemod/super_tanks++/difficulty_configs/%s.cfg", sDifficultyConfig);
		vLoadConfigs(sDifficultyConfig);
	}
}

public Action tTimerStopBlindness(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client == 0 || !IsClientInGame(client) || !IsPlayerAlive(client))
	{
		return Plugin_Stop;
	}
	if (bIsSurvivor(client))
	{
		g_bBlind[client] = false;
		vApplyBlindness(client, 0, g_umFadeUserMsgId);
	}
	return Plugin_Continue;
}

public Action tTimerBloodEffect(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	char sEffect[8];
	sEffect = !g_bTankConfig[g_iTankType[client]] ? g_sParticleEffects[g_iTankType[client]] : g_sParticleEffects2[g_iTankType[client]];
	if (StrContains(sEffect, "1") == -1 || client == 0 || !IsClientInGame(client) || !IsPlayerAlive(client))
	{
		return Plugin_Stop;
	}
	int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
	if (bIsTank(client) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(client))))
	{
		vAttachParticle(client, PARTICLE_BLOOD, 0.75, 30.0);
	}
	return Plugin_Continue;
}

public Action tTimerStopBury(Handle timer, DataPack pack)
{
	pack.Reset();
	int iSurvivor = GetClientOfUserId(pack.ReadCell());
	int iTank = GetClientOfUserId(pack.ReadCell());
	int iBuryHit = !g_bTankConfig[g_iTankType[iTank]] ? g_iBuryHit[g_iTankType[iTank]] : g_iBuryHit2[g_iTankType[iTank]];
	if (iBuryHit == 0 || iTank == 0 || iSurvivor == 0 || !IsClientInGame(iTank) || !IsClientInGame(iSurvivor) || !IsPlayerAlive(iTank) || !IsPlayerAlive(iSurvivor))
	{
		return Plugin_Stop;
	}
	if (bIsSurvivor(iSurvivor))
	{
		g_bBury[iSurvivor] = false;
		float flOrigin[3];
		float flBuryHeight = !g_bTankConfig[g_iTankType[iTank]] ? g_flBuryHeight[g_iTankType[iTank]] : g_flBuryHeight2[g_iTankType[iTank]];
		GetEntPropVector(iSurvivor, Prop_Send, "m_vecOrigin", flOrigin);
		flOrigin[2] = flOrigin[2] + flBuryHeight;
		SetEntPropVector(iSurvivor, Prop_Send, "m_vecOrigin", flOrigin);
		vWarpPlayer(iSurvivor, true);
		if (bIsPlayerIncapacitated(iSurvivor))
		{
			SDKCall(g_hSDKRevivePlayer, iSurvivor);
		}
		if (GetEntityMoveType(iSurvivor) == MOVETYPE_NONE)
		{
			SetEntityMoveType(iSurvivor, MOVETYPE_WALK);
		}
	}
	return Plugin_Continue;
}

public Action tTimerCarThrow(Handle timer, DataPack pack)
{
	pack.Reset();
	int iTank = GetClientOfUserId(pack.ReadCell());
	int iRock = EntRefToEntIndex(pack.ReadCell());
	int iCarThrow = !g_bTankConfig[g_iTankType[iTank]] ? g_iCarThrow[g_iTankType[iTank]] : g_iCarThrow2[g_iTankType[iTank]];
	if (iCarThrow == 0 || iTank == 0 || !IsClientInGame(iTank) || !IsPlayerAlive(iTank) || iRock == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}
	int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
	if (bIsTank(iTank) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(iTank))))
	{
		float flVelocity[3];
		if (IsValidEntity(iRock))
		{
			GetEntPropVector(iRock, Prop_Data, "m_vecVelocity", flVelocity);
			float flVector = GetVectorLength(flVelocity);
			if (flVector > 500.0)
			{
				int iCar = CreateEntityByName("prop_physics");
				if (IsValidEntity(iCar))
				{
					switch (GetRandomInt(1, 3))
					{
						case 1: SetEntityModel(iCar, MODEL_CAR);
						case 2: SetEntityModel(iCar, MODEL_CAR2);
						case 3: SetEntityModel(iCar, MODEL_CAR3);
					}
					int iRed = GetRandomInt(0, 255);
					int iGreen = GetRandomInt(0, 255);
					int iBlue = GetRandomInt(0, 255);
					SetEntityRenderColor(iCar, iRed, iGreen, iBlue, 255);
					float flPos[3];
					GetEntPropVector(iRock, Prop_Send, "m_vecOrigin", flPos);
					RemoveEntity(iRock);
					NormalizeVector(flVelocity, flVelocity);
					float flSpeed = g_cvSTFindConVar[11].FloatValue;
					ScaleVector(flVelocity, flSpeed * 1.4);
					DispatchSpawn(iCar);
					TeleportEntity(iCar, flPos, NULL_VECTOR, flVelocity);
					iCar = EntIndexToEntRef(iCar);
					vDeleteEntity(iCar, 10.0);
				}
				return Plugin_Stop;
			}
		}
	}
	return Plugin_Continue;
}

public Action tTimerDrug(Handle timer, DataPack pack)
{
	pack.Reset();
	int iSurvivor = GetClientOfUserId(pack.ReadCell());
	int iTank = GetClientOfUserId(pack.ReadCell());
	float flTime = pack.ReadFloat();
	int iDrugHit = !g_bTankConfig[g_iTankType[iTank]] ? g_iDrugHit[g_iTankType[iTank]] : g_iDrugHit2[g_iTankType[iTank]];
	float flDrugDuration = !g_bTankConfig[g_iTankType[iTank]] ? g_flDrugDuration[g_iTankType[iTank]] : g_flDrugDuration2[g_iTankType[iTank]];
	if (iDrugHit == 0 || iTank == 0 || iSurvivor == 0 || !IsClientInGame(iTank) || !IsClientInGame(iSurvivor) || !IsPlayerAlive(iTank) || !IsPlayerAlive(iSurvivor) || (flTime + flDrugDuration) < GetEngineTime())
	{
		if (bIsSurvivor(iSurvivor))
		{
			vApplyDrug(iSurvivor, false, g_umFadeUserMsgId, g_flDrugAngles);
		}
		g_bDrug[iSurvivor] = false;
		return Plugin_Stop;
	}
	if (bIsSurvivor(iSurvivor))
	{
		vApplyDrug(iSurvivor, true, g_umFadeUserMsgId, g_flDrugAngles);
	}
	return Plugin_Handled;
}

public Action tTimerElectricEffect(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	char sEffect[8];
	sEffect = !g_bTankConfig[g_iTankType[client]] ? g_sParticleEffects[g_iTankType[client]] : g_sParticleEffects2[g_iTankType[client]];
	if (StrContains(sEffect, "2") == -1 || client == 0 || !IsClientInGame(client) || !IsPlayerAlive(client))
	{
		return Plugin_Stop;
	}
	int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
	if (bIsTank(client) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(client))))
	{
		vAttachParticle(client, PARTICLE_ELECTRICITY, 0.75, 30.0);
	}
	return Plugin_Continue;
}

public Action tTimerFireEffect(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	char sEffect[8];
	sEffect = !g_bTankConfig[g_iTankType[client]] ? g_sParticleEffects[g_iTankType[client]] : g_sParticleEffects2[g_iTankType[client]];
	if (StrContains(sEffect, "3") == -1 || client == 0 || !IsClientInGame(client) || !IsPlayerAlive(client))
	{
		return Plugin_Stop;
	}
	int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
	if (bIsTank(client) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(client))))
	{
		vAttachParticle(client, PARTICLE_FIRE, 0.75, 0.0);
	}
	return Plugin_Continue;
}

public Action tTimerFlashEffect(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	int iFlashAbility = !g_bTankConfig[g_iTankType[client]] ? g_iFlashAbility[g_iTankType[client]] : g_iFlashAbility2[g_iTankType[client]];
	if (iFlashAbility == 0 || client == 0 || !IsClientInGame(client) || !IsPlayerAlive(client))
	{
		g_bFlash[client] = false;
		return Plugin_Stop;
	}
	int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
	if (bIsTank(client) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(client))))
	{
		char sSet[2][16];
		!g_bTankConfig[g_iTankType[client]] ? ExplodeString(g_sTankColors[g_iTankType[client]], "|", sSet, sizeof(sSet), sizeof(sSet[])) : ExplodeString(g_sTankColors2[g_iTankType[client]], "|", sSet, sizeof(sSet), sizeof(sSet[]));
		char sRGB[4][4];
		ExplodeString(sSet[0], ",", sRGB, sizeof(sRGB), sizeof(sRGB[]));
		int iRed = StringToInt(sRGB[0]);
		int iGreen = StringToInt(sRGB[1]);
		int iBlue = StringToInt(sRGB[2]);
		float flTankPos[3];
		float flTankAng[3];
		GetClientAbsOrigin(client, flTankPos);
		GetClientAbsAngles(client, flTankAng);
		int iAnim = GetEntProp(client, Prop_Send, "m_nSequence");
		int iEntity = CreateEntityByName("prop_dynamic");
		if (IsValidEntity(iEntity))
		{
			SetEntityModel(iEntity, MODEL_TANK);
			SetEntPropEnt(iEntity, Prop_Send, "m_hOwnerEntity", client);
			DispatchKeyValue(iEntity, "solid", "6");
			TeleportEntity(iEntity, flTankPos, flTankAng, NULL_VECTOR);
			DispatchSpawn(iEntity);
			AcceptEntityInput(iEntity, "DisableCollision");
			SetEntityRenderColor(iEntity, iRed, iGreen, iBlue, g_iAlpha[client]);
			SetEntProp(iEntity, Prop_Send, "m_nSequence", iAnim);
			SetEntPropFloat(iEntity, Prop_Send, "m_flPlaybackRate", 5.0);
			iEntity = EntIndexToEntRef(iEntity);
			vDeleteEntity(iEntity, 0.3);
		}
	}
	return Plugin_Continue;
}

public Action tTimerGhost(Handle timer, DataPack pack)
{
	pack.Reset();
	int iTank = GetClientOfUserId(pack.ReadCell());
	int iRed = pack.ReadCell();
	int iGreen = pack.ReadCell();
	int iBlue = pack.ReadCell();
	int iRed2 = pack.ReadCell();
	int iGreen2 = pack.ReadCell();
	int iBlue2 = pack.ReadCell();
	int iRed3 = pack.ReadCell();
	int iGreen3 = pack.ReadCell();
	int iBlue3 = pack.ReadCell();
	int iRed4 = pack.ReadCell();
	int iGreen4 = pack.ReadCell();
	int iBlue4 = pack.ReadCell();
	int iRed5 = pack.ReadCell();
	int iGreen5 = pack.ReadCell();
	int iBlue5 = pack.ReadCell();
	int iRed6 = pack.ReadCell();
	int iGreen6 = pack.ReadCell();
	int iBlue6 = pack.ReadCell();
	int iGhostAbility = !g_bTankConfig[g_iTankType[iTank]] ? g_iGhostAbility[g_iTankType[iTank]] : g_iGhostAbility2[g_iTankType[iTank]];
	if (iGhostAbility == 0 || iTank == 0 || !IsClientInGame(iTank) || !IsPlayerAlive(iTank))
	{
		g_bGhost[iTank] = false;
		return Plugin_Stop;
	}
	int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
	if (bIsTank(iTank) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(iTank))))
	{
		g_iAlpha[iTank] -= 2;
		int iGhostFade = !g_bTankConfig[g_iTankType[iTank]] ? g_iGhostFade[g_iTankType[iTank]] : g_iGhostFade2[g_iTankType[iTank]];
		if (g_iAlpha[iTank] < iGhostFade)
		{
			g_iAlpha[iTank] = iGhostFade;
		}
		int iEntity = -1;
		while ((iEntity = FindEntityByClassname(iEntity, "prop_dynamic")) != INVALID_ENT_REFERENCE)
		{
			char sModel[128];
			GetEntPropString(iEntity, Prop_Data, "m_ModelName", sModel, sizeof(sModel));
			if (strcmp(sModel, MODEL_JETPACK) == 0 || strcmp(sModel, MODEL_CONCRETE) == 0 || strcmp(sModel, MODEL_TIRES) == 0 || strcmp(sModel, MODEL_TANK) == 0)
			{
				int iOwner = GetEntPropEnt(iEntity, Prop_Send, "m_hOwnerEntity");
				if (iOwner == iTank)
				{
					if (strcmp(sModel, MODEL_JETPACK) == 0)
					{
						SetEntityRenderMode(iEntity, RENDER_TRANSCOLOR);
						SetEntityRenderColor(iEntity, iRed4, iGreen4, iBlue4, g_iAlpha[iTank]);
					}
					if (strcmp(sModel, MODEL_CONCRETE) == 0)
					{
						SetEntityRenderMode(iEntity, RENDER_TRANSCOLOR);
						SetEntityRenderColor(iEntity, iRed5, iGreen5, iBlue5, g_iAlpha[iTank]);
					}
					if (strcmp(sModel, MODEL_TIRES) == 0)
					{
						SetEntityRenderMode(iEntity, RENDER_TRANSCOLOR);
						SetEntityRenderColor(iEntity, iRed6, iGreen6, iBlue6, g_iAlpha[iTank]);
					}
					if (strcmp(sModel, MODEL_TANK) == 0)
					{
						SetEntityRenderMode(iEntity, RENDER_TRANSCOLOR);
						SetEntityRenderColor(iEntity, iRed, iGreen, iBlue, g_iAlpha[iTank]);
					}
				}
			}
		}
		while ((iEntity = FindEntityByClassname(iEntity, "beam_spotlight")) != INVALID_ENT_REFERENCE)
		{
			int iOwner = GetEntPropEnt(iEntity, Prop_Send, "m_hOwnerEntity");
			if (iOwner == iTank)
			{
				SetEntityRenderMode(iEntity, RENDER_TRANSCOLOR);
				SetEntityRenderColor(iEntity, iRed2, iGreen2, iBlue2, g_iAlpha[iTank]);
			}
		}
		while ((iEntity = FindEntityByClassname(iEntity, "env_steam")) != INVALID_ENT_REFERENCE)
		{
			int iOwner = GetEntPropEnt(iEntity, Prop_Send, "m_hOwnerEntity");
			if (iOwner == iTank)
			{
				SetEntityRenderMode(iEntity, RENDER_TRANSCOLOR);
				SetEntityRenderColor(iEntity, iRed3, iGreen3, iBlue3, g_iAlpha[iTank]);
			}
		}
		SetEntityRenderMode(iTank, RENDER_TRANSCOLOR);
		SetEntityRenderColor(iTank, iRed, iGreen, iBlue, g_iAlpha[iTank]);
	}
	return Plugin_Continue;
}

public Action tTimerStopGravity(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client == 0 || !IsClientInGame(client) || !IsPlayerAlive(client))
	{
		return Plugin_Stop;
	}
	if (bIsSurvivor(client))
	{
		g_bGravity2[client] = false;
		SetEntityGravity(client, 1.0);
	}
	return Plugin_Continue;
}

public Action tTimerHeal(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	int iHealAbility = !g_bTankConfig[g_iTankType[client]] ? g_iHealAbility[g_iTankType[client]] : g_iHealAbility2[g_iTankType[client]];
	if (iHealAbility == 0 || client == 0 || !IsClientInGame(client) || !IsPlayerAlive(client))
	{
		g_bHeal[client] = false;
		return Plugin_Stop;
	}
	int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
	if (bIsTank(client) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(client))))
	{
		int iType;
		int iEntity = -1;
		while ((iEntity = FindEntityByClassname(iEntity, "infected")) != INVALID_ENT_REFERENCE)
		{
			float flTankPos[3];
			float flInfectedPos[3];
			GetClientAbsOrigin(client, flTankPos);
			GetEntPropVector(iEntity, Prop_Send, "m_vecOrigin", flInfectedPos);
			float flDistance = GetVectorDistance(flInfectedPos, flTankPos);
			if (flDistance < 500.0)
			{
				int iHealth = GetClientHealth(client);
				int iExtraHealth = !g_bTankConfig[g_iTankType[client]] ? (iHealth + g_iHealCommon[g_iTankType[client]]) : (iHealth + g_iHealCommon2[g_iTankType[client]]);
				if (iHealth > 500)
				{
					SetEntityHealth(client, (iExtraHealth > 62400) ? 62400 : iExtraHealth);
					if (bIsL4D2Game())
					{
						SetEntProp(client, Prop_Send, "m_iGlowType", 3);
						SetEntProp(client, Prop_Send, "m_glowColorOverride", iGetRGBColor(0, 185, 0));
						SetEntProp(client, Prop_Send, "m_bFlashing", 1);
					}
					iType = 1;
				}
			}
		}
		for (int iInfected = 1; iInfected <= MaxClients; iInfected++)
		{
			if (bIsSpecialInfected(iInfected))
			{
				float flTankPos[3];
				float flInfectedPos[3];
				GetClientAbsOrigin(client, flTankPos);
				GetClientAbsOrigin(iInfected, flInfectedPos);
				float flDistance = GetVectorDistance(flTankPos, flInfectedPos);
				if (flDistance < 500.0)
				{
					int iHealth = GetClientHealth(client);
					int iExtraHealth = !g_bTankConfig[g_iTankType[client]] ? (iHealth + g_iHealSpecial[g_iTankType[client]]) : (iHealth + g_iHealSpecial2[g_iTankType[client]]);
					if (iHealth > 500)
					{
						SetEntityHealth(client, (iExtraHealth > 62400) ? 62400 : iExtraHealth);
						if (iType < 2 && bIsL4D2Game())
						{
							SetEntProp(client, Prop_Send, "m_iGlowType", 3);
							SetEntProp(client, Prop_Send, "m_glowColorOverride", iGetRGBColor(0, 220, 0));
							SetEntProp(client, Prop_Send, "m_bFlashing", 1);
							iType = 1;
						}
					}
				}
			}
			else if (bIsTank(iInfected) && iInfected != client)
			{
				float flTankPos[3];
				float flInfectedPos[3];
				GetClientAbsOrigin(client, flTankPos);
				GetClientAbsOrigin(iInfected, flInfectedPos);
				float flDistance = GetVectorDistance(flTankPos, flInfectedPos);
				if (flDistance < 500.0)
				{
					int iHealth = GetClientHealth(client);
					int iExtraHealth = !g_bTankConfig[g_iTankType[client]] ? (iHealth + g_iHealTank[g_iTankType[client]]) : (iHealth + g_iHealTank2[g_iTankType[client]]);
					if (iHealth > 500)
					{
						SetEntityHealth(client, (iExtraHealth > 62400) ? 62400 : iExtraHealth);
						if (bIsL4D2Game())
						{
							SetEntProp(client, Prop_Send, "m_iGlowType", 3);
							SetEntProp(client, Prop_Send, "m_glowColorOverride", iGetRGBColor(0, 255, 0));
							SetEntProp(client, Prop_Send, "m_bFlashing", 1);
							iType = 2;
						}
					}
				}
			}
		}
		if (iType == 0 && bIsL4D2Game())
		{
			char sSet[2][16];
			!g_bTankConfig[g_iTankType[client]] ? ExplodeString(g_sTankColors[g_iTankType[client]], "|", sSet, sizeof(sSet), sizeof(sSet[])) : ExplodeString(g_sTankColors2[g_iTankType[client]], "|", sSet, sizeof(sSet), sizeof(sSet[]));
			char sGlow[3][4];
			ExplodeString(sSet[1], ",", sGlow, sizeof(sGlow), sizeof(sGlow[]));
			int iRed = StringToInt(sGlow[0]);
			int iGreen = StringToInt(sGlow[1]);
			int iBlue = StringToInt(sGlow[2]);
			SetEntProp(client, Prop_Send, "m_iGlowType", 3);
			SetEntProp(client, Prop_Send, "m_glowColorOverride", iGetRGBColor(iRed, iGreen, iBlue));
			SetEntProp(client, Prop_Send, "m_bFlashing", 0);
		}
	}
	return Plugin_Continue;
}

public Action tTimerHurt(Handle timer, DataPack pack)
{
	pack.Reset();
	int iSurvivor = GetClientOfUserId(pack.ReadCell());
	int iTank = GetClientOfUserId(pack.ReadCell());
	float flTime = pack.ReadFloat();
	int iHurtAbility = !g_bTankConfig[g_iTankType[iTank]] ? g_iHurtAbility[g_iTankType[iTank]] : g_iHurtAbility2[g_iTankType[iTank]];
	float flHurtDuration = !g_bTankConfig[g_iTankType[iTank]] ? g_flHurtDuration[g_iTankType[iTank]] : g_flHurtDuration2[g_iTankType[iTank]];
	if (iHurtAbility == 0 || iTank == 0 || iSurvivor == 0 || !IsClientInGame(iTank) || !IsClientInGame(iSurvivor) || !IsPlayerAlive(iTank) || !IsPlayerAlive(iSurvivor) || (flTime + flHurtDuration) < GetEngineTime())
	{
		g_bHurt[iSurvivor] = false;
		return Plugin_Stop;
	}
	int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
	if (bIsTank(iTank) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(iTank))) && bIsSurvivor(iSurvivor))
	{
		char sDamage[16];
		!g_bTankConfig[g_iTankType[iTank]] ? IntToString(g_iHurtDamage[g_iTankType[iTank]], sDamage, sizeof(sDamage)) : IntToString(g_iHurtDamage2[g_iTankType[iTank]], sDamage, sizeof(sDamage));
		int iPointHurt = CreateEntityByName("point_hurt");
		if (IsValidEntity(iPointHurt))
		{
			DispatchKeyValue(iSurvivor, "targetname", "hurtme");
			DispatchKeyValue(iPointHurt, "Damage", sDamage);
			DispatchKeyValue(iPointHurt, "DamageTarget", "hurtme");
			DispatchKeyValue(iPointHurt, "DamageType", "2");
			DispatchSpawn(iPointHurt);
			AcceptEntityInput(iPointHurt, "Hurt", iTank);
			RemoveEntity(iPointHurt);
			DispatchKeyValue(iSurvivor, "targetname", "donthurtme");
		}
	}
	return Plugin_Continue;
}

public Action tTimerStopHypnosis(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client == 0 || !IsClientInGame(client) || !IsPlayerAlive(client))
	{
		return Plugin_Stop;
	}
	if (bIsSurvivor(client))
	{
		g_bHypno[client] = false;
	}
	return Plugin_Continue;
}

public Action tTimerIceEffect(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	char sEffect[8];
	sEffect = !g_bTankConfig[g_iTankType[client]] ? g_sParticleEffects[g_iTankType[client]] : g_sParticleEffects2[g_iTankType[client]];
	if (StrContains(sEffect, "4") == -1 || client == 0 || !IsClientInGame(client) || !IsPlayerAlive(client))
	{
		return Plugin_Stop;
	}
	int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
	if (bIsTank(client) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(client))))
	{
		vAttachParticle(client, PARTICLE_ICE, 2.0, 30.0);
	}
	return Plugin_Continue;
}

public Action tTimerStopIce(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client == 0 || !IsClientInGame(client) || !IsPlayerAlive(client))
	{
		return Plugin_Stop;
	}
	if (bIsSurvivor(client))
	{
		g_bIce[client] = false;
		float flPos[3];
		GetClientEyePosition(client, flPos);
		if (GetEntityMoveType(client) == MOVETYPE_NONE)
		{
			SetEntityMoveType(client, MOVETYPE_WALK);
			SetEntityRenderColor(client, 255, 255, 255, 255);
			EmitAmbientSound(SOUND_BULLET, flPos, client, SNDLEVEL_RAIDSIREN);
		}
	}
	return Plugin_Continue;
}

public Action tTimerIdleFix(Handle timer, DataPack pack)
{
	pack.Reset();
	int iSurvivor = GetClientOfUserId(pack.ReadCell());
	int iBot = GetClientOfUserId(pack.ReadCell());
	if (iSurvivor == 0 || iBot == 0 || !IsClientInGame(iSurvivor) || !IsPlayerAlive(iSurvivor) || !IsClientInGame(iBot) || !IsPlayerAlive(iSurvivor))
	{
		return Plugin_Stop;
	}
	if (GetClientTeam(iSurvivor) != 1 || iGetIdleBot(iSurvivor) || IsFakeClient(iSurvivor))
	{
		g_bAFK[iSurvivor] = false;
	}
	if (!bIsBotIdleSurvivor(iBot) || GetClientTeam(iBot) != 2)
	{
		iBot = iGetBotSurvivor();
	}
	if (iBot < 1)
	{
		g_bAFK[iSurvivor] = false;
	}
	if (g_bAFK[iSurvivor])
	{
		g_bAFK[iSurvivor] = false;
		SDKCall(g_hSDKSpecPlayer, iBot, iSurvivor);
		SetEntProp(iSurvivor, Prop_Send, "m_iObserverMode", 5);
	}
	return Plugin_Continue;
}

public Action tTimerInfectedThrow(Handle timer, DataPack pack)
{
	pack.Reset();
	int iTank = GetClientOfUserId(pack.ReadCell());
	int iRock = EntRefToEntIndex(pack.ReadCell());
	int iInfectedThrow = !g_bTankConfig[g_iTankType[iTank]] ? g_iInfectedThrow[g_iTankType[iTank]] : g_iInfectedThrow2[g_iTankType[iTank]];
	if (iInfectedThrow == 0 || iTank == 0 || !IsClientInGame(iTank) || !IsPlayerAlive(iTank) || iRock == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}
	int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
	if (bIsTank(iTank) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(iTank))))
	{
		float flVelocity[3];
		if (IsValidEntity(iRock))
		{
			GetEntPropVector(iRock, Prop_Data, "m_vecVelocity", flVelocity);
			float flVector = GetVectorLength(flVelocity);
			if (flVector > 500.0)
			{
				int iInfected = CreateFakeClient("Infected");
				if (iInfected > 0)
				{
					char sNumbers = !g_bTankConfig[g_iTankType[iTank]] ? g_sInfectedOptions[g_iTankType[iTank]][GetRandomInt(0, strlen(g_sInfectedOptions[g_iTankType[iTank]]) - 1)] : g_sInfectedOptions2[g_iTankType[iTank]][GetRandomInt(0, strlen(g_sInfectedOptions2[g_iTankType[iTank]]) - 1)];
					switch (sNumbers)
					{
						case '1': vSpawnInfected(iInfected, "smoker", false);
						case '2': vSpawnInfected(iInfected, "boomer", false);
						case '3': vSpawnInfected(iInfected, "hunter", false);
						case '4': bIsL4D2Game() ? vSpawnInfected(iInfected, "spitter", false) : vSpawnInfected(iInfected, "boomer", false);
						case '5': bIsL4D2Game() ? vSpawnInfected(iInfected, "jockey", false) : vSpawnInfected(iInfected, "hunter", false);
						case '6': bIsL4D2Game() ? vSpawnInfected(iInfected, "charger", false) : vSpawnInfected(iInfected, "smoker", false);
						case '7': vSpawnInfected(iInfected, "tank", false);
					}
					float flPos[3];
					GetEntPropVector(iRock, Prop_Send, "m_vecOrigin", flPos);
					RemoveEntity(iRock);
					NormalizeVector(flVelocity, flVelocity);
					float flSpeed = g_cvSTFindConVar[11].FloatValue;
					ScaleVector(flVelocity, flSpeed * 1.4);
					TeleportEntity(iInfected, flPos, NULL_VECTOR, flVelocity);
				}
				return Plugin_Stop;
			}
		}
	}
	return Plugin_Continue;
}

public Action tTimerStopInversion(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client == 0 || !IsClientInGame(client) || !IsPlayerAlive(client))
	{
		return Plugin_Stop;
	}
	if (bIsSurvivor(client))
	{
		g_bInvert[client] = false;
	}
	return Plugin_Continue;
}

public Action tTimerJump(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	int iJumperAbility = !g_bTankConfig[g_iTankType[client]] ? g_iJumperAbility[g_iTankType[client]] : g_iJumperAbility2[g_iTankType[client]];
	if (iJumperAbility == 0 || client == 0 || !IsClientInGame(client) || !IsPlayerAlive(client))
	{
		return Plugin_Stop;
	}
	int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
	int iJumperChance = !g_bTankConfig[g_iTankType[client]] ? g_iJumperChance[g_iTankType[client]] : g_iJumperChance2[g_iTankType[client]];
	if (GetRandomInt(1, iJumperChance) == 1 && bIsTank(client) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(client))))
	{
		if (iGetNearestSurvivor(client) > 200 && iGetNearestSurvivor(client) < 2000)
		{
			float flVelocity[3];
			GetEntPropVector(client, Prop_Data, "m_vecVelocity", flVelocity);
			if (flVelocity[0] > 0.0 && flVelocity[0] < 500.0)
			{
				flVelocity[0] += 500.0;
			}
			else if (flVelocity[0] < 0.0 && flVelocity[0] > -500.0)
			{
				flVelocity[0] += -500.0;
			}
			if (flVelocity[1] > 0.0 && flVelocity[1] < 500.0)
			{
				flVelocity[1] += 500.0;
			}
			else if (flVelocity[1] < 0.0 && flVelocity[1] > -500.0)
			{
				flVelocity[1] += -500.0;
			}
			flVelocity[2] += 750.0;
			TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, flVelocity);
		}
	}
	return Plugin_Continue;
}

public Action tTimerMeteorEffect(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	char sEffect[8];
	sEffect = !g_bTankConfig[g_iTankType[client]] ? g_sParticleEffects[g_iTankType[client]] : g_sParticleEffects2[g_iTankType[client]];
	if (StrContains(sEffect, "5") == -1 || client == 0 || !IsClientInGame(client) || !IsPlayerAlive(client))
	{
		return Plugin_Stop;
	}
	int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
	if (bIsTank(client) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(client))))
	{
		vAttachParticle(client, PARTICLE_METEOR, 6.0, 30.0);
	}
	return Plugin_Continue;
}

public Action tTimerMeteorEffectUpdate(Handle timer, DataPack pack)
{
	pack.Reset();
	float flPos[3];
	int iTank = GetClientOfUserId(pack.ReadCell());
	flPos[0] = pack.ReadFloat();
	flPos[1] = pack.ReadFloat();
	flPos[2] = pack.ReadFloat();
	float flTime = pack.ReadFloat();
	int iMeteorAbility = !g_bTankConfig[g_iTankType[iTank]] ? g_iMeteorAbility[g_iTankType[iTank]] : g_iMeteorAbility2[g_iTankType[iTank]];
	if (iMeteorAbility == 0 || iTank == 0 || !IsClientInGame(iTank) || !IsPlayerAlive(iTank))
	{
		g_bMeteor[iTank] = false;
		return Plugin_Stop;
	}
	int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
	if (bIsTank(iTank) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(iTank))))
	{
		if ((GetEngineTime() - flTime) > 5.0)
		{
			g_bMeteor[iTank] = false;
		}
		int iEntity = -1;
		if (g_bMeteor[iTank])
		{
			float flAngle[3];
			float flVelocity[3];
			float flHitpos[3];
			flAngle[0] = 0.0 + GetRandomFloat(-20.0, 20.0);
			flAngle[1] = 0.0 + GetRandomFloat(-20.0, 20.0);
			flAngle[2] = 60.0;
			GetVectorAngles(flAngle, flAngle);
			iGetRayHitPos(flPos, flAngle, flHitpos, iTank, true);
			float flDistance = GetVectorDistance(flPos, flHitpos);
			if (GetVectorDistance(flPos, flHitpos) > 2000.0)
			{
				flDistance = 1600.0;
			}
			float flVector[3];
			MakeVectorFromPoints(flPos, flHitpos, flVector);
			NormalizeVector(flVector, flVector);
			ScaleVector(flVector, flDistance - 40.0);
			AddVectors(flPos, flVector, flHitpos);
			if (flDistance > 100.0)
			{
				int iRock = CreateEntityByName("tank_rock");
				if (iRock > 0)
				{
					SetEntityModel(iRock, MODEL_CONCRETE);
					float flAngle2[3];
					flAngle2[0] = GetRandomFloat(-180.0, 180.0);
					flAngle2[1] = GetRandomFloat(-180.0, 180.0);
					flAngle2[2] = GetRandomFloat(-180.0, 180.0);
					flVelocity[0] = GetRandomFloat(0.0, 350.0);
					flVelocity[1] = GetRandomFloat(0.0, 350.0);
					flVelocity[2] = GetRandomFloat(0.0, 30.0);
					TeleportEntity(iRock, flHitpos, flAngle2, flVelocity);
					DispatchSpawn(iRock);
					ActivateEntity(iRock);
					AcceptEntityInput(iRock, "Ignite");
					SetEntPropEnt(iRock, Prop_Send, "m_hOwnerEntity", iTank);
				}
			}
		}
		else if (!g_bMeteor[iTank])
		{
			while ((iEntity = FindEntityByClassname(iEntity, "tank_rock")) != INVALID_ENT_REFERENCE)
			{
				int iOwner = GetEntPropEnt(iEntity, Prop_Send, "m_hOwnerEntity");
				if (iTank == iOwner)
				{
					vMeteor(iEntity, iOwner);
				}
			}
			return Plugin_Stop;
		}
		while ((iEntity = FindEntityByClassname(iEntity, "tank_rock")) != INVALID_ENT_REFERENCE)
		{
			int iOwner = GetEntPropEnt(iEntity, Prop_Send, "m_hOwnerEntity");
			if (iTank == iOwner)
			{
				if (flGetGroundUnits(iEntity) < 200.0)
				{
					vMeteor(iEntity, iOwner);
				}
			}
		}
	}
	return Plugin_Continue;
}

public Action tTimerStopNullify(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client == 0 || !IsClientInGame(client) || !IsPlayerAlive(client))
	{
		return Plugin_Stop;
	}
	if (bIsSurvivor(client))
	{
		g_bNullify[client] = false;
	}
	return Plugin_Continue;
}

public Action tTimerRestartCoordinates(Handle timer)
{
	for (int iSurvivor = 1; iSurvivor <= MaxClients; iSurvivor++)
	{
		if (bIsSurvivor(iSurvivor))
		{
			g_bRestartValid = true;
			g_flSpawnPosition[0] = 0.0;
			g_flSpawnPosition[1] = 0.0;
			g_flSpawnPosition[2] = 0.0;
			GetClientAbsOrigin(iSurvivor, g_flSpawnPosition);
			break;
		}
	}
}

public Action tTimerRocketLaunch(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client == 0 || !IsClientInGame(client) || !IsPlayerAlive(client))
	{
		return Plugin_Stop;
	}
	if (bIsSurvivor(client))
	{
		float flVelocity[3];
		flVelocity[0] = 0.0;
		flVelocity[1] = 0.0;
		flVelocity[2] = 800.0;
		EmitSoundToAll(SOUND_EXPLOSION, client, _, _, _, 1.0);
		EmitSoundToAll(SOUND_LAUNCH, client, _, _, _, 1.0);
		TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, flVelocity);
		SetEntityGravity(client, 0.1);
	}
	return Plugin_Handled;
}

public Action tTimerRocketDetonate(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client == 0 || !IsClientInGame(client) || !IsPlayerAlive(client))
	{
		return Plugin_Stop;
	}
	if (bIsSurvivor(client))
	{
		float flPosition[3];
		GetClientAbsOrigin(client, flPosition);
		TE_SetupExplosion(flPosition, g_iExplosionSprite, 10.0, 1, 0, 600, 5000);
		TE_SendToAll();
		g_iRocket[client] = 0;
		ForcePlayerSuicide(client);
		SetEntityGravity(client, 1.0);
	}
	return Plugin_Handled;
}

public Action tTimerSelfThrow(Handle timer, DataPack pack)
{
	pack.Reset();
	int iTank = GetClientOfUserId(pack.ReadCell());
	int iRock = EntRefToEntIndex(pack.ReadCell());
	int iSelfThrow = !g_bTankConfig[g_iTankType[iTank]] ? g_iSelfThrow[g_iTankType[iTank]] : g_iSelfThrow2[g_iTankType[iTank]];
	if (iSelfThrow == 0 || iTank == 0 || !IsClientInGame(iTank) || !IsPlayerAlive(iTank) || iRock == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}
	int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
	if (bIsTank(iTank) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(iTank))))
	{
		float flVelocity[3];
		if (IsValidEntity(iRock))
		{
			GetEntPropVector(iRock, Prop_Data, "m_vecVelocity", flVelocity);
			float flVector = GetVectorLength(flVelocity);
			if (flVector > 500.0)
			{
				float flPos[3];
				GetEntPropVector(iRock, Prop_Send, "m_vecOrigin", flPos);
				RemoveEntity(iRock);
				NormalizeVector(flVelocity, flVelocity);
				float flSpeed = g_cvSTFindConVar[11].FloatValue;
				ScaleVector(flVelocity, flSpeed * 1.4);
				TeleportEntity(iTank, flPos, NULL_VECTOR, flVelocity);
				return Plugin_Stop;
			}
		}
	}
	return Plugin_Continue;
}

public Action tTimerShake(Handle timer, DataPack pack)
{
	pack.Reset();
	int iSurvivor = GetClientOfUserId(pack.ReadCell());
	int iTank = GetClientOfUserId(pack.ReadCell());
	float flTime = pack.ReadFloat();
	int iShakeHit = !g_bTankConfig[g_iTankType[iTank]] ? g_iShakeHit[g_iTankType[iTank]] : g_iShakeHit2[g_iTankType[iTank]];
	float flShakeDuration = !g_bTankConfig[g_iTankType[iTank]] ? g_flShakeDuration[g_iTankType[iTank]] : g_flShakeDuration2[g_iTankType[iTank]];
	if (iShakeHit == 0 || iTank == 0 || iSurvivor == 0 || !IsClientInGame(iTank) || !IsClientInGame(iSurvivor) || !IsPlayerAlive(iTank) || !IsPlayerAlive(iSurvivor) || (flTime + flShakeDuration) < GetEngineTime())
	{
		g_bShake[iSurvivor] = false;
		return Plugin_Stop;
	}
	if (bIsSurvivor(iSurvivor))
	{
		Handle hShakeTarget = StartMessageOne("Shake", iSurvivor);
		if (hShakeTarget != null)
		{
			BfWrite bfWrite = UserMessageToBfWrite(hShakeTarget);
			bfWrite.WriteByte(0);
			bfWrite.WriteFloat(16.0);
			bfWrite.WriteFloat(0.5);
			bfWrite.WriteFloat(5.0);
			EndMessage();
		}
	}
	return Plugin_Continue;
}

public Action tTimerShield(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	int iShieldAbility = !g_bTankConfig[g_iTankType[client]] ? g_iShieldAbility[g_iTankType[client]] : g_iShieldAbility2[g_iTankType[client]];
	if (iShieldAbility == 0 || client == 0 || !IsClientInGame(client) || !IsPlayerAlive(client))
	{
		return Plugin_Stop;
	}
	int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
	if (bIsTank(client) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(client))) && !g_bShielded[client])
	{
		vShieldAbility(client, true, iShieldAbility);
	}
	return Plugin_Continue;
}

public Action tTimerPropaneThrow(Handle timer, DataPack pack)
{
	pack.Reset();
	int iTank = GetClientOfUserId(pack.ReadCell());
	int iRock = EntRefToEntIndex(pack.ReadCell());
	int iShieldAbility = !g_bTankConfig[g_iTankType[iTank]] ? g_iShieldAbility[g_iTankType[iTank]] : g_iShieldAbility2[g_iTankType[iTank]];
	if (iShieldAbility == 0 || iTank == 0 || !IsClientInGame(iTank) || !IsPlayerAlive(iTank) || iRock == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}
	int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
	if (bIsTank(iTank) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(iTank))))
	{
		float flVelocity[3];
		if (IsValidEntity(iRock))
		{
			GetEntPropVector(iRock, Prop_Data, "m_vecVelocity", flVelocity);
			float flVector = GetVectorLength(flVelocity);
			if (flVector > 500.0)
			{
				int iPropane = CreateEntityByName("prop_physics");
				if (IsValidEntity(iPropane))
				{
					SetEntityModel(iPropane, MODEL_PROPANETANK);
					float flPos[3];
					GetEntPropVector(iRock, Prop_Send, "m_vecOrigin", flPos);
					RemoveEntity(iRock);
					NormalizeVector(flVelocity, flVelocity);
					float flSpeed = g_cvSTFindConVar[11].FloatValue;
					ScaleVector(flVelocity, flSpeed * 1.4);
					DispatchSpawn(iPropane);
					TeleportEntity(iPropane, flPos, NULL_VECTOR, flVelocity);
				}
				return Plugin_Stop;
			}
		}
	}
	return Plugin_Continue;
}

public Action tTimerPyro(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	int iPyroAbility = !g_bTankConfig[g_iTankType[client]] ? g_iPyroAbility[g_iTankType[client]] : g_iPyroAbility2[g_iTankType[client]];
	if (iPyroAbility == 0 || client == 0 || !IsClientInGame(client) || !IsPlayerAlive(client))
	{
		g_bPyro[client] = false;
		return Plugin_Stop;
	}
	int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
	if (bIsTank(client) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(client))))
	{
		float flPyroBoost = !g_bTankConfig[g_iTankType[client]] ? g_flPyroBoost[g_iTankType[client]] : g_flPyroBoost2[g_iTankType[client]];
		if (bIsPlayerFired(client) && !g_bPyro[client])
		{
			g_bPyro[client] = true;
			float flCurrentSpeed = GetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue");
			SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", flCurrentSpeed + flPyroBoost);
		}
		else if (g_bPyro[client])
		{
			g_bPyro[client] = false;
			float flCurrentSpeed = GetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue");
			SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", flCurrentSpeed - flPyroBoost);
		}
	}
	return Plugin_Continue;
}

public Action tTimerShove(Handle timer, DataPack pack)
{
	pack.Reset();
	int iSurvivor = GetClientOfUserId(pack.ReadCell());
	int iTank = GetClientOfUserId(pack.ReadCell());
	float flTime = pack.ReadFloat();
	int iShoveHit = !g_bTankConfig[g_iTankType[iTank]] ? g_iShoveHit[g_iTankType[iTank]] : g_iShoveHit2[g_iTankType[iTank]];
	float flShoveDuration = !g_bTankConfig[g_iTankType[iTank]] ? g_flShoveDuration[g_iTankType[iTank]] : g_flShoveDuration2[g_iTankType[iTank]];
	if (iShoveHit == 0 || iTank == 0 || iSurvivor == 0 || !IsClientInGame(iTank) || !IsClientInGame(iSurvivor) || !IsPlayerAlive(iTank) || !IsPlayerAlive(iSurvivor) || (flTime + flShoveDuration) < GetEngineTime())
	{
		g_bShove[iSurvivor] = false;
		return Plugin_Stop;
	}
	if (bIsSurvivor(iSurvivor))
	{
		float flOrigin[3];
		GetClientAbsOrigin(iSurvivor, flOrigin);
		SDKCall(g_hSDKShovePlayer, iSurvivor, iSurvivor, flOrigin);
	}
	return Plugin_Continue;
}

public Action tTimerSmokeEffect(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	char sEffect[8];
	sEffect = !g_bTankConfig[g_iTankType[client]] ? g_sParticleEffects[g_iTankType[client]] : g_sParticleEffects2[g_iTankType[client]];
	if (StrContains(sEffect, "6") == -1 || client == 0 || !IsClientInGame(client) || !IsPlayerAlive(client))
	{
		return Plugin_Stop;
	}
	int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
	if (bIsTank(client) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(client))))
	{
		vAttachParticle(client, PARTICLE_SMOKE, 1.5, 0.0);
	}
	return Plugin_Continue;
}

public Action tTimerSpam(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	int iSpamAbility = !g_bTankConfig[g_iTankType[client]] ? g_iSpamAbility[g_iTankType[client]] : g_iSpamAbility2[g_iTankType[client]];
	if (iSpamAbility == 0 || client == 0 || !IsClientInGame(client) || !IsPlayerAlive(client))
	{
		g_bSpam[client] = false;
		return Plugin_Stop;
	}
	int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
	if (bIsTank(client) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(client))))
	{
		CreateTimer(0.5, tTimerSpamThrow, userid, TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
	}
	return Plugin_Continue;
}

public Action tTimerSpamThrow(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	int iSpamAbility = !g_bTankConfig[g_iTankType[client]] ? g_iSpamAbility[g_iTankType[client]] : g_iSpamAbility2[g_iTankType[client]];
	int iSpamAmount = !g_bTankConfig[g_iTankType[client]] ? g_iSpamAmount[g_iTankType[client]] : g_iSpamAmount2[g_iTankType[client]];
	if (iSpamAbility == 0 || g_iSpamCount[client] >= iSpamAmount || client == 0 || !IsClientInGame(client) || !IsPlayerAlive(client))
	{
		g_iSpamCount[client] = 0;
		return Plugin_Stop;
	}
	int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
	if (bIsTank(client) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(client))))
	{
		if (g_iSpamCount[client] < iSpamAmount)
		{
			char sDamage[6];
			!g_bTankConfig[g_iTankType[client]] ? IntToString(g_iSpamDamage[g_iTankType[client]], sDamage, sizeof(sDamage)) : IntToString(g_iSpamDamage2[g_iTankType[client]], sDamage, sizeof(sDamage));
			float flPos[3];
			float flAng[3];
			GetClientEyePosition(client, flPos);
			GetClientEyeAngles(client, flAng);
			flPos[2] += 80.0;
			int iSpammer = CreateEntityByName("env_rock_launcher");
			if (IsValidEntity(iSpammer))
			{
				DispatchKeyValue(iSpammer, "rockdamageoverride", sDamage);
				TeleportEntity(iSpammer, flPos, flAng, NULL_VECTOR);
				DispatchSpawn(iSpammer);
				AcceptEntityInput(iSpammer, "LaunchRock");
				RemoveEntity(iSpammer);
				g_iSpamCount[client]++;
			}
		}
	}
	return Plugin_Continue;
}

public Action tTimerSpitEffect(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	char sEffect[8];
	sEffect = !g_bTankConfig[g_iTankType[client]] ? g_sParticleEffects[g_iTankType[client]] : g_sParticleEffects2[g_iTankType[client]];
	if (StrContains(sEffect, "7") == -1 || client == 0 || !IsClientInGame(client) || !IsPlayerAlive(client))
	{
		return Plugin_Stop;
	}
	int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
	if (bIsTank(client) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(client))))
	{
		vAttachParticle(client, PARTICLE_SPIT, 2.0, 30.0);
	}
	return Plugin_Continue;
}

public Action tTimerStopStun(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client == 0 || !IsClientInGame(client) || !IsPlayerAlive(client))
	{
		return Plugin_Stop;
	}
	if (bIsSurvivor(client))
	{
		g_bStun[client] = false;
		SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", 1.0);
	}
	return Plugin_Continue;
}

public Action tTimerVision(Handle timer, DataPack pack)
{
	pack.Reset();
	int iSurvivor = GetClientOfUserId(pack.ReadCell());
	int iTank = GetClientOfUserId(pack.ReadCell());
	float flTime = pack.ReadFloat();
	int iVisionHit = !g_bTankConfig[g_iTankType[iTank]] ? g_iVisionHit[g_iTankType[iTank]] : g_iVisionHit2[g_iTankType[iTank]];
	float flVisionDuration = !g_bTankConfig[g_iTankType[iTank]] ? g_flVisionDuration[g_iTankType[iTank]] : g_flVisionDuration2[g_iTankType[iTank]];
	if (iVisionHit == 0 || iTank == 0 || iSurvivor == 0 || !IsClientInGame(iTank) || !IsClientInGame(iSurvivor) || !IsPlayerAlive(iTank) || !IsPlayerAlive(iSurvivor) || (flTime + flVisionDuration) < GetEngineTime())
	{
		g_bVision[iSurvivor] = false;
		return Plugin_Stop;
	}
	if (bIsSurvivor(iSurvivor))
	{
		int iFov = !g_bTankConfig[g_iTankType[iSurvivor]] ? g_iVisionFOV[g_iTankType[iSurvivor]] : g_iVisionFOV2[g_iTankType[iSurvivor]];
		SetEntProp(iSurvivor, Prop_Send, "m_iFOV", iFov);
		SetEntProp(iSurvivor, Prop_Send, "m_iDefaultFOV", iFov);
	}
	return Plugin_Continue;
}

public Action tTimerWarp(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	int iWarpAbility = !g_bTankConfig[g_iTankType[client]] ? g_iWarpAbility[g_iTankType[client]] : g_iWarpAbility2[g_iTankType[client]];
	if (iWarpAbility == 0 || client == 0 || !IsClientInGame(client) || !IsPlayerAlive(client))
	{
		return Plugin_Stop;
	}
	int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
	if (bIsTank(client) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(client))))
	{
		vWarpPlayer(client, false, true);
	}
	return Plugin_Continue;
}

public Action tTimerSetTransmit(Handle timer, any entity)
{
	if ((entity = EntRefToEntIndex(entity)) == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}
	if (IsValidEntity(entity))
	{
		SDKHook(entity, SDKHook_SetTransmit, SetTransmit);
	}
	return Plugin_Continue;
}

public Action tTimerUpdatePlayerCount(Handle timer)
{
	int iEnable = !g_bGeneralConfig ? g_iPluginEnabled : g_iPluginEnabled2;
	if (iEnable == 0 || !bIsSystemValid(g_cvSTFindConVar[1], g_sEnabledGameModes, g_sDisabledGameModes) || StrContains(g_sConfigExecute, "5") == -1)
	{
		return Plugin_Continue;
	}
	char sCountConfig[512];
	Format(sCountConfig, sizeof(sCountConfig), "cfg/sourcemod/super_tanks++/playercount_configs/%d.cfg", iGetPlayerCount());
	vLoadConfigs(sCountConfig);
	return Plugin_Continue;
}

public Action tTimerTankHealthUpdate(Handle timer)
{
	int iEnable = !g_bGeneralConfig ? g_iPluginEnabled : g_iPluginEnabled2;
	if (iEnable == 0 || !bIsSystemValid(g_cvSTFindConVar[1], g_sEnabledGameModes, g_sDisabledGameModes))
	{
		return Plugin_Continue;
	}
	int iDisplayHealth = !g_bGeneralConfig ? g_iDisplayHealth : g_iDisplayHealth2;
	if (iDisplayHealth > 0)
	{
		for (int iSurvivor = 1; iSurvivor <= MaxClients; iSurvivor++)
		{
			if (bIsHumanSurvivor(iSurvivor))
			{
				int iTarget = GetClientAimTarget(iSurvivor, false);
				if (IsValidEntity(iTarget))
				{
					char sClassname[32];
					GetEntityClassname(iTarget, sClassname, sizeof(sClassname));
					if (strcmp(sClassname, "player") == 0)
					{
						int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
						if (bIsTank(iTarget) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(iTarget))))
						{
							int iHealth = GetClientHealth(iTarget);
							int iDisplay = !g_bGeneralConfig ? g_iDisplayHealth : g_iDisplayHealth2;
							switch (iDisplay)
							{
								case 1: PrintHintText(iSurvivor, "%s %N", ST_PREFIX, iTarget);
								case 2: PrintHintText(iSurvivor, "%s %d HP", ST_PREFIX, iHealth);
								case 3: PrintHintText(iSurvivor, "%s %N (%d HP)", ST_PREFIX, iTarget, iHealth);
							}
						}
					}
				}
			}
		}
	}
	return Plugin_Continue;
}

public Action tTimerTankTypeUpdate(Handle timer)
{
	int iEnable = !g_bGeneralConfig ? g_iPluginEnabled : g_iPluginEnabled2;
	if (iEnable == 0 || !bIsSystemValid(g_cvSTFindConVar[1], g_sEnabledGameModes, g_sDisabledGameModes))
	{
		return Plugin_Continue;
	}
	g_cvSTFindConVar[10].SetString("32");
	if (iGetTankCount() > 0)
	{
		for (int iTank = 1; iTank <= MaxClients; iTank++)
		{
			int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
			if (bIsTank(iTank) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(iTank))))
			{
				int iCommonAbility = !g_bTankConfig[g_iTankType[iTank]] ? g_iCommonAbility[g_iTankType[iTank]] : g_iCommonAbility2[g_iTankType[iTank]];
				int iFlashAbility = !g_bTankConfig[g_iTankType[iTank]] ? g_iFlashAbility[g_iTankType[iTank]] : g_iFlashAbility2[g_iTankType[iTank]];
				int iGhostAbility = !g_bTankConfig[g_iTankType[iTank]] ? g_iGhostAbility[g_iTankType[iTank]] : g_iGhostAbility2[g_iTankType[iTank]];
				int iGravityAbility = !g_bTankConfig[g_iTankType[iTank]] ? g_iGravityAbility[g_iTankType[iTank]] : g_iGravityAbility2[g_iTankType[iTank]];
				int iHealAbility = !g_bTankConfig[g_iTankType[iTank]] ? g_iHealAbility[g_iTankType[iTank]] : g_iHealAbility2[g_iTankType[iTank]];
				int iMeteorAbility = !g_bTankConfig[g_iTankType[iTank]] ? g_iMeteorAbility[g_iTankType[iTank]] : g_iMeteorAbility2[g_iTankType[iTank]];
				int iSpamAbility = !g_bTankConfig[g_iTankType[iTank]] ? g_iSpamAbility[g_iTankType[iTank]] : g_iSpamAbility2[g_iTankType[iTank]];
				int iWarpAbility = !g_bTankConfig[g_iTankType[iTank]] ? g_iWarpAbility[g_iTankType[iTank]] : g_iWarpAbility2[g_iTankType[iTank]];
				int iWitchAbility = !g_bTankConfig[g_iTankType[iTank]] ? g_iWitchAbility[g_iTankType[iTank]] : g_iWitchAbility2[g_iTankType[iTank]];
				vCommonAbility(iTank, iCommonAbility);
				vFlashAbility(iTank, iFlashAbility);
				vGhostAbility(iTank, iGhostAbility);
				vGravityAbility(iTank, iGravityAbility);
				vHealAbility(iTank, iHealAbility);
				vMeteorAbility(iTank, iMeteorAbility);
				vSpamAbility(iTank, iSpamAbility);
				vWarpAbility(iTank, iWarpAbility);
				vWitchAbility(iTank, iWitchAbility);
				int iFireImmunity = !g_bTankConfig[g_iTankType[iTank]] ? g_iFireImmunity[g_iTankType[iTank]] : g_iFireImmunity2[g_iTankType[iTank]];
				if (iFireImmunity == 1 && !g_bPyro[iTank] && bIsPlayerBurning(iTank))
				{
					ExtinguishEntity(iTank);
					SetEntPropFloat(iTank, Prop_Send, "m_burnPercent", 1.0);
				}
				float flRunSpeed = !g_bTankConfig[g_iTankType[iTank]] ? g_flRunSpeed[g_iTankType[iTank]] : g_flRunSpeed2[g_iTankType[iTank]];
				SetEntPropFloat(iTank, Prop_Send, "m_flLaggedMovementValue", flRunSpeed);
			}
		}
	}
	return Plugin_Continue;
}

public Action tTimerTankSpawn(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client == 0 || !IsClientInGame(client) || !IsPlayerAlive(client))
	{
		return Plugin_Stop;
	}
	int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
	if (bIsTank(client) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(client))))
	{
		int iJumperAbility = !g_bTankConfig[g_iTankType[client]] ? g_iJumperAbility[g_iTankType[client]] : g_iJumperAbility2[g_iTankType[client]];
		int iParticleEffect = !g_bTankConfig[g_iTankType[client]] ? g_iParticleEffect[g_iTankType[client]] : g_iParticleEffect2[g_iTankType[client]];
		vJumperAbility(client, iJumperAbility);
		vParticleEffects(client, iParticleEffect);
		if (!g_bShielded[client])
		{
			int iShieldAbility = !g_bTankConfig[g_iTankType[client]] ? g_iShieldAbility[g_iTankType[client]] : g_iShieldAbility2[g_iTankType[client]];
			vShieldAbility(client, true, iShieldAbility);
		}
		char sName[33];
		sName = !g_bTankConfig[g_iTankType[client]] ? g_sCustomName[g_iTankType[client]] : g_sCustomName2[g_iTankType[client]];
		vSetName(client, sName);
		int iHealth = GetClientHealth(client);
		int iMultiHealth = !g_bGeneralConfig ? g_iMultiHealth : g_iMultiHealth2;
		int iExtraHealth = !g_bTankConfig[g_iTankType[client]] ? g_iExtraHealth[g_iTankType[client]] : g_iExtraHealth2[g_iTankType[client]];
		int iExtraHealthNormal = !g_bTankConfig[g_iTankType[client]] ? (iHealth + g_iExtraHealth[g_iTankType[client]]) : (iHealth + g_iExtraHealth2[g_iTankType[client]]);
		int iExtraHealthBoost = (iGetHumanCount() > 1) ? ((iHealth * iGetHumanCount()) + iExtraHealth) : (iExtraHealthNormal);
		int iExtraHealthBoost2 = (iGetHumanCount() > 1) ? (iHealth + (iGetHumanCount() * iExtraHealth)) : (iExtraHealthNormal);
		int iExtraHealthBoost3 = (iGetHumanCount() > 1) ? (iGetHumanCount() * (iHealth + iExtraHealth)) : (iExtraHealthNormal);
		int iBoost = (iExtraHealthBoost > 62400) ? 62400 : iExtraHealthBoost;
		int iBoost2 = (iExtraHealthBoost2 > 62400) ? 62400 : iExtraHealthBoost2;
		int iBoost3 = (iExtraHealthBoost3 > 62400) ? 62400 : iExtraHealthBoost3;
		if (iMultiHealth == 0)
		{
			SetEntityHealth(client, iExtraHealthNormal);
		}
		else if (iMultiHealth == 1)
		{
			SetEntityHealth(client, iBoost);
		}
		else if (iMultiHealth == 2)
		{
			SetEntityHealth(client, iBoost2);
		}
		else if (iMultiHealth == 3)
		{
			SetEntityHealth(client, iBoost3);
		}
		float flThrowInterval = !g_bTankConfig[g_iTankType[client]] ? g_flThrowInterval[g_iTankType[client]] : g_flThrowInterval2[g_iTankType[client]];
		vThrowInterval(client, flThrowInterval);
		CreateTimer(1.0, tTimerPyro, userid, TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
	}
	return Plugin_Continue;
}

public Action tTimerRockThrow(Handle timer, any entity)
{
	if ((entity = EntRefToEntIndex(entity)) == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}
	int iThrower = GetEntPropEnt(entity, Prop_Data, "m_hThrower");
	int iHumanSupport = !g_bGeneralConfig ? g_iHumanSupport : g_iHumanSupport2;
	if (iThrower > 0 && bIsTank(iThrower) && (iHumanSupport == 1 || (iHumanSupport == 0 && IsFakeClient(iThrower))))
	{
		int iCarThrow = !g_bTankConfig[g_iTankType[iThrower]] ? g_iCarThrow[g_iTankType[iThrower]] : g_iCarThrow2[g_iTankType[iThrower]];
		if (iCarThrow == 1)
		{
			DataPack dpDataPack;
			CreateDataTimer(0.1, tTimerCarThrow, dpDataPack, TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
			dpDataPack.WriteCell(GetClientUserId(iThrower));
			dpDataPack.WriteCell(EntIndexToEntRef(entity));
		}
		int iInfectedThrow = !g_bTankConfig[g_iTankType[iThrower]] ? g_iInfectedThrow[g_iTankType[iThrower]] : g_iInfectedThrow2[g_iTankType[iThrower]];
		if (iInfectedThrow == 1)
		{
			DataPack dpDataPack;
			CreateDataTimer(0.1, tTimerInfectedThrow, dpDataPack, TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
			dpDataPack.WriteCell(GetClientUserId(iThrower));
			dpDataPack.WriteCell(EntIndexToEntRef(entity));
		}
		int iSelfThrow = !g_bTankConfig[g_iTankType[iThrower]] ? g_iSelfThrow[g_iTankType[iThrower]] : g_iSelfThrow2[g_iTankType[iThrower]];
		if (iSelfThrow == 1)
		{
			DataPack dpDataPack;
			CreateDataTimer(0.1, tTimerSelfThrow, dpDataPack, TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
			dpDataPack.WriteCell(GetClientUserId(iThrower));
			dpDataPack.WriteCell(EntIndexToEntRef(entity));
		}
		int iShieldAbility = !g_bTankConfig[g_iTankType[iThrower]] ? g_iShieldAbility[g_iTankType[iThrower]] : g_iShieldAbility2[g_iTankType[iThrower]];
		if (iShieldAbility == 1)
		{
			DataPack dpDataPack;
			CreateDataTimer(0.1, tTimerPropaneThrow, dpDataPack, TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
			dpDataPack.WriteCell(GetClientUserId(iThrower));
			dpDataPack.WriteCell(EntIndexToEntRef(entity));
		}
	}
	return Plugin_Continue;
}

public Action tTimerSpawnTanks(Handle timer, any wave)
{
	vSpawnTank(wave);
}

public Action tTimerTankWave(Handle timer, any wave)
{
	if (iGetTankCount() == 0)
	{
		switch (wave)
		{
			case 1: g_iTankWave = 2;
			case 2: g_iTankWave = 3;
		}
	}
}