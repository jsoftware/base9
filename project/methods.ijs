NB. methods
NB.
NB. projclear      clear project definitions
NB. projclose      close project
NB. projinit       initialize project manager (on first load)
NB. projopen       open a project
NB. projpathfolder set project folder globals from project path
NB. projreset      reset all project globals
NB. projrun        run project
NB. projsave       save project

NB. =========================================================
NB. clears globals defined for a given project
projclear=: 3 : 0
Build=: Run=: Source=: ''
)

NB. =========================================================
NB. close project
projclose=: 3 : 0
projreset''
)

NB. =========================================================
NB. initialize project manager
NB.
NB. argument is project to open, or empty for last project
projinit=: 3 : 0
if. 0-:FolderTree do. setfolder_j_ Folder end.
projopen y,(0=#y) # >{.RecentProjects
)

NB. =========================================================
NB. open project
NB. defines project globals
projopen=: 3 : 0
projreset''
if. 0=#y do. return. end.
Project=: getprojfile y
ProjectPath=: }: 0 pick fpathname Project
projpathfolder ProjectPath
if. #Folder do.
  p=. (#jpath '~',Folder,'/') }. ProjectPath
  ProjectName=: Folder,'/',p
else.
  ProjectName=: ''
end.
projread''
NB. recentproj_add_j_ Project
)

NB. =========================================================
NB. set project folder from project path
projpathfolder=: 3 : 0
p=. touserfolder y
f=. (p i. '/') {. p
if. ('~'={.f) *: (<}.f) e. {."1 UserFolders do.
  setfolder_j_ ''
else.
  setfolder_j_ }.f
end.
)

NB. =========================================================
NB. resets globals defined for a given project
projreset=: 3 : 0
projclear''
Project=: ProjectPath=: ProjectName=: ''
)

NB. =========================================================
projrun=: 3 : 0
if. #y do.
  p=. 0 pick fpathname getprojfile y
else.
  p=. ProjectPath,'/'
end.
load ::] p,Run
)

