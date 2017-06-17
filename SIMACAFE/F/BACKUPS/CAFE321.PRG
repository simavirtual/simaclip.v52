/*SIMA - SISTEMA DE CAFETERIA

MODULO      : INFORMES
SUBMODULO...: CARNETS - POR GRUPOS                     MODULO No. 321

**************************************************************************
* TITULO..: IMPRESION DE CARNETS POR GRUPOS                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 01/2002 LUN A
       Colombia, Bucaramanga        INICIO: 08:30 PM   JUL 01/2002 LUN

OBJETIVOS:

1- Imprime los carnets de los Estudiantes por grupos

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Cafe_321(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		  cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		  cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		  cJorTxt)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-CAFE.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar linea
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de integraci¢n uno
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL PathDos := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL nRegIni := 0                   // Registro Inicial
       LOCAL nRegFin := 0                   // Registro Final
       LOCAL cGruFin := ''                  // Grupo final de impresi¢n
       LOCAL nNroIni := 0                   // N£mero de lista inicial
       LOCAL nNroFin := 0                   // N£mero de lista inicial

       LOCAL dFecVen := CTOD('00/00/00')    // Fecha de Vencimiento
       LOCAL aCarnet := {}                  // Detalles de los Carnets
       LOCAL nRecibo := 0                   // N£mero del Recibo
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cNombreTes := ''               // Nombre del estudiante
       CloseAll()                           // Cerrar Archivos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathCaFAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @PathDos,@cIntTre,@cIntCua,nModCry,.F.)
       cIntUno := PathUno+'\'+cPatSis
       cIntDos := PathDos+'\'+cPatSis
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,cIntDos+'\'+FileCon,'CON',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimCaf,'CAF',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FCaFAno+cAnoUsr+ExtFile,'ANO',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,cIntUno,cMaeAct,cAnoSis) .OR.;
	  !lUseGru(lShared,cIntUno,cMaeAct,cAnoUsr) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       SELECT &cMaeAct
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTEN ESTUDIANTES GRABADOS')

       CASE CAF->(RECCOUNT()) == 0
	    cError('NO EXISTE LA CONFIGURACION DEL SISTEMA')

       CASE ANO->(RECCOUNT()) == 0
	    cError('NO EXISTE LA CONFIGURACION DEL A¥O')

       CASE CON->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONCEPTOS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',CAF->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>LECTURA DE LA FECHA DE VENCIMIENTO
       cSavPan := SAVESCREEN(0,0,24,79)
       dFecVen := DATE()
       @ nFilInf+1,nColInf SAY 'FECHA VENCIMIENTO' GET dFecVen
       READ
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN LECTURA DE LA FECHA DE VENCIMIENTO

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>CAPTURA DE LOS NUMEROS DE LISTA
       IF !lNrosLista(nFilInf+3,nColInf,@nNroIni,@nNroFin)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS NUMEROS DE LISTA

*>>>>ACTIVACION DE LA IMPRESORA
       IF !Printer_on(CAF->lPrnArcCaF)
	   CloseAll(aUseDbf)
	   RETURN NIL
       ENDIF
       @ PROW(),00 SAY PCL({"Reset","Oficio","Linesp18",;
			    "ProporOf","CondenOn"})
       SET DEVICE TO SCREEN
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DE CARNETS PARA CADA GRUPO
       SELECT GRU
       GO nRegFin
       cGruFin = GRU->cCodigoGru

       GO nRegIni
       DO WHILE GRU->(RECNO()) <= nRegFin

**********PREPARACION DE LAS VARIABLES DE ARCHIVO
	    FileCli := cIntDos+'\CLIENTES\CL'+;
				GRU->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry)
	       cError('ABRIENDO EL ARCHIVO DE CLIENTES')
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseAll(aUseDbf)
	       RETURN NIL
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE CLI->(RECCOUNT()) == 0
		 cError('PARA IMPRIMIR CARNETS POR GRUPOS '+;
			'DEBEN ESTAR CREADOS LOS CLIENTES DE LA CARTERA')
	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE
	    IF lHayErr
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseAll(aUseDbf)
	       RETURN NIL
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********IMPRESION DEL CUERPO DEL INFORME
	    aCarnet := {}
	    nRecibo := 0
	    SELECT CLI
	    GO nNroIni
	    DO WHILE .NOT. CLI->(EOF())

*--------------IMPRESION DE LA LINEA DE ESTADO
		 LineaEstado('GRUPO: '+GRU->cCodigoGru+'/'+;
			      cGruFin+'ºNo. '+CLI->(STR(RECNO(),2))+'/'+;
			      CLI->(STR(RECCOUNT(),2)),cNomSis)
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------ANALISIS PARA LA SALIDA
		 SELECT CLI
		 IF nNroFin <> 0
		    IF CLI->(RECNO()) > nNroFin
		       CloseDbf('CLI',FileCli,nModCry)
		       CloseAll(aUseDbf)
		       RETURN NIL
		    ENDIF
		 ENDIF
*--------------FIN ANALISIS PARA LA SALIDA DEL MODULO

*--------------ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
		 IF CLI->lRetGruCli
		    SELECT CLI
		    CLI->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

*--------------BUSQUEDA DEL CODIGO DEL ESTUDIANTE
		 IF lSekCodigo(CLI->cCodigoEst,cMaeAct)
		    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
				  RTRIM(&cMaeAct->cNombreEst)
		 ELSE
		    SELECT CLI
		    CLI->(DBSKIP())
		    LOOP
		 ENDIF
		 cNombreTes := SUBS(cNombreTes+SPACE(32),1,32)
*--------------FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

*--------------ANALISIS SI EL ESTUDIANTE ESTA RETIRADO
		 IF &cMaeAct->lRetiroEst
		    SELECT CLI
		    CLI->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO

*--------------PREPARCION DE LA IMPRESION
		 nRecibo++
		 IF nRecibo <= 10
		    AADD(aCarnet,{cNombreTes,;
				  CLI->cCodigoEst+' GRUPO: '+;
				  GRU->cCodigoGru+;
				  SPACE(01)+'VALIDO HASTA:',;
				  cFecha(dFecVen)})
		 ENDIF
*--------------FIN PREPARCION DE LA IMPRESION

*--------------IMPRESION DE LOS CARNTES
		 SET DEVICE TO PRINT
		 IF nRecibo == 10 .OR. nRecibo == nNroFin-nNroIni+1 .OR.;
		    CLI->(RECNO()) == nNroFin
		    Carnet(aCarnet)
		    nRecibo := 0
		    aCarnet := {}
		    EJECT
		 ENDIF
		 SET DEVICE TO SCREEN
*--------------FIN IMPRESION DE LOS CARNTES

	       SELECT CLI
	       CLI->(DBSKIP())

	    ENDDO
	    nNroIni := 1
**********FIN IMPRESION DEL CUERPO DEL INFORME

**********AVANCE DEL SIGUIENTE GRUPO
	    CloseDbf('CLI',FileCli,nModCry)
	    SELECT GRU
	    GRU->(DBSKIP())

	    IF nRegIni = nRegFin
	       EXIT
	      *Salida por ser un solo grupo a imprimir
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE GRUPO

       ENDDO
       CloseDbf('CLI',FileCli,nModCry)
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN IMPRESION DE CARNETS PARA CADA GRUPO

/*************************************************************************
* TITULO..: IMPRESION DEL GRUPO DE CARNETS                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 01/2002 LUN A
       Colombia, Bucaramanga        INICIO: 10:00 PM   JUL 01/2002 LUN

OBJETIVOS:

1- Imprime el grupo de Carnets

2- Retorna Nil

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

***********IMPRESION DEL NOMBRE. LINEA UNO
	     FOR i := 1 TO nNroGru

		 nNroLin := 0
		 IF !lPar(nNroRec)
		    nNroLin := VAL(SUBS('10  13  14  13  13',nNroRec*2-1,2))
		 ENDIF
	       *ÀLineas entre cada grupo de recibos

		 @ PROW()+nNroLin,VAL(SUBS('023089',i*3-2,3));
			  SAY IF(nNroRec <= nTotRec,aCarnet[nNroRec,1],'')
		*Nombre del Estudiante

		 nNroRec++
	     ENDFOR
	     nNroRec := k
***********FIN IMPRESION DEL NOMBRE. LINEA UNO

***********IMPRESION DEL CODIGO Y GRUPO. LINEA DOS
	     FOR i := 1 TO nNroGru
		 nNroLin := IF(i==1,3,0)
		 nNroCol := VAL(SUBS('023089',i*3-2,3))
		 @ PROW()+nNroLin,nNroCol;
			  SAY IF(nNroRec <= nTotRec,aCarnet[nNroRec,2],'')
		 nNroRec++
	     ENDFOR
	     nNroRec := k
***********FIN IMPRESION DEL CODIGO Y GRUPO. LINEA DOS

***********IMPRESION DEL VALIDEZ. LINEA TRES
	     FOR i := 1 TO nNroGru
		 nNroLin := IF(i==1,1,0)
		 nNroCol := VAL(SUBS('042108',i*3-2,3))
		 @ PROW()+nNroLin,nNroCol;
			  SAY IF(nNroRec <= nTotRec,aCarnet[nNroRec,3],'')
		 nNroRec++
	     ENDFOR
	     k := nNroRec
***********FIN IMPRESION DEL VALIDEZ. LINEA TRES

       ENDDO
       RETURN NIL
*>>>>IMPRESION DE LOS RECIBOS