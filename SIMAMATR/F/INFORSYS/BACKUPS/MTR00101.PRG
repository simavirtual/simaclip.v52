/*************************************************************************
* TITULO ..: FORMULARIO DE SOLICITUD DE CUPO No. 01                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 10/2007 LUN A
       Colombia, Bucaramanga        INICIO: 12:00 AM   SEP 10/2007 LUN

OBJETIVOS:

1- Imprime el formulario de la solicitud de cupo No. 01

2- Este formulario es el por defecto del sistema.

3- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Mtr_001_01(cCodigo,cCodNiv,cNombre,cApelli,lExAlum,;
		    cNomSis,cNomEmp,cAnoUsr,lRapido,cObsUno,;
		    cObsDos,cObsTre,cJorTxt,cObsInc,;
		    aMarInf,cCodIso,aTitIso,aPieIso,aObsIso)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodigo                              // C¢digo de la Solicitud
       cCodNiv			            // C¢digo del Nivel
       cNombre                              // Nombres del aspirante
       cApelli                              // Apellidos del aspirante
       lExAlum                              // .T. Ex-Alumno
       cNomSis                              // Nombre del Sistema
       cNomEmp                              // Nombre de la Empresa
       cAnoUsr                              // A¤o del usuario
       lRapido                              // .T. Impresi¢n r pida
       cObsUno                              // Primera Observaci¢n
       cObsDos                              // Segunda Observaci¢n
       cObsTre                              // Tercera Observaci¢n
       cJorTxt                              // Jornada escogida
       cObsInc                              // Observaci¢n de la Inscripci¢n
       aMarInf			            // Margenes del informe
       cCodIso                              // C¢digo Iso del Informe
       aTitIso                              // T¡tulo Iso del Informe
       aPieIso      		            // Textos del pie de p gina
       aObsIso                              // Observaciones del informe */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nLenPrn := 0                   // Longitud de impresi¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS SI EL CANDIDATO ESTA RETIRADO
       IF ADM->lRetiroAdm
	  cError(ALLTRIM(ADM->cApelliEst)+' '+ALLTRIM(ADM->cNombreEst)+;
		 ' ESTA RETIRADO')
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS SI EL CANDIDATO ESTA RETIRADO

*>>>>ACTIVACION DE LA IMPRESORA
       cSavPan := SAVESCREEN(0,0,24,79)
       Termometro(0,"IMPRIMIENDO LA INSCRIPCION")
       Termometro(50)

       DO WHILE !Printer_on(MTR->lPrnArcMtr); ENDDO

       SendCodes(PCL({'Reset','Carta',;
		      'GraphiOn','CondenOf','ProporOf','DraftOn'}))

       lRapido := IF(lRapido == NIL,.T.,lRapido)
       IF !lRapido
	  SendCodes(PCL({'NegraOn','DobGolOn'}))
       ENDIF
       nLenPrn := PCL('n12Stan')
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>ENCABEZADO DEL FORMULARIO
       SendCodes(PCL('Elite'))
       SendCodes(PCL({'DobAncOn','DobAltOn'}))
       cTxtPrn := 'SOLICITUD DE CUPO NUMERO: '+cCodigo
       @ PROW()+aMarInf[1,1],((nLenPrn/2)-LEN(cTxtPrn))/2 SAY cTxtPrn
       SendCodes(PCL({'DobAncOf','DobAltOf','Elite'}))

       cTxtPrn := 'NIVEL '+cNomNiv(cCodNiv)+' '+cAnoUsr+'. JORNADA: '+cJorTxt
       @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn
*>>>>FIN ENCABEZADO DEL FORMULARIO

*>>>>CODIGO ISO DEL FORMULARIO
       IF !EMPTY(cCodIso)
	  SendCodes(PCL({'CondenOn'}))
	  @ PROW()+1,02 SAY cCodIso
	  SendCodes(PCL({'CondenOf','Elite'}))
	  @ PROW()+1,01 SAY 'FECHA DE SOLICITUD: '+ALLTRIM(cFecha(DATE()))
       ELSE
	  @ PROW()+2,01 SAY 'FECHA DE SOLICITUD: '+ALLTRIM(cFecha(DATE()))
       ENDIF
*>>>>FIN CODIGO ISO DEL FORMULARIO

*>>>>DETALLES FAMILIARES
       @ PROW(),42 SAY 'SEXO: M__ F__'+SPACE(04)+;
		       'GRUPO RH:____'+SPACE(04)+;
		       'ESTRATO No: __'

       @ PROW()+1,01 SAY 'NOMBRE: '+RTRIM(cApelli)+' '+cNombre+' '

       @ PROW()+1,01 SAY ''
       ForPrnEst()
       LineaPrn({'EPS:',REPL('_',85)})

       @ PROW()+1,01 SAY ''
       ForPrnPad()
       LineaPrn({'FAX:'    ,REPL('_',23),;
		 'CELULAR:',REPL('_',22),;
		 'BIPPER:' ,REPL('_',21)})

       @ PROW()+1,01 SAY ''
       ForPrnMad()
       LineaPrn({'FAX:'    ,REPL('_',23),;
		 'CELULAR:',REPL('_',22),;
		 'BIPPER:' ,REPL('_',21)})

       @ PROW()+1,01 SAY ''
       ForPrnAcu()
       LineaPrn({'FAX:'    ,REPL('_',23),;
		 'CELULAR:',REPL('_',22),;
		 'BIPPER:' ,REPL('_',21)})
*>>>>FIN DETALLES FAMILIARES

*>>>>COLEGIO DE PROCEDENCIA
       LineaPrn({'COLEGIO DE PROCEDENCIA' ,REPL('_',36),;
		 'CIUDAD'                 ,REPL('_',23)},2)
*>>>>FIN COLEGIO DE PROCEDENCIA

*>>>>FAMILIARES EN EL COLEGIO
       @ PROW()+1,01 SAY 'SI TIENE ACTUALMENTE ALGUN(OS) FAMILIAR(ES) EN '+;
			 'EL COLEGIO, NOMBRELO(S):'

       LineaPrn({'1. NOMBRE:',REPL('_',33),;
		     'CURSO:',REPL('_',10),;
		 'PARENTESCO',REPL('_',16)})

       LineaPrn({'2. NOMBRE:',REPL('_',33),;
		 'CURSO:'    ,REPL('_',10),;
		 'PARENTESCO',REPL('_',16)})
*>>>>FIN FAMILIARES EN EL COLEGIO

*>>>>OBSERVACIONES
       IF EMPTY(cObsInc)
	  LineaPrn({'OBSERVACIONES: ',REPL('_',74)},2)
       ELSE
	  @ PROW()+2,00 SAY 'OBSERVACIONES: '
	  SendCodes(PCL('CondenOn'))
	  @ PROW(),25 SAY cObsInc
	  SendCodes(PCL('CondenOf'))
       ENDIF
       @ PROW()+1,01 SAY REPL('_',90)
       @ PROW()+1,01 SAY REPL('_',90)
*>>>>FIN OBSERVACIONES

*>>>>OBSERVACIONES ISO
       IF !EMPTY(aObsIso[1]+aObsIso[2]+aObsIso[3])
	  SendCodes(PCL({'NegraOf','CondenOn'}))
	  @ PROW()+2,01 SAY aObsIso[1]
	  @ PROW()+1,01 SAY aObsIso[2]
	  @ PROW()+1,01 SAY aObsIso[3]
       ENDIF
       EJECT
       SET DEVICE TO SCREEN
       Termometro(100)
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN OBSERVACIONES ISO

/*************************************************************************
* TITULO ..: FORMATO DE CAPTURA DEL ESTUDIANTE                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 19/2007 MIE A
       Colombia, Bucaramanga        INICIO: 11:00 AM   SEP 19/2007 MIE

OBJETIVOS:

1- Imprime la parte del formato para la captura de la informaci¢n
   del acudiente.

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ForPrnEst(nNroFor)

*>>>>DESCRIPCION DE PARAMETROS
/*     nNroFor                              // N£mero de formato */
*>>>>FIN DESCRIPCION DE PARAMETROS

 *>>>>DECLARACION DE VARIABLES
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DETALLES DEL FORMATO
       nNroFor := IF(nNroFor == NIL,1,nNroFor)
       DO CASE
       CASE nNroFor == 1

	    aTitulo := {'NACIDO EN:',REPL('_',30),REPL('_',30),;
			'EL',REPL('_',04),REPL('_',04),REPL('_',04)}

	    aTamCol := {LEN(aTitulo[1]),LEN(aTitulo[2]),;
			LEN(aTitulo[3]),LEN(aTitulo[4]),;
			LEN(aTitulo[5]),LEN(aTitulo[6]),;
			LEN(aTitulo[7])}
	    cRegPrint(aTitulo,aTamCol,aNroCol)

	    @ PROW()+1,aNroCol[1] SAY aTitulo[1]
	    @ PROW(),  aNroCol[2] SAY aTitulo[2]
	    @ PROW(),  aNroCol[3] SAY aTitulo[3]
	    @ PROW(),  aNroCol[4] SAY aTitulo[4]
	    @ PROW(),  aNroCol[5] SAY aTitulo[5]
	    @ PROW(),  aNroCol[6] SAY aTitulo[6]
	    @ PROW(),  aNroCol[7] SAY aTitulo[7]

	    @ PROW()+1,aNroCol[2]+11 SAY 'CIUDAD'
	    @ PROW(),  aNroCol[3]+07 SAY 'DEPARTAMENTO'
	    @ PROW(),  aNroCol[5]    SAY 'MES'
	    @ PROW(),  aNroCol[6]    SAY 'DIA'
	    @ PROW(),  aNroCol[7]    SAY 'A¥O'

	    LineaPrn({'DOCUMENTO: ',REPL('_',30),;
				   'TIPO' ,REPL('_',04),;
				   'DE' ,REPL('_',34)})

	    LineaPrn({'DIRECCION:',REPL('_',49),;
			 'BARRIO:',REPL('_',21)})

	    LineaPrn({'CIUDAD:',REPL('_',20),;
		      'TEL:'   ,REPL('_',10),;
		      'CEL:'   ,REPL('_',10),;
		      'E-MAIL:',REPL('_',21)})

       ENDCASE
       RETURN NIL
*>>>>FIN DETALLES DEL FORMATO

/*************************************************************************
* TITULO ..: FORMATO DE CAPTURA DEL PADRE                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 19/2007 MIE A
       Colombia, Bucaramanga        INICIO: 10:00 AM   SEP 19/2007 MIE

OBJETIVOS:

1- Imprime la parte del formato para la captura de la informaci¢n
   del padre.

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ForPrnPad(nNroFor)

*>>>>DESCRIPCION DE PARAMETROS
/*     nNroFor                              // N£mero de formato */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DETALLES DEL FORMATO
       nNroFor := IF(nNroFor == NIL,1,nNroFor)
       DO CASE
       CASE nNroFor == 1

	    LineaPrn({'APELLIDOS PADRE:',REPL('_',30),;
			'NOMBRES PADRE:',REPL('_',27)})

	    LineaPrn({'DOCUMENTO:',REPL('_',21),;
		      'TIPO:',REPL('_',04),;
		      'DE:',REPL('_',23),;
		      'TEL:',REPL('_',13)})

	    LineaPrn({'EMPRESA:'        ,REPL('_',25),;
		      'CARGO:'          ,REPL('_',24),;
		      'TIEMPO SERVICIO:',REPL('_',06)},1)

	    LineaPrn({'DIRECCION:',REPL('_',49),;
			 'BARRIO:',REPL('_',21)})

	    LineaPrn({'CIUDAD:',REPL('_',20),;
		      'PROFESION:',REPL('_',20),;
		      'E-MAIL:',REPL('_',21)})
       ENDCASE
       RETURN NIL
*>>>>FIN DETALLES DEL FORMATO

/*************************************************************************
* TITULO ..: FORMATO DE CAPTURA DE LA MADRE                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 19/2007 MIE A
       Colombia, Bucaramanga        INICIO: 10:30 AM   SEP 19/2007 MIE

OBJETIVOS:

1- Imprime la parte del formato para la captura de la informaci¢n
   de la madre

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ForPrnMad(nNroFor)

*>>>>DESCRIPCION DE PARAMETROS
/*     nNroFor                              // N£mero de formato */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DETALLES DEL FORMATO
       nNroFor := IF(nNroFor == NIL,1,nNroFor)
       DO CASE
       CASE nNroFor == 1

	    LineaPrn({'APELLIDOS MADRE:',REPL('_',30),;
			'NOMBRES MADRE:',REPL('_',27)})

	    LineaPrn({'DOCUMENTO:',REPL('_',21),;
		      'TIPO:',REPL('_',04),;
		      'DE:',REPL('_',23),;
		      'TEL:',REPL('_',13)})

	    LineaPrn({'EMPRESA:'        ,REPL('_',25),;
		      'CARGO:'          ,REPL('_',24),;
		      'TIEMPO SERVICIO:',REPL('_',06)},1)

	    LineaPrn({'DIRECCION:',REPL('_',49),;
			 'BARRIO:',REPL('_',21)})

	    LineaPrn({   'CIUDAD:',REPL('_',20),;
		      'PROFESION:',REPL('_',20),;
			 'E-MAIL:',REPL('_',21)})

       ENDCASE
       RETURN NIL
*>>>>FIN DETALLES DEL FORMATO

/*************************************************************************
* TITULO ..: FORMATO DE CAPTURA DEL ACUDIENTE                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 19/2007 MIE A
       Colombia, Bucaramanga        INICIO: 10:45 AM   SEP 19/2007 MIE

OBJETIVOS:

1- Imprime la parte del formato para la captura de la informaci¢n
   del acudiente.

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ForPrnAcu(nNroFor)

*>>>>DESCRIPCION DE PARAMETROS
/*     nNroFor                              // N£mero de formato */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DETALLES DEL FORMATO
       nNroFor := IF(nNroFor == NIL,1,nNroFor)
       DO CASE
       CASE nNroFor == 1

	    LineaPrn({'APELLIDOS ACUDIENTE:',REPL('_',26),;
			'NOMBRES ACUDIENTE:',REPL('_',23)})

	    LineaPrn({'DOCUMEMTO:' ,REPL('_',19),;
		      'TIPO'       ,REPL('_',04),;
		      'DE:'        ,REPL('_',19),;
		      'PARENTESCO:',REPL('_',13)})

	    LineaPrn({'EMPRESA:'        ,REPL('_',25),;
		      'CARGO:'          ,REPL('_',24),;
		      'TIEMPO SERVICIO:',REPL('_',06)},1)

	    LineaPrn({'DIRECCION:',REPL('_',28),;
			 'BARRIO:',REPL('_',18),;
		       'TEL CASA:',REPL('_',13)})

	    LineaPrn({'CIUDAD:',REPL('_',20),;
		     'TEL OFI:',REPL('_',16),;
		      'E-MAIL:',REPL('_',27)})
       ENDCASE
       RETURN NIL
*>>>>FIN DETALLES DEL FORMATO







