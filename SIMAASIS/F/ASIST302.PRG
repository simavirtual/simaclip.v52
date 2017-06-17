/* SIMA - CONTROL DE ASISTENCIA

MODULO      : CONSULTAS
SUBMODULO...: POR PROFESOR

**************************************************************************
* TITULO..: CONSULTAS DE LAS NOVEDADES DE ASISTENCIA PROFESORES          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 08/2009 LUN A
       Colombia, Bucaramanga        INICIO: 02:30 PM   JUN 08/2009 LUN

OBJETIVOS:

1- Permite Consultar los Profesores


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Asist_302(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales No. 1
       aParam2                              // Parametros Generales No. 2
       aParam3                              // Parametros Generales No. 3 */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>PARAMETROS DE LA FUNCION
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // Modo de Protecci¢n
       LOCAL cNomSis := ''                  // Nombre del Sistema
       LOCAL cEmpPal := ''                  // Nombre de la Empresa principal
       LOCAL cNitEmp := ''                  // Nit de la Empresa
       LOCAL cNomEmp := ''                  // Nombre de la Empresa
       LOCAL cNomSec := ''                  // Nombre de la Empresa Secundario
       LOCAL cCodEmp := ''                  // C¢digo de la Empresa
       LOCAL cNomUsr := ''                  // Nombre del Usuario
       LOCAL cAnoUsr := ''                  // A¤o del usuario
       LOCAL cPatSis := ''                  // Path del sistema
       LOCAL nFilPal := ''                  // Fila Inferior Men£ principal
       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Actual
       LOCAL cJorTxt := ''                  // Jornada escogida
     *ÀParametros Generales No.1

       LOCAL nFilInf := ''                  // Fila Inferior del SubMen£
       LOCAL nColInf := ''                  // Columna Inferior del SubMen£
     *ÀParametros Generales No.2

       LOCAL nTipLec := ''                  // Tipo de Lectura
     *ÀParametros Generales No.3
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas

       #INCLUDE "CAMPOS\ARC-ASIS.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := ''                  // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de Integraci¢n Uno
       LOCAL PathUno := ''                  // Path de Integraci¢n Uno
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

       LOCAL cCodPnl := ''                  // C¢digo del personal
       LOCAL cNomPnl := ''                  // Nombre del personal
       LOCAL aTiempo := {}                  // Tiempo Transcurrido
       LOCAL lInsReg := .F.                 // .T. Insertar Registro

       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTtp := ''               // C¢digo tipo personal
       CloseAll()                           // Cerrar Archivos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>INICIALIZACION DE PARAMETROS
       lShared := xParametro(aParam1,aParam2,aParam3,'lShared')
       nModCry := xParametro(aParam1,aParam2,aParam3,'nModCry')
       cNomSis := xParametro(aParam1,aParam2,aParam3,'cNomSis')
       cEmpPal := xParametro(aParam1,aParam2,aParam3,'cEmpPal')
       cNitEmp := xParametro(aParam1,aParam2,aParam3,'cNitEmp')
       cNomEmp := xParametro(aParam1,aParam2,aParam3,'cNomEmp')
       cNomSec := xParametro(aParam1,aParam2,aParam3,'cNomSec')
       cCodEmp := xParametro(aParam1,aParam2,aParam3,'cCodEmp')
       cNomUsr := xParametro(aParam1,aParam2,aParam3,'cNomUsr')
       cAnoUsr := xParametro(aParam1,aParam2,aParam3,'cAnoUsr')
       cPatSis := xParametro(aParam1,aParam2,aParam3,'cPatSis')
       nFilPal := xParametro(aParam1,aParam2,aParam3,'nFilPal')
       cMaeAlu := xParametro(aParam1,aParam2,aParam3,'cMaeAlu')
       cMaeAct := xParametro(aParam1,aParam2,aParam3,'cMaeAct')
       cJorTxt := xParametro(aParam1,aParam2,aParam3,'cJorTxt')
     *ÀParametros Generales No.1

       nFilInf := xParametro(aParam1,aParam2,aParam3,'nFilInf')
       nColInf := xParametro(aParam1,aParam2,aParam3,'nColInf')
     *ÀParametros Generales No.2

     *ÀParametros Generales No.3

       cAnoSis := SUBS(cAnoUsr,3,2)
*>>>>FIN INICIALIZACION DE PARAMETROS

*>>>>LECTURA DE PATHS
       PathAsiAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry,.F.)
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+;
			 FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+fAsiNov,'NOV',NIL,lShared,nModCry})
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
       CASE PRO->(RECCOUNT()) == 0
	    cError('NO EXISTEN PROFESORES GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>DEFINICION DEL BROWSE
       SELECT PRO
       cTitSup := '<< CONSULTA DE PROFESORES '+;
		  ' .TOTAL ='+STR(PRO->(RECCOUNT()),4)+' A¥O: '+cAnoUsr+' >>'
      *ÀT¡tulo Superior del Browse

       aCampos := {{{"CODIGO","cCodigoPro"},{NIL}},;
		   {{"APELLIDOS;DEL PROFESOR","cApelliPro"},{NIL}},;
		   {{"NOMBRES;DEL PROFESOR","cNombrePro"},{NIL}}}
     *ÀDefinici¢n de Campos


       cTitInf := '<F3>Asitencia <F5>Buscar <ESC>Abandona'
      *ÀT¡tulo Inferior del Browse

       oBrowse := oBrowse(nFilPal+1,00,22,79,cTitSup,cTitInf,aCampos)
     *Creaci¢n del Browse
*>>>>FIN DEFINICION DEL BROWSE

*>>>>BROWSE DE LOS ESTUDIANTES
       SELECT PRO

       SETKEY(K_F3,{||VerAusPro(lShared,cAnoUsr,cPatSis)})

       PRO->(CtrlBrw(lShared,oBrowse))

       SETKEY(K_F2,NIL)
       SETKEY(K_F3,NIL)
       SETKEY(K_F5,NIL)
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN BROWSE DE LOS ESTUDIANTES

/*************************************************************************
* TITULO..: AUSENCIAS DEL PROFESOR                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 08/2009 MIE A
       Colombia,Bucaramanga         INICIO: 03:15 PM   JUN 08/2009 MIE

OBJETIVOS:

1- Debe estar en uso el maestro de alumnos habilitado

2- Debe estar en uso el archivo el archivo de control de asistencia

3- Visualiza las ausencias del estudiante

4- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION VerAusPro(lShared,cAnoUsr,cPatSis)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del Sistema */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema

       LOCAL cCodPro := ''                  // C¢digo del Programador
       LOCAL cTitSup := ''                  // T¡tulo Superior del Browse
       LOCAL aCampos := NIL                 // Definici¢n de Campos
       LOCAL cTitInf := ''                  // T¡tulo Inferior del Browse
       LOCAL oBrowse := NIL                 // Browse de Alumnos

       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL cNomEst := ''                  // Nombre del Estudiante
       LOCAL cCodGru := ''                  // C¢digo del Grupo
       LOCAL cNotCli := ''                  // Nota del Cliente
       LOCAL cTxtTem := ''                  // Texto Temporal

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
      bCodF03 := SETKEY(K_F3)

      SETKEY(K_F3,NIL)
*>>>>FIN DESACTIVACION DE LAS TECLAS DE FUNCION

*>>>>ANALISIS DEL COLOR
       Colores(xColores(IF(!EMPTY(xClrSys),xClrSys[7],'')),;
	       @cSayTxt,@cSayDat,@cClrMar,@cClrTit)
*>>>>IF ANALISIS DEL COLOR

*>>>>IMPRESION DEL NOMBRE
       cSavPan := SAVESCREEN(0,0,24,79)
       nNroFil := nMarco(03,'AUSENCIAS DEL PROFESOR',22,'°',;
			 cClrMar+','+cClrTit)

       nNroCol := 1
       @ nNroFil,nNroCol+00 SAY 'CODIGO: '+PRO->cCodigoPro
       cSay(nNroFil,nNroCol,'CODIGO:',PRO->cCodigoPro)

       cSay(nNroFil,nNroCol+15,'NOMBRE:',RTRIM(PRO->cApelliPro)+' '+;
					       PRO->cNombrePro)
*>>>>FIN IMPRESION DEL NOMBRE

*>>>>ANALISIS SI EL ESTUDIANTE ESTA RETIRADO
       IF PRO->lRetiroPro
	  SET COLOR TO G*
	  @ nNroFil+1,nNroCol+23 SAY 'RETIRADO'
	  SetClrTo()
       ENDIF
*>>>>FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO

*>>>>BROWSE DE LAS AUSENCIAS
       cTitSup := '<< AUSENCIAS DEL PROFESOR >>'
      *ÀT¡tulo Superior del Browse

       aCampos := {{{"F. INGRESO","dFecIngNov"},{NIL}},;
		   {{"H. INGRESO","cHorIngNov"},{NIL}},;
		   {{"F. SALIDA","dFecOutNov"},{NIL}},;
		   {{"H. SALIDA","cHorOutNov"},{NIL}}}
     *ÀDefinici¢n de Campos

       cTitInf := '<ESC>Abandona'
      *ÀT¡tulo Inferior del Browse

       oBrowse := oBrowse(04,00,22,79,cTitSup,cTitInf,aCampos)
     *Creaci¢n del Browse
*>>>>FIN BROWSE DE LAS AUSENCIAS

*>>>>IMPRESION DE LOS TITULOS
       cCodPro := PRO->cCodigoPro

       SELECT NOV
       SET FILTER TO NOV->cCodPnlNov == cCodPro .AND. NOV->cTipPerNov == '02'
       NOV->(DBGOTOP())

       IF NOV->(EOF())
	  cError('AL PROFESOR NO LE FIGURAN NOVEDADES DE ASISTENCIAS')
       ELSE
	  NOV->(CtrlBrw(lShared,oBrowse))
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)

       SETKEY(K_F3,bCodF03)
       RETURN NIL
*>>>>FIN IMPRESION DE LOS DATOS