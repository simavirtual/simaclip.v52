/*                   SIMA - CONTABILIDAD PROFESORES
	     BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO DE NOTAS

REQUERIMIENTOS:

- Compilar: clipper FuncsNoP /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo de Notas del Profesor

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/


/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 11/96 LUN A
       Colombia, Bucaramanga        INICIO: 11:55 AM   MAR 11/96 LUN

OBJETIVOS:

1)- Crea la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfNoP(lShared,PathNoP,FileNoP,fNtxNoP,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       PathNoP				    // Path del Archivo
       FileNoP				    // Nombre del Archivo
       fNtxNoP				    // Archivo de Indices
       aStrDbf                              // @Estructura del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cUnidad := ''                  // Unidad de Disco
       LOCAL PathAct := ''                  // Path Actual
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL aDbfNoP := {{"cCodigoEst","Character", 06,0},;
			 {"cApelliEst","Character", 25,0},;
			 {"cNombreEst","Character", 25,0},;
			 {"nNroLisEst","Numeric"  , 03,0},; // N£mero de lista.
			 {"nAproboEst","Numeric"  , 02,0},;
			 {"lRetiroNoP","Logical"  , 01,0},;
			 {"nGruTraNoP","Numeric"  , 02,0},;
			 {"nCamTemNoP","Numeric"  , 04,1},;
			 {"cNotas1NoP","Character", 81,0},;
			 {"cIndic1NoP","Character",125,0},; // 6*20=120 + 5 por cada periodo
			 {"cIndnt1NoP","Character",160,0},; // 8*20=160 + 5 => 1-4=99.9 5-8=99.9
			 {"cDefin1NoP","Character", 04,0},;
			 {"cDefRe1NoP","Character", 04,0},; // Definitiva Recuperada
			 {"cNotas2NoP","Character", 81,0},;
			 {"cIndic2NoP","Character",125,0},;
			 {"cIndnt2NoP","Character",160,0},; // 8*20=160 + 5 => 1-4=99.9 5-8=99.9
			 {"cDefin2NoP","Character", 04,0},;
			 {"cDefRe2NoP","Character", 04,0},; // Definitiva Recuperada
			 {"cNotas3NoP","Character", 81,0},;
			 {"cIndic3NoP","Character",125,0},;
			 {"cIndnt3NoP","Character",160,0},; // 8*20=160 + 5 => 1-4=99.9 5-8=99.9
			 {"cDefin3NoP","Character", 04,0},;
			 {"cDefRe3NoP","Character", 04,0},; // Definitiva Recuperada
			 {"cNotas4NoP","Character", 81,0},;
			 {"cIndic4NoP","Character",125,0},;
			 {"cIndnt4NoP","Character",160,0},; // 8*20=160 + 5 => 1-4=99.9 5-8=99.9
			 {"cDefin4NoP","Character", 04,0},;
			 {"cDefRe4NoP","Character", 04,0},; // Definitiva Recuperada
			 {"cNotas5NoP","Character", 81,0},;
			 {"cIndic5NoP","Character",125,0},;
			 {"cIndnt5NoP","Character",160,0},; // 8*20=160 + 5 => 1-4=99.9 5-8=99.9
			 {"cDefin5NoP","Character", 04,0},;
			 {"cDefRe5NoP","Character", 04,0},; // Definitiva Recuperada
			 {"cFallasNoP","Character", 10,0},;
			 {"nAcumulNop","Character", 05,2},;
			 {"nNotDefNop","Character", 04,1},;
			 {"cCodigoPro","Character", 06,0},; // C¢digo del Profesor
			 {"cNomUsrNop","Character", 10,0},; // Nombre del Usuario
			 {"dFecUsrNop","Date"     , 08,0},; // Fecha del Usuario
			 {"cHorUsrNop","Character", 10,0}}  // Hora del Usuario
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfNoP
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CAMBIO A LA UNIDAD DE DISKETTE
       PathAct := cPathAct()
       IF PathNoP == 'A:' .OR. PathNoP == 'B:'
	  cUnidad := DISKNAME()
	  IF !DISKCHANGE(PathNoP)
	     cError('NO SE CAMBIO A LA UNIDAD '+PathNoP)
	  ENDIF
       ENDIF
*>>>>FIN CAMBIO A LA UNIDAD DE DISKETTE

*>>>>CREACION DE LA ESTRUCTURA
       DO CASE
       CASE DIRCHANGE(PathNoP) == 0 .OR. PathNoP == 'A:'.OR. PathNoP == 'B:'
	    DBCREATE(FileNoP,aDbfNoP,"DBFNTX")

       CASE DIRCHANGE(PathNoP) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathNoP)

       CASE DIRCHANGE(PathNoP) == -5
	    cError('NO TIENE DERECHOS EN: '+PathNoP)
       ENDCASE
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>CAMBIO A LA UNIDAD DEL DISCO DURO
       IF PathNoP == 'A:' .OR. PathNoP == 'B:'
	  IF !DISKCHANGE(cUnidad)
	     cError('NO SE CAMBIO A LA UNIDAD '+cUnidad)
	  ENDIF
       ENDIF
       DIRCHANGE(PathAct)
       RETURN NIL
*>>>>FIN CAMBIO A LA UNIDAD DEL DISCO DURO

/*************************************************************************
* TITULO DE LA FUNCION..: RECUPERACION DE LA ESTRUCTURA                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 11/96 LUN A
       Colombia, Bucaramanga        INICIO: 11:15 AM   MAR 11/96 LUN

OBJETIVOS:

1)- Recupera la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfNoP(lShared,PathNoP,FileNoP,fNtxNoP)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       PathNoP			      // Path del Archivo
       FileNoP			      // Nombre del Archivo
       fNtxNoP			      // Archivo de Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathNoP+'\'+FileNoP,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")

       Termometro(0,"CREANDO LA ESTRUCTURA DE PROFESOR")
       Termometro(100)

       CreaDbfNoP(lShared,PathNoP,FileNoP,fNtxNoP)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 31/2001 MIE A
       Colombia, Bucaramanga        INICIO: 11:30 AM   OCT 31/2001 MIE

OBJETIVOS:

1)- Actualiza la Estructura del Archivo

2)- Retorna el N£mero de Error:
    0 => No hay Error
	 Estructura Actualizada
	 Estructura Sin problemas
    1 => Estructura No Actualizada

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nActStrNoP(lShared,nModCry,PathNoP,FileNoP)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathCar				    // Path del Archivo
       FileNoP				    // Nombre del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nNroErr := 0                   // N£mero del Error
       LOCAL       i := 0                   // Contador
       LOCAL aStrNew := {'1'}               // Estructura Nueva
       LOCAL aStrOld := {}                  // Estructura Vieja
       LOCAL lCambio := .F.                 // .T. Cambio la Estructura
       LOCAL FileTem := ''                  // Archivo temporal
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathNoP+'\'+FileNoP,'NOP',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE CARGAS DEL PROFESOR')
	  CloseDbf('NOP',PathNoP+'\'+FileNoP,nModCry)
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := NOP->(DBSTRUCT())
       CloseDbf('NOP',PathNoP+'\'+FileNoP,nModCry)
       CreaDbfNoP(lShared,PathNoP,FileNoP,,,@aStrNew)
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE LA ESTRUCTURA
       lCambio := .T.
       IF LEN(aStrNew) == LEN(aStrOld)
	  lCambio := .F.
       ENDIF

       IF !lCambio
	  FOR i := 1 TO LEN(aStrNew)
	      IF UPPER(aStrNew[i,1]) # UPPER(aStrOld[i,1]) .OR.;
		 UPPER(SUBS(aStrNew[i,2],1,1)) # UPPER(SUBS(aStrOld[i,2],1,1)) .OR.;
		 aStrNew[i,3] # aStrOld[i,3] .OR.;
		 aStrNew[i,4] # aStrOld[i,4]
		 lCambio := .T.
		 EXIT
	      ENDIF
	  ENDFOR
       ENDIF
*>>>>FIN VALIDACION DE LAS STRUCTURAS

*>>>>CONFIRMACION DE LA ACTUALIZACION
       IF lCambio
	  lCambio := .T.
	  IF !lCambio
	     nNroErr := 1
	  ENDIF
       ENDIF
*>>>>FIN CONFIRMACION DE LA ACTUALIZACION

*>>>>ACTUALIZACION DE LA STRUCTURA
       IF lCambio
	  FileTem := SUBS(FileNoP,1,AT('.',FileNoP))+'STR'
	  cSavPan := SAVESCREEN(0,0,24,79)
	  IF !lStrucFile(lShared,;
			 PathNoP+'\'+FileNoP,;
			 PathNoP+'\'+FileTem,;
			 {||CreaDbfNoP(lShared,PathNoP,FileTem)},nModCry)
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA STRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION..: ACTUALIZACION DE LOS ESTUDIANTES               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 27/96 LUN A
       Colombia, Bucaramanga        INICIO: 03:50 PM   MAY 27/96 LUN

OBJETIVOS:

1)- Actualiza los estudiantes del diskette o disco duro del profesor
    con los estudiantes de la contabilidad general.

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RevisarEst(lShared,cNomSis,cAnoUsr,cPatPro,cPatSco,cMaeAct,lAnoAct)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cNomSis                              // Nombre del sistema
       cNomUsr                              // Nombre de usuario
       cPatPro                              // Path del Profesor
       cPatSco				    // Path de la Contabilidad
       cMaeAct                              // Maestro Actual
       lAnoAct                              // .T. A¤o Actual */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL nNroFil := 0                   // N£mero de Fila
       LOCAL nNroCol := 0                   // N£mero de Columna

       LOCAL lEofAlu := .F.                 // .T. Fin de Archivo
       LOCAL lEofNoP := .F.                 // .T. Fin de Archivo
       LOCAL lCambio := .F.                 // .T. Existe cambio de grupo
       LOCAL cEstado := ''		    // Estado de la actualizaci¢n

       LOCAL nRegNoP := 0                   // Registro del Estudiante
       LOCAL nRegAlu := 0                   // Registro del Alumno

       LOCAL cCodigoTgr := ''               // Codigo del grupo
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       FIELD cCodigoGru                     // Codigo del grupo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,cPatSco,cMaeAct,cAnoSis) .OR.;
	  !lUseDbf(.T.,cPatPro+'\'+;
		       FCarPro+cAnoSis+ExtFile,'CAP',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS EN REVISION DE ESTUDIANTES')
	  CLOSE ALL
	  RETURN .F.
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       SELECT &cMaeAct
       lHayErr := .T.
       DO CASE
       CASE (RECCOUNT()) == 0
	    cError('NO EXISTEN ALUMNOS GRABADOS')

       CASE CAP->(RECCOUNT()) == 0
	    cError('NO EXISTE CARGA ACADEMICA DEL PROFESOR')
       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  RETURN .F.
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>VERIFICACION DE ERRORES EN EL DISCO
       SELECT CAP
       GO TOP
       DO WHILE .NOT. CAP->(EOF())

**********VALIDACION DE LA CARGA
	    cCodigoTgr := SUBS(CAP->cCodigoCar,5,4)
	    IF CAP->nTipCarCar # 0
	       CAP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN VALIDACION DE LA CARGA

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatPro+'\'+;
			CAP->cCodigoCar+ExtFile,'NOP',NIL,lShared)
	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL PROFESOR '+;
		      'CON CODIGO '+CAP->cCodigoCar)
	       lHayErr := .T.
	       EXIT
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********INDEXACION DEL ARCHIVO
	    SELECT NOP
	    fNtxTem := SUBS(TIME(),1,2)+'$'+;
		       SUBS(TIME(),4,2)+'$'+;
		       SUBS(TIME(),7,2)
	    fNtxTem := cPatPro+'\'+fNtxTem+cNtxTem
	    INDEX ON NOP->cCodigoEst TO &fNtxTem
	    IF lShared
	       DBSETINDEX(fNtxTem)
	    ELSE
	       SET INDEX TO (fNtxTem)
	    ENDIF
**********FIN INDEXACION DEL ARCHIVO

**********FILTRACION DEL MAESTRO
	    SELECT &cMaeAct
	    SET FILTER TO cCodigoGru == cCodigoTgr
	    GO TOP
	    IF EOF()
	       cError('NO EXISTEN ESTUDIANTES DEL GRUPO '+cCodigoTgr)
	    ENDIF
**********FIN FILTRACION DEL MAESTRO

**********ACTUALIZACION DEL GRUPO Y MATERIA
	    nNroFil := nMarco(01,'ACTUALIZANDO LOS ESTUDIANTES DE '+;
				 ALLTRIM(CAP->cNombreMat)+' '+;
				 'DEL GRUPO '+cCodigoTgr)
	    SELECT NOP
	    GO TOP
	    SELECT &cMaeAct
	    GO TOP
	    lCambio := .F.
	    lEofAlu := .F.
	    lEofNoP := .F.
	    DO WHILE !lEofAlu .OR. !lEofNoP

*--------------ANALISIS DEL CAMBIO DE GRUPO
		  SELECT &cMaeAct
		  cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
				      &cMaeAct->cNombreEst
		  cNombreTes := SUBS(cNombreTes+SPACE(40),1,40)
		 *Estudiante del maestro



		  cEstado = &cMaeAct->cCodigoGru + ' û'
		  IF .NOT. lCambio
		     IF &cMaeAct->cCodigoEst # NOP->cCodigoEst
			lCambio := .T.
		     ENDIF
		  ENDIF
*--------------FIN ANALISIS DE CAMBIO DE GRUPO

*--------------CONFIRMACION DEL GRUPO DEL ESTUDIANTE
		 IF .NOT. lCambio
		    SELECT NOP
		    IF NOP->(lRegLock(lShared,.F.))
		       REPL NOP->lRetiroNoP WITH .F.
		       NOP->(DBCOMMIT())
		    ELSE
		       cError('NO SE GRABA EL SWICTH DEL RETIRO DEL ESTUDIANTE')
		    ENDIF
		    IF lShared
		       NOP->(DBUNLOCK())
		    ENDIF
		 ENDIF
*--------------FIN CONFIRMACION DEL GRUPO DEL ESTUDIANTE

*--------------BUSQUEDA DEL ALUMNO EN EL DISCO
		 IF lCambio .AND. !lEofAlu

		    SELECT NOP
		    nRegNoP = RECNO()

		    IF !lSekCodigo(&cMaeAct->cCodigoEst,"NOP") .AND.;
		       !EMPTY(&cMaeAct->cCodigoEst)

*                      INCLUSION DEL ESTUDIANTE
			 IF &cMaeAct->cCodigoGru == cCodigoTgr
			    IF lGraRegDbf(lShared,'NOP',.T.,;
			       {{"NOP->cCodigoEst",&cMaeAct->cCodigoEst},;
				{"NOP->lRetiroNoP",.F.}})

			       cEstado = 'Incluido en '+cCodigoTgr
			       nNroFil++
			       @ nNroFil,01 SAY cNombreTes+;
						SPACE(10)+'...'+cEstado
			       IF nNroFil == 21
				  nNroFil := nMarco(01,'ACTUALIZANDO LOS ESTUDIANTES DE '+;
						       ALLTRIM(CAP->cNombreMat)+' '+;
						       'DEL GRUPO '+cCodigoTgr)
			       ENDIF
			    ELSE
			       cError('NO SE INCLUYE EL ESTUDIANTE')
			    ENDIF
			 ELSE
			    cEstado = 'EQUIVOCADO DE GRUPO'
			 ENDIF
*                      FIN INCLUSION DEL ESTUDIANTE

		    ENDIF

		    SELECT NOP
		    GO nRegNoP
		   *Reestablece el puntero del disco
		 ENDIF
*--------------FIN BUSQUEDA DEL ALUMNO EN EL DISCO

*--------------BUSQUEDA EN EL MAESTRO DE LA CONTABILIDAD
		 IF lCambio .AND. !lEofNoP

		    SELECT &cMaeAct
		    nRegAlu = RECNO()
		   *Guarda el puntero del maestro

		    SET FILTER TO
		   *Desactiva para buscar en todo el maestro
		    IF lSekCodigo(NOP->cCodigoEst,cMaeAct)

*                      CONFIRMAR EL GRUPO DEL ESTUDIANTE
			 cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
					     &cMaeAct->cNombreEst
			 cNombreTes = SUBS(cNombreTes+SPACE(40),1,40)
			*Estudiante del disco

			 SELECT NOP
			 IF &cMaeAct->cCodigoGru == cCodigoTgr

			    IF lGraRegDbf(lShared,"NOP",.F.,;
					  {{"NOP->lRetiroNoP",.F.}})
			       *Existe en el grupo
			       cEstado = cCodigoTgr + ' û'
			    ELSE
			       cError('NO SE GRABA EL REGISTRO')
			    ENDIF
			 ELSE
			    IF lGraRegDbf(lShared,"NOP",.F.,;
					  {{"NOP->lRetiroNoP",.T.}})
			      *No existe en el grupo
			       cEstado = 'Pertenece a otro Grupo'
			    ELSE
			       cError('NO SE GRABA EL REGISTRO')
			    ENDIF
			 ENDIF
*                      CONFIRMAR EL GRUPO DEL ESTUDIANTE

		    ELSE
			cNombreTes = 'EL CODIGO: '+NOP->cCodigoEst+;
				     ' NO EXISTE EN EL MAESTRO'
			cEstado = 'ERROR'
		    ENDIF

		    SELECT &cMaeAct
		    SET FILTER TO cCodigoGru == cCodigoTgr
		    GO nRegAlu
		   *Reestablece el puntero del maestro
		 ENDIF
*--------------FIN BUSQUEDA EN EL MAESTRO DE LA CONTABILIDAD

*--------------VISUALIZACION DEL ESTUDIANTE
		 nNroFil++
		 @ nNroFil,01 SAY cNombreTes+SPACE(10)+'...'+cEstado
		 IF nNroFil == 21
		    nNroFil := nMarco(01,'ACTUALIZANDO LOS ESTUDIANTES DE '+;
					 ALLTRIM(CAP->cNombreMat)+' '+;
					 'DEL GRUPO '+cCodigoTgr)
		 ENDIF
*--------------FIN VISUALIZACION DEL ESTUDIANTE

*--------------ANALISIS DEL EOF DE LAS NOTAS DEL PROFESOR
		 SELECT NOP
		 SKIP
		 IF EOF()
		    lEofNoP := .T.
		 ENDIF
*--------------FIN ANALISIS DEL EOF DE LAS NOTAS DEL PROFESOR

*--------------ANALISIS DEL EOF DE ALUMNOS
		 SELECT &cMaeAct
		 SKIP
		 IF EOF()
		    lEofAlu := .T.
		 ENDIF
*--------------FIN ANALISIS DEL EOF DE ALUMNOS

	    ENDDO
	   *Del archivo de notas de la contabilidad
**********FIN ACTUALIZACION DEL GRUPO Y MATERIA

	  CloseDbf('NOP')
	  DELETE FILE &fNtxTem

	  SELECT CAP
	  CAP->(DBSKIP())

       ENDDO
      *Del archivo ARCHIVOS DEL PROFESOR
       RETURN NIL
*>>>>LECTURA DE LOS GRUPOS Y LAS MATERIAS DE ARCHIVOS

*JUN 27/96 HORA: 05:15 PM

FUNCTION lGraRegDbf(lShared,cNalias,lGrabar,aCampos)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cNalias                              // Alias del archivo a grabar
       lGrabar                              // .F. Reemplaza el registro
       aCampos                              // Campos a grabar */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL i := 0                         // Contador
       LOCAL lHayErr := .T.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>GRABACION DEL REGISTRO
       SELECT &cNalias
       IF lRegLock(lShared,lGrabar)
	  FOR i := 1 TO LEN(aCampos)
	      REPL &(aCampos[i,1]) WITH aCampos[i,2]
	  ENDFOR
	  DBCOMMIT()
       ELSE
	  lHayErr := .F.
       ENDIF
       IF lShared
	  DBUNLOCK()
       ENDIF
       RETURN lHayErr
*>>>>FIN GRABACION DEL REGISTRO

/*************************************************************************
* TITULO..: BROWSE DEL ARCHIVO                                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 08/2003 MIE A
       Colombia, Bucaramanga        INICIO: 07:10 PM   OCT 08/2003 MIE

OBJETIVOS:

1- Browse del Archivo

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ManDbfNoP(aP1,aP2,aP3,;
		   FileNoP,nNroPer,cCodMat,cEvaInd,lMatSel,lGrabar,lSiLock)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       FileNoP                              // Archivo de Notas del Profesor
       nNroPer                              // N£mero del Periodo
       cCodMat                              // C¢digo de la Materia
       cEvaInd                              // Evaluar el Indicador
       lMatSel                              // .T. Materia Selectiva
       lGrabar                              // .T. Grabar Actualizacion
       lSiLock                              // .T. Bloquear el Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar Linea
       LOCAL lHayErr    := .F.              // .T. Hay Error

       LOCAL oBrowse := NIL                 // Browse de Transaciones
       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := xPrm(aP1,'lShared') // .T. Sistema Compartido
       LOCAL nModCry := xPrm(aP1,'nModCry') // Modo de Protecci¢n
       LOCAL cCodSui := xPrm(aP1,'cCodSui') // C¢digo del Sistema
       LOCAL cNomSis := xPrm(aP1,'cNomSis') // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := xPrm(aP1,'cEmpPal') // Nombre de la Empresa principal
       LOCAL cNitEmp := xPrm(aP1,'cNitEmp') // Nit de la Empresa
       LOCAL cNomEmp := xPrm(aP1,'cNomEmp') // Nombre de la Empresa
       LOCAL cNomSec := xPrm(aP1,'cNomSec') // Nombre de la Empresa Secundario
       LOCAL cCodEmp := xPrm(aP1,'cCodEmp') // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := xPrm(aP1,'cNomUsr') // Nombre del Usuario
       LOCAL cAnoUsr := xPrm(aP1,'cAnoUsr') // A¤o del usuario
       LOCAL cAnoSis := xPrm(aP1,'cAnoSis') // A¤o del sistema
       LOCAL cPatSis := xPrm(aP1,'cPatSis') // Path del sistema
     *ÀDetalles del Usuario

       LOCAL PathW01 := xPrm(aP1,'PathW01') // Sitio del Sistema No.01
       LOCAL PathW02 := xPrm(aP1,'PathW02') // Sitio del Sistema No.02
       LOCAL PathW03 := xPrm(aP1,'PathW03') // Sitio del Sistema No.03
       LOCAL PathW04 := xPrm(aP1,'PathW04') // Sitio del Sistema No.04
       LOCAL PathW05 := xPrm(aP1,'PathW05') // Sitio del Sistema No.05
       LOCAL PathW06 := xPrm(aP1,'PathW06') // Sitio del Sistema No.06
       LOCAL PathW07 := xPrm(aP1,'PathW07') // Sitio del Sistema No.07
       LOCAL PathW08 := xPrm(aP1,'PathW08') // Sitio del Sistema No.08
       LOCAL PathW09 := xPrm(aP1,'PathW09') // Sitio del Sistema No.09
       LOCAL PathW10 := xPrm(aP1,'PathW10') // Sitio del Sistema No.10
     *ÀSitios del Sistema

       LOCAL PathUno := xPrm(aP1,'PathUno') // Path de Integraci¢n Uno
       LOCAL PathDos := xPrm(aP1,'PathDos') // Path de Integraci¢n Dos
       LOCAL PathTre := xPrm(aP1,'PathTre') // Path de Integraci¢n Tres
       LOCAL PathCua := xPrm(aP1,'PathCua') // Path de Integraci¢n Cuatro
     *ÀPath de Integraci¢n

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>DECLARACION DE PARAMETROS ESPECIFICOS
       LOCAL cCodPro := xPrm(aP1,'cCodPro') // C¢digo del Profesor
       LOCAL cPatPro := xPrm(aP1,'cPatPro') // Path del Profesor
       LOCAL cNomPro := xPrm(aP1,'cNomPro') // Nombre del Profesor
*>>>>DECLARACION DE PARAMETROS ESPECIFICOS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimSpr,'SPR',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatPro+'\'+FileLog,'LOG',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileCla,'CLA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,FileNoP,'NOP',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf) .OR.;
	  !lUseMae(lShared,PathUno+'\'+cPatSis,cMaeAct,cAnoSis)
	  cError('ABRIENDO EL ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       SELECT &cMaeAct
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTEN ESTUDIANTS GRABADOS')

       CASE SPR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE CLA->(RECCOUNT()) == 0
	    cError('NO EXISTEN LAS CLASES DE INDICADORES')

       CASE NOP->(RECCOUNT()) == 0
	    cError('NO EXISTEN ESTUDIANTES PARA ESTA MATERIA')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SPR->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>MANTENIMIENTO DEL ARCHIVO
       SELECT NOP

       lSiLock := IF(EMPTY(lSiLock),.F.,lSiLock)
       IF lSiLock
	  lFileLock()
       ENDIF

       oBrowse := oDefBrwNoP(lShared,nFilPal+1,00,22,79,cNomUsr,cAnoUsr,;
			     cMaeAct,nNroPer,ALLTRIM(CAP->cNombreMat)+;
			     ' GRUPO: '+SUBS(CAP->cCodigoCar,5,4),;
			     cEvaInd)

       SETKEY(K_F9,{||MenuOtrNoP(aP1,aP2,aP3,;
				 FileNoP,nNroPer,cCodMat,lMatSel,lGrabar,;
				 lSiLock,oBrowse)})
       NOP->(CtrlBrw(lShared,oBrowse))
       SETKEY(K_F5,NIL)
       SETKEY(K_F9,NIL)

       IF lSiLock
	  DBUNLOCKALL()
       ENDIF

       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO..: BROWSE DEL ARCHIVO 		                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 08/2003 MIE A
       Colombia, Bucaramanga        INICIO: 07:30 PM   OCT 08/2003 MIE

OBJETIVOS:

1- Define el objeto Browse del archivo


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwNoP(lShared,nFilSup,nColSup,nFilInf,nColInf,;
		    cNomUsr,cAnoUsr,cMaeAct,nNroPer,cTitulo,;
		    cEvaInd)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // Archivos Compartidos
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del Usuario
       cMaeAct                              // Maestro Habilitado
       nNroPer                              // N£mero del Periodo
       cTitulo                              // Titulo del Browse
       cEvaInd                              // Evaluar el Indicador */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 1                   // Contador
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrowse := NIL		    // Browse del archivo
       LOCAL cTitul1 := ''                  // T¡tulo1 para encabezado de captura
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrowse := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas


       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'
       cTitulo := IF(cTitulo==NIL,'CONSULTA DEL CURSO',cTitulo)
       oBrowse:Cargo := {'<<'+cTitulo+'>>',;
			 '<F9>Otros <ESC>Abandonar'}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       cTitul1 := IF(EMPTY(PRA->cTitul1Ano),'INDI',PRA->cTitul1Ano)
       cTitul1 := SUBS(ALLTRIM(cTitul1),1,3)

       SELECT NOP
       oColumn	     := TBCOLUMNNEW('NRO;REG.', {||NOP->(RECNO())})
       oColumn:Cargo := {{'MODI',.F.}}
       oColumn:Picture := "999"
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NRO;LISTA', {||NOP->nNroLisEst})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','NOP'},{'FIELD','nNroLisEst'},;
			 {'PICTURE','999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO;ESTUDIANTE', {||NOP->cCodigoEst})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
       oBrowse:Freeze:= 3
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('RETIRO;GRUPO', {||NOP->lRetiroNoP})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRE DEL;ESTUDIANTE',;
				   {||cSekNomAlu(NOP->cCodigoEst,;
						 cMaeAct,'NOP')})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('NOTA;FINAL',{||cNotDefNoP('NOP',nNroPer)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('AUS',{||SUBS(NOP->cFallasNoP,nNroPer*2-1,2)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW(cTitul1+'1',{||cCodInd('NOP',nNroPer,1,cEvaInd)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW(cTitul1+'2',{||cCodInd('NOP',nNroPer,2,cEvaInd)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW(cTitul1+'3',{||cCodInd('NOP',nNroPer,3,cEvaInd)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW(cTitul1+'4',{||cCodInd('NOP',nNroPer,4,cEvaInd)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW(cTitul1+'5',{||cCodInd('NOP',nNroPer,5,cEvaInd)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW(cTitul1+'6',{||cCodInd('NOP',nNroPer,6,cEvaInd)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW(cTitul1+'7',{||cCodInd('NOP',nNroPer,7,cEvaInd)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW(cTitul1+'8',{||cCodInd('NOP',nNroPer,8,cEvaInd)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW(cTitul1+'9',{||cCodInd('NOP',nNroPer,9,cEvaInd)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW(cTitul1+'10',{||cCodInd('NOP',nNroPer,10,cEvaInd)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW(cTitul1+'11',{||cCodInd('NOP',nNroPer,11,cEvaInd)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW(cTitul1+'12',{||cCodInd('NOP',nNroPer,12,cEvaInd)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW(cTitul1+'13',{||cCodInd('NOP',nNroPer,13,cEvaInd)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW(cTitul1+'14',{||cCodInd('NOP',nNroPer,14,cEvaInd)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW(cTitul1+'15',{||cCodInd('NOP',nNroPer,15,cEvaInd)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW(cTitul1+'16',{||cCodInd('NOP',nNroPer,16,cEvaInd)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW(cTitul1+'17',{||cCodInd('NOP',nNroPer,17,cEvaInd)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW(cTitul1+'18',{||cCodInd('NOP',nNroPer,18,cEvaInd)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW(cTitul1+'19',{||cCodInd('NOP',nNroPer,19,cEvaInd)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW(cTitul1+'20',{||cCodInd('NOP',nNroPer,20,cEvaInd)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('NOMBRE;DEL USUARIO',{||NOP->cNomUsrNop})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FECHA DE;PROCESO',;
				    {||cFecha(NOP->dFecUsrNop)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('HORA DE;PROCESO',;
				    {||NOP->cHorUsrNop})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO..: LECTURA DEL CODIGO DEL INDICADOR                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 08/2003 MIE A
       Colombia, Bucaramanga        INICIO: 08:30 PM   OCT 08/2003 MIE

OBJETIVOS:

1- Lee un c¢digo del Indicador de un periodo especifico

2- Retorna el C¢digo del Indicador

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cCodInd(cNalias,nNroPer,nNroInd,cEvaInd)

*>>>>DECLARACION DE VARIABLES
/*     cNalias                              // Alias del Browse
       nNroPer                              // N£mero del Periodo
       nNroInd                              // N£mero del Indicador
       cEvaInd                              // Evaluar el Indicador */
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE VARIABLES
       LOCAL cCamInd := ''                  // Campo de Indicadores
       LOCAL cCodInd := ''                  // C¢digo del Indicador

       LOCAL cCamNtI := ''                  // Campo de Indicadores
       LOCAL cNotNtI := ''                  // Nota de la Recuperaci¢n
       LOCAL cNotInd := ''                  // Nota del Indicador
       LOCAL cNotRec := ''                  // Nota de la Recuperaci¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DEL CODIGO DEL INDICADOR
       cCamInd := 'NOP->cIndic'+STR(nNroPer,1,0)+'NoP'
       cCodInd := SUBS(&cCamInd,nNroInd*6-5,6)
       cCodInd += SPACE(01)

       cCamNtI := 'NOP->cIndnt'+STR(nNroPer,1,0)+'NoP'
       cNotNtI := SUBS(&cCamNtI,nNroInd*8-7,8)
*>>>>FIN LECTURA DEL CODIGO DEL INDICADOR

*>>>>LOCALIZACION DE LA CLASE DEL INDICADOR
       IF lLocCodigo('cCodigoCla','CLA',SUBS(cCodInd,1,1)) .AND.;
	  CLA->lRecupeCla

	  DO CASE
	  CASE EMPTY(SUBS(cCodInd,6,1)) .AND. cEvaInd # '2'
	       cCodInd := STUFF(cCodInd,7,1,'*')

	  CASE cEvaInd == '2'

	       IF SUBS(cCodInd,5,1) $ 'ID'

		  IF EMPTY(SUBS(cCodInd,6,1)) .OR.;
		     SUBS(cCodInd,6,1) $ 'ID'

		     cCodInd := STUFF(cCodInd,7,1,'*')

		  ENDIF

	       ENDIF

	  ENDCASE
       ENDIF

       IF cNalias # NIL
	  SELECT &cNalias
       ENDIF
       RETURN cCodInd+IF(cEvaInd == '2',;
		      ':'+SUBS(cNotNtI,1,4)+':'+SUBS(cNotNtI,5,4),'')
*>>>>FIN LOCALIZACION DE LA CLASE DEL INDICADOR

/*************************************************************************
* TITULO..: LECTURA DE LA NOTA DEFINTIVA                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 14/2006 MIE A
       Colombia, Bucaramanga        INICIO: 04:00 PM   MAR 14/2006 MIE

OBJETIVOS:

1- Lee la nota definitiva de un periodo especifico

2- Retorna la nota definitiva

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cNotDefNoP(cNalias,nNroPer)

*>>>>DECLARACION DE VARIABLES
       LOCAL cCamDef := ''                  // Campo de la definitiva
       LOCAL cNotDef := ''                  // Nota de la definitiva

       LOCAL cCamRec := ''                  // Campo nota de la recuperaci¢n
       LOCAL cNotRec := ''                  // Nota de la recuperaci¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE LA NOTA DEFINITIVA
       cCamDef := 'NOP->cDefin'+STR(nNroPer,1,0)+'NoP'
       cNotDef := &cCamDef

       cCamRec := 'NOP->cDefRe'+STR(nNroPer,1,0)+'NoP'
       cNotRec := &cCamRec

       IF cNalias # NIL
	  SELECT &cNalias
       ENDIF
       RETURN cNotDef+':'+cNotRec
*>>>>FIN LECTURA DE LA NOTA DEFINITIVA

/*************************************************************************
* TITULO..: MENU DE OTROS PARA EL ARCHIVO                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 08/2003 MIE A
       Colombia, Bucaramanga        INICIO: 09:00 PM   OCT 08/2003 MIE

OBJETIVOS:

1- Menu de Otros para el archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuOtrNoP(aP1,aP2,aP3,;
		    FileNoP,nNroPer,cCodMat,lMatSel,lGrabar,lSiLock,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       FileNoP                              // Archivo de Notas del Profesor
       nNroPer                              // N£mero del Periodo
       cCodMat                              // C¢digo de la Materia
       lMatSel                              // .T. Materia Selectiva
       lGrabar                              // .T. Grabar Actualizacion
       lSiLock                              // .T. Bloquear el Archivo
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := xPrm(aP1,'lShared') // .T. Sistema Compartido
       LOCAL nModCry := xPrm(aP1,'nModCry') // Modo de Protecci¢n
       LOCAL cCodSui := xPrm(aP1,'cCodSui') // C¢digo del Sistema
       LOCAL cNomSis := xPrm(aP1,'cNomSis') // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := xPrm(aP1,'cEmpPal') // Nombre de la Empresa principal
       LOCAL cNitEmp := xPrm(aP1,'cNitEmp') // Nit de la Empresa
       LOCAL cNomEmp := xPrm(aP1,'cNomEmp') // Nombre de la Empresa
       LOCAL cNomSec := xPrm(aP1,'cNomSec') // Nombre de la Empresa Secundario
       LOCAL cCodEmp := xPrm(aP1,'cCodEmp') // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := xPrm(aP1,'cNomUsr') // Nombre del Usuario
       LOCAL cAnoUsr := xPrm(aP1,'cAnoUsr') // A¤o del usuario
       LOCAL cAnoSis := xPrm(aP1,'cAnoSis') // A¤o del sistema
       LOCAL cPatSis := xPrm(aP1,'cPatSis') // Path del sistema
     *ÀDetalles del Usuario

       LOCAL PathW01 := xPrm(aP1,'PathW01') // Sitio del Sistema No.01
       LOCAL PathW02 := xPrm(aP1,'PathW02') // Sitio del Sistema No.02
       LOCAL PathW03 := xPrm(aP1,'PathW03') // Sitio del Sistema No.03
       LOCAL PathW04 := xPrm(aP1,'PathW04') // Sitio del Sistema No.04
       LOCAL PathW05 := xPrm(aP1,'PathW05') // Sitio del Sistema No.05
       LOCAL PathW06 := xPrm(aP1,'PathW06') // Sitio del Sistema No.06
       LOCAL PathW07 := xPrm(aP1,'PathW07') // Sitio del Sistema No.07
       LOCAL PathW08 := xPrm(aP1,'PathW08') // Sitio del Sistema No.08
       LOCAL PathW09 := xPrm(aP1,'PathW09') // Sitio del Sistema No.09
       LOCAL PathW10 := xPrm(aP1,'PathW10') // Sitio del Sistema No.10
     *ÀSitios del Sistema

       LOCAL PathUno := xPrm(aP1,'PathUno') // Path de Integraci¢n Uno
       LOCAL PathDos := xPrm(aP1,'PathDos') // Path de Integraci¢n Dos
       LOCAL PathTre := xPrm(aP1,'PathTre') // Path de Integraci¢n Tres
       LOCAL PathCua := xPrm(aP1,'PathCua') // Path de Integraci¢n Cuatro
     *ÀPath de Integraci¢n

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>DECLARACION DE PARAMETROS ESPECIFICOS
       LOCAL cCodPro := xPrm(aP1,'cCodPro') // C¢digo del Profesor
       LOCAL cPatPro := xPrm(aP1,'cPatPro') // Path del Profesor
       LOCAL cNomPro := xPrm(aP1,'cNomPro') // Nombre del Profesor
*>>>>DECLARACION DE PARAMETROS ESPECIFICOS

*>>>>DECLARCION Y EJECUCION DEL MENU
       IF lSiLock
	  AADD(aMenus,'1<VALIDAR CONTABILIDAD  >')
	  AADD(aMenus,'2<NUMEROS DE LISTA      >')
	  AADD(aMenus,'3<ORDENAMIENTO NRO LISTA>')
       ENDIF

       IF lSiLock
	  AADD(aAyuda,'Valida Los Indicadores con la Contabilidad Academica.')
	  AADD(aAyuda,'Optiene los N£meros de lista.')
	  AADD(aAyuda,'Ordena por N£meros de Lista.')
       ENDIF

       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,aAyuda,10,25,NIL,NIL,1,.F.)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nNroOpc == 0
	  RETURN NIL
       ENDIF
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>ANALISIS DE OPCION ESCOGIDA
       DO CASE
       CASE nNroOpc == 1
	    ValidaNot(aP1,aP2,aP3,;
		      FileNoP,nNroPer,cCodMat,lMatSel,;
		      lGrabar,oBrowse)

       CASE nNroOpc == 2
	    LeeLista(lShared,oBrowse)
	   *Lectura del N£mero de lista

       CASE nNroOpc == 3
	    OrdenaNoP(lShared,oBrowse,FileNoP)
	   *Ordenamiento por N£mero de lista

       ENDCASE

       RESTSCREEN(0,0,24,79,cSavPan)
       SELECT NOP
       NOP->(DBGOTOP())
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: VALIDAR CON CONTABILIDAD                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 08/2003 MIE A
       Colombia, Bucaramanga        INICIO: 09:15 PM   OCT 08/2003 MIE

OBJETIVOS:

1- Menu de Otros para el archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ValidaNot(aP1,aP2,aP3,;
		   FileNoP,nNroPer,cCodMat,lMatSel,lGrabar,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       FileNoP                              // Archivo de Notas del Profesor
       nNroPer                              // N£mero del Periodo
       cCodMat                              // C¢digo de la Materia
       lMatSel                              // .T. Materia Selectiva
       lGrabar                              // .T. Grabar Actualizacion
       oBrowse                              // oBrowse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar Linea
       LOCAL lHayErr := .F.                 // .T. Hay Error
     *ÀVariables generales

       LOCAL       i := 0                   // Contador
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura
       LOCAL nFilIni := 0                   // Fila Inicial
       LOCAL nColIni := 0                   // Columna Inicial

       LOCAL cIndNot := ''                  // Logros de Notas
       LOCAL cNotInd := ''                  // Nota de los Indicadores en Notas
       LOCAL cDefNot := ''                  // Juicio Valorativo
       LOCAL cRecNot := ''                  // Juicios Valorativo Recuperaci¢n

       LOCAL cIndNoP := ''                  // Logros de Notas del Profesor
       LOCAL cNtINoP := ''                  // Nota de los Indicadores en Profesor
       LOCAL cDefNoP := ''                  // Juicio Valorativo
       LOCAL cRecNoP := ''                  // Juicio Valorativo Recuperacion

       LOCAL nGrabar := 0                   // Opci¢n de Grabaci¢n
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cNombreTes := ''               // Nombre del estudiante

       LOCAL cCamIndNoP := ''               // Campo Indicadores profesor
       LOCAL cCamNtINop := ''               // Campo de Nota de Indicadores
       LOCAL cCamDefNoP := ''               // Campo Definitiva profesor
       LOCAL cCamRecNoP := ''               // Campo Recuperaci¢n profesor

       LOCAL cCamIndNot := ''               // Campo Indicadore en Notas
       LOCAL cCamNtINot := ''               // Campo de Nota de Indicadores
       LOCAL cCamDefNot := ''               // Campo Nota Definitiva en Notas
       LOCAL cCamRecNot := ''               // Campo Recuperaci¢n en Notas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := xPrm(aP1,'lShared') // .T. Sistema Compartido
       LOCAL nModCry := xPrm(aP1,'nModCry') // Modo de Protecci¢n
       LOCAL cCodSui := xPrm(aP1,'cCodSui') // C¢digo del Sistema
       LOCAL cNomSis := xPrm(aP1,'cNomSis') // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := xPrm(aP1,'cEmpPal') // Nombre de la Empresa principal
       LOCAL cNitEmp := xPrm(aP1,'cNitEmp') // Nit de la Empresa
       LOCAL cNomEmp := xPrm(aP1,'cNomEmp') // Nombre de la Empresa
       LOCAL cNomSec := xPrm(aP1,'cNomSec') // Nombre de la Empresa Secundario
       LOCAL cCodEmp := xPrm(aP1,'cCodEmp') // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := xPrm(aP1,'cNomUsr') // Nombre del Usuario
       LOCAL cAnoUsr := xPrm(aP1,'cAnoUsr') // A¤o del usuario
       LOCAL cAnoSis := xPrm(aP1,'cAnoSis') // A¤o del sistema
       LOCAL cPatSis := xPrm(aP1,'cPatSis') // Path del sistema
     *ÀDetalles del Usuario

       LOCAL PathW01 := xPrm(aP1,'PathW01') // Sitio del Sistema No.01
       LOCAL PathW02 := xPrm(aP1,'PathW02') // Sitio del Sistema No.02
       LOCAL PathW03 := xPrm(aP1,'PathW03') // Sitio del Sistema No.03
       LOCAL PathW04 := xPrm(aP1,'PathW04') // Sitio del Sistema No.04
       LOCAL PathW05 := xPrm(aP1,'PathW05') // Sitio del Sistema No.05
       LOCAL PathW06 := xPrm(aP1,'PathW06') // Sitio del Sistema No.06
       LOCAL PathW07 := xPrm(aP1,'PathW07') // Sitio del Sistema No.07
       LOCAL PathW08 := xPrm(aP1,'PathW08') // Sitio del Sistema No.08
       LOCAL PathW09 := xPrm(aP1,'PathW09') // Sitio del Sistema No.09
       LOCAL PathW10 := xPrm(aP1,'PathW10') // Sitio del Sistema No.10
     *ÀSitios del Sistema

       LOCAL PathUno := xPrm(aP1,'PathUno') // Path de Integraci¢n Uno
       LOCAL PathDos := xPrm(aP1,'PathDos') // Path de Integraci¢n Dos
       LOCAL PathTre := xPrm(aP1,'PathTre') // Path de Integraci¢n Tres
       LOCAL PathCua := xPrm(aP1,'PathCua') // Path de Integraci¢n Cuatro
     *ÀPath de Integraci¢n

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>DECLARACION DE PARAMETROS ESPECIFICOS
       LOCAL cCodPro := xPrm(aP1,'cCodPro') // C¢digo del Profesor
       LOCAL cPatPro := xPrm(aP1,'cPatPro') // Path del Profesor
       LOCAL cNomPro := xPrm(aP1,'cNomPro') // Nombre del Profesor
*>>>>DECLARACION DE PARAMETROS ESPECIFICOS

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
		       FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS')
	  CloseDbf('TCO')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL NIVEL DE LA CONTABILIDAD')
       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseDbf('TCO')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>CALCULO DEL CAMPO DE INDICADORES DE NOTAS
       IF !lMatSel
	  cCamIndNot := cCamJuiNot(lShared,cAnoUsr,cMaeAct,;
				   PathUno+'\'+cPatSis,;
				   nNroPer,&cMaeAct->cCodigoGru,;
				   cCodMat,.F.,@cCamDefNot,@cCamRecNot,;
				   @cCamNtINot)
	  IF EMPTY(cCamIndNot)
	     CloseDbf('TCO')
	     RETURN NIL
	  ENDIF
       ENDIF
       cCamIndNoP := 'NOP->cIndic'+STR(nNroPer,1,0)+'NoP'
       cCamNtINoP := 'NOP->cIndnt'+STR(nNroPer,1,0)+'NoP'
       cCamDefNoP := 'NOP->cDefin'+STR(nNroPer,1)+'NoP'
       cCamRecNoP := 'NOP->cDefRe'+STR(nNroPer,1,0)+'NoP'
*>>>>FIN CALCULO DEL CAMPO DE INDICADORES DE NOTAS

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,;
			 ALLTRIM(MAT->cNombreMat),22,'°')
       @ nNroFil,01 SAY 'CODIGO'
       @ nNroFil,08 SAY 'NOMBRE'
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>DETERMINACION DE COLS Y LONGITUD DE NOMBRE
       nNroCol := 08
       nFilIni := 06
       nColIni := nNroCol
       nNroFil := nFilIni

       nNroFil = nNroFil + 1
       cSavPan := SAVESCREEN(0,0,24,79)
*>>>>FIN DETERMINACION DE COLS Y LONGITUD DE NOMBRE

*>>>>CONSULTA DEL ESTUDIANTE
       cNombreTes := 'ESTUDIANTE NO EXISTE'
       IF lSekCodigo(NOP->cCodigoEst,cMaeAct)
	  cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			RTRIM(&cMaeAct->cNombreEst)
	  cNombreTes += ' DEL GRUPO '+&cMaeAct->cCodigoGru
       ENDIF

       nNroFil := nFilIni + 1
       @ nNroFil,01 SAY NOP->cCodigoEst
       @ nNroFil,08 SAY cNombreTes  PICT '@A'
*>>>>CONSULTA DEL ESTUDIANTE

*>>>>CALCULO DEL CAMPO DE INDICADORES DE NOTAS
       IF lMatSel
	  CloseDbf('PLA')
	  CloseDbf('NOT')
	  cCamIndNot := cCamJuiNot(lShared,cAnoUsr,cMaeAct,;
				   PathUno+'\'+cPatSis,;
				   nNroPer,&cMaeAct->cCodigoGru,;
				   cCodMat,.T.,;
				   @cCamDefNot,@cCamRecNot)
	  IF EMPTY(cCamIndNot)
	     cError('CAMPO DE INDICADORES VACIO DE NOTAS')
	     CloseDbf('TCO')
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN CALCULO DEL CAMPO DE INDICADORES DE NOTAS

*>>>>LOCALIZACION DEL ESTUDIANTE EN NOTAS
       cIndNot := ''
       cDefNot := ''
       cRecNot := ''
       IF lLocCodigo('cCodigoEst','NOT',NOP->cCodigoEst)

	  cIndNot := &cCamIndNot
	  cDefNot := &cCamDefNot
	  cRecNot := &cCamRecNot

	  IF SUBS(TCO->cEvaIndTbl,nNroPer,1) == '2'
	     cNotInd := &cCamNtINot
	  ENDIF
       ELSE
	  cError('EL ESTUDIANTE NO EXISTE EN NOTAS DEL GRUPO '+;
		 &cMaeAct->cCodigoGru)
	  CloseDbf('TCO')
	  RETURN NIL
       ENDIF
       IF EMPTY(cIndNot)
	  cError('NO APARECEN INDICADORES EN NOTAS')
       ENDIF
*>>>>FIN LOCALIZACION DEL ESTUDIANTE EN NOTAS

*>>>>LOCALIZACION DEL ESTUDIANTE EN NOTAS PROFESOR
       cIndNoP := ''
       cDefNoP := ''
       cRecNoP := ''
       IF lLocCodigo('cCodigoEst','NOP',NOP->cCodigoEst)
	  cIndNoP := &cCamIndNoP
	  cNtINoP := &cCamNtINoP
	  cDefNoP := &cCamDefNoP
	  cRecNoP := &cCamRecNoP
       ELSE
	  cError('EL ESTUDIANTE NO EXISTE EN LA MATERIA DEL PROFESOR')
	  CloseDbf('TCO')
	  RETURN NIL
       ENDIF
       IF EMPTY(cIndNoP)
	  cError('NO APARECEN INDICADORES EN EL PROFESOR')
       ENDIF
*>>>>FIN LOCALIZACION DEL ESTUDIANTE EN NOTAS PROFESOR

*>>>>VALIDACION DE LOS INDICADORES
       lGrabar := IF(lGrabar=NIL,.F.,lGrabar)
       lHayErr := .T.
       DO CASE
       CASE !EMPTY(cIndNot) .AND. EMPTY(cIndNoP)

	    cError('NO EXISTEN INDICADORES APLICADOS EN EL PROFESOR '+;
		   'PERIODO No. '+STR(nNroPer,1))

       CASE EMPTY(cIndNot) .AND. !EMPTY(cIndNoP)

	    cError('NO EXISTEN INDICADORES EN LA CONTABILIDAD '+;
		   'PERIODO No. '+STR(nNroPer,1))

       CASE cIndNot # cIndNoP

	    cError('EXISTE INCONSISTENCIA EN LOS INDICADORES '+;
		    'PERIODO No. '+STR(nNroPer,1))

       OTHERWISE
	    lHayErr := .F.
	    lGrabar := .F.
       ENDCASE

       IF lHayErr
	  IF lMatSel
	     cError('VERIFIQUE SI EL ESTUDIANTE FUE TRASLADADO')
	  ENDIF
       ENDIF
*>>>>FIN VALIDACION DE LOS INDICADORES

*>>>>VALIDACION DE LOS REGISTROS
       IF NOT->cCodigoEst # NOP->cCodigoEst
	  cError('LOS CODIGOS:'+NOT->cCodigoEst+':'+NOP->cCodigoEst+' '+;
		 'DEL ESTUDIANTE NO SON IGUALES')
	  CloseDbf('TCO')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE LOS REGISTROS

*>>>>IMPRESION DE LOS ENCABEZADOS DE LAS NOTAS
       @ nNroFil+2,01 SAY 'INDICADORES EN CONTABILIDAD:'
       i := 1
       DO WHILE i <= 10
	  @ nNroFil+3,nNroCol SAY (i<10,'INDI','IND')+LTRIM(STR(i))
	  i++
	  nNroCol := nNroCol + 7
       ENDDO

       nNroCol = nNroCol - (i-1)*7
       nNroFil = nNroFil + 1
      *Ubica la fila primera de grabacion
*>>>>FIN IMPRESION DE LOS ENCABEZADOS DE LAS NOTAS

*>>>>CONSULTA DE LOS INDICADORES EN CONTABILIDAD
       DispLogRec(nNroFil+3,nColIni,cIndNot)
*>>>>FIN CONSULTA DE LOS INDICADORES EN CONTABILIDAD

*>>>>IMPRESION DE LOS ENCABEZADOS DEL PROFESOR
       @ nNroFil+5,01 SAY 'INDICADORES EN EL PROFESOR:'
       i := 1
       DO WHILE i <= 10
	  @ nNroFil+6,nNroCol SAY (i<10,'INDI','IND')+LTRIM(STR(i))
	  i++
	  nNroCol := nNroCol + 7
       ENDDO
*>>>>FIN IMPRESION DE LOS ENCABEZADOS DEL PROFESOR

*>>>>CONSULTA DE LOS INDICADORES DEL PROFESOR
       DispLogRec(nNroFil+7,nColIni,cIndNoP)
*>>>>FIN CONSULTA DE LOS INDICADORES DEL PROFESOR

*>>>>CONSULTA DE JUICIOS VALORATIVOS
       cSay(nNroFil+10,01,'JUICIOS VALORATIVOS EN SIMACONT:')
       SET COLOR TO I
       cSay(nNroFil+10,33,SUBS(cDefNot,nNroPer*4-3,4))
       SET COLOR TO

       cSay(nNroFil+11,01,'JUICIOS VALORATIVOS EN SIMAPROF:')
       SET COLOR TO I
       cSay(nNroFil+11,33,cDefNoP)
       SET COLOR TO
       cSay(nNroFil+11,42,'Periodo No.',STR(nNroPer,1))

       IF !EMPTY(cRecNot) .OR. !EMPTY(cRecNoP)
	  cSay(nNroFil+12,01,'JUICIOS RECUPERADOS EN SIMACONT:')
	  SET COLOR TO I
	  cSay(nNroFil+12,33,SUBS(cRecNot,nNroPer*4-3,4))
	  SET COLOR TO
       ENDIF

       IF !EMPTY(cRecNot) .OR. !EMPTY(cRecNoP)
	  cSay(nNroFil+13,01,'JUICIOS RECUPERADOS EN SIMAPROF:')
	  SET COLOR TO I
	  cSay(nNroFil+13,33,cRecNoP)
	  SET COLOR TO
	  cSay(nNroFil+13,42,'Periodo No.',STR(nNroPer,1))
       ENDIF
*>>>>FIN CONSULTA DE JUICIOS VALORATIVOS

*>>>>GRABACION ACTUALIZACION DE LAS INCONSISTENCIAS
       IF lGrabar
	  nGrabar := nLeeOpcion('ACTUALIZAR: '+;
		    '1<CONTABILIDAD=>PROFESOR> '+;
		    '2<PROFESOR=>CONTABILIDAD> '+;
		    '3<ABANDONAR>?',3,'0')
	  DO CASE
	  CASE nGrabar == 1
	       SELECT NOP
	       IF NOP->(lRegLock(lShared,.F.))
		  REPL &cCamIndNoP WITH cIndNot
		  REPL &cCamDefNoP WITH SUBS(cDefNot,nNroPer*4-3,4)
		  REPL &cCamRecNoP WITH SUBS(cRecNot,nNroPer*4-3,4)
		  NOP->(DBCOMMIT())
	       ELSE
		  cError('NO SE GRABA LOS LOGROS DEL ESTUDIANTE')
	       ENDIF
	       IF lShared
		  NOP->(DBUNLOCK())
	       ENDIF

	  CASE nGrabar == 2
	       SELECT NOT
	       IF NOT->(lRegLock(lShared,.F.))
		  REPL &cCamIndNot WITH cIndNoP
		  REPL &cCamDefNot WITH STUFF(&cCamDefNot,nNroPer*4-3,4,cDefNoP)
		  REPL &cCamRecNot WITH STUFF(&cCamRecNot,nNroPer*4-3,4,cRecNoP)
		  NOT->(DBCOMMIT())
	       ELSE
		  cError('NO SE GRABA LOS LOGROS DEL ESTUDIANTE')
	       ENDIF
	       IF lShared
		  NOT->(DBUNLOCK())
	       ENDIF
	  OTHERWISE
	       cError('SE ABANDONA EL PROCESO DE ACTUALIZACION')
	  ENDCASE
       ENDIF
       cPausa()
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN GRABACION ACTUALIZACION DE LAS INCONSISTENCIAS

*>>>>ANALISIS DE DECISION
       IF SUBS(TCO->cEvaIndTbl,nNroPer,1) == '2'

**********IMPRESION DE LOS ENCABEZADOS DE LAS NOTAS
	    nNroFil := nFilIni-2
	    nNroCol := 08
	    @ nNroFil+2,01 SAY 'NOTAS INDICADORES EN CONTABILIDAD:'
	    i := 1
	    FOR i := 1 TO 5
	       @ nNroFil+3,nNroCol SAY 'NOT'+LTRIM(STR(i))
	       nNroCol := nNroCol + 9
	    ENDFOR
	    nNroFil = nNroFil + 1
	   *Ubica la fila primera de grabacion
**********FIN IMPRESION DE LOS ENCABEZADOS DE LAS NOTAS

**********CONSULTA DE LOS INDICADORES EN CONTABILIDAD
	    DispNtINoP(nNroFil+3,nColIni,cNotInd)
**********FIN CONSULTA DE LOS INDICADORES EN CONTABILIDAD

**********IMPRESION DE LOS ENCABEZADOS DEL PROFESOR
	    nNroCol := 08
	    @ nNroFil+8,01 SAY 'NOTAS INDICADORES EN EL PROFESOR:'
	    FOR i := 1 TO 5
	       @ nNroFil+9,nNroCol SAY 'NOT'+LTRIM(STR(i))
	       nNroCol := nNroCol + 9
	    ENDFOR
**********FIN IMPRESION DE LOS ENCABEZADOS DEL PROFESOR

**********CONSULTA DE LOS INDICADORES DEL PROFESOR
	    DispNtINoP(nNroFil+10,nColIni,cNtINoP)
	    cPausa()
**********FIN CONSULTA DE LOS INDICADORES DEL PROFESOR

       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
       CloseDbf('TCO')
       RETURN NIL
*>>>>FIN ANALISIS DE DECISION

/*************************************************************************
* TITULO..: CAMPO DE INDICADORES                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 05/2002 MIE A
       Colombia, Bucaramanga        INICIO: 01:30 PM   JUN 05/2002 MIE

OBJETIVOS:

1- Calcula el campo de los c¢digos de los indicadores para archivo de notas

2- Retorna el nombre del campo

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cCamJuiNot(lShared,cAnoUsr,cMaeAct,cPatCon,;
		    nNroPer,cCodGru,cCodMat,lMatVar,;
		    cNotDef,cNotRec,cNotInd,cCamFal)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cAnoUsr                              // A¤o del Usuario
       cMaeAct                              // Maestro Actual
       cPatCon			            // Path de Contabilidad
       nNroPer                              // N£mero del Periodo
       cCodGru                              // C¢digo del Grupo
       cCodMat                              // Codigo de la Materia
       lMatVar                              // .T. Materia Variable
       cNotDef                              // @Campo de Nota Definitiva
       cNotRec                              // @Campo de Nota Recuperaci¢n
       cNotInd                              // @Campo de Notas de Indicadores
       cCamFal                              // @Campo de Fallas */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL cPorcen := ''                  // Porcentaje de la materia
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL nRegMat := 0                   // Registro de la Materia
       LOCAL cCampo  := ''                  // Nombre del Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !('XXXX' $ cCodGru)
	  IF !lUseDbf(.T.,cPatCon+'\'+cMaeAct+'\'+;
			 cFilePlan(cAnoUsr,cCodGru),'PLA',NIL,lShared)

	     cError('NO EXISTE PLAN ACADEMICO PARA EL NIVEL DE '+;
		     cNomNiv(SUBS(cCodGru,1,2)))
	     CloseDbf('PLA')
	     RETURN ''
	  ENDIF
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>LOCALIZACION DE LA MATERIA VARIABLE
       lMatVar := IF(lMatVar==NIL,.F.,lMatVar)
       IF lMatVar
	  nRegMat := MAT->(RECNO())
	  IF !lMatVarMat(cCodMat,.F.)
	     cError('NO EXISTE LA MATERIA VARIABLE DE LA MATERIA:'+cCodMat)
	     CloseDbf('PLA')
	     RETURN ''
	  ENDIF
	  cCodMat := MAT->cCodigoMat
	  MAT->(DBGOTO(nRegMat))
       ENDIF
*>>>>FIN LOCALIZACION DE LA MATERIA VARIABLE

*>>>>LOCALIZACION DE LA MATERIA EN PLAN
       IF !('XXXX' $ cCodGru)
	  IF !lLocCodigo('cCodigoMat','PLA',cCodMat)
	     cError('LA MATERIA: '+cCodMat+;
		     'NO EXISTE EN PLAN DE: '+cCodGru)
	     CloseDbf('PLA')
	     RETURN ''
	  ENDIF
       ENDIF
*>>>>FIN LOCALIZACION DE LA MATERIA EN PLAN

*>>>>ASIGNACION DE LA MATERIA A GRABAR
       IF PLA->cTipArePla == 'N'
	  cCampo  := 'NOT->cJ'+STR(nNroPer,1)+cCodMat+'Not'
	  cNotDef := 'NOT->cAreN'+SUBS(cCodMat,1,2)+'Not'
	  cNotRec := 'NOT->cAreN'+SUBS(cCodMat,1,2)+'Rec'
	  cNotInd := 'NOT->cN'+STR(nNroPer,1)+cCodMat+'Not'
	  cCamFal := 'NOT->cFA'+cCodMat+'Not'
       ELSE
	  cPorcen := IF(PLA->nPorcenPla == 0,;
			'100','0'+STR(PLA->nPorcenPla,2))
	  cCampo  := 'NOT->cJ'+STR(nNroPer,1)+cCodMat+"Not"
	  cNotDef := 'NOT->cNt'+cCodMat+cPorcen
	  cNotRec := 'NOT->cNt'+cCodMat+'Rec'
	  cNotInd := 'NOT->cN'+STR(nNroPer,1)+cCodMat+'Not'
	  cCamFal := 'NOT->cFA'+cCodMat+'Not'
       ENDIF
*>>>>FIN ASIGNACION DE LA MATERIA A GRABAR

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatCon+'\'+cMaeAct+'\NOTAS\'+;
		   'NT'+cCodGru+cAnoSis+ExtFile,'NOT',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+cCodGru)
	  CloseDbf('PLA')
	  CloseDbf('NOT')
	  RETURN ''
       ENDIF
       RETURN cCampo
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO..: INDICADORES POR RECUPERAR                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 14/2002 VIE A
       Colombia, Bucaramanga        INICIO: 01:20 PM   JUN 14/2002 VIE

OBJETIVOS:

1- Calcula los indicadores pendiente por Recuperar

2- Retorna los Indicadores por Recuperar.

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cIndxRecu(cLogros,nNroPer)

*>>>>DESCRIPCION DE PARAMETROS
/*     cLogros                             // Indicadores
       nNroPer                             // N£mero del Periodo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cRecupe := ''                  // Indicadores por Recuperar
       LOCAL cCodLog := ''                  // C¢digo del Logro
       LOCAL nLenCod := 6                   // Longitud del C¢digo
       LOCAL lHayCla := .F.                 // .T. Hay Clase de Indicador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>INDICADORES POR RECUPERAR
       FOR i := 1 TO 20

***********REEVALUAR EL INDICADOR
	     cCodLog := SUBS(cLogros,nPosIni(i,nLenCod),nLenCod)
	     lHayCla := lLocCodigo('cCodigoCla','CLA',SUBS(cCodLog,1,1))

	     IF lHayCla .AND. CLA->cReeEvaCla == '01' // Reevaluar el indicador
		cRecupe += cCodLog
		LOOP
	     ENDIF
***********FIN REEVALUAR EL INDICADOR

***********ANALISIS DE DECISION
	     DO CASE
	     CASE SUBS(TCO->cEvaIndTbl,nNroPer,1) == '0'

*=================RECUPERACIONES POR CLASE DE INDICADOR
		    IF lHayCla .AND. CLA->lRecupeCla .AND.;
		       lLocCodigo('cCodigoEva','EVA',SUBS(cCodLog,6,1)) .AND.;
		       !EVA->lSiRecuEva

		       cRecupe += cCodLog
		    ELSE
		       IF CLA->cReeEvaCla == '01' // Reevaluar el indicador
			  cRecupe += cCodLog
		       ENDIF
		    ENDIF
*=================FIN RECUPERACIONES POR CLASE DE INDICADOR

	     CASE SUBS(TCO->cEvaIndTbl,nNroPer,1) == '1'

*=================RECUPERACIONES POR TIPO DE EVALUACION CUALITATIVA
		    IF lLocCodigo('cCodigoEva','EVA',SUBS(cCodLog,5,1)) .AND.;
		       EVA->lRecupeEva .AND. !EVA->lSiRecuEva .AND.;
		       lHayCla .AND. CLA->lRecupeCla

		       IF EMPTY(SUBS(cCodLog,6,1))
			  cRecupe += cCodLog
		       ELSE
			  IF lLocCodigo('cCodigoEva','EVA',SUBS(cCodLog,6,1)).AND.;
			     EVA->lRecupeEva .AND. !EVA->lSiRecuEva
			     cRecupe += cCodLog
			  ELSE
			     IF CLA->cReeEvaCla == '01' // Reevaluar el indicador
				cRecupe += cCodLog
			     ENDIF
			  ENDIF
		       ENDIF
		    ENDIF
*=================FIN RECUPERACIONES POR TIPO DE EVALUACION CUALITATIVA

	     CASE SUBS(TCO->cEvaIndTbl,nNroPer,1) == '2'

*=================RECUPERACIONES POR TIPO DE EVALUACION NUMERICA
		    IF lLocCodigo('cCodigoEva','EVA',SUBS(cCodLog,5,1)) .AND.;
		       EVA->lRecupeEva .AND. !EVA->lSiRecuEva .AND.;
		       lHayCla .AND. CLA->lRecupeCla

		       IF EMPTY(SUBS(cCodLog,6,1))
			  cRecupe += cCodLog
		       ELSE
			  IF lLocCodigo('cCodigoEva','EVA',SUBS(cCodLog,6,1)).AND.;
			     EVA->lRecupeEva .AND. !EVA->lSiRecuEva
			     cRecupe += cCodLog
			  ELSE
			     IF CLA->cReeEvaCla == '01' // Reevaluar el indicador
				cRecupe += cCodLog
			     ENDIF
			  ENDIF
		       ENDIF

		    ENDIF
*=================FIN RECUPERACIONES POR TIPO DE EVALUACION NUMERICA

	     ENDCASE
***********FIN ANALISIS DE DECISION

       ENDFOR
       RETURN cRecupe
*>>>>FIN INDICADORES POR RECUPERAR

/*************************************************************************
* TITULO..: INDICADORES POR RECUPERAR O RECUPERADOS                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 17/2006 MIE A
       Colombia, Bucaramanga        INICIO: 01:20 PM   MAY 17/2006 MIE

OBJETIVOS:

1- Calcula los indicadores por Recuperar o recuperados

2- Retorna los Indicadores por Recuperar o recuperados

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cIndRecupe(cLogros,nNroPer)

*>>>>DESCRIPCION DE PARAMETROS
/*     cLogros                             // Indicadores
       nNroPer                             // N£mero del Periodo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                  // Contador
       LOCAL cRecupe := ''                 // Indicadores por recuperar o recuperados
       LOCAL nLenCod := 6                  // Longitud del C¢digo
       LOCAL cCodLog := ''                  // C¢digo del Logro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE LOS INDICADORES POR RECUPERAR
       cRecupe := ''
       FOR i := 1 TO 20

	   cCodLog := SUBS(cLogros,nPosIni(i,nLenCod),nLenCod)

	   IF SUBS(TCO->cEvaIndTbl,nNroPer,1) == '0'

**************RECUPERACIONES POR CLASE DE INDICADOR
		IF lLocCodigo('cCodigoCla','CLA',SUBS(cCodLog,1,1)).AND.;
		   CLA->lRecupeCla

		   cRecupe += cCodLog

		ENDIF
**************FIN RECUPERACIONES POR CLASE DE INDICADOR

	   ELSE

**************RECUPERACIONES POR TIPO DE EVALUACION
		IF lLocCodigo('cCodigoEva','EVA',SUBS(cCodLog,5,1)).AND.;
		   EVA->lRecupeEva

		   cRecupe += cCodLog

		ENDIF
**************FIN RECUPERACIONES POR TIPO DE EVALUACION

	   ENDIF
       ENDFOR
       RETURN cRecupe
*>>>>FIN ANALISIS DE LOS INDICADORES POR RECUPERAR

/*************************************************************************
* TITULO..: VISUALIZACION DE LOS INDICADORES CON RECUPERACIONES          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 16/2002 LUN A
       Colombia, Bucaramanga        INICIO: 02:30 PM   SEP 16/2002 LUN

OBJETIVOS:

1- Visualiza los indicadores con evaluaci¢n y recuperaciones

2- Retorna Nil


SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/
	 
FUNCTION DispLogRec(nNroFil,nColIni,cLogros)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // @N£mero de la fila
       nColIni                              // Columba Inicial
       cLogros                              // Logros del Estudiante */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL nNroCol := 0                   // N£mero de columna
       LOCAL lOtrFil := .F.                 // .T. Otra Fila de impresi¢n
       LOCAL nNroInd := 0                   // N£mero de Indicadores
       LOCAL cCodLog := ''                  // C¢digo del Logro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE LOS LOGROS
       nNroInd := ROUND(LEN(ALLTRIM(cLogros))/6,0)
       nNroCol := nColIni
       lOtrFil := .F.
       FOR i := 1 TO nNroInd

************IMPRESION DEL LOGRO
	      cCodLog := SUBS(cLogros,i*6-5,6)
	     *Lectura del C¢digo

	      @ nNroFil,nNroCol SAY cCodLog PICT 'AAAAAA' COLOR("I")
	      nNroCol := nNroCol + 7
************FIN IMPRESION DEL LOGRO

************ANALISIS DEL CAMBIO DE LA FILA
	      IF !lOtrFil
		 IF i == 10 .AND. nNroInd > 10
		    nNroFil++
		    nNroCol := nColIni
		    lOtrFil := .T.
		 ENDIF
	      ENDIF
************FIN ANALISIS DEL CAMBIO DE LA FILA

       NEXT
       RETURN NIL
*>>>>FIN IMPRESION DE LOS LOGROS

/*************************************************************************
* TITULO..: VISUALIZACION DE LOS INDICADORES CON RECUPERACIONES          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 16/2002 LUN A
       Colombia, Bucaramanga        INICIO: 02:30 PM   SEP 16/2002 LUN

OBJETIVOS:

1- Visualiza los indicadores con evaluaci¢n y recuperaciones

2- Retorna Nil


SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION DispNtINoP(nNroFil,nColIni,cNtINot)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // @N£mero de la fila
       nColIni                              // Columba Inicial
       cLogros                              // Logros del Estudiante
       cNtINot			            // Nota de los Indicadores */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL nNroCol := 0                   // N£mero de columna
       LOCAL lOtrFil := .F.                 // .T. Otra Fila de impresi¢n
       LOCAL cCodNot := ''                  // C¢digo de la Nota
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE LOS LOGROS
       nNroCol := nColIni
       lOtrFil := .F.
       FOR i := 1 TO 20

************IMPRESION DEL LOGRO
	      cCodNot := SUBS(cNtINot,i*8-7,8)
	     *Lectura del C¢digo

	      @ nNroFil,nNroCol SAY cCodNot PICT 'AAAAAAAA' COLOR("I")
	      nNroCol := nNroCol + 9
************FIN IMPRESION DEL LOGRO

************ANALISIS DEL CAMBIO DE LA FILA
	      IF MOD(i,5) == 0
		 nNroFil++
		 nNroCol := nColIni
	      ENDIF
************FIN ANALISIS DEL CAMBIO DE LA FILA

       NEXT
       RETURN NIL
*>>>>FIN IMPRESION DE LOS LOGROS

/*************************************************************************
* TITULO..: LECTURA DE LOS NUMEROS DE LISTA                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 02/2004 VIE A
       Colombia, Bucaramanga        INICIO: 02:30 PM   ABR 02/2004 VIE

OBJETIVOS:

1- Lee los N£meros de lista.

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION LeeLista(lShared,oBrowse)

*>>>>DESCRIPCION DE PARAMENTROS
/*     lShared                              // Archivos Compartidos
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMENTROS

*>>>>RECORRIDO DEL ARCHIVO
       SELECT NOP
       NOP->(DBGOTOP())
       DO WHILE .NOT. NOP->(EOF())

**********GRABACION DEL NUMERO DE LISTA
	    IF NOP->(lRegLock(lShared,.F.))
	       REPL NOP->nNroLisEst WITH NOP->(RECNO())
	       NOP->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABA LOS LOGROS DEL ESTUDIANTE')
	    ENDIF
	    IF lShared
	       NOP->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL NUMERO DE LISTA

	  NOP->(DBSKIP())
       ENDDO
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN RECORRIDO DEL ARCHIVO

/*************************************************************************
* TITULO..: ORDENAR EL ARCHIVO POR NUMERO DE LISTA                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 02/2004 VIE A
       Colombia, Bucaramanga        INICIO: 03:0 PM    ABR 02/2004 VIE

OBJETIVOS:

1- Ordena el archivo por n£mero de lista.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OrdenaNoP(lShared,oBrowse,FileNoP)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       oBrowse			            // Browse del Profesor
       FileNoP				    // Nombre del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CONTENIDO
       IF NOP->(RECCOUNT()) == 0
	  cError('NO EXISTEN ESTUDIANTES GRABADOS')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>VALIDACION DEL NUMERO DE LISTA
       SELECT NOP
       NOP->(DBGOTOP())
       DO WHILE .NOT. NOP->(EOF())

**********ANALISIS DE DECISION
	    IF NOP->nNroLisEst == 0
	       cError('NO SE HAN ASIGNADO TODOS LOS NUMEROS DE LISTA')
	       lHayErr := .T.
	       EXIT
	    ENDIF
**********FIN ANALISIS DE DECISION

	  NOP->(DBSKIP())

       ENDDO
       IF lHayErr
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL NUMERO DE LISTA

*>>>>ANALISIS DE DECISION
       IF !lPregunta('ESTA SEGURO QUE DESEA ORDENAR? No Si')
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>ORDENACION DEL ARCHIVO
       CloseDbf('NOP')
       IF !lOrdFile(lShared,FileNoP,'nNroLisEst')
	  cError('NO SE ORDENO EL ARCHIVO')
       ENDIF
*>>>>FIN ORDENACION DEL ARCHIVO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,FileNoP,'NOP',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO'+FileNoP)
	  RETURN NIL
       ENDIF
       SELECT NOP
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO