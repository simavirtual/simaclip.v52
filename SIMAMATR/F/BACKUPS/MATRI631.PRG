/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : MATRICULAS
SUBMODULO...: IMPRESIONES         MODULO No. 631

**************************************************************************
* NOMBRE DEL PROGRAMA..: CARTE631.PRG                                    *
* TITULO DEL PROGRAMA..: IMPRESION DEL TOTAL DE ALUMNOS MATRICULADOS     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 14/96 JUE A
       Colombia, Bucaramanga        INICIO: 04:40 PM   AGO 14/96 JUE

REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Imprime el total de alumnos matriculados

2- Retorna NIL


SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_631(aParam1,aParam2,aParam3)

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

       LOCAL nCopias := 0                   // N£meros de copias a imprimir
       LOCAL nNroCop := 1                   // N£mero de copia

       LOCAL GetList := {}                  // Variable del sistema
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

*>>>>AREAS DE TRABAJO
       aUseDbf := {}

       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 fSimaCo,'SCO',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FSimMtr,'MTR',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE MTR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

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

*>>>>LECTURA DEL NUMERO DE COPIAS
       @ nFilInf+1,nColInf SAY "COPIAS:" GET nCopias PICT "99"
       READ
       IF EMPTY(nCopias)
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL NUMERO DE COPIAS

*>>>>IMPRESION DE N COPIAS
       DO WHILE nNroCop <= nCopias

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('ºNRO COPIAS:'+STR(nNroCop,2)+' DE:'+;
			STR(nCopias,2)+'ºPOR FAVOR ESPERE ...',cNomSis)

	    PrnTotMat(lShared,cNomEmp,cNomSis,cPatSis,PathUno,;
		      cNomUsr,cAnoUsr,cMaeAlu,cJorTxt)
	   *Impresi¢n totales matriculados

	    nNroCop++
**********FIN IMPRESION DE LA LINEA DE ESTADO

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN IMPRESION DE N COPIAS

/*************************************************************************
* TITULO DE LA FUNCION..: IMPRESION DEL TOTAL DE MATRICULADOS            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 02/94 VIE A
						       DIC 02/94 VIE
OBJETIVOS:

1)- Imprime el total de matriculados por niveles

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnTotMat(lShared,cNomEmp,cNomSis,cPatSis,;
		   PathUno,cNomUsr,cAnoUsr,cMaeAlu,;
		   cJorTxt)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cNomEmp                              // Nombre de la empresa
       cPatSis                              // Path del sistema
       PathUno                              // Path de Integraci¢n Uno
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del Usuario
       cNomSis                              // Nombre del sistema
       cMaeAct                              // Maestros Actualizados
       cJorTxt                              // Jornada Escogida */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
      #INCLUDE "EPSONFX.PRG"  // Impresora EPSON FX
      #INCLUDE "ARC-MATR.PRG"      // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL cMaeAct := ''                  // Maestro Actual

       LOCAL     i,j := 0                   // Contadores
       LOCAL cOpcSys := ''                  // Opci¢n del Sistema
       LOCAL nNroIso := ''                  // N£mero Iso del Informe
       LOCAL cCodIso := ''                  // C¢digo Iso del Informe
       LOCAL aTitIso := ''                  // T¡tulo Iso del Informe
       LOCAL cPiePag := ''                  // Pie de P gina por defecto
       LOCAL aPieIso := {}		    // Textos del pie de p gina
       LOCAL nTotPie := 0                   // Total de Pie de p ginas
       LOCAL aMezIso := {}                  // Campos a Mesclar
       LOCAL bInsIso := NIL                 // Block de Gestion Documental
       LOCAL oBrowse := NIL                 // Browse del Archivo
     *ÀGestion Documental

       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL nNroCol := 0                   // Columna de impresion
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL nTotReg := 22                  // Total de registros
       LOCAL lPagina := .T.                 // .T. Cambio de p gina
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitulo := {}                  // T¡tulos para impresi¢n
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL bDerAut := NIL                 // Block Derechos de Autor

       LOCAL       k := 0                      // Contador
       LOCAL nNroNiv := 0                   // N£mero de niveles

       LOCAL aMatAno := {}                  // Matriculas del A¤o
       LOCAL aMatAnt := {}                  // Matriculas del A¤o Anterior
       LOCAL aTotMat := {}                  // Total Maticulados
       LOCAL aNroNiv := {}                  // N£mero de Niveles
       LOCAL aMtrMes := {}                  // Matriculas por Meses a¤o actual
       LOCAL aMesAnt := {}                  // Matricuals por Meses a¤o anterior
       LOCAL cAnoAnt := ''                  // A¤o Anterior

       LOCAL nEstAno := 0                   // Total Estudiantes Activos
       LOCAL nRetAno := 0                   // N£mero de Retirados
       LOCAL nEstAnt := 0                   // Total Estudiantes Activos
       LOCAL nRetAnt := 0                   // N£mero de Retirados
       LOCAL nDifEst := 0                   // Diferencia de Estudiantes
       LOCAL nTotDif := 0                   // Total Diferencia
       LOCAL cUnoAnt := ''                  // Path de Integraci¢n
       LOCAL GetList := {}                  // Variable del sistema

       FIELD cCodigoGru                     // C¢digo del Grupo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DEL PATH ANTERIOR
       cAnoAnt := STR(VAL(cAnoUsr)-1,4)
       cUnoAnt := STUFF(PathUno+'\'+cPatSis,AT(cAnoUsr,PathUno+'\'+cPatSis),4,cAnoAnt)
*>>>>FIN CALCULO DEL PATH ANTERIOR

*>>>>CALCULO DEL TOTAL DE MATRICULADOS
       aMatAno := aTotMat(lShared,cNomEmp,cNomSis,;
			  PathUno+'\'+cPatSis,;
			  cAnoUsr,cMaeAlu,cJorTxt,;
			  aMtrMes)

       aMatAnt := aTotMat(lShared,cNomEmp,cNomSis,;
			  cUnoAnt,cAnoAnt,cMaeAlu,cJorTxt,aMesAnt)

       IF EMPTY(aMatAnt) .OR. EMPTY(aMatAno)
	  RETURN NIL
       ENDIF
*>>>>FIN CALCULO DEL TOTAL DE MATRICULADOS

*>>>>ESTUDIANTES MATRICULADOS A¥O ANTERIOR
       FOR i := 1 TO LEN(aMatAnt)
	   AADD(aTotMat,{0,0,0,0,0})
	   AADD(aNroNiv,0)
	     aNroNiv[i] := aMatAnt[i,1]   // N£mero del Nivel
	   aTotMat[i,1] := aNroNiv[i]     // N£mero del Nivel
	   aTotMat[i,2] := aMatAnt[i,2]   // Estudiantes Activos
	   aTotMat[i,3] := aMatAnt[i,3]   // Estudiantes Retirados
       ENDFOR
*>>>>FIN ESTUDIANTES MATRICULADOS A¥O ANTERIOR

*>>>>ESTUDIANTES MATRICULADOS A¥O ACTUAL
       FOR i := 1 TO LEN(aMatAno)
	   k := ASCAN(aNroNiv,aMatAno[i,1])
	   IF k == 0
	      AADD(aTotMat,{0,0,0,0,0})
	      aTotMat[i,1] := aMatAno[i,1]  // N£mero del Nivel
	      aTotMat[i,4] := aMatAno[i,2]  // Estudiantes Activos
	      aTotMat[i,5] := aMatAno[i,3]  // Estudiantes Retirados
	   ELSE
	      IF aTotMat[i,1] == aMatAno[i,1]
		 aTotMat[i,4] := aMatAno[i,2]  // Estudiantes Activos
		 aTotMat[i,5] := aMatAno[i,3]  // Estudiantes Retirados
	      ELSE
		 cError('NO COINCIDES LOS NIVELES',;
			aTotMat[i,1]+' # '+aMatAno[i,1])
	      ENDIF
	   ENDIF
       ENDFOR
*>>>>FIN ESTUDIANTES MATRICULADOS A¥O ACTUAL

*>>>>GESTION DOCUMENTAL DEL INFORME
       nLenPrn := PCL('n17Stan')

       nNroIso := 631
     *ÀN£mero de identificaci¢n del informe

       cOpcSys := '<MATRICULAS><IMPRESIONES><TOTAL MATRICULADOS>'
     *ÀOpci¢n del sistema del informe

       aMezIso := {}
       AADD(aMezIso,{'<cAnoUsr>',cAnoUsr})
       AADD(aMezIso,{'<cJorTxt>',cJorTxt})
     *ÀCampos a sustituir

       aTitIso := {}
       AADD(aTitIso,'TOTAL DE ESTUDIANTES MATRICULADOS.'+;
		    'A¥O:<cAnoUsr> JORNADA:<cJorTxt>')  // T¡tulo Uno
       AADD(aTitIso,'')                                 // T¡tulo Dos
       AADD(aTitIso,'')                                 // T¡tulo Tres
     *ÀT¡tulos del Informe por defecto

       cPiePag := ALLTRIM(SCO->cPiePagCon)
       IF !EMPTY(cPiePag)
	  cPiePag := SPACE((nLenPrn-LEN(cTxtPrn))/2)+cPiePag
       ENDIF

       aPieIso := {}
       AADD(aPieIso,'')                 // Pie de p gina Uno
       AADD(aPieIso,'')                 // Pie de p gina Dos
       AADD(aPieIso,IF(EMPTY(cPiePag),'',cPiePag))  // Pie de p gina Tres
     *ÀPie de p ginas por defecto

       bInsIso := {||lModRegIso(lShared,cNomUsr,oBrowse,;
				nNroIso,aTitIso[1],cOpcSys)}
     *ÀInclusi¢n o modificaci¢n de la gesti¢n docuemental
*>>>>FIN GESTION DOCUMENTAL DEL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF MTR->lPrnArcMtr
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'TotalMtr'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,MTR->cOpcPrnMtr,.F.,.F.,bInsIso,PathDoc)
	  IF EMPTY(nOpcPrn)
	      RETURN NIL
	  ENDIF
       ENDIF
       @ PROW(),00 SAY INICIALIZA
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>SUSTITUCION DE TEXTO
       DetalleIso(nNroIso,@cCodIso,@aTitIso,@aPieIso)

       IF !EMPTY(cCodIso)
	  cCodIso := 'ISO:'+cCodIso
       ENDIF

       FOR i := 1 TO LEN(aTitIso)
	   FOR j := 1 TO LEN(aMezIso)
	       aTitIso[i] := cReplTxt(aMezIso[j,1],aMezIso[j,2],aTitIso[i])
	   ENDFOR
       ENDFOR

       nTotPie := 0
       FOR i := 1 TO LEN(aPieIso)
	   IF EMPTY(aPieIso[i])
	      LOOP
	   ENDIF
	   nTotPie++
       ENDFOR
*>>>>FIN SUSTITUCION DE TEXTO

*>>>>ENCABEZADO DEL INFORME
       EncabezPrn(cNomEmp,cNomSis+cCodIso,;
		  aTitIso[1],;
		  aTitIso[2],;
		  aTitIso[3],;
		  nNroPag++,;
		  cTotPagina(nTotReg))
       bDerAut := {||PiePagPrn(aPieIso,nLenPrn)}
*>>>>FIN ENCABEZADO DEL INFORME

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {12,04,04,04}
       aTitulo := {'NIVELES',;
		   cAnoAnt,cAnoUsr,'DIF'}
       cTxtPrn := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>IMPRESION DEL ENCABEZADO DE COLUMNA
       nLenPrn := n10Stan
       @ PROW(),00 SAY DRAFT_ON+PICA
       @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY REPL('-',LEN(cTxtPrn))
       @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn
       @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY REPL('-',LEN(cTxtPrn))
       @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
*>>>>FIN IMPRESION DEL ENCABEZADO DE COLUMNA

*>>>>IMPRESION DE LOS NIVELES
       FOR i := 1 TO LEN(aTotMat)

	   nEstAnt += aTotMat[i,2]
	   nRetAnt += aTotMat[i,3]

	   nEstAno += aTotMat[i,4]
	   nRetAno += aTotMat[i,5]

	   nDifEst := aTotMat[i,4]-aTotMat[i,2]
	   nTotDif += nDifEst

	   aTitulo := {cNomNiv(aTotMat[i,1]),;
		       STR(aTotMat[i,2],4),;
		       STR(aTotMat[i,4],4),;
		       STR(nDifEst,4)}

	   cTxtPrn := cRegPrint(aTitulo,aNroCol)
	  *Prepara la variable de impresion

	   @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn
       ENDFOR
*>>>>FIN IMPRESION DE LOS NIVELES

*>>>>IMPRESION DE LOS TOTALES
       @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY SPACE(14)+REPL('-',4)+;
					       SPACE(01)+REPL('-',4)+;
					       SPACE(01)+REPL('-',4)

       @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY 'ESTUDIANTES'+;
					       SPACE(01)+'=>'+STR(nEstAnt,4)+;
					       SPACE(01)+STR(nEstAno,4)+;
					       SPACE(01)+STR(nTotDif,4)

       @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY 'RETIRADOS'+;
					       SPACE(03)+'=>'+STR(nRetAnt,4)+;
					       SPACE(01)+STR(nRetAno,4)+;
					       SPACE(01)+STR(nRetAno-nRetAnt,4)


       @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY 'MATRICULADOS'+'=>'+;
					       STR(nEstAnt+nRetAnt,4)+;
					       SPACE(01)+;
					       STR(nEstAno+nRetAno,4)+;
					       SPACE(01)+;
					       STR(nTotDif+(nRetAno-nRetAnt),4)


       IF !EMPTY(aMtrMes)
	  aMtrMes := ASORT(aMtrMes,,,{|x,y|x[1] < y[1]})
	  @ PROW(),00 SAY CONDEN_ON
	  @ PROW()+1,00 SAY ''
	  PrnArrTot(00,aMtrMes,1,cAnoUsr)
	  PrnArrTot(00,aMtrMes,2,cAnoUsr)
       ENDIF

       IF !EMPTY(aMesAnt)
	  aMesAnt := ASORT(aMesAnt,,,{|x,y|x[1] < y[1]})
	  @ PROW(),00 SAY CONDEN_ON
	  @ PROW()+1,00 SAY ''
	  PrnArrTot(00,aMesAnt,1,cAnoAnt)
	  PrnArrTot(00,aMesAnt,2,cAnoAnt)
       ENDIF

       nLenPrn := PCL('n17Stan')
       EVAL(bDerAut)
      *Derechos de Autor

       SET DEVICE TO SCREEN
       VerPrn(nOpcPrn,FilePrn)
       RETURN NIL
*>>>>FIN IMPRESION DE LOS TOTALES


FUNCTION aTotMat(lShared,cNomEmp,cNomSis,cIntUno,cAnoUsr,cMaeAlu,cJorTxt,;
		 aMtrMes)

*>>>>PARAMATROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cNomEmp                              // Nombre de la empresa
       cIntUno                              // Path de Integraci¢n Uno
       cAnoUsr                              // A¤o del Usuario
       cNomSis                              // Nombre del sistema
       cMaeAct                              // Maestros Actualizados
       cJorTxt                              // Jornada Escogida
       aMtrMes                              // Matriculas por Meses */
*>>>>FIN PARAMATROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
      #INCLUDE "ARC-MATR.PRG"      // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL cMaeAct := ''                  // Maestro Actual

       LOCAL nNroCol := 0                   // Columna de impresion
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL nTotReg := 22                  // Total de registros
       LOCAL lPagina := .T.                 // .T. Cambio de p gina
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitulo := {}                  // T¡tulos para impresi¢n
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n

       LOCAL       i := 0                   // Contador
       LOCAL nNroNiv := 0                   // N£mero de niveles
       LOCAL nNroRet := 0                   // N£mero de Retirados
       LOCAL nNroMat := 0                   // N£mero de matriculado
       LOCAL nTotMat := 0                   // Total Matriculados

       LOCAL GetList := {}                  // Variable del sistema

       FIELD cCodigoGru                     // C¢digo del Grupo


      LOCAL aTotMat := {}                  // Total Matriculados
*>>>>FIN DECLARACION DE VARIABLES

*>>>>INICIALIZACION DE LOS MESES
       FOR i := 1 TO 12
	   AADD(aMtrMes,{i,cMes(i,3),0})
       ENDFOR
*>>>>FIN INICIALIZACION DE LOS MESES

*>>>>IMPRESION DE LOS NIVELES
       FOR i := 1 TO LEN(cMaeAlu)/3

**********SELECION DE LAS AREAS DE TRABAJO
	    cMaeAct := SUBS(cMaeAlu,i*3-2,3)
	    IF !lUseMaeMtr(lShared,cIntUno,cMaeAct,cAnoSis,.T.,.F.) .OR.;
	       !lUseDbf(.T.,cIntUno+'\'+cMaeAct+'\'+;
			    FileNiv+SUBS(cAnoUsr,3,2)+ExtFile,'NIV',NIL,lShared)
	       cError('ABRIENDO ARCHIVOS')
	       CloseDbf(cMaeAct)
	       CloseDbf('NIV')
	       EXIT
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE NIV->(RECCOUNT()) == 0
		 cError('NO EXISTEN NIVELES GRABADOS')

	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE
	    IF lHayErr
	       CloseDbf(cMaeAct)
	       CloseDbf('NIV')
	       EXIT
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********IMPRESION DEL INFORME
	    SELECT NIV
	    GO TOP
	    DO WHILE .NOT. NIV->(EOF())

*--------------FILTRACION DEL MAESTRO
		 SELECT &cMaeAct
		 SET FILTER TO SUBS(cCodigoGru,1,2) == NIV->cCodigoNiv
		 GO TOP
*--------------FIN FILTRACION DEL MAESTRO

*--------------ANALISIS DE ESTUDIANTES
		 AADD(aTotMat,{0,0,0})
		 aTotMat[LEN(aTotMat),1] := NIV->cCodigoNiv

		 nNroMat := 0
		 DO WHILE .NOT. EOF()

*                   IMPRESION DE LA LINEA DE ESTADO
		      LineaEstado(cMaeAct+' DEL A¥O: '+cAnoUsr+' CONTANDO...'+;
				  ALLTRIM(STR(RECNO(),6)),cNomSis)
*                   FIN IMPRESION DE LA LINEA DE ESTADO

*                   CONTEO DE LOS ESTUDIANTES
		      IF &cMaeAct->lRetiroEst
			 aTotMat[LEN(aTotMat),3]++
			 nNroRet++
		      ELSE
			 nNroMat++
			 aTotMat[LEN(aTotMat),2]++
		      ENDIF
*                   FIN CONTEO DE LOS ESTUDIANTES

*                   CONTEO SEGUN EL MES
		      VlrConMtr(MONTH(&cMaeAct->dFecMatEst),;
				cMes(MONTH(&cMaeAct->dFecMatEst),3),1,aMtrMes)
*                   FIN CONTEO SEGUN EL MES


		    SKIP

		 ENDDO
		 nTotMat += nNroMat
*--------------FIN ANALISIS DE ESTUDIANTES

	       SELECT NIV
	       SKIP

	    ENDDO
	    SELECT &cMaeAct
	    SET FILTER TO

	    CloseDbf('NIV')
	    CloseDbf(cMaeAct)
**********FIN IMPRESION DEL INFORME

       ENDFOR
       RETURN aTotMat
*>>>>FIN IMPRESION DE LOS NIVELES

/*************************************************************************
* TITULO..: ACUMULACION DE CONCEPTOS                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 03/2003 MIE A
       Bucaramanga, Colombia        INICIO: 11:30 PM   SEP 03/2003 MIE

OBJETIVOS:

1- Permite acumular los valores de los conceptos

2- Retorna Nil


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION VlrConMtr(cCodCon,cNomCon,nVlrCon,aVlrCon)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodCon                              // C¢digo del Concepto
       cNomCon                              // Nombre del Concepto
       nVlrCon                              // Valor del Concepto
       aVlrCon                              // @Valor de los Conceptos */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL i := 0                         // Contador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ACUMUACION DE LOS CONCEPTOS
       IF EMPTY(aVlrCon)
	  AADD(aVlrCon,{cCodCon,cNomCon,nVlrCon})
       ELSE
	  i := ASCAN(aVlrCon,{|aArr|aArr[1] == cCodCon})
	  IF i == 0
	     AADD(aVlrCon,{cCodCon,cNomCon,nVlrCon})
	  ELSE
	     aVlrCon[i,3] += nVlrCon
	  ENDIF
       ENDIF
       RETURN NIL
*>>>>FIN ACUMUACION DE LOS CONCEPTOS


/*************************************************************************
* TITULO..: IMPRESION DE LOS CONCEPTOS DESCRIMINADOS                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 05/2003 VIE A
       Bucaramanga, Colombia        INICIO: 04:00 PM   SEP 05/2003 VIE

OBJETIVOS:

1- Imprime el valor de los conceptos descriminados

2- Retorna Nil


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnArrTot(nNroCol,aVlrCon,nTipPrn,cAnoUsr)

*>>>>DESCRIPCION DE PARAMETROS
/*     nNroCol                              // N£mero de Columna
       aVlrCon                              // Valor Por Conceptos
       nTipPrn                              // Tipo de Impresi¢n
       cAnoUsr                              // A¤o del Usuario */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL aNroCol := {}                  // N£mero de Columnas
       LOCAL aTitulo := {}                  // T¡tulos para impresi¢n
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nVlrCon := 0                   // Valor del Concepto
       LOCAL nTotCon := 0                   // Valor total de los Conceptos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DEL VALOR DE LOS CONCEPTOS
       nTipPrn := IF(EMPTY(nTipPrn),1,nTipPrn)
       FOR i:=1 TO LEN(aVlrCon)

	   AADD(aNroCol,6) // Ojo el 6 debe ser variable
	   DO CASE
	   CASE nTipPrn == 1   // Encabezado
		AADD(aTitulo,aVlrCon[i,2])

	   CASE nTipPrn == 2   // Registro en fila

		nVlrCon := aVlrCon[i,3]
		nTotCon += nVlrCon

		AADD(aTitulo,TRANS(nVlrCon,"#,###"))

	   CASE nTipPrn == 3   // Registros en Columna

		nVlrCon := aVlrCon[i,3]
		nTotCon += nVlrCon

		cTxtPrn := aVlrCon[i,2]+'=>'+TRANS(nVlrCon,"#,###")
		@ PROW()+1,nNroCol SAY cTxtPrn

	   ENDCASE

       ENDFOR
*>>>>FIN IMPRESION DEL VALOR DE LOS CONCEPTOS

*>>>>IMPRESION DEL TOTAL
       AADD(aNroCol,12)
       DO CASE
       CASE nTipPrn == 1

	    AADD(aTitulo,'TOTAL')
	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    @ PROW()+1,nNroCol SAY cTxtPrn

       CASE nTipPrn == 2

	    AADD(aTitulo,TRANS(nTotCon,"#,###"))
	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    @ PROW()+1,nNroCol SAY cTxtPrn+' A¥O: '+cAnoUsr

       CASE nTipPrn == 3

	    cTxtPrn := SPACE(18)+REPL('=',12)
	    @ PROW()+1,nNroCol SAY cTxtPrn

	    cTxtPrn := 'TOTAL'+SPACE(11)+'=>'+TRANS(nTotCon,"#,###")
	    @ PROW()+1,nNroCol SAY cTxtPrn

       ENDCASE
       RETURN NIL
*>>>>IMPRESION DEL TOTAL