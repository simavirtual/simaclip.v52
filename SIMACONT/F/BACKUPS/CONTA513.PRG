/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : FIN DE A¥O
SUBMODULO...: HABILITACIONES         MODULO No. 513

**************************************************************************
* TITULO..: ACTAS DE HABILITACIONES POR PROFESOR                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 18/1995 VIE A
       Colombia, Bucaramanga        INICIO: 12:55 PM   OCT 18/1995 VIE


OBJETIVOS:

1- Imprime las actas de habilitaci¢n por profesor

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_513(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "EPSONFX.PRG"
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cSavPan := ''                  // Salvar Pantalla

       LOCAL aNroCol := {}                  // Columnas de los titulos
       LOCAL aTitulo := {}                  // T¡tulos para el informe
       LOCAL aRegPrn := {}                  // Registro de impresion

       LOCAL nLinReg := 0                   // L¡neas del registro
       LOCAL cRegPrn := ''                  // Registro de impresi¢n
       LOCAL nLenPrn := 0                   // Longitud de impresi¢n

       LOCAL       i := 0                   // Contador
       LOCAL nCopias := 1                   // N£meros de copias a imprimir
       LOCAL nNroCop := 1                   // N£mero de copia
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL nTotReg := 0                   // Total registros a imprimir
       LOCAL nNroReg := 0                   // N£mero de registros

       LOCAL lTamAnc := .T.                 // .T. Tama¤o Ancho
       LOCAL aCabPri := {}                  // Encabezado principal
       LOCAL aCabSec := {}                  // Encabezado Secundario
       LOCAL cCodIni := ''                  // C¢digos impresora iniciales
       LOCAL cCabCol := ''                  // Encabezados de columnas
       LOCAL cCodFin := ''                  // C¢digos impresora finales
       LOCAL lCentra := .T.                 // Centrar Encabezados Columna
       LOCAL nColCab := 0                   // Columna encabezado columna

       LOCAL nAvance := 0                   // Avance de registros
       LOCAL cCodPro := ''                  // C¢digo del profesor
       LOCAL lMisPro := .T.                 // .T. Mismo profesor
       LOCAL cCodNiv := ''                  // C¢digo del nivel
       LOCAL lMisNiv := .T.                 // .T. Mismo nivel

       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cNombreTes := ''               // Nombre del estudiante
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
	  CloseAll()
	  RETURN NIL
       ENDIF
       CloseAll()
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimaCo,'SCO',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileMat+ExtFile,'MAT',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileAlu+cMaeAct+cAnoSis+ExtFile,'ALU',;
		       cPatSis+'\'+cMaeAct+'\'+;
		       fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared)
	  cError('ABRIENDO LOS ARCHIVOS DE ALUMNOS Y GRUPOS '+cPatSis)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL NIVEL DE '+cMaeAct)

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE NIV->(RECCOUNT()) == 0
	    cError('NO EXISTEN NIVELES GRABADOS')

       CASE ALU->(RECCOUNT()) == 0
	    cError('NO EXISTEN ALUMNOS GRABADOS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SCO->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>LECTURA DEL NUMERO DE COPIA
       nCopias := 1
       @ nFilInf+3,nColInf SAY 'NRO COPIAS:' GET nCopias PICT '99'
       READ
       IF nCopias == 0
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL NUMERO DE COPIA

*>>>>CREACION DE ARCHIVO TEMPORAL DE HABILITANTES
       GraHabTem(cNomSis,cNomUsr,cPatSis+'\'+cMaeAct,;
		 cAnoUsr,1,GRU->(RECCOUNT()),TCO->nTotPerTbl)
*>>>>FIN CREACION DE ARCHIVO TEMPORAL DE HABILITANTES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,FileTem+SUBS(cNomUsr,1,3)+'.UNO','UNO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,FileTem+SUBS(cNomUsr,1,3)+'.DOS','DOS',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS TEMPORALES')
	  RETURN NIL
       ENDIF
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE UNO->(RECCOUNT()) == 0
	    cError('NO HAY HABILITANTES')

       CASE DOS->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS A HABILITAR. POR FAVOR REVISAR')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>INDEXACION DEL ARCHIVO
       SELECT DOS
       fNtxTem := FileTem+SUBS(cNomUsr,1,3)+cExtTem
       INDEX ON DOS->cCodigoPro+DOS->cCodigoMat TO &fNtxTem
       DBSETINDEX(fNtxTem)
*>>>>FIN INDEXACION DEL ARCHIVO

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.
       nTotReg := DOS->(RECCOUNT())

       aCabPri := {cNomEmp,;
		   cNomSis+' JORNADA '+cJorTxt+' DE '+cAnoUsr,;
		   '',;
		   '',;
		   '',;
		   nNroPag,NIL,lTamAnc}

       cCodIni := DRAFT_OF+CONDEN_OF
       cCodFin := NEGRA_OF+DOBGOL_OF
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {06,06,40,06,16}
       aTitulo := {'GRUPO ','CODIGO','NOMBRE','NOTA','LETRAS'}
       cCabCol := cRegPrint(aTitulo,@aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n17Stan
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF !Printer_on()
	   RETURN NIL
       ENDIF
       @ PROW(),00 SAY INICIALIZA+PROPOR_OF+CONDEN_ON
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DE N COPIAS
       DO WHILE nNroCop <= nCopias

***********IMPRESION DEL TERMOMETRO
	     SET DEVICE TO SCREEN
	     Termometro(0,'IMPRIMIENDO LOS HABILITANTES COPIA No.'+;
			  STR(nNroCop,2)+'\'+STR(nCopias,2))
	     Termometro(10)
	     SET DEVICE TO PRINT
***********FIN IMPRESION DEL TERMOMETRO

***********IMPRESION DEL INFORME
	     SELECT UNO
	     GO TOP
	     cCodPro := DOS->cCodigoPro
	     lMisPro := .T.
	     cCodNiv := SUBS(DOS->cCodigoGru,1,2)
	     lMisNiv := .F.

	     DO WHILE .NOT. DOS->(EOF())

*---------------IMPRESION DEL ENCABEZADO DE ACTA
		  IF lMisPro .AND. !lMisNiv

		     aCabPri[4] := 'ACTA DE HABILITACION PARA '+;
				    ALLTRIM(SUBS('JARDIN  PRIMERO SEGUNDO '+;
						 'TERCERO CUARTO  QUINTO  '+;
						 'SEXTO   SEPTIMO OCTAVO  '+;
						 'NOVENO  DECIMO  UNDECIMO',;
						 (VAL(cCodNiv)+1)*8-7,8))
		     aCabPri[5] := 'FECHA: __________'

		     aCabSec := {'MATERIA : '+ALLTRIM(DOS->cNombreMat),;
				 'PROFESOR: '+ALLTRIM(DOS->cNombrePro)}

		     CabezaPrn(cCodIni,aCabPri,cCabCol,nColCab,cCodFin,aCabSec)

		     lMisPro := .T.
		     lMisNiv := .T.
		  ENDIF
*---------------FIN IMPRESION DEL ENCABEZADO DE ACTA

*---------------IMPRESION DE LOS HABILITANTES
		  IF lMisPro .AND. lMisNiv
		     cRegPrn := cRegPrint({DOS->cCodigoGru,;
					   SUBS(DOS->cCodigoEst,3,4),;
					   SUBS(DOS->cNombreEst+;
						SPACE(40),1,40),;
					   SPACE(06),;
					   SPACE(16)},;
					   aNroCol)

		     lPrintPrn(01,nColCab,cCodIni,aCabPri,cCabCol,;
				     nColCab,cCodFin,cRegPrn,cNomSis,;
				     cNomEmp,nLinReg,nLenPrn)
		  ENDIF
*---------------FIN IMPRESION DE LOS HABILITANTES

*---------------AVANCE DEL SIGUIENTE REGISTRO
		  nAvance := INT(( DOS->(RECNO()) / DOS->(RECCOUNT()) )*100)

		  IF STR(nAvance,3) $ '25 50 75100'
		     SET DEVICE TO SCREEN
		     Termometro(nAvance)
		     SET DEVICE TO PRINT
		  ENDIF

		  DOS->(DBSKIP())
*---------------FIN AVANCE DEL SIGUIENTE REGISTRO

*---------------ANALISIS DEL CAMBIO
		  lMisNiv := .T.
		  IF SUBS(DOS->cCodigoGru,1,2) # cCodNiv
		     lMisNiv := .F.
		     cCodNiv := SUBS(DOS->cCodigoGru,1,2)
		  ENDIF
*---------------FIN ANALISIS DEL CAMBIO

*---------------ANALISIS DEL CAMBIO
		  lMisPro := .T.
		  IF DOS->cCodigoPro # cCodPro
*		     lMisPro := .F.
		     lMisNiv := .F.
		     cCodPro := DOS->cCodigoPro
		  ENDIF
*---------------FIN ANALISIS DEL CAMBIO

*---------------IMPRESION DE LAS OBSERVACIONES
		  IF lMisPro .AND. !lMisNiv

		     lPrintPrn(01,nColCab,cCodIni,aCabPri,cCabCol,;
				     nColCab,cCodFin,;
				     REPL('-',LEN(cRegPrn)),cNomSis,;
				     cNomEmp,nLinReg,nLenPrn)
		    *Linea separadora

		     lPrintPrn(01,nColCab,cCodIni,aCabPri,cCabCol,;
				     nColCab,cCodFin,;
				     'Observaciones:',cNomSis,;
				     cNomEmp,nLinReg,nLenPrn)
		    *Observaci¢n

		     FOR i := 1 TO 5
			 lPrintPrn(IF(i=1,02,01),nColCab,;
				   cCodIni,aCabPri,cCabCol,nColCab,cCodFin,;
				   REPL('-',LEN(cRegPrn)),cNomSis,;
				   cNomEmp,nLinReg,nLenPrn)
		     ENDFOR
		   *ÀL¡neas para la observaci¢n

		     lPrintPrn(04,nColCab,cCodIni,aCabPri,cCabCol,;
				     nColCab,cCodFin,;
				     'Firma del Profesor',cNomSis,;
				     cNomEmp,nLinReg,nLenPrn)
		    *Firma del profesor

		  ENDIF
*---------------FIN IMPRESION DE LAS OBSERVACIONES

*---------------IMPRESION DE DERECHOS
		  IF lMisPro .AND. !lMisNiv
		     DerechosPrn(cNomSis,cNomEmp,nLenPrn)
		     @ PROW()-PROW(),00 SAY ' '
		    *Saca la ultima linea
		  ENDIF
*---------------FIN IMPRESION DE DERECHOS

	     ENDDO
***********IMPRESION DEL INFORME




	  nNroCop++

       ENDDO
       CLOSE ALL
       lFileDelete(FileTem+SUBS(cNomUsr,1,3)+'.UNO')
       lFileDelete(FileTem+SUBS(cNomUsr,1,3)+'.DOS')
       lFileDelete(FileTem+SUBS(cNomUsr,1,3)+cExtTem)
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>IMPRESION DE N COPIAS