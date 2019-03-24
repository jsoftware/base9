NB. Examples.  Run each with Ctrl+R.  Watch .ijx window

0 : 0
fork_jtask_ 'notepad.exe'           NB. run notepad, no wait, no I/O
5000 fork_jtask_ 'notepad.exe'      NB. run notepad, wait 5 sec, no I/O
_1 fork_jtask_ 'notepad.exe'        NB. run notepad, until closed, no I/O

5000 fork_jtask_ 'cmd /k dir'  NB. show dir in cmd window for 5 sec and close
_1 fork_jtask_ 'cmd /k dir'    NB. show dir in cmd window until user closes it

spawn_jtask_ 'net users'                 NB. get stdout from process
'i.3 4' spawn_jtask_ 'jconsole'          NB. call process with I/O

shell'echo.|time'                    NB. get result of shell command
(shell'dir /b/s')shell'find ".dll"'  NB. get all DDL names by piping
)
