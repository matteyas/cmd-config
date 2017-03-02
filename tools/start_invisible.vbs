set args = WScript.Arguments
num = args.Count

if num = 0 then
    WScript.Echo "Usage: <cscript | wscript> start_invisible.vbs <executable> [arguments]"
    WScript.Echo " note: <required> [optional] one|or_the_other"
    WScript.Quit 1
end if

sargs = ""
if num > 1 then
    sargs = " "
    for k = 1 to num - 1
        anArg = args.Item(k)
        sargs = sargs & anArg & " "
    next
end if

Set WshShell = WScript.CreateObject("WScript.Shell")

WshShell.Run """" & WScript.Arguments(0) & """" & sargs, 0, False