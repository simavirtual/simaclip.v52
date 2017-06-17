/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : PAGOS
SUBMODULO...: PAGOS EN LINEA

**************************************************************************
* TITULO..: PAGOS EN LINEA                                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 06/2008 MAR A
       Bucaramanga, Colombia        INICIO: 07:00 AM   MAY 06/2008 MAR

OBJETIVOS:

1- Permite generar un archivo plano de acuerdo al estandar de la Asobancaria
   para poder pagar la facturaci¢n en los cajeros automaticos.

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_291(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION PARAMETROS
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
*>>>>FIN DECLARACION PARAMETROS

*>>>>PARAMETROS ESPECIFICOS
       LOCAL nMesIni := xPrm(aP2,'nMesIni') // Mes inicial
*>>>>FIN PARAMETROS ESPECIFICOS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL       i := 0                   // Contador

       LOCAL cCodSer := ''                  // C¢digo del Servicio

       LOCAL nForPag := 0                   // Forma de pago
       LOCAL cForPag := ''                  // Forma de pago
       LOCAL aFecHoy := {}                  // Fecha de Proceso
       LOCAL cFecHoy := ''                  // Fecha del Proceso
       LOCAL cHorHoy := ''                  // Hora del Proceso

       LOCAL cRegIni := ''                  // Registro Inicial
       LOCAL cRegFin := ''                  // Registro Inicial
       LOCAL nTotReg := 0                   // Total de Registros
       LOCAL cTotReg := ''                  // Total de Registros
       LOCAL nTotOpo := 0                   // Total Valor Oportuno
       LOCAL cTotOpo := ''                  // Total Valor Oportuno
       LOCAL nTotExt := 0                   // Total Valor Extemporaneo
       LOCAL cTotExt := ''                  // Total Valor Extemporaneo

       LOCAL aTotErr := {}                  // Registro de Errores
       LOCAL aValErr := {1,3}               // Campos a Validar
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DEL BANCO
       IF BAN->(RECCOUNT()) > 1
	  nSelBanco(nFilInf+1,nColInf-1)
       ELSE
	  SELECT BAN
	  BAN->(DBGOTOP())
       ENDIF
*>>>>FIN SELECCION DEL BANCO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE

       CASE BAN->nPagOnlBan == 0
	    cError(ALLTRIM(BAN->cNombreBan)+' '+;
		  'NO TIENE DEFINIDO UN FORMATO PARA PAGOS EN LINEA')

       CASE BAN->nPagOnlBan > 7
	    cError('FORMATO PARA PAGOS EN LINEA No.'+;
		   STR(BAN->nPagOnlBan,2)+' '+'NO ESTA HABILITADO')

       CASE EMPTY(SCA->cSerFacCar)
	    cError('NO SE HA DEFINIDO LA DESCRIPCION DEL SERVICIO FACTURADO')

       CASE EMPTY(SCA->cCodFacCar)
	    cError('NO SE HA CONFIRGURADO EL CODIGO DEL SERVICIO FACTURADO')

       CASE EMPTY(BAN->cValCtaBan)
	    cError('NO SE HA CONFIRGURADO LA CUENTA DEL BANCO A VALIDAR')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>ANALISIS DE DECISION
       nForPag := 0
       cForPag := ''
       DO CASE
       CASE BAN->nPagOnlBan == 1  // Asobancaria 2001

	    nForPag := nLeeOpcion('GENERAR ARCHIVO PARA: '+;
		      '1<PAGO OPO> 2<PAGO EXT> 3<ABANDONAR>?',3,'0')
	    *Lee la forma de pago

	    IF nForPag == 3
	       RETURN NIL
	    ENDIF
	    cForPag := IF(nForPag==1,'1','2')

	    cError('PARA PAGO '+IF(cForPag=='1','OPORTUNO','EXTEMPORANEO'),;
		   'SE VA A GENERAR EL ARCHIVO CON EL FORMATO '+;
		   'DE ASOBANCARIA 2001')

       CASE BAN->nPagOnlBan == 2  // Asobancaria 2001. Place to Play

	    cError('SE VA A GENERAR EL ARCHIVO CON EL FORMATO '+;
		   'DE ASOBANCARIA 2001. PLACE TO PAY')

       CASE BAN->nPagOnlBan == 4  // Formato de ColPatria

	    nForPag := nLeeOpcion('GENERAR ARCHIVO PARA: '+;
		      '1<PAGO OPO> 2<PAGO EXT> 3<ABANDONAR>?',3,'0')
	    *Lee la forma de pago

	    IF nForPag == 3
	       RETURN NIL
	    ENDIF
	    cForPag := IF(nForPag==1,'1','2')

	    cError('PARA PAGO '+IF(cForPag=='1','OPORTUNO','EXTEMPORANEO'),;
		   'SE VA A GENERAR EL ARCHIVO CON EL FORMATO '+;
		   'DE COLPATRIA')


       CASE BAN->nPagOnlBan == 5  // Avisor. Manual Intercambio Archivos eCollect V.3.1.3

	    cError('SE VA A GENERAR EL ARCHIVO CON EL FORMATO '+;
		   'DE AVISOR TECHNOLOGIES')
	    cForPag := ''

       CASE BAN->nPagOnlBan == 6  // Pagos Inteligentes - www.pagosinteligentes.com

	    cError('SE VA A GENERAR EL ARCHIVO CON EL FORMATO '+;
		   'PARA PAGOS INTELIGENTES')
	    cForPag := ''

       CASE BAN->nPagOnlBan == 7  // Pagos Virtuales Davivienda

	    cError('SE VA A GENERAR EL ARCHIVO CON EL FORMATO '+;
		   'PARA PAGOS VIRTURALES DE DAVIVIENDA')
	    cForPag := ''

       ENDCASE
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>ANALISIS DE DECISION
       PathOnl := xPrm(aP2,'PathOnl')
       FileOnl := xPrm(aP2,'FileOnl')

       CloseDbf('ONL')
       CreaDbfOnl(lShared,nModCry,PathOnl,FileOnl)
*>>>>FIN ANALISIS DE DECISION

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathOnl+'\'+FileOnl,'ONL',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE ONL->(RECCOUNT()) > 0
	    cError('EXISTEN REGISTROS YA CREADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>REGISTRO ENCABEZADO DE ARCHIVO
       aFecHoy := aFecha(DATE())
       cHorHoy := TIME()

       DO CASE
       CASE BAN->nPagOnlBan == 1       // Asobancaria 2001

	    cNitEmp := SUBS(SCO->cNroNitCon+SPACE(10),1,10)
	    lCorrecion(@cNitEmp)

	    cFecHoy := aFecHoy[3]+aFecHoy[1]+aFecHoy[2]
	  *ÀAAAAMMDD

	    cHorHoy := SUBS(cHorHoy,1,2)+SUBS(cHorHoy,4,2)

	    cRegIni := '01'+;               // 01=>002:002.(Si) Constante. Indica el tipo de registro
		       cNitEmp+;            // 02=>010:012.(Si) Nit de la Empresa que presenta la facutraci¢n
		       REPL('0',10)+;       // 03=>010:022.(Si) Nit Recuador adicional que factura conjuntamente con la principal.
		       REPL('0',3)+;        // 04=>003:025.(Si) Ojo.C¢digo de la entidad financiera donde la Empresa tiene cuenta y desea que se le abone el recaudo por domiciliaci¢n. Este campo corresponde al c¢digo de tr nsito de la entidad financiera.
		       cFecHoy+;            // 05=>008:033.(Si) Fecha de Creaci¢n del archivo
		       cHorHoy+;            // 06=>004:037.(Si) Hora de grabaci¢n del archivo en formato de hora militar, es decir de 0001 hasta las 2400
		       'A'+;                // 07=>001:038.(Si) Modificardor de archivo. Car cter que refleja el orden cron¢logico de grabaci¢n de los archivos y permite diferenciar varios archivos generados en un mismo d¡a. Se debe empezar primero las letras may£sculas (A-Z) y posteriormente los n£meros
		       REPL(SPACE(01),182)  // 08=>182:220.(Si) Reservado. Blancos.


       CASE BAN->nPagOnlBan == 2       // Asobancaria 2001. Place to Pay

	    cNitEmp := SUBS(SCO->cNroNitCon+SPACE(10),1,10)
	    lCorrecion(@cNitEmp)

	    cFecHoy := aFecHoy[3]+aFecHoy[1]+aFecHoy[2]
	  *ÀAAAAMMDD

	    cHorHoy := SUBS(cHorHoy,1,2)+SUBS(cHorHoy,4,2)

	    cRegIni := '01'+;               // 01=>002:002.(Si) Constante. Indica el tipo de registro
		       cNitEmp+;            // 02=>010:012.(Si) Nit de la Empresa que presenta la facutraci¢n
		       REPL('0',10)+;       // 03=>010:022.(Si) Nit Recuador adicional que factura conjuntamente con la principal. No usado por PlacetoPay
		       REPL('0',3)+;        // 04=>003:025.(Si) Ojo.C¢digo de la entidad financiera donde la Empresa tiene cuenta y desea que se le abone el recaudo por domiciliaci¢n. Este campo corresponde al c¢digo de tr nsito de la entidad financiera. No Usado por Placetopay
		       cFecHoy+;            // 05=>008:033.(Si) Fecha de Creaci¢n del archivo
		       cHorHoy+;            // 06=>004:037.(Si) Hora de grabaci¢n del archivo en formato de hora militar, es decir de 0001 hasta las 2400
		       'A'+;                // 07=>001:038.(Si) Modificardor de archivo. Car cter que refleja el orden cron¢logico de grabaci¢n de los archivos y permite diferenciar varios archivos generados en un mismo d¡a. Se debe empezar primero las letras may£sculas (A-Z) y posteriormente los n£meros
		       REPL(SPACE(01),182)  // 08=>182:220.(Si) Reservado. Blancos


       CASE BAN->nPagOnlBan == 3       // Red Multicolor

	    cNitEmp := SUBS(SCO->cNroNitCon+SPACE(09),1,9)
	    lCorrecion(@cNitEmp)

	    cRegIni := '0001'+;                   // Ind. Encabezado Valor fijo
		       '0001'+;                   // Valor fijo
		       cNitEmp+;                  // C¢digo de la Empresa
		       '0001'+;                   // C¢digo Interno
		       '0'+aFecHoy[3]+;           // A¤o facturaci¢n
			   aFecHoy[1]+;           // Mes facturaci¢n
			   aFecHoy[2]+;           // Dia facturaci¢n
		       REPL(SPACE(01),54)         // Filler

       CASE BAN->nPagOnlBan == 4       // ColPatria

	    cRegIni := ''  // No requiere registro inicial


       CASE BAN->nPagOnlBan == 5       // Avisor
						  // Ini:Fin:Len
	    cRegIni := '1'+;                      // 001:001:001 Registro de control
		       ''+;                       // 002:009:008 Fecha de Corte del Archivo
		       +;                         // 010:015:006 Cantidad total de registros tipo 2 en el archivo
		       ''+;                       // 016:033:018 Valor total de transacciones en el archivo
		       '0'+aFecHoy[3]+;           // 034:035:002 Identificador del ciclo de facturaci¢n
			   aFecHoy[1]+;           // 036:562:527 Espacios
			   aFecHoy[2]+;           //
		       REPL(SPACE(01),54)         // Filler
	  *ÀEncabezado

       CASE BAN->nPagOnlBan == 6  // Pagos Inteligentes - www.pagosinteligentes.com

	    cRegIni := ''

       CASE BAN->nPagOnlBan == 7  // Pagos Virtuales - Davivienda

	    cRegIni := ''


       ENDCASE
*>>>>REGISTRO ENCABEZADO DE ARCHIVO

*>>>>GRABACION REGISTRO ENCABEZADO DE ARCHIVO
       IF !EMPTY(cRegIni)

	  IF ONL->(lRegLock(lShared,.T.))

	     REPL ONL->cCodigoBan WITH BAN->cCodigoBan
	     REPL ONL->cCodigoEst WITH 'INICIO'
	     REPL ONL->nPagOnlCar WITH BAN->nPagOnlBan
	     REPL ONL->cForPagOnl WITH cForPag
	     REPL ONL->cRegistTxt WITH cRegIni

	     REPL ONL->cNomUsrOnl WITH cNomUsr
	     REPL ONL->dFecUsrOnl WITH DATE()
	     REPL ONL->cHorUsrOnl WITH TIME()

	     ONL->(DBCOMMIT())
	  ELSE
	     cError('NO SE GRABA EL REGISTRO INICIAL DE LA CONFIGURACION')
	  ENDIF
	  IF lShared
	     ONL->(DBUNLOCK())
	  ENDIF

       ENDIF
*>>>>FIN GRABACION REGISTRO ENCABEZADO DE ARCHIVO

*>>>>REGISTRO ENCABEZADO DE LOTE
       DO CASE
       CASE BAN->nPagOnlBan == 1       // Asobancaria 2001

	    cNitEmp := SUBS(SCO->cNroNitCon+SPACE(10),1,10)
	    lCorrecion(@cNitEmp)

	    cFecHoy := aFecHoy[3]+aFecHoy[1]+aFecHoy[2]
	  *ÀAAAAMMDD

	    cRegIni := '05'+;               // 1=>002:002.(Si) Constante. Indica el tipo de registro.
		       SCO->cCodEanCon+;    // 2=>013:015.(Si) C¢digo del servicio facturado. C¢digo EAN13 o Nit
		       '0001'+;             // 3=>004:019.(Si) N£mero del lote. Consecutivo del lote dentro del archivo. Cada archivo tiene su propia secuencia de numeraci¢n de lotes.
		       SCA->cSerFacCar+;    // 4=>015:034.(Si) Nombre del servicio facturado que se le muestra al cliente receptor.
		       REPL(SPACE(01),186)  // 5=>186:220.(Si) Reservado.Filler.

       CASE BAN->nPagOnlBan == 2       // Asobancaria 2001. Place to Play

	    cNitEmp := SUBS(SCO->cNroNitCon+SPACE(10),1,10)
	    lCorrecion(@cNitEmp)

	    cFecHoy := aFecHoy[3]+aFecHoy[1]+aFecHoy[2]
	  *ÀAAAAMMDD

	    cRegIni := '05'+;               // 1=>002:002.(Si) Constante. Indica el tipo de registro.
		       SCO->cCodEanCon+;    // 2=>013:015.(Si) C¢digo del servicio facturado. C¢digo EAN13 o Nit
		       '0001'+;             // 3=>004:019.(Si) N£mero del lote. Consecutivo del lote dentro del archivo. Cada archivo tiene su propia secuencia de numeraci¢n de lotes.
		       SCA->cSerFacCar+;    // 4=>015:034.(Si) Nombre del servicio facturado que se le muestra al cliente receptor.
		       REPL(SPACE(01),186)  // 5=>186:220.(Si) Reservado.Filler

       CASE BAN->nPagOnlBan == 3       // Red Multicolor

	    cRegIni := ''

       CASE BAN->nPagOnlBan == 4       // ColPatria

	    cRegIni := ''

       CASE BAN->nPagOnlBan == 5       // Avisor

	    cRegIni := ''

       CASE BAN->nPagOnlBan == 6  // Pagos Inteligentes - www.pagosinteligentes.com

	    cRegIni := ''

       CASE BAN->nPagOnlBan == 7  // Pagos Virtuales - Davivienda

	    cRegIni := ''

       ENDCASE
*>>>>FIN REGISTRO ENCABEZADO DE LOTE

*>>>>GRABACION REGISTRO ENCABEZADO DE LOTE
       IF !EMPTY(cRegIni)

	  IF ONL->(lRegLock(lShared,.T.))

	     REPL ONL->nPagOnlCar WITH BAN->nPagOnlBan

	     REPL ONL->cCodigoBan WITH BAN->cCodigoBan
	     REPL ONL->cCodigoEst WITH 'LOTINI'
	     REPL ONL->cForPagOnl WITH cForPag
	     REPL ONL->cRegistTxt WITH cRegIni

	     REPL ONL->cNomUsrOnl WITH cNomUsr
	     REPL ONL->dFecUsrOnl WITH DATE()
	     REPL ONL->cHorUsrOnl WITH TIME()

	     ONL->(DBCOMMIT())
	  ELSE
	     cError('NO SE GRABA EL REGISTRO INICIAL DE LA CONFIGURACION')
	  ENDIF
	  IF lShared
	     ONL->(DBUNLOCK())
	  ENDIF

       ENDIF
*>>>>FIN GRABACION REGISTRO ENCABEZADO DE LOTE

*>>>>RECORRIDO DE LOS NIVELES
       FOR i := 1 TO LEN(cMaeAlu)/3

	   cMaeAct := SUBS(cMaeAlu,i*3-2,3)
	   nParameSet(aP1,'cMaeAct',cMaeAct)

	   PagOnline(aP1,aP2,aP3,nMesIni,cForPag,aTotErr,;
		     aValErr,@nTotReg,@nTotOpo,@nTotExt)
	 *ÀRegistro de detalle

       ENDFOR
*>>>>FIN RECORRIDO DE LOS NIVELES

*>>>>REGISTRO DE CONTROL DE LOTE
       cRegIni := ''
       DO CASE
       CASE BAN->nPagOnlBan == 1       // Asobancaria 2001

	    cTotReg := STR(nTotReg,9)
	    lCorrecion(@cTotReg)

	    cTotOpo := STR(nTotOpo,16,0)+'00'
	    lCorrecion(@cTotOpo)

	    cRegIni := '08'+;               // 01=>002:002.(Si) Indica el tipo de registro. Constante
		       cTotReg+;            // 02=>009:011.(Si) Total registros del lote.
		       cTotOpo+;            // 03=>018:029.(Si) Valor de servicio principal. Valor de la facturaci¢n de la empresa principal
		       REPL('0',18)+;       // 04=>018:047.(No) Valor de servicio adicional.
		       '0001'+;             // 05=>004:051.(Si) Valor N£mero del lote
		       REPL(SPACE(01),169)  // 06=>169:220.(Si) Reservado. Blancos.

       CASE BAN->nPagOnlBan == 2       // Asobancaria 2001. Place to Pay

	    cTotReg := STR(nTotReg,9)
	    lCorrecion(@cTotReg)

	    cTotOpo := STR(nTotOpo,16,0)+'00'
	    lCorrecion(@cTotOpo)

	    cRegIni := '08'+;               // 01=>002:002.(Si) Indica el tipo de registro. Constante
		       cTotReg+;            // 02=>009:011.(Si) Total registros del lote.
		       cTotOpo+;            // 03=>018:029.(Si) Valor de servicio principal. Valor de la facturaci¢n de la empresa principal
		       REPL('0',18)+;       // 04=>018:047.(No) Valor de servicio adicional.
		       '0001'+;             // 05=>004:051.(Si) Valor N£mero del lote
		       REPL(SPACE(01),169)  // 06=>169:220.(Si) Reservado. Blancos

       CASE BAN->nPagOnlBan == 4       // ColPatria

	    cRegIni := ''

       CASE BAN->nPagOnlBan == 5       // Avisor

	    cRegIni := ''

       CASE BAN->nPagOnlBan == 6  // Pagos Inteligentes - www.pagosinteligentes.com

	    cRegIni := ''

       CASE BAN->nPagOnlBan == 7  // Pagos Virtuales - Davivienda

	    cRegIni := ''

       ENDCASE
*>>>>FIN REGISTRO DE CONTROL DE LOTE

*>>>>GRABACION REGISTRO CONTROL DE LOTE
       IF !EMPTY(cRegIni)

	  IF ONL->(lRegLock(lShared,.T.))

	     REPL ONL->nPagOnlCar WITH BAN->nPagOnlBan

	     REPL ONL->cCodigoBan WITH BAN->cCodigoBan
	     REPL ONL->cCodigoEst WITH 'LOTFIN'
	     REPL ONL->cForPagOnl WITH cForPag
	     REPL ONL->cRegistTxt WITH cRegIni

	     REPL ONL->cNomUsrOnl WITH cNomUsr
	     REPL ONL->dFecUsrOnl WITH DATE()
	     REPL ONL->cHorUsrOnl WITH TIME()

	     ONL->(DBCOMMIT())
	  ELSE
	     cError('NO SE GRABA EL REGISTRO INICIAL DE LA CONFIGURACION')
	  ENDIF
	  IF lShared
	     ONL->(DBUNLOCK())
	  ENDIF

       ENDIF
*>>>>FIN GRABACION REGISTRO CONTROL DE LOTE

*>>>>REGISTRO FINAL
       DO CASE
       CASE BAN->nPagOnlBan == 1            // Asobancaria 2001

	    cTotReg := STR(nTotReg,9)
	    lCorrecion(@cTotReg)

	    cTotOpo := STR(nTotOpo,16,0)+'00'
	    lCorrecion(@cTotOpo)

	    cRegFin := '09'+;               // 01=>002:002.(Si) Indica el tipo de registro. Constante
		       cTotReg+;            // 02=>009:011.(Si) N£mero total de registros tipo "6" grabados en el archivo.
		       cTotOpo+;            // 03=>018:029.(Si) Valor total del servicio principal
		       REPL('0',18)+;       // 04=>018:047.(No) Valor total del servicio adicional.
		       REPL(SPACE(01),173)  // 06=>173:220.(Si) Reservado. Blancos.

       CASE BAN->nPagOnlBan == 2            // Asobancaria 2001. Place to Pay

	    cTotReg := STR(nTotReg,9)
	    lCorrecion(@cTotReg)

	    cTotOpo := STR(nTotOpo,16,0)+'00'
	    lCorrecion(@cTotOpo)

	    cRegFin := '09'+;               // 01=>002:002.(Si) Indica el tipo de registro. Constante
		       cTotReg+;            // 02=>009:011.(Si) N£mero total de registros tipo "6" grabados en el archivo.
		       cTotOpo+;            // 03=>018:029.(Si) Valor total del servicio principal
		       REPL('0',18)+;       // 04=>018:047.(No) Valor total del servicio adicional.
		       REPL(SPACE(01),173)  // 06=>173:220.(Si) Reservado. Blancos

       CASE BAN->nPagOnlBan == 3       // Red Multicolor

	    cTotReg := STR(nTotReg,9)
	    lCorrecion(@cTotReg)

	    cTotOpo := STR(nTotOpo,11,0)+'00'
	    lCorrecion(@cTotOpo)

	    cTotExt := STR(nTotExt,11,0)+'00'
	    lCorrecion(@cTotExt)

	    cRegFin := '0009'+;             // Ind. Encabezado Vr Fijo
		       cTotReg+;            // Total Registros Detalle
		       '0000'+;             // Total Reg. Borrados. Valor fijo
		       cTotOpo+;            // Total Vr Principal
		       cTotExt+;            // Total Adicional
		       REPL(SPACE(01),41)   // Espacios

       CASE BAN->nPagOnlBan == 4       // ColPatria

	    cRegFin := ''

       CASE BAN->nPagOnlBan == 5       // Avisor

	    cRegFin := ''

       CASE BAN->nPagOnlBan == 6  // Pagos Inteligentes - www.pagosinteligentes.com

	    cRegFin := ''

       CASE BAN->nPagOnlBan == 7  // Pagos Virtuales - Davivienda

	    cRegFin := ''

       ENDCASE
*>>>>FIN REGISTRO FINAL

*>>>>REGISTRO FINAL
       IF !EMPTY(cRegFin)
	  IF ONL->(lRegLock(lShared,.T.))

	     REPL ONL->cCodigoBan WITH BAN->cCodigoBan
	     REPL ONL->cCodigoEst WITH 'FINAL'
	     REPL ONL->nPagOnlCar WITH BAN->nPagOnlBan
	     REPL ONL->cForPagOnl WITH cForPag
	     REPL ONL->cRegistTxt WITH cRegFin

	     REPL ONL->cNomUsrOnl WITH cNomUsr
	     REPL ONL->dFecUsrOnl WITH DATE()
	     REPL ONL->cHorUsrOnl WITH TIME()

	     ONL->(DBCOMMIT())
	  ELSE
	     cError('NO SE GRABA EL REGISTRO INICIAL DE LA CONFIGURACION')
	  ENDIF
	  IF lShared
	     ONL->(DBUNLOCK())
	  ENDIF
       ENDIF
*>>>>FIN REGISTRO FINAL

*>>>>ACTUALIZACION REGISTRO INICIAL
       ONL->(DBGOTOP())

       cRegIni := ''
       DO CASE
       CASE BAN->nPagOnlBan == 5       // Avisor

	    cFecHoy := aFecHoy[3]+aFecHoy[1]+aFecHoy[2]
	  *ÀAAAAMMDD

	    cTotReg := STR(nTotReg,6)
	    lCorrecion(@cTotReg)

	    cTotOpo := STR(nTotOpo,16,0)+'00'
	    lCorrecion(@cTotOpo)

	    cTotExt := STR(nTotExt,16,0)+'00'
	    lCorrecion(@cTotExt)

	    cCodSer := SUBS(SCA->cCodSerCar,3,2)  // N£mero que identifica el servicio

				     // No=>Ini:Fin:Len.(Requerido)
	    cRegIni := '1'           // 01=>001:001:001.(S) Registro detalle
	    cRegIni += cFecHoy       // 02=>002:009:008.(S) Fecha de Corte
	    cRegIni += cTotReg       // 03=>010:015:006.(S) Cantidad total registros tipo 2
	    cRegIni += cTotOpo       // 04=>016:033:016.(S) Valor total de transacciones suma del campo ValueDate1
	    cRegIni += cCodSer	     // 05=>034:035:002.(S) 00=Cuando se maneja un solo ciclo de facturacion
	    cRegIni += SPACE(527)    // 06=>036:562:527.(S) Espacios para completar la longitud del registro


       ENDCASE
*>>>>FIN ACTUALIZACION REGISTRO INICIAL

*>>>>ACTUALIZACION REGISTRO INICIAL
       IF !EMPTY(cRegIni)

	  IF ONL->(lRegLock(lShared,.F.))

	     REPL ONL->cRegistTxt WITH cRegIni
	     ONL->(DBCOMMIT())

	  ELSE
	     cError('NO SE GRABA EL REGISTRO INICIAL DE LA CONFIGURACION')
	  ENDIF
	  IF lShared
	     ONL->(DBUNLOCK())
	  ENDIF

       ENDIF
       RETURN NIL
*>>>>FIN ACTUALIZACION REGISTRO INICIAL

/*************************************************************************
* TITULO..: RECORRIDO DE LOS PAGOS EN LINEA                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 29/2008 JUE A
       Bucaramanga, Colombia        INICIO: 09:30 AM   MAY 29/2008 JUE

OBJETIVOS:

1- Crea los registros de los pagos facturados.

2- Retorna .T. Si no hay problemas.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PagOnline(aP1,aP2,aP3,nMesIni,cForPag,aTotErr,;
		   aValErr,nTotReg,nTotOpo,nTotExt)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       nMesIni                              // Mes Inicial
       cForPag			            // Forma de pago
       aTotErr                              // Registro de Errores
       aValErr                              // Campos a Validar
       nTotReg                              // Total Registros
       nTotOpo                              // Total pago oporturno
       nTotExt                              // Total pago extemporaneo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION PARAMETROS
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
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL cMsgErr := ''                  // Mensaje de Error
       LOCAL aRegErr := {}                  // Registro Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,;
			 lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)

	  cError('ABRIENDO ARCHIVOS. GRUPOS DE '+cMaeAct)

	  CloseDbf('GRU')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTE GRUPOS GRABADOS EN '+cMaeAct)
       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseDbf('GRU')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>RECORRIDO POR GRUPOS
       SELECT GRU
       GRU->(DBGOTOP())
       DO WHILE .NOT. GRU->(EOF())

**********PREPARACION DE LAS VARIABLES DE ARCHIVO
	    FileCli := cPatSis+'\CLIENTES\CL'+;
				GRU->cCodigoGru+cAnoSis+ExtFile

	    FilePag := cPatSis+'\PAGOS\PA'+;
				GRU->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
	       !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)

	       cMsgErr := 'ABRIENDO CLIENTES Y PAGOS'
	       cError(cMsgErr)

	       aRegErr := {'',GRU->cCodigoGru,cMsgErr}
	       AADD(aTotErr,aRegErr)

	       CloseDbf('GRU')
	       CloseDbf('CLI')
	       CloseDbf('PAG')
	       RETURN NIL
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE CLI->(RECCOUNT()) == 0

		 cMsgErr := 'NO EXISTEN CLIENTES GRABADOS'
		 cError(cMsgErr+' PARA '+GRU->cCodigoGru)

	    CASE PAG->(RECCOUNT()) == 0

		 cMsgErr := 'NO EXISTEN PAGOS GRABADOS'
		 cError(cMsgErr+' PARA '+GRU->cCodigoGru)

	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE
	    IF lHayErr
	       aRegErr := {'',GRU->cCodigoGru,cMsgErr}
	       AADD(aTotErr,aRegErr)

	       CloseDbf('GRU')
	       CloseDbf('CLI')
	       CloseDbf('PAG')
	       RETURN NIL
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********GRABACION DE LA FACTURACION
	    RegOnline(aP1,aP2,aP3,;
		      nMesIni,cForPag,aTotErr,aValErr,;
		      @nTotReg,@nTotOpo,@nTotExt)
**********FIN GRABACION DE LA FACTURACION

**********AVANCE DEL REGISTRO
	    CloseDbf('CLI')
	    CloseDbf('PAG')

	    SELECT GRU
	    GRU->(DBSKIP())
**********FIN AVANCE DEL REGISTRO

       ENDDO
       CloseDbf('GRU')
       RETURN NIL
*>>>>FIN RECORRIDO POR GRUPOS

/*************************************************************************
* TITULO..: GRABACION DE LA FACTURACION                                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 29/2008 JUE A
       Bucaramanga, Colombia        INICIO: 10:30 AM   MAY 29/2008 JUE

OBJETIVOS:

1- Graba la facturaci¢n para los pagos en l¡nea

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RegOnline(aP1,aP2,aP3,nMesIni,cForPag,aTotErr,;
		   aValErr,nTotReg,nTotOpo,nTotExt)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       nMesIni                              // Mes Inicial
       cForPag			            // Forma de pago
       aTotErr                              // Registros de Errores
       aValErr                              // Campos a Validar
       nTotReg                              // Total Registros
       nTotOpo                              // Total pago oporturno
       nTotExt                              // Total pago extemporaneo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION PARAMETROS
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
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL nVlrInt := 0                   // Valor de los Intereses

       LOCAL cMsgErr := ''                  // Mensaje de Error
       LOCAL aRegErr := {}                  // Registro Error

       LOCAL aFecHoy := {}                  // Fecha de Proceso
       LOCAL cMesIni := ''                  // Mes Inicial
       LOCAL cMesFin := ''                  // Mes Final
       LOCAL cNroFac := ''                  // N£mero de la Factura
       LOCAL cCodFac := ''                  // Codigo de la Factura
       LOCAL cNroRef := ''                  // N£mero de la Referencia
       LOCAL cRefPal := ''                  // Referencia principal del Usuario
       LOCAL cRefSec := ''                  // Referencia secundaria del Usuario
       LOCAL cIdeCli := ''                  // N£mero de Identificaci¢n del Cliente
       LOCAL cDescri := ''                  // Descripci¢n

       LOCAL aIniOpo := {}                  // Fecha Inicail para pago oportuno
       LOCAL cIniOpo := ''                  // Fecha Inicial para pago oportuno

       LOCAL aFecOpo := {}                  // Fecha para pago oportuno
       LOCAL cFecOpo := ''                  // Fecha para pago oportuno

       LOCAL aIniExt := {}                  // Fecha Inicil para pago extemporaneo.
       LOCAL cIniExt := ''                  // Fecha Inicial para pago extemporaneo.

       LOCAL aFecExt := {}                  // Fecha para pago extemporaneo
       LOCAL cFecExt := ''                  // Fecha para pago extemporaneo

       LOCAL cVlrOpo := ''                  // Valor Oportuno
       LOCAL cVlrInt := ''                  // Valor de los Intereses
       LOCAL cVlrExt := ''                  // Valor Extemporaneo

       LOCAL cVlrPag := ''                  // Valor a pagar
       LOCAL cFecPag := ''                  // Fecha de pago

       LOCAL cRegTxt := ''                  // Registro en texto
       LOCAL cRegOpo := ''                  // Registro en texto Opoturno
       LOCAL cRegExt := ''                  // Registro en texto Extemporaneo.
       LOCAL cRegUsr := ''                  // Registro en texto

       LOCAL aVlrCon := {}                  // Valores por conceptos
       LOCAL nVlrMes := 0                   // Valor del Mes
       LOCAL nVlrOpo := 0                   // Valor Oportuno
       LOCAL nVlrAde := 0                   // Valor por adelantado

       LOCAL nLenTxt := 0                   // Longitud del Texto
       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL cNomFac := ''                  // Nombre para el Recibo
       LOCAL cDocNit := ''                  // Documento del que paga
       LOCAL cTipNit := ''                  // Tipo de Documento

       LOCAL cCodOnl := ''                  // C¢digo Asignado pago en l¡nea
       LOCAL cCodSer := ''                  // C¢digo del servicio

       LOCAL cNombre := ''                  // Nombre del Estudiante
       LOCAL cApelli := ''                  // Apellidos del Estudiante

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cApelliTes := ''               // Apellidos del Estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECORRIDO POR GRUPO
       cCodOnl := SCA->cCodOnlCar
       cCodSer := SCA->cCodSerCar

       SELECT CLI
       CLI->(DBGOTOP())
       DO WHILE .NOT. CLI->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('MES FACTURADO:'+cMes(nMesIni)+;
			'ºGRUPO: '+GRU->cCodigoGru+;
			'ºCODIGO: '+CLI->cCodigoEst+;
			'ºNo. '+STR(CLI->(RECNO()),2)+'/'+;
				STR(CLI->(RECCOUNT()),2),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
	    IF CLI->lRetgruCli
	       CLI->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

**********LOCALIZACION DEL PAGO
	    IF !lLocCodPag(CLI->cCodigoEst,nMesIni,.F.)
	       CLI->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN LOCALIZACION DEL PAGO

**********ANALISIS DE DECISION
	    IF PAG->nVlrPagPag == 0
	       CLI->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS DE DECISION

**********ANALISIS DEL RECIBO PAGADO
	    IF !EMPTY(PAG->dFecPagPag) .AND.;
	       (PAG->cEstadoPag == 'P' .OR. PAG->cEstadoPag == 'A')

	       CLI->(DBSKIP())
	       LOOP

	    ENDIF
**********FIN ANALISIS DEL RECIBO PAGADO

**********ANALISIS DEL RECIBO NO PAGADO
	    IF PAG->cEstadoPag == 'D'

	       CLI->(DBSKIP())
	       LOOP

	    ENDIF
**********FIN ANALISIS DEL RECIBO NO PAGADO


**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    cNombreTes := ''
	    cApelliTes := ''

	    IF !lSekCodMae(CLI->cCodigoEst,cMaeAct,@cNalias,.F.)

	       CLI->(DBSKIP())
	       LOOP

	    ENDIF

	    cNombreTes := ALLTRIM(&cMaeAct->cNombreEst)
	    cApelliTes := ALLTRIM(&cMaeAct->cApelliEst)

	    cNomFac := cNomFacMae(cMaeAct,CAA->nNomFacCaA)
	    cDocNit := cNitFacMae(cMaeAct,CAA->nNomFacCaA,,,,@cTipNit)
**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********CALCULO DE LOS INTERESES
	    nVlrInt := nVlrIntPag(CAA->lIntPenCaA,;
				  PAG->nMesIniPag,;
				  CAA->nMesAmnCaA)
**********FIN CALCULO DE LOS INTERESES

**********DETALLES DE LA FACTURACION
	    cMesIni := STR(PAG->nMesIniPag,2)
	    lCorrecion(@cMesIni)

	    cMesFin := STR(PAG->nMesFinPag,2)
	    lCorrecion(@cMesFin)

	    cCodEmp := STR(SCO->nCodEmpCon,2)
	    lCorrecion(@cCodEmp)

	    cNroFac := STR(PAG->nNroFacCaA,8)
	    lCorrecion(@cNroFac)

	    cCodFac := PAG->cCodigoEst+cMesIni+cMesFin

	    aFecHoy := aFecha(DATE())

	    aFecOpo := aFecha(PAG->dPagOpoPag)

	    cIniOpo := aFecOpo[1]+'/01/'+aFecOpo[3]
	    aIniOpo := aFecha(CTOD(cIniOpo))

	    aIniExt := aFecha(PAG->dPagOpoPag+1)
	    aFecExt := aFecha(PAG->dPagExtPag)


	    cRegTxt := ''
	    cRegUsr := ''
	    DO CASE
	    CASE BAN->nPagOnlBan == 1       // Asobancaria 2001

//                                31    +  10   +   4   +   2   +   1   = 48
		 cRefPal := REPL('0',31)+cCodFac+cAnoUsr+cCodEmp+cForPag


		 cRefSec := REPL('0',24)+PAG->cCodigoEst

		 cIdeCli := REPL('0',10)

		 cNroRef := ALLTRIM(cCodFac+cAnoUsr+cCodEmp+cNroFac)
		 cNroRef := SUBS(cNroRef+REPL('0',48),1,48)

		 IF cForPag == '1' // Pago Oportuno

		    IF CAA->nMtdFacCaA == 1  // M‚todo del Virrey

		       nVlrMes := 0
		       nVlrOpo := PAG->nSdoAntPag+;
				  PAG->nMorAntPag+;
				  nVlrMesMtd(aVlrCon,@nVlrMes)

		       IF PAG->nMesIniPag # PAG->nMesFinPag
			  nVlrAde := nVlrMes * (PAG->nMesFinPag - PAG->nMesIniPag)
			  nVlrOpo += nVlrAde
		       ENDIF
		     *ÀRecibo por adelantado

		       cVlrOpo := STR(nVlrOpo,10,0)+'00'
		       lCorrecion(@cVlrOpo)
		       cVlrOpo := '00'+cVlrOpo

		    ELSE
		       cVlrOpo := STR(PAG->nVlrPagPag,10,0)+'00'
		       lCorrecion(@cVlrOpo)
		       cVlrOpo := '00'+cVlrOpo
		    ENDIF

		 ENDIF

		 cVlrInt := STR(nVlrInt,6,0)+'0000'
		 lCorrecion(@cVlrInt)

		 cVlrExt := STR(PAG->nVlrPagPag+nVlrInt,10,0)+'00'
		 lCorrecion(@cVlrExt)
		 cVlrExt := '00'+cVlrExt

		 cFecOpo := aFecOpo[3]+aFecOpo[1]+aFecOpo[2]
		 cFecExt := aFecExt[3]+aFecExt[1]+aFecExt[2]
	       *ÀAAAAMMDD

		 IF cForPag == '1'
		    cVlrPag := cVlrOpo
		    cFecPag := cFecOpo
		 ELSE
		    cVlrPag := cVlrExt
		    cFecPag := cFecExt
		 ENDIF

		 cRegTxt := '06'+;                 // 01=>02:002. Tipo de Registro
			    cRefPal+;              // 02=>48:050. Referencia principal del Usuario
			    cRefSec+;              // 03=>30:080. Referencia secundaria del Usuario
			    REPL('0',2)+;          // 04=>02:082. Periodos facturados.
			    REPL('0',3)+;          // 05=>03:085. Ciclo
			    cVlrPag+;              // 06=>14:099. Valor del Servicio principal
			    REPL('0',13)+;         // 07=>13:112. C¢digo del servicio facturado por Empresa adicional
			    REPL('0',14)+;         // 08=>14:126. Valor del servicio adicional
			    cFecPag+;              // 09=>08:134. Fecha de vencimiento
			    REPL('0',8)+;          // 10=>08:142. Identificaci¢n de la EFR. Banco del Cliente
			    REPL('0',17)+;         // 11=>17:159. No. Cuenta del cliente receptor.
			    REPL('0',2)+;          // 12=>02:161. Tipo de cuenta del cliente receptor
			    REPL('0',10)+;         // 13=>10:171. No Identificaci¢n del cliente
			    REPL('0',22)+;         // 14=>22:193. Nombre del cliente receptor
			    REPL('0',3)+;          // 15=>03:196. C¢digo de Entidad Financiera Originaria
			    REPL('0',24)           // 16=>24:220. Reservado. Blancos.


	    CASE BAN->nPagOnlBan == 2       // Asobancaria 2001. Place to Play

//                                34    +   4   +   2   +  8 = 48
//		 cRefPal := REPL('0',34)+cAnoUsr+cCodEmp+cNroFac
		 cRefPal := REPL('0',40)+cNroFac

		 cRefSec := SUBS(cCodFac+REPL(' ',30),1,30)

		 cIdeCli := SUBS(PAG->cCodigoEst+REPL(' ',10),1,10)

		 cVlrOpo := STR(PAG->nVlrPagPag,10,0)+'00'
		 lCorrecion(@cVlrOpo)
		 cVlrOpo := '00'+cVlrOpo
		 nVlrOpo := PAG->nVlrPagPag

		 cVlrInt := STR(nVlrInt,6,0)+'0000'
		 lCorrecion(@cVlrInt)

		 cVlrExt := STR(PAG->nVlrPagPag+nVlrInt,10,0)+'00'
		 lCorrecion(@cVlrExt)
		 cVlrExt := '00'+cVlrExt

		 cFecOpo := aFecOpo[3]+aFecOpo[1]+aFecOpo[2]
		 cFecExt := aFecExt[3]+aFecExt[1]+aFecExt[2]
	       *ÀAAAAMMDD

		 cRegTxt := '06'+;                 // 01=>02:002. Tipo de Registro
			    cRefPal+;              // 02=>48:050. Referencia principal del Usuario
			    cRefSec+;              // 03=>30:080. Referencia secundaria del Usuario
			    REPL('0',2)+;          // 04=>02:082. Periodos facturados.
			    SPACE(03)+;            // 05=>03:085. Ciclo
			    cVlrOpo+;              // 06=>14:099. Valor del Servicio principal
			    REPL('0',13)+;         // 07=>13:112. C¢digo del servicio facturado por Empresa adicional
			    cVlrExt+;              // 08=>14:126. Valor del servicio adicional
			    cFecOpo+;              // 09=>08:134. Fecha de vencimiento
			    REPL('0',8)+;          // 10=>08:142. Identificaci¢n de la EFR. Banco del Cliente
			    REPL(SPACE(01),17)+;   // 11=>17:159. No. Cuenta del cliente receptor.
			    REPL('0',2)+;          // 12=>02:161. Tipo de cuenta del cliente receptor
			    cIdeCli+;              // 13=>10:171. No Identificaci¢n del cliente
			    REPL(SPACE(01),22)+;   // 14=>22:193. Nombre del cliente receptor
			    REPL('0',3)+;          // 15=>03:196. C¢digo de Entidad Financiera Originaria
			    cVlrInt+;              // 16=>10:206. Incremento al vencimiento
			    cFecExt+;              // 17=>08:214. Fecha de corte. Fecha de vencimiento
			    '1'+;                  // 18=>01:215. Incremento fijo.
			    REPL(SPACE(01),5)      // 19=>05:220. Reservado. Blancos.


	    CASE BAN->nPagOnlBan == 3       // Red Multicolor

/*
		 cCodFac := PAG->cCodigoEst+cMesIni+cMesFin+;
			    cAnoUsr+cCodEmp
*/

		 cCodFac := PAG->cCodigoEst+cMesIni+cMesFin
		 cCodFac := SUBS(cCodFac+REPL('0',18),1,18)

		 cVlrOpo := STR(PAG->nVlrPagPag,11,0)+'00'
		 lCorrecion(@cVlrOpo)
		 nVlrOpo := PAG->nVlrPagPag

		 cVlrExt := STR(PAG->nVlrPagPag+nVlrInt,11,0)+'00'
		 lCorrecion(@cVlrExt)

		 cRegTxt := '0002'+;               // Ind. Detalle Vr fijo
			    cCodFac+;              // C¢digo del recibo
			    '0000'+;               // Ind Actualizaci¢n. Valor fijo
			    '0012'+;               // N£mero Vista. Valor fijo
			    '0000'+;               // Indicador Interno
			    REPL(SPACE(01),10)+;   // Filler
			    SUBS(aFecHoy[3],3,2)+; // A¤o facturaci¢n
			    aFecHoy[1]+;           // Mes facturaci¢n
			    aFecHoy[2]+;           // Dia facturaci¢n
			    cMesIni+;              // Periodo facturado
			    SUBS(aFecOpo[3],3,2)+; // A¤o vencimiento
			    aFecOpo[1]+;           // Mes vencimiento
			    aFecOpo[2]+;           // Dia vencimiento
			    cVlrOpo+;              // Valor principal
			    cVlrExt                // Valor adicional

	    CASE BAN->nPagOnlBan == 4       // ColPatria

//                                15    +  10    = 25
		 cRefPal := REPL('0',15)+PAG->cCodigoEst+cMesIni+cMesFin


		 cRefSec := REPL('0',24)+PAG->cCodigoEst

		 cIdeCli := REPL('0',10)

		 cNroRef := ALLTRIM(cCodFac+cAnoUsr+cCodEmp+cNroFac)
		 cNroRef := SUBS(cNroRef+REPL('0',48),1,48)

		 IF cForPag == '1' // Pago Oportuno

		    IF CAA->nMtdFacCaA == 1  // M‚todo del Virrey

		       nVlrMes := 0
		       nVlrOpo := PAG->nSdoAntPag+;
				  PAG->nMorAntPag+;
				  nVlrMesMtd(aVlrCon,@nVlrMes)

		       IF PAG->nMesIniPag # PAG->nMesFinPag
			  nVlrAde := nVlrMes * (PAG->nMesFinPag - PAG->nMesIniPag)
			  nVlrOpo += nVlrAde
		       ENDIF
		     *ÀRecibo por adelantado

		       cVlrOpo := STR(nVlrOpo,13,0)+'00'
		       lCorrecion(@cVlrOpo)

		    ELSE
		       cVlrOpo := STR(PAG->nVlrPagPag,13,0)+'00'
		       lCorrecion(@cVlrOpo)
		    ENDIF

		 ENDIF

		 cVlrInt := STR(nVlrInt,6,0)
		 lCorrecion(@cVlrInt)

		 cVlrExt := STR(PAG->nVlrPagPag+nVlrInt,13,0)+'00'
		 lCorrecion(@cVlrExt)

		 cFecOpo := aFecOpo[3]+aFecOpo[1]+aFecOpo[2]
		 cFecExt := aFecExt[3]+aFecExt[1]+aFecExt[2]
	       *ÀAAAAMMDD

		 IF cForPag == '1'
		    cVlrPag := cVlrOpo
		    cFecPag := cFecOpo
		 ELSE
		    cVlrPag := cVlrExt
		    cFecPag := cFecExt
		 ENDIF


		 nLenTxt := LEN(ALLTRIM(cNombreTes))
		 IF nLenTxt >= 25
		    cNombreTes := SUBS(cNombreTes+SPACE(25),1,25)
		 ELSE
		    cNombreTes := cNombreTes+SPACE(25-nLenTxt)
		 ENDIF


		 nLenTxt := LEN(ALLTRIM(cNomFac))
		 IF nLenTxt >= 25
		    cNomFac := SUBS(cNomFac+SPACE(25),1,25)
		 ELSE
		    cNomFac := cNomFac+SPACE(25-nLenTxt)
		 ENDIF


		 nLenTxt := LEN(ALLTRIM(cDocNit))
		 IF nLenTxt >= 25
		    cDocNit := SUBS(cDocNit+SPACE(25),1,25)
		 ELSE
		    cDocNit := cDocNit+SPACE(25-nLenTxt)
		 ENDIF


		 cRegTxt := '6'+;                  // 01=>01:000-001. Tipo de Cuenta. Corriente
			    '0391016162'+;         // 02=>10:002-011. N£mero de la Cuenta.
			    cRefPal+;              // 03=>25:012-036. Referencia1. CodigoEst+MesIni+MesFin
			    cDocNit+;              // 04=>25:037-061. Referencia2. C‚dula del que paga
			    SPACE(12)+;            // 05=>12:062-073. Referencia3. No se utiliza
			    cVlrPag+;              // 06=>15:074-088. Valor del Servicio principal
			    cNombreTes+;           // 07=>25:089-113. Campo de Respuesta1=Nombre del Estudiante
			    cNomFac                // 08=>25:114-138. Campo de Respuesta1=Nombre del que paga el recibo

	    CASE BAN->nPagOnlBan == 5       // Avisor


		 cCodOnl := SUBS(cCodOnl,1,35)
		 cCodSer := SUBS(cCodSer,1,35)

		 cRefPal := cCodFac+REPL(' ',70)
		 cRefSec := PAG->cCodigoEst+REPL(' ',74)

		 cFecOpo := aFecOpo[3]+aFecOpo[1]+aFecOpo[2]
		 cFecExt := aFecExt[3]+aFecExt[1]+aFecExt[2]
	       *ÀAAAAMMDD

		 cVlrOpo := STR(PAG->nVlrPagPag,16,0)+'00'
		 lCorrecion(@cVlrOpo)
		 nVlrOpo := PAG->nVlrPagPag

		 cVlrExt := STR(PAG->nVlrPagPag+nVlrInt,16,0)+'00'
		 lCorrecion(@cVlrExt)

					  // No=>Ini:Fin:Len.(Requerido)
		 cRegTxt := '2'           // 01=>001:001:001.(S) Registro detalle
		 cRegTxt += cCodOnl	  // 02=>002:036:035.(S) C¢digo interno de entidad asignado por Avisor
		 cRegTxt += cCodSer	  // 03=>037:071:035.(S) C¢digo interno asignado por la Empresa para clasificar el servicio que se factura
		 cRegTxt += cRefSec	  // 04=>072:151:080.(S) Primer referencia
		 cRegTxt += cRefPal	  // 05=>152:231:080.(N) Segunda referencia
		 cRegTxt += SPACE(80)	  // 06=>232:311:080.(N) Tercera referencia
		 cRegTxt += SPACE(40)	  // 07=>312:351:040.(N) C¢digo de ¡tem cuando el servicio es de tipo Estado de cuenta
		 cRegTxt += SPACE(80)	  // 08=>352:431:040.(N) Descripci¢n de ¡tem cuando el servicio es de tipo Estado de cuenta
		 cRegTxt += '0'		  // 09=>432:432:001.(S) Nota d‚bito(= 0 Deuda del usuario) o cr‚dito(= 1 A favor del Usuario)
		 cRegTxt += cFecOpo	  // 10=>433:440:008.(S) Primera fecha de vencimiento
		 cRegTxt += cVlrOpo	  // 11=>441:458:018.(S) Valor primera fecha
		 cRegTxt += cFecExt	  // 12=>459:466:008.(N) Segunda fecha vencimiento
		 cRegTxt += cVlrExt	  // 13=>467:484:018.(N) Valor segunda fecha
		 cRegTxt += REPL('0',8)	  // 14=>485:492:008.(N) Tercera fecha de vencimiento
		 cRegTxt += REPL('0',18)  // 15=>493:510:018.(N) Valor tercera fecha
		 cRegTxt += REPL('0',8)	  // 14=>511:518:008.(N) Cuarta fecha de vencimiento
		 cRegTxt += REPL('0',18)  // 15=>519:536:018.(N) Valor cuarta fecha
		 cRegTxt += REPL('0',8)	  // 14=>537:544:008.(N) Quinta fecha de vencimiento
		 cRegTxt += REPL('0',18)  // 15=>545:562:018.(N) Valor quinta fecha


		 cNombre := SUBS(cNombreTes+SPACE(50),1,50)
		 cApelli := SUBS(cApelliTes+SPACE(50),1,50)

					  // No=>Ini:Fin:Len.(Requerido)
		 cRegUsr := cRefSec       // 01=>001:080:080.(S) Identifica al usuario autorizado.Debe corresponder con el campo Reference1 del archivo de entrada
		 cRegUsr += '01'          // 02=>081:082:002.(S) Indicador del tipo de usuario
		 cRegUsr += REPL(' ',35)  // 03=>083:117:035.(N) Segundo criterio de autenticaci[on del usuario para ingresar a efectuar pagos
		 cRegUsr += REPL('0',02)  // 04=>118:119:002.(N) Tipo de identificaci¢n
		 cRegUsr += cNombre       // 05=>120:169:050.(S) Nombre del Usuario
		 cRegUsr += cApelli       // 06=>170:219:050.(S) Apellido del Usuario
		 cRegUsr += REPL(' ',50)  // 07=>220:269:050.(N) mail
		 cRegUsr += REPL(' ',80)  // 08=>270:349:080.(N) Direcci¢n
		 cRegUsr += REPL(' ',50)  // 09=>350:399:050.(N) Ciudad
		 cRegUsr += REPL(' ',50)  // 10=>400:449:050.(N) Telefono
		 cRegUsr += REPL(' ',80)  // 11=>450:529:080.(N) *N£mero del periodo al cual pertenece
		 cRegUsr += '  '          // 12=>530:531:002.(N) Rol del usuario
		 cRegUsr += ' '           // 13=>532:532:001.(N) Tipo de Persona

	    CASE BAN->nPagOnlBan == 6  // Pagos Inteligentes - www.pagosinteligentes.com


		 cCodOnl := ALLTRIM(cCodOnl)

		 cRefPal := cCodFac+SCA->cCodFacCar+cAnoUsr

		 cVlrOpo := STR(PAG->nVlrPagPag,9,0)
		 lCorrecion(@cVlrOpo)

		 cVlrExt := STR(PAG->nVlrPagPag+nVlrInt,9,0)
		 lCorrecion(@cVlrExt)

		 cIniOpo := aIniOpo[2]+aIniOpo[1]+aIniOpo[3]
		 cFecOpo := aFecOpo[2]+aFecOpo[1]+aFecOpo[3]
	       *ÀAAAAMMDD

		 cIniExt := aIniExt[2]+aIniExt[1]+aIniExt[3]
		 cFecExt := aFecExt[2]+aFecExt[1]+aFecExt[3]
	       *ÀAAAAMMDD

		 cRegTxt := 'IDC'                 // 01=>Tipo de documento - IDC:Identificado £nico del cliente.
		 cRegTxt += ';'
		 cRegTxt += PAG->cCodigoEst	  // 02=>Numero del documento o identificaci¢n IDC
		 cRegTxt += ';'
		 cRegTxt += cRefPal               // 03=>Referencia1
		 cRegTxt += ';'
		 cRegTxt += cRefPal               // 04=>Referencia2
		 cRegTxt += ';'
		 cRegTxt += cRefPal               // 05=>Referencia3
		 cRegTxt += ';'
		 cRegTxt += ALLTRIM(SCA->cSerFacCar)+'.'+;
			    'RECIBO DE '+;
			    cMes(PAG->nMesIniPag)+' '+;
			    cAnoUsr               // 06=>Descripci¢n
		 cRegTxt += ';'

		 cRegOpo := cRegTxt
		 cRegExt := cRegTxt
						  
		 cRegOpo += cVlrOpo               // 07=>Total
		 cRegOpo += ';'
		 cRegOpo += '0'                   // 08=>Impuesto
		 cRegOpo += ';'
		 cRegOpo += '0'                   // 09=>Base devoluci¢n
		 cRegOpo += ';'
		 cRegOpo += cIniOpo+'235959'      // 10=>Fecha Inicio
		 cRegOpo += ';'
		 cRegOpo += cFecOpo+'235959'      // 11=>Fecha Expiraci¢n
		 cRegOpo += ';'
		 cRegOpo += cCodOnl               // 12=>C¢digo de Servicio para PSE

		 cRegExt += cVlrExt               // 07=>Total
		 cRegExt += ';'
		 cRegExt += '0'                   // 08=>Impuesto
		 cRegExt += ';'
		 cRegExt += '0'                   // 09=>Base devoluci¢n
		 cRegExt += ';'
		 cRegExt += cIniExt+'235959'      // 10=>Fecha Inicio
		 cRegExt += ';'
		 cRegExt += cFecExt+'235959'      // 11=>Fecha Expiraci¢n
		 cRegExt += ';'
		 cRegExt += cCodOnl               // 12=>C¢digo de Servicio para PSE

	    CASE BAN->nPagOnlBan == 7  // Pagos Virtuales - Davivienda

		 cDescri := 'RECIBO DE '+;
			    cMes(nMesIni,3)+' '+cAnoUsr+'.'+;
			    ALLTRIM(SCA->cSerFacCar)

		 cVlrOpo := ALLTRIM(STR(PAG->nVlrPagPag,10,0))
		 cVlrOpo := cVlrOpo
		 nVlrOpo := PAG->nVlrPagPag

		 cFecOpo := aFecOpo[2]+'/'+aFecOpo[1]+'/'+aFecOpo[3]
	       *ÀDDMMAAAA

		 cVlrExt := ALLTRIM(STR(PAG->nVlrPagPag+nVlrInt,10,0))
		 cVlrExt := cVlrExt


		 cFecExt := aFecExt[2]+'/'+aFecExt[1]+'/'+aFecExt[3]
	       *ÀDDMMAAAA

		 cRegTxt := cCodFac+ALLTRIM(SCA->cCodFacCar)+cAnoSis+'|'+;            // 01. ID_UNICO_PAGO
			    PAG->cCodigoEst+'|'+;                                     // 02. ID_CLIENTE
			    cVlrOpo+'|'+;	                                      // 03. VALOR_CON_IVA
			    '0|'+;                                                    // 04. VALOR_IVA
			    cDescri+'.PAGO OPORTUNO|'+;                               // 05. CONCEPTO
			    cFecOpo+'|'+;                                             // 06. FECHA_VENCIMIENTO
			    ' |'+;	                                              // 07. EMAIL
			    ' |'+;	                                              // 08. CLAVE_PAGO
			    ALLTRIM(cNombreTes)+'|'+;                                 // 09. NOMBRE
			    ALLTRIM(cApelliTes)+'|'+;                                 // 10. APELLIDO
			    ' |'+;	                                              // 11. TELEFONO
			    GRU->cCodigoGru+'|'+;                                     // 12. CAMPO_OPCIONAL1
			    cCodFac+cAnoUsr+ALLTRIM(SCA->cCodFacCar)+cNroFac+'|'+;    // 13. CAMPO_OPCIONAL2
			    ALLTRIM(BAN->cValCtaBan)+'|'+;                            // 14. CAMPO_OPCIONAL3
			    cFecExt+'|'+;		                              // 15. FECHA EXTEMPORANEO
			    cVlrExt+'|'+;                                             // 16. VALOR EXTEMPORANEO. VALOR CON IVA 2
			    '0|'+;                                                    // 17. VALOR_IVA 2
			    cDescri+'.PAGO EXTEMPORANEO'                              // 18. CONCEPTO 2
	    ENDCASE
**********DETALLES DE LA FACTURACION

**********GRABACION DEL PAGO
	    FOR i := 1 TO IF(BAN->nPagOnlBan==6,2,1)

		IF BAN->nPagOnlBan == 6 // Pagos Inteligentes - www.pagosinteligentes.com
		   IF i == 1
		      cRegTxt := cRegOpo
		   ELSE
		      cRegTxt := cRegExt
		   ENDIF
		ENDIF

		IF ONL->(lRegLock(lShared,.T.))

		   REPL ONL->nPagOnlCar WITH BAN->nPagOnlBan

		   REPL ONL->cCodigoBan WITH BAN->cCodigoBan
		   REPL ONL->cCodigoEst WITH PAG->cCodigoEst
		   REPL ONL->cCodigoGru WITH GRU->cCodigoGru
		   REPL ONL->nMesIniPag WITH PAG->nMesIniPag
		   REPL ONL->nMesFinPag WITH PAG->nMesFinPag
		   REPL ONL->cForPagOnl WITH cForPag
		   REPL ONL->nVlrOpoPag WITH nVlrOpo
		   REPL ONL->nVlrExtPag WITH PAG->nVlrPagPag+nVlrInt
		   REPL ONL->dFecFacPag WITH PAG->dFecFacPag
		   REPL ONL->dPagOpoPag WITH PAG->dPagOpoPag
		   REPL ONL->dPagExtPag WITH PAG->dPagExtPag
		   REPL ONL->nNroFacCaA WITH PAG->nNroFacCaA
		   REPL ONL->nIntMorPag WITH PAG->nIntMorPag
		   REPL ONL->nVlrMorPag WITH PAG->nVlrMorPag
		   REPL ONL->cConcepPag WITH PAG->cConcepPag

		   REPL ONL->cNombreEst WITH cNombreTes
		   REPL ONL->cApelliEst WITH cApelliTes


		   REPL ONL->cRegistTxt WITH cRegTxt
		   REPL ONL->cRegUsrTxt WITH cRegUsr


		   REPL ONL->cNomUsrOnl WITH cNomUsr
		   REPL ONL->dFecUsrOnl WITH DATE()
		   REPL ONL->cHorUsrOnl WITH TIME()

		   nTotReg++
		   nTotOpo += ONL->nVlrOpoPag
		   nTotExt += ONL->nVlrExtPag

		   ONL->(DBCOMMIT())
		ELSE
		   cError('NO SE GRABA EL REGISTRO INICIAL DE LA CONFIGURACION')
		ENDIF
		IF lShared
		   ONL->(DBUNLOCK())
		ENDIF

	    ENDFOR
**********FIN GRABACION DEL PAGO

	  CLI->(DBSKIP())

       ENDDO
       RETURN NIL
*>>>>FIN RECORRIDO POR GRUPO



