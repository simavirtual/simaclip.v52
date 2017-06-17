/*                       SIMA - MATRICULA ACADEMICA
	      BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO DESCUENTO

REQUERIMIENTOS:

- Compilar: clipper FuncsDes /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo de Descuentos

***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO..: MANTENIMIENTO DEL ARCHIVO DE DESCUENTOS		         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 28/2014 MAR A
       Colombia, Bucaramanga        INICIO: 07:30 AM   OCT 28/2014 MAR

OBJETIVOS:

1- Permite el mantenimiento del archivo Descuentos

SINTAXIS:

MantenDes()

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenDes(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
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
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-MATR.PRG"              // Archivos del Sistema


       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual

       LOCAL oBrowse := NIL                 // Browse de Descuentos
       LOCAL nOpcion := 0                   // N£mero de Opci¢n.
       LOCAL lNuevos := .F.                 // .T. Matricula para nuevos
       LOCAL cPatAnt := ''                  // Path A¤os anteriores
       LOCAL cAnoAnt := ''                  // A¤o Anterior
       LOCAL PathAlu := ''                  // Path del Alumno

       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTba := ''               // C¢digo del Banco

       CloseAll()
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE ALUMNOS NUEVOS O ANTIGUOS
       nOpcion := nLeeOpcion('DESCUENTOS PARA: '+;
			     '1<NUEVOS> 2<ANTIGUOS> '+;
			     '3<A¥OS ANTERIORES 4<ABANDONAR>?',4,'1')

       IF nOpcion == 4
	  cError('SE ABANDONA EL PROCESO')
	  CloseAll()
	  RETURN NIL
       ENDIF

       lNuevos := .F.
       IF nOpcion == 1
	  lNuevos := .T.
       ENDIF
*>>>>SELECCION DE ALUMNOS NUEVOS O ANTIGUOS

*>>>>LECTURA Y VALIDACION DEL A¥O
       IF nOpcion == 3 // A¥OS ANTERIORES

	  cSavPan := SAVESCREEN(0,0,24,79)
	  cAnoAnt := SPACE(04)
	  @ nFilInf+1,nColInf SAY 'A¥O:' GET cAnoAnt PICT '9999'
	  READ
	  RESTSCREEN(0,0,24,79,cSavPan)

	  IF EMPTY(cAnoAnt)
	     cError('SE ABANDONA EL PROCESO')
	     CloseAll()
	     RETURN NIL
	  ENDIF

	  MaeHab(lShared,nModCry,;
		 cAnoAnt+'.'+cIniJor(SUBS(cJornad,1,1))+'\'+;
		 fMtrAno+cAnoAnt+ExtFile,;
		 @cMaeAlu,@cJornad,'ANO->cMaeHabAno','ANO->cJorHabAno')
       *ÀMaestros habilitados.

       ENDIF
*>>>>FIN LECTURA Y VALIDACION DEL A¥O

*>>>>SELECION DEL A¥O ANTERIOR
       DO CASE
       CASE nOpcion == 1 // NUEVOS

	    cAnoAnt := STR((VAL(cAnoUsr)-1),4)
	    cPatAnt := cPatSis
	    cPatAnt := STUFF(cPatAnt,1,4,cAnoAnt)
	    cPatAnt := PathUno+'\'+cPatAnt

       CASE nOpcion == 2 // ANTIGUOS

	    cAnoAnt := STR((VAL(cAnoUsr)-1),4)
	    cPatAnt := cPatSis
	    cPatAnt := STUFF(cPatAnt,1,4,cAnoAnt)
	    cPatAnt := PathUno+'\'+cPatAnt

       CASE nOpcion == 3 // A¥OS ANTERIORES

	    cPatAnt := cPatSis
	    cPatAnt := STUFF(cPatAnt,1,4,cAnoAnt)
	    cPatAnt := PathUno+'\'+cPatAnt

       ENDCASE
*>>>>FIN SELECION DEL A¥O ANTERIOR

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileBan,'BAN',NIL,lShared,nModCry})
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
       CASE BAN->(RECCOUNT()) == 0
	    cError('NO EXISTE BANCOS CREADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       cCodigoTba := BAN->cCodigoBan
       CloseAll(aUseDbf)
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimMtr,'MTR',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fMtrAno+cAnoUsr+ExtFile,'ANO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileAdm+cAnoUsr+ExtFile,'ADM',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+FileBan,'BAN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileCon,'CON',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileDes,'DES',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FilePag,'PAG',NIL,lShared,nModCry})

       IF !lUseMae(lShared,cPatAnt,cMaeAlu,SUBS(cAnoAnt,3,2)) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
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

       CASE BAN->(RECCOUNT()) == 0
	    cError('NO EXISTEN LOS BANCOS GRABADOS')

       CASE CON->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONCEPTOS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',MTR->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>LOCALIZACION DEL BANCO
       IF !lLocCodigo('cCodigoBan','BAN',cCodigoTba)
	  cError('NO EXISTE EL CODIGO DEL BANCO:'+cCodigoTba)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DEL BANCO

*>>>>MANTENIMIENTO DEL ARCHIVO
       SELECT DES

       oBrowse := oDefBrwDes(lShared,nFilPal+1,00,22,79,nFilInf,nColInf,;
			     nFilPal,cNomEmp,cNomSis,cNomUsr,cAnoUsr,;
			     cMaeAlu,cPatSis,lAnoAct,lNuevos)

       SETKEY(K_F5,{||BuscarDes(lShared,cPatSis,oBrowse)})

       SETKEY(K_F9,{||MenuOtrDes(aP1,aP2,aP3,oBrowse)})

       DES->(CtrlBrw(lShared,oBrowse))
       SETKEY(K_F5,NIL)
       SETKEY(K_F9,NIL)

       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO..: DEFINICION DEL OBJETO BROWSE DE DESCUENTOS	                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 28/2014 MAR A
       Colombia, Bucaramanga        INICIO: 08:30 AM   OCT 28/2014 MAR

OBJETIVOS:

1- Define el objeto Browse del archivo Descuentos


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwDes(lShared,nFilSup,nColSup,nFilInf,nColInf,nNroFil,;
		    nNroCol,nFilPal,cNomEmp,cNomSis,cNomUsr,cAnoUsr,;
		    cMaeAlu,cPatSis,lAnoAct,lNuevos)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       cMaeAlu                              // Maetros habilitados
       lNuevos                              // .T. Estudiantes Nuevos*/
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrowse := NIL		    // Browse de Descuentos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrowse := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'


       oBrowse:Cargo     := {'<<MANTENIMIENTO DE DESCUENTOS Y RECARGOS>>',;
			    '<F5>Buscar '+;
			    '<INS>Incluir <F9>Imprimir <ESC>Abandonar',;
			    {||IncluirDes(lShared,nNroFil,nNroCol,nFilPal,;
					  cNomEmp,cNomSis,cNomUsr,cAnoUsr,;
					  cMaeAlu,cPatSis,lNuevos)}}


     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras


       SELECT DES
       oColumn	     := TBCOLUMNNEW('CODIGO', {||DES->cCodigoEst})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:Freeze:= 2
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna


       oColumn	     := TBCOLUMNNEW('APELLIDOS', {||DES->cApelliEst})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRES', {||DES->cNombreEst})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

/*
       oColumn	     := TBCOLUMNNEW('NOMBRE DEL ESTUDIANTE',;
				    {||IF(DES->(EOF()),SPACE(50),;
				     cSekNomAlu(DES->cCodigoEst,;
				     cMaeAlu,'DES',lAnoAct))})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
       oColumn:Width := 50
     *ÀDefinici¢n Columna
*/

       oColumn	     := TBCOLUMNNEW('MES',{||IF(DES->(EOF()),SPACE(10),;
						DES->nNroMesDes)})
       oColumn:Cargo := {{'MODI',.F.}}
       oColumn:Width := 10
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR',{||IF(DES->(EOF()),SPACE(12),;
					       DES->nValorDes)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('DEUDA A¥O ANTERIOR',{||IF(DES->(EOF()),SPACE(12),;
					       DES->nSdoAnoDes)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MORA A¥O ANTERIOR',{||IF(DES->(EOF()),SPACE(12),;
					       DES->nMorAnoDes)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CLASE',;
			{||IF(DES->(EOF()),SPACE(12),;
			   cNombreDes(DES->nTipDesDes,12))})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('DESCRIPCION', {||DES->cDescriDes})
       oColumn:Cargo := {{'MODI',.F.}}
       oColumn:Width := 50
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FECHA DE;LA NOVEDAD',;
				    {||cFecha(DES->dFechaDes)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

/* OJO
       IF CAA->lForPagCaA
	  oColumn	     := TBCOLUMNNEW('TIPO;DE PAGO',{||DES->cCodigoFpg})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','DES'},{'FIELD','cCodigoFpg'},;
			    {'PICTURE','@!'}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF

       IF CAA->lForPagCaA
	  oColumn := TBCOLUMNNEW('DOCUMENTO DEL;TIPO DE PAGO',;
				{||DES->cNroFpgDes})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','DES'},{'FIELD','cNroFpgDes'},;
			    {'PICTURE','@!'}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF
*/

       oColumn	     := TBCOLUMNNEW('RECIBO No',{||DES->nNroFacCaA})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','DES'},{'FIELD','nNroFacCaA'},;
			 {'PICTURE','999999999999'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CONCEPTOS',{||DES->cConcepDes})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','DES'},{'FIELD','cConcepDes'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VLR CON No. 1', {||DES->nVlrCo1Des})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','DES'},{'FIELD','nVlrCo1Des'},;
			 {'PICTURE','9999999.99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VLR CON No. 2', {||DES->nVlrCo2Des})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','DES'},{'FIELD','nVlrCo2Des'},;
			 {'PICTURE','9999999.99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VLR CON No. 3', {||DES->nVlrCo3Des})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','DES'},{'FIELD','nVlrCo3Des'},;
			 {'PICTURE','9999999.99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VLR CON No. 4', {||DES->nVlrCo4Des})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','DES'},{'FIELD','nVlrCo4Des'},;
			 {'PICTURE','9999999.99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VLR CON No. 5', {||DES->nVlrCo5Des})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','DES'},{'FIELD','nVlrCo5Des'},;
			 {'PICTURE','9999999.99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VLR CON No. 6', {||DES->nVlrCo6Des})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','DES'},{'FIELD','nVlrCo6Des'},;
			 {'PICTURE','9999999.99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VLR CON No. 7', {||DES->nVlrCo7Des})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','DES'},{'FIELD','nVlrCo7Des'},;
			 {'PICTURE','9999999.99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VLR CON No. 8', {||DES->nVlrCo8Des})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','DES'},{'FIELD','nVlrCo8Des'},;
			 {'PICTURE','9999999.99'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

/* OJO
       IF CAA->lNomConDes
	  oColumn	     := TBCOLUMNNEW('CONCEPTO FACTURA;RECARGO', {||DES->cNombreCon})
	  oColumn:Cargo := {{'MODI',.T.},{'ALIAS','DES'},{'FIELD','cNombreCon'},;
			    {'PICTURE','@!'}}
	  oBrowse:ADDCOLUMN(oColumn)
	*ÀDefinici¢n Columna
       ENDIF
*/

       oColumn	     := TBCOLUMNNEW('BANCO',{||DES->cCodigoBan})
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS','DES'},{'FIELD','cCodigoBan'},;
			 {'PICTURE','@!'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRE;DEL USUARIO',{||DES->cNomUsrDes})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FECHA DE;PROCESO',;
				    {||cFecha(DES->dFecUsrDes)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('HORA DE;PROCESO',;
				    {||DES->cHorUsrDes})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna


       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO..: BUSCAR EL CODIGO DE LA TARIFA EN EL BROWSE                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 28/2014 MAR A
       Colombia, Bucaramanga        INICIO: 08:45 AM   OCT 28/2014 MAR

OBJETIVOS:

1- Debe estar en uso los archivos de Descuentos

2- Busca el c¢digo del descuentos compuesto por el c¢digo del estudiante y
   el n£mero del mes del descuento

3- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BuscarDes(lShared,cPatSis,oBrowse)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cPatSis                              // Path del sistema
       oBrowse				    // Browse de Descuentos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-MATR.PRG"              // Archivos del Sistema

       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nRegTar := 0                   // Registro de Tarifa
       LOCAL lBuscar := .F.                 // .T. Realizar la b£squeda
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTes := ''               // C¢digo del estudiante
       LOCAL nNroMesTde := 0                // Mes del descuento
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ACTIVACION DEL INDICE
       IF lShared
	  DBSETINDEX(cPatSis+'\'+fNtxDes)
       ELSE
	  SET INDEX TO (cPatSis+'\'+fNtxDes)
       ENDIF
*>>>>FIN ACTIVACION DEL INDICE

*>>>>CAPTURA DEL CODIGO
       SET CURSOR ON

       cCodigoTes := cSpaces('DES','cCodigoEst')
       nNroMesTde := 0
       TitBuscar(LEN(cCodigoTes)+2,@nNroFil,@nNroCol)

       @ nNroFil,nNroCol GET cCodigoTes PICT '999999';
			 VALID lCorrecion(@cCodigoTes)
       READ

       nNroMesTde := 13
     *ÀMatricula
*>>>>FIN CAPTURA DEL CODIGO

*>>>>VALIDACION DEL CODIGO
       lBuscar := .F.
       DO CASE
       CASE EMPTY(cCodigoTes) .AND. EMPTY(nNroMesTde)
	    cError('PATRON DE BUSQUEDA NO ESPECIFICADO',;
		   'ADVERTENCIA')

       CASE EMPTY(cCodigoTes) .OR. EMPTY(nNroMesTde)
	    cError('PATRON DE BUSQUEDA INCOMPLETO',;
		   'ADVERTENCIA')
       OTHERWISE
	    lBuscar := .T.
       ENDCASE
*>>>>FIN VALIDACION DEL CODIGO

*>>>>BUSQUEDA DEL CODIGO
       SELECT DES
       IF lBuscar .AND. lSekDesAbo(cCodigoTes,nNroMesTde)
	  nRegTar := RECNO()
	  GO TOP
	  oBrowse:GOTOP()
	  GO nRegTar
	  oBrowse:FORCESTABLE()
       ELSE
	  oBrowse:GOTOP()
       ENDIF
       RETURN NIL
*>>>>FIN BUSQUEDA DEL CODIGO

/*************************************************************************
* TITULO..: INCLUCION DE LOS DESCUENTOS O RECARGOS	                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 28/2014 MAR A
       Colombia, Bucaramanga        INICIO: 08:45 AM   OCT 28/2014 MAR

1- Permiter defenir los clientes que tienen descuento o recargos para
   para la matricula.

2- Retorna NIL


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION IncluirDes(lShared,nFilInf,nColInf,nFilPal,cNomEmp,;
		    cNomSis,cNomUsr,cAnoUsr,cMaeAlu,cPatSis,;
		    lNuevos)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior del Men£
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del sistema
       cNomUsr                              // Nombre del Usuario
       cAnoUsr			            // A¤o del Usuario
       cMaeAlu                              // Maestros Habilitados
       cPatSis                              // Path del sistema
       lNuevos			            // .T. Estudiantes Nuevos */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-MATR.PRG"              // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar l¡nea
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal
       LOCAL cTxtTem := ''                  // Texto temporal

       LOCAL       i := 0                   // Contador
       LOCAL cTipDes := ''                  // Tipo de Descuento
       LOCAL nNroOpc := 0                   // N£mero de opci¢n
       LOCAL lncluir := .T.                 // .T. Incluir
       LOCAL lGrabar := .F.                 // Grabar el registro
       LOCAL nRegDes := 0                   // Registro del Descuento
       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cConcep := ''                  // Conceptos
       LOCAL aVlrCon[8]                     // Valor de los Conceptos
       LOCAL nVlrCon := 0                   // Valor del Concepto
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTes := ''               // C¢digo del estudiante
       LOCAL cNombreTes := ''               // Nombre del estudiante

       LOCAL nNroMesTde := 0                // Mes del descueto/Recargo
       LOCAL nTipDesTde := 0                // Tipo de Descuento
       LOCAL cDescriTde := ''               // Descripci¢n
       LOCAL  nValorTde := 0                // Valor descuento/Recargo
       LOCAL dFechaTde  := CTOD('00/00/00') // Fecha del Descuento
       LOCAL cNombreTco := ''               // Nombre del Descuento

       LOCAL cNroFpgTde := ''               // N£mero de la forma de pago
       LOCAL cCodigoTfp := ''               // C¢digo de la forma de pago
       LOCAL cTituloTfp := ''               // T¡tulo de la forma de pago
       SETCURSOR(1)                         // Activaci¢n del cursor
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ACTIVACION DEL INDICE
       IF lShared
	  DBSETINDEX(cPatSis+'\'+fNtxDes)
       ELSE
	  SET INDEX TO (cPatSis+'\'+fNtxDes)
       ENDIF
*>>>>FIN ACTIVACION DEL INDICE

/*>>>VALIDACION DE LA CONCILIACION
       IF SUBS(ANO->cValConAno,nNroMesTde,1) # SPACE(01)

	  cError('EL MES DE '+cMes(nNroMesTde,10)+' '+;
		 'YA SE REPORTO A CONTABILIDAD')
	  RETURN NIL

       ENDIF
*>>>>FIN VALIDACION DE LA CONCILIACION OJO */

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroMesTde := 13                     // Matricula
       LineaEstado('MES DE PROCESO: '+cMes(nNroMesTde,10),cNomSis)

       nNroFil := nMarco(nFilPal+1,'POR FAVOR ENTRE LOS DESCUENTOS'+;
			 ' O RECARGOS PARA EL MES ESCOGIDO',22,'°')

       aTamCol := {06,06,26,16,10,10}
       aTitulo := {'CODIGO'      ,'GRUPO '    ,'NOMBRE',;
		   'DESCRIPCION ','VALOR     ','TIPO'}
       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>GRABACION DE LOS DESCUENTOS
       nNroFil++
       DO WHILE .T.


**********LECTURA DEL CODIGO NUEVO
	    cSavPan := SAVESCREEN(nNroFil,0,nNroFil,79)
	    IF lNuevos

	       cNalias := 'ADM'

	       IF lLeeCodAdm(nNroFil,aNroCol[1],;
			     @cCodigoTes,{||lLocCodigo('cNumeroAdm',;
					    'ADM',cCodigoTes,;
					    'NUMERO DE INSCRIPCION')})
		   EXIT
	       ENDIF
	       cCodigoTes := ADM->cCodigoEst
	    ENDIF
**********FIN LECTURA DEL CODIGO NUEVO

**********LECTURA DEL CODIGO ANTIGUO
	    IF !lNuevos
	       cCodigoTes := cLeeCodEst(nNroFil,aNroCol[1],cMaeAlu,@cMaeAct)
		  cNalias := cMaeAct
	    ENDIF
**********FIN LECTURA DEL CODIGO ANTIGUO

**********VALIDACION DEL CODIGO
	    IF LASTKEY() == K_ESC .OR. EMPTY(cCodigoTes) .OR.;
	       EMPTY(cNalias)
	       EXIT
	    ENDIF
	    cNombreTes := ALLTRIM(RTRIM(&cNalias->cApelliEst)+' '+;
				  &cNalias->cNombreEst)
	    @ nNroFil,aNroCol[2] SAY &cNalias->cCodigoGru
	    @ nNroFil,aNroCol[3] SAY cNombreTes
**********FIN VALIDACION DEL CODIGO

**********VALIDACION DEL CUPO
	    IF !&cNalias->lSiCupoEst
	       cError(cNombreTes+' NO TIENE CUPO')
	       LOOP
	    ENDIF
**********FIN VALIDACION DEL CUPO

**********IMPRESION DEL ESTUDIANTE
	     cNombreTes := SUBS(cNombreTes,1,26)
	     @ nNroFil,aNroCol[2] SAY &cNalias->cCodigoGru
	     @ nNroFil,aNroCol[3] SAY cNombreTes
**********FIN IMPRESION DEL ESTUDIANTE

**********INICIALIZACION DEL VALOR DE LOS CONCEPTOS
	    FOR i := 1 TO 8
	       aVlrCon[i] := 0
	    ENDFOR
**********FIN INICIALIZACION DEL VALOR DE LOS CONCEPTOS

**********LECTURA DEL DESCUENTO ACTUAL
	    IF lSekCodDes(cCodigoTes,nNroMesTde,.F.)

	       cDescriTde := DES->cDescriDes
		nValorTde := DES->nValorDes

		FOR i := 1 TO (LEN(cConcep)/2)
		   aVlrCon[i] := &('DES->nVlrCo'+STR(i,1)+'Des')
		ENDFOR
		cConcep := DES->cConcepDes
		lncluir := .F.
		nRegDes := RECNO()
	    ELSE
	       cDescriTde := cSpaces('DES','cDescriDes')
		nValorTde := 0
		cConcep := '.'+SPACE(15)
		lncluir := .T.
	    ENDIF
**********FIN LECTURA DEL DESCUENTO ACTUAL

**********LECTURA DEL DESCUENTOS
	    @ nNroFil,aNroCol[4] GET cDescriTde PICT "@!S16";
		      VALID (cDescriTde) # cSpaces('DES','cDescriDes')

	    @ nNroFil,aNroCol[5] GET nValorTde  PICT "9999999.99";
		      VALID nValorTde # 0
	    READ
**********FIN LECTURA DEL DESCUENTOS

**********PREGUNTA DE DECISION
	    nNroOpc := nLeeOpcion('1<DESCUENTO> 2<RECARGO> '+;
				  '3<PAGO PARCIAL> 4<NO GRABAR>?',4,'0')
	    IF nNroOpc == 4
	       RESTSCREEN(nNroFil,00,nNroFil,79,cSavLin)
	       LOOP
	    ENDIF
**********FIN PREGUNTA DE DECISION

**********ANALISIS DEL TIPO DE DESCUENTO
	    DO CASE
	    CASE nNroOpc == 1
		    cTipDes := 'DESCUENTO'
		 nTipDesTde := 1

	    CASE nNroOpc == 2
		    cTipDes := 'RECARGO'
		 nTipDesTde := 2

	    CASE nNroOpc == 3
		    cTipDes := 'PAGO PARCIAL'
		 nTipDesTde := 4
	    ENDCASE
	    @ nNroFil,aNroCol[6] SAY cNombreDes(nTipDesTde)
**********FIN ANALISIS DEL TIPO DE DESCUENTO

**********LECTURA DE LOS CONCEPTOS
	    cSavPan := SAVESCREEN(0,0,24,79)

	    DO WHILE .T.
	       cTxtTem := 'ESCOJA LOS CONCEPTOS DEL '+cTipDes+':'
	       @ 21,24 SAY cTxtTem GET cConcep PICT "@!";
			    VALID lValLeeCon(nNroFil+1,02,21,25+LEN(cTxtTem),;
					     @cConcep)
	       READ
	       IF EMPTY(cConcep) .OR.;
		  !lPregunta('DESEA APLICAR LOS CONCEPTOS? Si No')
		  LOOP
	       ENDIF
	       EXIT
	    ENDDO
	    cConcep := ALLTRIM(cConcep)
	    RESTSCREEN(0,0,24,79,cSavPan)
**********FIN LECTURA DE LOS CONCEPTOS

**********ASIGNACION DE VALOR DE UN SOLO CONCEPTO
	    IF LEN(ALLTRIM(cConcep))/2 == 1
	       aVlrCon[1] := nValorTde
	    ELSE
	       cError('DEBE DEFINIR EL VALOR PARA '+;
		      'CADA UNO DE LOS CONCEPTOS')
	    ENDIF
**********FIN ASIGNACION DE VALOR DE UN SOLO CONCEPTO

/*
**********LECTURA DEL VALOR DE LOS CONCEPTOS
	    IF LEN(ALLTRIM(cConcep))/2 > 1
	       DO WHILE .T.

*-----------------LECTURA DE LOS CONCEPTOS
		    FOR i := 1 TO (LEN(cConcep)/2)
			cError('i:='+str(i,1))
			@ 10+i,10 GET aVlrCon[i] PICT '9999999.99';
				       VALID {|oLeeGet|Prueba1(oLeeGet)};
				       WHEN {|oLeeGet|Prueba2(oLeeGet)}
		    READ
		    ENDFOR
*-----------------FIN LECTURA DE LOS CONCEPTOS

*-----------------VALIDACION DEL TOTAL LEIDO
		    nVlrTot := 0
		    FOR i := 1 TO (LEN(cConcep)/2)
			nVlrTot += aVlrCon[i]
		    ENDFOR

		    IF nVlrTot # nValorTde
		       cError('VALOR NO COINCIDE')
		       LOOP
		    ENDIF
		    EXIT
*-----------------FIN VALIDACION DEL TOTAL LEIDO

	       ENDDO

	    ENDIF
**********FIN LECTURA DEL VALOR DE LOS CONCEPTOS
*/

**********LECTURA DE LA FECHA DEL PAGO PARCIAL
	    dFechaTde := DATE()
	    IF nTipDesTde == 4
	       cSavLin := SAVESCREEN(21,00,21,79)
	       DO WHILE .T.
		  @ 21,20 SAY 'FECHA DEL PAGO PARCIAL:' GET dFechaTde PICT '@D';
			  VALID {||HelpRead()};
			  WHEN  {||HelpRead('FECHA')}
		 READ
		 IF !EMPTY(dFechaTde)
		    EXIT
		 ENDIF
	       ENDDO
	       RESTSCREEN(21,00,21,79,cSavLin)
	    ENDIF
**********FIN LECTURA DE LA FECHA DEL PAGO PARCIAL

/* OJO

**********LECTURA Y VALIDACION DEL TIPO DE PAGO
	    cCodigoTfp := cSpaces('DES','cCodigoFpg')
	    IF nTipDesTde == 4

	       cCodigoTfp := DES->cCodigoFpg
	       IF CAA->lForPagCaA

		  cSavLin := SAVESCREEN(21,00,21,79)
		  @ 21,20 SAY 'INGRESE EL TIPO DE PAGO';
			  GET cCodigoTfp PICT '@!';
			  VALID lValidaFpg(10,20,@cCodigoTfp)
		  READ
		  RESTSCREEN(21,00,21,79,cSavLin)

	       ENDIF
	    ENDIF
**********FIN LECTURA Y VALIDACION DEL TIPO DE PAGO

*/

**********LECTURA DEL NUMERO DE LA FORMA DE PAGO
	    cNroFpgTde := cSpaces('DES','cNroFpgDes')
	    IF nTipDesTde == 4
	       cNroFpgTde := DES->cNroFpgDes
	       IF lLocCodigo('cCodigoFpg','FPG',cCodigoTfp)

		  cTituloTfp := 'INGRESE EL NUMERO '+ALLTRIM(FPG->cTituloFpg)
		  IF FPG->lLeeNroFpg
		     cSavLin := SAVESCREEN(21,00,21,79)
		     @ 21,20 SAY cTituloTfp GET cNroFpgTde PICT '@!'
		     READ
		     RESTSCREEN(21,00,21,79,cSavLin)
		  ENDIF

	       ENDIF
	    ENDIF
**********FIN LECTURA DEL NUMERO DE LA FORMA DE PAGO

**********LECTURA DEL NOMBRE DEL CONCEPTO REGARGO
	    cNombreTco := cSpaces('CON','cNombreCon')
	    IF ANO->lNomConDes

	       DO CASE
	       CASE nTipDesTde == 1 // DESCUENTO

		    cNombreTco := DES->cNombreCon

		    cSavLin := SAVESCREEN(21,00,21,79)
		    @ 21,20 SAY 'CONCEPTO DEL DESCUENTO PARA EL RECIBO' GET cNombreTco PICT '@!'
		    READ
		    RESTSCREEN(21,00,21,79,cSavLin)

	       CASE nTipDesTde == 2 // RECARGO

		    cNombreTco := DES->cNombreCon

		    cSavLin := SAVESCREEN(21,00,21,79)
		    @ 21,20 SAY 'CONCEPTO DEL RECARGO PARA EL RECIBO' GET cNombreTco PICT '@!'
		    READ
		    RESTSCREEN(21,00,21,79,cSavLin)

	       OTHERWISE
	       ENDCASE

	    ENDIF
**********LECTURA DEL NOMBRE DEL CONCEPTO DESCUENTO REGARGO

**********ANALISIS PARA LA GRABACION
	    SELECT DES
	    IF lncluir
	       lGrabar := DES->(lRegLock(lShared,.T.))
	    ELSE
	       GO nRegDes
	       lGrabar := DES->(lRegLock(lShared,.F.))
	    ENDIF
**********FIN ANALISIS PARA LA GRABACION


**********GRABACION DEL MES Y VALOR DEL DESCUENTO
	    IF lGrabar
	       REPL DES->cCodigoEst WITH cCodigoTes
	       REPL DES->cApelliEst WITH &cNalias->cApelliEst
	       REPL DES->cNombreEst WITH &cNalias->cNombreEst
	       REPL DES->nNroMesDes WITH nNroMesTde
	       REPL DES->nTipDesDes WITH nTipDesTde
	       REPL DES->cDescriDes WITH cDescriTde
	       REPL DES->nValorDes  WITH nValorTde
	       REPL DES->dFechaDes  WITH dFechaTde
	       REPL DES->cCodigoFpg WITH cCodigoTfp
	       REPL DES->cNroFpgDes WITH cNroFpgTde
	       REPL DES->cConcepDes WITH cConcep
	       REPL DES->cNombreCon WITH cNombreTco
	       FOR i := 1 TO (LEN(cConcep)/2)
		   REPL &('DES->nVlrCo'+STR(i,1)+'Des');
		   WITH aVlrCon[i]
	       ENDFOR

	       REPL DES->cNomUsrDes WITH cNomUsr
	       REPL DES->dFecUsrDes WITH DATE()
	       REPL DES->cHorUsrDes WITH TIME()
	       DES->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABAN LOS DETALLES DEL DESCUENTO')
	    ENDIF
	    IF lShared
	       DES->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL MES Y VALOR DEL DESCUENTO

**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    IF nNroFil > 19

*--------------IMPRESION DEL ULTIMO REGISITRO
		 nNroFil := nMarco(nFilPal+1,'POR FAVOR ENTRE LOS DESCUENTOS'+;
				   ' O RECARGOS PARA EL MES ESCOGIDO',22,'°')
		 @ nNroFil,nNroCol SAY cMsgTxt

		 nNroFil++
		 SET COLOR TO I
		 @ nNroFil,aNroCol[1] SAY cCodigoTes
		 SET COLOR TO
		 @ nNroFil,aNroCol[2] SAY &cNalias->cCodigoGru
		 @ nNroFil,aNroCol[3] SAY cNombreTes
		 SET COLOR TO I
		 @ nNroFil,aNroCol[4] SAY cDescriTde PICT '@S16'
		 @ nNroFil,aNroCol[5] SAY nValorTde  PICT '9999999.99'
		 @ nNroFil,aNroCol[6] SAY cNombreDes(nTipDesTde)
		 SET COLOR TO

		 nNroFil++
*--------------FIN IMPRESION DEL ULTIMO REGISITRO

	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

       ENDDO
       DES->(DBCLEARINDEX())                // Cierra los indixes
       SETCURSOR(0)                         // Activaci¢n del cursor
       RETURN NIL
*>>>>GRABACION DE LOS DESCUENTOS

/*************************************************************************
* TITULO..: MENU DE OTROS PARA EL ARCHIVO                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 29/2014 MIE A
       Colombia, Bucaramanga        INICIO: 03:00 PM   OCT 29/2014 MIE

OBJETIVOS:

1- Menu de Otros para el archivo

2- Retorna NIL


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuOtrDes(aP1,aP2,aP3,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       oBrowse                              // Browse del Archivo */
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
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARCION Y EJECUCION DEL MENU
       AADD(aMenus,'1<IMPRESION DE DESCUENTOS/RECARGOS >')
       AADD(aMenus,'2<DESCUENTOS/RECARGOS POR CONCEPTOS>')

       AADD(aAyuda,'Permite Imprimir la Relaci¢n de Abonos,Descuentos y Recargos')
       AADD(aAyuda,'Permite Imprimir la Relaci¢n de Abonos,Descuentos y Recargos por Conceptos')

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

	    OtrDes011(aP1,aP2,aP3,oBrowse)
	   *Impresi¢n Abonos,Descuentos y recargos

       CASE nNroOpc == 2

	    OtrDes012(aP1,aP2,aP3,oBrowse)
	   *Impresi¢n Abonos,Descuentos y recargos por conceptos

       ENDCASE
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: DESCUENTOS RECARGOS POR INTERVALO DE FECHAS                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 03/2006 LUN A
       Colombia, Bucaramanga        INICIO: 10:00 AM   ABR 03/2006 LUN

OBJETIVOS:

1- Debe estar en uso el archivo

2- Permite imprimir los abonos descuentos y recargos por intervalo de
   fechas.

3- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrDes011(aP1,aP2,aP3,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       oBrowse                              // Browse del Archivo */
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
       #INCLUDE "ARC-MATR.PRG"              // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
     *ÀVariables Generales

       LOCAL     i,j := 0                   // Contadores
       LOCAL cOpcSys := ''                  // Opci¢n del Sistema
       LOCAL nNroIso := ''                  // N£mero Iso del Informe
       LOCAL cCodIso := ''                  // C¢digo Iso del Informe
       LOCAL aTitIso := ''                  // T¡tulo Iso del Informe
       LOCAL cPiePag := ''                  // Pie de P gina por defecto
       LOCAL aPieIso := {}		    // Textos del pie de p gina
       LOCAL nTotPie := 0                   // Total de Pie de p ginas
       LOCAL aMezIso := {}                  // Campos a Mesclar
       LOCAL bInsIso := NIL                 // Block de Gestion Documental
     *ÀVariables Gestion Documental

       LOCAL nRegPrn := 0                   // Registro de Impresi¢n
       LOCAL cFecPrn := ''                  // @Fecha de Impresi¢n
       LOCAL cHorPrn := ''                  // @Hora de Impresi¢n
       LOCAL cDiaPrn := ''                  // @D¡a de Impresi¢n
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabPrn := {}                  // Encabezado del informe General
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitPrn := {}                  // T¡tulos para impresi¢n
       LOCAL aRegPrn := {}                  // Registros para impresi¢n
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
       LOCAL aCabXml := {}                  // Encabezado del Xml
       LOCAL aCamXml := {}                  // Campo Xml
       LOCAL aRegXml := {}                  // Registro Xml
     *ÀVariables de informe

       LOCAL nOpcion := 0                   // Opci¢n de selecci¢n
       LOCAL lValida := .F.                 // Validar Descuentos
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL lFechOk := .T.                 // Fecha de Acuerdo al intervalo
       LOCAL cTxtTem := ''                  // Texto Temporal

       LOCAL nVlrPag := 0                   // Valor Pagos Parciales
       LOCAL nVlrDes := 0                   // Valor Descuentos
       LOCAL nVlrRec := 0                   // Valor Recargos
       LOCAL nTotPag := 0                   // Total Pagos Parciales
       LOCAL nTotDes := 0                   // Total Descuentos
       LOCAL nTotRec := 0                   // Total Recargos

       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL dFecIni := CTOD('00/00/00')    // Fecha Inicial
       LOCAL dFecFin := CTOD('00/00/00')    // Fecha Final
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL nNroMesTde := 0                // Mes del descuento
       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
       LOCAL cNombreTes := ''               // Nombre del estudiante
     *ÀVariables temporales de campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA DEL MES
       nNroMesTde := 13
*>>>>FIN CAPTURA DEL MES

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE

       CASE MTR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE DES->(RECCOUNT()) == 0
	    cError('NO EXISTEN DESCUENTOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS


*>>>>GESTION DOCUMENTAL DEL INFORME
       nLenPrn := PCL('n17Stan')

       nNroIso := 541
     *ÀN£mero de identificaci¢n del informe

       cOpcSys := '<ACTUALIZAR><DESCUENTOS/RECARGOS>'+;
		  '<ACTIVAR INDIVIDUALES><F9>'+;
		  '<IMPRESION DE DESCUENTOS/RECARGOS>'
     *ÀOpci¢n del sistema del informe

       aMezIso := {}
       AADD(aMezIso,{'<cAnoUsr>',cAnoUsr})
       AADD(aMezIso,{'<cJorTxt>',cJorTxt})
     *ÀCampos a sustituir

       aTitIso := {}
       AADD(aTitIso,'A¥O: <cAnoUsr> JORNADA: <cJorTxt>')        // T¡tulo Uno
       AADD(aTitIso,'RELACION DE DESCUENTOS, RECARGOS') // T¡tulo Dos
       AADD(aTitIso,'')                                         // T¡tulo Tres
     *ÀT¡tulos del Informe por defecto

       cPiePag := ALLTRIM(MTR->cPiePagMtr)
       IF !EMPTY(cPiePag)
	  cPiePag := SPACE((nLenPrn-LEN(cTxtPrn))/2)+cPiePag
       ENDIF

       aPieIso := {}
       AADD(aPieIso,'')                 // Pie de p gina Uno
       AADD(aPieIso,'')                 // Pie de p gina Dos
       AADD(aPieIso,IF(EMPTY(cPiePag),'',cPiePag))  // Pie de p gina Tres
     *ÀPie de p ginas por defecto

       bInsIso := {||lModRegIso(lShared,cNomUsr,oBrowse,;
				nNroIso,aTitIso[1],cOpcSys)}
     *ÀInclusi¢n o modificaci¢n de la gesti¢n docuemental
*>>>>FIN GESTION DOCUMENTAL DEL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       nRegPrn := PRN->(RECNO())
       nLenPrn := PCL('n17Stan')

       IF MTR->lPrnArcMtr
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'MatriDes'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,MTR->cOpcPrnMtr,.F.,.T.,bInsIso,PathDoc)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
       SET DEVICE TO SCREEN
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  RETURN NIL
       ENDIF
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>SUSTITUCION DE TEXTO
       DetalleIso(nNroIso,@cCodIso,@aTitIso,@aPieIso)

       IF !EMPTY(cCodIso)
	  cCodIso := 'ISO:'+cCodIso
       ENDIF

       FOR i := 1 TO LEN(aTitIso)
	   FOR j := 1 TO LEN(aMezIso)
	       aTitIso[i] := cReplTxt(aMezIso[j,1],aMezIso[j,2],aTitIso[i])
	   ENDFOR
       ENDFOR

       nTotPie := 0
       FOR i := 1 TO LEN(aPieIso)
	   IF EMPTY(aPieIso[i])
	      LOOP
	   ENDIF
	   nTotPie++
       ENDFOR
*>>>>FIN SUSTITUCION DE TEXTO

*>>>>DEFINICION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.
       nLinTot := 2

       nTotReg := DES->(RECCOUNT())
       nTotReg := nTotReg+nLinTot

       aCabPrn := {cNomEmp,cNomSis+cCodIso,;
		   aTitIso[1],;
		   aTitIso[2],;
		   ''}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
                   nNroPag++,;
                   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINICION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {06,06,30,08,12,12,12,12,40}
       aTitPrn := {'CODIGO','GRUPO ','NOMBRE DEL ESTUDIANTE ',;
		   'MES ','FECHA','PAGO PARCIAL','DESCUENTOS','RECARGOS',;
		   'DESCRIPCION '}
       aCamXml := aTitPrn
       cCabCol := cRegPrint(aTitPrn,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       lCentra := .F.
       nColCab := 0
       IF lCentra
          nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
                               nColCab,cCodFin,aCabSec,;
                               @cFecPrn,@cHorPrn,@cDiaPrn)}
       bDerAut := {||PiePagPrn(aPieIso,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>IMPRESION DEL ENCABEZADO
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
       SET DEVICE TO SCREEN
      *Impresi¢n del Encabezado

       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)

       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,nOpcPrn,aCabPrn,aTitPrn)
*>>>>FIN IMPRESION DEL ENCABEZADO

*>>>>RECORRIDO DE LOS REGISTROS
       cSavPan := SAVESCREEN(0,0,24,79)
       Termometro(0,'IMPRIMIENDO')

       SELECT DES
       DES->(DBGOTOP())
       DO WHILE .NOT. DES->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstados('REGISTROS: '+DES->(STR(RECNO(),5))+'/'+;
				       DES->(STR(RECCOUNT(),5)),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( DES->(RECNO()) / DES->(RECCOUNT()) )*100)

            IF STR(nAvance,3) $ '25 50 75100'
	       Termometro(nAvance)
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

***********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
		cNalias := ''
	     cNombreTes := ' ALUMNO NO EXISTE'+SPACE(50)

	     IF lSekCodMae(DES->cCodigoEst,cMaeAlu,@cNalias,.F.)

		cNombreTes := RTRIM(&cNalias->cApelliEst)+' '+;
				    &cNalias->cNombreEst
		cCodigoTgr := &cNalias->cCodigoGru

	     ELSE

		cNombreTes := RTRIM(DES->cApelliEst)+' '+;
				    DES->cNombreEst
		cCodigoTgr := SPACE(04)

	     ENDIF
	     cNombreTes := SUBS(cNombreTes+SPACE(30),1,30)
***********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

***********ACUMULACION DEL TIPO DE DESCUENTO
	     lFechOk := .T.
	     nVlrDes := 0
	     nVlrRec := 0
	     nVlrPag := 0

	     IF lFechOk
		DO CASE
		CASE DES->nTipDesDes == 1  // Descuento
		     nVlrDes := DES->nValorDes
		     nTotDes += nVlrDes

		CASE DES->nTipDesDes == 2  // Recargo
		     nVlrRec := DES->nValorDes
		     nTotRec += nVlrRec

		CASE DES->nTipDesDes == 4  // Pago Parcial
		     nVlrPag := DES->nValorDes
		     nTotPag += nVlrPag
		ENDCASE
	     ENDIF
***********FIN ACUMULACION DEL TIPO DE DESCUENTO

**********IMPRESION DEL REGISTRO
	    IF lFechOk
	       aRegPrn := {}
	       AADD(aRegPrn,DES->cCodigoEst)
	       AADD(aRegPrn,cCodigoTgr)
	       AADD(aRegPrn,cNombreTes)

	       AADD(aRegPrn,STR(DES->nNroMesDes,2))

	       AADD(aRegPrn,cFecha(DES->dFechaDes))

	       AADD(aRegPrn,TRANS(nVlrPag,;
		    IF(nOpcPrn == 8,'@Z ##########','@Z ####,###,###')))

	       AADD(aRegPrn,TRANS(nVlrDes,;
		    IF(nOpcPrn == 8,'@Z ##########','@Z ####,###,###')))

	       AADD(aRegPrn,TRANS(nVlrRec,;
		    IF(nOpcPrn == 8,'@Z ##########','@Z ####,###,###')))

	       AADD(aRegPrn,cTxtTem+DES->cDescriDes)

	       lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		       aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

	       AADD(aRegPrn,'') // Campo Url

	    ENDIF
**********FIN IMPRESION DEL REGISTRO

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT DES
	    DES->(DBSKIP())
	    IF DES->(EOF())
	       Termometro(100)
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN RECORRIDO DE LOS REGISTROS

*>>>>IMPRESION ENCABEZADO DEL INFORME PARA TOTALES DE CONTROL
       SET DEVICE TO PRINT
       IF PROW() > 58 - nLinTot .OR. PROW() = 0
	  IF PROW() <> 0
	     EVAL(bDerAut)
	    *Impresi¢n de derechos
	     EJECT
	  ENDIF
	  EVAL(bCabeza)
	 *Impresi¢n del Encabezado
       ENDIF
*>>>>FIN IMPRESION ENCABEZADO DEL INFORME PARA TOTALES DE CONTROL

*>>>>IMPRESION DE LOS TOTALES
       @ PROW()+1,nColTxt(aNroCol,06) SAY REPL('-',aNroCol[06])
       @ PROW()  ,nColTxt(aNroCol,07) SAY REPL('-',aNroCol[07])
       @ PROW()  ,nColTxt(aNroCol,08) SAY REPL('-',aNroCol[08])


       @ PROW()+1,00 SAY 'TOTALES ...'
       @ PROW()  ,nColTxt(aNroCol,06) SAY TRANS(nTotPag,"$###,###,###")
       @ PROW()  ,nColTxt(aNroCol,07) SAY TRANS(nTotDes,"$###,###,###")
       @ PROW()  ,nColTxt(aNroCol,08) SAY TRANS(nTotRec,"$###,###,###")
*>>>>FIN IMPRESION DE LOS TOTALES

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       VerPrn(nOpcPrn,FilePrn,nHanXml)

       SET DEVICE TO SCREEN
       SET FILTER TO
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS


/*************************************************************************
* TITULO..: DESCUENTOS RECARGOS POR CONCEPTOS                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 17/2014 MIE A
       Colombia, Bucaramanga        INICIO: 09:00 AM   DIC 17/2014 MIE

OBJETIVOS:

1- Debe estar en uso el archivo

2- Permite imprimir los abonos descuentos y recargos por conceptos.

3- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrDes012(aP1,aP2,aP3,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       oBrowse                              // Browse del Archivo */
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
       #INCLUDE "ARC-MATR.PRG"              // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
     *ÀVariables Generales

       LOCAL     i,j := 0                   // Contadores
       LOCAL cOpcSys := ''                  // Opci¢n del Sistema
       LOCAL nNroIso := ''                  // N£mero Iso del Informe
       LOCAL cCodIso := ''                  // C¢digo Iso del Informe
       LOCAL aTitIso := ''                  // T¡tulo Iso del Informe
       LOCAL cPiePag := ''                  // Pie de P gina por defecto
       LOCAL aPieIso := {}		    // Textos del pie de p gina
       LOCAL nTotPie := 0                   // Total de Pie de p ginas
       LOCAL aMezIso := {}                  // Campos a Mesclar
       LOCAL bInsIso := NIL                 // Block de Gestion Documental
     *ÀVariables Gestion Documental

       LOCAL nRegPrn := 0                   // Registro de Impresi¢n
       LOCAL cFecPrn := ''                  // @Fecha de Impresi¢n
       LOCAL cHorPrn := ''                  // @Hora de Impresi¢n
       LOCAL cDiaPrn := ''                  // @D¡a de Impresi¢n
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabPrn := {}                  // Encabezado del informe General
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitPrn := {}                  // T¡tulos para impresi¢n
       LOCAL aRegPrn := {}                  // Registros para impresi¢n
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
       LOCAL aCabXml := {}                  // Encabezado del Xml
       LOCAL aCamXml := {}                  // Campo Xml
       LOCAL aRegXml := {}                  // Registro Xml
     *ÀVariables de informe

       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL dFecIni := CTOD('00/00/00')    // Fecha Inicial
       LOCAL dFecFin := CTOD('00/00/00')    // Fecha Final
       LOCAL lPrnFec := .F.                 // .T. Imprimir por Fechas
       LOCAL lValida := .F.                 // Validar Descuentos
       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL lHayPag := .F.                 // .T. Hay Pago
       LOCAL cTxtTem := ''                  // Texto Temporal

       LOCAL aVlrCon := {}                  // Descriminaci¢n por Conceptos
       LOCAL nTotDes := 0                   // Total Descuentos
       LOCAL nTotRec := 0                   // Total Recargos
       LOCAL nTotPag := 0                   // Total Pagos Parciales
       LOCAL aTotDes := {}                  // Descriminaci¢n de Descuentos
       LOCAL aTotRec := {}                  // Descriminaci¢n de Recargos
       LOCAL aTotPag := {}                  // Descriminaci¢n de Pagos Parciales
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL nNroMesTde := 0                // Mes del descuento
       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
       LOCAL cNombreTes := ''               // Nombre del estudiante
     *ÀVariables temporales de campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA DEL MES
       nNroMesTde := 13
*>>>>FIN CAPTURA DEL MES

*>>>>LECTURA DEL INTERVALO DE FECHAS
       dFecIni := CTOD('00/00/00')
       dFecFin := CTOD('00/00/00')

       IF lPregunta('DESEA EL INFORME POR INTERVALO DE FECHAS? No Si')

	  SET CURSOR ON
	  cSavPan := SAVESCREEN(0,0,24,79)
	  nNroFil := nMarco(10,'FECHA DE CORTE:',15,' ',NIL,20,47)

	  @ 22,20 SAY 'INGRESE LA FECHA EN EL SGTE ORDEN: (MM/DD/AA)'
	  @ nNroFil  ,21 SAY 'FECHA INICIAL :' GET dFecIni PICT '@D'
	  @ nNroFil+1,21 SAY 'FECHA FINAL   :' GET dFecFin PICT '@D'
	  READ

	  SET CURSOR OFF
	  RESTSCREEN(0,0,24,79,cSavPan)

	  IF EMPTY(dFecIni) .OR. EMPTY(dFecFin)
	     RETURN NIL
	  ENDIF

       ENDIF
*>>>>FIN LECTURA DEL INTERVALO DE FECHAS

*>>>>ANALISIS DE LA IMPRESION POR FECHAS
       IF EMPTY(dFecIni) .AND. EMPTY(dFecFin)
	  lPrnFec := .F.
       ELSE
	  lPrnFec := .T.
       ENDIF
       nTotReg := DES->(RECCOUNT())
*>>>>FIN ANALISIS DE LA IMPRESION POR FECHAS

*>>>>PREGUNTA DE DECISION
       lValida := lPregunta('DESEA VALIDAR LOS DESCUENTOS? No SI')
*>>>>FIN PREGUNTA DE DECISION

*>>>>GESTION DOCUMENTAL DEL INFORME
       nLenPrn := PCL('n17Stan')

       nNroIso := 542
     *ÀN£mero de identificaci¢n del informe

       cOpcSys := '<ACTUALIZAR><DESCUENTOS/RECARGOS>'+;
		  '<ACTIVAR INDIVIDUALES><F9>'+;
		  '<IMPRESION DE DESCUENTOS/RECARGOS>'
     *ÀOpci¢n del sistema del informe

       aMezIso := {}
       AADD(aMezIso,{'<cAnoUsr>',cAnoUsr})
       AADD(aMezIso,{'<cJorTxt>',cJorTxt})
     *ÀCampos a sustituir

       aTitIso := {}
       AADD(aTitIso,'A¥O: <cAnoUsr> JORNADA: <cJorTxt>')        // T¡tulo Uno
       AADD(aTitIso,'RELACION DE DESCUENTOS, RECARGOS') // T¡tulo Dos
       AADD(aTitIso,'')                                         // T¡tulo Tres
     *ÀT¡tulos del Informe por defecto

       cPiePag := ALLTRIM(MTR->cPiePagMtr)
       IF !EMPTY(cPiePag)
	  cPiePag := SPACE((nLenPrn-LEN(cTxtPrn))/2)+cPiePag
       ENDIF

       aPieIso := {}
       AADD(aPieIso,'')                 // Pie de p gina Uno
       AADD(aPieIso,'')                 // Pie de p gina Dos
       AADD(aPieIso,IF(EMPTY(cPiePag),'',cPiePag))  // Pie de p gina Tres
     *ÀPie de p ginas por defecto

       bInsIso := {||lModRegIso(lShared,cNomUsr,oBrowse,;
				nNroIso,aTitIso[1],cOpcSys)}
     *ÀInclusi¢n o modificaci¢n de la gesti¢n docuemental
*>>>>FIN GESTION DOCUMENTAL DEL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       nRegPrn := PRN->(RECNO())
       nLenPrn := PCL('n17Stan')

       IF MTR->lPrnArcMtr
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'MtrDesCon'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,MTR->cOpcPrnMtr,.F.,.T.,bInsIso,PathDoc)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
       SET DEVICE TO SCREEN
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  RETURN NIL
       ENDIF
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>SUSTITUCION DE TEXTO
       DetalleIso(nNroIso,@cCodIso,@aTitIso,@aPieIso)

       IF !EMPTY(cCodIso)
	  cCodIso := 'ISO:'+cCodIso
       ENDIF

       FOR i := 1 TO LEN(aTitIso)
	   FOR j := 1 TO LEN(aMezIso)
	       aTitIso[i] := cReplTxt(aMezIso[j,1],aMezIso[j,2],aTitIso[i])
	   ENDFOR
       ENDFOR

       nTotPie := 0
       FOR i := 1 TO LEN(aPieIso)
	   IF EMPTY(aPieIso[i])
	      LOOP
	   ENDIF
	   nTotPie++
       ENDFOR
*>>>>FIN SUSTITUCION DE TEXTO

*>>>>DEFINICION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.
       nLinTot := 2

       nTotReg := DES->(RECCOUNT())
       nTotReg := nTotReg+nLinTot

       aCabPrn := {cNomEmp,cNomSis+cCodIso,;
		   aTitIso[1],;
		   aTitIso[2],;
		   ''}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
                   nNroPag++,;
                   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINICION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {06,06,30,12,40,12,12,16,12}
       aTitPrn := {'CODIGO','GRUPO ','NOMBRE DEL ESTUDIANTE ',;
		   'FECHA','DESCRIPCION','TIPO','TOTAL','CONCEPTO',;
		   'VALOR'}
       aCamXml := aTitPrn
       cCabCol := cRegPrint(aTitPrn,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       lCentra := .F.
       nColCab := 0
       IF lCentra
          nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
                               nColCab,cCodFin,aCabSec,;
                               @cFecPrn,@cHorPrn,@cDiaPrn)}
       bDerAut := {||PiePagPrn(aPieIso,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>IMPRESION DEL ENCABEZADO
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
       SET DEVICE TO SCREEN
      *Impresi¢n del Encabezado

       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)

       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,nOpcPrn,aCabPrn,aTitPrn)
*>>>>FIN IMPRESION DEL ENCABEZADO

*>>>>RECORRIDO DE REGISTROS
       SELECT DES
       DES->(DBGOTOP())
       DO WHILE .NOT. DES->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstados('CODIGO:'+DES->cCodigoEst+' '+;
			 'REGISTROS: '+DES->(STR(RECNO(),5))+'/'+;
				       DES->(STR(RECCOUNT(),5)),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

***********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
		cNalias := ''
	     cNombreTes := ' ALUMNO NO EXISTE'+SPACE(50)

	     IF lSekCodMae(DES->cCodigoEst,cMaeAlu,@cNalias,.F.)

		cNombreTes := RTRIM(&cNalias->cApelliEst)+' '+;
				    &cNalias->cNombreEst
		cCodigoTgr := &cNalias->cCodigoGru

	     ELSE

		cNombreTes := RTRIM(DES->cApelliEst)+' '+;
				    DES->cNombreEst
		cCodigoTgr := SPACE(04)

	     ENDIF
	     cNombreTes := SUBS(cNombreTes+SPACE(30),1,30)
	     lHayPag := lLocPagMat(DES->cCodigoEst,13,.F.)
***********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

***********ANALISIS DE LA FECHA DE PAGO
	     IF lPrnFec

		IF lHayPag

		   IF (PAG->dFecPagPag < dFecIni  .OR.;
		       PAG->dFecPagPag > dFecFin)

		       DES->(DBSKIP())
		       LOOP

		   ENDIF

		ELSE
		   DES->(DBSKIP())
		   LOOP
		ENDIF

	     ENDIF
***********FIN ANALISIS DE LA FECHA DE PAGO

***********ACUMULACION DEL TIPO DE DESCUENTO
	     lHayErr := .F.
	     aVlrCon := {}

	     DO CASE
	     CASE DES->nTipDesDes == 1  // Descuento

		  nTotDes += DES->nValorDes
		  VlrConDes(DES->nValorDes,aVlrCon)

		  SumArrCon(aTotDes,aVlrCon)

	     CASE DES->nTipDesDes == 2  // Recargo

		  nTotRec += DES->nValorDes
		  VlrConDes(DES->nValorDes,aVlrCon)

		  SumArrCon(aTotRec,aVlrCon)

	     CASE DES->nTipDesDes == 4  // Pago Parcial

		  nTotPag += DES->nValorDes
		  VlrConDes(DES->nValorDes,aVlrCon)

		  SumArrCon(aTotPag,aVlrCon)
	     ENDCASE
***********FIN ACUMULACION DEL TIPO DE DESCUENTO

***********IMPRESION DE LA NOVEDAD
	     aRegPrn := {}
	     AADD(aRegPrn,DES->cCodigoEst)
	     AADD(aRegPrn,cCodigoTgr)
	     AADD(aRegPrn,cNombreTes)
	     IF lHayPag .AND. DES->cCodigoEst == PAG->cCodigoEst
		AADD(aRegPrn,cFecha(PAG->dFecPagPag))
	     ELSE
		AADD(aRegPrn,'')
	     ENDIF
	     AADD(aRegPrn,cTxtTem+DES->cDescriDes)
	     AADD(aRegPrn,cTipDes())
	     AADD(aRegPrn,TRANS(DES->nValorDes,'@Z ####,###,###'))

	     IF LEN(aVlrCon) >= 1
		AADD(aRegPrn,aVlrCon[1,2])
		AADD(aRegPrn,TRANS(aVlrCon[1,3],'@Z ####,###,###'))
	     ELSE
		IF EMPTY(aVlrCon)
		   AADD(aRegPrn,'?')
		   AADD(aRegPrn,'?')
		ELSE
		   AADD(aRegPrn,'error')
		   AADD(aRegPrn,'error')
		ENDIF
	     ENDIF
	   *ÀImpresi¢n del Primer Concepto

	     cTxtPrn := cRegPrint(aRegPrn,aNroCol)
	     IF lHayErr
		cTxtPrn += '?revisar'
	     ELSE
		cTxtPrn += IF(DES->nValorDes # nSuma(aVlrCon,3),'?REVISAR','')
	     ENDIF
	     lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		     aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
***********FIN IMPRESION DE LA NOVEDAD

***********IMPRESION DE LOS RESTANTES CONCEPTOS DESCRIMINADOS
	     IF LEN(aVlrCon) > 1
		FOR i := 2 TO LEN(aVlrCon)
		    aRegPrn := {'','','','','','','',;
				aVlrCon[i,2],;
				TRANS(aVlrCon[i,3],'@Z ####,###,###')}

		    cTxtPrn := cRegPrint(aRegPrn,aNroCol)
		    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
			    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
		ENDFOR
	     ENDIF
***********FIN IMPRESION DE LOS RESTANTES CONCEPTOS DESCRIMINADOS


	  DES->(DBSKIP())

       ENDDO
*>>>>FIN RECORRIDO DE REGISTROS

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
*>>>>FIN IMPRESION DERECHOS

*>>>>IMPRESION ENCABEZADO DEL RESUMEN
       aNroCol := {18,12,16,12}
       aRegPrn := {'RESUMEN','TOTAL ','CONCEPTO','TOTAL'}

       cTxtPrn := cRegPrint(aRegPrn,aNroCol)
       lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
*>>>>FIN IMPRESION ENCABEZADO DEL RESUMEN


*>>>>TOTAL DESCUENTOS
       aRegPrn := {}
       IF nTotDes # 0
	  AADD(aRegPrn,'DESCUENTOS')
	  AADD(aRegPrn,TRANS(nTotDes,"$###,###,###"))

	  IF LEN(aTotDes) >= 1
	     AADD(aRegPrn,aTotDes[1,2])
	     AADD(aRegPrn,TRANS(aTotDes[1,3],'@Z ####,###,###'))
	  ELSE
	     IF EMPTY(aTotDes)
		AADD(aRegPrn,'?')
		AADD(aRegPrn,'?')
	     ELSE
		AADD(aRegPrn,'error')
		AADD(aRegPrn,'error')
	     ENDIF
	  ENDIF

	  cTxtPrn := cRegPrint(aRegPrn,aNroCol)+;
		     IF(nTotDes # nSuma(aTotDes,3),'?REVISAR','')
	  lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)

	  IF LEN(aTotDes) > 1
	     FOR i := 2 TO LEN(aTotDes)
		 aRegPrn := {'','',;
			     aTotDes[i,2],;
			     TRANS(aTotDes[i,3],'@Z ####,###,###')}
		 cTxtPrn := cRegPrint(aRegPrn,aNroCol)
		 lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
	     ENDFOR
	  ENDIF

       ENDIF
*>>>>FIN TOTAL DESCUENTOS

*>>>>TOTAL RECARGOS
       aRegPrn := {}
       IF nTotRec # 0

	  AADD(aRegPrn,'RECARGOS')
	  AADD(aRegPrn,TRANS(nTotRec,"$###,###,###"))

	  IF LEN(aTotRec) >= 1
	     AADD(aRegPrn,aTotRec[1,2])
	     AADD(aRegPrn,TRANS(aTotRec[1,3],'@Z ####,###,###'))
	  ELSE
	     IF EMPTY(aTotRec)
		AADD(aRegPrn,'?')
		AADD(aRegPrn,'?')
	     ELSE
		AADD(aRegPrn,'error')
		AADD(aRegPrn,'error')
	     ENDIF
	  ENDIF

	  cTxtPrn := cRegPrint(aRegPrn,aNroCol)+;
		     IF(nTotRec # nSuma(aTotRec,3),'?REVISAR','')

	  lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)

	  IF LEN(aTotRec) > 1
	     FOR i := 2 TO LEN(aTotRec)
		 aRegPrn := {'','',;
			     aTotRec[i,2],;
			     TRANS(aTotRec[i,3],'@Z ####,###,###')}
		 cTxtPrn := cRegPrint(aRegPrn,aNroCol)
		 lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
	     ENDFOR
	  ENDIF

       ENDIF
*>>>>FIN TOTAL RECARGOS

*>>>>TOTAL PAGO PARCIAL
       aRegPrn := {}
       IF nTotPag # 0

	  AADD(aRegPrn,'PAGO PARCIAL')
	  AADD(aRegPrn,TRANS(nTotPag,"$###,###,###"))

	  IF LEN(aTotPag) >= 1
	     AADD(aRegPrn,aTotPag[1,2])
	     AADD(aRegPrn,TRANS(aTotPag[1,3],'@Z ####,###,###'))
	  ELSE
	     IF EMPTY(aTotPag)
		AADD(aRegPrn,'?')
		AADD(aRegPrn,'?')
	     ELSE
		AADD(aRegPrn,'error')
		AADD(aRegPrn,'error')
	     ENDIF
	  ENDIF

	  cTxtPrn := cRegPrint(aRegPrn,aNroCol)+;
		     IF(nTotPag # nSuma(aTotPag,3),'?REVISAR','')
	  lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)

	  IF LEN(aTotPag) > 1
	     FOR i := 2 TO LEN(aTotPag)
		 aRegPrn := {'','',;
			     aTotPag[i,2],;
			     TRANS(aTotPag[i,3],'@Z ####,###,###')}
		 cTxtPrn := cRegPrint(aRegPrn,aNroCol)
		 lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
	     ENDFOR
	  ENDIF

       ENDIF
*>>>>FIN TOTAL PAGO PARCIAL

*>>>>IMPRESION DERECHOS
       DerechosPrn(cNomSis,cNomEmp,PCL('n20Stan'))
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       VerPrn(nOpcPrn,FilePrn)

       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS


