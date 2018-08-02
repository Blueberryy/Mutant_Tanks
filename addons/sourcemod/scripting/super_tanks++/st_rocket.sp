// Super Tanks++: Rocket Ability
#pragma semicolon 1
#pragma newdecls required
#include <super_tanks++>

public Plugin myinfo =
{
	name = "[ST++] Rocket Ability",
	author = ST_AUTHOR,
	description = ST_DESCRIPTION,
	version = ST_VERSION,
	url = ST_URL
};

bool g_bLateLoad;
bool g_bTankConfig[ST_MAXTYPES + 1];
float g_flRocketRange[ST_MAXTYPES + 1];
float g_flRocketRange2[ST_MAXTYPES + 1];
int g_iRocket[ST_MAXTYPES + 1];
int g_iRocketAbility[ST_MAXTYPES + 1];
int g_iRocketAbility2[ST_MAXTYPES + 1];
int g_iRocketChance[ST_MAXTYPES + 1];
int g_iRocketChance2[ST_MAXTYPES + 1];
int g_iRocketHit[ST_MAXTYPES + 1];
int g_iRocketHit2[ST_MAXTYPES + 1];
int g_iRocketRangeChance[ST_MAXTYPES + 1];
int g_iRocketRangeChance2[ST_MAXTYPES + 1];
int g_iRocketSprite = -1;

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	EngineVersion evEngine = GetEngineVersion();
	if (evEngine != Engine_Left4Dead && evEngine != Engine_Left4Dead2)
	{
		strcopy(error, err_max, "[ST++] Rocket Ability only supports Left 4 Dead 1 & 2.");
		return APLRes_SilentFailure;
	}
	g_bLateLoad = late;
	return APLRes_Success;
}

public void OnAllPluginsLoaded()
{
	if (!LibraryExists("super_tanks++"))
	{
		SetFailState("No Super Tanks++ library found.");
	}
}

public void OnPluginStart()
{
	vCreateInfoFile("cfg/sourcemod/super_tanks++/", "information/", "st_rocket", "st_rocket");
}

public void OnMapStart()
{
	g_iRocketSprite = PrecacheModel(SPRITE_FIRE, true);
	PrecacheSound(SOUND_EXPLOSION, true);
	PrecacheSound(SOUND_FIRE, true);
	PrecacheSound(SOUND_LAUNCH, true);
	if (g_bLateLoad)
	{
		vLateLoad(true);
		g_bLateLoad = false;
	}
}

public void OnClientPostAdminCheck(int client)
{
	SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);
}

public void OnClientDisconnect(int client)
{
	SDKUnhook(client, SDKHook_OnTakeDamage, OnTakeDamage);
}

void vLateLoad(bool late)
{
	if (late)
	{
		for (int iPlayer = 1; iPlayer <= MaxClients; iPlayer++)
		{
			if (bIsValidClient(iPlayer))
			{
				SDKHook(iPlayer, SDKHook_OnTakeDamage, OnTakeDamage);
			}
		}
	}
}

public Action OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype)
{
	if (ST_PluginEnabled() && damage > 0.0)
	{
		if (ST_TankAllowed(attacker) && IsPlayerAlive(attacker) && bIsSurvivor(victim))
		{
			char sClassname[32];
			GetEntityClassname(inflictor, sClassname, sizeof(sClassname));
			if (strcmp(sClassname, "weapon_tank_claw") == 0 || strcmp(sClassname, "tank_rock") == 0)
			{
				int iRocketChance = !g_bTankConfig[ST_TankType(attacker)] ? g_iRocketChance[ST_TankType(attacker)] : g_iRocketChance2[ST_TankType(attacker)];
				int iRocketHit = !g_bTankConfig[ST_TankType(attacker)] ? g_iRocketHit[ST_TankType(attacker)] : g_iRocketHit2[ST_TankType(attacker)];
				vRocketHit(victim, attacker, iRocketChance, iRocketHit);
			}
		}
	}
}

public void ST_Configs(char[] savepath, int limit, bool main)
{
	KeyValues kvSuperTanks = new KeyValues("Super Tanks++");
	kvSuperTanks.ImportFromFile(savepath);
	for (int iIndex = 1; iIndex <= limit; iIndex++)
	{
		char sName[MAX_NAME_LENGTH + 1];
		Format(sName, sizeof(sName), "Tank %d", iIndex);
		if (kvSuperTanks.JumpToKey(sName))
		{
			main ? (g_iRocketAbility[iIndex] = kvSuperTanks.GetNum("Rocket Ability/Ability Enabled", 0)) : (g_iRocketAbility2[iIndex] = kvSuperTanks.GetNum("Rocket Ability/Ability Enabled", g_iRocketAbility[iIndex]));
			main ? (g_iRocketAbility[iIndex] = iSetCellLimit(g_iRocketAbility[iIndex], 0, 1)) : (g_iRocketAbility2[iIndex] = iSetCellLimit(g_iRocketAbility2[iIndex], 0, 1));
			main ? (g_iRocketChance[iIndex] = kvSuperTanks.GetNum("Rocket Ability/Rocket Chance", 4)) : (g_iRocketChance2[iIndex] = kvSuperTanks.GetNum("Rocket Ability/Rocket Chance", g_iRocketChance[iIndex]));
			main ? (g_iRocketChance[iIndex] = iSetCellLimit(g_iRocketChance[iIndex], 1, 9999999999)) : (g_iRocketChance2[iIndex] = iSetCellLimit(g_iRocketChance2[iIndex], 1, 9999999999));
			main ? (g_iRocketHit[iIndex] = kvSuperTanks.GetNum("Rocket Ability/Rocket Hit", 0)) : (g_iRocketHit2[iIndex] = kvSuperTanks.GetNum("Rocket Ability/Rocket Hit", g_iRocketHit[iIndex]));
			main ? (g_iRocketHit[iIndex] = iSetCellLimit(g_iRocketHit[iIndex], 0, 1)) : (g_iRocketHit2[iIndex] = iSetCellLimit(g_iRocketHit2[iIndex], 0, 1));
			main ? (g_flRocketRange[iIndex] = kvSuperTanks.GetFloat("Rocket Ability/Rocket Range", 150.0)) : (g_flRocketRange2[iIndex] = kvSuperTanks.GetFloat("Rocket Ability/Rocket Range", g_flRocketRange[iIndex]));
			main ? (g_flRocketRange[iIndex] = flSetFloatLimit(g_flRocketRange[iIndex], 1.0, 9999999999.0)) : (g_flRocketRange2[iIndex] = flSetFloatLimit(g_flRocketRange2[iIndex], 1.0, 9999999999.0));
			main ? (g_iRocketRangeChance[iIndex] = kvSuperTanks.GetNum("Rocket Ability/Rocket Range Chance", 16)) : (g_iRocketRangeChance2[iIndex] = kvSuperTanks.GetNum("Rocket Ability/Rocket Range Chance", g_iRocketRangeChance[iIndex]));
			main ? (g_iRocketRangeChance[iIndex] = iSetCellLimit(g_iRocketRangeChance[iIndex], 1, 9999999999)) : (g_iRocketRangeChance2[iIndex] = iSetCellLimit(g_iRocketRangeChance2[iIndex], 1, 9999999999));
			kvSuperTanks.Rewind();
		}
	}
	delete kvSuperTanks;
}

public void ST_Ability(int client)
{
	if (ST_TankAllowed(client) && IsPlayerAlive(client))
	{
		int iRocketAbility = !g_bTankConfig[ST_TankType(client)] ? g_iRocketAbility[ST_TankType(client)] : g_iRocketAbility2[ST_TankType(client)];
		int iRocketRangeChance = !g_bTankConfig[ST_TankType(client)] ? g_iRocketChance[ST_TankType(client)] : g_iRocketChance2[ST_TankType(client)];
		float flRocketRange = !g_bTankConfig[ST_TankType(client)] ? g_flRocketRange[ST_TankType(client)] : g_flRocketRange2[ST_TankType(client)];
		float flTankPos[3];
		GetClientAbsOrigin(client, flTankPos);
		for (int iSurvivor = 1; iSurvivor <= MaxClients; iSurvivor++)
		{
			if (bIsSurvivor(iSurvivor))
			{
				float flSurvivorPos[3];
				GetClientAbsOrigin(iSurvivor, flSurvivorPos);
				float flDistance = GetVectorDistance(flTankPos, flSurvivorPos);
				if (flDistance <= flRocketRange)
				{
					vRocketHit(iSurvivor, client, iRocketRangeChance, iRocketAbility);
				}
			}
		}
	}
}

void vRocketHit(int client, int owner, int chance, int enabled)
{
	if (enabled == 1 && GetRandomInt(1, chance) == 1 && bIsSurvivor(client))
	{
		int iFlame = CreateEntityByName("env_steam");
		if (bIsValidEntity(iFlame))
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
			vSetEntityParent(iFlame, client);
			iFlame = EntIndexToEntRef(iFlame);
			vDeleteEntity(iFlame, 3.0);
			g_iRocket[client] = iFlame;
		}
		EmitSoundToAll(SOUND_FIRE, client, _, _, _, 1.0);
		DataPack dpDataPack;
		CreateDataTimer(2.0, tTimerRocketLaunch, dpDataPack, TIMER_FLAG_NO_MAPCHANGE);
		dpDataPack.WriteCell(GetClientUserId(client));
		dpDataPack.WriteCell(GetClientUserId(owner));
		DataPack dpDataPack2;
		CreateDataTimer(3.5, tTimerRocketDetonate, dpDataPack2, TIMER_FLAG_NO_MAPCHANGE);
		dpDataPack2.WriteCell(GetClientUserId(client));
		dpDataPack2.WriteCell(GetClientUserId(owner));
	}
}

void vCreateInfoFile(const char[] filepath, const char[] folder, const char[] filename, const char[] label = "")
{
	char sConfigFilename[128];
	char sConfigLabel[128];
	File fFilename;
	Format(sConfigFilename, sizeof(sConfigFilename), "%s%s%s.txt", filepath, folder, filename);
	if (FileExists(sConfigFilename))
	{
		return;
	}
	fFilename = OpenFile(sConfigFilename, "w+");
	strlen(label) > 0 ? strcopy(sConfigLabel, sizeof(sConfigLabel), label) : strcopy(sConfigLabel, sizeof(sConfigLabel), sConfigFilename);
	if (fFilename != null)
	{
		fFilename.WriteLine("// Note: The config will automatically update any changes mid-game. No need to restart the server or reload the plugin.");
		fFilename.WriteLine("\"Super Tanks++\"");
		fFilename.WriteLine("{");
		fFilename.WriteLine("	\"Example\"");
		fFilename.WriteLine("	{");
		fFilename.WriteLine("		// The Super Tank sends survivors into space.");
		fFilename.WriteLine("		// \"Ability Enabled\" - When a survivor is within range of the Tank, the survivor is sent into space.");
		fFilename.WriteLine("		// - \"Rocket Range\"");
		fFilename.WriteLine("		// - \"Rocket Range Chance\"");
		fFilename.WriteLine("		// \"Rocket Hit\" - When a survivor is hit by a Tank's claw or rock, the survivor is sent into space.");
		fFilename.WriteLine("		// - \"Rocket Chance\"");
		fFilename.WriteLine("		// Requires \"st_rocket.smx\" to be installed.");
		fFilename.WriteLine("		\"Rocket Ability\"");
		fFilename.WriteLine("		{");
		fFilename.WriteLine("			// Enable this ability.");
		fFilename.WriteLine("			// Note: This setting does not affect the \"Rocket Hit\" setting.");
		fFilename.WriteLine("			// 0: OFF");
		fFilename.WriteLine("			// 1: ON");
		fFilename.WriteLine("			\"Ability Enabled\"				\"0\"");
		fFilename.WriteLine("");
		fFilename.WriteLine("			// The Super Tank has 1 out of this many chances to trigger the ability.");
		fFilename.WriteLine("			// Minimum: 1 (Greatest chance)");
		fFilename.WriteLine("			// Maximum: 9999999999 (Less chance)");
		fFilename.WriteLine("			\"Rocket Chance\"					\"4\"");
		fFilename.WriteLine("");
		fFilename.WriteLine("			// Enable the Super Tank's claw/rock attack.");
		fFilename.WriteLine("			// 0: OFF");
		fFilename.WriteLine("			// 1: ON");
		fFilename.WriteLine("			\"Rocket Hit\"					\"0\"");
		fFilename.WriteLine("");
		fFilename.WriteLine("			// The distance between a survivor and the Super Tank needed to trigger the ability.");
		fFilename.WriteLine("			// Minimum: 1.0 (Closest)");
		fFilename.WriteLine("			// Maximum: 9999999999.0 (Farthest)");
		fFilename.WriteLine("			\"Rocket Range\"					\"150.0\"");
		fFilename.WriteLine("");
		fFilename.WriteLine("			// The Super Tank has 1 out of this many chances to trigger the range ability.");
		fFilename.WriteLine("			// Minimum: 1 (Greatest chance)");
		fFilename.WriteLine("			// Maximum: 9999999999 (Less chance)");
		fFilename.WriteLine("			\"Rocket Range Chance\"			\"16\"");
		fFilename.WriteLine("		}");
		fFilename.WriteLine("	}");
		fFilename.WriteLine("}");
		delete fFilename;
	}
}

public Action tTimerRocketLaunch(Handle timer, DataPack pack)
{
	pack.Reset();
	int iSurvivor = GetClientOfUserId(pack.ReadCell());
	int iTank = GetClientOfUserId(pack.ReadCell());
	int iRocketAbility = !g_bTankConfig[ST_TankType(iTank)] ? g_iRocketAbility[ST_TankType(iTank)] : g_iRocketAbility2[ST_TankType(iTank)];
	if (iRocketAbility == 0 || !bIsTank(iTank) || !IsPlayerAlive(iTank) || !bIsSurvivor(iSurvivor))
	{
		return Plugin_Stop;
	}
	if (bIsSurvivor(iSurvivor))
	{
		float flVelocity[3];
		flVelocity[0] = 0.0;
		flVelocity[1] = 0.0;
		flVelocity[2] = 800.0;
		EmitSoundToAll(SOUND_EXPLOSION, iSurvivor, _, _, _, 1.0);
		EmitSoundToAll(SOUND_LAUNCH, iSurvivor, _, _, _, 1.0);
		TeleportEntity(iSurvivor, NULL_VECTOR, NULL_VECTOR, flVelocity);
		SetEntityGravity(iSurvivor, 0.1);
	}
	return Plugin_Handled;
}

public Action tTimerRocketDetonate(Handle timer, DataPack pack)
{
	pack.Reset();
	int iSurvivor = GetClientOfUserId(pack.ReadCell());
	int iTank = GetClientOfUserId(pack.ReadCell());
	int iRocketAbility = !g_bTankConfig[ST_TankType(iTank)] ? g_iRocketAbility[ST_TankType(iTank)] : g_iRocketAbility2[ST_TankType(iTank)];
	if (iRocketAbility == 0 || !bIsTank(iTank) || !IsPlayerAlive(iTank) || !bIsSurvivor(iSurvivor))
	{
		return Plugin_Stop;
	}
	if (bIsSurvivor(iSurvivor))
	{
		float flPosition[3];
		GetClientAbsOrigin(iSurvivor, flPosition);
		TE_SetupExplosion(flPosition, g_iRocketSprite, 10.0, 1, 0, 600, 5000);
		TE_SendToAll();
		g_iRocket[iSurvivor] = 0;
		ForcePlayerSuicide(iSurvivor);
		SetEntityGravity(iSurvivor, 1.0);
	}
	return Plugin_Handled;
}