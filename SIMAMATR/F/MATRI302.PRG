/* SIMA - MATRICULA ACADEMICA

MODULO      : CITACION
SUBMODULO...: CONSULTA               MODULO No. 302

**************************************************************************
* NOMBRE DEL PROGRAMA..: MATRI302.PRG                                    *
* TITULO DEL PROGRAMA..: CONSULTA DE EXAMENES                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 03/96 MIE A
       Colombia, Bucaramanga        INICIO: 10:20 PM   ENE 03/96 MIE


REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Permite permite consultar las candidatos citados para entrevistas

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_302(aParam1,aParam2,aParam3)

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
       IF !lUseDbf(.T.,PathSis+'\'+fSimMtr,'MTR',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
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
       CASE MTR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

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

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',MTR->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>ANALISIS DE LA ACTIVACION DE LOS EXAMENES
       IF !ANO->lHayEntAno
	  cError('NO ESTA HABILITADA LA OPCION PARA ENTREVISTAS')
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
       oConsul := oDefExamen(nFilPal+1,00,22,79,nNroIns)
       SETKEY(K_F5,{||BuscarAdm(oConsul)})
       SETKEY(K_F9,{||nCopiasExa(10,30,oConsul,cNomEmp,;
				 cNomSis,cAnoUsr,cMaeAlu)})
       ADM->(CtrlBrw(lShared,oConsul))
       SETKEY(K_F5,NIL)
       SETKEY(K_F9,NIL)
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
       Colombia, Bucaramanga        INICIO: 10:25 PM   ENE 03/96 MIE

OBJETIVOS:

1- Define el objeto Browse del examenes

2- Debe estar en uso el archivo de Admisiones

SINTAXIS:

 oConsul := oDefExamen(00,00,24,79,'94')

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefExamen(nFilSup,nColSup,nFilInf,nColInf,nNroIns)

*>>>>PARAMETROS DE LA FUNCION
/*     nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       nNroIns			            // N£mero de Inscritos */
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
       oConsul:Cargo     := {'<<  CONSULTA CANDIDATOS A ENTREVISTAR. '+;
			     'TOTAL = '+STR(nNroIns,4)+'  >>',;
			    '<F5>Buscar  <F9>Imprimir <ESC>Abandonar'}
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

       oColumn	     := TBCOLUMNNEW('FECHA CITA',{||ADM->dFecEntAdm})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ADM'},;
			 {'FIELD','dFecEntAdm'}, {'PICTURE','@D'}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('HORA CITA',{||ADM->cHorEntAdm})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','ADM'},;
			 {'FIELD','cHorEntAdm'}, {'PICTURE','@9'}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oConsul
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO DE LA FUNCION..: IMPRESION DE N COPIAS                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 03/96 MIE A
       Colombia, Bucaramanga        INICIO: 10:30 PM   ENE 03/96 MIE

OBJETIVOS:

1- Debe estar en uso el archivo de admisiones

2- Permiter imprimir por niveles varias copias de los candidatos a
   entrevistas.

3- La funci¢n esta dise¤ada para ejecutar dentro del browse del archivo

4- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nCopiasExa(nNroFil,nNroCol,oObject,cNomEmp,cNomSis,cAnoUsr,cMaeAlu)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de impresi¢n
       nNroCol                              // Columna de impresi¢n
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del sistemas
       oObject                              // Objeto en el que se ejecuta
       cAnoUsr                              // A¤o del usuario
       cMaeAlu                              // Maestro Habilitados */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroNiv := 0                   // N£mero Nivel
       LOCAL cNivIni := 0                   // Nivel Inicial
       LOCAL cNivFin := 0                   // Nivel Final
       LOCAL nCopias := 0                   // N£meros de copias a imprimir
       LOCAL nNroCop := 1                   // N£mero de copia
       SET CURSOR ON
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE LOS NIVELES A IMPRIMIR
       @ nNroFil,nNroCol TO nNroFil+4,nNroCol+17 DOUBLE
      *Marco de captura
       IF !lLeeNivels(nNroFil+1,nNroCol+1,@cNivIni,@cNivFin,@nCopias,cMaeAlu)
	  SELECT ADM
	  GO TOP
	  oObject:GOTOP()
	  RETURN NIL
       ENDIF
       nNroNiv := VAL(cNivIni)
*>>>>FIN LECTURA DE LOS NIVELES A IMPRIMIR

*>>>>IMPRESION DEL INFORME
       DO WHILE nNroNiv <= VAL(cNivFin)

**********FILTRACION DEL MAESTRO
	    SET FILTER TO VAL(SUBS(ADM->cCodigoGru,1,2)) == nNroNiv
	    GO TOP
	    IF EOF()
	       cError('PARA '+cNomNiv(nNroNiv)+' NO HAY INSCRITOS')
	       nNroCop := nCopias+1
	    ENDIF
**********FIN FILTRACION DEL MAESTRO

**********IMPRESION DE N COPIAS
	    DO WHILE nNroCop <= nCopias

*--------------IMPRESION DE LA LINEA DE ESTADO
		 LineaEstado('IMPRIMIENDO NIVEL: '+STR(nNroNiv,2)+'º'+;
			     'HASTA NIVEL: '+cNivFin+;
			     'ºNRO COPIAS:'+STR(nNroCop,2)+' DE:'+;
			     STR(nCopias,2)+'ºPOR FAVOR ESPERE ...',cNomSis)
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

	       PrnSiExam2(nNroNiv,cNomEmp,cNomSis,cAnoUsr)
	      *Impresion de la lista por niveles

	       nNroCop++

	    ENDDO
**********FIN IMPRESION DE N COPIAS

	  nNroNiv++
	  nNroCop := 1

       ENDDO
       SET CURSOR OFF
       SELECT ADM
       SET FILTER TO
       GO TOP
       oObject:GOTOP()
       RETURN NIL
*>>>>FIN IMPRESION DEL INFORME


/*************************************************************************
* TITULO DE LA FUNCION..: IMPRESION DE LOS CANDITOS A ENTREVISTAS        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 03/96 MIE A
       Colombia, Bucaramanga        INICIO: 10:35 PM   ENE 03/96 MIE

OBJETIVOS:

1- Imprime la relaci¢n de candidatos a entrevistas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnSiExam2(nNroNiv,cNomEmp,cNomSis,cAnoUsr)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroNiv                              // N£mero de nivel
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del sistema
       cAnoUsr                              // A¤o del usuario */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"

       LOCAL aNroCol := {}                 // Columnas para el informe
       LOCAL aTitulo := {}                 // T¡tulos para el informe
       LOCAL cTxtPrn := ''                 // Texto de impresi¢n
       LOCAL nLenPrn := 0                  // Longitud de impresi¢n
       LOCAL nNumero := 1                  // Contador de alumnos
       LOCAL nNroPag := 1                  // N£mero de p gina
       LOCAL nTotReg := 0                  // Total registros a imprimir
       LOCAL cTotPag := 0                  // Total p ginas a imprimir
       LOCAL lPagina := .T.                // .T. Cambio de p gina

       LOCAL cNombreTes := ''              // Nombre del Estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VARIABLES PARA EL ENCABEZADO DEL INFORME
       COUNT FOR VAL(SUBS(ADM->cCodigoGru,1,2)) == nNroNiv .AND.;
			  ADM->lEntrevAdm .AND. !ADM->lSiCupoEst;
			  TO nTotReg
      *Total de registros a imprimir
*>>>>FIN VARIABLES PARA EL ENCABEZADO DEL INFORME

*>>>>VALIDACION DE LA ASIGNACION DE CITAS
       IF nTotReg == 0
	  cError('PARA '+cNomNiv(nNroNiv)+' NO HAY CITADOS A ENTREVISTAS')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE LA ASIGNACION DE CITAS

*>>>>ACTIVACION DE LA IMPRESORA
       IF !Printer_on(MTR->lPrnArcMtr)
	   RETURN NIL
       ENDIF
       @ PROW(),00 SAY INICIALIZA
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT ADM
       GO TOP
       DO WHILE .NOT. ADM->(EOF()) .AND. nTotReg # 0

**********IMPRESION DE LOS ENCABEZADOS
	    IF lPagina

*--------------ENCABEZADO DEL INFORME
		 EncabezPrn(cNomEmp,cNomSis,;
			    'RELACION DE CANDIDATOS PARA ENTREVISTAS '+;
			    cAnoUsr,;
			    cNomNiv(nNroNiv),;
			    '',;
			    nNroPag++,;
			    cTotPagina(nTotReg))
*--------------FIN ENCABEZADO DEL INFORME

*--------------ENCABEZADOS DE COLUMNA
		 aNroCol := {04,06,40,08}
		 aTitulo := {'No. ',;
			     'CODIGO',;
			     'APELLIDOS Y NOMBRES ','PADRES'}
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
*--------------FIN ENCABEZADOS DE COLUMNA

*--------------IMPRESION DEL ENCABEZADO DE COLUMNA
		 nLenPrn := n12Stan
		 @ PROW(),00 SAY DRAFT_ON+ELITE
		 @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY REPL('-',LEN(cTxtPrn))
		 @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn
		 @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY REPL('-',LEN(cTxtPrn))
		 @ PROW()  ,00 SAY NEGRA_OF+DOBGOL_OF
*--------------FIN IMPRESION DEL ENCABEZADO DE COLUMNA

	    ENDIF
**********FIN IMPRESION DE LOS ENCABEZADOS

**********IMPRESION DEL CONTENIDO DEL INFORME
	    IF ADM->lEntrevAdm .AND. !(ADM->lSiCupoEst)
	       cNombreTes = RTRIM(ADM->cApelliEst)+' '+;
				  ADM->cNombreEst+SPACE(10)

	       aNroCol := {04,06,40,08}
	       aTitulo := {STR(nNumero++,4),;
			   ADM->cNumeroAdm,;
			   SUBS(cNombreTes,1,40),;
			   IF (ADM->lExAlumAdm,'EXALUMNO',SPACE(08))}

	       cTxtPrn := cRegPrint(aTitulo,aNroCol)
	      *Prepara la variable de impresion

	       @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn
	    ENDIF
**********FIN IMPRESION DEL CONTENIDO DEL INFORME

**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > 58
	       DerechosPrn(cNomSis,cNomEmp,n17Stan)
	       EJECT
	       lPagina := .T.
	    ELSE
	       lPagina := .F.
	    ENDIF
**********FIN ANALISIS PARA EL CAMBIO DE PAGINA

	  ADM->(DBSKIP())

       ENDDO
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
       IF nTotReg # 0
	  DerechosPrn(cNomSis,cNomEmp,n17Stan)
	  @ PROW()-PROW(),00 SAY ' '
	 *Saca la ultima linea
      ENDIF
      SET DEVICE TO SCREEN
      RETURN NIL
*>>>>FIN IMPRESION DERECHOS