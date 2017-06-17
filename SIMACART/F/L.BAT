del \SimaClip.v52\simacart\f\objs\CARTE417.obj
del \SimaClip.v52\simacart\f\objs\CART1259.obj
del \SimaClip.v52\simacart\f\objs\CARTE613.obj
del \SimaClip.v52\simacart\f\objs\CARTE614.obj
del \SimaClip.v52\simacart\f\objs\CARTE605.obj

del \SimaClip.v52\simacart\f\objs\OTRMOR6A.obj
del \SimaClip.v52\simacart\f\objs\OTRMOR9A.obj
del \SimaClip.v52\simacart\f\objs\OTREXT34.obj


clipper \SimaClip.v52\simacart\f\CARTE417 /w/m/b
clipper \SimaClip.v52\simacart\f\CART1259 /w/m/b
clipper \SimaClip.v52\simacart\f\CARTE613 /w/m/b
clipper \SimaClip.v52\simacart\f\CARTE614 /w/m/b
clipper \SimaClip.v52\simacart\f\CARTE605 /w/m/b

clipper \SimaClip.v52\simacart\f\funcions\OTRMOR6A /w/m/b
clipper \SimaClip.v52\simacart\f\funcions\OTRMOR9A /w/m/b
clipper \SimaClip.v52\simacart\f\funcions\OTRMOR9B /w/m/b
clipper \SimaClip.v52\simacart\f\funcions\OTREXT34 /w/m/b

copy *.obj \SimaClip.v52\simacart\f\objs
del  *.obj

del ..\pluscart.*
call lnk\Make %1
cd ..
pluscart
