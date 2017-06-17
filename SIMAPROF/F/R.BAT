del *.obj
del ..\SimaProf.*
call lnk\MakeProf %1
cd ..
SimaProf
cd f