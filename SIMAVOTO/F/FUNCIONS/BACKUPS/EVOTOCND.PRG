/*************************************************************************
* TITULO..: MANTENIMIENTO DEL ARCHIVO                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: feb 17/2009 DIA A
       Colombia, Bucaramanga        INICIO:  10:15 AM  feb 17/2009 DIA

OBJETIVOS:

1- Permite el mantenimiento del archivo

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenCnd(aP1,aP2,aP3,aArchvo,cOpcPrn,nCodPrn,;
		   lModReg,lDelReg,lInsReg,lHaySql,bInsReg,;
		   lVotEst)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       aArchvo                              // Archivos en Uso
       cOpcPrn                              // Opciones de Impresi¢n
       nCodPrn                              // C¢digo de Impresi¢n 
       lModReg                              // .T. Modificar el Registro
       lDelReg                              // .T. Borrar Registros
       lInsReg                              // .T. Insertar Registro
       lHaySql                              // .T. Exportar a Sql
       bInsReg                              // Insertar Registros
       lVotEst                              // Votaciones .T. Estudiantes .F. Profesores */
*>>>>FIN DESCRIPCION DE PARAMETROS

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
       LOCAL cJornad := xPrm(aP1,'cJornad') // Jornadas habilitadas
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>DECLARACION DE VARIABLES
       #INCLUDE 'inkey.ch'                  // Declaraci¢n de teclas

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL       i := 0                   // Contador
       LOCAL lHayPrn := .F.                 // .T. Hay Archivo de Impresi¢n
       LOCAL aUseDbf := {}                  // Archivos en Uso
       LOCAL fArchvo := ''                  // Nombre del Archivo
       LOCAL fNtxArc := ''                  // Archivo Indice
       LOCAL cNalias := ''                  // Alias del Archivo

       LOCAL cTitSup := ''                  // T¡tulo Superior del Browse
       LOCAL cTitInf := ''                  // T¡tulo Inferior del Browse
       LOCAL bBrwIns := NIL		    // Insertar Registros en Browse
       LOCAL oBrowse := NIL                 // Browse
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       FOR i := 1 TO LEN(aArchvo)
           fArchvo := aArchvo[i,1]
           fNtxArc := aArchvo[i,2]
           cNalias := aArchvo[i,3]
           AADD(aUseDbf,{.T.,fArchvo,cNalias,fNtxArc,lShared,nModCry})
           IF cNalias == 'PRN'
              lHayPrn := .T.
           ENDIF
       ENDFOR
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
          cError('ABRIENDO EL ARCHIVO')
          CloseAll()
          RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>LOCALIZACION DE LA IMPRESORA
       IF lHayPrn
          IF !lLocCodigo('nCodigoPrn','PRN',nCodPrn)
             cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
             CloseAll()
             RETURN NIL
          ENDIF
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>PARAMETROS POR DEFECTO
       lModReg := IF(EMPTY(lModReg),.F.,lModReg)
       lModReg := IF(lModReg .AND. CND->(RECCOUNT())==0,.F.,lModReg)

       lDelReg := IF(lDelReg==NIL,.F.,lDelReg)

       lInsReg := IF(lInsReg==NIL,.F.,lInsReg)

       lHaySql := IF(lHaySql==NIL,.F.,lHaySql)
*>>>>FIN PARAMETROS POR DEFECTO

*>>>>INSERCION DE REGISTROS
       IF !EMPTY(bInsReg)
	  EVAL(bInsReg)
       ENDIF
*>>>>FIN INSERCION DE REGISTROS

*>>>>BROWSE DEL ARCHIVO
       cTitSup := '<< CANDIDATOS. '+IF(lVotEst,'ESTUDIANTES','PROFESORES')+'>>'
       cTitInf := '<F2>Consultar <F5>Buscar'+;
		   IF(lModReg,' <F4>Actualizar','')+' <F9>Otros'+;
		   IF(lDelReg,' <DEL>Borrar','')+;
		   IF(lInsReg,' <INS>Incluir','')

       bBrwIns := {||InsertCnd(aP1,lVotEst)}
       oBrowse := oBrwDbfCnd(lShared,cNomUsr,cAnoUsr,03,00,22,79,;
			     cTitSup,cTitInf,;
			     lModReg,lDelReg,lInsReg,lHaySql,bBrwIns,;
			     lVotEst,cMaeAlu)
*>>>>FIN BROWSE DEL ARCHIVO

*>>>>MANTENIMIENTO DEL ARCHIVO
       SETKEY(K_F2,{||lManRegCnd(lShared,cNomUsr,3,oBrowse)})
     *ÀConsulta

       IF lModReg
	  SETKEY(K_F4,{||lManRegCnd(lShared,cNomUsr,2,oBrowse,;
				    CND->cCodigoEle)})
       ENDIF
     *ÀActualizar

       SETKEY(K_F5,{||BuscarCnd(oBrowse)})

       SETKEY(K_F9,{||MenuOtrCnd(aP1,aP2,aP3,;
				 aArchvo,cOpcPrn,nCodPrn,lModReg,;
                                 lDelReg,lInsReg,lHaySql,oBrowse)})

       CND->(CtrlBrw(lShared,oBrowse))

       SETKEY(K_F2,NIL)
       SETKEY(K_F4,NIL)
       SETKEY(K_F5,NIL)
       SETKEY(K_F9,NIL)
       CloseAll()
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO..: DEFINICION DEL OBJETO BROWSE                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: feb 17/2009 DIA A
       Colombia, Bucaramanga        INICIO:  10:15 AM  feb 17/2009 DIA

OBJETIVOS:

1- Define el objeto Browse del archivo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oBrwDbfCnd(lShared,cNomUsr,cAnoUsr,nFilSup,nColSup,nFilInf,nColInf,;
		    cTitSup,cTitInf,lModReg,lDelReg,lInsReg,lHaySql,bBrwIns,;
		    lVotEst,cMaeAlu)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del Usuario
       nFilSup                              // Fila Superior
       nColSup                              // Columna Superior
       nFilInf                              // Fila Inferior
       nColInf                              // Columna Inferior
       cTitSup                              // T¡tulo Superior del Browse
       cTitInf                              // T¡tulo Inferior del Browse
       lModReg                              // .T. Modificar el Registro
       lDelReg                              // .T. Borrar Registros
       lInsReg                              // .T. Insertar Registros
       lHaySql                              // .T. Exportar a Sql
       bBrwIns				    // Insertar Registros en Browse
       lVotEst                              // Votaciones .T. Estudiantes .F. Profesores
       cMaeAlu                              // Maestros habilitados */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Objeto Columna
       LOCAL oBrowse := NIL                 // Browse del Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrowse := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'

       IF lInsReg
	  oBrowse:Cargo := {cTitSup,cTitInf,bBrwIns}
       ELSE
          oBrowse:Cargo := {cTitSup,cTitInf}
       ENDIF
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT CND
       oColumn := TBCOLUMNNEW('CODIGO;ELECCION',{||CND->cCodigoEle})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','CND'},;
			 {'FIELD','cCodigoEle'},{'PICTURE','@!S76'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('NUMERO',{||CND->cCodigoCnd})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','CND'},;
			 {'FIELD','cCodigoCnd'},{'PICTURE','@!S76'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('CODIGO;ESTUDIANTE',{||CND->cCodigoEst})
       oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','CND'},;
			 {'FIELD','cCodigoEst'},{'PICTURE','@!S76'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       IF lVotEst
	  oColumn := TBCOLUMNNEW('CURSO',{||CND->cCodigoGru})
	  oColumn:Cargo := {{'MODI',lModReg},{'ALIAS','CND'},;
			    {'FIELD','cCodigoGru'},{'PICTURE','@!S76'}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF

       IF lVotEst
	  oColumn := TBCOLUMNNEW('NOMBRE DEL ESTUDIANTE',;
				 {||cSekNomAlu(CND->cCodigoEst,;
					       cMaeAlu,'CND',.F.)})
       ELSE
	  oColumn := TBCOLUMNNEW('NOMBRE DEL PROFESOR',;
				 {||cSekNomPro(CND->cCodigoEst,'CND')})
       ENDIF
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('TOTAL VOTOS',{||CND->nTotVotEle})
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS','CND'},;
			 {'FIELD','nTotVotEle'},{'PICTURE','9999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna


       oColumn	     := TBCOLUMNNEW('NOMBRE;DEL USUARIO',{||CND->cNomUsrCnd})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FECHA DE;PROCESO',;
				    {||cFecha(CND->dFecUsrCnd)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('HORA DE;PROCESO',;
				    {||cHoraSys(CND->cHorUsrCnd)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO',{||CND->nIdeCodCnd})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('No.',{||CND->(RECNO())})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO..: INCLUSION DE CANDIDATOS           	                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 16/2001 VIE A
       Colombia, Bucaramanga        INICIO: 11:00 AM   FEB 16/2001 VIE

OBJETIVOS:

1- Incluye un registro al archivo

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION InsertCnd(aP1,lVotEst)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       lVotEst                              // Votaciones .T. Estudiantes .F. Profesores */
*>>>>FIN DESCRIPCION DE PARAMETROS

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
       LOCAL cJornad := xPrm(aP1,'cJornad') // Jornadas habilitadas
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "CAMPOS\ARC-VOT.PRG"       // Archivos del Sistema

       LOCAL       i := 0                   // Contador
       LOCAL nNroFil := 3                   // Fila de Lectura
       LOCAL nNroCol := 2                   // Columna de Lectura
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lGrabar := .F.                 // .T. Grabar registro
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTcn := ''               // C¢digo del Candidato
       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
       LOCAL cCodigoTel := ''               // C¢digo de Elecci¢n
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>LECTURA Y CONFIRMACION DEL REGISTRO
       SET CURSOR ON
       nNroFil := nMarco(nNroFil,'POR FAVOR DIGITE LOS CANDIDATOS',22,'°')
       DO WHILE .T.

**********INICIALIZACION DE LAS VARIABLES
	    IF !lHayErr
	       cCodigoTcn := cSpaces('CND','cCodigoCnd')
	       cCodigoTes := cSpaces('CND','cCodigoEst')
	       cCodigoTel := cSpaces('CND','cCodigoEle')
	    ENDIF
**********FIN INICIALIZACION DE LAS VARIABLES

**********LECTURA DEL REGISTRO
	    @ nNroFil+0,nNroCol SAY 'CANDIDATO PARA       :';
				GET cCodigoTel PICT '99';
				VALID lValEle(ROW(),COL()-1,@cCodigoTel)

	    @ nNroFil+1,nNroCol SAY 'CODIGO DEL CANDIDATO :';
				GET cCodigoTcn PICT '999';
				VALID !lValCodCnd(cCodigoTcn,cCodigoTel)

	    @ nNroFil+2,nNroCol SAY 'CODIGO DEL '+;
				    IF(lVotEst,'ESTUDIANTE:','PROFESOR:');
				GET cCodigoTes PICT '999999'
	    READ
**********FIN LECTURA DEL REGISTRO

**********VALIDACION DEL REGISTRO
	    lGrabar := .F.
	    DO CASE
	    CASE (EMPTY(cCodigoTcn) .OR. EMPTY(cCodigoTel)) .OR.;
		 (VAL(cCodigoTcn) # 0 .AND. EMPTY(cCodigoTes))

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

*>>>>BUSQUEDA DEL CODIGO DEL ESTUDIANTE
       cCodigoTgr := ''
       IF !EMPTY(cCodigoTes)
	  IF lVotEst
	     IF lSekCodMae(cCodigoTes,cMaeAlu,@cMaeAct)
		cCodigoTgr := &cMaeAct->cCodigoGru
	     ENDIF
	  ELSE
	     IF lLocCodigo('cCodigoPro','PRO',cCodigoTes)
		cCodigoTgr := SPACE(04)
	     ENDIF
	  ENDIF
       ELSE
	  cCodigoTes := 'BLANCO'
       ENDIF
*>>>>FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

*>>>>GRABACION DEL REGISTRO
       SELECT CND
       IF lGrabar
	  IF (VAL(cCodigoTcn) # 0 .AND. !EMPTY(cCodigoTes)) .OR.;
	     (VAL(cCodigoTcn) == 0 .AND. cCodigoTes == 'BLANCO' .AND.;
	      ELE->nValidaEle == 0)

	      IF CND->(lRegLock(lShared,.T.))
		 REPL CND->cCodigoCnd WITH cCodigoTcn
		 REPL CND->cCodigoEst WITH cCodigoTes
		 REPL CND->cCodigoGru WITH cCodigoTgr
		 REPL CND->cCodigoEle WITH cCodigoTel
		 CND->(DBCOMMIT())
	      ENDIF
	      IF lShared
		 CND->(DBUNLOCK())
	      ENDIF

	  ENDIF
       ENDIF
*>>>>FIN GRABACION DEL REGISTRO

*>>>>GRABACION DE LOS VOTOS EN BLANCO
       IF lGrabar .AND. VAL(cCodigoTcn) == 0 .AND.;
	  cCodigoTes == 'BLANCO' .AND. lVotEst

	  FOR i := 1 TO LEN(cMaeAlu)/3

	      CloseDbf('NIV')
	      CloseDbf('GRU')
	      cMaeAct := SUBS(cMaeAlu,i*3-2,3)
	      DO CASE
	      CASE ELE->nValidaEle == 1

*******************VOTOS EN BLANCO PARA LOS NIVELES
		     IF lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
				    FileNiv+cAnoSis+ExtFile,'NIV',;
				    NIL,lShared,nModCry)

			SELECT NIV
			DO WHILE .NOT. NIV->(EOF())

			   SELECT CND
			   IF CND->(lRegLock(lShared,.T.))
			      REPL CND->cCodigoCnd WITH cCodigoTcn
			      REPL CND->cCodigoEst WITH cCodigoTes
			      REPL CND->cCodigoGru WITH NIV->cCodigoNiv+'00'
			      REPL CND->cCodigoEle WITH cCodigoTel
			      CND->(DBCOMMIT())
			   ENDIF
			   IF lShared
			      CND->(DBUNLOCK())
			   ENDIF

			   SELECT NIV
			   NIV->(DBSKIP())

			ENDDO

		     ELSE
			cError('ABRIENDO EL ARCHIVO DE NIVELES')
		     ENDIF
*******************FIN VOTOS EN BLANCO PARA LOS NIVELES

	      CASE ELE->nValidaEle == 2

*******************VOTOS EN BLANCO PARA LOS GRUPOS
		     IF lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
				FileGru+cMaeAct+cAnoSis+ExtFile,;
				'GRU',NIL,lShared,nModCry)

			SELECT GRU
			DO WHILE .NOT. GRU->(EOF())

			   SELECT CND
			   IF CND->(lRegLock(lShared,.T.))
			      REPL CND->cCodigoCnd WITH cCodigoTcn
			      REPL CND->cCodigoEst WITH cCodigoTes
			      REPL CND->cCodigoGru WITH GRU->cCodigoGru
			      REPL CND->cCodigoEle WITH cCodigoTel
			      CND->(DBCOMMIT())
			   ENDIF
			   IF lShared
			      CND->(DBUNLOCK())
			   ENDIF

			   SELECT GRU
			   GRU->(DBSKIP())
			ENDDO

		     ELSE
			cError('ABRIENDO EL ARCHIVO DE NIVELES')
		     ENDIF
*******************FIN VOTOS EN BLANCO PARA LOS GRUPOS

	      ENDCASE
	  ENDFOR

       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DE LOS VOTOS EN BLANCO