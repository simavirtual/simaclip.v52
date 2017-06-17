/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : LISTADOS
SUBMODULO...: CARNETS

**************************************************************************
* TITULO..: IMPRESION DE CARNETS                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 23/96 MAR A
       Colombia, Bucaramanga        INICIO: 12:05 PM   ABR 23/96 MAR


REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Imprime por grupos y n£mero de lista los carnets de los estudiantes


2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_306(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "EPSONFX.PRG"
       #DEFINE  TAMPAGE CHR(27)+'C'+CHR(51) // P gina de 51 l¡neas
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar l¡nea

       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL aCarnet := {}                  // Detalles de los Carnets
       LOCAL dFecVen := CTOD('00/00/00')    // Fecha de Vencimiento
       LOCAL nRecibo := 0                   // N£mero del Recibo
       LOCAL       k := 0                   // Contador
       LOCAL nNroBis := 0                   // N£mero del bimestre
       LOCAL nNroIni := 0                   // N£mero de lista inicial
       LOCAL nNroFin := 0                   // N£mero de lista inicial
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL cGruFin := ''                  // C¢digo del grupo final
       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias
       LOCAL nPorAcu := 0                   // Porcentaje acumulado
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cNombreTpr := ''               // Nombre del profesor
       LOCAL cNombreTes := ''               // Nombre del estudiante
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

*>>>>SELECCION DEL NIVEL
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       nParameSet(aParam1,'cMaeAct',cMaeAct)
*>>>>FIN SELECCION DEL NIVEL

*>>>>SELECCION DEL PATH DEL SISTEMA
       DO CASE
       CASE 'JAR' $ cMaeAct
	    cPatSis := cPatSis+'\JAR'
       CASE 'PRI' $ cMaeAct
	    cPatSis := cPatSis+'\PRI'
       CASE 'BTO' $ cMaeAct
	    cPatSis := cPatSis+'\BTO'
       ENDCASE
*>>>>FIN SELECCION DEL PATH DEL SISTEMA

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimaCo,'SCO',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FileAlu+cMaeAct+cAnoSis+ExtFile,'ALU',;
		       cPatSis+'\'+;
		       fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared)
	  cError('ABRIENDO ARCHIVOS EN '+cPatSis)
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

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       CASE ALU->(RECCOUNT()) == 0
	    cError('NO EXISTEN ESTUDIANTES GRABADOS')

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

*>>>>LECTURA DE LA FECHA DE VENCIMIENTO
       cSavLin := SAVESCREEN(nFilInf+1,nColInf,nFilInf+1,79)
       dFecVen := DATE()
       @ nFilInf+1,nColInf SAY 'FECHA VENCIMIENTO' GET dFecVen
       READ
       RESTSCREEN(nFilInf+1,nColInf,nFilInf+1,79,cSavLin)
*>>>>FIN LECTURA DE LA FECHA DE VENCIMIENTO

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>CAPTURA DE LOS NUMEROS DE LISTA
       IF !lNrosLista(nFilInf+3,nColInf,@nNroIni,@nNroFin)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS NUMEROS DE LISTA

*>>>>ACTIVACION DE LA IMPRESORA
       IF SCO->lPrnArcCon
	  SET DEVICE TO PRINT
       ELSE
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCO->cOpcPrnCon,.F.)
	  IF EMPTY(nOpcPrn)
	     CloseAll()
	     RETURN NIL
	  ENDIF
       ENDIF
       @ PROW(),00 SAY INICIALIZA
       @ PROW(),00 SAY PROPOR_OF
       @ PROW(),00 SAY CONDEN_ON
       @ PROW(),00 SAY TAMPAGE
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DE LAS NOTAS DIGITADAS
       SELECT GRU
       GO nRegFin
       cGruFin = GRU->cCodigoGru

       GO nRegIni
       DO WHILE GRU->(RECNO()) <= nRegFin

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\NOTAS\'+;
			   'NT'+GRU->cCodigoGru+cAnoSis+ExtFile,;
			   'NOT',NIL,lShared)

	       SET DEVICE TO SCREEN
	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		      GRU->cCodigoGru+' EN '+cPatSis+'\NOTAS')
	      CLOSE ALL
	      RETURN NIL
	   ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********IMPRESION DE LA LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstado('BIMESTRE: '+STR(nNroBis,2)+'º'+;
			'IMPRIMIENDO EL GRUPO: '+GRU->cCodigoGru+'/'+;
			cGruFin+'ºFAVOR ESPERAR ...',cNomSis)
	    SET DEVICE TO PRINT
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********IMPRESION DEL CUERPO DEL INFORME
	    aCarnet := {}
	    nRecibo := 0
	    SELECT NOT
	    GO nNroIni
	    DO WHILE .NOT. EOF()

*--------------IMPRESION DE LA LINEA DE ESTADO
		 SET DEVICE TO SCREEN
		 LineaEstado('IMPRIMIENDO EL GRUPO: '+GRU->cCodigoGru+'/'+;
			      cGruFin+'ºNo. '+NOT->(STR(RECNO(),2))+'/'+;
			      NOT->(STR(RECCOUNT(),2)),cNomSis)
		 SET DEVICE TO PRINT
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------ANALISIS PARA LA SALIDA DEL MODULO
		 SELECT NOT
		 IF nNroFin <> 0
		    IF NOT->(RECNO()) > nNroFin
		       SET DEVICE TO SCREEN
		       CLOSE ALL
		       RETURN NIL
		    ENDIF
		 ENDIF
*--------------FIN ANALISIS PARA LA SALIDA DEL MODULO

*--------------ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
		 IF NOT->lRetGruNot
		    SELECT NOT
		    NOT->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

*--------------BUSQUEDA DEL CODIGO DEL ESTUDIANTE
		 IF lSekCodigo(NOT->cCodigoEst,'ALU')
		    cNombreTes := RTRIM(ALU->cApelliEst)+' '+;
				  RTRIM(ALU->cNombreEst)
		 ELSE
		    cNombreTes := 'EL ALUMNO NO EXISTE'
		 ENDIF
		 cNombreTes := SUBS(cNombreTes+SPACE(50),1,36)
*--------------FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

*--------------ANALISIS SI EL ESTUDIANTE ESTA RETIRADO
		 IF ALU->lRetiroEst
		    SELECT NOT
		    NOT->(DBSKIP())  // OJO CON EL BOLETIN
		    LOOP
		 ENDIF
*--------------FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO

*--------------PREPARCION DE LA IMPRESION
		 nRecibo++
		 IF nRecibo <= 8
		    AADD(aCarnet,{cJorTxt,;
				  cConverNiv(SUBS(GRU->cCodigoGru,1,2))+;
				  SUBS(GRU->cCodigoGru,3,2),;
				  cAnoUsr,;
				  cNombreTes,;
				  ALU->cDocNitEst,;
				  ALU->cTe1AcuEst,;
				  cFecha(dFecVen),;
				  ALU->cCodigoEst})
		 ENDIF
*--------------FIN PREPARCION DE LA IMPRESION

*--------------IMPRESION DE LOS CARNTES
		 IF nRecibo == 8 .OR. nRecibo == nNroFin-nNroIni+1 .OR.;
		    NOT->(RECNO()) == nNroFin
		    Carnet(aCarnet)
		    nRecibo := 0
		    aCarnet := {}
		    EJECT
		 ENDIF
*--------------FIN IMPRESION DE LOS CARNTES

	       SELECT NOT
	       SKIP

	    ENDDO
	    CLOSE NOT
**********FIN IMPRESION DEL CUERPO DEL INFORME

	  nNroIni := 1
	  SELECT GRU
	  SKIP

       ENDDO
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       SET DEVICE TO SCREEN
       VerPrn(nOpcPrn,FilePrn)
       CloseAll()
       RETURN NIL
*>>>>FIN IMPRESION DE LAS NOTAS DIGITADAS

/*************************************************************************
* TITULO DE LA FUNCION..: IMPRESION DE ORDENES DE HABILITACION           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 23/96 MAR A
       Colombia, Bucaramanga        INICIO: 12:35 PM   ABR 23/96 MAR

OBJETIVOS:

1- Imprime el carnet

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carnet(aCarnet)

*>>>>PARAMETROS DE LA FUNCION
/*     aCarnet				    // Detalles de la facturaci¢n */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroRec := 0                   // N£mero de recibo
       LOCAL nTotRec := 0                   // Total Recibos
       LOCAL nNroGru := 2                   // Grupos de recibos
       LOCAL       i := 0                   // Contador
       LOCAL       k := 0                   // Temporal
       LOCAL nNroLin := 0                   // N£mero de l¡neas
       LOCAL nNroCol := 0                   // N£mero de columna
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE LOS RECIBOS
       nNroRec := 1
	     k := nNroRec
       nTotRec := LEN(aCarnet)
       DO WHILE nNroRec <= nTotRec

***********IMPRESION DE LA SECCION,CURSO Y A¥O. LINEA UNO
	     FOR i := 1 TO nNroGru
		 nNroLin := 0

		 IF !lNroPar(nNroRec)
		    nNroLin := VAL(SUBS('02  06  08  06',nNroRec*2-1,2))
		 ENDIF
	       *ÀLineas entre cada grupo de recibos

		 @ PROW()+nNroLin,VAL(SUBS('028088',i*3-2,3));
			  SAY IF(nNroRec <= nTotRec,aCarnet[nNroRec,1],'')
		*Secci¢n

		 @ PROW(),VAL(SUBS('042102',i*3-2,3));
			  SAY IF(nNroRec <= nTotRec,aCarnet[nNroRec,2],'')
		*Curso

		 @ PROW(),VAL(SUBS('054114',i*3-2,3));
			  SAY IF(nNroRec <= nTotRec,aCarnet[nNroRec,3],'')
		*A¤o
		 nNroRec++
	     ENDFOR
	     nNroRec := k
***********FIN IMPRESION DE LA SECCION,CURSO Y A¥O. LINEA UNO

***********IMPRESION DEL NOMBRE. LINEA DOS
	     FOR i := 1 TO nNroGru
		 nNroLin := IF(i==1,2,0)
		 nNroCol := VAL(SUBS('028088',i*3-2,3))
		 @ PROW()+nNroLin,nNroCol;
			  SAY IF(nNroRec <= nTotRec,aCarnet[nNroRec,4],'')
		 nNroRec++
	     ENDFOR
	     nNroRec := k
***********FIN IMPRESION DEL NOMBRE. LINEA DOS

***********IMPRESION DEL DOCUMENTO Y TELEFONO. LINEA TRES
	     FOR i := 1 TO nNroGru
		 nNroLin := IF(i==1,2,0)
		 nNroCol := VAL(SUBS('017093',i*3-2,3))

		 @ PROW()+nNroLin,VAL(SUBS('028088',i*3-2,3));
			  SAY IF(nNroRec <= nTotRec,aCarnet[nNroRec,5],'')
		*Documento

		 @ PROW(),VAL(SUBS('052113',i*3-2,3));
			  SAY IF(nNroRec <= nTotRec,aCarnet[nNroRec,6],'')
		*Telefono

		 nNroRec++
	     ENDFOR
	     nNroRec := k
***********FIN IMPRESION DEL DOCUMENTO Y TELEFONO. LINEA TRES

***********IMPRESION FECHA DE VENCIMIENTO. LINEA CUATRO
	     FOR i := 1 TO nNroGru
		 nNroLin := IF(i==1,2,0)
		 nNroCol := VAL(SUBS('012071',i*3-2,3))
		 @ PROW()+nNroLin,nNroCol;
			  SAY IF(nNroRec <= nTotRec,aCarnet[nNroRec,7],'')

		 @ PROW(),VAL(SUBS('028088',i*3-2,3));
			  SAY 'CODIGO: '+;
			      IF(nNroRec <= nTotRec,aCarnet[nNroRec,8],'')
		*C¢digo

		 nNroRec++
	     ENDFOR
	     k := nNroRec
***********FIN IMPRESION FECHA DE VENCIMIENTO. LINEA CUATRO

       ENDDO
       RETURN NIL
*>>>>IMPRESION DE LOS RECIBOS


