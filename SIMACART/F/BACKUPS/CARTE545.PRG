/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : ACTUALIZAR
SUBMODULO...: DESCUENTOS/RECARGOS - ELIMINAR

**************************************************************************
* TITULO..: ELIMINAR DESCUENTOS Y RECARGOS                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 12/2009 JUE
       Colombia, Bucaramanga        INICIO: 10:00 PM   MAR 12/2009 JUE

OBJETIVOS:

1- Permite eliminar los descuentos o recargos antes de ser facrurados.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_545(aP1,aP2,aP3)

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
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"              // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar l¡nea
       LOCAL lHayErr := .F.                 // .T. Hay Error

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

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+FileDes,'DES',;
			 cPatSis+'\'+fNtxDes,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,PathUno+'\'+cPatSis,cMaeAlu,cAnoSis) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTEN ALUMNOS GRABADOS')

       CASE CAA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL A¥O')

       CASE DES->(RECCOUNT()) == 0
	    cError('NO EXISTEN DESCUENTOS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>SELECION DE MES A PROCESAR
       nNroMesTde := nMesano(nFilInf+1,IF(nColInf>30,30,nColInf),NIL,.F.)
       IF nNroMesTde == 0
	  RETURN NIL
       ENDIF
       LineaEstado('MES DE PROCESO: '+cMes(nNroMesTde,10),cNomSis)
*>>>>FIN SELECION DE MES A PROCESAR

*>>>>IMPRESION DE LOS ENCABEZADOS
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

**********LECTURA DEL CODIGO DEL ESTUDIANTE
	    cSavLin := SAVESCREEN(nNroFil,00,nNroFil,79)
	    cCodigoTes := cLeeCodEst(nNroFil,aNroCol[1],;
				     cMaeAlu,@cMaeAct)
	    IF EMPTY(cCodigoTes)
	       EXIT
	    ENDIF
	    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			  RTRIM(&cMaeAct->cNombreEst)
**********FIN LECTURA DEL CODIGO DEL ESTUDIANTE

**********IMPRESION DEL ESTUDIANTE
	     cNombreTes := SUBS(cNombreTes,1,26)
	     @ nNroFil,aNroCol[2] SAY &cMaeAct->cCodigoGru
	     @ nNroFil,aNroCol[3] SAY cNombreTes
**********FIN IMPRESION DEL ESTUDIANTE

**********LOCALIZACION DEL DESCUENTO
	    SELECT DES
	    DES->(DBGOTOP())
	    LOCATE FOR DES->cCodigoEst == cCodigoTes .AND.;
		       DES->nNroMesDes == nNroMesTde .AND.;
		       (DES->nTipDesDes == 1 .OR.;
			DES->nTipDesDes == 2 .OR.;
			DES->nTipDesDes == 4)

	    IF !DES->(FOUND())
	       cError('NO EXISTE DESCUENTOS/RECARGOS APLICADOS')
	       RESTSCREEN(nNroFil,00,nNroFil,79,cSavLin)
	       LOOP
	    ENDIF
**********FIN LOCALIZACION DEL DESCUENTO

**********PREPARACION DE LAS VARIABLES DE ARCHIVOS
	    FileCli := cPatSis+'\CLIENTES\CL'+;
		       &cMaeAct->cCodigoGru+cAnoSis+ExtFile

	    FilePag := cPatSis+'\PAGOS\PA'+;
		       &cMaeAct->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVOS

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)
	       cError('ABRIENDO EL ARCHIVO DE PAGOS')
	       RESTSCREEN(nNroFil,00,nNroFil,79,cSavLin)
	       LOOP
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********LOCALIZACION DEL CODIGO DEL PAGO
	    IF lLocCodPag(cCodigoTes,DES->nNroMesDes,.F.)

	       lHayErr := .T.
	       DO CASE
	       CASE DES->nTipDesDes == 1 .AND.;
		    PAG->nVlrDesPag == DES->nValorDes
		    cError('EL DESCUENTO YA FUE FACTURADO')

	       CASE DES->nTipDesDes == 2 .AND.;
		    PAG->nVlrRecPag == DES->nValorDes
		    cError('EL RECARGO YA FUE FACTURADO')

	       CASE DES->nTipDesDes == 4 .AND.;
		    PAG->nPagParPag == DES->nValorDes
		    cError('EL PAGO PARCIAL YA FUE FACTURADO')

	       OTHERWISE
		    lHayErr :=.F.
	       ENDCASE

	       IF lHayErr
		  RESTSCREEN(nNroFil,00,nNroFil,79,cSavLin)
		  LOOP
	       ENDIF

	    ENDIF
**********FIN LECTURA DE LOS DETALLES DEL PAGO

**********LECTURA DEL DESCUENTOS
	    @ nNroFil,aNroCol[4] SAY DES->cDescriDes PICT "@!S16"
	    @ nNroFil,aNroCol[5] SAY DES->nValorDes  PICT "9999999.99"
	    @ nNroFil,aNroCol[6] SAY cNombreDes(DES->nTipDesDes)
**********FIN LECTURA DEL DESCUENTOS

**********MARCA O DESMARCA UN REGISTRO
	    SELECT DES
	    IF DES->(lRegLock(lShared,.F.)) .AND.;
		cError('Presione "S" para Confirmar',;
		       'DESEA '+IF(deleted(),'RECUPERAR','BORRAR')+' EL '+;
		       cNombreDes(DES->nTipDesDes)+'?',;
		       'Escape = No Borrar') == 'S'
	       IF(DELETED(),DBRECALL(),DBDELETE()) // Marca o Desmarca
	    ENDIF
**********FIN MARCA O DESMARCA UN REGISTRO

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
		 @ nNroFil,aNroCol[2] SAY &cMaeAct->cCodigoGru
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
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>GRABACION DE LOS DESCUENTOS