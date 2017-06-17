/* SIMA - CONTROL DE ASISTENCIA

MODULO      : CONSULTAS
SUBMODULO...: POR ESTUDIANTES                          MODULO No. 301

**************************************************************************
* TITULO..: CONSULTAS DE LAS NOVEDADES DE ASISTENCIA                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 09/2004 MIE A
       Colombia, Bucaramanga        INICIO: 01:30 PM   JUN 09/2004 MIE

OBJETIVOS:

1- Permite Consultar los Estudiantes


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Asist_301(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		   cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		   cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		   cJorTxt,lModReg,lDelReg)

*>>>>PARAMETROS DE LA FUNCION
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
       lModReg                              // Modificar Registros
       lDelReg                              // .T. Borrar Registros */
*>>>>FIN PARAMETROS DE LA FUNCION

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

       LOCAL cTitSup := ''                  // T¡tulo Superior del Browse
       LOCAL aCampos := NIL                 // Definici¢n de Campos
       LOCAL cTitInf := ''                  // T¡tulo Inferior del Browse
       LOCAL oBrowse := NIL                 // Browse de Alumnos

       LOCAL GetList := {}                  // Variable del Sistema

       CloseAll()                           // Cerrar Archivos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathAsiAno(lShared,cPatSis,cAnoUsr,@cIntUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry)
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}

       AADD(aUseDbf,{.T.,cIntUno+'\'+FileHra,'HRA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FAsiAno+cAnoUsr+ExtFile,'ANO',NIL,lShared,nModCry})

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
       SELECT &cMaeAct
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTEN ESTUDIANTES GRABADOS')

       CASE HRA->(RECCOUNT()) == 0
	    cError('NO SE HA DEFINIDO LA DIVISION DE LAS HORAS')

       CASE ANO->(RECCOUNT()) == 0
	    cError('NO EXISTE LA CONFIGURACION DEL A¥O')

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


       cTitInf := '<F2>Personal <F3>Asitencia <F5>Buscar <ESC>Abandona'
      *ÀT¡tulo Inferior del Browse

       oBrowse := oBrowse(nFilPal+1,00,22,79,cTitSup,cTitInf,aCampos)
     *Creaci¢n del Browse
*>>>>FIN DEFINICION DEL BROWSE

*>>>>BROWSE DE LOS ESTUDIANTES
       SELECT &cMaeAct

       SETKEY(K_F2,{||InfoAlu(nFilPal,1,cMaeAct,cNomEmp,cNomSis)})

       SETKEY(K_F3,{||VerAusEst(lShared,cAnoUsr,cPatSis,cMaeAct,;
				lModReg,lDelReg,cMaeAlu)})

       SETKEY(K_F5,{||BuscarAlu(lShared,oBrowse,cMaeAct,SUBS(cAnoUsr,3,2),cIntUno)})

       DO CASE
       CASE cMaeAct == 'JAR'
	    JAR->(CtrlBrw(lShared,oBrowse))

       CASE cMaeAct == 'PRI'
	    PRI->(CtrlBrw(lShared,oBrowse))

       CASE cMaeAct == 'BTO'
	    BTO->(CtrlBrw(lShared,oBrowse))

       ENDCASE
       SETKEY(K_F2,NIL)
       SETKEY(K_F3,NIL)
       SETKEY(K_F5,NIL)
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN BROWSE DE LOS ESTUDIANTES

/*************************************************************************
* TITULO..: AUSENCIAS DEL ESTUDIANTE                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 09/2004 MAR A
       Colombia,Bucaramanga         INICIO: 02:30 PM   JUN 09/2004 MAR

OBJETIVOS:

1- Debe estar en uso el maestro de alumnos habilitado

2- Debe estar en uso el archivo el archivo de control de asistencia

3- Visualiza las ausencias del estudiante

4- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION VerAusEst(lShared,cAnoUsr,cPatSis,cMaeAct,lModReg,lDelReg,;
		   cMaeAlu,cNalias,cCodEst)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del Sistema
       cMaeAct			            // Maestro Actual
       lModReg                              // .T. Modificar Registros
       lDelReg                              // .T. Borrar Registros
       cMaeAlu                              // Maestros Habilitados
       cNalias                              // Alias del que Invoca
       cCodEst                              // C¢digo del Estudiante */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL cNomEst := ''                  // Nombre del Estudiante
       LOCAL cCodGru := ''                  // C¢digo del Grupo
       LOCAL cNotCli := ''                  // Nota del Cliente
       LOCAL cTxtTem := ''                  // Texto Temporal
       LOCAL oBrowse := NIL                 // Browse del Archivo

       LOCAL bCodF02 := NIL                 // Code Block asignado a F2
       LOCAL bCodF03 := NIL                 // Code Block asignado a F3
       LOCAL bCodF04 := NIL                 // Code Block asignado a F4
       LOCAL bCodF05 := NIL                 // Code Block asignado a F5
       LOCAL bCodF06 := NIL                 // Code Block asignado a F6

       MEMVA xClrSys			    // Color del Sistema
       LOCAL cSayTxt := ''                  // Color del Texto fijo
       LOCAL cSayDat := ''                  // Color para los datos
       LOCAL cClrMar := ''                  // Color del Marco y Fondo
       LOCAL cClrTit := ''                  // Color T¡tulo del Marco
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DESACTIVACION DE LAS TECLAS DE FUNCION
      bCodF02 := SETKEY(K_F2)
      bCodF03 := SETKEY(K_F3)
      bCodF05 := SETKEY(K_F5)

      SETKEY(K_F2,NIL)
      SETKEY(K_F3,NIL)
      SETKEY(K_F5,NIL)
*>>>>FIN DESACTIVACION DE LAS TECLAS DE FUNCION

*>>>>BUSQUEDA DEL MAESTRO ACTUAL
       IF !EMPTY(cNalias)
	  cMaeAct := cMaeAct(cCodEst,cMaeAlu)
       ENDIF
*>>>>FIN BUSQUEDA DEL MAESTRO ACTUAL

*>>>>ANALISIS DEL COLOR
       Colores(xColores(IF(!EMPTY(xClrSys),xClrSys[7],'')),;
	       @cSayTxt,@cSayDat,@cClrMar,@cClrTit)
*>>>>IF ANALISIS DEL COLOR

*>>>>IMPRESION DEL NOMBRE
       cSavPan := SAVESCREEN(0,0,24,79)
       nNroFil := nMarco(03,'AUSENCIAS DEL ESTUDIANTE',22,'°',;
			 cClrMar+','+cClrTit)

       nNroCol := 1
       @ nNroFil,nNroCol+00 SAY 'CODIGO: '+&cMaeAct->cCodigoEst
       cSay(nNroFil,nNroCol,'CODIGO:',&cMaeAct->cCodigoEst)

       cSay(nNroFil,nNroCol+15,'NOMBRE:',RTRIM(&cMaeAct->cApelliEst)+' '+;
					       &cMaeAct->cNombreEst)

       cSay(nNroFil,nNroCol+65,'CURSO:',&cMaeAct->cCodigoGru)
*>>>>FIN IMPRESION DEL NOMBRE

*>>>>ANALISIS SI EL ESTUDIANTE ESTA RETIRADO
       IF &cMaeAct->lRetiroEst
	  SET COLOR TO G*
	  @ nNroFil+1,nNroCol+23 SAY 'RETIRADO'
	  SetClrTo()
       ENDIF
*>>>>FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO

*>>>>IMPRESION DE LOS TITULOS
       cCodEst := &cMaeAct->cCodigoEst

       SELECT ASI
       SET FILTER TO ASI->cCodigoEst == cCodEst
       ASI->(DBGOTOP())

       IF ASI->(EOF())
	  cError('AL ESTUDIANTE NO LE FIGURAN AUSENCIAS DE NINGUN TIPO')
       ELSE
	  oBrowse := oBrwDbfCtr(lShared,cAnoUsr,08,01,22,78,;
				lModReg,lDelReg,cMaeAlu)
	  ASI->(CtrlBrw(lShared,oBrowse))
       ENDIF
*>>>>FIN IMPRESION DE LOS DATOS

*>>>>ACTIVACION DE LAS TECLAS DE FUNCION
       SETKEY(K_F2,bCodF02)
       SETKEY(K_F3,bCodF03)
       SETKEY(K_F5,bCodF05)

       RESTSCREEN(0,0,24,79,cSavPan)
       SELECT &cMaeAct
       IF !EMPTY(cNalias)
	  SELECT &cNalias
       ENDIF
       RETURN NIL
*>>>>FIN ACTIVACION DE LAS TECLAS DE FUNCION

