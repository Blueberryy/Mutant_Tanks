/**
 * Mutant Tanks: a L4D/L4D2 SourceMod Plugin
 * Copyright (C) 2020  Alfred "Crasher_3637/Psyk0tik" Llagas
 *
 * This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **/

#include <sourcemod>
#include <sdkhooks>
#include <adminmenu>
#include <dhooks>
#include <mutant_tanks>

#undef REQUIRE_PLUGIN
#tryinclude <left4dhooks>
#define REQUIRE_PLUGIN

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo =
{
	name = "Mutant Tanks",
	author = MT_AUTHOR,
	description = "Mutant Tanks makes fighting Tanks great again!",
	version = MT_VERSION,
	url = MT_URL
};

bool g_bLateLoad;

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	if (!bIsValidGame(false) && !bIsValidGame())
	{
		strcopy(error, err_max, "\"Mutant Tanks\" only supports Left 4 Dead 1 & 2.");

		return APLRes_SilentFailure;
	}

	CreateNative("MT_CanTypeSpawn", aNative_CanTypeSpawn);
	CreateNative("MT_GetAccessFlags", aNative_GetAccessFlags);
	CreateNative("MT_GetCurrentFinaleWave", aNative_GetCurrentFinaleWave);
	CreateNative("MT_GetImmunityFlags", aNative_GetImmunityFlags);
	CreateNative("MT_GetMaxType", aNative_GetMaxType);
	CreateNative("MT_GetMinType", aNative_GetMinType);
	CreateNative("MT_GetPropColors", aNative_GetPropColors);
	CreateNative("MT_GetRunSpeed", aNative_GetRunSpeed);
	CreateNative("MT_GetTankColors", aNative_GetTankColors);
	CreateNative("MT_GetTankName", aNative_GetTankName);
	CreateNative("MT_GetTankType", aNative_GetTankType);
	CreateNative("MT_HasAdminAccess", aNative_HasAdminAccess);
	CreateNative("MT_HasChanceToSpawn", aNative_HasChanceToSpawn);
	CreateNative("MT_HideEntity", aNative_HideEntity);
	CreateNative("MT_IsAdminImmune", aNative_IsAdminImmune);
	CreateNative("MT_IsCorePluginEnabled", aNative_IsCorePluginEnabled);
	CreateNative("MT_IsFinaleType", aNative_IsFinaleType);
	CreateNative("MT_IsGlowEnabled", aNative_IsGlowEnabled);
	CreateNative("MT_IsNonFinaleType", aNative_IsNonFinaleType);
	CreateNative("MT_IsTankSupported", aNative_IsTankSupported);
	CreateNative("MT_IsTypeEnabled", aNative_IsTypeEnabled);
	CreateNative("MT_SetTankType", aNative_SetTankType);
	CreateNative("MT_SpawnTank", aNative_SpawnTank);

	RegPluginLibrary("mutant_tanks");

	g_bLateLoad = late;

	return APLRes_Success;
}

#define MODEL_CONCRETE_CHUNK "models/props_debris/concrete_chunk01a.mdl"
#define MODEL_JETPACK "models/props_equipment/oxygentank01.mdl"
#define MODEL_PROPANETANK "models/props_junk/propanecanister001a.mdl"
#define MODEL_TANK "models/infected/hulk.mdl"
#define MODEL_TIRES "models/props_vehicles/tire001c_car.mdl"
#define MODEL_TREE_TRUNK "models/props_foliage/tree_trunk.mdl"
#define MODEL_WITCH "models/infected/witch.mdl"
#define MODEL_WITCHBRIDE "models/infected/witch_bride.mdl"

#define PARTICLE_BLOOD "boomer_explode_D"
#define PARTICLE_ELECTRICITY "electrical_arc_01_parent"
#define PARTICLE_FIRE "aircraft_destroy_fastFireTrail"
#define PARTICLE_ICE "apc_wheel_smoke1"
#define PARTICLE_METEOR "smoke_medium_01"
#define PARTICLE_SMOKE "smoker_smokecloud"
#define PARTICLE_SPIT "spitter_projectile"

#define SOUND_ELECTRICITY "items/suitchargeok1.wav"
#define SOUND_SPIT "player/spitter/voice/warn/spitter_spit_02.wav"

#define MT_MAX_ABILITIES 100

#define MT_ARRIVAL_SPAWN (1 << 0) // announce spawn
#define MT_ARRIVAL_BOSS (1 << 1) // announce evolution
#define MT_ARRIVAL_RANDOM (1 << 2) // announce randomization
#define MT_ARRIVAL_TRANSFORM (1 << 3) // announce transformation
#define MT_ARRIVAL_REVERT (1 << 4) // announce revert

#define MT_CONFIG_DIFFICULTY (1 << 0) // difficulty_configs
#define MT_CONFIG_MAP (1 << 1) // l4d_map_configs/l4d2_map_configs
#define MT_CONFIG_GAMEMODE (1 << 2) // l4d_map_configs/l4d2_map_configs
#define MT_CONFIG_DAY (1 << 3) // daily_configs
#define MT_CONFIG_COUNT (1 << 4) // playercount_configs

#define MT_PARTICLE_BLOOD (1 << 0) // blood particle
#define MT_PARTICLE_ELECTRICITY (1 << 1) // electric particle
#define MT_PARTICLE_FIRE (1 << 2) // fire particle
#define MT_PARTICLE_ICE (1 << 3) // ice particle
#define MT_PARTICLE_METEOR (1 << 4) // meteor particle
#define MT_PARTICLE_SMOKE (1 << 5) // smoke particle
#define MT_PARTICLE_SPIT (1 << 6) // spit particle

#define MT_PROP_BLUR (1 << 0) // blur prop
#define MT_PROP_LIGHT (1 << 1) // light prop
#define MT_PROP_OXYGENTANK (1 << 2) // oxgyen tank prop
#define MT_PROP_FLAME (1 << 3) // flame prop
#define MT_PROP_ROCK (1 << 4) // rock prop
#define MT_PROP_TIRE (1 << 5) // tire prop
#define MT_PROP_PROPANETANK (1 << 6) // propane tank prop

#define MT_ROCK_BLOOD (1 << 0) // blood particle
#define MT_ROCK_ELECTRICITY (1 << 1) // electric particle
#define MT_ROCK_FIRE (1 << 2) // fire particle
#define MT_ROCK_SPIT (1 << 3) // spit particle

enum ConfigState
{
	ConfigState_None, // no section yet
	ConfigState_Start, // reached "Mutant Tanks" section
	ConfigState_Settings, // reached "Plugin Settings" section
	ConfigState_Type, // reached "Tank #" section
	ConfigState_Admin, // reached "STEAM_" or "[U:" section
	ConfigState_Specific // reached specific sections
};

enum struct esGeneral
{
	ArrayList g_alAbilitySections[4];
	ArrayList g_alAdmins;
	ArrayList g_alPlugins;

	bool g_bAbilityPlugin[MT_MAX_ABILITIES + 1];
	bool g_bPluginEnabled;
	bool g_bHideNameChange;
	bool g_bMapStarted;
	bool g_bSettingsFound;

	char g_sCurrentSection[128];
	char g_sCurrentSubSection[128];
	char g_sDisabledGameModes[513];
	char g_sEnabledGameModes[513];
	char g_sHealthCharacters[4];
	char g_sSavePath[PLATFORM_MAX_PATH];
	char g_sUsedPath[PLATFORM_MAX_PATH];

	ConfigState g_csState;

	ConVar g_cvMTEnabledGameModes;
	ConVar g_cvMTDifficulty;
	ConVar g_cvMTDisabledGameModes;
	ConVar g_cvMTGameMode;
	ConVar g_cvMTGameModeTypes;
	ConVar g_cvMTGameTypes;
	ConVar g_cvMTPluginEnabled;

	float g_flRegularInterval;

	GlobalForward g_gfAbilityActivatedForward;
	GlobalForward g_gfAbilityCheckForward;
	GlobalForward g_gfButtonPressedForward;
	GlobalForward g_gfButtonReleasedForward;
	GlobalForward g_gfChangeTypeForward;
	GlobalForward g_gfConfigsLoadForward;
	GlobalForward g_gfConfigsLoadedForward;
	GlobalForward g_gfDisplayMenuForward;
	GlobalForward g_gfEventFiredForward;
	GlobalForward g_gfHookEventForward;
	GlobalForward g_gfMenuItemSelectedForward;
	GlobalForward g_gfPluginCheckForward;
	GlobalForward g_gfPluginEndForward;
	GlobalForward g_gfPostTankSpawnForward;
	GlobalForward g_gfRockBreakForward;
	GlobalForward g_gfRockThrowForward;
	GlobalForward g_gfSettingsCachedForward;
	GlobalForward g_gfTypeChosenForward;

	Handle g_hLaunchDirectionDetour;
	Handle g_hTankRockDetour;

	int g_iAccessFlags;
	int g_iAllowDeveloper;
	int g_iAnnounceArrival;
	int g_iAnnounceDeath;
	int g_iBaseHealth;
	int g_iConfigCreate;
	int g_iConfigEnable;
	int g_iConfigExecute;
	int g_iConfigMode;
	int g_iCurrentMode;
	int g_iDeathRevert;
	int g_iDetectPlugins;
	int g_iDisplayHealth;
	int g_iDisplayHealthType;
	int g_iFileTimeOld[6];
	int g_iFileTimeNew[6];
	int g_iFinalesOnly;
	int g_iFinaleMaxTypes[3];
	int g_iFinaleMinTypes[3];
	int g_iFinaleWave[3];
	int g_iGameModeTypes;
	int g_iHumanCooldown;
	int g_iIgnoreLevel;
	int g_iImmunityFlags;
	int g_iLauncher;
	int g_iMasterControl;
	int g_iMaxType;
	int g_iMinType;
	int g_iMultiHealth;
	int g_iPlayerCount[2];
	int g_iPluginEnabled;
	int g_iRegularAmount;
	int g_iRegularCount;
	int g_iRegularLimit;
	int g_iRegularMaxType;
	int g_iRegularMinType;
	int g_iRegularMode;
	int g_iRegularWave;
	int g_iRenamePlayers;
	int g_iSpawnMode;
	int g_iTankWave;
	int g_iType;

	TopMenu g_tmMTMenu;
}

esGeneral g_esGeneral;

enum struct esAdmin
{
	int g_iAccessFlags[MAXPLAYERS + 1];
	int g_iImmunityFlags[MAXPLAYERS + 1];
}

esAdmin g_esAdmin[MT_MAXTYPES + 1];

enum struct esPlayer
{
	bool g_bAdminMenu;
	bool g_bBlood;
	bool g_bBlur;
	bool g_bBoss;
	bool g_bDied;
	bool g_bDying;
	bool g_bElectric;
	bool g_bFire;
	bool g_bIce;
	bool g_bKeepCurrentType;
	bool g_bMeteor;
	bool g_bNeedHealth;
	bool g_bRandomized;
	bool g_bSmoke;
	bool g_bSpit;
	bool g_bThirdPerson;
	bool g_bTransformed;
	bool g_bUsedParser;

	char g_sHealthCharacters[4];
	char g_sOriginalName[33];
	char g_sSection[128];
	char g_sTankName[33];

	ConfigState g_csState;

	float g_flClawDamage;
	float g_flPropsChance[7];
	float g_flRandomInterval;
	float g_flRockDamage;
	float g_flRunSpeed;
	float g_flThrowInterval;
	float g_flTransformDelay;
	float g_flTransformDuration;

	int g_iAccessFlags;
	int g_iAnnounceArrival;
	int g_iAnnounceDeath;
	int g_iBodyEffects;
	int g_iBossHealth[4];
	int g_iBossStageCount;
	int g_iBossStages;
	int g_iBossType[4];
	int g_iBulletImmunity;
	int g_iCooldown;
	int g_iDeathRevert;
	int g_iDetectPlugins;
	int g_iDisplayHealth;
	int g_iDisplayHealthType;
	int g_iExplosiveImmunity;
	int g_iExtraHealth;
	int g_iFavoriteType;
	int g_iFireImmunity;
	int g_iFlame[2];
	int g_iFlameColor[4];
	int g_iGlowColor[3];
	int g_iGlowEnabled;
	int g_iGlowFlashing;
	int g_iGlowMaxRange;
	int g_iGlowMinRange;
	int g_iGlowType;
	int g_iIgnoreLevel;
	int g_iImmunityFlags;
	int g_iLastButtons;
	int g_iLight[3];
	int g_iLightColor[4];
	int g_iMeleeImmunity;
	int g_iMultiHealth;
	int g_iOzTank[2];
	int g_iOzTankColor[4];
	int g_iPropsAttached;
	int g_iPropaneTank;
	int g_iPropTankColor[4];
	int g_iRandomTank;
	int g_iRenamePlayers;
	int g_iRock[20];
	int g_iRockColor[4];
	int g_iRockEffects;
	int g_iRockModel;
	int g_iSection;
	int g_iSkinColor[4];
	int g_iTankHealth;
	int g_iTankModel;
	int g_iTankNote;
	int g_iTankType;
	int g_iTire[2];
	int g_iTireColor[4];
	int g_iTransformType[10];
}

esPlayer g_esPlayer[MAXPLAYERS + 1];

enum struct esTank
{
	bool g_bAbilityFound[MT_MAX_ABILITIES + 1];

	char g_sHealthCharacters[4];
	char g_sTankName[33];

	float g_flClawDamage;
	float g_flPropsChance[7];
	float g_flRandomInterval;
	float g_flRockDamage;
	float g_flRunSpeed;
	float g_flTankChance;
	float g_flThrowInterval;
	float g_flTransformDelay;
	float g_flTransformDuration;

	int g_iAccessFlags;
	int g_iAnnounceArrival;
	int g_iAnnounceDeath;
	int g_iBodyEffects;
	int g_iBossHealth[4];
	int g_iBossStages;
	int g_iBossType[4];
	int g_iBulletImmunity;
	int g_iDeathRevert;
	int g_iDetectPlugins;
	int g_iDisplayHealth;
	int g_iDisplayHealthType;
	int g_iExplosiveImmunity;
	int g_iExtraHealth;
	int g_iFinaleTank;
	int g_iFireImmunity;
	int g_iFlameColor[4];
	int g_iGlowColor[3];
	int g_iGlowEnabled;
	int g_iGlowFlashing;
	int g_iGlowMaxRange;
	int g_iGlowMinRange;
	int g_iGlowType;
	int g_iHumanSupport;
	int g_iImmunityFlags;
	int g_iLightColor[4];
	int g_iMeleeImmunity;
	int g_iMenuEnabled;
	int g_iMultiHealth;
	int g_iOzTankColor[4];
	int g_iPropsAttached;
	int g_iPropTankColor[4];
	int g_iRandomTank;
	int g_iRenamePlayers;
	int g_iRockColor[4];
	int g_iRockEffects;
	int g_iRockModel;
	int g_iSkinColor[4];
	int g_iSpawnEnabled;
	int g_iSpawnMode;
	int g_iTankEnabled;
	int g_iTankNote;
	int g_iTireColor[4];
	int g_iTransformType[10];
	int g_iTypeLimit;
}

esTank g_esTank[MT_MAXTYPES + 1];

enum struct esCache
{
	char g_sHealthCharacters[4];
	char g_sTankName[33];

	float g_flClawDamage;
	float g_flPropsChance[7];
	float g_flRandomInterval;
	float g_flRockDamage;
	float g_flRunSpeed;
	float g_flThrowInterval;
	float g_flTransformDelay;
	float g_flTransformDuration;

	int g_iAnnounceArrival;
	int g_iAnnounceDeath;
	int g_iBodyEffects;
	int g_iBossHealth[4];
	int g_iBossStages;
	int g_iBossType[4];
	int g_iBulletImmunity;
	int g_iDeathRevert;
	int g_iDetectPlugins;
	int g_iDisplayHealth;
	int g_iDisplayHealthType;
	int g_iExplosiveImmunity;
	int g_iExtraHealth;
	int g_iFireImmunity;
	int g_iFlameColor[4];
	int g_iGlowColor[3];
	int g_iGlowEnabled;
	int g_iGlowFlashing;
	int g_iGlowMaxRange;
	int g_iGlowMinRange;
	int g_iGlowType;
	int g_iLightColor[4];
	int g_iMeleeImmunity;
	int g_iMultiHealth;
	int g_iOzTankColor[4];
	int g_iPropsAttached;
	int g_iPropTankColor[4];
	int g_iRandomTank;
	int g_iRenamePlayers;
	int g_iRockColor[4];
	int g_iRockEffects;
	int g_iRockModel;
	int g_iSkinColor[4];
	int g_iTankNote;
	int g_iTireColor[4];
	int g_iTransformType[10];
}

esCache g_esCache[MAXPLAYERS + 1];

public any aNative_CanTypeSpawn(Handle plugin, int numParams)
{
	int iType = GetNativeCell(1);
	return iType > 0 && g_esTank[iType].g_iSpawnEnabled == 1 && bCanTypeSpawn(iType);
}

public any aNative_GetAccessFlags(Handle plugin, int numParams)
{
	int iMode = GetNativeCell(1), iType = GetNativeCell(2), iAdmin = GetNativeCell(3);
	if (iMode > 0)
	{
		switch (iMode)
		{
			case 1: return g_esGeneral.g_iAccessFlags;
			case 2: return (iType > 0) ? g_esTank[iType].g_iAccessFlags : 0;
			case 3: return bIsValidClient(iAdmin, MT_CHECK_INDEX|MT_CHECK_INGAME|MT_CHECK_INKICKQUEUE|MT_CHECK_FAKECLIENT) ? g_esPlayer[iAdmin].g_iAccessFlags : 0;
			case 4: return (bIsValidClient(iAdmin, MT_CHECK_INDEX|MT_CHECK_INGAME|MT_CHECK_INKICKQUEUE|MT_CHECK_FAKECLIENT) && iType > 0) ? g_esAdmin[iType].g_iAccessFlags[iAdmin] : 0;
		}
	}

	return 0;
}

public any aNative_GetCurrentFinaleWave(Handle plugin, int numParams)
{
	return g_esGeneral.g_iTankWave;
}

public any aNative_GetImmunityFlags(Handle plugin, int numParams)
{
	int iMode = GetNativeCell(1), iType = GetNativeCell(2), iAdmin = GetNativeCell(3);
	if (iMode > 0)
	{
		switch (iMode)
		{
			case 1: return g_esGeneral.g_iImmunityFlags;
			case 2: return (iType > 0) ? g_esTank[iType].g_iImmunityFlags : 0;
			case 3: return bIsValidClient(iAdmin, MT_CHECK_INDEX|MT_CHECK_INGAME|MT_CHECK_INKICKQUEUE|MT_CHECK_FAKECLIENT) ? g_esPlayer[iAdmin].g_iImmunityFlags : 0;
			case 4: return (bIsValidClient(iAdmin, MT_CHECK_INDEX|MT_CHECK_INGAME|MT_CHECK_INKICKQUEUE|MT_CHECK_FAKECLIENT) && iType > 0) ? g_esAdmin[iType].g_iImmunityFlags[iAdmin] : 0;
		}
	}

	return 0;
}

public any aNative_GetMaxType(Handle plugin, int numParams)
{
	return g_esGeneral.g_iMaxType;
}

public any aNative_GetMinType(Handle plugin, int numParams)
{
	return g_esGeneral.g_iMinType;
}

public any aNative_GetPropColors(Handle plugin, int numParams)
{
	int iTank = GetNativeCell(1);
	if (bIsTank(iTank, MT_CHECK_INDEX|MT_CHECK_INGAME|MT_CHECK_INKICKQUEUE))
	{
		int iType = GetNativeCell(2), iColor[4];
		for (int iPos = 0; iPos < sizeof(iColor); iPos++)
		{
			switch (iType)
			{
				case 1: iColor[iPos] = g_esCache[iTank].g_iSkinColor[iPos];
				case 2: iColor[iPos] = g_esCache[iTank].g_iOzTankColor[iPos];
				case 3: iColor[iPos] = g_esCache[iTank].g_iFlameColor[iPos];
				case 4: iColor[iPos] = g_esCache[iTank].g_iRockColor[iPos];
				case 5: iColor[iPos] = g_esCache[iTank].g_iTireColor[iPos];
				case 6: iColor[iPos] = g_esCache[iTank].g_iPropTankColor[iPos];
			}

			SetNativeCellRef(iPos + 3, iColor[iPos]);
		}
	}
}

public any aNative_GetRunSpeed(Handle plugin, int numParams)
{
	int iTank = GetNativeCell(1);
	return (bIsTank(iTank, MT_CHECK_INDEX|MT_CHECK_INGAME|MT_CHECK_INKICKQUEUE) && g_esCache[iTank].g_flRunSpeed > 0.0) ? g_esCache[iTank].g_flRunSpeed : 1.0;
}

public any aNative_GetTankColors(Handle plugin, int numParams)
{
	int iTank = GetNativeCell(1);
	if (bIsTank(iTank, MT_CHECK_INDEX|MT_CHECK_INGAME|MT_CHECK_INKICKQUEUE))
	{
		int iType = GetNativeCell(2), iColor[4];
		for (int iPos = 0; iPos < sizeof(iColor); iPos++)
		{
			switch (iType)
			{
				case 1: iColor[iPos] = g_esCache[iTank].g_iSkinColor[iPos];
				case 2:
				{
					if (iPos < sizeof(esCache::g_iGlowColor))
					{
						iColor[iPos] = g_esCache[iTank].g_iGlowColor[iPos];
					}
				}
			}

			SetNativeCellRef(iPos + 3, iColor[iPos]);
		}
	}
}

public any aNative_GetTankName(Handle plugin, int numParams)
{
	int iTank = GetNativeCell(1);
	if (bIsTank(iTank, MT_CHECK_INDEX|MT_CHECK_INGAME|MT_CHECK_INKICKQUEUE))
	{
		SetNativeString(2, g_esCache[iTank].g_sTankName, sizeof(esCache::g_sTankName));
	}
}

public any aNative_GetTankType(Handle plugin, int numParams)
{
	int iTank = GetNativeCell(1);
	return bIsTank(iTank, MT_CHECK_INDEX|MT_CHECK_INGAME|MT_CHECK_INKICKQUEUE) ? g_esPlayer[iTank].g_iTankType : 0;
}

public any aNative_HasAdminAccess(Handle plugin, int numParams)
{
	int iAdmin = GetNativeCell(1);
	return bIsTank(iAdmin) && bHasCoreAdminAccess(iAdmin);
}

public any aNative_HasChanceToSpawn(Handle plugin, int numParams)
{
	int iType = GetNativeCell(1);
	return iType > 0 && bTankChance(iType);
}

public any aNative_HideEntity(Handle plugin, int numParams)
{
	int iEntity = GetNativeCell(1);
	bool bMode = GetNativeCell(2);
	if (bIsValidEntity(iEntity))
	{
		switch (bMode)
		{
			case true: SDKHook(iEntity, SDKHook_SetTransmit, SetTransmit);
			case false: SDKUnhook(iEntity, SDKHook_SetTransmit, SetTransmit);
		}
	}
}

public any aNative_IsAdminImmune(Handle plugin, int numParams)
{
	int iSurvivor = GetNativeCell(1), iTank = GetNativeCell(2);
	return bIsHumanSurvivor(iSurvivor) && bIsTank(iTank) && bIsCoreAdminImmune(iSurvivor, iTank);
}

public any aNative_IsCorePluginEnabled(Handle plugin, int numParams)
{
	return g_esGeneral.g_cvMTPluginEnabled.BoolValue && g_esGeneral.g_bPluginEnabled;
}

public any aNative_IsFinaleType(Handle plugin, int numParams)
{
	int iType = GetNativeCell(1);
	return iType > 0 && g_esTank[iType].g_iFinaleTank == 1;
}

public any aNative_IsGlowEnabled(Handle plugin, int numParams)
{
	int iTank = GetNativeCell(1);
	return bIsTank(iTank, MT_CHECK_INDEX|MT_CHECK_INGAME|MT_CHECK_INKICKQUEUE) && g_esCache[iTank].g_iGlowEnabled == 1;
}

public any aNative_IsNonFinaleType(Handle plugin, int numParams)
{
	int iType = GetNativeCell(1);
	return iType > 0 && g_esTank[iType].g_iFinaleTank == 2;
}

public any aNative_IsTankSupported(Handle plugin, int numParams)
{
	return bIsTankAllowed(GetNativeCell(1), GetNativeCell(2));
}

public any aNative_IsTypeEnabled(Handle plugin, int numParams)
{
	int iType = GetNativeCell(1);
	return iType > 0 && g_esTank[iType].g_iTankEnabled == 1 && bIsTypeAvailable(iType);
}

public any aNative_SetTankType(Handle plugin, int numParams)
{
	int iTank = GetNativeCell(1), iType = GetNativeCell(2);
	bool bMode = GetNativeCell(3);
	if (bIsTank(iTank, MT_CHECK_INDEX|MT_CHECK_INGAME|MT_CHECK_INKICKQUEUE))
	{
		switch (bMode)
		{
			case true:
			{
				vResetTank(iTank);
				vSetColor(iTank, iType);
				vTankSpawn(iTank, 5);
			}
			case false: g_esPlayer[iTank].g_iTankType = iType;
		}
	}
}

public any aNative_SpawnTank(Handle plugin, int numParams)
{
	int iTank = GetNativeCell(1), iType = GetNativeCell(2);
	if (bIsValidClient(iTank))
	{
		vQueueTank(iTank, iType);
	}
}

public void OnPluginStart()
{
	g_esGeneral.g_gfAbilityActivatedForward = new GlobalForward("MT_OnAbilityActivated", ET_Ignore, Param_Cell);
	g_esGeneral.g_gfAbilityCheckForward = new GlobalForward("MT_OnAbilityCheck", ET_Ignore, Param_Array, Param_Array, Param_Array, Param_Array);
	g_esGeneral.g_gfButtonPressedForward = new GlobalForward("MT_OnButtonPressed", ET_Ignore, Param_Cell, Param_Cell);
	g_esGeneral.g_gfButtonReleasedForward = new GlobalForward("MT_OnButtonReleased", ET_Ignore, Param_Cell, Param_Cell);
	g_esGeneral.g_gfChangeTypeForward = new GlobalForward("MT_OnChangeType", ET_Ignore, Param_Cell, Param_Cell);
	g_esGeneral.g_gfConfigsLoadForward = new GlobalForward("MT_OnConfigsLoad", ET_Ignore, Param_Cell);
	g_esGeneral.g_gfConfigsLoadedForward = new GlobalForward("MT_OnConfigsLoaded", ET_Ignore, Param_String, Param_String, Param_String, Param_Cell, Param_Cell, Param_Cell);
	g_esGeneral.g_gfDisplayMenuForward = new GlobalForward("MT_OnDisplayMenu", ET_Ignore, Param_Cell);
	g_esGeneral.g_gfEventFiredForward = new GlobalForward("MT_OnEventFired", ET_Ignore, Param_Cell, Param_String, Param_Cell);
	g_esGeneral.g_gfHookEventForward = new GlobalForward("MT_OnHookEvent", ET_Ignore, Param_Cell);
	g_esGeneral.g_gfMenuItemSelectedForward = new GlobalForward("MT_OnMenuItemSelected", ET_Ignore, Param_Cell, Param_String);
	g_esGeneral.g_gfPluginCheckForward = new GlobalForward("MT_OnPluginCheck", ET_Ignore, Param_Array);
	g_esGeneral.g_gfPluginEndForward = new GlobalForward("MT_OnPluginEnd", ET_Ignore);
	g_esGeneral.g_gfPostTankSpawnForward = new GlobalForward("MT_OnPostTankSpawn", ET_Ignore, Param_Cell);
	g_esGeneral.g_gfRockBreakForward = new GlobalForward("MT_OnRockBreak", ET_Ignore, Param_Cell, Param_Cell);
	g_esGeneral.g_gfRockThrowForward = new GlobalForward("MT_OnRockThrow", ET_Ignore, Param_Cell, Param_Cell);
	g_esGeneral.g_gfSettingsCachedForward = new GlobalForward("MT_OnSettingsCached", ET_Ignore, Param_Cell, Param_Cell, Param_Cell);
	g_esGeneral.g_gfTypeChosenForward = new GlobalForward("MT_OnTypeChosen", ET_Event, Param_CellByRef, Param_Cell);

	vMultiTargetFilters(1);

	LoadTranslations("common.phrases");
	LoadTranslations("mutant_tanks.phrases");

	RegConsoleCmd("sm_mt_config", cmdMTConfig, "View a section of the config file.");
	RegConsoleCmd("sm_mt_info", cmdMTInfo, "View information about Mutant Tanks.");
	RegConsoleCmd("sm_mt_list", cmdMTList, "View a list of installed abilities.");
	RegConsoleCmd("sm_mt_version", cmdMTVersion, "Find out the current version of Mutant Tanks.");
	RegAdminCmd("sm_tank", cmdTank, ADMFLAG_ROOT, "Spawn a Mutant Tank.");
	RegConsoleCmd("sm_tank2", cmdTank2, "Spawn a Mutant Tank.");
	RegConsoleCmd("sm_mutanttank", cmdMutantTank, "Choose a Mutant Tank.");

	g_esGeneral.g_cvMTDisabledGameModes = CreateConVar("mt_disabledgamemodes", "", "Disable Mutant Tanks in these game modes.\nSeparate by commas.\nEmpty: None\nNot empty: Disabled only in these game modes.");
	g_esGeneral.g_cvMTEnabledGameModes = CreateConVar("mt_enabledgamemodes", "", "Enable Mutant Tanks in these game modes.\nSeparate by commas.\nEmpty: All\nNot empty: Enabled only in these game modes.");
	g_esGeneral.g_cvMTGameModeTypes = CreateConVar("mt_gamemodetypes", "0", "Enable Mutant Tanks in these game mode types.\n0 OR 15: All game mode types.\n1: Co-Op modes only.\n2: Versus modes only.\n4: Survival modes only.\n8: Scavenge modes only. (Only available in Left 4 Dead 2.)", _, true, 0.0, true, 15.0);
	g_esGeneral.g_cvMTPluginEnabled = CreateConVar("mt_pluginenabled", "1", "Enable Mutant Tanks.\n0: OFF\n1: ON", _, true, 0.0, true, 1.0);
	CreateConVar("mt_pluginversion", MT_VERSION, "Mutant Tanks Version", FCVAR_NOTIFY|FCVAR_DONTRECORD);
	AutoExecConfig(true, "mutant_tanks");

	g_esGeneral.g_cvMTDifficulty = FindConVar("z_difficulty");
	g_esGeneral.g_cvMTGameMode = FindConVar("mp_gamemode");
	g_esGeneral.g_cvMTGameTypes = FindConVar("sv_gametypes");

	g_esGeneral.g_cvMTDisabledGameModes.AddChangeHook(vMTPluginStatusCvar);
	g_esGeneral.g_cvMTEnabledGameModes.AddChangeHook(vMTPluginStatusCvar);
	g_esGeneral.g_cvMTGameModeTypes.AddChangeHook(vMTPluginStatusCvar);

	g_esGeneral.g_cvMTDifficulty.AddChangeHook(vMTGameDifficultyCvar);

	char sSMPath[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, sSMPath, sizeof(sSMPath), "data/mutant_tanks/");
	CreateDirectory(sSMPath, 511);
	FormatEx(g_esGeneral.g_sSavePath, sizeof(esGeneral::g_sSavePath), "%smutant_tanks.cfg", sSMPath);
	vLoadConfigs(g_esGeneral.g_sSavePath, 1);
	g_esGeneral.g_iFileTimeOld[0] = GetFileTime(g_esGeneral.g_sSavePath, FileTime_LastChange);

	HookEvent("round_start", vEventHandler);

	TopMenu tmAdminMenu;
	if (LibraryExists("adminmenu") && ((tmAdminMenu = GetAdminTopMenu()) != null))
	{
		OnAdminMenuReady(tmAdminMenu);
	}

	HookUserMessage(GetUserMessageId("SayText2"), umNameChange, true);

	GameData gdMutantTanks = new GameData("mutant_tanks");

	switch (gdMutantTanks == null)
	{
		case true: LogError("Unable to load the \"mutant_tanks\" gamedata file.");
		case false:
		{
			g_esGeneral.g_hLaunchDirectionDetour = DHookCreateFromConf(gdMutantTanks, "CEnvRockLauncher::LaunchCurrentDir");
			if (g_esGeneral.g_hLaunchDirectionDetour == null)
			{
				LogError("Failed to find signature: CEnvRockLauncher::LaunchCurrentDir");
			}

			g_esGeneral.g_hTankRockDetour = DHookCreateFromConf(gdMutantTanks, "CTankRock::Create");
			if (g_esGeneral.g_hTankRockDetour == null)
			{
				LogError("Failed to find signature: CTankRock::Create");
			}

			delete gdMutantTanks;
		}
	}

	if (g_bLateLoad)
	{
		for (int iPlayer = 1; iPlayer <= MaxClients; iPlayer++)
		{
			if (bIsValidClient(iPlayer, MT_CHECK_INGAME|MT_CHECK_INKICKQUEUE))
			{
				OnClientPutInServer(iPlayer);
				OnClientPostAdminCheck(iPlayer);
			}
		}

		g_bLateLoad = false;
	}
}

public void OnMapStart()
{
	g_esGeneral.g_bMapStarted = true;

	PrecacheModel(MODEL_CONCRETE_CHUNK, true);
	PrecacheModel(MODEL_JETPACK, true);
	PrecacheModel(MODEL_PROPANETANK, true);
	PrecacheModel(MODEL_TIRES, true);
	PrecacheModel(MODEL_TREE_TRUNK, true);
	PrecacheModel(MODEL_WITCH, true);
	PrecacheModel(MODEL_WITCHBRIDE, true);

	vPrecacheParticle(PARTICLE_BLOOD);
	vPrecacheParticle(PARTICLE_ELECTRICITY);
	vPrecacheParticle(PARTICLE_FIRE);
	vPrecacheParticle(PARTICLE_ICE);
	vPrecacheParticle(PARTICLE_METEOR);
	vPrecacheParticle(PARTICLE_SMOKE);
	vPrecacheParticle(PARTICLE_SPIT);

	PrecacheSound(SOUND_ELECTRICITY, true);
	PrecacheSound(SOUND_SPIT, true);

	vReset();
}

public void OnClientPutInServer(int client)
{
	SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);

	vReset3(client);
	vCacheSettings(client);
	vResetCore(client);

	g_esGeneral.g_iPlayerCount[0] = iGetPlayerCount();
}

public void OnClientPostAdminCheck(int client)
{
	if (bIsValidClient(client, MT_CHECK_INDEX|MT_CHECK_INGAME|MT_CHECK_INKICKQUEUE|MT_CHECK_FAKECLIENT))
	{
		GetClientName(client, g_esPlayer[client].g_sOriginalName, sizeof(esPlayer::g_sOriginalName));

		vLoadConfigs(g_esGeneral.g_sSavePath, 3);
	}
}

public void OnClientDisconnect_Post(int client)
{
	vReset3(client);
	vResetCore(client);
}

public void OnConfigsExecuted()
{
	g_esGeneral.g_iRegularCount = 0;
	g_esGeneral.g_iType = 0;

	vLoadConfigs(g_esGeneral.g_sSavePath, 1);

	char sMapName[128];
	GetCurrentMap(sMapName, sizeof(sMapName));
	if (IsMapValid(sMapName))
	{
		vPluginStatus();

		CreateTimer(g_esGeneral.g_flRegularInterval, tTimerRegularWaves, _, TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
		CreateTimer(1.0, tTimerRefreshConfigs, _, TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
	}

	if ((g_esGeneral.g_iConfigCreate & MT_CONFIG_DIFFICULTY) && g_esGeneral.g_iConfigEnable == 1)
	{
		char sSMPath[PLATFORM_MAX_PATH];
		BuildPath(Path_SM, sSMPath, sizeof(sSMPath), "data/mutant_tanks/difficulty_configs/");
		CreateDirectory(sSMPath, 511);

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

			vCreateConfigFile("difficulty_configs/", sDifficulty);
		}
	}

	if ((g_esGeneral.g_iConfigCreate & MT_CONFIG_MAP) && g_esGeneral.g_iConfigEnable == 1)
	{
		char sSMPath[PLATFORM_MAX_PATH];
		BuildPath(Path_SM, sSMPath, sizeof(sSMPath), "data/mutant_tanks/%s", (bIsValidGame() ? "l4d2_map_configs/" : "l4d_map_configs/"));
		CreateDirectory(sSMPath, 511);

		char sMap[128];
		ArrayList alMaps = new ArrayList(16);
		if (alMaps != null)
		{
			int iSerial = -1;
			ReadMapList(alMaps, iSerial, "default", MAPLIST_FLAG_MAPSFOLDER);
			ReadMapList(alMaps, iSerial, "allexistingmaps__", MAPLIST_FLAG_MAPSFOLDER|MAPLIST_FLAG_NO_DEFAULT);

			int iMapCount = (alMaps.Length > 0) ? alMaps.Length : 0;
			if (iMapCount > 0)
			{
				for (int iMap = 0; iMap < iMapCount; iMap++)
				{
					alMaps.GetString(iMap, sMap, sizeof(sMap));
					vCreateConfigFile((bIsValidGame() ? "l4d2_map_configs/" : "l4d_map_configs/"), sMap);
				}
			}

			delete alMaps;
		}
	}

	if ((g_esGeneral.g_iConfigCreate & MT_CONFIG_GAMEMODE) && g_esGeneral.g_iConfigEnable == 1)
	{
		char sSMPath[PLATFORM_MAX_PATH];
		BuildPath(Path_SM, sSMPath, sizeof(sSMPath), "data/mutant_tanks/%s", (bIsValidGame() ? "l4d2_gamemode_configs/" : "l4d_gamemode_configs/"));
		CreateDirectory(sSMPath, 511);

		char sGameType[2049], sTypes[64][32];
		g_esGeneral.g_cvMTGameTypes.GetString(sGameType, sizeof(sGameType));
		ReplaceString(sGameType, sizeof(sGameType), " ", "");
		ExplodeString(sGameType, ",", sTypes, sizeof(sTypes), sizeof(sTypes[]));

		for (int iMode = 0; iMode < sizeof(sTypes); iMode++)
		{
			if (StrContains(sGameType, sTypes[iMode]) != -1 && sTypes[iMode][0] != '\0')
			{
				vCreateConfigFile((bIsValidGame() ? "l4d2_gamemode_configs/" : "l4d_gamemode_configs/"), sTypes[iMode]);
			}
		}
	}

	if ((g_esGeneral.g_iConfigCreate & MT_CONFIG_DAY) && g_esGeneral.g_iConfigEnable == 1)
	{
		char sSMPath[PLATFORM_MAX_PATH];
		BuildPath(Path_SM, sSMPath, sizeof(sSMPath), "data/mutant_tanks/daily_configs/");
		CreateDirectory(sSMPath, 511);

		char sWeekday[32];
		for (int iDay = 0; iDay <= 6; iDay++)
		{
			switch (iDay)
			{
				case 1: sWeekday = "monday";
				case 2: sWeekday = "tuesday";
				case 3: sWeekday = "wednesday";
				case 4: sWeekday = "thursday";
				case 5: sWeekday = "friday";
				case 6: sWeekday = "saturday";
				default: sWeekday = "sunday";
			}

			vCreateConfigFile("daily_configs/", sWeekday);
		}
	}

	if ((g_esGeneral.g_iConfigCreate & MT_CONFIG_COUNT) && g_esGeneral.g_iConfigEnable == 1)
	{
		char sSMPath[PLATFORM_MAX_PATH];
		BuildPath(Path_SM, sSMPath, sizeof(sSMPath), "data/mutant_tanks/playercount_configs/");
		CreateDirectory(sSMPath, 511);

		char sPlayerCount[32];
		for (int iCount = 0; iCount <= MAXPLAYERS + 1; iCount++)
		{
			IntToString(iCount, sPlayerCount, sizeof(sPlayerCount));
			vCreateConfigFile("playercount_configs/", sPlayerCount);
		}
	}

	if ((g_esGeneral.g_iConfigExecute & MT_CONFIG_DIFFICULTY) && g_esGeneral.g_iConfigEnable == 1 && g_esGeneral.g_cvMTDifficulty != null)
	{
		char sDifficulty[11], sDifficultyConfig[PLATFORM_MAX_PATH];
		g_esGeneral.g_cvMTDifficulty.GetString(sDifficulty, sizeof(sDifficulty));

		BuildPath(Path_SM, sDifficultyConfig, sizeof(sDifficultyConfig), "data/mutant_tanks/difficulty_configs/%s.cfg", sDifficulty);
		vLoadConfigs(sDifficultyConfig, 2);
		vPluginStatus();
		g_esGeneral.g_iFileTimeOld[1] = GetFileTime(sDifficultyConfig, FileTime_LastChange);
	}

	if ((g_esGeneral.g_iConfigExecute & MT_CONFIG_MAP) && g_esGeneral.g_iConfigEnable == 1)
	{
		char sMap[64], sMapConfig[PLATFORM_MAX_PATH];
		GetCurrentMap(sMap, sizeof(sMap));

		BuildPath(Path_SM, sMapConfig, sizeof(sMapConfig), (bIsValidGame() ? "data/mutant_tanks/l4d2_map_configs/%s.cfg" : "data/mutant_tanks/l4d_map_configs/%s.cfg"), sMap);
		vLoadConfigs(sMapConfig, 2);
		vPluginStatus();
		g_esGeneral.g_iFileTimeOld[2] = GetFileTime(sMapConfig, FileTime_LastChange);
	}

	if ((g_esGeneral.g_iConfigExecute & MT_CONFIG_GAMEMODE) && g_esGeneral.g_iConfigEnable == 1)
	{
		char sMode[64], sModeConfig[PLATFORM_MAX_PATH];
		g_esGeneral.g_cvMTGameMode.GetString(sMode, sizeof(sMode));

		BuildPath(Path_SM, sModeConfig, sizeof(sModeConfig), (bIsValidGame() ? "data/mutant_tanks/l4d2_gamemode_configs/%s.cfg" : "data/mutant_tanks/l4d_gamemode_configs/%s.cfg"), sMode);
		vLoadConfigs(sModeConfig, 2);
		vPluginStatus();
		g_esGeneral.g_iFileTimeOld[3] = GetFileTime(sModeConfig, FileTime_LastChange);
	}

	if ((g_esGeneral.g_iConfigExecute & MT_CONFIG_DAY) && g_esGeneral.g_iConfigEnable == 1)
	{
		char sDay[9], sDayNumber[2], sDayConfig[PLATFORM_MAX_PATH];
		FormatTime(sDayNumber, sizeof(sDayNumber), "%w", GetTime());

		int iDayNumber = StringToInt(sDayNumber);

		switch (iDayNumber)
		{
			case 1: sDay = "monday";
			case 2: sDay = "tuesday";
			case 3: sDay = "wednesday";
			case 4: sDay = "thursday";
			case 5: sDay = "friday";
			case 6: sDay = "saturday";
			default: sDay = "sunday";
		}

		BuildPath(Path_SM, sDayConfig, sizeof(sDayConfig), "data/mutant_tanks/daily_configs/%s.cfg", sDay);
		vLoadConfigs(sDayConfig, 2);
		vPluginStatus();
		g_esGeneral.g_iFileTimeOld[4] = GetFileTime(sDayConfig, FileTime_LastChange);
	}

	if ((g_esGeneral.g_iConfigExecute & MT_CONFIG_COUNT) && g_esGeneral.g_iConfigEnable == 1)
	{
		char sCountConfig[PLATFORM_MAX_PATH];
		BuildPath(Path_SM, sCountConfig, sizeof(sCountConfig), "data/mutant_tanks/playercount_configs/%i.cfg", iGetPlayerCount());
		vLoadConfigs(sCountConfig, 2);
		vPluginStatus();
		g_esGeneral.g_iFileTimeOld[5] = GetFileTime(sCountConfig, FileTime_LastChange);
	}
}

public void OnMapEnd()
{
	g_esGeneral.g_bMapStarted = false;

	vReset();

	if (g_esGeneral.g_alAdmins != null)
	{
		g_esGeneral.g_alAdmins.Clear();

		delete g_esGeneral.g_alAdmins;
	}
}

public void OnPluginEnd()
{
	vMultiTargetFilters(0);

	for (int iTank = 1; iTank <= MaxClients; iTank++)
	{
		if (bIsTank(iTank, MT_CHECK_INGAME|MT_CHECK_ALIVE|MT_CHECK_INKICKQUEUE))
		{
			vReset2(iTank);
		}
	}

	Call_StartForward(g_esGeneral.g_gfPluginEndForward);
	Call_Finish();
}

public Action umNameChange(UserMsg msg_id, BfRead msg, const int[] players, int playersNum, bool reliable, bool init)
{
	if (!g_esGeneral.g_bHideNameChange)
	{
		return Plugin_Continue;
	}

	static char sMessage[256];

	msg.ReadByte();
	msg.ReadByte();
	msg.ReadString(sMessage, sizeof(sMessage), true);

	if (StrEqual(sMessage, "#Cstrike_Name_Change")) 
	{
		g_esGeneral.g_bHideNameChange = false;

		return Plugin_Handled;
	}

	return Plugin_Continue;
}

public void OnAdminMenuReady(Handle topmenu)
{
	TopMenu tmMTMenu = TopMenu.FromHandle(topmenu);
	if (topmenu == g_esGeneral.g_tmMTMenu)
	{
		return;
	}

	g_esGeneral.g_tmMTMenu = tmMTMenu;

	TopMenuObject tmoCommands = g_esGeneral.g_tmMTMenu.AddCategory("MutantTanks", iMTAdminMenuHandler);
	if (tmoCommands != INVALID_TOPMENUOBJECT)
	{
		g_esGeneral.g_tmMTMenu.AddItem("sm_tank", vMutantTanksMenu, tmoCommands, "sm_tank", ADMFLAG_ROOT);
		g_esGeneral.g_tmMTMenu.AddItem("sm_mt_config", vMTConfigMenu, tmoCommands, "sm_mt_config", ADMFLAG_GENERIC);
		g_esGeneral.g_tmMTMenu.AddItem("sm_mt_info", vMTInfoMenu, tmoCommands, "sm_mt_info", ADMFLAG_GENERIC);
		g_esGeneral.g_tmMTMenu.AddItem("sm_mt_list", vMTListMenu, tmoCommands, "sm_mt_list", ADMFLAG_ROOT);
		g_esGeneral.g_tmMTMenu.AddItem("sm_mt_version", vMTVersionMenu, tmoCommands, "sm_mt_version", ADMFLAG_ROOT);
	}
}

public int iMTAdminMenuHandler(TopMenu topmenu, TopMenuAction action, TopMenuObject object_id, int param, char[] buffer, int maxlength)
{
	switch (action)
	{
		case TopMenuAction_DisplayTitle, TopMenuAction_DisplayOption: FormatEx(buffer, maxlength, "Mutant Tanks");
	}

	return 0;
}

public void vMutantTanksMenu(TopMenu topmenu, TopMenuAction action, TopMenuObject object_id, int param, char[] buffer, int maxlength)
{
	switch (action)
	{
		case TopMenuAction_DisplayOption: FormatEx(buffer, maxlength, "%T", "MTMenu", param);
		case TopMenuAction_SelectOption:
		{
			g_esPlayer[param].g_bAdminMenu = true;

			vTankMenu(param, 0);
		}
	}
}

public void vMTConfigMenu(TopMenu topmenu, TopMenuAction action, TopMenuObject object_id, int param, char[] buffer, int maxlength)
{
	switch (action)
	{
		case TopMenuAction_DisplayOption: FormatEx(buffer, maxlength, "%T", "MTConfigMenu", param);
		case TopMenuAction_SelectOption:
		{
			g_esPlayer[param].g_bAdminMenu = true;

			vConfigMenu(param, 0);
		}
	}
}

public void vMTInfoMenu(TopMenu topmenu, TopMenuAction action, TopMenuObject object_id, int param, char[] buffer, int maxlength)
{
	switch (action)
	{
		case TopMenuAction_DisplayOption: FormatEx(buffer, maxlength, "%T", "MTInfoMenu", param);
		case TopMenuAction_SelectOption:
		{
			g_esPlayer[param].g_bAdminMenu = true;

			vInfoMenu(param, 0);
		}
	}
}

public void vMTListMenu(TopMenu topmenu, TopMenuAction action, TopMenuObject object_id, int param, char[] buffer, int maxlength)
{
	switch (action)
	{
		case TopMenuAction_DisplayOption: FormatEx(buffer, maxlength, "%T", "MTListMenu", param);
		case TopMenuAction_SelectOption: vListAbilities(param);
	}
}

public void vMTVersionMenu(TopMenu topmenu, TopMenuAction action, TopMenuObject object_id, int param, char[] buffer, int maxlength)
{
	switch (action)
	{
		case TopMenuAction_DisplayOption: FormatEx(buffer, maxlength, "%T", "MTVersionMenu", param);
		case TopMenuAction_SelectOption: MT_PrintToChat(param, "%s Mutant Tanks{yellow} v%s{mint}, by{olive} Psyk0tik (Crasher_3637)", MT_TAG3, MT_VERSION);
	}
}

public Action cmdMTConfig(int client, int args)
{
	if (g_esPlayer[client].g_bUsedParser)
	{
		ReplyToCommand(client, "%s The plugin is still parsing the config file.", MT_TAG2);

		return Plugin_Handled;
	}

	if (bIsValidClient(client, MT_CHECK_INDEX|MT_CHECK_INGAME|MT_CHECK_INKICKQUEUE|MT_CHECK_FAKECLIENT))
	{
		static char sSteamID32[32], sSteam3ID[32];
		GetClientAuthId(client, AuthId_Steam2, sSteamID32, sizeof(sSteamID32));
		GetClientAuthId(client, AuthId_Steam3, sSteam3ID, sizeof(sSteam3ID));

		if (!CheckCommandAccess(client, "sm_tank", ADMFLAG_ROOT) && !bIsDeveloper(client))
		{
			ReplyToCommand(client, "%s %t", MT_TAG2, "NoCommandAccess");

			return Plugin_Handled;
		}
	}
	else
	{
		ReplyToCommand(client, "%s This command is to be used only in-game.", MT_TAG);

		return Plugin_Handled;
	}

	if (args < 1)
	{
		switch (IsVoteInProgress())
		{
			case true: ReplyToCommand(client, "%s %t", MT_TAG2, "Vote in Progress");
			case false: vConfigMenu(client, 0);
		}

		return Plugin_Handled;
	}

	GetCmdArg(1, g_esPlayer[client].g_sSection, sizeof(esPlayer::g_sSection));
	if (IsCharNumeric(g_esPlayer[client].g_sSection[0]))
	{
		g_esPlayer[client].g_iSection = StringToInt(g_esPlayer[client].g_sSection);
	}

	vParseConfig(client);

	return Plugin_Handled;
}

static void vParseConfig(int client)
{
	g_esPlayer[client].g_bUsedParser = true;

	SMCParser smcParser = new SMCParser();
	if (smcParser != null)
	{
		smcParser.OnStart = SMCParseStart2;
		smcParser.OnEnterSection = SMCNewSection2;
		smcParser.OnKeyValue = SMCKeyValues2;
		smcParser.OnLeaveSection = SMCEndSection2;
		smcParser.OnEnd = SMCParseEnd2;
		SMCError smcError = smcParser.ParseFile(g_esGeneral.g_sUsedPath);

		if (smcError != SMCError_Okay)
		{
			char sSmcError[64];
			smcParser.GetErrorString(smcError, sSmcError, sizeof(sSmcError));

			PrintToServer("%s Error while parsing the \"%s\" file. Error Message: %s.", MT_TAG, g_esGeneral.g_sUsedPath, sSmcError);
			LogError("Error while parsing the \"%s\" file. Error Message: %s.", g_esGeneral.g_sUsedPath, sSmcError);
		}

		delete smcParser;
	}
	else
	{
		PrintToServer("%s Failed to parse the \"%s\" file.", MT_TAG, g_esGeneral.g_sUsedPath);
		LogError("Failed to parse the \"%s\" file.", g_esGeneral.g_sUsedPath);
	}
}

public void SMCParseStart2(SMCParser smc)
{
	for (int iPlayer = 1; iPlayer <= MaxClients; iPlayer++)
	{
		if (g_esPlayer[iPlayer].g_bUsedParser && bIsValidClient(iPlayer, MT_CHECK_INGAME|MT_CHECK_INKICKQUEUE|MT_CHECK_FAKECLIENT))
		{
			g_esPlayer[iPlayer].g_csState = ConfigState_None;
			g_esPlayer[iPlayer].g_iIgnoreLevel = 0;

			MT_PrintToChat(iPlayer, "%s Parsing the config file...", MT_TAG2);
		}
	}
}

public SMCResult SMCNewSection2(SMCParser smc, const char[] name, bool opt_quotes)
{
	static char sTankName[8][33], sType[5];
	for (int iPlayer = 1; iPlayer <= MaxClients; iPlayer++)
	{
		if (g_esPlayer[iPlayer].g_bUsedParser && bIsValidClient(iPlayer, MT_CHECK_INGAME|MT_CHECK_INKICKQUEUE|MT_CHECK_FAKECLIENT))
		{
			if (g_esPlayer[iPlayer].g_iIgnoreLevel)
			{
				g_esPlayer[iPlayer].g_iIgnoreLevel++;

				return SMCParse_Continue;
			}

			if (g_esPlayer[iPlayer].g_csState == ConfigState_None)
			{
				if (StrEqual(name, "MutantTanks", false) || StrEqual(name, "Mutant Tanks", false) || StrEqual(name, "Mutant_Tanks", false) || StrEqual(name, "MT", false))
				{
					g_esPlayer[iPlayer].g_csState = ConfigState_Start;

					MT_PrintToChat(iPlayer, (opt_quotes) ? ("\"%s\"\n{") : ("%s\n{"), name);
				}
				else
				{
					g_esPlayer[iPlayer].g_iIgnoreLevel++;
				}
			}
			else if (g_esPlayer[iPlayer].g_csState == ConfigState_Start)
			{
				if ((StrEqual(name, "PluginSettings", false) || StrEqual(name, "Plugin Settings", false) || StrEqual(name, "Plugin_Settings", false) || StrEqual(name, "settings", false)) && StrContains(name, g_esPlayer[iPlayer].g_sSection, false) != -1)
				{
					g_esPlayer[iPlayer].g_csState = ConfigState_Settings;

					MT_PrintToChat(iPlayer, (opt_quotes) ? ("%10s \"%s\"\n%10s {") : ("%10s %s\n%10s {"), "", name, "");
				}
				else if (g_esPlayer[iPlayer].g_iSection > 0 && (StrContains(name, "Tank#", false) != -1 || StrContains(name, "Tank #", false) != -1 || StrContains(name, "Tank_#", false) != -1 || StrContains(name, "Tank", false) != -1 || name[0] == '#' || IsCharNumeric(name[0])))
				{
					FormatEx(sTankName[0], sizeof(sTankName[]), "Tank#%i", g_esPlayer[iPlayer].g_iSection);
					FormatEx(sTankName[1], sizeof(sTankName[]), "Tank #%i", g_esPlayer[iPlayer].g_iSection);
					FormatEx(sTankName[2], sizeof(sTankName[]), "Tank_#%i", g_esPlayer[iPlayer].g_iSection);
					FormatEx(sTankName[3], sizeof(sTankName[]), "Tank%i", g_esPlayer[iPlayer].g_iSection);
					FormatEx(sTankName[4], sizeof(sTankName[]), "Tank %i", g_esPlayer[iPlayer].g_iSection);
					FormatEx(sTankName[5], sizeof(sTankName[]), "Tank_%i", g_esPlayer[iPlayer].g_iSection);
					FormatEx(sTankName[6], sizeof(sTankName[]), "#%i", g_esPlayer[iPlayer].g_iSection);
					FormatEx(sTankName[7], sizeof(sTankName[]), "%i", g_esPlayer[iPlayer].g_iSection);

					IntToString(g_esPlayer[iPlayer].g_iSection, sType, sizeof(sType));
					if (StrContains(name, sType) != -1)
					{
						for (int iType = 0; iType < sizeof(sTankName); iType++)
						{
							if (StrEqual(name, sTankName[iType], false))
							{
								g_esPlayer[iPlayer].g_csState = ConfigState_Type;

								MT_PrintToChat(iPlayer, (opt_quotes) ? ("%10s \"%s\"\n%10s {") : ("%10s %s\n%10s {"), "", name, "");
							}
						}
					}
					else
					{
						g_esPlayer[iPlayer].g_iIgnoreLevel++;
					}
				}
				else if ((StrContains(name, "STEAM_", false) == 0 || strncmp("0:", name, 2) == 0 || strncmp("1:", name, 2) == 0 || (!strncmp(name, "[U:", 3) && name[strlen(name) - 1] == ']')) && StrContains(name, g_esPlayer[iPlayer].g_sSection, false) != -1)
				{
					g_esPlayer[iPlayer].g_csState = ConfigState_Admin;

					MT_PrintToChat(iPlayer, (opt_quotes) ? ("%10s \"%s\"\n%10s {") : ("%10s %s\n%10s {"), "", name, "");
				}
				else
				{
					g_esPlayer[iPlayer].g_iIgnoreLevel++;
				}
			}
			else if (g_esPlayer[iPlayer].g_csState == ConfigState_Settings || g_esPlayer[iPlayer].g_csState == ConfigState_Type || g_esPlayer[iPlayer].g_csState == ConfigState_Admin)
			{
				g_esPlayer[iPlayer].g_csState = ConfigState_Specific;

				MT_PrintToChat(iPlayer, (opt_quotes) ? ("%20s \"%s\"\n%20s {") : ("%20s %s\n%20s {"), "", name, "");
			}
			else
			{
				g_esPlayer[iPlayer].g_iIgnoreLevel++;
			}
		}
	}

	return SMCParse_Continue;
}

public SMCResult SMCKeyValues2(SMCParser smc, const char[] key, const char[] value, bool key_quotes, bool value_quotes)
{
	static char sKey[64], sValue[384];
	for (int iPlayer = 1; iPlayer <= MaxClients; iPlayer++)
	{
		if (g_esPlayer[iPlayer].g_bUsedParser && bIsValidClient(iPlayer, MT_CHECK_INGAME|MT_CHECK_INKICKQUEUE|MT_CHECK_FAKECLIENT))
		{
			if (g_esPlayer[iPlayer].g_iIgnoreLevel)
			{
				return SMCParse_Continue;
			}

			if (g_esPlayer[iPlayer].g_csState == ConfigState_Specific)
			{
				FormatEx(sKey, sizeof(sKey), ((key_quotes) ? ("\"%s\"") : ("%s")), key);
				FormatEx(sValue, sizeof(sValue), ((value_quotes) ? ("\"%s\"") : ("%s")), value);
				MT_PrintToChat(iPlayer, "%30s %30s %s", "", sKey, (value[0] == '\0') ? "\"\"" : sValue);
			}
		}
	}

	return SMCParse_Continue;
}

public SMCResult SMCEndSection2(SMCParser smc)
{
	for (int iPlayer = 1; iPlayer <= MaxClients; iPlayer++)
	{
		if (g_esPlayer[iPlayer].g_bUsedParser && bIsValidClient(iPlayer, MT_CHECK_INGAME|MT_CHECK_INKICKQUEUE|MT_CHECK_FAKECLIENT))
		{
			if (g_esPlayer[iPlayer].g_iIgnoreLevel)
			{
				g_esPlayer[iPlayer].g_iIgnoreLevel--;

				return SMCParse_Continue;
			}

			if (g_esPlayer[iPlayer].g_csState == ConfigState_Specific)
			{
				if (StrEqual(g_esPlayer[iPlayer].g_sSection, "PluginSettings", false) || StrEqual(g_esPlayer[iPlayer].g_sSection, "Plugin Settings", false) || StrEqual(g_esPlayer[iPlayer].g_sSection, "Plugin_Settings", false) || StrEqual(g_esPlayer[iPlayer].g_sSection, "settings", false))
				{
					g_esPlayer[iPlayer].g_csState = ConfigState_Settings;

					MT_PrintToChat(iPlayer, "%20s }", "");
				}
				else if (g_esPlayer[iPlayer].g_iSection > 0 && (StrContains(g_esPlayer[iPlayer].g_sSection, "Tank#", false) != -1 || StrContains(g_esPlayer[iPlayer].g_sSection, "Tank #", false) != -1 || StrContains(g_esPlayer[iPlayer].g_sSection, "Tank_#", false) != -1 || StrContains(g_esPlayer[iPlayer].g_sSection, "Tank", false) != -1 || g_esPlayer[iPlayer].g_sSection[0] == '#' || IsCharNumeric(g_esPlayer[iPlayer].g_sSection[0])))
				{
					g_esPlayer[iPlayer].g_csState = ConfigState_Type;

					MT_PrintToChat(iPlayer, "%20s }", "");
				}
				else if (StrContains(g_esPlayer[iPlayer].g_sSection, "STEAM_", false) == 0 || strncmp("0:", g_esPlayer[iPlayer].g_sSection, 2) == 0 || strncmp("1:", g_esPlayer[iPlayer].g_sSection, 2) == 0 || (!strncmp(g_esPlayer[iPlayer].g_sSection, "[U:", 3) && g_esPlayer[iPlayer].g_sSection[strlen(g_esPlayer[iPlayer].g_sSection) - 1] == ']'))
				{
					g_esPlayer[iPlayer].g_csState = ConfigState_Admin;

					MT_PrintToChat(iPlayer, "%20s }", "");
				}
			}
			else if (g_esPlayer[iPlayer].g_csState == ConfigState_Settings || g_esPlayer[iPlayer].g_csState == ConfigState_Type || g_esPlayer[iPlayer].g_csState == ConfigState_Admin)
			{
				g_esPlayer[iPlayer].g_csState = ConfigState_Start;

				MT_PrintToChat(iPlayer, "%10s }", "");
			}
			else if (g_esPlayer[iPlayer].g_csState == ConfigState_Start)
			{
				g_esPlayer[iPlayer].g_csState = ConfigState_None;

				MT_PrintToChat(iPlayer, "}");
			}
		}
	}

	return SMCParse_Continue;
}

public void SMCParseEnd2(SMCParser smc, bool halted, bool failed)
{
	for (int iPlayer = 1; iPlayer <= MaxClients; iPlayer++)
	{
		if (g_esPlayer[iPlayer].g_bUsedParser && bIsValidClient(iPlayer))
		{
			g_esPlayer[iPlayer].g_bUsedParser = false;
			g_esPlayer[iPlayer].g_csState = ConfigState_None;
			g_esPlayer[iPlayer].g_iIgnoreLevel = 0;
			g_esPlayer[iPlayer].g_iSection = 0;
			g_esPlayer[iPlayer].g_sSection[0] = '\0';

			MT_PrintToChat(iPlayer, "\n\n\n\n\n\n%s Parsing complete...", MT_TAG2);
			MT_PrintToChat(iPlayer, "%s See console for full output.", MT_TAG2);
		}
	}
}

static void vConfigMenu(int admin, int item)
{
	Menu mConfigMenu = new Menu(iConfigMenuHandler, MENU_ACTIONS_DEFAULT|MenuAction_Display);
	mConfigMenu.SetTitle("Config Parser Menu");

	static int iCount;
	iCount = 0;

	if (g_esGeneral.g_bSettingsFound)
	{
		mConfigMenu.AddItem("Plugin Settings", "Plugin Settings");
		iCount++;
	}

	static char sMenuItem[46];
	for (int iIndex = g_esGeneral.g_iMinType; iIndex <= g_esGeneral.g_iMaxType; iIndex++)
	{
		FormatEx(sMenuItem, sizeof(sMenuItem), "%s (Tank #%i)", g_esTank[iIndex].g_sTankName, iIndex);
		mConfigMenu.AddItem(g_esTank[iIndex].g_sTankName, sMenuItem);
		iCount++;
	}

	if (g_esGeneral.g_alAdmins != null)
	{
		static int iAdminSize;
		iAdminSize = (g_esGeneral.g_alAdmins.Length > 0) ? g_esGeneral.g_alAdmins.Length : 0;
		if (iAdminSize > 0)
		{
			static char sAdmins[32];
			for (int iPos = 0; iPos < iAdminSize; iPos++)
			{
				g_esGeneral.g_alAdmins.GetString(iPos, sAdmins, sizeof(sAdmins));
				mConfigMenu.AddItem(sAdmins, sAdmins);
				iCount++;
			}
		}
	}

	mConfigMenu.ExitBackButton = g_esPlayer[admin].g_bAdminMenu;

	if (iCount > 0)
	{
		mConfigMenu.DisplayAt(admin, item, MENU_TIME_FOREVER);
	}
	else
	{
		MT_PrintToChat(admin, "%s %t", MT_TAG2, "NoItems");

		delete mConfigMenu;
	}
}

public int iConfigMenuHandler(Menu menu, MenuAction action, int param1, int param2)
{
	switch (action)
	{
		case MenuAction_End: delete menu;
		case MenuAction_Cancel:
		{
			if (g_esPlayer[param1].g_bAdminMenu)
			{
				g_esPlayer[param1].g_bAdminMenu = false;

				if (param2 == MenuCancel_ExitBack && g_esGeneral.g_tmMTMenu != null)
				{
					g_esGeneral.g_tmMTMenu.Display(param1, TopMenuPosition_LastCategory);
				}
			}
		}
		case MenuAction_Select:
		{
			char sInfo[33];
			menu.GetItem(param2, sInfo, sizeof(sInfo));
			if (StrContains(sInfo, "Plugin", false) != -1 || StrContains(sInfo, "settings", false) != -1 || StrContains(sInfo, "STEAM_", false) == 0 || (!strncmp(sInfo, "[U:", 3) && sInfo[strlen(sInfo) - 1] == ']'))
			{
				g_esPlayer[param1].g_sSection = sInfo;
			}
			else
			{
				for (int iIndex = g_esGeneral.g_iMinType; iIndex <= g_esGeneral.g_iMaxType; iIndex++)
				{
					if (StrEqual(sInfo, g_esTank[iIndex].g_sTankName, false))
					{
						IntToString(iIndex, g_esPlayer[param1].g_sSection, sizeof(esPlayer::g_sSection));
						g_esPlayer[param1].g_iSection = iIndex;

						break;
					}
				}
			}

			vParseConfig(param1);

			if (bIsValidClient(param1, MT_CHECK_INGAME|MT_CHECK_INKICKQUEUE))
			{
				vConfigMenu(param1, menu.Selection);
			}
		}
		case MenuAction_Display:
		{
			char sMenuTitle[255];
			Panel panel = view_as<Panel>(param2);
			FormatEx(sMenuTitle, sizeof(sMenuTitle), "%T", "MTConfigMenu", param1);
			panel.SetTitle(sMenuTitle);
		}
	}

	return 0;
}

public Action cmdMTInfo(int client, int args)
{
	if (!bIsValidClient(client, MT_CHECK_INDEX|MT_CHECK_INGAME|MT_CHECK_INKICKQUEUE|MT_CHECK_FAKECLIENT))
	{
		ReplyToCommand(client, "%s This command is to be used only in-game.", MT_TAG);

		return Plugin_Handled;
	}

	switch (IsVoteInProgress())
	{
		case true: ReplyToCommand(client, "%s %t", MT_TAG2, "Vote in Progress");
		case false: vInfoMenu(client, 0);
	}

	return Plugin_Handled;
}

static void vInfoMenu(int client, int item)
{
	Menu mInfoMenu = new Menu(iInfoMenuHandler, MENU_ACTIONS_DEFAULT|MenuAction_Display|MenuAction_DisplayItem);
	mInfoMenu.SetTitle("Mutant Tanks Information");
	mInfoMenu.AddItem("Status", "Status");
	mInfoMenu.AddItem("Details", "Details");
	mInfoMenu.AddItem("Human Support", "Human Support");

	Call_StartForward(g_esGeneral.g_gfDisplayMenuForward);
	Call_PushCell(mInfoMenu);
	Call_Finish();

	mInfoMenu.ExitBackButton = g_esPlayer[client].g_bAdminMenu;
	mInfoMenu.DisplayAt(client, item, MENU_TIME_FOREVER);
}

public int iInfoMenuHandler(Menu menu, MenuAction action, int param1, int param2)
{
	switch (action)
	{
		case MenuAction_End: delete menu;
		case MenuAction_Cancel:
		{
			if (g_esPlayer[param1].g_bAdminMenu)
			{
				g_esPlayer[param1].g_bAdminMenu = false;

				if (param2 == MenuCancel_ExitBack && g_esGeneral.g_tmMTMenu != null)
				{
					g_esGeneral.g_tmMTMenu.Display(param1, TopMenuPosition_LastCategory);
				}
			}
		}
		case MenuAction_Select:
		{
			switch (param2)
			{
				case 0: MT_PrintToChat(param1, "%s %t", MT_TAG3, (!g_esGeneral.g_cvMTPluginEnabled.BoolValue || !g_esGeneral.g_bPluginEnabled) ? "AbilityStatus1" : "AbilityStatus2");
				case 1: MT_PrintToChat(param1, "%s %t", MT_TAG3, "GeneralDetails");
				case 2: MT_PrintToChat(param1, "%s %t", MT_TAG3, g_esTank[g_esPlayer[param1].g_iTankType].g_iHumanSupport == 0 ? "AbilityHumanSupport1" : "AbilityHumanSupport2");
			}

			char sInfo[33];
			menu.GetItem(param2, sInfo, sizeof(sInfo));

			Call_StartForward(g_esGeneral.g_gfMenuItemSelectedForward);
			Call_PushCell(param1);
			Call_PushString(sInfo);
			Call_Finish();

			if (param2 < 3 && bIsValidClient(param1, MT_CHECK_INGAME|MT_CHECK_INKICKQUEUE))
			{
				vInfoMenu(param1, menu.Selection);
			}
		}
		case MenuAction_Display:
		{
			char sMenuTitle[PLATFORM_MAX_PATH];
			Panel panel = view_as<Panel>(param2);
			FormatEx(sMenuTitle, sizeof(sMenuTitle), "%T", "MTInfoMenu", param1);
			panel.SetTitle(sMenuTitle);
		}
		case MenuAction_DisplayItem:
		{
			char sMenuOption[PLATFORM_MAX_PATH];

			switch (param2)
			{
				case 0:
				{
					FormatEx(sMenuOption, sizeof(sMenuOption), "%T", "Status", param1);

					return RedrawMenuItem(sMenuOption);
				}
				case 1:
				{
					FormatEx(sMenuOption, sizeof(sMenuOption), "%T", "Details", param1);

					return RedrawMenuItem(sMenuOption);
				}
				case 2:
				{
					FormatEx(sMenuOption, sizeof(sMenuOption), "%T", "HumanSupport", param1);

					return RedrawMenuItem(sMenuOption);
				}
			}
		}
	}

	return 0;
}

public Action cmdMTList(int client, int args)
{
	if (!g_esGeneral.g_cvMTPluginEnabled.BoolValue || !g_esGeneral.g_bPluginEnabled)
	{
		ReplyToCommand(client, "%s Mutant Tanks\x01 is disabled.", MT_TAG4);

		return Plugin_Handled;
	}

	if (bIsValidClient(client, MT_CHECK_INDEX|MT_CHECK_INGAME|MT_CHECK_INKICKQUEUE|MT_CHECK_FAKECLIENT))
	{
		static char sSteamID32[32], sSteam3ID[32];
		GetClientAuthId(client, AuthId_Steam2, sSteamID32, sizeof(sSteamID32));
		GetClientAuthId(client, AuthId_Steam3, sSteam3ID, sizeof(sSteam3ID));

		if (!CheckCommandAccess(client, "sm_tank", ADMFLAG_ROOT) && !bIsDeveloper(client))
		{
			ReplyToCommand(client, "%s %t", MT_TAG2, "NoCommandAccess");

			return Plugin_Handled;
		}
	}

	vListAbilities(client);

	return Plugin_Handled;
}

static void vListAbilities(int admin)
{
	static bool bHuman;
	bHuman = bIsValidClient(admin, MT_CHECK_FAKECLIENT);
	if (g_esGeneral.g_alPlugins != null)
	{
		static int iListSize;
		iListSize = (g_esGeneral.g_alPlugins.Length > 0) ? g_esGeneral.g_alPlugins.Length : 0;
		if (iListSize > 0)
		{
			static char sFilename[PLATFORM_MAX_PATH];
			for (int iPos = 0; iPos < iListSize; iPos++)
			{
				g_esGeneral.g_alPlugins.GetString(iPos, sFilename, sizeof(sFilename));

				switch (bHuman)
				{
					case true: MT_PrintToChat(admin, "%s %s{olive} is installed.", MT_TAG3, sFilename);
					case false: ReplyToCommand(admin, "%s %s is installed.", MT_TAG, sFilename);
				}
			}
		}
		else
		{
			switch (bHuman)
			{
				case true: MT_PrintToChat(admin, "%s No abilities were found.", MT_TAG2);
				case false: ReplyToCommand(admin, "%s No abilities were found.", MT_TAG);
			}
		}
	}
	else
	{
		switch (bHuman)
		{
			case true: MT_PrintToChat(admin, "%s No abilities were found.", MT_TAG2);
			case false: ReplyToCommand(admin, "%s No abilities were found.", MT_TAG);
		}
	}
}

public Action cmdMTVersion(int client, int args)
{
	if (bIsValidClient(client, MT_CHECK_INDEX|MT_CHECK_INGAME|MT_CHECK_INKICKQUEUE|MT_CHECK_FAKECLIENT))
	{
		static char sSteamID32[32], sSteam3ID[32];
		GetClientAuthId(client, AuthId_Steam2, sSteamID32, sizeof(sSteamID32));
		GetClientAuthId(client, AuthId_Steam3, sSteam3ID, sizeof(sSteam3ID));

		if (!CheckCommandAccess(client, "sm_tank", ADMFLAG_ROOT) && !bIsDeveloper(client))
		{
			ReplyToCommand(client, "%s %t", MT_TAG2, "NoCommandAccess");

			return Plugin_Handled;
		}
	}
	else
	{
		ReplyToCommand(client, "%s This command is to be used only in-game.", MT_TAG);

		return Plugin_Handled;
	}

	ReplyToCommand(client, "%s Mutant Tanks{yellow} v%s{mint}, by{olive} Psyk0tik (Crasher_3637)", MT_TAG3, MT_VERSION);

	return Plugin_Handled;
}

public Action cmdTank(int client, int args)
{
	if (!g_esGeneral.g_cvMTPluginEnabled.BoolValue || !g_esGeneral.g_bPluginEnabled)
	{
		ReplyToCommand(client, "%s Mutant Tanks\x01 is disabled.", MT_TAG4);

		return Plugin_Handled;
	}

	if (!bIsValidClient(client, MT_CHECK_INDEX|MT_CHECK_INGAME|MT_CHECK_INKICKQUEUE|MT_CHECK_FAKECLIENT))
	{
		ReplyToCommand(client, "%s %t", MT_TAG, "Command is in-game only");

		return Plugin_Handled;
	}

	if (args < 1)
	{
		switch (IsVoteInProgress())
		{
			case true: ReplyToCommand(client, "%s %t", MT_TAG2, "Vote in Progress");
			case false: vTankMenu(client, 0);
		}

		return Plugin_Handled;
	}

	static char sType[5];
	GetCmdArg(1, sType, sizeof(sType));
	static int iType, iAmount, iMode;
	iType = iClamp(StringToInt(sType), g_esGeneral.g_iMinType, g_esGeneral.g_iMaxType);
	iAmount = GetCmdArgInt(2);
	iMode = GetCmdArgInt(3);

	if (iAmount == 0)
	{
		iAmount = 1;
	}

	if ((IsCharNumeric(sType[0]) && (iType < g_esGeneral.g_iMinType || iType > g_esGeneral.g_iMaxType)) || iAmount > 32 || iMode < 0 || iMode > 1 || args > 3)
	{
		ReplyToCommand(client, "%s Usage: sm_tank <type %i-%i> <amount: 1-32> <0: spawn at crosshair|1: spawn automatically>", MT_TAG2, g_esGeneral.g_iMinType, g_esGeneral.g_iMaxType);

		return Plugin_Handled;
	}

	if (IsCharNumeric(sType[0]) && (g_esTank[iType].g_iTankEnabled == 0 || g_esTank[iType].g_iMenuEnabled == 0 || !bIsTypeAvailable(iType, client) || !bCanTypeSpawn(iType) || !bHasCoreAdminAccess(client, iType)))
	{
		ReplyToCommand(client, "%s %s\x04 (Tank #%i)\x01 is disabled.", MT_TAG4, g_esTank[iType].g_sTankName, iType);

		return Plugin_Handled;
	}

	vTank(client, sType, false, iAmount, iMode);

	return Plugin_Handled;
}

public Action cmdTank2(int client, int args)
{
	if (!g_esGeneral.g_cvMTPluginEnabled.BoolValue || !g_esGeneral.g_bPluginEnabled)
	{
		ReplyToCommand(client, "%s Mutant Tanks\x01 is disabled.", MT_TAG4);

		return Plugin_Handled;
	}

	if (bIsValidClient(client, MT_CHECK_INDEX|MT_CHECK_INGAME|MT_CHECK_INKICKQUEUE|MT_CHECK_FAKECLIENT))
	{
		static char sSteamID32[32], sSteam3ID[32];
		GetClientAuthId(client, AuthId_Steam2, sSteamID32, sizeof(sSteamID32));
		GetClientAuthId(client, AuthId_Steam3, sSteam3ID, sizeof(sSteam3ID));

		if (!CheckCommandAccess(client, "sm_tank", ADMFLAG_ROOT) && !bIsDeveloper(client))
		{
			ReplyToCommand(client, "%s %t", MT_TAG2, "NoCommandAccess");

			return Plugin_Handled;
		}
	}
	else
	{
		ReplyToCommand(client, "%s %t", MT_TAG, "Command is in-game only");

		return Plugin_Handled;
	}

	if (args < 1)
	{
		switch (IsVoteInProgress())
		{
			case true: ReplyToCommand(client, "%s %t", MT_TAG2, "Vote in Progress");
			case false: vTankMenu(client, 0);
		}

		return Plugin_Handled;
	}

	static char sType[5];
	GetCmdArg(1, sType, sizeof(sType));
	static int iType, iAmount, iMode;
	iType = iClamp(StringToInt(sType), g_esGeneral.g_iMinType, g_esGeneral.g_iMaxType);
	iAmount = GetCmdArgInt(2);
	iMode = GetCmdArgInt(3);

	if (iAmount == 0)
	{
		iAmount = 1;
	}

	if ((IsCharNumeric(sType[0]) && (iType < g_esGeneral.g_iMinType || iType > g_esGeneral.g_iMaxType)) || iAmount > 32 || iMode < 0 || iMode > 1 || args > 3)
	{
		ReplyToCommand(client, "%s Usage: sm_tank2 <type %i-%i> <amount: 1-32> <0: spawn at crosshair|1: spawn automatically>", MT_TAG2, g_esGeneral.g_iMinType, g_esGeneral.g_iMaxType);

		return Plugin_Handled;
	}

	if (IsCharNumeric(sType[0]) && (g_esTank[iType].g_iTankEnabled == 0 || g_esTank[iType].g_iMenuEnabled == 0 || !bIsTypeAvailable(iType, client) || !bCanTypeSpawn(iType) || !bHasCoreAdminAccess(client, iType)))
	{
		ReplyToCommand(client, "%s %s\x04 (Tank #%i)\x01 is disabled.", MT_TAG4, g_esTank[iType].g_sTankName, iType);

		return Plugin_Handled;
	}

	vTank(client, sType, false, iAmount, iMode);

	return Plugin_Handled;
}

public Action cmdMutantTank(int client, int args)
{
	if (!g_esGeneral.g_cvMTPluginEnabled.BoolValue || !g_esGeneral.g_bPluginEnabled)
	{
		ReplyToCommand(client, "%s Mutant Tanks\x01 is disabled.", MT_TAG4);

		return Plugin_Handled;
	}

	if (g_esGeneral.g_iSpawnMode == 1 && !CheckCommandAccess(client, "sm_tank", ADMFLAG_ROOT) && !bIsDeveloper(client))
	{
		ReplyToCommand(client, "%s %t", MT_TAG2, "NoCommandAccess");

		return Plugin_Handled;
	}

	if (!bIsValidClient(client, MT_CHECK_INDEX|MT_CHECK_INGAME|MT_CHECK_INKICKQUEUE|MT_CHECK_FAKECLIENT))
	{
		ReplyToCommand(client, "%s %t", MT_TAG, "Command is in-game only");

		return Plugin_Handled;
	}

	if (args < 1)
	{
		switch (IsVoteInProgress())
		{
			case true: ReplyToCommand(client, "%s %t", MT_TAG2, "Vote in Progress");
			case false: vTankMenu(client, 0);
		}

		return Plugin_Handled;
	}

	static char sType[5];
	GetCmdArg(1, sType, sizeof(sType));
	static int iType, iAmount, iMode;
	iType = iClamp(StringToInt(sType), g_esGeneral.g_iMinType, g_esGeneral.g_iMaxType);
	iAmount = GetCmdArgInt(2);
	iMode = GetCmdArgInt(3);

	if (iAmount == 0)
	{
		iAmount = 1;
	}

	if ((IsCharNumeric(sType[0]) && (iType < g_esGeneral.g_iMinType || iType > g_esGeneral.g_iMaxType)) || iAmount > 32 || iMode < 0 || iMode > 1 || args > 3)
	{
		ReplyToCommand(client, "%s Usage: sm_mutanttank <type %i-%i> <amount: 1-32> <0: spawn at crosshair|1: spawn automatically>", MT_TAG2, g_esGeneral.g_iMinType, g_esGeneral.g_iMaxType);

		return Plugin_Handled;
	}

	if (IsCharNumeric(sType[0]) && (g_esTank[iType].g_iTankEnabled == 0 || g_esTank[iType].g_iMenuEnabled == 0 || !bIsTypeAvailable(iType, client) || !bCanTypeSpawn(iType) || !bHasCoreAdminAccess(client, iType)))
	{
		ReplyToCommand(client, "%s %s\x04 (Tank #%i)\x01 is disabled.", MT_TAG4, g_esTank[iType].g_sTankName, iType);

		return Plugin_Handled;
	}

	vTank(client, sType, false, iAmount, iMode);

	return Plugin_Handled;
}

static void vTank(int admin, char[] type, bool spawn = true, int amount = 1, int mode = 0)
{
	int iType = StringToInt(type);

	switch (iType)
	{
		case 0:
		{
			int iTypeCount, iTankTypes[MT_MAXTYPES + 1];
			for (int iIndex = g_esGeneral.g_iMinType; iIndex <= g_esGeneral.g_iMaxType; iIndex++)
			{
				if (g_esTank[iIndex].g_iTankEnabled == 0 || !bHasCoreAdminAccess(admin, iIndex) || g_esTank[iIndex].g_iMenuEnabled == 0 || !bIsTypeAvailable(iIndex, admin) || !bCanTypeSpawn(iIndex) || StrContains(g_esTank[iIndex].g_sTankName, type, false) == -1)
				{
					continue;
				}

				g_esGeneral.g_iType = iIndex;
				iTankTypes[iTypeCount + 1] = iIndex;
				iTypeCount++;
			}

			switch (iTypeCount)
			{
				case 0:
				{
					MT_PrintToChat(admin, "%s %t", MT_TAG3, "RequestFailed");

					return;
				}
				case 1: MT_PrintToChat(admin, "%s %t", MT_TAG3, "RequestSucceeded");
				default:
				{
					MT_PrintToChat(admin, "%s %t", MT_TAG3, "MultipleMatches");

					g_esGeneral.g_iType = iTankTypes[GetRandomInt(1, iTypeCount)];
				}
			}
		}
		default: g_esGeneral.g_iType = iClamp(iType, g_esGeneral.g_iMinType, g_esGeneral.g_iMaxType);
	}

	switch (bIsTank(admin))
	{
		case true:
		{
			switch (bIsTank(admin, MT_CHECK_FAKECLIENT))
			{
				case true:
				{
					switch (spawn)
					{
						case true: vSpawnTank(admin, g_esGeneral.g_iType, amount, mode);
						case false:
						{
							char sSteamID32[32], sSteam3ID[32];
							GetClientAuthId(admin, AuthId_Steam2, sSteamID32, sizeof(sSteamID32));
							GetClientAuthId(admin, AuthId_Steam3, sSteam3ID, sizeof(sSteam3ID));

							if ((GetClientButtons(admin) & IN_SPEED) && (CheckCommandAccess(admin, "sm_tank", ADMFLAG_ROOT) || bIsDeveloper(admin)))
							{
								vChangeTank(admin, amount, mode);
							}
							else
							{
								int iTime = GetTime();

								switch (g_esPlayer[admin].g_iCooldown > iTime)
								{
									case true: MT_PrintToChat(admin, "%s %t", MT_TAG3, "HumanCooldown", g_esPlayer[admin].g_iCooldown - iTime);
									case false:
									{
										g_esPlayer[admin].g_iCooldown = -1;

										vNewTankSettings(admin);
										vSetColor(admin, g_esGeneral.g_iType);

										switch (g_esPlayer[admin].g_bNeedHealth)
										{
											case true:
											{
												g_esPlayer[admin].g_bNeedHealth = false;

												vTankSpawn(admin);
											}
											case false: vTankSpawn(admin, 5);
										}

										if (bIsTank(admin, MT_CHECK_FAKECLIENT))
										{
											vExternalView(admin, 1.5);
										}

										if (g_esGeneral.g_iMasterControl == 0 && (!CheckCommandAccess(admin, "mt_admin", ADMFLAG_ROOT) && !bIsDeveloper(admin)))
										{
											g_esPlayer[admin].g_iCooldown = iTime + g_esGeneral.g_iHumanCooldown;
										}
									}
								}
							}

							g_esGeneral.g_iType = 0;
						}
					}
				}
				case false: vSpawnTank(admin, g_esGeneral.g_iType, amount, mode);
			}
		}
		case false:
		{
			char sSteamID32[32], sSteam3ID[32];
			GetClientAuthId(admin, AuthId_Steam2, sSteamID32, sizeof(sSteamID32));
			GetClientAuthId(admin, AuthId_Steam3, sSteam3ID, sizeof(sSteam3ID));

			if (CheckCommandAccess(admin, "sm_tank", ADMFLAG_ROOT) || bIsDeveloper(admin))
			{
				vChangeTank(admin, amount, mode);
			}
			else
			{
				MT_PrintToChat(admin, "%s %t", MT_TAG2, "NoCommandAccess");
			}
		}
	}
}

static void vChangeTank(int admin, int amount, int mode)
{
	int iTarget = GetClientAimTarget(admin, false);

	switch (bIsValidEntity(iTarget))
	{
		case true:
		{
			char sClassname[32];
			GetEntityClassname(iTarget, sClassname, sizeof(sClassname));
			if (bIsTank(iTarget) && StrEqual(sClassname, "player"))
			{
				vNewTankSettings(iTarget);
				vSetColor(iTarget, g_esGeneral.g_iType);
				vTankSpawn(iTarget, 5);

				if (bIsTank(iTarget, MT_CHECK_FAKECLIENT))
				{
					vExternalView(iTarget, 1.5);
				}

				g_esGeneral.g_iType = 0;
			}
			else
			{
				vSpawnTank(admin, g_esGeneral.g_iType, amount, mode);
			}
		}
		case false: vSpawnTank(admin, g_esGeneral.g_iType, amount, mode);
	}
}

static void vQueueTank(int admin, int type, bool mode = true)
{
	char sType[5];
	IntToString(type, sType, sizeof(sType));
	vTank(admin, sType, mode);
}

static void vSpawnTank(int admin, int type, int amount, int mode)
{
	char sParameter[32];

	switch (mode)
	{
		case 0: sParameter = "tank";
		case 1: sParameter = "tank auto";
	}

	switch (amount)
	{
		case 1: vCheatCommand(admin, bIsValidGame() ? "z_spawn_old" : "z_spawn", sParameter);
		default:
		{
			for (int iAmount = 0; iAmount <= amount; iAmount++)
			{
				if (iAmount < amount)
				{
					vCheatCommand(admin, bIsValidGame() ? "z_spawn_old" : "z_spawn", sParameter);
					g_esGeneral.g_iType = type;
				}
				else if (iAmount == amount)
				{
					g_esGeneral.g_iType = 0;
				}
			}
		}
	}
}

static void vTankMenu(int admin, int item)
{
	Menu mTankMenu = new Menu(iTankMenuHandler, MENU_ACTIONS_DEFAULT|MenuAction_Display);
	mTankMenu.SetTitle("Mutant Tanks Menu");

	static int iCount;
	iCount = 0;

	if (g_esPlayer[admin].g_iTankType > 0)
	{
		mTankMenu.AddItem("Default Tank", "Default Tank");
		iCount++;
	}

	static char sMenuItem[46];
	for (int iIndex = g_esGeneral.g_iMinType; iIndex <= g_esGeneral.g_iMaxType; iIndex++)
	{
		if (g_esTank[iIndex].g_iTankEnabled == 0 || !bHasCoreAdminAccess(admin, iIndex) || g_esTank[iIndex].g_iMenuEnabled == 0 || !bIsTypeAvailable(iIndex, admin) || !bCanTypeSpawn(iIndex))
		{
			continue;
		}

		FormatEx(sMenuItem, sizeof(sMenuItem), "%s (Tank #%i)", g_esTank[iIndex].g_sTankName, iIndex);
		mTankMenu.AddItem(g_esTank[iIndex].g_sTankName, sMenuItem);
		iCount++;
	}

	mTankMenu.ExitBackButton = g_esPlayer[admin].g_bAdminMenu;

	if (iCount > 0)
	{
		mTankMenu.DisplayAt(admin, item, MENU_TIME_FOREVER);
	}
	else
	{
		MT_PrintToChat(admin, "%s %t", MT_TAG2, "NoItems");

		delete mTankMenu;
	}
}

public int iTankMenuHandler(Menu menu, MenuAction action, int param1, int param2)
{
	switch (action)
	{
		case MenuAction_End: delete menu;
		case MenuAction_Cancel:
		{
			if (g_esPlayer[param1].g_bAdminMenu)
			{
				g_esPlayer[param1].g_bAdminMenu = false;

				if (param2 == MenuCancel_ExitBack && g_esGeneral.g_tmMTMenu != null)
				{
					g_esGeneral.g_tmMTMenu.Display(param1, TopMenuPosition_LastCategory);
				}
			}
		}
		case MenuAction_Select:
		{
			char sInfo[33];
			menu.GetItem(param2, sInfo, sizeof(sInfo));

			switch (StrEqual(sInfo, "Default Tank", false))
			{
				case true: vQueueTank(param1, g_esPlayer[param1].g_iTankType, false);
				case false:
				{
					for (int iIndex = g_esGeneral.g_iMinType; iIndex <= g_esGeneral.g_iMaxType; iIndex++)
					{
						if (g_esTank[iIndex].g_iTankEnabled == 0 || !bHasCoreAdminAccess(param1, iIndex) || g_esTank[iIndex].g_iMenuEnabled == 0 || !bIsTypeAvailable(iIndex, param1) || !bCanTypeSpawn(iIndex))
						{
							continue;
						}

						if (StrEqual(sInfo, g_esTank[iIndex].g_sTankName, false))
						{
							vQueueTank(param1, iIndex, false);

							break;
						}
					}
				}
			}

			if (bIsValidClient(param1, MT_CHECK_INGAME|MT_CHECK_INKICKQUEUE))
			{
				vTankMenu(param1, menu.Selection);
			}
		}
		case MenuAction_Display:
		{
			char sMenuTitle[PLATFORM_MAX_PATH];
			Panel panel = view_as<Panel>(param2);
			FormatEx(sMenuTitle, sizeof(sMenuTitle), "%T", "MTMenu", param1);
			panel.SetTitle(sMenuTitle);
		}
	}

	return 0;
}

public void OnEntityCreated(int entity, const char[] classname)
{
	if (g_esGeneral.g_cvMTPluginEnabled.BoolValue && g_esGeneral.g_bPluginEnabled && bIsValidEntity(entity))
	{
		if (StrEqual(classname, "tank_rock"))
		{
			RequestFrame(vRockThrowFrame, EntIndexToEntRef(entity));
		}
		else if (StrEqual(classname, "infected"))
		{
			SDKHook(entity, SDKHook_OnTakeDamage, OnTakeDamage);
		}
		else if (StrEqual(classname, "trigger_finale", false) || StrEqual(classname, "finale_trigger", false))
		{
			HookEntityOutput(classname, "EscapeVehicleLeaving", vFinaleHook);
		}
	}
}

public void OnEntityDestroyed(int entity)
{
	if (g_esGeneral.g_cvMTPluginEnabled.BoolValue && g_esGeneral.g_bPluginEnabled && bIsValidEntity(entity))
	{
		static char sClassname[32];
		GetEntityClassname(entity, sClassname, sizeof(sClassname));
		if (StrEqual(sClassname, "tank_rock"))
		{
			static int iThrower;
			iThrower = GetEntPropEnt(entity, Prop_Data, "m_hThrower");
			if (bIsTankAllowed(iThrower) && bHasCoreAdminAccess(iThrower) && g_esTank[g_esPlayer[iThrower].g_iTankType].g_iTankEnabled == 1)
			{
				Call_StartForward(g_esGeneral.g_gfRockBreakForward);
				Call_PushCell(iThrower);
				Call_PushCell(entity);
				Call_Finish();
			}
		}
		else if (StrEqual(sClassname, "infected"))
		{
			SDKUnhook(entity, SDKHook_OnTakeDamage, OnTakeDamage);
		}
	}
}

public void OnGameFrame()
{
	if (g_esGeneral.g_cvMTPluginEnabled.BoolValue && g_esGeneral.g_bPluginEnabled)
	{
		static char sClassname[32], sHealthBar[51], sSet[2][2];
		static float flPercentage;
		static int iTarget, iHealth;
		for (int iPlayer = 1; iPlayer <= MaxClients; iPlayer++)
		{
			if (bIsValidClient(iPlayer, MT_CHECK_INGAME|MT_CHECK_ALIVE|MT_CHECK_INKICKQUEUE|MT_CHECK_FAKECLIENT))
			{
				iTarget = GetClientAimTarget(iPlayer, false);
				if (bIsValidEntity(iTarget))
				{
					GetEntityClassname(iTarget, sClassname, sizeof(sClassname));
					if (StrEqual(sClassname, "player") && bIsTank(iTarget))
					{
						if (g_esCache[iTarget].g_sTankName[0] == '\0')
						{
							g_esCache[iTarget].g_sTankName = "Tank";
						}

						sHealthBar[0] = '\0';
						iHealth = (g_esPlayer[iTarget].g_bDying) ? 0 : GetClientHealth(iTarget);
						flPercentage = (float(iHealth) / float(g_esPlayer[iTarget].g_iTankHealth)) * 100;

						ReplaceString(g_esCache[iTarget].g_sHealthCharacters, sizeof(esCache::g_sHealthCharacters), " ", "");
						ExplodeString(g_esCache[iTarget].g_sHealthCharacters, ",", sSet, sizeof(sSet), sizeof(sSet[]));

						for (int iCount = 0; iCount < (float(iHealth) / float(g_esPlayer[iTarget].g_iTankHealth)) * sizeof(sHealthBar) - 1 && iCount < sizeof(sHealthBar) - 1; iCount++)
						{
							StrCat(sHealthBar, sizeof(sHealthBar), sSet[0]);
						}

						for (int iCount = 0; iCount < sizeof(sHealthBar) - 1; iCount++)
						{
							StrCat(sHealthBar, sizeof(sHealthBar), sSet[1]);
						}

						switch (g_esCache[iTarget].g_iDisplayHealthType)
						{
							case 1:
							{
								switch (g_esCache[iTarget].g_iDisplayHealth)
								{
									case 1: PrintHintText(iPlayer, "%s", g_esCache[iTarget].g_sTankName);
									case 2: PrintHintText(iPlayer, "%i HP", iHealth);
									case 3: PrintHintText(iPlayer, "%i/%i HP (%.0f%s)", iHealth, g_esPlayer[iTarget].g_iTankHealth, flPercentage, "%%");
									case 4: PrintHintText(iPlayer, "HP: |-<%s>-|", sHealthBar);
									case 5: PrintHintText(iPlayer, "%s (%i HP)", g_esCache[iTarget].g_sTankName, iHealth);
									case 6: PrintHintText(iPlayer, "%s [%i/%i HP (%.0f%s)]", g_esCache[iTarget].g_sTankName, iHealth, g_esPlayer[iTarget].g_iTankHealth, flPercentage, "%%");
									case 7: PrintHintText(iPlayer, "%s\nHP: |-<%s>-|", g_esCache[iTarget].g_sTankName, sHealthBar);
									case 8: PrintHintText(iPlayer, "%i HP\nHP: |-<%s>-|", iHealth, sHealthBar);
									case 9: PrintHintText(iPlayer, "%i/%i HP (%.0f%s)\nHP: |-<%s>-|", iHealth, g_esPlayer[iTarget].g_iTankHealth, flPercentage, "%%", sHealthBar);
									case 10: PrintHintText(iPlayer, "%s (%i HP)\nHP: |-<%s>-|", g_esCache[iTarget].g_sTankName, iHealth, sHealthBar);
									case 11: PrintHintText(iPlayer, "%s [%i/%i HP (%.0f%s)]\nHP: |-<%s>-|", g_esCache[iTarget].g_sTankName, iHealth, g_esPlayer[iTarget].g_iTankHealth, flPercentage, "%%", sHealthBar);
								}
							}
							case 2:
							{
								switch (g_esCache[iTarget].g_iDisplayHealth)
								{
									case 1: PrintCenterText(iPlayer, "%s", g_esCache[iTarget].g_sTankName);
									case 2: PrintCenterText(iPlayer, "%i HP", iHealth);
									case 3: PrintCenterText(iPlayer, "%i/%i HP (%.0f%s)", iHealth, g_esPlayer[iTarget].g_iTankHealth, flPercentage, "%%");
									case 4: PrintCenterText(iPlayer, "HP: |-<%s>-|", sHealthBar);
									case 5: PrintCenterText(iPlayer, "%s (%i HP)", g_esCache[iTarget].g_sTankName, iHealth);
									case 6: PrintCenterText(iPlayer, "%s [%i/%i HP (%.0f%s)]", g_esCache[iTarget].g_sTankName, iHealth, g_esPlayer[iTarget].g_iTankHealth, flPercentage, "%%");
									case 7: PrintCenterText(iPlayer, "%s\nHP: |-<%s>-|", g_esCache[iTarget].g_sTankName, sHealthBar);
									case 8: PrintCenterText(iPlayer, "%i HP\nHP: |-<%s>-|", iHealth, sHealthBar);
									case 9: PrintCenterText(iPlayer, "%i/%i HP (%.0f%s)\nHP: |-<%s>-|", iHealth, g_esPlayer[iTarget].g_iTankHealth, flPercentage, "%%", sHealthBar);
									case 10: PrintCenterText(iPlayer, "%s (%i HP)\nHP: |-<%s>-|", g_esCache[iTarget].g_sTankName, iHealth, sHealthBar);
									case 11: PrintCenterText(iPlayer, "%s [%i/%i HP (%.0f%s)]\nHP: |-<%s>-|", g_esCache[iTarget].g_sTankName, iHealth, g_esPlayer[iTarget].g_iTankHealth, flPercentage, "%%", sHealthBar);
								}
							}
						}
					}
				}
			}
		}
	}
}

public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon)
{
	if (!g_esGeneral.g_cvMTPluginEnabled.BoolValue || !g_esGeneral.g_bPluginEnabled || !bIsTankAllowed(client))
	{
		return Plugin_Continue;
	}

	if (bIsTankAllowed(client, MT_CHECK_FAKECLIENT))
	{
		static int iButton;
		for (int iBit = 0; iBit < 26; iBit++)
		{
			iButton = (1 << iBit);
			if (buttons & iButton)
			{
				if (!(g_esPlayer[client].g_iLastButtons & iButton))
				{
					Call_StartForward(g_esGeneral.g_gfButtonPressedForward);
					Call_PushCell(client);
					Call_PushCell(iButton);
					Call_Finish();
				}
			}
			else if (g_esPlayer[client].g_iLastButtons & iButton)
			{
				Call_StartForward(g_esGeneral.g_gfButtonReleasedForward);
				Call_PushCell(client);
				Call_PushCell(iButton);
				Call_Finish();
			}
		}

		g_esPlayer[client].g_iLastButtons = buttons;
	}

	if (g_esCache[client].g_iFireImmunity == 1 && bIsPlayerBurning(client))
	{
		ExtinguishEntity(client);
		SetEntPropFloat(client, Prop_Send, "m_burnPercent", 1.0);
	}

	return Plugin_Continue;
}

public Action OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype)
{
	if (g_esGeneral.g_cvMTPluginEnabled.BoolValue && g_esGeneral.g_bPluginEnabled && damage >= 0.5)
	{
		static char sClassname[32];
		if (bIsValidEntity(inflictor))
		{
			GetEntityClassname(inflictor, sClassname, sizeof(sClassname));
		}

		if (bIsTankAllowed(attacker) && bHasCoreAdminAccess(attacker) && bIsSurvivor(victim) && !bIsCoreAdminImmune(victim, attacker))
		{
			if (StrEqual(sClassname, "weapon_tank_claw") && g_esCache[attacker].g_flClawDamage > 0.0)
			{
				damage = g_esCache[attacker].g_flClawDamage;

				return Plugin_Changed;
			}
			else if (StrEqual(sClassname, "tank_rock") && g_esCache[attacker].g_flRockDamage > 0.0)
			{
				damage = g_esCache[attacker].g_flRockDamage;

				return Plugin_Changed;
			}
		}
		else if (bIsInfected(victim, MT_CHECK_INDEX|MT_CHECK_INGAME|MT_CHECK_ALIVE|MT_CHECK_INKICKQUEUE) || bIsCommonInfected(victim))
		{
			if (bIsTankAllowed(victim) && bHasCoreAdminAccess(victim))
			{
				if (((damagetype & DMG_BULLET) && g_esCache[victim].g_iBulletImmunity == 1) || (((damagetype & DMG_BLAST) || (damagetype & DMG_BLAST_SURFACE) || (damagetype & DMG_AIRBOAT) || (damagetype & DMG_PLASMA)) && g_esCache[victim].g_iExplosiveImmunity == 1)
					|| ((damagetype & DMG_BURN) && g_esCache[victim].g_iFireImmunity == 1) || (((damagetype & DMG_SLASH) || (damagetype & DMG_CLUB)) && g_esCache[victim].g_iMeleeImmunity == 1))
				{
					return Plugin_Handled;
				}
			}

			if (attacker == victim || StrEqual(sClassname, "tank_rock") ||
				(((damagetype & DMG_BLAST) || (damagetype & DMG_BLAST_SURFACE) || (damagetype & DMG_AIRBOAT) || (damagetype & DMG_PLASMA) || (damagetype & DMG_BURN)) && bIsTank(attacker)))
			{
				return Plugin_Handled;
			}
		}
	}

	return Plugin_Continue;
}

public Action SetTransmit(int entity, int client)
{
	int iOwner = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
	if (g_esGeneral.g_cvMTPluginEnabled.BoolValue && g_esGeneral.g_bPluginEnabled && iOwner == client && !bIsTankThirdPerson(client) && !g_esPlayer[client].g_bThirdPerson)
	{
		return Plugin_Handled;
	}

	return Plugin_Continue;
}

static void vCacheSettings(int tank)
{
	bool bHasAccess = bIsTankAllowed(tank) && bHasCoreAdminAccess(tank), bHuman = bIsTank(tank, MT_CHECK_FAKECLIENT);
	int iType = g_esPlayer[tank].g_iTankType;
	vGetSettingValue(bHasAccess, true, g_esCache[tank].g_sHealthCharacters, sizeof(esCache::g_sHealthCharacters), g_esTank[iType].g_sHealthCharacters, g_esGeneral.g_sHealthCharacters);
	vGetSettingValue(bHasAccess, bHuman, g_esCache[tank].g_sHealthCharacters, sizeof(esCache::g_sHealthCharacters), g_esPlayer[tank].g_sHealthCharacters, g_esCache[tank].g_sHealthCharacters);
	vGetSettingValue(bHasAccess, bHuman, g_esCache[tank].g_sTankName, sizeof(esCache::g_sTankName), g_esPlayer[tank].g_sTankName, g_esTank[iType].g_sTankName);
	g_esCache[tank].g_flClawDamage = flGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_flClawDamage, g_esTank[iType].g_flClawDamage, true);
	g_esCache[tank].g_flRandomInterval = flGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_flRandomInterval, g_esTank[iType].g_flRandomInterval);
	g_esCache[tank].g_flRockDamage = flGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_flRockDamage, g_esTank[iType].g_flRockDamage, true);
	g_esCache[tank].g_flRunSpeed = flGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_flRunSpeed, g_esTank[iType].g_flRunSpeed, true);
	g_esCache[tank].g_flThrowInterval = flGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_flThrowInterval, g_esTank[iType].g_flThrowInterval, true);
	g_esCache[tank].g_flTransformDelay = flGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_flTransformDelay, g_esTank[iType].g_flTransformDelay);
	g_esCache[tank].g_flTransformDuration = flGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_flTransformDuration, g_esTank[iType].g_flTransformDuration);
	g_esCache[tank].g_iAnnounceArrival = iGetSettingValue(bHasAccess, true, g_esTank[iType].g_iAnnounceArrival, g_esGeneral.g_iAnnounceArrival);
	g_esCache[tank].g_iAnnounceArrival = iGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_iAnnounceArrival, g_esCache[tank].g_iAnnounceArrival);
	g_esCache[tank].g_iAnnounceDeath = iGetSettingValue(bHasAccess, true, g_esTank[iType].g_iAnnounceDeath, g_esGeneral.g_iAnnounceDeath);
	g_esCache[tank].g_iAnnounceDeath = iGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_iAnnounceDeath, g_esCache[tank].g_iAnnounceDeath);
	g_esCache[tank].g_iBodyEffects = iGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_iBodyEffects, g_esTank[iType].g_iBodyEffects);
	g_esCache[tank].g_iBossStages = iGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_iBossStages, g_esTank[iType].g_iBossStages);
	g_esCache[tank].g_iBulletImmunity = iGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_iBulletImmunity, g_esTank[iType].g_iBulletImmunity);
	g_esCache[tank].g_iDeathRevert = iGetSettingValue(bHasAccess, true, g_esTank[iType].g_iDeathRevert, g_esGeneral.g_iDeathRevert);
	g_esCache[tank].g_iDeathRevert = iGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_iDeathRevert, g_esCache[tank].g_iDeathRevert);
	g_esCache[tank].g_iDetectPlugins = iGetSettingValue(bHasAccess, true, g_esTank[iType].g_iDetectPlugins, g_esGeneral.g_iDetectPlugins);
	g_esCache[tank].g_iDetectPlugins = iGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_iDetectPlugins, g_esCache[tank].g_iDetectPlugins);
	g_esCache[tank].g_iDisplayHealth = iGetSettingValue(bHasAccess, true, g_esTank[iType].g_iDisplayHealth, g_esGeneral.g_iDisplayHealth);
	g_esCache[tank].g_iDisplayHealth = iGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_iDisplayHealth, g_esCache[tank].g_iDisplayHealth);
	g_esCache[tank].g_iDisplayHealthType = iGetSettingValue(bHasAccess, true, g_esTank[iType].g_iDisplayHealthType, g_esGeneral.g_iDisplayHealthType);
	g_esCache[tank].g_iDisplayHealthType = iGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_iDisplayHealthType, g_esCache[tank].g_iDisplayHealthType);
	g_esCache[tank].g_iExplosiveImmunity = iGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_iExplosiveImmunity, g_esTank[iType].g_iExplosiveImmunity);
	g_esCache[tank].g_iExtraHealth = iGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_iExtraHealth, g_esTank[iType].g_iExtraHealth);
	g_esCache[tank].g_iFireImmunity = iGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_iFireImmunity, g_esTank[iType].g_iFireImmunity);
	g_esCache[tank].g_iGlowEnabled = iGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_iGlowEnabled, g_esTank[iType].g_iGlowEnabled);
	g_esCache[tank].g_iGlowFlashing = iGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_iGlowFlashing, g_esTank[iType].g_iGlowFlashing);
	g_esCache[tank].g_iGlowMaxRange = iGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_iGlowMaxRange, g_esTank[iType].g_iGlowMaxRange);
	g_esCache[tank].g_iGlowMinRange = iGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_iGlowMinRange, g_esTank[iType].g_iGlowMinRange);
	g_esCache[tank].g_iGlowType = iGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_iGlowType, g_esTank[iType].g_iGlowType);
	g_esCache[tank].g_iMeleeImmunity = iGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_iMeleeImmunity, g_esTank[iType].g_iMeleeImmunity);
	g_esCache[tank].g_iMultiHealth = iGetSettingValue(bHasAccess, true, g_esTank[iType].g_iMultiHealth, g_esGeneral.g_iMultiHealth);
	g_esCache[tank].g_iMultiHealth = iGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_iMultiHealth, g_esCache[tank].g_iMultiHealth);
	g_esCache[tank].g_iPropsAttached = iGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_iPropsAttached, g_esTank[iType].g_iPropsAttached);
	g_esCache[tank].g_iRandomTank = iGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_iRandomTank, g_esTank[iType].g_iRandomTank);
	g_esCache[tank].g_iRenamePlayers = iGetSettingValue(bHasAccess, true, g_esTank[iType].g_iRenamePlayers, g_esGeneral.g_iRenamePlayers);
	g_esCache[tank].g_iRenamePlayers = iGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_iRenamePlayers, g_esCache[tank].g_iRenamePlayers);
	g_esCache[tank].g_iRockEffects = iGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_iRockEffects, g_esTank[iType].g_iRockEffects);
	g_esCache[tank].g_iRockModel = iGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_iRockModel, g_esTank[iType].g_iRockModel);
	g_esCache[tank].g_iTankNote = iGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_iTankNote, g_esTank[iType].g_iTankNote);

	for (int iPos = 0; iPos < sizeof(esCache::g_iTransformType); iPos++)
	{
		g_esCache[tank].g_iTransformType[iPos] = iGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_iTransformType[iPos], g_esTank[iType].g_iTransformType[iPos]);

		if (iPos < sizeof(esCache::g_flPropsChance))
		{
			g_esCache[tank].g_flPropsChance[iPos] = flGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_flPropsChance[iPos], g_esTank[iType].g_flPropsChance[iPos]);
		}

		if (iPos < sizeof(esCache::g_iSkinColor))
		{
			g_esCache[tank].g_iSkinColor[iPos] = iGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_iSkinColor[iPos], g_esTank[iType].g_iSkinColor[iPos], true);
			g_esCache[tank].g_iBossHealth[iPos] = iGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_iBossHealth[iPos], g_esTank[iType].g_iBossHealth[iPos]);
			g_esCache[tank].g_iBossType[iPos] = iGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_iBossType[iPos], g_esTank[iType].g_iBossType[iPos]);
			g_esCache[tank].g_iLightColor[iPos] = iGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_iLightColor[iPos], g_esTank[iType].g_iLightColor[iPos], true);
			g_esCache[tank].g_iOzTankColor[iPos] = iGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_iOzTankColor[iPos], g_esTank[iType].g_iOzTankColor[iPos], true);
			g_esCache[tank].g_iFlameColor[iPos] = iGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_iFlameColor[iPos], g_esTank[iType].g_iFlameColor[iPos], true);
			g_esCache[tank].g_iRockColor[iPos] = iGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_iRockColor[iPos], g_esTank[iType].g_iRockColor[iPos], true);
			g_esCache[tank].g_iTireColor[iPos] = iGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_iTireColor[iPos], g_esTank[iType].g_iTireColor[iPos], true);
			g_esCache[tank].g_iPropTankColor[iPos] = iGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_iPropTankColor[iPos], g_esTank[iType].g_iPropTankColor[iPos], true);
		}

		if (iPos < sizeof(esCache::g_iGlowColor))
		{
			g_esCache[tank].g_iGlowColor[iPos] = iGetSettingValue(bHasAccess, bHuman, g_esPlayer[tank].g_iGlowColor[iPos], g_esTank[iType].g_iGlowColor[iPos], true);
		}
	}

	Call_StartForward(g_esGeneral.g_gfSettingsCachedForward);
	Call_PushCell(tank);
	Call_PushCell(bHasAccess);
	Call_PushCell(iType);
	Call_Finish();
}

static void vClearAbilityList()
{
	for (int iPos = 0; iPos < sizeof(esGeneral::g_alAbilitySections); iPos++)
	{
		if (g_esGeneral.g_alAbilitySections[iPos] != null)
		{
			g_esGeneral.g_alAbilitySections[iPos].Clear();

			delete g_esGeneral.g_alAbilitySections[iPos];
		}
	}
}

static void vClearPluginList()
{
	if (g_esGeneral.g_alPlugins != null)
	{
		g_esGeneral.g_alPlugins.Clear();

		delete g_esGeneral.g_alPlugins;
	}
}

static void vLoadConfigs(const char[] savepath, int mode)
{
	vClearPluginList();
	g_esGeneral.g_alPlugins = new ArrayList(ByteCountToCells(PLATFORM_MAX_PATH));
	if (g_esGeneral.g_alPlugins != null)
	{
		Call_StartForward(g_esGeneral.g_gfPluginCheckForward);
		Call_PushArrayEx(g_esGeneral.g_alPlugins, MT_MAX_ABILITIES + 1, SM_PARAM_COPYBACK);
		Call_Finish();
	}

	Call_StartForward(g_esGeneral.g_gfAbilityCheckForward);

	vClearAbilityList();
	for (int iPos = 0; iPos < sizeof(esGeneral::g_alAbilitySections); iPos++)
	{
		g_esGeneral.g_alAbilitySections[iPos] = new ArrayList(ByteCountToCells(PLATFORM_MAX_PATH));
		Call_PushArrayEx(g_esGeneral.g_alAbilitySections[iPos], MT_MAX_ABILITIES + 1, SM_PARAM_COPYBACK);
	}

	Call_Finish();

	for (int iPos = 0; iPos < MT_MAX_ABILITIES; iPos++)
	{
		g_esGeneral.g_bAbilityPlugin[iPos] = false;
	}

	if (g_esGeneral.g_alPlugins != null)
	{
		int iListSize = (g_esGeneral.g_alPlugins.Length > 0) ? g_esGeneral.g_alPlugins.Length : 0;
		if (iListSize > 0)
		{
			for (int iPos = 0; iPos < iListSize; iPos++)
			{
				g_esGeneral.g_bAbilityPlugin[iPos] = true;
			}
		}
	}

	g_esGeneral.g_iConfigMode = mode;
	g_esGeneral.g_bSettingsFound = false;
	strcopy(g_esGeneral.g_sUsedPath, sizeof(esGeneral::g_sUsedPath), savepath);

	SMCParser smcLoader = new SMCParser();
	if (smcLoader != null)
	{
		smcLoader.OnStart = SMCParseStart;
		smcLoader.OnEnterSection = SMCNewSection;
		smcLoader.OnKeyValue = SMCKeyValues;
		smcLoader.OnLeaveSection = SMCEndSection;
		smcLoader.OnEnd = SMCParseEnd;
		SMCError smcError = smcLoader.ParseFile(savepath);

		if (smcError != SMCError_Okay)
		{
			char sSmcError[64];
			smcLoader.GetErrorString(smcError, sSmcError, sizeof(sSmcError));

			PrintToServer("%s Error while parsing the \"%s\" file. Error Message: %s.", MT_TAG, savepath, sSmcError);
			LogError("Error while parsing the \"%s\" file. Error Message: %s.", savepath, sSmcError);
		}

		delete smcLoader;
	}
	else
	{
		PrintToServer("%s Failed to parse the \"%s\" file.", MT_TAG, savepath);
		LogError("Failed to parse the \"%s\" file.", savepath);
	}
}

public void SMCParseStart(SMCParser smc)
{
	g_esGeneral.g_csState = ConfigState_None;
	g_esGeneral.g_iIgnoreLevel = 0;
	g_esGeneral.g_sCurrentSection[0] = '\0';
	g_esGeneral.g_sCurrentSubSection[0] = '\0';

	if (g_esGeneral.g_iConfigMode == 1)
	{
		g_esGeneral.g_iPluginEnabled = 0;
		g_esGeneral.g_iAnnounceArrival = 31;
		g_esGeneral.g_iAnnounceDeath = 1;
		g_esGeneral.g_iBaseHealth = 0;
		g_esGeneral.g_iDeathRevert = 0;
		g_esGeneral.g_iDetectPlugins = 0;
		g_esGeneral.g_iDisplayHealth = 11;
		g_esGeneral.g_iDisplayHealthType = 1;
		g_esGeneral.g_iFinalesOnly = 0;
		g_esGeneral.g_sHealthCharacters = "|,-";
		g_esGeneral.g_iMultiHealth = 0;
		g_esGeneral.g_iMinType = 1;
		g_esGeneral.g_iMaxType = MT_MAXTYPES;
		g_esGeneral.g_iAllowDeveloper = 1;
		g_esGeneral.g_iAccessFlags = 0;
		g_esGeneral.g_iImmunityFlags = 0;
		g_esGeneral.g_iHumanCooldown = 600;
		g_esGeneral.g_iMasterControl = 0;
		g_esGeneral.g_iRenamePlayers = 0;
		g_esGeneral.g_iSpawnMode = 1;
		g_esGeneral.g_iRegularAmount = 0;
		g_esGeneral.g_flRegularInterval = 300.0;
		g_esGeneral.g_iRegularLimit = 2;
		g_esGeneral.g_iRegularMode = 0;
		g_esGeneral.g_iRegularWave = 0;
		g_esGeneral.g_iGameModeTypes = 0;
		g_esGeneral.g_sEnabledGameModes[0] = '\0';
		g_esGeneral.g_sDisabledGameModes[0] = '\0';
		g_esGeneral.g_iConfigEnable = 0;
		g_esGeneral.g_iConfigCreate = 0;
		g_esGeneral.g_iConfigExecute = 0;

		for (int iPos = 0; iPos < sizeof(esGeneral::g_iFinaleWave); iPos++)
		{
			g_esGeneral.g_iFinaleMaxTypes[iPos] = g_esGeneral.g_iMaxType;
			g_esGeneral.g_iFinaleMinTypes[iPos] = g_esGeneral.g_iMinType;
			g_esGeneral.g_iFinaleWave[iPos] = 0;
		}

		for (int iIndex = g_esGeneral.g_iMinType; iIndex <= g_esGeneral.g_iMaxType; iIndex++)
		{
			FormatEx(g_esTank[iIndex].g_sTankName, sizeof(esTank::g_sTankName), "Tank #%i", iIndex);
			g_esTank[iIndex].g_iTankEnabled = 0;
			g_esTank[iIndex].g_flTankChance = 100.0;
			g_esTank[iIndex].g_iTankNote = 0;
			g_esTank[iIndex].g_iSpawnEnabled = 1;
			g_esTank[iIndex].g_iMenuEnabled = 1;
			g_esTank[iIndex].g_iAnnounceArrival = 0;
			g_esTank[iIndex].g_iAnnounceDeath = 0;
			g_esTank[iIndex].g_iDeathRevert = 0;
			g_esTank[iIndex].g_iDetectPlugins = 0;
			g_esTank[iIndex].g_iDisplayHealth = 0;
			g_esTank[iIndex].g_iDisplayHealthType = 0;
			g_esTank[iIndex].g_sHealthCharacters[0] = '\0';
			g_esTank[iIndex].g_iMultiHealth = 0;
			g_esTank[iIndex].g_iHumanSupport = 0;
			g_esTank[iIndex].g_iRenamePlayers = 0;
			g_esTank[iIndex].g_iGlowEnabled = 0;
			g_esTank[iIndex].g_iGlowFlashing = 0;
			g_esTank[iIndex].g_iGlowMinRange = 0;
			g_esTank[iIndex].g_iGlowMaxRange = 999999;
			g_esTank[iIndex].g_iGlowType = 0;
			g_esTank[iIndex].g_iAccessFlags = 0;
			g_esTank[iIndex].g_iImmunityFlags = 0;
			g_esTank[iIndex].g_iTypeLimit = 32;
			g_esTank[iIndex].g_iFinaleTank = 0;
			g_esTank[iIndex].g_iBossStages = 4;
			g_esTank[iIndex].g_iRandomTank = 1;
			g_esTank[iIndex].g_flRandomInterval = 5.0;
			g_esTank[iIndex].g_flTransformDelay = 10.0;
			g_esTank[iIndex].g_flTransformDuration = 10.0;
			g_esTank[iIndex].g_iSpawnMode = 0;
			g_esTank[iIndex].g_iPropsAttached = 126;
			g_esTank[iIndex].g_iBodyEffects = 0;
			g_esTank[iIndex].g_iRockEffects = 0;
			g_esTank[iIndex].g_iRockModel = 2;
			g_esTank[iIndex].g_flClawDamage = -1.0;
			g_esTank[iIndex].g_iExtraHealth = 0;
			g_esTank[iIndex].g_flRockDamage = -1.0;
			g_esTank[iIndex].g_flRunSpeed = -1.0;
			g_esTank[iIndex].g_flThrowInterval = -1.0;
			g_esTank[iIndex].g_iBulletImmunity = 0;
			g_esTank[iIndex].g_iExplosiveImmunity = 0;
			g_esTank[iIndex].g_iFireImmunity = 0;
			g_esTank[iIndex].g_iMeleeImmunity = 0;

			for (int iPos = 0; iPos < sizeof(esTank::g_iTransformType); iPos++)
			{
				g_esTank[iIndex].g_iTransformType[iPos] = iPos + 1;

				if (iPos < sizeof(esTank::g_flPropsChance))
				{
					g_esTank[iIndex].g_flPropsChance[iPos] = 33.3;
				}

				if (iPos < sizeof(esTank::g_iSkinColor))
				{
					g_esTank[iIndex].g_iSkinColor[iPos] = -1;
					g_esTank[iIndex].g_iBossHealth[iPos] = 5000 / (iPos + 1);
					g_esTank[iIndex].g_iBossType[iPos] = iPos + 2;
					g_esTank[iIndex].g_iLightColor[iPos] = -1;
					g_esTank[iIndex].g_iOzTankColor[iPos] = -1;
					g_esTank[iIndex].g_iFlameColor[iPos] = -1;
					g_esTank[iIndex].g_iRockColor[iPos] = -1;
					g_esTank[iIndex].g_iTireColor[iPos] = -1;
					g_esTank[iIndex].g_iPropTankColor[iPos] = -1;
				}

				if (iPos < sizeof(esTank::g_iGlowColor))
				{
					g_esTank[iIndex].g_iGlowColor[iPos] = -1;
				}
			}
		}
	}

	if (g_esGeneral.g_iConfigMode == 3)
	{
		for (int iPlayer = 1; iPlayer <= MaxClients; iPlayer++)
		{
			if (bIsValidClient(iPlayer, MT_CHECK_INGAME|MT_CHECK_INKICKQUEUE|MT_CHECK_FAKECLIENT))
			{
				g_esPlayer[iPlayer].g_sTankName[0] = '\0';
				g_esPlayer[iPlayer].g_iTankNote = 0;
				g_esPlayer[iPlayer].g_iAnnounceArrival = 0;
				g_esPlayer[iPlayer].g_iAnnounceDeath = 0;
				g_esPlayer[iPlayer].g_iDeathRevert = 0;
				g_esPlayer[iPlayer].g_iDetectPlugins = 0;
				g_esPlayer[iPlayer].g_iDisplayHealth = 0;
				g_esPlayer[iPlayer].g_iDisplayHealthType = 0;
				g_esPlayer[iPlayer].g_sHealthCharacters[0] = '\0';
				g_esPlayer[iPlayer].g_iMultiHealth = 0;
				g_esPlayer[iPlayer].g_iRenamePlayers = 0;
				g_esPlayer[iPlayer].g_iGlowEnabled = 0;
				g_esPlayer[iPlayer].g_iGlowFlashing = 0;
				g_esPlayer[iPlayer].g_iGlowMinRange = 0;
				g_esPlayer[iPlayer].g_iGlowMaxRange = 0;
				g_esPlayer[iPlayer].g_iGlowType = 0;
				g_esPlayer[iPlayer].g_iFavoriteType = 0;
				g_esPlayer[iPlayer].g_iAccessFlags = 0;
				g_esPlayer[iPlayer].g_iImmunityFlags = 0;
				g_esPlayer[iPlayer].g_iBossStages = 0;
				g_esPlayer[iPlayer].g_iRandomTank = 0;
				g_esPlayer[iPlayer].g_flRandomInterval = 0.0;
				g_esPlayer[iPlayer].g_flTransformDelay = 0.0;
				g_esPlayer[iPlayer].g_flTransformDuration = 0.0;
				g_esPlayer[iPlayer].g_iPropsAttached = 0;
				g_esPlayer[iPlayer].g_iBodyEffects = 0;
				g_esPlayer[iPlayer].g_iRockEffects = 0;
				g_esPlayer[iPlayer].g_iRockModel = 0;
				g_esPlayer[iPlayer].g_flClawDamage = -1.0;
				g_esPlayer[iPlayer].g_iExtraHealth = 0;
				g_esPlayer[iPlayer].g_flRockDamage = -1.0;
				g_esPlayer[iPlayer].g_flRunSpeed = -1.0;
				g_esPlayer[iPlayer].g_flThrowInterval = -1.0;
				g_esPlayer[iPlayer].g_iBulletImmunity = 0;
				g_esPlayer[iPlayer].g_iExplosiveImmunity = 0;
				g_esPlayer[iPlayer].g_iFireImmunity = 0;
				g_esPlayer[iPlayer].g_iMeleeImmunity = 0;

				for (int iPos = 0; iPos < sizeof(esPlayer::g_iTransformType); iPos++)
				{
					g_esPlayer[iPlayer].g_iTransformType[iPos] = 0;

					if (iPos < sizeof(esPlayer::g_flPropsChance))
					{
						g_esPlayer[iPlayer].g_flPropsChance[iPos] = 0.0;
					}

					if (iPos < sizeof(esPlayer::g_iSkinColor))
					{
						g_esPlayer[iPlayer].g_iSkinColor[iPos] = -1;
						g_esPlayer[iPlayer].g_iBossHealth[iPos] = 0;
						g_esPlayer[iPlayer].g_iBossType[iPos] = 0;
						g_esPlayer[iPlayer].g_iLightColor[iPos] = -1;
						g_esPlayer[iPlayer].g_iOzTankColor[iPos] = -1;
						g_esPlayer[iPlayer].g_iFlameColor[iPos] = -1;
						g_esPlayer[iPlayer].g_iRockColor[iPos] = -1;
						g_esPlayer[iPlayer].g_iTireColor[iPos] = -1;
						g_esPlayer[iPlayer].g_iPropTankColor[iPos] = -1;
					}

					if (iPos < sizeof(esPlayer::g_iGlowColor))
					{
						g_esPlayer[iPlayer].g_iGlowColor[iPos] = -1;
					}
				}

				for (int iIndex = g_esGeneral.g_iMinType; iIndex <= g_esGeneral.g_iMaxType; iIndex++)
				{
					g_esAdmin[iIndex].g_iAccessFlags[iPlayer] = 0;
					g_esAdmin[iIndex].g_iImmunityFlags[iPlayer] = 0;
				}
			}
		}

		if (g_esGeneral.g_alAdmins == null)
		{
			g_esGeneral.g_alAdmins = new ArrayList(ByteCountToCells(PLATFORM_MAX_PATH));
		}
	}

	Call_StartForward(g_esGeneral.g_gfConfigsLoadForward);
	Call_PushCell(g_esGeneral.g_iConfigMode);
	Call_Finish();
}

public SMCResult SMCNewSection(SMCParser smc, const char[] name, bool opt_quotes)
{
	if (g_esGeneral.g_iIgnoreLevel)
	{
		g_esGeneral.g_iIgnoreLevel++;

		return SMCParse_Continue;
	}

	if (g_esGeneral.g_csState == ConfigState_None)
	{
		if (StrEqual(name, "MutantTanks", false) || StrEqual(name, "Mutant Tanks", false) || StrEqual(name, "Mutant_Tanks", false) || StrEqual(name, "MT", false))
		{
			g_esGeneral.g_csState = ConfigState_Start;
		}
		else
		{
			g_esGeneral.g_iIgnoreLevel++;
		}
	}
	else if (g_esGeneral.g_csState == ConfigState_Start)
	{
		if (StrEqual(name, "PluginSettings", false) || StrEqual(name, "Plugin Settings", false) || StrEqual(name, "Plugin_Settings", false) || StrEqual(name, "settings", false))
		{
			g_esGeneral.g_bSettingsFound = true;
			g_esGeneral.g_csState = ConfigState_Settings;

			strcopy(g_esGeneral.g_sCurrentSection, sizeof(esGeneral::g_sCurrentSection), name);
		}
		else if (StrContains(name, "Tank#", false) == 0 || StrContains(name, "Tank #", false) == 0 || StrContains(name, "Tank_#", false) == 0 || StrContains(name, "Tank", false) == 0 || name[0] == '#' || IsCharNumeric(name[0]))
		{
			static char sTankName[8][33];
			for (int iIndex = g_esGeneral.g_iMinType; iIndex <= g_esGeneral.g_iMaxType; iIndex++)
			{
				FormatEx(sTankName[0], sizeof(sTankName[]), "Tank#%i", iIndex);
				FormatEx(sTankName[1], sizeof(sTankName[]), "Tank #%i", iIndex);
				FormatEx(sTankName[2], sizeof(sTankName[]), "Tank_#%i", iIndex);
				FormatEx(sTankName[3], sizeof(sTankName[]), "Tank%i", iIndex);
				FormatEx(sTankName[4], sizeof(sTankName[]), "Tank %i", iIndex);
				FormatEx(sTankName[5], sizeof(sTankName[]), "Tank_%i", iIndex);
				FormatEx(sTankName[6], sizeof(sTankName[]), "#%i", iIndex);
				FormatEx(sTankName[7], sizeof(sTankName[]), "%i", iIndex);

				for (int iType = 0; iType < sizeof(sTankName); iType++)
				{
					if (StrEqual(name, sTankName[iType], false))
					{
						g_esGeneral.g_csState = ConfigState_Type;

						strcopy(g_esGeneral.g_sCurrentSection, sizeof(esGeneral::g_sCurrentSection), name);
					}
				}
			}
		}
		else if (StrContains(name, "STEAM_", false) == 0 || strncmp("0:", name, 2) == 0 || strncmp("1:", name, 2) == 0 || (!strncmp(name, "[U:", 3) && name[strlen(name) - 1] == ']'))
		{
			g_esGeneral.g_csState = ConfigState_Admin;

			strcopy(g_esGeneral.g_sCurrentSection, sizeof(esGeneral::g_sCurrentSection), name);

			if (g_esGeneral.g_alAdmins != null)
			{
				static int iAdminSize;
				iAdminSize = (g_esGeneral.g_alAdmins.Length > 0) ? g_esGeneral.g_alAdmins.Length : 0;
				if (iAdminSize > 0)
				{
					static bool bAdd;
					bAdd = true;
					static char sAdmin[32];
					for (int iPos = 0; iPos < iAdminSize; iPos++)
					{
						g_esGeneral.g_alAdmins.GetString(iPos, sAdmin, sizeof(sAdmin));
						if (StrEqual(name, sAdmin, false))
						{
							bAdd = false;

							break;
						}
					}

					if (bAdd)
					{
						g_esGeneral.g_alAdmins.PushString(name);
					}
				}
				else
				{
					g_esGeneral.g_alAdmins.PushString(name);
				}
			}
		}
		else
		{
			g_esGeneral.g_iIgnoreLevel++;
		}
	}
	else if (g_esGeneral.g_csState == ConfigState_Settings || g_esGeneral.g_csState == ConfigState_Type || g_esGeneral.g_csState == ConfigState_Admin)
	{
		g_esGeneral.g_csState = ConfigState_Specific;

		strcopy(g_esGeneral.g_sCurrentSubSection, sizeof(esGeneral::g_sCurrentSubSection), name);
	}
	else
	{
		g_esGeneral.g_iIgnoreLevel++;
	}

	return SMCParse_Continue;
}

public SMCResult SMCKeyValues(SMCParser smc, const char[] key, const char[] value, bool key_quotes, bool value_quotes)
{
	if (g_esGeneral.g_iIgnoreLevel)
	{
		return SMCParse_Continue;
	}

	if (g_esGeneral.g_csState == ConfigState_Specific && value[0] != '\0')
	{
		static char sRange[3][10], sValue[50], sSet[10][6], sTankName[8][33];
		if (g_esGeneral.g_iConfigMode < 3 && (StrEqual(g_esGeneral.g_sCurrentSection, "PluginSettings", false) || StrEqual(g_esGeneral.g_sCurrentSection, "Plugin Settings", false) || StrEqual(g_esGeneral.g_sCurrentSection, "Plugin_Settings", false) || StrEqual(g_esGeneral.g_sCurrentSection, "settings", false)))
		{
			g_esGeneral.g_iPluginEnabled = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "General", "General", "General", "General", key, "PluginEnabled", "Plugin Enabled", "Plugin_Enabled", "enabled", g_esGeneral.g_iPluginEnabled, value, 0, 1);
			g_esGeneral.g_iAnnounceArrival = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "General", "General", "General", "General", key, "AnnounceArrival", "Announce Arrival", "Announce_Arrival", "arrival", g_esGeneral.g_iAnnounceArrival, value, 0, 31);
			g_esGeneral.g_iAnnounceDeath = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "General", "General", "General", "General", key, "AnnounceDeath", "Announce Death", "Announce_Death", "death", g_esGeneral.g_iAnnounceDeath, value, 0, 1);
			g_esGeneral.g_iBaseHealth = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "General", "General", "General", "General", key, "BaseHealth", "Base Health", "Base_Health", "health", g_esGeneral.g_iBaseHealth, value, 0, MT_MAXHEALTH);
			g_esGeneral.g_iDeathRevert = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "General", "General", "General", "General", key, "DeathRevert", "Death Revert", "Death_Revert", "revert", g_esGeneral.g_iDeathRevert, value, 0, 1);
			g_esGeneral.g_iDetectPlugins = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "General", "General", "General", "General", key, "DetectPlugins", "Detect Plugins", "Detect_Plugins", "detect", g_esGeneral.g_iDetectPlugins, value, 0, 1);
			g_esGeneral.g_iDisplayHealth = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "General", "General", "General", "General", key, "DisplayHealth", "Display Health", "Display_Health", "displayhp", g_esGeneral.g_iDisplayHealth, value, 0, 11);
			g_esGeneral.g_iDisplayHealthType = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "General", "General", "General", "General", key, "DisplayHealthType", "Display Health Type", "Display_Health_Type", "displaytype", g_esGeneral.g_iDisplayHealthType, value, 0, 2);
			g_esGeneral.g_iFinalesOnly = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "General", "General", "General", "General", key, "FinalesOnly", "Finales Only", "Finales_Only", "finale", g_esGeneral.g_iFinalesOnly, value, 0, 2);
			g_esGeneral.g_iMultiHealth = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "General", "General", "General", "General", key, "MultiplyHealth", "Multiply Health", "Multiply_Health", "multihp", g_esGeneral.g_iMultiHealth, value, 0, 3);
			g_esGeneral.g_iHumanCooldown = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "HumanSupport", "Human Support", "Human_Support", "human", key, "HumanCooldown", "Human Cooldown", "Human_Cooldown", "cooldown", g_esGeneral.g_iHumanCooldown, value, 0, 999999);
			g_esGeneral.g_iMasterControl = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "HumanSupport", "Human Support", "Human_Support", "human", key, "MasterControl", "Master Control", "Master_Control", "master", g_esGeneral.g_iMasterControl, value, 0, 1);
			g_esGeneral.g_iRenamePlayers = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "HumanSupport", "Human Support", "Human_Support", "human", key, "RenamePlayers", "Rename Players", "Rename_Players", "rename", g_esGeneral.g_iRenamePlayers, value, 0, 1);
			g_esGeneral.g_iSpawnMode = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "HumanSupport", "Human Support", "Human_Support", "human", key, "SpawnMode", "Spawn Mode", "Spawn_Mode", "spawnmode", g_esGeneral.g_iSpawnMode, value, 0, 1);
			g_esGeneral.g_iRegularAmount = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Waves", "Waves", "Waves", "Waves", key, "RegularAmount", "Regular Amount", "Regular_Amount", "regamount", g_esGeneral.g_iRegularAmount, value, 0, 16);
			g_esGeneral.g_flRegularInterval = flGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Waves", "Waves", "Waves", "Waves", key, "RegularInterval", "Regular Interval", "Regular_Interval", "reginterval", g_esGeneral.g_flRegularInterval, value, 0.1, 999999.0);
			g_esGeneral.g_iRegularLimit = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Waves", "Waves", "Waves", "Waves", key, "RegularLimit", "Regular Limit", "Regular_Limit", "reglimit", g_esGeneral.g_iRegularLimit, value, 0, 999999);
			g_esGeneral.g_iRegularMode = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Waves", "Waves", "Waves", "Waves", key, "RegularMode", "Regular Mode", "Regular_Mode", "regmode", g_esGeneral.g_iRegularMode, value, 0, 1);
			g_esGeneral.g_iRegularWave = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Waves", "Waves", "Waves", "Waves", key, "RegularWave", "Regular Wave", "Regular_Wave", "regwave", g_esGeneral.g_iRegularWave, value, 0, 1);

			if (StrEqual(g_esGeneral.g_sCurrentSubSection, "General", false))
			{
				if (StrEqual(key, "HealthCharacters", false) || StrEqual(key, "Health Characters", false) || StrEqual(key, "Health_Characters", false) || StrEqual(key, "hpchars", false))
				{
					strcopy(g_esGeneral.g_sHealthCharacters, sizeof(esGeneral::g_sHealthCharacters), value);
				}
				else if (StrEqual(key, "TypeRange", false) || StrEqual(key, "Type Range", false) || StrEqual(key, "Type_Range", false) || StrEqual(key, "types", false))
				{
					strcopy(sValue, sizeof(sValue), value);
					ReplaceString(sValue, sizeof(sValue), " ", "");
					ExplodeString(sValue, "-", sRange, sizeof(sRange), sizeof(sRange[]));

					g_esGeneral.g_iMinType = (sRange[0][0] != '\0') ? iClamp(StringToInt(sRange[0]), 1, MT_MAXTYPES) : g_esGeneral.g_iMinType;
					g_esGeneral.g_iMaxType = (sRange[1][0] != '\0') ? iClamp(StringToInt(sRange[1]), 1, MT_MAXTYPES) : g_esGeneral.g_iMaxType;
				}
			}

			if ((StrEqual(g_esGeneral.g_sCurrentSubSection, "Administration", false) || StrEqual(g_esGeneral.g_sCurrentSubSection, "admin", false)))
			{
				g_esGeneral.g_iAllowDeveloper = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Administration", "Administration", "Administration", "admin", key, "AllowDeveloper", "Allow Developer", "Allow_Developer", "developer", g_esGeneral.g_iAllowDeveloper, value, 0, 1);

				if (StrEqual(key, "AccessFlags", false) || StrEqual(key, "Access Flags", false) || StrEqual(key, "Access_Flags", false) || StrEqual(key, "access", false))
				{
					g_esGeneral.g_iAccessFlags = ReadFlagString(value);
				}
				else if (StrEqual(key, "ImmunityFlags", false) || StrEqual(key, "Immunity Flags", false) || StrEqual(key, "Immunity_Flags", false) || StrEqual(key, "immunity", false))
				{
					g_esGeneral.g_iImmunityFlags = ReadFlagString(value);
				}
			}

			if (StrEqual(g_esGeneral.g_sCurrentSubSection, "Waves", false))
			{
				if (StrEqual(key, "RegularType", false) || StrEqual(key, "Regular Type", false) || StrEqual(key, "Regular_Type", false) || StrEqual(key, "regtype", false))
				{
					strcopy(sValue, sizeof(sValue), value);
					ReplaceString(sValue, sizeof(sValue), " ", "");
					ExplodeString(sValue, "-", sRange, sizeof(sRange), sizeof(sRange[]));

					g_esGeneral.g_iRegularMinType = (sRange[0][0] != '\0') ? iClamp(StringToInt(sRange[0]), 0, g_esGeneral.g_iMaxType) : g_esGeneral.g_iRegularMinType;
					g_esGeneral.g_iRegularMaxType = (sRange[1][0] != '\0') ? iClamp(StringToInt(sRange[1]), 0, g_esGeneral.g_iMaxType) : g_esGeneral.g_iRegularMaxType;
				}
				else if (StrEqual(key, "FinaleTypes", false) || StrEqual(key, "Finale Types", false) || StrEqual(key, "Finale_Types", false) || StrEqual(key, "fintypes", false))
				{
					strcopy(sValue, sizeof(sValue), value);
					ReplaceString(sValue, sizeof(sValue), " ", "");
					ExplodeString(sValue, ",", sRange, sizeof(sRange), sizeof(sRange[]));

					for (int iPos = 0; iPos < sizeof(sRange); iPos++)
					{
						if (sRange[iPos][0] == '\0')
						{
							continue;
						}

						ExplodeString(sRange[iPos], "-", sSet, sizeof(sSet), sizeof(sSet[]));

						g_esGeneral.g_iFinaleMinTypes[iPos] = (sSet[0][0] != '\0') ? iClamp(StringToInt(sSet[0]), 0, g_esGeneral.g_iMaxType) : g_esGeneral.g_iFinaleMinTypes[iPos];
						g_esGeneral.g_iFinaleMaxTypes[iPos] = (sSet[1][0] != '\0') ? iClamp(StringToInt(sSet[1]), 0, g_esGeneral.g_iMaxType) : g_esGeneral.g_iFinaleMaxTypes[iPos];
					}
				}
				else if (StrEqual(key, "FinaleWaves", false) || StrEqual(key, "Finale Waves", false) || StrEqual(key, "Finale_Waves", false) || StrEqual(key, "finwaves", false))
				{
					strcopy(sValue, sizeof(sValue), value);
					ReplaceString(sValue, sizeof(sValue), " ", "");
					ExplodeString(sValue, ",", sSet, sizeof(sSet), sizeof(sSet[]));

					for (int iPos = 0; iPos < sizeof(esGeneral::g_iFinaleWave); iPos++)
					{
						g_esGeneral.g_iFinaleWave[iPos] = (sSet[iPos][0] != '\0') ? iClamp(StringToInt(sSet[iPos]), 0, 16) : g_esGeneral.g_iFinaleWave[iPos];
					}
				}
			}

			if (g_esGeneral.g_iConfigMode == 1)
			{
				g_esGeneral.g_iGameModeTypes = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "GameModes", "Game Modes", "Game_Modes", "modes", key, "GameModeTypes", "Game Mode Types", "Game_Mode_Types", "types", g_esGeneral.g_iGameModeTypes, value, 0, 15);
				g_esGeneral.g_iConfigEnable = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Custom", "Custom", "Custom", "Custom", key, "EnableCustomConfigs", "Enable Custom Configs", "Enable_Custom_Configs", "enabled", g_esGeneral.g_iConfigEnable, value, 0, 1);
				g_esGeneral.g_iConfigCreate = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Custom", "Custom", "Custom", "Custom", key, "CreateConfigTypes", "Create Config Types", "Create_Config_Types", "create", g_esGeneral.g_iConfigCreate, value, 0, 31);
				g_esGeneral.g_iConfigExecute = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Custom", "Custom", "Custom", "Custom", key, "ExecuteConfigTypes", "Execute Config Types", "Execute_Config_Types", "execute", g_esGeneral.g_iConfigExecute, value, 0, 31);

				if (StrEqual(g_esGeneral.g_sCurrentSubSection, "GameModes", false) || StrEqual(g_esGeneral.g_sCurrentSubSection, "Game Modes", false) || StrEqual(g_esGeneral.g_sCurrentSubSection, "Game_Modes", false) || StrEqual(g_esGeneral.g_sCurrentSubSection, "modes", false))
				{
					if (StrEqual(key, "EnabledGameModes", false) || StrEqual(key, "Enabled Game Modes", false) || StrEqual(key, "Enabled_Game_Modes", false) || StrEqual(key, "enabled", false))
					{
						strcopy(g_esGeneral.g_sEnabledGameModes, sizeof(esGeneral::g_sEnabledGameModes), value);
					}
					else if (StrEqual(key, "DisabledGameModes", false) || StrEqual(key, "Disabled Game Modes", false) || StrEqual(key, "Disabled_Game_Modes", false) || StrEqual(key, "disabled", false))
					{
						strcopy(g_esGeneral.g_sDisabledGameModes, sizeof(esGeneral::g_sDisabledGameModes), value);
					}
				}
			}

			Call_StartForward(g_esGeneral.g_gfConfigsLoadedForward);
			Call_PushString(g_esGeneral.g_sCurrentSubSection);
			Call_PushString(key);
			Call_PushString(value);
			Call_PushCell(0);
			Call_PushCell(-1);
			Call_PushCell(g_esGeneral.g_iConfigMode);
			Call_Finish();
		}
		else if (g_esGeneral.g_iConfigMode < 3 && (StrContains(g_esGeneral.g_sCurrentSection, "Tank#", false) == 0 || StrContains(g_esGeneral.g_sCurrentSection, "Tank #", false) == 0 || StrContains(g_esGeneral.g_sCurrentSection, "Tank_#", false) == 0 || StrContains(g_esGeneral.g_sCurrentSection, "Tank", false) == 0 || g_esGeneral.g_sCurrentSection[0] == '#' || IsCharNumeric(g_esGeneral.g_sCurrentSection[0])))
		{
			for (int iIndex = g_esGeneral.g_iMinType; iIndex <= g_esGeneral.g_iMaxType; iIndex++)
			{
				FormatEx(sTankName[0], sizeof(sTankName[]), "Tank#%i", iIndex);
				FormatEx(sTankName[1], sizeof(sTankName[]), "Tank #%i", iIndex);
				FormatEx(sTankName[2], sizeof(sTankName[]), "Tank_#%i", iIndex);
				FormatEx(sTankName[3], sizeof(sTankName[]), "Tank%i", iIndex);
				FormatEx(sTankName[4], sizeof(sTankName[]), "Tank %i", iIndex);
				FormatEx(sTankName[5], sizeof(sTankName[]), "Tank_%i", iIndex);
				FormatEx(sTankName[6], sizeof(sTankName[]), "#%i", iIndex);
				FormatEx(sTankName[7], sizeof(sTankName[]), "%i", iIndex);

				for (int iType = 0; iType < sizeof(sTankName); iType++)
				{
					if (StrEqual(g_esGeneral.g_sCurrentSection, sTankName[iType], false))
					{
						g_esTank[iIndex].g_iTankEnabled = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "General", "General", "General", "General", key, "TankEnabled", "Tank Enabled", "Tank_Enabled", "enabled", g_esTank[iIndex].g_iTankEnabled, value, 0, 1);
						g_esTank[iIndex].g_flTankChance = flGetKeyValue(g_esGeneral.g_sCurrentSubSection, "General", "General", "General", "General", key, "TankChance", "Tank Chance", "Tank_Chance", "chance", g_esTank[iIndex].g_flTankChance, value, 0.0, 100.0);
						g_esTank[iIndex].g_iTankNote = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "General", "General", "General", "General", key, "TankNote", "Tank Note", "Tank_Note", "note", g_esTank[iIndex].g_iTankNote, value, 0, 1);
						g_esTank[iIndex].g_iSpawnEnabled = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "General", "General", "General", "General", key, "SpawnEnabled", "Spawn Enabled", "Spawn_Enabled", "spawn", g_esTank[iIndex].g_iSpawnEnabled, value, 0, 1);
						g_esTank[iIndex].g_iMenuEnabled = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "General", "General", "General", "General", key, "MenuEnabled", "Menu Enabled", "Menu_Enabled", "menu", g_esTank[iIndex].g_iMenuEnabled, value, 0, 1);
						g_esTank[iIndex].g_iAnnounceArrival = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "General", "General", "General", "General", key, "AnnounceArrival", "Announce Arrival", "Announce_Arrival", "arrival", g_esTank[iIndex].g_iAnnounceArrival, value, 0, 31);
						g_esTank[iIndex].g_iAnnounceDeath = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "General", "General", "General", "General", key, "AnnounceDeath", "Announce Death", "Announce_Death", "death", g_esTank[iIndex].g_iAnnounceDeath, value, 0, 1);
						g_esTank[iIndex].g_iDeathRevert = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "General", "General", "General", "General", key, "DeathRevert", "Death Revert", "Death_Revert", "revert", g_esTank[iIndex].g_iDeathRevert, value, 0, 1);
						g_esTank[iIndex].g_iDetectPlugins = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "General", "General", "General", "General", key, "DetectPlugins", "Detect Plugins", "Detect_Plugins", "detect", g_esTank[iIndex].g_iDetectPlugins, value, 0, 1);
						g_esTank[iIndex].g_iDisplayHealth = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "General", "General", "General", "General", key, "DisplayHealth", "Display Health", "Display_Health", "displayhp", g_esTank[iIndex].g_iDisplayHealth, value, 0, 11);
						g_esTank[iIndex].g_iDisplayHealthType = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "General", "General", "General", "General", key, "DisplayHealthType", "Display Health Type", "Display_Health_Type", "displaytype", g_esTank[iIndex].g_iDisplayHealthType, value, 0, 2);
						g_esTank[iIndex].g_iMultiHealth = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "General", "General", "General", "General", key, "MultiplyHealth", "Multiply Health", "Multiply_Health", "multihp", g_esTank[iIndex].g_iMultiHealth, value, 0, 3);
						g_esTank[iIndex].g_iHumanSupport = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "HumanSupport", "Human Support", "Human_Support", "human", key, "HumanSupport", "Human Support", "Human_Support", "human", g_esTank[iIndex].g_iHumanSupport, value, 0, 2);
						g_esTank[iIndex].g_iRenamePlayers = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "HumanSupport", "Human Support", "Human_Support", "human", key, "RenamePlayers", "Rename Players", "Rename_Players", "rename", g_esTank[iIndex].g_iRenamePlayers, value, 0, 1);
						g_esTank[iIndex].g_iGlowEnabled = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "General", "General", "General", "General", key, "GlowEnabled", "Glow Enabled", "Glow_Enabled", "glow", g_esTank[iIndex].g_iGlowEnabled, value, 0, 1);
						g_esTank[iIndex].g_iGlowFlashing = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "General", "General", "General", "General", key, "GlowFlashing", "Glow Flashing", "Glow_Flashing", "glowflashing", g_esTank[iIndex].g_iGlowFlashing, value, 0, 1);
						g_esTank[iIndex].g_iGlowType = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "General", "General", "General", "General", key, "GlowType", "Glow Type", "Glow_Type", "glowtype", g_esTank[iIndex].g_iGlowType, value, 0, 1);
						g_esTank[iIndex].g_iTypeLimit = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Spawn", "Spawn", "Spawn", "Spawn", key, "TypeLimit", "Type Limit", "Type_Limit", "limit", g_esTank[iIndex].g_iTypeLimit, value, 0, 16);
						g_esTank[iIndex].g_iFinaleTank = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Spawn", "Spawn", "Spawn", "Spawn", key, "FinaleTank", "Finale Tank", "Finale_Tank", "finale", g_esTank[iIndex].g_iFinaleTank, value, 0, 2);
						g_esTank[iIndex].g_iBossStages = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Spawn", "Spawn", "Spawn", "Spawn", key, "BossStages", "Boss Stages", "Boss_Stages", "stages", g_esTank[iIndex].g_iBossStages, value, 1, 4);
						g_esTank[iIndex].g_iRandomTank = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Spawn", "Spawn", "Spawn", "Spawn", key, "RandomTank", "Random Tank", "Random_Tank", "random", g_esTank[iIndex].g_iRandomTank, value, 0, 1);
						g_esTank[iIndex].g_flRandomInterval = flGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Spawn", "Spawn", "Spawn", "Spawn", key, "RandomInterval", "Random Interval", "Random_Interval", "randinterval", g_esTank[iIndex].g_flRandomInterval, value, 0.1, 999999.0);
						g_esTank[iIndex].g_flTransformDelay = flGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Spawn", "Spawn", "Spawn", "Spawn", key, "TransformDelay", "Transform Delay", "Transform_Delay", "transdelay", g_esTank[iIndex].g_flTransformDelay, value, 0.1, 999999.0);
						g_esTank[iIndex].g_flTransformDuration = flGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Spawn", "Spawn", "Spawn", "Spawn", key, "TransformDuration", "Transform Duration", "Transform_Duration", "transduration", g_esTank[iIndex].g_flTransformDuration, value, 0.1, 999999.0);
						g_esTank[iIndex].g_iSpawnMode = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Spawn", "Spawn", "Spawn", "Spawn", key, "SpawnMode", "Spawn Mode", "Spawn_Mode", "mode", g_esTank[iIndex].g_iSpawnMode, value, 0, 3);
						g_esTank[iIndex].g_iRockModel = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Props", "Props", "Props", "Props", key, "RockModel", "Rock Model", "Rock_Model", "rockmodel", g_esTank[iIndex].g_iRockModel, value, 0, 2);
						g_esTank[iIndex].g_iPropsAttached = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Props", "Props", "Props", "Props", key, "PropsAttached", "Props Attached", "Props_Attached", "attached", g_esTank[iIndex].g_iPropsAttached, value, 0, 127);
						g_esTank[iIndex].g_iBodyEffects = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Particles", "Particles", "Particles", "Particles", key, "BodyEffects", "Body Effects", "Body_Effects", "body", g_esTank[iIndex].g_iBodyEffects, value, 0, 127);
						g_esTank[iIndex].g_iRockEffects = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Particles", "Particles", "Particles", "Particles", key, "RockEffects", "Rock Effects", "Rock_Effects", "rock", g_esTank[iIndex].g_iRockEffects, value, 0, 15);
						g_esTank[iIndex].g_flClawDamage = flGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Enhancements", "Enhancements", "Enhancements", "enhance", key, "ClawDamage", "Claw Damage", "Claw_Damage", "claw", g_esTank[iIndex].g_flClawDamage, value, -1.0, 999999.0);
						g_esTank[iIndex].g_iExtraHealth = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Enhancements", "Enhancements", "Enhancements", "enhance", key, "ExtraHealth", "Extra Health", "Extra_Health", "health", g_esTank[iIndex].g_iExtraHealth, value, MT_MAX_HEALTH_REDUCTION, MT_MAXHEALTH);
						g_esTank[iIndex].g_flRockDamage = flGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Enhancements", "Enhancements", "Enhancements", "enhance", key, "RockDamage", "Rock Damage", "Rock_Damage", "rock", g_esTank[iIndex].g_flRockDamage, value, -1.0, 999999.0);
						g_esTank[iIndex].g_flRunSpeed = flGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Enhancements", "Enhancements", "Enhancements", "enhance", key, "RunSpeed", "Run Speed", "Run_Speed", "speed", g_esTank[iIndex].g_flRunSpeed, value, -1.0, 3.0);
						g_esTank[iIndex].g_flThrowInterval = flGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Enhancements", "Enhancements", "Enhancements", "enhance", key, "ThrowInterval", "Throw Interval", "Throw_Interval", "throw", g_esTank[iIndex].g_flThrowInterval, value, -1.0, 999999.0);
						g_esTank[iIndex].g_iBulletImmunity = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Immunities", "Immunities", "Immunities", "Immunities", key, "BulletImmunity", "Bullet Immunity", "Bullet_Immunity", "bullet", g_esTank[iIndex].g_iBulletImmunity, value, 0, 1);
						g_esTank[iIndex].g_iExplosiveImmunity = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Immunities", "Immunities", "Immunities", "Immunities", key, "ExplosiveImmunity", "Explosive Immunity", "Explosive_Immunity", "explosive", g_esTank[iIndex].g_iExplosiveImmunity, value, 0, 1);
						g_esTank[iIndex].g_iFireImmunity = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Immunities", "Immunities", "Immunities", "Immunities", key, "FireImmunity", "Fire Immunity", "Fire_Immunity", "fire", g_esTank[iIndex].g_iFireImmunity, value, 0, 1);
						g_esTank[iIndex].g_iMeleeImmunity = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Immunities", "Immunities", "Immunities", "Immunities", key, "MeleeImmunity", "Melee Immunity", "Melee_Immunity", "melee", g_esTank[iIndex].g_iMeleeImmunity, value, 0, 1);

						if (StrEqual(g_esGeneral.g_sCurrentSubSection, "General", false))
						{
							if (StrEqual(key, "TankName", false) || StrEqual(key, "Tank Name", false) || StrEqual(key, "Tank_Name", false) || StrEqual(key, "name", false))
							{
								strcopy(g_esTank[iIndex].g_sTankName, sizeof(esTank::g_sTankName), value);
							}
							else if (StrEqual(key, "HealthCharacters", false) || StrEqual(key, "Health Characters", false) || StrEqual(key, "Health_Characters", false) || StrEqual(key, "hpchars", false))
							{
								strcopy(g_esTank[iIndex].g_sHealthCharacters, sizeof(esTank::g_sHealthCharacters), value);
							}
							else if (StrEqual(key, "SkinColor", false) || StrEqual(key, "Skin Color", false) || StrEqual(key, "Skin_Color", false) || StrEqual(key, "skin", false))
							{
								strcopy(sValue, sizeof(sValue), value);
								ReplaceString(sValue, sizeof(sValue), " ", "");
								ExplodeString(sValue, ",", sSet, sizeof(sSet), sizeof(sSet[]));

								for (int iPos = 0; iPos < sizeof(esTank::g_iSkinColor); iPos++)
								{
									g_esTank[iIndex].g_iSkinColor[iPos] = (sSet[iPos][0] != '\0' && StringToInt(sSet[iPos]) >= 0) ? iClamp(StringToInt(sSet[iPos]), 0, 255) : GetRandomInt(0, 255);
								}
							}
							else if (StrEqual(key, "GlowColor", false) || StrEqual(key, "Glow Color", false) || StrEqual(key, "Glow_Color", false))
							{
								strcopy(sValue, sizeof(sValue), value);
								ReplaceString(sValue, sizeof(sValue), " ", "");
								ExplodeString(sValue, ",", sSet, sizeof(sSet), sizeof(sSet[]));

								for (int iPos = 0; iPos < sizeof(esTank::g_iGlowColor); iPos++)
								{
									g_esTank[iIndex].g_iGlowColor[iPos] = (sSet[iPos][0] != '\0' && StringToInt(sSet[iPos]) >= 0) ? iClamp(StringToInt(sSet[iPos]), 0, 255) : GetRandomInt(0, 255);
								}
							}
							else if (StrEqual(key, "GlowRange", false) || StrEqual(key, "Glow Range", false) || StrEqual(key, "Glow_Range", false))
							{
								strcopy(sValue, sizeof(sValue), value);
								ReplaceString(sValue, sizeof(sValue), " ", "");
								ExplodeString(sValue, "-", sRange, sizeof(sRange), sizeof(sRange[]));

								g_esTank[iIndex].g_iGlowMinRange = (sRange[0][0] != '\0') ? iClamp(StringToInt(sRange[0]), 0, 999999) : g_esTank[iIndex].g_iGlowMinRange;
								g_esTank[iIndex].g_iGlowMaxRange = (sRange[1][0] != '\0') ? iClamp(StringToInt(sRange[1]), 0, 999999) : g_esTank[iIndex].g_iGlowMaxRange;
							}
						}

						if ((StrEqual(g_esGeneral.g_sCurrentSubSection, "Administration", false) || StrEqual(g_esGeneral.g_sCurrentSubSection, "admin", false)))
						{
							if (StrEqual(key, "AccessFlags", false) || StrEqual(key, "Access Flags", false) || StrEqual(key, "Access_Flags", false) || StrEqual(key, "access", false))
							{
								g_esTank[iIndex].g_iAccessFlags = ReadFlagString(value);
							}
							else if (StrEqual(key, "ImmunityFlags", false) || StrEqual(key, "Immunity Flags", false) || StrEqual(key, "Immunity_Flags", false) || StrEqual(key, "immunity", false))
							{
								g_esTank[iIndex].g_iImmunityFlags = ReadFlagString(value);
							}
						}

						if (StrEqual(g_esGeneral.g_sCurrentSubSection, "Spawn", false))
						{
							if (StrEqual(key, "TransformTypes", false) || StrEqual(key, "Transform Types", false) || StrEqual(key, "Transform_Types", false) || StrEqual(key, "transtypes", false))
							{
								strcopy(sValue, sizeof(sValue), value);
								ReplaceString(sValue, sizeof(sValue), " ", "");
								ExplodeString(sValue, ",", sSet, sizeof(sSet), sizeof(sSet[]));

								for (int iPos = 0; iPos < sizeof(esTank::g_iTransformType); iPos++)
								{
									g_esTank[iIndex].g_iTransformType[iPos] = (sSet[iPos][0] != '\0') ? iClamp(StringToInt(sSet[iPos]), g_esGeneral.g_iMinType, g_esGeneral.g_iMaxType) : g_esTank[iIndex].g_iTransformType[iPos];
								}
							}
							else
							{
								strcopy(sValue, sizeof(sValue), value);
								ReplaceString(sValue, sizeof(sValue), " ", "");
								ExplodeString(sValue, ",", sSet, sizeof(sSet), sizeof(sSet[]));

								for (int iPos = 0; iPos < sizeof(esTank::g_iBossHealth); iPos++)
								{
									if (StrEqual(key, "BossHealthStages", false) || StrEqual(key, "Boss Health Stages", false) || StrEqual(key, "Boss_Health_Stages", false) || StrEqual(key, "healthstages", false))
									{
										g_esTank[iIndex].g_iBossHealth[iPos] = (sSet[iPos][0] != '\0') ? iClamp(StringToInt(sSet[iPos]), 1, MT_MAXHEALTH) : g_esTank[iIndex].g_iBossHealth[iPos];
									}
									else if (StrEqual(key, "BossTypes", false) || StrEqual(key, "Boss Types", false) || StrEqual(key, "Boss_Types", false))
									{
										g_esTank[iIndex].g_iBossType[iPos] = (sSet[iPos][0] != '\0') ? iClamp(StringToInt(sSet[iPos]), g_esGeneral.g_iMinType, g_esGeneral.g_iMaxType) : g_esTank[iIndex].g_iBossType[iPos];
									}
								}
							}
						}

						if (StrEqual(g_esGeneral.g_sCurrentSubSection, "Props", false))
						{
							if (StrEqual(key, "PropsChance", false) || StrEqual(key, "Props Chance", false) || StrEqual(key, "Props_Chance", false) || StrEqual(key, "chance", false))
							{
								strcopy(sValue, sizeof(sValue), value);
								ReplaceString(sValue, sizeof(sValue), " ", "");
								ExplodeString(sValue, ",", sSet, sizeof(sSet), sizeof(sSet[]));

								for (int iPos = 0; iPos < sizeof(esTank::g_flPropsChance); iPos++)
								{
									g_esTank[iIndex].g_flPropsChance[iPos] = (sSet[iPos][0] != '\0') ? flClamp(StringToFloat(sSet[iPos]), 0.0, 100.0) : g_esTank[iIndex].g_flPropsChance[iPos];
								}
							}
							else
							{
								strcopy(sValue, sizeof(sValue), value);
								ReplaceString(sValue, sizeof(sValue), " ", "");
								ExplodeString(sValue, ",", sSet, sizeof(sSet), sizeof(sSet[]));

								for (int iPos = 0; iPos < sizeof(esTank::g_iLightColor); iPos++)
								{
									if (StrEqual(key, "LightColor", false) || StrEqual(key, "Light Color", false) || StrEqual(key, "Light_Color", false) || StrEqual(key, "light", false))
									{
										g_esTank[iIndex].g_iLightColor[iPos] = (sSet[iPos][0] != '\0' && StringToInt(sSet[iPos]) >= 0) ? iClamp(StringToInt(sSet[iPos]), 0, 255) : GetRandomInt(0, 255);
									}
									else if (StrEqual(key, "OxygenTankColor", false) || StrEqual(key, "Oxygen Tank Color", false) || StrEqual(key, "Oxygen_Tank_Color", false) || StrEqual(key, "oxygen", false))
									{
										g_esTank[iIndex].g_iOzTankColor[iPos] = (sSet[iPos][0] != '\0' && StringToInt(sSet[iPos]) >= 0) ? iClamp(StringToInt(sSet[iPos]), 0, 255) : GetRandomInt(0, 255);
									}
									else if (StrEqual(key, "FlameColor", false) || StrEqual(key, "Flame Color", false) || StrEqual(key, "Flame_Color", false) || StrEqual(key, "flame", false))
									{
										g_esTank[iIndex].g_iFlameColor[iPos] = (sSet[iPos][0] != '\0' && StringToInt(sSet[iPos]) >= 0) ? iClamp(StringToInt(sSet[iPos]), 0, 255) : GetRandomInt(0, 255);
									}
									else if (StrEqual(key, "RockColor", false) || StrEqual(key, "Rock Color", false) || StrEqual(key, "Rock_Color", false) || StrEqual(key, "rock", false))
									{
										g_esTank[iIndex].g_iRockColor[iPos] = (sSet[iPos][0] != '\0' && StringToInt(sSet[iPos]) >= 0) ? iClamp(StringToInt(sSet[iPos]), 0, 255) : GetRandomInt(0, 255);
									}
									else if (StrEqual(key, "TireColor", false) || StrEqual(key, "Tire Color", false) || StrEqual(key, "Tire_Color", false) || StrEqual(key, "tire", false))
									{
										g_esTank[iIndex].g_iTireColor[iPos] = (sSet[iPos][0] != '\0' && StringToInt(sSet[iPos]) >= 0) ? iClamp(StringToInt(sSet[iPos]), 0, 255) : GetRandomInt(0, 255);
									}
									else if (StrEqual(key, "PropaneTankColor", false) || StrEqual(key, "Propane Tank Color", false) || StrEqual(key, "Propane_Tank_Color", false) || StrEqual(key, "propane", false))
									{
										g_esTank[iIndex].g_iPropTankColor[iPos] = (sSet[iPos][0] != '\0' && StringToInt(sSet[iPos]) >= 0) ? iClamp(StringToInt(sSet[iPos]), 0, 255) : GetRandomInt(0, 255);
									}
								}
							}
						}

						for (int iPos = 0; iPos < MT_MAX_ABILITIES; iPos++)
						{
							g_esTank[iIndex].g_bAbilityFound[iPos] = bHasAbility(g_esGeneral.g_sCurrentSubSection, iPos);
						}

						Call_StartForward(g_esGeneral.g_gfConfigsLoadedForward);
						Call_PushString(g_esGeneral.g_sCurrentSubSection);
						Call_PushString(key);
						Call_PushString(value);
						Call_PushCell(iIndex);
						Call_PushCell(-1);
						Call_PushCell(g_esGeneral.g_iConfigMode);
						Call_Finish();
					}
				}
			}
		}
		else if (g_esGeneral.g_iConfigMode == 3 && (StrContains(g_esGeneral.g_sCurrentSection, "STEAM_", false) == 0 || strncmp("0:", g_esGeneral.g_sCurrentSection, 2) == 0 || strncmp("1:", g_esGeneral.g_sCurrentSection, 2) == 0 || (!strncmp(g_esGeneral.g_sCurrentSection, "[U:", 3) && g_esGeneral.g_sCurrentSection[strlen(g_esGeneral.g_sCurrentSection) - 1] == ']')))
		{
			static char sSteamID32[32], sSteam3ID[32];
			for (int iPlayer = 1; iPlayer <= MaxClients; iPlayer++)
			{
				if (bIsValidClient(iPlayer, MT_CHECK_INGAME|MT_CHECK_INKICKQUEUE|MT_CHECK_FAKECLIENT))
				{
					if (GetClientAuthId(iPlayer, AuthId_Steam2, sSteamID32, sizeof(sSteamID32)) && GetClientAuthId(iPlayer, AuthId_Steam3, sSteam3ID, sizeof(sSteam3ID)))
					{
						if (StrEqual(sSteamID32, g_esGeneral.g_sCurrentSection, false) || StrEqual(sSteam3ID, g_esGeneral.g_sCurrentSection, false))
						{
							g_esPlayer[iPlayer].g_iTankNote = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "General", "General", "General", "General", key, "TankNote", "Tank Note", "Tank_Note", "note", g_esPlayer[iPlayer].g_iTankNote, value, 0, 1);
							g_esPlayer[iPlayer].g_iAnnounceArrival = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "General", "General", "General", "General", key, "AnnounceArrival", "Announce Arrival", "Announce_Arrival", "arrival", g_esPlayer[iPlayer].g_iAnnounceArrival, value, 0, 31);
							g_esPlayer[iPlayer].g_iAnnounceDeath = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "General", "General", "General", "General", key, "AnnounceDeath", "Announce Death", "Announce_Death", "death", g_esPlayer[iPlayer].g_iAnnounceDeath, value, 0, 1);
							g_esPlayer[iPlayer].g_iDeathRevert = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "General", "General", "General", "General", key, "DeathRevert", "Death Revert", "Death_Revert", "revert", g_esPlayer[iPlayer].g_iDeathRevert, value, 0, 1);
							g_esPlayer[iPlayer].g_iDetectPlugins = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "General", "General", "General", "General", key, "DetectPlugins", "Detect Plugins", "Detect_Plugins", "detect", g_esPlayer[iPlayer].g_iDetectPlugins, value, 0, 1);
							g_esPlayer[iPlayer].g_iDisplayHealth = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "General", "General", "General", "General", key, "DisplayHealth", "Display Health", "Display_Health", "displayhp", g_esPlayer[iPlayer].g_iDisplayHealth, value, 0, 11);
							g_esPlayer[iPlayer].g_iDisplayHealthType = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "General", "General", "General", "General", key, "DisplayHealthType", "Display Health Type", "Display_Health_Type", "displaytype", g_esPlayer[iPlayer].g_iDisplayHealthType, value, 0, 2);
							g_esPlayer[iPlayer].g_iMultiHealth = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "General", "General", "General", "General", key, "MultiplyHealth", "Multiply Health", "Multiply_Health", "multihp", g_esPlayer[iPlayer].g_iMultiHealth, value, 0, 3);
							g_esPlayer[iPlayer].g_iRenamePlayers = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "HumanSupport", "Human Support", "Human_Support", "human", key, "RenamePlayers", "Rename Players", "Rename_Players", "rename", g_esPlayer[iPlayer].g_iRenamePlayers, value, 0, 1);
							g_esPlayer[iPlayer].g_iGlowEnabled = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "General", "General", "General", "General", key, "GlowEnabled", "Glow Enabled", "Glow_Enabled", "glow", g_esPlayer[iPlayer].g_iGlowEnabled, value, 0, 1);
							g_esPlayer[iPlayer].g_iGlowFlashing = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "General", "General", "General", "General", key, "GlowFlashing", "Glow Flashing", "Glow_Flashing", "glowflashing", g_esPlayer[iPlayer].g_iGlowFlashing, value, 0, 1);
							g_esPlayer[iPlayer].g_iGlowType = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "General", "General", "General", "General", key, "GlowType", "Glow Type", "Glow_Type", "glowtype", g_esPlayer[iPlayer].g_iGlowType, value, 0, 1);
							g_esPlayer[iPlayer].g_iBossStages = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Spawn", "Spawn", "Spawn", "Spawn", key, "BossStages", "Boss Stages", "Boss_Stages", "stages", g_esPlayer[iPlayer].g_iBossStages, value, 1, 4);
							g_esPlayer[iPlayer].g_iRandomTank = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Spawn", "Spawn", "Spawn", "Spawn", key, "RandomTank", "Random Tank", "Random_Tank", "random", g_esPlayer[iPlayer].g_iRandomTank, value, 0, 1);
							g_esPlayer[iPlayer].g_flRandomInterval = flGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Spawn", "Spawn", "Spawn", "Spawn", key, "RandomInterval", "Random Interval", "Random_Interval", "randinterval", g_esPlayer[iPlayer].g_flRandomInterval, value, 0.1, 999999.0);
							g_esPlayer[iPlayer].g_flTransformDelay = flGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Spawn", "Spawn", "Spawn", "Spawn", key, "TransformDelay", "Transform Delay", "Transform_Delay", "transdelay", g_esPlayer[iPlayer].g_flTransformDelay, value, 0.1, 999999.0);
							g_esPlayer[iPlayer].g_flTransformDuration = flGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Spawn", "Spawn", "Spawn", "Spawn", key, "TransformDuration", "Transform Duration", "Transform_Duration", "transduration", g_esPlayer[iPlayer].g_flTransformDuration, value, 0.1, 999999.0);
							g_esPlayer[iPlayer].g_iRockModel = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Props", "Props", "Props", "Props", key, "RockModel", "Rock Model", "Rock_Model", "rockmodel", g_esPlayer[iPlayer].g_iRockModel, value, 0, 2);
							g_esPlayer[iPlayer].g_iPropsAttached = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Props", "Props", "Props", "Props", key, "PropsAttached", "Props Attached", "Props_Attached", "attached", g_esPlayer[iPlayer].g_iPropsAttached, value, 0, 127);
							g_esPlayer[iPlayer].g_iBodyEffects = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Particles", "Particles", "Particles", "Particles", key, "BodyEffects", "Body Effects", "Body_Effects", "body", g_esPlayer[iPlayer].g_iBodyEffects, value, 0, 127);
							g_esPlayer[iPlayer].g_iRockEffects = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Particles", "Particles", "Particles", "Particles", key, "RockEffects", "Rock Effects", "Rock_Effects", "rock", g_esPlayer[iPlayer].g_iRockEffects, value, 0, 15);
							g_esPlayer[iPlayer].g_flClawDamage = flGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Enhancements", "Enhancements", "Enhancements", "enhance", key, "ClawDamage", "Claw Damage", "Claw_Damage", "claw", g_esPlayer[iPlayer].g_flClawDamage, value, -1.0, 999999.0);
							g_esPlayer[iPlayer].g_iExtraHealth = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Enhancements", "Enhancements", "Enhancements", "enhance", key, "ExtraHealth", "Extra Health", "Extra_Health", "health", g_esPlayer[iPlayer].g_iExtraHealth, value, MT_MAX_HEALTH_REDUCTION, MT_MAXHEALTH);
							g_esPlayer[iPlayer].g_flRockDamage = flGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Enhancements", "Enhancements", "Enhancements", "enhance", key, "RockDamage", "Rock Damage", "Rock_Damage", "rock", g_esPlayer[iPlayer].g_flRockDamage, value, -1.0, 999999.0);
							g_esPlayer[iPlayer].g_flRunSpeed = flGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Enhancements", "Enhancements", "Enhancements", "enhance", key, "RunSpeed", "Run Speed", "Run_Speed", "speed", g_esPlayer[iPlayer].g_flRunSpeed, value, -1.0, 3.0);
							g_esPlayer[iPlayer].g_flThrowInterval = flGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Enhancements", "Enhancements", "Enhancements", "enhance", key, "ThrowInterval", "Throw Interval", "Throw_Interval", "throw", g_esPlayer[iPlayer].g_flThrowInterval, value, -1.0, 999999.0);
							g_esPlayer[iPlayer].g_iBulletImmunity = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Immunities", "Immunities", "Immunities", "Immunities", key, "BulletImmunity", "Bullet Immunity", "Bullet_Immunity", "bullet", g_esPlayer[iPlayer].g_iBulletImmunity, value, 0, 1);
							g_esPlayer[iPlayer].g_iExplosiveImmunity = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Immunities", "Immunities", "Immunities", "Immunities", key, "ExplosiveImmunity", "Explosive Immunity", "Explosive_Immunity", "explosive", g_esPlayer[iPlayer].g_iExplosiveImmunity, value, 0, 1);
							g_esPlayer[iPlayer].g_iFireImmunity = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Immunities", "Immunities", "Immunities", "Immunities", key, "FireImmunity", "Fire Immunity", "Fire_Immunity", "fire", g_esPlayer[iPlayer].g_iFireImmunity, value, 0, 1);
							g_esPlayer[iPlayer].g_iMeleeImmunity = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Immunities", "Immunities", "Immunities", "Immunities", key, "MeleeImmunity", "Melee Immunity", "Melee_Immunity", "melee", g_esPlayer[iPlayer].g_iMeleeImmunity, value, 0, 1);
							g_esPlayer[iPlayer].g_iFavoriteType = iGetKeyValue(g_esGeneral.g_sCurrentSubSection, "Administration", "Administration", "Administration", "admin", key, "FavoriteType", "Favorite Type", "Favorite_Type", "favorite", g_esPlayer[iPlayer].g_iFavoriteType, value, 0, g_esGeneral.g_iMaxType);

							if (StrEqual(g_esGeneral.g_sCurrentSubSection, "General", false))
							{
								if (StrEqual(key, "TankName", false) || StrEqual(key, "Tank Name", false) || StrEqual(key, "Tank_Name", false) || StrEqual(key, "name", false))
								{
									strcopy(g_esPlayer[iPlayer].g_sTankName, sizeof(esPlayer::g_sTankName), value);
								}
								else if (StrEqual(key, "HealthCharacters", false) || StrEqual(key, "Health Characters", false) || StrEqual(key, "Health_Characters", false) || StrEqual(key, "hpchars", false))
								{
									strcopy(g_esPlayer[iPlayer].g_sHealthCharacters, sizeof(esPlayer::g_sHealthCharacters), value);
								}
								else if (StrEqual(key, "SkinColor", false) || StrEqual(key, "Skin Color", false) || StrEqual(key, "Skin_Color", false) || StrEqual(key, "skin", false))
								{
									strcopy(sValue, sizeof(sValue), value);
									ReplaceString(sValue, sizeof(sValue), " ", "");
									ExplodeString(sValue, ",", sSet, sizeof(sSet), sizeof(sSet[]));

									for (int iPos = 0; iPos < sizeof(esPlayer::g_iSkinColor); iPos++)
									{
										g_esPlayer[iPlayer].g_iSkinColor[iPos] = (sSet[iPos][0] != '\0' && StringToInt(sSet[iPos]) >= 0) ? iClamp(StringToInt(sSet[iPos]), 0, 255) : GetRandomInt(0, 255);
									}
								}
								else if (StrEqual(key, "GlowColor", false) || StrEqual(key, "Glow Color", false) || StrEqual(key, "Glow_Color", false))
								{
									strcopy(sValue, sizeof(sValue), value);
									ReplaceString(sValue, sizeof(sValue), " ", "");
									ExplodeString(sValue, ",", sSet, sizeof(sSet), sizeof(sSet[]));

									for (int iPos = 0; iPos < sizeof(esPlayer::g_iGlowColor); iPos++)
									{
										g_esPlayer[iPlayer].g_iGlowColor[iPos] = (sSet[iPos][0] != '\0' && StringToInt(sSet[iPos]) >= 0) ? iClamp(StringToInt(sSet[iPos]), 0, 255) : GetRandomInt(0, 255);
									}
								}
								else if (StrEqual(key, "GlowRange", false) || StrEqual(key, "Glow Range", false) || StrEqual(key, "Glow_Range", false))
								{
									strcopy(sValue, sizeof(sValue), value);
									ReplaceString(sValue, sizeof(sValue), " ", "");
									ExplodeString(sValue, "-", sRange, sizeof(sRange), sizeof(sRange[]));

									g_esPlayer[iPlayer].g_iGlowMinRange = (sRange[0][0] != '\0') ? iClamp(StringToInt(sRange[0]), 0, 999999) : g_esPlayer[iPlayer].g_iGlowMinRange;
									g_esPlayer[iPlayer].g_iGlowMaxRange = (sRange[1][0] != '\0') ? iClamp(StringToInt(sRange[1]), 0, 999999) : g_esPlayer[iPlayer].g_iGlowMaxRange;
								}
							}

							if ((StrEqual(g_esGeneral.g_sCurrentSubSection, "Administration", false) || StrEqual(g_esGeneral.g_sCurrentSubSection, "admin", false)))
							{
								if (StrEqual(key, "AccessFlags", false) || StrEqual(key, "Access Flags", false) || StrEqual(key, "Access_Flags", false) || StrEqual(key, "access", false))
								{
									g_esPlayer[iPlayer].g_iAccessFlags = ReadFlagString(value);
								}
								else if (StrEqual(key, "ImmunityFlags", false) || StrEqual(key, "Immunity Flags", false) || StrEqual(key, "Immunity_Flags", false) || StrEqual(key, "immunity", false))
								{
									g_esPlayer[iPlayer].g_iImmunityFlags = ReadFlagString(value);
								}
							}

							if (StrEqual(g_esGeneral.g_sCurrentSubSection, "Spawn", false))
							{
								if (StrEqual(key, "TransformTypes", false) || StrEqual(key, "Transform Types", false) || StrEqual(key, "Transform_Types", false) || StrEqual(key, "transtypes", false))
								{
									strcopy(sValue, sizeof(sValue), value);
									ReplaceString(sValue, sizeof(sValue), " ", "");
									ExplodeString(sValue, ",", sSet, sizeof(sSet), sizeof(sSet[]));

									for (int iPos = 0; iPos < sizeof(esPlayer::g_iTransformType); iPos++)
									{
										g_esPlayer[iPlayer].g_iTransformType[iPos] = (sSet[iPos][0] != '\0') ? iClamp(StringToInt(sSet[iPos]), g_esGeneral.g_iMinType, g_esGeneral.g_iMaxType) : g_esPlayer[iPlayer].g_iTransformType[iPos];
									}
								}
								else
								{
									strcopy(sValue, sizeof(sValue), value);
									ReplaceString(sValue, sizeof(sValue), " ", "");
									ExplodeString(sValue, ",", sSet, sizeof(sSet), sizeof(sSet[]));

									for (int iPos = 0; iPos < sizeof(esPlayer::g_iBossHealth); iPos++)
									{
										if (StrEqual(key, "BossHealthStages", false) || StrEqual(key, "Boss Health Stages", false) || StrEqual(key, "Boss_Health_Stages", false) || StrEqual(key, "healthstages", false))
										{
											g_esPlayer[iPlayer].g_iBossHealth[iPos] = (sSet[iPos][0] != '\0') ? iClamp(StringToInt(sSet[iPos]), 1, MT_MAXHEALTH) : g_esPlayer[iPlayer].g_iBossHealth[iPos];
										}
										else if (StrEqual(key, "BossTypes", false) || StrEqual(key, "Boss Types", false) || StrEqual(key, "Boss_Types", false))
										{
											g_esPlayer[iPlayer].g_iBossType[iPos] = (sSet[iPos][0] != '\0') ? iClamp(StringToInt(sSet[iPos]), g_esGeneral.g_iMinType, g_esGeneral.g_iMaxType) : g_esPlayer[iPlayer].g_iBossType[iPos];
										}
									}
								}
							}

							if (StrEqual(g_esGeneral.g_sCurrentSubSection, "Props", false))
							{
								if (StrEqual(key, "PropsChance", false) || StrEqual(key, "Props Chance", false) || StrEqual(key, "Props_Chance", false) || StrEqual(key, "chance", false))
								{
									strcopy(sValue, sizeof(sValue), value);
									ReplaceString(sValue, sizeof(sValue), " ", "");
									ExplodeString(sValue, ",", sSet, sizeof(sSet), sizeof(sSet[]));

									for (int iPos = 0; iPos < sizeof(esPlayer::g_flPropsChance); iPos++)
									{
										g_esPlayer[iPlayer].g_flPropsChance[iPos] = (sSet[iPos][0] != '\0') ? flClamp(StringToFloat(sSet[iPos]), 0.0, 100.0) : g_esPlayer[iPlayer].g_flPropsChance[iPos];
									}
								}
								else
								{
									strcopy(sValue, sizeof(sValue), value);
									ReplaceString(sValue, sizeof(sValue), " ", "");
									ExplodeString(sValue, ",", sSet, sizeof(sSet), sizeof(sSet[]));

									for (int iPos = 0; iPos < sizeof(esPlayer::g_iLightColor); iPos++)
									{
										if (StrEqual(key, "LightColor", false) || StrEqual(key, "Light Color", false) || StrEqual(key, "Light_Color", false) || StrEqual(key, "light", false))
										{
											g_esPlayer[iPlayer].g_iLightColor[iPos] = (sSet[iPos][0] != '\0' && StringToInt(sSet[iPos]) >= 0) ? iClamp(StringToInt(sSet[iPos]), 0, 255) : GetRandomInt(0, 255);
										}
										else if (StrEqual(key, "OxygenTankColor", false) || StrEqual(key, "Oxygen Tank Color", false) || StrEqual(key, "Oxygen_Tank_Color", false) || StrEqual(key, "oxygen", false))
										{
											g_esPlayer[iPlayer].g_iOzTankColor[iPos] = (sSet[iPos][0] != '\0' && StringToInt(sSet[iPos]) >= 0) ? iClamp(StringToInt(sSet[iPos]), 0, 255) : GetRandomInt(0, 255);
										}
										else if (StrEqual(key, "FlameColor", false) || StrEqual(key, "Flame Color", false) || StrEqual(key, "Flame_Color", false) || StrEqual(key, "flame", false))
										{
											g_esPlayer[iPlayer].g_iFlameColor[iPos] = (sSet[iPos][0] != '\0' && StringToInt(sSet[iPos]) >= 0) ? iClamp(StringToInt(sSet[iPos]), 0, 255) : GetRandomInt(0, 255);
										}
										else if (StrEqual(key, "RockColor", false) || StrEqual(key, "Rock Color", false) || StrEqual(key, "Rock_Color", false) || StrEqual(key, "rock", false))
										{
											g_esPlayer[iPlayer].g_iRockColor[iPos] = (sSet[iPos][0] != '\0' && StringToInt(sSet[iPos]) >= 0) ? iClamp(StringToInt(sSet[iPos]), 0, 255) : GetRandomInt(0, 255);
										}
										else if (StrEqual(key, "TireColor", false) || StrEqual(key, "Tire Color", false) || StrEqual(key, "Tire_Color", false) || StrEqual(key, "tire", false))
										{
											g_esPlayer[iPlayer].g_iTireColor[iPos] = (sSet[iPos][0] != '\0' && StringToInt(sSet[iPos]) >= 0) ? iClamp(StringToInt(sSet[iPos]), 0, 255) : GetRandomInt(0, 255);
										}
										else if (StrEqual(key, "PropaneTankColor", false) || StrEqual(key, "Propane Tank Color", false) || StrEqual(key, "Propane_Tank_Color", false) || StrEqual(key, "propane", false))
										{
											g_esPlayer[iPlayer].g_iPropTankColor[iPos] = (sSet[iPos][0] != '\0' && StringToInt(sSet[iPos]) >= 0) ? iClamp(StringToInt(sSet[iPos]), 0, 255) : GetRandomInt(0, 255);
										}
									}
								}
							}

							if (StrContains(g_esGeneral.g_sCurrentSubSection, "Tank#", false) == 0 || StrContains(g_esGeneral.g_sCurrentSubSection, "Tank #", false) == 0 || StrContains(g_esGeneral.g_sCurrentSubSection, "Tank_#", false) == 0 || StrContains(g_esGeneral.g_sCurrentSubSection, "Tank", false) == 0 || g_esGeneral.g_sCurrentSubSection[0] == '#' || IsCharNumeric(g_esGeneral.g_sCurrentSubSection[0]))
							{
								for (int iIndex = g_esGeneral.g_iMinType; iIndex <= g_esGeneral.g_iMaxType; iIndex++)
								{
									FormatEx(sTankName[0], sizeof(sTankName[]), "Tank#%i", iIndex);
									FormatEx(sTankName[1], sizeof(sTankName[]), "Tank #%i", iIndex);
									FormatEx(sTankName[2], sizeof(sTankName[]), "Tank_#%i", iIndex);
									FormatEx(sTankName[3], sizeof(sTankName[]), "Tank%i", iIndex);
									FormatEx(sTankName[4], sizeof(sTankName[]), "Tank %i", iIndex);
									FormatEx(sTankName[5], sizeof(sTankName[]), "Tank_%i", iIndex);
									FormatEx(sTankName[6], sizeof(sTankName[]), "#%i", iIndex);
									FormatEx(sTankName[7], sizeof(sTankName[]), "%i", iIndex);

									for (int iType = 0; iType < sizeof(sTankName); iType++)
									{
										if (StrEqual(g_esGeneral.g_sCurrentSubSection, sTankName[iType], false))
										{
											if (StrEqual(key, "AccessFlags", false) || StrEqual(key, "Access Flags", false) || StrEqual(key, "Access_Flags", false) || StrEqual(key, "access", false))
											{
												g_esAdmin[iIndex].g_iAccessFlags[iPlayer] = ReadFlagString(value);
											}
											else if (StrEqual(key, "ImmunityFlags", false) || StrEqual(key, "Immunity Flags", false) || StrEqual(key, "Immunity_Flags", false) || StrEqual(key, "immunity", false))
											{
												g_esAdmin[iIndex].g_iImmunityFlags[iPlayer] = ReadFlagString(value);
											}
										}
									}
								}
							}

							Call_StartForward(g_esGeneral.g_gfConfigsLoadedForward);
							Call_PushString(g_esGeneral.g_sCurrentSubSection);
							Call_PushString(key);
							Call_PushString(value);
							Call_PushCell(0);
							Call_PushCell(iPlayer);
							Call_PushCell(g_esGeneral.g_iConfigMode);
							Call_Finish();

							break;
						}
					}
				}
			}
		}
	}

	return SMCParse_Continue;
}

public SMCResult SMCEndSection(SMCParser smc)
{
	if (g_esGeneral.g_iIgnoreLevel)
	{
		g_esGeneral.g_iIgnoreLevel--;

		return SMCParse_Continue;
	}

	if (g_esGeneral.g_csState == ConfigState_Specific)
	{
		if (StrEqual(g_esGeneral.g_sCurrentSection, "PluginSettings", false) || StrEqual(g_esGeneral.g_sCurrentSection, "Plugin Settings", false) || StrEqual(g_esGeneral.g_sCurrentSection, "Plugin_Settings", false) || StrEqual(g_esGeneral.g_sCurrentSection, "settings", false))
		{
			g_esGeneral.g_csState = ConfigState_Settings;
		}
		else if (StrContains(g_esGeneral.g_sCurrentSection, "Tank#", false) == 0 || StrContains(g_esGeneral.g_sCurrentSection, "Tank #", false) == 0 || StrContains(g_esGeneral.g_sCurrentSection, "Tank_#", false) == 0 || StrContains(g_esGeneral.g_sCurrentSection, "Tank", false) == 0 || g_esGeneral.g_sCurrentSection[0] == '#' || IsCharNumeric(g_esGeneral.g_sCurrentSection[0]))
		{
			g_esGeneral.g_csState = ConfigState_Type;
		}
		else if (StrContains(g_esGeneral.g_sCurrentSection, "STEAM_", false) == 0 || strncmp("0:", g_esGeneral.g_sCurrentSection, 2) == 0 || strncmp("1:", g_esGeneral.g_sCurrentSection, 2) == 0 || (!strncmp(g_esGeneral.g_sCurrentSection, "[U:", 3) && g_esGeneral.g_sCurrentSection[strlen(g_esGeneral.g_sCurrentSection) - 1] == ']'))
		{
			g_esGeneral.g_csState = ConfigState_Admin;
		}
	}
	else if (g_esGeneral.g_csState == ConfigState_Settings || g_esGeneral.g_csState == ConfigState_Type || g_esGeneral.g_csState == ConfigState_Admin)
	{
		g_esGeneral.g_csState = ConfigState_Start;
	}
	else if (g_esGeneral.g_csState == ConfigState_Start)
	{
		g_esGeneral.g_csState = ConfigState_None;
	}

	return SMCParse_Continue;
}

public void SMCParseEnd(SMCParser smc, bool halted, bool failed)
{
	g_esGeneral.g_csState = ConfigState_None;
	g_esGeneral.g_iIgnoreLevel = 0;
	g_esGeneral.g_sCurrentSection[0] = '\0';
	g_esGeneral.g_sCurrentSubSection[0] = '\0';

	for (int iPlayer = 1; iPlayer <= MaxClients; iPlayer++)
	{
		if (bIsValidClient(iPlayer))
		{
			vCacheSettings(iPlayer);
		}
	}
}

public void vEventHandler(Event event, const char[] name, bool dontBroadcast)
{
	if (g_esGeneral.g_cvMTPluginEnabled.BoolValue && g_esGeneral.g_bPluginEnabled)
	{
		if (StrEqual(name, "ability_use"))
		{
			int iTankId = event.GetInt("userid"), iTank = GetClientOfUserId(iTankId);
			if (bIsTankAllowed(iTank) && bHasCoreAdminAccess(iTank))
			{
				vThrowInterval(iTank);
			}
		}
		else if (StrEqual(name, "bot_player_replace"))
		{
			int iBotId = event.GetInt("bot"), iBot = GetClientOfUserId(iBotId),
				iTankId = event.GetInt("player"), iTank = GetClientOfUserId(iTankId);
			if (bIsValidClient(iBot) && bIsTank(iTank))
			{
				vReset2(iBot, 0);
				vReset3(iBot);
				vCacheSettings(iBot);
			}
		}
		else if (StrEqual(name, "finale_escape_start") || StrEqual(name, "finale_vehicle_ready"))
		{
			vFirstTank(2);
			g_esGeneral.g_iTankWave = 3;
		}
		else if (StrEqual(name, "finale_start"))
		{
			vFirstTank(0);
			g_esGeneral.g_iTankWave = 1;
		}
		else if (StrEqual(name, "finale_vehicle_leaving"))
		{
			vFirstTank(2);
			g_esGeneral.g_iTankWave = 4;
		}
		else if (StrEqual(name, "player_bot_replace"))
		{
			int iTankId = event.GetInt("player"), iTank = GetClientOfUserId(iTankId),
				iBotId = event.GetInt("bot"), iBot = GetClientOfUserId(iBotId);
			if (bIsValidClient(iTank) && bIsTank(iBot))
			{
				vRevertName(iTank);
				vReset2(iTank, 0);
				vReset3(iTank);
				vCacheSettings(iTank);
			}
		}
		else if (StrEqual(name, "player_death"))
		{
			int iTankId = event.GetInt("userid"), iTank = GetClientOfUserId(iTankId);
			if (bIsTankAllowed(iTank, MT_CHECK_INDEX|MT_CHECK_INGAME|MT_CHECK_INKICKQUEUE) || g_esPlayer[iTank].g_iTankType > 0)
			{
				g_esPlayer[iTank].g_bDied = true;
				g_esPlayer[iTank].g_bDying = false;

				if (bIsValidClient(iTank, MT_CHECK_FAKECLIENT))
				{
					vRevertName(iTank);
				}

				if (g_esCache[iTank].g_iAnnounceDeath == 1 && bIsCloneAllowed(iTank))
				{
					if (g_esCache[iTank].g_sTankName[0] == '\0')
					{
						g_esCache[iTank].g_sTankName = "Tank";
					}

					switch (GetRandomInt(1, 10))
					{
						case 1: MT_PrintToChatAll("%s %t", MT_TAG2, "Death1", g_esCache[iTank].g_sTankName);
						case 2: MT_PrintToChatAll("%s %t", MT_TAG2, "Death2", g_esCache[iTank].g_sTankName);
						case 3: MT_PrintToChatAll("%s %t", MT_TAG2, "Death3", g_esCache[iTank].g_sTankName);
						case 4: MT_PrintToChatAll("%s %t", MT_TAG2, "Death4", g_esCache[iTank].g_sTankName);
						case 5: MT_PrintToChatAll("%s %t", MT_TAG2, "Death5", g_esCache[iTank].g_sTankName);
						case 6: MT_PrintToChatAll("%s %t", MT_TAG2, "Death6", g_esCache[iTank].g_sTankName);
						case 7: MT_PrintToChatAll("%s %t", MT_TAG2, "Death7", g_esCache[iTank].g_sTankName);
						case 8: MT_PrintToChatAll("%s %t", MT_TAG2, "Death8", g_esCache[iTank].g_sTankName);
						case 9: MT_PrintToChatAll("%s %t", MT_TAG2, "Death9", g_esCache[iTank].g_sTankName);
						case 10: MT_PrintToChatAll("%s %t", MT_TAG2, "Death10", g_esCache[iTank].g_sTankName);
					}
				}

				if (g_esCache[iTank].g_iDeathRevert == 1)
				{
					int iType = g_esPlayer[iTank].g_iTankType;
					vNewTankSettings(iTank, true);
					vSetColor(iTank);

					g_esPlayer[iTank].g_iTankType = iType;
				}

				vReset2(iTank, g_esCache[iTank].g_iDeathRevert);

				CreateTimer(1.0, tTimerResetType, iTankId, TIMER_FLAG_NO_MAPCHANGE);
				CreateTimer(3.0, tTimerTankWave, g_esGeneral.g_iTankWave, TIMER_FLAG_NO_MAPCHANGE);
			}
		}
		else if (StrEqual(name, "player_incapacitated"))
		{
			int iTankId = event.GetInt("userid"), iTank = GetClientOfUserId(iTankId);
			if (bIsTank(iTank, MT_CHECK_INDEX|MT_CHECK_INGAME|MT_CHECK_INKICKQUEUE))
			{
				g_esPlayer[iTank].g_bDied = false;
				g_esPlayer[iTank].g_bDying = true;

				CreateTimer(7.5, tTimerKillStuckTank, iTankId, TIMER_FLAG_NO_MAPCHANGE);
			}
		}
		else if (StrEqual(name, "player_now_it"))
		{
			int iTankId = event.GetInt("userid"), iTank = GetClientOfUserId(iTankId);
 			if (bIsTank(iTank, MT_CHECK_INDEX|MT_CHECK_INGAME|MT_CHECK_ALIVE|MT_CHECK_INKICKQUEUE) && bIsValidGame())
			{
				SetEntProp(iTank, Prop_Send, "m_iGlowType", 0);
				SetEntProp(iTank, Prop_Send, "m_glowColorOverride", 0);
			}
		}
		else if (StrEqual(name, "player_no_longer_it"))
		{
			int iTankId = event.GetInt("userid"), iTank = GetClientOfUserId(iTankId);
 			if (bIsTank(iTank, MT_CHECK_INDEX|MT_CHECK_INGAME|MT_CHECK_ALIVE|MT_CHECK_INKICKQUEUE) && g_esCache[iTank].g_iGlowEnabled == 1)
			{
				if (bIsValidGame() && !bIsPlayerIncapacitated(iTank))
				{
					SetEntProp(iTank, Prop_Send, "m_glowColorOverride", iGetRGBColor(g_esCache[iTank].g_iGlowColor[0], g_esCache[iTank].g_iGlowColor[1], g_esCache[iTank].g_iGlowColor[2]));
					SetEntProp(iTank, Prop_Send, "m_bFlashing", g_esCache[iTank].g_iGlowFlashing);
					SetEntProp(iTank, Prop_Send, "m_nGlowRangeMin", g_esCache[iTank].g_iGlowMinRange);
					SetEntProp(iTank, Prop_Send, "m_nGlowRange", g_esCache[iTank].g_iGlowMaxRange);
					SetEntProp(iTank, Prop_Send, "m_iGlowType", (g_esCache[iTank].g_iGlowType == 1 ? 3 : 2));
				}
			}
		}
		else if (StrEqual(name, "player_spawn"))
		{
			int iTankId = event.GetInt("userid"), iTank = GetClientOfUserId(iTankId);
			if (bIsValidClient(iTank, MT_CHECK_INDEX|MT_CHECK_INGAME|MT_CHECK_INKICKQUEUE|MT_CHECK_FAKECLIENT))
			{
				vRevertName(iTank);
			}

			if (bIsTank(iTank))
			{
				g_esPlayer[iTank].g_bDying = false;

				if (g_esPlayer[iTank].g_bDied)
				{
					g_esPlayer[iTank].g_bDied = false;
					g_esPlayer[iTank].g_iTankType = 0;
				}

				switch (g_esGeneral.g_iType)
				{
					case 0:
					{
						switch (bIsTankAllowed(iTank, MT_CHECK_FAKECLIENT))
						{
							case true:
							{
								switch (g_esGeneral.g_iSpawnMode)
								{
									case 0:
									{
										g_esPlayer[iTank].g_bNeedHealth = true;

										vTankMenu(iTank, 0);
									}
									case 1: vMutateTank(iTank);
								}
							}
							case false: vMutateTank(iTank);
						}
					}
					default: vMutateTank(iTank);
				}
			}
		}
		else if (StrEqual(name, "round_start"))
		{
			g_esGeneral.g_iTankWave = 0;
		}

		Call_StartForward(g_esGeneral.g_gfEventFiredForward);
		Call_PushCell(event);
		Call_PushString(name);
		Call_PushCell(dontBroadcast);
		Call_Finish();
	}
}

static void vPluginStatus()
{
	if (g_esGeneral.g_cvMTPluginEnabled.BoolValue && g_esGeneral.g_iPluginEnabled == 1)
	{
		bool bPluginAllowed = bIsPluginEnabled();

		switch (bPluginAllowed)
		{
			case true:
			{
				g_esGeneral.g_bPluginEnabled = true;

				vHookEvents(true);

				if (!DHookEnableDetour(g_esGeneral.g_hLaunchDirectionDetour, false, mreLaunchDirection))
				{
					LogError("Failed to enable detour pre: CEnvRockLauncher::LaunchCurrentDir");
				}

				if (!DHookEnableDetour(g_esGeneral.g_hTankRockDetour, true, mreTankRock))
				{
					LogError("Failed to enable detour post: CTankRock::Create");
				}
			}
			case false:
			{
				g_esGeneral.g_bPluginEnabled = false;

				vHookEvents(false);

				if (!DHookDisableDetour(g_esGeneral.g_hLaunchDirectionDetour, false, mreLaunchDirection))
				{
					LogError("Failed to disable detour pre: CEnvRockLauncher::LaunchCurrentDir");
				}

				if (!DHookDisableDetour(g_esGeneral.g_hTankRockDetour, true, mreTankRock))
				{
					LogError("Failed to disable detour post: CTankRock::Create");
				}
			}
		}
	}
}

static void vHookEvents(bool hook)
{
	static bool bHooked;
	if (hook && !bHooked)
	{
		bHooked = true;

		HookEvent("ability_use", vEventHandler);
		HookEvent("bot_player_replace", vEventHandler);
		HookEvent("finale_escape_start", vEventHandler);
		HookEvent("finale_start", vEventHandler, EventHookMode_Pre);
		HookEvent("finale_vehicle_leaving", vEventHandler);
		HookEvent("finale_vehicle_ready", vEventHandler);
		HookEvent("player_bot_replace", vEventHandler);
		HookEvent("player_death", vEventHandler, EventHookMode_Pre);
		HookEvent("player_incapacitated", vEventHandler);
		HookEvent("player_spawn", vEventHandler);
		HookEvent("player_now_it", vEventHandler);
		HookEvent("player_no_longer_it", vEventHandler);

		vHookEventForward(true);
	}
	else if (!hook && bHooked)
	{
		bHooked = false;

		UnhookEvent("ability_use", vEventHandler);
		UnhookEvent("bot_player_replace", vEventHandler);
		UnhookEvent("finale_escape_start", vEventHandler);
		UnhookEvent("finale_start", vEventHandler, EventHookMode_Pre);
		UnhookEvent("finale_vehicle_leaving", vEventHandler);
		UnhookEvent("finale_vehicle_ready", vEventHandler);
		UnhookEvent("player_bot_replace", vEventHandler);
		UnhookEvent("player_death", vEventHandler, EventHookMode_Pre);
		UnhookEvent("player_incapacitated", vEventHandler);
		UnhookEvent("player_spawn", vEventHandler);
		UnhookEvent("player_now_it", vEventHandler);
		UnhookEvent("player_no_longer_it", vEventHandler);

		vHookEventForward(false);
	}
}

static void vHookEventForward(bool mode)
{
	Call_StartForward(g_esGeneral.g_gfHookEventForward);
	Call_PushCell(mode);
	Call_Finish();
}

static void vBoss(int tank, int limit, int stages, int type, int stage)
{
	if (stages >= stage)
	{
		static int iHealth, iNewHealth, iFinalHealth;
		iHealth = GetClientHealth(tank);
		if (iHealth <= limit)
		{
			g_esPlayer[tank].g_iBossStageCount = stage;

			vNewTankSettings(tank);
			vSetColor(tank, type);
			vTankSpawn(tank, 1);

			iNewHealth = g_esPlayer[tank].g_iTankHealth + limit;
			iFinalHealth = (iNewHealth > MT_MAXHEALTH) ? MT_MAXHEALTH : iNewHealth;
			//SetEntityHealth(tank, iFinalHealth);
			SetEntProp(tank, Prop_Data, "m_iHealth", iFinalHealth);
			SetEntProp(tank, Prop_Data, "m_iMaxHealth", iFinalHealth);
		}
	}
}

static void vNewTankSettings(int tank, bool revert = false)
{
	vResetTank(tank);

	Call_StartForward(g_esGeneral.g_gfChangeTypeForward);
	Call_PushCell(tank);
	Call_PushCell(revert);
	Call_Finish();
}

static void vRemoveProps(int tank, int mode = 1)
{
	if (bIsValidEntRef(g_esPlayer[tank].g_iTankModel))
	{
		g_esPlayer[tank].g_iTankModel = EntRefToEntIndex(g_esPlayer[tank].g_iTankModel);
		if (bIsValidEntity(g_esPlayer[tank].g_iTankModel))
		{
			SDKUnhook(g_esPlayer[tank].g_iTankModel, SDKHook_SetTransmit, SetTransmit);
			RemoveEntity(g_esPlayer[tank].g_iTankModel);
		}
	}

	g_esPlayer[tank].g_iTankModel = INVALID_ENT_REFERENCE;

	for (int iLight = 0; iLight < sizeof(esPlayer::g_iLight); iLight++)
	{
		if (bIsValidEntRef(g_esPlayer[tank].g_iLight[iLight]))
		{
			g_esPlayer[tank].g_iLight[iLight] = EntRefToEntIndex(g_esPlayer[tank].g_iLight[iLight]);
			if (bIsValidEntity(g_esPlayer[tank].g_iLight[iLight]))
			{
				SDKUnhook(g_esPlayer[tank].g_iLight[iLight], SDKHook_SetTransmit, SetTransmit);
				RemoveEntity(g_esPlayer[tank].g_iLight[iLight]);
			}
		}

		g_esPlayer[tank].g_iLight[iLight] = INVALID_ENT_REFERENCE;
	}

	for (int iOzTank = 0; iOzTank < sizeof(esPlayer::g_iFlame); iOzTank++)
	{
		if (bIsValidEntRef(g_esPlayer[tank].g_iFlame[iOzTank]))
		{
			g_esPlayer[tank].g_iFlame[iOzTank] = EntRefToEntIndex(g_esPlayer[tank].g_iFlame[iOzTank]);
			if (bIsValidEntity(g_esPlayer[tank].g_iFlame[iOzTank]))
			{
				SDKUnhook(g_esPlayer[tank].g_iFlame[iOzTank], SDKHook_SetTransmit, SetTransmit);
				RemoveEntity(g_esPlayer[tank].g_iFlame[iOzTank]);
			}
		}

		g_esPlayer[tank].g_iFlame[iOzTank] = INVALID_ENT_REFERENCE;

		if (bIsValidEntRef(g_esPlayer[tank].g_iOzTank[iOzTank]))
		{
			g_esPlayer[tank].g_iOzTank[iOzTank] = EntRefToEntIndex(g_esPlayer[tank].g_iOzTank[iOzTank]);
			if (bIsValidEntity(g_esPlayer[tank].g_iOzTank[iOzTank]))
			{
				SDKUnhook(g_esPlayer[tank].g_iOzTank[iOzTank], SDKHook_SetTransmit, SetTransmit);
				RemoveEntity(g_esPlayer[tank].g_iOzTank[iOzTank]);
			}
		}

		g_esPlayer[tank].g_iOzTank[iOzTank] = INVALID_ENT_REFERENCE;
	}

	for (int iRock = 0; iRock < sizeof(esPlayer::g_iRock); iRock++)
	{
		if (bIsValidEntRef(g_esPlayer[tank].g_iRock[iRock]))
		{
			g_esPlayer[tank].g_iRock[iRock] = EntRefToEntIndex(g_esPlayer[tank].g_iRock[iRock]);
			if (bIsValidEntity(g_esPlayer[tank].g_iRock[iRock]))
			{
				SDKUnhook(g_esPlayer[tank].g_iRock[iRock], SDKHook_SetTransmit, SetTransmit);
				RemoveEntity(g_esPlayer[tank].g_iRock[iRock]);
			}
		}

		g_esPlayer[tank].g_iRock[iRock] = INVALID_ENT_REFERENCE;
	}

	for (int iTire = 0; iTire < sizeof(esPlayer::g_iTire); iTire++)
	{
		if (bIsValidEntRef(g_esPlayer[tank].g_iTire[iTire]))
		{
			g_esPlayer[tank].g_iTire[iTire] = EntRefToEntIndex(g_esPlayer[tank].g_iTire[iTire]);
			if (bIsValidEntity(g_esPlayer[tank].g_iTire[iTire]))
			{
				SDKUnhook(g_esPlayer[tank].g_iTire[iTire], SDKHook_SetTransmit, SetTransmit);
				RemoveEntity(g_esPlayer[tank].g_iTire[iTire]);
			}
		}

		g_esPlayer[tank].g_iTire[iTire] = INVALID_ENT_REFERENCE;
	}

	if (bIsValidEntRef(g_esPlayer[tank].g_iPropaneTank))
	{
		g_esPlayer[tank].g_iPropaneTank = EntRefToEntIndex(g_esPlayer[tank].g_iPropaneTank);
		if (bIsValidEntity(g_esPlayer[tank].g_iPropaneTank))
		{
			SDKUnhook(g_esPlayer[tank].g_iPropaneTank, SDKHook_SetTransmit, SetTransmit);
			RemoveEntity(g_esPlayer[tank].g_iPropaneTank);
		}
	}

	g_esPlayer[tank].g_iPropaneTank = INVALID_ENT_REFERENCE;

	if (bIsValidGame() && g_esCache[tank].g_iGlowEnabled == 1)
	{
		SetEntProp(tank, Prop_Send, "m_iGlowType", 0);
		SetEntProp(tank, Prop_Send, "m_glowColorOverride", 0);
	}

	if (mode == 1)
	{
		SetEntityRenderMode(tank, RENDER_NORMAL);
		SetEntityRenderColor(tank, 255, 255, 255, 255);
	}
}

static void vReset()
{
	g_esGeneral.g_iRegularCount = 0;
	g_esGeneral.g_iType = 0;

	for (int iPlayer = 1; iPlayer <= MaxClients; iPlayer++)
	{
		if (bIsValidClient(iPlayer, MT_CHECK_INGAME|MT_CHECK_INKICKQUEUE))
		{
			vReset2(iPlayer);
			vReset3(iPlayer);
			vCacheSettings(iPlayer);
			vResetCore(iPlayer);
		}
	}

	vClearAbilityList();
	vClearPluginList();
}

static void vReset2(int tank, int mode = 1)
{
	vRemoveProps(tank, mode);
	vResetSpeed(tank, true);
	vSpawnModes(tank, false);
}

static void vReset3(int tank)
{
	g_esPlayer[tank].g_bBlood = false;
	g_esPlayer[tank].g_bBlur = false;
	g_esPlayer[tank].g_bElectric = false;
	g_esPlayer[tank].g_bFire = false;
	g_esPlayer[tank].g_bIce = false;
	g_esPlayer[tank].g_bKeepCurrentType = false;
	g_esPlayer[tank].g_bMeteor = false;
	g_esPlayer[tank].g_bNeedHealth = false;
	g_esPlayer[tank].g_bSmoke = false;
	g_esPlayer[tank].g_bSpit = false;
	g_esPlayer[tank].g_iBossStageCount = 0;
	g_esPlayer[tank].g_iCooldown = -1;
	g_esPlayer[tank].g_iTankType = 0;
}

static void vResetCore(int client)
{
	g_esPlayer[client].g_bAdminMenu = false;
	g_esPlayer[client].g_bDied = false;
	g_esPlayer[client].g_bDying = false;
	g_esPlayer[client].g_bThirdPerson = false;
	g_esPlayer[client].g_csState = ConfigState_None;
	g_esPlayer[client].g_iLastButtons = 0;
	g_esPlayer[client].g_sOriginalName[0] = '\0';
}

static void vResetSpeed(int tank, bool mode = false)
{
	if (bIsValidClient(tank))
	{
		switch (mode)
		{
			case true: SetEntPropFloat(tank, Prop_Send, "m_flLaggedMovementValue", 1.0);
			case false:
			{
				if (g_esCache[tank].g_flRunSpeed > 0.0)
				{
					SetEntPropFloat(tank, Prop_Send, "m_flLaggedMovementValue", g_esCache[tank].g_flRunSpeed);
				}
			}
		}
	}
}

static void vResetTank(int tank)
{
	ExtinguishEntity(tank);
	vAttachParticle(tank, PARTICLE_ELECTRICITY, 2.0, 30.0);
	EmitSoundToAll(SOUND_ELECTRICITY, tank);
	vResetSpeed(tank, true);
}

static void vRevertName(int tank)
{
	static char sCurrentName[33];
	GetClientName(tank, sCurrentName, sizeof(sCurrentName));
	if (!StrEqual(sCurrentName, g_esPlayer[tank].g_sOriginalName) && g_esPlayer[tank].g_sOriginalName[0] != '\0')
	{
		g_esGeneral.g_bHideNameChange = true;
		SetClientName(tank, g_esPlayer[tank].g_sOriginalName);
		g_esGeneral.g_bHideNameChange = false;
	}
}

static void vSpawnModes(int tank, bool status)
{
	g_esPlayer[tank].g_bBoss = status;
	g_esPlayer[tank].g_bRandomized = status;
	g_esPlayer[tank].g_bTransformed = status;
}

static void vSetColor(int tank, int type = 0)
{
	if (type == 0)
	{
		vRemoveProps(tank);

		return;
	}

	if (g_esPlayer[tank].g_iTankType > 0 && g_esPlayer[tank].g_iTankType == type && !g_esPlayer[tank].g_bKeepCurrentType)
	{
		vRemoveProps(tank);

		g_esPlayer[tank].g_iTankType = 0;

		return;
	}

	g_esPlayer[tank].g_iTankType = type;

	vCacheSettings(tank);

	SetEntityRenderMode(tank, RENDER_NORMAL);
	SetEntityRenderColor(tank, g_esCache[tank].g_iSkinColor[0], g_esCache[tank].g_iSkinColor[1], g_esCache[tank].g_iSkinColor[2], g_esCache[tank].g_iSkinColor[3]);

	if (bIsValidGame() && g_esCache[tank].g_iGlowEnabled == 1)
	{
		SetEntProp(tank, Prop_Send, "m_glowColorOverride", iGetRGBColor(g_esCache[tank].g_iGlowColor[0], g_esCache[tank].g_iGlowColor[1], g_esCache[tank].g_iGlowColor[2]));
		SetEntProp(tank, Prop_Send, "m_bFlashing", g_esCache[tank].g_iGlowFlashing);
		SetEntProp(tank, Prop_Send, "m_nGlowRangeMin", g_esCache[tank].g_iGlowMinRange);
		SetEntProp(tank, Prop_Send, "m_nGlowRange", g_esCache[tank].g_iGlowMaxRange);
		SetEntProp(tank, Prop_Send, "m_iGlowType", (g_esCache[tank].g_iGlowType == 1 ? 3 : 2));
	}
}

static void vSetName(int tank, const char[] oldname, const char[] name, int mode)
{
	if (bIsTank(tank))
	{
		if (!bIsTank(tank, MT_CHECK_FAKECLIENT) || g_esCache[tank].g_iRenamePlayers == 1)
		{
			g_esGeneral.g_bHideNameChange = true;
			SetClientName(tank, name);
			g_esGeneral.g_bHideNameChange = false;
		}

		switch (mode)
		{
			case 0: vAnnounceArrival(tank, name);
			case 1:
			{
				if (g_esCache[tank].g_iAnnounceArrival & MT_ARRIVAL_BOSS)
				{
					MT_PrintToChatAll("%s %t", MT_TAG2, "Evolved", oldname, name, g_esPlayer[tank].g_iBossStageCount + 1);
				}
			}
			case 2:
			{
				if (g_esCache[tank].g_iAnnounceArrival & MT_ARRIVAL_RANDOM)
				{
					MT_PrintToChatAll("%s %t", MT_TAG2, "Randomized", oldname, name);
				}
			}
			case 3:
			{
				if (g_esCache[tank].g_iAnnounceArrival & MT_ARRIVAL_TRANSFORM)
				{
					MT_PrintToChatAll("%s %t", MT_TAG2, "Transformed", oldname, name);
				}
			}
			case 4:
			{
				if (g_esCache[tank].g_iAnnounceArrival & MT_ARRIVAL_REVERT)
				{
					MT_PrintToChatAll("%s %t", MT_TAG2, "Untransformed", oldname, name);
				}
			}
			case 5:
			{
				vAnnounceArrival(tank, name);
				MT_PrintToChat(tank, "%s %t", MT_TAG3, "ChangeType");
			}
		}

		if (g_esCache[tank].g_iTankNote == 1 && bIsCloneAllowed(tank))
		{
			char sPhrase[32], sTankNote[32], sSteamID32[32], sSteam3ID[32], sSteamIDFinal[32];
			FormatEx(sPhrase, sizeof(sPhrase), "Tank #%i", g_esPlayer[tank].g_iTankType);
			GetClientAuthId(tank, AuthId_Steam2, sSteamID32, sizeof(sSteamID32));
			GetClientAuthId(tank, AuthId_Steam3, sSteam3ID, sizeof(sSteam3ID));
			FormatEx(sSteamIDFinal, sizeof(sSteamIDFinal), "%s", (TranslationPhraseExists(sSteamID32) ? sSteamID32 : sSteam3ID));
			FormatEx(sTankNote, sizeof(sTankNote), "%s", ((bIsTank(tank, MT_CHECK_FAKECLIENT) && g_esPlayer[tank].g_iTankNote == 1) ? sSteamIDFinal : sPhrase));

			switch (TranslationPhraseExists(sTankNote))
			{
				case true: MT_PrintToChatAll("%s %t", MT_TAG3, sTankNote);
				case false: MT_PrintToChatAll("%s %t", MT_TAG3, "NoNote");
			}
		}
	}
}

static void vSetProps(int tank)
{
	if (bIsTank(tank))
	{
		if (GetRandomFloat(0.1, 100.0) <= g_esCache[tank].g_flPropsChance[0] && (g_esCache[tank].g_iPropsAttached & MT_PROP_BLUR) && !g_esPlayer[tank].g_bBlur)
		{
			g_esPlayer[tank].g_bBlur = true;

			CreateTimer(0.25, tTimerBlurEffect, GetClientUserId(tank), TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
		}

		float flOrigin[3], flAngles[3];
		GetEntPropVector(tank, Prop_Send, "m_vecOrigin", flOrigin);
		GetEntPropVector(tank, Prop_Send, "m_angRotation", flAngles);

		for (int iLight = 0; iLight < sizeof(esPlayer::g_iLight); iLight++)
		{
			if ((g_esPlayer[tank].g_iLight[iLight] == 0 || g_esPlayer[tank].g_iLight[iLight] == INVALID_ENT_REFERENCE) && GetRandomFloat(0.1, 100.0) <= g_esCache[tank].g_flPropsChance[1] && (g_esCache[tank].g_iPropsAttached & MT_PROP_LIGHT))
			{
				vLightProp(tank, iLight, flOrigin, flAngles);
			}
			else if (bIsValidEntRef(g_esPlayer[tank].g_iLight[iLight]))
			{
				g_esPlayer[tank].g_iLight[iLight] = EntRefToEntIndex(g_esPlayer[tank].g_iLight[iLight]);
				if (bIsValidEntity(g_esPlayer[tank].g_iLight[iLight]))
				{
					SDKUnhook(g_esPlayer[tank].g_iLight[iLight], SDKHook_SetTransmit, SetTransmit);
					RemoveEntity(g_esPlayer[tank].g_iLight[iLight]);

					if (g_esCache[tank].g_iPropsAttached & MT_PROP_LIGHT)
					{
						vLightProp(tank, iLight, flOrigin, flAngles);
					}
				}
			}
		}

		GetClientEyePosition(tank, flOrigin);
		GetClientAbsAngles(tank, flAngles);

		for (int iOzTank = 0; iOzTank < sizeof(esPlayer::g_iOzTank); iOzTank++)
		{
			if ((g_esPlayer[tank].g_iOzTank[iOzTank] == 0 || g_esPlayer[tank].g_iOzTank[iOzTank] == INVALID_ENT_REFERENCE) && GetRandomFloat(0.1, 100.0) <= g_esCache[tank].g_flPropsChance[2] && (g_esCache[tank].g_iPropsAttached & MT_PROP_OXYGENTANK))
			{
				g_esPlayer[tank].g_iOzTank[iOzTank] = CreateEntityByName("prop_dynamic_override");
				if (bIsValidEntity(g_esPlayer[tank].g_iOzTank[iOzTank]))
				{
					SetEntityModel(g_esPlayer[tank].g_iOzTank[iOzTank], MODEL_JETPACK);
					SetEntityRenderColor(g_esPlayer[tank].g_iOzTank[iOzTank], g_esCache[tank].g_iOzTankColor[0], g_esCache[tank].g_iOzTankColor[1], g_esCache[tank].g_iOzTankColor[2], g_esCache[tank].g_iOzTankColor[3]);

					vSetEntityParent(g_esPlayer[tank].g_iOzTank[iOzTank], tank, true);

					switch (iOzTank)
					{
						case 0:
						{
							SetVariantString("rfoot");
							vSetVector(flOrigin, 0.0, 30.0, 8.0);
						}
						case 1:
						{
							SetVariantString("lfoot");
							vSetVector(flOrigin, 0.0, 30.0, -8.0);
						}
					}

					AcceptEntityInput(g_esPlayer[tank].g_iOzTank[iOzTank], "SetParentAttachment");

					float flAngles2[3];
					vSetVector(flAngles2, 0.0, 0.0, 1.0);
					GetVectorAngles(flAngles2, flAngles2);
					vCopyVector(flAngles, flAngles2);
					flAngles2[2] += 90.0;
					DispatchKeyValueVector(g_esPlayer[tank].g_iOzTank[iOzTank], "origin", flOrigin);
					DispatchKeyValueVector(g_esPlayer[tank].g_iOzTank[iOzTank], "angles", flAngles2);

					AcceptEntityInput(g_esPlayer[tank].g_iOzTank[iOzTank], "Enable");
					AcceptEntityInput(g_esPlayer[tank].g_iOzTank[iOzTank], "DisableCollision");

					TeleportEntity(g_esPlayer[tank].g_iOzTank[iOzTank], flOrigin, NULL_VECTOR, flAngles2);
					DispatchSpawn(g_esPlayer[tank].g_iOzTank[iOzTank]);

					SDKHook(g_esPlayer[tank].g_iOzTank[iOzTank], SDKHook_SetTransmit, SetTransmit);
					g_esPlayer[tank].g_iOzTank[iOzTank] = EntIndexToEntRef(g_esPlayer[tank].g_iOzTank[iOzTank]);

					if ((g_esPlayer[tank].g_iFlame[iOzTank] == 0 || g_esPlayer[tank].g_iFlame[iOzTank] == INVALID_ENT_REFERENCE) && GetRandomFloat(0.1, 100.0) <= g_esCache[tank].g_flPropsChance[3] && (g_esCache[tank].g_iPropsAttached & MT_PROP_FLAME))
					{
						g_esPlayer[tank].g_iFlame[iOzTank] = CreateEntityByName("env_steam");
						if (bIsValidEntity(g_esPlayer[tank].g_iFlame[iOzTank]))
						{
							SetEntityRenderColor(g_esPlayer[tank].g_iFlame[iOzTank], g_esCache[tank].g_iFlameColor[0], g_esCache[tank].g_iFlameColor[1], g_esCache[tank].g_iFlameColor[2], g_esCache[tank].g_iFlameColor[3]);

							DispatchKeyValue(g_esPlayer[tank].g_iFlame[iOzTank], "spawnflags", "1");
							DispatchKeyValue(g_esPlayer[tank].g_iFlame[iOzTank], "Type", "0");
							DispatchKeyValue(g_esPlayer[tank].g_iFlame[iOzTank], "InitialState", "1");
							DispatchKeyValue(g_esPlayer[tank].g_iFlame[iOzTank], "Spreadspeed", "1");
							DispatchKeyValue(g_esPlayer[tank].g_iFlame[iOzTank], "Speed", "250");
							DispatchKeyValue(g_esPlayer[tank].g_iFlame[iOzTank], "Startsize", "6");
							DispatchKeyValue(g_esPlayer[tank].g_iFlame[iOzTank], "EndSize", "8");
							DispatchKeyValue(g_esPlayer[tank].g_iFlame[iOzTank], "Rate", "555");
							DispatchKeyValue(g_esPlayer[tank].g_iFlame[iOzTank], "JetLength", "40");

							vSetEntityParent(g_esPlayer[tank].g_iFlame[iOzTank], g_esPlayer[tank].g_iOzTank[iOzTank], true);

							float flOrigin2[3], flAngles3[3];
							vSetVector(flOrigin2, -2.0, 0.0, 26.0);
							vSetVector(flAngles3, 0.0, 0.0, 1.0);
							GetVectorAngles(flAngles3, flAngles3);

							TeleportEntity(g_esPlayer[tank].g_iFlame[iOzTank], flOrigin2, flAngles3, NULL_VECTOR);
							DispatchSpawn(g_esPlayer[tank].g_iFlame[iOzTank]);
							AcceptEntityInput(g_esPlayer[tank].g_iFlame[iOzTank], "TurnOn");

							SDKHook(g_esPlayer[tank].g_iFlame[iOzTank], SDKHook_SetTransmit, SetTransmit);
							g_esPlayer[tank].g_iFlame[iOzTank] = EntIndexToEntRef(g_esPlayer[tank].g_iFlame[iOzTank]);
						}
					}
				}
			}
			else if (bIsValidEntRef(g_esPlayer[tank].g_iOzTank[iOzTank]))
			{
				g_esPlayer[tank].g_iOzTank[iOzTank] = EntRefToEntIndex(g_esPlayer[tank].g_iOzTank[iOzTank]);
				if (bIsValidEntity(g_esPlayer[tank].g_iOzTank[iOzTank]))
				{
					if (g_esCache[tank].g_iPropsAttached & MT_PROP_OXYGENTANK)
					{
						SetEntityRenderColor(g_esPlayer[tank].g_iOzTank[iOzTank], g_esCache[tank].g_iOzTankColor[0], g_esCache[tank].g_iOzTankColor[1], g_esCache[tank].g_iOzTankColor[2], g_esCache[tank].g_iOzTankColor[3]);
					}
					else
					{
						SDKUnhook(g_esPlayer[tank].g_iOzTank[iOzTank], SDKHook_SetTransmit, SetTransmit);
						RemoveEntity(g_esPlayer[tank].g_iOzTank[iOzTank]);

						g_esPlayer[tank].g_iOzTank[iOzTank] = INVALID_ENT_REFERENCE;
					}
				}

				if (bIsValidEntRef(g_esPlayer[tank].g_iFlame[iOzTank]))
				{
					g_esPlayer[tank].g_iFlame[iOzTank] = EntRefToEntIndex(g_esPlayer[tank].g_iFlame[iOzTank]);
					if (bIsValidEntity(g_esPlayer[tank].g_iFlame[iOzTank]))
					{
						if (g_esCache[tank].g_iPropsAttached & MT_PROP_FLAME)
						{
							SetEntityRenderColor(g_esPlayer[tank].g_iFlame[iOzTank], g_esCache[tank].g_iFlameColor[0], g_esCache[tank].g_iFlameColor[1], g_esCache[tank].g_iFlameColor[2], g_esCache[tank].g_iFlameColor[3]);
						}
						else
						{
							SDKUnhook(g_esPlayer[tank].g_iFlame[iOzTank], SDKHook_SetTransmit, SetTransmit);
							RemoveEntity(g_esPlayer[tank].g_iFlame[iOzTank]);

							g_esPlayer[tank].g_iFlame[iOzTank] = INVALID_ENT_REFERENCE;
						}
					}
				}
			}
		}

		GetEntPropVector(tank, Prop_Send, "m_vecOrigin", flOrigin);
		GetEntPropVector(tank, Prop_Send, "m_angRotation", flAngles);

		for (int iRock = 0; iRock < sizeof(esPlayer::g_iRock); iRock++)
		{
			if ((g_esPlayer[tank].g_iRock[iRock] == 0 || g_esPlayer[tank].g_iRock[iRock] == INVALID_ENT_REFERENCE) && GetRandomFloat(0.1, 100.0) <= g_esCache[tank].g_flPropsChance[4] && (g_esCache[tank].g_iPropsAttached & MT_PROP_ROCK))
			{
				g_esPlayer[tank].g_iRock[iRock] = CreateEntityByName("prop_dynamic_override");
				if (bIsValidEntity(g_esPlayer[tank].g_iRock[iRock]))
				{
					SetEntityRenderColor(g_esPlayer[tank].g_iRock[iRock], g_esCache[tank].g_iRockColor[0], g_esCache[tank].g_iRockColor[1], g_esCache[tank].g_iRockColor[2], g_esCache[tank].g_iRockColor[3]);
					vSetRockModel(tank, g_esPlayer[tank].g_iRock[iRock]);

					DispatchKeyValueVector(g_esPlayer[tank].g_iRock[iRock], "origin", flOrigin);
					DispatchKeyValueVector(g_esPlayer[tank].g_iRock[iRock], "angles", flAngles);
					vSetEntityParent(g_esPlayer[tank].g_iRock[iRock], tank, true);

					switch (iRock)
					{
						case 0, 4, 8, 12, 16: SetVariantString("rshoulder");
						case 1, 5, 9, 13, 17: SetVariantString("lshoulder");
						case 2, 6, 10, 14, 18: SetVariantString("relbow");
						case 3, 7, 11, 15, 19: SetVariantString("lelbow");
					}

					AcceptEntityInput(g_esPlayer[tank].g_iRock[iRock], "SetParentAttachment");
					AcceptEntityInput(g_esPlayer[tank].g_iRock[iRock], "Enable");
					AcceptEntityInput(g_esPlayer[tank].g_iRock[iRock], "DisableCollision");

					if (bIsValidGame())
					{
						switch (iRock)
						{
							case 0, 1, 4, 5, 8, 9, 12, 13, 16, 17: SetEntPropFloat(g_esPlayer[tank].g_iRock[iRock], Prop_Data, "m_flModelScale", 0.4);
							case 2, 3, 6, 7, 10, 11, 14, 15, 18, 19: SetEntPropFloat(g_esPlayer[tank].g_iRock[iRock], Prop_Data, "m_flModelScale", 0.5);
						}
					}

					flAngles[0] += GetRandomFloat(-90.0, 90.0);
					flAngles[1] += GetRandomFloat(-90.0, 90.0);
					flAngles[2] += GetRandomFloat(-90.0, 90.0);

					TeleportEntity(g_esPlayer[tank].g_iRock[iRock], NULL_VECTOR, flAngles, NULL_VECTOR);
					DispatchSpawn(g_esPlayer[tank].g_iRock[iRock]);

					SDKHook(g_esPlayer[tank].g_iRock[iRock], SDKHook_SetTransmit, SetTransmit);
					g_esPlayer[tank].g_iRock[iRock] = EntIndexToEntRef(g_esPlayer[tank].g_iRock[iRock]);
				}
			}
			else if (bIsValidEntRef(g_esPlayer[tank].g_iRock[iRock]))
			{
				g_esPlayer[tank].g_iRock[iRock] = EntRefToEntIndex(g_esPlayer[tank].g_iRock[iRock]);
				if (bIsValidEntity(g_esPlayer[tank].g_iRock[iRock]))
				{
					if (g_esCache[tank].g_iPropsAttached & MT_PROP_ROCK)
					{
						SetEntityRenderColor(g_esPlayer[tank].g_iRock[iRock], g_esCache[tank].g_iRockColor[0], g_esCache[tank].g_iRockColor[1], g_esCache[tank].g_iRockColor[2], g_esCache[tank].g_iRockColor[3]);
						vSetRockModel(tank, g_esPlayer[tank].g_iRock[iRock]);
					}
					else
					{
						SDKUnhook(g_esPlayer[tank].g_iRock[iRock], SDKHook_SetTransmit, SetTransmit);
						RemoveEntity(g_esPlayer[tank].g_iRock[iRock]);

						g_esPlayer[tank].g_iRock[iRock] = INVALID_ENT_REFERENCE;
					}
				}
			}
		}

		GetEntPropVector(tank, Prop_Send, "m_vecOrigin", flOrigin);
		GetEntPropVector(tank, Prop_Send, "m_angRotation", flAngles);
		flAngles[0] += 90.0;

		for (int iTire = 0; iTire < sizeof(esPlayer::g_iTire); iTire++)
		{
			if ((g_esPlayer[tank].g_iTire[iTire] == 0 || g_esPlayer[tank].g_iTire[iTire] == INVALID_ENT_REFERENCE) && GetRandomFloat(0.1, 100.0) <= g_esCache[tank].g_flPropsChance[5] && (g_esCache[tank].g_iPropsAttached & MT_PROP_TIRE))
			{
				g_esPlayer[tank].g_iTire[iTire] = CreateEntityByName("prop_dynamic_override");
				if (bIsValidEntity(g_esPlayer[tank].g_iTire[iTire]))
				{
					SetEntityModel(g_esPlayer[tank].g_iTire[iTire], MODEL_TIRES);
					SetEntityRenderColor(g_esPlayer[tank].g_iTire[iTire], g_esCache[tank].g_iTireColor[0], g_esCache[tank].g_iTireColor[1], g_esCache[tank].g_iTireColor[2], g_esCache[tank].g_iTireColor[3]);

					DispatchKeyValueVector(g_esPlayer[tank].g_iTire[iTire], "origin", flOrigin);
					DispatchKeyValueVector(g_esPlayer[tank].g_iTire[iTire], "angles", flAngles);
					vSetEntityParent(g_esPlayer[tank].g_iTire[iTire], tank, true);

					switch (iTire)
					{
						case 0: SetVariantString("rfoot");
						case 1: SetVariantString("lfoot");
					}

					AcceptEntityInput(g_esPlayer[tank].g_iTire[iTire], "SetParentAttachment");
					AcceptEntityInput(g_esPlayer[tank].g_iTire[iTire], "Enable");
					AcceptEntityInput(g_esPlayer[tank].g_iTire[iTire], "DisableCollision");

					if (bIsValidGame())
					{
						SetEntPropFloat(g_esPlayer[tank].g_iTire[iTire], Prop_Data, "m_flModelScale", 1.5);
					}

					TeleportEntity(g_esPlayer[tank].g_iTire[iTire], NULL_VECTOR, flAngles, NULL_VECTOR);
					DispatchSpawn(g_esPlayer[tank].g_iTire[iTire]);

					SDKHook(g_esPlayer[tank].g_iTire[iTire], SDKHook_SetTransmit, SetTransmit);
					g_esPlayer[tank].g_iTire[iTire] = EntIndexToEntRef(g_esPlayer[tank].g_iTire[iTire]);
				}
			}
			else if (bIsValidEntRef(g_esPlayer[tank].g_iTire[iTire]))
			{
				g_esPlayer[tank].g_iTire[iTire] = EntRefToEntIndex(g_esPlayer[tank].g_iTire[iTire]);
				if (bIsValidEntity(g_esPlayer[tank].g_iTire[iTire]))
				{
					if (g_esCache[tank].g_iPropsAttached & MT_PROP_TIRE)
					{
						SetEntityRenderColor(g_esPlayer[tank].g_iTire[iTire], g_esCache[tank].g_iTireColor[0], g_esCache[tank].g_iTireColor[1], g_esCache[tank].g_iTireColor[2], g_esCache[tank].g_iTireColor[3]);
					}
					else
					{
						SDKUnhook(g_esPlayer[tank].g_iTire[iTire], SDKHook_SetTransmit, SetTransmit);
						RemoveEntity(g_esPlayer[tank].g_iTire[iTire]);

						g_esPlayer[tank].g_iTire[iTire] = INVALID_ENT_REFERENCE;
					}
				}
			}
		}

		GetEntPropVector(tank, Prop_Send, "m_vecOrigin", flOrigin);
		GetEntPropVector(tank, Prop_Send, "m_angRotation", flAngles);

		if ((g_esPlayer[tank].g_iPropaneTank == 0 || g_esPlayer[tank].g_iPropaneTank == INVALID_ENT_REFERENCE) && GetRandomFloat(0.1, 100.0) <= g_esCache[tank].g_flPropsChance[6] && (g_esCache[tank].g_iPropsAttached & MT_PROP_PROPANETANK))
		{
			g_esPlayer[tank].g_iPropaneTank = CreateEntityByName("prop_dynamic_override");
			if (bIsValidEntity(g_esPlayer[tank].g_iPropaneTank))
			{
				SetEntityModel(g_esPlayer[tank].g_iPropaneTank, MODEL_PROPANETANK);
				SetEntityRenderColor(g_esPlayer[tank].g_iPropaneTank, g_esCache[tank].g_iPropTankColor[0], g_esCache[tank].g_iPropTankColor[1], g_esCache[tank].g_iPropTankColor[2], g_esCache[tank].g_iPropTankColor[3]);

				DispatchKeyValueVector(g_esPlayer[tank].g_iPropaneTank, "origin", flOrigin);
				DispatchKeyValueVector(g_esPlayer[tank].g_iPropaneTank, "angles", flAngles);
				vSetEntityParent(g_esPlayer[tank].g_iPropaneTank, tank, true);

				SetVariantString("mouth");
				vSetVector(flOrigin, 10.0, 5.0, 0.0);
				vSetVector(flAngles, 60.0, 0.0, -90.0);
				AcceptEntityInput(g_esPlayer[tank].g_iPropaneTank, "SetParentAttachment");
				AcceptEntityInput(g_esPlayer[tank].g_iPropaneTank, "Enable");
				AcceptEntityInput(g_esPlayer[tank].g_iPropaneTank, "DisableCollision");

				if (bIsValidGame())
				{
					SetEntPropFloat(g_esPlayer[tank].g_iPropaneTank, Prop_Data, "m_flModelScale", 1.1);
				}

				TeleportEntity(g_esPlayer[tank].g_iPropaneTank, flOrigin, flAngles, NULL_VECTOR);
				DispatchSpawn(g_esPlayer[tank].g_iPropaneTank);

				SDKHook(g_esPlayer[tank].g_iPropaneTank, SDKHook_SetTransmit, SetTransmit);
				g_esPlayer[tank].g_iPropaneTank = EntIndexToEntRef(g_esPlayer[tank].g_iPropaneTank);
			}
		}
		else if (bIsValidEntRef(g_esPlayer[tank].g_iPropaneTank))
		{
			g_esPlayer[tank].g_iPropaneTank = EntRefToEntIndex(g_esPlayer[tank].g_iPropaneTank);
			if (bIsValidEntity(g_esPlayer[tank].g_iPropaneTank))
			{
				if (g_esCache[tank].g_iPropsAttached & MT_PROP_PROPANETANK)
				{
					SetEntityRenderColor(g_esPlayer[tank].g_iPropaneTank, g_esCache[tank].g_iPropTankColor[0], g_esCache[tank].g_iPropTankColor[1], g_esCache[tank].g_iPropTankColor[2], g_esCache[tank].g_iPropTankColor[3]);
				}
				else
				{
					SDKUnhook(g_esPlayer[tank].g_iPropaneTank, SDKHook_SetTransmit, SetTransmit);
					RemoveEntity(g_esPlayer[tank].g_iPropaneTank);

					g_esPlayer[tank].g_iPropaneTank = INVALID_ENT_REFERENCE;
				}
			}
		}
	}
}

static void vSetRockModel(int tank, int rock)
{
	switch (g_esCache[tank].g_iRockModel)
	{
		case 0: SetEntityModel(rock, MODEL_CONCRETE_CHUNK);
		case 1: SetEntityModel(rock, MODEL_TREE_TRUNK);
		case 2: SetEntityModel(rock, (GetRandomInt(0, 1) == 0 ? MODEL_CONCRETE_CHUNK : MODEL_TREE_TRUNK));
	}
}

static void vAnnounceArrival(int tank, const char[] name)
{
	if (g_esCache[tank].g_iAnnounceArrival & MT_ARRIVAL_SPAWN)
	{
		switch (GetRandomInt(1, 10))
		{
			case 1: MT_PrintToChatAll("%s %t", MT_TAG2, "Arrival1", name);
			case 2: MT_PrintToChatAll("%s %t", MT_TAG2, "Arrival2", name);
			case 3: MT_PrintToChatAll("%s %t", MT_TAG2, "Arrival3", name);
			case 4: MT_PrintToChatAll("%s %t", MT_TAG2, "Arrival4", name);
			case 5: MT_PrintToChatAll("%s %t", MT_TAG2, "Arrival5", name);
			case 6: MT_PrintToChatAll("%s %t", MT_TAG2, "Arrival6", name);
			case 7: MT_PrintToChatAll("%s %t", MT_TAG2, "Arrival7", name);
			case 8: MT_PrintToChatAll("%s %t", MT_TAG2, "Arrival8", name);
			case 9: MT_PrintToChatAll("%s %t", MT_TAG2, "Arrival9", name);
			case 10: MT_PrintToChatAll("%s %t", MT_TAG2, "Arrival10", name);
		}
	}
}

static void vLightProp(int tank, int light, float origin[3], float angles[3])
{
	g_esPlayer[tank].g_iLight[light] = CreateEntityByName("beam_spotlight");
	if (bIsValidEntity(g_esPlayer[tank].g_iLight[light]))
	{
		DispatchKeyValueVector(g_esPlayer[tank].g_iLight[light], "origin", origin);
		DispatchKeyValueVector(g_esPlayer[tank].g_iLight[light], "angles", angles);

		DispatchKeyValue(g_esPlayer[tank].g_iLight[light], "spotlightwidth", "10");
		DispatchKeyValue(g_esPlayer[tank].g_iLight[light], "spotlightlength", "60");
		DispatchKeyValue(g_esPlayer[tank].g_iLight[light], "spawnflags", "3");

		SetEntityRenderColor(g_esPlayer[tank].g_iLight[light], g_esCache[tank].g_iLightColor[0], g_esCache[tank].g_iLightColor[1], g_esCache[tank].g_iLightColor[2], g_esCache[tank].g_iLightColor[3]);

		DispatchKeyValue(g_esPlayer[tank].g_iLight[light], "maxspeed", "100");
		DispatchKeyValue(g_esPlayer[tank].g_iLight[light], "HDRColorScale", "0.7");
		DispatchKeyValue(g_esPlayer[tank].g_iLight[light], "fadescale", "1");
		DispatchKeyValue(g_esPlayer[tank].g_iLight[light], "fademindist", "-1");

		vSetEntityParent(g_esPlayer[tank].g_iLight[light], tank, true);

		switch (light)
		{
			case 0:
			{
				SetVariantString("mouth");
				vSetVector(angles, -90.0, 0.0, 0.0);
			}
			case 1:
			{
				SetVariantString("rhand");
				vSetVector(angles, 90.0, 0.0, 0.0);
			}
			case 2:
			{
				SetVariantString("lhand");
				vSetVector(angles, -90.0, 0.0, 0.0);
			}
		}

		AcceptEntityInput(g_esPlayer[tank].g_iLight[light], "SetParentAttachment");
		AcceptEntityInput(g_esPlayer[tank].g_iLight[light], "Enable");
		AcceptEntityInput(g_esPlayer[tank].g_iLight[light], "DisableCollision");

		TeleportEntity(g_esPlayer[tank].g_iLight[light], NULL_VECTOR, angles, NULL_VECTOR);
		DispatchSpawn(g_esPlayer[tank].g_iLight[light]);

		SDKHook(g_esPlayer[tank].g_iLight[light], SDKHook_SetTransmit, SetTransmit);
		g_esPlayer[tank].g_iLight[light] = EntIndexToEntRef(g_esPlayer[tank].g_iLight[light]);
	}
}

static void vParticleEffects(int tank)
{
	if (bIsTankAllowed(tank) && g_esCache[tank].g_iBodyEffects > 0)
	{
		if ((g_esCache[tank].g_iBodyEffects & MT_PARTICLE_BLOOD) && !g_esPlayer[tank].g_bBlood)
		{
			g_esPlayer[tank].g_bBlood = true;

			CreateTimer(0.75, tTimerBloodEffect, GetClientUserId(tank), TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
		}

		if ((g_esCache[tank].g_iBodyEffects & MT_PARTICLE_ELECTRICITY) && !g_esPlayer[tank].g_bElectric)
		{
			g_esPlayer[tank].g_bElectric = true;

			CreateTimer(0.75, tTimerElectricEffect, GetClientUserId(tank), TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
		}

		if ((g_esCache[tank].g_iBodyEffects & MT_PARTICLE_FIRE) && !g_esPlayer[tank].g_bFire)
		{
			g_esPlayer[tank].g_bFire = true;

			CreateTimer(0.75, tTimerFireEffect, GetClientUserId(tank), TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
		}

		if ((g_esCache[tank].g_iBodyEffects & MT_PARTICLE_ICE) && !g_esPlayer[tank].g_bIce)
		{
			g_esPlayer[tank].g_bIce = true;

			CreateTimer(2.0, tTimerIceEffect, GetClientUserId(tank), TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
		}

		if ((g_esCache[tank].g_iBodyEffects & MT_PARTICLE_METEOR) && !g_esPlayer[tank].g_bMeteor)
		{
			g_esPlayer[tank].g_bMeteor = true;

			CreateTimer(6.0, tTimerMeteorEffect, GetClientUserId(tank), TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
		}

		if ((g_esCache[tank].g_iBodyEffects & MT_PARTICLE_SMOKE) && !g_esPlayer[tank].g_bSmoke)
		{
			g_esPlayer[tank].g_bSmoke = true;

			CreateTimer(1.5, tTimerSmokeEffect, GetClientUserId(tank), TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
		}

		if ((g_esCache[tank].g_iBodyEffects & MT_PARTICLE_SPIT) && bIsValidGame() && !g_esPlayer[tank].g_bSpit)
		{
			g_esPlayer[tank].g_bSpit = true;

			CreateTimer(2.0, tTimerSpitEffect, GetClientUserId(tank), TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
		}
	}
}

static void vFirstTank(int wave)
{
	int iType = GetRandomInt(g_esGeneral.g_iFinaleMinTypes[wave], g_esGeneral.g_iFinaleMaxTypes[wave]);
	if (iType == 0 || g_esTank[iType].g_iTankEnabled == 0 || g_esTank[iType].g_iSpawnEnabled == 0 || !bIsTypeAvailable(iType) || !bCanTypeSpawn(iType) || g_esGeneral.g_iFinaleMinTypes[wave] == 0 || g_esGeneral.g_iFinaleMaxTypes[wave] == 0)
	{
		int iChosen = iChooseType(2);
		if (iChosen > 0)
		{
			g_esGeneral.g_iType = iChosen;

			int iRealType = iGetRealType(g_esGeneral.g_iType, 2);
			if (iRealType == 0)
			{
				g_esGeneral.g_iType = 0;
			}
		}
	}
	else
	{
		g_esGeneral.g_iType = iType;
	}
}

static void vMutateTank(int tank)
{
	if (bCanTypeSpawn())
	{
		switch (g_esGeneral.g_iTankWave)
		{
			case 0: vTankCountCheck(tank, g_esGeneral.g_iRegularAmount);
			case 1: vTankCountCheck(tank, g_esGeneral.g_iFinaleWave[g_esGeneral.g_iTankWave - 1]);
			case 2: vTankCountCheck(tank, g_esGeneral.g_iFinaleWave[g_esGeneral.g_iTankWave - 1]);
			case 3: vTankCountCheck(tank, g_esGeneral.g_iFinaleWave[g_esGeneral.g_iTankWave - 1]);
		}

		int iType;
		if (g_esGeneral.g_iType <= 0 && g_esPlayer[tank].g_iTankType <= 0)
		{
			int iChosen = iChooseType(1, tank);
			if (iChosen > 0)
			{
				iType = iChosen;

				int iRealType = iGetRealType(iType, tank, 1);
				if (iRealType > 0)
				{
					vSetColor(tank, iRealType);
				}
			}
		}
		else
		{
			iType = (g_esGeneral.g_iType > 0) ? g_esGeneral.g_iType : g_esPlayer[tank].g_iTankType;
			vSetColor(tank, iType);
		}

		g_esGeneral.g_iType = 0;

		vTankSpawn(tank);

		CreateTimer(0.1, tTimerCheckView, GetClientUserId(tank), TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
		CreateTimer(1.0, tTimerTankUpdate, GetClientUserId(tank), TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);

		switch (g_esTank[g_esPlayer[tank].g_iTankType].g_iSpawnMode)
		{
			case 1:
			{
				if (!g_esPlayer[tank].g_bBoss)
				{
					vSpawnModes(tank, true);

					DataPack dpBoss;
					CreateDataTimer(1.0, tTimerBoss, dpBoss, TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
					dpBoss.WriteCell(GetClientUserId(tank));
					dpBoss.WriteCell(g_esCache[tank].g_iBossStages);

					for (int iPos = 0; iPos < sizeof(esCache::g_iBossHealth); iPos++)
					{
						dpBoss.WriteCell(g_esCache[tank].g_iBossHealth[iPos]);
						dpBoss.WriteCell(g_esCache[tank].g_iBossType[iPos]);
					}
				}
			}
			case 2:
			{
				if (!g_esPlayer[tank].g_bRandomized)
				{
					vSpawnModes(tank, true);

					CreateTimer(g_esCache[tank].g_flRandomInterval, tTimerRandomize, GetClientUserId(tank), TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
				}
			}
			case 3:
			{
				if (!g_esPlayer[tank].g_bTransformed)
				{
					vSpawnModes(tank, true);

					CreateTimer(g_esCache[tank].g_flTransformDelay, tTimerTransform, GetClientUserId(tank), TIMER_FLAG_NO_MAPCHANGE);

					DataPack dpUntransform;
					CreateDataTimer(g_esCache[tank].g_flTransformDuration + g_esCache[tank].g_flTransformDelay, tTimerUntransform, dpUntransform, TIMER_FLAG_NO_MAPCHANGE);
					dpUntransform.WriteCell(GetClientUserId(tank));
					dpUntransform.WriteCell(g_esPlayer[tank].g_iTankType);
				}
			}
		}

		if (bIsTank(tank, MT_CHECK_FAKECLIENT) && g_esPlayer[tank].g_iFavoriteType > 0 && iType != g_esPlayer[tank].g_iFavoriteType)
		{
			vFavoriteMenu(tank);
		}

		if (GetEntProp(tank, Prop_Send, "m_isGhost") == 0)
		{
			g_esPlayer[tank].g_bKeepCurrentType = false;
		}
	}
}

static void vFavoriteMenu(int admin)
{
	Menu mFavoriteMenu = new Menu(iFavoriteMenuHandler, MENU_ACTIONS_DEFAULT|MenuAction_Display|MenuAction_DisplayItem);
	mFavoriteMenu.SetTitle("Use your favorite Mutant Tank type?");
	mFavoriteMenu.AddItem("Yes", "Yes");
	mFavoriteMenu.AddItem("No", "No");
	mFavoriteMenu.Display(admin, MENU_TIME_FOREVER);
}

public int iFavoriteMenuHandler(Menu menu, MenuAction action, int param1, int param2)
{
	switch (action)
	{
		case MenuAction_End: delete menu;
		case MenuAction_Select:
		{
			switch (param2)
			{
				case 0: vQueueTank(param1, g_esPlayer[param1].g_iFavoriteType, false);
				case 1: MT_PrintToChat(param1, "%s %t", MT_TAG3, "FavoriteUnused");
			}
		}
		case MenuAction_Display:
		{
			char sMenuTitle[PLATFORM_MAX_PATH];
			Panel panel = view_as<Panel>(param2);
			FormatEx(sMenuTitle, sizeof(sMenuTitle), "%T", "MTFavoriteMenu", param1);
			panel.SetTitle(sMenuTitle);
		}
		case MenuAction_DisplayItem:
		{
			char sMenuOption[PLATFORM_MAX_PATH];

			switch (param2)
			{
				case 0:
				{
					FormatEx(sMenuOption, sizeof(sMenuOption), "%T", "OptionYes", param1);

					return RedrawMenuItem(sMenuOption);
				}
				case 1:
				{
					FormatEx(sMenuOption, sizeof(sMenuOption), "%T", "OptionNo", param1);

					return RedrawMenuItem(sMenuOption);
				}
			}
		}
	}

	return 0;
}

static void vTankCountCheck(int tank, int amount)
{
	if (amount == 0 || iGetTankCount() == amount || (g_esGeneral.g_iTankWave == 0 && (g_esGeneral.g_iRegularMode == 1 || g_esGeneral.g_iRegularWave == 0)))
	{
		return;
	}

	if (iGetTankCount() < amount)
	{
		CreateTimer(3.0, tTimerSpawnTanks, amount, TIMER_FLAG_NO_MAPCHANGE);
	}
	else if (iGetTankCount() > amount)
	{
		switch (bIsValidClient(tank, MT_CHECK_FAKECLIENT))
		{
			case true: ForcePlayerSuicide(tank);
			case false: KickClient(tank);
		}
	}
}

static void vTankSpawn(int tank, int mode = 0)
{
	DataPack dpTankSpawn = new DataPack();
	RequestFrame(vTankSpawnFrame, dpTankSpawn);
	dpTankSpawn.WriteCell(GetClientUserId(tank));
	dpTankSpawn.WriteCell(mode);
}

public void vTankSpawnFrame(DataPack pack)
{
	pack.Reset();

	static int iTank, iMode;
	iTank = GetClientOfUserId(pack.ReadCell()), iMode = pack.ReadCell();
	delete pack;
	if (bIsTankAllowed(iTank) && bHasCoreAdminAccess(iTank))
	{
		vCacheSettings(iTank);
		vParticleEffects(iTank);
		vThrowInterval(iTank);

		static char sCurrentName[33];
		GetClientName(iTank, sCurrentName, sizeof(sCurrentName));
		if (sCurrentName[0] == '\0')
		{
			sCurrentName = "Tank";
		}

		if (g_esCache[iTank].g_sTankName[0] == '\0')
		{
			g_esCache[iTank].g_sTankName = "Tank";
		}

		vSetName(iTank, sCurrentName, g_esCache[iTank].g_sTankName, iMode);
		vSetProps(iTank);

		if (iMode == 0)
		{
			if (bIsCloneAllowed(iTank))
			{
				static int iHumanCount, iSpawnHealth, iExtraHealthNormal, iExtraHealthBoost, iExtraHealthBoost2, iExtraHealthBoost3, iNoBoost, iBoost,
					iBoost2, iBoost3, iNegaNoBoost, iNegaBoost, iNegaBoost2, iNegaBoost3, iFinalNoHealth, iFinalHealth, iFinalHealth2, iFinalHealth3;
				iHumanCount = iGetHumanCount();
				iSpawnHealth = (g_esGeneral.g_iBaseHealth > 0) ? g_esGeneral.g_iBaseHealth : GetClientHealth(iTank);
				iExtraHealthNormal = iSpawnHealth + g_esCache[iTank].g_iExtraHealth;
				iExtraHealthBoost = (iHumanCount > 1) ? ((iSpawnHealth * iHumanCount) + g_esCache[iTank].g_iExtraHealth) : iExtraHealthNormal;
				iExtraHealthBoost2 = (iHumanCount > 1) ? (iSpawnHealth + (iHumanCount * g_esCache[iTank].g_iExtraHealth)) : iExtraHealthNormal;
				iExtraHealthBoost3 = (iHumanCount > 1) ? (iHumanCount * (iSpawnHealth + g_esCache[iTank].g_iExtraHealth)) : iExtraHealthNormal;
				iNoBoost = (iExtraHealthNormal > MT_MAXHEALTH) ? MT_MAXHEALTH : iExtraHealthNormal;
				iBoost = (iExtraHealthBoost > MT_MAXHEALTH) ? MT_MAXHEALTH : iExtraHealthBoost;
				iBoost2 = (iExtraHealthBoost2 > MT_MAXHEALTH) ? MT_MAXHEALTH : iExtraHealthBoost2;
				iBoost3 = (iExtraHealthBoost3 > MT_MAXHEALTH) ? MT_MAXHEALTH : iExtraHealthBoost3;
				iNegaNoBoost = (iExtraHealthNormal < iSpawnHealth) ? 1 : iExtraHealthNormal;
				iNegaBoost = (iExtraHealthBoost < iSpawnHealth) ? 1 : iExtraHealthBoost;
				iNegaBoost2 = (iExtraHealthBoost2 < iSpawnHealth) ? 1 : iExtraHealthBoost2;
				iNegaBoost3 = (iExtraHealthBoost3 < iSpawnHealth) ? 1 : iExtraHealthBoost3;
				iFinalNoHealth = (iExtraHealthNormal >= 0) ? iNoBoost : iNegaNoBoost;
				iFinalHealth = (iExtraHealthNormal >= 0) ? iBoost : iNegaBoost;
				iFinalHealth2 = (iExtraHealthNormal >= 0) ? iBoost2 : iNegaBoost2;
				iFinalHealth3 = (iExtraHealthNormal >= 0) ? iBoost3 : iNegaBoost3;
				//SetEntityHealth(iTank, iFinalNoHealth);
				SetEntProp(iTank, Prop_Data, "m_iHealth", iFinalNoHealth);
				SetEntProp(iTank, Prop_Data, "m_iMaxHealth", iFinalNoHealth);

				switch (g_esCache[iTank].g_iMultiHealth)
				{
					case 1:
					{
						//SetEntityHealth(iTank, iFinalHealth);
						SetEntProp(iTank, Prop_Data, "m_iHealth", iFinalHealth);
						SetEntProp(iTank, Prop_Data, "m_iMaxHealth", iFinalHealth);
					}
					case 2:
					{
						//SetEntityHealth(iTank, iFinalHealth2);
						SetEntProp(iTank, Prop_Data, "m_iHealth", iFinalHealth2);
						SetEntProp(iTank, Prop_Data, "m_iMaxHealth", iFinalHealth2);
					}
					case 3:
					{
						//SetEntityHealth(iTank, iFinalHealth3);
						SetEntProp(iTank, Prop_Data, "m_iHealth", iFinalHealth3);
						SetEntProp(iTank, Prop_Data, "m_iMaxHealth", iFinalHealth3);
					}
				}

				if (bIsTankAllowed(iTank, MT_CHECK_FAKECLIENT) && g_esTank[g_esPlayer[iTank].g_iTankType].g_iHumanSupport == 1 && bHasCoreAdminAccess(iTank))
				{
					MT_PrintToChat(iTank, "%s %t", MT_TAG3, "SpawnMessage");
					MT_PrintToChat(iTank, "%s %t", MT_TAG2, "AbilityButtons");
					MT_PrintToChat(iTank, "%s %t", MT_TAG2, "AbilityButtons2");
					MT_PrintToChat(iTank, "%s %t", MT_TAG2, "AbilityButtons3");
					MT_PrintToChat(iTank, "%s %t", MT_TAG2, "AbilityButtons4");
				}
			}

			g_esPlayer[iTank].g_iTankHealth = GetClientHealth(iTank);
		}

		vResetSpeed(iTank);

		Call_StartForward(g_esGeneral.g_gfPostTankSpawnForward);
		Call_PushCell(iTank);
		Call_Finish();
	}
}

static void vThrowInterval(int tank)
{
	if (bIsTankAllowed(tank) && g_esCache[tank].g_flThrowInterval > 0.0)
	{
		int iAbility = GetEntPropEnt(tank, Prop_Send, "m_customAbility");
		if (iAbility > 0)
		{
			SetEntPropFloat(iAbility, Prop_Send, "m_duration", g_esCache[tank].g_flThrowInterval);
			SetEntPropFloat(iAbility, Prop_Send, "m_timestamp", GetGameTime() + g_esCache[tank].g_flThrowInterval);
		}
	}
}

static bool bCanTypeSpawn(int type = 0)
{
	static int iCondition;
	iCondition = (type > 0) ? g_esTank[type].g_iFinaleTank : g_esGeneral.g_iFinalesOnly;

	switch (iCondition)
	{
		case 0: return true;
		case 1: return bIsFinaleMap() || g_esGeneral.g_iTankWave > 0;
		case 2: return !bIsFinaleMap() && g_esGeneral.g_iTankWave <= 0;
		case 3: return bIsFinaleMap() && g_esGeneral.g_iTankWave <= 0;
		case 4: return bIsFinaleMap() && g_esGeneral.g_iTankWave > 0;
	}

	return false;
}

static bool bHasAbility(const char[] subsection, int index)
{
	if (g_esGeneral.g_alAbilitySections[0] != null)
	{
		static int iListSize;
		iListSize = (g_esGeneral.g_alAbilitySections[0].Length > 0) ? g_esGeneral.g_alAbilitySections[0].Length : 0;
		if (iListSize > 0)
		{
			if (iListSize - 1 < index)
			{
				return false;
			}

			static char sSub[4][32];
			for (int iPos = 0; iPos < sizeof(sSub); iPos++)
			{
				g_esGeneral.g_alAbilitySections[iPos].GetString(index, sSub[iPos], sizeof(sSub[]));
				if (StrEqual(subsection, sSub[iPos], false))
				{
					return true;
				}
			}
		}
	}

	return false;
}

static bool bHasCoreAdminAccess(int admin, int type = 0)
{
	if (!bIsValidClient(admin, MT_CHECK_INDEX|MT_CHECK_INGAME|MT_CHECK_INKICKQUEUE|MT_CHECK_FAKECLIENT) || bIsDeveloper(admin))
	{
		return true;
	}

	static int iType, iTypePlayerFlags, iPlayerFlags, iAdminFlags, iTypeFlags, iGlobalFlags;
	iType = type > 0 ? type : g_esPlayer[admin].g_iTankType;
	iTypePlayerFlags = g_esAdmin[iType].g_iAccessFlags[admin];
	iPlayerFlags = g_esPlayer[admin].g_iAccessFlags;
	iAdminFlags = GetUserFlagBits(admin);
	iTypeFlags = g_esTank[iType].g_iAccessFlags;
	iGlobalFlags = g_esGeneral.g_iAccessFlags;
	if ((iTypeFlags != 0 && ((!(iTypeFlags & iTypePlayerFlags) && !(iTypePlayerFlags & iTypeFlags)) || (!(iTypeFlags & iPlayerFlags) && !(iPlayerFlags & iTypeFlags)) || (!(iTypeFlags & iAdminFlags) && !(iAdminFlags & iTypeFlags))))
		|| (iGlobalFlags != 0 && ((!(iGlobalFlags & iTypePlayerFlags) && !(iTypePlayerFlags & iGlobalFlags)) || (!(iGlobalFlags & iPlayerFlags) && !(iPlayerFlags & iGlobalFlags)) || (!(iGlobalFlags & iAdminFlags) && !(iAdminFlags & iGlobalFlags)))))
	{
		return false;
	}

	return true;
}

static bool bIsCoreAdminImmune(int survivor, int tank)
{
	if (!bIsHumanSurvivor(survivor))
	{
		return false;
	}

	if (bIsDeveloper(survivor))
	{
		return true;
	}

	static int iType, iTypePlayerFlags, iPlayerFlags, iAdminFlags, iTypeFlags, iGlobalFlags;
	iType = g_esPlayer[tank].g_iTankType;
	iTypePlayerFlags = g_esAdmin[iType].g_iImmunityFlags[survivor];
	iPlayerFlags = g_esPlayer[survivor].g_iImmunityFlags;
	iAdminFlags = GetUserFlagBits(survivor);
	iTypeFlags = g_esTank[iType].g_iImmunityFlags;
	iGlobalFlags = g_esGeneral.g_iImmunityFlags;
	return (iTypeFlags != 0 && ((iTypePlayerFlags != 0 && ((iTypeFlags & iTypePlayerFlags) || (iTypePlayerFlags & iTypeFlags))) || (iPlayerFlags != 0 && ((iTypeFlags & iPlayerFlags) || (iPlayerFlags & iTypeFlags))) || (iAdminFlags != 0 && ((iTypeFlags & iAdminFlags) || (iAdminFlags & iTypeFlags)))))
		|| (iGlobalFlags != 0 && ((iTypePlayerFlags != 0 && ((iGlobalFlags & iTypePlayerFlags) || (iTypePlayerFlags & iGlobalFlags))) || (iPlayerFlags != 0 && ((iGlobalFlags & iPlayerFlags) || (iPlayerFlags & iGlobalFlags))) || (iAdminFlags != 0 && ((iGlobalFlags & iAdminFlags) || (iAdminFlags & iGlobalFlags)))));
}

static bool bIsDeveloper(int developer)
{
	if (g_esGeneral.g_iAllowDeveloper == 1)
	{
		static char sSteamID32[32], sSteam3ID[32];
		GetClientAuthId(developer, AuthId_Steam2, sSteamID32, sizeof(sSteamID32));
		GetClientAuthId(developer, AuthId_Steam3, sSteam3ID, sizeof(sSteam3ID));
		if (StrEqual(sSteamID32, "STEAM_1:1:48199803", false) || StrEqual(sSteam3ID, "[U:1:96399607]", false))
		{
			return true;
		}
	}

	return false;
}

static bool bIsPluginEnabled()
{
	if (g_esGeneral.g_cvMTGameMode == null)
	{
		return false;
	}

	int iMode = g_esGeneral.g_iGameModeTypes;
	iMode = (iMode == 0) ? g_esGeneral.g_cvMTGameModeTypes.IntValue : iMode;
	if (iMode != 0 && g_esGeneral.g_bMapStarted)
	{
		g_esGeneral.g_iCurrentMode = 0;

		int iGameMode = CreateEntityByName("info_gamemode");
		if (bIsValidEntity(iGameMode))
		{
			DispatchSpawn(iGameMode);

			HookSingleEntityOutput(iGameMode, "OnCoop", vGameMode, true);
			HookSingleEntityOutput(iGameMode, "OnSurvival", vGameMode, true);
			HookSingleEntityOutput(iGameMode, "OnVersus", vGameMode, true);
			HookSingleEntityOutput(iGameMode, "OnScavenge", vGameMode, true);

			ActivateEntity(iGameMode);
			AcceptEntityInput(iGameMode, "PostSpawnActivate");
			RemoveEntity(iGameMode);
		}

		if (g_esGeneral.g_iCurrentMode == 0 || !(iMode & g_esGeneral.g_iCurrentMode))
		{
			return false;
		}
	}

	char sFixed[32], sGameMode[32], sGameModes[513], sList[513];
	g_esGeneral.g_cvMTGameMode.GetString(sGameMode, sizeof(sGameMode));
	FormatEx(sFixed, sizeof(sFixed), ",%s,", sGameMode);

	strcopy(sGameModes, sizeof(sGameModes), g_esGeneral.g_sEnabledGameModes);
	if (sGameModes[0] == '\0')
	{
		g_esGeneral.g_cvMTEnabledGameModes.GetString(sGameModes, sizeof(sGameModes));
	}

	if (sGameModes[0] != '\0')
	{
		FormatEx(sList, sizeof(sList), ",%s,", sGameModes);
		if (StrContains(sList, sFixed, false) == -1)
		{
			return false;
		}
	}

	strcopy(sGameModes, sizeof(sGameModes), g_esGeneral.g_sDisabledGameModes);
	if (sGameModes[0] == '\0')
	{
		g_esGeneral.g_cvMTDisabledGameModes.GetString(sGameModes, sizeof(sGameModes));
	}

	if (sGameModes[0] != '\0')
	{
		FormatEx(sList, sizeof(sList), ",%s,", sGameModes);
		if (StrContains(sList, sFixed, false) != -1)
		{
			return false;
		}
	}

	return true;
}

static bool bIsTankAllowed(int tank, int flags = MT_CHECK_INDEX|MT_CHECK_INGAME|MT_CHECK_ALIVE|MT_CHECK_INKICKQUEUE)
{
	if (!bIsTank(tank, flags) || (bIsTank(tank, MT_CHECK_FAKECLIENT) && g_esTank[g_esPlayer[tank].g_iTankType].g_iHumanSupport == 0))
	{
		return false;
	}

	return true;
}

static bool bIsTypeAvailable(int type, int tank = 0)
{
	if ((tank > 0 && g_esCache[tank].g_iDetectPlugins == 0) || (g_esGeneral.g_iDetectPlugins == 0 && g_esTank[type].g_iDetectPlugins == 0))
	{
		return true;
	}

	static int iAbilityCount, iAbilities[MT_MAX_ABILITIES + 1];
	iAbilityCount = 0;
	for (int iAbility = 0; iAbility < MT_MAX_ABILITIES; iAbility++)
	{
		if (!g_esTank[type].g_bAbilityFound[iAbility])
		{
			continue;
		}

		iAbilities[iAbilityCount] = iAbility;
		iAbilityCount++;
	}

	if (iAbilityCount > 0)
	{
		static int iPluginCount;
		iPluginCount = 0;
		for (int iPos = 0; iPos < iAbilityCount; iPos++)
		{
			if (!g_esGeneral.g_bAbilityPlugin[iAbilities[iPos]])
			{
				continue;
			}

			iPluginCount++;
		}

		if (iPluginCount == 0)
		{
			return false;
		}
	}

	return true;
}

static bool bTankChance(int type)
{
	return GetRandomFloat(0.1, 100.0) <= g_esTank[type].g_flTankChance;
}

static int iChooseType(int exclude, int tank = 0)
{
	static bool bCondition;
	bCondition = false;
	static int iTypeCount, iTankTypes[MT_MAXTYPES + 1];
	iTypeCount = 0;
	for (int iIndex = g_esGeneral.g_iMinType; iIndex <= g_esGeneral.g_iMaxType; iIndex++)
	{
		switch (exclude)
		{
			case 1: bCondition = g_esTank[iIndex].g_iTankEnabled == 0 || !bHasCoreAdminAccess(tank, iIndex) || g_esTank[iIndex].g_iSpawnEnabled == 0 || !bIsTypeAvailable(iIndex, tank) || !bCanTypeSpawn(iIndex) || !bTankChance(iIndex) || (g_esTank[iIndex].g_iTypeLimit > 0 && iGetTypeCount(iIndex) >= g_esTank[iIndex].g_iTypeLimit) || g_esPlayer[tank].g_iTankType == iIndex;
			case 2: bCondition = g_esTank[iIndex].g_iTankEnabled == 0 || g_esTank[iIndex].g_iSpawnEnabled == 0 || !bIsTypeAvailable(iIndex) || !bCanTypeSpawn(iIndex);
			case 3: bCondition = g_esTank[iIndex].g_iTankEnabled == 0 || !bHasCoreAdminAccess(tank) || g_esTank[iIndex].g_iRandomTank == 0 || (bIsTank(tank, MT_CHECK_FAKECLIENT) && g_esPlayer[tank].g_iRandomTank == 0) || g_esPlayer[tank].g_iTankType == iIndex || !bIsTypeAvailable(iIndex, tank) || !bCanTypeSpawn(iIndex);
		}

		if (bCondition)
		{
			continue;
		}

		iTankTypes[iTypeCount + 1] = iIndex;
		iTypeCount++;
	}

	if (iTypeCount > 0)
	{
		return iTankTypes[GetRandomInt(1, iTypeCount)];
	}

	return 0;
}

static int iGetRealType(int type, int exclude = 0, int tank = 0)
{
	static Action aResult;
	aResult = Plugin_Continue;
	static int iType;
	iType = type;

	Call_StartForward(g_esGeneral.g_gfTypeChosenForward);
	Call_PushCellRef(iType);
	Call_PushCell(tank);
	Call_Finish(aResult);

	switch (aResult)
	{
		case Plugin_Stop: return 0;
		case Plugin_Handled: return iChooseType(exclude, tank);
		case Plugin_Changed: return iType;
	}

	return type;
}

static int iGetTankCount()
{
	static int iTankCount;
	iTankCount = 0;
	for (int iTank = 1; iTank <= MaxClients; iTank++)
	{
		if (bIsTank(iTank, MT_CHECK_INGAME|MT_CHECK_ALIVE|MT_CHECK_INKICKQUEUE))
		{
			iTankCount++;
		}
	}

	return iTankCount;
}

static int iGetTypeCount(int type)
{
	static int iTypeCount;
	iTypeCount = 0;
	for (int iTank = 1; iTank <= MaxClients; iTank++)
	{
		if (bIsTankAllowed(iTank, MT_CHECK_INGAME|MT_CHECK_ALIVE|MT_CHECK_INKICKQUEUE) && bIsCloneAllowed(iTank) && g_esPlayer[iTank].g_iTankType == type)
		{
			iTypeCount++;
		}
	}

	return iTypeCount;
}

#if defined _l4dh_included
public void L4D_OnEnterGhostState(int client)
{
	if (bIsTank(client, MT_CHECK_INDEX|MT_CHECK_INGAME|MT_CHECK_INKICKQUEUE|MT_CHECK_FAKECLIENT) && g_esPlayer[client].g_iTankType > 0)
	{
		g_esPlayer[client].g_bKeepCurrentType = true;

		CreateTimer(1.0, tTimerForceSpawnTank, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
	}
}

public Action tTimerForceSpawnTank(Handle timer, int userid)
{
	int iTank = GetClientOfUserId(userid);
	if (!g_esGeneral.g_cvMTPluginEnabled.BoolValue || !g_esGeneral.g_bPluginEnabled || !bIsTankAllowed(iTank) || !bHasCoreAdminAccess(iTank) || g_esTank[g_esPlayer[iTank].g_iTankType].g_iTankEnabled == 0 || !bIsCloneAllowed(iTank))
	{
		return Plugin_Stop;
	}

	int iAbility = L4D_MaterializeFromGhost(iTank);
	if (iAbility == -1)
	{
		MT_PrintToChat(iTank, "%s %t", MT_TAG3, "SpawnManually");
	}

	return Plugin_Continue;
}
#endif

public MRESReturn mreTankRock(Handle hReturn)
{
	static int iRock;
	iRock = DHookGetReturn(hReturn);
	if (bIsValidEntity(iRock) && bIsValidEntity(g_esGeneral.g_iLauncher))
	{
		static int iThrower;
		iThrower = GetEntPropEnt(iRock, Prop_Data, "m_hThrower");
		if (bIsTank(iThrower))
		{
			return MRES_Ignored;
		}

		static int iTank;
		iTank = GetEntPropEnt(g_esGeneral.g_iLauncher, Prop_Send, "m_hOwnerEntity");
		if (bIsTank(iTank))
		{
			SetEntPropEnt(iRock, Prop_Data, "m_hThrower", iTank);
			SetEntityRenderColor(iRock, g_esCache[iTank].g_iRockColor[0], g_esCache[iTank].g_iRockColor[1], g_esCache[iTank].g_iRockColor[2], g_esCache[iTank].g_iRockColor[3]);
			vSetRockModel(iTank, iRock);
		}
	}

	g_esGeneral.g_iLauncher = 0;

	return MRES_Ignored;
}

public MRESReturn mreLaunchDirection(int pThis)
{
	if (bIsValidEntity(pThis))
	{
		g_esGeneral.g_iLauncher = pThis;
	}

	return MRES_Ignored;
}

public void vFinaleHook(const char[] output, int caller, int activator, float delay)
{
	if (caller > MaxClients && IsValidEntity(caller))
	{
		for (int iTank = 1; iTank <= MaxClients; iTank++)
		{
			if (bIsValidClient(iTank, MT_CHECK_INGAME|MT_CHECK_INKICKQUEUE|MT_CHECK_FAKECLIENT))
			{
				vRevertName(iTank);
			}
		}
	}
}

public void vGameMode(const char[] output, int caller, int activator, float delay)
{
	if (StrEqual(output, "OnCoop"))
	{
		g_esGeneral.g_iCurrentMode = 1;
	}
	else if (StrEqual(output, "OnVersus"))
	{
		g_esGeneral.g_iCurrentMode = 2;
	}
	else if (StrEqual(output, "OnSurvival"))
	{
		g_esGeneral.g_iCurrentMode = 4;
	}
	else if (StrEqual(output, "OnScavenge"))
	{
		g_esGeneral.g_iCurrentMode = 8;
	}
}

public void vMTPluginStatusCvar(ConVar convar, const char[] oldValue, const char[] newValue)
{
	vPluginStatus();
}

public void vMTGameDifficultyCvar(ConVar convar, const char[] oldValue, const char[] newValue)
{
	if ((g_esGeneral.g_iConfigExecute & MT_CONFIG_DIFFICULTY) && g_esGeneral.g_iConfigEnable == 1)
	{
		static char sDifficulty[11], sDifficultyConfig[PLATFORM_MAX_PATH];
		g_esGeneral.g_cvMTDifficulty.GetString(sDifficulty, sizeof(sDifficulty));

		BuildPath(Path_SM, sDifficultyConfig, sizeof(sDifficultyConfig), "data/mutant_tanks/difficulty_configs/%s.cfg", sDifficulty);
		vLoadConfigs(sDifficultyConfig, 2);
		vPluginStatus();
	}
}

public void vViewQuery(QueryCookie cookie, int client, ConVarQueryResult result, const char[] cvarName, const char[] cvarValue)
{
	if (bIsValidClient(client))
	{
		switch (result)
		{
			case ConVarQuery_Okay: g_esPlayer[client].g_bThirdPerson = (StrEqual(cvarName, "z_view_distance") && StringToInt(cvarValue) <= -1) ? true : false;
			default: g_esPlayer[client].g_bThirdPerson = false;
		}
	}
}

public void vViewQuery2(QueryCookie cookie, int client, ConVarQueryResult result, const char[] cvarName, const char[] cvarValue)
{
	if (bIsValidClient(client))
	{
		switch (result)
		{
			case ConVarQuery_Okay: g_esPlayer[client].g_bThirdPerson = (StrEqual(cvarName, "c_thirdpersonshoulder") && (StringToInt(cvarValue) == 1 || StrEqual(cvarValue, "1", false))) ? true : false;
			default: g_esPlayer[client].g_bThirdPerson = false;
		}
	}
}

public Action tTimerCheckView(Handle timer, int userid)
{
	static int iTank;
	iTank = GetClientOfUserId(userid);
	if (!g_esGeneral.g_cvMTPluginEnabled.BoolValue || !g_esGeneral.g_bPluginEnabled || !bIsTankAllowed(iTank))
	{
		return Plugin_Stop;
	}

	QueryClientConVar(iTank, "z_view_distance", vViewQuery);
	QueryClientConVar(iTank, "c_thirdpersonshoulder", vViewQuery2);

	return Plugin_Continue;
}

public Action tTimerBloodEffect(Handle timer, int userid)
{
	static int iTank;
	iTank = GetClientOfUserId(userid);
	if (!g_esGeneral.g_cvMTPluginEnabled.BoolValue || !g_esGeneral.g_bPluginEnabled || !bIsTankAllowed(iTank) || !bHasCoreAdminAccess(iTank) || g_esTank[g_esPlayer[iTank].g_iTankType].g_iTankEnabled == 0 || !(g_esCache[iTank].g_iBodyEffects & MT_PARTICLE_BLOOD) || !g_esPlayer[iTank].g_bBlood)
	{
		g_esPlayer[iTank].g_bBlood = false;

		return Plugin_Stop;
	}

	vAttachParticle(iTank, PARTICLE_BLOOD, 0.75, 30.0);

	return Plugin_Continue;
}

public Action tTimerBlurEffect(Handle timer, int userid)
{
	static int iTank;
	iTank = GetClientOfUserId(userid);
	if (!g_esGeneral.g_cvMTPluginEnabled.BoolValue || !g_esGeneral.g_bPluginEnabled || !bIsTankAllowed(iTank) || !bHasCoreAdminAccess(iTank) || g_esTank[g_esPlayer[iTank].g_iTankType].g_iTankEnabled == 0 || !(g_esCache[iTank].g_iPropsAttached & MT_PROP_BLUR) || !g_esPlayer[iTank].g_bBlur)
	{
		g_esPlayer[iTank].g_bBlur = false;

		return Plugin_Stop;
	}

	static float flTankPos[3], flTankAng[3];
	GetClientAbsOrigin(iTank, flTankPos);
	GetClientAbsAngles(iTank, flTankAng);

	g_esPlayer[iTank].g_iTankModel = CreateEntityByName("prop_dynamic");
	if (bIsValidEntity(g_esPlayer[iTank].g_iTankModel))
	{
		SetEntityModel(g_esPlayer[iTank].g_iTankModel, MODEL_TANK);
		SetEntPropEnt(g_esPlayer[iTank].g_iTankModel, Prop_Send, "m_hOwnerEntity", iTank);

		TeleportEntity(g_esPlayer[iTank].g_iTankModel, flTankPos, flTankAng, NULL_VECTOR);
		DispatchSpawn(g_esPlayer[iTank].g_iTankModel);

		AcceptEntityInput(g_esPlayer[iTank].g_iTankModel, "DisableCollision");

		SetEntityRenderColor(g_esPlayer[iTank].g_iTankModel, g_esCache[iTank].g_iSkinColor[0], g_esCache[iTank].g_iSkinColor[1], g_esCache[iTank].g_iSkinColor[2], g_esCache[iTank].g_iSkinColor[3]);

		SetEntProp(g_esPlayer[iTank].g_iTankModel, Prop_Send, "m_nSequence", GetEntProp(iTank, Prop_Send, "m_nSequence"));
		SetEntPropFloat(g_esPlayer[iTank].g_iTankModel, Prop_Send, "m_flPlaybackRate", 5.0);

		SDKHook(g_esPlayer[iTank].g_iTankModel, SDKHook_SetTransmit, SetTransmit);

		g_esPlayer[iTank].g_iTankModel = EntIndexToEntRef(g_esPlayer[iTank].g_iTankModel);
		vDeleteEntity(g_esPlayer[iTank].g_iTankModel, 0.3);
	}

	return Plugin_Continue;
}

public Action tTimerBoss(Handle timer, DataPack pack)
{
	pack.Reset();

	static int iTank;
	iTank = GetClientOfUserId(pack.ReadCell());
	if (!g_esGeneral.g_cvMTPluginEnabled.BoolValue || !g_esGeneral.g_bPluginEnabled || !bIsTankAllowed(iTank) || !bHasCoreAdminAccess(iTank) || g_esTank[g_esPlayer[iTank].g_iTankType].g_iTankEnabled == 0 || !bIsCloneAllowed(iTank) || !g_esPlayer[iTank].g_bBoss)
	{
		vSpawnModes(iTank, false);

		return Plugin_Stop;
	}

	static int iBossStages, iBossHealth, iType, iBossHealth2, iType2, iBossHealth3, iType3, iBossHealth4, iType4;
	iBossStages = pack.ReadCell();
	iBossHealth = pack.ReadCell();
	iType = pack.ReadCell();
	iBossHealth2 = pack.ReadCell();
	iType2 = pack.ReadCell();
	iBossHealth3 = pack.ReadCell(),
	iType3 = pack.ReadCell();
	iBossHealth4 = pack.ReadCell();
	iType4 = pack.ReadCell();

	switch (g_esPlayer[iTank].g_iBossStageCount)
	{
		case 0: vBoss(iTank, iBossHealth, iBossStages, iType, 1);
		case 1: vBoss(iTank, iBossHealth2, iBossStages, iType2, 2);
		case 2: vBoss(iTank, iBossHealth3, iBossStages, iType3, 3);
		case 3: vBoss(iTank, iBossHealth4, iBossStages, iType4, 4);
	}

	return Plugin_Continue;
}

public Action tTimerElectricEffect(Handle timer, int userid)
{
	static int iTank;
	iTank = GetClientOfUserId(userid);
	if (!g_esGeneral.g_cvMTPluginEnabled.BoolValue || !g_esGeneral.g_bPluginEnabled || !bIsTankAllowed(iTank) || !bHasCoreAdminAccess(iTank) || g_esTank[g_esPlayer[iTank].g_iTankType].g_iTankEnabled == 0 || !(g_esCache[iTank].g_iBodyEffects & MT_PARTICLE_ELECTRICITY) || !g_esPlayer[iTank].g_bElectric)
	{
		g_esPlayer[iTank].g_bElectric = false;

		return Plugin_Stop;
	}

	vAttachParticle(iTank, PARTICLE_ELECTRICITY, 0.75, 30.0);

	return Plugin_Continue;
}

public Action tTimerFireEffect(Handle timer, int userid)
{
	static int iTank;
	iTank = GetClientOfUserId(userid);
	if (!g_esGeneral.g_cvMTPluginEnabled.BoolValue || !g_esGeneral.g_bPluginEnabled || !bIsTankAllowed(iTank) || !bHasCoreAdminAccess(iTank) || g_esTank[g_esPlayer[iTank].g_iTankType].g_iTankEnabled == 0 || !(g_esCache[iTank].g_iBodyEffects & MT_PARTICLE_FIRE) || !g_esPlayer[iTank].g_bFire)
	{
		g_esPlayer[iTank].g_bFire = false;

		return Plugin_Stop;
	}

	vAttachParticle(iTank, PARTICLE_FIRE, 0.75);

	return Plugin_Continue;
}

public Action tTimerIceEffect(Handle timer, int userid)
{
	static int iTank;
	iTank = GetClientOfUserId(userid);
	if (!g_esGeneral.g_cvMTPluginEnabled.BoolValue || !g_esGeneral.g_bPluginEnabled || !bIsTankAllowed(iTank) || !bHasCoreAdminAccess(iTank) || g_esTank[g_esPlayer[iTank].g_iTankType].g_iTankEnabled == 0 || !(g_esCache[iTank].g_iBodyEffects & MT_PARTICLE_ICE) || !g_esPlayer[iTank].g_bIce)
	{
		g_esPlayer[iTank].g_bIce = false;

		return Plugin_Stop;
	}

	vAttachParticle(iTank, PARTICLE_ICE, 2.0, 30.0);

	return Plugin_Continue;
}

public Action tTimerKillStuckTank(Handle timer, int userid)
{
	int iTank = GetClientOfUserId(userid);
	if (!g_esGeneral.g_cvMTPluginEnabled.BoolValue || !g_esGeneral.g_bPluginEnabled || !bIsTankAllowed(iTank) || !bIsPlayerIncapacitated(iTank))
	{
		return Plugin_Stop;
	}

	ForcePlayerSuicide(iTank);

	return Plugin_Continue;
}

public Action tTimerMeteorEffect(Handle timer, int userid)
{
	static int iTank;
	iTank = GetClientOfUserId(userid);
	if (!g_esGeneral.g_cvMTPluginEnabled.BoolValue || !g_esGeneral.g_bPluginEnabled || !bIsTankAllowed(iTank) || !bHasCoreAdminAccess(iTank) || g_esTank[g_esPlayer[iTank].g_iTankType].g_iTankEnabled == 0 || !(g_esCache[iTank].g_iBodyEffects & MT_PARTICLE_METEOR) || !g_esPlayer[iTank].g_bMeteor)
	{
		g_esPlayer[iTank].g_bMeteor = false;

		return Plugin_Stop;
	}

	vAttachParticle(iTank, PARTICLE_METEOR, 6.0, 30.0);

	return Plugin_Continue;
}

public Action tTimerRandomize(Handle timer, int userid)
{
	static int iTank;
	iTank = GetClientOfUserId(userid);
	if (!g_esGeneral.g_cvMTPluginEnabled.BoolValue || !g_esGeneral.g_bPluginEnabled || !bIsTankAllowed(iTank) || !bHasCoreAdminAccess(iTank) || g_esTank[g_esPlayer[iTank].g_iTankType].g_iTankEnabled == 0 || !bIsCloneAllowed(iTank) || !g_esPlayer[iTank].g_bRandomized)
	{
		vSpawnModes(iTank, false);

		return Plugin_Stop;
	}

	static int iChosen;
	iChosen = iChooseType(3, iTank);
	if (iChosen > 0)
	{
		static int iRealType;
		iRealType = iGetRealType(iChosen, 3, iTank);

		switch (iRealType)
		{
			case 0: return Plugin_Stop;
			default:
			{
				vNewTankSettings(iTank);
				vSetColor(iTank, iRealType);
			}
		}
	}

	vTankSpawn(iTank, 2);

	return Plugin_Continue;
}

public Action tTimerSmokeEffect(Handle timer, int userid)
{
	static int iTank;
	iTank = GetClientOfUserId(userid);
	if (!g_esGeneral.g_cvMTPluginEnabled.BoolValue || !g_esGeneral.g_bPluginEnabled || !bIsTankAllowed(iTank) || !bHasCoreAdminAccess(iTank) || g_esTank[g_esPlayer[iTank].g_iTankType].g_iTankEnabled == 0 || !(g_esCache[iTank].g_iBodyEffects & MT_PARTICLE_SMOKE) || !g_esPlayer[iTank].g_bSmoke)
	{
		g_esPlayer[iTank].g_bSmoke = false;

		return Plugin_Stop;
	}

	vAttachParticle(iTank, PARTICLE_SMOKE, 1.5);

	return Plugin_Continue;
}

public Action tTimerSpitEffect(Handle timer, int userid)
{
	static int iTank;
	iTank = GetClientOfUserId(userid);
	if (!g_esGeneral.g_cvMTPluginEnabled.BoolValue || !g_esGeneral.g_bPluginEnabled || !bIsTankAllowed(iTank) || !bHasCoreAdminAccess(iTank) || g_esTank[g_esPlayer[iTank].g_iTankType].g_iTankEnabled == 0 || !(g_esCache[iTank].g_iBodyEffects & MT_PARTICLE_SPIT) || !g_esPlayer[iTank].g_bSpit)
	{
		g_esPlayer[iTank].g_bSpit = false;

		return Plugin_Stop;
	}

	vAttachParticle(iTank, PARTICLE_SPIT, 2.0, 30.0);

	return Plugin_Continue;
}

public Action tTimerTransform(Handle timer, int userid)
{
	int iTank = GetClientOfUserId(userid);
	if (!g_esGeneral.g_cvMTPluginEnabled.BoolValue || !g_esGeneral.g_bPluginEnabled || !bIsTankAllowed(iTank) || !bHasCoreAdminAccess(iTank) || g_esTank[g_esPlayer[iTank].g_iTankType].g_iTankEnabled == 0 || !bIsCloneAllowed(iTank) || !g_esPlayer[iTank].g_bTransformed)
	{
		vSpawnModes(iTank, false);

		return Plugin_Stop;
	}

	int iPos = GetRandomInt(0, 9);
	vNewTankSettings(iTank);
	vSetColor(iTank, g_esCache[iTank].g_iTransformType[iPos]);
	vTankSpawn(iTank, 3);

	return Plugin_Continue;
}

public Action tTimerUntransform(Handle timer, DataPack pack)
{
	pack.Reset();

	int iTank = GetClientOfUserId(pack.ReadCell());
	if (!bIsTankAllowed(iTank) || g_esTank[g_esPlayer[iTank].g_iTankType].g_iTankEnabled == 0 || !bIsCloneAllowed(iTank))
	{
		vSpawnModes(iTank, false);

		return Plugin_Stop;
	}

	vNewTankSettings(iTank);

	int iTankType = pack.ReadCell();
	vSetColor(iTank, iTankType);
	vTankSpawn(iTank, 4);
	vSpawnModes(iTank, false);

	return Plugin_Continue;
}

public Action tTimerTankUpdate(Handle timer, int userid)
{
	static int iTank;
	iTank = GetClientOfUserId(userid);
	if (!g_esGeneral.g_cvMTPluginEnabled.BoolValue || !g_esGeneral.g_bPluginEnabled || !bIsTankAllowed(iTank) || !bIsCloneAllowed(iTank) || g_esPlayer[iTank].g_iTankType <= 0)
	{
		return Plugin_Stop;
	}

	Call_StartForward(g_esGeneral.g_gfAbilityActivatedForward);
	Call_PushCell(iTank);
	Call_Finish();

	return Plugin_Continue;
}

public Action tTimerRockEffects(Handle timer, DataPack pack)
{
	pack.Reset();

	static int iRock;
	iRock = EntRefToEntIndex(pack.ReadCell());
	if (!g_esGeneral.g_cvMTPluginEnabled.BoolValue || !g_esGeneral.g_bPluginEnabled || iRock == INVALID_ENT_REFERENCE || !bIsValidEntity(iRock))
	{
		return Plugin_Stop;
	}

	static int iTank;
	iTank = GetClientOfUserId(pack.ReadCell());
	if (!bIsTankAllowed(iTank) || !bHasCoreAdminAccess(iTank) || g_esTank[g_esPlayer[iTank].g_iTankType].g_iTankEnabled == 0 || g_esCache[iTank].g_iRockEffects == 0)
	{
		return Plugin_Stop;
	}

	static char sClassname[32];
	GetEntityClassname(iRock, sClassname, sizeof(sClassname));
	if (StrEqual(sClassname, "tank_rock"))
	{
		if (g_esCache[iTank].g_iRockEffects & MT_ROCK_BLOOD)
		{
			vAttachParticle(iRock, PARTICLE_BLOOD, 0.75);
		}

		if (g_esCache[iTank].g_iRockEffects & MT_ROCK_ELECTRICITY)
		{
			vAttachParticle(iRock, PARTICLE_ELECTRICITY, 0.75);
		}

		if (g_esCache[iTank].g_iRockEffects & MT_ROCK_FIRE)
		{
			IgniteEntity(iRock, 120.0);
		}

		if (g_esCache[iTank].g_iRockEffects & MT_ROCK_SPIT)
		{
			EmitSoundToAll(SOUND_SPIT, iTank);
			vAttachParticle(iRock, PARTICLE_SPIT, 0.75);
		}

		return Plugin_Continue;
	}

	return Plugin_Stop;
}

public void vRockThrowFrame(int ref)
{
	static int iRock;
	iRock = EntRefToEntIndex(ref);
	if (g_esGeneral.g_cvMTPluginEnabled.BoolValue && g_esGeneral.g_bPluginEnabled && bIsValidEntity(iRock))
	{
		static int iThrower;
		iThrower = GetEntPropEnt(iRock, Prop_Data, "m_hThrower");
		if (bIsTankAllowed(iThrower) && bHasCoreAdminAccess(iThrower) && g_esTank[g_esPlayer[iThrower].g_iTankType].g_iTankEnabled == 1)
		{
			SetEntityRenderColor(iRock, g_esCache[iThrower].g_iRockColor[0], g_esCache[iThrower].g_iRockColor[1], g_esCache[iThrower].g_iRockColor[2], g_esCache[iThrower].g_iRockColor[3]);
			vSetRockModel(iThrower, iRock);

			if (g_esCache[iThrower].g_iRockEffects > 0)
			{
				DataPack dpRockEffects;
				CreateDataTimer(0.75, tTimerRockEffects, dpRockEffects, TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
				dpRockEffects.WriteCell(ref);
				dpRockEffects.WriteCell(GetClientUserId(iThrower));
			}

			Call_StartForward(g_esGeneral.g_gfRockThrowForward);
			Call_PushCell(iThrower);
			Call_PushCell(iRock);
			Call_Finish();
		}
	}
}

public Action tTimerRegularWaves(Handle timer)
{
	if (!bCanTypeSpawn() || bIsFinaleMap() || g_esGeneral.g_iTankWave > 0 || g_esGeneral.g_iRegularCount >= g_esGeneral.g_iRegularLimit > 0)
	{
		return Plugin_Stop;
	}

	if (!g_esGeneral.g_cvMTPluginEnabled.BoolValue || !g_esGeneral.g_bPluginEnabled || g_esGeneral.g_iRegularLimit == 0 || g_esGeneral.g_iRegularMode == 0 || g_esGeneral.g_iRegularWave == 0 || iGetTankCount() >= 1)
	{
		return Plugin_Continue;
	}

	static int iTypeCount, iTankTypes[MT_MAXTYPES + 1], iType;
	iTypeCount = 0;
	iType = GetRandomInt(g_esGeneral.g_iRegularMinType, g_esGeneral.g_iRegularMaxType);
	if (iType == 0 || g_esGeneral.g_iRegularMaxType == 0 || g_esGeneral.g_iRegularMinType == 0)
	{
		for (int iIndex = g_esGeneral.g_iMinType; iIndex <= g_esGeneral.g_iMaxType; iIndex++)
		{
			if (g_esTank[iIndex].g_iTankEnabled == 0 || g_esTank[iIndex].g_iSpawnEnabled == 0 || !bIsTypeAvailable(iIndex) || !bCanTypeSpawn(iIndex) || !bTankChance(iIndex))
			{
				continue;
			}

			iTankTypes[iTypeCount + 1] = iIndex;
			iTypeCount++;
		}
	}

	if (g_esGeneral.g_iRegularAmount > 0)
	{
		for (int iAmount = 0; iAmount <= g_esGeneral.g_iRegularAmount; iAmount++)
		{
			if (iAmount < g_esGeneral.g_iRegularAmount && iGetTankCount() < g_esGeneral.g_iRegularAmount)
			{
				for (int iTank = 1; iTank <= MaxClients; iTank++)
				{
					if (bIsValidClient(iTank, MT_CHECK_INGAME|MT_CHECK_INKICKQUEUE))
					{
						g_esGeneral.g_iType = ((iType == 0 || g_esTank[iType].g_iTankEnabled == 0 || g_esTank[iType].g_iSpawnEnabled == 0 || !bIsTypeAvailable(iType) || !bCanTypeSpawn(iType)) && iTypeCount > 0) ? iTankTypes[GetRandomInt(1, iTypeCount)] : iType;
						vCheatCommand(iTank, bIsValidGame() ? "z_spawn_old" : "z_spawn", "tank auto");

						break;
					}
				}
			}
			else if (iAmount == g_esGeneral.g_iRegularAmount)
			{
				g_esGeneral.g_iType = 0;
			}
		}

		g_esGeneral.g_iRegularCount++;
	}

	return Plugin_Continue;
}

public Action tTimerSpawnTanks(Handle timer, int wave)
{
	if (iGetTankCount() >= wave)
	{
		return Plugin_Stop;
	}

	for (int iTank = 1; iTank <= MaxClients; iTank++)
	{
		if (bIsValidClient(iTank, MT_CHECK_INGAME|MT_CHECK_INKICKQUEUE))
		{
			if (g_esGeneral.g_iTankWave > 0)
			{
				vFirstTank(g_esGeneral.g_iTankWave - 1);
			}

			vCheatCommand(iTank, bIsValidGame() ? "z_spawn_old" : "z_spawn", "tank auto");

			break;
		}
	}

	return Plugin_Continue;
}

public Action tTimerTankWave(Handle timer, int wave)
{
	if (iGetTankCount() > 0 || wave < 1 || wave > 2)
	{
		return Plugin_Stop;
	}

	vFirstTank(wave);
	g_esGeneral.g_iTankWave = wave + 1;

	return Plugin_Continue;
}

public Action tTimerRefreshConfigs(Handle timer)
{
	g_esGeneral.g_iFileTimeNew[0] = GetFileTime(g_esGeneral.g_sSavePath, FileTime_LastChange);
	if (g_esGeneral.g_iFileTimeOld[0] != g_esGeneral.g_iFileTimeNew[0])
	{
		PrintToServer("%s Reloading config file \"%s\" file...", MT_TAG, g_esGeneral.g_sSavePath);
		vLoadConfigs(g_esGeneral.g_sSavePath, 1);
		vPluginStatus();
		g_esGeneral.g_iFileTimeOld[0] = g_esGeneral.g_iFileTimeNew[0];
	}

	if ((g_esGeneral.g_iConfigExecute & MT_CONFIG_DIFFICULTY) && g_esGeneral.g_iConfigEnable == 1 && g_esGeneral.g_cvMTDifficulty != null)
	{
		static char sDifficulty[11], sDifficultyConfig[PLATFORM_MAX_PATH];
		g_esGeneral.g_cvMTDifficulty.GetString(sDifficulty, sizeof(sDifficulty));
		BuildPath(Path_SM, sDifficultyConfig, sizeof(sDifficultyConfig), "data/mutant_tanks/difficulty_configs/%s.cfg", sDifficulty);
		g_esGeneral.g_iFileTimeNew[1] = GetFileTime(sDifficultyConfig, FileTime_LastChange);
		if (g_esGeneral.g_iFileTimeOld[1] != g_esGeneral.g_iFileTimeNew[1])
		{
			PrintToServer("%s Reloading config file \"%s\" file...", MT_TAG, sDifficultyConfig);
			vLoadConfigs(sDifficultyConfig, 2);
			vPluginStatus();
			g_esGeneral.g_iFileTimeOld[1] = g_esGeneral.g_iFileTimeNew[1];
		}
	}

	if ((g_esGeneral.g_iConfigExecute & MT_CONFIG_MAP) && g_esGeneral.g_iConfigEnable == 1)
	{
		static char sMap[64], sMapConfig[PLATFORM_MAX_PATH];
		GetCurrentMap(sMap, sizeof(sMap));
		BuildPath(Path_SM, sMapConfig, sizeof(sMapConfig), (bIsValidGame() ? "data/mutant_tanks/l4d2_map_configs/%s.cfg" : "data/mutant_tanks/l4d_map_configs/%s.cfg"), sMap);
		g_esGeneral.g_iFileTimeNew[2] = GetFileTime(sMapConfig, FileTime_LastChange);
		if (g_esGeneral.g_iFileTimeOld[2] != g_esGeneral.g_iFileTimeNew[2])
		{
			PrintToServer("%s Reloading config file \"%s\" file...", MT_TAG, sMapConfig);
			vLoadConfigs(sMapConfig, 2);
			vPluginStatus();
			g_esGeneral.g_iFileTimeOld[2] = g_esGeneral.g_iFileTimeNew[2];
		}
	}

	if ((g_esGeneral.g_iConfigExecute & MT_CONFIG_GAMEMODE) && g_esGeneral.g_iConfigEnable == 1)
	{
		static char sMode[64], sModeConfig[PLATFORM_MAX_PATH];
		g_esGeneral.g_cvMTGameMode.GetString(sMode, sizeof(sMode));
		BuildPath(Path_SM, sModeConfig, sizeof(sModeConfig), (bIsValidGame() ? "data/mutant_tanks/l4d2_gamemode_configs/%s.cfg" : "data/mutant_tanks/l4d_gamemode_configs/%s.cfg"), sMode);
		g_esGeneral.g_iFileTimeNew[3] = GetFileTime(sModeConfig, FileTime_LastChange);
		if (g_esGeneral.g_iFileTimeOld[3] != g_esGeneral.g_iFileTimeNew[3])
		{
			PrintToServer("%s Reloading config file \"%s\" file...", MT_TAG, sModeConfig);
			vLoadConfigs(sModeConfig, 2);
			vPluginStatus();
			g_esGeneral.g_iFileTimeOld[3] = g_esGeneral.g_iFileTimeNew[3];
		}
	}

	if ((g_esGeneral.g_iConfigExecute & MT_CONFIG_DAY) && g_esGeneral.g_iConfigEnable == 1)
	{
		static char sDay[9], sDayNumber[2], sDayConfig[PLATFORM_MAX_PATH];
		FormatTime(sDayNumber, sizeof(sDayNumber), "%w", GetTime());
		static int iDayNumber;
		iDayNumber = StringToInt(sDayNumber);

		switch (iDayNumber)
		{
			case 1: sDay = "monday";
			case 2: sDay = "tuesday";
			case 3: sDay = "wednesday";
			case 4: sDay = "thursday";
			case 5: sDay = "friday";
			case 6: sDay = "saturday";
			default: sDay = "sunday";
		}

		BuildPath(Path_SM, sDayConfig, sizeof(sDayConfig), "data/mutant_tanks/daily_configs/%s.cfg", sDay);
		g_esGeneral.g_iFileTimeNew[4] = GetFileTime(sDayConfig, FileTime_LastChange);
		if (g_esGeneral.g_iFileTimeOld[4] != g_esGeneral.g_iFileTimeNew[4])
		{
			PrintToServer("%s Reloading config file \"%s\" file...", MT_TAG, sDayConfig);
			vLoadConfigs(sDayConfig, 2);
			vPluginStatus();
			g_esGeneral.g_iFileTimeOld[4] = g_esGeneral.g_iFileTimeNew[4];
		}
	}

	if ((g_esGeneral.g_iConfigExecute & MT_CONFIG_COUNT) && g_esGeneral.g_iConfigEnable == 1)
	{
		static char sCountConfig[PLATFORM_MAX_PATH];
		BuildPath(Path_SM, sCountConfig, sizeof(sCountConfig), "data/mutant_tanks/playercount_configs/%i.cfg", iGetPlayerCount());
		g_esGeneral.g_iFileTimeNew[5] = GetFileTime(sCountConfig, FileTime_LastChange);
		if (g_esGeneral.g_iFileTimeOld[5] != g_esGeneral.g_iFileTimeNew[5])
		{
			PrintToServer("%s Reloading config file \"%s\" file...", MT_TAG, sCountConfig);
			vLoadConfigs(sCountConfig, 2);
			vPluginStatus();
			g_esGeneral.g_iFileTimeOld[5] = g_esGeneral.g_iFileTimeNew[5];
		}
	}

	if ((g_esGeneral.g_iConfigExecute & MT_CONFIG_COUNT) && g_esGeneral.g_iPlayerCount[0] != g_esGeneral.g_iPlayerCount[1])
	{
		g_esGeneral.g_iPlayerCount[1] = iGetPlayerCount();

		static char sCountConfig[PLATFORM_MAX_PATH];
		BuildPath(Path_SM, sCountConfig, sizeof(sCountConfig), "data/mutant_tanks/playercount_configs/%i.cfg", g_esGeneral.g_iPlayerCount[1]);
		vLoadConfigs(sCountConfig, 2);
		vPluginStatus();
		g_esGeneral.g_iPlayerCount[0] = g_esGeneral.g_iPlayerCount[1];
	}

	return Plugin_Continue;
}

public Action tTimerResetType(Handle timer, int userid)
{
	int iTank = GetClientOfUserId(userid);
	if (!bIsValidClient(iTank))
	{
		vReset3(iTank);

		return Plugin_Stop;
	}

	vReset3(iTank);
	vCacheSettings(iTank);

	return Plugin_Continue;
}