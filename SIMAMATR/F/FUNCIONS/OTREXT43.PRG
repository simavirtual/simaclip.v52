/*************************************************************************
* TITULO ..: LECTURA DEL ARCHIVO DEL EXTRACTO                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 06/99 JUE A
       Bucaramanga, Colombia        INICIO: 09:55 PM   MAY 06/99 JUE

REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Lee el archivo ascii generado por el Banco o Coorporaci¢n
   correspondiente al mes del estracto.

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION FOtrExt43(aP1,aP2,aP3,;
		   cNroMes,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1			            // Parametros Generales
       aP2			            // Parametros Generales
       aP3			            // Parametros Generales
       cNroMes                              // N£mero del Mes
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
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .T.                 // .T. Hay Error
       LOCAL cSavLin := ''                  // Salvar Linea
       LOCAL cNomArc := ''                  // Nombre del archivo
       LOCAL PathAct := ''                  // Paht Actual
       LOCAL nVlrDec := 0                   // Valor Decimal

       LOCAL nMesIni := 0                   // Mes del pago
       LOCAL cCodRef := ''                  // C¢digo de la Referencia
       LOCAL cCodTra := ''                  // C¢digo de la transaci¢n
       LOCAL cSigTra := ''                  // Signo de la transaci¢n
       LOCAL nValor  := 0                   // Valor de la Transaci¢n
       LOCAL dFecha  := CTOD('00/00/00')    // Fecha de Pago
       LOCAL lSumar := .F.                 // .T. Credito .F. Debito

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ACTIVACION DEL CURSOR
       cSavPan := SAVESCREEN(0,0,24,79)
       IF !EMPTY(oBrowse)
	  SETCURSOR(1)
       ENDIF
*>>>>FIN ACTIVACION DEL CURSOR

*>>>>LECTURA DEL DIRECTORIO DEL ARCHIVO DE PAGOS
       cNomArc := SPACE(99)
       cSavLin := SAVESCREEN(nFilInf+1,00,nFilInf+2,79)
       @ nFilInf+1,nColInf-20 SAY "NOMBRE DEL ARCHIVO "+;
			       "DEL EXTRACTO DE "+cMes(VAL(cNroMes),10)+':'
       DO WHILE .T.

**********LECTURA DEL ARCHIVO
	    @ nFilInf+2,nColInf-20 GET cNomArc PICT "@!S40"
	    READ
**********FIN LECTURA DEL ARCHIVO

**********VALIDACION DEL ARCHIVO
	    DO CASE
	    CASE EMPTY(cNomArc)
		 RESTSCREEN(nFilInf+1,00,nFilInf+2,79,cSavLin)
		 RETURN NIL

	    CASE !FILE(ALLTRIM(cNomArc))
		 cError('NO EXISTE EL ARCHIVO '+ALLTRIM(cNomArc))
		 LOOP

	    OTHERWISE
		 IF !lPregunta('DESEA CORREGIR? No Si')
		    EXIT
		 ENDIF
	    ENDCASE
**********FIN VALIDACION DEL ARCHIVO

       ENDDO
*>>>>FIN LECTURA DEL DIRECTORIO DEL ARCHIVO DE PAGOS

*>>>>VERIFICACION O CREACION DEL DIRECTORIO MODEM
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE (cPatSis+"\MODEM\"+BAN->cCodigoBan) == 0
	    DIRCHANGE(PathAct)

       CASE DIRCHANGE (cPatSis+"\MODEM\"+BAN->cCodigoBan) == -5
	    cError("NO HAY DERECHOS EN EL DIRECTORIO MODEM")
	    QUIT

       CASE DIRCHANGE(cPatSis+"\MODEM\"+BAN->cCodigoBan) == -3
	    DIRMAKE(cPatSis+"\MODEM\"+BAN->cCodigoBan)
       ENDCASE
       DIRCHANGE(PathAct)
*>>>>FIN VERIFICACION O CREACION DEL DIRECTORIO MODEM

*>>>>CIERRE DE AREAS DE TRABAJO
       FileTmv := FileTmv+BAN->cCodigoBan+ExtFile
       FileMoB := BAN->cCodigoBan+cAnoUsr+cNroMes+ExtFile
       CloseDbf('TRA',cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+FileMoB,nModCry)
       CloseDbf('TMV',cPatSis+'\'+FileTmv,nModCry)
       CloseDbf('CMV',cPatSis+'\'+FileCmv,nModCry)
*>>>>FIN CIERRE DE AREAS DE TRABAJO

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileTmv,'TMV',NIL,lNoRed,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileCmv,'CMV',NIL,lNoRed,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+;
			 FileMoB,'TRA',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>CREACION DEL ARCHIVO DEL ESTRACTO
       RESTSCREEN(nFilInf+1,00,nFilInf+2,79,cSavLin)
       cNomArc := ALLTRIM(cNomArc)

       CreaDbfExt(lShared,nModCry,;
		  cPatSis+'\MODEM\'+BAN->cCodigoBan,FileMoB)
      *Creaci¢n de archivo del extracto
*>>>>FIN CREACION DEL ARCHIVO DEL ESTRACTO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ERROR ABRIENDO ARCHIVOS')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE CMV->(RECCOUNT()) == 0
	    cError('NO EXISTEN LOS NOMBRES DE LOS CONCEPTOS DEL MOVIMIENTO')

       CASE TMV->(RECCOUNT()) == 0
	    cError('NO EXISTEN LOS NOMBRES DE LOS CONCEPTOS DEL MOVIMIENTO')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>CONVERSION DEL ARCHIVO ASCII
       Termometro(0,'LEYENDO EL ARCHIVO')
       Termometro(20)
       SELECT TRA
       APPEND FROM &cNomArc SDF
       Termometro(50)
*>>>>FIN CONVERSION DEL ARCHIVO ASCII

*>>>>CONVERSION DEL ARCHIVO A LOS RESPECTIVOS CAMPOS
       SELECT TRA
       GO TOP
       DO WHILE .NOT. TRA->(EOF())

**********LECTURA DE LOS RESPECTIVO CAMPOS
	    cCodRef := cCodRef(TRA->Registro)

	    cCodTra := SUBS(TRA->Registro,BAN->nTipMovBan,BAN->nLenTipBan)
	    IF BAN->nSigMovBan # 0 .AND.;
	       BAN->nLenSigBan # 0 .AND.;
	       BAN->nLugSigBan # 0

	       cSigTra := SUBS(TRA->Registro,BAN->nSigMovBan,BAN->nLenSigBan)
	       IF BAN->nLugSigBan == 1
		  cCodTra := cSigTra+cCodTra
	       ELSE
		  cCodTra := cCodTra+cSigTra
	       ENDIF
	    ENDIF

	    nVlrDec := 0
	    IF !EMPTY(BAN->nPagDecBan)
	       nVlrDec := VAL(SUBS(TRA->Registro,BAN->nPagDecBan,;
						 BAN->nLenDecBan))/100
	    ENDIF
	    nValor  := VAL(SUBS(TRA->Registro,BAN->nPagIntBan,;
				BAN->nLenIntBan))+nVlrDec

	    dFecha  := CTOD(SUBS(TRA->Registro,BAN->nMesPagBan,02)+'/'+;
			       SUBS(TRA->Registro,BAN->nDiaPagBan,02)+'/'+;
			       SUBS(TRA->Registro,;
				    BAN->nAnoPagBan,BAN->nLenAnoBan))
**********FIN LECTURA DE LOS RESPECTIVO CAMPOS

**********LOCALIZACION DE LA TRANSACION
	    IF lLocCodigo('cCodigoTra','TMV',cCodTra)
	       lSumar := TMV->lSumarTra
	    ELSE
	       cError('EL CODIGO: '+cCodTra+;
		      ' NO EXISTE SE ASUME COMO UN DEBITO')
	       lSumar := .F.
	    ENDIF
**********FIN LOCALIZACION DE LA TRANSACION

**********GRABACION DE LOS CAMPOS
	    SELECT TRA
	    IF TRA->(lRegLock(lShared,.F.))
	       REPL TRA->cCodRefTra WITH cCodRef
	       REPL TRA->cCodigoEst WITH SUBS(cCodRef,1,6)
	       REPL TRA->cCodigoTra WITH cCodTra
	       REPL TRA->nCodigoCmv WITH nCodigoCmv(VAL(cNroMes),;
						    cCodRef,BAN->nLenRefBan)
	       REPL TRA->nValorTra  WITH nValor
	       REPL TRA->dFechaTra  WITH dFecha
	       REPL TRA->lSumarTra  WITH lSumar
	       REPL TRA->lInsUsrTra WITH .F.
	       TRA->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABA EL REGISTRO')
	    ENDIF
	    IF lShared
	       TRA->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DE LOS CAMPOS

	  TRA->(DBSKIP())

       ENDDO
       Termometro(100)
*>>>>CONVERSION DEL ARCHIVO A LOS RESPECTIVOS CAMPOS

*>>>>CREACION DE INDICES
       SELECT TRA
       fNtxMoB := BAN->cCodigoBan+cAnoUsr+cNroMes+cExtNtx
       INDEX ON TRA->cCodRefTra TO &(cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+fNtxMoB)
*>>>>FIN CREACION DE INDICES

*>>>>CIERRE DE ARCHIVOS
       IF EMPTY(oBrowse)
	  CloseDbf('TRA',cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+;
		   FileMoB,nModCry)
	  CloseDbf('TMV',cPatSis+'\'+FileTmv,nModCry)
	  CloseDbf('CMV',cPatSis+'\'+FileCmv,nModCry)
       ELSE
	  SELECT TRA
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
       ENDIF
       RESTSCREEN(nFilInf+1,00,nFilInf+2,79,cSavPan)
       RETURN NIL
*>>>>FIN CIERRE DE ARCHIVOS