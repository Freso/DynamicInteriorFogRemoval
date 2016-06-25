;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname Fragments:Terminals:TERM_DIFR_MainMenu Extends Terminal Hidden Const

;BEGIN FRAGMENT Fragment_Terminal_01
Function Fragment_Terminal_01(ObjectReference akTerminalRef)
;BEGIN CODE
DIFR_InteriorFogVisibilityLevel.SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_02
Function Fragment_Terminal_02(ObjectReference akTerminalRef)
;BEGIN CODE
DIFR_InteriorFogVisibilityLevel.SetValue(2)
(DIFR_DynamicInteriorFogRemovalQuest as DIFR_DynamicInteriorFogRemovalScript).DeactivateMod()
Debug.MessageBox("Please exit and restart the game in order for the Vanilla fog settings to be restored.")
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_03
Function Fragment_Terminal_03(ObjectReference akTerminalRef)
;BEGIN CODE
DIFR_InteriorFogVisibilityLevel.SetValue(0)
(DIFR_DynamicInteriorFogRemovalQuest as DIFR_DynamicInteriorFogRemovalScript).ActivateMod()
(DIFR_DynamicInteriorFogRemovalQuest as DIFR_DynamicInteriorFogRemovalScript).ApplyFogSettingsToCellData()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

GlobalVariable Property DIFR_InteriorFogVisibilityLevel Auto Const

Quest Property DIFR_DynamicInteriorFogRemovalQuest Auto Const
