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

#define MT_ITEM_SECTION "itemability"
#define MT_ITEM_SECTION2 "item ability"
#define MT_ITEM_SECTION3 "item_ability"
#define MT_ITEM_SECTION4 "item"
#define MT_ITEM_SECTIONS MT_ITEM_SECTION, MT_ITEM_SECTION2, MT_ITEM_SECTION3, MT_ITEM_SECTION4

#define MT_MENU_ITEM "Item Ability"

enum struct esItemPlayer
{
	bool g_bActivated;

	char g_sItemLoadout[325];

	float g_flItemChance;
	float g_flOpenAreasOnly;

	int g_iAccessFlags;
	int g_iComboAbility;
	int g_iHumanAbility;
	int g_iImmunityFlags;
	int g_iItemAbility;
	int g_iItemMessage;
	int g_iItemMode;
	int g_iRequiresHumans;
	int g_iTankType;
}

esItemPlayer g_esItemPlayer[MAXPLAYERS + 1];

enum struct esItemAbility
{
	char g_sItemLoadout[325];

	float g_flItemChance;
	float g_flOpenAreasOnly;

	int g_iAccessFlags;
	int g_iComboAbility;
	int g_iHumanAbility;
	int g_iImmunityFlags;
	int g_iItemAbility;
	int g_iItemMessage;
	int g_iItemMode;
	int g_iRequiresHumans;
}

esItemAbility g_esItemAbility[MT_MAXTYPES + 1];

enum struct esItemCache
{
	char g_sItemLoadout[325];

	float g_flItemChance;
	float g_flOpenAreasOnly;

	int g_iComboAbility;
	int g_iHumanAbility;
	int g_iItemAbility;
	int g_iItemMessage;
	int g_iItemMode;
	int g_iRequiresHumans;
}

esItemCache g_esItemCache[MAXPLAYERS + 1];

void vItemMapStart()
{
	vItemReset();
}

void vItemClientPutInServer(int client)
{
	g_esItemPlayer[client].g_bActivated = false;
}

void vItemClientDisconnect_Post(int client)
{
	g_esItemPlayer[client].g_bActivated = false;
}

void vItemMapEnd()
{
	vItemReset();
}

void vItemMenu(int client, const char[] name, int item)
{
	if (StrContains(MT_ITEM_SECTION4, name, false) == -1)
	{
		return;
	}

	Menu mAbilityMenu = new Menu(iItemMenuHandler, MENU_ACTIONS_DEFAULT|MenuAction_Display|MenuAction_DisplayItem);
	mAbilityMenu.SetTitle("Item Ability Information");
	mAbilityMenu.AddItem("Status", "Status");
	mAbilityMenu.AddItem("Buttons", "Buttons");
	mAbilityMenu.AddItem("Details", "Details");
	mAbilityMenu.AddItem("Human Support", "Human Support");
	mAbilityMenu.DisplayAt(client, item, MENU_TIME_FOREVER);
}

public int iItemMenuHandler(Menu menu, MenuAction action, int param1, int param2)
{
	switch (action)
	{
		case MenuAction_End: delete menu;
		case MenuAction_Select:
		{
			switch (param2)
			{
				case 0: MT_PrintToChat(param1, "%s %t", MT_TAG3, g_esItemCache[param1].g_iItemAbility == 0 ? "AbilityStatus1" : "AbilityStatus2");
				case 1: MT_PrintToChat(param1, "%s %t", MT_TAG3, "AbilityButtons4");
				case 2: MT_PrintToChat(param1, "%s %t", MT_TAG3, "ItemDetails");
				case 3: MT_PrintToChat(param1, "%s %t", MT_TAG3, g_esItemCache[param1].g_iHumanAbility == 0 ? "AbilityHumanSupport1" : "AbilityHumanSupport2");
			}

			if (bIsValidClient(param1, MT_CHECK_INGAME))
			{
				vItemMenu(param1, MT_ITEM_SECTION4, menu.Selection);
			}
		}
		case MenuAction_Display:
		{
			char sMenuTitle[PLATFORM_MAX_PATH];
			Panel pItem = view_as<Panel>(param2);
			FormatEx(sMenuTitle, sizeof(sMenuTitle), "%T", "ItemMenu", param1);
			pItem.SetTitle(sMenuTitle);
		}
		case MenuAction_DisplayItem:
		{
			if (param2 >= 0)
			{
				char sMenuOption[PLATFORM_MAX_PATH];

				switch (param2)
				{
					case 0: FormatEx(sMenuOption, sizeof(sMenuOption), "%T", "Status", param1);
					case 1: FormatEx(sMenuOption, sizeof(sMenuOption), "%T", "Buttons", param1);
					case 2: FormatEx(sMenuOption, sizeof(sMenuOption), "%T", "Details", param1);
					case 3: FormatEx(sMenuOption, sizeof(sMenuOption), "%T", "HumanSupport", param1);
				}

				return RedrawMenuItem(sMenuOption);
			}
		}
	}

	return 0;
}

void vItemDisplayMenu(Menu menu)
{
	menu.AddItem(MT_MENU_ITEM, MT_MENU_ITEM);
}

void vItemMenuItemSelected(int client, const char[] info)
{
	if (StrEqual(info, MT_MENU_ITEM, false))
	{
		vItemMenu(client, MT_ITEM_SECTION4, 0);
	}
}

void vItemMenuItemDisplayed(int client, const char[] info, char[] buffer, int size)
{
	if (StrEqual(info, MT_MENU_ITEM, false))
	{
		FormatEx(buffer, size, "%T", "ItemMenu2", client);
	}
}

void vItemPluginCheck(ArrayList &list)
{
	list.PushString(MT_MENU_ITEM);
}

void vItemAbilityCheck(ArrayList &list, ArrayList &list2, ArrayList &list3, ArrayList &list4)
{
	list.PushString(MT_ITEM_SECTION);
	list2.PushString(MT_ITEM_SECTION2);
	list3.PushString(MT_ITEM_SECTION3);
	list4.PushString(MT_ITEM_SECTION4);
}

void vItemCombineAbilities(int tank, int type, const float random, const char[] combo)
{
	if (bIsTank(tank, MT_CHECK_FAKECLIENT) && g_esItemCache[tank].g_iHumanAbility != 2)
	{
		return;
	}

	static char sAbilities[320], sSet[4][32];
	FormatEx(sAbilities, sizeof(sAbilities), ",%s,", combo);
	FormatEx(sSet[0], sizeof(sSet[]), ",%s,", MT_ITEM_SECTION);
	FormatEx(sSet[1], sizeof(sSet[]), ",%s,", MT_ITEM_SECTION2);
	FormatEx(sSet[2], sizeof(sSet[]), ",%s,", MT_ITEM_SECTION3);
	FormatEx(sSet[3], sizeof(sSet[]), ",%s,", MT_ITEM_SECTION4);
	if (StrContains(sAbilities, sSet[0], false) != -1 || StrContains(sAbilities, sSet[1], false) != -1 || StrContains(sAbilities, sSet[2], false) != -1 || StrContains(sAbilities, sSet[3], false) != -1)
	{
		if (type == MT_COMBO_MAINRANGE && g_esItemCache[tank].g_iItemAbility == 1 && g_esItemCache[tank].g_iComboAbility == 1 && !g_esItemPlayer[tank].g_bActivated)
		{
			static char sSubset[10][32];
			ExplodeString(combo, ",", sSubset, sizeof(sSubset), sizeof(sSubset[]));
			for (int iPos = 0; iPos < sizeof(sSubset); iPos++)
			{
				if (StrEqual(sSubset[iPos], MT_ITEM_SECTION, false) || StrEqual(sSubset[iPos], MT_ITEM_SECTION2, false) || StrEqual(sSubset[iPos], MT_ITEM_SECTION3, false) || StrEqual(sSubset[iPos], MT_ITEM_SECTION4, false))
				{
					if (random <= MT_GetCombinationSetting(tank, 1, iPos))
					{
						static float flDelay;
						flDelay = MT_GetCombinationSetting(tank, 3, iPos);

						switch (flDelay)
						{
							case 0.0: g_esItemPlayer[tank].g_bActivated = true;
							default: CreateTimer(flDelay, tTimerItemCombo, GetClientUserId(tank), TIMER_FLAG_NO_MAPCHANGE);
						}

						break;
					}
				}
			}
		}
	}
}

void vItemConfigsLoad(int mode)
{
	switch (mode)
	{
		case 1:
		{
			for (int iIndex = MT_GetMinType(); iIndex <= MT_GetMaxType(); iIndex++)
			{
				g_esItemAbility[iIndex].g_iAccessFlags = 0;
				g_esItemAbility[iIndex].g_iImmunityFlags = 0;
				g_esItemAbility[iIndex].g_iComboAbility = 0;
				g_esItemAbility[iIndex].g_iHumanAbility = 0;
				g_esItemAbility[iIndex].g_flOpenAreasOnly = 0.0;
				g_esItemAbility[iIndex].g_iRequiresHumans = 0;
				g_esItemAbility[iIndex].g_iItemAbility = 0;
				g_esItemAbility[iIndex].g_iItemMessage = 0;
				g_esItemAbility[iIndex].g_flItemChance = 33.3;
				g_esItemAbility[iIndex].g_sItemLoadout = "rifle,pistol,first_aid_kit,pain_pills";
				g_esItemAbility[iIndex].g_iItemMode = 0;
			}
		}
		case 3:
		{
			for (int iPlayer = 1; iPlayer <= MaxClients; iPlayer++)
			{
				if (bIsValidClient(iPlayer))
				{
					g_esItemPlayer[iPlayer].g_iAccessFlags = 0;
					g_esItemPlayer[iPlayer].g_iImmunityFlags = 0;
					g_esItemPlayer[iPlayer].g_iComboAbility = 0;
					g_esItemPlayer[iPlayer].g_iHumanAbility = 0;
					g_esItemPlayer[iPlayer].g_flOpenAreasOnly = 0.0;
					g_esItemPlayer[iPlayer].g_iRequiresHumans = 0;
					g_esItemPlayer[iPlayer].g_iItemAbility = 0;
					g_esItemPlayer[iPlayer].g_iItemMessage = 0;
					g_esItemPlayer[iPlayer].g_flItemChance = 0.0;
					g_esItemPlayer[iPlayer].g_sItemLoadout[0] = '\0';
					g_esItemPlayer[iPlayer].g_iItemMode = 0;
				}
			}
		}
	}
}

void vItemConfigsLoaded(const char[] subsection, const char[] key, const char[] value, int type, int admin, int mode)
{
	if (mode == 3 && bIsValidClient(admin))
	{
		g_esItemPlayer[admin].g_iComboAbility = iGetKeyValue(subsection, MT_ITEM_SECTIONS, key, "ComboAbility", "Combo Ability", "Combo_Ability", "combo", g_esItemPlayer[admin].g_iComboAbility, value, 0, 1);
		g_esItemPlayer[admin].g_iHumanAbility = iGetKeyValue(subsection, MT_ITEM_SECTIONS, key, "HumanAbility", "Human Ability", "Human_Ability", "human", g_esItemPlayer[admin].g_iHumanAbility, value, 0, 2);
		g_esItemPlayer[admin].g_flOpenAreasOnly = flGetKeyValue(subsection, MT_ITEM_SECTIONS, key, "OpenAreasOnly", "Open Areas Only", "Open_Areas_Only", "openareas", g_esItemPlayer[admin].g_flOpenAreasOnly, value, 0.0, 999999.0);
		g_esItemPlayer[admin].g_iRequiresHumans = iGetKeyValue(subsection, MT_ITEM_SECTIONS, key, "RequiresHumans", "Requires Humans", "Requires_Humans", "hrequire", g_esItemPlayer[admin].g_iRequiresHumans, value, 0, 32);
		g_esItemPlayer[admin].g_iItemAbility = iGetKeyValue(subsection, MT_ITEM_SECTIONS, key, "AbilityEnabled", "Ability Enabled", "Ability_Enabled", "aenabled", g_esItemPlayer[admin].g_iItemAbility, value, 0, 1);
		g_esItemPlayer[admin].g_iItemMessage = iGetKeyValue(subsection, MT_ITEM_SECTIONS, key, "AbilityMessage", "Ability Message", "Ability_Message", "message", g_esItemPlayer[admin].g_iItemMessage, value, 0, 1);
		g_esItemPlayer[admin].g_flItemChance = flGetKeyValue(subsection, MT_ITEM_SECTIONS, key, "ItemChance", "Item Chance", "Item_Chance", "chance", g_esItemPlayer[admin].g_flItemChance, value, 0.0, 100.0);
		g_esItemPlayer[admin].g_iItemMode = iGetKeyValue(subsection, MT_ITEM_SECTIONS, key, "ItemMode", "Item Mode", "Item_Mode", "mode", g_esItemPlayer[admin].g_iItemMode, value, 0, 1);

		if (StrEqual(subsection, MT_ITEM_SECTION, false) || StrEqual(subsection, MT_ITEM_SECTION2, false) || StrEqual(subsection, MT_ITEM_SECTION3, false) || StrEqual(subsection, MT_ITEM_SECTION4, false))
		{
			if (StrEqual(key, "AccessFlags", false) || StrEqual(key, "Access Flags", false) || StrEqual(key, "Access_Flags", false) || StrEqual(key, "access", false))
			{
				g_esItemPlayer[admin].g_iAccessFlags = ReadFlagString(value);
			}
			else if (StrEqual(key, "ImmunityFlags", false) || StrEqual(key, "Immunity Flags", false) || StrEqual(key, "Immunity_Flags", false) || StrEqual(key, "immunity", false))
			{
				g_esItemPlayer[admin].g_iImmunityFlags = ReadFlagString(value);
			}
			else if (StrEqual(key, "ItemLoadout", false) || StrEqual(key, "Item Loadout", false) || StrEqual(key, "Item_Loadout", false) || StrEqual(key, "loadout", false))
			{
				strcopy(g_esItemPlayer[admin].g_sItemLoadout, sizeof(esItemPlayer::g_sItemLoadout), value);
			}
		}
	}

	if (mode < 3 && type > 0)
	{
		g_esItemAbility[type].g_iComboAbility = iGetKeyValue(subsection, MT_ITEM_SECTIONS, key, "ComboAbility", "Combo Ability", "Combo_Ability", "combo", g_esItemAbility[type].g_iComboAbility, value, 0, 1);
		g_esItemAbility[type].g_iHumanAbility = iGetKeyValue(subsection, MT_ITEM_SECTIONS, key, "HumanAbility", "Human Ability", "Human_Ability", "human", g_esItemAbility[type].g_iHumanAbility, value, 0, 2);
		g_esItemAbility[type].g_flOpenAreasOnly = flGetKeyValue(subsection, MT_ITEM_SECTIONS, key, "OpenAreasOnly", "Open Areas Only", "Open_Areas_Only", "openareas", g_esItemAbility[type].g_flOpenAreasOnly, value, 0.0, 999999.0);
		g_esItemAbility[type].g_iRequiresHumans = iGetKeyValue(subsection, MT_ITEM_SECTIONS, key, "RequiresHumans", "Requires Humans", "Requires_Humans", "hrequire", g_esItemAbility[type].g_iRequiresHumans, value, 0, 32);
		g_esItemAbility[type].g_iItemAbility = iGetKeyValue(subsection, MT_ITEM_SECTIONS, key, "AbilityEnabled", "Ability Enabled", "Ability_Enabled", "aenabled", g_esItemAbility[type].g_iItemAbility, value, 0, 1);
		g_esItemAbility[type].g_iItemMessage = iGetKeyValue(subsection, MT_ITEM_SECTIONS, key, "AbilityMessage", "Ability Message", "Ability_Message", "message", g_esItemAbility[type].g_iItemMessage, value, 0, 1);
		g_esItemAbility[type].g_flItemChance = flGetKeyValue(subsection, MT_ITEM_SECTIONS, key, "ItemChance", "Item Chance", "Item_Chance", "chance", g_esItemAbility[type].g_flItemChance, value, 0.0, 100.0);
		g_esItemAbility[type].g_iItemMode = iGetKeyValue(subsection, MT_ITEM_SECTIONS, key, "ItemMode", "Item Mode", "Item_Mode", "mode", g_esItemAbility[type].g_iItemMode, value, 0, 1);

		if (StrEqual(subsection, MT_ITEM_SECTION, false) || StrEqual(subsection, MT_ITEM_SECTION2, false) || StrEqual(subsection, MT_ITEM_SECTION3, false) || StrEqual(subsection, MT_ITEM_SECTION4, false))
		{
			if (StrEqual(key, "AccessFlags", false) || StrEqual(key, "Access Flags", false) || StrEqual(key, "Access_Flags", false) || StrEqual(key, "access", false))
			{
				g_esItemAbility[type].g_iAccessFlags = ReadFlagString(value);
			}
			else if (StrEqual(key, "ImmunityFlags", false) || StrEqual(key, "Immunity Flags", false) || StrEqual(key, "Immunity_Flags", false) || StrEqual(key, "immunity", false))
			{
				g_esItemAbility[type].g_iImmunityFlags = ReadFlagString(value);
			}
			else if (StrEqual(key, "ItemLoadout", false) || StrEqual(key, "Item Loadout", false) || StrEqual(key, "Item_Loadout", false) || StrEqual(key, "loadout", false))
			{
				strcopy(g_esItemAbility[type].g_sItemLoadout, sizeof(esItemAbility::g_sItemLoadout), value);
			}
		}
	}
}

void vItemSettingsCached(int tank, bool apply, int type)
{
	bool bHuman = bIsTank(tank, MT_CHECK_FAKECLIENT);
	vGetSettingValue(apply, bHuman, g_esItemCache[tank].g_sItemLoadout, sizeof(esItemCache::g_sItemLoadout), g_esItemPlayer[tank].g_sItemLoadout, g_esItemAbility[type].g_sItemLoadout);
	g_esItemCache[tank].g_flItemChance = flGetSettingValue(apply, bHuman, g_esItemPlayer[tank].g_flItemChance, g_esItemAbility[type].g_flItemChance);
	g_esItemCache[tank].g_iComboAbility = iGetSettingValue(apply, bHuman, g_esItemPlayer[tank].g_iComboAbility, g_esItemAbility[type].g_iComboAbility);
	g_esItemCache[tank].g_iHumanAbility = iGetSettingValue(apply, bHuman, g_esItemPlayer[tank].g_iHumanAbility, g_esItemAbility[type].g_iHumanAbility);
	g_esItemCache[tank].g_iItemAbility = iGetSettingValue(apply, bHuman, g_esItemPlayer[tank].g_iItemAbility, g_esItemAbility[type].g_iItemAbility);
	g_esItemCache[tank].g_iItemMessage = iGetSettingValue(apply, bHuman, g_esItemPlayer[tank].g_iItemMessage, g_esItemAbility[type].g_iItemMessage);
	g_esItemCache[tank].g_iItemMode = iGetSettingValue(apply, bHuman, g_esItemPlayer[tank].g_iItemMode, g_esItemAbility[type].g_iItemMode);
	g_esItemCache[tank].g_flOpenAreasOnly = flGetSettingValue(apply, bHuman, g_esItemPlayer[tank].g_flOpenAreasOnly, g_esItemAbility[type].g_flOpenAreasOnly);
	g_esItemCache[tank].g_iRequiresHumans = iGetSettingValue(apply, bHuman, g_esItemPlayer[tank].g_iRequiresHumans, g_esItemAbility[type].g_iRequiresHumans);
	g_esItemPlayer[tank].g_iTankType = apply ? type : 0;
}

void vItemCopyStats(int oldTank, int newTank)
{
	vItemCopyStats2(oldTank, newTank);
}

void vItemEventFired(Event event, const char[] name)
{
	if (StrEqual(name, "bot_player_replace"))
	{
		int iBotId = event.GetInt("bot"), iBot = GetClientOfUserId(iBotId),
			iTankId = event.GetInt("player"), iTank = GetClientOfUserId(iTankId);
		if (bIsValidClient(iBot) && bIsTank(iTank))
		{
			vItemCopyStats2(iBot, iTank);
		}
	}
	else if (StrEqual(name, "player_bot_replace"))
	{
		int iTankId = event.GetInt("player"), iTank = GetClientOfUserId(iTankId),
			iBotId = event.GetInt("bot"), iBot = GetClientOfUserId(iBotId);
		if (bIsValidClient(iTank) && bIsTank(iBot))
		{
			vItemCopyStats2(iTank, iBot);
		}
	}
	else if (StrEqual(name, "player_death"))
	{
		int iTankId = event.GetInt("userid"), iTank = GetClientOfUserId(iTankId);
		if (MT_IsTankSupported(iTank, MT_CHECK_INDEX|MT_CHECK_INGAME) && MT_IsCustomTankSupported(iTank) && g_esItemCache[iTank].g_iItemAbility == 1 && g_esItemPlayer[iTank].g_bActivated)
		{
			vItemAbility(iTank);
		}
	}
	else if (StrEqual(name, "mission_lost") || StrEqual(name, "round_start") || StrEqual(name, "round_end"))
	{
		vItemReset();
	}
}

void vItemAbilityActivated(int tank)
{
	if (MT_IsTankSupported(tank, MT_CHECK_INDEX|MT_CHECK_INGAME|MT_CHECK_FAKECLIENT) && ((!MT_HasAdminAccess(tank) && !bHasAdminAccess(tank, g_esItemAbility[g_esItemPlayer[tank].g_iTankType].g_iAccessFlags, g_esItemPlayer[tank].g_iAccessFlags)) || g_esItemCache[tank].g_iHumanAbility == 0))
	{
		return;
	}

	if (MT_IsTankSupported(tank) && (!bIsTank(tank, MT_CHECK_FAKECLIENT) || g_esItemCache[tank].g_iHumanAbility != 1) && MT_IsCustomTankSupported(tank) && g_esItemCache[tank].g_iItemAbility == 1 && g_esItemCache[tank].g_iComboAbility == 0 && GetRandomFloat(0.1, 100.0) <= g_esItemCache[tank].g_flItemChance && !g_esItemPlayer[tank].g_bActivated)
	{
		g_esItemPlayer[tank].g_bActivated = true;
	}
}

void vItemButtonPressed(int tank, int button)
{
	if (MT_IsTankSupported(tank, MT_CHECK_INDEX|MT_CHECK_INGAME|MT_CHECK_ALIVE|MT_CHECK_FAKECLIENT) && MT_IsCustomTankSupported(tank))
	{
		if (bIsAreaNarrow(tank, g_esItemCache[tank].g_flOpenAreasOnly) || MT_DoesTypeRequireHumans(g_esItemPlayer[tank].g_iTankType) || (g_esItemCache[tank].g_iRequiresHumans > 0 && iGetHumanCount() < g_esItemCache[tank].g_iRequiresHumans) || (!MT_HasAdminAccess(tank) && !bHasAdminAccess(tank, g_esItemAbility[g_esItemPlayer[tank].g_iTankType].g_iAccessFlags, g_esItemPlayer[tank].g_iAccessFlags)))
		{
			return;
		}

		if (button & MT_SPECIAL_KEY2)
		{
			if (g_esItemCache[tank].g_iItemAbility == 1 && g_esItemCache[tank].g_iHumanAbility == 1)
			{
				switch (g_esItemPlayer[tank].g_bActivated)
				{
					case true: MT_PrintToChat(tank, "%s %t", MT_TAG3, "ItemHuman2");
					case false:
					{
						g_esItemPlayer[tank].g_bActivated = true;

						MT_PrintToChat(tank, "%s %t", MT_TAG3, "ItemHuman");
					}
				}
			}
		}
	}
}

void vItemChangeType(int tank)
{
	if (MT_IsTankSupported(tank, MT_CHECK_INDEX|MT_CHECK_INGAME|MT_CHECK_FAKECLIENT) && ((!MT_HasAdminAccess(tank) && !bHasAdminAccess(tank, g_esItemAbility[g_esItemPlayer[tank].g_iTankType].g_iAccessFlags, g_esItemPlayer[tank].g_iAccessFlags)) || g_esItemCache[tank].g_iHumanAbility == 0))
	{
		return;
	}

	if (MT_IsTankSupported(tank) && MT_IsCustomTankSupported(tank) && g_esItemCache[tank].g_iItemAbility == 1)
	{
		vItemAbility(tank);
	}
}

void vItemCopyStats2(int oldTank, int newTank)
{
	g_esItemPlayer[newTank].g_bActivated = g_esItemPlayer[oldTank].g_bActivated;
}

void vItemAbility(int tank)
{
	g_esItemPlayer[tank].g_bActivated = false;

	if (bIsAreaNarrow(tank, g_esItemCache[tank].g_flOpenAreasOnly) || MT_DoesTypeRequireHumans(g_esItemPlayer[tank].g_iTankType) || (g_esItemCache[tank].g_iRequiresHumans > 0 && iGetHumanCount() < g_esItemCache[tank].g_iRequiresHumans) || (!MT_HasAdminAccess(tank) && !bHasAdminAccess(tank, g_esItemAbility[g_esItemPlayer[tank].g_iTankType].g_iAccessFlags, g_esItemPlayer[tank].g_iAccessFlags)))
	{
		return;
	}

	static char sItems[5][64];
	ReplaceString(g_esItemCache[tank].g_sItemLoadout, sizeof(esItemCache::g_sItemLoadout), " ", "");
	ExplodeString(g_esItemCache[tank].g_sItemLoadout, ",", sItems, sizeof(sItems), sizeof(sItems[]));
	for (int iSurvivor = 1; iSurvivor <= MaxClients; iSurvivor++)
	{
		if (bIsSurvivor(iSurvivor, MT_CHECK_INGAME|MT_CHECK_ALIVE) && !MT_IsAdminImmune(iSurvivor, tank) && !bIsAdminImmune(iSurvivor, g_esItemPlayer[tank].g_iTankType, g_esItemAbility[g_esItemPlayer[tank].g_iTankType].g_iImmunityFlags, g_esItemPlayer[iSurvivor].g_iImmunityFlags))
		{
			switch (g_esItemCache[tank].g_iItemMode)
			{
				case 0: vCheatCommand(iSurvivor, "give", sItems[GetRandomInt(1, sizeof(sItems)) - 1]);
				case 1:
				{
					for (int iItem = 0; iItem < sizeof(sItems); iItem++)
					{
						if (StrContains(g_esItemCache[tank].g_sItemLoadout, sItems[iItem]) != -1 && sItems[iItem][0] != '\0')
						{
							vCheatCommand(iSurvivor, "give", sItems[iItem]);
						}
					}
				}
			}
		}
	}

	if (g_esItemCache[tank].g_iItemMessage == 1)
	{
		static char sTankName[33];
		MT_GetTankName(tank, sTankName);
		MT_PrintToChatAll("%s %t", MT_TAG2, "Item", sTankName);
		MT_LogMessage(MT_LOG_ABILITY, "%s %T", MT_TAG, "Item", LANG_SERVER, sTankName);
	}
}

void vItemReset()
{
	for (int iPlayer = 1; iPlayer <= MaxClients; iPlayer++)
	{
		if (bIsValidClient(iPlayer, MT_CHECK_INGAME))
		{
			g_esItemPlayer[iPlayer].g_bActivated = false;
		}
	}
}

public Action tTimerItemCombo(Handle timer, int userid)
{
	int iTank = GetClientOfUserId(userid);
	if (!MT_IsCorePluginEnabled() || !MT_IsTankSupported(iTank) || (!MT_HasAdminAccess(iTank) && !bHasAdminAccess(iTank, g_esItemAbility[g_esItemPlayer[iTank].g_iTankType].g_iAccessFlags, g_esItemPlayer[iTank].g_iAccessFlags)) || !MT_IsTypeEnabled(g_esItemPlayer[iTank].g_iTankType) || !MT_IsCustomTankSupported(iTank) || g_esItemCache[iTank].g_iItemAbility == 0 || g_esItemPlayer[iTank].g_bActivated)
	{
		return Plugin_Stop;
	}

	g_esItemPlayer[iTank].g_bActivated = true;

	return Plugin_Continue;
}