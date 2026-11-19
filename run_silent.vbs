' Launch PortronicsKeepAlive.ps1 completely hidden with NO black console popup
Set WshShell = CreateObject("WScript.Shell")
scriptDir = CreateObject("Scripting.FileSystemObject").GetParentFolderName(WScript.ScriptFullName)
psCommand = "powershell.exe -ExecutionPolicy Bypass -NoProfile -WindowStyle Hidden -File """ & scriptDir & "\PortronicsKeepAlive.ps1"""
WshShell.Run psCommand, 0, False
