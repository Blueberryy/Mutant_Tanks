// Super Tanks++: Throw Ability
#pragma semicolon 1
#pragma newdecls required
#include <super_tanks++>

public Plugin myinfo =
{
	name = "[ST++] Throw Ability",
	author = ST_AUTHOR,
	description = ST_DESCRIPTION,
	version = ST_VERSION,
	url = ST_URL
};

#define MODEL_CAR "models/props_vehicles/cara_82hatchback.mdl"
#define MODEL_CAR2 "models/props_vehicles/cara_69sedan.mdl"
#define MODEL_CAR3 "models/props_vehicles/cara_84sedan.mdl"

bool g_bTankConfig[ST_MAXTYPES + 1];
char g_sThrowCarOptions[ST_MAXTYPES + 1][7];
char g_sThrowCarOptions2[ST_MAXTYPES + 1][7];
char g_sThrowInfectedOptions[ST_MAXTYPES + 1][15];
char g_sThrowInfectedOptions2[ST_MAXTYPES + 1][15];
ConVar g_cvSTFindConVar;
int g_iThrowAbility[ST_MAXTYPES + 1];
int g_iThrowAbility2[ST_MAXTYPES + 1];

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	EngineVersion evEngine = GetEngineVersion();
	if (evEngine != Engine_Left4Dead && evEngine != Engine_Left4Dead2)
	{
		strcopy(error, err_max, "[ST++] Throw Ability only supports Left 4 Dead 1 & 2.");
		return APLRes_SilentFailure;
	}
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
	g_cvSTFindConVar = FindConVar("z_tank_throw_force");
}

public void OnMapStart()
{
	PrecacheModel(MODEL_CAR, true);
	PrecacheModel(MODEL_CAR2, true);
	PrecacheModel(MODEL_CAR3, true);
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
			main ? (g_bTankConfig[iIndex] = false) : (g_bTankConfig[iIndex] = true);
			main ? (g_iThrowAbility[iIndex] = kvSuperTanks.GetNum("Throw Ability/Ability Enabled", 0)) : (g_iThrowAbility2[iIndex] = kvSuperTanks.GetNum("Throw Ability/Ability Enabled", g_iThrowAbility[iIndex]));
			main ? (g_iThrowAbility[iIndex] = iSetCellLimit(g_iThrowAbility[iIndex], 0, 3)) : (g_iThrowAbility2[iIndex] = iSetCellLimit(g_iThrowAbility2[iIndex], 0, 3));
			main ? (kvSuperTanks.GetString("Throw Ability/Throw Car Options", g_sThrowCarOptions[iIndex], sizeof(g_sThrowCarOptions[]), "123")) : (kvSuperTanks.GetString("Throw Ability/Throw Car Options", g_sThrowCarOptions2[iIndex], sizeof(g_sThrowCarOptions2[]), g_sThrowCarOptions[iIndex]));
			main ? (kvSuperTanks.GetString("Throw Ability/Throw Infected Options", g_sThrowInfectedOptions[iIndex], sizeof(g_sThrowInfectedOptions[]), "1234567")) : (kvSuperTanks.GetString("Throw Ability/Throw Infected Options", g_sThrowInfectedOptions2[iIndex], sizeof(g_sThrowInfectedOptions2[]), g_sThrowInfectedOptions[iIndex]));
			kvSuperTanks.Rewind();
		}
	}
	delete kvSuperTanks;
}

public void ST_RockThrow(int client, int entity)
{
	int iThrowAbility = !g_bTankConfig[ST_TankType(client)] ? g_iThrowAbility[ST_TankType(client)] : g_iThrowAbility2[ST_TankType(client)];
	if (iThrowAbility == 1)
	{
		DataPack dpDataPack;
		CreateDataTimer(0.1, tTimerCarThrow, dpDataPack, TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
		dpDataPack.WriteCell(GetClientUserId(client));
		dpDataPack.WriteCell(EntIndexToEntRef(entity));
	}
	if (iThrowAbility == 2)
	{
		DataPack dpDataPack;
		CreateDataTimer(0.1, tTimerInfectedThrow, dpDataPack, TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
		dpDataPack.WriteCell(GetClientUserId(client));
		dpDataPack.WriteCell(EntIndexToEntRef(entity));
	}
	if (iThrowAbility == 3)
	{
		DataPack dpDataPack;
		CreateDataTimer(0.1, tTimerSelfThrow, dpDataPack, TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
		dpDataPack.WriteCell(GetClientUserId(client));
		dpDataPack.WriteCell(EntIndexToEntRef(entity));
	}
}

void vDeleteEntity(int entity, float time = 0.1)
{
	if (bIsValidEntRef(entity))
	{
		char sVariant[64];
		Format(sVariant, sizeof(sVariant), "OnUser1 !self:kill::%f:1", time);
		AcceptEntityInput(entity, "ClearParent");
		SetVariantString(sVariant);
		AcceptEntityInput(entity, "AddOutput");
		AcceptEntityInput(entity, "FireUser1");
	}
}

void vSpawnInfected(int client, char[] infected)
{
	ChangeClientTeam(client, 3);
	char sCommand[32];
	sCommand = bIsL4D2Game() ? "z_spawn_old" : "z_spawn";
	int iCmdFlags = GetCommandFlags(sCommand);
	SetCommandFlags(sCommand, iCmdFlags & ~FCVAR_CHEAT);
	FakeClientCommand(client, "%s %s", sCommand, infected);
	SetCommandFlags(sCommand, iCmdFlags|FCVAR_CHEAT);
	KickClient(client);
}

bool bIsValidEntity(int entity)
{
	return entity > 0 && entity <= 2048 && IsValidEntity(entity);
}

bool bIsValidEntRef(int entity)
{
	return entity && EntRefToEntIndex(entity) != INVALID_ENT_REFERENCE;
}

public Action tTimerCarThrow(Handle timer, DataPack pack)
{
	pack.Reset();
	int iTank = GetClientOfUserId(pack.ReadCell());
	int iRock = EntRefToEntIndex(pack.ReadCell());
	int iThrowAbility = !g_bTankConfig[ST_TankType(iTank)] ? g_iThrowAbility[ST_TankType(iTank)] : g_iThrowAbility2[ST_TankType(iTank)];
	if (iThrowAbility == 0 || iThrowAbility != 1 || iTank == 0 || !IsClientInGame(iTank) || !IsPlayerAlive(iTank) || iRock == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}
	if (bIsTank(iTank))
	{
		float flVelocity[3];
		if (bIsValidEntity(iRock))
		{
			GetEntPropVector(iRock, Prop_Data, "m_vecVelocity", flVelocity);
			float flVector = GetVectorLength(flVelocity);
			if (flVector > 500.0)
			{
				int iCar = CreateEntityByName("prop_physics");
				if (bIsValidEntity(iCar))
				{
					char sNumbers = !g_bTankConfig[ST_TankType(iTank)] ? g_sThrowCarOptions[ST_TankType(iTank)][GetRandomInt(0, strlen(g_sThrowCarOptions[ST_TankType(iTank)]) - 1)] : g_sThrowCarOptions2[ST_TankType(iTank)][GetRandomInt(0, strlen(g_sThrowCarOptions2[ST_TankType(iTank)]) - 1)];
					switch (sNumbers)
					{
						case '1': SetEntityModel(iCar, MODEL_CAR);
						case '2': SetEntityModel(iCar, MODEL_CAR2);
						case '3': SetEntityModel(iCar, MODEL_CAR3);
						default: SetEntityModel(iCar, MODEL_CAR);
					}
					int iRed = GetRandomInt(0, 255);
					int iGreen = GetRandomInt(0, 255);
					int iBlue = GetRandomInt(0, 255);
					SetEntityRenderColor(iCar, iRed, iGreen, iBlue, 255);
					float flPos[3];
					GetEntPropVector(iRock, Prop_Send, "m_vecOrigin", flPos);
					AcceptEntityInput(iRock, "Kill");
					NormalizeVector(flVelocity, flVelocity);
					float flSpeed = g_cvSTFindConVar.FloatValue;
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

public Action tTimerInfectedThrow(Handle timer, DataPack pack)
{
	pack.Reset();
	int iTank = GetClientOfUserId(pack.ReadCell());
	int iRock = EntRefToEntIndex(pack.ReadCell());
	int iThrowAbility = !g_bTankConfig[ST_TankType(iTank)] ? g_iThrowAbility[ST_TankType(iTank)] : g_iThrowAbility2[ST_TankType(iTank)];
	if (iThrowAbility == 0 || iThrowAbility != 2 || iTank == 0 || !IsClientInGame(iTank) || !IsPlayerAlive(iTank) || iRock == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}
	if (bIsTank(iTank))
	{
		float flVelocity[3];
		if (bIsValidEntity(iRock))
		{
			GetEntPropVector(iRock, Prop_Data, "m_vecVelocity", flVelocity);
			float flVector = GetVectorLength(flVelocity);
			if (flVector > 500.0)
			{
				int iInfected = CreateFakeClient("Infected");
				if (iInfected > 0)
				{
					char sNumbers = !g_bTankConfig[ST_TankType(iTank)] ? g_sThrowInfectedOptions[ST_TankType(iTank)][GetRandomInt(0, strlen(g_sThrowInfectedOptions[ST_TankType(iTank)]) - 1)] : g_sThrowInfectedOptions2[ST_TankType(iTank)][GetRandomInt(0, strlen(g_sThrowInfectedOptions2[ST_TankType(iTank)]) - 1)];
					switch (sNumbers)
					{
						case '1': vSpawnInfected(iInfected, "smoker");
						case '2': vSpawnInfected(iInfected, "boomer");
						case '3': vSpawnInfected(iInfected, "hunter");
						case '4': bIsL4D2Game() ? vSpawnInfected(iInfected, "spitter") : vSpawnInfected(iInfected, "boomer");
						case '5': bIsL4D2Game() ? vSpawnInfected(iInfected, "jockey") : vSpawnInfected(iInfected, "hunter");
						case '6': bIsL4D2Game() ? vSpawnInfected(iInfected, "charger") : vSpawnInfected(iInfected, "smoker");
						case '7': vSpawnInfected(iInfected, "tank");
						default: vSpawnInfected(iInfected, "hunter");
					}
					float flPos[3];
					GetEntPropVector(iRock, Prop_Send, "m_vecOrigin", flPos);
					AcceptEntityInput(iRock, "Kill");
					NormalizeVector(flVelocity, flVelocity);
					float flSpeed = g_cvSTFindConVar.FloatValue;
					ScaleVector(flVelocity, flSpeed * 1.4);
					TeleportEntity(iInfected, flPos, NULL_VECTOR, flVelocity);
				}
				return Plugin_Stop;
			}
		}
	}
	return Plugin_Continue;
}

public Action tTimerSelfThrow(Handle timer, DataPack pack)
{
	pack.Reset();
	int iTank = GetClientOfUserId(pack.ReadCell());
	int iRock = EntRefToEntIndex(pack.ReadCell());
	int iThrowAbility = !g_bTankConfig[ST_TankType(iTank)] ? g_iThrowAbility[ST_TankType(iTank)] : g_iThrowAbility2[ST_TankType(iTank)];
	if (iThrowAbility == 0 || iThrowAbility != 3 || iTank == 0 || !IsClientInGame(iTank) || !IsPlayerAlive(iTank) || iRock == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}
	if (bIsTank(iTank))
	{
		float flVelocity[3];
		if (bIsValidEntity(iRock))
		{
			GetEntPropVector(iRock, Prop_Data, "m_vecVelocity", flVelocity);
			float flVector = GetVectorLength(flVelocity);
			if (flVector > 500.0)
			{
				float flPos[3];
				GetEntPropVector(iRock, Prop_Send, "m_vecOrigin", flPos);
				AcceptEntityInput(iRock, "Kill");
				NormalizeVector(flVelocity, flVelocity);
				float flSpeed = g_cvSTFindConVar.FloatValue;
				ScaleVector(flVelocity, flSpeed * 1.4);
				TeleportEntity(iTank, flPos, NULL_VECTOR, flVelocity);
				return Plugin_Stop;
			}
		}
	}
	return Plugin_Continue;
}