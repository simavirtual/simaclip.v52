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

FUNCTION Mtr_001_06(cCodigo,cCodNiv,cNombre,cApelli,lExAlum,;
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
       aMarInf			            // L¡neas de espaciado
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

       SendCodes(PCL({'Reset','Oficio',;
		      'GraphiOn','CondenOf','ProporOf','DraftOn'}))

       IF ANO->lPrnEmpAno
	  SendCodes(PCL({'DobAncOn','DobAltOn'}))
	  @ PROW(),00 SAY cNomEmp
	  SendCodes(PCL({'DobAncOf','DobAltOf'}))
       ENDIF

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
       @ PROW()+1,01 SAY 'NOMBRE: '+RTRIM(cApelli)+' '+cNombre+' '+;
			 'SEXO: M__ F__'

       @ PROW()+1,01 SAY ''
       ForPrnEst()

       @ PROW()+1,01 SAY ''
       ForPrnPad()

       @ PROW()+1,01 SAY ''
       ForPrnMad()

       @ PROW()+1,01 SAY ''
       ForPrnAcu()
*>>>>FIN DETALLES FAMILIARES

*>>>>COLEGIO DE PROCEDENCIA
       LineaPrn({'COLEGIO DE PROCEDENCIA' ,REPL('_',36),;
		 'CIUDAD'                 ,REPL('_',23)},2)
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
*>>>>FIN FAMILIARES EN EL COLEGIO

*>>>>COLEGIOS DE PROCEDENCIA
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
*>>>>FIN COLEGIOS DE PROCEDENCIA

*>>>>OBSERVACIONES
       IF EMPTY(cObsInc)
	  LineaPrn({'OBSERVACIONES: ',REPL('_',74)},2)
       ELSE
	  @ PROW()+2,00 SAY 'OBSERVACIONES: '
	  SendCodes(PCL('CondenOn'))
	  @ PROW(),25 SAY cObsInc
	  SendCodes(PCL('CondenOf'))
       ENDIF
*>>>>FIN OBSERVACIONES

*>>>>FIRMAS DEL FORMULARIO
       LineaPrn({'RECTOR(A):',REPL('_',26)+SPACE(02),;
		 'PSICOORIENTADOR(A):',REPL('_',30)},2)
*>>>>FIN FIRMAS DEL FORMULARIO

*>>>>CITACION PARA EXAMEN
       LineaPrn({'ENTREVISTA EL DIA',REPL('_',49),;
		 'HORA',REPL('_',11)},2)

       LineaPrn({'EVALUACION EL DIA',REPL('_',49),;
		 'HORA',REPL('_',11)},1)
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