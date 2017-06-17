del \SimaClip.v52\SimaCont\f\objs\*.obj

del ..\pluscont.*

call lnk\MakeCont %1
cd ..
pluscont
cd f