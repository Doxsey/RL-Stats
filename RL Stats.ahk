;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template script (you can customize this template by editing "ShellNew\Template.ahk" in your Windows folder)
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
;#include C:\Users\Ryan\Documents\RLScript\RL_DB.ahk
;SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.



return ;returns from initial load (otherwise it runs code until 1st return, i think anyway)

;iniLocation := "C:\Users\Ryan\Desktop\RL\iniRL.ini"

SetGlobals:
	{
	global folderLoc := "C:\Users\Ryan\Desktop\RL\"
	global iniLocation := "C:\Users\Ryan\Desktop\RL\iniRL.ini" ;C:\Users\Ryan\Desktop\RL\iniRL.ini
	global PDataSource := "C:\Users\Ryan\Desktop\RL\RL_PData.txt" ;C:\Users\Ryan\Desktop\RL\RL_PData.txt
	global DataSource := "C:\Users\Ryan\Desktop\RL\RLData.txt" ;C:\Users\Ryan\Desktop\RL\RLData.txt
	global RefreshSource := "C:\Users\Ryan\Desktop\RL\RL2Data.txt" ;C:\Users\Ryan\Desktop\RL\RL2Data.txt
	return
	}

RunningUpdate:
	{
	Gui +LastFound ;Sets gui control to the last found ahk gui.
	GuiControl,,StatusText,Updating... ;Changes the text "StatusText" to "Updating..."
	;An ini file is used to store old rank and current rank for each game mode
	
	IniRead, ini3sRank, %iniLocation%, 3v3Standard, CurrentRank
	IniRead, iniPrev3sRank, %iniLocation%, 3v3Standard, PreviousRank
	
	IniRead, ini2sRank, %iniLocation%, Doubles, CurrentRank
	IniRead, iniPrev2sRank, %iniLocation%, Doubles, PreviousRank
	
	IniRead, ini3SoloRank, %iniLocation%, Solo Standard 3v3, CurrentRank
	IniRead, iniPrev3SoloRank, %iniLocation%, Solo Standard 3v3, PreviousRank
	
	
	;UrlDownloadToFile https://rocketleague.tracker.network/profile/steam/76561198067409816, %folderLoc%RL_PData.txt

	UrlDownloadToFile https://rocketleague.tracker.network/rocket-league/profile/steam/76561198067409816/overview, %folderLoc%RLData.txt ;Downloads the URL source to the file RLData.txt

	
		
	;newNumOf3sGames := NumberOfGames("Ranked Standard 3v3") ;Calls NumberOf3sGames function to get the new # of games played
	new3sRank := CurrentRank("Ranked Standard 3v3") ;Calls Current3sRank function to get new 3s rank
		
	;newNumOf2sGames := NumberOfGames("Ranked Doubles 2v2") ;Calls NumberOf2sGames function to get the new # of games played
	new2sRank := CurrentRank("Ranked Doubles 2v2") ;Calls Current2sRank function to get new 2s rank
	
	;newNumOf3SoloGames := NumberOfGames("Ranked Solo Standard 3v3") ;see above
	;new3SoloRank := CurrentRank("Ranked Solo Standard 3v3") ;see above
	
	
	
	;Checks to see if rank has changed (aka, no new data)
	If (new3sRank = ini3sRank AND new2sRank = ini2sRank)
		{
			GuiControl,,StatusText,No Change
			return
		}
	
	IniRead, iniGoals, %iniLocation%, PerformanceStats, Goals
	IniRead, iniSaves, %iniLocation%, PerformanceStats, Saves
	IniRead, iniShots, %iniLocation%, PerformanceStats, Shots
	IniRead, iniAssists, %iniLocation%, PerformanceStats, Assists
	IniRead, iniMVPs, %iniLocation%, PerformanceStats, MVPs
	
	Goals := GetPerformanceStat("Goals")
	Saves := GetPerformanceStat("Saves")
	Shots := GetPerformanceStat("Shots")
	Assists := GetPerformanceStat("Assists")
	MVPs := GetPerformanceStat("MVPs")
	
	goalChange := Goals - iniGoals
	saveChange := Saves - iniSaves
	shotChange := Shots - iniShots
	assistChange := Assists - iniAssists
	mvpChange := MVPs - iniMVPs
	
	GuiControl,,Goals,%goalChange%
	GuiControl,,Saves,%saveChange%
	GuiControl,,Shots,%shotChange%
	GuiControl,,Assists,%assistChange%
	GuiControl,,MVPs,%mvpChange%
	
	IniWrite, %Goals%, %iniLocation%, PerformanceStats, Goals
	IniWrite, %Saves%, %iniLocation%, PerformanceStats, Saves
	IniWrite, %Shots%, %iniLocation%, PerformanceStats, Shots
	IniWrite, %Assists%, %iniLocation%, PerformanceStats, Assists
	IniWrite, %MVPs%, %iniLocation%, PerformanceStats, MVPs	
	
	If (new3sRank != ini3sRank) ;Rank changed
		{
			IniWrite, %ini3sRank%, %iniLocation%, 3v3Standard, PreviousRank
			IniWrite, %new3sRank%, %iniLocation%, 3v3Standard, CurrentRank
			rankChange := new3sRank - ini3sRank
			
			
			UrlDownloadToFile http://rl.doxseycircus.com/insRL.php?GameMode=4&PreviousRank=%ini3sRank%&CurrentRank=%new3sRank%&Change=%rankChange%&Goals=%goalChange%&Saves=%saveChange%&Shots=%shotChange%&Assists=%assistChange%&MVP=%mvpChange%, %folderLoc%DB_Response.txt ;Downloads the URL source to the file RLData.txt
			FileRead, OutputVar, %folderLoc%DB_Response.txt
			
			GuiControl,,Curr3sRank,%new3sRank%
			GuiControl,,Prev3sRank,%ini3sRank%
			GuiControl,,3sChange,%rankChange%
			GuiControl,,2sChange,0
			GuiControl,,3SoloChange,0
			GuiControl,,StatusText,New 3v3 Data
			
			If (OutputVar != "Data Sent")
						{
						GuiControl,,StatusText,New 3v3 Data (Error in DB Send)
						}
			
			
			return 
		}

	If (new2sRank != ini2sRank) ;Rank changed
		{
			IniWrite, %ini2sRank%, %iniLocation%, Doubles, PreviousRank
			IniWrite, %new2sRank%, %iniLocation%, Doubles, CurrentRank
			rankChange := new2sRank - ini2sRank
									
			UrlDownloadToFile http://rl.doxseycircus.com/insRL.php?GameMode=2&PreviousRank=%ini2sRank%&CurrentRank=%new2sRank%&Change=%rankChange%&Goals=%goalChange%&Saves=%saveChange%&Shots=%shotChange%&Assists=%assistChange%&MVP=%mvpChange%, %folderLoc%DB_Response.txt ;Downloads the URL source to the file RLData.txt
			FileRead, OutputVar, %folderLoc%DB_Response.txt
			
			GuiControl,,Curr2sRank,%new2sRank%
			GuiControl,,Prev2sRank,%ini2sRank%
			GuiControl,,2sChange,%rankChange%
			GuiControl,,3sChange,0
			GuiControl,,3SoloChange,0
			GuiControl,,StatusText,New 2v2 Data
			
			If (OutputVar != "Data Sent")
						{
						GuiControl,,StatusText,New 2v2 Data (Error in DB Send)
						}
			
			return 
		}
	
	return
}

InitialGuiRanks:
	{
	
	IniRead, ini3sRank, %iniLocation%, 3v3Standard, CurrentRank
	IniRead, iniPrev3sRank, %iniLocation%, 3v3Standard, PreviousRank
	IniRead, ini2sRank, %iniLocation%, Doubles, CurrentRank
	IniRead, iniPrev2sRank, %iniLocation%, Doubles, PreviousRank
	IniRead, ini3SoloRank, %iniLocation%, Solo Standard 3v3, CurrentRank
	IniRead, iniPrev3SoloRank, %iniLocation%, Solo Standard 3v3, PreviousRank
	
	;IniRead, Goals, %iniLocation%, PerformanceStats, Goals
	;IniRead, Saves, %iniLocation%, PerformanceStats, Saves
	;IniRead, Shots, %iniLocation%, PerformanceStats, Shots
	;IniRead, Assists, %iniLocation%, PerformanceStats, Assists
	;IniRead, MVPs, %iniLocation%, PerformanceStats, MVPs

	Gui +LastFound
	GuiControl,,Curr3sRank,%ini3sRank%
	GuiControl,,Prev3sRank,%iniPrev3sRank%
	GuiControl,,Curr2sRank,%ini2sRank%
	GuiControl,,Prev2sRank,%iniPrev2sRank%
	GuiControl,,Curr3SoloRank,%ini3SoloRank%
	GuiControl,,Prev3SoloRank,%iniPrev3SoloRank%
	
	GuiControl,,Goals,0
	GuiControl,,Saves,0
	GuiControl,,Shots,0
	GuiControl,,Assists,0
	GuiControl,,MVPs,0
	
	GuiControl,,StatusText,Initialization Finished
	return
	}
	
InitializeLocalData:
	{
	Gui +LastFound ;Sets gui control to the last found ahk gui.
	GuiControl,,StatusText,Initializing... ;Changes the text "StatusText" to "Updating..."
	
	;Checking for Standard 3v3 Data
	IniRead, ini3sRank, %iniLocation%, 3v3Standard, CurrentRank
	IniRead, iniPrev3sRank, %iniLocation%, 3v3Standard, PreviousRank
		
		;Checks if these categories exist in the ini file. If not, they're created and filled with "No Data"
		If (ini3sRank == "ERROR")
			{
			IniWrite, 0, %iniLocation%, 3v3Standard, CurrentRank ;Defaults the key to 0 if missing
			}
		If (iniPrev3sRank == "ERROR")
			{
			IniWrite, 0, %iniLocation%, 3v3Standard, PreviousRank ;Defaults the key to 0 if missing
			}
	
	;Checking for Doubles Data	
	IniRead, ini2sRank, %iniLocation%, Doubles, CurrentRank
	IniRead, iniPrev2sRank, %iniLocation%, Doubles, PreviousRank
		
		;Checks if these categories exist in the ini file. If not, they're created and filled with "No Data"
		If (ini2sRank == "ERROR")
			{
			IniWrite, 0, %iniLocation%, Doubles, CurrentRank ;Defaults the key to 0 if missing
			}
		If (iniPrev2sRank == "ERROR")
			{
			IniWrite, 0, %iniLocation%, Doubles, PreviousRank ;Defaults the key to 0 if missing
			}
	
	;Checking for Solo 3s Data	
	IniRead, ini3SoloRank, %iniLocation%, Solo Standard 3v3, CurrentRank
	IniRead, iniPrev3SoloRank, %iniLocation%, Solo Standard 3v3, PreviousRank
		
		;Checks if these categories exist in the ini file. If not, they're created and filled with "No Data"
		If (ini3SoloRank == "ERROR")
			{
			IniWrite, 0, %iniLocation%, Solo Standard 3v3, CurrentRank ;Defaults the key to 0 if missing
			}
		If (iniPrev3SoloRank == "ERROR")
			{
			IniWrite, 0, %iniLocation%, Solo Standard 3v3, PreviousRank ;Defaults the key to 0 if missing
			}
	GoSub, InitializePerformanceStats
	return
	}
	
UpdateLocalData:
	{
	UrlDownloadToFile https://rocketleague.tracker.network/rocket-league/profile/steam/76561198067409816/overview, %folderLoc%RLData.txt ;################################
	;UrlDownloadToFile https://rocketleague.tracker.network/profile/steam/76561198067409816, %folderLoc%RL_PData.txt
	return
	}
	
CreateInitialGui: ;Creates the gui window. SmartGUI creator was used to do this.
	{
	Gui, +AlwaysOnTop +Owner
	
	Gui, Font, S10 CDefault, Verdana
	Gui, Add, GroupBox, x12 y20 w240 h110 , Standard 3v3
	Gui, Add, GroupBox, x12 y140 w240 h110 , Doubles
	Gui, Add, GroupBox, x12 y260 w240 h110 +Left, Solo Standard 3v3
	Gui, Add, GroupBox, x12 y380 w240 h110 , Solo 1v1
	Gui, Add, GroupBox, x272 y20 w180 h220 +Left, Performance Data

	Gui, Add, Text, x22 y100 w60 h20 vCurr3sRank +Center, No Data
	Gui, Add, Text, x92 y100 w70 h20 vPrev3sRank +Center, No Data
	Gui, Add, Text, x172 y100 w70 h20 v3sChange +Center, No Data

	Gui, Add, Text, x22 y220 w60 h20 vCurr2sRank +Center, No Data
	Gui, Add, Text, x92 y220 w70 h20 vPrev2sRank +Center, No Data
	Gui, Add, Text, x172 y220 w70 h20 v2sChange +Center, No Data

	Gui, Add, Text, x22 y340 w60 h20 vCurr3SoloRank +Center, No Data
	Gui, Add, Text, x92 y340 w70 h20 vPrev3SoloRank +Center, No Data
	Gui, Add, Text, x172 y340 w70 h20 v3SoloChange +Center, No Data

	Gui, Add, Text, x22 y460 w60 h20 vCurr1sRank +Center, No Data
	Gui, Add, Text, x92 y460 w70 h20 vPrev1sRank +Center, No Data
	Gui, Add, Text, x172 y460 w70 h20 v1sChange +Center, No Data

	Gui, Add, Text, x292 y80 w70 h20 vGoals +Center, No Data
	Gui, Add, Text, x372 y80 w70 h20 vAssists +Center, No Data
	Gui, Add, Text, x292 y140 w70 h20 vShots +Center, No Data
	Gui, Add, Text, x372 y140 w70 h20 vSaves +Center, No Data
	Gui, Add, Text, x292 y200 w70 h20 vMVPs +Center, No Data

	Gui, Add, Text, x12 y500 w440 h30 vStatusText, %A_Space%

	Gui, Font, S10 CDefault Underline, Verdana
	Gui, Add, Text, x22 y50 w60 h40 +Center, Current Rank
	Gui, Add, Text, x92 y50 w70 h40 +Center, Previous Rank
	Gui, Add, Text, x172 y50 w70 h40 +Center, Rank Change
	Gui, Add, Text, x22 y170 w60 h40 +Center, Current Rank
	Gui, Add, Text, x92 y170 w70 h40 +Center, Previous Rank
	Gui, Add, Text, x172 y170 w70 h40 +Center, Rank Change
	Gui, Add, Text, x22 y290 w60 h40 +Center, Current Rank
	Gui, Add, Text, x92 y290 w70 h40 +Center, Previous Rank
	Gui, Add, Text, x172 y290 w70 h40 +Center, Rank Change
	Gui, Add, Text, x22 y410 w60 h40 +Center, Current Rank
	Gui, Add, Text, x92 y410 w70 h40 +Center, Previous Rank
	Gui, Add, Text, x172 y410 w70 h40 +Center, Rank Change
	Gui, Add, Text, x292 y50 w70 h20 +Center, Goals
	Gui, Add, Text, x372 y50 w70 h20 +Center, Assists
	Gui, Add, Text, x292 y110 w70 h20 +Center, Shots
	Gui, Add, Text, x372 y110 w70 h20 +Center, Saves
	Gui, Add, Text, x292 y170 w70 h20 +Center, MVPs
	; Generated using SmartGUI Creator 4.0
	Gui, Show, x2130 y10 h553 w470, RankGUI
	return
	
	GuiClose: ;Destroys the gui data when it is closed
	Gui, Destroy
	return
	}

CurrentRank(gameMode)
	{
		FileRead, OutputVar, %DataSource%
		;SearchString = Ranked Standard 3v3
		FoundPOS1 := RegExMatch(OutputVar, gameMode)
		FoundPOS2 := RegExMatch(OutputVar, "match__rating--value", Rank, FoundPOS1)
		FoundPOS3 := RegExMatch(OutputVar, ">", Rank, FoundPOS2)
		Rval := RegExMatch(OutputVar, "\d+,?\d*", Rank, FoundPOS3)
		Rank := StrReplace(Rank, ",")
		;StringReplace, NumRank, Rank,% ",",,
		Return %Rank%
	}

	
InitializePerformanceStats:
	{
	IniRead, Goals, %iniLocation%, PerformanceStats, Goals
	IniRead, Saves, %iniLocation%, PerformanceStats, Saves
	IniRead, Shots, %iniLocation%, PerformanceStats, Shots
	IniRead, Assists, %iniLocation%, PerformanceStats, Assists
	IniRead, MVPs, %iniLocation%, PerformanceStats, MVPs
		
		;Checks if these categories exist in the ini file. If not, they're created and filled with "No Data"
		If (Goals == "ERROR")
			{
			IniWrite, 0, %iniLocation%, PerformanceStats, Goals ;Defaults the key to 0 if missing
			}
		If (Saves == "ERROR")
			{
			IniWrite, 0, %iniLocation%, PerformanceStats, Saves ;Defaults the key to 0 if missing
			}
		If (Shots == "ERROR")
			{
			IniWrite, 0, %iniLocation%, PerformanceStats, Shots ;Defaults the key to 0 if missing
			}
		If (Assists == "ERROR")
			{
			IniWrite, 0, %iniLocation%, PerformanceStats, Assists ;Defaults the key to 0 if missing
			}
		If (MVPs == "ERROR")
			{
			IniWrite, 0, %iniLocation%, PerformanceStats, MVPs ;Defaults the key to 0 if missing
			}
	
	Gui +LastFound ;Sets gui control to the last found ahk gui.
	GuiControl,,StatusText,Downloading Initial Stats... ;Changes the text "StatusText" to "Updating..."
	
	
	;##########################################
	UrlDownloadToFile https://rocketleague.tracker.network/rocket-league/profile/steam/76561198067409816/overview, %folderLoc%RLData.txt
	;UrlDownloadToFile https://rocketleague.tracker.network/rocket-league/profile/steam/76561198067409816/overview, %folderLoc%RL_PData.txt
	;##########################################
	
	Goals := GetPerformanceStat("Goals")
	Saves := GetPerformanceStat("Saves")
	Shots := GetPerformanceStat("Shots")
	Assists := GetPerformanceStat("Assists")
	MVPs := GetPerformanceStat("MVPs")
	
	
	If Goals is not integer
		Goals := 0
	If Saves is not integer
		Saves := 0
	If Shots is not integer
		Shots := 0
	If Assists is not integer
		Assists := 0
	If MVPs is not integer
		MVPs := 0
		
	IniWrite, %Goals%, %iniLocation%, PerformanceStats, Goals
	IniWrite, %Saves%, %iniLocation%, PerformanceStats, Saves
	IniWrite, %Shots%, %iniLocation%, PerformanceStats, Shots
	IniWrite, %Assists%, %iniLocation%, PerformanceStats, Assists
	IniWrite, %MVPs%, %iniLocation%, PerformanceStats, MVPs		
	return
	}		
	
UpdatePerformanceStats:
	{
	;UrlDownloadToFile https://rocketleague.tracker.network/profile/steam/76561198067409816, %folderLoc%RL_PData.txt
	IniRead, iniGoals, %iniLocation%, PerformanceStats, Goals
	IniRead, iniSaves, %iniLocation%, PerformanceStats, Saves
	IniRead, iniShots, %iniLocation%, PerformanceStats, Shots
	IniRead, iniAssists, %iniLocation%, PerformanceStats, Assists
	IniRead, iniMVPs, %iniLocation%, PerformanceStats, MVPs
	
	Goals := GetPerformanceStat("Goals")
	Saves := GetPerformanceStat("Saves")
	Shots := GetPerformanceStat("Shots")
	Assists := GetPerformanceStat("Assists")
	MVPs := GetPerformanceStat("MVPs")
	
	If (Goals != iniGoals) ;changed
		{
			IniWrite, %Goals%, %iniLocation%, PerformanceStats, Goals
			goalChange := Goals - iniGoals
		}	
	If (Saves != iniSaves) ;changed
		{
			IniWrite, %Saves%, %iniLocation%, PerformanceStats, Saves
			saveChange := Saves - iniSaves
		}			
	If (Shots != iniShots) ;changed
		{
			IniWrite, %Shots%, %iniLocation%, PerformanceStats, Shots
			shotChange := Shots - iniShots
		}	
	If (Assists != iniAssists) ;changed
		{
			IniWrite, %Assists%, %iniLocation%, PerformanceStats, Assists
			assistChange := Assists - iniAssists
		}
	If (MVPs != iniMVPs) ;changed
		{
			IniWrite, %MVPs%, %iniLocation%, PerformanceStats, MVPs
			mvpChange := MVPs - iniMVPs
		}
	
	Msgbox %goalChange%, %saveChange%, 
	;Msgbox %Saves%
	;Msgbox %Shots%
	return
	}

	
GetPerformanceStat(requestedStat)
	{
	FileRead, OutputVar, %FolderLoc%RLData.txt.
	FoundPOS1 := RegExMatch(OutputVar, "<span title=""" . requestedStat . """ class=""name"" data-")
	FoundPOS2 := RegExMatch(OutputVar, "span class=""value""", PData, FoundPOS1)
	FoundPOS3 := RegExMatch(OutputVar, ">\d+,?\d+", PData, FoundPOS2)
	PData := StrReplace(PData, ">")
	PData := StrReplace(PData, ",")
	return %PData%
	}
		
	