/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : FIN DE A¥O
SUBMODULO...: HABILITACIONES         MODULO No. 511

**************************************************************************
* TITULO..: GRABACION Y CORRECION DE HABILITACIONES                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 16/95 VIE A
       Colombia, Bucaramanga        INICIO: 12:15 PM   NOV 16/95 VIE


REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Permite grabar y corregir las notas de las habilitaciones

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_511(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar L¡nea.

       LOCA        i := 0                   // Contador
       LOCAL aNroCol := {}                  // Numeros de Columna
       LOCAL nNroFil := 0                   // N£mero de la fila
       LOCAL aStrNot := {}                  // Estructura de las notas

       LOCAL   cNota := ''                  // Nota de la Materia
       LOCA  cCabeza := ''                  // Texto de Cabecera
       LOCAL nNroReg := 0                   // N£mero de Registro
       LOCAL nTotPer := 0                   // Total de periodos
       LOCAL lHayNot := .F.                 // .T. Hay Notas
       LOCAL lNotNum := .F.                 // .T. Nota Numerica .F. Nota Cualitativa
       LOCAL cCamNot := ''                  // Campo de la Habilitaci¢n
       LOCAL cCamHab := ''                  // Campo de la Habilitaci¢n
       LOCAL cNotHab := ''                  // Nota de la Habilitaci¢n
       LOCAL nNotHab := 0                   // Nota de la Habilitaci¢n
       LOCAL dFecHab := CTOD('00/00/00')    // Fecha de la Habilitaci¢n
       LOCAL cNroAct := ''                  // Acta de Habilitaci¢n
       LOCAL nNroOpc := 0                   // N£mero de Opci¢n
       LOCAL cValNot := ''                  // Validaci¢n de la nota
       LOCAL lHayItv := .F.                 // .T. Nota Numerica por Intervalo de Juicios valorativos

       LOCAL cCodJvf := ''                  // C¢digo de la Nota
       LOCAL lAprobo := .F.                 // .T. Aprobo
       LOCAL Getlist := {}                  // Variable del sistema

       LOCAL cCodigoTes := ''               // C¢digo del estudiante
       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
       LOCAL cCodigoTma := ''               // C¢digo de la Materia
       LOCAL cNombreTma := ''               // Nombre de la materia
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
       IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       fConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileMat,'MAT',NIL,lShared)                 .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileJvf,'JVF',NIL,lShared)                 .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileAlu+cMaeAct+cAnoSis+ExtFile,'ALU',;
		       cPatSis+'\'+cMaeAct+'\'+;
		       fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared)
	  cError('ABRIENDO EL ARCHIVO DE GRUPOS '+cPatSis)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE NIV->(RECCOUNT()) == 0
	    cError('NO EXISTEN NIVELES GRABADOS')

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL NIVEL')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE ALU->(RECCOUNT()) == 0
	    cError('NO EXISTEN ALUMNOS GRABADOS')

       CASE lHayJvfTco() .AND. JVF->(RECCOUNT()) == 0
	    cError('NO EXISTEN JUICIOS VALORATIVOS GRAGADOS PARA '+cMaeAct)

       CASE lHayItvTco() .AND. !lHayItvJvf()
	    cError('SE DEBE DEFINIR BIEN EL INTERVALO DE LOS JUICIOS VALORATIVOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>CAPTURA DEL CODIGO DE LA MATERIA
       cCodigoTma := cSpaces('MAT','cCodigoMat')
       nNroReg := 0
       lSelMateria(nFilInf+1,01,@nNroReg)
       IF nNroReg == 0
	  CLOSE ALL
	  RETURN NIL
       ENDIF
       SELECT MAT
       GO nNroReg
       cCodigoTma := MAT->cCodigoMat
       cNombreTma := MAT->cNombreMat
*>>>>FIN CAPTURA DEL CODIGO DE LA MATERIA

*>>>>ANALISIS DE LA CONFIGURACION DEL NIVEL
       nTotPer := TCO->nTotPerTbl
       lHayNot := IF(SUBS(TCO->cHayNotTbl,nTotPer,1)='1',.T.,.F.)
       lNotNum := IF(SUBS(TCO->cNotNumTbl,nTotPer,1)='1',.T.,.F.)
       IF .NOT. lHayNot
	  cError('NO ESTA HABILITADA LA OPCION DE CAPTURA DE'+;
		 IF(lNotNum,'NOTAS','JUICIOS'))
	  CLOSE ALL
	  RETURN NIL
       ENDIF
       lHayItv := lHayItvJvf()
*>>>>FIN ANALISIS DE LA CONFIGURACION DEL NIVEL

*>>>>VALIDACION DE LA NOTA
       IF lNotNum
	  cValNot := ALLTRIM(TCO->cValNumTbl)+SPACE(01)
       ELSE
	  IF EMPTY(TCO->cValNumTbl)
	     cValNot := ALLTRIM(TCO->cValNotTbl)+SPACE(01)
	  ELSE
	     cValNot := ALLTRIM(TCO->cValNumTbl)+SPACE(01)
	  ENDIF
       ENDIF
*>>>>FIN VALIDACION DE LA NOTA

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1)
       cCabeza := cRegPrint({'CODIGO',;
			     SUBS(cNombreTma,1,44),;
			     IF(lNotNum,'NOTA','JUICIO'),;
			     'FECHA','ACTA'},;
			    {06,44,06,10,06},@aNroCol)
       @ nNroFil-2,01 SAY cCabeza
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>MODIFICACION DE LAS NOTAS
       cSavPan := SAVESCREEN(00,00,24,79)
       DO WHILE .T.

**********CAPTURA DEL CODIGO DEL ESTUDIANTE
	    cSavLin := SAVESCREEN(nNroFil,00,nNroFil,79)
	    cCodigoTes := SPACE(06)
	    @ nNroFil,aNroCol[1] GET cCodigoTes PICT '999999';
				 VALID lCorrecion(@cCodigoTes)
	    READ
	    IF EMPTY(cCodigoTes)
	       EXIT
	    ENDIF
**********FIN CAPTURA DEL CODIGO DEL ESTUDIANTE

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    IF !lSekCodigo(cCodigoTes,'ALU','DEL ESTUDIANTE')
	       LOOP
	    ENDIF
	    cNombreTes := RTRIM(ALU->cApelliEst)+' '+;
			  RTRIM(ALU->cNombreEst)
	    cNombreTes := SUBS(cNombreTes+SPACE(50),1,50)
	    cCodigoTgr := ALU->cCodigoGru
	    @ nNroFil,aNroCol[2] SAY cNombreTes
**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********SELECION DE LAS AREAS DE TRABAJO
	    CloseDbf('NOT')
	    IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\NOTAS\'+;
			    'NT'+cCodigoTgr+cAnoSis+ExtFile,;
			    'NOT',NIL,lShared)

	       cError('ABRIENDO LOS ARCHIVOS DE NOTAS '+;
		      'DEL GRUPO '+cCodigoTgr+' EN '+cPatSis)
	       CloseDbf('NOT')
	       LOOP
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE NOT->(RECCOUNT()) == 0
		 cError("SE BORRARON LAS NOTAS DEL GRUPO: "+cCodigoTgr,;
			"Error Grave. TOME NOTA")
	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE

	    IF lHayErr
	       CloseDbf('NOT')
	       LOOP
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********LOCALIZACION DEL CODIGO EN NOTAS
	    IF !lLocCodigo('cCodigoEst','NOT',cCodigoTes)
	       cError(ALLTRIM(cNombreTes)+' NO EXISTE EN NOTAS DEL '+;
		      'GRUPO: '+cCodigoTgr)
	       LOOP
	    ENDIF
**********FIN LOCALIZACION DEL CODIGO EN NOTAS

**********ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
	    IF NOT->lRetGruNot
	       cError(ALLTRIM(cNombreTes)+' PERTENECE A OTRO GRUPO')
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

**********ANALISIS DEL AREA ESCOGIDA
	    SELECT NOT
	    aStrNot := DBSTRUCT()
	    IF SUBS(cCodigoTma,3,2) == '00'
	       cCamNot := ''
	       cCamHab := ''
	       FOR i:=1 TO LEN(aStrNot)
		 IF SUBS(aStrNot[i,1],2,6) == 'NT'+cCodigoTma
		    cCamNot := aStrNot[i,1]
		    cCamHab := 'cHa'+cCodigoTma+'Not'
		    EXIT
		 ENDIF
	       ENDFOR
	    ENDIF
**********FIN ANALISIS DEL AREA ESCOGIDA

**********ANALISIS DE LA MATERIA ESCOGIDA
	    IF SUBS(cCodigoTma,3,2) # '00'
	       cCamNot := ''
	       cCamHab := ''
	       FOR i:=1 TO LEN(aStrNot)
		 IF SUBS(aStrNot[i,1],2,6) == 'NT'+cCodigoTma
		    cCamNot := aStrNot[i,1]
		    cCamHab := 'cHa'+cCodigoTma+'Not'
		    EXIT
		 ENDIF
	       ENDFOR
	    ENDIF
**********FIN ANALISIS DE LA MATERIA ESCOGIDA

**********VALIDACION DE LA MATERIA ESCOGIDA
	    IF EMPTY(cCamNot) .OR. EMPTY(cCamHab)
	       cError('LA METERIA NO FIGURA EN LAS NOTAS DEL GRUPO '+cCodigoTgr)
	       CLOSE ALL
	       RETURN NIL
	    ENDIF
**********FIN VALIDACION DE LA MATERIA ESCOGIDA

**********ANALISIS DE LA NOTA DE HABILITACION
	    cNota   := ALLTRIM(SUBS(&cCamNot,nTotPer*4-3,4))

	    IF lNotNum .AND. !lHayJvfTco()

	       IF VAL(cNota) >= VAL(TCO->cMinHabTbl)
		  cError('NO DEBE RECUPERAR')
		  LOOP
	       ENDIF
	    ELSE
	       IF lHayItv .AND. VAL(cNota) > 0
		  cNota := cNotDefJvf(VAL(cNota))
	       ENDIF

	       cCodJvf := ''
	       lAprobo := IF(cAproboJvf(cNota,,@cCodJvf) = 'N',.F.,.T.)
	       cCodJvf := UPPER(ALLTRIM(cCodJvf))

	       *IF UPPER(cNota) # 'I' .AND. UPPER(cNota) # 'D'
	       IF lAprobo
		  cError('NO DEBE RECUPERAR','NOTA'+cNota,cCodigoTma)
		  LOOP
	       ENDIF
	    ENDIF
**********FIN ANALISIS DE LA NOTA DE HABILITACION

**********LECTURA Y MODIFICACION DE LA HABILITACION
	    SELECT NOT
	    lHayErr := .F.
	    DO WHILE .T.

*--------------ANALISIS DE DECISION
		 IF .NOT. lHayErr
		    cNotHab := SUBS(&cCamHab,1,4)
		    dFecHab := CTOD(SUBS(&cCamHab,5,10))
		    cNroAct := SUBS(&cCamHab,15,6)
		    IF EMPTY(dFecHab)
		       dFecHab := TCO->dFecRecTbl
		    ENDIF
		    IF EMPTY(cNroAct)
		       cNroAct := TCO->cActRecTbl
		    ENDIF
		 ENDIF
*--------------FIN ANALISIS DE DECISION

*--------------LECTURA DE LA HABILITACION
		 IF lNotNum
		    nNotHab := VAL(cNotHab)
		    @ nNroFil,aNroCol[3] GET nNotHab PICT '99.9';
					 VALID nNotHab <= VAL(cValNot)
		 ELSE
		    @ nNroFil,aNroCol[3] GET cNotHab PICT '@! XXXX'
		 ENDIF
		 @ nNroFil,aNroCol[4] GET dFecHab PICT '@D';
				      VALID {||HelpRead(cNomEmp,cNomSis)};
				      WHEN  {||HelpRead(cNomEmp,cNomSis,'FECHA')}
		 @ nNroFil,aNroCol[5] GET cNroAct PICT 'XXXXXX'
		 READ
		 IF lNotNum
		    cNotHab := STR(nNotHab,4,1)
		 ENDIF
*--------------FIN LECTURA DE LA HABILITACION

*--------------VALIDACION DE LA LECTURA
		 nNroOpc := nLeeOpcion('1<GRABAR> 2<CORREGIR> 3<NO GRABAR>?',3,'0')
		 IF nNroOpc == 2
		    lHayErr := .T.
		    LOOP
		 ENDIF
		 EXIT
*--------------FIN VALIDACION DE LA LECTURA

	    ENDDO
	    IF nNroOpc == 3
	       LOOP
	    ENDIF
**********FIN LECTURA Y MODIFICACION DE LA HABILITACION

**********GRABACION DE LA HABILITACION
	    SELECT NOT
	    IF NOT->(lRegLock(lShared,.F.))
	       REPL &cCamHab WITH cNotHab+DTOC(dFecHab)+cNroAct
	       NOT->(DBCOMMIT())
	    ELSE
	       cError('NO SE PUEDE GRABAR LAS NOTAS')
	    ENDIF
	    IF lShared
	       NOT->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DE LA HABILITACION

**********CONTROL DE LA FILA DE VISUALIZACION
	    nNroFil++
	    IF nNroFil > 20

	       nNroFil := nMarco(nFilInf+1)
	       @ nNroFil-2,01 SAY cCabeza

	       SET COLOR TO I
	       @ nNroFil,aNroCol[1] SAY cCodigoTes
	       SET COLOR TO
	       @ nNroFil,aNroCol[2] SAY cNombreTes
	       SET COLOR TO I
	       @ nNroFil,aNroCol[3] SAY cNotHab PICT IF(lNotNum,'99.9','XXXX')
	       SET COLOR TO
	       @ nNroFil,aNroCol[4] SAY dFecHab PICT '@D'
	       SET COLOR TO I
	       @ nNroFil,aNroCol[5] SAY cNroAct PICT 'XXXXXX'
	       SET COLOR TO
	       nNroFil++

	    ENDIF
**********FIN CONTROL DE LA FILA DE VISUALIZACION

       ENDDO
       CLOSE ALL
       RETURN NIL
*>>>>FIN MODIFICACION DE LAS NOTAS