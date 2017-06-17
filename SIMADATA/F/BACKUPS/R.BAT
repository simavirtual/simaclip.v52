del *.obj
del ..\simadata.*
call lnk\Make %1
cd ..
simadata
cd f