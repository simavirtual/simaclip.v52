/*SISTEMA DE MATRICULA ACADEMICA

MODULO      : CUPOS
SUBMODULO...: CUPOS           MODULO No. 402

**************************************************************************
* NOMBRE DEL PROGRAMA..: MATRI402.PRG                                    *
* TITULO DEL PROGRAMA..: CONSULTA LOS CUPOS ASIGNANDOS                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 06/96 MAR A
       Colombia, Bucaramanga        INICIO: 04:00 PM   AGO 06/96 MAR

REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Permite consultar consultar los cupos asisgnados

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_402(aParam1,aParam2,aParam3)

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
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
     *ÀVariables generales

       LOCAL nNroNiv := 0                   // N£mero del nivel
       LOCAL cNroAdm := 0                   // N£mero de Admitidos
       LOCAL cCupDis := ''                  // N£mero Cupos disponibles
       LOCAL oConsul := NIL                 // Browse de Alumnos
       LOCAL GetList := {}                  // Variable del Sistema
     *ÀVariables espec¡ficas

       LOCAL cCodigoTni := ''               // Codigo del nivel
     *ÀVariables temporales de campo
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

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathUno+'\'+PathSis+'\'+;
		       FilePer,'PER',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       fMtrAno+cAnoUsr+ExtFile,'ANO',NIL,lShared).OR.;
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
       CASE ANO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DE LA MATRICULA PARA EL A¥O')

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

*>>>>LECTURA DEL CODIGO DEL NIVEL
       IF !lLeeCodNiv(nFilInf+1,nColInf,@cCodigoTni,;
		    {||lValCodNiv(cCodigoTni,cMaeAlu)})
	  CLOSE ALL
	  RETURN NIL
       ENDIF
       nNroNiv := VAL(cCodigoTni)
*>>>>FIN LECTURA DEL CODIGO DEL NIVEL

*>>>>FILTRACION DEL ARCHIVO
       SELECT ADM
       SET FILTER TO VAL(SUBS(ADM->cCodigoGru,1,2)) == nNroNiv
       COUNT ALL FOR VAL(SUBS(ADM->cCodigoGru,1,2)) == nNroNiv TO cNroAdm
       GO TOP
       IF EOF()
	  cError('NO EXISTEN INSCRITOS PARA '+cNomNiv(nNroNiv))
	  CLOSE ALL
	  RETURN NIL
       ENDIF
       cNroAdm := STR(cNroAdm,4)
       cCupDis := SUBS(ANO->cNroCupAno,(nNroNiv+1)*4-3,4)
*>>>>FIN FILTRACION DEL ARCHIVO

*>>>>MANTENIMIENTO DEL ARCHIVO
       SELECT ADM
       oConsul := oDefCupos(nFilPal+1,00,22,79,cNroAdm,cCupDis,;
			    ANO->lHayExaAno,ANO->lHayExaAno)

       SETKEY(K_F2,{||InfoAlu(nFilPal,1,'ADM',cNomEmp,cNomSis)})

       IF ANO->lHayExaAno .OR. ANO->lHayExaAno
	  SETKEY(K_F3,{||ResultaAlu(nFilPal,1,cNomEmp,cNomSis,;
				    ANO->lHayExaAno,ANO->lHayExaAno)})
       ENDIF

       SETKEY(K_F4,{||CuposDispi(lShared,cNomEmp,cNomSis,nFilPal,cMaeAlu)})

       SETKEY(K_F5,{||BuscarAdm(oConsul)})

       ADM->(CtrlBrw(lShared,oConsul))
       SETKEY(K_F2,NIL)
       SETKEY(K_F3,NIL)
       SETKEY(K_F4,NIL)
       SETKEY(K_F5,NIL)
       SET FILTER TO
       CLOSE ALL
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

***************************************************************************
*----------------------------FIN DEL PROGRAMA ----------------------------*
*--------------- DECLARACION DE FUNCIONES PARA EL PROGRAMA ---------------*
***************************************************************************

/*************************************************************************
* TITULO DE LA FUNCION..: DEFINICION OBJETO DE CUPOS                     *
**************************************************************************

OBJETIVOS:                          FECHA DE CREACION: AGO 28/94 DOM A
						       AGO 28/94 DOM

1- Define el objeto Browse de cupos

2- Debe estar en uso el archivo de Admisiones

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefCupos(nFilSup,nColSup,nFilInf,nColInf,;
		   cNroAdm,cCupDis,lHayExa,lHayEnt)

*>>>>PARAMETROS DE LA FUNCION
/*     nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       cNroAdm                              // N£mero de Admitidos
       cCupDis                              // N£mero cupos disponibles
       lHayExa                              // .T. Hay Examenes
       lHayEnt                              // .T. Hay Entrevistas */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oConsul := NIL                 // Browse de Alumnos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       cCupDis := IF(EMPTY(cCupDis),'NO HAY',cCupDis)
       oConsul := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oConsul:ColSep  := '³'
       oConsul:HeadSep := 'Ä'
       IF lHayExa .OR. lHayEnt
	  oConsul:Cargo   := {'<<  CONSULTA DE CUPOS. '+;
			      'CANDIDATOS = '+cNroAdm+' '+;
			      '. CUPOS DISPONIBLES = '+cCupDis+' >>',;
			      '<F2>Informaci¢n <F3>Resultados <F4>Cupos '+;
			      '<F5>Buscar'}
       ELSE
	  oConsul:Cargo   := {'<<  CONSULTA DE CUPOS. '+;
			      'CANDIDATOS = '+cNroAdm+' '+;
			      '. CUPOS DISPONIBLES = '+cCupDis+' >>',;
			      '<F2>Informaci¢n <F4>Cupos <F5>Buscar'}
       ENDIF
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT ADM
       oColumn	     := TBCOLUMNNEW('CODIGO', {||ADM->cNumeroAdm})
       oColumn:Cargo := {{'MODI',.F.}}
       oConsul:ADDCOLUMN(oColumn)
       oConsul:Freeze := 1
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CURSO',{||ADM->cCodigoGru})
       oColumn:Cargo := {{'MODI',.F.}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRE DEL CANDIDATO',;
			      {||RTRIM(ADM->cApelliEst)+' '+ADM->cNombreEst})
       oColumn:Cargo := {{'MODI',.F.}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CUPO',;
			      {||IF(ADM->lSiCupoEst,'SI','NO')})
       oColumn:Cargo := {{'MODI',.F.}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('PADRES',;
			      {||IF(ADM->lExAlumAdm,'EXALUMNO',SPACE(08))})
       oColumn:Cargo := {{'MODI',.F.}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('MATRICULADO',{||IF(ADM->lSiMatrEst,;
						'SI',;
						'NO')})
       oColumn:Cargo := {{'MODI',.F.}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('F.MATRI',{||cFecha(ADM->dFecMatEst)})
       oColumn:Cargo := {{'MODI',.F.}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('H.MATRI',{||cHoraSys(ADM->cHorMatEst)})
       oColumn:Cargo := {{'MODI',.F.}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oConsul
*>>>>FIN DEFINICION DEL OBJETO BROWSE