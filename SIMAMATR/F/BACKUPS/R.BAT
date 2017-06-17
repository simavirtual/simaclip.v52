echo off

del \SimaClip.v52\SimaMatr\f\objs\*.obj

copy \SimaClip.v52\SimaMatr\f\*.obj \SimaClip.v52\SimaMatr\f\objs
del *.obj

del ..\*.exe
del ..\*.ovl
call lnk\MakeMatr %1

cd ..
SimaMatr
cd f