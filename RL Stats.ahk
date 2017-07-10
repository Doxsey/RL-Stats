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
#include C:\Users\Ryan\Documents\RLScript\RL_DB.ahk
;SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

return ;returns from initial load (otherwise it runs code until 1st return, i think anyway)


RunningUpdate:
	;An ini file is used to store old rank and current rank for each game mode
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
	
	Gui +LastFound ;Sets gui control to the last found ahk gui.
	GuiControl,,StatusText,Updating... ;Changes the text "StatusText" to "Updating..."
	
	

	UrlDownloadToFile http://rocketleague.tracker.network/profile/steam/76561198067409816, C:\Users\Ryan\Desktop\RL\RLData.txt ;Downloads the URL source to the file RLData.txt
	
	;####################################################################
	
	
	
	
	newNumOf3sGames := NumberOfGames("Ranked Standard 3v3") ;Calls NumberOf3sGames function to get the new # of games played
	new3sRank := CurrentRank("Ranked Standard 3v3") ;Calls Current3sRank function to get new 3s rank
	
	newNumOf2sGames := NumberOfGames("Ranked Doubles 2v2") ;Calls NumberOf2sGames function to get the new # of games played
	new2sRank := CurrentRank("Ranked Doubles 2v2") ;Calls Current2sRank function to get new 2s rank
	
	newNumOf3SoloGames := NumberOfGames("Ranked Solo Standard 3v3") ;see above
	new3SoloRank := CurrentRank("Ranked Solo Standard 3v3") ;see above
	
		
	
	;Checks to see if the number of games played is the same for all 3 game modes (aka, no new data)
	If (newNumOf3sGames = iniNumOf3sGames AND newNumOf2sGames = iniNumOf2sGames AND newNumOf3SoloGames = iniNumOf3SoloGames)
		{
			GuiControl,,StatusText,No Change
			return
		}
	
	;Checks to see if the number of gmaes played has decreased, which indicates a scraping error (or RegEx error)
	If (newNumOf3sGames < iniNumOf3sGames)
		{
			GuiControl,,StatusText,Error in 3s Games
			return
		}
	
	;Checks to see if the number of gmaes played has decreased, which indicates a scraping error (or RegEx error)	
	If (newNumOf3SoloGames < iniNumOf3SoloGames)
		{
			GuiControl,,StatusText,Error in Std Solo Games
			return
		}
	
	;Checks to see if the number of gmaes played has decreased, which indicates a scraping error (or RegEx error)
	If (newNumOf2sGames < iniNumOf2sGames)
		{
			GuiControl,,StatusText,Error in 2s Games
			return
		}
	
	;Number of games has increased indicating new data. Writes the new data to the ini file and updates the gui
	If (newNumOf3sGames > iniNumOf3sGames)
		{
			IniWrite, %ini3sRank%, %iniLocation%, 3v3Standard, PreviousRank
			IniWrite, %new3sRank%, %iniLocation%, 3v3Standard, CurrentRank
			IniWrite, %newNumOf3sGames%, %iniLocation%, 3v3Standard, CurrentGameCount
			rankChange := new3sRank - ini3sRank
			
			UrlDownloadToFile http://rl.doxseycircus.com/insRL.php?GameMode=4&PreviousRank=%ini3sRank%&CurrentRank=%new3sRank%&Change=%rankChange%, C:\Users\Ryan\Desktop\RL\DB_Response.txt ;Downloads the URL source to the file RLData.txt
			FileRead, OutputVar, C:\Users\Ryan\Desktop\RL\DB_Response.txt
			;msgbox %OutputVar%
			If (OutputVar != "Data Sent")
						{
						msgbox "Error in DB Send"
						}
				
			GuiControl,,Curr3sRank,%new3sRank%
			GuiControl,,Prev3sRank,%ini3sRank%
			GuiControl,,3sChange,%rankChange%
			GuiControl,,StatusText,New 3v3 Data
			return
		}
	
	;Number of games has increased indicating new data. Writes the new data to the ini file and updates the gui
	If (newNumOf2sGames > iniNumOf2sGames)
		{
			IniWrite, %ini2sRank%, %iniLocation%, Doubles, PreviousRank
			IniWrite, %new2sRank%, %iniLocation%, Doubles, CurrentRank
			IniWrite, %newNumOf2sGames%, %iniLocation%, Doubles, CurrentGameCount
			rankChange := new2sRank - ini2sRank
			
			UrlDownloadToFile http://rl.doxseycircus.com/insRL.php?GameMode=2&PreviousRank=%ini2sRank%&CurrentRank=%new2sRank%&Change=%rankChange%, C:\Users\Ryan\Desktop\RL\DB_Response.txt ;Downloads the URL source to the file RLData.txt
			FileRead, OutputVar, C:\Users\Ryan\Desktop\RL\DB_Response.txt
			;msgbox %OutputVar%
			If (OutputVar != "Data Sent")
						{
						msgbox "Error in DB Send"
						}
			
			GuiControl,,Curr2sRank,%new2sRank%
			GuiControl,,Prev2sRank,%ini2sRank%
			GuiControl,,2sChange,%rankChange%
			GuiControl,,StatusText,New Doubles Data
			return
		}
	
	;Number of games has increased indicating new data. Writes the new data to the ini file and updates the gui	
	If (newNumOf3SoloGames > iniNumOf3SoloGames)
		{
			IniWrite, %ini3SoloRank%, %iniLocation%, Solo Standard 3v3, PreviousRank
			IniWrite, %new3SoloRank%, %iniLocation%, Solo Standard 3v3, CurrentRank
			IniWrite, %newNumOf3SoloGames%, %iniLocation%, Solo Standard 3v3, CurrentGameCount
			rankChange := new3SoloRank - ini3SoloRank
			
			UrlDownloadToFile http://rl.doxseycircus.com/insRL.php?GameMode=3&PreviousRank=%ini3SoloRank%&CurrentRank=%new3SoloRank%&Change=%rankChange%, C:\Users\Ryan\Desktop\RL\DB_Response.txt ;Downloads the URL source to the file RLData.txt
			FileRead, OutputVar, C:\Users\Ryan\Desktop\RL\DB_Response.txt
			;msgbox %OutputVar%
			If (OutputVar != "Data Sent")
						{
						msgbox "Error in DB Send"
						}
			
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
		
		;Checks if these categories exist in the ini file. If not, they're created and filled with "No Data"
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
		
		;Checks if these categories exist in the ini file. If not, they're created and filled with "No Data"
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
		
		;Checks if these categories exist in the ini file. If not, they're created and filled with "No Data"
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



CreateInitialGui: ;Creates the gui window. SmartGUI creator was used to do this.
	Gui, +AlwaysOnTop +Owner
	Gui, Font, S8 CDefault, Verdana
	
	Gui, Add, GroupBox, x42 y20 w330 h70 , Standard 3v3
	Gui, Add, GroupBox, x42 y110 w330 h70 , Doubles
	Gui, Add, GroupBox, x42 y199 w330 h70 , Solo Standard
	
	;Note: the "v" before the names indicates a variable name. So "vCurr3sRank" is a text field with the variable name "Curr3sRank"
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
	
	Gui, Show, x2130 y10 h320 w420, RankGUI
	return
	
	GuiClose: ;Destroys the gui data when it is closed
	Gui, Destroy
	return


CurrentRank(gameMode) 
	{
		FileRead, OutputVar, C:\Users\Ryan\Desktop\RL\RLData.txt
		;SearchString = Ranked Standard 3v3
		FoundPOS1 := RegExMatch(OutputVar, gameMode)
		FoundPOS2 := RegExMatch(OutputVar, "season-rank", Rank, FoundPOS1)
		Rval := RegExMatch(OutputVar, "[\d,]+", Rank, FoundPOS2-115)
		StringReplace, NumRank, Rank,% ",",,
		Return %NumRank%
	}	
	
	
NumberOfGames(gameMode)
	{
		FileRead, OutputVar, C:\Users\Ryan\Desktop\RL\RLData.txt
		;SearchString = Ranked Standard 3v3
		FoundPOS1 := RegExMatch(OutputVar, gameMode)
		FoundPOS2 := RegExMatch(OutputVar, "\/tr", NumOfGames, FoundPOS1)
			;Looks for "Win Streak" text. Changes the offset if the win streak text is there
				winStreak := RegExMatch(OutputVar, "small", NumOfGames, FoundPOS2-130)
				possWinStreak := (FoundPOS2-winStreak)
				if (FoundPOS2-winStreak > 0)
					{
						FoundPOS3 := RegExMatch(OutputVar, "\d{1,4}", NumOfGames, FoundPOS2-380)
						Return %NumOfGames%
					}
		FoundPOS3 := RegExMatch(OutputVar, "\d{1,4}", NumOfGames, FoundPOS2-150)
		
		Return %NumOfGames%
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
