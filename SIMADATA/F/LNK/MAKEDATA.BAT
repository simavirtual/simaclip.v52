@ECHO OFF

echo RMAKE DEL SIMA
IF %1==1 GOTO Rtlink
IF %1==2 GOTO Blinker4
IF %1==3 GOTO Blinker1
IF %1==4 GOTO ExoSpace
IF %1==5 GOTO CauseWay
GOTO Blinker4

:Rtlink
echo Rtlink
rmake \SimaClip.v52\SimaCart\f\Lnk\PlusCart /dRTLINK /XW5000
GOTO QUIT

:Blinker4
echo Blinker Versi¢n 4.0
rmake \SimaClip.v52\SimaCart\f\Lnk\PlusCart /dBLINKER4 /XW5000
GOTO QUIT

:Blinker1
echo Blinker Versi¢n 1.0
Rmake \SimaClip.v52\SimaCart\f\Lnk\PlusCart /dBLINKER1 /XW5000
GOTO QUIT

:ExoSpace
echo ExoSpace
Rmake \SimaClip.v52\SimaCart\f\Lnk\PlusCart /dEXOSPACE /XW5000
GOTO QUIT

:CauseWay
echo CauseWay
Rmake \SimaClip.v52\SimaCart\f\Lnk\PlusCart /dCAUSEWAY /XW5000
GOTO QUIT

:QUIT
