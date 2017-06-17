/* SIMA - MATRICULA ACADEMICA

MODULO      : PAGOS
SUBMODULO...: CANCELACION DE RECIBOS

**************************************************************************
* TITULO..: CANCELACION DE PAGOS                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 09/96 LUN A
       Colombia, Bucaramanga        INICIO: 04:15 PM   DIC 09/96 LUN

REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Permite cancelar o definir la forma de pago como se cancelo el recibo

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_503(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-MATR.PRG"      // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar L¡nea
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
     *ÀVariables generales

       LOCAL nNroFil := 0                   // N£mero de la fila
       LOCAL aNroCol := {}                  // Numeros de Columna
       LOCAL cCabeza := ''                  // Encabezado de columna

       LOCAL nPago   := 0                   // Forma de pago
       LOCAL cPago   := ''                  // Forma de pago
       LOCAL nVlrInt := 0                   // Valor Intereses
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTes := ''               // Codigo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante

       LOCAL dFecPagTpa := CTOD('00/00/00') // Fecha de pago
       LOCAL cMatricTpa := ''               // '1'->Matr¡cula '0'->Pensi¢n
       LOCAL cEstadoTpa := ''               // Forma del pago
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

       LOCAL cNalias := ''                  // Alias del Maestro
       LOCAL lNuevos := .F.                 // .T. Matricula para nuevos

       LOCAL cAnoAlu := ''                  // A¤o del Meaestro de Estudiantes.
       LOCAL cPatAlu := ''                  // Path del Maetrro del Estudiantes
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

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+;
		       fMtrAno+cAnoUsr+ExtFile,'ANO',NIL,lShared)
	  cError('ABRIENDO LOS ARCHIVOS')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>ANALISIS DEL A¥O DEL MAESTRO DE ESTUDIANTES
       IF EMPTY(ANO->cAnoAluAno)
	  cAnoAlu := cAnoUsr
	  cPatAlu := cPatSis
       ELSE
	  cAnoAlu := ANO->cAnoAluAno
	  cPatAlu := cAnoAlu+SUBS(cPatSis,LEN(cPatSis)-3,4)
       ENDIF
       CloseDbf('ANO')
*>>>>FIN ANALISIS DEL A¥O DEL MAESTRO DE ESTUDIANTES

*>>>>SELECCION DE ALUMNOS NUEVOS O ANTIGUOS
       lNuevos := .F.
       IF nLeeOpcion('VA REGISTRAR PAGOS PARA: '+;
		     '1<NUEVOS> 2<ANTIGUOS>?',2,'1') == 1
	  lNuevos := .T.
       ENDIF
*>>>>FIN SELECCION DE ALUMNOS NUEVOS O ANTIGUOS

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       lHayErr := .F.
       DO CASE
       CASE lNuevos
	    IF !lUseDbf(.T.,cPatSis+'\'+;
			FileAdm+cAnoUsr+ExtFile,'ADM',NIL,lShared)
	       lHayErr := .T.
	    ENDIF

       CASE !lNuevos
	    IF !lUseMaeMtr(lShared,PathUno+'\'+cPatAlu,cMaeAlu,SUBS(cAnoAlu,3,2))
	       lHayErr := .T.
	    ENDIF
       ENDCASE
       IF lHayErr
	  cError("ABRIENDO ARCHIVOS EN "+IF(lNuevos,"NUEVOS","ANTIGUOS"))
	  CloseAll()
	  RETURN NIL
       ENDIF

       IF !lUseDbf(.T.,cPatSis+'\'+;
		       fMtrAno+cAnoUsr+ExtFile,'ANO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FilePag,'PAG',cPatSis+'\'+fNtxPag,lShared)
	  cError('ABRIENDO LOS ARCHIVOS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE

       CASE ANO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DE LA MATRICULA PARA EL A¥O')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>TIPO DE CONCEPTO PENSION O MATRICULA
       cMatricTpa := '0'
       IF nLeeOpcion('ESCOJA EL CONCEPTO: '+;
		     '1<MATRICULA> 2<PENSION>?',2,'1') == 1
	  cMatricTpa := '1'
       ENDIF
*>>>>FIN TIPO DE CONCEPTO PENSION O MATRICULA

*>>>>FILTRACION DE LOS PAGOS
       SELECT PAG
       IF cMatricTpa == '1'
	  SET FILTER TO PAG->cMatricPag == '1'
       ELSE
	  SET FILTER TO PAG->cMatricPag == '0'
       ENDIF
       GO TOP
*>>>>FIN FILTRACION DE LOS PAGOS

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1)
       cCabeza := cRegPrint({'CODIGO',;
			     'NOMBRE',;
			     'VALOR ',;
			     'VALOR INTERES ',;
			     'FORMA   ',;
			     'MES1',;
			     'MES2'},;
			    {06,24,12,14,08,04,04},@aNroCol)
       @ nNroFil-2,01 SAY cCabeza
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>CANCELACION DE LOS RECIBOS
       DO WHILE .T.

**********LECTURA DEL CODIGO NUEVO
	    IF lNuevos
	       cNalias := 'ADM'

	       lLeeCodAdm(nNroFil,aNroCol[1],;
			     @cCodigoTes,{||lLocCodigo('cNumeroAdm',;
					    'ADM',cCodigoTes,;
					    'NUMERO DE INSCRIPCION')})

	       cCodigoTes := IF(EMPTY(cCodigoTes),cCodigoTes,ADM->cCodigoEst)
	    ENDIF
**********FIN LECTURA DEL CODIGO NUEVO

**********LECTURA DEL CODIGO ANTIGUO
	    IF !lNuevos
	       cCodigoTes := cLeeCodEst(nNroFil,aNroCol[1],cMaeAlu,@cMaeAct)
		  cNalias := cMaeAct
	    ENDIF

	    IF LASTKEY() == K_ESC .OR. EMPTY(cCodigoTes)
	       EXIT
	    ENDIF
**********FIN LECTURA DEL CODIGO ANTIGUO

**********BUSQUEDA DE LOS DETALLES DEL PAGO
	    IF !lSekCodigo(cCodigoTes+cMatricTpa,'PAG')
	       cError('NO APARECE RECIBO PARA EL CODIGO: '+cCodigoTes)
	       LOOP
	    ENDIF
**********FIN BUSQUEDA DE LOS DETALLES DEL PAGO

**********LECTURA DEL NOMBRE DEL ESTUDIANTE
	    cNombreTes := ALLTRIM(RTRIM(&cNalias->cApelliEst)+' '+;
					&cNalias->cNombreEst)
	    cNombreTes := SUBS(cNombreTes,1,24)
**********FIN LECTURA DEL NOMBRE DEL ESTUDIANTE

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('CONCEPTO DE FACTURACION: '+;
			IF(cMatricTpa=='1','MATRICULA','PENSION')+;
			IF(EMPTY(cNalias),'',;
			'ºCURSO: '+&cNalias->cCodigoGru),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********CALCULO DE LOS INTERESES
	    IF PAG->lIntPenPag
	       nVlrInt  := ROUND((PAG->nVlrMesPag*PAG->nIntmorPag)/100,0)
	    ELSE
	       nVlrInt := PAG->nVlrMorPag
	    ENDIF
**********FIN CALCULO DE LOS INTERESES

**********ANALISIS DE LA FORMA DE PAGO
	    DO CASE
	    CASE PAG->cEstadoPag == 'P'
		    nVlrInt := 0
		 cEstadoTpa := 'PAGO OPO'

	    CASE PAG->cEstadoPag == 'A'
		 cEstadoTpa := 'PAGO EXT'

	    CASE PAG->cEstadoPag == 'D'
		 cEstadoTpa := 'NO PAGO '

	    OTHERWISE
		 cEstadoTpa := 'ERROR   '
	    ENDCASE
**********FIN ANALISIS DE LA FORMA DE PAGO

**********IMPRESION DE LOS DETALLES DEL PAGO
	    @ nNroFil,aNroCol[2] SAY cNombreTes
	    @ nNroFil,aNroCol[3] SAY PAG->nVlrpagPag  PICT "$###,###.99"
	    @ nNroFil,aNroCol[4] SAY nVlrInt          PICT "$###,###.99"
	    SET COLOR TO I
	    @ nNroFil,aNroCol[5] SAY cEstadoTpa
	    SET COLOR TO

	    @ nNroFil,aNroCol[6] SAY IF(PAG->cMatricPag == '1',;
					'MATR',cMes(PAG->nMesIniPag,4))
	    @ nNroFil,aNroCol[7] SAY IF(PAG->cMatricPag == '1',;
					'MATR',cMes(PAG->nMesFinPag,4))
**********FIN IMPRESION DE LOS DETALLES DEL PAGO

**********LECTURA DE LA FORMA DE PAGO
	    IF !ANO->lLeeFecAno
	       nPago := nLeeOpcion('ENTRE LA FORMA DEL PAGO: '+;
				   '1<PAGO OPO> 2<PAGO EXT> '+;
				   '3<NO PAGO> 4<ABANDONAR>?',4,'1')
	      *Lee la forma de pago

	       IF nPago == 4
		  LOOP
	       ENDIF
	    ENDIF
**********FIN LECTURA DE LA FORMA DE PAGO

**********LECTURA Y VALIDACION DE LA FECHA DE PAGO
	    IF ANO->lLeeFecAno

*--------------LECTURA DE LA FORMA DE PAGO
		 nPago := nLeeOpcion('ENTRE LA FORMA DE PAGO: '+;
			   '1<PAGO> 2<NO PAGO> 3<ABANDONAR>?',3,'0')
		 IF nPago == 3
		    LOOP
		 ENDIF
*--------------FIN LECTURA DE LA FORMA DE PAGO

*--------------LECTURA DE LA FECHA DE PAGO
		 dFecPagTpa := PAG->dFecPagPag
		 DO CASE
		 CASE nPago == 1

		      cSavLin := SAVESCREEN(21,00,21,79)
		      @ 21,20 SAY 'ENTRE LA FECHA DE PAGO:(MM/DD/AA)';
			      GET dFecPagTpa
		      READ
		      RESTSCREEN(21,00,21,79,cSavLin)

		      IF EMPTY(dFecPagTpa)
			 LOOP
		      ENDIF

		      IF dFecPagTpa <= PAG->dPagOpoPag
			 nPago := 1
		      ELSE
			 nPago := 2
		      ENDIF

		 CASE nPago == 2
		      nPago := 3
		      dFecPagTpa := CTOD('00/00/00')
		 ENDCASE
*--------------FIN LECTURA DE LA FECHA DE PAGO

	    ENDIF
**********FIN LECTURA Y VALIDACION DE LA FECHA DE PAGO

**********LECTURA Y ANALISIS DE LA FORMA DE PAGO
	    DO CASE
	    CASE nPago       == 1
		  cEstadoTpa := 'PAGO OPO'
		  cPago      := 'P'

	    CASE nPago       == 2
		  cEstadoTpa := 'PAGO EXT'
		  cPago      := 'A'

	    CASE nPago       == 3
		  cEstadoTpa := 'NO PAGO '
		  cPago      := 'D'

	    OTHERWISE
		  cPago      := 'E'
		  cEstadoTpa := 'ERROR   '
	    ENDCASE
**********FIN LECTURA Y ANALISIS DE LA FORMA DE PAGO

**********GRABACION DE LA FORMA DE PAGO
	    IF PAG->(lRegLock(lShared,.F.))
	       REPL PAG->cEstadoPag WITH cPago
	       REPL PAG->dFecPagPag WITH dFecPagTpa
	       REPL PAG->cNomUsrPag WITH cNomUsr
	       REPL PAG->dFecUsrPag WITH DATE()
	       REPL PAG->cHorUsrPag WITH TIME()
	       PAG->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABA LA FORMA DE PAGO')
	    ENDIF
	    IF lShared
	       PAG->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DE LA FORMA DE PAGO

**********IMPRESION DE LOS DETALLES DEL PAGO
	    SET COLOR TO I
	    @ nNroFil,aNroCol[5] SAY cEstadoTpa
	    SET COLOR TO
**********FIN IMPRESION DE LOS DETALLES DEL PAGO

***********CONTROL DE LA FILA DE VISUALIZACION
	     nNroFil++
	     IF nNroFil > 20

*---------------VISUALIZACION DEL ULTIMO ESTUDIANTE
		  nNroFil := nMarco(nFilPal+1)
		  @ nNroFil-2,01 SAY cCabeza

		  SET COLOR TO I
		  @ nNroFil,aNroCol[1] SAY cCodigoTes
		  SET COLOR TO
		  @ nNroFil,aNroCol[2] SAY cNombreTes
		  @ nNroFil,aNroCol[3] SAY PAG->nVlrpagPag;
				       PICT "$###,###.99"
		  @ nNroFil,aNroCol[4] SAY nVlrInt;
				       PICT "$###,###.99"
		  SET COLOR TO I
		  @ nNroFil,aNroCol[5] SAY cEstadoTpa
		  SET COLOR TO
		  @ nNroFil,aNroCol[6] SAY IF(PAG->cMatricPag == '1',;
					      'MATR',cMes(PAG->nMesIniPag,4))
		  @ nNroFil,aNroCol[7] SAY IF(PAG->cMatricPag == '1',;
					      'MATR',cMes(PAG->nMesFinPag,4))
		  nNroFil++
*---------------FIN VISUALIZACION DEL ULTIMO ESTUDIANTE

	     ENDIF
***********CONTROL DE LA FILA DE VISUALIZACION

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN CANCELACION DE LOS RECIBOS