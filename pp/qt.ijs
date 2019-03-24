NB. qt
NB.
NB. cover for pplint from qt

pplintqt=: 3 : 0
res=. pplint y
if. (0=#res) +. res-:y do. '' return. end.
if. 0=L.res do. '0',res return. end.
'line msg'=. res
'1',(":line),' ',msg
)
