/* SIMA - COLEGIOS

MODULO      : SIMA
SUBMODULO...: PATH

**************************************************************************
* TITULO..: PATHS DE INTEGRACION DEL SIMA                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 23/2008 MIE A
       Colombia, Bucaramanga        INICIO:  09:11 AM  ABR 23/2008 MIE

OBJETIVOS:

1- Modifica los paths de integraci¢n del sima de cualquier colegio
   con el objetivo de realizar pruebas.

2- Return Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Cole_101(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "CAMPOS\ARC-COL.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar Linea
       LOCAL lHayErr    := .F.              // .T. Hay Error

       LOCAL cPatDat := ''                  // Path de los Datos
       LOCAL cDirCol := ''                  // Directorio del Colegio

       LOCAL lMtrAno := .F.                 // .T. Existe el Archivo
       LOCAL lConAno := .F.                 // .T. Existe el Archivo
       LOCAL lProAno := .F.                 // .T. Existe el Archivo
       LOCAL lCarAno := .F.                 // .T. Existe el Archivo
       LOCAL lDatAno := .F.                 // .T. Existe el Archivo
       LOCAL lAsiAno := .F.                 // .T. Existe el Archivo
       LOCAL lCafAno := .F.                 // .T. Existe el Archivo
       LOCAL lSimTol := .F.                 // .T. Existe el Archivo
       LOCAL lSimPak := .F.                 // .T. Existe el Archivo

       LOCAL GetList := {}                  // Variable del sistema
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

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Actual
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos

       CloseAll()
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>LECTURA DEL DIRECTORIO DEL COLEGIO
       cDirCol := SPACE(08)
       @ nFilInf+1,nColInf SAY 'DIRECTORIO DEL COLEGIO:' GET cDirCol PICT '@!'
       READ
       cDirCol := ALLTRIM(cDirCol)
       cDirCol := LOWER(cDirCol)
*>>>>FIN LECTURA DEL DIRECTORIO DEL COLEGIO

*>>>>AREAS DE TRABAJO
       aUseDbf := {}

       fMtrAno := cDirCol+'\'+'SIMAMATR'+'\'+cPatSis+'\'+;
		  fMtrAno+cAnoUsr+ExtFile
       IF FILE(fMtrAno)
	  AADD(aUseDbf,{.T.,fMtrAno,'MTA',NIL,lShared,nModCry})
	  lMtrAno := .T.
       ENDIF

       fConAno := cDirCol+'\'+'SIMACONT'+'\'+cPatSis+'\'+;
		  fConAno+cAnoUsr+ExtFile

       IF FILE(fConAno)
	  AADD(aUseDbf,{.T.,fConAno,'COA',NIL,lShared,nModCry})
	  lConAno := .T.
       ENDIF

       fProAno := cDirCol+'\'+'SIMAPROF'+'\'+cPatSis+'\'+;
		  fProAno+cAnoUsr+ExtFile
       IF FILE(fProAno)
	  AADD(aUseDbf,{.T.,fProAno,'PRA',NIL,lShared,nModCry})
	  lProAno := .T.
       ENDIF

       IF lProAno
	  FilePro := cDirCol+'\'+'SIMACONT'+'\'+cPatSis+'\'+;
		     FilePro+cAnoSis+ExtFile
	  IF FILE(FilePro)
	     AADD(aUseDbf,{.T.,FilePro,'PRO',NIL,lShared,nModCry})
	  ENDIF
       ENDIF

       fCarAno := cDirCol+'\'+'SIMACART'+'\'+cPatSis+'\'+;
		  fCarAno+cAnoUsr+ExtFile
       IF FILE(fCarAno)
	  AADD(aUseDbf,{.T.,fCarAno,'CAA',NIL,lShared,nModCry})
	  lCarAno := .T.
       ENDIF

       fDatAno := cDirCol+'\'+'SIMADATA'+'\'+cPatSis+'\'+;
		  fDatAno+cAnoUsr+ExtFile
       IF FILE(fDatAno)
	  AADD(aUseDbf,{.T.,fDatAno,'DAA',NIL,lShared,nModCry})
	  lDatAno := .T.
       ENDIF

       FAsiAno := cDirCol+'\'+'SIMAASIS'+'\'+cPatSis+'\'+;
		  FAsiAno+cAnoUsr+ExtFile
       IF FILE(FAsiAno)
	  AADD(aUseDbf,{.T.,FAsiAno,'ASA',NIL,lShared,nModCry})
	  lAsiAno := .T.
       ENDIF

       FCafAno := cDirCol+'\'+'SIMACAFE'+'\'+cPatSis+'\'+;
		  FCafAno+cAnoUsr+ExtFile
       IF FILE(FCafAno)
	  AADD(aUseDbf,{.T.,FCafAno,'CFA',NIL,lShared,nModCry})
	  lCafAno := .T.
       ENDIF

       fSimTol := cDirCol+'\'+'SIMATOOL'+'\'+PathSis+'\'+;
		  fSimTol+ExtFile
       IF FILE(fSimTol)
	  AADD(aUseDbf,{.T.,fSimTol,'TOL',NIL,lShared,nModCry})
	  lSimTol := .T.
       ENDIF

       fSimPak := cDirCol+'\'+'SIMAPARK'+'\'+PathSis+'\'+;
		  fSimPak+ExtFile
       IF FILE(fSimPak)
	  AADD(aUseDbf,{.T.,fSimPak,'PAR',NIL,lShared,nModCry})
	  lSimPak := .T.
       ENDIF
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE lMtrAno .AND. MTA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL A¥O DE SIMAMATR')

       CASE lConAno .AND. COA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL A¥O DE SIMACONT')

       CASE lProAno .AND. PRA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL A¥O DE SIMAPROF')

       CASE lCarAno .AND. CAA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL A¥O DE SIMACART')

       CASE lDatAno .AND. DAA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL A¥O DE SIMADATA')

       CASE lAsiAno .AND. ASA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL A¥O DE SIMAASIS')

       CASE lCafAno .AND. CFA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL A¥O DE SIMACAFE')

       CASE lSimTol .AND. TOL->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL DE SIMATOOL')

       CASE lSimPak .AND. PAR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL DE SIMAPARK')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>CAMBIOS DEL PATH DE INTEGRACION DE SIMAMATR
       cPatDat := '\simacole'
       IF lMtrAno

	  IF MTA->(lRegLock(lShared,.F.))
	     REPL MTA->cIntUnoAno WITH cPatDat+'\'+cDirCol+'\'+'SimaCont'
	     REPL MTA->cIntDosAno WITH cPatDat+'\'+cDirCol+'\'+'SimaCart'
	     REPL MTA->cIntTreAno WITH ''
	     REPL MTA->cIntCuaAno WITH ''
	     MTA->(DBCOMMIT())
	  ELSE
	     cError('NO SE GRABA EL REGISTRO INICIAL DE CONFIGURACION')
	  ENDIF
	  IF lShared
	     MTA->(DBUNLOCK())
	  ENDIF

       ENDIF
*>>>>FIN CAMBIOS DEL PATH DE INTEGRACION DE SIMAMATR

*>>>>CAMBIOS DEL PATH DE INTEGRACION DE SIMACONT
       IF lConAno

	  IF COA->(lRegLock(lShared,.F.))
	     REPL COA->cIntUnoCoA WITH cPatDat+'\'+cDirCol+'\'+'SimaProf'
	     REPL COA->cIntDosCoA WITH cPatDat+'\'+cDirCol+'\'+'SimaMatr'
	     REPL COA->cIntTreCoA WITH cPatDat+'\'+cDirCol+'\'+'SimaCart'
	     REPL COA->cIntCuaCoA WITH ''
	     COA->(DBCOMMIT())
	  ELSE
	     cError('NO SE GRABA EL REGISTRO INICIAL DE CONFIGURACION')
	  ENDIF
	  IF lShared
	     COA->(DBUNLOCK())
	  ENDIF

       ENDIF
*>>>>FIN CAMBIOS DEL PATH DE INTEGRACION DE SIMACONT

*>>>>CAMBIOS DEL PATH DE INTEGRACION DE SIMAPROF
       IF lProAno

	  IF PRA->(lRegLock(lShared,.F.))
	     REPL PRA->PathUnoAno WITH cPatDat+'\'+cDirCol+'\'+'SimaCont'
	     REPL PRA->PathDosAno WITH ''
	     REPL PRA->PathTreAno WITH ''
	     REPL PRA->PathCuaAno WITH ''
	     PRA->(DBCOMMIT())
	  ELSE
	     cError('NO SE GRABA EL REGISTRO DE LA CONFIGURACION')
	  ENDIF
	  IF lShared
	     PRA->(DBUNLOCK())
	  ENDIF

       ENDIF
*>>>>FIN CAMBIOS DEL PATH DE INTEGRACION DE SIMAPROF

*>>>>CAMBIOS DEL PATH DE INTEGRACION DE SIMACART
       IF lCarAno

	  IF CAA->(lRegLock(lShared,.F.))

	     REPL CAA->cIntUnoCaA WITH cPatDat+'\'+cDirCol+'\'+'SimaCont'
	     REPL CAA->cIntDosCaA WITH cPatDat+'\'+cDirCol+'\'+'SimaMatr'
	     REPL CAA->cIntTreCaA WITH cPatDat+'\'+cDirCol+'\'+'SimaCafe'
	     REPL CAA->cIntCuaCaA WITH cPatDat+'\'+cDirCol+'\'+'SimaData'
	     CAA->(DBCOMMIT())

	  ELSE
	     cError('NO SE GRABA EL REGISTRO INICIAL DE CONFIGURACION')
	  ENDIF

	  IF lShared
	     CAA->(DBUNLOCK())
	  ENDIF

       ENDIF
*>>>>FIN CAMBIOS DEL PATH DE INTEGRACION DE SIMACART

*>>>>CAMBIOS DEL PATH DE INTEGRACION DE SIMADATA
       IF lDatAno

	  IF DAA->(lRegLock(lShared,.F.))
	     REPL DAA->cIntUnoDaA WITH cPatDat+'\'+cDirCol+'\'+'SimaCont'
	     REPL DAA->cIntDosDaA WITH cPatDat+'\'+cDirCol+'\'+'SimaCart'
	     REPL DAA->cIntTreDaA WITH cPatDat+'\'+cDirCol+'\'+'SimaMatr'
	     REPL DAA->cIntCuaDaA WITH ''
	     DAA->(DBCOMMIT())
	  ELSE
	     cError('NO SE GRABA EL REGISTRO INICIAL DE LA CONFIGURACION')
	  ENDIF
	  IF lShared
	     DAA->(DBUNLOCK())
	  ENDIF

       ENDIF
*>>>>FIN CAMBIOS DEL PATH DE INTEGRACION DE SIMADATA

*>>>>CAMBIOS DEL PATH DE INTEGRACION DE SIMAASIS
       IF lAsiAno

	  IF ASA->(lRegLock(lShared,.F.))
	     REPL ASA->cIntUnoAsa WITH cPatDat+'\'+cDirCol+'\'+'SimaCont'
	     REPL ASA->cIntDosAsa WITH cPatDat+'\'+cDirCol+'\'+'SimaCart'
	     REPL ASA->cIntTreAsa WITH cPatDat+'\'+cDirCol+'\'+'SimaMatr'
	     REPL ASA->cIntCuaAsa WITH ''
	     ASA->(DBCOMMIT())
	  ELSE
	     cError('NO SE GRABA EL REGISTRO INICIAL DE LA CONFIGURACION')
	  ENDIF
	  IF lShared
	     ASA->(DBUNLOCK())
	  ENDIF

       ENDIF
*>>>>FIN CAMBIOS DEL PATH DE INTEGRACION DE SIMAASIS

*>>>>CAMBIOS DEL PATH DE INTEGRACION DE SIMACAFE
       IF lCafAno

	  IF CFA->(lRegLock(lShared,.F.))
	     REPL CFA->cIntUnoCfA WITH cPatDat+'\'+cDirCol+'\'+'SimaCont'
	     REPL CFA->cIntDosCfA WITH cPatDat+'\'+cDirCol+'\'+'SimaCart'
	     REPL CFA->cIntTreCfA WITH cPatDat+'\'+cDirCol+'\'+'SimaMatr'
	     REPL CFA->cIntCuaCfA WITH ''
	     CFA->(DBCOMMIT())
	  ELSE
	     cError('NO SE GRABA EL REGISTRO INICIAL DE LA CONFIGURACION')
	  ENDIF
	  IF lShared
	     CFA->(DBUNLOCK())
	  ENDIF

       ENDIF
*>>>>FIN CAMBIOS DEL PATH DE INTEGRACION DE SIMACAFE

*>>>>BORRADO DE LA CLAVES DE LOS PROFESORES
       IF lProAno
	  SELECT PRO
	  PRO->(DBGOTOP())
	  DO WHILE .NOT. PRO->(EOF())

*************LINEA DE ESTADO
	       LineaEstado('BORRANDO CLAVES DE LOS PROFESORES'+;
			   'ºNo. '+STR(PRO->(RECNO()),4)+'/'+;
				   STR(PRO->(RECCOUNT()),4),cNomSis)
*************FIN LINEA DE ESTADO

*************ELIMINACION DE LA CLAVE DEL PROFESOR
	       IF PRO->(lRegLock(lShared,.F.))
		  REPL PRO->cPasWorPro WITH ''
		  PRO->(DBCOMMIT())
	       ELSE
		  cError('NO SE GRABA EL REGISTRO INICIAL DE LA CONFIGURACION')
	       ENDIF
	       IF lShared
		  PRO->(DBUNLOCK())
	       ENDIF

	       PRO->(DBSKIP())
*************FIN ELIMINACION DE LA CLAVE DEL PROFESOR

	  ENDDO
       ENDIF
*>>>>FIN BORRADO DE LA CLAVES DE LOS PROFESORES

*>>>>CAMBIOS DEL PATH DE INTEGRACION DE SIMADATA
       IF lDatAno

	  IF DAA->(lRegLock(lShared,.F.))
	     REPL DAA->cIntUnoDaA WITH cPatDat+'\'+cDirCol+'\'+'SimaCont'
	     REPL DAA->cIntDosDaA WITH cPatDat+'\'+cDirCol+'\'+'SimaCart'
	     REPL DAA->cIntTreDaA WITH cPatDat+'\'+cDirCol+'\'+'SimaMatr'
	     REPL DAA->cIntCuaDaA WITH ''
	     DAA->(DBCOMMIT())
	  ELSE
	     cError('NO SE GRABA EL REGISTRO INICIAL DE LA CONFIGURACION')
	  ENDIF
	  IF lShared
	     DAA->(DBUNLOCK())
	  ENDIF

       ENDIF
*>>>>FIN CAMBIOS DEL PATH DE INTEGRACION DE SIMADATA

*>>>>CAMBIOS DEL PATH DE INTEGRACION DE SIMATOOL
       IF lSimTol

	  IF TOL->(lRegLock(lShared,.F.))

	     REPL TOL->PathMatr WITH cPatDat+'\'+cDirCol+'\'+'SimaMatr'
	     REPL TOL->PathCont WITH cPatDat+'\'+cDirCol+'\'+'SimaCont'
	     REPL TOL->PathProf WITH cPatDat+'\'+cDirCol+'\'+'SimaProf'
	     REPL TOL->PathCart WITH cPatDat+'\'+cDirCol+'\'+'SimaCart'
	     REPL TOL->PathVoto WITH cPatDat+'\'+cDirCol+'\'+'SimaVoto'
	     REPL TOL->PathCafe WITH cPatDat+'\'+cDirCol+'\'+'SimaCafe'
	     TOL->(DBCOMMIT())

	  ELSE
	     cError('NO SE GRABA EL REGISTRO INICIAL DE CONFIGURACION')
	  ENDIF

	  IF lShared
	     TOL->(DBUNLOCK())
	  ENDIF

       ENDIF
*>>>>FIN CAMBIOS DEL PATH DE INTEGRACION DE SIMATOOL

*>>>>CAMBIOS DEL PATH DE INTEGRACION DE SIMAPARK
       IF lSimPak

	  IF PAR->(lRegLock(lShared,.F.))

	     REPL PAR->cPatDatPak WITH cPatDat+'\'+cDirCol+'\'+'datos'
	     PAR->(DBCOMMIT())

	  ELSE
	     cError('NO SE GRABA EL REGISTRO INICIAL DE CONFIGURACION')
	  ENDIF

	  IF lShared
	     PAR->(DBUNLOCK())
	  ENDIF

       ENDIF
*>>>>CAMBIOS DEL PATH DE INTEGRACION DE SIMAPARK

*>>>>BROWSE DE LOS ARCHIVOS
       IF lMtrAno
	  cError('SIMAMATR PATHS ACTUALIZADOS',cDirCol)
       ENDIF

       IF lConAno
	  cError('SIMACONT PATHS ACTUALIZADOS',cDirCol)
       ENDIF

       IF lProAno
	  cError('SIMAPROF PATHS ACTUALIZADOS',cDirCol)
       ENDIF

       IF lCarAno
	  cError('SIMACART PATHS ACTUALIZADOS',cDirCol)
       ENDIF

       IF lDatAno
	  cError('SIMADATA PATHS ACTUALIZADOS',cDirCol)
       ENDIF

       IF lSimTol
	  cError('SIMATOOL PATHS ACTUALIZADOS',cDirCol)
       ENDIF

       IF lSimPak
	  cError('SIMAPARK PATHS ACTUALIZADOS',cDirCol)
       ENDIF

       IF lAsiAno
	  cError('SIMAASIS PATHS ACTUALIZADOS',cDirCol)
       ENDIF

       IF lCafAno
	  cError('SIMACAFE PATHS ACTUALIZADOS',cDirCol)
       ENDIF

       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN BROWSE DE LOS ARCHIVOS