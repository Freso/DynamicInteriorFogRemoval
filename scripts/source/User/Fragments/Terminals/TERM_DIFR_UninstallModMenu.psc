;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname Fragments:Terminals:TERM_DIFR_UninstallModMenu Extends Terminal Hidden Const

;BEGIN FRAGMENT Fragment_Terminal_01
Function Fragment_Terminal_01(ObjectReference akTerminalRef)
;BEGIN CODE
(DIFR_DynamicInteriorFogRemovalQuest as DIFR_DynamicInteriorFogRemovalScript).UninstallMod()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Quest Property DIFR_DynamicInteriorFogRemovalQuest Auto Const
