NB. task main

NB. =========================================================
NB.*fork v run task and optionally wait for completion
NB.
NB. form: [timeout=0] fork cmdline
NB.
NB.   timeout: 0 no wait, _1 infinite, >0 timeout
NB.   cmdline: 'shortcmd arg1 arg2 ...'
NB.   cmdline: '"command with space" arg1 ...'
NB.
NB. e.g. fork_jtask_ 'notepad.exe'
fork=: (3 : 0)`([: 2!:1 '(' , ')&' ,~ ])@.IFUNIX
0 fork y
:
ph=. CreateProcess y
if. x do. Wait ph;x end.
CloseHandle ph
empty''
)

NB. =========================================================
NB.*spawn v [monad] get stdout of executed task
NB.
NB. form:  stdout=. spawn cmdline
NB.
NB.   stdout: _1 fail, '' or stdout stream value if success
NB.   cmdline: 'shortcmd arg1 arg2 ...'
NB.   cmdline: '"command with space" arg1 ...'
NB.
NB. e.g. spawn 'net users'

NB.*spawn v [dyad] send stdin and get stdout of task
NB.
NB. form: stdout=. [stdin=''] spawn cmdline
NB.
NB.   stdin: input to stream as stdin, '' no input
NB.
NB. e.g. 'i.3 4'spawn'jconsole'
spawn=: (3 : 0)`(2!:0@])@.IFUNIX
'' spawn y
:
'or ow'=. CreatePipe 1
'ir iw'=. CreatePipe 2,#x
ph=. (ow,ir) CreateProcess y
CloseHandle ir
if. #x do. x WriteAll iw end.
CloseHandle iw
CloseHandle ow
r=. ReadAll or
CloseHandle or
CloseHandle ph
r
)

NB. =========================================================
NB.*shell v [monad] get stdout of shell command
NB.
NB.   e.g. shell 'dir /b/s'

NB.*shell v [dyad] send stdin and get stdout of shell command
NB.
NB.   e.g. (shell 'dir /b/s') shell 'find ".dll"'
SHELL=: IFUNIX{::'cmd /c ';''

shell=: ''&$: : (spawn SHELL,])

NB. =========================================================
NB.*launch v [monad] launch default application for parameter
NB.
NB.    launch jpath'~system'              NB. file manager
NB.    launch jpath'~bin/installer.txt'   NB. text editor
NB.    launch 'http://jsoftware.com'      NB. web browser

3 : 0''
LAUNCH=: ('gnome-open';'open';'start';'') {::~ ('Linux';'Darwin';'Win')i.<UNAME
if. 0=nc<'LAUNCH_j_'do.if. 0<#LAUNCH_j_ do.LAUNCH=: LAUNCH_j_ end.end.
)
launch=: 3 : 'shell LAUNCH,'' '',y'
