/**
 * Mutant Tanks: a L4D/L4D2 SourceMod Plugin
 * Copyright (C) 2021  Alfred "Crasher_3637/Psyk0tik" Llagas
 *
 * This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **/

#if !defined MT_ABILITIES_MAIN
#error This plugin must be inside "scripting/mutant_tanks/abilities" while compiling "mt_abilities.sp" to include its content.
#endif

#define SOUND_METAL "physics/metal/metal_solid_impact_hard5.wav"

#define MT_GOD_SECTION "godability"
#define MT_GOD_SECTION2 "god ability"
#define MT_GOD_SECTION3 "god_ability"
#define MT_GOD_SECTION4 "god"
#define MT_GOD_SECTIONS MT_GOD_SECTION, MT_GOD_SECTION2, MT_GOD_SECTION3, MT_GOD_SECTION4

#define MT_MENU_GOD "God Ability"

enum struct esGodPlayer
{
	bool g_bActivated;

	float g_flGodChance;
	float g_flOpenAreasOnly;

	int g_iAccessFlags;
	int g_iAmmoCount;
	int g_iComboAbility;
	int g_iCooldown;
	int g_iDuration;
	int g_iGodAbility;
	int g_iGodDuration;
	int g_iGodMessage;
	int g_iHumanAbility;
	int g_iHumanAmmo;
	int g_iHumanCooldown;
	int g_iHumanMode;
	int g_iImmunityFlags;
	int g_iRequiresHumans;
	int g_iTankType;
}

esGodPlayer g_esGodPlayer[MAXPLAYERS + 1];

enum struct esGodAbility
{
	float g_flGodChance;
	float g_flOpenAreasOnly;

	int g_iAccessFlags;
	int g_iComboAbility;
	int g_iGodAbility;
	int g_iGodDuration;
	int g_iGodMessage;
	int g_iHumanAbility;
	int g_iHumanAmmo;
	int g_iHumanCooldown;
	int g_iHumanMode;
	int g_iImmunityFlags;
	int g_iRequiresHumans;
}

esGodAbility g_esGodAbility[MT_MAXTYPES + 1];

enum struct esGodCache
{
	float g_flGodChance;
	float g_flOpenAreasOnly;

	int g_iComboAbility;
	int g_iGodAbility;
	int g_iGodDuration;
	int g_iGodMessage;
	int g_iHumanAbility;
	int g_iHumanAmmo;
	int g_iHumanCooldown;
	int g_iHumanMode;
	int g_iRequiresHumans;
}

esGodCache g_esGodCache[MAXPLAYERS + 1];

void vGodMapStart()
{
	vGodReset();
}

void vGodClientPutInServer(int client)
{
	SDKHook(client, SDKHook_OnTakeDamage, OnGodTakeDamage);
	vRemoveGod(client);
}

void vGodClientDisconnect_Post(int client)
{
	vRemoveGod(client);
}

void vGodMapEnd()
{
	vGodReset();
}

void vGodMenu(int client, const char[] name, int item)
{
	if (StrContains(MT_GOD_SECTION4, name, false) == -1)
	{
		return;
	}

	Menu mAbilityMenu = new Menu(iGodMenuHandler, MENU_ACTIONS_DEFAULT|MenuAction_Display|MenuAction_DisplayItem);
	mAbilityMenu.SetTitle("God Ability Information");
	mAbilityMenu.AddItem("Status", "Status");
	mAbilityMenu.AddItem("Ammunition", "Ammunition");
	mAbilityMenu.AddItem("Buttons", "Buttons");
	mAbilityMenu.AddItem("Button Mode", "Button Mode");
	mAbilityMenu.AddItem("Cooldown", "Cooldown");
	mAbilityMenu.AddItem("Details", "Details");
	mAbilityMenu.AddItem("Duration", "Duration");
	mAbilityMenu.AddItem("Human Support", "Human Support");
	mAbilityMenu.DisplayAt(client, item, MENU_TIME_FOREVER);
}

public int iGodMenuHandler(Menu menu, MenuAction action, int param1, int param2)
{
	switch (action)
	{
		case MenuAction_End: delete menu;
		case MenuAction_Select:
		{
			switch (param2)
			{
				case 0: MT_PrintToChat(param1, "%s %t", MT_TAG3, g_esGodCache[param1].g_iGodAbility == 0 ? "AbilityStatus1" : "AbilityStatus2");
				case 1: MT_PrintToChat(param1, "%s %t", MT_TAG3, "AbilityAmmo", g_esGodCache[param1].g_iHumanAmmo - g_esGodPlayer[param1].g_iAmmoCount, g_esGodCache[param1].g_iHumanAmmo);
				case 2: MT_PrintToChat(param1, "%s %t", MT_TAG3, "AbilityButtons");
				case 3: MT_PrintToChat(param1, "%s %t", MT_TAG3, g_esGodCache[param1].g_iHumanMode == 0 ? "AbilityButtonMode1" : "AbilityButtonMode2");
				case 4: MT_PrintToChat(param1, "%s %t", MT_TAG3, "AbilityCooldown", g_esGodCache[param1].g_iHumanCooldown);
				case 5: MT_PrintToChat(param1, "%s %t", MT_TAG3, "GodDetails");
				case 6: MT_PrintToChat(param1, "%s %t", MT_TAG3, "AbilityDuration2", g_esGodCache[param1].g_iGodDuration);
				case 7: MT_PrintToChat(param1, "%s %t", MT_TAG3, g_esGodCache[param1].g_iHumanAbility == 0 ? "AbilityHumanSupport1" : "AbilityHumanSupport2");
			}

			if (bIsValidClient(param1, MT_CHECK_INGAME))
			{
				vGodMenu(param1, MT_GOD_SECTION4, menu.Selection);
			}
		}
		case MenuAction_Display:
		{
			char sMenuTitle[PLATFORM_MAX_PATH];
			Panel pGod = view_as<Panel>(param2);
			FormatEx(sMenuTitle, sizeof(sMenuTitle), "%T", "GodMenu", param1);
			pGod.SetTitle(sMenuTitle);
		}
		case MenuAction_DisplayItem:
		{
			if (param2 >= 0)
			{
				char sMenuOption[PLATFORM_MAX_PATH];

				switch (param2)
				{
					case 0: FormatEx(sMenuOption, sizeof(sMenuOption), "%T", "Status", param1);
					case 1: FormatEx(sMenuOption, sizeof(sMenuOption), "%T", "Ammunition", param1);
					case 2: FormatEx(sMenuOption, sizeof(sMenuOption), "%T", "Buttons", param1);
					case 3: FormatEx(sMenuOption, sizeof(sMenuOption), "%T", "ButtonMode", param1);
					case 4: FormatEx(sMenuOption, sizeof(sMenuOption), "%T", "Cooldown", param1);
					case 5: FormatEx(sMenuOption, sizeof(sMenuOption), "%T", "Details", param1);
					case 6: FormatEx(sMenuOption, sizeof(sMenuOption), "%T", "Duration", param1);
					case 7: FormatEx(sMenuOption, sizeof(sMenuOption), "%T", "HumanSupport", param1);
				}

				return RedrawMenuItem(sMenuOption);
			}
		}
	}

	return 0;
}

void vGodDisplayMenu(Menu menu)
{
	menu.AddItem(MT_MENU_GOD, MT_MENU_GOD);
}

void vGodMenuItemSelected(int client, const char[] info)
{
	if (StrEqual(info, MT_MENU_GOD, false))
	{
		vGodMenu(client, MT_GOD_SECTION4, 0);
	}
}

void vGodMenuItemDisplayed(int client, const char[] info, char[] buffer, int size)
{
	if (StrEqual(info, MT_MENU_GOD, false))
	{
		FormatEx(buffer, size, "%T", "GodMenu2", client);
	}
}

void vGodPlayerRunCmd(int client)
{
	if (!MT_IsTankSupported(client) || !g_esGodPlayer[client].g_bActivated || (bIsTank(client, MT_CHECK_FAKECLIENT) && g_esGodCache[client].g_iHumanMode == 1) || g_esGodPlayer[client].g_iDuration == -1)
	{
		return;
	}

	static int iTime;
	iTime = GetTime();
	if (g_esGodPlayer[client].g_iDuration < iTime)
	{
		if (bIsTank(client, MT_CHECK_FAKECLIENT) && (MT_HasAdminAccess(client) || bHasAdminAccess(client, g_esGodAbility[g_esGodPlayer[client].g_iTankType].g_iAccessFlags, g_esGodPlayer[client].g_iAccessFlags)) && g_esGodCache[client].g_iHumanAbility == 1 && (g_esGodPlayer[client].g_iCooldown == -1 || g_esGodPlayer[client].g_iCooldown < GetTime()))
		{
			vGodReset3(client);
		}

		vGodReset2(client);
	}
}

public Action OnGodTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype)
{
	if (MT_IsCorePluginEnabled() && bIsValidClient(victim, MT_CHECK_INDEX|MT_CHECK_INGAME|MT_CHECK_ALIVE) && damage > 0.0)
	{
		if (MT_IsTankSupported(victim) && MT_IsCustomTankSupported(victim) && g_esGodPlayer[victim].g_bActivated)
		{
			static bool bSurvivor;
			bSurvivor = bIsSurvivor(attacker);
			if ((!MT_HasAdminAccess(victim) && !bHasAdminAccess(victim, g_esGodAbility[g_esGodPlayer[victim].g_iTankType].g_iAccessFlags, g_esGodPlayer[victim].g_iAccessFlags)) || (bSurvivor && (MT_IsAdminImmune(attacker, victim) || bIsAdminImmune(attacker, g_esGodPlayer[victim].g_iTankType, g_esGodAbility[g_esGodPlayer[victim].g_iTankType].g_iImmunityFlags, g_esGodPlayer[attacker].g_iImmunityFlags))))
			{
				return Plugin_Continue;
			}

			EmitSoundToAll(SOUND_METAL, victim);

			if ((damagetype & DMG_BURN) || (damagetype & DMG_DIRECT))
			{
				ExtinguishEntity(victim);
			}

			if ((damagetype & DMG_SLASH) || (damagetype & DMG_CLUB))
			{
				static float flTankPos[3];
				GetClientAbsOrigin(victim, flTankPos);

				switch (bSurvivor && MT_DoesSurvivorHaveRewardType(attacker, MT_REWARD_GODMODE))
				{
					case true: vPushNearbyEntities(victim, flTankPos, 300.0, 100.0);
					case false: vPushNearbyEntities(victim, flTankPos);
				}
			}

			return Plugin_Handled;
		}
	}

	return Plugin_Continue;
}

void vGodPluginCheck(ArrayList &list)
{
	list.PushString(MT_MENU_GOD);
}

void vGodAbilityCheck(ArrayList &list, ArrayList &list2, ArrayList &list3, ArrayList &list4)
{
	list.PushString(MT_GOD_SECTION);
	list2.PushString(MT_GOD_SECTION2);
	list3.PushString(MT_GOD_SECTION3);
	list4.PushString(MT_GOD_SECTION4);
}

void vGodCombineAbilities(int tank, int type, const float random, const char[] combo)
{
	if (bIsTank(tank, MT_CHECK_FAKECLIENT) && g_esGodCache[tank].g_iHumanAbility != 2)
	{
		return;
	}

	static char sAbilities[320], sSet[4][32];
	FormatEx(sAbilities, sizeof(sAbilities), ",%s,", combo);
	FormatEx(sSet[0], sizeof(sSet[]), ",%s,", MT_GOD_SECTION);
	FormatEx(sSet[1], sizeof(sSet[]), ",%s,", MT_GOD_SECTION2);
	FormatEx(sSet[2], sizeof(sSet[]), ",%s,", MT_GOD_SECTION3);
	FormatEx(sSet[3], sizeof(sSet[]), ",%s,", MT_GOD_SECTION4);
	if (StrContains(sAbilities, sSet[0], false) != -1 || StrContains(sAbilities, sSet[1], false) != -1 || StrContains(sAbilities, sSet[2], false) != -1 || StrContains(sAbilities, sSet[3], false) != -1)
	{
		if (type == MT_COMBO_MAINRANGE && g_esGodCache[tank].g_iGodAbility == 1 && g_esGodCache[tank].g_iComboAbility == 1 && !g_esGodPlayer[tank].g_bActivated)
		{
			static char sSubset[10][32];
			ExplodeString(combo, ",", sSubset, sizeof(sSubset), sizeof(sSubset[]));
			for (int iPos = 0; iPos < sizeof(sSubset); iPos++)
			{
				if (StrEqual(sSubset[iPos], MT_GOD_SECTION, false) || StrEqual(sSubset[iPos], MT_GOD_SECTION2, false) || StrEqual(sSubset[iPos], MT_GOD_SECTION3, false) || StrEqual(sSubset[iPos], MT_GOD_SECTION4, false))
				{
					if (random <= MT_GetCombinationSetting(tank, 1, iPos))
					{
						static float flDelay;
						flDelay = MT_GetCombinationSetting(tank, 3, iPos);

						switch (flDelay)
						{
							case 0.0: vGod(tank, iPos);
							default:
							{
								DataPack dpCombo;
								CreateDataTimer(flDelay, tTimerGodCombo, dpCombo, TIMER_FLAG_NO_MAPCHANGE);
								dpCombo.WriteCell(GetClientUserId(tank));
								dpCombo.WriteCell(iPos);
							}
						}
					}

					break;
				}
			}
		}
	}
}

void vGodConfigsLoad(int mode)
{
	switch (mode)
	{
		case 1:
		{
			for (int iIndex = MT_GetMinType(); iIndex <= MT_GetMaxType(); iIndex++)
			{
				g_esGodAbility[iIndex].g_iAccessFlags = 0;
				g_esGodAbility[iIndex].g_iImmunityFlags = 0;
				g_esGodAbility[iIndex].g_iComboAbility = 0;
				g_esGodAbility[iIndex].g_iHumanAbility = 0;
				g_esGodAbility[iIndex].g_iHumanAmmo = 5;
				g_esGodAbility[iIndex].g_iHumanCooldown = 30;
				g_esGodAbility[iIndex].g_iHumanMode = 1;
				g_esGodAbility[iIndex].g_flOpenAreasOnly = 0.0;
				g_esGodAbility[iIndex].g_iRequiresHumans = 1;
				g_esGodAbility[iIndex].g_iGodAbility = 0;
				g_esGodAbility[iIndex].g_iGodMessage = 0;
				g_esGodAbility[iIndex].g_flGodChance = 33.3;
				g_esGodAbility[iIndex].g_iGodDuration = 5;
			}
		}
		case 3:
		{
			for (int iPlayer = 1; iPlayer <= MaxClients; iPlayer++)
			{
				if (bIsValidClient(iPlayer))
				{
					g_esGodPlayer[iPlayer].g_iAccessFlags = 0;
					g_esGodPlayer[iPlayer].g_iImmunityFlags = 0;
					g_esGodPlayer[iPlayer].g_iComboAbility = 0;
					g_esGodPlayer[iPlayer].g_iHumanAbility = 0;
					g_esGodPlayer[iPlayer].g_iHumanAmmo = 0;
					g_esGodPlayer[iPlayer].g_iHumanCooldown = 0;
					g_esGodPlayer[iPlayer].g_iHumanMode = 0;
					g_esGodPlayer[iPlayer].g_flOpenAreasOnly = 0.0;
					g_esGodPlayer[iPlayer].g_iRequiresHumans = 0;
					g_esGodPlayer[iPlayer].g_iGodAbility = 0;
					g_esGodPlayer[iPlayer].g_iGodMessage = 0;
					g_esGodPlayer[iPlayer].g_flGodChance = 0.0;
					g_esGodPlayer[iPlayer].g_iGodDuration = 0;
				}
			}
		}
	}
}

void vGodConfigsLoaded(const char[] subsection, const char[] key, const char[] value, int type, int admin, int mode)
{
	if (mode == 3 && bIsValidClient(admin))
	{
		g_esGodPlayer[admin].g_iComboAbility = iGetKeyValue(subsection, MT_GOD_SECTIONS, key, "ComboAbility", "Combo Ability", "Combo_Ability", "combo", g_esGodPlayer[admin].g_iComboAbility, value, 0, 1);
		g_esGodPlayer[admin].g_iHumanAbility = iGetKeyValue(subsection, MT_GOD_SECTIONS, key, "HumanAbility", "Human Ability", "Human_Ability", "human", g_esGodPlayer[admin].g_iHumanAbility, value, 0, 2);
		g_esGodPlayer[admin].g_iHumanAmmo = iGetKeyValue(subsection, MT_GOD_SECTIONS, key, "HumanAmmo", "Human Ammo", "Human_Ammo", "hammo", g_esGodPlayer[admin].g_iHumanAmmo, value, 0, 999999);
		g_esGodPlayer[admin].g_iHumanCooldown = iGetKeyValue(subsection, MT_GOD_SECTIONS, key, "HumanCooldown", "Human Cooldown", "Human_Cooldown", "hcooldown", g_esGodPlayer[admin].g_iHumanCooldown, value, 0, 999999);
		g_esGodPlayer[admin].g_iHumanMode = iGetKeyValue(subsection, MT_GOD_SECTIONS, key, "HumanMode", "Human Mode", "Human_Mode", "hmode", g_esGodPlayer[admin].g_iHumanMode, value, 0, 1);
		g_esGodPlayer[admin].g_flOpenAreasOnly = flGetKeyValue(subsection, MT_GOD_SECTIONS, key, "OpenAreasOnly", "Open Areas Only", "Open_Areas_Only", "openareas", g_esGodPlayer[admin].g_flOpenAreasOnly, value, 0.0, 999999.0);
		g_esGodPlayer[admin].g_iRequiresHumans = iGetKeyValue(subsection, MT_GOD_SECTIONS, key, "RequiresHumans", "Requires Humans", "Requires_Humans", "hrequire", g_esGodPlayer[admin].g_iRequiresHumans, value, 0, 32);
		g_esGodPlayer[admin].g_iGodAbility = iGetKeyValue(subsection, MT_GOD_SECTIONS, key, "AbilityEnabled", "Ability Enabled", "Ability_Enabled", "aenabled", g_esGodPlayer[admin].g_iGodAbility, value, 0, 1);
		g_esGodPlayer[admin].g_iGodMessage = iGetKeyValue(subsection, MT_GOD_SECTIONS, key, "AbilityMessage", "Ability Message", "Ability_Message", "message", g_esGodPlayer[admin].g_iGodMessage, value, 0, 1);
		g_esGodPlayer[admin].g_flGodChance = flGetKeyValue(subsection, MT_GOD_SECTIONS, key, "GodChance", "God Chance", "God_Chance", "chance", g_esGodPlayer[admin].g_flGodChance, value, 0.0, 100.0);
		g_esGodPlayer[admin].g_iGodDuration = iGetKeyValue(subsection, MT_GOD_SECTIONS, key, "GodDuration", "God Duration", "God_Duration", "duration", g_esGodPlayer[admin].g_iGodDuration, value, 1, 999999);

		if (StrEqual(subsection, MT_GOD_SECTION, false) || StrEqual(subsection, MT_GOD_SECTION2, false) || StrEqual(subsection, MT_GOD_SECTION3, false) || StrEqual(subsection, MT_GOD_SECTION4, false))
		{
			if (StrEqual(key, "AccessFlags", false) || StrEqual(key, "Access Flags", false) || StrEqual(key, "Access_Flags", false) || StrEqual(key, "access", false))
			{
				g_esGodPlayer[admin].g_iAccessFlags = ReadFlagString(value);
			}
			else if (StrEqual(key, "ImmunityFlags", false) || StrEqual(key, "Immunity Flags", false) || StrEqual(key, "Immunity_Flags", false) || StrEqual(key, "immunity", false))
			{
				g_esGodPlayer[admin].g_iImmunityFlags = ReadFlagString(value);
			}
		}
	}

	if (mode < 3 && type > 0)
	{
		g_esGodAbility[type].g_iComboAbility = iGetKeyValue(subsection, MT_GOD_SECTIONS, key, "ComboAbility", "Combo Ability", "Combo_Ability", "combo", g_esGodAbility[type].g_iComboAbility, value, 0, 1);
		g_esGodAbility[type].g_iHumanAbility = iGetKeyValue(subsection, MT_GOD_SECTIONS, key, "HumanAbility", "Human Ability", "Human_Ability", "human", g_esGodAbility[type].g_iHumanAbility, value, 0, 2);
		g_esGodAbility[type].g_iHumanAmmo = iGetKeyValue(subsection, MT_GOD_SECTIONS, key, "HumanAmmo", "Human Ammo", "Human_Ammo", "hammo", g_esGodAbility[type].g_iHumanAmmo, value, 0, 999999);
		g_esGodAbility[type].g_iHumanCooldown = iGetKeyValue(subsection, MT_GOD_SECTIONS, key, "HumanCooldown", "Human Cooldown", "Human_Cooldown", "hcooldown", g_esGodAbility[type].g_iHumanCooldown, value, 0, 999999);
		g_esGodAbility[type].g_iHumanMode = iGetKeyValue(subsection, MT_GOD_SECTIONS, key, "HumanMode", "Human Mode", "Human_Mode", "hmode", g_esGodAbility[type].g_iHumanMode, value, 0, 1);
		g_esGodAbility[type].g_flOpenAreasOnly = flGetKeyValue(subsection, MT_GOD_SECTIONS, key, "OpenAreasOnly", "Open Areas Only", "Open_Areas_Only", "openareas", g_esGodAbility[type].g_flOpenAreasOnly, value, 0.0, 999999.0);
		g_esGodAbility[type].g_iRequiresHumans = iGetKeyValue(subsection, MT_GOD_SECTIONS, key, "RequiresHumans", "Requires Humans", "Requires_Humans", "hrequire", g_esGodAbility[type].g_iRequiresHumans, value, 0, 32);
		g_esGodAbility[type].g_iGodAbility = iGetKeyValue(subsection, MT_GOD_SECTIONS, key, "AbilityEnabled", "Ability Enabled", "Ability_Enabled", "aenabled", g_esGodAbility[type].g_iGodAbility, value, 0, 1);
		g_esGodAbility[type].g_iGodMessage = iGetKeyValue(subsection, MT_GOD_SECTIONS, key, "AbilityMessage", "Ability Message", "Ability_Message", "message", g_esGodAbility[type].g_iGodMessage, value, 0, 1);
		g_esGodAbility[type].g_flGodChance = flGetKeyValue(subsection, MT_GOD_SECTIONS, key, "GodChance", "God Chance", "God_Chance", "chance", g_esGodAbility[type].g_flGodChance, value, 0.0, 100.0);
		g_esGodAbility[type].g_iGodDuration = iGetKeyValue(subsection, MT_GOD_SECTIONS, key, "GodDuration", "God Duration", "God_Duration", "duration", g_esGodAbility[type].g_iGodDuration, value, 1, 999999);

		if (StrEqual(subsection, MT_GOD_SECTION, false) || StrEqual(subsection, MT_GOD_SECTION2, false) || StrEqual(subsection, MT_GOD_SECTION3, false) || StrEqual(subsection, MT_GOD_SECTION4, false))
		{
			if (StrEqual(key, "AccessFlags", false) || StrEqual(key, "Access Flags", false) || StrEqual(key, "Access_Flags", false) || StrEqual(key, "access", false))
			{
				g_esGodAbility[type].g_iAccessFlags = ReadFlagString(value);
			}
			else if (StrEqual(key, "ImmunityFlags", false) || StrEqual(key, "Immunity Flags", false) || StrEqual(key, "Immunity_Flags", false) || StrEqual(key, "immunity", false))
			{
				g_esGodAbility[type].g_iImmunityFlags = ReadFlagString(value);
			}
		}
	}
}

void vGodSettingsCached(int tank, bool apply, int type)
{
	bool bHuman = bIsTank(tank, MT_CHECK_FAKECLIENT);
	g_esGodCache[tank].g_iComboAbility = iGetSettingValue(apply, bHuman, g_esGodPlayer[tank].g_iComboAbility, g_esGodAbility[type].g_iComboAbility);
	g_esGodCache[tank].g_flGodChance = flGetSettingValue(apply, bHuman, g_esGodPlayer[tank].g_flGodChance, g_esGodAbility[type].g_flGodChance);
	g_esGodCache[tank].g_iGodAbility = iGetSettingValue(apply, bHuman, g_esGodPlayer[tank].g_iGodAbility, g_esGodAbility[type].g_iGodAbility);
	g_esGodCache[tank].g_iGodDuration = iGetSettingValue(apply, bHuman, g_esGodPlayer[tank].g_iGodDuration, g_esGodAbility[type].g_iGodDuration);
	g_esGodCache[tank].g_iGodMessage = iGetSettingValue(apply, bHuman, g_esGodPlayer[tank].g_iGodMessage, g_esGodAbility[type].g_iGodMessage);
	g_esGodCache[tank].g_iHumanAbility = iGetSettingValue(apply, bHuman, g_esGodPlayer[tank].g_iHumanAbility, g_esGodAbility[type].g_iHumanAbility);
	g_esGodCache[tank].g_iHumanAmmo = iGetSettingValue(apply, bHuman, g_esGodPlayer[tank].g_iHumanAmmo, g_esGodAbility[type].g_iHumanAmmo);
	g_esGodCache[tank].g_iHumanCooldown = iGetSettingValue(apply, bHuman, g_esGodPlayer[tank].g_iHumanCooldown, g_esGodAbility[type].g_iHumanCooldown);
	g_esGodCache[tank].g_iHumanMode = iGetSettingValue(apply, bHuman, g_esGodPlayer[tank].g_iHumanMode, g_esGodAbility[type].g_iHumanMode);
	g_esGodCache[tank].g_flOpenAreasOnly = flGetSettingValue(apply, bHuman, g_esGodPlayer[tank].g_flOpenAreasOnly, g_esGodAbility[type].g_flOpenAreasOnly);
	g_esGodCache[tank].g_iRequiresHumans = iGetSettingValue(apply, bHuman, g_esGodPlayer[tank].g_iRequiresHumans, g_esGodAbility[type].g_iRequiresHumans);
	g_esGodPlayer[tank].g_iTankType = apply ? type : 0;
}

void vGodCopyStats(int oldTank, int newTank)
{
	vGodCopyStats2(oldTank, newTank);

	if (oldTank != newTank)
	{
		vRemoveGod(oldTank);
	}
}

void vGodEventFired(Event event, const char[] name)
{
	if (StrEqual(name, "bot_player_replace"))
	{
		int iBotId = event.GetInt("bot"), iBot = GetClientOfUserId(iBotId),
			iTankId = event.GetInt("player"), iTank = GetClientOfUserId(iTankId);
		if (bIsValidClient(iBot) && bIsTank(iTank))
		{
			vGodCopyStats2(iBot, iTank);
			vRemoveGod(iBot);
		}
	}
	else if (StrEqual(name, "player_bot_replace"))
	{
		int iTankId = event.GetInt("player"), iTank = GetClientOfUserId(iTankId),
			iBotId = event.GetInt("bot"), iBot = GetClientOfUserId(iBotId);
		if (bIsValidClient(iTank) && bIsTank(iBot))
		{
			vGodCopyStats2(iTank, iBot);
			vRemoveGod(iTank);
		}
	}
	else if (StrEqual(name, "player_incapacitated") || StrEqual(name, "player_death") || StrEqual(name, "player_spawn"))
	{
		int iTankId = event.GetInt("userid"), iTank = GetClientOfUserId(iTankId);
		if (MT_IsTankSupported(iTank, MT_CHECK_INDEX|MT_CHECK_INGAME))
		{
			vRemoveGod(iTank);
		}
	}
	else if (StrEqual(name, "mission_lost") || StrEqual(name, "round_start") || StrEqual(name, "round_end"))
	{
		vGodReset();
	}
}

Action aGodPlayerHitByVomitJar(int player, int thrower)
{
	if (MT_IsTankSupported(player) && g_esGodPlayer[player].g_bActivated && bIsSurvivor(thrower, MT_CHECK_INDEX|MT_CHECK_INGAME) && !MT_DoesSurvivorHaveRewardType(thrower, MT_REWARD_DAMAGEBOOST))
	{
		return Plugin_Handled;
	}

	return Plugin_Continue;
}

Action aGodPlayerShovedBySurvivor(int player, int survivor)
{
	if (MT_IsTankSupported(player) && g_esGodPlayer[player].g_bActivated && bIsSurvivor(survivor, MT_CHECK_INDEX|MT_CHECK_INGAME))
	{
		return Plugin_Handled;
	}

	return Plugin_Continue;
}

void vGodAbilityActivated(int tank)
{
	if (MT_IsTankSupported(tank, MT_CHECK_INDEX|MT_CHECK_INGAME|MT_CHECK_FAKECLIENT) && ((!MT_HasAdminAccess(tank) && !bHasAdminAccess(tank, g_esGodAbility[g_esGodPlayer[tank].g_iTankType].g_iAccessFlags, g_esGodPlayer[tank].g_iAccessFlags)) || g_esGodCache[tank].g_iHumanAbility == 0))
	{
		return;
	}

	if (MT_IsTankSupported(tank) && (!bIsTank(tank, MT_CHECK_FAKECLIENT) || g_esGodCache[tank].g_iHumanAbility != 1) && MT_IsCustomTankSupported(tank) && g_esGodCache[tank].g_iGodAbility == 1 && g_esGodCache[tank].g_iComboAbility == 0 && !g_esGodPlayer[tank].g_bActivated)
	{
		vGodAbility(tank);
	}
}

void vGodButtonPressed(int tank, int button)
{
	if (MT_IsTankSupported(tank, MT_CHECK_INDEX|MT_CHECK_INGAME|MT_CHECK_ALIVE|MT_CHECK_FAKECLIENT) && MT_IsCustomTankSupported(tank))
	{
		if (bIsAreaNarrow(tank, g_esGodCache[tank].g_flOpenAreasOnly) || MT_DoesTypeRequireHumans(g_esGodPlayer[tank].g_iTankType) || (g_esGodCache[tank].g_iRequiresHumans > 0 && iGetHumanCount() < g_esGodCache[tank].g_iRequiresHumans) || (!MT_HasAdminAccess(tank) && !bHasAdminAccess(tank, g_esGodAbility[g_esGodPlayer[tank].g_iTankType].g_iAccessFlags, g_esGodPlayer[tank].g_iAccessFlags)))
		{
			return;
		}

		if (button & MT_MAIN_KEY)
		{
			if (g_esGodCache[tank].g_iGodAbility == 1 && g_esGodCache[tank].g_iHumanAbility == 1)
			{
				static int iTime;
				iTime = GetTime();
				static bool bRecharging;
				bRecharging = g_esGodPlayer[tank].g_iCooldown != -1 && g_esGodPlayer[tank].g_iCooldown > iTime;

				switch (g_esGodCache[tank].g_iHumanMode)
				{
					case 0:
					{
						if (!g_esGodPlayer[tank].g_bActivated && !bRecharging)
						{
							vGodAbility(tank);
						}
						else if (g_esGodPlayer[tank].g_bActivated)
						{
							MT_PrintToChat(tank, "%s %t", MT_TAG3, "GodHuman3");
						}
						else if (bRecharging)
						{
							MT_PrintToChat(tank, "%s %t", MT_TAG3, "GodHuman4", g_esGodPlayer[tank].g_iCooldown - iTime);
						}
					}
					case 1:
					{
						if (g_esGodPlayer[tank].g_iAmmoCount < g_esGodCache[tank].g_iHumanAmmo && g_esGodCache[tank].g_iHumanAmmo > 0)
						{
							if (!g_esGodPlayer[tank].g_bActivated && !bRecharging)
							{
								g_esGodPlayer[tank].g_bActivated = true;
								g_esGodPlayer[tank].g_iAmmoCount++;

								MT_PrintToChat(tank, "%s %t", MT_TAG3, "GodHuman", g_esGodPlayer[tank].g_iAmmoCount, g_esGodCache[tank].g_iHumanAmmo);
							}
							else if (g_esGodPlayer[tank].g_bActivated)
							{
								MT_PrintToChat(tank, "%s %t", MT_TAG3, "GodHuman3");
							}
							else if (bRecharging)
							{
								MT_PrintToChat(tank, "%s %t", MT_TAG3, "GodHuman4", g_esGodPlayer[tank].g_iCooldown - iTime);
							}
						}
						else
						{
							MT_PrintToChat(tank, "%s %t", MT_TAG3, "GodAmmo");
						}
					}
				}
			}
		}
	}
}

void vGodButtonReleased(int tank, int button)
{
	if (MT_IsTankSupported(tank, MT_CHECK_INDEX|MT_CHECK_INGAME|MT_CHECK_ALIVE|MT_CHECK_FAKECLIENT) && g_esGodCache[tank].g_iHumanAbility == 1)
	{
		if (button & MT_MAIN_KEY)
		{
			if (g_esGodCache[tank].g_iHumanMode == 1 && g_esGodPlayer[tank].g_bActivated && (g_esGodPlayer[tank].g_iCooldown == -1 || g_esGodPlayer[tank].g_iCooldown < GetTime()))
			{
				vGodReset2(tank);
				vGodReset3(tank);
			}
		}
	}
}

void vGodChangeType(int tank)
{
	vRemoveGod(tank);
}

void vGodCopyStats2(int oldTank, int newTank)
{
	g_esGodPlayer[newTank].g_iAmmoCount = g_esGodPlayer[oldTank].g_iAmmoCount;
	g_esGodPlayer[newTank].g_iCooldown = g_esGodPlayer[oldTank].g_iCooldown;
}

void vGod(int tank, int pos = -1)
{
	static int iDuration;
	iDuration = (pos != -1) ? RoundToNearest(MT_GetCombinationSetting(tank, 4, pos)) : g_esGodCache[tank].g_iGodDuration;
	g_esGodPlayer[tank].g_bActivated = true;
	g_esGodPlayer[tank].g_iDuration = GetTime() + iDuration;

	MT_UnvomitPlayer(tank);

	if (bIsTank(tank, MT_CHECK_FAKECLIENT) && g_esGodCache[tank].g_iHumanAbility == 1)
	{
		g_esGodPlayer[tank].g_iAmmoCount++;

		MT_PrintToChat(tank, "%s %t", MT_TAG3, "GodHuman", g_esGodPlayer[tank].g_iAmmoCount, g_esGodCache[tank].g_iHumanAmmo);
	}

	if (g_esGodCache[tank].g_iGodMessage == 1)
	{
		static char sTankName[33];
		MT_GetTankName(tank, sTankName);
		MT_PrintToChatAll("%s %t", MT_TAG2, "God", sTankName);
		MT_LogMessage(MT_LOG_ABILITY, "%s %T", MT_TAG, "God", LANG_SERVER, sTankName);
	}
}

void vGodAbility(int tank)
{
	if (bIsAreaNarrow(tank, g_esGodCache[tank].g_flOpenAreasOnly) || MT_DoesTypeRequireHumans(g_esGodPlayer[tank].g_iTankType) || (g_esGodCache[tank].g_iRequiresHumans > 0 && iGetHumanCount() < g_esGodCache[tank].g_iRequiresHumans) || (!MT_HasAdminAccess(tank) && !bHasAdminAccess(tank, g_esGodAbility[g_esGodPlayer[tank].g_iTankType].g_iAccessFlags, g_esGodPlayer[tank].g_iAccessFlags)))
	{
		return;
	}

	if (!bIsTank(tank, MT_CHECK_FAKECLIENT) || (g_esGodPlayer[tank].g_iAmmoCount < g_esGodCache[tank].g_iHumanAmmo && g_esGodCache[tank].g_iHumanAmmo > 0))
	{
		if (GetRandomFloat(0.1, 100.0) <= g_esGodCache[tank].g_flGodChance)
		{
			vGod(tank);
		}
		else if (bIsTank(tank, MT_CHECK_FAKECLIENT) && g_esGodCache[tank].g_iHumanAbility == 1)
		{
			MT_PrintToChat(tank, "%s %t", MT_TAG3, "GodHuman2");
		}
	}
	else if (bIsTank(tank, MT_CHECK_FAKECLIENT) && g_esGodCache[tank].g_iHumanAbility == 1)
	{
		MT_PrintToChat(tank, "%s %t", MT_TAG3, "GodAmmo");
	}
}

void vRemoveGod(int tank)
{
	g_esGodPlayer[tank].g_bActivated = false;
	g_esGodPlayer[tank].g_iAmmoCount = 0;
	g_esGodPlayer[tank].g_iCooldown = -1;
	g_esGodPlayer[tank].g_iDuration = -1;
}

void vGodReset()
{
	for (int iPlayer = 1; iPlayer <= MaxClients; iPlayer++)
	{
		if (bIsValidClient(iPlayer, MT_CHECK_INGAME))
		{
			vRemoveGod(iPlayer);
		}
	}
}

void vGodReset2(int tank)
{
	g_esGodPlayer[tank].g_bActivated = false;
	g_esGodPlayer[tank].g_iDuration = -1;

	if (g_esGodCache[tank].g_iGodMessage == 1)
	{
		char sTankName[33];
		MT_GetTankName(tank, sTankName);
		MT_PrintToChatAll("%s %t", MT_TAG2, "God2", sTankName);
		MT_LogMessage(MT_LOG_ABILITY, "%s %T", MT_TAG, "God2", LANG_SERVER, sTankName);
	}
}

void vGodReset3(int tank)
{
	int iTime = GetTime();
	g_esGodPlayer[tank].g_iCooldown = (g_esGodPlayer[tank].g_iAmmoCount < g_esGodCache[tank].g_iHumanAmmo && g_esGodCache[tank].g_iHumanAmmo > 0) ? (iTime + g_esGodCache[tank].g_iHumanCooldown) : -1;
	if (g_esGodPlayer[tank].g_iCooldown != -1 && g_esGodPlayer[tank].g_iCooldown > iTime)
	{
		MT_PrintToChat(tank, "%s %t", MT_TAG3, "GodHuman5", g_esGodPlayer[tank].g_iCooldown - iTime);
	}
}

public Action tTimerGodCombo(Handle timer, DataPack pack)
{
	pack.Reset();

	int iTank = GetClientOfUserId(pack.ReadCell());
	if (!MT_IsCorePluginEnabled() || !MT_IsTankSupported(iTank) || (!MT_HasAdminAccess(iTank) && !bHasAdminAccess(iTank, g_esGodAbility[g_esGodPlayer[iTank].g_iTankType].g_iAccessFlags, g_esGodPlayer[iTank].g_iAccessFlags)) || !MT_IsTypeEnabled(g_esGodPlayer[iTank].g_iTankType) || !MT_IsCustomTankSupported(iTank) || g_esGodCache[iTank].g_iGodAbility == 0 || g_esGodPlayer[iTank].g_bActivated)
	{
		return Plugin_Stop;
	}

	int iPos = pack.ReadCell();
	vGod(iTank, iPos);

	return Plugin_Continue;
}