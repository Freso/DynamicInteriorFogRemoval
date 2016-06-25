Scriptname DIFR_DynamicInteriorFogRemovalScript extends Quest
{Handles the DIFR mod's main functionality, and removes interior fog dynamically as the player goes into non-sky-lit cells.}

Actor playerRef
Cell currentCell
float currentScriptVersion = 1.0
float EPSILON = 0.0000001 Const

Group Holotapes
Holotape Property DIFR_ModSettingsHolotape Auto Const
EndGroup

Group GlobalVariables
GlobalVariable Property DIFR_InteriorFogVisibilityLevel Auto Const
GlobalVariable Property DIFR_ScriptVersionInUse Auto Const
GlobalVariable Property DIFR_IsModUninstalled Auto Const
EndGroup

Group FogVisibilityEnums
int Property INVISIBLE = 0 Auto Const
int Property SUBTLE = 1 Auto Const
int Property VANILLA = 2 Auto Const
EndGroup

Group Quest
Quest Property OutOfTimeQuest Auto Const
EndGroup

Group Messages
Message Property DIFR_RespawnModItems Auto Const
EndGroup

;**************************************************************************************************
;EVENTS

Event OnInit()
	playerRef = Game.GetPlayer()
	
	;Event sent to the player when the game's difficulty is changed.
	RegisterForRemoteEvent(playerRef, "OnDifficultyChanged")
	;Event called when the player loads a save game.
	RegisterForRemoteEvent(playerRef, "OnPlayerLoadGame")
	;Event for when the player starts a new game, tracks the first quest which takes place after exiting Vault 111.
	RegisterForRemoteEvent(OutOfTimeQuest, "OnStageSet")

	ActivateMod(true)
EndEvent

Event Quest.OnStageSet(Quest OutOfTimeQuest, int auiStageID, int auiItemID)
	if(OutOfTimeQuest.GetCurrentStageID() >= 10)	;Checks if the player is outside of vault 111 when starting a new playthrough.
		AddDIFRHolotape()
		UnRegisterForRemoteEvent(OutOfTimeQuest, "OnStageSet")
	endif
EndEvent

Event Actor.OnPlayerLoadGame(Actor player)
	currentScriptVersion = 1.0
	if(!(Math.abs(DIFR_ScriptVersionInUse.GetValue() - currentScriptVersion) <= EPSILON))
		DIFR_ScriptVersionInUse.SetValue(currentScriptVersion)
		Utility.Wait(2)
		Debug.Notification("[Dynamic Interior Fog Removal]: Mod updated to version " + "1.0")
		
		int iButton = DIFR_RespawnModItems.Show()
		if(iButton == 0)
			ActivateMod(true)
		else
			ActivateMod()
		endif
	endif
	
	ApplyFogSettingsToCellData()
EndEvent

Event OnPlayerTeleport()	
	ApplyFogSettingsToCellData()
EndEvent

;**************************************************************************************************
;FUNCTIONS

Function AddDIFRHolotape()
	if(playerRef.GetItemCount(DIFR_ModSettingsHolotape) == 0)
		playerRef.AddItem(DIFR_ModSettingsHolotape)
	endif
EndFunction

Function ApplyFogSettingsToCellData()
	currentCell = playerRef.GetParentCell()
	
	if(currentCell.IsInterior())
		if(DIFR_InteriorFogVisibilityLevel.GetValueInt() == INVISIBLE)
			currentCell.SetFogPlanes(0.0, 999999999.0)
			currentCell.SetFogPower(10.0)
		elseif(DIFR_InteriorFogVisibilityLevel.GetValueInt() == SUBTLE)
			currentCell.SetFogPlanes(0.0, 10000.0)
			currentCell.SetFogPower(2.0)
		elseif(DIFR_InteriorFogVisibilityLevel.GetValueInt() == VANILLA)
			;The mod is deactivated through the DIFR_ModSettingsHolotape.
		endif
		
		if(DIFR_InteriorFogVisibilityLevel.GetValueInt() != VANILLA)
			Debug.Trace("[Dynamic Interior Fog Removal]: Interior Cell Defogged - " + currentCell)
		endif
		
	endif
EndFunction

Function ActivateMod(bool addModItems = false)
	;Event for when the player is teleported to a different cell.
	RegisterForPlayerTeleport()
	
	if(addModItems)
		AddDIFRHolotape()
	endif
EndFunction

Function DeactivateMod()
	UnregisterForPlayerTeleport()
EndFunction

Function UninstallMod()
	DeactivateMod()
	playerRef.RemoveItem(DIFR_ModSettingsHolotape, playerRef.GetItemCount(DIFR_ModSettingsHolotape))
	UnRegisterForRemoteEvent(playerRef, "OnPlayerLoadGame")
	UnRegisterForRemoteEvent(OutOfTimeQuest, "OnStageSet")
	DIFR_IsModUninstalled.SetValue(1)
	CompleteQuest()
EndFunction