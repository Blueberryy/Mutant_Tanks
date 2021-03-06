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

#define MT_HIT_SECTION "hitability"
#define MT_HIT_SECTION2 "hit ability"
#define MT_HIT_SECTION3 "hit_ability"
#define MT_HIT_SECTION4 "hit"
#define MT_HIT_SECTIONS MT_HIT_SECTION, MT_HIT_SECTION2, MT_HIT_SECTION3, MT_HIT_SECTION4

#define MT_MENU_HIT "Hit Ability"

enum struct esHitPlayer
{

	float g_flHitDamageMultiplier;
	float g_flOpenAreasOnly;

	int g_iAccessFlags;
	int g_iHitAbility;
	int g_iHitGroup;
	int g_iHumanAbility;
	int g_iImmunityFlags;
	int g_iRequiresHumans;
	int g_iTankType;
}

esHitPlayer g_esHitPlayer[MAXPLAYERS + 1];

enum struct esHitAbility
{
	float g_flHitDamageMultiplier;
	float g_flOpenAreasOnly;

	int g_iAccessFlags;
	int g_iHitAbility;
	int g_iHitGroup;
	int g_iHumanAbility;
	int g_iImmunityFlags;
	int g_iRequiresHumans;
}

esHitAbility g_esHitAbility[MT_MAXTYPES + 1];

enum struct esHitCache
{
	float g_flHitDamageMultiplier;
	float g_flOpenAreasOnly;

	int g_iHitAbility;
	int g_iHitGroup;
	int g_iHumanAbility;
	int g_iRequiresHumans;
}

esHitCache g_esHitCache[MAXPLAYERS + 1];

void vHitClientPutInServer(int client)
{
	SDKHook(client, SDKHook_TraceAttack, HitTraceAttack);
}

void vHitMenu(int client, const char[] name, int item)
{
	if (StrContains(MT_HIT_SECTION4, name, false) == -1)
	{
		return;
	}

	Menu mAbilityMenu = new Menu(iHitMenuHandler, MENU_ACTIONS_DEFAULT|MenuAction_Display|MenuAction_DisplayItem);
	mAbilityMenu.SetTitle("Hit Ability Information");
	mAbilityMenu.AddItem("Status", "Status");
	mAbilityMenu.AddItem("Details", "Details");
	mAbilityMenu.AddItem("Human Support", "Human Support");
	mAbilityMenu.DisplayAt(client, item, MENU_TIME_FOREVER);
}

public int iHitMenuHandler(Menu menu, MenuAction action, int param1, int param2)
{
	switch (action)
	{
		case MenuAction_End: delete menu;
		case MenuAction_Select:
		{
			switch (param2)
			{
				case 0: MT_PrintToChat(param1, "%s %t", MT_TAG3, g_esHitCache[param1].g_iHitAbility == 0 ? "AbilityStatus1" : "AbilityStatus2");
				case 1: MT_PrintToChat(param1, "%s %t", MT_TAG3, "HitDetails");
				case 2: MT_PrintToChat(param1, "%s %t", MT_TAG3, g_esHitCache[param1].g_iHumanAbility == 0 ? "AbilityHumanSupport1" : "AbilityHumanSupport2");
			}

			if (bIsValidClient(param1, MT_CHECK_INGAME))
			{
				vHitMenu(param1, MT_HIT_SECTION4, menu.Selection);
			}
		}
		case MenuAction_Display:
		{
			char sMenuTitle[PLATFORM_MAX_PATH];
			Panel pHit = view_as<Panel>(param2);
			FormatEx(sMenuTitle, sizeof(sMenuTitle), "%T", "HitMenu", param1);
			pHit.SetTitle(sMenuTitle);
		}
		case MenuAction_DisplayItem:
		{
			if (param2 >= 0)
			{
				char sMenuOption[PLATFORM_MAX_PATH];

				switch (param2)
				{
					case 0: FormatEx(sMenuOption, sizeof(sMenuOption), "%T", "Status", param1);
					case 1: FormatEx(sMenuOption, sizeof(sMenuOption), "%T", "Details", param1);
					case 2: FormatEx(sMenuOption, sizeof(sMenuOption), "%T", "HumanSupport", param1);
				}

				return RedrawMenuItem(sMenuOption);
			}
		}
	}

	return 0;
}

void vHitDisplayMenu(Menu menu)
{
	menu.AddItem(MT_MENU_HIT, MT_MENU_HIT);
}

void vHitMenuItemSelected(int client, const char[] info)
{
	if (StrEqual(info, MT_MENU_HIT, false))
	{
		vHitMenu(client, MT_HIT_SECTION4, 0);
	}
}

void vHitMenuItemDisplayed(int client, const char[] info, char[] buffer, int size)
{
	if (StrEqual(info, MT_MENU_HIT, false))
	{
		FormatEx(buffer, size, "%T", "HitMenu2", client);
	}
}

public Action HitTraceAttack(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &ammotype, int hitbox, int hitgroup)
{
	if (MT_IsCorePluginEnabled() && bIsValidClient(victim, MT_CHECK_INDEX|MT_CHECK_INGAME|MT_CHECK_ALIVE) && damage > 0.0)
	{
		if (MT_IsTankSupported(victim) && MT_IsCustomTankSupported(victim) && g_esHitCache[victim].g_iHitAbility == 1)
		{
			if (bIsAreaNarrow(victim, g_esHitCache[victim].g_flOpenAreasOnly) || MT_DoesTypeRequireHumans(g_esHitPlayer[victim].g_iTankType) || (g_esHitCache[victim].g_iRequiresHumans > 0 && iGetHumanCount() < g_esHitCache[victim].g_iRequiresHumans) || (!MT_HasAdminAccess(victim) && !bHasAdminAccess(victim, g_esHitAbility[g_esHitPlayer[victim].g_iTankType].g_iAccessFlags, g_esHitPlayer[victim].g_iAccessFlags)) || (bIsSurvivor(attacker) && (MT_IsAdminImmune(attacker, victim) || bIsAdminImmune(attacker, g_esHitPlayer[victim].g_iTankType, g_esHitAbility[g_esHitPlayer[victim].g_iTankType].g_iImmunityFlags, g_esHitPlayer[attacker].g_iImmunityFlags) || MT_DoesSurvivorHaveRewardType(attacker, MT_REWARD_DAMAGEBOOST))) || (bIsTank(victim, MT_CHECK_FAKECLIENT) && g_esHitCache[victim].g_iHumanAbility == 0))
			{
				return Plugin_Continue;
			}

			damage *= g_esHitCache[victim].g_flHitDamageMultiplier;

			static int iBit, iFlag;
			iBit = hitgroup - 1;
			iFlag = (1 << iBit);

			return !!(g_esHitCache[victim].g_iHitGroup & iFlag) ? Plugin_Changed : Plugin_Handled;
		}
	}

	return Plugin_Continue;
}

void vHitPluginCheck(ArrayList &list)
{
	list.PushString(MT_MENU_HIT);
}

void vHitAbilityCheck(ArrayList &list, ArrayList &list2, ArrayList &list3, ArrayList &list4)
{
	list.PushString(MT_HIT_SECTION);
	list2.PushString(MT_HIT_SECTION2);
	list3.PushString(MT_HIT_SECTION3);
	list4.PushString(MT_HIT_SECTION4);
}

void vHitConfigsLoad(int mode)
{
	switch (mode)
	{
		case 1:
		{
			for (int iIndex = MT_GetMinType(); iIndex <= MT_GetMaxType(); iIndex++)
			{
				g_esHitAbility[iIndex].g_iAccessFlags = 0;
				g_esHitAbility[iIndex].g_iImmunityFlags = 0;
				g_esHitAbility[iIndex].g_iHumanAbility = 0;
				g_esHitAbility[iIndex].g_flOpenAreasOnly = 0.0;
				g_esHitAbility[iIndex].g_iRequiresHumans = 1;
				g_esHitAbility[iIndex].g_iHitAbility = 0;
				g_esHitAbility[iIndex].g_flHitDamageMultiplier = 1.5;
				g_esHitAbility[iIndex].g_iHitGroup = 1;
			}
		}
		case 3:
		{
			for (int iPlayer = 1; iPlayer <= MaxClients; iPlayer++)
			{
				if (bIsValidClient(iPlayer))
				{
					g_esHitPlayer[iPlayer].g_iAccessFlags = 0;
					g_esHitPlayer[iPlayer].g_iImmunityFlags = 0;
					g_esHitPlayer[iPlayer].g_iHumanAbility = 0;
					g_esHitPlayer[iPlayer].g_flOpenAreasOnly = 0.0;
					g_esHitPlayer[iPlayer].g_iRequiresHumans = 0;
					g_esHitPlayer[iPlayer].g_iHitAbility = 0;
					g_esHitPlayer[iPlayer].g_flHitDamageMultiplier = 0.0;
					g_esHitPlayer[iPlayer].g_iHitGroup = 0;
				}
			}
		}
	}
}

void vHitConfigsLoaded(const char[] subsection, const char[] key, const char[] value, int type, int admin, int mode)
{
	if (mode == 3 && bIsValidClient(admin))
	{
		g_esHitPlayer[admin].g_iHumanAbility = iGetKeyValue(subsection, MT_HIT_SECTIONS, key, "HumanAbility", "Human Ability", "Human_Ability", "human", g_esHitPlayer[admin].g_iHumanAbility, value, 0, 1);
		g_esHitPlayer[admin].g_flOpenAreasOnly = flGetKeyValue(subsection, MT_HIT_SECTIONS, key, "OpenAreasOnly", "Open Areas Only", "Open_Areas_Only", "openareas", g_esHitPlayer[admin].g_flOpenAreasOnly, value, 0.0, 999999.0);
		g_esHitPlayer[admin].g_iRequiresHumans = iGetKeyValue(subsection, MT_HIT_SECTIONS, key, "RequiresHumans", "Requires Humans", "Requires_Humans", "hrequire", g_esHitPlayer[admin].g_iRequiresHumans, value, 0, 32);
		g_esHitPlayer[admin].g_iHitAbility = iGetKeyValue(subsection, MT_HIT_SECTIONS, key, "AbilityEnabled", "Ability Enabled", "Ability_Enabled", "aenabled", g_esHitPlayer[admin].g_iHitAbility, value, 0, 1);
		g_esHitPlayer[admin].g_flHitDamageMultiplier = flGetKeyValue(subsection, MT_HIT_SECTIONS, key, "HitDamageMultiplier", "Hit Damage Multiplier", "Hit_Damage_Multiplier", "dmgmulti", g_esHitPlayer[admin].g_flHitDamageMultiplier, value, 1.0, 999999.0);
		g_esHitPlayer[admin].g_iHitGroup = iGetKeyValue(subsection, MT_HIT_SECTIONS, key, "HitGroup", "Hit Group", "Hit_Group", "group", g_esHitPlayer[admin].g_iHitGroup, value, 1, 127);

		if (StrEqual(subsection, MT_HIT_SECTION, false) || StrEqual(subsection, MT_HIT_SECTION2, false) || StrEqual(subsection, MT_HIT_SECTION3, false) || StrEqual(subsection, MT_HIT_SECTION4, false))
		{
			if (StrEqual(key, "AccessFlags", false) || StrEqual(key, "Access Flags", false) || StrEqual(key, "Access_Flags", false) || StrEqual(key, "access", false))
			{
				g_esHitPlayer[admin].g_iAccessFlags = ReadFlagString(value);
			}
			else if (StrEqual(key, "ImmunityFlags", false) || StrEqual(key, "Immunity Flags", false) || StrEqual(key, "Immunity_Flags", false) || StrEqual(key, "immunity", false))
			{
				g_esHitPlayer[admin].g_iImmunityFlags = ReadFlagString(value);
			}
		}
	}

	if (mode < 3 && type > 0)
	{
		g_esHitAbility[type].g_iHumanAbility = iGetKeyValue(subsection, MT_HIT_SECTIONS, key, "HumanAbility", "Human Ability", "Human_Ability", "human", g_esHitAbility[type].g_iHumanAbility, value, 0, 1);
		g_esHitAbility[type].g_flOpenAreasOnly = flGetKeyValue(subsection, MT_HIT_SECTIONS, key, "OpenAreasOnly", "Open Areas Only", "Open_Areas_Only", "openareas", g_esHitAbility[type].g_flOpenAreasOnly, value, 0.0, 999999.0);
		g_esHitAbility[type].g_iRequiresHumans = iGetKeyValue(subsection, MT_HIT_SECTIONS, key, "RequiresHumans", "Requires Humans", "Requires_Humans", "hrequire", g_esHitAbility[type].g_iRequiresHumans, value, 0, 32);
		g_esHitAbility[type].g_iHitAbility = iGetKeyValue(subsection, MT_HIT_SECTIONS, key, "AbilityEnabled", "Ability Enabled", "Ability_Enabled", "aenabled", g_esHitAbility[type].g_iHitAbility, value, 0, 1);
		g_esHitAbility[type].g_flHitDamageMultiplier = flGetKeyValue(subsection, MT_HIT_SECTIONS, key, "HitDamageMultiplier", "Hit Damage Multiplier", "Hit_Damage_Multiplier", "dmgmulti", g_esHitAbility[type].g_flHitDamageMultiplier, value, 1.0, 999999.0);
		g_esHitAbility[type].g_iHitGroup = iGetKeyValue(subsection, MT_HIT_SECTIONS, key, "HitGroup", "Hit Group", "Hit_Group", "group", g_esHitAbility[type].g_iHitGroup, value, 1, 127);

		if (StrEqual(subsection, MT_HIT_SECTION, false) || StrEqual(subsection, MT_HIT_SECTION2, false) || StrEqual(subsection, MT_HIT_SECTION3, false) || StrEqual(subsection, MT_HIT_SECTION4, false))
		{
			if (StrEqual(key, "AccessFlags", false) || StrEqual(key, "Access Flags", false) || StrEqual(key, "Access_Flags", false) || StrEqual(key, "access", false))
			{
				g_esHitAbility[type].g_iAccessFlags = ReadFlagString(value);
			}
			else if (StrEqual(key, "ImmunityFlags", false) || StrEqual(key, "Immunity Flags", false) || StrEqual(key, "Immunity_Flags", false) || StrEqual(key, "immunity", false))
			{
				g_esHitAbility[type].g_iImmunityFlags = ReadFlagString(value);
			}
		}
	}
}

void vHitSettingsCached(int tank, bool apply, int type)
{
	bool bHuman = bIsTank(tank, MT_CHECK_FAKECLIENT);
	g_esHitCache[tank].g_flHitDamageMultiplier = flGetSettingValue(apply, bHuman, g_esHitPlayer[tank].g_flHitDamageMultiplier, g_esHitAbility[type].g_flHitDamageMultiplier);
	g_esHitCache[tank].g_iHitAbility = iGetSettingValue(apply, bHuman, g_esHitPlayer[tank].g_iHitAbility, g_esHitAbility[type].g_iHitAbility);
	g_esHitCache[tank].g_iHitGroup = iGetSettingValue(apply, bHuman, g_esHitPlayer[tank].g_iHitGroup, g_esHitAbility[type].g_iHitGroup);
	g_esHitCache[tank].g_iHumanAbility = iGetSettingValue(apply, bHuman, g_esHitPlayer[tank].g_iHumanAbility, g_esHitAbility[type].g_iHumanAbility);
	g_esHitCache[tank].g_flOpenAreasOnly = flGetSettingValue(apply, bHuman, g_esHitPlayer[tank].g_flOpenAreasOnly, g_esHitAbility[type].g_flOpenAreasOnly);
	g_esHitCache[tank].g_iRequiresHumans = iGetSettingValue(apply, bHuman, g_esHitPlayer[tank].g_iRequiresHumans, g_esHitAbility[type].g_iRequiresHumans);
	g_esHitPlayer[tank].g_iTankType = apply ? type : 0;
}