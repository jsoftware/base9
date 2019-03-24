NB. task
NB.
NB. executing tasks with optional timeout or I/O
NB.
NB. TASKS WITHOUT I/O
NB.
NB.   fork_jtask_ 'notepad.exe'           NB. run notepad, no wait, no I/O
NB.   5000 fork_jtask_ 'notepad.exe'      NB. run notepad, wait 5 sec, no I/O
NB.   _1 fork_jtask_ 'notepad.exe'        NB. run notepad, until closed, no I/O
NB.
NB.   5000 fork_jtask_ 'cmd /k dir'  NB. show dir in cmd window for 5 sec and close
NB.   _1 fork_jtask_ 'cmd /k dir'    NB. show dir in cmd window until user closes it
NB.
NB.   launch jpath'~system'        NB. run default application, no wait
NB.
NB. TASKS WITH I/O
NB.
NB.   spawn_jtask_ 'net users'                    NB. get stdout from process
NB.   '+/i.3 4' spawn_jtask_ 'jconsole'           NB. call process with I/O
NB.   12 15 18 21
NB.
NB. SHELL COMMANDS (WITH I/O)
NB.
NB.   shell'echo.|time'                    NB. get result of shell command
NB. The current time is:  8:04:13.09
NB. Enter the new time:
NB.
NB.   (shell'dir /b')shell'find ".dll"'    NB. get all DDL names by piping
NB. j.dll
NB. jregexp.dll
NB.
NB. NOTE: the implementation uses C-type structures
NB.       by the original Method of Named Fields
NB.
NB. Script developed by Oleg Kobchenko.

coclass <'jtask'
