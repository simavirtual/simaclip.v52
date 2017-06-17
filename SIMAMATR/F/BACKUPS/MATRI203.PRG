/* SIMA - MATRICULA ACADEMICA

MODULO      : EXAMENES
SUBMODULO...: CONSULTA               MODULO No. 202

**************************************************************************
* NOMBRE DEL PROGRAMA..: MATRI203.PRG                                    *
* TITULO DEL PROGRAMA..: CONSULTA DE EXAMENES                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 03/96 MIE A
       Colombia, Bucaramanga        INICIO: 06:20 PM   ENE 03/96 MIE


REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Permite permite consultar las notas de los examenes

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_203(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-MATR.PRG"      // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr    := .F.              // .T. Hay Error

       LOCAL nNroIns := 0                   // N£mero de Inscriptos
       LOCAL oConsul := NIL                 // Browse de Alumnos

       LOCAL cCodigoTni := ''               // C¢digo del nivel

       LOCAL GetList := {}                  // Variable del Sistema
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
       IF !lUseDbf(.T.,cPatSis+'\'+;
		       fMtrAno+cAnoUsr+ExtFile,'ANO',NIL,lShared) .OR.;
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

       CASE ANO->nNroExaAno == 0
	    cError('No se ha definido el n£mero de notas para los examenes')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>ANALISIS DE LA ACTIVACION DE LOS EXAMENES
       IF !ANO->lHayExaAno
	  cError('NO ESTA HABILITADA LA OPCION PARA EXAMENES')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE LA ACTIVACION DE LOS EXAMENES

*>>>>LECTURA DEL CODIGO DEL NIVEL
       IF !lLeeCodNiv(nFilInf+1,nColInf,@cCodigoTni,;
		    {||lValCodNiv(cCodigoTni,cMaeAlu)})
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL CODIGO DEL NIVEL

*>>>>CONVERSION DEL NIVEL PARA GUARDERIA O JARDIN
       IF ('GUA' $ cMaeAlu .OR. 'JAR' $ cMaeAlu) .AND.;
	  ISALPHA(cCodigoTni)
	  cCodigoTni := cConverNiv(cCodigoTni)
       ENDIF
*>>>>FIN CONVERSION DEL NIVEL PARA GUARDERIA O JARDIN

*>>>>FILTRACION DEL ARCHIVO
       SELECT ADM
       SET FILTER TO VAL(SUBS(ADM->cCodigoGru,1,2)) == VAL(cCodigoTni)
       COUNT ALL FOR VAL(SUBS(ADM->cCodigoGru,1,2)) == VAL(cCodigoTni);
		 TO nNroIns
       GO TOP
*>>>>FIN FILTRACION DEL ARCHIVO

*>>>>MANTENIMIENTO DEL ARCHIVO
       SELECT ADM
       oConsul := oDefExaAdm(nFilPal+1,00,22,79,nNroIns)
       SETKEY(K_F5,{||BuscarAdm(oConsul)})
       ADM->(CtrlBrw(lShared,oConsul))
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
* TITULO DE LA FUNCION..: DEFINICION OBJETO DE EXAMENES                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 03/96 MIE A
       Colombia, Bucaramanga        INICIO: 06:35 PM   ENE 03/96 MIE

1- Define el objeto Browse del examenes

2- Debe estar en uso el archivo de Admisiones

SINTAXIS:

 oConsul := oDefExaAdm(00,00,24,79,'94')

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefExaAdm(nFilSup,nColSup,nFilInf,nColInf,nNroIns)

*>>>>PARAMETROS DE LA FUNCION
/*     nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       nNroIns			            // N£mero de inscritos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oConsul := NIL                 // Browse de Alumnos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oConsul := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oConsul:ColSep    := '³'
       oConsul:HeadSep   := 'Ä'
       oConsul:Cargo     := {'<<  CONSULTA DE EXAMENES. '+;
			     'TOTAL = '+STR(nNroIns,4)+'  >>',;
			    '<F5>Buscar  <ESC>Abandonar'}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT ADM
       oColumn	     := TBCOLUMNNEW('NUMERO', {||ADM->cNumeroAdm})
       oColumn:Cargo := {{'MODI',.F.}}
       oConsul:ADDCOLUMN(oColumn)
       oConsul:Freeze := 3
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('GRUPO',{||ADM->cCodigoGru})
       oColumn:Cargo := {{'MODI',.F.}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRE',;
			      {||RTRIM(ADM->cApelliEst)+' '+ADM->cNombreEst})
       oColumn:Cargo := {{'MODI',.F.}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       IF ANO->nNroExaAno >= 1
	  oColumn        := TBCOLUMNNEW('NOT1',;
				       {||cNotaExa(ADM->cNotExaAdm,1)})
	  oColumn:Cargo  := {{'MODI',.F.}}
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF ANO->nNroExaAno >= 2
	  oColumn	:= TBCOLUMNNEW('NOT2',;
				       {||cNotaExa(ADM->cNotExaAdm,2)})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF ANO->nNroExaAno >= 3
	  oColumn	:= TBCOLUMNNEW('NOT3',;
				       {||cNotaExa(ADM->cNotExaAdm,3)})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF ANO->nNroExaAno >= 4
	  oColumn	:= TBCOLUMNNEW('NOT4',;
				       {||cNotaExa(ADM->cNotExaAdm,4)})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF ANO->nNroExaAno >= 5
	  oColumn	:= TBCOLUMNNEW('NOT5',;
				       {||cNotaExa(ADM->cNotExaAdm,5)})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF ANO->nNroExaAno >= 6
	  oColumn	:= TBCOLUMNNEW('NOT6',;
				       {||cNotaExa(ADM->cNotExaAdm,6)})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF ANO->nNroExaAno >= 7
	  oColumn	:= TBCOLUMNNEW('NOT7',;
				       {||cNotaExa(ADM->cNotExaAdm,7)})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF ANO->nNroExaAno >= 8
	  oColumn	:= TBCOLUMNNEW('NOT8',;
				       {||cNotaExa(ADM->cNotExaAdm,8)})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF ANO->nNroExaAno >= 9
	  oColumn	:= TBCOLUMNNEW('NOT9',;
				       {||cNotaExa(ADM->cNotExaAdm,9)})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       IF ANO->nNroExaAno >= 10
	  oColumn	:= TBCOLUMNNEW('NOT10',;
				       {||cNotaExa(ADM->cNotExaAdm,10)})
	  oColumn:Cargo := {{'MODI',.F.}}
	  oConsul:ADDCOLUMN(oColumn)
       ENDIF
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOTA',;
				    {||ADM->nDefExaAdm})
       oColumn:Cargo := {{'MODI',.F.}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('APROBO',;
			      {||IF(ADM->lExamenAdm,'SI','NO')})
       oColumn:Cargo := {{'MODI',.F.}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CITA',;
			      {||IF(ADM->lEntrevAdm,'SI','NO')})
       oColumn:Cargo := {{'MODI',.F.}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('PADRES',;
			      {||IF(ADM->lRetiroAdm,'RETIRADO',;
				 IF(ADM->lExAlumAdm,'EXALUMNO',SPACE(08)))})
       oColumn:Cargo := {{'MODI',.F.}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oConsul
       FUNCTION cNotaExa(cNotas,i)
       RETURN SUBS(cNotas,i*4-3,4)
*>>>>FIN DEFINICION DEL OBJETO BROWSE