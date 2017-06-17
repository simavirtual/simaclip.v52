/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : FIN DE A¥O
SUBMODULO...: HABILITACIONES         MODULO No. 515

**************************************************************************
* TITULO..: ORDENES DE HABILITACION                                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 20/1995 VIE A
       Colombia, Bucaramanga        INICIO: 12:35 PM   OCT 20/1995 VIE


OBJETIVOS:

1- Imprime las ¢rdenes de habilitaci¢n de todos los habilitantes o del
   estudiante especificado.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_514(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "EPSONFX.PRG"
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema
       #DEFINE  TAMPAGE CHR(27)+'C'+CHR(22) // P gina de 22 l¡neas
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cSavPan := ''                  // Salvar Pantalla

       LOCAL nCopias := 1                   // N£meros de copias a imprimir
       LOCAL nNroCop := 1                   // N£mero de copia

       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL nNroRec := 0                   // N£mero de recibos

       LOCAL aDetHab := {}                  // Detalles habilitantes
       LOCAL lPapSta := .T.                 // .T. Papel Estandar
       LOCAL lConden := .T.                 // .T. Condensado */

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // Modo de Protecci¢n
       LOCAL cCodSui := ''                  // C¢digo del Sistema
       LOCAL cNomSis := ''                  // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := ''                  // Nombre de la Empresa principal
       LOCAL cNitEmp := ''                  // Nit de la Empresa
       LOCAL cNomEmp := ''                  // Nombre de la Empresa
       LOCAL cNomSec := ''                  // Nombre de la Empresa Secundario
       LOCAL cCodEmp := ''                  // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := ''                  // Nombre del Usuario
       LOCAL cAnoUsr := ''                  // A¤o del usuario
       LOCAL cAnoSis := ''                  // A¤o del sistema
       LOCAL cPatSis := ''                  // Path del sistema
     *ÀDetalles del Usuario

       LOCAL nFilPal := 0                   // Fila Inferior Men£ principal
       LOCAL nFilInf := 0                   // Fila Inferior del SubMen£
       LOCAL nColInf := 0                   // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL PathW01 := ''                  // Sitio del Sistema No.01
       LOCAL PathW02 := ''                  // Sitio del Sistema No.02
       LOCAL PathW03 := ''                  // Sitio del Sistema No.03
       LOCAL PathW04 := ''                  // Sitio del Sistema No.04
       LOCAL PathW05 := ''                  // Sitio del Sistema No.05
       LOCAL PathW06 := ''                  // Sitio del Sistema No.06
       LOCAL PathW07 := ''                  // Sitio del Sistema No.07
       LOCAL PathW08 := ''                  // Sitio del Sistema No.08
       LOCAL PathW09 := ''                  // Sitio del Sistema No.09
       LOCAL PathW10 := ''                  // Sitio del Sistema No.10
     *ÀSitios del Sistema

       LOCAL PathUno := ''                  // Path de Integraci¢n Uno
       LOCAL PathDos := ''                  // Path de Integraci¢n Dos
       LOCAL PathTre := ''                  // Path de Integraci¢n Tres
       LOCAL PathCua := ''                  // Path de Integraci¢n Cuatro
     *ÀPath de Integraci¢n

       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cJorTxt := ''                  // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL aParams := {}                  // Parametros Generales
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>LECTURA PARAMETROS GENERALES
       aParams := aParams(aParam1,aParam2,aParam3)
       IF  !lParam0102(aParams,;
		       @lShared,@nModCry,@cCodSui,@cNomSis,;
		       @cEmpPal,@cNitEmp,@cNomEmp,@cNomSec,@cCodEmp,;
		       @cNomUsr,@cAnoUsr,@cAnoSis,@cPatSis,;
		       @nFilPal,@nFilInf,@nColInf,;
		       @PathW01,@PathW02,@PathW03,@PathW04,@PathW05,;
		       @PathW06,@PathW07,@PathW08,@PathW09,@PathW10,;
		       @PathUno,@PathDos,@PathTre,@PathCua,;
		       @cMaeAlu,@cMaeAct,@cJorTxt)
	  CloseAll()
	  RETURN NIL
       ENDIF
       CloseAll()
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimaCo,'SCO',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       fConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileMat+ExtFile,'MAT',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileAlu+cMaeAct+cAnoSis+ExtFile,'ALU',;
		       cPatSis+'\'+cMaeAct+'\'+;
		       fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared)
	  cError('ABRIENDO LOS ARCHIVOS DE ALUMNOS Y GRUPOS '+cPatSis)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL NIVEL DE '+cMaeAct)

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE NIV->(RECCOUNT()) == 0
	    cError('NO EXISTEN NIVELES GRABADOS')

       CASE ALU->(RECCOUNT()) == 0
	    cError('NO EXISTEN ALUMNOS GRABADOS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SCO->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>LECTURA DEL NUMERO DE COPIA
       nCopias := 1
       @ nFilInf+3,nColInf SAY 'NRO COPIAS:' GET nCopias PICT '99'
       READ
       IF nCopias == 0
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL NUMERO DE COPIA

*>>>>LECTURA DE LAS CARACTERISTICAS DE IMPRESION
       lPapSta := lPregunta('Desea imprimir en papel carta normal? Si No')
*      lConden := lPregunta('Forma de impresi¢n Condensado? Si No')
       lConden := .T.
*>>>>FIN LECTURA DE LAS CARACTERISTICAS DE IMPRESION

*>>>>CREACION DE ARCHIVO TEMPORAL DE HABILITANTES
       GraHabTem(cNomSis,cNomUsr,cPatSis+'\'+cMaeAct,;
		 cAnoUsr,1,GRU->(RECCOUNT()),TCO->nTotPerTbl)
*>>>>FIN CREACION DE ARCHIVO TEMPORAL DE HABILITANTES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,FileTem+SUBS(cNomUsr,1,3)+'.UNO','UNO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,FileTem+SUBS(cNomUsr,1,3)+'.DOS','DOS',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS TEMPORALES')
	  RETURN NIL
       ENDIF
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE UNO->(RECCOUNT()) == 0
	    cError('NO HAY HABILITANTES')

       CASE DOS->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS A HABILITAR. POR FAVOR REVISAR')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>ACTIVACION DE LA IMPRESORA
       IF !Printer_on()
	   RETURN NIL
       ENDIF

       IF lConden
	  @ PROW(),00 SAY INICIALIZA+PROPOR_OF+CONDEN_ON+TAMPAGE
       ELSE
	  @ PROW(),00 SAY INICIALIZA+PROPOR_OF+TAMPAGE
       ENDIF
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DE N COPIAS
       DO WHILE nNroCop <= nCopias

***********IMPRESION DEL TERMOMETRO
	     SET DEVICE TO SCREEN
	     Termometro(0,'IMPRIMIENDO LOS HABILITANTES COPIA No.'+;
			  STR(nNroCop,2)+'\'+STR(nCopias,2))
	     Termometro(10)
	     SET DEVICE TO PRINT
***********FIN IMPRESION DEL TERMOMETRO

***********IMPRESION DEL INFORME
	     SELECT DOS
	     GO TOP
	     nNroRec := 0
	     aDetHab := {}
	     DO WHILE .NOT. DOS->(EOF())

*---------------PREPARCION DE LA IMPRESION
		  nNroRec++
		  IF nNroRec <= IF(lPapSta,2,3)
		     AADD(aDetHab,{DOS->cCodigoGru,;
				   DOS->cCodigoEst,;
				   DOS->cNombreEst,;
				   DOS->cNombreMat})
		  ENDIF
*---------------FIN PREPARCION DE LA IMPRESION

*---------------IMPRESION DE LA ORDENES DE HABILITACION
		  IF nNroRec == IF(lPapSta,2,3)
		     OrdenHab(cNomEmp,cAnoUsr,cMaeAct,;
			      cJorTxt,aDetHab,lPapSta,lConden)
		     EJECT
		     nNroRec := 0
		     aDetHab := {}
		  ENDIF
*---------------FIN IMPRESION DE LA ORDENES DE HABILITACION

*---------------AVANCE DEL SIGUIENTE REGISTRO
		  nAvance := INT(( DOS->(RECNO()) / DOS->(RECCOUNT()) )*100)

		  IF STR(nAvance,3) $ '25 50 75100'
		     SET DEVICE TO SCREEN
		     Termometro(nAvance)
		     SET DEVICE TO PRINT
		  ENDIF

		  DOS->(DBSKIP())
*---------------FIN AVANCE DEL SIGUIENTE REGISTRO

	     ENDDO
***********IMPRESION DEL INFORME

	  nNroCop++

       ENDDO
*>>>>FIN IMPRESION DE N COPIAS

*>>>>IMPRESION DE LA ULTIMA ORDEN DE HABILITACION
       IF LEN(aDetHab) # 0
	  OrdenHab(cNomEmp,cAnoUsr,cMaeAct,;
		   cJorTxt,aDetHab,lPapSta,lConden)
       ENDIF

       CLOSE ALL
       lFileDelete(FileTem+SUBS(cNomUsr,1,3)+'.UNO')
       lFileDelete(FileTem+SUBS(cNomUsr,1,3)+'.DOS')
       lFileDelete(FileTem+SUBS(cNomUsr,1,3)+cExtTem)
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DE LA ULTIMA ORDEN DE HABILITACION


/*************************************************************************
* TITULO DE LA FUNCION..: IMPRESION DE ORDENES DE HABILITACION           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 20/95 VIE A
       Colombia, Bucaramanga        INICIO: 12:40 PM   OCT 20/95 VIE

OBJETIVOS:

1- Imprime las ¢rdenes de habilitaci¢n para el estudiante especificado

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OrdenHab(cNomEmp,cAnoUsr,cMaeAct,cJorTxt,aDetHab,lPapSta,lConden)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomEmp                              // Nombre de la empresa
       cAnoUsr			            // A¤o del sistema
       cMaeAct                              // Maestro habilitado
       cJorTxt                              // Jornada escogida
       aDetHab			            // Detalles habilitaci¢n
       lPapSta                              // .T. Papel Estandar
       lConden                              // .T. Condensado */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cNomNiv := ''                  // Nombre del nivel
       LOCAL nNroRec := 0                   // N£mero de recibo
       LOCAL nNroLin := 0                   // N£mero de l¡neas
       LOCAL nNroCol := 0                   // N£mero de columna
       LOCAL cTxtPrn := ''                  // Texto a imprimir
*>>>>FIN DECLARACION DE VARIABLES

*>>>>FIN DECLARACION DE PARAMETROS

*>>>>ANALISIS DEL NIVEL ESCOGIDO
       DO CASE
       CASE 'JAR' $ cMaeAct
	    cNomNiv := 'JARDIN'
       CASE 'PRI' $ cMaeAct
	    cNomNiv := 'PRIMARIA'
       CASE 'BTO' $ cMaeAct
	    cNomNiv := 'BACHILLERATO'
       ENDCASE
*>>>>FIN ANALISIS DEL NIVEL ESCOGIDO

*>>>>IMPRESION DEL NOMBRE DE LA EMPRESA
       nNroRec := LEN(aDetHab)
       FOR i := 1 TO nNroRec
	   nNroLin := IF(i==1,1,0)
	   IF lConden
	      nNroCol := nColRec(i,cNomEmp,lPapSta,lConden)
	   ELSE
	      nNroCol := nColRec(i,NIL,lPapSta,lConden)
	   ENDIF
	   @ PROW()+nNroLin,nNroCol SAY cNomEmp
       ENDFOR
*>>>>FIN IMPRESION DEL NOMBRE DE LA EMPRESA

*>>>>IMPRESION DEL NIVEL JORNADA Y A¥O
       cTxtPrn := cNomNiv+' '+cJorTxt+' DE '+cAnoUsr

       FOR i := 1 TO nNroRec
	   nNroLin := IF(i==1,1,00)
	   IF lConden
	      nNroCol := nColRec(i,cTxtPrn,lPapSta,lConden)
	   ELSE
	      nNroCol := nColRec(i,NIL,lPapSta,lConden)
	   ENDIF
	   @ PROW()+nNroLin,nNroCol SAY cTxtPrn
       ENDFOR
*>>>>FIN IMPRESION DEL NIVEL JORNADA Y A¥O

*>>>>IMPRESION DE LA ORDEN DE HABILITACION
       cTxtPrn := 'ORDEN DE HABILITACION'

       IF lConden
	  @ PROW(),00 SAY CONDEN_OF+NEGRA_ON
       ENDIF

       FOR i := 1 TO nNroRec
	   nNroLin := IF(i==1,2,00)
	   IF lConden
	      nNroCol := nColRec(i,cTxtPrn,lPapSta,.F.)
	   ELSE
	      nNroCol := nColRec(i,NIL,lPapSta,lConden)
	   ENDIF
	   @ PROW()+nNroLin,nNroCol SAY cTxtPrn

       ENDFOR
       IF lConden
	   @ PROW(),00 SAY CONDEN_ON+NEGRA_OF
       ENDIF
*>>>>FIN IMPRESION DE LA ORDEN DE HABILITACION

*>>>>IMPRESION DE LA MATERIA A HABILITAR
       FOR i := 1 TO nNroRec
	   cTxtPrn := 'PARA '+ALLTRIM(aDetHab[i,4])
	   nNroLin := IF(i==1,1,00)
	   IF lConden
	      nNroCol := nColRec(i,cTxtPrn,lPapSta,lConden)
	   ELSE
	      nNroCol := nColRec(i,NIL,lPapSta,lConden)
	   ENDIF
	   @ PROW()+nNroLin,nNroCol SAY cTxtPrn
       ENDFOR
*>>>>FIN IMPRESION DE LA MATERIA A HABILITAR

*>>>>IMPRESION DEL GRUPO
       FOR i := 1 TO nNroRec
	   cTxtPrn := 'GRUPO: '+aDetHab[i,1]
	   nNroLin := IF(i==1,2,00)
	   nNroCol := nColRec(i,NIL,lPapSta,lConden)
	   @ PROW()+nNroLin,nNroCol SAY cTxtPrn
       ENDFOR
*>>>>FIN IMPRESION DEL GRUPO

*>>>>IMPRESION DEL CODIGO
       FOR i := 1 TO nNroRec
	   cTxtPrn := 'CODIGO: '+aDetHab[i,2]
	   nNroLin := IF(i==1,0,00)
	   nNroCol := nColRec(i,NIL,lPapSta,lConden)+25
	   @ PROW()+nNroLin,nNroCol SAY cTxtPrn
       ENDFOR
*>>>>FIN IMPRESION DEL CODIGO

*>>>>IMPRESION DEL NOMBRE DE ESTUDIANTE
       FOR i := 1 TO nNroRec
	   cTxtPrn := 'NOMBRE: '+aDetHab[i,3]
	   nNroLin := IF(i==1,1,00)
	   nNroCol := nColRec(i,NIL,lPapSta,lConden)
	   @ PROW()+nNroLin,nNroCol SAY cTxtPrn
       ENDFOR
*>>>>FIN IMPRESION DEL NOMBRE DE ESTUDIANTE

*>>>>IMPRESION DE LA OBSERVACION No. 1
       cTxtPrn := 'Debe presentarse puntualmente en la fecha '

       FOR i := 1 TO nNroRec
	   nNroLin := IF(i==1,2,00)
	   nNroCol := nColRec(i,NIL,lPapSta,lConden)
	   @ PROW()+nNroLin,nNroCol SAY cTxtPrn
       ENDFOR
*>>>>FIN IMPRESION DE LA OBSERVACION No. 1

*>>>>IMPRESION DE LA OBSERVACION No. 2
       cTxtPrn := 'de la habilitaci¢n con los elementos '

       FOR i := 1 TO nNroRec
	   nNroLin := IF(i==1,1,00)
	   nNroCol := nColRec(i,NIL,lPapSta,lConden)
	   @ PROW()+nNroLin,nNroCol SAY cTxtPrn
       ENDFOR
*>>>>FIN IMPRESION DE LA OBSERVACION No. 2

*>>>>IMPRESION DE LA OBSERVACION No. 3
       cTxtPrn := 'necesarios para presentar la prueba.'

       FOR i := 1 TO nNroRec
	   nNroLin := IF(i==1,1,00)
	   nNroCol := nColRec(i,NIL,lPapSta,lConden)
	   @ PROW()+nNroLin,nNroCol SAY cTxtPrn
       ENDFOR
*>>>>FIN IMPRESION DE LA OBSERVACION No. 3

/*>>>>IMPRESION DE LA LINEA SEPARDORA
       FOR i := 1 TO nNroRec
	   nNroLin := IF(i==1,1,00)
	   nNroCol := nColRec(i,NIL,lPapSta,lConden)
	   @ PROW()+nNroLin,nNroCol SAY REPL('=',nLenRec(lPapSta,lConden))
       ENDFOR
*>>>>FIN IMPRESION DE LA LINEA SEPARDORA */

*>>>>IMPRESION DEL TITULO PARA LA NOTA
       cTxtPrn := 'NOTA'+SPACE(02)+'LETRAS'
       IF lConden
	  @ PROW(),00 SAY CONDEN_OF+NEGRA_ON
       ENDIF

       FOR i := 1 TO nNroRec
	   nNroLin := IF(i==1,1,00)
	   nNroCol := nColRec(i,NIL,lPapSta,.F.)
	   @ PROW()+nNroLin,nNroCol SAY cTxtPrn
       ENDFOR
*>>>>FIN IMPRESION DEL TITULO PARA LA NOTA

*>>>>IMPRESION DE LAS LINEAS DE LA NOTA
       cTxtPrn := REPL('_',4)+SPACE(02)+;
		  REPL('_',nLenRec(lPapSta,.F.)-6)

       FOR i := 1 TO nNroRec
	   nNroLin := IF(i==1,1,00)
	   nNroCol := nColRec(i,NIL,lPapSta,.F.)
	   @ PROW()+nNroLin,nNroCol SAY cTxtPrn
       ENDFOR
       IF lConden
	  @ PROW(),00 SAY CONDEN_ON+NEGRA_OF
       ENDIF
*>>>>FIN IMPRESION DE LAS LINEAS DE LA NOTA

*>>>>IMPRESION FIRMA DEL PROFESOR
       cTxtPrn := 'FIRMA DEL PROFESOR: '+;
		  REPL('_',nLenRec(lPapSta,lConden)-20)

       FOR i := 1 TO nNroRec
	   nNroLin := IF(i==1,2,00)
	   nNroCol := nColRec(i,NIL,lPapSta,lConden)
	   @ PROW()+nNroLin,nNroCol SAY cTxtPrn
       ENDFOR
       RETURN NIL
*>>>>FIN IMPRESION FIRMA DEL PROFESOR
