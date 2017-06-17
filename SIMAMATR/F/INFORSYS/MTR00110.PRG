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

FUNCTION Mtr_001_10(cCodigo,cCodNiv,cNombre,cApelli,lExAlum,;
		    cNomSis,cNomEmp,cAnoUsr,lRapido,cObsUno,;
		    cObsDos,cObsTre,cJorTxt,cObsInc,;
		    aMarInf,cCodIso,aTitIso,aPieIso,aObsIso)

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
       cObsInc                              // Observaci¢n de la Inscripci¢n
       aMarInf			            // Margenes del informe
       cCodIso                              // C¢digo Iso del Informe
       aTitIso                              // T¡tulo Iso del Informe
       aPieIso      		            // Textos del pie de p gina
       aObsIso                              // Observaciones del informe */
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

       @ PROW()+1,01 SAY 'DATOS PERSONALES: '
       ForPrnEst()

       @ PROW()+1,01 SAY 'DATOS FAMILIARES: '
       ForPrnPad()

       @ PROW()+1,01 SAY ''
       ForPrnMad()

       @ PROW()+1,01 SAY ''
       ForPrnAcu()
*>>>>FIN DETALLES FAMILIARES

*>>>>COLEGIO DE PROCEDENCIA
       @ PROW()+1,01 SAY ''
       @ PROW()+1,01 SAY 'DATOS ESCOLARES DEL ASPIRANTE:'
       LineaPrn({'COLEGIO DE PROCEDENCIA' ,REPL('_',36),;
		 'CIUDAD'                 ,REPL('_',23)},1)
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

       LineaPrn({'MATRICULARSE EN FECHA ',REPL('_',49),;
		 'HORA'                  ,REPL('_',12)},2)
*>>>>FIN OBSERVACIONES

*>>>>CITACION PARA EXAMEN
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
*>>>>FIN CITACION PARA EXAMEN

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