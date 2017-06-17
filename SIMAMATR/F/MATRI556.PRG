/* SIMA - MATRICULA ACADEMICA

MODULO      : MODULO PRINCIPAL
SUBMODULO...: PAGOS        MODULO No. 556

**************************************************************************
* TITULO..: PAGOS PARA DIAN                                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 29/2014 MIE A
       Colombia, Bucaramanga        INICIO: 08:00 PM   ABR 29/2014 MIE

OBJETIVOS:

1- Crea un archivo dbf con extensi¢n xls con los pagos de matriculas
   del primer contratante.

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_556(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-MATR.PRG"      // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
     *ÀVariables generales

       LOCAL PathAct := ''                  // Path Actual
       LOCAL fArchvo := ''                  // Nombre del Archivo
       LOCAL aDbfStr := {}                  // Estructura del Archivo

       LOCAL nTipPer := 0                   // Tipo de Persona

       LOCAL cCodEst := ''
       LOCAL cCodGru := ''
       LOCAL cApelli := ''
       LOCAL cNombre := ''
       LOCAL cTipNit := ''
       LOCAL cDocNit := ''
       LOCAL cApell1 := ''
       LOCAL cApell2 := ''
       LOCAL cNombr1 := ''
       LOCAL cNombr2 := ''
       LOCAL cDirecc := ''
       LOCAL cCiudad := ''
       LOCAL nVlrMtr := ''
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

       LOCAL nOpcion := 0                   // N£mero de Opci¢n.
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

*>>>>DECLARACION DE LA ESTRUCTURA
       AADD(aDbfStr,{"cCodEst","Character",006,0}) // C¢digo del Estudiante
       AADD(aDbfStr,{"cCodGru","Character",004,0}) // Codigo del grupo

       AADD(aDbfStr,{"cApelli","Character",030,0}) // Apellido
       AADD(aDbfStr,{"cNombre","Character",030,0}) // Nombre

       AADD(aDbfStr,{"cTipNit","Character",003,0}) // Tipo de Documento
       AADD(aDbfStr,{"cDocNit","Character",016,0}) // Documento de Identidad

       AADD(aDbfStr,{"cApell1","Character",030,0}) // Apellido1
       AADD(aDbfStr,{"cApell2","Character",030,0}) // Apellido2

       AADD(aDbfStr,{"cNombr1","Character",030,0}) // Nombre1
       AADD(aDbfStr,{"cNombr2","Character",030,0}) // Nombre2

       AADD(aDbfStr,{"cNomEmp","Character",030,0}) // Razon Social
       AADD(aDbfStr,{"cDirecc","Character",100,0}) // Direccion de la casa
       AADD(aDbfStr,{"cCiudad","Character",030,0}) // Ciudad

       AADD(aDbfStr,{"nVlrMtr","Numeric"  ,014,2}) // Valor Matricula
       AADD(aDbfStr,{"dFecPag","Date"     ,008,0}) // Fecha de Pago
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       fArchvo := 'DIANMTR.XLS'
       PathAct := cPathAct()
       DO CASE
       CASE nCd(PathDoc) == 0
	    DBCREATE(fArchvo,aDbfStr,'DBFNTX')

       CASE nCd(PathDoc) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathDoc)

       CASE nCd(PathDoc) == -5
	    cError('NO TIENE DERECHOS EN: '+PathDoc)
       ENDCASE
       nCd(PathAct)
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 FilePer,'PER',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+FileTar,'TAR',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FilePag,'PAG',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathDoc+'\'+fArchvo,'XLS',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,PathUno+'\'+cPatSis,cMaeAlu,cAnoSis) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>RECORRIDO DE LOS PAGOS
       SELECT PAG
       PAG->(DBGOTOP())
       DO WHILE .NOT. PAG->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstados('REGISTRO No. '+PAG->(STR(RECNO(),4))+'/'+;
			  PAG->(STR(RECCOUNT(),4)),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********ANALISIS DE DECISION
	    IF PAG->cMatricPag <> '1'
	       PAG->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS DE DECISION

**********BUSQUEDA DEL ESTUDIANTE
	    cMaeAct := cMaeAct(PAG->cCodigoEst,cMaeAlu)
	    IF EMPTY(cMaeAct)
	       cMaeAct := ''
	    ENDIF
	    IF !(cMaeAct $ cMaeAlu)
	       PAG->(DBSKIP())
	       LOOP
	    ENDIF

	    cCodGru := &cMaeAct->cCodigoGru
**********FIN BUSQUEDA DEL ESTUDIANTE

**********BUSQUEDA DEL CONTRATANTE
	    nTipPer := nTipPerMae(&cMaeAct->cNitCo1Est,;
				  &cMaeAct->cPadNitEst,;
				  &cMaeAct->cMadNitEst)

	    DO CASE
	    CASE nTipPer == 1     // Padre

		 cApelli := RTRIM(&cMaeAct->cApePadEst)
		 cNombre := RTRIM(&cMaeAct->cNomPadEst)

		 cDocNit := ALLTRIM(&cMaeAct->cPadNitEst)
		 cTipNit := ALLTRIM(&cMaeAct->cPadTntEst)

		 cDirecc := ALLTRIM(&cMaeAct->cDirPadEst)
		 cCiudad := ALLTRIM(&cMaeAct->cCiuPadEst)

	    CASE nTipPer == 2     // Madre

		 cApelli := ALLTRIM(&cMaeAct->cApeMadEst)
		 cNombre := ALLTRIM(&cMaeAct->cNomMadEst)

		 cDocNit := ALLTRIM(&cMaeAct->cMadNitEst)
		 cTipNit := ALLTRIM(&cMaeAct->cMadTntEst)

		 cDirecc := ALLTRIM(&cMaeAct->cDirMadEst)
		 cCiudad := ALLTRIM(&cMaeAct->cCiuMadEst)

	    CASE nTipPer == 3     // Otra Persona

		 IF lLocNitPer(&cMaeAct->cNitCo1Est,&cMaeAct->cTipCo1Est)

		    cApelli := ALLTRIM(PER->cApeUnoPer)+' '+;
			       ALLTRIM(PER->cApeDosPer)

		    cNombre := ALLTRIM(PER->cNomUnoPer)+' '+;
			       ALLTRIM(PER->cNomDosPer)

		    cDocNit := ALLTRIM(PER->cDocNitPer)
		    cTipNit := ALLTRIM(PER->cTipNitPer)

		    cDirecc := ALLTRIM(PER->cDireccPer)
		    cCiudad := ALLTRIM(PER->cCiudadPer)


		 ELSE
		    cApelli := 'PERSONA NO'
		    cNombre := 'EXISTE'

		    cDocNit := ALLTRIM(&cMaeAct->cNitCo1Est)
		    cTipNit := ALLTRIM(&cMaeAct->cTipCo1Est)

		    cDirecc := ''
		    cCiudad := ''
		 ENDIF

	    OTHERWISE
		 cApelli := ''
		 cNombre := ''

		 cDocNit := ALLTRIM(&cMaeAct->cNitCo1Est)
		 cTipNit := ALLTRIM(&cMaeAct->cTipCo1Est)

		 cDirecc := ''
		 cCiudad := ''
	    ENDCASE

	    cSeparar(cApelli,@cApell1,@cApell2)
	    cSeparar(cNombre,@cNombr1,@cNombr2)
**********FIN BUSQUEDA DEL CONTRATANTE

**********GRABACION DEL REGISTRO
	    IF XLS->(lRegLock(lShared,.T.))

	       REPL XLS->cCodEst WITH PAG->cCodigoEst
	       REPL XLS->cCodGru WITH cCodGru
	       REPL XLS->nVlrMtr WITH PAG->nVlrPagPag
	       REPL XLS->dFecPag WITH PAG->dFecPagPag

	       REPL XLS->cApelli WITH cApelli
	       REPL XLS->cNombre WITH cNombre

	       REPL XLS->cTipNit WITH cTipNit
	       REPL XLS->cDocNit WITH cDocNit


	       REPL XLS->cApell1 WITH cApell1
	       REPL XLS->cApell2 WITH cApell2

	       REPL XLS->cNombr1 WITH cNombr1
	       REPL XLS->cNombr2 WITH cNombr2

	       REPL XLS->cNomEmp WITH ''
	       REPL XLS->cDirecc WITH cDirecc
	       REPL XLS->cCiudad WITH cCiudad

	    ELSE
		cError('NO SE GRABA EL REGISTRO')
	    ENDIF
	    XLS->(DBCOMMIT())
**********FIN GRABACION DEL REGISTRO


	  PAG->(DBSKIP())

       ENDDO
*>>>>FIN RECORRIDO DE LOS PAGOS

FUNCTION cSeparar(cTexto,cTxtUno,cTxtDos)

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroPos := 0                   // N£mero de posici¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SEPARACION DEL TEXTO
       cTexto := ALLTRIM(cTexto)
       nNroPos := AT(' ',cTexto)
       IF nNroPos == 0
	  cTxtUno := cTexto
	  cTxtDos := ''
       ELSE
	  cTxtUno := SUBS(cTexto,1,nNroPos)
	  cTxtDos := SUBS(cTexto,nNroPos,LEN(cTexto)-nNroPos+1)

	  cTxtUno := ALLTRIM(cTxtUno)
	  cTxtDos := ALLTRIM(cTxtDos)
       ENDIF
       RETURN NIL
*>>>>FIN SEPARACION DEL TEXTO