use MAEALU.DAT

USE MAEALU.DAT
REPL ALL cCodigoGru WITH SUBS(CURSO,AT('-',CURSO)+1,4)
REPL ALL cCodigoEst WITH STR(CODIGO,6)
CLOSE DATA


/*
use maejar11.dat
zap
append from mae2011.dat for val(subs(cCodigoGru,1,2)) > 11


use maepri11.dat
zap
append from mae2011.dat for val(subs(cCodigoGru,1,2)) <= 5

use maebto11.dat
zap
append from mae2011.dat for val(subs(cCodigoGru,1,2)) >= 6 .and. val(subs(cCodigoGru,1,2)) <= 11
*/
