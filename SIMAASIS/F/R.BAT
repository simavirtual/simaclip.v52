del *.obj
del ..\SimaAsis.*
call lnk\Make %1
cd ..
SimaAsis
cd f