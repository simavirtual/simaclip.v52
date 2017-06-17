/*                      SIMASOFT - SISTEMA ADMINISTRADOR
		      FUNCIONES DEL ARCHIVO DE LICENCIAS

***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO..: CREACION DE LA ESTRUCTURA                                    *
**************************************************************************

AUTOR: Nelson Fern쟮dez G줺ez       FECHA DE CREACION: SEP 10/2002 MAR A
       Colombia, Bucaramanga        INICIO: 02:00 PM   SEP 10/2002 MAR

OBJETIVOS:

1- Creaci줻 de la estructura

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfLic(lShared,nModCry,PathArc,fArchvo,fNtxArc,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci줻
       PathArc				    // Path del Archivo
       fArchvo				    // Nombre del Archivo
       fNtxArc				    // Archivo de Indices
       aStrDbf                              // Estructura del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual

       LOCAL     i,j := 0                   // Contadores
       LOCAL aDbfStr := {}                  // Estructura del Archivo
       LOCAL aRegIni := {}                  // Registros Iniciales
       LOCAL cCampo  := ''                  // Nombre del Campo

       LOCAL aLicGen := {}                  // Licencia General
       LOCAL aDetLic := {}                  // Detalles de la Licencia
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE LA ESTRUCTURA
       AADD(aDbfStr,{"cCodigoLic","Character",016,0})  // cCodigoEmp+cCodigoSui
       AADD(aDbfStr,{"lSharedLic","Logical"  ,001,0})  // .T. Archivos Compartidos
       AADD(aDbfStr,{"nModCryLic","Numeric"  ,001,0})  // 0=>No Protecci줻 1=>Sin Proteci줻 Inicial 2=>Con Proteci줻 Inicial
       AADD(aDbfStr,{"nSysOpeLic","Numeric"  ,001,0})  // Sistema Operativo 0=>Windows 1=>Novell 2=>Linux
       AADD(aDbfStr,{"cPwdSisLic","Character",010,0})  // PassWord Creaci줻 usuarios
       AADD(aDbfStr,{"nPruebaLic","Numeric"  ,001,0})  // 0=>Licencia Activa 1=>Licencia de Prueba 3=>Licencia de Prueba Abierta 4=>Demo
       AADD(aDbfStr,{"cAnoHabLic","Character",004,0})  // A쨚 Habilitado
       AADD(aDbfStr,{"cMesHabLic","Character",012,0})  // Mes Habilitado. Mes Inicial Mes Final
       AADD(aDbfStr,{"cPwdHarLic","Character",040,0})  // Serial del HardWare
       AADD(aDbfStr,{"cPwdInsLic","Character",040,0})  // Serial de Instalaci줻
       AADD(aDbfStr,{"cDerSysLic","Character",110,0})  // Derechos del Sistema
       AADD(aDbfStr,{"lPiePagLic","Logical"  ,001,0})  // .T. Imprimir Pie de P쟥ina
       AADD(aDbfStr,{"cMaeAluLic","Character",009,0})  // Maestros habilitados
       AADD(aDbfStr,{"cJornadLic","Character",010,0})  // Jornadas habilitadas
       AADD(aDbfStr,{"nPerHabLic","Numeric"  ,001,0})  // Periodo Habilitado
       AADD(aDbfStr,{"cDirEmpLic","Character",008,0})  // Directorio de la Empresa
     *픁etalles de la Licencia
*>>>>DECLARACION DE LA ESTRUCTURA

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfStr
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := DIRNAME()
       DO CASE
       CASE DIRCHANGE(PathArc) == 0
	    DBCREATE(fArchvo,aDbfStr,"DBFNTX")

       CASE DIRCHANGE(PathArc) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathArc)

       CASE DIRCHANGE(PathArc) == -5
	    cError('NO TIENE DERECHOS EN: '+PathArc)
       ENDCASE
       DIRCHANGE(PathAct)
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathArc+'\'+fArchvo,'ARC',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE CONFIGURACION DEL SISTEMA')
	  CloseDbf('ARC',PathArc+'\'+fArchvo,nModCry)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>LICENCIAS COLEGIO DEMO
       aRegIni := {}

       aLicGen := {}
       AADD(aLicGen,{'ARC->lSharedLic',.T.})
       AADD(aLicGen,{'ARC->cMaeAluLic','JARPRIBTO'})
       AADD(aLicGen,{'ARC->cJornadLic','D'})
       AADD(aLicGen,{'ARC->nSysOpeLic',0})
       AADD(aLicGen,{'ARC->nModCryLic',0})
       AADD(aLicGen,{'ARC->cPwdSisLic','ELLAS'})
       AADD(aLicGen,{'ARC->nPruebaLic',0})
       AADD(aLicGen,{'ARC->cAnoHabLic',''})
       AADD(aLicGen,{'ARC->cMesHabLic',''})
       AADD(aLicGen,{'ARC->cPwdHarLic',''})
       AADD(aLicGen,{'ARC->cDerSysLic',REPL('1',110)})
       AADD(aLicGen,{'ARC->lPiePagLic',.T.})
       AADD(aLicGen,{'ARC->nPerHabLic',0})
       AADD(aLicGen,{'ARC->cDirEmpLic','SIMABGA'})
     *픁etalles Generales de la Licencia

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0019990101'})
       AADD(aRegIni,aDetLic)
     *픋icencia Matr죅ula Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0019990102'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0019990103'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Profesores

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0019990104'})
       AADD(aRegIni,aDetLic)
     *픋icencia Cartera Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0019990105'})
       AADD(aRegIni,aDetLic)
     *픋icencia Votaciones

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0019990106'})
       AADD(aRegIni,aDetLic)
     *픋icencia Cafeteria

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0019990107'})
       AADD(aRegIni,aDetLic)
     *픋icencia Central de Riesgos

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0019990108'})
       AADD(aRegIni,aDetLic)
     *픋icencia Control de Asistencia

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0019990109'})
       AADD(aRegIni,aDetLic)
     *픋icencia Cuentas por Pagar

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0019990110'})
       AADD(aRegIni,aDetLic)
     *픋icencia SimaWww

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0019990111'})
       AADD(aRegIni,aDetLic)
     *픋icencia Control del Parquedero

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0019990112'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Profesores. USB
*>>>>FIN LICENCIAS COLEGIO DEMO

*>>>>LICENCIAS COLEGIO LA SALLE. BUCARAMANGA
       aLicGen := {}
       AADD(aLicGen,{'ARC->lSharedLic',.T.})
       AADD(aLicGen,{'ARC->cMaeAluLic','JARPRIBTO'})
       AADD(aLicGen,{'ARC->cJornadLic','D'})
       AADD(aLicGen,{'ARC->nSysOpeLic',1})
       AADD(aLicGen,{'ARC->nModCryLic',0})
       AADD(aLicGen,{'ARC->cPwdSisLic','ELLAS'})
       AADD(aLicGen,{'ARC->nPruebaLic',0})
       AADD(aLicGen,{'ARC->cAnoHabLic',''})
       AADD(aLicGen,{'ARC->cMesHabLic',''})
       AADD(aLicGen,{'ARC->cPwdHarLic',''})
       AADD(aLicGen,{'ARC->cDerSysLic',REPL('1',110)})
       AADD(aLicGen,{'ARC->lPiePagLic',.T.})
       AADD(aLicGen,{'ARC->nPerHabLic',0})
       AADD(aLicGen,{'ARC->cDirEmpLic','SALLEBGA'})
     *픁etalles Generales de la Licencia

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0010010101'})
       AADD(aRegIni,aDetLic)
     *픋icencia Matr죅ula Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0010010102'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0010010103'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Profesores

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0010010104'})
       AADD(aRegIni,aDetLic)
     *픋icencia Cartera Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0010010105'})
       AADD(aRegIni,aDetLic)
     *픋icencia Votaciones

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0010010106'})
       AADD(aRegIni,aDetLic)
     *픋icencia Cafeteria

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0010010107'})
       AADD(aRegIni,aDetLic)
     *픋icencia Central de Riesgos

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0010010108'})
       AADD(aRegIni,aDetLic)
     *픋icencia Control de Asistencia

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0010010109'})
       AADD(aRegIni,aDetLic)
     *픋icencia Cuentas por Pagar

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0010010110'})
       AADD(aRegIni,aDetLic)
     *픋icencia SimaWww

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0010010111'})
       AADD(aRegIni,aDetLic)
     *픋icencia Control del Parquedero

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0010010112'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Profesores. USB

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0010010113'})
       AADD(aRegIni,aDetLic)
     *픋icencia Utilidades. Etiquetas
*>>>>FIN LICENCIAS COLEGIO LA SALLE. BUCARAMANGA

*>>>>LICENCIAS INSTITUTO SAN JOSE DE LA SALLE
       aLicGen := {}
       AADD(aLicGen,{'ARC->lSharedLic',.T.})
       AADD(aLicGen,{'ARC->cMaeAluLic','PRIBTO'})
       AADD(aLicGen,{'ARC->cJornadLic','D'})
       AADD(aLicGen,{'ARC->nSysOpeLic',0})
       AADD(aLicGen,{'ARC->nModCryLic',0})
       AADD(aLicGen,{'ARC->cPwdSisLic','ELLAS'})
       AADD(aLicGen,{'ARC->nPruebaLic',0})
       AADD(aLicGen,{'ARC->cAnoHabLic',''})
       AADD(aLicGen,{'ARC->cMesHabLic',''})
       AADD(aLicGen,{'ARC->cPwdHarLic',''})
       AADD(aLicGen,{'ARC->cDerSysLic',REPL('1',110)})
       AADD(aLicGen,{'ARC->lPiePagLic',.T.})
       AADD(aLicGen,{'ARC->nPerHabLic',0})
       AADD(aLicGen,{'ARC->cDirEmpLic','SANJOSE'})
     *픁etalles Generales de la Licencia

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0010020101'})
       AADD(aRegIni,aDetLic)
     *픋icencia Matr죅ula Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0010020102'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0010020103'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Profesores

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0010020104'})
       AADD(aRegIni,aDetLic)
     *픋icencia Cartera Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0010020105'})
       AADD(aRegIni,aDetLic)
     *픋icencia Votaciones

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0010020108'})
       AADD(aRegIni,aDetLic)
     *픋icencia Control de Asistencia

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0010020110'})
       AADD(aRegIni,aDetLic)
     *픋icencia SimaWww
*>>>>FIN LICENCIAS INSTITUTO SAN JOSE DE LA SALLE

*>>>>LICENCIAS DEL SAGRADO CORAZON DE JESUS DE BUCARAMANGA
       aLicGen := {}
       AADD(aLicGen,{'ARC->lSharedLic',.T.})
       AADD(aLicGen,{'ARC->cMaeAluLic','JARPRIBTO'})
       AADD(aLicGen,{'ARC->cJornadLic','D'})
       AADD(aLicGen,{'ARC->nSysOpeLic',2})
       AADD(aLicGen,{'ARC->nModCryLic',0})
       AADD(aLicGen,{'ARC->cPwdSisLic','ELLAS'})
       AADD(aLicGen,{'ARC->nPruebaLic',0})
       AADD(aLicGen,{'ARC->cAnoHabLic',''})
       AADD(aLicGen,{'ARC->cMesHabLic',''})
       AADD(aLicGen,{'ARC->cPwdHarLic',''})
       AADD(aLicGen,{'ARC->cDerSysLic',REPL('1',110)})
       AADD(aLicGen,{'ARC->lPiePagLic',.T.})
       AADD(aLicGen,{'ARC->nPerHabLic',0})
       AADD(aLicGen,{'ARC->cDirEmpLic','BELEBGA'})
     *픁etalles Generales de la Licencia

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0010030101'})
       AADD(aRegIni,aDetLic)
     *픋icencia Matr죅ula Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0010030102'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0010030103'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Profesores

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0010030104'})
       AADD(aRegIni,aDetLic)
     *픋icencia Cartera Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0010030105'})
       AADD(aRegIni,aDetLic)
     *픋icencia Votaciones

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0010030108'})
       AADD(aRegIni,aDetLic)
     *픋icencia Control de Asistencia

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0010030110'})

       aDetLic[8,2] := '2004'  // A쨚 Habilitado
       AADD(aRegIni,aDetLic)
     *픋icencia SimaWww
*>>>>FIN LICENCIAS DEL SAGRADO CORAZON DE JESUS DE BUCARAMANGA

*>>>>LICENCIAS COLEGIO VIRREY SOLIS. BUCARAMANGA
       aLicGen := {}
       AADD(aLicGen,{'ARC->lSharedLic',.T.})
       AADD(aLicGen,{'ARC->cMaeAluLic','JARPRIBTO'})
       AADD(aLicGen,{'ARC->cJornadLic','D'})
       AADD(aLicGen,{'ARC->nSysOpeLic',2})
       AADD(aLicGen,{'ARC->nModCryLic',0})
       AADD(aLicGen,{'ARC->cPwdSisLic','ELLAS'})
       AADD(aLicGen,{'ARC->nPruebaLic',0})
       AADD(aLicGen,{'ARC->cAnoHabLic',''})
       AADD(aLicGen,{'ARC->cMesHabLic',''})
       AADD(aLicGen,{'ARC->cPwdHarLic',''})
       AADD(aLicGen,{'ARC->cDerSysLic',REPL('1',110)})
       AADD(aLicGen,{'ARC->lPiePagLic',.T.})
       AADD(aLicGen,{'ARC->nPerHabLic',0})
       AADD(aLicGen,{'ARC->cDirEmpLic','VIRREY'})
     *픁etalles Generales de la Licencia

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0010040101'})
       AADD(aRegIni,aDetLic)
     *픋icencia Matr죅ula Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0010040102'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0010040103'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Profesores

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0010040104'})
       AADD(aRegIni,aDetLic)
     *픋icencia Cartera Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0010040105'})
       AADD(aRegIni,aDetLic)
     *픋icencia Votaciones
*>>>>FIN LICENCIAS COLEGIO VIRREY SOLIS. BUCARAMANGA

*>>>>LICENCIAS PARQUEADERO LA DIEZ. BUCARAMANGA
       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0010050111'})
       AADD(aRegIni,aDetLic)
     *픋icencia Control del Parqueadero
*>>>>LICENCIAS PARQUEADERO LA DIEZ. BUCARAMANGA

*>>>>LICENCIAS PARQUEADERO LA XXXX. BUCARAMANGA
       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0010060111'})
       AADD(aRegIni,aDetLic)
     *픋icencia Control del Parqueadero
*>>>>LICENCIAS PARQUEADERO LA XXXX. BUCARAMANGA

*>>>>LICENCIAS DEL SAGRADO CORAZON DE JESUS. BARRANCABERMEJA
       aLicGen := {}
       AADD(aLicGen,{'ARC->lSharedLic',.T.})
       AADD(aLicGen,{'ARC->cMaeAluLic','JARPRIBTO'})
       AADD(aLicGen,{'ARC->cJornadLic','D'})
       AADD(aLicGen,{'ARC->nSysOpeLic',0})
       AADD(aLicGen,{'ARC->nModCryLic',0})
       AADD(aLicGen,{'ARC->cPwdSisLic','ELLAS'})
       AADD(aLicGen,{'ARC->nPruebaLic',0})
       AADD(aLicGen,{'ARC->cAnoHabLic',''})
       AADD(aLicGen,{'ARC->cMesHabLic',''})
       AADD(aLicGen,{'ARC->cPwdHarLic',''})
       AADD(aLicGen,{'ARC->cDerSysLic',REPL('1',110)})
       AADD(aLicGen,{'ARC->lPiePagLic',.T.})
       AADD(aLicGen,{'ARC->nPerHabLic',0})
       AADD(aLicGen,{'ARC->cDirEmpLic','BELEBAN'})
     *픁etalles Generales de la Licencia

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0020010101'})
       AADD(aRegIni,aDetLic)
     *픋icencia Matr죅ula Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0020010102'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0020010103'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Profesores

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLSAN0020010104'})
       AADD(aRegIni,aDetLic)
     *픋icencia Cartera Acad굆ica
*>>>>FIN LICENCIAS DEL SAGRADO CORAZON DE JESUS. BARRANCABERMEJA

*>>>>LICENCIAS COLEGIO LA SALLE. CUCUTA
       aLicGen := {}
       AADD(aLicGen,{'ARC->lSharedLic',.T.})
       AADD(aLicGen,{'ARC->cMaeAluLic','JARPRIBTO'})
       AADD(aLicGen,{'ARC->cJornadLic','D'})
       AADD(aLicGen,{'ARC->nSysOpeLic',0})
       AADD(aLicGen,{'ARC->nModCryLic',0})
       AADD(aLicGen,{'ARC->cPwdSisLic','ELLAS'})
       AADD(aLicGen,{'ARC->nPruebaLic',0})
       AADD(aLicGen,{'ARC->cAnoHabLic',''})
       AADD(aLicGen,{'ARC->cMesHabLic',''})
       AADD(aLicGen,{'ARC->cPwdHarLic',''})
       AADD(aLicGen,{'ARC->cDerSysLic',REPL('1',110)})
       AADD(aLicGen,{'ARC->lPiePagLic',.T.})
       AADD(aLicGen,{'ARC->nPerHabLic',0})
       AADD(aLicGen,{'ARC->cDirEmpLic','SALLECUT'})
     *픁etalles Generales de la Licencia

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLNSA0010010101'})
       AADD(aRegIni,aDetLic)
     *픋icencia Matr죅ula Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLNSA0010010104'})
       AADD(aRegIni,aDetLic)
     *픋icencia Cartera Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLNSA0010010107'})
       AADD(aRegIni,aDetLic)
     *픋icencia Central de Riesgos

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLNSA0010010109'})
       AADD(aRegIni,aDetLic)
     *픋icencia Cuentas por Pagar
*>>>>FIN LICENCIAS COLEGIO LA SALLE. CUCUTA

*>>>>LICENCIAS COLEGIO DE LA SALLE BOGOTA
       aLicGen := {}
       AADD(aLicGen,{'ARC->lSharedLic',.T.})
       AADD(aLicGen,{'ARC->cMaeAluLic','JARPRIBTO'})
       AADD(aLicGen,{'ARC->cJornadLic','D'})
       AADD(aLicGen,{'ARC->nSysOpeLic',0})
       AADD(aLicGen,{'ARC->nModCryLic',0})
       AADD(aLicGen,{'ARC->cPwdSisLic','ELLAS'})
       AADD(aLicGen,{'ARC->nPruebaLic',0})
       AADD(aLicGen,{'ARC->cAnoHabLic',''})
       AADD(aLicGen,{'ARC->cMesHabLic',''})
       AADD(aLicGen,{'ARC->cPwdHarLic',''})
       AADD(aLicGen,{'ARC->cDerSysLic',REPL('1',110)})
       AADD(aLicGen,{'ARC->lPiePagLic',.T.})
       AADD(aLicGen,{'ARC->nPerHabLic',0})
       AADD(aLicGen,{'ARC->cDirEmpLic','COLSALLE'})
     *픁etalles Generales de la Licencia

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010010101'})
       AADD(aRegIni,aDetLic)
     *픋icencia Matr죅ula Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010010102'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010010103'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Profesores

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010010104'})
       AADD(aRegIni,aDetLic)
     *픋icencia Cartera Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010010105'})
       AADD(aRegIni,aDetLic)
     *픋icencia Votaciones

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010010106'})
       AADD(aRegIni,aDetLic)
     *픋icencia Cafeteria

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010010107'})
       AADD(aRegIni,aDetLic)
     *픋icencia Central de Riesgos

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010010108'})
       AADD(aRegIni,aDetLic)
     *픋icencia Control de Asistencia
*>>>>FIN LICENCIAS COLEGIO DE LA SALLE BOGOTA

*>>>>LICENCIAS INSTITUTO SAN BERNARDO DE LA SALLE
       aLicGen := {}
       AADD(aLicGen,{'ARC->lSharedLic',.T.})           // 1
       AADD(aLicGen,{'ARC->cMaeAluLic','JARPRIBTO'})   // 2
       AADD(aLicGen,{'ARC->cJornadLic','DN'})          // 3
       AADD(aLicGen,{'ARC->nSysOpeLic',0})             // 4
       AADD(aLicGen,{'ARC->nModCryLic',0})             // 5
       AADD(aLicGen,{'ARC->cPwdSisLic','ELLAS'})       // 6
       AADD(aLicGen,{'ARC->nPruebaLic',0})             // 7
       AADD(aLicGen,{'ARC->cAnoHabLic',''})            // 8
       AADD(aLicGen,{'ARC->cMesHabLic',''})            // 9
       AADD(aLicGen,{'ARC->cPwdHarLic',''})            // 10
       AADD(aLicGen,{'ARC->cDerSysLic',REPL('1',110)}) // 11
       AADD(aLicGen,{'ARC->lPiePagLic',.T.})           // 12
       AADD(aLicGen,{'ARC->nPerHabLic',0})             // 13
       AADD(aLicGen,{'ARC->cDirEmpLic','ISB'})         // 14
     *픁etalles Generales de la Licencia

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010020101'})
       AADD(aRegIni,aDetLic)
     *픋icencia Matr죅ula Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010020102'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010020103'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Profesores

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010020104'})
       AADD(aRegIni,aDetLic)
     *픋icencia Cartera Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010020105'})
       AADD(aRegIni,aDetLic)
     *픋icencia Votaciones

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010020106'})
       AADD(aRegIni,aDetLic)
     *픋icencia Cafeteria

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010020107'})
       AADD(aRegIni,aDetLic)
     *픋icencia Central de Riesgos.

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010020108'})
       AADD(aRegIni,aDetLic)
*      aDetLic[8,2] := '2005'  // A쨚 Habilitado
     *픋icencia Control de Asistencia. Demo
*>>>>FIN LICENCIAS INSTITUTO SAN BERNARDO DE LA SALLE

*>>>>LICENCIAS LICEO HERMANO MIGUEL
       aLicGen := {}
       AADD(aLicGen,{'ARC->lSharedLic',.T.})
       AADD(aLicGen,{'ARC->cMaeAluLic','PRIBTO'})
       AADD(aLicGen,{'ARC->cJornadLic','D'})
       AADD(aLicGen,{'ARC->nSysOpeLic',0})
       AADD(aLicGen,{'ARC->nModCryLic',0})
       AADD(aLicGen,{'ARC->cPwdSisLic','ELLAS'})
       AADD(aLicGen,{'ARC->nPruebaLic',0})
       AADD(aLicGen,{'ARC->cAnoHabLic',''})
       AADD(aLicGen,{'ARC->cMesHabLic',''})
       AADD(aLicGen,{'ARC->cPwdHarLic',''})
       AADD(aLicGen,{'ARC->cDerSysLic',REPL('1',110)})
       AADD(aLicGen,{'ARC->lPiePagLic',.T.})
       AADD(aLicGen,{'ARC->nPerHabLic',0})
       AADD(aLicGen,{'ARC->cDirEmpLic','LHM'})
     *픁etalles Generales de la Licencia

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010030101'})
       AADD(aRegIni,aDetLic)
     *픋icencia Matr죅ula Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010030102'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010030103'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Profesores

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010030104'})
       AADD(aRegIni,aDetLic)
     *픋icencia Cartera Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010030106'})
       AADD(aRegIni,aDetLic)
     *픋icencia Cafeteria

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010030107'})
       AADD(aRegIni,aDetLic)
     *픋icencia Central de Riesgos
*>>>>FIN LICENCIAS LICEO HERMANO MIGUEL

*>>>>LICENCIAS NUESTRA SE쩙RA DE LA PRESENTACION - CENTRO
       aLicGen := {}
       AADD(aLicGen,{'ARC->lSharedLic',.T.})
       AADD(aLicGen,{'ARC->cMaeAluLic','JARPRIBTO'})
       AADD(aLicGen,{'ARC->cJornadLic','D'})
       AADD(aLicGen,{'ARC->nSysOpeLic',0})
       AADD(aLicGen,{'ARC->nModCryLic',0})
       AADD(aLicGen,{'ARC->cPwdSisLic','ELLAS'})
       AADD(aLicGen,{'ARC->nPruebaLic',0})
       AADD(aLicGen,{'ARC->cAnoHabLic',''})
       AADD(aLicGen,{'ARC->cMesHabLic',''})
       AADD(aLicGen,{'ARC->cPwdHarLic',''})
       AADD(aLicGen,{'ARC->cDerSysLic',REPL('1',110)})
       AADD(aLicGen,{'ARC->lPiePagLic',.F.})
       AADD(aLicGen,{'ARC->nPerHabLic',0})
       AADD(aLicGen,{'ARC->cDirEmpLic','PRES1BGO'})
     *픁etalles Generales de la Licencia

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010040101'})
       AADD(aRegIni,aDetLic)
     *픋icencia Matr죅ula Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010040102'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010040103'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Profesores

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010040104'})
       AADD(aRegIni,aDetLic)
     *픋icencia Cartera Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010040106'})
       AADD(aRegIni,aDetLic)
     *픋icencia Cafeteria

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010040107'})
       AADD(aRegIni,aDetLic)
     *픋icencia SimaData

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010040108'})
       AADD(aRegIni,aDetLic)
     *픋icencia Control de Asistencia
*>>>>FIN LICENCIAS NUESTRA SE쩙RA DE LA PRESENTACION - CENTRO

*>>>>LICENCIA CONGREGACION HNAS DOMINICAS DE LA PRESENTACION
       aLicGen := {}
       AADD(aLicGen,{'ARC->lSharedLic',.T.})
       AADD(aLicGen,{'ARC->cMaeAluLic','JARPRIBTO'})
       AADD(aLicGen,{'ARC->cJornadLic','D'})
       AADD(aLicGen,{'ARC->nSysOpeLic',0})
       AADD(aLicGen,{'ARC->nModCryLic',0})
       AADD(aLicGen,{'ARC->cPwdSisLic','ELLAS'})
       AADD(aLicGen,{'ARC->nPruebaLic',0})
       AADD(aLicGen,{'ARC->cAnoHabLic',''})
       AADD(aLicGen,{'ARC->cMesHabLic',''})
       AADD(aLicGen,{'ARC->cPwdHarLic',''})
       AADD(aLicGen,{'ARC->cDerSysLic',REPL('1',110)})
       AADD(aLicGen,{'ARC->lPiePagLic',.F.})
       AADD(aLicGen,{'ARC->nPerHabLic',0})
       AADD(aLicGen,{'ARC->cDirEmpLic','HNASDOMI'})
     *픁etalles Generales de la Licencia

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010110111'})
       AADD(aRegIni,aDetLic)
     *픋icencia Control del Parqueadero
*>>>>FIN LICENCIA CONGREGACION HNAS DOMINICAS DE LA PRESENTACION

*>>>>LICENCIAS COLEGIO LA PRESENTACION - FERIAS
       aLicGen := {}
       AADD(aLicGen,{'ARC->lSharedLic',.T.})
       AADD(aLicGen,{'ARC->cMaeAluLic','BTO'})
       AADD(aLicGen,{'ARC->cJornadLic','D'})
       AADD(aLicGen,{'ARC->nSysOpeLic',0})
       AADD(aLicGen,{'ARC->nModCryLic',0})
       AADD(aLicGen,{'ARC->cPwdSisLic','ELLAS'})
       AADD(aLicGen,{'ARC->nPruebaLic',0})
       AADD(aLicGen,{'ARC->cAnoHabLic',''})
       AADD(aLicGen,{'ARC->cMesHabLic',''})
       AADD(aLicGen,{'ARC->cPwdHarLic',''})
       AADD(aLicGen,{'ARC->cDerSysLic',REPL('1',110)})
       AADD(aLicGen,{'ARC->lPiePagLic',.F.})
       AADD(aLicGen,{'ARC->nPerHabLic',0})
       AADD(aLicGen,{'ARC->cDirEmpLic','FERIAS'})
     *픁etalles Generales de la Licencia

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010140101'})
       AADD(aRegIni,aDetLic)
     *픋icencia Matr죅ula Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010140104'})
       AADD(aRegIni,aDetLic)
     *픋icencia Cartera Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010140107'})
       AADD(aRegIni,aDetLic)
     *픋icencia SimaData
*>>>>FIN LICENCIAS COLEGIO LA PRESENTACION - FERIAS

*>>>>LICENCIAS COLEGIO PARROQUIAL SAN CARLOS
       aLicGen := {}
       AADD(aLicGen,{'ARC->lSharedLic',.T.})
       AADD(aLicGen,{'ARC->cMaeAluLic','JARPRIBTO'})
       AADD(aLicGen,{'ARC->cJornadLic','D'})
       AADD(aLicGen,{'ARC->nSysOpeLic',0})
       AADD(aLicGen,{'ARC->nModCryLic',0})
       AADD(aLicGen,{'ARC->cPwdSisLic','ELLAS'})
       AADD(aLicGen,{'ARC->nPruebaLic',0})
       AADD(aLicGen,{'ARC->cAnoHabLic',''})
       AADD(aLicGen,{'ARC->cMesHabLic',''})
       AADD(aLicGen,{'ARC->cPwdHarLic',''})
       AADD(aLicGen,{'ARC->cDerSysLic',REPL('1',110)})
       AADD(aLicGen,{'ARC->lPiePagLic',.T.})
       AADD(aLicGen,{'ARC->nPerHabLic',0})
       AADD(aLicGen,{'ARC->cDirEmpLic','SANCARLO'})
     *픁etalles Generales de la Licencia

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010050101'})
       AADD(aRegIni,aDetLic)
     *픋icencia Matr죅ula Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010050102'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010050103'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Profesores

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010050104'})
       AADD(aRegIni,aDetLic)
     *픋icencia Cartera Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010050108'})
       AADD(aRegIni,aDetLic)
     *픋icencia Control de Asistencia
*>>>>FIN LICENCIAS COLEGIO PARROQUIAL SAN CARLOS

*>>>>LICENCIAS ASOPAF - INSTITUTO SAN BERNARDO DE LA SALLE
       aLicGen := {}
       AADD(aLicGen,{'ARC->lSharedLic',.T.})
       AADD(aLicGen,{'ARC->cMaeAluLic','JARPRIBTO'})
       AADD(aLicGen,{'ARC->cJornadLic','D'})
       AADD(aLicGen,{'ARC->nSysOpeLic',0})
       AADD(aLicGen,{'ARC->nModCryLic',0})
       AADD(aLicGen,{'ARC->cPwdSisLic','ELLAS'})
       AADD(aLicGen,{'ARC->nPruebaLic',0})
       AADD(aLicGen,{'ARC->cAnoHabLic',''})
       AADD(aLicGen,{'ARC->cMesHabLic',''})
       AADD(aLicGen,{'ARC->cPwdHarLic',''})
       AADD(aLicGen,{'ARC->cDerSysLic',REPL('1',110)})
       AADD(aLicGen,{'ARC->lPiePagLic',.T.})
       AADD(aLicGen,{'ARC->nPerHabLic',0})
       AADD(aLicGen,{'ARC->cDirEmpLic','ASPAISB'})
     *픁etalles Generales de la Licencia

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010060101'})
       AADD(aRegIni,aDetLic)
     *픋icencia Matr죅ula Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010060104'})
       AADD(aRegIni,aDetLic)
     *픋icencia Cartera Acad굆ica
*>>>>FIN LICENCIAS ASOPAF - INSTITUTO SAN BERNARDO DE LA SALLE

*>>>>LICENCIAS INSTITUCION EDUCATIVA DISTRITAL MA쩇NA
       aLicGen := {}
       AADD(aLicGen,{'ARC->lSharedLic',.T.})
       AADD(aLicGen,{'ARC->cMaeAluLic','PRIBTO'})
       AADD(aLicGen,{'ARC->cJornadLic','M'})
       AADD(aLicGen,{'ARC->nSysOpeLic',0})
       AADD(aLicGen,{'ARC->nModCryLic',0})
       AADD(aLicGen,{'ARC->cPwdSisLic','ELLAS'})
       AADD(aLicGen,{'ARC->nPruebaLic',0})
       AADD(aLicGen,{'ARC->cAnoHabLic',''})
       AADD(aLicGen,{'ARC->cMesHabLic',''})
       AADD(aLicGen,{'ARC->cPwdHarLic',''})
       AADD(aLicGen,{'ARC->cDerSysLic',REPL('1',110)})
       AADD(aLicGen,{'ARC->lPiePagLic',.T.})
       AADD(aLicGen,{'ARC->nPerHabLic',0})
       AADD(aLicGen,{'ARC->cDirEmpLic','IEDOBREM'})
     *픁etalles Generales de la Licencia

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010070101'})
       AADD(aRegIni,aDetLic)
     *픋icencia Matr죅ula Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010070102'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010070103'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Profesores
*>>>>FIN LICENCIAS INSTITUCION EDUCATIVA DISTRITAL MA쩇NA

*>>>>LICENCIAS INSTITUCION EDUCATIVA DISTRITAL TARDE
       aLicGen := {}
       AADD(aLicGen,{'ARC->lSharedLic',.T.})
       AADD(aLicGen,{'ARC->cMaeAluLic','PRIBTO'})
       AADD(aLicGen,{'ARC->cJornadLic','T'})
       AADD(aLicGen,{'ARC->nSysOpeLic',0})
       AADD(aLicGen,{'ARC->nModCryLic',0})
       AADD(aLicGen,{'ARC->cPwdSisLic','ELLAS'})
       AADD(aLicGen,{'ARC->nPruebaLic',0})
       AADD(aLicGen,{'ARC->cAnoHabLic',''})
       AADD(aLicGen,{'ARC->cMesHabLic',''})
       AADD(aLicGen,{'ARC->cPwdHarLic',''})
       AADD(aLicGen,{'ARC->cDerSysLic',REPL('1',110)})
       AADD(aLicGen,{'ARC->lPiePagLic',.T.})
       AADD(aLicGen,{'ARC->nPerHabLic',0})
       AADD(aLicGen,{'ARC->cDirEmpLic','IEDOBRET'})
     *픁etalles Generales de la Licencia

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010080101'})
       AADD(aRegIni,aDetLic)
     *픋icencia Matr죅ula Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010080102'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010080103'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Profesores
*>>>>FIN LICENCIAS INSTITUCION EDUCATIVA DISTRITAL TARDE

*>>>>LICENCIAS I.E.D. CLEMENCIA OLGUIN DE URDANETA
       aLicGen := {}
       AADD(aLicGen,{'ARC->lSharedLic',.T.})
       AADD(aLicGen,{'ARC->cMaeAluLic','JARPRIBTO'})
       AADD(aLicGen,{'ARC->cJornadLic','D'})
       AADD(aLicGen,{'ARC->nSysOpeLic',0})
       AADD(aLicGen,{'ARC->nModCryLic',0})
       AADD(aLicGen,{'ARC->cPwdSisLic','ELLAS'})
       AADD(aLicGen,{'ARC->nPruebaLic',0})
       AADD(aLicGen,{'ARC->cAnoHabLic',''})
       AADD(aLicGen,{'ARC->cMesHabLic',''})
       AADD(aLicGen,{'ARC->cPwdHarLic',''})
       AADD(aLicGen,{'ARC->cDerSysLic',REPL('1',110)})
       AADD(aLicGen,{'ARC->lPiePagLic',.T.})
       AADD(aLicGen,{'ARC->nPerHabLic',0})
       AADD(aLicGen,{'ARC->cDirEmpLic','IEDOLGUI'})
     *픁etalles Generales de la Licencia

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010090101'})
       AADD(aRegIni,aDetLic)
     *픋icencia Matr죅ula Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010090102'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010090103'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Profesores
*>>>>FIN LICENCIAS I.E.D. CLEMENCIA OLGUIN DE URDANETA

*>>>>LICENCIAS ACADEMIA LA SALLE SAN BENILDO
       aLicGen := {}
       AADD(aLicGen,{'ARC->lSharedLic',.T.})
       AADD(aLicGen,{'ARC->cMaeAluLic','PRIBTO'})
       AADD(aLicGen,{'ARC->cJornadLic','D'})
       AADD(aLicGen,{'ARC->nSysOpeLic',0})
       AADD(aLicGen,{'ARC->nModCryLic',0})
       AADD(aLicGen,{'ARC->cPwdSisLic','ELLAS'})
       AADD(aLicGen,{'ARC->nPruebaLic',0})
       AADD(aLicGen,{'ARC->cAnoHabLic',''})
       AADD(aLicGen,{'ARC->cMesHabLic',''})
       AADD(aLicGen,{'ARC->cPwdHarLic',''})
       AADD(aLicGen,{'ARC->cDerSysLic',REPL('1',110)})
       AADD(aLicGen,{'ARC->lPiePagLic',.T.})
       AADD(aLicGen,{'ARC->nPerHabLic',0})
       AADD(aLicGen,{'ARC->cDirEmpLic','BENILDO'})
     *픁etalles Generales de la Licencia

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010100101'})
       AADD(aRegIni,aDetLic)
     *픋icencia Matr죅ula Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010100102'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010100103'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Profesores
*>>>>FIN LICENCIAS ACADEMIA LA SALLE SAN BENILDO

*>>>>LICENCIAS COLEGIO NUESTRA SE쩙RA DE LA SABIDURIA
       aLicGen := {}
       AADD(aLicGen,{'ARC->lSharedLic',.T.})
       AADD(aLicGen,{'ARC->cMaeAluLic','JARPRIBTO'})
       AADD(aLicGen,{'ARC->cJornadLic','D'})
       AADD(aLicGen,{'ARC->nSysOpeLic',0})
       AADD(aLicGen,{'ARC->nModCryLic',0})
       AADD(aLicGen,{'ARC->cPwdSisLic','ELLAS'})
       AADD(aLicGen,{'ARC->nPruebaLic',0})
       AADD(aLicGen,{'ARC->cAnoHabLic',''})
       AADD(aLicGen,{'ARC->cMesHabLic',''})
       AADD(aLicGen,{'ARC->cPwdHarLic',''})
       AADD(aLicGen,{'ARC->cDerSysLic',REPL('1',110)})
       AADD(aLicGen,{'ARC->lPiePagLic',.F.})
       AADD(aLicGen,{'ARC->nPerHabLic',0})
       AADD(aLicGen,{'ARC->cDirEmpLic','SABIDURI'})
     *픁etalles Generales de la Licencia

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010120101'})
       AADD(aRegIni,aDetLic)
     *픋icencia Matr죅ula Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010120102'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010120103'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Profesores

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010120104'})
       AADD(aRegIni,aDetLic)
     *픋icencia Cartera Acad굆ica
*>>>>FIN LICENCIAS COLEGIO NUESTRA SE쩙RA DE LA SABIDURIA

*>>>>LICENCIAS E.D. JUAN LUIS LONDO쩙
       aLicGen := {}
       AADD(aLicGen,{'ARC->lSharedLic',.T.})
       AADD(aLicGen,{'ARC->cMaeAluLic','PRIBTO'})
       AADD(aLicGen,{'ARC->cJornadLic','D'})
       AADD(aLicGen,{'ARC->nSysOpeLic',0})
       AADD(aLicGen,{'ARC->nModCryLic',0})
       AADD(aLicGen,{'ARC->cPwdSisLic','ELLAS'})
       AADD(aLicGen,{'ARC->nPruebaLic',0})
       AADD(aLicGen,{'ARC->cAnoHabLic',''})
       AADD(aLicGen,{'ARC->cMesHabLic',''})
       AADD(aLicGen,{'ARC->cPwdHarLic',''})
       AADD(aLicGen,{'ARC->cDerSysLic',REPL('1',110)})
       AADD(aLicGen,{'ARC->lPiePagLic',.F.})
       AADD(aLicGen,{'ARC->nPerHabLic',0})
       AADD(aLicGen,{'ARC->cDirEmpLic','JUANLUIS'})
     *픁etalles Generales de la Licencia

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010130101'})
       AADD(aRegIni,aDetLic)
     *픋icencia Matr죅ula Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010130102'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010130103'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Profesores

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0010130105'})
       AADD(aRegIni,aDetLic)
     *픋icencia Votaciones
*>>>>FIN LICENCIAS E.D. JUAN LUIS LONDO쩙

*>>>>LICENCIAS LICEO LA SALLE - ZIPAQUIRA
       aLicGen := {}
       AADD(aLicGen,{'ARC->lSharedLic',.T.})
       AADD(aLicGen,{'ARC->cMaeAluLic','PRI'})
       AADD(aLicGen,{'ARC->cJornadLic','D'})
       AADD(aLicGen,{'ARC->nSysOpeLic',0})
       AADD(aLicGen,{'ARC->nModCryLic',0})
       AADD(aLicGen,{'ARC->cPwdSisLic','ELLAS'})
       AADD(aLicGen,{'ARC->nPruebaLic',0})
       AADD(aLicGen,{'ARC->cAnoHabLic',''})
       AADD(aLicGen,{'ARC->cMesHabLic',''})
       AADD(aLicGen,{'ARC->cPwdHarLic',''})
       AADD(aLicGen,{'ARC->cDerSysLic',REPL('1',110)})
       AADD(aLicGen,{'ARC->lPiePagLic',.T.})
       AADD(aLicGen,{'ARC->nPerHabLic',0})
       AADD(aLicGen,{'ARC->cDirEmpLic','LICEZIPA'})
     *픁etalles Generales de la Licencia

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0050010101'})
       AADD(aRegIni,aDetLic)
     *픋icencia Matr죅ula Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0050010104'})
       AADD(aRegIni,aDetLic)
     *픋icencia Cartera Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0050010107'})
       AADD(aRegIni,aDetLic)
     *픋icencia SimaData

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0050010109'})
       AADD(aRegIni,aDetLic)
     *픋icencia Cuentas por Pagar
*>>>>FIN LICENCIAS LICEO LA SALLE - ZIPAQUIRA

*>>>>LICENCIAS COLEGIO DE LA PRESENTACION - ZIPAQUIRA
       aLicGen := {}
       AADD(aLicGen,{'ARC->lSharedLic',.T.})
       AADD(aLicGen,{'ARC->cMaeAluLic','JARPRIBTO'})
       AADD(aLicGen,{'ARC->cJornadLic','D'})
       AADD(aLicGen,{'ARC->nSysOpeLic',0})
       AADD(aLicGen,{'ARC->nModCryLic',0})
       AADD(aLicGen,{'ARC->cPwdSisLic','ELLAS'})
       AADD(aLicGen,{'ARC->nPruebaLic',0})
       AADD(aLicGen,{'ARC->cAnoHabLic',''})
       AADD(aLicGen,{'ARC->cMesHabLic',''})
       AADD(aLicGen,{'ARC->cPwdHarLic',''})
       AADD(aLicGen,{'ARC->cDerSysLic',REPL('1',110)})
       AADD(aLicGen,{'ARC->lPiePagLic',.F.})
       AADD(aLicGen,{'ARC->nPerHabLic',0})
       AADD(aLicGen,{'ARC->cDirEmpLic','PRES1ZIP'})
     *픁etalles Generales de la Licencia

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0050020101'})
       AADD(aRegIni,aDetLic)
     *픋icencia Matr죅ula Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0050020102'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0050020103'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Profesores

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0050020104'})
       AADD(aRegIni,aDetLic)
     *픋icencia Cartera Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0050020107'})
       AADD(aRegIni,aDetLic)
     *픋icencia SimaData
*>>>>FIN LICENCIAS COLEGIO DE LA PRESENTACION - ZIPAQUIRA

*>>>>LICENCIAS COLEGIO DE LA PRESENTACION - UBATE
       aLicGen := {}
       AADD(aLicGen,{'ARC->lSharedLic',.T.})
       AADD(aLicGen,{'ARC->cMaeAluLic','JARPRIBTO'})
       AADD(aLicGen,{'ARC->cJornadLic','D'})
       AADD(aLicGen,{'ARC->nSysOpeLic',0})
       AADD(aLicGen,{'ARC->nModCryLic',0})
       AADD(aLicGen,{'ARC->cPwdSisLic','ELLAS'})
       AADD(aLicGen,{'ARC->nPruebaLic',0})
       AADD(aLicGen,{'ARC->cAnoHabLic',''})
       AADD(aLicGen,{'ARC->cMesHabLic',''})
       AADD(aLicGen,{'ARC->cPwdHarLic',''})
       AADD(aLicGen,{'ARC->cDerSysLic',REPL('1',110)})
       AADD(aLicGen,{'ARC->lPiePagLic',.F.})
       AADD(aLicGen,{'ARC->nPerHabLic',0})
       AADD(aLicGen,{'ARC->cDirEmpLic','PREUBATE'})
     *픁etalles Generales de la Licencia

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0060010101'})
       AADD(aRegIni,aDetLic)
     *픋icencia Matr죅ula Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0060010104'})
       AADD(aRegIni,aDetLic)
     *픋icencia Cartera Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCUN0060010107'})
       AADD(aRegIni,aDetLic)
     *픋icencia SimaData
*>>>>FIN LICENCIAS COLEGIO DE LA PRESENTACION - UBATE

*>>>>LICENCIAS COLEGIO DE LA PRESENTACION - SOGAMOSO
       aLicGen := {}
       AADD(aLicGen,{'ARC->lSharedLic',.T.})
       AADD(aLicGen,{'ARC->cMaeAluLic','JARPRIBTO'})
       AADD(aLicGen,{'ARC->cJornadLic','D'})
       AADD(aLicGen,{'ARC->nSysOpeLic',0})
       AADD(aLicGen,{'ARC->nModCryLic',0})
       AADD(aLicGen,{'ARC->cPwdSisLic','ELLAS'})
       AADD(aLicGen,{'ARC->nPruebaLic',0})
       AADD(aLicGen,{'ARC->cAnoHabLic',''})
       AADD(aLicGen,{'ARC->cMesHabLic',''})
       AADD(aLicGen,{'ARC->cPwdHarLic',''})
       AADD(aLicGen,{'ARC->cDerSysLic',REPL('1',110)})
       AADD(aLicGen,{'ARC->lPiePagLic',.F.})
       AADD(aLicGen,{'ARC->nPerHabLic',0})
       AADD(aLicGen,{'ARC->cDirEmpLic','PRES1SOG'})
     *픁etalles Generales de la Licencia

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLBOY0020010101'})
       AADD(aRegIni,aDetLic)
     *픋icencia Matr죅ula Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLBOY0020010102'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLBOY0020010103'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Profesores

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLBOY0020010104'})
       AADD(aRegIni,aDetLic)
     *픋icencia Cartera Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLBOY0020010107'})
       AADD(aRegIni,aDetLic)
     *픋icencia SimaData
*>>>>FIN LICENCIAS COLEGIO DE LA PRESENTACION - SOGAMOSO

*>>>>LICENCIAS COLEGIO DE LA PRESENTACION - DUITAMA
       aLicGen := {}
       AADD(aLicGen,{'ARC->lSharedLic',.T.})
       AADD(aLicGen,{'ARC->cMaeAluLic','JARPRIBTO'})
       AADD(aLicGen,{'ARC->cJornadLic','D'})
       AADD(aLicGen,{'ARC->nSysOpeLic',0})
       AADD(aLicGen,{'ARC->nModCryLic',0})
       AADD(aLicGen,{'ARC->cPwdSisLic','ELLAS'})
       AADD(aLicGen,{'ARC->nPruebaLic',0})
       AADD(aLicGen,{'ARC->cAnoHabLic',''})
       AADD(aLicGen,{'ARC->cMesHabLic',''})
       AADD(aLicGen,{'ARC->cPwdHarLic',''})
       AADD(aLicGen,{'ARC->cDerSysLic',REPL('1',110)})
       AADD(aLicGen,{'ARC->lPiePagLic',.F.})
       AADD(aLicGen,{'ARC->nPerHabLic',0})
       AADD(aLicGen,{'ARC->cDirEmpLic','PRES1DUI'})
     *픁etalles Generales de la Licencia

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLBOY0030010101'})
       AADD(aRegIni,aDetLic)
     *픋icencia Matr죅ula Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLBOY0030010102'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLBOY0030010103'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Profesores

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLBOY0030010104'})
       AADD(aRegIni,aDetLic)
     *픋icencia Cartera Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLBOY0030010107'})
       AADD(aRegIni,aDetLic)
     *픋icencia SimaData
*>>>>FIN LICENCIAS COLEGIO DE LA PRESENTACION - DUITAMA

*>>>>LICENCIAS COLEGIO LA SALLE VILLAVICENCIO
       aLicGen := {}
       AADD(aLicGen,{'ARC->lSharedLic',.T.})
       AADD(aLicGen,{'ARC->cMaeAluLic','JARPRIBTO'})
       AADD(aLicGen,{'ARC->cJornadLic','DN'})
       AADD(aLicGen,{'ARC->nSysOpeLic',0})
       AADD(aLicGen,{'ARC->nModCryLic',0})
       AADD(aLicGen,{'ARC->cPwdSisLic','ELLAS'})
       AADD(aLicGen,{'ARC->nPruebaLic',0})
       AADD(aLicGen,{'ARC->cAnoHabLic',''})
       AADD(aLicGen,{'ARC->cMesHabLic',''})
       AADD(aLicGen,{'ARC->cPwdHarLic',''})
       AADD(aLicGen,{'ARC->cDerSysLic',REPL('1',110)})
       AADD(aLicGen,{'ARC->lPiePagLic',.T.})
       AADD(aLicGen,{'ARC->nPerHabLic',0})
       AADD(aLicGen,{'ARC->cDirEmpLic','VILLABO'})
     *픁etalles Generales de la Licencia

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLMET0010010101'})
       AADD(aRegIni,aDetLic)
     *픋icencia Matr죅ula Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLMET0010010102'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLMET0010010103'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Profesores

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLMET0010010104'})
       AADD(aRegIni,aDetLic)
     *픋icencia Cartera Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLMET0010010106'})
       AADD(aRegIni,aDetLic)
     *픋icencia Cafeteria

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLMET0010010107'})
       AADD(aRegIni,aDetLic)
     *픋icencia Central de Riesgos

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLMET0010010109'})
       AADD(aRegIni,aDetLic)
     *픋icencia Cuentas por Pagar
*>>>>FIN LICENCIAS COLEGIO LA SALLE VILLAVICENCIO

*>>>>LICENCIAS ESCUELA LA SALLE PARA LA PAZ Y LA VIDA
       aLicGen := {}
       AADD(aLicGen,{'ARC->lSharedLic',.T.})
       AADD(aLicGen,{'ARC->cMaeAluLic','PRI'})
       AADD(aLicGen,{'ARC->cJornadLic','D'})
       AADD(aLicGen,{'ARC->nSysOpeLic',0})
       AADD(aLicGen,{'ARC->nModCryLic',0})
       AADD(aLicGen,{'ARC->cPwdSisLic','ELLAS'})
       AADD(aLicGen,{'ARC->nPruebaLic',0})
       AADD(aLicGen,{'ARC->cAnoHabLic',''})
       AADD(aLicGen,{'ARC->cMesHabLic',''})
       AADD(aLicGen,{'ARC->cPwdHarLic',''})
       AADD(aLicGen,{'ARC->cDerSysLic',REPL('1',110)})
       AADD(aLicGen,{'ARC->lPiePagLic',.T.})
       AADD(aLicGen,{'ARC->nPerHabLic',0})
       AADD(aLicGen,{'ARC->cDirEmpLic','PAZVIDA'})
     *픁etalles Generales de la Licencia

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLMET0010020101'})
       AADD(aRegIni,aDetLic)
     *픋icencia Matr죅ula Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLMET0010020102'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLMET0010020103'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Profesores
*>>>>FIN LICENCIAS ESCUELA LA SALLE PARA LA PAZ Y LA VIDA

*>>>>LICENCIAS COLEGIO DE LA SALLE - CARTAGENA DIURNA
       aLicGen := {}
       AADD(aLicGen,{'ARC->lSharedLic',.T.})
       AADD(aLicGen,{'ARC->cMaeAluLic','JARPRIBTO'})
       AADD(aLicGen,{'ARC->cJornadLic','D'})
       AADD(aLicGen,{'ARC->nSysOpeLic',0})
       AADD(aLicGen,{'ARC->nModCryLic',0})
       AADD(aLicGen,{'ARC->cPwdSisLic','ELLAS'})
       AADD(aLicGen,{'ARC->nPruebaLic',0})
       AADD(aLicGen,{'ARC->cAnoHabLic',''})
       AADD(aLicGen,{'ARC->cMesHabLic',''})
       AADD(aLicGen,{'ARC->cPwdHarLic',''})
       AADD(aLicGen,{'ARC->cDerSysLic',REPL('1',110)})
       AADD(aLicGen,{'ARC->lPiePagLic',.T.})
       AADD(aLicGen,{'ARC->nPerHabLic',0})
       AADD(aLicGen,{'ARC->cDirEmpLic','CTGDIU'})
     *픁etalles Generales de la Licencia

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLBOL0010010101'})
       AADD(aRegIni,aDetLic)
     *픋icencia Matr죅ula Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLBOL0010010102'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLBOL0010010103'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Profesores

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLBOL0010010104'})
       AADD(aRegIni,aDetLic)
     *픋icencia Cartera Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLBOL0010010107'})
       AADD(aRegIni,aDetLic)
     *픋icencia Central de Riesgos

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLBOL0010010109'})
       AADD(aRegIni,aDetLic)
     *픋icencia Cuentas por Pagar
*>>>>FIN LICENCIAS COLEGIO DE LA SALLE - CARTAGENA DIURNA

*>>>>LICENCIAS COLEGIO DE LA SALLE - CARTAGENA ANTONIO RAMOS
       aLicGen := {}
       AADD(aLicGen,{'ARC->lSharedLic',.T.})
       AADD(aLicGen,{'ARC->cMaeAluLic','PRIBTO'})
       AADD(aLicGen,{'ARC->cJornadLic','D'})
       AADD(aLicGen,{'ARC->nSysOpeLic',0})
       AADD(aLicGen,{'ARC->nModCryLic',0})
       AADD(aLicGen,{'ARC->cPwdSisLic','ELLAS'})
       AADD(aLicGen,{'ARC->nPruebaLic',0})
       AADD(aLicGen,{'ARC->cAnoHabLic',''})
       AADD(aLicGen,{'ARC->cMesHabLic',''})
       AADD(aLicGen,{'ARC->cPwdHarLic',''})
       AADD(aLicGen,{'ARC->cDerSysLic',REPL('1',110)})
       AADD(aLicGen,{'ARC->lPiePagLic',.T.})
       AADD(aLicGen,{'ARC->nPerHabLic',0})
       AADD(aLicGen,{'ARC->cDirEmpLic','CTGRAM'})
     *픁etalles Generales de la Licencia

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLBOL0010020101'})
       AADD(aRegIni,aDetLic)
     *픋icencia Matr죅ula Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLBOL0010020102'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLBOL0010020103'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Profesores
*>>>>FIN LICENCIAS COLEGIO DE LA SALLE - CARTAGENA ADICIONAL

*>>>>LICENCIAS COLEGIO MONTESSORI LTDA. CARTAGENA
       aLicGen := {}
       AADD(aLicGen,{'ARC->lSharedLic',.T.})
       AADD(aLicGen,{'ARC->cMaeAluLic','JARPRIBTO'})
       AADD(aLicGen,{'ARC->cJornadLic','D'})
       AADD(aLicGen,{'ARC->nSysOpeLic',0})
       AADD(aLicGen,{'ARC->nModCryLic',0})
       AADD(aLicGen,{'ARC->cPwdSisLic','ELLAS'})
       AADD(aLicGen,{'ARC->nPruebaLic',0})
       AADD(aLicGen,{'ARC->cAnoHabLic',''})
       AADD(aLicGen,{'ARC->cMesHabLic',''})
       AADD(aLicGen,{'ARC->cPwdHarLic',''})
       AADD(aLicGen,{'ARC->cDerSysLic',REPL('1',110)})
       AADD(aLicGen,{'ARC->lPiePagLic',.T.})
       AADD(aLicGen,{'ARC->nPerHabLic',0})
       AADD(aLicGen,{'ARC->cDirEmpLic','CTGMONTE'})
     *픁etalles Generales de la Licencia

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLBOL0010030101'})
       AADD(aRegIni,aDetLic)
     *픋icencia Matr죅ula Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLBOL0010030102'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLBOL0010030103'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Profesores

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLBOL0010030104'})
       AADD(aRegIni,aDetLic)
     *픋icencia Cartera Acad굆ica
*>>>>FIN LICENCIAS COLEGIO MONTESSORI LTDA. CARTAGENA

*>>>>LICENCIAS INSTITUCION EDUCATIVA LA INMACULADA
       aLicGen := {}
       AADD(aLicGen,{'ARC->lSharedLic',.T.})
       AADD(aLicGen,{'ARC->cMaeAluLic','PRIBTO'})
       AADD(aLicGen,{'ARC->cJornadLic','D'})
       AADD(aLicGen,{'ARC->nSysOpeLic',0})
       AADD(aLicGen,{'ARC->nModCryLic',0})
       AADD(aLicGen,{'ARC->cPwdSisLic','ELLAS'})
       AADD(aLicGen,{'ARC->nPruebaLic',0})
       AADD(aLicGen,{'ARC->cAnoHabLic',''})
       AADD(aLicGen,{'ARC->cMesHabLic',''})
       AADD(aLicGen,{'ARC->cPwdHarLic',''})
       AADD(aLicGen,{'ARC->cDerSysLic',REPL('1',110)})
       AADD(aLicGen,{'ARC->lPiePagLic',.F.})
       AADD(aLicGen,{'ARC->nPerHabLic',0})
       AADD(aLicGen,{'ARC->cDirEmpLic','OROCUE'})
     *픁etalles Generales de la Licencia

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCAS0020010101'})
       AADD(aRegIni,aDetLic)
     *픋icencia Matr죅ula Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCAS0020010102'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCAS0020010103'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Profesores

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','COLCAS0020010105'})
       AADD(aRegIni,aDetLic)
     *픋icencia Votaciones
*>>>>FIN LICENCIAS INSTITUCION EDUCATIVA LA INMACULADA

*>>>>GRABACION DE LOS REGISTROS
       FOR i := 1 TO LEN(aRegIni)

	   IF ARC->(lRegLock(lShared,.T.))
	      FOR j := 1 TO LEN(aRegIni[i])

		  LineaEstado('LICENCIAS:'+;
			      ALLTRIM(STR(i,4))+':'+;
			      ALLTRIM(STR(j,4))+;
			      ALLTRIM(STR(LEN(aRegIni),4))+'/'+;
			      'SIMASOFT','www.simavirtual.com')

		  cCampo := aRegIni[i][j][1]
		  REPL &cCampo WITH aRegIni[i][j][2]
		  ARC->(DBCOMMIT())
	      ENDFOR
	   ELSE
	      cError('NO SE GRABA EL REGISTRO INICIAL DE LA CONFIGURACION')
	   ENDIF
	   IF lShared
	      ARC->(DBUNLOCK())
	   ENDIF

       ENDFOR
       CloseDbf('ARC',PathArc+'\'+fArchvo,nModCry)
       RETURN NIL
*>>>>FIN GRABACION DE LOS REGISTROS

/*************************************************************************
* TITULO..: RECUPERACION DE LA ESTRUCTURA                                *
**************************************************************************

AUTOR: Nelson Fern쟮dez G줺ez       FECHA DE CREACION: SEP 10/2002 MAR A
       Colombia, Bucaramanga        INICIO: 02:05 PM   SEP 10/2002 MAR

OBJETIVOS:

1)- Recupera la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfLic(lShared,nModCry,PathArc,fArchvo,fNtxArc)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci줻
       PathArc			            // Path del Archivo
       fArchvo			            // Nombre del Archivo
       fNtxArc			            // Archivo de Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       cSavPan := SAVESCREEN(0,0,24,79)
       cError("SE BORRO EL ARCHIVO "+PathArc+'\'+fArchvo,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")
       Termometro(0,"CREANDO LA ESTRUCTURA")
       Termometro(100)
       CreaDbfLic(lShared,nModCry,PathArc,fArchvo,fNtxArc)
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern쟮dez G줺ez       FECHA DE CREACION: SEP 10/2002 MAR A
       Colombia, Bucaramanga        INICIO: 02:10 PM   SEP 10/2002 MAR

OBJETIVOS:

1- Actualiza la Estructura del Archivo

2- Retorna el N즡ero de Error:
   0 => No hay Error
	Estructura Actualizada
	Estructura Sin problemas
   1 => Estructura No Actualizada

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nActStrLic(lShared,nModCry,PathArc,cNomArc)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci줻
       PathArc				    // Path del Archivo
       cNomArc				    // Nombre del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nNroErr := 0                   // N즡ero del Error
       LOCAL       i := 0                   // Contador
       LOCAL aStrNew := {'1'}               // Estructura Nueva
       LOCAL aStrOld := {}                  // Estructura Vieja
       LOCAL lCambio := .F.                 // .T. Cambio la Estructura
       LOCAL FileTem := ''                  // Archivo temporal
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathArc+'\'+cNomArc,'ARC',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE CORRECIONES')
	  CloseDbf('ARC')
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := ARC->(DBSTRUCT())
       CloseDbf('ARC')
       CreaDbfLic(lShared,nModCry,PathArc,cNomArc,,@aStrNew)
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE LA ESTRUCTURA
       lCambio := .T.
       IF LEN(aStrNew) == LEN(aStrOld)
	  lCambio := .F.
	  nNroErr := 1
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
       IF lCambio .AND. lShared
	  cError('El Archivo LICENCIAS su Estructura Esta DesActualizada.',;
		 'ATENCION',;
		 'Para Actualizarla NO Debe Haber Ning즢 Usuario en la Red.')
	  lCambio := lPregunta('DESEA ACTUALIZAR LA ESTRUCTURA? No Si')
	  IF !lCambio
	     nNroErr := 1
	  ENDIF
       ENDIF
*>>>>FIN CONFIRMACION DE LA ACTUALIZACION

*>>>>ACTUALIZACION DE LA STRUCTURA
       IF lCambio
	  FileTem := SUBS(cNomArc,1,AT('.',cNomArc))+'STR'
	  cSavPan := SAVESCREEN(0,0,24,79)
	  IF !lStrucFile(lShared,;
			 PathArc+'\'+cNomArc,;
			 PathArc+'\'+FileTem,;
			 {||CreaDbfLic(lShared,nModCry,PathArc,FileTem)})
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA STRUCTURA

/*************************************************************************
* TITULO..: MANTENIMIENTO DEL ARCHIVO                                    *
**************************************************************************

AUTOR: Nelson Fern쟮dez G줺ez       FECHA DE CREACION: SEP 10/2002 MAR A
       Colombia, Bucaramanga        INICIO: 02:15 PM   SEP 10/2002 MAR

OBJETIVOS:

1- Permite el mantenimiento del archivo

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenLic(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		   nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,cPatSis)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci줻
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       nFilInf                              // Fila Inferior del SubMen�
       nColInf                              // Columna Inferior del SubMen�
       nFilPal                              // Fila Inferior Men� principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A쨚 del usuario
       cPatSis                              // Path del sistema */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                   // Declaraci줻 de teclas
       #INCLUDE "CAMPOS\ARC-SOFT.PRG"        // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A쨚 del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL cTitSup := ''                  // T죜ulo Superior del Browse
       LOCAL aCampos := {}                  // Definici줻 de Campos
       LOCAL cTitInf := ''                  // T죜ulo Inferior del Browse
       LOCAL bCodIns := NIL                 // CodeBlock Inserci줻 de Registros
       LOCAL oBrowse := NIL                 // Browse de Alumnos

       LOCAL GetList := {}                  // Variable del Sistema
       CloseAll()
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimSof,'SOF',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileCiu,'CIU',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileEmp,'EMP',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileCmd,'CMD',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileSui,'SUI',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileLic,'ARC',NIL,lShared,nModCry})
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
       CASE SOF->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE CIU->(RECCOUNT()) == 0
	    cError('NO EXISTEN MUNICIPIOS GRABADOS')

       CASE EMP->(RECCOUNT()) == 0
	    cError('NO EXISTEN EMPRESAS CREADAS')

       CASE CMD->(RECCOUNT()) == 0
	    cError('NO EXISTEN COMUNIDADES CREADAS')

       CASE SUI->(RECCOUNT()) == 0
	    cError('NO EXISTEN SUITES CREADAS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SOF->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>DEFINICION DEL BROWSE
       SELECT ARC
       cTitSup := '<< MANTENIMIENTO DE LICENCIAS >>'
      *픖죜ulo Superior del Browse

       aCampos := {}

       AADD(aCampos,{{"DIRECTORIO","cDirEmpLic"},;
		     {{'MODI',.F.},{'ALIAS','ARC'},;
		      {'FIELD','cDirEmpLic'},{'PICTURE','@!'}}})

       AADD(aCampos,{{"LICENCIA","cCodigoLic"},;
		     {{'MODI',.T.},{'ALIAS','ARC'},;
		      {'FIELD','cCodigoLic'},{'PICTURE','@!'}}})

       AADD(aCampos,{{"lShared","lSharedLic"},;
		     {{'MODI',.T.},{'ALIAS','ARC'},;
		      {'FIELD','lSharedLic'},{'PICTURE','@!'}}})

       AADD(aCampos,{{"cMaeAlu","cMaeAluLic"},;
		     {{'MODI',.T.},{'ALIAS','ARC'},;
		      {'FIELD','cMaeAluLic'},{'PICTURE','@!'}}})

       AADD(aCampos,{{"cJornad","cJornadLic"},;
		     {{'MODI',.T.},{'ALIAS','ARC'},;
		      {'FIELD','cJornadLic'},{'PICTURE','@!'}}})

       AADD(aCampos,{{"nSysOpe","nSysOpeLic"},;
		     {{'MODI',.T.},{'ALIAS','ARC'},;
		      {'FIELD','nSysOpeLic'},{'PICTURE','9'}}})

       AADD(aCampos,{{"nModCry","nModCryLic"},;
		     {{'MODI',.T.},{'ALIAS','ARC'},;
		      {'FIELD','nModCryLic'},{'PICTURE','9'}}})

       AADD(aCampos,{{"cPwdSis","cPwdSisLic"},;
		     {{'MODI',.T.},{'ALIAS','ARC'},;
		      {'FIELD','cPwdSisLic'},{'PICTURE','@!'}}})

       AADD(aCampos,{{"nPrueba","nPruebaLic"},;
		     {{'MODI',.T.},{'ALIAS','ARC'},;
		      {'FIELD','nPruebaLic'},{'PICTURE','9'}}})

       AADD(aCampos,{{"cAnoHab","cAnoHabLic"},;
		     {{'MODI',.T.},{'ALIAS','ARC'},;
		      {'FIELD','cAnoHabLic'},{'PICTURE','@!'}}})

       AADD(aCampos,{{"cMesHab","cMesHabLic"},;
		     {{'MODI',.T.},{'ALIAS','ARC'},;
		      {'FIELD','cMesHabLic'},{'PICTURE','@!'}}})

       AADD(aCampos,{{"cDerSys","cDerSysLic"},;
		     {{'MODI',.T.},{'ALIAS','ARC'},;
		      {'FIELD','cDerSysLic'},{'PICTURE','@!'}}})

       AADD(aCampos,{{"lPiePag","lPiePagLic"},;
		     {{'MODI',.T.},{'ALIAS','ARC'},;
		      {'FIELD','lPiePag'},{'PICTURE','@!'}}})

       AADD(aCampos,{{"nPerHab","nPerHabLic"},;
		     {{'MODI',.T.},{'ALIAS','ARC'},;
		      {'FIELD','nPerHabLic'},{'PICTURE','@!'}}})

       AADD(aCampos,{{"cPwdHar","cPwdHarLic"},;
		     {{'MODI',.T.},{'ALIAS','ARC'},;
		      {'FIELD','cPwdHarLic'},{'PICTURE','@!'}}})

       AADD(aCampos,{{"cPwdIns","cPwdInsLic"},;
		     {{'MODI',.T.},{'ALIAS','ARC'},;
		      {'FIELD','cPwdInsLic'},{'PICTURE','@!'}}})

       cTitInf := '<INS>Incluir <F5>Buscar <F9>Otros <ESC>Abandona'
      *픖죜ulo Inferior del Browse

       bCodIns := {||IncluirLic(lShared)}

       oBrowse := oBrowse(nFilPal+1,00,22,79,cTitSup,cTitInf,aCampos,bCodIns)
     *Creaci줻 del Browse
*>>>>FIN DEFINICION DEL BROWSE

*>>>>BROWSE DEL ARCHIVO
       SELECT ARC

       SETKEY(K_F5,{||BuscarLic(oBrowse)})
       SETKEY(K_F9,{||MenuOtrLic(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
				 cNomEmp,nFilInf,nColInf,nFilPal,cNomUsr,;
				 cAnoUsr,cPatSis,oBrowse)})
       CtrlBrw(lShared,oBrowse)
       SETKEY(K_F5,NIL)
       SETKEY(K_F9,NIL)

       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN BROWSE DEL ARCHIVO

/*************************************************************************
* TITULO..: INCLUCION DE UN REGISTRO          	                         *
**************************************************************************

AUTOR: Nelson Fern쟮dez G줺ez       FECHA DE CREACION: SEP 10/2002 MAR A
       Colombia, Bucaramanga        INICIO: 02:20 PM   SEP 10/2002 MAR

OBJETIVOS:

1- Incluye un registro al archivo

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION IncluirLic(lShared)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroFil := 3                   // Fila de Lectura
       LOCAL nNroCol := 2                   // Columna de Lectura
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lGrabar := .F.                 // .T. Grabar registro
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTli := ''               // C줰igo de la Licencia
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA Y CONFIRMACION DEL REGISTRO
       SET CURSOR ON
       nNroFil := nMarco(nNroFil,'POR FAVOR DIGITE EL CODIGO DE LICENCIA',22,'�')
       DO WHILE .T.

**********INICIALIZACION DE VARIABLES
	    IF !lHayErr
	       cCodigoTli := cSpaces('ARC','cCodigoLic')
	    ENDIF
**********FIN INICIALIZACION DE VARIABLES

**********LECTURA DEL REGISTRO
	    @ nNroFil+0,nNroCol SAY 'CODIGO DE TIPO :';
				GET cCodigoTli PICT '@!X';
				VALID !lValCodLic(cCodigoTli)
	    READ
**********FIN LECTURA DEL REGISTRO

**********VALIDACION DEL REGISTRO
	    lGrabar := .F.
	    DO CASE
	    CASE EMPTY(cCodigoTli)

		 cError('DEBE DAR LOS DATOS COMPLETOS. '+;
			'NO SE GRABA EL REGISTRO')
	    OTHERWISE
		 lGrabar := .T.
	    ENDCASE
**********FIN VALIDACION DEL REGISTRO

**********PREGUNTA DE DECISION
	    IF lGrabar
	       IF lPregunta('DESEA GRABAR EL REGISTRO? Si No')
		  EXIT
	       ENDIF
	    ELSE
	       EXIT
	    ENDIF
	    lHayErr := .T.
**********PREGUNTA DE DECISION

       ENDDO
*>>>>FIN LECTURA Y CONFIRMACION DEL REGISTRO

*>>>>GRABACION DEL REGISTRO
       SELECT ARC
       IF lGrabar
	  IF ARC->(lRegLock(lShared,.T.))
	     REPL ARC->cCodigoLic WITH cCodigoTli
	     ARC->(DBCOMMIT())
	  ENDIF
       ENDIF
       IF lShared
	  ARC->(DBUNLOCK())
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DEL REGISTRO

/*************************************************************************
* TITULO..: VALIDACION DEL CODIGO                                        *
**************************************************************************

AUTOR: Nelson Fern쟮dez G줺ez       FECHA DE CREACION: SEP 10/2002 MAR A
       Colombia, Bucaramanga        INICIO: 02:25 PM   SEP 10/2002 MAR

OBJETIVOS:

1- Debe estar en uso el archivo

2- Realiza la validaci줻 del c줰igo

3- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValCodLic(cCodigo)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodigo				    // C줰igo a validar */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO
       IF lLocCodigo('cCodigoLic','ARC',cCodigo) .AND. !lHayErr
	  cError('ESTE CODIGO YA EXISTE')
	  lHayErr := .T.
       ENDIF
       RETURN lHayErr
*>>>>FIN VALIDACION DEL CODIGO

/*************************************************************************
* TITULO..: BUSCAR EL CODIGO                                             *
**************************************************************************

AUTOR: Nelson Fern쟮dez G줺ez       FECHA DE CREACION: SEP 10/2002 MAR A
       Colombia, Bucaramanga        INICIO: 02:30 PM   SEP 10/2002 MAR

OBJETIVOS:

1- Debe estar en uso los archivo.

2- Busca el c줰igo.

3- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BuscarLic(oBrowse)

*>>>>PARAMETROS DE LA FUNCION
/*     oBrowse			            // Browse del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nNroReg := 0                   // N즡ero del Registro
       LOCAL lBuscar := .T.                 // .T. Realizar la b즧queda
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigo := ''                  // C줰igo de Buscar
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA DEL CODIGO
       SET CURSOR ON
       cCodigo := cSpaces('ARC','cCodigoLic')
       TitBuscar(2,@nNroFil,@nNroCol)
       @ nNroFil,nNroCol GET cCodigo PICT '9999';
			 VALID lValidaLic(ROW(),COL()-1,@cCodigo)
       READ
*>>>>FIN CAPTURA DEL CODIGO

*>>>>VALIDACION DEL CODIGO
       IF EMPTY(cCodigo)
	  cError('PATRON DE BUSQUEDA NO ESPECIFICADO',;
		  'ADVERTENCIA')
	  lBuscar := .F.
       ENDIF
*>>>>FIN VALIDACION DEL CODIGO

*>>>>BUSQUEDA DEL CODIGO
       SELECT ARC
       IF lBuscar .AND. lLocCodigo('cCodigoLic','ARC',cCodigo)
	   nNroReg := RECNO()
	   GO TOP
	   oBrowse:GOTOP()
	   GO nNroReg
	   oBrowse:FORCESTABLE()
       ELSE
	  oBrowse:GOTOP()
       ENDIF
       RETURN NIL
*>>>>FIN BUSQUEDA DEL CODIGO

/*************************************************************************
* TITULO..: VALIDACION DEL CODIGO                                        *
**************************************************************************

AUTOR: Nelson Fern쟮dez G줺ez       FECHA DE CREACION: SEP 10/2002 MAR A
       Colombia, Bucaramanga        INICIO: 02:35 PM   SEP 10/2002 MAR

OBJETIVOS:

1- Debe estar en uso el archivo

2- Realiza la validaci줻 del c줰igo de acuerdo al nombre

3- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValidaLic(nNroFil,nNroCol,cCodigo)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       cCodigo				    // C줰igo a Validar */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroReg := 0                   // N즡ero del registro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO DEL BANCO
       IF !lLocCodigo('cCodigoLic','ARC',cCodigo)
	  nNroReg := nSelCodLic(nNroFil,nNroCol)
	  IF nNroReg == 0
	     cCodigo := 0
	  ELSE
	     GO nNroReg
	     cCodigo := ARC->cCodigoLic
	  ENDIF
       ENDIF
       RETURN .T.
*>>>>FIN VALIDACION DEL CODIGO DEL BANCO

/*************************************************************************
* TITULO..: SELECCION DEL CODIGO                                         *
**************************************************************************

AUTOR: Nelson Fern쟮dez G줺ez       FECHA DE CREACION: SEP 10/2002 MAR A
       Colombia, Bucaramanga        INICIO: 02:40 PM   SEP 10/2002 MAR

OBJETIVOS:

1- Debe estar en uso el archivo.

2- Permite escoger el registro del archivo de acuerdo al nombre.

3- Retorna el n즡ero del registro escogido

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nSelCodLic(nNroFil,nNroCol)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // N즡ero de la fila
       nNroCol                              // N즡ero de la Columna */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nFilSup := 0                   // Fila superior
       LOCAL nColSup := 0                   // Colunma superior
       LOCAL nFilInf := 0                   // Fila inferior
       LOCAL nColInf := 0                   // Columna inferior
       LOCAL nNroReg := 0		    // Registro del Banco
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       IF ARC->(RECCOUNT()) == 0
	  cError('NO EXISTEN REGISTROS GRABADOS')
	  RETURN 0
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>INICIALIZACION DE LAS COORDENADAS
	SELECT ARC
	nFilSup := nNroFil+1
	nColSup := nNroCol+2
	IF nFilSup+RECCOUNT() > 22
	   nFilInf := 22
	ELSE
	   nFilInf := nFilSup + RECCOUNT()
	ENDIF
	nColInf := nColSup+18
*>>>>FIN INICIALIZACION DE LAS COORDENADAS

*>>>>SELECCION DEL REGISTRO
       ARC->(DBGOTOP())
       cSavPan := SAVESCREEN(0,0,24,79)
       @ nFilSup-1,nColSup-1 TO nFilInf,nColInf+1 DOUBLE
       nNroReg := nBrowseDbf(nFilSup,nColSup,nFilInf-1,nColInf,;
			     {||ARC->cNombreLic})
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN nNroReg
*>>>>FIN SELECCION DEL REGISTRO

/*************************************************************************
* TITULO..: MENU DE OTROS PARA EL ARCHIVO                                *
**************************************************************************

AUTOR: Nelson Fern쟮dez G줺ez       FECHA DE CREACION: SEP 10/2002 MAR A
       Colombia, Bucaramanga        INICIO: 02:45 PM   SEP 10/2002 MAR

OBJETIVOS:

1- Menu de Otros para el archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuOtrLic(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		    nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,cPatSis,;
		    oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci줻
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       nFilInf                              // Fila Inferior del SubMen�
       nColInf                              // Columna Inferior del SubMen�
       nFilPal                              // Fila Inferior Men� principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A쨚 del usuario
       cPatSis                              // Path del sistema
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A쨚 del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL aMenus  := {}                  // Vector de declaracion de men�
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men�
       LOCAL nNroOpc := 1                   // Numero de la opcion

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARCION Y EJECUCION DEL MENU
       AADD(aMenus,'1<CREACION DE LICENCIAS>')
       AADD(aMenus,'2<REGISTROS SQL        >')

       AADD(aAyuda,'Crea la Licencia para Cada Empresa')
       AADD(aAyuda,'Crea los registros Sql de la Tabla')

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
	    OtrLic011(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		      nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,cPatSis,;
		      oBrowse)
	   *Creaci줻 de Licencias

       CASE nNroOpc == 2
	   *Registros Sql

       ENDCASE
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: MENU OTROS OPCION No. 01                                     *
**************************************************************************

AUTOR: Nelson Fern쟮dez G줺ez       FECHA DE CREACION: SEP 10/2002 MAR A
       Colombia, Bucaramanga        INICIO: 09:00 PM   SEP 10/2002 MAR

OBJETIVOS:

1- Crea las licencias de las Empresas.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrLic011(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		   nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,cPatSis,;
		   oBrowse)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci줻
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       nFilInf                              // Fila Inferior del SubMen�
       nColInf                              // Columna Inferior del SubMen�
       nFilPal                              // Fila Inferior Men� principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A쨚 del usuario
       cPatSis                              // Path del sistema
       oBrowse                              // Browse del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SOFT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL PathAct := ''                  // Path Actual
       LOCAL PathDat := ''                  // Path de Datos

       LOCAL       i := 0                   // Contador
       LOCAL aDetLic := {}                  // Detalles de la Licencia
       LOCAL cTxtLic := ''                  // Texto de la Licencia
       LOCAL xCamLic := ''                  // Campo de Licencia
       LOCAL cPwdIns := ''                  // Serial de Instalaci줻
       LOCAL cPaises := ''                  // Nombre del Pais
       LOCAL cNomDpt := ''                  // Nombre del Departamento
       LOCAL cNomMun := ''                  // Nombre del Municipio
       LOCAL aRegIni := {}                  // Registros Iniciales

       LOCAL cCodigoTem := ''               // C줰igo de la Empresa
       LOCAL cCodigoTsu := ''               // C줰igo de la Suite
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE LAS LICENCIAS
       SELECT ARC
       ARC->(DBGOTOP())
       DO WHILE .NOT. ARC->(EOF())

**********INICIALIZACION DE VARIABLES
	    cCodigoTem := SUBS(ARC->cCodigoLic,1,12)
	    cCodigoTsu := SUBS(ARC->cCodigoLic,13,4)

	    cSavPan := SAVESCREEN(0,0,24,79)
	    Termometro(0,'CREACION DE LA LICENCIA DE '+cCodigoTem)
**********FIN INICIALIZACION DE VARIABLES

**********LOCALIZACION DE LA EMPRESA
	    IF !lLocCodigo('cCodigoEmp','EMP',cCodigoTem)
	       cError('NO EXISTE LA EMPRESA CODIGO: '+cCodigoTem)
	       RETURN NIL
	    ENDIF
	    IF EMPTY(EMP->cNaliasEmp)
	       cError('EL ALIAS DE LA EMPRESA '+cCodigoTem+' NO ESTA DEFINIDO')
	       RETURN NIL
	    ENDIF
**********FIN LOCALIZACION DE LA EMPRESA

**********LOCALIZACION DEL PAIS
	    IF !lLocCodigo('ALLTRIM(cCodigoCiu)','CIU',SUBS(cCodigoTem,1,3))
	       cError('NO EXISTE EL PAIS CODIGO: '+SUBS(cCodigoTem,1,3))
	       RETURN NIL
	    ENDIF
	    cPaises := ALLTRIM(CIU->cNombreCiu)
**********FIN LOCALIZACION DEL PAIS

**********LOCALIZACION DEL DEPARTAMENTO
	    IF !lLocCodigo('ALLTRIM(cCodigoCiu)','CIU',SUBS(cCodigoTem,1,6))
	       cError('NO EXISTE EL DEPARTAMENTO CODIGO: '+SUBS(cCodigoTem,1,6))
	       RETURN NIL
	    ENDIF
	    cNomDpt := ALLTRIM(CIU->cNombreCiu)
**********FIN LOCALIZACION DEL DEPARTAMENTO

**********LOCALIZACION DEL MUNICIPIO
	    IF !lLocCodigo('ALLTRIM(cCodigoCiu)','CIU',SUBS(cCodigoTem,1,9))
	       cError('NO EXISTE EL MUNICIPIO CODIGO: '+SUBS(cCodigoTem,1,6))
	       RETURN NIL
	    ENDIF
	    cNomMun := ALLTRIM(CIU->cNombreCiu)
**********FIN LOCALIZACION DEL MUNICIPIO

**********LOCALIZACION DE LA COMUNIDAD
	    IF !lLocCodigo('cCodigoCmd','CMD',EMP->cCodigoCmd)
	       cError('NO EXISTE LA COMUNIDAD CODIGO: '+EMP->cCodigoCmd)
	       RETURN NIL
	    ENDIF
**********FIN LOCALIZACION DE LA COMUNIDAD

**********LOCALIZACION DE LA SUITE
	    IF !lLocCodigo('cCodigoSui','SUI',cCodigoTsu)
	       cError('NO EXISTE LA SUITE CODIGO: '+cCodigoTsu)
	       RETURN NIL
	    ENDIF
**********FIN LOCALIZACION DE LA SUITE

**********VERIFICACION O CREACION DEL DIRECTORIO DATOSZIP
	    PathAct := DIRNAME()
	    PathDat := 'c:\datoszip'
	    DO CASE
	    CASE DIRCHANGE (PathDat) == 0
		 DIRCHANGE(PathAct)

	    CASE DIRCHANGE (PathDat) == -5
		 cError("NO HAY DERECHOS EN EL DIRECTORIO "+PathSis)
		 QUIT

	    CASE DIRCHANGE(PathDat) == -3
		 DIRMAKE(PathDat)
	    ENDCASE
**********FIN VERIFICACION O CREACION DEL DIRECTORIO DATOSZIP

**********VERIFICACION O CREACION DEL DIRECTORIO ALIAS DE EMPRESA
	    PathDat += '\'+ALLTRIM(EMP->cNaliasEmp)
	    DO CASE
	    CASE DIRCHANGE (PathDat) == 0
		 DIRCHANGE(PathAct)

	    CASE DIRCHANGE (PathDat) == -5
		 cError("NO HAY DERECHOS EN EL DIRECTORIO "+PathSis)
		 QUIT

	    CASE DIRCHANGE(PathDat) == -3
		 DIRMAKE(PathDat)
	    ENDCASE
**********FIN VERIFICACION O CREACION DEL DIRECTORIO ALIAS DE EMPRESA

**********VERIFICACION O CREACION DEL DIRECTORIO ALIAS DE SUITE
	    PathDat += '\'+ALLTRIM(SUI->cNaliasSui)
	    DO CASE
	    CASE DIRCHANGE (PathDat) == 0
		 DIRCHANGE(PathAct)

	    CASE DIRCHANGE (PathDat) == -5
		 cError("NO HAY DERECHOS EN EL DIRECTORIO "+PathSis)
		 QUIT

	    CASE DIRCHANGE(PathDat) == -3
		 DIRMAKE(PathDat)
	    ENDCASE
**********FIN VERIFICACION O CREACION DEL DIRECTORIO ALIAS DE SUITE

**********DETALLES DE INSTALACION
	    aDetLic := {}

	    AADD(aDetLic,ALLTRIM(CMD->cNombreCmd))     //01:cEmpPal
	    IF EMPTY(EMP->cNroNitEmp)
	       AADD(aDetLic,ALLTRIM(CMD->cNroNitCmd))  //02:cNitEmp
	    ELSE
	       AADD(aDetLic,ALLTRIM(EMP->cNroNitEmp))  //02:cNitEmp
	    ENDIF
	    AADD(aDetLic,ALLTRIM(EMP->cNombreEmp))     //03:cNomEmp
	    AADD(aDetLic,ALLTRIM(EMP->cCodigoEmp))     //04:cCodEmp
	    AADD(aDetLic,cPaises)                      //05:cPaises
	    AADD(aDetLic,cNomDpt)                      //06:cNomDpt
	    AADD(aDetLic,cNomMun)                      //07:cNomMun
	    AADD(aDetLic,ALLTRIM(CMD->cTituloCmd))     //08:cNomSec
	    AADD(aDetLic,ARC->lSharedLic)              //09:lShared
	    AADD(aDetLic,ARC->nModCryLic)              //10:nModCry
	    AADD(aDetLic,ARC->nSysOpeLic)              //11:nSysOpe
	    AADD(aDetLic,ARC->cDerSysLic)              //12:cDerSys
	    AADD(aDetLic,ALLTRIM(ARC->cPwdSisLic))     //13:cPwdSis
	    AADD(aDetLic,ARC->nPruebaLic)              //14:nPrueba
	    AADD(aDetLic,ALLTRIM(ARC->cAnoHabLic))     //15:cAnoHab
	    AADD(aDetLic,ALLTRIM(ARC->cMesHabLic))     //16:cMesHab
	    AADD(aDetLic,ALLTRIM(ARC->cPwdHarLic))     //17:cPwdHar
	    AADD(aDetLic,ARC->lPiePagLic)              //18:lPiePag
	    AADD(aDetLic,ALLTRIM(ARC->cMaeAluLic))     //19:cMaeAct
	    AADD(aDetLic,ALLTRIM(ARC->cJornadLic))     //20:cJornad
	    AADD(aDetLic,ARC->nPerHabLic)              //21:nPerHab
	    AADD(aDetLic,cCodigoTsu)                   //22:cCodSui
	    AADD(aDetLic,ARC->cDirEmpLic)              //23:cCodSui

	    Termometro(50)
**********FIN DETALLES DE INSTALACION

**********CREACION DE LA LICENCIA
	    cTxtLic := CHR(LEN(aDetLic)+1)
	    FOR i := 1 TO LEN(aDetLic)

		xCamLic := aDetLic[i]
		DO CASE
		CASE UPPER(VALTYPE(xCamLic)) == 'C'
		     cTxtLic += 'C'+CHR(LEN(xCamLic))+xCamLic


		CASE UPPER(VALTYPE(xCamLic)) == 'N'
		     cTxtLic += 'N'+CHR(16)+STR(xCamLic,16,2)

		CASE UPPER(VALTYPE(xCamLic)) == 'L'
		     cTxtLic += 'L'+CHR(1)+IF(xCamLic,'1','0')

		ENDCASE

	    ENDFOR
**********FIN CREACION DE LA LICENCIA

**********CREACION DEL SERIAL
	    cPwdIns := STR(CHECKSUM(cTxtLic),10,0)
	    IF ARC->(lRegLock(lShared,.F.))
	       REPL ARC->cPwdInsLic WITH cPwdIns
	       ARC->(DBCOMMIT())
	    ENDIF
	    IF lShared
	       ARC->(DBUNLOCK())
	    ENDIF
**********FIN CREACION DEL SERIAL

**********VALIDACION DEL TAMA쩙 DE LA LICENCIA
	    cTxtLic += 'C'+CHR(LEN(cPwdIns))+cPwdIns     //23:cCodSui
	    IF LEN(cTxtLic) == 500
	       cError('EL TAMA쩙 DE LA LICENCIA ES MAYOR A 500 CARACTERES')
	       RETURN NIL
	    ENDIF
**********FIN VALIDACION DEL TAMA쩙 DE LA LICENCIA

**********CREACION DEL ARCHIVO DE LICENCIA
	    aRegIni := {}
	    AADD(aRegIni,{{'TEM->abc',CRYPT(EMP->cCodigoEmp+SPACE(08),'IVANAN')},;
			  {'TEM->xyz',CRYPT(cTxtLic,'IVANAN')}})

	    FileLic(lShared,nModCry,PathDat,;
		    FileDat+cCodigoTsu+ExtFile,;
		    aRegIni,EMP->cCodigoEmp)

	    Termometro(100)
**********FIN CREACION DEL ARCHIVO DE LICENCIA

	  ARC->(DBSKIP())

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>CREACION DE LAS LICENCIAS

/*************************************************************************
* TITULO..: CREACION DEL ARCHIVO DE LA LICENCIA                          *
**************************************************************************

AUTOR: Nelson Fern쟮dez G줺ez       FECHA DE CREACION: SEP 10/2002 MAR A
       Colombia, Bucaramanga        INICIO: 09:15 PM   SEP 10/2002 MAR

OBJETIVOS:

1- Lee un campo del texto de la licencia

2- Retorna el campo de la licencia

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION FileLic(lShared,nModCry,PathArc,fArchvo,aRegIni,cCodEmp)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       nModCry                              // Modo de Protecci줻
       PathArc                              // Path del Archivo
       fArchvo                              // Nombre del Archivo
       aRegIni                              // Registro Inicial
       cCodEmp                              // C줰igo de la Empresa */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual

       LOCAL     i,j := 0                   // Contadores
       LOCAL aDbfStr := {}                  // Estructura del Archivo
       LOCAL cCampo  := ''                  // Nombre del Campo

       LOCAL cTxtLic := ''                  // Texto de la Licencia
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE LA ESTRUCTURA
       AADD(aDbfStr,{"abc","Character",020,0})  // C줰igo de la Empresa
       AADD(aDbfStr,{"xyz","Character",500,0})  // Detalles de la Licencia
*>>>>DECLARACION DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := DIRNAME()
       DO CASE
       CASE DIRCHANGE(PathArc) == 0
	    DBCREATE(PathArc+'\'+fArchvo,aDbfStr,"DBFNTX")

       CASE DIRCHANGE(PathArc) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathArc)

       CASE DIRCHANGE(PathArc) == -5
	    cError('NO TIENE DERECHOS EN: '+PathArc)
       ENDCASE
       DIRCHANGE(PathAct)
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathArc+'\'+fArchvo,'TEM',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE DATOS DE LICENCIA')
	  CloseDbf('TEM',PathArc+'\'+fArchvo,nModCry)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>GRABACION DE LOS REGISTROS
       FOR i := 1 TO LEN(aRegIni)

	   IF TEM->(lRegLock(lShared,.T.))
	      FOR j := 1 TO LEN(aRegIni[i])
		  cCampo := aRegIni[i][j][1]
		  REPL &cCampo WITH aRegIni[i][j][2]
		  TEM->(DBCOMMIT())
	      ENDFOR
	   ELSE
	      cError('NO SE GRABA EL REGISTRO INICIAL DE LA CONFIGURACION')
	   ENDIF
	   IF lShared
	      TEM->(DBUNLOCK())
	   ENDIF

       ENDFOR
       CloseDbf('TEM',PathArc+'\'+fArchvo,nModCry)
       RETURN NIL
*>>>>FIN GRABACION DE LOS REGISTROS

*>>>>LICENCIAS DEL SIMA
/*
       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','0101'})
       AADD(aRegIni,aDetLic)
     *픋icencia Matr죅ula Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','0102'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','0103'})
       AADD(aRegIni,aDetLic)
     *픋icencia Contabilidad Profesores

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','0104'})
       AADD(aRegIni,aDetLic)
     *픋icencia Cartera Acad굆ica

       aDetLic := {}
       aDetLic := ACLONE(aLicGen)
       AADD(aDetLic,{'ARC->cCodigoLic','0107'})
       AADD(aRegIni,aDetLic)
     *픋icencia SimaData
*/
*>>>>FIN LICENCIAS DEL SIMA