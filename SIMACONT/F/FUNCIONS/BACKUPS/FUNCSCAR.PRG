/*                  SISTEMA CONTABILIDAD ACADEMICA
	  BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO DE CARGAS

REQUERIMIENTOS:

- Compilar: clipper FuncsCar /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo cargas

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DE LA FUNCION..: CREACION DE LA ESTRUCTURA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 10/95 MAR A
       Colombia, Bucaramanga        INICIO: 02:25 PM   OCT 10/95 MAR

OBJETIVOS:

1)- Crea la estructura del archivo

2)- Retorna NIL

SINTAXIS:

   CreaDbfCar(PathCar,FileCar,fNtxCar)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfCar(PathCar,FileCar,fNtxCar)

*>>>>PARAMETROS DE LA FUNCION
/*     PathCar				    // Path del Archivo
       FileCar				    // Nombre del Archivo
       fNtxCar				    // Archivo de Indices */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lShared := .T.                 // .T. Archivo Compartido
       LOCAL PathAct := ''                  // Path Actual

       LOCAL aDbfCar := {{"cCodigoPro","Character",06,0},;  // C¢digo del profesor
			 {"cCodigoCar","Character",08,0},;  // C¢digo de la Carga. Materia + Grupo
			 {"nTipCarCar","Numeric"  ,01,0},;  // Tipo de Carga. 0=>Normal 1=>Variable por Grupo 2=>Variable por Nivel 3=>Variable por Niveles
			 {"cIntHorPla","Character",02,0},;  // Intensidad Horaria
			 {"lAcademCar","Numeric"  ,01,0}}   // .T. Carga Acad‚mica
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathCar) == 0
	    DBCREATE(FileCar,aDbfCar,"DBFNTX")

       CASE DIRCHANGE(PathCar) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathCar)

       CASE DIRCHANGE(PathCar) == -5
	    cError('NO TIENE DERECHOS EN: '+PathCar)
       ENDCASE

       DIRCHANGE(PathAct)
       RETURN NIL
*>>>>FIN CREACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO DE LA FUNCION..: RECUPERACION DE LA ESTRUCTURA                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 10/95 MAR A
       Colombia, Bucaramanga        INICIO: 02:30 PM   OCT 10/95 MAR

OBJETIVOS:

1)- Recupera la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfCar(PathCar,FileCar,fNtxCar)

*>>>>PARAMETROS DE LA FUNCION
/*     PathCar			      // Path del Archivo
       FileCar			      // Nombre del Archivo
       fNtxCar			      // Archivo de Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathCar+'\'+FileCar,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")
       Termometro(0,"CREANDO LA ESTRUCTURA DE PROFESOR")
       Termometro(100)
       CreaDbfCar(PathCar,FileCar,fNtxCar)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO DEL PROGRAMA..: LOCALIZAR LA ASIGNACION DEL PROFESOR            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 01/2000 LUN A
       Colombia, Bucaramanga        INICIO: 01:10 PM   ENE 01/2000 LUN

OBJETIVOS:

1- Deben estar en uso el archivo de Asignaci¢n Acad‚mica.

2- Permite localizar el c¢digo de la asignaci¢n acad‚mica.

3- Retorna .T. si localizo el registro.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lLocCodCar(cCodCar,cCodPro)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodCar				      // C¢digo de la Carga Acad‚mica
       cCodPro                                // C¢digo del Profesor */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lExiste := .T.                 // .T. Existe el c¢digo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION DEL CODIGO
       SELECT CAR
       GO TOP
       LOCATE FOR CAR->cCodigoCar == cCodCar .AND.;
		  CAR->cCodigoPro == cCodPro
       IF .NOT. FOUND()
	  lExiste := .F.
       ENDIF
       RETURN lExiste
*>>>>FIN LOCALIZACION DEL CODIGO

/*************************************************************************
* TITULO..: VALIDACION DEL CODIGO                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 23/2002 MAR A
       Colombia, Bucaramanga        INICIO: 05:30 PM   ABR 23/2002 MAR

OBJETIVOS:

1- Debe estar en uso el archivo Bancos

2- Realiza la validaci¢n del c¢digo del Banco de acuerdo al nombre

3- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValCarga(nNroFil,nNroCol,cCodigo)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       cCodigo			            // C¢digo a Validar */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroReg := 0                   // N£mero del Registro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO
       IF !lLocCodigo('cCodigoCar','CAR',cCodigo)
	  nNroReg := nSelCarga(nNroFil,nNroCol)
	  IF nNroReg == 0
	     cCodigo := cSpaces('CAR','cCodigoCar')
	  ELSE
	     GO nNroReg
	     cCodigo := CAR->cCodigoCar
	  ENDIF
       ENDIF
       SELECT CAR
       SET FILTER TO
       RETURN .T.
*>>>>FIN VALIDACION DEL CODIGO

/*************************************************************************
* TITULO..: SELECCION DEL CODIGO                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 23/2002 MAR A
       Colombia, Bucaramanga        INICIO: 05:35 PM   ABR 23/2002 MAR

OBJETIVOS:

1- Debe estar en uso el archivo

2- Permite escoger el registro de acuerdo al c¢digo o descripci¢n

3- Retorna el n£mero del registro escogido

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nSelCarga(nNroFil,nNroCol)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // N£mero de la fila
       nNroCol                              // N£mero de la Columna */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nFilSup := 0                   // Fila superior
       LOCAL nColSup := 0                   // Colunma superior
       LOCAL nFilInf := 0                   // Fila inferior
       LOCAL nColInf := 0                   // Columna inferior
       LOCAL nNroReg := 0		    // Registro del Banco
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       IF CAR->(RECCOUNT()) == 0
	  cError('NO EXISTEN CARGAS GRABADAS')
	  RETURN 0
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>INICIALIZACION DE LAS COORDENADAS
	SELECT CAR
	nFilSup := nNroFil+1
	nColSup := nNroCol+2
	IF nFilSup+RECCOUNT() > 22
	   nFilInf := 22
	ELSE
	   nFilInf := nFilSup + RECCOUNT()
	ENDIF
	nColInf := nColSup+40
*>>>>FIN INICIALIZACION DE LAS COORDENADAS

*>>>>SELECCION DEL CODIGO
       CAR->(DBGOTOP())
       cSavPan := SAVESCREEN(0,0,24,79)
       @ nFilSup-1,nColSup-1 TO nFilInf,nColInf+1 DOUBLE
       nNroReg := nBrowseDbf(nFilSup,nColSup,nFilInf-1,nColInf,;
			     {||SUBS(CAR->cCodigoCar,5,4)+' '+;
				cSekNomMat(SUBS(CAR->cCodigoCar,1,4),'CAR')})
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN nNroReg
*>>>>FIN SELECCION DEL CODIGO

/*************************************************************************
* TITULO..: VALIDACION DE EXISTENCIA DEL CODIGO                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 23/2002 MAR A
       Colombia, Bucaramanga        INICIO: 05:40 PM   ABR 23/2002 MAR

OBJETIVOS:

1- Debe estar en uso el archivo.

2- Realiza la validaci¢n de existencia del C¢digo.

3- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValCodCar(cCodigo)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodigo			            // C¢digo a Validar */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO DEL BANCO
       IF cCodigo # cSpaces('CAR','cCodigoCar')
	  IF lLocCodigo('cCodigoCar','CAR',cCodigo)
	     cError('ESTE CODIGO YA EXISTE')
	     lHayErr := .T.
	  ENDIF
       ENDIF
       RETURN lHayErr
*>>>>FIN VALIDACION DEL CODIGO DEL BANCO

/*************************************************************************
* TITULO DEL PROGRAMA..: INTERVALO DE GRUPOS                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MIE 28/96 MIE A
       Colombia, Bucaramanga        INICIO: 04:25 PM   MIE 28/96 MIE

OBJETIVOS:

1- Debe estar en uso el archivo de Cargas del Profesor

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Permite selecionar un intervalo de materias

4- Retorna .T. si se ley¢ un intervalo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lIntervCaP(nNroFil,nNroCol,nRegIni,nRegFin)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // N£mero de la fila
       nNroCol                              // N£mero de la Columna
       nRegIni                              // @Registro Inicial
       nRegFin                              // @Registro Final */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL nFilSup := 0                   // Fila superior
       LOCAL nColSup := 0                   // Colunma superior
       LOCAL nFilInf := 0                   // Fila inferior
       LOCAL nColInf := 0                   // Columna inferior
       LOCAL nRegTem := 0                   // Registro temporal
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE ENCABEZADOS
       cMsgTxt ='CURSO INICIAL:'
       @ nNroFil  ,nNroCol SAY cMsgTxt
       @ nNroFil+1,nNroCol SAY 'CURSO FINAL  :'
*>>>>FIN IMPRESION DE ENCABEZADOS

*>>>>CAPTURA DEL INTERVALO INICIAL
	SELECT CAP
	nNroCol = nNroCol + LEN(cMsgTxt)
	nFilSup := nNroFil
	nColSup := nNroCol
	IF nFilSup+RECCOUNT() > 22
	   nFilInf := 21
	ELSE
	   nFilInf := nFilSup + RECCOUNT() - IF(RECCOUNT()>1,1,0)
	ENDIF
	nColInf := nColSup+LEN(CAP->cNombreMat)-17

	CAP->(DBGOTOP())
	nRegIni := nBrowseDbf(nFilSup,nColSup,nFilInf,nColInf,;
			      {||SUBS(CAP->cCodigoCar,5,4)+' '+Materia()})
	IF nRegIni == 0
	   RETURN .F.
	ENDIF
	CAP->(DBGOTO(nRegIni))
	@ nFilSup,nColSup SAY SUBS(CAP->cCodigoCar,5,4)+' '+Materia()
*>>>>FIN CAPTURA DEL INTERVALO INICIAL

*>>>>CAPTURA DEL INTERVALO FINAL
       CAP->(DBGOTOP())
       nRegFin := nBrowseDbf(nFilSup+1,nColSup,nFilInf,nColInf,;
			     {||SUBS(CAP->cCodigoCar,5,4)+' '+Materia()})
       IF nRegFin == 0
	  RETURN .F.
       ENDIF
       CAP->(DBGOTO(nRegFin))
       @ nFilSup+1,nColSup SAY SUBS(CAP->cCodigoCar,5,4)+' '+Materia()
*>>>>FIN CAPTURA DEL INTERVALO FINAL

*>>>>INTERCAMBIO DE REGISTROS
       IF nRegIni > nRegFin
	  nRegTem = nRegIni
	  nRegIni = nRegFin
	  nRegFin = nRegTem
       ENDIF
       RETURN .T.
*>>>>FIN INTERCAMBIO DE REGISTROS

FUNCTION Materia()
   SELECT MAT
   LOCATE FOR MAT->cCodigoMat == SUBS(CAP->cCodigoCar,1,4)
   SELECT CAP
RETURN SUBS(MAT->cNombreMat,1,80) // 20