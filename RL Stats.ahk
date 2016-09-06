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
;SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

return ;returns from initial load (otherwise it runs code until 1st return, i think anyway)

;^1::
;GoSub, CreateInitialGui
;GoSub, InitializeLocalData
;GoSub, InitialGuiRanks
;return

;^2::
;GoSub, RunningUpdate
;return

RunningUpdate:
	iniLocation = C:\Users\Ryan\Desktop\RL\iniRL.ini ;Change to global later
	IniRead, ini3sRank, %iniLocation%, 3v3Standard, CurrentRank
	IniRead, iniNumOf3sGames, %iniLocation%, 3v3Standard, CurrentGameCount
	IniRead, iniPrev3sRank, %iniLocation%, 3v3Standard, PreviousRank
	
	IniRead, ini2sRank, %iniLocation%, Doubles, CurrentRank
	IniRead, iniNumOf2sGames, %iniLocation%, Doubles, CurrentGameCount
	IniRead, iniPrev2sRank, %iniLocation%, Doubles, PreviousRank
	
	IniRead, ini3SoloRank, %iniLocation%, Solo Standard 3v3, CurrentRank
	IniRead, iniNumOf3SoloGames, %iniLocation%, Solo Standard 3v3, CurrentGameCount
	IniRead, iniPrev3SoloRank, %iniLocation%, Solo Standard 3v3, PreviousRank
	
	Gui +LastFound
	GuiControl,,StatusText,Updating...
	
	
	UrlDownloadToFile http://rocketleague.tracker.network/profile/steam/76561198067409816, C:\Users\Ryan\Desktop\RL\RLData.txt
	;msgbox NumberOf3sGames()
	
	
	newNumOf3sGames := NumberOf3sGames()
	new3sRank := Current3sRank()
	
	newNumOf2sGames := NumberOf2sGames()
	new2sRank := Current2sRank()
	
	newNumOf3SoloGames := NumberOf3SoloGames()
	new3SoloRank := Current3SoloRank()
	
	If (newNumOf3sGames = iniNumOf3sGames AND newNumOf2sGames = iniNumOf2sGames AND newNumOf3SoloGames = iniNumOf3SoloGames)
		{
			GuiControl,,StatusText,No Change
			return
		}
		
	If (newNumOf3sGames < iniNumOf3sGames)
		{
			GuiControl,,StatusText,Error in 3s Games
			return
		}
		
	If (newNumOf3SoloGames < iniNumOf3SoloGames)
		{
			GuiControl,,StatusText,Error in Standard Solo Games
			return
		}
	
	If (newNumOf2sGames < iniNumOf2sGames)
		{
			GuiControl,,StatusText,Error in 2s Games
			return
		}
	
	If (newNumOf3sGames > iniNumOf3sGames)
		{
			IniWrite, %ini3sRank%, %iniLocation%, 3v3Standard, PreviousRank
			IniWrite, %new3sRank%, %iniLocation%, 3v3Standard, CurrentRank
			IniWrite, %newNumOf3sGames%, %iniLocation%, 3v3Standard, CurrentGameCount
			rankChange := new3sRank - ini3sRank
				
			GuiControl,,Curr3sRank,%new3sRank%
			GuiControl,,Prev3sRank,%ini3sRank%
			GuiControl,,3sChange,%rankChange%
			GuiControl,,StatusText,New 3v3 Data
			return
		}
	
	If (newNumOf2sGames > iniNumOf2sGames)
		{
			IniWrite, %ini2sRank%, %iniLocation%, Doubles, PreviousRank
			IniWrite, %new2sRank%, %iniLocation%, Doubles, CurrentRank
			IniWrite, %newNumOf2sGames%, %iniLocation%, Doubles, CurrentGameCount
			rankChange := new2sRank - ini2sRank
				
			GuiControl,,Curr2sRank,%new2sRank%
			GuiControl,,Prev2sRank,%ini2sRank%
			GuiControl,,2sChange,%rankChange%
			GuiControl,,StatusText,New Doubles Data
			return
		}
		
	If (newNumOf3SoloGames > iniNumOf3SoloGames)
		{
			IniWrite, %ini3SoloRank%, %iniLocation%, Solo Standard 3v3, PreviousRank
			IniWrite, %new3SoloRank%, %iniLocation%, Solo Standard 3v3, CurrentRank
			IniWrite, %newNumOf3SoloGames%, %iniLocation%, Solo Standard 3v3, CurrentGameCount
			rankChange := new3SoloRank - ini3SoloRank
				
			GuiControl,,Curr3SoloRank,%new3SoloRank%
			GuiControl,,Prev3SoloRank,%ini3SoloRank%
			GuiControl,,3SoloChange,%rankChange%
			GuiControl,,StatusText,New Solo Standard 3v3 Data
			return
		}
return

InitialGuiRanks:
	iniLocation = C:\Users\Ryan\Desktop\RL\iniRL.ini ;Change to global later
	IniRead, ini3sRank, %iniLocation%, 3v3Standard, CurrentRank
	IniRead, iniPrev3sRank, %iniLocation%, 3v3Standard, PreviousRank
	IniRead, ini2sRank, %iniLocation%, Doubles, CurrentRank
	IniRead, iniPrev2sRank, %iniLocation%, Doubles, PreviousRank
	IniRead, ini3SoloRank, %iniLocation%, Solo Standard 3v3, CurrentRank
	IniRead, iniPrev3SoloRank, %iniLocation%, Solo Standard 3v3, PreviousRank

	Gui +LastFound
	GuiControl,,Curr3sRank,%ini3sRank%
	GuiControl,,Prev3sRank,%iniPrev3sRank%
	GuiControl,,Curr2sRank,%ini2sRank%
	GuiControl,,Prev2sRank,%iniPrev2sRank%
	GuiControl,,Curr3SoloRank,%ini3SoloRank%
	GuiControl,,Prev3SoloRank,%iniPrev3SoloRank%
	;GuiControl,,Prev3sRank,%iniPrev3sRank%
	
return

InitializeLocalData:
	iniLocation = C:\Users\Ryan\Desktop\RL\iniRL.ini
	
	;Checking for Standard 3v3 Data
	IniRead, ini3sRank, %iniLocation%, 3v3Standard, CurrentRank
	IniRead, iniNumOf3sGames, %iniLocation%, 3v3Standard, CurrentGameCount
	IniRead, iniPrev3sRank, %iniLocation%, 3v3Standard, PreviousRank
		
		If (ini3sRank == "ERROR")
			{
			IniWrite, 0, %iniLocation%, 3v3Standard, CurrentRank ;Defaults the key to 0 if missing
			}
		If (iniNumOf3sGames == "ERROR")
			{
			IniWrite, 0, %iniLocation%, 3v3Standard, CurrentGameCount ;Defaults the key to 0 if missing
			}
		If (iniPrev3sRank == "ERROR")
			{
			IniWrite, 0, %iniLocation%, 3v3Standard, PreviousRank ;Defaults the key to 0 if missing
			}
	
	;Checking for Doubles Data	
	IniRead, ini2sRank, %iniLocation%, Doubles, CurrentRank
	IniRead, iniNumOf2sGames, %iniLocation%, Doubles, CurrentGameCount
	IniRead, iniPrev2sRank, %iniLocation%, Doubles, PreviousRank
		
		If (ini2sRank == "ERROR")
			{
			IniWrite, 0, %iniLocation%, Doubles, CurrentRank ;Defaults the key to 0 if missing
			}
		If (iniNumOf2sGames == "ERROR")
			{
			IniWrite, 0, %iniLocation%, Doubles, CurrentGameCount ;Defaults the key to 0 if missing
			}
		If (iniPrev2sRank == "ERROR")
			{
			IniWrite, 0, %iniLocation%, Doubles, PreviousRank ;Defaults the key to 0 if missing
			}
	
	;Checking for Solo 3s Data	
	IniRead, ini3SoloRank, %iniLocation%, Solo Standard 3v3, CurrentRank
	IniRead, iniNumOf3SoloGames, %iniLocation%, Solo Standard 3v3, CurrentGameCount
	IniRead, iniPrev3SoloRank, %iniLocation%, Solo Standard 3v3, PreviousRank
		
		If (ini3SoloRank == "ERROR")
			{
			IniWrite, 0, %iniLocation%, Solo Standard 3v3, CurrentRank ;Defaults the key to 0 if missing
			}
		If (iniNumOf3SoloGames == "ERROR")
			{
			IniWrite, 0, %iniLocation%, Solo Standard 3v3, CurrentGameCount ;Defaults the key to 0 if missing
			}
		If (iniPrev3SoloRank == "ERROR")
			{
			IniWrite, 0, %iniLocation%, Solo Standard 3v3, PreviousRank ;Defaults the key to 0 if missing
			}
return

UpdateLocalData:
	UrlDownloadToFile http://rocketleague.tracker.network/profile/steam/76561198067409816, C:\Users\Ryan\Desktop\RL\RLData.txt

return



CreateInitialGui:
	Gui, +AlwaysOnTop +Owner
	Gui, Font, S8 CDefault, Verdana
	
	Gui, Add, GroupBox, x42 y20 w330 h70 , Standard 3v3
	Gui, Add, GroupBox, x42 y110 w330 h70 , Doubles
	Gui, Add, GroupBox, x42 y199 w330 h70 , Solo Standard
	
	Gui, Add, Text, x52 y60 w90 h20 vCurr3sRank +Center, No Data
	Gui, Add, Text, x162 y60 w90 h20 vPrev3sRank +Center, No Data
	Gui, Add, Text, x272 y60 w90 h20 v3sChange +Center, No Data
	
	Gui, Add, Text, x52 y150 w90 h20 vCurr2sRank +Center, No Data
	Gui, Add, Text, x162 y150 w90 h20 vPrev2sRank +Center, No Data
	Gui, Add, Text, x272 y150 w90 h20 v2sChange +Center, No Data
	
	Gui, Add, Text, x52 y239 w90 h20 vCurr3SoloRank +Center, No Data
	Gui, Add, Text, x162 y239 w90 h20 vPrev3SoloRank +Center, No Data
	Gui, Add, Text, x272 y239 w90 h20 v3SoloChange +Center, No Data
		
	Gui, Add, Text, x42 y279 w170 h20 vStatusText, %A_Space%

	Gui, Font, S8 CDefault Underline, Verdana
	Gui, Add, Text, x52 y40 w90 h20 +Center, Current Rank
	Gui, Add, Text, x162 y40 w90 h20 +Center, Previous Rank
	Gui, Add, Text, x272 y40 w90 h20 +Center, Change
	Gui, Add, Text, x52 y130 w90 h20 +Center, Current Rank
	Gui, Add, Text, x162 y130 w90 h20 +Center, Previous Rank
	Gui, Add, Text, x272 y130 w90 h20 +Center, Change
	Gui, Add, Text, x52 y219 w90 h20 +Center, Current Rank
	Gui, Add, Text, x162 y219 w90 h20 +Center, Previous Rank
	Gui, Add, Text, x272 y219 w90 h20 +Center, Change
	
	Gui, Show, x298 y167 h320 w420, RankGUI
	return
	
	GuiClose:
	Gui, Destroy
	return

Current3SoloRank() 
	{
		FileRead, OutputVar, C:\Users\Ryan\Desktop\RL\RLData.txt
		;SearchString = Ranked Standard 3v3
		FoundPOS1 := RegExMatch(OutputVar, "Ranked Solo Standard 3v3")
		FoundPOS2 := RegExMatch(OutputVar, "center;.>[\r\n].+\d{3}", 3soloRank, FoundPOS1)
		Rval := RegExMatch(OutputVar, "\d{3}", 3soloRank, FoundPOS2)
		Return %3soloRank%
	}

NumberOf3SoloGames()
	{
		FileRead, OutputVar, C:\Users\Ryan\Desktop\RL\RLData.txt
		;SearchString = Ranked Standard 3v3
		FoundPOS1 := RegExMatch(OutputVar, "Ranked Solo Standard 3v3")
		FoundPOS2 := RegExMatch(OutputVar, "center;.>[\r\n].+\d{3}", NumOfGames, FoundPOS1)
		FoundPOS3 := RegExMatch(OutputVar, "center;.>[\r\n].+\d{3,}[\r\n]", NumOfGames, FoundPOS2+10)
		Rval := RegExMatch(OutputVar, "\d+", NumOfGames, FoundPOS3)
		Return %NumOfGames%
	}	

Current3sRank() 
	{
		FileRead, OutputVar, C:\Users\Ryan\Desktop\RL\RLData.txt
		;SearchString = Ranked Standard 3v3
		FoundPOS1 := RegExMatch(OutputVar, "Ranked Standard 3v3")
		FoundPOS2 := RegExMatch(OutputVar, "center;.>[\r\n].+\d{3}", 3sRank, FoundPOS1)
		Rval := RegExMatch(OutputVar, "\d+", 3sRank, FoundPOS2)
		Return %3sRank%
	}
	
NumberOf3sGames()
	{
		FileRead, OutputVar, C:\Users\Ryan\Desktop\RL\RLData.txt
		;SearchString = Ranked Standard 3v3
		FoundPOS1 := RegExMatch(OutputVar, "Ranked Standard 3v3")
		FoundPOS2 := RegExMatch(OutputVar, "center;.>[\r\n].+\d{3}", NumOfGames, FoundPOS1)
		FoundPOS3 := RegExMatch(OutputVar, "center;.>[\r\n].+\d{3,}[\r\n]", NumOfGames, FoundPOS2+10)
		Rval := RegExMatch(OutputVar, "\d+", NumOfGames, FoundPOS3)
		Return %NumOfGames%
	}

Current2sRank() 
	{
		FileRead, OutputVar, C:\Users\Ryan\Desktop\RL\RLData.txt
		;SearchString = Ranked Standard 3v3
		FoundPOS1 := RegExMatch(OutputVar, "Ranked Doubles 2v2")
		;FoundPOS2 := RegExMatch(OutputVar, "color:red\D+\d+.+",matchVar,FoundPOS1)
		FoundPOS3 := RegExMatch(OutputVar, "center;.>[\r\n].+\d{3,4}", matchVar, FoundPOS1)
		Rval := RegExMatch(OutputVar, "\d+", 2sRank, FoundPOS3)
		Return %2sRank%
	}

NumberOf2sGames()
	{
		FileRead, OutputVar, C:\Users\Ryan\Desktop\RL\RLData.txt
		;SearchString = Ranked Standard 3v3
		FoundPOS1 := RegExMatch(OutputVar, "Ranked Doubles 2v2")
		FoundPOS2 := RegExMatch(OutputVar, "center;.>[\r\n].+\d{3,4}", NumOfGames, FoundPOS1) ;Rank Position
		FoundPOS3 := RegExMatch(OutputVar, "center;.>[\r\n].+\d{3,4}", NumOfGames, FoundPOS2+80)
		;FoundPOS4 := RegExMatch(OutputVar, "center;.>[\r\n].+\d+[\r\n]", NumOfGames, FoundPOS3+10)
		Rval := RegExMatch(OutputVar, "\d+", NumOfGames, FoundPOS3)
		Return %NumOfGames%
	}