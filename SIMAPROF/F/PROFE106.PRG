/* SIMA - CONTABILIDAD PROFESORES

MODULO      : LISTAS
SUBMODULO...: HOJA DEL OBSERVADOR

**************************************************************************
* TITULO..: HOJA DEL OBSERVADOR                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 31/2001 MIE A
       Colombia, Bucaramanga        INICIO: 11:30 PM   ENE 31/2001 MIE


OBJETIVOS:

1- Permite imprimir los datos de la Hoja del Observador

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Profe_106(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema
       #INCLUDE "EPSONFX.PRG"               // Impresora EPSON FX

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL cSavLin := ''                  // Salvar l¡nea
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTes := ''               // C¢digo del estudiante
       LOCAL cNombreTes := ''               // Nombre del estudiante
*>>>>FIN DECLARACION DE VARIABLES

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

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>DECLARACION DE PARAMETROS ESPECIFICOS
       LOCAL cCodPro := xPrm(aP1,'cCodPro') // C¢digo del Profesor
       LOCAL cPatPro := xPrm(aP1,'cPatPro') // Path del Profesor
       LOCAL cNomPro := xPrm(aP1,'cNomPro') // Nombre del Profesor
       CloseAll()
*>>>>DECLARACION DE PARAMETROS ESPECIFICOS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
		     fSimaCo,'SCO',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimSpr,'SPR',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
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
       CASE 'JAR' $ cMaeAlu .AND. JAR->(RECCOUNT()) == 0
	    cError('NO EXISTEN ESTUDIANTES DE JARDIN')

       CASE 'PRI' $ cMaeAlu .AND. PRI->(RECCOUNT()) == 0
	    cError('NO EXISTEN ESTUDIANTES DE PRIMARIA')

       CASE 'BTO' $ cMaeAlu .AND. BTO->(RECCOUNT()) == 0
	    cError('NO EXISTEN ESTUDIANTES DE BACHILLERATO')

       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL DE CONTABILIDAD')

       CASE SPR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SPR->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,'POR FAVOR ENTRE LOS CODIGOS DE LOS '+;
				   'ESTUDIANTES',22,'°')
       nNroCol := 1
       aTamCol := {06,40,06}
       aTitulo := {'CODIGO','NOMBRE','CURSO '}

       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>ACTIVACION DE LA IMPRESORA
       IF SPR->lPrnArcSpr
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'observa'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SPR->cOpcPrnSpr,.T.)
	  IF EMPTY(nOpcPrn)
	     CloseAll()
	     RETURN NIL
	  ENDIF
       ENDIF
       SendCodes(PCL('Reset'))
       SendCodes(PCL({'DraftOn','Pica','CondenOn'}))
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>GRABACION DE LOS REGISTROS
       nNroFil++
       DO WHILE .T.

**********LECTURA DEL CODIGO DEL ESTUDIANTE
	    SET DEVICE TO SCREEN
	    cSavLin := SAVESCREEN(nNroFil,00,nNroFil,79)
	    cCodigoTes := cLeeCodEst(nNroFil,aNroCol[1],cMaeAlu,@cMaeAct)
	    IF EMPTY(cCodigoTes)
	       EXIT
	    ENDIF
	    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			  RTRIM(&cMaeAct->cNombreEst)
	    @ nNroFil,aNroCol[2] SAY cNombreTes
	    @ nNroFil,aNroCol[3] SAY &cMaeAct->cCodigoGru
**********FIN LECTURA DEL CODIGO DEL ESTUDIANTE

**********IMPRESION DE LA HOJA DEL OBSERVADOR
	    SET DEVICE TO PRINT
	    DO CASE
	    CASE SCO->nHojObsCon == 0
		 HojObs00(cAnoUsr,cMaeAct)
		*Hoja del Observador por Defecto

	    ENDCASE
	    SET DEVICE TO SCREEN
**********FIN IMPRESION DE LA HOJA DEL OBSERVADOR

**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    IF nNroFil > 19

*--------------IMPRESION DEL ULTIMO REGISTRO
		 nNroFil := nMarco(nFilPal+1,'POR FAVOR ENTRE LOS CODIGOS '+;
					     'DE LOS ESTUDIANTES',22,'°')
		 nNroFil++
		 SET COLOR TO I
		 @ nNroFil,aNroCol[1] SAY cCodigoTes
		 @ nNroFil,aNroCol[2] SAY cNombreTes
		 @ nNroFil,aNroCol[3] SAY &cMaeAct->cCodigoGru
		 SET COLOR TO

		 nNroFil++
*--------------FIN IMPRESION DEL ULTIMO REGISTRO

	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

       ENDDO
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN GRABACION DE LOS REGISTROS

***************************************************************************
*----------------------------FIN DEL PROGRAMA ----------------------------*
*--------------- DECLARACION DE FUNCIONES PARA EL PROGRAMA ---------------*
***************************************************************************

/*************************************************************************
* TITULO..: HOJA DEL OBSERVADOR No. 00                                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 30/2000 MAR A
       Colombia, Bucaramanga        INICIO: 03:40 PM   ENE 30/2000 MAR

1- Imprime la Hoja del Observador.

2- Es la Hoja del Observador por defecto del sistema.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION HojObs00(cAnoUsr,cMaeAct)

*>>>>DECLARACION DE VARIABLES
       LOCAL cEdaEst := ''                  // Edad del Estudiante
       LOCAL cMsgTxt := ''                  // Texto Variable
       LOCAL cNombre := ''                  // Nombre
       LOCAL cCodGru := ''                  // C¢digo del Grupo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE LA HOJA DEL OBSERVADOR
       SETPRC(0,0)
       @ PROW()+11,40 SAY &cMaeAct->cCodigoEst
       @ PROW(),100 SAY cAnoUsr
       @ PROW()+02,36 SAY RTRIM(&cMaeAct->cApelliEst)+' '+;
		       RTRIM(&cMaeAct->cNombreEst)

       cCodGru := cNomNiv(SUBS(&cMaeAct->cCodigoGru,1,2))+'-'+;
		  SUBS(&cMaeAct->cCodigoGru,3,2)

       cEdaEst := STR((DATE()-&cMaeAct->dFecNacEst)/360,4,0)

       @ PROW()+2,20 SAY cCamPrn(cCodGru,14)+;
			 SPACE(04)+cEdaEst+SPACE(30)+;
			 cFecha(&cMaeAct->dFecNacEst)+SPACE(25)+;
			 &cMaeAct->cGrupRhEst

       cNombre := ALLTRIM(&cMaeAct->cNomPadEst)+' '+;
		  ALLTRIM(&cMaeAct->cApePadEst)
       @ PROW()+2,31 SAY cCamPrn(cNombre,36)+SPACE(07)+;
			 cCamPrn(&cMaeAct->cProPadEst,16)+SPACE(25)+;
			 ALLTRIM(&cMaeAct->cTelPadEst)

       cNombre := ALLTRIM(&cMaeAct->cNomMadEst)+' '+;
		  ALLTRIM(&cMaeAct->cApeMadEst)
       @ PROW()+2,33 SAY cCamPrn(cNombre,28)+SPACE(14)+;
			 cCamPrn(&cMaeAct->cProMadEst,16)+SPACE(25)+;
			 ALLTRIM(&cMaeAct->cTelMadEst)

       cNombre := ALLTRIM(&cMaeAct->cNomAcuEst)+' '+;
		  ALLTRIM(&cMaeAct->cApeAcuEst)
       @ PROW()+2,34 SAY cCamPrn(cNombre,36)+SPACE(14)+;
			 cCamPrn(&cMaeAct->cParAcuEst,24)+SPACE(10)+;
			 ALLTRIM(&cMaeAct->cTe1AcuEst)

       @ PROW()+2,46 SAY cCamPrn(ALLTRIM(&cMaeAct->cDireccEst)+' '+;
			 ALLTRIM(&cMaeAct->cBarrioEst),65)+SPACE(07)+;
			 ALLTRIM(&cMaeAct->cTelefnEst)
       @ PROW(),0 SAY ''
       EJECT
       RETURN NIL
*>>>>FIN IMPRESION DE LA HOJA DEL OBSERVADOR