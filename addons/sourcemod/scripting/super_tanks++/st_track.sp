// Super Tanks++: Track Ability
#pragma semicolon 1
#pragma newdecls required
#include <super_tanks++>

public Plugin myinfo =
{
	name = "[ST++] Track Ability",
	author = ST_AUTHOR,
	description = ST_DESCRIPTION,
	version = ST_VERSION,
	url = ST_URL
};

bool g_bTankConfig[ST_MAXTYPES + 1];
char g_sTankColors[ST_MAXTYPES + 1][28];
char g_sTankColors2[ST_MAXTYPES + 1][28];
float g_flTrackSpeed[ST_MAXTYPES + 1];
float g_flTrackSpeed2[ST_MAXTYPES + 1];
int g_iGlowEffect[ST_MAXTYPES + 1];
int g_iGlowEffect2[ST_MAXTYPES + 1];
int g_iTrackAbility[ST_MAXTYPES + 1];
int g_iTrackAbility2[ST_MAXTYPES + 1];
int g_iTrackChance[ST_MAXTYPES + 1];
int g_iTrackChance2[ST_MAXTYPES + 1];
int g_iTrackMode[ST_MAXTYPES + 1];
int g_iTrackMode2[ST_MAXTYPES + 1];

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	EngineVersion evEngine = GetEngineVersion();
	if (evEngine != Engine_Left4Dead && evEngine != Engine_Left4Dead2)
	{
		strcopy(error, err_max, "[ST++] Track Ability only supports Left 4 Dead 1 & 2.");
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

public void Think(int entity)
{
	bIsValidEntity(entity) ? vTrack(entity) : SDKUnhook(entity, SDKHook_Think, Think);
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
			main ? (kvSuperTanks.GetString("General/Skin-Glow Colors", g_sTankColors[iIndex], sizeof(g_sTankColors[]), "255,255,255,255|255,255,255")) : (kvSuperTanks.GetString("General/Skin-Glow Colors", g_sTankColors2[iIndex], sizeof(g_sTankColors2[]), g_sTankColors[iIndex]));
			main ? (g_iGlowEffect[iIndex] = kvSuperTanks.GetNum("General/Glow Effect", 1)) : (g_iGlowEffect2[iIndex] = kvSuperTanks.GetNum("General/Glow Effect", g_iGlowEffect[iIndex]));
			main ? (g_iGlowEffect[iIndex] = iSetCellLimit(g_iGlowEffect[iIndex], 0, 1)) : (g_iGlowEffect2[iIndex] = iSetCellLimit(g_iGlowEffect2[iIndex], 0, 1));
			main ? (g_iTrackAbility[iIndex] = kvSuperTanks.GetNum("Track Ability/Ability Enabled", 0)) : (g_iTrackAbility2[iIndex] = kvSuperTanks.GetNum("Track Ability/Ability Enabled", g_iTrackAbility[iIndex]));
			main ? (g_iTrackAbility[iIndex] = iSetCellLimit(g_iTrackAbility[iIndex], 0, 1)) : (g_iTrackAbility2[iIndex] = iSetCellLimit(g_iTrackAbility2[iIndex], 0, 1));
			main ? (g_iTrackChance[iIndex] = kvSuperTanks.GetNum("Track Ability/Track Chance", 4)) : (g_iTrackChance2[iIndex] = kvSuperTanks.GetNum("Track Ability/Track Chance", g_iTrackChance[iIndex]));
			main ? (g_iTrackChance[iIndex] = iSetCellLimit(g_iTrackChance[iIndex], 1, 9999999999)) : (g_iTrackChance2[iIndex] = iSetCellLimit(g_iTrackChance2[iIndex], 1, 9999999999));
			main ? (g_iTrackMode[iIndex] = kvSuperTanks.GetNum("Track Ability/Track Mode", 1)) : (g_iTrackMode2[iIndex] = kvSuperTanks.GetNum("Track Ability/Track Mode", g_iTrackMode[iIndex]));
			main ? (g_iTrackMode[iIndex] = iSetCellLimit(g_iTrackMode[iIndex], 0, 1)) : (g_iTrackMode2[iIndex] = iSetCellLimit(g_iTrackMode2[iIndex], 0, 1));
			main ? (g_flTrackSpeed[iIndex] = kvSuperTanks.GetFloat("Track Ability/Track Speed", 300.0)) : (g_flTrackSpeed2[iIndex] = kvSuperTanks.GetFloat("Track Ability/Track Speed", g_flTrackSpeed[iIndex]));
			main ? (g_flTrackSpeed[iIndex] = flSetFloatLimit(g_flTrackSpeed[iIndex], 100.0, 500.0)) : (g_flTrackSpeed2[iIndex] = flSetFloatLimit(g_flTrackSpeed2[iIndex], 100.0, 500.0));
			kvSuperTanks.Rewind();
		}
	}
	delete kvSuperTanks;
}

public void ST_RockThrow(int client, int entity)
{
	int iTrackAbility = !g_bTankConfig[ST_TankType(client)] ? g_iTrackAbility[ST_TankType(client)] : g_iTrackAbility2[ST_TankType(client)];
	int iTrackChance = !g_bTankConfig[ST_TankType(client)] ? g_iTrackChance[ST_TankType(client)] : g_iTrackChance2[ST_TankType(client)];
	if (iTrackAbility == 1 && GetRandomInt(1, iTrackChance) == 1 && bIsTank(client))
	{
		DataPack dpDataPack;
		CreateDataTimer(0.5, tTimerTrack, dpDataPack, TIMER_FLAG_NO_MAPCHANGE);
		dpDataPack.WriteCell(GetClientUserId(client));
		dpDataPack.WriteCell(EntIndexToEntRef(entity));
	}
}

void vTrack(int entity)
{
	int iTank = GetEntPropEnt(entity, Prop_Data, "m_hThrower");
	int iTrackMode = !g_bTankConfig[ST_TankType(iTank)] ? g_iTrackMode[ST_TankType(iTank)] : g_iTrackMode2[ST_TankType(iTank)];
	float flTrackSpeed = !g_bTankConfig[ST_TankType(iTank)] ? g_flTrackSpeed[ST_TankType(iTank)] : g_flTrackSpeed2[ST_TankType(iTank)];
	switch (iTrackMode)
	{
		case 0:
		{
			float flPos[3];
			float flVelocity[3];
			GetEntPropVector(entity, Prop_Send, "m_vecOrigin", flPos);
			GetEntPropVector(entity, Prop_Data, "m_vecVelocity", flVelocity);
			float flVector = GetVectorLength(flVelocity);
			if (flVector < 100.0)
			{
				return;
			}
			NormalizeVector(flVelocity, flVelocity);
			int iTarget = iGetRandomTarget(flPos, flVelocity);
			if (iTarget > 0)
			{
				float flPos2[3];
				float flVelocity2[3];
				GetClientEyePosition(iTarget, flPos2);
				GetEntPropVector(iTarget, Prop_Data, "m_vecVelocity", flVelocity2);
				bool bVisible = bVisiblePosition(flPos, flPos2, entity, 2);
				float flDistance = GetVectorDistance(flPos, flPos2);
				if (!bVisible || flDistance > 500.0)
				{
					return;
				}
				SetEntityGravity(entity, 0.01);
				float flDirection[3];
				float flVelocity3[3];
				SubtractVectors(flPos2, flPos, flDirection);
				NormalizeVector(flDirection, flDirection);
				ScaleVector(flDirection, 0.5);
				AddVectors(flVelocity, flDirection, flVelocity3);
				NormalizeVector(flVelocity3, flVelocity3);
				ScaleVector(flVelocity3, flVector);
				TeleportEntity(entity, NULL_VECTOR, NULL_VECTOR, flVelocity3);
			}
		}
		case 1:
		{
			float flPos[3];
			float flVelocity[3];
			GetEntPropVector(entity, Prop_Send, "m_vecOrigin", flPos);
			GetEntPropVector(entity, Prop_Data, "m_vecVelocity", flVelocity);
			if (GetVectorLength(flVelocity) < 50.0)
			{
				return;
			}
			NormalizeVector(flVelocity, flVelocity);
			int iTarget = iGetRandomTarget(flPos, flVelocity);
			float flVelocity2[3];
			float flVector[3];
			flVector[0] = flVector[1] = flVector[2] = 0.0;
			bool bVisible;
			float flAngle[3];
			float flDistance = 1000.0;
			if (iTarget > 0)
			{
				float flPos2[3];
				GetClientEyePosition(iTarget, flPos2);
				flDistance = GetVectorDistance(flPos, flPos2);
				bVisible = bVisiblePosition(flPos, flPos2, entity, 1);
				GetEntPropVector(iTarget, Prop_Data, "m_vecVelocity", flVelocity2);
				AddVectors(flPos2, flVelocity2, flPos2);
				MakeVectorFromPoints(flPos, flPos2, flVector);
			}
			GetVectorAngles(flVelocity, flAngle);
			float flLeft[3];
			float flRight[3];
			float flUp[3];
			float flDown[3];
			float flFront[3];
			float flVector1[3];
			float flVector2[3];
			float flVector3[3];
			float flVector4[3];
			float flVector5[3];
			float flVector6[3];
			float flVector7[3];
			float flVector8[3];
			flFront[0] = flFront[1] = flFront[2] = 0.0;
			float flFactor1 = 0.2;
			float flFactor2 = 0.5;
			float flVector9;
			float flBase = 1500.0;
			if (bVisible)
			{
				flBase = 80.0;
				float flFront2 = flGetDistance(flPos, flAngle, 0.0, 0.0, flFront, entity);
				float flDown2 = flGetDistance(flPos, flAngle, 90.0, 0.0, flDown, entity);
				float flUp2 = flGetDistance(flPos, flAngle, -90.0, 0.0, flUp, entity);
				float flLeft2 = flGetDistance(flPos, flAngle, 0.0, 90.0, flLeft, entity);
				float flRight2 = flGetDistance(flPos, flAngle, 0.0, -90.0, flRight, entity);
				float flDistance2 = flGetDistance(flPos, flAngle, 30.0, 0.0, flVector1, entity);
				float flDistance3 = flGetDistance(flPos, flAngle, 30.0, 45.0, flVector2, entity);
				float flDistance4 = flGetDistance(flPos, flAngle, 0.0, 45.0, flVector3, entity);
				float flDistance5 = flGetDistance(flPos, flAngle, -30.0, 45.0, flVector4, entity);
				float flDistance6 = flGetDistance(flPos, flAngle, -30.0, 0.0, flVector5, entity);
				float flDistance7 = flGetDistance(flPos, flAngle, -30.0, -45.0, flVector6, entity);
				float flDistance8 = flGetDistance(flPos, flAngle, 0.0, -45.0, flVector7, entity);
				float flDistance9 = flGetDistance(flPos, flAngle, 30.0, -45.0, flVector8, entity);
				NormalizeVector(flFront, flFront);
				NormalizeVector(flUp, flUp);
				NormalizeVector(flDown, flDown);
				NormalizeVector(flLeft, flLeft);
				NormalizeVector(flRight, flRight);
				NormalizeVector(flVector, flVector);
				NormalizeVector(flVector1, flVector1);
				NormalizeVector(flVector2, flVector2);
				NormalizeVector(flVector3, flVector3);
				NormalizeVector(flVector4, flVector4);
				NormalizeVector(flVector5, flVector5);
				NormalizeVector(flVector6, flVector6);
				NormalizeVector(flVector7, flVector7);
				NormalizeVector(flVector8, flVector8);
				if (flFront2 > flBase)
				{
					flFront2 = flBase;
				}
				if (flUp2 > flBase)
				{
					flUp2 = flBase;
				}
				if (flDown2 > flBase)
				{
					flDown2 = flBase;
				}
				if (flLeft2 > flBase)
				{
					flLeft2 = flBase;
				}
				if (flRight2 > flBase)
				{
					flRight2 = flBase;
				}
				if (flDistance2 > flBase)
				{
					flDistance2 = flBase;
				}
				if (flDistance3 > flBase)
				{
					flDistance3 = flBase;
				}
				if (flDistance4 > flBase)
				{
					flDistance4 = flBase;
				}
				if (flDistance5 > flBase)
				{
					flDistance5 = flBase;
				}
				if (flDistance6 > flBase)
				{
					flDistance6 = flBase;
				}
				if (flDistance7 > flBase)
				{
					flDistance7 = flBase;
				}
				if (flDistance8 > flBase)
				{
					flDistance8 = flBase;
				}
				if (flDistance9 > flBase)
				{
					flDistance9 = flBase;
				}
				flVector9 =- 1.0 * flFactor1 * (flBase - flFront2) / flBase;
				ScaleVector(flFront, flVector9);
				flVector9 =- 1.0 * flFactor1 * (flBase - flUp2) / flBase;
				ScaleVector(flUp, flVector9);
				flVector9 =- 1.0 * flFactor1 * (flBase - flDown2) / flBase;
				ScaleVector(flDown, flVector9);
				flVector9 =- 1.0 * flFactor1 * (flBase - flLeft2) / flBase;
				ScaleVector(flLeft, flVector9);
				flVector9 =- 1.0 * flFactor1 * (flBase - flRight2) / flBase;
				ScaleVector(flRight, flVector9);
				flVector9 =- 1.0 * flFactor1 * (flBase - flDistance2) / flDistance2;
				ScaleVector(flVector1, flVector9);
				flVector9 =- 1.0 * flFactor1 * (flBase - flDistance3) / flDistance3;
				ScaleVector(flVector2, flVector9);
				flVector9 =- 1.0 * flFactor1 * (flBase - flDistance4) / flDistance4;
				ScaleVector(flVector3, flVector9);
				flVector9 =- 1.0 * flFactor1 * (flBase - flDistance5) / flDistance5;
				ScaleVector(flVector4, flVector9);
				flVector9 =- 1.0 * flFactor1 * (flBase - flDistance6) / flDistance6;
				ScaleVector(flVector5, flVector9);
				flVector9 =- 1.0 * flFactor1 * (flBase - flDistance7) / flDistance7;
				ScaleVector(flVector6, flVector9);
				flVector9 =- 1.0 * flFactor1 * (flBase - flDistance8) / flDistance8;
				ScaleVector(flVector7, flVector9);
				flVector9 =- 1.0 * flFactor1 * (flBase - flDistance9) / flDistance9;
				ScaleVector(flVector8, flVector9);
				if (flDistance >= 500.0)
				{
					flDistance = 500.0;
				}
				flVector9 = 1.0 * flFactor2 * (1000.0 - flDistance) / 500.0;
				ScaleVector(flVector, flVector9);
				AddVectors(flFront, flUp, flFront);
				AddVectors(flFront, flDown, flFront);
				AddVectors(flFront, flLeft, flFront);
				AddVectors(flFront, flRight, flFront);
				AddVectors(flFront, flVector1, flFront);
				AddVectors(flFront, flVector2, flFront);
				AddVectors(flFront, flVector3, flFront);
				AddVectors(flFront, flVector4, flFront);
				AddVectors(flFront, flVector5, flFront);
				AddVectors(flFront, flVector6, flFront);
				AddVectors(flFront, flVector7, flFront);
				AddVectors(flFront, flVector8, flFront);
				AddVectors(flFront, flVector, flFront);
				NormalizeVector(flFront, flFront);
			}
			float flAngle2 = flGetAngle(flFront, flVelocity);
			ScaleVector(flFront, flAngle2);
			float flVelocity3[3];
			AddVectors(flVelocity, flFront, flVelocity3);
			NormalizeVector(flVelocity3, flVelocity3);
			ScaleVector(flVelocity3, flTrackSpeed);
			SetEntityGravity(entity, 0.01);
			TeleportEntity(entity, NULL_VECTOR, NULL_VECTOR, flVelocity3);
			char sSet[2][16];
			char sTankColors[28];
			sTankColors = !g_bTankConfig[ST_TankType(iTank)] ? g_sTankColors[ST_TankType(iTank)] : g_sTankColors2[ST_TankType(iTank)];
			TrimString(sTankColors);
			ExplodeString(sTankColors, "|", sSet, sizeof(sSet), sizeof(sSet[]));
			char sGlow[3][4];
			ExplodeString(sSet[1], ",", sGlow, sizeof(sGlow), sizeof(sGlow[]));
			TrimString(sGlow[0]);
			int iRed2 = (sGlow[0][0] != '\0') ? StringToInt(sGlow[0]) : 255;
			TrimString(sGlow[1]);
			int iGreen2 = (sGlow[1][0] != '\0') ? StringToInt(sGlow[1]) : 255;
			TrimString(sGlow[2]);
			int iBlue2 = (sGlow[2][0] != '\0') ? StringToInt(sGlow[2]) : 255;
			int iGlowEffect = !g_bTankConfig[ST_TankType(iTank)] ? g_iGlowEffect[ST_TankType(iTank)] : g_iGlowEffect2[ST_TankType(iTank)];
			if (iGlowEffect == 1 && bIsL4D2Game())
			{
				SetEntProp(entity, Prop_Send, "m_iGlowType", 3);
				SetEntProp(entity, Prop_Send, "m_nGlowRange", 0);
				SetEntProp(entity, Prop_Send, "m_glowColorOverride", iGetRGBColor(iRed2, iGreen2, iBlue2));
			}
		}
	}
}

void vCopyVector(float source[3], float target[3])
{
	target[0] = source[0];
	target[1] = source[1];
	target[2] = source[2];
}

float flGetAngle(float angle1[3], float angle2[3])
{
	return ArcCosine(GetVectorDotProduct(angle1, angle2) / (GetVectorLength(angle1) * GetVectorLength(angle2)));
}

float flGetDistance(float pos[3], float angle[3], float offset1, float offset2, float force[3], int entity) 
{
	float flAngle[3];
	vCopyVector(angle, flAngle);
	flAngle[0] += offset1;
	flAngle[1] += offset2;
	GetAngleVectors(flAngle, force, NULL_VECTOR, NULL_VECTOR);
	float flDistance = flGetRayDistance(pos, flAngle, entity);
	return flDistance;
}

float flGetRayDistance(float pos[3], float angle[3], int entity)
{
	float flHitPos[3];
	iGetRayHitPos(pos, angle, flHitPos, entity);
	return GetVectorDistance(pos, flHitPos);
}

int iGetRandomTarget(float pos[3], float angle[3])
{
	float flMin = 4.0;
	float flPos[3];
	float flAngle;
	int iTarget;
	for (int iSurvivor = 1; iSurvivor <= MaxClients; iSurvivor++)
	{
		if (bIsSurvivor(iSurvivor))
		{
			GetClientEyePosition(iSurvivor, flPos);
			MakeVectorFromPoints(pos, flPos, flPos);
			flAngle = flGetAngle(angle, flPos);
			if (flAngle <= flMin)
			{
				flMin = flAngle;
				iTarget = iSurvivor;
			}
		}
	}
	return iTarget;
}

int iGetRGBColor(int red, int green, int blue) 
{
	return (blue * 65536) + (green * 256) + red;
}

int iGetRayHitPos(float pos[3], float angle[3], float hitpos[3], int entity = 0, bool offset = false)
{
	int iHit = 0;
	Handle hTrace = TR_TraceRayFilterEx(pos, angle, MASK_SOLID, RayType_Infinite, bTraceRayDontHitSelfAndSurvivor, entity);
	if (TR_DidHit(hTrace))
	{
		TR_GetEndPosition(hitpos, hTrace);
		iHit = TR_GetEntityIndex(hTrace);
	}
	delete hTrace;
	if (offset)
	{
		float flVector[3];
		MakeVectorFromPoints(hitpos, pos, flVector);
		NormalizeVector(flVector, flVector);
		ScaleVector(flVector, 15.0);
		AddVectors(hitpos, flVector, hitpos);
	}
	return iHit;
}

bool bIsValidClient(int client)
{
	return client > 0 && client <= MaxClients && IsClientInGame(client) && !IsClientInKickQueue(client);
}

bool bIsValidEntity(int entity)
{
	return entity > 0 && entity <= 2048 && IsValidEntity(entity);
}

public bool bTraceRayDontHitSelfAndPlayer(int entity, int mask, any data)
{
	if (entity == data || bIsValidClient(entity))
	{
		return false;
	}
	return true;
}

public bool bTraceRayDontHitSelfAndSurvivor(int entity, int mask, any data)
{
	if (entity == data || bIsSurvivor(entity))
	{
		return false;
	}
	return true;
}

bool bVisiblePosition(float pos1[3], float pos2[3], int entity, int flag)
{
	Handle hTrace;
	switch (flag)
	{
		case 1: hTrace = TR_TraceRayFilterEx(pos2, pos1, MASK_SOLID, RayType_EndPoint, bTraceRayDontHitSelfAndSurvivor, entity);
		case 2: hTrace = TR_TraceRayFilterEx(pos2, pos1, MASK_SOLID, RayType_EndPoint, bTraceRayDontHitSelfAndPlayer, entity);
	}
	if (TR_DidHit(hTrace))
	{
		return false;
	}
	delete hTrace;
	return true;
}

public Action tTimerTrack(Handle timer, DataPack pack)
{
	pack.Reset();
	int iTank = GetClientOfUserId(pack.ReadCell());
	int iRock = EntRefToEntIndex(pack.ReadCell());
	int iTrackAbility = !g_bTankConfig[ST_TankType(iTank)] ? g_iTrackAbility[ST_TankType(iTank)] : g_iTrackAbility2[ST_TankType(iTank)];
	if (iTrackAbility == 0 || iTank == 0 || !IsClientInGame(iTank) || !IsPlayerAlive(iTank) || iRock == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}
	if (bIsTank(iTank))
	{
		if (bIsValidEntity(iRock))
		{
			SDKUnhook(iRock, SDKHook_Think, Think);
			SDKHook(iRock, SDKHook_Think, Think);
		}
	}
	return Plugin_Continue;
}