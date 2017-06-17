/*                    SIMA - MATRICULA ACADEMICA
	    BIBLIOTECAS DE FUNCIONES PARA EL DISE¥O DE INSCRIPCIONES

REQUERIMIENTOS:

- Compilar: clipper fTipoAdm /w/m/b

OBJETIVOS:

- Funciones aplicadas para los diferentes formularios de inscripci¢n.


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO ..: FORMULARIO DE SOLICITUD DE CUPO No. 01                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 02/96 MAR A
       Colombia, Bucaramanga        INICIO: 02:00 PM   ENE 02/96 MAR

OBJETIVOS:

1- Imprime el formulario de la solicitud de cupo No. 01

2- Este formulario es el por defecto del sistema.


2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Solicitu01(cCodigo,cCodNiv,cNombre,cApelli,lExAlum,;
		    cNomSis,cNomEmp,cAnoUsr,lRapido,cObsUno,;
		    cObsDos,cObsTre,cJorTxt,cObsInc)

*>>>>PARAMETROS DE LA FUNCION
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
       cObsInc                              // Observaci¢n de la Inscripci¢n */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"
       #DEFINE  CARTA  CHR(27)+'C'+CHR(66) // P gina de 66 l¡neas

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

       @ PROW(),00 SAY INICIALIZA+CARTA+;
		       GRAPHI_ON+CONDEN_OF+PROPOR_OF+DRAFT_ON

       lRapido := IF(lRapido == NIL,.T.,lRapido)
       IF lRapido
	  @ PROW(),00 SAY ELITE
       ELSE
	  @ PROW(),00 SAY NEGRA_ON+DOBGOL_ON+ELITE
       ENDIF
       nLenPrn := n12Stan
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL FORMULARIO DE SOLICITUD DE CUPO
       @ PROW(),00 SAY DOBANC_ON+DOBALT_ON
       cTxtPrn := 'SOLICITUD DE CUPO NUMERO: '+cCodigo
       @ PROW()+9,((nLenPrn/2)-LEN(cTxtPrn))/2 SAY cTxtPrn
       @ PROW(),00 SAY DOBANC_OF+DOBALT_OF

       cTxtPrn := 'NIVEL '+cNomNiv(cCodNiv)+' '+cAnoUsr+'. JORNADA: '+cJorTxt
       @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn

       @ PROW()+2,01 SAY 'FECHA DE SOLICITUD: '+ALLTRIM(cFecha(DATE()))
       @ PROW()+1,01 SAY 'NOMBRE: '+RTRIM(cApelli)+' '+cNombre+' '+;
			 'SEXO: M__ F__'

       aTitulo := {'NACIDO EN:',REPL('_',30),REPL('_',30),;
		   'EL',REPL('_',04),;
		   REPL('_',04),REPL('_',04)}
       aTamCol := {LEN(aTitulo[1]),LEN(aTitulo[2]),;
		   LEN(aTitulo[3]),LEN(aTitulo[4]),;
		   LEN(aTitulo[5]),LEN(aTitulo[6]),;
		   LEN(aTitulo[7])}
       cRegPrint(aTitulo,aTamCol,aNroCol)
       @ PROW()+2,aNroCol[1] SAY aTitulo[1]
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

       LineaPrn({'IDENTIFICACION: ',REPL('_',04),;
		 'No' ,REPL('_',30),;
		 'DE' ,REPL('_',31)})
       LineaPrn({'DIRECCION:',REPL('_',49),'BARRIO:',REPL('_',21)})
       LineaPrn({'CIUDAD:',REPL('_',20),'TEL:',REPL('_',20),;
		 'E-MAIL:',REPL('_',27)})

       LineaPrn({'APELLIDOS PADRE:',REPL('_',30),;
		 'NOMBRES PADRE:',REPL('_',27)},2)
       LineaPrn({'IDENTIFICACION: ____ No.:',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'TEL:',REPL('_',13)})
       LineaPrn({'EMPRESA:',REPL('_',38),'CARGO:',REPL('_',35)},1)
       LineaPrn({'DIRECCION:',REPL('_',49),'BARRIO:',REPL('_',21)})
       LineaPrn({'CIUDAD:',REPL('_',20),'PROFESION:',REPL('_',20),;
		 'E-MAIL:',REPL('_',21)})

       LineaPrn({'APELLIDOS MADRE:',REPL('_',30),;
		 'NOMBRES MADRE:',REPL('_',27)},2)
       LineaPrn({'IDENTIFICACION: ____ No.:',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'TEL:',REPL('_',13)})
       LineaPrn({'EMPRESA:',REPL('_',38),'CARGO:',REPL('_',35)},1)
       LineaPrn({'DIRECCION:',REPL('_',49),'BARRIO:',REPL('_',21)})
       LineaPrn({'CIUDAD:',REPL('_',20),'PROFESION:',REPL('_',20),;
		 'E-MAIL:',REPL('_',21)})

       LineaPrn({'APELLIDOS ACUDIENTE:',REPL('_',26),;
		 'NOMBRES ACUDIENTE:',REPL('_',23)},2)
       LineaPrn({'IDENTI: ____ No.:',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'PARENTESCO:',REPL('_',14)})
       LineaPrn({'DIRECCION:',REPL('_',28),;
		 'BARRIO:',REPL('_',18),;
		 'TEL CASA:',REPL('_',13)})
       LineaPrn({'CIUDAD:',REPL('_',20),'TEL OFI:',REPL('_',16),;
		 'E-MAIL:',REPL('_',27)})

       LineaPrn({'COLEGIO DE PROCEDENCIA' ,REPL('_',36),;
		 'CIUDAD'                 ,REPL('_',23)},2)

       @ PROW()+1,01 SAY 'SI TIENE ACTUALMENTE ALGUN(OS) FAMILIAR(ES) EN '+;
			 'EL COLEGIO, NOMBRELO(S):'

       LineaPrn({'1. NOMBRE:',REPL('_',33),;
		 'CURSO:'    ,REPL('_',10),;
		 'PARENTESCO',REPL('_',16)})

       LineaPrn({'2. NOMBRE:',REPL('_',33),;
		 'CURSO:'    ,REPL('_',10),;
		 'PARENTESCO',REPL('_',16)})


       IF EMPTY(cObsInc)
	  LineaPrn({'OBSERVACIONES: ',REPL('_',74)},2)
       ELSE
	  @ PROW()+2,00 SAY 'OBSERVACIONES: '
	  @ PROW(),00 SAY CONDEN_ON
	  @ PROW(),25 SAY cObsInc
	  @ PROW(),00 SAY CONDEN_OF
       ENDIF
       @ PROW()+1,01 SAY REPL('_',90)
       @ PROW()+1,01 SAY REPL('_',90)

       LineaPrn({'MATRICULARSE EN FECHA ',REPL('_',49),;
		 'HORA'                  ,REPL('_',12)},2)
*>>>>FIN IMPRESION DEL FORMULARIO DE SOLICITUD DE CUPO

*>>>>IMPRESION DE LOS DERECHOS DE AUTOR
       cTxtPrn = ALLTRIM(UPPER(cNomSis))+'. '+;
		  'Instalado para: '+ALLTRIM(UPPER(cNomEmp))

       IF (n20Stan-LEN(cTxtPrn))/2 < 0
	  cError('LA COLUMNA ES NEGATIVA EN DerechosPrn')
       ENDIF

       @ PROW(),00 SAY CONDEN_ON
       @ PROW()+1,(n20Stan-LEN(cTxtPrn))/2 SAY cTxtPrn
       @ PROW(),00 SAY CONDEN_OF
       @ PROW()+1,01 SAY REPL('=',90)
*>>>>FIN IMPRESION DEL FORMULARIO DE SOLICITUD DE CUPO

*>>>>IMPRESION DE LA CITACION PARA EXAMEN
       cTxtPrn := 'CITACION No. '+cCodigo+;
		  ' PARA EL NIVEL '+cNomNiv(cCodNiv)
       @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn

       @ PROW()+2,01 SAY 'NOMBRE: '+RTRIM(cApelli)+' '+RTRIM(cNombre)

       LineaPrn({'DEBE PRESENTARSE EL DIA',REPL('_',49),;
		 'HORA',REPL('_',11)},1)

       @ PROW()+1,01 SAY 'OBSERVACIONES: '+REPL('_',74)
       @ PROW()+1,01 SAY REPL('_',90)
       @ PROW()+1,01 SAY REPL('_',90)

       IF !EMPTY(cObsUno+cObsDos+cObsTre)
	  @ PROW(),00   SAY NEGRA_OF+CONDEN_ON
	  @ PROW()+2,01 SAY 'NOTA: '+cObsUno
	  @ PROW()+1,01 SAY '      '+cObsDos
	  @ PROW()+1,01 SAY '      '+cObsTre
       ENDIF
       DerechosPrn(cNomSis,cNomEmp,n20Stan)
       EJECT
       SET DEVICE TO SCREEN
       Termometro(100)
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN IMPRESION DE LA CITACION PARA EXAMEN

/*************************************************************************
* TITULO ..: FORMULARIO DE SOLICITUD DE CUPO No. 02                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 02/99 LUN A
       Colombia, Bucaramanga        INICIO: 12:00 AM   AGO 02/99 LUN

OBJETIVOS:

1- Imprime el formulario de la solicitud de cupo No. 02

2- Formulario dise¤ado para el Virrey Solis en tama¤o oficio.

3- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Solicitu02(cCodigo,cCodNiv,cNombre,cApelli,lExAlum,;
		    cNomSis,cNomEmp,cAnoUsr,lRapido,cObsUno,;
		    cObsDos,cObsTre,cJorTxt,cObsInc)

*>>>>PARAMETROS DE LA FUNCION
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
       cObsInc                              // Observaci¢n de la Inscripci¢n */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
*      #INCLUDE "EPSONFX.PRG"
       #DEFINE  OFICIO CHR(27)+'C'+CHR(78) // P gina de 78 l¡neas

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

       @ PROW(),00 SAY INICIALIZA+OFICIO+;
		       GRAPHI_ON+CONDEN_OF+PROPOR_OF+DRAFT_ON

       lRapido := IF(lRapido == NIL,.T.,lRapido)
       IF lRapido
	  @ PROW(),00 SAY ELITE
       ELSE
	  @ PROW(),00 SAY NEGRA_ON+DOBGOL_ON+ELITE
       ENDIF
       nLenPrn := n12Stan
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL FORMULARIO DE SOLICITUD DE CUPO
       @ PROW(),00 SAY DOBANC_ON+DOBALT_ON
       cTxtPrn := 'SOLICITUD DE CUPO NUMERO: '+cCodigo
       @ PROW()+9,((nLenPrn/2)-LEN(cTxtPrn))/2 SAY cTxtPrn
       @ PROW(),00 SAY DOBANC_OF+DOBALT_OF

       cTxtPrn := 'NIVEL '+cNomNiv(cCodNiv)+' '+cAnoUsr+'. JORNADA: '+cJorTxt
       @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn

       @ PROW()+2,01 SAY 'FECHA DE SOLICITUD: '+ALLTRIM(cFecha(DATE()))
       @ PROW()+1,01 SAY 'NOMBRE: '+RTRIM(cApelli)+' '+cNombre+' '+;
			 'SEXO: M__ F__'


       aTitulo := {'NACIDO EN:',REPL('_',30),REPL('_',30),;
		   'EL',REPL('_',04),;
		   REPL('_',04),REPL('_',04)}
       aTamCol := {LEN(aTitulo[1]),LEN(aTitulo[2]),;
		   LEN(aTitulo[3]),LEN(aTitulo[4]),;
		   LEN(aTitulo[5]),LEN(aTitulo[6]),;
		   LEN(aTitulo[7])}
       cRegPrint(aTitulo,aTamCol,aNroCol)
       @ PROW()+2,aNroCol[1] SAY aTitulo[1]
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

       LineaPrn({'IDENTIFICACION: ',REPL('_',04),;
		 'No' ,REPL('_',30),;
		 'DE' ,REPL('_',31)})
       LineaPrn({'DIRECCION:',REPL('_',49),'BARRIO:',REPL('_',21)})
       LineaPrn({'CIUDAD:',REPL('_',20),'TEL:',REPL('_',20),;
		 'E-MAIL:',REPL('_',27)})

       LineaPrn({'APELLIDOS PADRE:',REPL('_',30),;
		 'NOMBRES PADRE:',REPL('_',27)},2)
       LineaPrn({'IDENTIFICACION: ____ No.:',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'TEL:',REPL('_',13)})
       LineaPrn({'EMPRESA:',REPL('_',38),'CARGO:',REPL('_',35)},1)
       LineaPrn({'DIRECCION:',REPL('_',49),'BARRIO:',REPL('_',21)})
       LineaPrn({'CIUDAD:',REPL('_',20),'PROFESION:',REPL('_',20),;
		 'E-MAIL:',REPL('_',21)})
       LineaPrn({'INGRESO MENSUAL: $',REPL('_',26)},1)

       LineaPrn({'APELLIDOS MADRE:',REPL('_',30),;
		 'NOMBRES MADRE:',REPL('_',27)},2)
       LineaPrn({'IDENTIFICACION: ____ No.:',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'TEL:',REPL('_',13)})
       LineaPrn({'EMPRESA:',REPL('_',38),'CARGO:',REPL('_',35)},1)
       LineaPrn({'DIRECCION:',REPL('_',49),'BARRIO:',REPL('_',21)})
       LineaPrn({'CIUDAD:',REPL('_',20),'PROFESION:',REPL('_',20),;
		 'E-MAIL:',REPL('_',21)})
       LineaPrn({'INGRESO MENSUAL: $',REPL('_',26)})

       LineaPrn({'APELLIDOS ACUDIENTE:',REPL('_',26),;
		 'NOMBRES ACUDIENTE:',REPL('_',23)},2)
       LineaPrn({'IDENTI: ____ No.:',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'PARENTESCO:',REPL('_',14)})
       LineaPrn({'DIRECCION:',REPL('_',28),;
		 'BARRIO:',REPL('_',18),;
		 'TEL CASA:',REPL('_',13)})
       LineaPrn({'CIUDAD:',REPL('_',20),'TEL OFI:',REPL('_',16),;
		 'E-MAIL:',REPL('_',27)})
       LineaPrn({'INGRESO MENSUAL: $',REPL('_',26)})

       LineaPrn({'COLEGIO DE PROCEDENCIA' ,REPL('_',36),;
		 'CIUDAD'                 ,REPL('_',23)},2)

       @ PROW()+2,01 SAY 'SI TIENE ACTUALMENTE ALGUN(OS) FAMILIAR(ES) EN '+;
			 'EL COLEGIO, NOMBRELO(S):'

       LineaPrn({'1. NOMBRE:',REPL('_',33),;
		 'CURSO:'    ,REPL('_',10),;
		 'PARENTESCO',REPL('_',16)})

       LineaPrn({'2. NOMBRE:',REPL('_',33),;
		 'CURSO:'    ,REPL('_',10),;
		 'PARENTESCO',REPL('_',16)})

       LineaPrn({'3. NOMBRE:',REPL('_',33),;
		 'CURSO:'    ,REPL('_',10),;
		 'PARENTESCO',REPL('_',16)})

       LineaPrn({'MADRE O PADRE EXALUMNOS: '+;
		 IF(lExAlum,'SI COLEGIO:'+REPL('_',29)+;
			    'CIUDAD'+REPL('_',16),'NO')},2)

       IF EMPTY(cObsInc)
	  LineaPrn({'OBSERVACIONES: ',REPL('_',74)},2)
       ELSE
	  @ PROW()+2,00 SAY 'OBSERVACIONES: '
	  @ PROW(),00 SAY CONDEN_ON
	  @ PROW(),25 SAY cObsInc
	  @ PROW(),00 SAY CONDEN_OF
       ENDIF
       @ PROW()+1,01 SAY REPL('_',90)
       @ PROW()+1,01 SAY REPL('_',90)
       @ PROW()+1,01 SAY REPL('_',90)

       LineaPrn({'MATRICULARSE EN FECHA ',REPL('_',49),;
		 'HORA'                  ,REPL('_',12)},2)
*>>>>FIN IMPRESION DEL FORMULARIO DE SOLICITUD DE CUPO

*>>>>IMPRESION DE LOS DERECHOS DE AUTOR
       cTxtPrn = ALLTRIM(UPPER(cNomSis))+'.'+;
		  'Instalado para: '+ALLTRIM(UPPER(cNomEmp))

       IF (n20Stan-LEN(cTxtPrn))/2 < 0
	  cError('LA COLUMNA ES NEGATIVA EN DerechosPrn')
       ENDIF

       @ PROW(),00 SAY CONDEN_ON
       @ PROW()+1,(n20Stan-LEN(cTxtPrn))/2 SAY cTxtPrn
       @ PROW(),00 SAY CONDEN_OF
       @ PROW()+1,01 SAY REPL('=',100)
*>>>>FIN IMPRESION DEL FORMULARIO DE SOLICITUD DE CUPO

*>>>>IMPRESION DE LA CITACION PARA EXAMEN
       cTxtPrn := 'CITACION No. '+cCodigo+;
		  ' PARA EL NIVEL '+cNomNiv(cCodNiv)
       @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn

       @ PROW()+2,01 SAY 'NOMBRE: '+RTRIM(cApelli)+' '+RTRIM(cNombre)

       LineaPrn({'DEBE PRESENTARSE EL DIA:','/'+REPL('_',04)+'/'+;
		 ' A PRUEBA DE ADMISION',SPACE(19)+'HORA:'+REPL('_',13)},2)

       LineaPrn({'ENTREVISTA: ',REPL('_',58),'HORA:',REPL('_',12)},2)
       @ PROW()+1,01 SAY REPL('_',90)
       @ PROW()+1,01 SAY REPL('_',90)
       @ PROW()+1,01 SAY REPL('_',90)

       IF !EMPTY(cObsUno+cObsDos+cObsTre)
	  @ PROW(),00   SAY NEGRA_OF+CONDEN_ON
	  @ PROW()+2,01 SAY 'NOTA: '+cObsUno
	  @ PROW()+1,01 SAY '      '+cObsDos
	  @ PROW()+1,01 SAY '      '+cObsTre
       ENDIF
       EJECT
       SET DEVICE TO SCREEN
       Termometro(100)
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN IMPRESION DE LA CITACION PARA EXAMEN

/*************************************************************************
* TITULO ..: FORMULARIO DE SOLICITUD DE CUPO No. 03                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 02/96 MAR A
       Colombia, Bucaramanga        INICIO: 02:00 PM   ENE 02/96 MAR

OBJETIVOS:

1- Imprime el formulario de la solicitud de cupo No. 03

2- Formulario dise¤ado para el Instituto San Bernardo y Colegio la Merced

3- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Solicitu03(cCodigo,cCodNiv,cNombre,cApelli,lExAlum,;
		    cNomSis,cNomEmp,cAnoUsr,lRapido,cObsUno,;
		    cObsDos,cObsTre,cJorTxt,cObsInc)

*>>>>PARAMETROS DE LA FUNCION
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
       cObsInc                              // Observaci¢n para la Inscripci¢n */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
*       #INCLUDE "EPSONFX.PRG"
*       #DEFINE  CARTA  CHR(27)+'C'+CHR(66) // P gina de 66 l¡neas

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

       @ PROW(),00 SAY INICIALIZA+CARTA+;
		       GRAPHI_ON+CONDEN_OF+PROPOR_OF+DRAFT_ON

       lRapido := IF(lRapido == NIL,.T.,lRapido)
       IF lRapido
	  @ PROW(),00 SAY ELITE
       ELSE
	  @ PROW(),00 SAY NEGRA_ON+DOBGOL_ON+ELITE
       ENDIF
       nLenPrn := n12Stan
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL FORMULARIO DE SOLICITUD DE CUPO
       @ PROW(),00 SAY DOBANC_ON+DOBALT_ON
       cTxtPrn := 'SOLICITUD DE CUPO NUMERO: '+cCodigo
       @ PROW()+9,((nLenPrn/2)-LEN(cTxtPrn))/2 SAY cTxtPrn
       @ PROW(),00 SAY DOBANC_OF+DOBALT_OF

       cTxtPrn := 'NIVEL '+cNomNiv(cCodNiv)+' '+cAnoUsr+'. JORNADA: '+cJorTxt
       @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn

       @ PROW()+2,01 SAY 'FECHA DE SOLICITUD: '+ALLTRIM(cFecha(DATE()))
       @ PROW()+1,01 SAY 'NOMBRE: '+RTRIM(cApelli)+' '+cNombre+' '+;
			 'SEXO: M__ F__'

       aTitulo := {'NACIDO EN:',REPL('_',30),REPL('_',30),;
		   'EL',REPL('_',04),;
		   REPL('_',04),REPL('_',04)}
       aTamCol := {LEN(aTitulo[1]),LEN(aTitulo[2]),;
		   LEN(aTitulo[3]),LEN(aTitulo[4]),;
		   LEN(aTitulo[5]),LEN(aTitulo[6]),;
		   LEN(aTitulo[7])}
       cRegPrint(aTitulo,aTamCol,aNroCol)
       @ PROW()+2,aNroCol[1] SAY aTitulo[1]
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

       LineaPrn({'IDENTIFICACION: ',REPL('_',04),;
		 'No' ,REPL('_',30),;
		 'DE' ,REPL('_',31)})
       LineaPrn({'DIRECCION:',REPL('_',49),'BARRIO:',REPL('_',21)})
       LineaPrn({'CIUDAD:',REPL('_',20),'TEL:',REPL('_',20),;
		 'E-MAIL:',REPL('_',27)})

       LineaPrn({'APELLIDOS PADRE:',REPL('_',30),;
		 'NOMBRES PADRE:',REPL('_',27)},2)
       LineaPrn({'IDENTIFICACION: ____ No.:',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'TEL:',REPL('_',13)})
       LineaPrn({'EMPRESA:',REPL('_',38),'CARGO:',REPL('_',35)},1)
       LineaPrn({'DIRECCION:',REPL('_',49),'BARRIO:',REPL('_',21)})
       LineaPrn({'CIUDAD:',REPL('_',20),'PROFESION:',REPL('_',20),;
		 'E-MAIL:',REPL('_',21)})

       LineaPrn({'APELLIDOS MADRE:',REPL('_',30),;
		 'NOMBRES MADRE:',REPL('_',27)},2)
       LineaPrn({'IDENTIFICACION: ____ No.:',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'TEL:',REPL('_',13)})
       LineaPrn({'EMPRESA:',REPL('_',38),'CARGO:',REPL('_',35)},1)
       LineaPrn({'DIRECCION:',REPL('_',49),'BARRIO:',REPL('_',21)})
       LineaPrn({'CIUDAD:',REPL('_',20),'PROFESION:',REPL('_',20),;
		 'E-MAIL:',REPL('_',21)})

       LineaPrn({'APELLIDOS ACUDIENTE:',REPL('_',26),;
		 'NOMBRES ACUDIENTE:',REPL('_',23)},2)
       LineaPrn({'IDENTI: ____ No.:',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'PARENTESCO:',REPL('_',14)})
       LineaPrn({'DIRECCION:',REPL('_',28),;
		 'BARRIO:',REPL('_',18),;
		 'TEL CASA:',REPL('_',13)})
       LineaPrn({'CIUDAD:',REPL('_',20),'TEL OFI:',REPL('_',16),;
		 'E-MAIL:',REPL('_',27)})

/*
       @ PROW()+2,01 SAY 'SI TIENE ACTUALMENTE ALGUN(OS) FAMILIAR(ES) EN '+;
			 'EL COLEGIO, NOMBRELO(S):'

       LineaPrn({'1. NOMBRE:',REPL('_',33),;
		 'CURSO:'    ,REPL('_',10),;
		 'PARENTESCO',REPL('_',16)})

       LineaPrn({'2. NOMBRE:',REPL('_',33),;
		 'CURSO:'    ,REPL('_',10),;
		 'PARENTESCO',REPL('_',16)})

       LineaPrn({'MADRE O PADRE EXALUMNOS: '+;
		 IF(lExAlum,'SI COLEGIO:'+REPL('_',29)+;
			    'CIUDAD'+REPL('_',16),'NO')},1) */

       LineaPrn({SPACE(35)+'COLEGIOS DE PROCEDENCIA'},1)
       LineaPrn({'PREESCOLAR:'},1)
       LineaPrn({'A¥O'        ,SPACE(02),'NIVEL'      ,SPACE(10),;
		 'INSTITUCION',SPACE(30),'CIUDAD'},1)
       LineaPrn({REPL('_',04),SPACE(01),REPL('_',15),SPACE(00),;
		 REPL('_',40),SPACE(01),REPL('_',23)},1)
       LineaPrn({'PRIMARIA:'},1)
       LineaPrn({REPL('_',04),SPACE(01),REPL('_',15),SPACE(00),;
		 REPL('_',40),SPACE(01),REPL('_',23)},1)
       LineaPrn({'BACHILLERATO:'},1)
       LineaPrn({REPL('_',04),SPACE(01),REPL('_',15),SPACE(00),;
		 REPL('_',40),SPACE(01),REPL('_',23)},1)
       LineaPrn({REPL('_',04),SPACE(01),REPL('_',15),SPACE(00),;
		 REPL('_',40),SPACE(01),REPL('_',23)},1)
       LineaPrn({REPL('_',04),SPACE(01),REPL('_',15),SPACE(00),;
		 REPL('_',40),SPACE(01),REPL('_',23)},1)
       LineaPrn({REPL('_',04),SPACE(01),REPL('_',15),SPACE(00),;
		 REPL('_',40),SPACE(01),REPL('_',23)},1)
       LineaPrn({REPL('_',04),SPACE(01),REPL('_',15),SPACE(00),;
		 REPL('_',40),SPACE(01),REPL('_',23)},1)
       LineaPrn({REPL('_',04),SPACE(01),REPL('_',15),SPACE(00),;
		 REPL('_',40),SPACE(01),REPL('_',23)},1)
       LineaPrn({REPL('_',04),SPACE(01),REPL('_',15),SPACE(00),;
		 REPL('_',40),SPACE(01),REPL('_',23)},1)

       IF EMPTY(cObsInc)
	  LineaPrn({'OBSERVACIONES: ',REPL('_',74)},2)
       ELSE
	  @ PROW()+2,00 SAY 'OBSERVACIONES: '
	  @ PROW(),00 SAY CONDEN_ON
	  @ PROW(),25 SAY cObsInc
	  @ PROW(),00 SAY CONDEN_OF
       ENDIF
       @ PROW()+1,01 SAY REPL('_',90)
       @ PROW()+1,01 SAY REPL('_',90)
*>>>>FIN IMPRESION DEL FORMULARIO DE SOLICITUD DE CUPO

*>>>>IMPRESION DE LA NOTA DE OBSERVACION
       IF !EMPTY(cObsUno+cObsDos+cObsTre)
	  @ PROW(),00   SAY NEGRA_OF+CONDEN_ON
	  @ PROW()+2,01 SAY 'NOTA: '+cObsUno
	  @ PROW()+1,01 SAY '      '+cObsDos
	  @ PROW()+1,01 SAY '      '+cObsTre
       ENDIF
       DerechosPrn(cNomSis,cNomEmp,n20Stan)
       EJECT
       SET DEVICE TO SCREEN
       Termometro(100)
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN IMPRESION DE LA NOTA DE OBSERVACION

/*************************************************************************
* TITULO ..: FORMULARIO DE SOLICITUD DE CUPO No. 04                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 02/96 MAR A
       Colombia, Bucaramanga        INICIO: 02:00 PM   ENE 02/96 MAR

OBJETIVOS:

1- Imprime el formulario de la solicitud de cupo No. 01

2- Este formulario es el por defecto del sistema.


2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Solicitu04(cCodigo,cCodNiv,cNombre,cApelli,lExAlum,;
		    cNomSis,cNomEmp,cAnoUsr,lRapido,cObsUno,;
		    cObsDos,cObsTre,cJorTxt,cObsInc)

*>>>>PARAMETROS DE LA FUNCION
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
       cObsInc                              // Observaci¢n de la Inscripci¢n */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
*       #INCLUDE "EPSONFX.PRG"
*       #DEFINE  CARTA  CHR(27)+'C'+CHR(66) // P gina de 66 l¡neas

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

       @ PROW(),00 SAY INICIALIZA+CARTA+;
		       GRAPHI_ON+CONDEN_OF+PROPOR_OF+DRAFT_ON

       lRapido := IF(lRapido == NIL,.T.,lRapido)
       IF lRapido
	  @ PROW(),00 SAY ELITE
       ELSE
	  @ PROW(),00 SAY NEGRA_ON+DOBGOL_ON+ELITE
       ENDIF
       nLenPrn := n12Stan
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL FORMULARIO DE SOLICITUD DE CUPO
       @ PROW(),00 SAY DOBANC_ON+DOBALT_ON
       cTxtPrn := 'SOLICITUD DE CUPO NUMERO: '+cCodigo
       @ PROW()+9,((nLenPrn/2)-LEN(cTxtPrn))/2 SAY cTxtPrn
       @ PROW(),00 SAY DOBANC_OF+DOBALT_OF

       cTxtPrn := 'NIVEL '+cNomNiv(cCodNiv)+' '+cAnoUsr+'. JORNADA: '+cJorTxt
       @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn

       @ PROW()+2,01 SAY 'FECHA DE SOLICITUD: '+ALLTRIM(cFecha(DATE()))
       @ PROW()+1,01 SAY 'NOMBRE: '+RTRIM(cApelli)+' '+cNombre+' '+;
			 'SEXO: M__ F__'

       aTitulo := {'NACIDO EN:',REPL('_',30),REPL('_',30),;
		   'EL',REPL('_',04),;
		   REPL('_',04),REPL('_',04)}
       aTamCol := {LEN(aTitulo[1]),LEN(aTitulo[2]),;
		   LEN(aTitulo[3]),LEN(aTitulo[4]),;
		   LEN(aTitulo[5]),LEN(aTitulo[6]),;
		   LEN(aTitulo[7])}
       cRegPrint(aTitulo,aTamCol,aNroCol)
       @ PROW()+2,aNroCol[1] SAY aTitulo[1]
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

       LineaPrn({'IDENTIFICACION: ',REPL('_',04),;
		 'No' ,REPL('_',30),;
		 'DE' ,REPL('_',31)})
       LineaPrn({'DIRECCION:',REPL('_',49),'BARRIO:',REPL('_',21)})
       LineaPrn({'CIUDAD:',REPL('_',20),'TEL:',REPL('_',20),;
		 'E-MAIL:',REPL('_',27)})

       LineaPrn({'APELLIDOS PADRE:',REPL('_',30),;
		 'NOMBRES PADRE:',REPL('_',27)},2)
       LineaPrn({'IDENTIFICACION: ____ No.:',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'TEL:',REPL('_',13)})
       LineaPrn({'EMPRESA:',REPL('_',38),'CARGO:',REPL('_',35)},1)
       LineaPrn({'DIRECCION:',REPL('_',49),'BARRIO:',REPL('_',21)})
       LineaPrn({'CIUDAD:',REPL('_',20),'PROFESION:',REPL('_',20),;
		 'E-MAIL:',REPL('_',21)})

       LineaPrn({'APELLIDOS MADRE:',REPL('_',30),;
		 'NOMBRES MADRE:',REPL('_',27)},2)
       LineaPrn({'IDENTIFICACION: ____ No.:',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'TEL:',REPL('_',13)})
       LineaPrn({'EMPRESA:',REPL('_',38),'CARGO:',REPL('_',35)},1)
       LineaPrn({'DIRECCION:',REPL('_',49),'BARRIO:',REPL('_',21)})
       LineaPrn({'CIUDAD:',REPL('_',20),'PROFESION:',REPL('_',20),;
		 'E-MAIL:',REPL('_',21)})

       LineaPrn({'APELLIDOS ACUDIENTE:',REPL('_',26),;
		 'NOMBRES ACUDIENTE:',REPL('_',23)},2)
       LineaPrn({'IDENTI: ____ No.:',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'PARENTESCO:',REPL('_',14)})
       LineaPrn({'DIRECCION:',REPL('_',28),;
		 'BARRIO:',REPL('_',18),;
		 'TEL CASA:',REPL('_',13)})
       LineaPrn({'CIUDAD:',REPL('_',20),'TEL OFI:',REPL('_',16),;
		 'E-MAIL:',REPL('_',27)})

       LineaPrn({'COLEGIO DE PROCEDENCIA' ,REPL('_',36),;
		 'CIUDAD'                 ,REPL('_',23)},2)

       @ PROW()+1,01 SAY 'SI TIENE ACTUALMENTE ALGUN(OS) FAMILIAR(ES) EN '+;
			 'EL COLEGIO, NOMBRELO(S):'

       LineaPrn({'1. NOMBRE:',REPL('_',33),;
		 'CURSO:'    ,REPL('_',10),;
		 'PARENTESCO',REPL('_',16)})

       LineaPrn({'2. NOMBRE:',REPL('_',33),;
		 'CURSO:'    ,REPL('_',10),;
		 'PARENTESCO',REPL('_',16)})


       IF EMPTY(cObsInc)
	  LineaPrn({'OBSERVACIONES: ',REPL('_',74)},2)
       ELSE
	  @ PROW()+2,00 SAY 'OBSERVACIONES: '
	  @ PROW(),00 SAY CONDEN_ON
	  @ PROW(),25 SAY cObsInc
	  @ PROW(),00 SAY CONDEN_OF
       ENDIF
       @ PROW()+1,01 SAY REPL('_',90)
       @ PROW()+1,01 SAY REPL('_',90)

       LineaPrn({'RECTOR(A):',REPL('_',26)+SPACE(02),;
		 'PSICOORIENTADOR(A):',REPL('_',30)},2)
*>>>>FIN IMPRESION DEL FORMULARIO DE SOLICITUD DE CUPO

*>>>>IMPRESION DE LOS DERECHOS DE AUTOR
       cTxtPrn = ALLTRIM(UPPER(cNomSis))+'.'+;
		  'Instalado para: '+ALLTRIM(UPPER(cNomEmp))

       IF (n20Stan-LEN(cTxtPrn))/2 < 0
	  cError('LA COLUMNA ES NEGATIVA EN DerechosPrn')
       ENDIF

       @ PROW(),00 SAY CONDEN_ON
       @ PROW()+1,(n20Stan-LEN(cTxtPrn))/2 SAY cTxtPrn
       @ PROW(),00 SAY CONDEN_OF
       @ PROW()+1,01 SAY REPL('=',90)
*>>>>FIN IMPRESION DEL FORMULARIO DE SOLICITUD DE CUPO

*>>>>IMPRESION DE LA CITACION PARA EXAMEN
       cTxtPrn := 'CITACION No. '+cCodigo+;
		  ' PARA EL NIVEL '+cNomNiv(cCodNiv)
       @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn

       @ PROW()+2,01 SAY 'NOMBRE: '+RTRIM(cApelli)+' '+RTRIM(cNombre)

       LineaPrn({'DEBE PRESENTARSE EL DIA',REPL('_',49),;
		 'HORA',REPL('_',11)},1)

       @ PROW()+1,01 SAY 'OBSERVACIONES: '+REPL('_',74)
       @ PROW()+1,01 SAY REPL('_',90)
       @ PROW()+1,01 SAY REPL('_',90)

       IF !EMPTY(cObsUno+cObsDos+cObsTre)
	  @ PROW(),00   SAY NEGRA_OF+CONDEN_ON
	  @ PROW()+2,01 SAY 'NOTA: '+cObsUno
	  @ PROW()+1,01 SAY '      '+cObsDos
	  @ PROW()+1,01 SAY '      '+cObsTre
       ENDIF
       DerechosPrn(cNomSis,cNomEmp,n20Stan)
       EJECT
       SET DEVICE TO SCREEN
       Termometro(100)
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN IMPRESION DE LA CITACION PARA EXAMEN

/*************************************************************************
* TITULO ..: FORMULARIO DE SOLICITUD DE CUPO No. 05                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 31/2003 JUE A
       Colombia, Bucaramanga        INICIO: 10:30 AM   JUL 31/2003 JUE

OBJETIVOS:

1- Imprime el formulario de la solicitud de cupo No. 05 que fue reformado
   del formulario No.1 agregando, foto, tiempo de servicio,empresa,cargo
   tiempo de servicio del acudiente.

3- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Solicitu05(cCodigo,cCodNiv,cNombre,cApelli,lExAlum,;
		    cNomSis,cNomEmp,cAnoUsr,lRapido,cObsUno,;
		    cObsDos,cObsTre,cJorTxt,cObsInc)

*>>>>PARAMETROS DE LA FUNCION
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
       cObsInc                              // Observaci¢n de la Inscripci¢n */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
*       #INCLUDE "EPSONFX.PRG"
*       #DEFINE  CARTA  CHR(27)+'C'+CHR(66) // P gina de 66 l¡neas

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

       @ PROW(),00 SAY INICIALIZA+CARTA+;
		       GRAPHI_ON+CONDEN_OF+PROPOR_OF+DRAFT_ON

       lRapido := IF(lRapido == NIL,.T.,lRapido)
       IF lRapido
	  @ PROW(),00 SAY ELITE
       ELSE
	  @ PROW(),00 SAY NEGRA_ON+DOBGOL_ON+ELITE
       ENDIF
       nLenPrn := n12Stan
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL FORMULARIO DE SOLICITUD DE CUPO
       @ PROW(),00 SAY DOBANC_ON+DOBALT_ON
       cTxtPrn := 'SOLICITUD DE CUPO NUMERO: '+cCodigo
       @ PROW()+9,((nLenPrn/2)-LEN(cTxtPrn))/2 SAY cTxtPrn
       @ PROW(),00 SAY DOBANC_OF+DOBALT_OF
       @ PROW(),91 SAY '[FOTO]'

       cTxtPrn := 'NIVEL '+cNomNiv(cCodNiv)+' '+cAnoUsr+'. JORNADA: '+cJorTxt
       @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn

       @ PROW()+2,01 SAY 'FECHA DE SOLICITUD: '+ALLTRIM(cFecha(DATE()))
       @ PROW()+1,01 SAY 'NOMBRE: '+RTRIM(cApelli)+' '+cNombre+' '+;
			 'SEXO: M__ F__ TIPO DE SANGRE:____'

       @ PROW()+1,01 SAY 'DATOS PERSONALES: '

       aTitulo := {'NACIDO EN:',REPL('_',30),REPL('_',30),;
		   'EL',REPL('_',04),;
		   REPL('_',04),REPL('_',04)}
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

       LineaPrn({'IDENTIFICACION: ',REPL('_',04),;
		 'No' ,REPL('_',30),;
		 'DE' ,REPL('_',31)})
       LineaPrn({'DIRECCION:',REPL('_',49),'BARRIO:',REPL('_',21)})
       LineaPrn({'CIUDAD:',REPL('_',20),'TEL:',REPL('_',20),;
		 'E-MAIL:',REPL('_',27)})

       @ PROW()+1,01 SAY 'DATOS FAMILIARES: '

       LineaPrn({'APELLIDOS PADRE:',REPL('_',30),;
		 'NOMBRES PADRE:',REPL('_',27)},1)
       LineaPrn({'IDENTIFICACION: ____ No.:',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'TEL:',REPL('_',13)})
       LineaPrn({'EMPRESA:',REPL('_',25),;
		 'CARGO:',REPL('_',24),;
		 'TIEMPO SERVICIO:',REPL('_',06)},1)
       LineaPrn({'DIRECCION:',REPL('_',49),'BARRIO:',REPL('_',21)})
       LineaPrn({'CIUDAD:',REPL('_',20),'PROFESION:',REPL('_',20),;
		 'E-MAIL:',REPL('_',21)})

       LineaPrn({'APELLIDOS MADRE:',REPL('_',30),;
		 'NOMBRES MADRE:',REPL('_',27)},2)
       LineaPrn({'IDENTIFICACION: ____ No.:',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'TEL:',REPL('_',13)})
       LineaPrn({'EMPRESA:',REPL('_',25),;
		 'CARGO:',REPL('_',24),;
		 'TIEMPO SERVICIO:',REPL('_',06)},1)
       LineaPrn({'DIRECCION:',REPL('_',49),'BARRIO:',REPL('_',21)})
       LineaPrn({'CIUDAD:',REPL('_',20),'PROFESION:',REPL('_',20),;
		 'E-MAIL:',REPL('_',21)})

       LineaPrn({'APELLIDOS ACUDIENTE:',REPL('_',26),;
		 'NOMBRES ACUDIENTE:',REPL('_',23)},2)
       LineaPrn({'IDENTI: ____ No.:',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'PARENTESCO:',REPL('_',14)})
       LineaPrn({'EMPRESA:',REPL('_',25),;
		 'CARGO:',REPL('_',24),;
		 'TIEMPO SERVICIO:',REPL('_',06)},1)
       LineaPrn({'DIRECCION:',REPL('_',28),;
		 'BARRIO:',REPL('_',18),;
		 'TEL CASA:',REPL('_',13)})
       LineaPrn({'CIUDAD:',REPL('_',20),'TEL OFI:',REPL('_',16),;
		 'E-MAIL:',REPL('_',27)})

       @ PROW()+1,01 SAY 'DATOS ESCOLARES DEL ASPIRANTE:'

       LineaPrn({'COLEGIO DE PROCEDENCIA' ,REPL('_',36),;
		 'CIUDAD'                 ,REPL('_',23)},1)

       @ PROW()+1,01 SAY 'SI TIENE ACTUALMENTE ALGUN(OS) FAMILIAR(ES) EN '+;
			 'EL COLEGIO, NOMBRELO(S):'

       LineaPrn({'1. NOMBRE:',REPL('_',33),;
		 'CURSO:'    ,REPL('_',10),;
		 'PARENTESCO',REPL('_',16)})

       LineaPrn({'2. NOMBRE:',REPL('_',33),;
		 'CURSO:'    ,REPL('_',10),;
		 'PARENTESCO',REPL('_',16)})


       IF EMPTY(cObsInc)
	  LineaPrn({'OBSERVACIONES: ',REPL('_',74)},2)
       ELSE
	  @ PROW()+2,00 SAY 'OBSERVACIONES: '
	  @ PROW(),00 SAY CONDEN_ON
	  @ PROW(),25 SAY cObsInc
	  @ PROW(),00 SAY CONDEN_OF
       ENDIF
       @ PROW()+1,01 SAY REPL('_',90)
       @ PROW()+1,01 SAY REPL('_',90)

       LineaPrn({'MATRICULARSE EN FECHA ',REPL('_',49),;
		 'HORA'                  ,REPL('_',12)},2)
*>>>>FIN IMPRESION DEL FORMULARIO DE SOLICITUD DE CUPO


*>>>>IMPRESION DE LA CITACION PARA EXAMEN
       @ PROW()+1,01 SAY REPL('=',90)
       cTxtPrn := 'CITACION No. '+cCodigo+;
		  ' PARA EL NIVEL '+cNomNiv(cCodNiv)
       @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn

       @ PROW()+2,01 SAY 'NOMBRE: '+RTRIM(cApelli)+' '+RTRIM(cNombre)

       LineaPrn({'DEBE PRESENTARSE EL DIA',REPL('_',49),;
		 'HORA',REPL('_',11)},1)

       @ PROW()+1,01 SAY 'OBSERVACIONES: '+REPL('_',74)
       @ PROW()+1,01 SAY REPL('_',90)
       @ PROW()+1,01 SAY REPL('_',90)

       IF !EMPTY(cObsUno+cObsDos+cObsTre)
	  @ PROW(),00   SAY NEGRA_OF+CONDEN_ON
	  @ PROW()+2,01 SAY 'NOTA: '+cObsUno
	  @ PROW()+1,01 SAY '      '+cObsDos
	  @ PROW()+1,01 SAY '      '+cObsTre
       ENDIF
       DerechosPrn(cNomSis,cNomEmp,n20Stan)
       EJECT
       SET DEVICE TO SCREEN
       Termometro(100)
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN IMPRESION DE LA CITACION PARA EXAMEN

/*************************************************************************
* TITULO ..: FORMULARIO DE SOLICITUD DE CUPO No. 06                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 01/2003 VIE A
       Colombia, Bucaramanga        INICIO: 12:30 AM   AGO 01/2003 VIE

OBJETIVOS:

1- Imprime el formulario de la solicitud de cupo No. 06 que fue reformado
   del formulario No.4.

2- Este formulario es el por defecto del sistema.

3- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Solicitu06(cCodigo,cCodNiv,cNombre,cApelli,lExAlum,;
		    cNomSis,cNomEmp,cAnoUsr,lRapido,cObsUno,;
		    cObsDos,cObsTre,cJorTxt,cObsInc)

*>>>>PARAMETROS DE LA FUNCION
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
       cObsInc                              // Observaci¢n de la Inscripci¢n */
*>>>>FIN PARAMETROS DE LA FUNCION

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

       SendCodes(PCL({'Reset','Carta','GraphiOn','CondenOf',;
		      'ProporOf','DraftOn'}))

/*
       @ PROW(),00 SAY INICIALIZA+CARTA+;
		       GRAPHI_ON+CONDEN_OF+PROPOR_OF+DRAFT_ON
*/

       IF ANO->lPrnEmpAno
*	  @ PROW(),00 SAY DOBANC_ON+DOBALT_ON

	  SendCodes(PCL({'DobAncOn','DobAltOn'}))
	  @ PROW(),00 SAY cNomEmp
	  SendCodes(PCL({'DobAncOf','DobAltOf'}))

*	  @ PROW(),00 SAY DOBANC_OF+DOBALT_OF
       ENDIF

       lRapido := IF(lRapido == NIL,.T.,lRapido)
       IF lRapido
	  SendCodes(PCL('Elite'))
*	  @ PROW(),00 SAY ELITE
       ELSE
*	  @ PROW(),00 SAY NEGRA_ON+DOBGOL_ON+ELITE
	  SendCodes(PCL({'NegraOn','DobGolOn','Elite'}))
       ENDIF
       nLenPrn := PCL('n12Stan')
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL FORMULARIO DE SOLICITUD DE CUPO
*      @ PROW(),00 SAY DOBANC_ON+DOBALT_ON
       SendCodes(PCL({'DobAncOn','DobAltOn'}))

       cTxtPrn := 'SOLICITUD DE CUPO NUMERO: '+cCodigo
       IF ANO->lPrnEmpAno
	  @ PROW()+2,((nLenPrn/2)-LEN(cTxtPrn))/2 SAY cTxtPrn
       ELSE
	  @ PROW()+9,((nLenPrn/2)-LEN(cTxtPrn))/2 SAY cTxtPrn
       ENDIF
*      @ PROW(),00 SAY DOBANC_OF+DOBALT_OF
       SendCodes(PCL({'DobAncOf','DobAltOf'}))

       cTxtPrn := 'NIVEL '+cNomNiv(cCodNiv)+' '+cAnoUsr+'. JORNADA: '+cJorTxt
       @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn

       @ PROW()+2,59 SAY 'FECHA DE SOLICITUD: '+ALLTRIM(cFecha(DATE()))
       @ PROW()+1,01 SAY 'NOMBRE: '+RTRIM(cApelli)+' '+cNombre
*			 'SEXO: M__ F__'

       aTitulo := {'NACIDO EN:',REPL('_',30),REPL('_',30),;
		   'EL',REPL('_',04),;
		   REPL('_',04),REPL('_',04)}
       aTamCol := {LEN(aTitulo[1]),LEN(aTitulo[2]),;
		   LEN(aTitulo[3]),LEN(aTitulo[4]),;
		   LEN(aTitulo[5]),LEN(aTitulo[6]),;
		   LEN(aTitulo[7])}
       cRegPrint(aTitulo,aTamCol,aNroCol)
       @ PROW()+2,aNroCol[1] SAY aTitulo[1]
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

       LineaPrn({'IDENTIFICACION: ',REPL('_',04),;
		 'No' ,REPL('_',30),;
		 'DE' ,REPL('_',31)})
       LineaPrn({'DIRECCION:',REPL('_',49),'BARRIO:',REPL('_',21)})
       LineaPrn({'CIUDAD:',REPL('_',20),'TEL:',REPL('_',20),;
		 'E-MAIL:',REPL('_',27)})

       LineaPrn({'APELLIDOS PADRE:',REPL('_',30),;
		 'NOMBRES PADRE:',REPL('_',27)},2)
       LineaPrn({'IDENTIFICACION: ____ No.:',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'TEL:',REPL('_',13)})
       LineaPrn({'EMPRESA:',REPL('_',38),'CARGO:',REPL('_',35)},1)
       LineaPrn({'DIRECCION:',REPL('_',49),'BARRIO:',REPL('_',21)})
       LineaPrn({'CIUDAD:',REPL('_',20),'PROFESION:',REPL('_',20),;
		 'E-MAIL:',REPL('_',21)})

       LineaPrn({'APELLIDOS MADRE:',REPL('_',30),;
		 'NOMBRES MADRE:',REPL('_',27)},2)
       LineaPrn({'IDENTIFICACION: ____ No.:',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'TEL:',REPL('_',13)})
       LineaPrn({'EMPRESA:',REPL('_',38),'CARGO:',REPL('_',35)},1)
       LineaPrn({'DIRECCION:',REPL('_',49),'BARRIO:',REPL('_',21)})
       LineaPrn({'CIUDAD:',REPL('_',20),'PROFESION:',REPL('_',20),;
		 'E-MAIL:',REPL('_',21)})

       LineaPrn({'APELLIDOS ACUDIENTE:',REPL('_',26),;
		 'NOMBRES ACUDIENTE:',REPL('_',23)},2)
       LineaPrn({'IDENTI: ____ No.:',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'PARENTESCO:',REPL('_',14)})
       LineaPrn({'DIRECCION:',REPL('_',28),;
		 'BARRIO:',REPL('_',18),;
		 'TEL CASA:',REPL('_',13)})
       LineaPrn({'CIUDAD:',REPL('_',20),'TEL OFI:',REPL('_',16),;
		 'E-MAIL:',REPL('_',27)})

       LineaPrn({'COLEGIO DE PROCEDENCIA' ,REPL('_',36),;
		 'CIUDAD'                 ,REPL('_',23)},2)

       @ PROW()+1,01 SAY 'SI TIENE ACTUALMENTE ALGUN(OS) FAMILIAR(ES) EN '+;
			 'EL COLEGIO, NOMBRELO(S):'

       LineaPrn({'1. NOMBRE:',REPL('_',33),;
		 'CURSO:'    ,REPL('_',10),;
		 'PARENTESCO',REPL('_',16)})

       LineaPrn({'2. NOMBRE:',REPL('_',33),;
		 'CURSO:'    ,REPL('_',10),;
		 'PARENTESCO',REPL('_',16)})

       LineaPrn({SPACE(35)+'COLEGIOS DE PROCEDENCIA'},1)
       LineaPrn({'GRADO'            ,SPACE(01),;
		 'A¥O'              ,SPACE(02),;
		 'PLANTEL EDUCATIVO',SPACE(24),;
		 'CIUDAD'},1)
       LineaPrn({'PR',SPACE(04),REPL('_',04),SPACE(00),;
		 REPL('_',40),SPACE(01),REPL('_',23)},1)
       LineaPrn({'JA',SPACE(04),REPL('_',04),SPACE(00),;
		 REPL('_',40),SPACE(01),REPL('_',23)},1)
       LineaPrn({'TR',SPACE(04),REPL('_',04),SPACE(00),;
		 REPL('_',40),SPACE(01),REPL('_',23)},1)
       LineaPrn({'1§',SPACE(04),REPL('_',04),SPACE(00),;
		 REPL('_',40),SPACE(01),REPL('_',23)},1)
       LineaPrn({'2§',SPACE(04),REPL('_',04),SPACE(00),;
		 REPL('_',40),SPACE(01),REPL('_',23)},1)
       LineaPrn({'3§',SPACE(04),REPL('_',04),SPACE(00),;
		 REPL('_',40),SPACE(01),REPL('_',23)},1)
       LineaPrn({'4§',SPACE(04),REPL('_',04),SPACE(00),;
		 REPL('_',40),SPACE(01),REPL('_',23)},1)
       LineaPrn({'5§',SPACE(04),REPL('_',04),SPACE(00),;
		 REPL('_',40),SPACE(01),REPL('_',23)},1)
       LineaPrn({'6§',SPACE(04),REPL('_',04),SPACE(00),;
		 REPL('_',40),SPACE(01),REPL('_',23)},1)
       LineaPrn({'7§',SPACE(04),REPL('_',04),SPACE(00),;
		 REPL('_',40),SPACE(01),REPL('_',23)},1)
       LineaPrn({'8§',SPACE(04),REPL('_',04),SPACE(00),;
		 REPL('_',40),SPACE(01),REPL('_',23)},1)
       LineaPrn({'9§',SPACE(04),REPL('_',04),SPACE(00),;
		 REPL('_',40),SPACE(01),REPL('_',23)},1)
       LineaPrn({'10§',SPACE(03),REPL('_',04),SPACE(00),;
		 REPL('_',40),SPACE(01),REPL('_',23)},1)

       IF EMPTY(cObsInc)
	  LineaPrn({'OBSERVACIONES: ',REPL('_',74)},2)
       ELSE
	  @ PROW()+2,00 SAY 'OBSERVACIONES: '
	  @ PROW(),00 SAY CONDEN_ON
	  @ PROW(),25 SAY cObsInc
	  @ PROW(),00 SAY CONDEN_OF
       ENDIF
*       @ PROW()+1,01 SAY REPL('_',90)

       LineaPrn({'RECTOR(A):',REPL('_',26)+SPACE(02),;
		 'PSICOORIENTADOR(A):',REPL('_',30)},2)
*>>>>FIN IMPRESION DEL FORMULARIO DE SOLICITUD DE CUPO

*>>>>IMPRESION DE LA CITACION PARA EXAMEN
       LineaPrn({'ENTREVISTA EL DIA',REPL('_',49),;
		 'HORA',REPL('_',11)},2)

       LineaPrn({'EVALUACION EL DIA',REPL('_',49),;
		 'HORA',REPL('_',11)},1)

       IF !EMPTY(cObsUno+cObsDos+cObsTre)
*	  @ PROW(),00   SAY NEGRA_OF+CONDEN_ON
	  SendCodes(PCL({'NegraOf','CondenOn'}))

	  @ PROW()+2,01 SAY 'NOTA: '+cObsUno
	  @ PROW()+1,01 SAY '      '+cObsDos
	  @ PROW()+1,01 SAY '      '+cObsTre
       ENDIF
       DerechosPrn(cNomSis,cNomEmp,n20Stan)
       EJECT
       SET DEVICE TO SCREEN
       Termometro(100)
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN IMPRESION DE LA CITACION PARA EXAMEN

/*************************************************************************
* TITULO ..: FORMULARIO DE SOLICITUD DE CUPO No. 07                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 02/96 MAR A
       Colombia, Bucaramanga        INICIO: 02:00 PM   ENE 02/96 MAR

OBJETIVOS:

1- Imprime el formulario de la solicitud de cupo No. 01

2- Este formulario sugerencia del Virrey Solis

3- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Solicitu07(cCodigo,cCodNiv,cNombre,cApelli,lExAlum,;
		    cNomSis,cNomEmp,cAnoUsr,lRapido,cObsUno,;
		    cObsDos,cObsTre,cJorTxt,cObsInc)

*>>>>PARAMETROS DE LA FUNCION
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
       cObsInc                              // Observaci¢n de la Inscripci¢n */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
*       #DEFINE  CARTA  CHR(27)+'C'+CHR(66) // P gina de 66 l¡neas

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

       @ PROW(),00 SAY INICIALIZA+CARTA+;
		       GRAPHI_ON+CONDEN_OF+PROPOR_OF+DRAFT_ON

       lRapido := IF(lRapido == NIL,.T.,lRapido)
       IF lRapido
	  @ PROW(),00 SAY ELITE
       ELSE
	  @ PROW(),00 SAY NEGRA_ON+DOBGOL_ON+ELITE
       ENDIF
       nLenPrn := n12Stan
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL FORMULARIO DE SOLICITUD DE CUPO
       @ PROW(),00 SAY DOBANC_ON+DOBALT_ON
       cTxtPrn := 'SOLICITUD DE CUPO NUMERO: '+cCodigo
       @ PROW()+9,((nLenPrn/2)-LEN(cTxtPrn))/2 SAY cTxtPrn
       @ PROW(),00 SAY DOBANC_OF+DOBALT_OF

       cTxtPrn := 'NIVEL '+cNomNiv(cCodNiv)+' '+cAnoUsr+'. JORNADA: '+cJorTxt
       @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn

       @ PROW()+2,01 SAY 'FECHA DE SOLICITUD: '+ALLTRIM(cFecha(DATE()))
       @ PROW()+1,01 SAY 'NOMBRE: '+RTRIM(cApelli)+' '+cNombre+' '+;
			 'SEXO: M__ F__'

       aTitulo := {'NACIDO EN:',REPL('_',30),REPL('_',30),;
		   'EL',REPL('_',04),;
		   REPL('_',04),REPL('_',04)}
       aTamCol := {LEN(aTitulo[1]),LEN(aTitulo[2]),;
		   LEN(aTitulo[3]),LEN(aTitulo[4]),;
		   LEN(aTitulo[5]),LEN(aTitulo[6]),;
		   LEN(aTitulo[7])}
       cRegPrint(aTitulo,aTamCol,aNroCol)
       @ PROW()+2,aNroCol[1] SAY aTitulo[1]
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

       LineaPrn({'IDENTIFICACION: ',REPL('_',04),;
		 'No' ,REPL('_',30),;
		 'DE' ,REPL('_',31)})
       LineaPrn({'DIRECCION:',REPL('_',49),'BARRIO:',REPL('_',21)})
       LineaPrn({'CIUDAD:',REPL('_',20),'TEL:',REPL('_',20),;
		 'E-MAIL:',REPL('_',27)})

       LineaPrn({'APELLIDOS PADRE:',REPL('_',30),;
		 'NOMBRES PADRE:',REPL('_',27)},2)
       LineaPrn({'IDENTIFICACION: ____ No.:',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'TEL:',REPL('_',13)})
       LineaPrn({'EMPRESA:',REPL('_',38),'CARGO:',REPL('_',35)},1)
       LineaPrn({'DIRECCION:',REPL('_',49),'BARRIO:',REPL('_',21)})
       LineaPrn({'CIUDAD:',REPL('_',20),'PROFESION:',REPL('_',20),;
		 'E-MAIL:',REPL('_',21)})

       LineaPrn({'APELLIDOS MADRE:',REPL('_',30),;
		 'NOMBRES MADRE:',REPL('_',27)},2)
       LineaPrn({'IDENTIFICACION: ____ No.:',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'TEL:',REPL('_',13)})
       LineaPrn({'EMPRESA:',REPL('_',38),'CARGO:',REPL('_',35)},1)
       LineaPrn({'DIRECCION:',REPL('_',49),'BARRIO:',REPL('_',21)})
       LineaPrn({'CIUDAD:',REPL('_',20),'PROFESION:',REPL('_',20),;
		 'E-MAIL:',REPL('_',21)})

       LineaPrn({'APELLIDOS ACUDIENTE:',REPL('_',26),;
		 'NOMBRES ACUDIENTE:',REPL('_',23)},2)
       LineaPrn({'IDENTI: ____ No.:',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'PARENTESCO:',REPL('_',14)})
       LineaPrn({'DIRECCION:',REPL('_',28),;
		 'BARRIO:',REPL('_',18),;
		 'TEL CASA:',REPL('_',13)})
       LineaPrn({'CIUDAD:',REPL('_',20),'TEL OFI:',REPL('_',16),;
		 'E-MAIL:',REPL('_',27)})

       LineaPrn({'COLEGIO DE PROCEDENCIA' ,REPL('_',36),;
		 'CIUDAD'                 ,REPL('_',23)},2)

       @ PROW()+1,01 SAY 'POR FAVOR SUMINISTRE LA SIGUIENTE INFORMACION:'
       LineaPrn({'1. ENFERMEDADES QUE PADECE:',REPL('_',62)})
       LineaPrn({'2. RELIGION:',REPL('_',77)})


       IF EMPTY(cObsInc)
	  LineaPrn({'OBSERVACIONES: ',REPL('_',74)},2)
       ELSE
	  @ PROW()+2,00 SAY 'OBSERVACIONES: '
	  @ PROW(),00 SAY CONDEN_ON
	  @ PROW(),25 SAY cObsInc
	  @ PROW(),00 SAY CONDEN_OF
       ENDIF
       @ PROW()+1,01 SAY REPL('_',90)
       @ PROW()+1,01 SAY REPL('_',90)

       LineaPrn({'MATRICULARSE EN FECHA ',REPL('_',49),;
		 'HORA'                  ,REPL('_',12)},2)
*>>>>FIN IMPRESION DEL FORMULARIO DE SOLICITUD DE CUPO

*>>>>IMPRESION DE LOS DERECHOS DE AUTOR
       cTxtPrn = ALLTRIM(UPPER(cNomSis))+'. '+;
		  'Instalado para: '+ALLTRIM(UPPER(cNomEmp))

       IF (n20Stan-LEN(cTxtPrn))/2 < 0
	  cError('LA COLUMNA ES NEGATIVA EN DerechosPrn')
       ENDIF

       @ PROW(),00 SAY CONDEN_ON
       @ PROW()+1,(n20Stan-LEN(cTxtPrn))/2 SAY cTxtPrn
       @ PROW(),00 SAY CONDEN_OF
       @ PROW()+1,01 SAY REPL('=',90)
*>>>>FIN IMPRESION DEL FORMULARIO DE SOLICITUD DE CUPO

*>>>>IMPRESION DE LA CITACION PARA EXAMEN
       cTxtPrn := 'CITACION No. '+cCodigo+;
		  ' PARA EL NIVEL '+cNomNiv(cCodNiv)
       @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn

       @ PROW()+2,01 SAY 'NOMBRE: '+RTRIM(cApelli)+' '+RTRIM(cNombre)

       LineaPrn({'DEBE PRESENTARSE EL DIA',REPL('_',49),;
		 'HORA',REPL('_',11)},1)

       @ PROW()+1,01 SAY 'OBSERVACIONES: '+REPL('_',74)
       @ PROW()+1,01 SAY REPL('_',90)
       @ PROW()+1,01 SAY REPL('_',90)

       IF !EMPTY(cObsUno+cObsDos+cObsTre)
	  @ PROW(),00   SAY NEGRA_OF+CONDEN_ON
	  @ PROW()+2,01 SAY 'NOTA: '+cObsUno
	  @ PROW()+1,01 SAY '      '+cObsDos
	  @ PROW()+1,01 SAY '      '+cObsTre
       ENDIF
       DerechosPrn(cNomSis,cNomEmp,n20Stan)
       EJECT
       SET DEVICE TO SCREEN
       Termometro(100)
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN IMPRESION DE LA CITACION PARA EXAMEN

/*************************************************************************
* TITULO ..: FORMULARIO DE SOLICITUD DE CUPO No. 08                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 14/2004 MIE A
       Colombia, Bucaramanga        INICIO: 11:00 AM   SEP 14/2004 MIE

OBJETIVOS:

1- Imprime el formulario de la solicitud de cupo No. 08

2- Este formulario es una alternativa para reemplazar el formulario por
   defecto, debido a que contiene todos los campos que se solicitan en
   la digitaci¢n de la hoja de vida.

3- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Solicitu08(cCodigo,cCodNiv,cNombre,cApelli,lExAlum,;
		    cNomSis,cNomEmp,cAnoUsr,lRapido,cObsUno,;
		    cObsDos,cObsTre,cJorTxt,cObsInc)

*>>>>PARAMETROS DE LA FUNCION
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
       cObsInc                              // Observaci¢n de la Inscripci¢n */
*>>>>FIN PARAMETROS DE LA FUNCION

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

       @ PROW(),00 SAY PCL({'Reset','Carta','GraphiOn','CondenOf',;
			    'ProporOf','DraftOn'})

       lRapido := IF(lRapido == NIL,.T.,lRapido)
       IF lRapido
	  @ PROW(),00 SAY PCL('Elite')
       ELSE
	  @ PROW(),00 SAY PCL({'NegraOn','DobGolOn','Elite'})
       ENDIF
       nLenPrn := PCL('n12Stan')
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL FORMULARIO DE SOLICITUD DE CUPO
       @ PROW(),00 SAY PCL({'DobAncOn','DobAltOn'})

       cTxtPrn := 'SOLICITUD DE CUPO NUMERO: '+cCodigo
       @ PROW()+9,((nLenPrn/2)-LEN(cTxtPrn))/2 SAY cTxtPrn
       @ PROW(),00 SAY PCL({'DobAncOf','DobAltOf'})
       @ PROW(),91 SAY '[FOTO]'

       cTxtPrn := 'NIVEL '+cNomNiv(cCodNiv)+' '+cAnoUsr+'. JORNADA: '+cJorTxt
       @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn

       @ PROW()+2,01 SAY 'FECHA DE SOLICITUD: '+ALLTRIM(cFecha(DATE()))
       @ PROW()+1,01 SAY 'NOMBRE: '+RTRIM(cApelli)+' '+cNombre+' '+;
			 'SEXO: M__ F__'+SPACE(08)+'ESTRATO No: __'

       aTitulo := {'NACIDO EN:',REPL('_',30),REPL('_',30),;
		   'EL',REPL('_',04),;
		   REPL('_',04),REPL('_',04)}
       aTamCol := {LEN(aTitulo[1]),LEN(aTitulo[2]),;
		   LEN(aTitulo[3]),LEN(aTitulo[4]),;
		   LEN(aTitulo[5]),LEN(aTitulo[6]),;
		   LEN(aTitulo[7])}
       cRegPrint(aTitulo,aTamCol,aNroCol)
       @ PROW()+2,aNroCol[1] SAY aTitulo[1]
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

       LineaPrn({'IDENTIFICACION: ',REPL('_',04),;
		 'No' ,REPL('_',30),;
		 'DE' ,REPL('_',31)})
       LineaPrn({'DIRECCION:',REPL('_',49),'BARRIO:',REPL('_',21)})
       LineaPrn({'CIUDAD:',REPL('_',20),'TEL:',REPL('_',10),;
		 'CEL:',REPL('_',10),'E-MAIL:',REPL('_',21)})

       LineaPrn({'APELLIDOS PADRE:',REPL('_',30),;
		 'NOMBRES PADRE:',REPL('_',27)},2)
       LineaPrn({'IDENTIFICACION: ____ No.:',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'TEL:',REPL('_',13)})
       LineaPrn({'EMPRESA:',REPL('_',25),;
		 'CARGO:',REPL('_',24),;
		 'TIEMPO SERVICIO:',REPL('_',06)},1)
       LineaPrn({'DIRECCION:',REPL('_',49),'BARRIO:',REPL('_',21)})
       LineaPrn({'CIUDAD:',REPL('_',20),'PROFESION:',REPL('_',20),;
		 'E-MAIL:',REPL('_',21)})
      LineaPrn({'FAX:',REPL('_',23),'CELULAR:',REPL('_',22),;
		 'BIPPER:',REPL('_',21)})

       LineaPrn({'APELLIDOS MADRE:',REPL('_',30),;
		 'NOMBRES MADRE:',REPL('_',27)},2)
       LineaPrn({'IDENTIFICACION: ____ No.:',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'TEL:',REPL('_',13)})
       LineaPrn({'EMPRESA:',REPL('_',25),;
		 'CARGO:',REPL('_',24),;
		 'TIEMPO SERVICIO:',REPL('_',06)},1)
       LineaPrn({'DIRECCION:',REPL('_',49),'BARRIO:',REPL('_',21)})
       LineaPrn({'CIUDAD:',REPL('_',20),'PROFESION:',REPL('_',20),;
		 'E-MAIL:',REPL('_',21)})
       LineaPrn({'FAX:',REPL('_',23),'CELULAR:',REPL('_',22),;
		  'BIPPER:',REPL('_',21)})

       LineaPrn({'APELLIDOS ACUDIENTE:',REPL('_',26),;
		 'NOMBRES ACUDIENTE:',REPL('_',23)},2)
       LineaPrn({'IDENTI: ____ No.:',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'PARENTESCO:',REPL('_',14)})
       LineaPrn({'EMPRESA:',REPL('_',25),;
		 'CARGO:',REPL('_',24),;
		 'TIEMPO SERVICIO:',REPL('_',06)},1)
       LineaPrn({'DIRECCION:',REPL('_',28),;
		 'BARRIO:',REPL('_',18),;
		 'TEL CASA:',REPL('_',13)})
       LineaPrn({'CIUDAD:',REPL('_',20),'TEL OFI:',REPL('_',16),;
		 'E-MAIL:',REPL('_',27)})
       LineaPrn({'FAX:',REPL('_',23),'CELULAR:',REPL('_',22),;
		  'BIPPER:',REPL('_',21)})

       LineaPrn({'COLEGIO DE PROCEDENCIA' ,REPL('_',36),;
		 'CIUDAD'                 ,REPL('_',23)},2)

       @ PROW()+1,01 SAY 'SI TIENE ACTUALMENTE ALGUN(OS) FAMILIAR(ES) EN '+;
			 'EL COLEGIO, NOMBRELO(S):'

       LineaPrn({'1. NOMBRE:',REPL('_',33),;
		 'CURSO:'    ,REPL('_',10),;
		 'PARENTESCO',REPL('_',16)})

       LineaPrn({'2. NOMBRE:',REPL('_',33),;
		 'CURSO:'    ,REPL('_',10),;
		 'PARENTESCO',REPL('_',16)})


       IF EMPTY(cObsInc)
	  LineaPrn({'OBSERVACIONES: ',REPL('_',74)},2)
       ELSE
	  @ PROW()+2,00 SAY 'OBSERVACIONES: '
	  @ PROW(),00 SAY PCL('CondenOn')
	  @ PROW(),25 SAY cObsInc
	  @ PROW(),00 SAY PCL('CondenOf')
       ENDIF
       LineaPrn({'MATRICULARSE EN FECHA ',REPL('_',49),;
		 'HORA'                  ,REPL('_',12)},2)
*>>>>FIN IMPRESION DEL FORMULARIO DE SOLICITUD DE CUPO

*>>>>IMPRESION DE LA CITACION PARA EXAMEN
       @ PROW()+1,01 SAY REPL('=',90)
       cTxtPrn := 'CITACION No. '+cCodigo+;
		  ' PARA EL NIVEL '+cNomNiv(cCodNiv)
       @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn

       @ PROW()+2,01 SAY 'NOMBRE: '+RTRIM(cApelli)+' '+RTRIM(cNombre)

       LineaPrn({'DEBE PRESENTARSE EL DIA',REPL('_',49),;
		 'HORA',REPL('_',11)},1)

       @ PROW()+1,01 SAY 'OBSERVACIONES: '+REPL('_',74)
       @ PROW()+1,01 SAY REPL('_',90)
       @ PROW()+1,01 SAY REPL('_',90)

       IF !EMPTY(cObsUno+cObsDos+cObsTre)
	  @ PROW(),00 SAY PCL({'NegraOf','CondenOn'})
	  @ PROW()+2,01 SAY 'NOTA: '+cObsUno
	  @ PROW()+1,01 SAY '      '+cObsDos
	  @ PROW()+1,01 SAY '      '+cObsTre
       ENDIF
       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
       EJECT
       SET DEVICE TO SCREEN
       Termometro(100)
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN IMPRESION DE LA CITACION PARA EXAMEN

/*************************************************************************
* TITULO ..: FORMULARIO DE SOLICITUD DE CUPO No. 09                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 02/96 MAR A
       Colombia, Bucaramanga        INICIO: 02:00 PM   ENE 02/96 MAR

OBJETIVOS:

1- Imprime el formulario de la solicitud de cupo No. 01

2- Este formulario para el Colegio de la Presentaci¢n

3- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Solicitu09(cCodigo,cCodNiv,cNombre,cApelli,lExAlum,;
		    cNomSis,cNomEmp,cAnoUsr,lRapido,cObsUno,;
		    cObsDos,cObsTre,cJorTxt,cObsInc)

*>>>>PARAMETROS DE LA FUNCION
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
       cObsInc                              // Observaci¢n de la Inscripci¢n */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
*       #INCLUDE "EPSONFX.PRG"
*       #DEFINE  CARTA  CHR(27)+'C'+CHR(66) // P gina de 66 l¡neas

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

       @ PROW(),00 SAY INICIALIZA+CARTA+;
		       GRAPHI_ON+CONDEN_OF+PROPOR_OF+DRAFT_ON

       lRapido := IF(lRapido == NIL,.T.,lRapido)
       IF lRapido
	  @ PROW(),00 SAY ELITE
       ELSE
	  @ PROW(),00 SAY NEGRA_ON+DOBGOL_ON+ELITE
       ENDIF
       nLenPrn := n12Stan
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL FORMULARIO DE SOLICITUD DE CUPO
       @ PROW(),00 SAY DOBANC_ON+DOBALT_ON
       cTxtPrn := 'SOLICITUD DE CUPO NUMERO: '+cCodigo
       @ PROW()+9,((nLenPrn/2)-LEN(cTxtPrn))/2 SAY cTxtPrn
       @ PROW(),00 SAY DOBANC_OF+DOBALT_OF

       cTxtPrn := 'NIVEL '+cNomNiv(cCodNiv)+' '+cAnoUsr+'. JORNADA: '+cJorTxt
       @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn

       @ PROW()+2,01 SAY 'FECHA DE SOLICITUD: '+ALLTRIM(cFecha(DATE()))
       @ PROW()+1,01 SAY 'NOMBRE: '+RTRIM(cApelli)+' '+cNombre+' '+;
			 'SEXO: M__ F__ EDAD:A¥OS:___ MESES___'

       aTitulo := {'NACIDO EN:',REPL('_',30),REPL('_',30),;
		   'EL',REPL('_',04),;
		   REPL('_',04),REPL('_',04)}
       aTamCol := {LEN(aTitulo[1]),LEN(aTitulo[2]),;
		   LEN(aTitulo[3]),LEN(aTitulo[4]),;
		   LEN(aTitulo[5]),LEN(aTitulo[6]),;
		   LEN(aTitulo[7])}
       cRegPrint(aTitulo,aTamCol,aNroCol)
       @ PROW()+2,aNroCol[1] SAY aTitulo[1]
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

       LineaPrn({'IDENTIFICACION: ',REPL('_',04),;
		 'No' ,REPL('_',30),;
		 'DE' ,REPL('_',31)})
       LineaPrn({'DIRECCION:',REPL('_',49),'BARRIO:',REPL('_',21)})
       LineaPrn({'CIUDAD:',REPL('_',20),'TEL:',REPL('_',20),;
		 'E-MAIL:',REPL('_',27)})
       LineaPrn({'SACRAMENTOS QUE HA RECIBIDO: BAUTISMO:',REPL('_',02),;
		 'PRIMERA COMUNION:',REPL('_',02),;
		 'CONFIRMACION:',REPL('_',02)})

       LineaPrn({'APELLIDOS PADRE:',REPL('_',30),;
		 'NOMBRES PADRE:',REPL('_',27)},2)
       LineaPrn({'IDENTIFICACION: ____ No.:',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'TEL:',REPL('_',13)})
       LineaPrn({'EMPRESA:',REPL('_',38),'CARGO:',REPL('_',35)},1)
       LineaPrn({'DIRECCION:',REPL('_',49),'BARRIO:',REPL('_',21)})
       LineaPrn({'CIUDAD:',REPL('_',20),'PROFESION:',REPL('_',20),;
		 'E-MAIL:',REPL('_',21)})
       LineaPrn({'RELIGION QUE PROFESA:',REPL('_',68)})

       LineaPrn({'APELLIDOS MADRE:',REPL('_',30),;
		 'NOMBRES MADRE:',REPL('_',27)},2)
       LineaPrn({'IDENTIFICACION: ____ No.:',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'TEL:',REPL('_',13)})
       LineaPrn({'EMPRESA:',REPL('_',38),'CARGO:',REPL('_',35)},1)
       LineaPrn({'DIRECCION:',REPL('_',49),'BARRIO:',REPL('_',21)})
       LineaPrn({'CIUDAD:',REPL('_',20),'PROFESION:',REPL('_',20),;
		 'E-MAIL:',REPL('_',21)})
       LineaPrn({'RELIGION QUE PROFESA:',REPL('_',68)})
       LineaPrn({'MATRIMONIO: ECLECIASTICO:',REPL('_',02),;
		 'CIVIL:',REPL('_',02),;
		 'UNION LIBRE:',REPL('_',02),;
		 'OTRO:',REPL('_',02)})

       LineaPrn({'APELLIDOS ACUDIENTE:',REPL('_',26),;
		 'NOMBRES ACUDIENTE:',REPL('_',23)},2)
       LineaPrn({'IDENTI: ____ No.:',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'PARENTESCO:',REPL('_',14)})
       LineaPrn({'DIRECCION:',REPL('_',28),;
		 'BARRIO:',REPL('_',18),;
		 'TEL CASA:',REPL('_',13)})
       LineaPrn({'CIUDAD:',REPL('_',20),'TEL OFI:',REPL('_',16),;
		 'E-MAIL:',REPL('_',27)})

       LineaPrn({'EL ESTUDIANTE RESIDE: PADRES:',REPL('_',02),;
		 'PADRE:',REPL('_',02),;
		 'MADRE:',REPL('_',02),;
		 'HNOS:',REPL('_',02),;
		 'OTROS:',REPL('_',02),;
		 'CUAL:',REPL('_',12)},2)

       LineaPrn({'COLEGIO DE PROCEDENCIA' ,REPL('_',36),;
		 'CIUDAD'                 ,REPL('_',23)})
       LineaPrn({'                      ' ,REPL('_',36),;
		 'CIUDAD'                 ,REPL('_',23)})
       LineaPrn({'PORQUE ASPIRA A ENTRAR A ESTE COLEGIO:' ,REPL('_',51)})
       LineaPrn({'',REPL('_',89)})

       @ PROW()+1,01 SAY 'SI TIENE ACTUALMENTE ALGUN(OS) FAMILIAR(ES) EN '+;
			 'EL COLEGIO, NOMBRELO(S):'

       LineaPrn({'1. NOMBRE:',REPL('_',33),;
		 'CURSO:'    ,REPL('_',10),;
		 'PARENTESCO',REPL('_',16)})

       LineaPrn({'2. NOMBRE:',REPL('_',33),;
		 'CURSO:'    ,REPL('_',10),;
		 'PARENTESCO',REPL('_',16)})

       LineaPrn({'3. NOMBRE:',REPL('_',33),;
		 'CURSO:'    ,REPL('_',10),;
		 'PARENTESCO',REPL('_',16)})

       LineaPrn({'REFERENCIAS PERSONALES:',REPL('',01)},2)
       LineaPrn({'ESCRIBA EL NOMBRE DE DOS PERSONAS,'+;
		 'OJALA VINCULADAS DE ALGUNA MANERA CON EL COLEGIO'})
       LineaPrn({REPL('_',60),'TELEFONO:',REPL('_',19)})
       LineaPrn({REPL('_',60),'TELEFONO:',REPL('_',19)})
*>>>>FIN IMPRESION DEL FORMULARIO DE SOLICITUD DE CUPO

*>>>>IMPRESION DE LOS DERECHOS DE AUTOR
       cTxtPrn = ALLTRIM(UPPER(cNomSis))+'. '+;
		  'Instalado para: '+ALLTRIM(UPPER(cNomEmp))

       IF (n20Stan-LEN(cTxtPrn))/2 < 0
	  cError('LA COLUMNA ES NEGATIVA EN DerechosPrn')
       ENDIF

       @ PROW(),00 SAY CONDEN_ON
       @ PROW()+1,(n20Stan-LEN(cTxtPrn))/2 SAY cTxtPrn
       @ PROW(),00 SAY CONDEN_OF
       @ PROW()+1,01 SAY REPL('=',90)
*>>>>FIN IMPRESION DEL FORMULARIO DE SOLICITUD DE CUPO

*>>>>IMPRESION DE LA CITACION PARA EXAMEN
       IF !EMPTY(cObsUno+cObsDos+cObsTre)
	  @ PROW(),00   SAY NEGRA_OF+CONDEN_ON
	  @ PROW()+2,01 SAY 'NOTA: '+cObsUno
	  @ PROW()+1,01 SAY '      '+cObsDos
	  @ PROW()+1,01 SAY '      '+cObsTre
       ENDIF
       DerechosPrn(cNomSis,cNomEmp,n20Stan)
       EJECT
       SET DEVICE TO SCREEN
       Termometro(100)
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN IMPRESION DE LA CITACION PARA EXAMEN

/*************************************************************************
* TITULO ..: FORMULARIO DE SOLICITUD DE CUPO No. 10                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 31/2003 JUE A
       Colombia, Bucaramanga        INICIO: 10:30 AM   JUL 31/2003 JUE

OBJETIVOS:

1- Imprime el formulario de la solicitud de cupo No. 10 que fue reformado
   del formulario No.05 agregando, foto, tiempo de servicio,empresa,cargo
   tiempo de servicio del acudiente.

3- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Solicitu10(cCodigo,cCodNiv,cNombre,cApelli,lExAlum,;
		    cNomSis,cNomEmp,cAnoUsr,lRapido,cObsUno,;
		    cObsDos,cObsTre,cJorTxt,cObsInc)

*>>>>PARAMETROS DE LA FUNCION
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
       cObsInc                              // Observaci¢n de la Inscripci¢n */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
*       #INCLUDE "EPSONFX.PRG"
*       #DEFINE  CARTA  CHR(27)+'C'+CHR(66) // P gina de 66 l¡neas

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

       @ PROW(),00 SAY INICIALIZA+CARTA+;
		       GRAPHI_ON+CONDEN_OF+PROPOR_OF+DRAFT_ON

       lRapido := IF(lRapido == NIL,.T.,lRapido)
       IF lRapido
	  @ PROW(),00 SAY ELITE
       ELSE
	  @ PROW(),00 SAY NEGRA_ON+DOBGOL_ON+ELITE
       ENDIF
       nLenPrn := n12Stan
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL FORMULARIO DE SOLICITUD DE CUPO
       @ PROW(),00 SAY DOBANC_ON+DOBALT_ON
       cTxtPrn := 'SOLICITUD DE CUPO NUMERO: '+cCodigo
       @ PROW()+9,((nLenPrn/2)-LEN(cTxtPrn))/2 SAY cTxtPrn
       @ PROW(),00 SAY DOBANC_OF+DOBALT_OF
       @ PROW(),91 SAY '[FOTO]'

       cTxtPrn := 'NIVEL '+cNomNiv(cCodNiv)+' '+cAnoUsr+'. JORNADA: '+cJorTxt
       @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn

       @ PROW()+2,01 SAY 'FECHA DE SOLICITUD: '+ALLTRIM(cFecha(DATE()))
       @ PROW()+1,01 SAY 'NOMBRE: '+RTRIM(cApelli)+' '+cNombre+' '+;
			 'SEXO: M__ F__ TIPO DE SANGRE:____'

       @ PROW()+1,01 SAY 'DATOS PERSONALES: '

       aTitulo := {'NACIDO EN:',REPL('_',30),REPL('_',30),;
		   'EL',REPL('_',04),;
		   REPL('_',04),REPL('_',04)}
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

       LineaPrn({'IDENTIFICACION: ',REPL('_',04),;
		 'No' ,REPL('_',30),;
		 'DE' ,REPL('_',31)})
       LineaPrn({'DIRECCION:',REPL('_',49),'BARRIO:',REPL('_',21)})
       LineaPrn({'CIUDAD:',REPL('_',20),'TEL:',REPL('_',20),;
		 'E-MAIL:',REPL('_',27)})

       @ PROW()+1,01 SAY 'DATOS FAMILIARES: '

       LineaPrn({'APELLIDOS PADRE:',REPL('_',30),;
		 'NOMBRES PADRE:',REPL('_',27)},1)
       LineaPrn({'IDENTIFICACION: ____ No.:',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'TEL:',REPL('_',13)})
       LineaPrn({'EMPRESA:',REPL('_',25),;
		 'CARGO:',REPL('_',24),;
		 'TIEMPO SERVICIO:',REPL('_',06)},1)
       LineaPrn({'DIRECCION:',REPL('_',49),'BARRIO:',REPL('_',21)})
       LineaPrn({'CIUDAD:',REPL('_',20),'PROFESION:',REPL('_',20),;
		 'E-MAIL:',REPL('_',21)})

       LineaPrn({'APELLIDOS MADRE:',REPL('_',30),;
		 'NOMBRES MADRE:',REPL('_',27)},2)
       LineaPrn({'IDENTIFICACION: ____ No.:',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'TEL:',REPL('_',13)})
       LineaPrn({'EMPRESA:',REPL('_',25),;
		 'CARGO:',REPL('_',24),;
		 'TIEMPO SERVICIO:',REPL('_',06)},1)
       LineaPrn({'DIRECCION:',REPL('_',49),'BARRIO:',REPL('_',21)})
       LineaPrn({'CIUDAD:',REPL('_',20),'PROFESION:',REPL('_',20),;
		 'E-MAIL:',REPL('_',21)})

       LineaPrn({'APELLIDOS ACUDIENTE:',REPL('_',26),;
		 'NOMBRES ACUDIENTE:',REPL('_',23)},2)
       LineaPrn({'IDENTI: ____ No.:',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'PARENTESCO:',REPL('_',14)})
       LineaPrn({'EMPRESA:',REPL('_',25),;
		 'CARGO:',REPL('_',24),;
		 'TIEMPO SERVICIO:',REPL('_',06)},1)
       LineaPrn({'DIRECCION:',REPL('_',28),;
		 'BARRIO:',REPL('_',18),;
		 'TEL CASA:',REPL('_',13)})
       LineaPrn({'CIUDAD:',REPL('_',20),'TEL OFI:',REPL('_',16),;
		 'E-MAIL:',REPL('_',27)})

       @ PROW()+1,01 SAY 'DATOS ESCOLARES DEL ASPIRANTE:'

       LineaPrn({'COLEGIO DE PROCEDENCIA' ,REPL('_',36),;
		 'CIUDAD'                 ,REPL('_',23)},1)

       @ PROW()+1,01 SAY 'SI TIENE ACTUALMENTE ALGUN(OS) FAMILIAR(ES) EN '+;
			 'EL COLEGIO, NOMBRELO(S):'

       LineaPrn({'1. NOMBRE:',REPL('_',33),;
		 'CURSO:'    ,REPL('_',10),;
		 'PARENTESCO',REPL('_',16)})

       LineaPrn({'2. NOMBRE:',REPL('_',33),;
		 'CURSO:'    ,REPL('_',10),;
		 'PARENTESCO',REPL('_',16)})


       IF EMPTY(cObsInc)
	  LineaPrn({'OBSERVACIONES: ',REPL('_',74)},2)
       ELSE
	  @ PROW()+2,00 SAY 'OBSERVACIONES: '
	  @ PROW(),00 SAY CONDEN_ON
	  @ PROW(),25 SAY cObsInc
	  @ PROW(),00 SAY CONDEN_OF
       ENDIF
       @ PROW()+1,01 SAY REPL('_',90)
       @ PROW()+1,01 SAY REPL('_',90)

       LineaPrn({'MATRICULARSE EN FECHA ',REPL('_',49),;
		 'HORA'                  ,REPL('_',12)},2)
*>>>>FIN IMPRESION DEL FORMULARIO DE SOLICITUD DE CUPO


*>>>>IMPRESION DE LA CITACION PARA EXAMEN
       @ PROW()+1,01 SAY REPL('=',90)
       cTxtPrn := 'CITACION No. '+cCodigo+;
		  ' PARA EL NIVEL '+cNomNiv(cCodNiv)
       @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn

       @ PROW()+2,01 SAY 'NOMBRE: '+RTRIM(cApelli)+' '+RTRIM(cNombre)

       LineaPrn({'DEBE PRESENTARSE EL DIA',REPL('_',49),;
		 'HORA',REPL('_',11)},1)

       @ PROW()+1,01 SAY 'OBSERVACIONES: '+REPL('_',74)
       @ PROW()+1,01 SAY REPL('_',90)
       @ PROW()+1,01 SAY REPL('_',90)

       IF !EMPTY(cObsUno+cObsDos+cObsTre)
	  @ PROW(),00   SAY NEGRA_OF+CONDEN_ON
	  @ PROW()+2,01 SAY 'NOTA: '+cObsUno
	  @ PROW()+1,01 SAY '      '+cObsDos
	  @ PROW()+1,01 SAY '      '+cObsTre
       ENDIF
       DerechosPrn(cNomSis,cNomEmp,n20Stan)
       EJECT
       SET DEVICE TO SCREEN
       Termometro(100)
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN IMPRESION DE LA CITACION PARA EXAMEN

/*************************************************************************
* TITULO ..: FORMULARIO DE SOLICITUD DE CUPO No. 99                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 02/96 MAR A
       Colombia, Bucaramanga        INICIO: 02:00 PM   ENE 02/96 MAR

OBJETIVOS:

1- Imprime el formulario de la solicitud de cupo No. 01

2- Este formulario para el Colegio de la Presentaci¢n

3- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Solicitu99(cCodigo,cCodNiv,cNombre,cApelli,;
		    lExAlum,cAnoUsr,cJorTxt,cObsInc,;
		    cNroDoc)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodigo                              // C¢digo de la Solicitud
       cCodNiv			            // C¢digo del Nivel
       cNombre                              // Nombres del aspirante
       cApelli                              // Apellidos del aspirante
       lExAlum                              // .T. Ex-Alumno
       cAnoUsr                              // A¤o del usuario
       cJorTxt                              // Jornada escogida
       cObsInc                              // Observaci¢n de la Inscripci¢n
       cNroDoc                              // N£mero del Documento */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador

       LOCAL lOficio := .F.                 // .T. Tama¤o Oficio
       LOCAL aMezIni := {}                  // Campos a Mesclar iniciales
       LOCAL aMezcla := {}                  // Campos a Mesclar
       LOCAL bCodBlo := NIL                 // Code Block.
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAMPOS GENERALES
       bCodBlo  := {||Eject()}
       CamSusPrn(@aMezIni)
       AADD(aMezIni,{'<SLP>',bCodBlo})
       AADD(aMezIni,{'<FECHA>',cFecha(DATE(),10)})
*>>>>FIN CAMPOS GENERALES

*>>>>CAMPOS DE SUSTITUCION
       aMezcla := {}
       AADD(aMezcla,{'(NOMBRE)',RTRIM(cApelli)+' '+RTRIM(cNombre)})
       AADD(aMezcla,{'(CODIGO)',cCodigo})
       AADD(aMezcla,{'(NIVEL)',cNomNiv(cCodNiv)})
       AADD(aMezcla,{'(ANO)',cAnoUsr})
       AADD(aMezcla,{'(JORNADA)',cJorTxt})

       FOR i := 1 TO LEN(aMezIni)
	   AADD(aMezcla,{aMezIni[i,1],aMezIni[i,2]})
       NEXT
*>>>>FIN CAMPOS DE SUSTITUCION

*>>>>IMPRESION DEL DOCUMENTO
       DO WHILE !Printer_on(MTR->lPrnArcMtr); ENDDO
       PrnFileDoc('Bases\FrmAdm'+cNroDoc+'.Txt',aMezcla,;
		   NIL,NIL,NIL,lOficio)
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DEL DOCUMENTO
