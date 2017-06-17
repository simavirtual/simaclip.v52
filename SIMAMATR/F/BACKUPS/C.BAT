clipper \SimaClip.v52\SimaMatr\f\SimaMatr /w/m/b
clipper \SimaClip.v52\SimaMatr\f\Matri101 /w/m/b
clipper \SimaClip.v52\SimaMatr\f\Matri102 /w/m/b
clipper \SimaClip.v52\SimaMatr\f\Matri103 /w/m/b
clipper \SimaClip.v52\SimaMatr\f\Matri104 /w/m/b
clipper \SimaClip.v52\SimaMatr\f\Matri201 /w/m/b
clipper \SimaClip.v52\SimaMatr\f\Matri202 /w/m/b
clipper \SimaClip.v52\SimaMatr\f\Matri203 /w/m/b
clipper \SimaClip.v52\SimaMatr\f\Matri301 /w/m/b
clipper \SimaClip.v52\SimaMatr\f\Matri302 /w/m/b
clipper \SimaClip.v52\SimaMatr\f\Matri303 /w/m/b
clipper \SimaClip.v52\SimaMatr\f\Matri304 /w/m/b
clipper \SimaClip.v52\SimaMatr\f\Matri401 /w/m/b
clipper \SimaClip.v52\SimaMatr\f\Matri402 /w/m/b
clipper \SimaClip.v52\SimaMatr\f\Matri403 /w/m/b
clipper \SimaClip.v52\SimaMatr\f\Matri501 /w/m/b
clipper \SimaClip.v52\SimaMatr\f\Matri601 /w/m/b
clipper \SimaClip.v52\SimaMatr\f\Matri705 /w/m/b

copy *.obj objs
RTLINK @SimaMatr
del *.obj
cd ..
SimaMatr
