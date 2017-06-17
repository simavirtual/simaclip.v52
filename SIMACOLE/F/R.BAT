del *.obj
del ..\simacole.*
call lnk\MakeCOL %1
cd ..
simacole
cd f