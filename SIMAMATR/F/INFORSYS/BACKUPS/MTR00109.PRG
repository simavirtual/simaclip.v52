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

FUNCTION Mtr_001_09(cCodigo,cCodNiv,cNombre,cApelli,lExAlum,;
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

       @ PROW()+1,01 SAY ''
       ForPrnEst()
       LineaPrn({'SACRAMENTOS QUE HA RECIBIDO: BAUTISMO:',REPL('_',02),;
		 'PRIMERA COMUNION:'                     ,REPL('_',02),;
		 'CONFIRMACION:'                         ,REPL('_',13)})

       LineaPrn({'EL ESTUDIANTE RESIDE: PADRES:',REPL('_',02),;
		 'PADRE:'                       ,REPL('_',02),;
		 'MADRE:'                       ,REPL('_',02),;
		 'HNOS:'                        ,REPL('_',02),;
		 'OTROS:'                       ,REPL('_',02),;
		 'CUAL:'                        ,REPL('_',12)})

       @ PROW()+1,01 SAY ''
       ForPrnPad()
       LineaPrn({'RELIGION QUE PROFESA:',REPL('_',68)})

       @ PROW()+1,01 SAY ''
       ForPrnMad()
       LineaPrn({'RELIGION QUE PROFESA:',REPL('_',68)})

       LineaPrn({'MATRIMONIO: ECLECIASTICO:',REPL('_',04),;
		 'CIVIL:'                   ,REPL('_',04),;
		 'UNION LIBRE:'             ,REPL('_',04),;
		 'OTRO:'                    ,REPL('_',23)})

       @ PROW()+1,01 SAY ''
       ForPrnAcu()
*>>>>FIN DETALLES FAMILIARES

*>>>>COLEGIO DE PROCEDENCIA
       @ PROW()+1,01 SAY ''
       LineaPrn({'COLEGIO DE PROCEDENCIA' ,REPL('_',36),;
		 'CIUDAD'                 ,REPL('_',23)})
       LineaPrn({'                      ' ,REPL('_',36),;
		 'CIUDAD'                 ,REPL('_',23)})

       LineaPrn({'PORQUE ASPIRA A ENTRAR A ESTE COLEGIO:' ,REPL('_',51)})
       LineaPrn({'',REPL('_',89)})
*>>>>FIN COLEGIO DE PROCEDENCIA

*>>>>FAMILIARES EN EL COLEGIO
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
*>>>>FIN FAMILIARES EN EL COLEGIO

*>>>>REFERENCIAS PERSONALES
       LineaPrn({'REFERENCIAS PERSONALES:',REPL('',01)},2)
       LineaPrn({'ESCRIBA EL NOMBRE DE DOS PERSONAS,'+;
		 'OJALA VINCULADAS DE ALGUNA MANERA CON EL COLEGIO'})
       LineaPrn({REPL('_',60),'TELEFONO:',REPL('_',19)})
       LineaPrn({REPL('_',60),'TELEFONO:',REPL('_',19)})
*>>>>FIN REFERENCIAS PERSONALES

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