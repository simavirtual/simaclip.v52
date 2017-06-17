/*                     SISTEMA CONTABILIDAD ACADEMICA
	    BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO PLAN DE ESTUDIOS

REQUERIMIENTOS:

- Compilar: clipper FuncsPla /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo plan acad‚mica

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO..: CREACION DE LA ESTRUCTURA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 03/95 MIE A
       Colombia, Bucaramanga        INICIO: 01:30 PM   MAY 03/95 MIE

OBJETIVOS:

1)- Crea la estructura del archivo Plan Acad‚mico

2)- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfPla(PathPla,FilePla,cCodGru,aStrDbf)

*>>>>DESCRIPCION DE PARAMETROS
/*     PathPla				    // Path del Archivo
       FilePla				    // Nombre del Archivo
       cCodGru                              // Codigo del Nivel o Grupo
       aStrDbf                              // Estructura del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lShared := .T.                 // .T. Archivo Compartido
       LOCAL PathAct := ''                  // Path Actual
       LOCAL aDbfStr := {}                  // Estructura del Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE LA ESTRUCTURA
       AADD(aDbfStr,{"cCodigoMat","Character",04,0}) // C¢digo de la materia
       AADD(aDbfStr,{"cIntHorPla","Character",02,0}) // Intensidad Horaria
       AADD(aDbfStr,{"cIntCerPla","Character",02,0}) // Intensidad Horaria para el Certificado
       AADD(aDbfStr,{"nPorcenPla","Numeric"  ,02,0}) // Porcentaje para la evaluaci¢n
       AADD(aDbfStr,{"cTipArePla","Character",01,0}) // Area o Materia
       AADD(aDbfStr,{"nNroOrdPla","Numeric"  ,02,0}) // Orden en el Boletin
*      AADD(aDbfStr,{"nRegOrdPla","Numeric"  ,02,0}) // N£mero del Registro a Ordenar
       AADD(aDbfStr,{"lHayNotPla","Logical"  ,01,0}) // .T. La materia o arae se califica
       AADD(aDbfStr,{"cHayNotPla","Character",05,0}) // El Area o Asignatura lleva Nota. Ej: '11111' 1:Con Nota 0:Sin Nota
       AADD(aDbfStr,{"cPrnNotPla","Character",05,0}) // Imprimir la Nota en el Boletin. Ej: '0000'  1:Si  0:No
       AADD(aDbfStr,{"cPrnBolPla","Character",06,0}) // No Imprimir la Materia en el Boletin. Ej: 1:No Imprime  0:Si Imprime P1,P2,P3,P4,P5,LF
       AADD(aDbfStr,{"lCertifPla","Logical"  ,01,0}) // .T. Entra en el certificado de notas
       AADD(aDbfStr,{"cMatCerPla","Character",04,0}) // C¢digo de la materia para el certificado
*>>>>FIN DECLARACION DE LA ESTRUCTURA

*>>>>ADICION DE CAMPOS SEGUN EL PLAN ACADEMICO
       SELECT GRU
       IF LEN(cCodGru) == 2

	  GO TOP
	  DO WHILE .NOT. EOF()
	     IF SUBS(GRU->cCodigoGru,1,2) == SUBS(cCodGru,1,2)
		AADD(aDbfStr,{"cPr"+GRU->cCodigoGru+"Pla","Character",06,0})
	     ENDIF
	     SKIP
	  ENDDO

       ELSE
	  AADD(aDbfStr,{"cPr"+cCodGru+"Pla","Character",06,0})
       ENDIF
*>>>>FIN ADICION DE CAMPOS SEGUN EL PLAN ACADEMICO

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
          aStrDbf := aDbfStr
          RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathPla) == 0
	    DBCREATE(FilePla,aDbfStr,"DBFNTX")

       CASE DIRCHANGE(PathPla) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathPla)

       CASE DIRCHANGE(PathPla) == -5
	    cError('NO TIENE DERECHOS EN: '+PathPla)
       ENDCASE

       DIRCHANGE(PathAct)
       RETURN NIL
*>>>>FIN CREACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION..: RECUPERACION DE LA ESTRUCTURA                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 03/95 MIE A
       Colombia, Bucaramanga        INICIO: 01:35 PM   MAY 03/95 MIE

OBJETIVOS:

1)- Recupera la estructura del archivo de Plan Acad‚mico

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfPla(PathPla,FilePla)

*>>>>PARAMETROS DE LA FUNCION
/*     PathPla			      // Path del Archivo
       FilePla			      // Nombre del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathPla+'\'+FilePla,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")
       Termometro(0,"CREANDO LA ESTRUCTURA DEL PLAN DE ESTUDIOS")
       Termometro(100)
       CreaDbfPla(PathPla,FilePla)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: VECTOR DE LA ESTRUCTURA                                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 11/2008 JUE A
       Colombia, Bucaramanga        INICIO:  09:45 AM  SEP 11/2008 JUE

OBJETIVOS:

1- Crea para accesar todos los campos de la tabla

2- Debe estar en uso el archivo

3- Retorna el vector

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aArrStrPla(cNalias)

*>>>>DESCRIPCION DE PARAMETROS
/*     cNalias                              // Alias del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cCodigo := ''                  // C¢digo del Campo
       LOCAL cCampos := ''                  // Campo de la Tabla
       LOCAL aCampos := {}                  // Campos de la Tabla
       LOCAL aStrDbf := {'1'}               // Estructura de la Tabla
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAMPOS DE LA TABLA
       cNalias := IF(EMPTY(cNalias),'PLA',cNalias)

       SELECT &cNalias
       aStrDbf := DBSTRUCT()

       FOR i := 1 TO LEN(aStrDbf)

	   cCampos := aStrDbf[i,1]
	   DO CASE
	   CASE LEN(cCampos) == 10
		cCodigo := SUBS(cCampos,1,7)
	   CASE LEN(cCampos) == 9
		cCodigo := SUBS(cCampos,1,7)
	   OTHERWISE
		cCodigo := 'Err'
		cError('EL CAMPO '+cCampos+' '+;
		       'NO CUMPLE LA NORMA DEL NOMBRE')
	   ENDCASE

	   AADD(aCampos,{cCodigo,&(cNalias+'->'+cCampos)})

       ENDFOR
       RETURN aCampos
*>>>>FIN CAMPOS DE LA TABLA

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDA LA EXISTENCIA DEL PLAN ACADEMICO        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 08/95 LUN A
       Colombia, Bucaramanga        INICIO: 12:15 AM   MAY 08/95 LUN

OBJETIVOS:

1- Se debe pasar solo un maestro habilitado

2- Valida la existencia de los archivos del plan acad‚mico para el
   correspondiente nivel.

3- Retorna .T. si existen los archivos o NIL si se paso mal el maestro

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lFilesPla(cPatSis,cAnoSis,cMaeAlu)

*>>>>PARAMETROS DE LA FUNCION
/*     cPatSis                              // Path del sistema
       cAnoSis                              // A¤o del Sistema
       cMaeAlu                              // Maestros habilitados */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL lExiste := NIL                // .T. Existen los archivos
       LOCAL cNroNiv := ''                 // N£mero de nivel
       LOCAL       i := 0                  // Contador
       SET FIXED OFF
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE EXISTENCIA DE LOS ARCHIVOS
       DO CASE
       CASE 'JAR' $ cMaeAlu
	    lExiste := .F.
	    FOR i := 12 TO 16
		FileTem := cPatSis+'\'+FilePla+PADL(i,2,'0')+cAnoSis+ExtFile
		IF FILE (FileTem)
		   lExiste := .T.
		ENDIF
	    ENDFOR

       CASE 'PRI' $ cMaeAlu
	    lExiste := .F.
	    FOR i := 0 TO 5
		FileTem := cPatSis+'\'+FilePla+PADL(i,2,'0')+cAnoSis+ExtFile
		IF FILE (FileTem)
		   lExiste := .T.
		ENDIF
	    ENDFOR

       CASE 'BTO' $ cMaeAlu
	    lExiste := .F.
	    FOR i := 6 TO 11
		FileTem := cPatSis+'\'+FilePla+PADL(i,2,'0')+cAnoSis+ExtFile
		IF FILE (FileTem)
		   lExiste := .T.
		ENDIF
	    ENDFOR

       ENDCASE
       SET FIXED ON
       RETURN lExiste
*>>>>FIN VALIDACION DE EXISTENCIA DE LOS ARCHIVOS

/*************************************************************************
* TITULO DE LA FUNCION..: LOCALIZAR EL CODIGO                   	 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 12/95 VIE A
       Bucaramanga, Colombia        INICIO: 11:30 AM   MAY 12/95 VIE

OBJETIVOS:

1- Debe estar en uso el archivo

2- Verifica la existencia del c¢digo

3- Deja el archivo en el registro del c¢digo si este existe.

4- Retorna .F. si no se presentaron problemas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lLocCodPla(cCodigo,lMensaj)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodigo				    // C¢digo a localizar
       lMensaj                              // .T. Mostrar mensaje error */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lExiste := .T.                 // .T. Existe el c¢digo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION DEL CODIGO
       lMensaj := IF(lMensaj == NIL,.T.,lMensaj)
       SELECT PLA
       GO TOP
       LOCATE FOR PLA->cCodigoMat == cCodigo
       IF .NOT. FOUND()
	  IF lMensaj
	     cError('LA MATERIA: '+cCodigo+' NO EXISTE')
	  ENDIF
	  lExiste := .F.
       ENDIF
       RETURN lExiste
*>>>>FIN LOCALIZACION DEL CODIGO

/*************************************************************************
* TITULO DE LA FUNCION..: MANTENIMIENTO DEL ARCHIVO          	         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 12/95 VIE A
       Colombia, Bucaramanga        INICIO: 11:32 AM   MAY 12/95 VIE

OBJETIVOS:

1- Permite el mantenimiento del archivo

2- Se debe pasar el directorio completo de archivo

3- Retorn NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenPla(aParam1,aParam2,aParam3,;
		   cCodGru)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       cCodGru                              // C¢digo del Grupo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cNroNiv := ''                  // N£mero del Nivel
       LOCAL cNomPla := ''                  // Nombre del Plan Academico
       LOCAL oBrowse := NIL                 // Objeto para el Browse
       LOCAL nNroGru := 0                   // N£mero de Grupos
       LOCAL fPlaNiv := ''                  // Plan por Nivel
       LOCAL fPlaGru := ''                  // Plan por Grupo
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
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>CREACION DEL NOMBRE DEL ARCHIVO DEL PLAN ACADEMICO
       cNroNiv := SUBS(cCodGru,1,2)
       IF LEN(cCodGru) == 4
	  fPlaGru := 'PL'+cCodGru+cAnoSis+ExtFile
	  fPlaNiv := 'PLAN'+cNroNiv+cAnoSis+ExtFile
	  FilePla := fPlaGru
	  cNomPla := cCodGru
       ELSE
	  fPlaNiv := 'PLAN'+cNroNiv+cAnoSis+ExtFile
	  fPlaGru := 'PL'+cNroNiv+'01'+cAnoSis+ExtFile
	  FilePla := fPlaNiv
	  cNomPla := cNomNiv(cNroNiv)
       ENDIF
*>>>>FIN CREACION DEL NOMBRE DEL ARCHIVO DEL PLAN ACADEMICO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimaCo,'SCO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FilePla,'PLA',NIL,lShared)
	  cError('ABRIENDO ARCHIVO DE PLAN DE ESTUDIOS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>LOCALIZACION DEL NIVEL
       IF !lLocCodigo('cCodigoNiv','NIV',cNroNiv)
	  cError('EL NIVEL '+cNroNiv+' NO EXISTE')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>LOCALIZACION DEL NIVEL

*>>>>LECTURA DEL TOTAL DE GRUPOS POR NIVEL
       IF LEN(cCodGru) == 4
	  nNroGru := 1
       ELSE
	  nNroGru := NIV->nNroGruNiv
	  IF EMPTY(nNroGru)
	     cError('NO ESTAN DEFINIDOS EL TOTAL DE GRUPOS EN NIVELES')
	     CLOSE ALL
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN LECTURA DEL TOTAL DE GRUPOS POR NIVEL

*>>>>MANTENIMIENTO DEL ARCHIVO
       oBrowse := oDefBrwPla(lShared,cAnoUsr,cPatSis,cMaeAct,fPlaNiv,;
			     fPlaGru,nFilPal+1,00,22,79,;
			     'PLAN DE ESTUDIOS DE '+cNomPla+'.',;
			     cNroNiv,nNroGru,cCodGru)
       SETKEY(K_F3,{||VerSubPlan(lShared,cCodGru,PLA->cCodigoMat)})
       SETKEY(K_F5,{||BuscarPla(oBrowse)})

       SETKEY(K_F9,{||MenuOtrPla(aParam1,aParam2,aParam3,;
				 cCodGru,oBrowse)})

       SETKEY(K_F12,{||lOrdPlan(lShared,cPatSis+'\'+cMaeAct+'\'+FilePla,oBrowse)})

       PLA->(CtrlBrw(lShared,oBrowse))
       SETKEY(K_F3,NIL)
       SETKEY(K_F5,NIL)
       SETKEY(K_F9,NIL)
       SETKEY(K_F12,NIL)
       CLOSE PLA
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: DEFINICION DEL OBJETO BROWSE          	 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 12/95 VIE A
       Colombia, Bucaramanga        INICIO: 11:37 AM   MAY 12/95 VIE

OBJETIVOS:

1- Define el objeto Browse del archivo

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwPla(lShared,cAnoUsr,cPatSis,cMaeAct,fPlaNiv,fPlaGru,nFilSup,;
		    nColSup,nFilInf,nColInf,cTitulo,cNroNiv,nNroGru,cCodGru)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cAnoUsr                              // A¤o del Usuario
       cPatSis                              // Path del sistema
       cMaeAct                              // Maestro Actual
       fPlaNiv                              // Plan por Nivel
       fPlaGru                              // Plan por Grupo
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       cTitulo                              // T¡tulo del Browse
       cNroNiv                              // N£mero del Nivel
       nNroGru                              // N£mero de grupos en el nivel
       cCodGru                              // C¢digo del Grupo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cNomNiv := ''                  // Nombre del nivel
       LOCAL cNroGru := ''                  // Grupo del Nivel
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrowse := NIL		    // Objeto Browse
       LOCAL cCampos := ''                  // Campos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrowse := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'

       DO CASE
       CASE cMaeAct == 'JAR'
	    cNomNiv := 'JARDIN'
       CASE cMaeAct == 'PRI'
	    cNomNiv := 'PRIMARIA'
       CASE cMaeAct == 'BTO'
	    cNomNiv := 'BACHILLERATO'
       ENDCASE

       cTitulo := IF(cTitulo == NIL,;
		     'MANTENIMIENTO DE PLAN DE ESTUDIOS DE',cTitulo)
       oBrowse:Cargo := {'<<'+cTitulo+' '+cNomNiv+' >>',;
			 '<INS>Incluir <F3>SubDivisi¢n <F5>Buscar '+;
			 '<DEL>Borrar '+'<F9>Otros ',;
			 {||IncluirPla(lShared,cAnoUsr,cPatSis,;
				       cMaeAct,fPlaNiv,fPlaGru)}}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT PLA
       oColumn	     := TBCOLUMNNEW('CODIGO',{||PLA->cCodigoMat})
       IF SCO->lModPlaCon
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PLA'},;
			    {'FIELD','cCodigoMat'},{'PICTURE','9999'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('AREAS Y MATERIAS',;
			     {||IIF(SUBS(PLA->cCodigoMat,3,2) == '00',;
			     cSekNomMat(PLA->cCodigoMat,'PLA'),;
			     '  '+cSekNomMat(PLA->cCodigoMat,'PLA'))})
       oColumn:Cargo := {{'MODI',.F.}}
       oColumn:Width := 32
       oBrowse:ADDCOLUMN(oColumn)
       oBrowse:Freeze:= 2
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('INTENSIDAD',{||PLA->cIntHorPla})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PLA'},{'FIELD','cIntHorPla'},;
			 {'PICTURE','@!'}}
       oColumn:Picture := "@!"
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('POR%',;
			      {||IIF(SUBS(PLA->cCodigoMat,3,2) # '00',;
					  PLA->nPorcenPla,'**')})

       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PLA'},{'FIELD','nPorcenPla'},;
			 {'PICTURE','99'}}
       oColumn:Picture := "99"
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TIPO',;
				  {||IIF(SUBS(PLA->cCodigoMat,3,2) == '00',;
					 IIF(PLA->cTipArePla == 'P',;
					     'PROMEDIABLE','NO PROMEDIO'),;
					 SPACE(11))})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('TIPO',{||PLA->cTipArePla})
       IF SCO->lModPlaCon
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PLA'},;
			    {'FIELD','cTipArePla'},{'PICTURE','@! XX'}}
       ELSE
	  oColumn:Cargo := {{'MODI',.F.}}
       ENDIF
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('ORDEN;BOLITIN',;
				 {||IIF(SUBS(PLA->cCodigoMat,3,2) == '00',;
					     PLA->nNroOrdPla,'**')})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PLA'},;
			 {'FIELD','nNroOrdPla'},{'PICTURE','99'}}
       oColumn:Picture := "99"
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('HAY NOTAS;DEFINITIVAS', {||PLA->cHayNotPla})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PLA'},{'FIELD','cHayNotPla'},;
			 {'PICTURE','99999'}}
       oColumn:Picture := "@!"
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('IMPRIMIR NOTA;DEFINITIVA', {||PLA->cPrnNotPla})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PLA'},;
			 {'FIELD','cPrnNotPla'}, {'PICTURE','99999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NO IMPRIMIR;EN BOLETIN',{||PLA->cPrnBolPla})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PLA'},;
			 {'FIELD','cPrnBolPla'}, {'PICTURE','999999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('ENTRA AL;CERTIFICADO', {||PLA->lCertifPla})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PLA'},{'FIELD','lCertifPla'},;
			 {'PICTURE','@!'}}
       oColumn:Picture := "@!"
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('INTENSIDAD;CERTIFICADO',;
			      {||IIF(SUBS(PLA->cCodigoMat,3,2) # '00' .OR. PLA->cTipArePla == 'N',;
					  PLA->cIntCerPla,'**')})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PLA'},{'FIELD','cIntCerPla'},;
			 {'PICTURE','@!'}}
       oColumn:Picture := "@!"
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MATERIA PARA;EL CERTIFICADO', {||PLA->cMatCerPla})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PLA'},{'FIELD','cMatCerPla'},;
			 {'PICTURE','9999'}}
       oColumn:Picture := "9999"
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       FOR i := 1 TO nNroGru

	   cNroGru := STR(i,2)
	   IF LEN(cCodGru) == 4
	      cNroGru := SUBS(cCodGru,3,2)  // Plan por Grupo
	   ELSE
	      lCorrecion(@cNroGru)          // Plan por Grado
	   ENDIF

	   cCampos := 'cPr'+cNroNiv+cNroGru+'Pla'
	   IF SCO->lAreProCon
	      oColumn := TBCOLUMNNEW(cNroNiv+cNroGru,{||&cCampos})
	      oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PLA'},;
				{'FIELD','CPR'+cNroNiv+cNroGru+'PLA'},;
				{'PICTURE','999999'}}

	   ELSE
	      oColumn := TBCOLUMNNEW(cNroNiv+cNroGru,{||&cCampos})
	      oColumn:Cargo := {{'MODI',.F.},{'ALIAS','PLA'},;
				{'FIELD','CPR'+cNroNiv+cNroGru+'PLA'},;
				{'PICTURE','999999'}}
	   ENDIF
	   oBrowse:ADDCOLUMN(oColumn)
	 *ÀDefinici¢n Columna

       ENDFOR

       oColumn	     := TBCOLUMNNEW('No.', {||PLA->(RECNO())})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO DE LA FUNCION..: INCLUCION DE UN REGISTRO          	         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 12/95 VIE A
       Colombia, Bucaramanga        INICIO: 11:50 AM   MAY 12/95 VIE

OBJETIVOS:

1- Incluye un registro al archivo

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION IncluirPla(lShared,cAnoUsr,cPatSis,cMaeAct,fPlaNiv,fPlaGru)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cAnoUsr                              // A¤o del Usuario
       cPatSis                              // Path del sistema
       cMaeAct                              // Maestro Actual
       fPlaNiv			            // Plan por Nivel
       fPlaGru                              // Plan por Grupos */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       LOCAL nNroFil := 3                   // Fila de Lectura
       LOCAL nNroCol := 2                   // Columna de Lectura
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lGrabar := .F.                 // .T. Grabar registro
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodAre    := ''               // C¢digo del area
       LOCAL cNomAre    := ''               // Nombre del area
       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL cNombreTma := ''               // Nombre de la materia
       LOCAL cIntHorTpl := ''               // Intensidad horaria
       LOCAL nNroOrdTpl := 0                // Orden para el boletin
       LOCAL cTipAreTpl := ''               // Tipo de area
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>LECTURA DEL PLAN ACADEMICO ANTERIOR
       IF PLA->(RECCOUNT()) == 0
	  IF lLeeMatPla(lShared,cAnoUsr,cPatSis,cMaeAct,fPlaNiv,fPlaGru)
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN LECTURA DEL PLAN ACADEMICO ANTERIOR

*>>>>LECTURA Y CONFIRMACION DEL REGISTRO
       SET CURSOR ON
       nNroFil := nMarco(nNroFil,'POR FAVOR ENTRE LOS DATOS DEL PLAN DE ESTUDIOS',22,'°')
       DO WHILE .T.

**********INICIALIZACION DE LAS VARIABLES
	    IF !lHayErr
	       cCodigoTma := cSpaField('PLA','cCodigoMat')
	       cIntHorTpl := cSpaField('PLA','cIntHorPla')
	       nNroOrdTpl := 0
	       cTipAreTpl := cSpaField('PLA','cTipArePla')
	    ENDIF
**********FIN INICIALIZACION DE LAS VARIABLES

**********LECTURA DEL REGISTRO
	    @ nNroFil+0,nNroCol SAY 'CODIGO DE LA MATERIA:';
				GET cCodigoTma PICT '9999';
				VALID lValCodPla(ROW(),COL()-4,@cCodigoTma)

	    @ nNroFil+1,nNroCol SAY 'INTENSIDAD          :';
				GET cIntHorTpl PICT '@!'

	    @ nNroFil+2,nNroCol SAY 'ORDEN EN EL BOLETIN :';
				GET nNroOrdTpl PICT '99'

	    @ nNroFil+3,nNroCol SAY 'TIPO DE LA MATERIA  :';
				GET cTipAreTpl PICT '@!';
				VALID lValTipAre(ROW(),COL()-1,@cTipAreTpl)
	    READ
**********FIN LECTURA DEL REGISTRO

**********VALIDACION DEL REGISTRO
	    lGrabar := .F.
	    DO CASE
	    CASE cCodigoTma == cSpaField('PLA','cCodigoMat') .OR.;
		 cTipAreTpl == cSpaField('PLA','cTipArePla')

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

*>>>>GRABACION DEL AREA
       SELECT PLA
       IF lGrabar .AND. !lLocCodPla(SUBS(cCodigoTma,1,2)+'00',.F.)
	  IF PLA->(lRegLock(lShared,.T.))
	     REPL PLA->cCodigoMat WITH SUBS(cCodigoTma,1,2)+'00'
	     REPL PLA->cIntHorPla WITH cIntHorTpl
	     REPL PLA->nNroOrdPla WITH nNroOrdTpl
	     REPL PLA->cTipArePla WITH cTipAreTpl
	     REPL PLA->lCertifPla WITH .F.
	     PLA->(DBCOMMIT())
	  ENDIF
       ENDIF
       IF lShared
	  PLA->(DBUNLOCK())
       ENDIF
*>>>>FIN GRABACION DEL CAMPO

*>>>>GRABACION DEL REGISTRO
       SELECT PLA
       IF cTipAreTpl == 'P'
	 IF lGrabar
	    IF PLA->(lRegLock(lShared,.T.))
	       REPL PLA->cCodigoMat WITH cCodigoTma
	       REPL PLA->cIntHorPla WITH cIntHorTpl
	       PLA->(DBCOMMIT())
	    ENDIF
	 ENDIF
	 IF lShared
	    PLA->(DBUNLOCK())
	 ENDIF
       ENDIF
       SELECT MAT
       SET FILTER TO
       SELECT PLA
       RETURN NIL
*>>>>FIN GRABACION DEL CAMPO

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION DEL CODIGO                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 12/95 VIE A
       Colombia, Bucaramanga        INICIO: 12:00 AM   MAY 12/95 VIE

OBJETIVOS:

1- Debe estar en uso el archivo

2- Realiza la validaci¢n del c¢digo

3- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValCodPla(nNroFil,nNroCol,cCodigo)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       cCodigo			            // @Codigo a validar */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL nNroReg := 0                   // N£mero del registro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO
       SELECT MAT
       IF !lLocCodigo('cCodigoMat','MAT',cCodigo)
	  lSelMateria(nNroFil,nNroCol,@nNroReg)
	  IF nNroReg == 0
	     cCodigo := cSpaField('PLA','cCodigoMat')
	  ELSE
	     GO nNroReg
	     cCodigo := MAT->cCodigoMat
	  ENDIF
       ENDIF

       SELECT PLA
       IF lLocCodPla(cCodigo,.F.)
	  cError('ESTE CODIGO YA EXISTE')
	  lHayErr := .T.
       ENDIF

       RETURN !lHayErr
*>>>>FIN VALIDACION DEL CODIGO

/*************************************************************************
* TITULO DE LA FUNCION..: BUSCAR EL CODIGO EN EL BROWSE                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 12/95 VIE A
       Colombia, Bucaramanga        INICIO: 12:01 AM   MAY 12/95 VIE

OBJETIVOS:

1- Localiza el c¢digo dentro del Browse del archivo

2- Retorna NIL

SINTAXIS:

  BuscarMat(oBrowse)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BuscarPla(oBrowse)

*>>>>PARAMETROS DE LA FUNCION
/*     oBrowse			      // Browse de Grupos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nNroReg := 0                   // N£mero del Registro
       LOCAL lBuscar := .T.                 // .T. Realizar la b£squeda
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTma := ''               // C¢digo de la materia
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA DEL CODIGO
       SET CURSOR ON
       cCodigoTma := cSpaField('PLA','cCodigoMat')
       TitBuscar(LEN(cCodigoTma),@nNroFil,@nNroCol)
       @ nNroFil,nNroCol GET cCodigoTma PICT '9999';
			 VALID lVerCodPla(ROW(),COL()-4,@cCodigoTma)
       READ
*>>>>FIN CAPTURA DEL CODIGO

*>>>>VALIDACION DEL CODIGO
       IF cCodigoTma == cSpaField('PLA','cCodigoMat')
	  cError('PATRON DE BUSQUEDA NO ESPECIFICADO',;
		  'ADVERTENCIA')
	  lBuscar := .F.
       ENDIF
*>>>>FIN VALIDACION DEL CODIGO

*>>>>BUSQUEDA DEL CODIGO
       SELECT PLA
       IF lBuscar .AND. lLocCodPla(cCodigoTma)
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
* TITULO DE LA FUNCION..: VERIFICAR CODIGO DEL PLAN ACADEMICO            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 12/95 VIE A
       Colombia, Bucaramanga        INICIO: 12:03 AM   MAY 12/95 VIE

OBJETIVOS:

1- Debe estar en uso el archivo

2- Realiza la validaci¢n del c¢digo

3- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lVerCodPla(nNroFil,nNroCol,cCodigo,nNroReg)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       cCodigo			            // @Codigo a validar
       nNroReg			            // @N£mero del Registro */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>VALIDACION DEL CODIGO DEL CONCEPTO
       IF !lLocCodigo('cCodigoMat','MAT',cCodigo)
	  lSelCodPla(nNroFil,nNroCol,@nNroReg)
	  IF nNroReg == 0
	     cCodigo := cSpaField('PLA','cCodigoMat')
	  ELSE
	     GO nNroReg
	     cCodigo := PLA->cCodigoMat
	  ENDIF
       ELSE
	  nNroReg := RECNO()
       ENDIF
       RETURN .T.
*>>>>FIN VALIDACION DEL CODIGO DEL CONCEPTO

/*************************************************************************
* TITULO DEL PROGRAMA..: SELECCION DEL CODIGO DEL PLAN                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 12/95 VIE A
       Colombia, Bucaramanga        INICIO: 12:05 AM   MAY 12/95 VIE

OBJETIVOS:

1- Debe estar en uso el archivo

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Permite escoger una materia determinada

4- Retorna .T. si escogio la materia

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lSelCodPla(nNroFil,nNroCol,nNroReg,cTitulo)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // N£mero de la fila
       nNroCol                              // N£mero de la Columna
       nNroReg		                    // @N£mero del registro escogido
       cTitulo                              // T¡tulo de lectura */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nFilSup := 0                   // Fila superior
       LOCAL nColSup := 0                   // Colunma superior
       LOCAL nFilInf := 0                   // Fila inferior
       LOCAL nColInf := 0                   // Columna inferior
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE ENCABEZADOS
       cTitulo := IF(cTitulo == NIL,'',cTitulo)
       @ nNroFil,nNroCol SAY cTitulo
*>>>>FIN IMPRESION DE ENCABEZADOS

*>>>>SELECCION DEL REGISTRO
	SELECT PLA
	nNroCol = nNroCol + LEN(cTitulo)
	nFilSup := nNroFil
	nColSup := nNroCol
	IF nFilSup+RECCOUNT() > 22
	   nFilInf := 21
	ELSE
	   nFilInf := nFilSup + RECCOUNT() - 1
	ENDIF
	nColInf := nColSup+LEN(PLA->cCodigoMat)+LEN(MAT->cNombreMat)+1

	PLA->(DBGOTOP())
	nNroReg := nBrowseDbf(nFilSup,nColSup,nFilInf,nColInf,;
			      {||PLA->cCodigoMat+' '+;
				 cSekNomMat(PLA->cCodigoMat,'PLA')})
	IF nNroReg == 0
	   RETURN .F.
	ENDIF
	PLA->(DBGOTO(nNroReg))
	@ nFilSup,nColSup SAY PLA->cCodigoMat
	RETURN .T.
*>>>>FIN SELECCION DEL REGISTRO

/*************************************************************************
* TITULO DE LA FUNCION..: DEFINICION DEL OBJETO BROWSE DE CARGAS	 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 15/95 LUN A
       Colombia, Bucaramanga        INICIO: 01:20 PM   MAY 15/95 LUN

OBJETIVOS:

1- Define el objeto Browse de la carga acad‚mica para el grupo escogido

2- Debe estar en uso el archivo de grupos en el registro del grupo escogido

3- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefCargas(lShared,nFilSup,nColSup,nFilInf,nColInf,cCodGru,cMaeAct)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       cCodGru                              // C¢digo del Grupo
       cMaeAct                              // Maestro Actual */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrowse := NIL		    // Objeto Browse

       LOCAL cNomCam := ''                  // Nombre del campo
       LOCAL lMatVarTma := .F.              // .T. Materia Variable
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       cNomCam := 'PLA->cPr'+cCodGru+'Pla'
       cSekNomPro(cNomCam,'PLA')

       oBrowse := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'

       oBrowse:Cargo := {'<< CARGA ACADEMICA PARA EL GRUPO '+;
			     GRU->cCodigoGru+' >>','<INS>Incluir Profesor '+;
			     '<F9>Imprimir <ESC>Abandonar',{||IncProPla(lShared,cMaeAct)}}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT PLA
       oColumn	     := TBCOLUMNNEW('MATERIA',;
				   {||PLA->cCodigoMat+' '+;
				      cSekNomMat(PLA->cCodigoMat,'PLA')})
       oColumn:Cargo := {{'MODI',.F.}}
       oColumn:Width := 35
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO', {||cCodProBrw(PLA->cCodigoMat,;
							    cCodGru,'PLA')})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PLA'},;
			 {'FIELD','cPr'+cCodGru+'Pla'},;
			 {'PICTURE','999999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('PROFESOR',;
			{||IF(lLocMatVar(PLA->cCodigoMat,'PLA'),;
			      'FIGURA EN SU RESPECTIVA SUBDIVISION',;
			      cSekNomPro(PLA->&('cPr'+cCodGru+'Pla'),'PLA'))})
       oColumn:Cargo := {{'MODI',.F.}}
       oColumn:Width := 51
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO DE LA FUNCION..: INCLUIR CODIGO PROFESOR EN CARGA ACADEMICA     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 15/95 LUN A
       Colombia, Bucaramanga        INICIO: 02:55 PM   MAY 15/95 LUN

OBJETIVOS:

1- Graba el c¢digo del profesor que dicta la materia

2- Debe estar en uso el archivo grupos en el registro escogido

3- Debe estar en uso el archivo profesor

4- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION IncProPla(lShared,cMaeAct)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // Archivos Compartidos
       cMaeAct                              // Maestro Actual */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE CONSTANTES
       LOCAL nNroFil := 3                   // Fila de Lectura
       LOCAL nNroCol := 2                   // Columna de Lectura
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL nPosIni := 0                   // Posici¢n Inicial
       LOCAL lGrabar := .F.                 // .T. Grabar registro
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTpr := ''               // C¢digo del profesor
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>LECTURA Y CONFIRMACION DEL REGISTRO
       SET CURSOR ON
       nNroFil := nMarco(nNroFil,'POR FAVOR ENTRE EL CODIGO DEL PROFESOR',22,'°')
       DO WHILE .T.

**********INICIALIZACION DE LAS VARIABLES
	    IF !lHayErr
	       cCodigoTpr := cSpaField('PRO','cCodigoPro')
	    ENDIF
**********FIN INICIALIZACION DE LAS VARIABLES

**********LECTURA DEL REGISTRO
	    @ nNroFil+0,nNroCol SAY 'CODIGO DEL PROFESOR :';
				GET cCodigoTpr PICT '999999';
				VALID lValProfes(ROW(),COL()-6,@cCodigoTpr)
	    READ
**********FIN LECTURA DEL REGISTRO

**********PREGUNTA DE DECISION
	    IF lPregunta('DESEA GRABAR EL REGISTRO? Si No')
	       EXIT
	    ENDIF
**********PREGUNTA DE DECISION

       ENDDO
*>>>>FIN LECTURA Y CONFIRMACION DEL REGISTRO

*>>>>GRABACION DEL REGISTRO
       SELECT PLA
       IF PLA->(lRegLock(lShared,.F.))
	  REPL PLA->&('cPr'+GRU->cCodigoGru+'Pla') WITH cCodigoTpr
	  PLA->(DBCOMMIT())
       ELSE
	  cError('NO SE GRABA LA CARGA DEL PROFESOR')
       ENDIF
       IF lShared
	  PLA->(DBUNLOCK())
       ENDIF
*>>>>FIN GRABACION DEL REGISTRO

*>>>>GRABACION DEL NIVEL DONDE DICTA EL PROFESOR
       lGrabar := !(cMaeAct $ PRO->cMaeAluPro)
       IF lGrabar
	  SELECT PRO
	  nPosIni := AT(SPACE(03),PRO->cMaeAluPro)
	  IF PRO->(lRegLock(lShared,.F.))
	     REPL PRO->cMaeAluPro WITH STUFF(PRO->cMaeAluPro,nPosIni,3,cMaeAct)
	     PRO->(DBCOMMIT())
	  ELSE
	     cError('NO SE GRABA EL NIVEL DONDE DICTA EL PROFESOR')
	  ENDIF
	  IF lShared
	     PRO->(DBUNLOCK())
	  ENDIF
       ENDIF
       SELECT PLA
       RETURN NIL
*>>>>FIN GRABACION DEL NIVEL DONDE DICTA EL PROFESOR

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDA EL CONTENIDO DEL PLAN ACADEMICO         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 19/95 VIE A
       Colombia, Bucaramanga        INICIO: 02:15 PM   MAY 19/95 VIE

OBJETIVOS:

1- Debe estar en uso el archivo de Grupos

2- Valida el contenido de los archivos del plan acad‚mico

3- Retorna por referencia los param‚tros de la funci¢n marcados con @

4- Retorna .T. si algun plan se encuentra vacio

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lVaciosPla(cPatSis,cAnoSis,cNroNiv)

*>>>>PARAMETROS DE LA FUNCION
/*     cPatSis                              // Path del sistema
       cAnoSis                              // A¤o del Sistema
       cNroNiv                              // @N£mero del nivel */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL lShared := .T.                 // .T. Archivo compartido
       LOCAL lExiste := .F.                 // .T. Existen los Clientes
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE EXISTENCIA DE LAS NOTAS
       SELECT GRU
       GO TOP
       DO WHILE .NOT. EOF()

**********LOCALIZACION DEL NIVEL
	   cNroNiv := SUBS(GRU->cCodigoGru,1,2)
	   IF !lLocCodigo('cCodigoNiv','NIV',cNroNiv)
	      cError('EL NIVEL '+cNroNiv+' NO EXISTE')
	      lExiste := .T.
	      EXIT
	   ENDIF
**********FIN LOCALIZACION DEL NIVEL

**********SELECCION DEL NOMBRE DEL ARCHIVO DEL PLAN ACADEMICO
	    IF NIV->lPlaGruNiv
	       FilePla := 'PL'+GRU->cCodigoGru+cAnoSis+ExtFile
	    ELSE
	       FilePla := 'PLAN'+cNroNiv+cAnoSis+ExtFile
	    ENDIF
**********FIN SELECCION DEL NOMBRE DEL ARCHIVO DEL PLAN ACADEMICO

***********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\'+FilePla,'PLA',NIL,lShared)
	       cNroNiv := SUBS(GRU->cCodigoGru,1,2)
	       lExiste := .T.
	       EXIT
	    ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

**********VERIFICACION DE EXISTENCIA
	    lExiste := .T.
	    DO CASE
	    CASE PLA->(RECCOUNT()) == 0
		 cNroNiv := SUBS(GRU->cCodigoGru,1,2)
		 EXIT
	    OTHERWISE
		 lExiste := .F.
	    ENDCASE
**********FIN VERIFICACION DE EXISTENCIA

	  CloseDbf('PLA')
	  SELECT GRU
	  SKIP

       ENDDO
       RETURN lExiste
*>>>>VALIDACION DE EXISTENCIA DE LAS NOTAS

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION DEL TIPO DE AREA                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 11/95 JUE A
       Colombia, Bucaramanga        INICIO: 11:20 AM   MAY 11/95 JUE

OBJETIVOS:

1- Realiza la validaci¢n del c¢digo

2- Retorna .T. si hay problemas

3- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValTipAre(nNroFil,nNroCol,cCodigo)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       cCodigo			            // @Codigo a validar */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL aMenus  := {}                  // Declaraci¢n de Men£s
       LOCAL aAyudas := {}                  // Declaraci¢n de Ayudas
       LOCAL nNroOpc := 1                   // N£mero de Opci¢n
*>>>>DECLARACION DE VARIABLES

*>>>>DEFINICION DE LOS TIPOS DE MATERIAS
       aMenus := {'1<PROMEDIABLE   >',;
		  '2<NO PROMEDIABLE>'}

       aAyudas := {'Promediable el  rea',;
		   'NO Promediable el  rea. Ej: Disciplina o Conducta'}
*>>>>FIN DEFINICION DE LOS TIPOS DE MATERIAS

*>>>>VALIDACION DEL CODIGO
       IF cCodigo # 'P' .AND. cCodigo # 'N'

	  SAVE SCREEN
	  nNroOpc := nMenu(aMenus,aAyudas,nNroFil,nNroCol,NIL,NIL,1,.F.)
	  RESTORE SCREEN

	  IF nNroOpc == 0
	     cCodigo := cSpaField('MAT','cTipMatMat')
	  ELSE
	     cCodigo := SUBS('PN',nNroOpc,1)
	  ENDIF

       ENDIF
       RETURN .T.
*>>>>FIN VALIDACION DEL CODIGO

/*************************************************************************
* TITULO DE LA FUNCION..: NOMBRE DEL PROFESOR QUE DICTA MATERIA          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 12/95 JUE A
       Bucaramanga,Colombia         INICIO: 10:23 AM   OCT 12/95 JUE

OBJETIVOS:

1- Debe estar en uso los archivos de plan y profesor

2- Busca el nombre del profesor de la materia y grupo especificado

3- Retorna por referencia los param‚tros de la funci¢n marcados con @

4- Retorna nombre del profesor

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cNomProMat(cCodMat,cCodGru,cCodPro)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodMat                              // C¢digo de la materia
       cCodGru                              // C¢digo del grupo
       cCodPro                              // @C¢digo del profesor */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cNombreTpr := ''               // Nombre del profesor
*>>>>FIN DECLARACION DE VARIABLES

*>>>>BUSQUEDA DE LA MATERIA
       cNombreTpr := 'PROFESOR NO EXITE'
       cCodPro := cSpaces('PRO','cCodigoPro')

       IF lLocCodigo('cCodigoMat','PLA',cCodMat)

	  cCodPro := &('PLA->cPr'+GRU->cCodigoGru+'Pla')
	  IF lLocCodigo('cCodigoPro','PRO',cCodPro)
	     cNombreTpr := RTRIM(PRO->cApelliPro)+' '+;
			   RTRIM(PRO->cNombrePro)
	  ENDIF

       ENDIF
       cNombreTpr := SUBS(cNombreTpr+SPACE(50),1,50)
       RETURN cNombreTpr
*>>>>FIN BUSQUEDA DE LA MATERIA

/*************************************************************************
* TITULO DEL PROGRAMA..: CODIGO DEL PROFESOR EN EL BROWSE                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 09/98 LUN A
       Colombia, Bucaramanga        INICIO: 12:50 AM   MAR 09/98 LUN

OBJETIVOS:

1- Deben estar en uso el archivo de profesores

2- Devuelve al Browse el c¢digo del Profesor en caso que el c¢digo de la
   materia sea fija, en caso contrario devueve asteriscos.

2- Retorna el c¢digo del profesor.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cCodProBrw(cCodMat,cCodGru,cAlias,lValAre)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodMat				      // C¢digo de la Materia.
       cCodGru                                // C¢digo del Profesor.
       cAlias                                 // Alias diferente al maestro
       lValAre                                // .T. Validar Area */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cCodigoTpr := ''                 // C¢digo del profesor
*>>>>FIN DECLARACION DE VARIABLES

*>>>>BUSQUEDA DEL CODIGO
       lValAre := IF(lValAre==NIL,.F.,lValAre)
       IF lLocMatVar(cCodMat,cAlias)
	  cCodigoTpr := '******'
       ELSE
	  IF lValAre .AND. SUBS(cCodMat,3,2) == '00'
	     cCodigoTpr := '-Area-'
	  ELSE
	     cCodigoTpr := &('PLA->cPr'+cCodGru+'Pla')
	  ENDIF
       ENDIF
       IF cAlias # NIL
	  SELECT &cAlias
       ENDIF
       RETURN cCodigoTpr
*>>>>FIN BUSQUEDA DEL CODIGO

/*************************************************************************
* TITULO DE LA FUNCION..: VISUALIZACION DEL SUB PLAN            	 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 06/98 VIE A
       Colombia, Bucaramanga        INICIO: 04:50 PM   MAR 06/98 VIE


OBJETIVOS:

1- Visualiza la Subdivision de una materia variable

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION VerSubPlan(lShared,cCodGru,cCodMat)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cCodGru                              // C¢digo del Grupo
       oBrowse                              // Objeto */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>VISUALIZACION DEL BROWSE
       IF lLocCodigo('cCodigoMat','MAT',cCodMat)

	  DO CASE
	  CASE MAT->nMatVarMat == 1
	       VerSuNPlan(lShared,SUBS(cCodGru,1,2),cCodMat)

	  CASE MAT->nMatVarMat == 2
	       VerSuGPlan(lShared,cCodGru,cCodMat)

	  OTHERWISE
	     cError(ALLTRIM(MAT->cNombreMat)+ ' NO TIENE SUBDIVISION')
	  ENDCASE

       ENDIF
       SELECT PLA
       RETURN NIL
*>>>>FIN VISUALIZACION DEL BROWSE

/*************************************************************************
* TITULO DE LA FUNCION..: ORDENAMIENTO DEL PLAN ACADEMICO       	 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 06/98 VIE A
       Colombia, Bucaramanga        INICIO: 04:50 PM   MAR 06/98 VIE


OBJETIVOS:

1- Ordena el plan acad‚mico

2- Retorna .T. si no hay problemas.

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lOrdPlan(lShared,FilePla,oBrwPla)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       FilePla                              // Archivo del Plan Acad‚mico
       oBrwPla                              // Browse del Plan Acad‚mico */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL aStrPla := {}                  // Estructura del Plan Acad‚mico
*>>>>FIN DECLARACION DE VARIABLES

*>>>>COPIA DEL MAESTRO PARA EL ORDENAMIENTO
       IF EMPTY(oBrwPla)
	  cSavPan := SAVESCREEN(0,0,24,79)
       ENDIF
       Termometro(0,'ORDENANDO EL PLAN DE ESTUDIOS')
       Termometro(10)

       Termometro(20)
       CloseDbf('PLA')
       IF FILECOPY(FilePla,'PLAN.DBF') == 0
	  cError('NO SE PUDO HACER LA COPIA EN EL TEMPORAL')
	  RETURN .F.
       ENDIF

       IF !lOrdFile(lShared,'PLAN.DBF','nNroOrdPla')
	  cError('NO SE ORDENO EL ARCHIVO PLAN TEMPORAL')
	  RETURN .F.
       ENDIF
*>>>>FIN COPIA DEL MAESTRO PARA EL ORDENAMIENTO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,FilePla,'PLA',NIL,.F.)
	  cError('ABRIENDO ARCHIVO')
	  CloseDbf('PLA')
	  RETURN .F.
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE PLA->(RECCOUNT()) == 0
	    cError('NO EXISTEN REGISTROS EN EL PLAN DE ESTUDIOS')
       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseDbf('PLA')
	  RETURN .F.
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,'PLAN.DBF','ARE',NIL,lShared) .OR.;
	  !lUseDbf(.T.,'PLAN.DBF','ASI',NIL,lShared)
	  cError('ERROR ABRIENDO ARCHIVOS PLAN TEMPORAL')
	  CloseDbf('PLA')
	  CloseDbf('ARE')
	  RETURN .F.
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>FILTRACION DEL PLAN POR AREA
       SELECT ARE
       SET FILTER TO SUBS(ARE->cCodigoMat,3,2) == '00'
       GO TOP
       IF EOF()
	  cError('NO EXISTEN AREAS EN LA FILTRACION')
	  ARE->(DBCLEARFILTER())
	  CloseDbf('PLA')
	  CloseDbf('ARE')
	  CloseDbf('ASI')
	  RETURN .F.
       ENDIF
       SELECT PLA
       aStrPla := DBSTRUCT()
       ZAP
*>>>>FIN FILTRACION DEL PLAN POR AREA

*>>>>CREACION DEL PLAN ACADEMICO ORDENADO
       SELECT ARE
       GO TOP
       Termometro(50)
       DO WHILE .NOT. ARE->(EOF())

**********GRABACION DEL AREA
	    SELECT PLA
	    IF PLA->(lRegLock(lShared,.T.))

	       FOR i:=1 TO LEN(aStrPla)
		   REPL PLA->&(aStrPla[i][1]) WITH ARE->&(aStrPla[i][1])
		   PLA->(DBCOMMIT())
	       ENDFOR

	    ELSE
	       cError('NO SE GRABA EL REGISTRO')
	    ENDIF
	    IF lShared
	       PLA->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL AREA

**********FILTRACION DE LA MATERIA
	    SELECT ASI
	    SET FILTER TO SUBS(ASI->cCodigoMat,1,2) == SUBS(ARE->cCodigoMat,1,2) .AND.;
			  SUBS(ASI->cCodigoMat,3,2) # '00'
	    GO TOP
	    IF EOF()
	       ARE->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN FILTRACION DE LA MATERIA

**********GRABACION DE LAS MATERIAS DEL AREA
	    Termometro(75)
	    SELECT ASI
	    GO TOP
	    DO WHILE .NOT. ASI->(EOF())
	       SELECT PLA
	       IF PLA->(lRegLock(lShared,.T.))

		  FOR i:=1 TO LEN(aStrPla)
		      REPL PLA->&(aStrPla[i][1]) WITH ASI->&(aStrPla[i][1])
		      PLA->(DBCOMMIT())
		  ENDFOR

	       ELSE
		  cError('NO SE GRABA EL REGISTRO')
	       ENDIF
	       IF lShared
		  PLA->(DBUNLOCK())
	       ENDIF
	       ASI->(DBSKIP())
	    ENDDO
**********FIN GRABACION DEL AREA

	  ARE->(DBSKIP())

       ENDDO
*>>>>FIN CREACION DEL PLAN ACADEMICO ORDENADO

*>>>>BORRADO DEL ARCHIVO TEMPORAL
       Termometro(90)

       CloseDbf('ARE')
       CloseDbf('ASI')

       IF !lFileDelete('PLAN.DBF')
	  cError('NO SE BORRO EL ARCHIVO TEMPORAL')
       ENDIF
*>>>>FIN BORRADO DEL ARCHIVO TEMPORAL

*>>>>SELECION DE LAS AREAS DE TRABAJO
       CloseDbf('PLA')
       IF !lUseDbf(.T.,FilePla,'PLA',NIL,lShared)
	  cError('ERROR ABRIENDO ARCHIVO')
	  CloseDbf('PLA')
	  RETURN .F.
       ENDIF
       Termometro(100)
       IF EMPTY(oBrwPla)
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       IF !EMPTY(oBrwPla)
	  SELECT PLA
	  oBrwPla:GOTOP()
	  GO TOP
	  oBrwPla:FORCESTABLE()
       ENDIF
       RETURN .T.
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

/*************************************************************************
* TITULO DEL PROGRAMA..: INTERVALO DE MATERIA DEL PLAN                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 27/95 MAR A
       Colombia, Bucaramanga        INICIO: 12:00 AM   MAY 27/95 MAR

OBJETIVOS:

1- Debe estar en uso el archivo de grupos

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Permite selecionar un intervalo de grupos.

4- Retorna .T. si se ley¢ un intervalo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lIntervPla(nNroFil,nNroCol,nRegIni,nRegFin)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // N£mero de la fila
       nNroCol                              // N£mero de la Columna
       nRegIni                              // @Registro Inicial
       nRegFin                              // @Registro Final */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavLin := ''                  // Salvar l¡neas
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL nFilSup := 0                   // Fila superior
       LOCAL nColSup := 0                   // Colunma superior
       LOCAL nFilInf := 0                   // Fila inferior
       LOCAL nColInf := 0                   // Columna inferior
       LOCAL nRegTem := 0                   // Registro temporal
       LOCAL nLenBrw := 0                   // Longitud del Browse
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE ENCABEZADOS
       cMsgTxt = 'MATERIA INICIAL:'
       @ nNroFil  ,nNroCol SAY cMsgTxt
       @ nNroFil+1,nNroCol SAY 'MATERIA FINAL  :'
*>>>>FIN IMPRESION DE ENCABEZADOS

*>>>>CAPTURA DEL INTERVALO INICIAL
	SELECT PLA
	nNroCol = nNroCol + LEN(cMsgTxt)+1
	nFilSup := nNroFil
	nColSup := nNroCol
	IF nFilSup+RECCOUNT() > 22
	   nFilInf := 21
	ELSE
	   nFilInf := nFilSup + RECCOUNT() - 1
	ENDIF
	nLenBrw := 40
	nColInf := nColSup+nLenBrw

	PLA->(DBGOTOP())
	nRegIni := nBrowseDbf(nFilSup,nColSup,nFilInf,nColInf,;
			      {||cSekNomMat(PLA->cCodigoMat,'PLA')})
	IF nRegIni == 0
	   RETURN .F.
	ENDIF
	PLA->(DBGOTO(nRegIni))
	@ nFilSup,nColSup SAY cSekNomMat(PLA->cCodigoMat,'PLA')
*>>>>FIN CAPTURA DEL INTERVALO INICIAL

*>>>>CAPTURA DEL INTERVALO FINAL
       PLA->(DBGOTOP())
       nRegFin := nBrowseDbf(nFilSup+1,nColSup,nFilInf,nColInf,;
			    {||cSekNomMat(PLA->cCodigoMat,'PLA')})
       IF nRegFin == 0
	  RETURN .F.
       ENDIF
       PLA->(DBGOTO(nRegFin))
       @ nFilSup+1,nColSup SAY cSekNomMat(PLA->cCodigoMat,'PLA')
*>>>>FIN CAPTURA DEL INTERVALO FINAL

*>>>>INTERCAMBIO DE REGISTROS
       IF nRegIni > nRegFin
	  nRegTem = nRegIni
	  nRegIni = nRegFin
	  nRegFin = nRegTem
       ENDIF
       RETURN .T.
*>>>>FIN INTERCAMBIO DE REGISTROS

/*************************************************************************
* TITULO..: VALIDACION SI LA MATERIA PERTENCE AL PLAN                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 23/95 MAR A
       Colombia, Bucaramanga        INICIO: 11:20 AM   MAY 23/95 MAR

OBJETIVOS:

1- Valida si la materia pertenece al plan Acad‚mico del nivel

2- Debe estar en uso el archivo del plan Academico para el nivel

3- Debe estar en uso el archivo de errores si se activa la opci¢n de
   grabar el error.

4- Retorna .T. no pertenece al plan

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lMatPlan(lShared,nTipCar,cMatPla,cMatSub,;
		  cCodGru,lGraErr,aGenLog,cAliasL)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nTipCar                              // Tipo de Carga
       cMatPla			            // Materia del Plan
       cMatSub                              // Materia de la Subdivisi¢n
       cCodGru                              // C¢digo del grupo
       lGraErr                              // .T. Grabar el error
       aGenLog                              // Campos Generales
       cAliasL                              // Alias del Log */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL aCamLog := {}                  // Campos del Log
       LOCAL cTxtLog := ''                  // Texto del Log

       LOCAL lHayErr := .T.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE LA MATERIA
       DO CASE
       CASE !lLocCodigo('cCodigoMat','PLA',cMatPla)

	    cTxtLog := cMatPla+' '+ALLTRIM(MAT->cNombreMat)+;
		       ' plan de '+cNomNiv(SUBS(cCodGru,1,2))+' NO EXISTE'

       CASE nTipCar == 1 .AND.;  // Variable por Grupo
	    !lLocMatVar(cMatSub) .AND.;
	    !lLocMatSuG(cMatSub,cCodGru,.F.)

	     cTxtLog := 'Materia:'+cMatSub+' '+;
			'Sub Division de: '+cCodGru+' '+;
			'plan de '+cNomNiv(SUBS(cCodGru,1,2))+' NO EXISTE'

       CASE (nTipCar == 2 .OR. nTipCar == 3) .AND.; // Variable por nivel o niveles
	    !lLocMatVar(cMatSub)             .AND.;
	    !lLocMatSuN(cMatSub,SUBS(cCodGru,1,2),.F.) .AND.;
	    lLocCodigo('cCodigoMat','PLA',MAT->cCodigoMat)

	     cTxtLog := 'Materia:'+cMatSub+' '+;
			'Sub Division de '+SUBS(cCodGru,1,2)+;
			' plan de '+cNomNiv(SUBS(cCodGru,1,2))+' NO EXISTE'

       OTHERWISE
	    lHayErr := .F.
       ENDCASE
       IF lHayErr

	  cError(cTxtLog)
	  lGraErr := IIF(lGraErr == NIL,.F.,lGraErr)
	  IF lGraErr
	     AADD(aCamLog,{'cObservLog',cTxtLog})
	     aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
	  ENDIF
       ENDIF
       RETURN !lHayErr
*>>>>FIN VALIDACION DE LA MATERIA

/*************************************************************************
* TITULO..: LEE PLAN DE ESTUDIOS DEL A¥O ANTERIOR                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 22/2002 VIE A
       Colombia, Bucaramanga        INICIO: 10:30 AM   MAR 22/2002 VIE

OBJETIVOS:

1- Deben estar en uso el archivo del plan de Estudios

2- Permite leer el plan de estudios del A¤o Anterior

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lLeeMatPla(lShared,cAnoUsr,cPatSis,cMaeAct,fPlaNiv,fPlaGru)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cAnoUsr                              // A¤o del Usuario
       cPatSis                              // Path del sistema
       cMaeAct                              // Maestro Actual
       fPlaNiv                              // Plan por Niveles
       fPlaGru                              // Plan por Grupos */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL     i,j := 0                   // Contadores
       LOCAL nNroOpc := 0                   // N£mero de Opci¢n
       LOCAL cAnoAnt := ''                  // A¤o Anterior
       LOCAL cAnoSis := ''                  // A¤o Anterior
       LOCAL cPatAnt := ''                  // Path Anterior
       LOCAL aStrAct := {}                  // Estructura Actual
       LOCAL aStrAnt := {}                  // Estructura Actual
       LOCAL lHayCam := .F.                 // .T. Hay Campo
       LOCAL PathPla := ''                  // Path del Plan Acad‚mico
       LOCAL fPlaDbf := ''                  // Archivo del Plan de Estudios
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE LA LECTURA DEL PLAN
	nNroOpc := nLeeOpcion('PLAN ACADEMICO: 1<A¥O ANTERIOR> '+;
			      '2<ACTUALIZAR> 3<INSERTAR> '+;
			      '4<ABANDONAR>?',4,'0',22)
	IF nNroOpc == 4
	   RETURN .T.
	ELSE
	   IF nNroOPc == 3
	      RETURN .F.
	   ENDIF
	ENDIF
*>>>>FIN ANALISIS DE LA LECTURA DEL PLAN

*>>>>ANALISIS DE DECISION
       IF !lPregunta('DESEA CONTINUAR? No Si')
	  RETURN .T.
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>SELECION DEL A¥O ANTERIOR
       IF nNroOpc == 1
	  cAnoAnt := STR((VAL(cAnoUsr)-1),4)
	  cAnoSis := SUBS(cAnoAnt,3,2)
	  cPatAnt := cPatSis
	  cPatAnt := STUFF(cPatAnt,1,4,cAnoAnt)
	  PathPla := cPatAnt+'\'+cMaeAct
	  fPlaNiv := STUFF(fPlaNiv,LEN(fPlaNiv)-5,2,cAnoSis)
	  fPlaGru := STUFF(fPlaGru,LEN(fPlaGru)-5,2,cAnoSis)
       ELSE
	  PathPla := cPatSis+'\'+cMaeAct+'\PLAN'
       ENDIF
*>>>>FIN SELECION DEL A¥O ANTERIOR

*>>>>VALIDACION DEL ARCHIVO
       IF !FILE(PathPla+'\'+fPlaNiv)
	  IF !FILE(PathPla+'\'+fPlaGru)
	     cError('NO EXISTE EL PLAN DE ESTUDIOS DEL A¥O ANTERIOR')
	     RETURN .T.
	  ELSE
	     fPlaDbf := fPlaGru
	  ENDIF
       ELSE
	  fPlaDbf := fPlaNiv
       ENDIF
*>>>>FIN VALIDACION DEL ARCHIVO

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathPla+'\'+fPlaDbf,'TEM',NIL,lShared)
	  cError('NO EXISTEN PLAN DE ESTUDIOS DEL EL A¥O ANTERIOR')
	  CloseDbf('TEM')
	  RETURN .T.
       ENDIF
       aStrAct := PLA->(DBSTRUCT())
       aStrAnt := TEM->(DBSTRUCT())
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>LECTURA DE LOS PROFESORES DEL A¥O ANTERIOR
       SELECT TEM
       GO TOP
       DO WHILE .NOT. TEM->(EOF())

**********GRABACION DEL REGISTRO
	    IF PLA->(lRegLock(lShared,.T.))

*--------------GRABACION Y VALIDACION DE LOS CAMPOS
		 FOR i := 1 TO LEN(aStrAct)

*....................VALIDACION DEL CAMPO
		       lHayCam := .F.
		       FOR j := 1 TO LEN(aStrAnt)
			   IF aStrAct[i,1] == aStrAnt[j,1]
			      lHayCam := .T.
			      EXIT
			   ENDIF
		       ENDFOR
*....................FIN VALIDACION DEL CAMPO

*....................GRABACION DEL CAMPO
		       IF lHayCam
			  REPL PLA->&(aStrAct[i,1]) WITH TEM->&(aStrAct[i,1])
			  PLA->(DBCOMMIT())
		       ENDIF
*....................FIN GRABACION DEL CAMPO

		 ENDFOR
*--------------FIN GRABACION Y VALIDACION DE LOS CAMPOS

	    ELSE
	       cError('NO SE GRABA EL REGISTRO')
	    ENDIF

	    IF lShared
	       PLA->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL REGISTRO

	  SELECT TEM
	  SKIP

       ENDDO
*       CloseDbf('TEM')
       RETURN .T.
*>>>>FIN LECTURA DE LOS PROFESORES DEL A¥O ANTERIOR

/*************************************************************************
* TITULO..: NOMBRE DEL ARCHIVO DEL PLAN           	                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 11/2003 VIE A
       Colombia, Bucaramanga        INICIO: 12:15 AM   ABR 11/2003 VIE


OBJETIVOS:

1- Determina si el plan esta por nivel o por grupo.

2- Retorna .T.  si el plan esta por nivel

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nTipoPlan(cCodNiv)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodNiv                              // C¢digo del Nivel */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nTipPla := 0                  // Tipo de Plan. 0=>Error,1=Por Nivel,2=>Por Grupo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION DEL NIVEL
       IF !lLocCodigo('cCodigoNiv','NIV',cCodNiv)
	  cError('EL NIVEL '+cCodNiv+' NO EXISTE')
	  RETURN 0
       ENDIF
*>>>>FIN LOCALIZACION DEL NIVEL

*>>>>ANALISIS DE DECISION
       IF NIV->lPlaGruNiv
	  nTipPla := 2
       ELSE
	  nTipPla := 1
       ENDIF
       RETURN nTipPla
*>>>>FIN ANALISIS DE DECISION

/*************************************************************************
* TITULO..: MENU DE OTROS PARA EL ARCHIVO                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV  3/2004 MIE A
       Colombia, Bucaramanga        INICIO:  3:22 PM   NOV  3/2004 MIE

OBJETIVOS:

1- Menu de Otros para el archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuOtrPla(aParam1,aParam2,aParam3,;
		    cCodGru)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       cCodGru                              // C¢digo del Grupo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

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
       IF  !lParam0102(aParams,;
		       @lShared,@nModCry,@cCodSui,@cNomSis,;
		       @cEmpPal,@cNitEmp,@cNomEmp,@cNomSec,@cCodEmp,;
		       @cNomUsr,@cAnoUsr,@cAnoSis,@cPatSis,;
		       @nFilPal,@nFilInf,@nColInf,;
		       @PathW01,@PathW02,@PathW03,@PathW04,@PathW05,;
		       @PathW06,@PathW07,@PathW08,@PathW09,@PathW10,;
		       @PathUno,@PathDos,@PathTre,@PathCua,;
		       @cMaeAlu,@cMaeAct,@cJorTxt)
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>DECLARCION Y EJECUCION DEL MENU
       aMenus := {}
       AADD(aMenus,'1<PLAN DE ESTUDIOS    >')
       AADD(aMenus,'2<ASIGNACION ACADEMICA>')

       aAyuda := {}
       AADD(aAyuda,'Imprime el plan de Estudios')
       AADD(aAyuda,'Imprime la asignaci¢n academica del grado')

       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,aAyuda,10,25,'MENU OTROS',NIL,1,.F.)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nNroOpc == 0
          RETURN NIL
       ENDIF
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>ANALISIS DE OPCION ESCOGIDA
       DO CASE
       CASE nNroOpc == 1
	    ProgrNivel(lShared,cNomEmp,cNomSis,cNomUsr,cAnoUsr,cJorTxt,;
		       cCodGru)

       CASE nNroOpc == 2
	    ProfsNivel(lShared,cNomEmp,cNomSis,cNomUsr,cAnoUsr,cJorTxt,;
		       cCodGru)

       ENDCASE
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO DE LA FUNCION..: IMPRESION DE LOS PROFESORES DEL NIVEL          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 21/97 MAR A
       Colombia, Bucaramanga        INICIO: 03:25 PM   ENE 21/97 MAR

OBJETIVOS:

1- Imprime el programa acad‚mico del nivel respectivo

2- Debe estar en uso los archivos de Plan Acad‚mico, Materias,
   profesores y niveles.

3- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ProfsNivel(lShared,cNomEmp,cNomSis,cNomUsr,cAnoUsr,cJorTxt,cCodGru)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del Sistema
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cJorTxt                              // Jornada escogida
       cNroNiv                              // N£mero de Nivel */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"               // Impresora EPSON FX

       LOCAL cSavPan := ''                  // Salvar Pantalla
     *ÀVariables generales

       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitulo := {}                  // T¡tulos para impresi¢n
       LOCAL cCabCol := ''                  // Encabezado de Columna
       LOCAL aCabSec := {}                  // Encabezado Secundario
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL lCentra := .F.                 // .T. Centrar el informe
       LOCAL nColCab := 0                   // Columna del encabezado
       LOCAL bPagina := NIL                 // Block de P gina
       LOCAL bCabeza := NIL                 // Block de Encabezado
       LOCAL bDerAut := NIL                 // Block Derechos de Autor
       LOCAL nLinReg := 1                   // L¡neas del registro
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL FilePrn := ''                  // Archivo de Impresi¢n
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables de informe


       LOCAL nAvance := 0                   // Avance de registros
       LOCAL cIntHor := ''                  // Intensidad Horaria
       LOCAL cNroNiv := ''                  // N£mero del Nivel
       LOCAL cNomPla := ''                  // Nombre Plan
       LOCAL lSiorNo := .F.                 // Variable de decision
     *ÀVariables espec¡ficas

       FIELD cCodigoGru                     // C¢digo del Grupo
       LOCAL cNombreTma := ''               // Nombre de la materia
       LOCAL cCodigoTpr := ''               // C¢digo del Profesor
       LOCAL cNombreTpr := ''               // Nombre del profesor
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CONTENIDO
       IF PLA->(RECCOUNT()) == 0
	  cError('EL PLAN ACADEMICO NO ESTA CREADO')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>ANALISIS DEL PLAN ACADEMICO POR GRUPO
       cNroNiv := SUBS(cCodGru,1,2)
       IF LEN(cCodGru) == 4
	  cNomPla := cCodGru
       ELSE
	  cNomPla := cNomNiv(cNroNiv)
       ENDIF
*>>>>FIN ANALISIS DEL PLAN ACADEMICO POR GRUPO

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := NIV->nNroGruNiv+;
		  PLA->(RECCOUNT())+;
		  SUN->(RECCOUNT())+;
		  SUG->(RECCOUNT())+;
		  nLinTot


       aCabeza := {cNomEmp,cNomSis,;
		   'PROFESORES PARA '+cNomPla+;
		   '. A¥O:'+cAnoUsr+' JORNADA: '+cJorTxt,;
		   '',;
		   '',;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}
       cCodIni := DRAFT_ON+ELITE+CONDEN_ON
       cCodFin := NEGRA_OF+DOBGOL_OF
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {04,84,02,04,06,06,52}
       aTitulo := {'MAT',;
		   'MATERIA',;
		   'IH',;
		   'GRU',;
		   'CODIGO','CAMBIO',;
		   'NOMBRE DEL PROFESOR'}
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n20Stan
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF SCO->lPrnArcCon
	  SET DEVICE TO PRINT
       ELSE
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCO->cOpcPrnCon,.F.)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
       @ PROW(),00 SAY INICIALIZA
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL PLAN ACADEMICO
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT

       SELECT PLA
       GO TOP
       DO WHILE .NOT. PLA->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( PLA->(RECNO()) / PLA->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********LOCALIZACION DE LA MATERIA
	    IF SUBS(PLA->cCodigoMat,3,2) == '00'
	       cNombreTma := 'AREA NO EXISTE'
	    ELSE
	       cNombreTma := 'MATERIA NO EXISTE'
	    ENDIF
	    IF lLocCodigo('cCodigoMat','MAT',PLA->cCodigoMat)
	       cNombreTma := MAT->cNombreMat
	    ENDIF
**********FIN LOCALIZACION DE LA MATERIA

**********LECTURA DEL AREA
	    IF SUBS(PLA->cCodigoMat,3,2) == '00'
	       cIntHor    := PLA->cIntHorPla
	       IF PLA->cTipArePla == 'N'
		  cIntHor := PLA->cIntHorPla
	       ENDIF
	       cNombreTma := cNombreTma+SPACE(04)
	    ELSE
	       cIntHor    := PLA->cIntHorPla
	       cNombreTma := SPACE(02)+cNombreTma+SPACE(02)
	    ENDIF
**********FIN LECTURA DEL AREA

**********IMPRESION DEL AREA
	    IF SUBS(PLA->cCodigoMat,3,2) == '00' .AND. PLA->cTipArePla # 'N'
	       aTitulo := {PLA->cCodigoMat,;
			   cNombreTma,;
			   SPACE(02),;
			   SPACE(04),;
			   SPACE(06),;
			   SPACE(06),;
			   SPACE(52)}

	       cTxtPrn := cRegPrint(aTitulo,aNroCol)
	       IF !SCO->lAreProCon
		  lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
	       ENDIF
	    ENDIF
**********FIN IMPRESION DEL AREA

**********IMPRESION DE LOS PROFESORES
	    IF SCO->lAreProCon
	       lSiorNo := .T.
	    ELSE
	       lSiorNo := SUBS(PLA->cCodigoMat,3,2) # '00'   .OR.;
			  (SUBS(PLA->cCodigoMat,3,2) == '00' .AND.;
			  PLA->cTipArePla == 'N')
	    ENDIF

	    IF lSiorNo

	       SELECT GRU
	       IF LEN(cCodGru) == 2
		  SET FILTER TO SUBS(GRU->cCodigoGru,1,2) == cNroNiv
	       ELSE
		  SET FILTER TO GRU->cCodigoGru == cCodGru
	       ENDIF
	       GO TOP

	       DO WHILE .NOT. GRU->(EOF())

*-----------------LOCALIZACION DEL PROFESOR
		    cCodigoTpr := SPACE(06)
		    cNombreTpr := SPACE(52)

		    IF lLocCodigo('cCodigoMat','MAT',PLA->cCodigoMat) .AND.;
		       (MAT->nMatVarMat == 1 .OR. MAT->nMatVarMat == 2)
		       cCodigoTpr := '******'
		    ELSE
		       cCodigoTpr := PLA->(&('cPr'+GRU->cCodigoGru+'Pla'))
		    ENDIF

		    IF lLocCodigo('cCodigoPro','PRO',cCodigoTpr)
		       IF MAT->nMatVarMat == 0
			  cNombreTpr := RTRIM(PRO->cApelliPro)+' '+;
					PRO->cNombrePro
		       ENDIF
		    ENDIF
		    cNombreTpr := SUBS(cNombreTpr+SPACE(52),1,52)
*-----------------FIN LOCALIZACION DEL PROFESOR

*-----------------IMPRESION DEL REGISTRO
		    IF EMPTY(cNombreTma)
		       aTitulo := {SPACE(04),;
				   SPACE(32),;
				   SPACE(02),;
				   GRU->cCodigoGru,;
				   cCodigoTpr,;
				   SPACE(06),;
				   cNombreTpr}
		    ELSE
		       aTitulo := {PLA->cCodigoMat,;
				   cNombreTma,;
				   cIntHor,;
				   GRU->cCodigoGru,;
				   cCodigoTpr,;
				   SPACE(06),;
				   cNombreTpr}
		    ENDIF
		    cTxtPrn := cRegPrint(aTitulo,aNroCol)
		    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
		    cNombreTma := ''
*-----------------FIN IMPRESION DEL REGISTRO

*-----------------IMPRESION DE LA SUBDIVISION POR NIVEL
		    IF MAT->nMatVarMat == 1

*......................FILTRACION DE LA SUBDIVISION
			 SELECT SUN
			 SET FILTER TO (SUN->cCodigoNiv == cNroNiv .OR.;
					SUN->cCodigoNiv == 'XX')  .AND.;
			     SUBS(SUN->cCodigoMat,1,2) == SUBS(PLA->cCodigoMat,1,2)
			 GO TOP
*......................FIN FILTRACION DE LA SUBDIVISION

*......................RECORRIDO DE LA SUBDIVISION
			 DO WHILE .NOT. SUN->(EOF())

*                           LOCALIZACION DE LA MATERIA
			      IF lLocCodigo('cCodigoMat','MAT',SUN->cCodigoMat)
				 cNombreTma := SPACE(04)+MAT->cNombreMat
			      ELSE
				 cNombreTma := SPACE(04)+'MATERIA NO EXISTE'
			      ENDIF
*                           FIN LOCALIZACION DE LA MATERIA

*                           LOCALIZACION DEL PROFESOR
			      cCodigoTpr := SPACE(06)
			      cNombreTpr := SPACE(52)

			      IF SUN->lPorNivSuN
				 cCodigoTpr := SUN->cCodigoPro
			      ELSE
				 cCodigoTpr := MAT->cCodigoPro
			      ENDIF

			      IF lLocCodigo('cCodigoPro','PRO',cCodigoTpr)
				 cNombreTpr := RTRIM(PRO->cApelliPro)+' '+;
					       PRO->cNombrePro
			      ENDIF
			      cNombreTpr := SUBS(cNombreTpr+SPACE(52),1,52)
*                           FIN LOCALIZACION DEL PROFESOR

*                           IMPRESION DEL REGISTRO
			      aTitulo := {SUN->cCodigoMat,;
					  cNombreTma,;
					  SUN->cIntHorSuN,;
					  GRU->cCodigoGru,;
					  cCodigoTpr,;
					  cNombreTpr}
			      cTxtPrn := cRegPrint(aTitulo,aNroCol)
			      lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
			      cNombreTma := ''
*                           FIN IMPRESION DEL REGISTRO

			    SUN->(DBSKIP())

			 ENDDO
			 SET FILTER TO
			 SELECT PLA
*......................FIN RECORRIDO DE LA SUBDIVISION

		    ENDIF
*-----------------FIN IMPRESION DE LA SUBDIVISION POR NIVEL

*-----------------IMPRESION DE LA SUBDIVISION POR GRUPO
		    IF MAT->nMatVarMat == 2

*......................FILTRACION DE LA SUBDIVISION
			 SELECT SUG
			 SET FILTER TO SUG->cCodigoGru == GRU->cCodigoGru .AND.;
			     SUBS(SUG->cCodigoMat,1,2) == SUBS(PLA->cCodigoMat,1,2)
			 GO TOP
*......................FIN FILTRACION DE LA SUBDIVISION

*......................RECORRIDO DE LA SUBDIVISION
			 DO WHILE .NOT. SUG->(EOF())

*                           LOCALIZACION DE LA MATERIA
			      IF lLocCodigo('cCodigoMat','MAT',SUG->cCodigoMat)
				 cNombreTma := SPACE(04)+MAT->cNombreMat
			      ELSE
				 cNombreTma := SPACE(04)+'MATERIA NO EXISTE'
			      ENDIF
*                           FIN LOCALIZACION DE LA MATERIA

*                           LOCALIZACION DEL PROFESOR
			      cCodigoTpr := SUG->cCodigoPro
			      cNombreTpr := SPACE(52)

			      IF lLocCodigo('cCodigoPro','PRO',cCodigoTpr)
				 cNombreTpr := RTRIM(PRO->cApelliPro)+' '+;
					       PRO->cNombrePro
			      ENDIF
			      cNombreTpr := SUBS(cNombreTpr+SPACE(52),1,52)
*                           FIN LOCALIZACION DEL PROFESOR

*                           IMPRESION DEL REGISTRO
			      aTitulo := {SUG->cCodigoMat,;
					  cNombreTma,;
					  SUG->cIntHorSuG,;
					  GRU->cCodigoGru,;
					  cCodigoTpr,;
					  SPACE(06),;
					  cNombreTpr}
			      cTxtPrn := cRegPrint(aTitulo,aNroCol)
			      lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
			      cNombreTma := ''
*                           FIN IMPRESION DEL REGISTRO

			    SUG->(DBSKIP())

			 ENDDO
			 SET FILTER TO
			 SELECT PLA

		    ENDIF
*-----------------FIN IMPRESION DE LA SUBDIVISION POR GRUPO

		  SELECT GRU
		  SKIP

	      ENDDO
	      SET FILTER TO

	    ENDIF
**********FIN IMPRESION DE LOS PROFESORES

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT PLA
	    PLA->(DBSKIP())
	    IF PLA->(EOF())
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN IMPRESION DEL PLAN ACADEMICO

*>>>>IMPRESION DERECHOS
       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       VerPrn(nOpcPrn,FilePrn)
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO DE LA FUNCION..: IMPRESION DEL PROGRAMA ACADEMICO               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 21/97 MAR A
       Colombia, Bucaramanga        INICIO: 10:40 PM   ENE 21/97 MAR

OBJETIVOS:

1- Imprime el programa acad‚mico del nivel respectivo

2- Debe estar en uso los archivos de Plan Acad‚mico y Materias

3- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ProgrNivel(lShared,cNomEmp,cNomSis,cNomUsr,cAnoUsr,cJorTxt,cCodGru)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del Sistema
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cJorTxt                              // Jornada escogida
       cCodGru                              // C¢digo del Grupo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
     *ÀVariables generales

       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitulo := {}                  // T¡tulos para impresi¢n
       LOCAL cCabCol := ''                  // Encabezado de Columna
       LOCAL aCabSec := {}                  // Encabezado Secundario
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL lCentra := .F.                 // .T. Centrar el informe
       LOCAL nColCab := 0                   // Columna del encabezado
       LOCAL bPagina := NIL                 // Block de P gina
       LOCAL bCabeza := NIL                 // Block de Encabezado
       LOCAL bDerAut := NIL                 // Block Derechos de Autor
       LOCAL nLinReg := 1                   // L¡neas del registro
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL FilePrn := ''                  // Archivo de Impresi¢n
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables de informe


       LOCAL cNomPla := ''                  // Nombre del Plan
       LOCAL cNroNiv := ''                  // N£mero del Nivel
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL cIntHor := ''                  // Intensidad Horaria
     *ÀVariables espec¡ficas

       LOCAL cNombreTma := ''               // Nombre de la materia
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CONTENIDO
       IF PLA->(RECCOUNT()) == 0
	  cError('EL PLAN ACADEMICO NO ESTA CREADO')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>ANALISIS DEL PLAN ACADEMICO POR GRUPO
       cNroNiv := SUBS(cCodGru,1,2)
       IF LEN(cCodGru) == 4
	  cNomPla := cCodGru
       ELSE
	  cNomPla := cNomNiv(cNroNiv)
       ENDIF
*>>>>FIN ANALISIS DEL PLAN ACADEMICO POR GRUPO

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := PLA->(RECCOUNT())+;
		  SUN->(RECCOUNT())+;
		  SUG->(RECCOUNT())+nLinTot
       aCabeza := {cNomEmp,cNomSis,;
		   'PLAN DE ESTUDIOS DE '+cNomPla+;
		   '. A¥O:'+cAnoUsr+' JORNADA: '+cJorTxt,;
		   '',;
		   '',;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}
       cCodIni := DRAFT_ON+PICA+CONDEN_ON
       cCodFin := NEGRA_OF+DOBGOL_OF
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {06,02,90,06,26}
       aTitulo := {'CODIGO',;
		   'IH',;
		   'MATERIAS','PRNBOL','OBSERVACIONES'}
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n17Stan
       lCentra := .T.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF SCO->lPrnArcCon
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'PLAN'+cNroNiv
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCO->cOpcPrnCon,.F.)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
       @ PROW(),00 SAY INICIALIZA
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL PLAN ACADEMICO
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT

       SELECT PLA
       GO TOP
       DO WHILE .NOT. PLA->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( PLA->(RECNO()) / PLA->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********LOCALIZACION DE LA MATERIA
	    IF SUBS(PLA->cCodigoMat,3,2) == '00'
	       cNombreTma := 'AREA NO EXISTE'
	    ELSE
	       cNombreTma := 'MATERIA NO EXISTE'
	    ENDIF
	    IF lLocCodigo('cCodigoMat','MAT',PLA->cCodigoMat)
	       cNombreTma := MAT->cNombreMat
	    ENDIF
**********FIN LOCALIZACION DE LA MATERIA

**********PREPARACION DEL LAS VARIABLES
	    IF SUBS(PLA->cCodigoMat,3,2) == '00'
	       cIntHor := PLA->cIntHorPla
	       IF PLA->cTipArePla == 'N'
		  cIntHor := PLA->cIntHorPla
	       ENDIF
	       cNombreTma := cNombreTma+SPACE(08)
	    ELSE
	       cIntHor    := PLA->cIntHorPla
	       cNombreTma := SPACE(02)+cNombreTma+SPACE(06)
	    ENDIF
**********FIN PREPARACION DEL LAS VARIABLES

**********IMPRESION DEL REGISTRO
	    aTitulo := {PLA->cCodigoMat,;
			cIntHor,;
			cNombreTma+SPACE(02),;
			PLA->cPrnBolPla,;
			SPACE(26)}
	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL REGISTRO

**********IMPRESION DE LA SUBDIVISION POR NIVEL
	    IF MAT->nMatVarMat == 1

*--------------FILTRACION DE LA SUBDIVISION

		 SELECT SUN
		 SET FILTER TO (SUN->cCodigoNiv == cNroNiv .OR.;
				SUN->cCodigoNiv == 'XX')  .AND.;
		     SUBS(SUN->cCodigoMat,1,2) == SUBS(PLA->cCodigoMat,1,2)
		 GO TOP
*--------------FIN FILTRACION DE LA SUBDIVISION

*--------------RECORRIDO DE LA SUBDIVISION
		 DO WHILE .NOT. SUN->(EOF())

*-------------------LOCALIZACION DE LA MATERIA
		      IF lLocCodigo('cCodigoMat','MAT',SUN->cCodigoMat)
			 cNombreTma := SPACE(04)+MAT->cNombreMat+SPACE(06)
		      ELSE
			 cNombreTma := SPACE(04)+'MATERIA NO EXISTE'
		      ENDIF
*-------------------FIN LOCALIZACION DE LA MATERIA

*-------------------IMPRESION DEL REGISTRO
		      aTitulo := {SUN->cCodigoMat,;
				  PLA->cIntHorPla,;
				  cNombreTma,;
				  PLA->cPrnBolPla,;
				  SPACE(32)}
		      cTxtPrn := cRegPrint(aTitulo,aNroCol)
		      lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
*-------------------FIN IMPRESION DEL REGISTRO

		    SUN->(DBSKIP())

		 ENDDO
		 SET FILTER TO
		 SELECT PLA
*--------------FIN RECORRIDO DE LA SUBDIVISION

	    ENDIF
**********FIN IMPRESION DE LA SUBDIVISION POR NIVEL

**********IMPRESION DE LA SUBDIVISION POR GRUPO
	    IF MAT->nMatVarMat == 2

*--------------FILTRACION DE LA SUBDIVISION
		 SELECT SUG
		 IF LEN(cCodGru) == 4
		    SET FILTER TO SUG->cCodigoGru == cCodGru .AND.;
			SUBS(SUG->cCodigoMat,1,2) == SUBS(PLA->cCodigoMat,1,2)
		 ELSE
		    SET FILTER TO SUBS(SUG->cCodigoGru,1,2) == cNroNiv .AND.;
			SUBS(SUG->cCodigoMat,1,2) == SUBS(PLA->cCodigoMat,1,2)
		 ENDIF
		 GO TOP
*--------------FIN FILTRACION DE LA SUBDIVISION

*--------------RECORRIDO DE LA SUBDIVISION
		 DO WHILE .NOT. SUG->(EOF())

*-------------------LOCALIZACION DE LA MATERIA
		      IF lLocCodigo('cCodigoMat','MAT',SUG->cCodigoMat)
			 cNombreTma := SPACE(04)+SUG->cCodigoGru+'->'+;
				       MAT->cNombreMat
		      ELSE
			 cNombreTma := SPACE(04)+'MATERIA NO EXISTE'
		      ENDIF
*-------------------FIN LOCALIZACION DE LA MATERIA

*-------------------IMPRESION DEL REGISTRO
		      aTitulo := {SUG->cCodigoMat,;
				  PLA->cIntHorPla,;
				  cNombreTma,;
				  SPACE(32)}
		      cTxtPrn := cRegPrint(aTitulo,aNroCol)
		      lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
*-------------------FIN IMPRESION DEL REGISTRO

		    SUG->(DBSKIP())

		 ENDDO
		 SET FILTER TO
		 SELECT PLA
*--------------FIN RECORRIDO DE LA SUBDIVISION

	    ENDIF
**********FIN IMPRESION DE LA SUBDIVISION POR NIVEL

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT PLA
	    PLA->(DBSKIP())
	    IF PLA->(EOF())
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN IMPRESION DEL PLAN ACADEMICO

*>>>>IMPRESION DERECHOS
       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       SET DEVICE TO SCREEN
       VerPrn(nOpcPrn,FilePrn)
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS