/* SIMA - MATRICULA ACADEMICA

MODULO      : CITACION
SUBMODULO...: IMPRESION              MODULO No. 306

**************************************************************************
* NOMBRE DEL PROGRAMA..: MATRI306.PRG                                    *
* TITULO DEL PROGRAMA..: RELACION DE CANDIDATOS A ENTREVISTAR            *
**************************************************************************

AUTOR: Nelson Fern�ndez G�mez       FECHA DE CREACION: JUL 29/96 LUN A
       Colombia, Bucaramanga        INICIO: 05:05 PM   JUL 29/96 LUN


REQUERIMIENTOS:

1- Para ejecutar la funci�n tener presente la sintaxis

OBJETIVOS:

1- Imprime la relaci�n de los candidatos a entrevistar por niveles

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_306(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-MATR.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci�n uno
       LOCAL cIntDos := ''                  // Path de integraci�n dos
       LOCAL cIntTre := ''                  // Path de integraci�n tres
       LOCAL cIntCua := ''                  // Path de integraci�n cuatro
     *�Variables generales

       LOCAL nNroNiv := 0                   // N�mero Nivel
       LOCAL cNivIni := 0                   // Nivel Inicial
       LOCAL cNivFin := 0                   // Nivel Final
       LOCAL nCopias := 0                   // N�meros de copias a imprimir
       LOCAL nNroCop := 1                   // N�mero de copia
     *�Variables espec�ficas 
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // Modo de Protecci�n
       LOCAL cCodSui := ''                  // C�digo del Sistema
       LOCAL cNomSis := ''                  // Nombre del Sistema
     *�Detalles del Sistema

       LOCAL cEmpPal := ''                  // Nombre de la Empresa principal
       LOCAL cNitEmp := ''                  // Nit de la Empresa
       LOCAL cNomEmp := ''                  // Nombre de la Empresa
       LOCAL cNomSec := ''                  // Nombre de la Empresa Secundario
       LOCAL cCodEmp := ''                  // C�digo de la Empresa
     *�Detalles de la Empresa

       LOCAL cNomUsr := ''                  // Nombre del Usuario
       LOCAL cAnoUsr := ''                  // A�o del usuario
       LOCAL cAnoSis := ''                  // A�o del sistema
       LOCAL cPatSis := ''                  // Path del sistema
     *�Detalles del Usuario

       LOCAL nFilPal := 0                   // Fila Inferior Men� principal
       LOCAL nFilInf := 0                   // Fila Inferior del SubMen�
       LOCAL nColInf := 0                   // Columna Inferior del SubMen�
     *�Detalles Tecnicos

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
     *�Sitios del Sistema

       LOCAL PathUno := ''                  // Path de Integraci�n Uno
       LOCAL PathDos := ''                  // Path de Integraci�n Dos
       LOCAL PathTre := ''                  // Path de Integraci�n Tres
       LOCAL PathCua := ''                  // Path de Integraci�n Cuatro
     *�Path de Integraci�n

       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cJorTxt := ''                  // Jornada escogida
     *�Detalles Acad�micos

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
		       fMtrAno+cAnoUsr+ExtFile,'ANO',NIL,lShared) .OR.;
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

       CASE ANO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DE LA MATRICULA PARA EL A�O')

       CASE ADM->(RECCOUNT()) == 0
	    cError('No Existen Inscripciones')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CLOSE ALL
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

*>>>>ANALISIS DE LA ACTIVACION DE LOS EXAMENES
       IF !ANO->lHayEntAno
	  cError('NO ESTA HABILITADA LA OPCION PARA ENTREVISTAS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE LA ACTIVACION DE LOS EXAMENES

*>>>>LECTURA DE LOS NIVELES A IMPRIMIR
       IF !lLeeNivels(nFilInf+1,nColInf,@cNivIni,@cNivFin,@nCopias,cMaeAlu)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
       nNroNiv := VAL(cNivIni)
*>>>>FIN LECTURA DE LOS NIVELES A IMPRIMIR

*>>>>SELECION DEL TIPO DE IMPRESION
       IF lShared
	  NNETSETQ('COLA')
	  NNETCAPBEG(1)
	  IF !lPregunta('DESEA IMPRIMIR EN RED? Si No')
	     NNETCAPEND(1)
	  ENDIF
       ENDIF
*>>>>FIN SELECION DEL TIPO DE IMPRESION

*>>>>IMPRESION DEL INFORME
       DO WHILE nNroNiv <= VAL(cNivFin)

**********FILTRACION DEL MAESTRO
	    SET FILTER TO VAL(SUBS(ADM->cCodigoGru,1,2)) == nNroNiv
	    GO TOP
	    IF EOF()
	       cError('PARA '+cNomNiv(nNroNiv)+' NO HAY INSCRITOS')
	       nNroCop := nCopias+1
	    ENDIF
**********FIN FILTRACION DEL MAESTRO

**********IMPRESION DE N COPIAS
	    DO WHILE nNroCop <= nCopias

*--------------IMPRESION DE LA LINEA DE ESTADO
		 LineaEstado('IMPRIMIENDO NIVEL: '+STR(nNroNiv,2)+'�'+;
			     'HASTA NIVEL: '+cNivFin+;
			     '�NRO COPIAS:'+STR(nNroCop,2)+' DE:'+;
			     STR(nCopias,2)+'�POR FAVOR ESPERE ...',cNomSis)
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

	       CitadosPrn(cNomSis,cNomEmp,cAnoUsr,nNroNiv,cJorTxt)
	      *Relaci�n de citados a entrevistas

	       nNroCop++

	    ENDDO
**********FIN IMPRESION DE N COPIAS

	  nNroNiv++
	  nNroCop := 1

       ENDDO
       SET FILTER TO
       CLOSE ALL
       RETURN NIL
*>>>>FIN IMPRESION DEL INFORME


***************************************************************************
*----------------------------FIN DEL PROGRAMA ----------------------------*
*--------------- DECLARACION DE FUNCIONES PARA EL PROGRAMA ---------------*
***************************************************************************

/*************************************************************************
* TITULO DEL PROGRAMA..: IMPRESION DE LOS CANDITOS A ENTREVISTAS         *
**************************************************************************

AUTOR: Nelson Fern�ndez G�mez       FECHA DE CREACION: JUL 29/96 LUN A
       Colombia, Bucaramanga        INICIO: 01:20 PM   JUL 29/96 LUN

OBJETIVOS:

1- Imprime la relaci�n de candidatos a entrevistar

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CitadosPrn(cNomSis,cNomEmp,cAnoUsr,nNroNiv,cJorTxt)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomSis                              // Nombre del sistema
       cNomEmp                              // Nombre de la empresa
       cAnoUsr                              // A�o del usuario
       cNroNiv                              // N�mero del nivel
       cJorTxt                              // Jornada Escogida */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"               // Impresora EPSON FX

       LOCAL nNroPag := 1                   // N�mero de p�gina
       LOCAL lTamAnc := .F.                 // .T. Tama�o Ancho
       LOCAL nLinTot := 2                   // L�neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C�digos de impresi�n iniciales
       LOCAL cCodFin := ''                  // C�digos de impresi�n finales
       LOCAL aNroCol := {}                  // Columnas de impresi�n
       LOCAL aTitulo := {}                  // T�tulos para impresi�n
       LOCAL cCabCol := ''                  // Encabezado de Columna
       LOCAL aCabSec := {}                  // Encabezado Secundario
       LOCAL nLenPrn := 0                   // Longitud l�nea de impresi�n
       LOCAL lCentra := .F.                 // .T. Centrar el informe
       LOCAL nColCab := 0                   // Columna del encabezado
       LOCAL bPagina := NIL                 // Block de P�gina
       LOCAL bCabeza := NIL                 // Block de Encabezado
       LOCAL bDerAut := NIL                 // Block Derechos de Autor
       LOCAL nLinReg := 1                   // L�neas del registro
       LOCAL cTxtPrn := ''                  // Texto de impresi�n
     *�Variables de informe

       LOCAL       i := 0                   // Contador
       LOCAL lSiorNo := .F.                 // Variable de decisi�n
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL lMisFec := .F.                 // .T. Misma Fecha
       LOCAL lMisHor := .F.                 // .T. Misma Hora
       LOCAL dFecAnt := CTOD('00/00/00')    // Fecha Anterior
       LOCAL cHorAnt := ''                  // Hora Anterior
     *�Variables espec�ficas

       LOCAL cNombreTes := ''               // Nombre del Estudiante
     *�Variables temporales de campos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR
       COUNT FOR VAL(SUBS(ADM->cCodigoGru,1,2)) == nNroNiv     .AND.;
		 !ADM->lRetiroAdm .AND. ADM->lEntrevAdm        .AND.;
		 !ADM->lSiCupoEst .AND. EMPTY(ADM->dFecNacEst) .AND.;
		 EMPTY(ADM->cLugNacEst);
	     TO nTotReg
       IF nTotReg == 0
	  SET DEVICE TO SCREEN
	  cError('NO APARECEN ESTUDIANTES PORA ENTREVISTAR PARA EL '+;
		 'NIVEL '+STR(nNroNiv,2))
	  RETURN NIL
       ENDIF
*>>>>FIN CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR

*>>>>DEFINICION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       aCabeza := {cNomEmp,cNomSis,;
		   'RELACION DE INSCRITOS A ENTREVISTAS PARA '+;
		   cAnoUsr+'. JORNADA: '+cJorTxt,;
		   '',;
		   cNomNiv(nNroNiv),;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}
       cCodIni := DRAFT_ON+PICA+CONDEN_OF
       cCodFin := NEGRA_OF+DOBGOL_OF
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {04,06,14,08,32,08}
       aTitulo := {'No. ',;
		   'CODIGO',;
		   'FECHA ',;
		   'HORA',;
		   'APELLIDOS Y NOMBRES ','OBSERV'}
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n17Stan
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>IMPRESION DEL TERMOMETRO
       Termometro(0,'IMPRIMIENDO EL GRUPO '+cNomNiv(nNroNiv))
       Termometro(10)
*>>>>FIN IMPRESION DEL TERMOMETRO

*>>>>ACTIVACION DE LA IMPRESORA
       IF !Printer_on(MTR->lPrnArcMtr)
	   RETURN NIL
       ENDIF
       @ PROW(),00 SAY INICIALIZA
       EVAL(bCabeza)
      *Impresi�n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT ADM
       GO TOP

       lMisFec := .F.
       lMisHor := .F.
       dFecAnt := ADM->dFecEntAdm
       cHorAnt := ADM->cHorEntAdm
       DO WHILE .NOT. ADM->(EOF())

**********IMPRESION DEL CONTENIDO DEL INFORME
	    IF !ADM->lRetiroAdm .AND. ADM->lEntrevAdm        .AND.;
	       !ADM->lSiCupoEst .AND. EMPTY(ADM->dFecNacEst) .AND.;
	       EMPTY(ADM->cLugNacEst)

	       cNombreTes  = RTRIM(ADM->cNombreEst)+' '+;
				   ADM->cApelliEst+SPACE(36)
	       cNombreTes := SUBS(cNombreTes,1,32)

	       aTitulo := {STR(++i,4),;
			   ADM->cNumeroAdm,;
			   IF(lMisFec .OR. EMPTY(ADM->dFecEntAdm),;
			      SPACE(aNroCol[3]),;
			      cFecha(ADM->dFecEntAdm)+' '+;
			      cDia(DOW(ADM->dFecEntAdm))+' '),;
			   IF(lMisHor .OR. EMPTY(ADM->cHorEntAdm),;
			      SPACE(aNroCol[4]),;
			      SUBS(cHoraSys(ADM->cHorEntAdm),6,8)),;
			   cNombreTes,;
			   IF (ADM->lExAlumAdm,'EXALUMNO',SPACE(08))}

	       cTxtPrn := cRegPrint(aTitulo,aNroCol)
	       lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
	    ENDIF
**********FIN IMPRESION DEL CONTENIDO DEL INFORME

**********AVANCE DEL SIGUIENTE REGISTRO
	    nAvance := INT(i/nTotReg)*100

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF

	    SELECT ADM
	    ADM->(DBSKIP())
**********FIN AVANCE DEL SIGUIENTE REGISTRO

**********ANALISIS DEL ROMPIEMIENTO
	    IF !ADM->lRetiroAdm .AND. ADM->lEntrevAdm        .AND.;
	       !ADM->lSiCupoEst .AND. EMPTY(ADM->dFecNacEst) .AND.;
	       EMPTY(ADM->cLugNacEst)

	       IF dFecAnt # ADM->dFecEntAdm .OR. lPagina(nLinReg)
		  lMisFec := .F.
		  dFecAnt := ADM->dFecEntAdm
	       ELSE
		  lMisFec := .T.
	       ENDIF

	       IF cHorAnt # ADM->cHorEntAdm .OR. lPagina(nLinReg)
		  lMisHor := .F.
		  cHorAnt := ADM->cHorEntAdm
	       ELSE
		  lMisHor := .T.
	       ENDIF
	    ENDIF
**********FIN ANALISIS DEL ROMPIEMIENTO

       ENDDO
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS
