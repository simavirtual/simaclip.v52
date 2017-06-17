/*               	 SISTEMA CARTERA ACADEMICA
	      BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO CLIENTES

REQUERIMIENTOS:

- Compilar: clipper FuncsCli /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo de Clientes

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 24/94 SAB A
						       DIC 24/94 SAB
OBJETIVOS:

1)- Crea la estructura del archivo Clientes

2)- Retorna NIL

SINTAXIS:



*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfCli(lShared,nModCry,PathCli,FileCli,lIntUno,fNtxCli,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathCli				    // Path del Archivo
       FileCli				    // Nombre del Archivo
       lIntUno			            // Sistema Integrado
       fNtxCli				    // Archivo de Indices
       aStrDbf                              // @Estructura de las bases */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual

       LOCAL aDbfCli := {{"cCodigoEst","Character",06,0},; // C¢digo del Estudiante
			 {"lRetGruCli","Logical"  ,01,0},; // .T. Retirado del Grupo
			 {"nNroLisEst","Numeric"  ,03,0},; // N£mero de lista
			 {"nSdoActCli","Numeric"  ,12,2},; // Saldo Actual
			 {"nSdoMorCli","Numeric"  ,12,2},; // Valor de la Mora
			 {"cConSdoCli","Character",16,0},; // Conceptos del saldo en mora
			 {"nSdoAnoCli","Numeric"  ,12,2},; // Saldo a¤o Anterior
			 {"nMorAnoCli","Numeric"  ,12,2},; // Mora a¤o Anterior
			 {"nAnoSdoCli","Numeric"  ,04,0},; // A¤o del Saldo
			 {"cAnoSdoCli","Numeric"  ,04,0},; // A¤o del Saldo
			 {"nSdAbonCli","Numeric"  ,12,2},; // Saldo Actual sin abonos
			 {"nMoAbonCli","Numeric"  ,12,2},; // Mora Actual sin abonos
			 {"nSdoFavCli","Numeric"  ,12,2},; // Saldo a Favor.
			 {"cNroCopCli","Character",24,0},; // N£mero de copias del recibo
			 {"cMesPagCli","Character",12,0},; // Control de meses pagados
			 {"cTipNovCli","Character",48,0},; // Tipo de Novedad de Reporte. Cuatro caracteres por mes.
			 {"nPorBecCli","Numeric"  ,03,0},; // Porcentaje de la beca
			 {"nVlrBecCli","Numeric"  ,12,2},; // Valor de la Beca
			 {"nBecIniCli","Numeric"  ,02,0},; // Mes Inicial de la Beca
			 {"nBecFinCli","Numeric"  ,02,0},; // Mes Final de la Beca
			 {"cHayNovCli","Character",12,0},; // Un caracter para cada mes. Ej: 1->Aplicar Novedad 0->No aplicar Novedad. Descuentos Generales
			 {"lFondosCli","Logical"  ,01,0},; // .T. Pertenece al fondo
			 {"cHayRepCli","Character",05,0},; // Control del Reporte. Ej: 0212R =>02 Mes Inicial 1=>Padre,Madre,Acudiente,2=>Nombre a Reportar:Deudor Principal,Primer Fiador,Segundo Fiador. R=>Retirado del Reporte
			 {"cNomUsrCli","Character",10,0},; // Nombre del Usuario
			 {"dFecUsrCli","Date"     ,08,0},; // Fecha del Usuario
			 {"cHorUsrCli","Character",10,0}}  // Hora del Usuario
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfCli
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathCli) == 0
	    DBCREATE(FileCli,aDbfCli,"DBFNTX")
	    Proteger(FileCli,nModCry)

       CASE DIRCHANGE(PathCli) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathCli)

       CASE DIRCHANGE(PathCli) == -5
	    cError('NO TIENE DERECHOS EN: '+PathCli)
       ENDCASE

       DIRCHANGE(PathAct)
       RETURN NIL
*>>>>FIN CREACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION..: RECUPERACION DE LA ESTRUCTURA                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 24/94 SAB A
						       DIC 24/94 SAB
OBJETIVOS:

1)- Recupera la estructura del archivo de Clientes

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfCli(lShared,nModCry,PathCli,FileCli,lIntUno,fNtxCli)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       nModCry                        // Modo de Protecci¢n
       PathCli			      // Path del Archivo
       FileCli			      // Nombre del Archivo
       lIntUno			      // .T. Sistema Integrado
       fNtxCli			      // Archivo de Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathCli+'\'+FileCli,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")

       Termometro(0,"CREANDO LA ESTRUCTURA DE EMPRESA")
       Termometro(100)

       CreaDbfCli(lShared,nModCry,PathCli,FileCli,lIntUno,fNtxCli)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 01/2003 LUN A
       Colombia, Bucaramanga        INICIO: 10:00 PM   ABR 01/2003 LUN

OBJETIVOS:

1)- Actualiza la Estructura del Archivo

2)- Retorna el N£mero de Error:
    0 => No hay Error
	 Estructura Actualizada
	 Estructura Sin problemas
    1 => Estructura No Actualizada

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nActStrCli(lShared,nModCry,PathArc,fArchvo,cMsgErr)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc				    // Path del Archivo
       fArchvo				    // Nombre del Archivo
       cMsgErr                              // Mensaje de Error */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL PathAct := ''                  // Path Actual
       LOCAL nNroErr := 0                   // N£mero del Error
       LOCAL       i := 0                   // Contador
       LOCAL aStrNew := {'1'}               // Estructura Nueva
       LOCAL aStrOld := {}                  // Estructura Vieja
       LOCAL lCambio := .F.                 // .T. Cambio la Estructura
       LOCAL FileTem := ''                  // Archivo temporal
       LOCAL FileBak := ''                  // Archivo Backups
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathArc+'\'+fArchvo,'CLI',NIL,lShared,nModCry)
	  CloseDbf('CLI',PathArc+'\'+fArchvo,nModCry)
	  cMsgErr := 'Error. Abriendo el Archivo de Clientes'
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := CLI->(DBSTRUCT())
       CloseDbf('CLI',PathArc+'\'+fArchvo,nModCry)
       CreaDbfCli(lShared,nModCry,PathArc,fArchvo,NIL,NIL,@aStrNew)
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE LA ESTRUCTURA
       lCambio := .T.
       IF LEN(aStrNew) == LEN(aStrOld)
	  lCambio := .F.
	  nNroErr := 1
	  cMsgErr := 'La Estructura ESTA Actualizada'
       ENDIF

       IF !lCambio
	  FOR i := 1 TO LEN(aStrNew)
	      IF UPPER(aStrNew[i,1]) # UPPER(aStrOld[i,1]) .OR.;
		 UPPER(SUBS(aStrNew[i,2],1,1)) # UPPER(SUBS(aStrOld[i,2],1,1)) .OR.;
		 aStrNew[i,3] # aStrOld[i,3] .OR.;
		 aStrNew[i,4] # aStrOld[i,4]
		 lCambio := .T.
		 EXIT
	      ENDIF
	  ENDFOR
       ENDIF
*>>>>FIN VALIDACION DE LAS STRUCTURAS

*>>>>VERIFICACION O CREACION DEL DIRECTORIO BACKUPS
       IF lCambio
	  PathAct := cPathAct()
	  DO CASE
	  CASE DIRCHANGE (PathArc+'\BACKUPS') == 0
	       DIRCHANGE(PathAct)

	  CASE DIRCHANGE (PathArc+'\BACKUPS') == -5
	       cError("NO HAY DERECHOS EN EL DIRECTORIO LOGROS")
	       QUIT

	  CASE DIRCHANGE(PathArc+'\BACKUPS') == -3
	       DIRMAKE(PathArc+'\BACKUPS')
	  ENDCASE
	  DIRCHANGE(PathAct)

	  FileBak := FileExtTmp(PathArc+'\BACKUPS\',fArchvo,.F.)
	  FILECOPY(PathArc+'\'+fArchvo,PathArc+'\BACKUPS\'+FileBak)
       ENDIF
*>>>>FIN VERIFICACION O CREACION DEL DIRECTORIO BACKUPS

*>>>>ACTUALIZACION DE LA ESTRUCTURA
       IF lCambio
	  nNroErr := 0
	  cMsgErr := 'Estructura SI Actualizada'
	  FileTem := SUBS(fArchvo,1,AT('.',fArchvo))+'STR'
	  cSavPan := SAVESCREEN(0,0,24,79)
	  IF !lStrucFile(lShared,;
			 PathArc+'\'+fArchvo,;
			 PathArc+'\'+FileTem,;
			 {||CreaDbfCli(lShared,nModCry,PathArc,FileTem)},;
			 nModCry)
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	     nNroErr := 1
	     cMsgErr := 'NO se Actualizo la Estructura'
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDA LA EXISTENCIA DE LOS CLIENTES           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 24/94 SAB A
						       DIC 24/94 SAB
OBJETIVOS:

1)- Debe estar en uso el archivo de Grupos

2)- Valida la existencia de los clientes

3)- Retorna .T. si existen los clientes

SINTAXIS:

   lExisteCli

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lFilesCli(cPatSis,cAnoSis)

*>>>>PARAMETROS DE LA FUNCION
/*     cPatSis                              // Path del sistema
       cAnoSis                              // A¤o del Sistema */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL lExiste := .F.                 // .T. Existen los Clientes
       LOCAL PathAct := ''                  // Path Actual
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VERIFICACION O CREACION DEL DIRECTORIO CLIENTES
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE (cPatSis+"\CLIENTES") == 0
	    DIRCHANGE(PathAct)

       CASE DIRCHANGE (cPatSis+"\CLIENTES") == -5
	    cError("NO HAY DERECHOS EN EL DIRECTORIO CLIENTES")
	    QUIT

       CASE DIRCHANGE(cPatSis+"\CLIENTES") == -3
	    DIRMAKE(cPatSis+"\CLIENTES")
       ENDCASE
*>>>>FIN VERIFICACION O CREACION DE DIRECTORIO CLIENTES

*>>>>VERIFICACION O CREACION DEL DIRECTORIO PAGOS
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE (cPatSis+"\PAGOS") == 0
	    DIRCHANGE(PathAct)

       CASE DIRCHANGE (cPatSis+"\PAGOS") == -5
	    cError("NO HAY DERECHOS EN EL DIRECTORIO PAGOS")
	    QUIT

       CASE DIRCHANGE(cPatSis+"\PAGOS") == -3
	    DIRMAKE(cPatSis+"\PAGOS")
       ENDCASE
*>>>>FIN VERIFICACION O CREACION DE DIRECTORIO PAGOS

*>>>>VALIDACION DE EXISTENCIA DE LOS CLIENTES Y PAGOS
       SELECT GRU
       GO TOP
       DO WHILE .NOT. EOF()

**********VERIFICACION DE EXISTENCIA
	    lExiste := .T.
	    DO CASE
	    CASE FILE (cPatSis+'\CLIENTES\CL'+GRU->cCodigoGru+cAnoSis+ExtFile)
	    CASE FILE (cPatSis+'\PAGOS\PA'   +GRU->cCodigoGru+cAnoSis+ExtFile)
	    OTHERWISE
		 lExiste := .F.
	    ENDCASE
**********FIN VERIFICACION DE EXISTENCIA

	  SKIP

       ENDDO
       RETURN lExiste
*>>>>FIN VALIDACION DE EXISTENCIA DE LOS CLIENTES Y PAGOS

/*************************************************************************
* TITULO DE LA FUNCION..: MESES DE ATRASO                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 26/94 LUN A
						       DIC 26/94 LUN

OBJETIVOS:

1- Debe estar en uso el archivo de clientes en el registro del estudiante

2- Retorna el estado de los retrasos de los pagos

* SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cAtrasos()

*>>>>DECLARACION DE VARIABLES
       LOCAL cAtraso := ''                  // Atrasos del estudiante
       LOCAL       i := 0                   // Contador
       LOCAL nMesMor := 0                   // Mes de mora
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE LOS MESES ATRASADOS
       cAtraso := SPACE(24)
       i := 1
       DO WHILE i <= LEN(CLI->cMespagCli)

	  IF SUBS(CLI->cMespagCli,i,1) = 'D'

	     nMesMor = i + 1
	     IF nMesMor < 10
		nMesMor := '0'+STR(nMesMor,1)
	     ELSE
		nMesMor := STR(nMesMor,2)
	     ENDIF
	   *ÀCorrecion automatica del mes de atraso

	     cAtraso := STUFF(cAtraso,i*2-1,2,nMesMor)
	    *Almacena el mes atrasado a facturar

	  ENDIF
	  i := i + 1
       ENDDO
       RETURN cAtraso
*>>>>FIN LECTURA DE LOS MESES ATRASADOS

/*************************************************************************
* TITULO DE LA FUNCION..: GRABACION DE LAS COPIAS EMITIDAS               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 26/94 LUN A
						       DIC 26/94 LUN
OBJETIVOS:

1- Debe estar en uso el archivo de clientes en el registro del estudiante

2- Incrementa el n£mero de copias impresas de un recibo

3- Retorna el N£mero de copias emitidas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cCopias(nMesIni)

*>>>>PARAMETROS DE LA FUNCION
/*     nMesIni                              // Mes inicial del pago */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cCopias := ''                  // Copias del recibo emitidas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>INCREMENTO DEL NUMERO DE COPIAS
       cCopias := VAL(SUBS(CLI->cNroCopCli,nMesIni*2-1,2))+1
       cCopias := TRANS(cCopias,"99")
       RETURN cCopias
*>>>>FIN INCREMENTO DEL NUMERO DE COPIAS

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION SI TIENE BECA                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 26/94 LUN A
						       DIC 26/94 LUN
OBJETIVOS:

1- Debe estar en uso el archivo de clientes en el registro del estudiante

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Retorna .T. si tiene beca

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lTieneBeca(nMesIni,nMesFin)

*>>>>PARAMETROS DE LA FUNCION
/*     nMesIni                              // Mes Inicial de pago
       nMesFin                              // Mes final de pago */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lTieBec := .F.                 // .T. = Tiene Beca
       LOCAL       i := 0                   // Contador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS SI EL ESTUDIANTE ESTA BECADO
       lTieBec := .F.
       IF CLI->nBecIniCli # 0 .AND. CLI->nBecFinCli # 0
	  FOR i := nMesIni TO nMesFin
	      IF i >= CLI->nBecIniCli .AND. i <= CLI->nBecFinCli
		 lTieBec := .T.
		 EXIT
	      ENDIF
	  NEXT
       ENDIF
       RETURN lTieBec
*>>>>FIN ANALISIS SI EL ESTUDIANTE ESTA BECADO

/*************************************************************************
* TITULO DE LA FUNCION..: NUMERO DE BECAS                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 26/94 LUN A
						       DIC 26/94 LUN
OBJETIVOS:

1- Debe estar en uso el archivo de clientes en el registro del estudiante

2- Retorna el n£mero de becas a descontar al estudiante

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nNroBecas(nMesIni,nMesFin)

*>>>>PARAMETROS DE LA FUNCION
/*     nMesIni                                // Mes Inicial del Pago
       nMesFin                                // Mes Final del pago */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIBLES
       LOCAL nBecas  := 0                     // N£mero de becas
       LOCAL nMesPag := nMesIni               // Mes de pago
*>>>>FIN DECLARACION DE VARIBLES

*>>>>CALCULO DEL NUMERO DE BECAS
       DO WHILE nMesPag <= nMesFin
	  IF nMesPag >= CLI->nBecIniCli .AND. nMesPag <= CLI->nBecFinCli
	     nBecas = nBecas + 1
	  ENDIF
	  nMesPag += 1
       ENDDO
       RETURN nBecas
*>>>>FIN CALCULO DEL NUMERO DE BECAS

/*************************************************************************
* TITULO DE LA FUNCION..: LOCALIZACION DEL CODIGO                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 15/94 VIE A
						       JUL 15/94 VIE
OBJETIVOS:

1- Debe estar en uso el archivo de Clientes

2- Verifica la existencia del c¢digo del cliente

3- Deja el archivo en el registro del cliente si este existe.

4- Retorna .T. si encontro el codigo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lLocCodCli(cCodCli,lMensaj)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodCli		                    // C¢digo del cliente
       lMensaj                              // .T. Mostrar mensaje de error*/
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lExiste := .T.                 // .T. = Existe el c¢digo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION DEL CODIGO
       lMensaj := IF(lMensaj == NIL,.T.,lMensaj)
       SELECT CLI
       GO TOP
       LOCATE FOR CLI->cCodigoEst == cCodCli
       IF .NOT. FOUND()
	  IF lMensaj
	     cError('EL CODIGO '+cCodCli+;
		    ' DEL ESTUDIANTE NO EXISTE EN EL GRUPO')
	  ENDIF
	  lExiste := .F.
       ENDIF
       RETURN lExiste
*>>>>FIN LOCALIZACION DEL CODIGO


/*************************************************************************
* TITULO DE LA FUNCION..: MANTENIMIENTO DEL ARCHIVO DE CLIENTES		 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 15/94 VIE A
						       JUL 15/94 VIE
OBJETIVOS:

1- Permite el mantenimiento del archivo Clientes

SINTAXIS:

MantenDes()

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenCli(aParam1,aParam2,aParam3,;
		   lModReg)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       lModReg                              // .T. Modificar Registros */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual
       LOCAL cNalias := ''                  // Alias del maestro

       LOCAL oBrwCli := NIL                 // Browse de Clientes
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTgr := ''               // Codigo del grupo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // Modo de Protecci¢n
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

       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cJorTxt := ''                  // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := 0                   // Fila Inferior Men£ principal
       LOCAL nFilInf := 0                   // Fila Inferior del SubMen£
       LOCAL nColInf := 0                   // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL PathW01 := ''                  // Sitio del Sistema No.01
     *ÀSitios del Sistema

       LOCAL aParams := {}                  // Parametros Generales
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>LECTURA PARAMETROS GENERALES
       aParams := aParams(aParam1,aParam2,aParam3)
       IF !lParam0104(aParams,;
		      @lShared,@nModCry,@cNomSis,;
		      @cEmpPal,@cNitEmp,@cNomEmp,@cNomSec,@cCodEmp,;
		      @cNomUsr,@cAnoUsr,@cAnoSis,@cPatSis,;
		      @nFilPal,@nFilInf,@nColInf,;
		      @PathW01,;
		      @cMaeAlu,@cMaeAct,@cJorTxt)
	  CloseAll()
	  RETURN NIL
       ENDIF
       CloseAll()
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>LECTURA DE PATHS
       PathCarAno(lShared,cPatSis,cAnoUsr,@cIntUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry)
     *ÀLectura de paths

       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       cNalias := cMaeAct
*>>>>FIN LECTURA DE PATHS

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,cIntUno,cMaeAct,cAnoSis,lAnoAct) .OR.;
	  !lUseGru(lShared,cIntUno,cMaeAct,cAnoSis,lAnoAct)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       SELECT &cNalias
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTE ESTUDIANTES GRABADOS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTE GRUPOS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LECTURA DEL GRUPO
       cCodigoTgr := cSpaces('GRU','cCodigoGru')
       IF !lLeeCodGru(nFilInf+1,nColInf,@cCodigoTgr,cMaeAct)
	  CloseAll()
	  RETURN NIL
       ENDIF
       CloseDbf('GRU')
*>>>>FIN LECTURA DEL GRUPO

*>>>>ANALISIS DE DECISION
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>SELECION DE LAS AREAS DE TRABAJO
       FileCli := cPatSis+'\CLIENTES\CL'+cCodigoTgr+cAnoSis+ExtFile
       IF !lUseDbf(.T.,FileCli,'CLI',NIL,lNoRed,nModCry)

	  cError('POSIBLEMENTE EL GRUPO NO EXISTE')

	  CloseDbf('CLI',FileCli,nModCry)
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       DO CASE
       CASE CLI->(RECCOUNT()) == 0
	    cError('NO EXISTEN CLIENTES','POR FAVOR VERIFIQUE')

	    CloseDbf('CLI',FileCli,nModCry)
	    CloseAll()
	    RETURN NIL
       ENDCASE
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>MANTENIMIENTO DEL ARCHIVO
       SELECT CLI
       oBrwCli := oDefBrwCli(lShared,nFilPal+1,00,22,79,;
			     cCodigoTgr,cNalias,lModReg)

       SETKEY(K_F5,{||BuscarCli(oBrwCli)})

       SETKEY(K_F9,{||MenuOtrCli(aParam1,aParam2,aParam3,;
				 oBrwCli,FileCli)})

       CLI->(CtrlBrw(lShared,oBrwCli))
       SETKEY(K_F5,NIL)

       CloseDbf('CLI',FileCli,nModCry)
       CloseAll()
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO DE LA FUNCION..: DEFINICION DEL OBJETO BROWSE DE CLIENTES	 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 15/94 VIE A
						       JUL 15/94 VIE
OBJETIVOS:

1- Define el objeto Browse del archivo Clientes

SINTAXIS:

 oBrwCli := oDefBrwCli(00,00,24,79,'94')

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwCli(lShared,nFilSup,nColSup,nFilInf,;
		    nColInf,cCodGru,cMaeAct,lModReg)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       cCodGru                              // C¢digo del Grupo
       cMaeAct			            // Maestro Actual
       lModReg                              // .T. Modificar Registros */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrwCli := NIL		    // Browse de Clientes
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrwCli := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrwCli:ColSep    := '³'
       oBrwCli:HeadSep   := 'Ä'
       oBrwCli:Cargo     := {'<<MANTENIMIENTO DE CLIENTES DEL GRUPO '+cCodGru+' >>',;
			    '<F5>Buscar  <ESC>Abandonar'}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       lModReg := IF(EMPTY(lModReg),.F.,lModReg)

       SELECT CLI
       oColumn	     := TBCOLUMNNEW('No', {||STR(CLI->(RECNO()),2)})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwCli:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO', {||CLI->cCodigoEst})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwCli:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRE DEL ESTUDIANTE',;
				   {||cSekNomAlu(CLI->cCodigoEst,;
						 cMaeAct,'CLI')})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwCli:ADDCOLUMN(oColumn)
*       oBrwCli:Freeze:= 3
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('PERTENECE',{||IF(CLI->lRetGruCli,;
				    'OTRO GRUPO','AL GRUPO  ')})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwCli:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('No.',{||CLI->nNroLisEst})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CLI'},;
			 {'FIELD','nNroLisEst'},{'PICTURE','999'}}
       oBrwCli:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('SALDO ACTUAL',{||CLI->nSdoActCli})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwCli:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR MORA',{||CLI->nSdoMorCli})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwCli:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('SALDO A¥O ANTERIOR',{||CLI->nSdoAnoCli})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CLI'},;
			 {'FIELD','nSdoAnoCli'}, {'PICTURE','9999999.99'}}
       oBrwCli:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MORA A¥O ANTERIOR',{||CLI->nMorAnoCli})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CLI'},;
			 {'FIELD','nMorAnoCli'}, {'PICTURE','9999999.99'}}
       oBrwCli:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('A¥O DEL SALDO',{||CLI->nAnoSdoCli})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CLI'},;
			 {'FIELD','nAnoSdoCli'}, {'PICTURE','9999'}}
       oBrwCli:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('A¥O DEL SALDO no',{||CLI->cAnoSdoCli})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CLI'},;
			 {'FIELD','cAnoSdoCli'}, {'PICTURE','9999'}}
       oBrwCli:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('SDOACT ABONO',{||CLI->nSdAbonCli})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwCli:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('MORA ABONO',{||CLI->nMoAbonCli})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwCli:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('SALDO A FAVOR',{||CLI->nSdoFavCli})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwCli:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

	oColumn	     := TBCOLUMNNEW('MESES PAGOS', {||CLI->cMesPagCli})
	IF lModReg
	   oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CLI'},;
			     {'FIELD','cMesPagCli'}, {'PICTURE','@X'}}
	ELSE
*	   oColumn:Cargo := {{'MODI',.F.}}
	   oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CLI'},;
			     {'FIELD','cMesPagCli'}, {'PICTURE','@X'}}
	ENDIF
       oBrwCli:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('COPIAS', {||CLI->cNroCopCli})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwCli:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

	oColumn	     := TBCOLUMNNEW('CONCEPTOS DEL SALDO', {||CLI->cConSdoCli})
	IF lModReg
	   oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CLI'},;
			     {'FIELD','cConSdoCli'}, {'PICTURE','@X'}}
	ELSE
*	   oColumn:Cargo := {{'MODI',.F.}}
	   oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CLI'},;
			     {'FIELD','cConSdoCli'}, {'PICTURE','@X'}}
	ENDIF
       oBrwCli:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

	oColumn	     := TBCOLUMNNEW('REPORTES', {||CLI->cHayRepCli})
	IF lModReg
	   oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CLI'},;
			     {'FIELD','CLI->cHayRepCli'}, {'PICTURE','@X'}}
	ELSE
	   oColumn:Cargo := {{'MODI',.F.}}
	ENDIF
       oBrwCli:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('INICIO BECA',;
				   {||IF(CLI->nBecIniCli == 0,;
				    CLI->nBecIniCli,cMes(CLI->nBecIniCli))})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwCli:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FINAL BECA',;
				   {||IF(CLI->nBecFinCli == 0,;
				   CLI->nBecFinCli,cMes(CLI->nBecFinCli))})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwCli:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('BECA%', {||CLI->nPorBecCli})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwCli:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('VALOR BECA', {||CLI->nVlrBecCli})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwCli:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOV. REC/DES', {||CLI->cHayNovCli})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrwCli:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FONDO', {||CLI->lFondosCli})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','CLI'},;
			{'FIELD','FONDOS_CLI'}, {'PICTURE','@!'}}
       oBrwCli:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrwCli
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION DEL REGISTRO DEL CLIENTE PARA I/O   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 15/94 VIE A
						       JUL 15/94 VIE
OBJETIVOS:

1- Debe estar en uso el archivo de Clientes

3- Verifica si se pueden hacer operaciones sobre el registro

4- Retorna el valor l¢gico de la Validaci¢n

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValRegCli()

*>>>>VALIDACION DEL REGISTRO
       LOCAL lHayErr := .F.
       IF CLI->lRetGruCli
	  cError('EL CLIENTE PERTENECE A OTRO GRUPO')
	  lHayErr := .T.
       ENDIF
       RETURN !lHayErr
*>>>>FIN VALIDACION DEL REGISTRO

/*************************************************************************
* TITULO DE LA FUNCION..: BUSCAR EL CODIGO DEL CLIENTE                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 15/94 VIE A
						       JUL 15/94 VIE
OBJETIVOS:

1- Debe estar en uso los archivos de Clientes

2- Busca el c¢digo del Cliente

3- Retorna NIL

SINTAXIS:

  BuscarCli(oBrwCli)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BuscarCli(oBrwCli)

*>>>>PARAMETROS DE LA FUNCION
/*     oBrwCli				    // Browse de Clientes */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nRegCli := 0                   // Registro de Tarifa
       LOCAL lBuscar := .F.                 // .T. Realizar la b£squeda
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTcl := ''               // Codigo del cliente
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA DEL CODIGO
       SET CURSOR ON

       cCodigoTcl := cSpaces('CLI','cCodigoEst')
       TitBuscar(LEN(cCodigoTcl),@nNroFil,@nNroCol)
       @ nNroFil,nNroCol GET cCodigoTcl PICT '999999' VALID ;
			 lValCodCli(ROW(),COL()-6,@cCodigoTcl)
       READ
*>>>>FIN CAPTURA DEL CODIGO

*>>>>VALIDACION DEL CODIGO
       DO CASE
       CASE VAL(cCodigoTcl) == 0

	    cError('PATRON DE BUSQUEDA NO ESPECIFICADO',;
		   'ADVERTENCIA')

       OTHERWISE
	    lBuscar := .T.
       ENDCASE
*>>>>FIN VALIDACION DEL CODIGO

*>>>>BUSQUEDA DEL CODIGO
       SELECT CLI
       IF lBuscar .AND. lLocCodCli(cCodigoTcl)
	  nRegCli := RECNO()
	  GO TOP
	  oBrwCli:GOTOP()
	  GO nRegCli
	  oBrwCli:FORCESTABLE()
       ELSE
	  oBrwCli:GOTOP()
       ENDIF
       RETURN NIL
*>>>>FIN BUSQUEDA DEL CODIGO

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION DEL CODIGO DEL CLIENTE              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 15/94 VIE A
						       JUL 15/94 VIE
OBJETIVOS:

1- Debe estar en uso el archivo de Clientes

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Valida la existencia del c¢digo del estudiante

4- Retorna el valor l¢gico

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValCodCli(nNroFil,nNroCol,cCodCli)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       cCodCli                              // C¢digo del Cliente */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO
       lCorrecion(@cCodCli)
       IF !EMPTY(cCodCli)
	  IF lLocCodCli(cCodCli)
	     IF lValRegCli()
		lHayErr := .T.
	     ENDIF
	  ENDIF
       ELSE
	  lHayErr := .T.
       ENDIF
       RETURN lHayErr
*>>>>FIN VALIDACION DEL CODIGO

/*************************************************************************
* TITULO..: COMPARACION DE ESTRUCTURA DE DATOS DE CLIENTES               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 06/2003 JUE A
       Colombia, Bucaramanga        INICIO: 05:30 PM   MAR 06/2003 JUE

OBJETIVOS:

1- Permite comparar dos estructuras de datos para verificar si son iguales

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/


FUNCTION IguaStrCli(lShared,nModCry,PathArc,cAnoUsr,ExtFile)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc                              // Path del Archivo
       cAnoUsr                              // A¤o del Usuario
       ExtFile                              // Extencion del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del Sistema

       LOCAL FileCli := ''                  // Archivo de Clientes
       LOCAL FileBak := ''                  // Archivo de Temporal

       LOCAL aStrNew := {'1'}               // Estructura del Archivo Nuevo
       LOCAL aStrOld := {'1'}               // Estructura del Archivo Anterior
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE LAS ESTRUCTURAS
       SELECT GRU
       GRU->(DBGOTOP())
       DO WHILE .NOT. GRU->(EOF())

**********PREPARACION DE LAS VARIABLES DE ARCHIVO
	    FileCli := PathArc+'\CLIENTES\CL'+;
			       GRU->cCodigoGru+cAnoSis+'.DBF'

	    FileBak := PathArc+'\CLIENTES\BACKUPS\CL'+;
			       GRU->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
	       !lUseDbf(.T.,FileBak,'BAK',NIL,lShared,nModCry)

	       cError('ABRIENDO DE CLIENTES')
	       lHayErr := .T.
	       EXIT
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('Registro No. '+ALLTRIM(STR(GRU->(RECNO())),9)+'/'+;
					ALLTRIM(STR(GRU->(RECCOUNT())),9),'')
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********ANALISIS DE LA PROTECION DE LA BASE DE DATOS
	    IF nModCry # 0

*--------------DESPROTECION DE LA BASE DE DATOS
		 IF nHayProtec(FileBak) == 1  // 1=>Protegida
		    IF !lProtecDbf(FileBak,'#DBFNTX&')
		       IF cError('El archivo '+FileBak+' No Se puede Accesar')
			  lHayErr := .T.
			  EXIT
		       ENDIF
		    ENDIF
		 ENDIF
*--------------FIN DESPROTECION DE LA BASE DE DATOS

	    ENDIF
**********FIN ANALISIS DE LA PROTECION DE LA BASE DE DATOS

**********COMPARACION DE ESTRUCTURAS
	    aStrNew := CLI->(DBSTRUCT())
	    aStrOld := BAK->(DBSTRUCT())
	    IF .NOT. lgualStr(aStrNew,aStrOld,FileCli)
	       lHayErr := .T.
	       EXIT
	    ENDIF
**********FIN COMPARACION DE ESTRUCTURAS

	  GRU->(DBSKIP())

       ENDDO
       CloseDbf('CLI',FileCli,nModCry)
       CloseDbf('BAK',FileBak,nModCry)
       RETURN !lHayErr
*>>>>FIN VALIDACION DE LAS ESTRUCTURAS

/*************************************************************************
* TITULO..: SELECCION TIPO DE LA MORA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 28/2003 VIE A
       Bucaramanga, Colombia        INICIO: 04:30 PM   MAR 28/2003 VIE

OBJETIVOS:

1)- Retorna por referencia los param‚tros de la funci¢n marcados con @

2)- Permite activar el nivel de estudios Jardin, Primaria o Bachillerato

3)- Retorna las tres iniciales del nivel de estudios

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cSelTipMor(nNroFil,nNroCol,cDesMor)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // N£mero de la fila
       nNroCol                              // N£mero de la columna
       cDesMor                              // @Descripci¢n de la Mora */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL aMenus  := {}                  // Declaracion de Menus
       LOCAL nNroOpc := 1                   // N£mero de Opci¢n
       LOCAL cTipMor := ''                  // Tipos de Mora
*>>>>FIN DECLARACION DE VARIABLES

*>>>>INICIALIZACION DE LOS TIPOS DE MORA
       AADD(aMenus,'MORA DE UN MES     ')
       AADD(aMenus,'MORA DE DOS MESES  ')
       AADD(aMenus,'MORA DE TRES MESES ')
       AADD(aMenus,'MORA DE 4 A 6 MESES')
       AADD(aMenus,'MORA > A 6 MESES   ')
       cTipMor := 'CDEFG'
*>>>>FIN INICIALIZACION DE LOS TIPOS DE MORA

*>>>>SELECCION DEL TIPO DE MORA
       cSavPan := SAVESCREEN(0,0,24,79)
       DO WHILE .T.

	  nNroOpc := nMenu(aMenus,NIL,nNroFil,nNroCol,'MORA DE:',NIL,1,.F.)
	  IF nNroOpc <> 0
	     EXIT
	  ENDIF

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
       cDesMor := aMenus[nNroOpc]
       RETURN SUBS(cTipMor,nNroOpc,1)
*>>>>FIN SELECCION DEL TIPO DE MORA

/*************************************************************************
* TITULO..: MENU DEL ESTADO DE CUENTA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 29/2003 LUN A
       Colombia, Bucaramanga        INICIO: 01:00 PM   SEP 29/2003 LUN

OBJETIVOS:

1- Menu del Estado de Cuenta

2- Retorna Nil


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuEstCta(lShared,nModCry,cNomSis,cNomEmp,cNomUsr,cAnoUsr,;
		    cPatSis,cMaeAct,cJorTxt,cCodEst,cNomEst,cCodGru,;
		    oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cNomEmp                              // Nombre de la Empresa
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del Sistema
       cMaeAct                              // Maestro Actual
       cJorTxt                              // Jornada escogida
       cCodEst                              // C¢digo del Estudiante
       cAnoUsr                              // A¤o del Usuario
       oBrowse                              // Del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

       LOCAL aPagCon := {}                  // Conceptos pagodos

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARCION Y EJECUCION DEL MENU
       AADD(aMenus,'1<CERTIFICADO DE PAGOS >')
*       AADD(aMenus,'2<CERTIFICADO DESCRIMINADO>')
       AADD(aMenus,'2<SIMULACION DEL ESTADO>')
       AADD(aMenus,'3<FORMATO CERTIFICADO  >')
       AADD(aMenus,'4<CONCEPTOS EN MORA    >')
       AADD(aMenus,'5<CONCEPTOS FACTURADOS >')

       AADD(aAyuda,'Permite Imprimir el Certificado de Pagos')
*       AADD(aAyuda,'Permite Imprimir el Certificado de Pagos Descriminado')
       AADD(aAyuda,'Permite Imprimir la Simulaci¢n del Estado de Cuenta')
       AADD(aAyuda,'Permite Crear o Editar el Formato del Certificado')
       AADD(aAyuda,'Consulta los conceptos en mora')
       AADD(aAyuda,'Consulta los conceptos facturados')

       IF LEN(aMenus) == 1
	  nNroOpc := 1
       ELSE
	  cSavPan := SAVESCREEN(0,0,24,79)
	  nNroOpc := nMenu(aMenus,aAyuda,10,25,NIL,NIL,1,.F.)
	  RESTSCREEN(0,0,24,79,cSavPan)
	  IF nNroOpc == 0
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>ANALISIS DE OPCION ESCOGIDA
       DO CASE
       CASE nNroOpc == 1
	    CertCar01(lShared,cAnoUsr,cNomUsr,cMaeAct,cJorTxt,;
		       cCodEst,cPatSis,cCodGru,cPatSis+'\'+fNtxDes)
	   *Impresi¢n del Certificado

/*
       CASE nNroOpc == 2
	    CertCar02(lShared,cAnoUsr,cNomUsr,cMaeAct,cJorTxt,;
		       cCodEst,cCodGru,cPatSis+'\'+fNtxDes)
	   *Impresi¢n del Certificado Descriminado
*/

       CASE nNroOpc == 2
	    lValEstCta(lShared,nModCry,cNomSis,cNomEmp,;
		       cNomUsr,cAnoUsr,cPatSis,cCodEst,;
		       cNomEst,cCodGru,SCA->lPrnArcCar,;
		       SCA->cOpcPrnCar,oBrowse)
	   *Simulaci¢n del Estado.

       CASE nNroOpc == 3
	    FormCerti(cNomSis)
	   *Formato del Certificado

       CASE nNroOpc == 4
	    cSavPan := SAVESCREEN(0,0,24,79)
	    IF EMPTY(CLI->cConSdoCli)
	       cError('NO EXISTEN CONCEPTOS EN MORA')
	    ELSE
	       cError(ALLTRIM(CLI->cConSdoCli),'CONCEPTOS EN MORA')
	    ENDIF
	    RESTSCREEN(0,0,24,79,cSavPan)

       CASE nNroOpc == 5
	    cSavPan := SAVESCREEN(0,0,24,79)
	    VisConPago(2,PAG->cCodigoEst)
	    RESTSCREEN(0,0,24,79,cSavPan)
	  *ÀConsultar conceptos pagados

       ENDCASE
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: CERTIFICADO DE PAGO                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 29/2003 LUN A
       Colombia, Bucaramanga        INICIO: 01:30 PM   SEP 29/2003 LUN

OBJETIVOS:

1- Impresi¢n de los conceptos del a¤o.

2- Retorna Nil


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lPrnConAno(cNomUsr,cAnoUsr,cPatSis,cCodEst,cCodGru,fDesNtx,nMarIzq)

*>>>>DESCRIPCION DE PARAMETROS
/*     cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del Usuario
       cPatSis                              // Path del Sistema
       cCodEst                              // C¢digo del Estudiante
       cCodGru                              // C¢digo del Grupo
       fDesNtx                              // Archivo Indice del Descuento
       nMarIzq                              // Margen Izquierdo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"              // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lErrHay := .F.                 // .T. Hay Error
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del Sistema

       LOCAL cIntCaf := ''                  // Path Integraci¢n del restaurante
       LOCAL cIntRut := ''                  // Path Integraci¢n del rutas


       LOCAL       i := 0                   // Contador
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n

       LOCAL nRegCli := 0                   // Registro de Clientes
       LOCAL nRegPag := 0                   // Registro de Pagos
       LOCAL aVlrCon := {}                  // Valor Por Conceptos
       LOCAL nVlrPag := 0                   // Valor del Pago
       LOCAL lSiCert := .T.                 // .T. Certificado
       LOCAL lSiPaso := .F.                 // Control de flujo

       LOCAL lShared := .T.
       LOCAL nModCry := 0
*>>>>FIN DECLARACION DE VARIABLES

*>>>>TARIFAS DE LAS MATRICULAS
       IF !EMPTY(CAA->cConMatCaA)
	  VlrTarMtr(CAA->cConMatCaA,cCodGru,aVlrCon,lSiCert)
       ENDIF
*>>>>FIN TARIFAS DE LAS MATRICULAS

*>>>>CONCEPTOS DE LA CARTERA
       nRegCli := CLI->(RECNO())
       nRegPag := PAG->(RECNO())

       lLocCodigo('cCodigoEst','PAG',cCodEst)
       lHayErr := !lVlrConAno(aVlrCon,lSiCert,fDesNtx)
*>>>>FIN CONCEPTOS DE LA CARTERA


*>>>>CONCEPTOS DEL RESTAURANTE
       cIntCaf := ALLTRIM(CAA->cIntCafCaA)
       IF !EMPTY(cIntCaf)

	  cIntCaf := ALLTRIM(CAA->cIntCafCaA)+'\simacart'

	  lSiPaso := .T.

**********PREPARACION DE LAS VARIABLES DE ARCHIVO
	    FileCli := cIntCaf+'\'+cPatSis+'\CLIENTES\CL'+;
		       cCodGru+cAnoSis+ExtFile

	    FilePag := cIntCaf+'\'+cPatSis+'\PAGOS\PA'+;
		       cCodGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
	       !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry) .OR.;
	       !lUseDbf(.T.,cIntCaf+'\'+cPatSis+'\'+FileTar,'TAR',NIL,lShared,nModCry) .OR.;
	       !lUseDbf(.T.,cIntCaf+'\'+cPatSis+'\'+FileDes,'DES',NIL,lShared,nModCry)

	       lErrHay := .T.

	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********LOCALIZACION DEL CLIENTE
	    IF !lErrHay
	       IF lLocCodigo('cCodigoEst','CLI',cCodEst)

		  lLocCodigo('cCodigoEst','PAG',cCodEst)
		  lHayErr := !lVlrConAno(aVlrCon,lSiCert,fDesNtx)

	       ENDIF
	    ENDIF
**********FIN LOCALIZACION DEL CLIENTE

       ENDIF
*>>>>CONCEPTOS DEL RESTAURANTE

*>>>>CONCEPTOS DE RUTAS
       cIntRut := ALLTRIM(CAA->cIntRutCaA)
       IF !EMPTY(cIntRut)

	  cIntRut := ALLTRIM(CAA->cIntRutCaA)+'\simacart'

	  lSiPaso := .T.

**********PREPARACION DE LAS VARIABLES DE ARCHIVO
	    FileCli := cIntRut+'\'+cPatSis+'\CLIENTES\CL'+;
		       cCodGru+cAnoSis+ExtFile

	    FilePag := cIntRut+'\'+cPatSis+'\PAGOS\PA'+;
		       cCodGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
	       !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry) .OR.;
	       !lUseDbf(.T.,cIntRut+'\'+cPatSis+'\'+FileTar,'TAR',NIL,lShared,nModCry) .OR.;
	       !lUseDbf(.T.,cIntRut+'\'+cPatSis+'\'+FileDes,'DES',NIL,lShared,nModCry)

	       lErrHay := .T.

	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********LOCALIZACION DEL CLIENTE
	    IF !lErrHay
	       IF lLocCodigo('cCodigoEst','CLI',cCodEst)

		  lLocCodigo('cCodigoEst','PAG',cCodEst)
		  lHayErr := !lVlrConAno(aVlrCon,lSiCert,fDesNtx)

	       ENDIF
	    ENDIF
**********FIN LOCALIZACION DEL CLIENTE

       ENDIF
*>>>>FIN CONCEPTOS DE RUTAS

*>>>>PREPARACION DE LAS VARIABLES DE ARCHIVO
       IF lSiPaso

	  FileCli := cPatSis+'\CLIENTES\CL'+;
		     cCodGru+cAnoSis+ExtFile

	  FilePag := cPatSis+'\PAGOS\PA'+;
		     cCodGru+cAnoSis+ExtFile

       ENDIF
*>>>>FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF lSiPaso
	  IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
	     !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry) .OR.;
	     !lUseDbf(.T.,cPatSis+'\'+FileTar,'TAR',NIL,lShared,nModCry) .OR.;
	     !lUseDbf(.T.,cPatSis+'\'+FileDes,'DES',NIL,lShared,nModCry)
	     RETURN NIL
	  ENDIF
       ENDIF
       CLI->(DBGOTO(nRegCli))
       PAG->(DBGOTO(nRegPag))
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>IMPRESION DEL CERTIFICADO
       nMarIzq := IF(nMarIzq==NIL,01,nMarIzq)
       FOR i:=1 TO LEN(aVlrCon)
	   @ PROW()+1,nMarIzq SAY aVlrCon[i,2]+'=>'+;
			      TRANS(aVlrCon[i,3],'$999,999,999')

       ENDFOR
       @ PROW()+1,nMarIzq SAY SPACE(18)+REPL('=',12)
       @ PROW()+1,nMarIzq SAY SPACE(18)+TRANS(nSuma(aVlrCon,3),'$999,999,999')
       RETURN !lHayErr
*>>>>FIN IMPRESION DEL CERTIFICADO

/*************************************************************************
* TITULO..: CERTIFICADOS DEL ESTUDIANTE                                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 15/99 VIE A
       Colombia, Bucaramanga        INICIO: 11:30 AM   OCT 15/99 VIE

OBJETIVOS:

1- Permite imprimir los certificados por a¤os.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CertCar01(lShared,cAnoUsr,cNomUsr,cMaeAct,;
		   cJorTxt,cCodEst,cPatSis,cCodGru,;
		   fNtxDes)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // Archivos Compartidos
       cAnoUsr                              // A¤o del Usuario
       cNomUsr                              // Nombre del Usuario
       cMaeAct                              // Maestro Actual
       cJorTxt                              // Jornada escogida
       cCodEst                              // C¢digo del Estudiante
       cPatSis                              // Path del Sistema
       cCodGru                              // C¢digo del Grupo
       fNtxDes                              // Indice de Descuentos
       nMarIzq                              // Margen Izquierdo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL FilePrn := ''                  // Archivo de Impresi¢n
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n

       LOCAL       i := 0                   // Contador
       LOCAL nNroFil := 0                   // N£mero de Fila
       LOCAL nNroCol := 0                   // N£mero de Columna
       LOCAL cUsoCer := ''                  // Uso del Certificado
       LOCAL nCopias := 1                   // N£meros de copias a imprimir
       LOCAL nNroCop := 1                   // N£mero de copia
       LOCAL nLenLin := 0                   // Longitud de la l¡nea
       LOCAL nNroFrm := 1                   // N£mero del Formato
       LOCAL cNroFrm := ''                  // N£mero del Formato

       LOCAL bPagos  := NIL                 // Code Block de Pagos
       LOCAL aMezcla := {}                  // Mezcla de Texto
       LOCAL nNroCar := 1                   // N£mero de la Carta
       LOCAL bTarifa := NIL                 // Code Block de Tarifas

       LOCAL cDocNit := ''                  // Documento del Contratante
       LOCAL cTipNit := ''                  // Tipo del Documento del Contrante
       LOCAL cLugNit := ''                  // Lugar del documento
       LOCAL nTipPer := 0                   // Tipo persona
       LOCAL cNombre := ''                  // Nombre
       LOCAL cNomCnt := ''                  // Nombres de Contratantes
       LOCAL cNomFia := ''                  // Nombres de los Fiadores

       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cConcepTes := ''               // C¢digo del Concepto
       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
       SET CURSOR ON
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DEL NUMERO DE LA CARTA MODELO
       cSavPan := SAVESCREEN(0,0,24,79)
       TitBuscar(18,@nNroFil,@nNroCol,'INGRESE EL No.','FORMATO MODELO')
       @ nNroFil,nNroCol GET nNroFrm PICT '999'
       READ
       IF EMPTY(nNroFrm)
	  RESTSCREEN(0,0,24,79,cSavPan)
	  RETURN NIL
       ENDIF
       cNroFrm := STR(nNroFrm,3)
       lCorrecion(@cNroFrm)
*>>>>FIN LECTURA DEL NUMERO DE LA CARTA MODELO

*>>>>LECTURA DE LA DESTINACION DEL CERTIFICADO
       cUsoCer := SPACE(70)
       TitBuscar(70,@nNroFil,@nNroCol,'CERTIFICADO PARA:',;
		 'USO DEL CERTIFICADO')

       SETCURSOR(1)
       @ nNroFil,nNroCol GET cUsoCer PICT '@S70!'
       READ
       cUsoCer := ALLTRIM(cUsoCer)
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN LECTURA DE LA DESTINACION DEL CERTIFICADO

*>>>>LECTURA DEL NUMERO DE COPIA
       TitBuscar(20,@nNroFil,@nNroCol,'COPIAS:','NUMERO DE COPIAS')
       @ nNroFil,nNroCol GET nCopias PICT '99'
       READ
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nCopias == 0
	  RETURN NIL
       ENDIF
       SETCURSOR(0)
*>>>>FIN LECTURA DEL NUMERO DE COPIA

*>>>>LECTURA DE LOS CONTRATANTES
       FOR i := 1 TO 4

	   cDocNit := &(cMaeAct+'->cNitCo'+STR(i,1)+'Est')
	   cTipNit := &(cMaeAct+'->cTipCo'+STR(i,1)+'Est')

	   IF !EMPTY(cDocNit)

	      nTipPer := nTipPerMae(cDocNit,;
				    &cMaeAct->cPadNitEst,;
				    &cMaeAct->cMadNitEst)
	      IF nTipPer == 3
		 lLocNitPer(cDocNit,cTipNit)
	      ENDIF

	      DO CASE
	      CASE nTipPer == 1                    // Padre

		   cNombre := ALLTRIM(&cMaeAct->cApePadEst)+' '+;
			      ALLTRIM(&cMaeAct->cNomPadEst)

		   cTipNit := &cMaeAct->cPadTntEst
		   cLugNit := &cMaeAct->cPadLugEst


	      CASE nTipPer == 2                    // Madre

		   cNombre := ALLTRIM(&cMaeAct->cApeMadEst)+' '+;
			      ALLTRIM(&cMaeAct->cNomMadEst)

		   cTipNit := &cMaeAct->cMadTntEst
		   cLugNit := &cMaeAct->cMadLugEst

	      CASE nTipPer == 3                    // Otra Persona

		   cNombre := cNomPer(PER->cApeUnoPer,;
				      PER->cApeDosPer,;
				      PER->cNomUnoPer,;
				      PER->cNomDosPer)

		   cLugNit := PER->cLugNitPer
		   cTipNit := cTipNitPer(PER->cTipNitPer)

	      ENDCASE

	      cDocNit := ALLTRIM(cDocNit)
	      cTipNit := ALLTRIM(cTipNit)
	      cLugNit := UPPER(ALLTRIM(cLugNit))
	      cNombre := ALLTRIM(cNombre)

	      IF i <= 2
		 cNomCnt += IF(EMPTY(cNomCnt),'',',')+;
			    cNombre+;
			    IF(EMPTY(cTipNit),'',' '+cTipNit)+;
			    IF(EMPTY(cDocNit),'',' No.'+cDocNit)+;
			    IF(EMPTY(cLugNit),'',' DE '+cLugNit)
	      ELSE
		 cNomFia += IF(EMPTY(cNomFia),'',',')+;
			    cNombre+;
			    IF(EMPTY(cTipNit),'',' '+cTipNit)+;
			    IF(EMPTY(cDocNit),'',' No.'+cDocNit)+;
			    IF(EMPTY(cLugNit),'',' DE '+cLugNit)
	      ENDIF

	   ENDIF

       ENDFOR
*>>>>FIN LECTURA DE LOS CONTRATANTES

*>>>>SUSTITUCION DE CAMPOS
       cNombreTes := RTRIM(&cMaeAct->cNombreEst)+' '+;
		     RTRIM(&cMaeAct->cApelliEst)
       cCodigoTgr := &cMaeAct->cCodigoGru
       cConcepTes := ALLTRIM(&cMaeAct->cConcepEst)

       bPagos := {||lPrnConAno(cNomUsr,cAnoUsr,cPatSis,cCodEst,cCodGru,fNtxDes,;
			       SCA->nIzqConCar)}

       bTarifa := {||PrnTarCar(ALLTRIM(CAA->cConPenCaA)+cConcepTes,;
			       cCodigoTgr,SCA->nIzqConCar)}

       aMezcla := {{'<TC>',PCL('Carta')},;
		   {'<TO>',PCL('Oficio')},;
		   {'<T1>',PCL('Pica')},;
		   {'<T2>',PCL('Elite')},;
		   {'<C1>',PCL('CondenOn')},;
		   {'<C0>',PCL('CondenOf')},;
		   {'<G1>',PCL('DobAncOn')},;
		   {'<G0>',PCL('DobAncOf')},;
		   {'<A¥O>',cAnoUsr},;
		   {'<JORNADA>',cJorTxt},;
		   {'<NROCER>',ALLTRIM(STR(SCO->nNroCerCon,16))},;
                   {'<CODIGO>',&cMaeAct->cCodigoEst},;
		   {'<NOMBRE>',cNombreTes},;
		   {'<GRADO>',cNomNiv(SUBS(&cMaeAct->cCodigoGru,1,2))},;
		   {'<NRODOC>',ALLTRIM(&cMaeAct->cDocNitEst)},;
		   {'<LUGDOC>',ALLTRIM(&cMaeAct->cLugNitEst)},;
		   {'<PAGOS>' ,bPagos},;
		   {'<TARIFAS>',bTarifa},;
		   {'<USO>',cUsoCer},;
		   {'<FECHA>',cFecha(DATE(),10)},;
		   {'<CONTRATANTES>',cNomCnt},;
		   {'<FIADORES>',cNomFia}}
*>>>>FIN SUSTITUCION DE CAMPOS

*>>>>ACTIVACION DE LA IMPRESORA
       IF SCA->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCA->cOpcPrnCar,.F.)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
       SendCodes(PCL('Reset'))
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>ESPECIFICACION DEL TAMA¥O DEL PAPEL
       nLenLin := IF(EMPTY(SCA->nMarDerCar),70,SCA->nMarDerCar)

       FOR i = 1 TO nCopias
	   @PROW()+1,00 SAY ''
	   PrnFileDoc("Bases\Certi"+cNroFrm+'.txt',;
		      aMezcla,nLenLin,SCA->nIzqTxtCar,1000)
       ENDFOR
*>>>>FIN ESPECIFICACION DEL TAMA¥O DEL PAPEL

*>>>>GRABACION DEL SECUENCIAL DEL CERTIFICADO
       IF SCO->(lRegLock(lShared,.F.))
	  REPL SCO->nNroCerCon WITH SCO->nNroCerCon+1
	  SCO->(DBCOMMIT())
       ENDIF
       IF lShared
	  SCO->(DBUNLOCK())
       ENDIF
       VerPrn(nOpcPrn,FilePrn)
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN GRABACION DEL SECUENCIAL DEL CERTIFICADO

/*************************************************************************
* TITULO..: CERTIFICADOS DEL ESTUDIANTE No. 2                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 05/2005 MAR A
       Colombia, Bucaramanga        INICIO: 11:00 AM   JUL 05/2005 MAR

OBJETIVOS:

1- Permite imprimir los certificados de los pagos descriminado por
   conceptos.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CertCar02(lShared,cAnoUsr,cNomUsr,cMaeAct,;
		   cJorTxt,cCodEst,cCodGru,fNtxDes)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // Archivos Compartidos
       cAnoUsr                              // A¤o del Usuario
       cNomUsr                              // Nombre del Usuario
       cMaeAct                              // Maestro Actual
       cJorTxt                              // Jornada escogida
       cCodEst                              // C¢digo del Estudiante
       cCodGru                              // C¢digo del Grupo
       fNtxDes                              // Indice de Descuentos
       nMarIzq                              // Margen Izquierdo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL FilePrn := ''                  // Archivo de Impresi¢n
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n

       LOCAL     i,j := 0                   // Contador
       LOCAL nNroFil := 0                   // N£mero de Fila
       LOCAL nNroCol := 0                   // N£mero de Columna
       LOCAL cUsoCer := ''                  // Uso del Certificado
       LOCAL nCopias := 1                   // N£meros de copias a imprimir
       LOCAL nNroCop := 1                   // N£mero de copia
       LOCAL nLenLin := 0                   // Longitud de la l¡nea
       LOCAL nNroFrm := 1                   // N£mero del Formato
       LOCAL cNroFrm := ''                  // N£mero del Formato

       LOCAL aMezcla := {}                  // Mezcla de Texto
       LOCAL nNroCar := 1                   // N£mero de la Carta

       LOCAL aVlrCon := {}                  // Valor de los Conceptos
       LOCAL lSiCert := .T.                 // .T. Certificado
       LOCAL cCodCon := ''                  // C¢digo de Conceptos
       LOCAL cNomCon := ''                  // Nombre del Concepto
       LOCAL nVlrCon := ''                  // Valor del Concepto

       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cConcepTes := ''               // C¢digo del Concepto
       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
       SET CURSOR ON
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DEL NUMERO DE LA CARTA MODELO
       cSavPan := SAVESCREEN(0,0,24,79)
       TitBuscar(18,@nNroFil,@nNroCol,'INGRESE EL No.','FORMATO MODELO')
       @ nNroFil,nNroCol GET nNroFrm PICT '999'
       READ
       IF EMPTY(nNroFrm)
	  RESTSCREEN(0,0,24,79,cSavPan)
	  RETURN NIL
       ENDIF
       cNroFrm := STR(nNroFrm,3)
       lCorrecion(@cNroFrm)
*>>>>FIN LECTURA DEL NUMERO DE LA CARTA MODELO

*>>>>DESCRIMINACION DE LOS CONCEPTOS
       IF !EMPTY(CAA->cConMatCaA)
	  VlrTarMtr(CAA->cConMatCaA,cCodGru,aVlrCon,lSiCert)
       ENDIF
       lVlrConAno(aVlrCon,lSiCert,fNtxDes)

       cCodCon := ''
       FOR i := 1 TO LEN(aVlrCon)
	   cCodCon += aVlrCon[i,1]
       ENDFOR

       IF EMPTY(cCodCon)
	  RESTSCREEN(0,0,24,79,cSavPan)
	  RETURN NIL
       ENDIF
*>>>>FIN DESCRIMINACION DE LOS CONCEPTOS

*>>>>SELECCION DE LOS CONCEPTOS
       TitBuscar(70,@nNroFil,@nNroCol,'CONCEPTOS A IMPRIMIR:',;
		 'CONCEPTOS DEL CERTIFICADO')

       SETCURSOR(1)
       @ nNroFil,nNroCol GET cCodCon PICT '@S70!';
			 VALID !lPar(LEN(ALLTRIM(cCodCon))/2)
       READ

       cCodCon := ALLTRIM(cCodCon)
       IF EMPTY(cCodCon)
	  RESTSCREEN(0,0,24,79,cSavPan)
	  RETURN NIL
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN SELECCION DE LOS CONCEPTOS

*>>>>LECTURA DE LA DESTINACION DEL CERTIFICADO
       cUsoCer := SPACE(70)
       TitBuscar(70,@nNroFil,@nNroCol,'CERTIFICADO PARA:',;
		 'USO DEL CERTIFICADO')

       SETCURSOR(1)
       @ nNroFil,nNroCol GET cUsoCer PICT '@S70!'
       READ
       cUsoCer := ALLTRIM(cUsoCer)
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN LECTURA DE LA DESTINACION DEL CERTIFICADO

*>>>>LECTURA DEL NUMERO DE COPIA
       TitBuscar(20,@nNroFil,@nNroCol,'COPIAS:','NUMERO DE COPIAS')
       @ nNroFil,nNroCol GET nCopias PICT '99'
       READ
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nCopias == 0
	  RETURN NIL
       ENDIF
       SETCURSOR(0)
*>>>>FIN LECTURA DEL NUMERO DE COPIA

*>>>>ACTIVACION DE LA IMPRESORA
       IF SCA->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCA->cOpcPrnCar,.F.)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
       SendCodes(PCL('Reset'))
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>NOMBRE DEL ESTUDIANTE
       cNombreTes := RTRIM(&cMaeAct->cNombreEst)+' '+;
		     RTRIM(&cMaeAct->cApelliEst)
*>>>>FIN NOMBRE DEL ESTUDIANTE

*>>>>IMPRESION DE LOS CERTIFICADOS
       FOR i := 1 TO LEN(aVlrCon)

*==========VALIDACION DEL CONCEPTO
	     IF !aVlrCon[i,1] $ cCodCon
		LOOP
	     ENDIF
*==========FIN VALIDACION DEL CONCEPTO

*==========SUSTITUCION DE CAMPOS
	     aMezcla := {{'<TC>',PCL('Carta')},;
			 {'<TO>',PCL('Oficio')},;
			 {'<T1>',PCL('Pica')},;
			 {'<T2>',PCL('Elite')},;
			 {'<C1>',PCL('CondenOn')},;
			 {'<C0>',PCL('CondenOf')},;
			 {'<G1>',PCL('DobAncOn')},;
			 {'<G0>',PCL('DobAncOf')},;
			 {'<A¥O>',cAnoUsr},;
			 {'<JORNADA>',cJorTxt},;
			 {'<NROCER>',ALLTRIM(STR(SCO->nNroCerCon,16))},;
			 {'<CODIGO>',&cMaeAct->cCodigoEst},;
			 {'<NOMBRE>',cNombreTes},;
			 {'<GRADO>',cNomNiv(SUBS(&cMaeAct->cCodigoGru,1,2))},;
			 {'<NRODOC>',ALLTRIM(&cMaeAct->cDocNitEst)},;
			 {'<LUGDOC>',ALLTRIM(&cMaeAct->cLugNitEst)},;
			 {'<CONCEPTO>' ,ALLTRIM(aVlrCon[i,2])},;
			 {'<VALOR>',TRANS(aVlrCon[i,3],'$999,999,999')},;
			 {'<USO>',cUsoCer},;
			 {'<FECHA>',cFecha(DATE(),10)}}
*==========FIN SUSTITUCION DE CAMPOS

*==========ESPECIFICACION DEL TAMA¥O DEL PAPEL
	     nLenLin := IF(EMPTY(SCA->nMarDerCar),70,SCA->nMarDerCar)

	     FOR j = 1 TO nCopias
		 @PROW()+1,00 SAY ''
		 PrnFileDoc("Bases\Certi"+cNroFrm+'.txt',;
			    aMezcla,nLenLin,SCA->nIzqTxtCar,1000)
	     ENDFOR
*==========FIN ESPECIFICACION DEL TAMA¥O DEL PAPEL

*==========GRABACION DEL SECUENCIAL DEL CERTIFICADO
	     IF SCO->(lRegLock(lShared,.F.))
		REPL SCO->nNroCerCon WITH SCO->nNroCerCon+1
		SCO->(DBCOMMIT())
	     ENDIF
	     IF lShared
		SCO->(DBUNLOCK())
	     ENDIF
*==========FIN GRABACION DEL SECUENCIAL DEL CERTIFICADO

       ENDFOR
       VerPrn(nOpcPrn,FilePrn)
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DE LOS CERTIFICADOS

/*************************************************************************
* TITULO ..: EDICION DEL FORMATO PARA EL CERTIFICADO                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 04/2003 VIE A
       Colombia, Bucaramanga        INICIO: 10:00 AM   OCT 04/2003 VIE

OBJETIVOS:

1- Permite Crear,modicar el modelo del formato para el certificado
   de la Cartera

2- Retorna Nil

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION FormCerti(cNomSis)

*>>>>DESCRIPCION DE PARAMETROS
/*     cNomSis                              // Nombre del Sistema */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla

       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL nNroCol := 0                   // N£mero de la Columna
       LOCAL nNroFrm := 1                   // N£mero del Formato
       LOCAL cNroFrm := ''                  // N£mero del Formato
       LOCAL cTxtHlp := ''                  // Texto de Ayuda */
       LOCAL cTitHlp := ''                  // T¡tulo para la Ayuda
       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DEL NUMERO DE LA CARTA MODELO
       cSavPan := SAVESCREEN(0,0,24,79)
       SET CURSOR ON
       TitBuscar(18,@nNroFil,@nNroCol,'INGRESE EL No.','FORMATO MODELO')
       @ nNroFil,nNroCol GET nNroFrm PICT '999'
       READ
       IF EMPTY(nNroFrm)
	  RESTSCREEN(0,0,24,79,cSavPan)
	  RETURN NIL
       ENDIF
       cNroFrm := STR(nNroFrm,3)
       lCorrecion(@cNroFrm)
*>>>>FIN LECTURA DEL NUMERO DE LA CARTA MODELO

*>>>>EDICION DE LA CARTA MODELO
       cTxtHlp :=   'Inserte el texto: <JORNADA> => '+;
		    'para incluir la Jornada de Estudio'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		    'Inserte el texto: <NROCER> => '+;
		    'para incluir el N£mero del Certificado'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		    'Inserte el texto: <A¥O> => '+;
		    'para incluir el A¤o del Certificado'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		    'Inserte el texto: <NOMBRE> => '+;
		    'para incluir el Nombre del Estudiante'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		    'Inserte el texto: <GRADO> => '+;
		    'para incluir el Nombre del Grado o Nivel '+;
		    'del Estudiante'+CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		    'Inserte el texto: <CODIGO> => '+;
		    'para incluir el C¢digo del Estudiante'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		    'Inserte el texto: <NRODOC> => '+;
		    'para incluir el N£mero del Documento del Estudiante'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		    'Inserte el texto: <LUGDOC> => '+;
		    'para incluir el Lugar del Documento del Estudiante'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		    'Inserte el texto: <PAGOS> => '+;
		    'para los conceptos cancelados por el Estudiante'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		    'Inserte el texto: <TARIFAS> => '+;
		    'para los valores de los conceptos a pagar por el Estudiante'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		    'Inserte el texto: <USO> => '+;
		    'para incluir la Uso del Certificado'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		    'Inserte el texto: <FECHA> => '+;
		    'para incluir la fecha actual'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: <JI>  => '+;
		    'para justificar el texto a la izquierda'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: <JD>  => '+;
		    'para justificar el texto a la derecha'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: <JC>  => '+;
		    'para centrar '+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: <JF>  => '+;
		    'para selecionar justificaci¢n completa'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: <T1>  => '+;
		    'Tama¤o de letra No. 1 : PICA(10cpi)'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: <T2>  => '+;
		    'Tama¤o de letra No. 2 : ELITE(12cpi)'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: <C1>  => '+;
		    'Activar imprisi¢n Condensado'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: <C0>  => '+;
		    'Desactivar impresi¢n Condensado'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: <TC>  => '+;
		    'para imprimir en tama¤o Carta'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: <TO>  => '+;
		    'para imprimir en tama¤o Oficio'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: <G1>  => '+;
		    'para imprimir el Texto en tama¤o Grande'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: <G0>  => '+;
		    'para Desactivar la impresi¢n en tama¤o Grande'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)

       cTitHlp := 'TEXTOS PARA LA SUSTITUCION'

       EditFile(cNomSis,"Bases\Certi"+cNroFrm+'.Txt',;
			 "Edite el Texto del Formato No. "+cNroFrm,;
			 cTxtHlp,cTitHlp)

       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN EDICION DE LA CARTA MODELO

/*************************************************************************
* TITULO..: CERTIFICADO DE TARIFAS                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 11/2004 LUN A
       Colombia, Bucaramanga        INICIO: 07:00 PM   MAR 11/2004 LUN

OBJETIVOS:

1- Impresi¢n de los conceptos de las tarifas.

2- Retorna Nil


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnTarCar(cConcep,cCodGru,nMarIzq)

*>>>>DESCRIPCION DE PARAMETROS
/*     nVlrDiv                              // Conceptos
       cCodGru                              // C¢digo del Grupo
       aVlrCon                              // @Valor de los Conceptos
       nMarIzq                              // Margen Izquierdo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL aVlrCon := {}                  // Valor de los Conceptos
       LOCAL lSiCert := .T.                 // .T. Certificado
*>>>>FIN DECLARACION DE VARIABLES

*>>>>TARIFAS DE LAS MATRICULAS
       IF !EMPTY(CAA->cConMatCaA)
	  VlrTarMtr(CAA->cConMatCaA,cCodGru,aVlrCon,lSiCert)
       ENDIF
*>>>>FIN TARIFAS DE LAS MATRICULAS

*>>>>IMPRESION DEL CERTIFICADO
       VlrTarCar(cConcep,cCodGru,aVlrCon,lSiCert)
       lPrnConCer(aVlrCon,nMarIzq)
       RETURN NIL
*>>>>FIN IMPRESION DEL CERTIFICADO


/*************************************************************************
* TITULO..: IMPRESION DE CONCEPTOS EN CERTIFICADOS                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 11/2004 LUN A
       Colombia, Bucaramanga        INICIO: 07:00 PM   MAR 11/2004 LUN

OBJETIVOS:

1- Impresi¢n de los conceptos de las tarifas.

2- Retorna Nil


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lPrnConCer(aVlrCon,nMarIzq)

*>>>>DESCRIPCION DE PARAMETROS
/*     aVlrCon                              // Valor de los Conceptos
       nMarIzq                              // Margen Izquierdo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE LOS CONCEPTOS CERTIFICADO
       nMarIzq := IF(nMarIzq==NIL,01,nMarIzq)
       FOR i:=1 TO LEN(aVlrCon)
	   @ PROW()+1,nMarIzq SAY aVlrCon[i,2]+'=>'+;
			      TRANS(aVlrCon[i,3],'$999,999,999')

       ENDFOR
       @ PROW()+1,nMarIzq SAY SPACE(18)+REPL('=',12)
       @ PROW()+1,nMarIzq SAY SPACE(18)+TRANS(nSuma(aVlrCon,3),'$999,999,999')
       RETURN NIL
*>>>>FIN IMPRESION DE LOS CONCEPTOS CERTIFICADO

/*************************************************************************
* TITULO..: MENU OTROS DEL ARCHIVO                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 05/2006 LUN A
       Colombia, Bucaramanga        INICIO: 05:30 AM   FEB 05/2006 LUN

OBJETIVOS:

1- Menu de informes para el archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuOtrCli(aParam1,aParam2,aParam3,;
		    oBrowse,FileCli)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       oBrowse                              // Browse del Archivo
       FileCli                              // Archivo de Clientes */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // Modo de Protecci¢n
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

       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cJorTxt := ''                  // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := 0                   // Fila Inferior Men£ principal
       LOCAL nFilInf := 0                   // Fila Inferior del SubMen£
       LOCAL nColInf := 0                   // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL PathW01 := ''                  // Sitio del Sistema No.01
     *ÀSitios del Sistema

       LOCAL aParams := {}                  // Parametros Generales
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>LECTURA PARAMETROS GENERALES
       aParams := aParams(aParam1,aParam2,aParam3)
       IF !lParam0104(aParams,;
		      @lShared,@nModCry,@cNomSis,;
		      @cEmpPal,@cNitEmp,@cNomEmp,@cNomSec,@cCodEmp,;
		      @cNomUsr,@cAnoUsr,@cAnoSis,@cPatSis,;
		      @nFilPal,@nFilInf,@nColInf,;
		      @PathW01,;
		      @cMaeAlu,@cMaeAct,@cJorTxt)
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>DECLARACION Y EJECUCION DEL MENU
       AADD(aMenus,'1<NUMERO DE LISTA     >')
       AADD(aMenus,'2<ORDENA POR LISTA    >')

       AADD(aAyuda,'Obtiene el N£mero de lista de los Estudiantes.')
       AADD(aAyuda,'Ordena el Archivo por N£mero de Lista')

       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,aAyuda,10,25,NIL,NIL,1,.F.)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nNroOpc == 0
	  RETURN NIL
       ENDIF
*>>>>FIN DECLARACION Y EJECUCION DEL MENU

*>>>>ANALISIS DE OPCION ESCOGIDA
       DO CASE
       CASE nNroOpc == 1
	    OtrCli01(aParam1,aParam2,aParam3,;
		     oBrowse,FileCli)
	  *Graba del archivo el n£mero de lista.

       CASE nNroOpc == 2

	    OrdenaCli(lShared,FileCli,oBrowse)
	  *ÀOrdenar Clientes

       ENDCASE
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: LECTURA DE LOS NUMEROS DE LISTA                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 05/2006 LUN A
       Colombia, Bucaramanga        INICIO: 05:35 PM   FEB 05/2006 LUN

OBJETIVOS:

1- Graba en el maestro los n£mero de lista.

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrCli01(aParam1,aParam2,aParam3,;
		  oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cSavPan := ''                  // Salvar Pantalla
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // Modo de Protecci¢n
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

       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cJorTxt := ''                  // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := 0                   // Fila Inferior Men£ principal
       LOCAL nFilInf := 0                   // Fila Inferior del SubMen£
       LOCAL nColInf := 0                   // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL PathW01 := ''                  // Sitio del Sistema No.01
     *ÀSitios del Sistema

       LOCAL aParams := {}                  // Parametros Generales
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>LECTURA PARAMETROS GENERALES
       aParams := aParams(aParam1,aParam2,aParam3)
       IF !lParam0104(aParams,;
		      @lShared,@nModCry,@cNomSis,;
		      @cEmpPal,@cNitEmp,@cNomEmp,@cNomSec,@cCodEmp,;
		      @cNomUsr,@cAnoUsr,@cAnoSis,@cPatSis,;
		      @nFilPal,@nFilInf,@nColInf,;
		      @PathW01,;
		      @cMaeAlu,@cMaeAct,@cJorTxt)
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>LECTURA DE LOS NUMEROS DE LISTA
       SELECT CLI
       CLI->(DBGOTOP())
       DO WHILE .NOT. CLI->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('ºREGISTRO No. '+CLI->(STR(RECNO(),2))+'/'+;
			 CLI->(STR(RECCOUNT(),2)),cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********GRABACION DEL NUMERO DE LISTA
	    SELECT CLI
	    IF lRegLock(lShared,.F.)

	       REPL CLI->nNroLisEst WITH CLI->(RECNO())
	      *Grabaci¢n del n£mero de lista.

	       CLI->(DBCOMMIT())
	    ELSE
	       cError('NO SE PUEDE GRABAR EL NUMERO DE LISTA')
	    ENDIF

	    IF lShared
	       CLI->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL NUMERO DE LISTA

	  SELECT CLI
	  CLI->(DBSKIP())

       ENDDO
       SELECT CLI
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN LECTURA DE LOS NUMEROS DE LISTA

/*************************************************************************
* TITULO..: ORDENAR EL ARCHIVO POR NUMERO DE LISTA                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 05/2006 LUN A
       Colombia, Bucaramanga        INICIO: 05:45 PM   FEB 05/2006 LUN


OBJETIVOS:

1- Ordena el archivo de alumnos por el n£mero de lista.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OrdenaCli(lShared,FileCli,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       FileCli                              // Archivo de Clientes
       oBrowse				    // Browse del Profesor */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CONTENIDO
       SELECT CLI
       IF RECCOUNT() == 0
	  cError('NO EXISTEN REGISTROS EN EL ARCHIVO')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>VALIDACION DEL NUMERO DE LISTA
       SELECT CLI
       CLI->(DBGOTOP())
       DO WHILE .NOT. CLI->(EOF())

**********ANALISIS DE DECISION
	    IF CLI->nNroLisEst == 0
	       cError('NO SE HAN ASIGNADO TODOS LOS NUMEROS DE LISTA')
	       lHayErr := .T.
	       EXIT
	    ENDIF
**********FIN ANALISIS DE DECISION

	  CLI->(DBSKIP())

       ENDDO
       IF lHayErr
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL NUMERO DE LISTA

*>>>>ANALISIS DE DECISION
       cError('DEBE HACER COPIA DE SEGURIDAD DEL DIRECTORIO CLIENTES')
       IF !lPregunta('ESTA SEGURO QUE DESEA ORDENAR? No Si')
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>ORDENACION DEL ARCHIVO
       CloseDbf('CLI')
       IF !lOrdFile(lShared,FileCli,'nNroLisEst')
	  cError('NO SE ORDENO EL ARCHIVO DE CLIENTES')
       ENDIF
*>>>>FIN ORDENACION DEL ARCHIVO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO DE CLIENTES')
	  RETURN NIL
       ENDIF
       SELECT CLI
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO


/*************************************************************************
* TITULO..: CONSULTA VALOR CONCEPTOS                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 05/2006 LUN A
       Colombia, Bucaramanga        INICIO: 05:45 PM   FEB 05/2006 LUN


OBJETIVOS:

1- Permite consultar el vector aVlrCon con fines de depuraci¢n.


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION WaitVlrCon(aVlrCon)

*>>>>DESCRIPCION DE PARAMETROS
/*     aVlrCon                              // Valor de los Conceptos */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL i := 0                         // Contador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CONSULTA
       FOR i:=1 TO LEN(aVlrCon)
	   wait  aVlrCon[i,2]+'=>'+TRANS(aVlrCon[i,3],'$999,999,999')
       ENDFOR
       RETURN NIL
*>>>>FIN CONSULTA