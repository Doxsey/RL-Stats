# RL-Stats

Hello Postmaster.

This was written for autohotkey. I'm sorry. (autohotkey.com)

As it stands, it is hard-coded for me only. I also have a different function for each type of game mode. I would like to change it to a single function and just pass in the desired game mode info. I'll only do this if there's more interest than just me.
***
I have two hot-key functions set for this:

1. The first one loads the GUI and the saved data. The functions called to do this are:
 * CreateInitialGui
 * InitializeLocalData
 * InitialGuiRanks

2. Once the GUI is loaded, I have a hot-key to check for updated data. This function is:
 * RunningUpdate

***
I created RL Stats.ahk that contains the functions and the code. AHK has a main file called AutoHotkey.ahk that stores the main code. Within AutoHotkey.ahk I have this:

```c
#include C:\Users\Ryan\Desktop\RL\Repository\RL-Stats\RL Stats.ahk

^1:: ;Creates the initial GUI and loads the stats. Ctrl+1 activates this function.
GoSub, CreateInitialGui
GoSub, InitializeLocalData
GoSub, InitialGuiRanks
return

^2::  ;Checks for updates. Ctrl+2 activates this function.
GoSub, RunningUpdate
return
```
***
