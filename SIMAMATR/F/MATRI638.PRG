/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : MATRICULAS - INFORMES
SUBMODULO...: ETIQUETAS

**************************************************************************
* TITULO..: ETIQUETAS                                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 13/2002 MIE A
       Bucaramanga, Colombia	    INICIO: 10:40 PM   NOV 13/2002 MIE

OBJETIVOS:

1- Imprime las etiquetas de los estudiantes.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_638(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
     *ÀVariables generales

       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL aMenus  := {}	            // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nLenOpc := 0                   // Longitud de las opciones

       LOCAL GetList := {}                  // Variable del Sistema
     *ÀVariables espec¡ficas
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
       IF  !lParam0101(aParams,;
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

*>>>>DECLARACION Y EJECUCION DEL MENU
       AADD(aMenus,'1<ANTIGUOS POR GRUPOS>')
       AADD(aMenus,'2<NUEVOS POR NIVELES >')

       AADD(aAyuda,'Imprime las Etiquetas de Estudiantes Antiguos por Grupos')
       AADD(aAyuda,'Imprime las Etiquetas de Estudiantes Nuevos por Grados')
*>>>>FIN DECLARACION Y EJECUCION DEL MENU

*>>>>VALIDACION DEL LIMITE DE LA ULTIMA COLUMNA
       nLenOpc := LEN(aMenus[1])
      *Calculo de la Longitud mayor

       IF nColInf + nLenOpc + 2 > 78
	  nColInf := 78-nLenOpc
	  nParameSet(aParam1,'nColInf',nColInf)
       ENDIF
*>>>>FIN VALIDACION DEL LIMITE DE LA ULTIMA COLUMNA

*>>>>ANALISIS DE OPCION ESCOGIDA
       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,aAyuda,nFilInf+1,nColInf,NIL,NIL,1,.F.)
       RESTSCREEN(0,0,24,79,cSavPan)

       DO CASE
       CASE nNroOpc == 1
	    EtiqueGru(aParam1,aParam2,aParam3)

       CASE nNroOpc == 2
	    EtiqueNiv(aParam1,aParam2,aParam3)

       ENDCASE
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: ETIQUETAS POR GRUPOS DE LOS ANTIGUOS                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 13/2002 MIE A
       Bucaramanga, Colombia	    INICIO: 11:15 PM   NOV 13/2002 MIE

OBJETIVOS:

1- Imprime las etiquetas de los estudiantes.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION EtiqueGru(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-MATR.PRG"      // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
     *ÀVariables generales

       LOCAL lUseNtx := .F.                 // .T. Poner en Uso lo indices
       LOCAL lAnoAct := .T.                 // A¤o Actual
       LOCAL cPatAnt := ''                  // Path A¤os anteriores
       LOCAL cAnoAnt := .F.                 // A¤o Anterior

       LOCAL nRegAct := 0                   // Registro Actual
       LOCAL lHayEof := .F.                 // .T. Fin de Archivo

       LOCAL nRegIni := 0                   // Registro Inicial
       LOCAL nRegFin := 0                   // Registro Final
       LOCAL cGruFin := ''                  // Grupo final de impresi¢n

       LOCAL aEtique := {}                  // Detalles de las Etiquetas
       LOCAL nNroEti := 0                   // N£mero del Etiqueta
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
       LOCAL cNombreTes := ''               // Nombre del Estudiante

       FIELD cCodigoGru                     // C¢digo del Grupo
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
       IF  !lParam0101(aParams,;
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

*>>>>SELECION DEL A¥O ANTERIOR
       cAnoAnt := STR((VAL(cAnoUsr)-1),4)
       cPatAnt := cPatSis
       cPatAnt := STUFF(cPatAnt,1,4,cAnoAnt)
       cPatAnt := PathUno+'\'+cPatAnt
       PathAlu := PathUno+'\'+cPatSis
*>>>>FIN SELECION DEL A¥O ANTERIOR

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimMtr,'MTR',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared) .OR.;
	  !lUseGru(lShared,cPatAnt,cMaeAct,SUBS(cAnoAnt,3,2),lAnoAct) .OR.;
	  !lUseMaeMtr(lShared,cPatAnt,cMaeAct,SUBS(cAnoAnt,3,2),lAnoAct,lUseNtx)

	  cError('ABRIENDO ARCHIVOS EN MATRICULAS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE MTR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE 'JAA' $ cMaeAlu .AND. JAA->(RECCOUNT()) == 0
	    cError('No Existen Estudiantes de Jardin para '+cAnoAnt)

       CASE 'PRA' $ cMaeAlu .AND. PRA->(RECCOUNT()) == 0
	    cError('No Existen Estudiantes de Primaria para '+cAnoAnt)

       CASE 'BTA' $ cMaeAlu .AND. BTA->(RECCOUNT()) == 0
	    cError('No Existen Estudiantes de Bachillerato para '+cAnoAnt)

       CASE GRU->(RECCOUNT()) == 0
	    cError('No Existen Grupos Grabados para '+cAnoAnt)

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',MTR->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       SELECT GRU
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>SELECION DEL TIPO DE IMPRESION
       IF lShared
	  ActivaPrn(lShared,cNomSis,PathSis,fSimMtr,'cColaAcMtr','Mtr')
       ENDIF
*>>>>FIN SELECION DEL TIPO DE IMPRESION

*>>>>ACTIVACION DE LA IMPRESORA
       IF MTR->lPrnArcMtr
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'etiqueta'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,MTR->cOpcPrnMtr,.F.)
	  IF EMPTY(nOpcPrn)
	      RETURN NIL
	  ENDIF
       ENDIF
       @ PROW(),00 SAY PCL({'Reset','ProporOf','CondenOf','Pica'})
       SET DEVICE TO SCREEN
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>RECORRIDO POR GRUPOS
       SELECT GRU
       GO nRegFin
       cGruFin = GRU->cCodigoGru

       GO nRegIni
       DO WHILE GRU->(RECNO()) <= nRegFin

**********FILTRACION DEL MAESTRO
	    SELECT &cMaeAct
	    SET FILTER TO cCodigoGru == GRU->cCodigoGru
	    GO TOP
	    IF EOF()
	       cError('NO EXISTEN ESTUDIANTES PARA EL GRUPO '+GRU->cCodigoGru)

*--------------AVANCE DEL SIGUIENTE GRUPO
		 SELECT GRU
		 SKIP

		 IF nRegIni = nRegFin
		    EXIT
		   *Salida por ser un solo grupo a imprimir
		 ENDIF
		 LOOP
*--------------FIN AVANCE DEL SIGUIENTE GRUPO

	    ENDIF
**********FIN FILTRACION DEL MAESTRO

**********IMPRESION DE LAS ETIQUETAS
	    aEtique := {}
	    nNroEti := 0

	    SELECT &cMaeAct
	    GO TOP

	    DO WHILE .NOT. EOF()

*--------------VALIDACION DEL CODIGO
		 DO CASE
		 CASE &cMaeAct->lRetiroEst

		      SELECT &cMaeAct
		      DBSKIP()
		      LOOP

		 CASE !(&cMaeAct->lSiCupoEst)

		      SELECT &cMaeAct
		      DBSKIP()
		      LOOP

/*
		 CASE SUBS(&cMaeAct->cCodigoGru,1,2) = '11' .AND.;
		      !&cMaeAct->lRepiteEst

		      SELECT &cMaeAct
		      DBSKIP()
		      LOOP
*/

		 ENDCASE
*--------------FIN VALIDACION DEL CODIGO

*--------------IMPRESION DE LA LINEA DE ESTADO
		 LineaEstado('IMPRIMIENDO EL GRUPO: '+GRU->cCodigoGru+'º'+;
			     'HASTA EL GRUPO: '+cGruFin+;
			     'ºREG No.: '+STR(RECNO(),4),cNomSis)
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------ANALISIS DEL SIGUIENTE NIVEL
		 IF &cMaeAct->lRepiteEst

*...................REPITE EL NIVEL
		      IF SUBS(&cMaeAct->cCodigoGru,1,2) == '17'
			 cCodigoTgr := '00'+SUBS(&cMaeAct->cCodigoGru,3,2)
		      ELSE
			 cCodigoTgr := &cMaeAct->cCodigoGru
		      ENDIF
*...................FIN REPITE EL NIVEL

		 ELSE

*...................PROMOCION AL SIGUIENTE NIVEL
		      IF SUBS(&cMaeAct->cCodigoGru,1,2) == '16'
			 cCodigoTgr := '00'
		      ELSE
			 IF SUBS(&cMaeAct->cCodigoGru,1,2) == '17'
			    cCodigoTgr := '01'
			 ELSE
			    cCodigoTgr := STR(VAL(SUBS(&cMaeAct->cCodigoGru,1,2))+1,2)
			 ENDIF
		      ENDIF
		      lCorrecion(@cCodigoTgr)
		      cCodigoTgr += SUBS(&cMaeAct->cCodigoGru,3,2)
*...................FIN PROMOCION AL SIGUIENTE NIVEL

		 ENDIF
		 cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			       RTRIM(&cMaeAct->cNombreEst)
		 cNombreTes := ALLTRIM(SUBS(cNombreTes+SPACE(28),1,28))
		 cNombreTes += '-'+&cMaeAct->cCodigoGru
*--------------FIN ANALISIS DEL SIGUIENTE NIVEL

*--------------PREPARCION DE LA IMPRESION
		 nNroEti++
		 IF nNroEti <= 22
		    AADD(aEtique,{'MATRICULA A¥O: '+cAnoUsr,;
				  'CODIGO:'+&cMaeAct->cCodigoEst+' '+;
				  'GRADO: '+cNomNiv(SUBS(cCodigoTgr,1,2)),;
				  cNombreTes})
		 ENDIF
*--------------FIN PREPARCION DE LA IMPRESION

*--------------CONTROL DE FIN DE ARCHIVO
		 SELECT &cMaeAct
		 nRegAct := RECNO()
		 DBSKIP()
		 lHayEof := .F.
		 IF EOF()
		    lHayEof := .T.
		 ENDIF
		 DBGOTO(nRegAct)
*--------------FIN CONTROL DE FIN DE ARCHIVO

*--------------IMPRESION DE LAS ETIQUETAS
		 IF nNroEti == 22 .OR. lHayEof

		    SET DEVICE TO PRINT
		    Etiqueta(aEtique)
		    nNroEti := 0
		    aEtique := {}
		    EJECT
		    SET DEVICE TO SCREEN
		 ENDIF
*--------------FIN IMPRESION DE LAS ETIQUETAS

*--------------AVANCE DEL SIGUIENTE REGISTRO
		 SELECT &cMaeAct
		 DBSKIP()
*--------------FIN AVANCE DEL SIGUIENTE REGISTRO

	    ENDDO
**********FIN IMPRESION DE LAS ETIQUETAS

**********AVANCE DEL SIGUIENTE GRUPO
	    SELECT GRU
	    SKIP

	    IF nRegIni = nRegFin
	       EXIT
	      *Salida por ser un solo grupo a imprimir
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE GRUPO

       ENDDO
       SET FILTER TO
       VerPrn(nOpcPrn,FilePrn)
       CloseAll()
       RETURN NIL
*>>>>FIN RECORRIDO POR GRUPOS

/*************************************************************************
* TITULO..: IMPRESION DE LAS ETIQUETAS                                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 14/2002 JUE A
       Bucaramanga, Colombia	    INICIO: 12:00 PM   NOV 14/2002 JUE

OBJETIVOS:

1- Imprime las Etiquetas

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Etiqueta(aEtique)

*>>>>PARAMETROS DE LA FUNCION
/*     aEtique				    // Detalles de la Etiqueta */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroEti := 0                   // N£mero de recibo
       LOCAL nTotEti := 0                   // Total Recibos
       LOCAL nNroGru := 2                   // Grupos de Etiquetas
       LOCAL     i,k := 0                   // Contadores
       LOCAL nNroLin := 0                   // N£mero de l¡neas
       LOCAL nNroCol := 0                   // N£mero de columna
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE LAS ETIQUETAS
       nNroEti := 1
	     k := nNroEti
       nTotEti := LEN(aEtique)

       DO WHILE nNroEti <= nTotEti

***********VALIDACION DEL LA ULTIMA ETIQUETA
	     IF nNroEti == nTotEti
		nNroGru := 1
	     ENDIF
***********FIN VALIDACION DEL LA ULTIMA ETIQUETA

***********IMPRESION LINEA No.1
	     FOR i := 1 TO nNroGru
		 nNroLin := IF(i==1,nNroLin,0)
		 nNroCol := VAL(SUBS('000036',i*3-2,3))
		 @ PROW()+nNroLin,nNroCol SAY aEtique[nNroEti,1]
		 nNroEti++
	     ENDFOR
	     nNroEti := k
***********FIN IMPRESION LINEA No.1

***********IMPRESION LINEA No.2
	     FOR i := 1 TO nNroGru
		 nNroLin := IF(i==1,1,0)
		 nNroCol := VAL(SUBS('000036',i*3-2,3))
		 @ PROW()+nNroLin,nNroCol SAY aEtique[nNroEti,2]
		 nNroEti++
	     ENDFOR
	     nNroEti := k
***********FIN IMPRESION LINEA No.2

***********IMPRESION LINEA No.3
	     FOR i := 1 TO nNroGru
		 nNroLin := IF(i==1,1,0)
		 nNroCol := VAL(SUBS('000036',i*3-2,3))
		 @ PROW()+nNroLin,nNroCol SAY aEtique[nNroEti,3]
		 nNroEti++
	     ENDFOR
	     k := nNroEti
***********FIN IMPRESION LINEA No.3

***********INCREMENTO DE LAS FILAS
	     IF !lNroPar(nNroEti)
		nNroLin := 4
	     ENDIF
***********FIN INCREMENTO DE LAS FILAS

       ENDDO
       RETURN NIL
*>>>>FIN IMPRESION DE LAS ETIQUETAS

/*************************************************************************
* TITULO..: ETIQUETAS POR GRADOS DE LOS NUEVOS                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 17/2002 DOM A
       Bucaramanga, Colombia	    INICIO: 12:37 PM   NOV 17/2002 DOM

OBJETIVOS:

1- Imprime las etiquetas de los estudiantes nuevos por grados.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION EtiqueNiv(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-MATR.PRG"      // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr    := .F.              // .T. Hay Error

       LOCAL nNroNiv := 0                   // N£mero Nivel
       LOCAL cNivIni := 0                   // Nivel Inicial
       LOCAL cNivFin := 0                   // Nivel Final

       LOCAL aEtique := {}                  // Detalles de las Etiquetas
       LOCAL nNroEti := 0                   // N£mero del Etiqueta
       LOCAL nRegAct := 0                   // Registro Actual
       LOCAL lHayEof := .F.                 // .T. Fin de Archivo
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cNombreTes := ''               // Nombre del Estudiante
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
       IF  !lParam0101(aParams,;
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

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimMtr,'MTR',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FileAdm+cAnoUsr+ExtFile,'ADM',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE MTR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE ADM->(RECCOUNT()) == 0
	    cError('No Existen Inscripciones')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',MTR->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>LECTURA DE LOS NIVELES A IMPRIMIR
       IF !lLeeNivels(nFilInf+1,nColInf,@cNivIni,@cNivFin,NIL,cMaeAlu)
	  CloseAll()
	  RETURN NIL
       ENDIF
       nNroNiv := VAL(cNivIni)
*>>>>FIN LECTURA DE LOS NIVELES A IMPRIMIR

*>>>>SELECION DEL TIPO DE IMPRESION
       IF lShared
	  ActivaPrn(lShared,cNomSis,PathSis,fSimMtr,'cColaAcMtr','Mtr')
       ENDIF
*>>>>FIN SELECION DEL TIPO DE IMPRESION

*>>>>ACTIVACION DE LA IMPRESORA
       IF MTR->lPrnArcMtr
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'etiqueta'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,MTR->cOpcPrnMtr,.F.)
	  IF EMPTY(nOpcPrn)
	      RETURN NIL
	  ENDIF
       ENDIF
       @ PROW(),00 SAY PCL({'Reset','ProporOf','CondenOf','Pica'})
       SET DEVICE TO SCREEN
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL INFORME
       SELECT ADM
       DO WHILE nNroNiv <= VAL(cNivFin)

**********FILTRACION DEL MAESTRO
	    SET FILTER TO VAL(SUBS(ADM->cCodigoGru,1,2)) == nNroNiv
	    GO TOP
	    IF EOF()
	       cError('PARA '+cNomNiv(nNroNiv)+' NO HAY INSCRITOS')
	    ENDIF
**********FIN FILTRACION DEL MAESTRO

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('IMPRIMIENDO NIVEL: '+STR(nNroNiv,2)+'º'+;
			'HASTA NIVEL: '+cNivFin+;
			'ºPOR FAVOR ESPERE ...',cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********IMPRESION DE LAS HOJAS DE LA MATRICULA
	    SELECT ADM
	    GO TOP
	    DO WHILE .NOT. EOF()

*--------------ANALISIS SI TIENE CUPO
		 IF .NOT. ADM->lSiCupoEst
		    ADM->(DBSKIP())
		    LOOP
		 ENDIF
		 cNombreTes := RTRIM(ADM->cApelliEst)+' '+;
			       RTRIM(ADM->cNombreEst)
		 cNombreTes := ALLTRIM(SUBS(cNombreTes+SPACE(28),1,28))
		 cNombreTes += '-'+ADM->cCodigoGru
*--------------FIN ANALISIS SI TIENE CUPO

*--------------PREPARCION DE LA IMPRESION
		 nNroEti++
		 IF nNroEti <= 22
		    AADD(aEtique,{'MATRICULA A¥O: '+cAnoUsr,;
				  'CODIGO:'+ADM->cCodigoEst+' '+;
				  'GRADO: '+;
				  cNomNiv(SUBS(ADM->cCodigoGru,1,2)),;
				  cNombreTes})
		 ENDIF
*--------------FIN PREPARCION DE LA IMPRESION

*--------------CONTROL DE FIN DE ARCHIVO
		 SELECT ADM
		 nRegAct := ADM->(RECNO())
		 ADM->(DBSKIP())
		 lHayEof := .F.
		 IF EOF()
		    lHayEof := .T.
		 ENDIF
		 ADM->(DBGOTO(nRegAct))
*--------------FIN CONTROL DE FIN DE ARCHIVO

*--------------IMPRESION DE LAS ETIQUETAS
		 IF nNroEti == 22 .OR. lHayEof

		    SET DEVICE TO PRINT
		    Etiqueta(aEtique)
		    nNroEti := 0
		    aEtique := {}
		    EJECT
		    SET DEVICE TO SCREEN
		 ENDIF
*--------------FIN IMPRESION DE LAS ETIQUETAS

	       ADM->(DBSKIP())

	    ENDDO
**********FIN IMPRESION DE LAS HOJAS DE LA MATRICULA

	  nNroNiv++

       ENDDO
       SET FILTER TO
       VerPrn(nOpcPrn,FilePrn)
       CloseAll()
       RETURN NIL
*>>>>FIN IMPRESION DEL INFORME