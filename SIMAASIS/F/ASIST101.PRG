/* SIMA - CONTROL DE ASISTENCIA

MODULO      : ASISTENCIA
SUBMODULO...: ASISTENCIA                              MODULO No. 101

**************************************************************************
* TITULO..: LECTURA DE LAS NOVEDADES DE ASISTENCIA                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 23/2007 MIE A
       Colombia, Bucaramanga        INICIO: 02:30 PM   MAY 23/2007 MIE

OBJETIVOS:

1- Permite leer las novedades de asistencia de los estudiantes

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Asist_101(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		   cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		   cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		   cJorTxt,nTipLec)

*>>>>DESCRIPCION DE PARAMETROS
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
       cJorTxt                              // Jornada escogida
       nTipLec                              // Tipo de Lectura */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "CAMPOS\ARC-ASIS.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de Integraci¢n Uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal
       LOCAL nNroKey := 0                   // Tecla pulsada
       LOCAL nFilTem := 0                   // Fila Temporal
       LOCAL nColTem := 0                   // Columna Temporal

       LOCAL cTitSup := ''                  // T¡tulo Superior del Browse
       LOCAL aCampos := NIL                 // Definici¢n de Campos
       LOCAL cTitInf := ''                  // T¡tulo Inferior del Browse
       LOCAL oBrowse := NIL                 // Browse de Alumnos
       LOCAL cTexto  := ''                  // Texto temporal
       LOCAL cCodigo := ''                  // C¢digo de la lectura
       LOCAL dFecIni := CTOD('00/00/00')    // Fecha Inicial
       LOCAL nHraIni := 0                   // Registro inicial de la Hora
       LOCAL nHraFin := 0                   // Registro Final de la Hora
       LOCAL lIniCla := .F.                 // Hora de clase inicial
       LOCAL lFinCla := .F.                 // Hora de clase final


       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTtp := ''               // C¢digo tipo personal
       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cCodigoTta := ''               // C¢digo del Tipo de Ausencia
       LOCAL cCodigoThr := ''               // C¢digo de la Hora
       LOCAL cNomPadTct := ''               // Nombre del Padre o Acudiente
       LOCAL cNomAutTct := ''               // Nombre del que Autoriza
       LOCAL cObservTct := ''               // Observaci¢n
       CloseAll()                           // Cerrar Archivos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathAsiAno(lShared,cPatSis,cAnoUsr,@cIntUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry)
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}

       AADD(aUseDbf,{.T.,cIntUno+'\'+FileHra,'HRA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FAsiAno+cAnoUsr+ExtFile,'ASA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+fTipAus,'TAU',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+fCtrAsi,'ASI',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,cIntUno,cMaeAlu,cAnoSis) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE 'JAR' $ cMaeAlu .AND. JAR->(RECCOUNT()) == 0
	    cError('No Existen Estudiantes de Jardin para '+cAnoUsr)

       CASE 'PRI' $ cMaeAlu .AND. PRI->(RECCOUNT()) == 0
	    cError('No Existen Estudiantes de Primaria para '+cAnoUsr)

       CASE 'BTO' $ cMaeAlu .AND. BTO->(RECCOUNT()) == 0
	    cError('No Existen Estudiantes de Bachillerato para '+cAnoUsr)

       CASE HRA->(RECCOUNT()) == 0
	    cError('NO SE HA DEFINIDO LA DIVISION DE LAS HORAS')

       CASE ASA->(RECCOUNT()) == 0
	    cError('NO EXISTE LA CONFIGURACION DEL A¥O')

       CASE ASA->nCodEstAsA == 0
	    cError('DEBE DEFINIR LA POSICION DEL CODIGO DEL ESTUDIANTE')

       CASE ASA->nLenCodAsA == 0
	    cError('DEBE DEFINIR LA LONGITUD DEL CODIGO DEL ESTUDIANTE')

       CASE ASA->nTipPnlAsA == 0
	    cError('DEBE DEFINIR LA POSICION DEL TIPO DE PERSONAL')

       CASE ASA->nLenPnlAsA == 0
	    cError('DEBE DEFINIR LA LONGITUD DEL TIPO DE PERSONAL')

       CASE TAU->(RECCOUNT()) == 0
	    cError('NO ESTAN CREADOS LOS TIPOS DE AUSENCIAS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>DEFINICION DEL BROWSE
       SELECT &cMaeAct
       cTitSup := '<< CONSULTA DE ESTUDIANTE DE '+cMaeAct+;
		  ' .TOTAL ='+STR(RECCOUNT(),4)+' A¥O: '+cAnoUsr+' >>'
      *ÀT¡tulo Superior del Browse

       aCampos := {{{"CODIGO","cCodigoEst"},{NIL}},;
		   {{"GRUPO","cCodigoGru"},{NIL}},;
		   {{"APELLIDOS;DEL ESTUDIANTE","cApelliEst"},{NIL}},;
		   {{"NOMBRES;DEL ESTUDIANTE","cNombreEst"},{NIL}},;
		   {{"FECHA MATRICULA","dFecMatEst"},{NIL}},;
		   {{"HORA","cHorMatEst"},{NIL}},;
		   {{"RETIRADO","lRetiroEst"},{NIL}},;
		   {{"FECHA","dFecRetEst"},{NIL}}}
     *ÀDefinici¢n de Campos


       cTitInf := '<F5>Buscar <F7>Seleccionar <ESC>Abandona'
      *ÀT¡tulo Inferior del Browse

       oBrowse := oBrowse(nFilPal+1,00,22,79,cTitSup,cTitInf,aCampos)
     *Creaci¢n del Browse
*>>>>FIN DEFINICION DEL BROWSE

*>>>>VISUALIZACION DE LA FECHA
       FecHorSys(cNomSis)
       SETKEY(K_F10,{||LeerFecHora(cNomSis)})
       cError('LA TECLA <F10> PERMITE MODIFICAR',;
	      'POR FAVOR REVISE LA FECHA Y HORA')
*>>>>FIN VISUALIZACION DE LA FECHA

*>>>>LECTURA DEL INTERVALO DE FECHAS
       dFecIni := DATE()

       cSavPan := SAVESCREEN(0,0,24,79)
       @ 21,20 SAY 'INGRESE LA FECHA EN EL SGTE ORDEN: (MM/DD/AA)'
       @ nFilInf+1,nColInf SAY 'FECHA:' GET dFecIni PICT '@D'
       READ

       IF EMPTY(dFecIni)
	  RESTSCREEN(0,0,24,79,cSavPan)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF

       IF !lPregunta('DESEA CONTINUAR? Si No')
	  RESTSCREEN(0,0,24,79,cSavPan)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN LECTURA DEL INTERVALO DE FECHAS

*>>>>LECTURA DEL TIPO DE AUSENCIA
       SELECT TAU
       TAU->(DBGOTOP())
       cCodigoTta := TAU->cCodigoTau

       IF ASA->nTipLecAsA == 0 .AND. TAU->(RECCOUNT()) > 1

	  cSavPan := SAVESCREEN(0,0,24,79)
	  cCodigoTta := cSpaces('TAU','cCodigoTau')
	  @ nFilInf+1,nColInf SAY 'TIPO DE AUSENCIA ';
			      GET cCodigoTta PICT '@!';
			      VALID lValTipoA(ROW(),COL()-3,@cCodigoTta)
	  READ

	  IF EMPTY(cCodigoTta)
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF

	  IF !lPregunta('ESCOGIO '+ALLTRIM(TAU->cNombreTau)+'. '+;
		       'DESEA CONTINUAR? Si No')
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)

       ENDIF
*>>>>FIN LECTURA DEL TIPO DE AUSENCIA

*>>>>LECTURA DE LA HORA DE CLASE
       SELECT HRA
       HRA->(DBGOTOP())
       cCodigoThr := HRA->cCodigoHra

       IF ASA->nTipLecAsA == 0 .AND. HRA->(RECCOUNT()) > 1

	  cCodigoThr := cSpaces('HRA','cCodigoHra')
	  @ nFilInf+1,nColInf SAY 'HORA DE CLASE';
			      GET cCodigoThr PICT 'XX';
			      VALID lValCodHra(ROW(),COL()-1,@cCodigoThr)
	  READ

	  IF EMPTY(cCodigoThr)
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF

	  IF !lPregunta('ESCOGIO '+ALLTRIM(HRA->cNombreHra)+'. '+;
		       'DESEA CONTINUAR? Si No')
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)

       ENDIF
*>>>>FIN LECTURA DE LA HORA DE CLASE

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,ALLTRIM(TAU->cNombreTau)+'. '+;
				   ALLTRIM(HRA->cNombreHra)+'. '+;
				   'DIGITE LOS CODIGOS.',22,'°')

       DO CASE
       CASE TAU->nTipNovTau == 1
	  aTamCol := {20,30}
	  aTitulo := {'CODIGO','NOMBRE'}

       CASE TAU->nTipNovTau == 2
	  aTamCol := {20,30,30}
	  aTitulo := {'CODIGO','ACUDIENTE','QUIEN AUTORIZA'}

       OTHERWISE
	  aTamCol := {20,40}
	  aTitulo := {'CODIGO','NOMBRE'}

       ENDCASE

       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>LECTURA Y GRABACION DE LOS CODIGOS
       nNroFil++
       DO WHILE .T.

**********LECTURA DEL CODIGO
	    cCodigo := cLeeCodigo(lShared,cAnoUsr,cMaeAct,cIntUno,;
				  nNroFil,aNroCol[1],nTipLec,oBrowse)
	    IF EMPTY(cCodigo)
	       EXIT
	    ENDIF
**********FIN LECTURA DEL CODIGO

**********ANALISIS DEL CODIGO
	    DO CASE
	    CASE nTipLec == 1  // C¢digo de 6 digitos
		 cCodigoTes := cCodigo
		 cCodigoTtp := ASA->cTipEstAsA

	    CASE nTipLec == 2  // C¢digo de barras
		 cCodigoTes := SUBS(cCodigo,ASA->nCodEstAsA,ASA->nLenCodAsA)
		 cCodigoTtp := SUBS(cCodigo,ASA->nTipPnlAsA,ASA->nLenPnlAsA)

	    CASE nTipLec == 3  // C¢digo del estudiante por browse
		 cCodigoTes := cCodigo
		 cCodigoTtp := ASA->cTipEstAsA

	    ENDCASE
**********FIN ANALISIS DEL CODIGO

**********VALIDACION TIPO DEL ESTUDIANTE
	    IF cCodigoTtp # ASA->cTipEstAsA
	       cError('EL CODIGO: '+cCodigoTes+' NO ES DE UN ESTUDIANTE')
	       LOOP
	    ENDIF
**********FIN VALIDACION TIPO DEL ESTUDIANTE

**********BUSQUEDA DEL CODIGO
	    IF nTipLec # 3 .AND. !lSekCodMae(cCodigoTes,cMaeAlu,@cMaeAct)
	       LOOP
	    ENDIF
	    cNombreTes := RTRIM(&cMaeAct->cNombreEst)+' '+;
			  RTRIM(&cMaeAct->cApelliEst)
	    cNombreTes := ALLTRIM(SUBS(cNombreTes+SPACE(34),1,34))
**********FIN BUSQUEDA DEL CODIGO

**********ANALISIS SI EL ESTUDIANTE ESTA RETIRADO
	    IF &cMaeAct->lRetiroEst
	       cError(cNombreTes+' ESTA RETIRADO')
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO

**********ANALISIS DE DECISION
	    IF nTipLec == 3 .AND.;
	      !lPregunta('ESCOGIO A '+cNombreTes+' '+;
			 'GRUPO:'+&cMaeAct->cCodigoGru+' '+;
			 'DESEA CONTINUAR? Si No')
	       LOOP
	    ENDIF
**********FIN ANALISIS DE DECISION

**********CONSULTA DEL NOMBRE DEL ESTUDIANTE
	    IF TAU->nTipNovTau == 0
	       @ nNroFil,aNroCol[2] SAY cNombreTes
	    ELSE
	       LineaEstado('NOMBRE: '+cNombreTes+'º'+;
			   'GRUPO: '+&cMaeAct->cCodigoGru,cNomSis)
	    ENDIF
**********CONSULTA DEL NOMBRE DEL ESTUDIANTE

**********CONSULTA DEL NOMBRE DEL ESTUDIANTE
	    IF TAU->nTipNovTau == 0
	       LineaEstado('NOMBRE: '+cNombreTes+'º'+;
			   'GRUPO: '+&cMaeAct->cCodigoGru,cNomSis)
	    ELSE
	       @ nNroFil,aNroCol[1] SAY &cMaeAct->cCodigoEst
	       @ nNroFil,aNroCol[2] SAY cNombreTes
	    ENDIF
**********CONSULTA DEL NOMBRE DEL ESTUDIANTE

**********LECTURA DEL TIPO DE AUSENCIA
	    IF ASA->nTipLecAsA # 0

	       cSavPan := SAVESCREEN(0,0,24,79)
	       DO WHILE .T.

		  IF TAU->(RECCOUNT()) == 1
		     SELECT TAU
		     TAU->(DBGOTOP())
		     cCodigoTta := TAU->cCodigoTau
		     EXIT
		  ENDIF

		  cCodigoTta := cSpaces('TAU','cCodigoTau')
		  @ nFilInf+1,nColInf SAY 'TIPO DE AUSENCIA ';
				      GET cCodigoTta PICT '@!';
				      VALID lValTipoA(ROW(),COL()-3,@cCodigoTta)
		  READ

		  IF EMPTY(cCodigoTta)
		     EXIT
		  ENDIF

		  IF !lPregunta('ESCOGIO '+ALLTRIM(TAU->cNombreTau)+'. '+;
			       'DESEA CONTINUAR? Si No')
		     LOOP
		  ENDIF
		  EXIT

	       ENDDO
	       RESTSCREEN(0,0,24,79,cSavPan)

	       IF EMPTY(cCodigoTta)
		  LOOP
	       ENDIF

	    ENDIF
**********FIN LECTURA DEL TIPO DE AUSENCIA

**********LECTURA Y VALIDACION DE LA HORA DE CLASE
	    nHraIni := 1
	    nHraFin := 1
//	    IF ASA->nTipLecAsA # 0
	    IF ASA->nTipLecAsA # 0 .AND. HRA->(RECCOUNT()) > 1

	       cSavPan := SAVESCREEN(0,0,24,79)
	       DO WHILE .T.

*=================LECTURA DEL INTERVALO
		    nHraIni := 0
		    nHraFin := 0
		    TitBuscar(20,@nFilTem,@nColTem,;
			      'INGRESE LAS HORAS:','HORAS',22)
		    IF !lIntervHra(nFilTem+1,nColTem,@nHraIni,@nHraFin) .OR.;
		       nHraIni == 0 .OR. nHraFin == 0
		       lHayErr := .T.
		       EXIT
		    ENDIF
*=================FIN LECTURA DEL INTERVALO

*=================VALIDACION DE LA HORA
		    HRA->(DBGOTO(nHraIni))
		    lIniCla := HRA->lHraClaHra

		    HRA->(DBGOTO(nHraFin))
		    lFinCla := HRA->lHraClaHra

		    lHayErr := .T.
		    DO CASE
		    CASE lIniCla .AND. !lFinCla
			 cError('HORA FINAL NO ES UNA HORA DE CLASE')

		    CASE !lIniCla .AND. lFinCla
			 cError('HORA INICIAL NO ES UNA HORA DE CLASE')

		    CASE !lIniCla .AND. !lFinCla .AND.;
			 nHraIni # nHraFin

			 HRA->(DBGOTO(nHraIni))
			 cError('SOLO SE DEBE SELECCIONAR '+;
				ALLTRIM(HRA->cNombreHra))

		    OTHERWISE
			 lHayErr :=.F.
		    ENDCASE
		    IF lHayErr
		       LOOP
		    ENDIF
		    EXIT
*=================FIN VALIDACION DE LA HORA

	       ENDDO
	       IF lHayErr .OR. !lPregunta('DESEA CONTINUAR? Si No')
		  RESTSCREEN(0,0,24,79,cSavPan)
		  LOOP
	       ENDIF
	       RESTSCREEN(0,0,24,79,cSavPan)
	    ENDIF
**********FIN LECTURA Y VALIDACION DE LA HORA DE CLASE

**********LOCALIZACION DEL TIPO DE AUSENCIA
	    IF .T.

	       HRA->(DBGOTO(nHraIni))

	       SELECT ASI
	       ASI->(DBGOTOP())

	       LOCATE FOR ASI->cCodigoEst == cCodigoTes .AND.;
			  ASI->dFecAsiCtr == dFecIni .AND.;
			  ASI->cCodigoHra == HRA->cCodigoHra .AND.;
			  ALLTRIM(ASI->cCodigoTau) == ALLTRIM(cCodigoTta)

	       IF ASI->(FOUND())
		  cError(cNombreTes+' YA FUE REGISTRADO')
		  LOOP
	       ENDIF

	    ENDIF
**********FIN LOCALIZACION DEL TIPO DE AUSENCIA

**********LECTURA DE LAS NOVEDADES
	    DO CASE
	    CASE TAU->nTipNovTau == 1  // Observaci¢n
		 cObservTct := cSpaces('ASI','cObservCtr')
		 @ ++nNroFil,aNroCol[2] SAY 'OBSERVACION:';
					GET cObservTct PICT '@!S43'
		 READ

	    CASE TAU->nTipNovTau == 2  // Autorizaci¢n

		 cNomPadTct := cSpaces('ASI','cNomPadCtr')
		 @ nNroFil++,aNroCol[2] GET cNomPadTct PICT '@!S30 ';
				      VALID !EMPTY(cNomPadTct)

		 cNomAutTct := cSpaces('ASI','cNomAutCtr')
		 @ nNroFil++,aNroCol[3] GET cNomAutTct PICT '@!S30 ';
				      VALID !EMPTY(cNomAutTct)

		 cObservTct := cSpaces('ASI','cObservCtr')
		 @ nNroFil++,aNroCol[2] SAY 'OBSERVACION:';
				      GET cObservTct PICT '@!S44'
		 READ

	    ENDCASE
**********FIN LECTURA DE LAS NOVEDADES

**********RECORRIDO POR HORAS
	    SELECT HRA
	    HRA->(DBGOTO(nHraIni))
	    DO WHILE HRA->(RECNO()) <= nHraFin

*==============VALIDACION DE LA HORA DE CLASE
		 IF nHraIni # nHraFin .AND. !HRA->lHraClaHra
		    SELECT HRA
		    HRA->(DBSKIP())
		    LOOP
		 ENDIF
*==============FIN VALIDACION DE LA HORA DE CLASE

*==============GRABACION DEL REGISTRO
		 IF ASI->(lRegLock(lShared,.T.))

		    REPL ASI->cCodigoEst WITH cCodigoTes
		    REPL ASI->dFecAsiCtr WITH dFecIni
		    REPL ASI->cCodigoHra WITH HRA->cCodigoHra
		    REPL ASI->cCodigoTau WITH cCodigoTta
		    REPL ASI->cNomUsrCtr WITH cNomUsr
		    REPL ASI->dFecUsrCtr WITH DATE()
		    REPL ASI->cHorUsrCtr WITH TIME()

		    DO CASE
		    CASE TAU->nTipNovTau == 1  // Observaci¢n
			 REPL ASI->cObservCtr WITH cObservTct

		    CASE TAU->nTipNovTau == 2  // Autorizaci¢n
			 REPL ASI->cNomPadCtr WITH cNomPadTct
			 REPL ASI->cNomAutCtr WITH cNomAutTct
			 REPL ASI->cObservCtr WITH cObservTct
		    ENDCASE

		    ASI->(DBCOMMIT())
		    IF lShared
		       ASI->(DBUNLOCK())
		    ENDIF
		 ENDIF
*==============FIN GRABACION DEL REGISTRO

	       SELECT HRA
	       HRA->(DBSKIP())

	    ENDDO
**********FIN RECORRIDO POR HORAS

**********PAUSA
	   IF nTipLec == 3
	      cPausa()
	   ENDIF
**********FIN PAUSA

**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    IF nNroFil > 19

*--------------IMPRESION DEL ULTIMO REGISITRO
		 nNroFil := nMarco(nFilPal+1,ALLTRIM(TAU->cNombreTau)+'. '+;
					     ALLTRIM(HRA->cNombreHra)+'. '+;
					     'DIGITE LOS CODIGOS.',22,'°')

		 @ nNroFil,nNroCol SAY cMsgTxt

		 nNroFil++
		 SET COLOR TO I
		 @ nNroFil,aNroCol[1] SAY cCodigoTes
		 @ nNroFil,aNroCol[2] SAY cNombreTes
		 SET COLOR TO

		 nNroFil++
*--------------FIN IMPRESION DEL ULTIMO REGISITRO

	    ENDIF
**********FIN INCREMENTO DE LAS FILAS


       ENDDO
       CloseAll()
       SETKEY(K_F10,NIL)
       SHOWTIME()
       RETURN NIL
*>>>>FIN LECTURA Y GRABACION DE LOS CODIGOS

/*************************************************************************
* TITULO..: SELECCIONAR DEL BROWSE                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 28/2007 LUN A
       Colombia, Bucaramanga        INICIO: 10:00 PM   MAY 28/2007 LUN

OBJETIVOS:

1- Permite seleccionar el registro en el cual se encuentra el browse

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION EnterBrw(nNroKey)

*>>>>DESCRIPCION DE PARAMETROS
/*     nNroKey                              // N£mero de la tecla pulsada */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>SELECCION DEL REGISTRO
       nNroKey := LASTKEY()
       KEYBOARD CHR(27)
       RETURN NIL
*>>>>FIN SELECCION DEL REGISTRO

/*************************************************************************
* TITULO..: LECTURA DEL CODIGO DEL PERSONAL                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 07/2007 JUE A
       Colombia, Bucaramanga        INICIO: 03:45 PM   JUN 07/2007 JUE

OBJETIVOS:

1- Permite leer el c¢digo del personal del colegio

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/


FUNCTION cLeeCodigo(lShared,cAnoUsr,cMaeAct,PathSco,;
		    nNroFil,nNroCol,nTipLec,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cAnoUsr                              // A¤o del usuario
       cMaeAct                              // Maestro Activo
       PathSco                              // Path de la Contabilidad
       nNroFil                              // N£mero de la fila
       nNroCol                              // N£mero de la columna
       nTipLec                              // Tipo de Lectura
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL nNroKey := 0                   // Tecla pulsada
       LOCAL cCodigo := ''                  // C¢digo a Leer

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DEL CODIGO
       DO CASE
       CASE nTipLec == 1  // C¢digo de 6 digitos
	    cCodigo := SPACE(06)
	    @ nNroFil,nNroCol GET cCodigo PICT '@ 999999'
	    READ

       CASE nTipLec == 2  // C¢digo de barras
	    cCodigo := SPACE(20)
	    @ nNroFil,nNroCol GET cCodigo PICT '@! X9999999999999999999'
	    READ

       CASE nTipLec == 3  // C¢digo del estudiante por browse

	    SELECT &cMaeAct
	    SETKEY(K_F5,{||BuscarAlu(lShared,oBrowse,cMaeAct,;
				     cAnoSis,PathSco)})
	    SETKEY(K_F7,{||EnterBrw(@nNroKey)})

	    DO CASE
	    CASE cMaeAct == 'JAR'
		 JAR->(CtrlBrw(lShared,oBrowse))

	    CASE cMaeAct == 'PRI'
		 PRI->(CtrlBrw(lShared,oBrowse))

	    CASE cMaeAct == 'BTO'
		 BTO->(CtrlBrw(lShared,oBrowse))

	    ENDCASE

	    IF nNroKey == 0 .AND. LASTKEY() == K_ESC
	       cCodigo := SPACE(01)
	    ELSE
	       cCodigo := &cMaeAct->cCodigoEst
	    ENDIF

       ENDCASE
       SETKEY(K_F5,NIL)
       SETKEY(K_F7,NIL)
       RETURN cCodigo
*>>>>LECTURA DEL CODIGO
