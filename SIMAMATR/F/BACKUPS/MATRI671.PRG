/* SIMA - MATRICULA ACADEMICA

MODULO     : MATRICULAS
SUBMODULO..: CANCELACION                               MODULO No. 671

**************************************************************************
* TITULO..: IMPRESION FORMATO DE CANCALACION DE MATRICULA                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 02/2000 JUE A
       Colombia, Bucaramanga        INICIO: 04:25 PM   NOV 02/2000 JUE

REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Permite imprimir el formato de la cancelaci¢n de la matr¡cula.

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_671(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-MATR.PRG"       // Archivos del Sistema
       #INCLUDE "EPSONFX1.PRG"              // Impresora EPSON FX
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas

       #DEFINE  PAGINA33 CHR(27)+'C'+CHR(33)// P gina de 33 l¡neas

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
     *ÀVariables generales

       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal
       LOCAL nSdoAct := 0                   // Saldo Actual

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
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

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+FSimMtr,'MTR',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 fSimaCo,'SCO',NIL,lSiRed,0})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf) .OR.;
	  !lUseMaeMtr(lShared,PathUno+'\'+cPatSis,cMaeAlu,SUBS(cAnoUsr,3,2))
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTEN ESTUDIANTES GRABADOS')

       CASE MTR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

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

*>>>>ACTIVACION DE LA IMPRESORA
       IF MTR->lPrnArcMtr
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'Retiro'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,MTR->cOpcPrnMtr,.F.,.T.)
	  IF EMPTY(nOpcPrn)
	     CloseAll()
	     RETURN NIL
	  ENDIF
       ENDIF
       SendCodes(INICIALIZA+PROPOR_OF)
       SendCodes(CONDEN_OF+PICA+NEGRA_ON+DRAFT_ON+PAGINA33)
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DE LOS ENCABEZADOS
       SET DEVICE TO SCREEN
       nNroFil := nMarco(nFilPal+1,'POR FAVOR ENTRE EL CODIGO '+;
				   'DEL ESTUDIANTE',22,'°')
       aTamCol := {06,06,40}
       aTitulo := {'CODIGO','CURSO ','NOMBRE'}
       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
       SET DEVICE TO PRINT
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>IMPRESION DE LOS FORMATOS DE CANCELACION DE MATRICULA
       nNroFil++
       DO WHILE .T.

**********CAPTURA DEL CODIGO DEL ESTUDIANTE
	    SET DEVICE TO SCREEN
	    cCodigoTes := cLeeCodEst(nNroFil,aNroCol[1],cMaeAlu,@cMaeAct)
	    IF LASTKEY() == K_ESC .OR. VAL(cCodigoTes) == 0 .OR.;
	       EMPTY(cMaeAct)
	       EXIT
	    ENDIF
	    cNombreTes := ALLTRIM(RTRIM(&cMaeAct->cApelliEst)+' '+;
					&cMaeAct->cNombreEst)
	    @ nNroFil,aNroCol[2] SAY &cMaeAct->cCodigoGru
	    @ nNroFil,aNroCol[3] SAY cNombreTes
**********FIN CAPTURA DEL CODIGO DEL ESTUDIANTE

**********PREPARACION DE LAS VARIABLES DE ARCHIVOS
	    FileCli := PathDos+'\'+cPatSis+'\CLIENTES\CL'+;
		       &cMaeAct->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVOS

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !EMPTY(PathDos)
	       IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry)
		  cError('ABRIENDO EL ARCHIVO DE CLIENTES')
		  LOOP
	       ENDIF
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********LOCALIZACION DEL CODIGO
	    nSdoAct := 0
	    IF !EMPTY(PathDos)
	       IF !lLocCodigo('cCodigoEst','CLI',cCodigoTes)
		  cError(cNombreTes+' NO EXISTE EN LOS '+;
			 'CLIENTES DEL GRUPO: '+&cMaeAct->cCodigoGru)
		  LOOP
	       ENDIF
	       nSdoAct := CLI->nSdoActCli+CLI->nSdoMorCli
	    ENDIF
**********FIN LOCALIZACION DEL CODIGO

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('GRUPO: '+&cMaeAct->cCodigoGru+'ºESTUDIANTE: '+;
			SUBS(cNombreTes+SPACE(30),1,30),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********IMPRESION DEL FORMATO DE CANCELACION DE MATRICULA
	    SET DEVICE TO PRINT
	    DO CASE
	    CASE .T.
		 FinMatri01(cNomEmp,cNomSis,cAnoUsr,cJorTxt,cMaeAct,;
			    &cMaeAct->cCodigoEst,cNombreTes,;
			    &cMaeAct->cCodigoGru,nSdoAct)
		 EJECT
	    ENDCASE
**********FIN IMPRESION DEL FORMATO DE CANCELACION DE MATRICULA

**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    IF nNroFil > 21

*--------------IMPRESION DEL ULTIMO REGISTRO
		 SET DEVICE TO SCREEN
		 nNroFil := nMarco(nFilPal+1,'POR FAVOR ENTRE EL CODIGO '+;
					     'DEL ESTUDIANTE',22,'°')
		 @ nNroFil,nNroCol SAY cMsgTxt

		 nNroFil++
		 SET COLOR TO I
		 @ nNroFil,aNroCol[1] SAY cCodigoTes
		 @ nNroFil,aNroCol[2] SAY &cMaeAct->cCodigoGru
		 @ nNroFil,aNroCol[3] SAY cNombreTes
		 SET COLOR TO

		 nNroFil++
*--------------FIN IMPRESION DEL ULTIMO REGISTRO

	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

       ENDDO
       VerPrn(nOpcPrn,FilePrn)
       CloseAll()
       RETURN NIL
*>>>>FIN IMPRESION DE LOS FORMATOS DE CANCELACION DE MATRICULA

/*************************************************************************
* TITULO..: FORMATO DE CANCELACION DE MATRICULA No. 01                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 02/2000 JUE A
       Colombia, Bucaramanga        INICIO: 04:25 PM   NOV 02/2000 JUE


OBJETIVOS:

1- Imprime el formato de cancelaci¢n de la matr¡cula.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION FinMatri01(cNomEmp,cNomSis,cAnoUsr,cJorTxt,;
		    cMaeAct,cCodEst,cNomEst,cCodGru,nSdoAct)

*>>>>DESCRIPCION DE PARAMETROS
/*     cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombres del Sistema
       cAnoUsr                              // A¤o del sistema
       cJorTxt                              // Jornada escogida
       cMaeAct			            // Maestro Actual
       cCodEst                              // C¢digo del Estudiante
       cNomEst                              // Nombre del Estudiante
       cCodGru                              // C¢digo del Grupo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL nNroCol := 0                   // N£mero de Columnas
       LOCAL cTxtPrn := ''                  // Texto de Impresi¢n
       LOCAL aFirmas := {}                  // Firmas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>PREPARACION DE LAS FIRMAS
       aFirmas := {{ALLTRIM(SCO->cGerentCon),ALLTRIM(SCO->cNitGerCon),;
		   'RECTOR'},;
		   {ALLTRIM(SCO->cSecretCon),ALLTRIM(SCO->cNitSecCon),;
		   'SECRETARIO(A)'}}
*>>>>FIN PREPARACION DE LAS FIRMAS

*>>>>IMPRESION DEL FORMATO DE CANCELACION DE MATRICULA
       nNroCol := ((40-LEN(ALLTRIM(cNomEmp))))/2
       SendCodes(DOBANC_ON)
       @ PROW(),nNroCol SAY cNomEmp
       SendCodes(DOBANC_OF)

       cTxtPrn := 'FORMATO DE CANCELACION DE MATRICULA'
       nNroCol := ((80-LEN(cTxtPrn)))/2
       @ PROW()+2,nNroCol SAY cTxtPrn

       cTxtPrn := 'JORNADA: '+cJorTxt+'. A¥O: '+cAnoUsr
       nNroCol := ((80-LEN(cTxtPrn)))/2
       @ PROW()+1,nNroCol SAY cTxtPrn

       cTxtPrn := 'ALUMNO(A): '+cNomEst
       @ PROW()+2,02 SAY cTxtPrn

       @ PROW()+1,02 SAY 'CODIGO: '+cCodEst+;
			 ' CURSO: '+cCodGru+SPACE(10)+;
			 'FECHA DE RETIRO: (MM/DD/AAAA): __/__/____'
     *ÀImpresi¢n del encabezado.

       IF nSdoAct == 0
	  @ PROW()+2,02 SAY 'ULTIMO MES AUTORIZADO PARA PAGAR: '+;
			    'ENE FEB MAR ABR MAY JUN JUL AGO SEP OCT NOV DIC'
       ELSE
	  @ PROW()+2,02 SAY 'ULTIMO MES AUTORIZADO PARA PAGAR: '+;
			    'ENE FEB MAR ABR MAY JUN JUL AGO SEP OCT NOV DIC'

	  @ PROW()+2,02 SAY 'A LAS '+TIME()+' DE '+cFecha(DATE())+;
			    ' DEBE LA SUMA DE $ '+;
			    ALLTRIM(TRANS(nSdoAct,"####,###,###"))
       ENDIF

       @ PROW()+2,02 SAY 'ULTIMO PERIODO HABILITADO: '+;
			 'P1:__ P2:__ P3:__ P4:__ P5:__'
     *ÀImpresi¢n del encabezado.

       @ PROW()+2,02 SAY 'MOTIVO DEL RETIRO: '+REPL('_',61)
       FOR i := 1 TO 2
	  @ PROW()+1,02 SAY REPL('_',80)
       NEXT
     *ÀImpresi¢n del encabezado.

       @ PROW()+2,02 SAY 'OBSERVACION: '+REPL('_',67)
       FOR i := 1 TO 2
	  @ PROW()+1,02 SAY REPL('_',80)
       NEXT
     *ÀImpresi¢n del encabezado.

       SendCodes(CONDEN_ON)
       Firmas(n17Stan,4,aFirmas)
       SendCodes(CONDEN_OF)
      *Impresi¢n firmantes del libro

       @ PROW()+3,02 SAY '>'+REPL('=',78)+'<'

       RETURN NIL
*>>>>FIN IMPRESION DEL FORMATO DE CANCELACION DE MATRICULA
