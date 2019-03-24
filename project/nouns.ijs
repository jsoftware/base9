NB. project nouns
NB.
NB. when new files are added to a project, by default the files
NB. are added as jpath names. The conversion method:
NB.  - searches for the best fit, i.e. the jpath id that results in
NB.    the shortest remaining name.
NB.  - if no jpath id fits the name, then check for parents of the
NB.    current lookin folder, as long as they are below the root
NB.  - if no parent of the current lookin folder matches, then the
NB.    full path name is used.
NB.
NB. directory paths do not end in separator
NB.
NB. ---------------------------------------------------------
NB. definitions:
NB. Project           project filename (full name)
NB. ProjectPath       project path (full path)
NB. ProjectName       project name (short name)
NB.
NB. ---------------------------------------------------------
NB. read from the projectfile:
NB. Build             build script
NB. Run               run script
NB. Source            source files
NB.
NB. ---------------------------------------------------------
NB. other:
NB. PPScript          pretty print script

PPScript=: jpath '~system/util/pp.ijs'
Project=: ProjectPath=: ProjectName=: ''
