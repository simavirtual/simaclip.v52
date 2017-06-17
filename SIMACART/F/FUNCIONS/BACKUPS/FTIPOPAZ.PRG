/*               	 SISTEMA CARTERA ACADEMICA
	      BIBLIOTECAS DE FUNCIONES PARA LOS RECIBOS DE PAZ Y SALVOS

REQUERIMIENTOS:

- Compilar: clipper FuncsPaz /w/m/b

OBJETIVOS:

- Funciones aplicadas para todos los recibos de paz y salvos de los
  diferentes colegios.

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DEL PROGRAMA..: RECIBO DE PAZ Y SALVO No. 01                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 31/97 VIE A
       Bucaramanga, Colombia        INICIO: 11:50 AM   OCT 31/97 VIE

OBJETIVOS:

1- Imprime el recibo de paz y salvo.

2- El recibo se imprime dos por tama¤o carta todo impreso.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/


FUNCTION PazSalvo01(cNomEmp,cNomSec,cNomSis,cAnoUsr,cJorTxt,cMaeAct,;
		    cCodEst,cNomEst,cCodGru,cNroLis,aFirmas,dFecPaz,;
		    nSdoAct,cObsTxt,lMatric,cCodIso,aTitIso,aPieIso)

*>>>>DESCRIPCION DE PARAMETROS
/*     cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       cNomSis                              // Nombres del Sistema
       cAnoUsr                              // A¤o del sistema
       cJorTxt                              // Jornada escogida
       cMaeAct			            // Maestro Actual
       cCodEst                              // C¢digo del Estudiante
       cNomEst                              // Nombre del Estudiante
       cCodGru                              // C¢digo del Grupo
       cNroLis                              // N£mero de lista
       aFirmas                              // Firmantes del Paz y Salvo
       dFecPaz                              // Fecha del Paz y Salvo
       nSdoAct                              // Saldo Actual
       cObsTxt                              // Observaci¢n
       lMatric                              // .T. Matricula .F. Prematricula
       cCodIso                              // C¢digo Iso del Informe
       aTitIso                              // T¡tulo Iso del Informe
       aPieIso       	                    // Textos del pie de p gina */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"               // Impresora EPSON FX

       LOCAL nLinFec := 4                   // L¡neas para la fecha
       LOCAL nNroCol := 0                   // N£mero de Columnas
       LOCAL cTxtPrn := ''                  // Texto de Impresi¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DEL PAZ Y SALVO
       IF LEN(cNomEmp) <= 40

	  nNroCol := ((40-LEN(ALLTRIM(cNomEmp))))/2

	  SendCodes(PCL('DobAncOn'))
	  @ PROW(),nNroCol SAY cNomEmp
	  SendCodes(PCL('DobAncOf'))

       ELSE
	  nNroCol := ((80-LEN(ALLTRIM(cNomEmp))))/2
	  @ PROW(),nNroCol SAY cNomEmp
       ENDIF

       IF EMPTY(aFirmas[4]) .AND. EMPTY(aFirmas[5]) .AND.;
	  EMPTY(aFirmas[6])

	  cTxtPrn := 'JORNADA: '+cJorTxt
	  nNroCol := ((80-LEN(cTxtPrn)))/2
	  @ PROW()+2,nNroCol SAY cTxtPrn

	  cTxtPrn := 'A¥O: '+cAnoUsr
	  nNroCol := ((80-LEN(cTxtPrn)))/2
	  @ PROW()+2,nNroCol SAY cTxtPrn

       ELSE

	  cTxtPrn := 'JORNADA: '+cJorTxt+;
		     '. A¥O: '+cAnoUsr
	  nNroCol := ((80-LEN(cTxtPrn)))/2
	  @ PROW()+2,nNroCol SAY cTxtPrn

	  SendCodes(PCL('CondenOn'))
	  @ PROW(),90 SAY cCodIso
	  SendCodes(PCL('CondenOf'))

	  cTxtPrn := 'PAZ Y SALVO'
	  nNroCol := ((80-LEN(cTxtPrn)))/2
	  @ PROW()+2,nNroCol SAY cTxtPrn

       ENDIF

       cTxtPrn := 'ALUMNO(A): '+cNomEst
       @ PROW()+3,02 SAY cTxtPrn

       @ PROW()+1,02 SAY 'CODIGO: '+cCodEst+;
			 ' CURSO: '+cCodGru+' No.'+cNroLis
     *ÀImpresi¢n del encabezado.

       IF !EMPTY(aFirmas)
	  @ PROW()+4,02 SAY IF(EMPTY(aFirmas[1]),SPACE(22),REPL('_',22))+;
			    IF(EMPTY(aFirmas[2]),SPACE(26),;
			       SPACE(04)+REPL('_',22))+;
			    IF(EMPTY(aFirmas[3]),SPACE(22),;
			       SPACE(04)+REPL('_',22))

	  @ PROW()+1,02 SAY IF(EMPTY(aFirmas[1]),SPACE(22),aFirmas[1])+;
			    IF(EMPTY(aFirmas[2]),SPACE(26),SPACE(04)+aFirmas[2])+;
			    IF(EMPTY(aFirmas[3]),SPACE(22),SPACE(04)+aFirmas[3])

	  IF EMPTY(aFirmas[4]) .AND. EMPTY(aFirmas[5]) .AND.;
	     EMPTY(aFirmas[6])

	     lMatric := IF(lMatric==NIL,.T.,lMatric)
	     IF lMatric
		nNroCol := ((40-LEN(ALLTRIM('PAZ Y SALVO'))))/2
	     ELSE
		nNroCol := ((40-LEN(ALLTRIM('PAZ Y SALVO PRE-MATRICULA'))))/2
	     ENDIF

	     SendCodes(PCL('DobAncOn'))
	     IF lMatric
		@ PROW()+4,nNroCol SAY 'PAZ Y SALVO'
	     ELSE
		@ PROW()+4,nNroCol SAY 'PAZ Y SALVO PRE-MATRICULA'
	     ENDIF
	     SendCodes(PCL('DobAncOf'))
	     @ PROW()+3,00 SAY ''
	     nLinFec := 3

	  ELSE

	     @ PROW()+4,02 SAY IF(EMPTY(aFirmas[4]),;
				  SPACE(22),REPL('_',22))+;
			       IF(EMPTY(aFirmas[5]),;
				  SPACE(26),SPACE(04)+REPL('_',22))+;
			       IF(EMPTY(aFirmas[6]),;
				  SPACE(22),SPACE(04)+REPL('_',22))

	     @ PROW()+1,02 SAY IF(EMPTY(aFirmas[4]),;
				  SPACE(22),aFirmas[4])+;
			       IF(EMPTY(aFirmas[5]),;
				  SPACE(26),SPACE(04)+aFirmas[5])+;
			       IF(EMPTY(aFirmas[6]),;
				  SPACE(22),SPACE(04)+aFirmas[6])
	  ENDIF

	  @ PROW()+4,02 SAY IF(EMPTY(aFirmas[7]),SPACE(22),REPL('_',22))+;
			    IF(EMPTY(aFirmas[8]),SPACE(26),;
			       SPACE(04)+REPL('_',22))+;
			    IF(EMPTY(aFirmas[9]),SPACE(22),;
			       SPACE(04)+REPL('_',22))

	  @ PROW()+1,02 SAY IF(EMPTY(aFirmas[7]),SPACE(22),aFirmas[7])+;
			    IF(EMPTY(aFirmas[8]),SPACE(26),SPACE(04)+aFirmas[8])+;
			    IF(EMPTY(aFirmas[9]),SPACE(22),SPACE(04)+aFirmas[9])


       ENDIF

       cTxtPrn := 'FECHA DE IMPRESION: '+;
		  IF(nSdoAct==0,'','*')+cFecha(dFecPaz,3)
       @ PROW()+nLinFec,02 SAY cTxtPrn

       cObsTxt := aPieIso[3]

       SendCodes(PCL('CondenOn'))
       nNroCol := ((137-LEN(ALLTRIM(cObsTxt))))/2
       @ PROW()+2,nNroCol SAY cObsTxt
       SendCodes(PCL('CondenOf'))
       RETURN NIL
*>>>>FIN IMPRESION DEL PAZ Y SALVO

/*************************************************************************
* TITULO DEL PROGRAMA..: RECIBO DE PAZ Y SALVO No. 02                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 13/98 MAR A
       Bucaramanga, Colombia        INICIO: 11:50 AM   OCT 13/98 MAR

OBJETIVOS:

1- Imprime el recibo de paz y salvo.

2- El recibo se imprime tres por tama¤o carta todo impreso.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/


FUNCTION PazSalvo02(cNomEmp,cNomSec,cNomSis,cAnoUsr,cJorTxt,cMaeAct,;
		    cCodEst,cNomEst,cCodGru,cNroLis,aFirmas,dFecPaz,;
		    nSdoAct,lMatric)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       cNomSis                              // Nombres del Sistema
       cAnoUsr                              // A¤o del sistema
       cJorTxt                              // Jornada escogida
       cMaeAct			            // Maestro Actual
       cCodEst                              // C¢digo del Estudiante
       cNomEst                              // Nombre del Estudiante
       cCodGru                              // C¢digo del Grupo
       cNroLis                              // N£mero de lista
       aFirmas                              // Firmantes del Paz y Salvo
       dFecPaz                              // Fecha del Paz y Salvo
       nSdoAct                              // Saldo Actual
       lMatric                              // .T. Matricula .F. Prematricula */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
*       #INCLUDE "EPSONFX.PRG"               // Impresora EPSON FX

       LOCAL nLinFec := 6                   // L¡neas para la fecha
       LOCAL nNroCol := 0                   // N£mero de Columnas
       LOCAL cTxtPrn := ''                  // Texto de Impresi¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DEL PAZ Y SALVO
       nNroCol := ((80-LEN(ALLTRIM(cNomEmp))))/2
       @ PROW(),nNroCol SAY cNomEmp

       nNroCol := ((80-LEN(ALLTRIM(cNomSec))))/2
       @ PROW()+1,nNroCol SAY cNomSec

       cTxtPrn := 'JORNADA: '+cJorTxt+;
		  '. A¥O: '+cAnoUsr
       nNroCol := ((80-LEN(cTxtPrn)))/2
       @ PROW()+2,nNroCol SAY cTxtPrn


       cTxtPrn := cNomEst
       @ PROW()+2,02 SAY cTxtPrn

       cTxtPrn := 'CODIGO: '+cCodEst+;
		  ' CURSO: '+cCodGru+' No.'+cNroLis
       nNroCol := ((80-LEN(cTxtPrn)))/2
       @ PROW()+2,nNroCol SAY cTxtPrn
     *ÀImpresi¢n del encabezado.

       lMatric := IF(lMatric==NIL,.T.,lMatric)
       IF lMatric
	  nNroCol := ((80-LEN(ALLTRIM('P A Z  Y  S A L V O'))))/2
	  @ PROW()+4,nNroCol SAY 'P A Z  Y  S A L V O'
       ELSE
	  nNroCol := ((80-LEN(ALLTRIM('P A Z  Y  S A L V O  '+;
				      'P R E - M A T R I C U L A'))))/2

	  @ PROW()+4,nNroCol SAY 'P A Z  Y  S A L V O  '+;
				 'P R E - M A T R I C U L A'
       ENDIF
       @ PROW()+3,00 SAY ''


       nLinFec := 2
       cTxtPrn := IF(nSdoAct==0,'','*')+cFecha(dFecPaz,3)

       @ PROW()+nLinFec,02 SAY cTxtPrn

       @ PROW()+00,30 SAY ALLTRIM(SCO->cGerentCon)
       @ PROW()+01,30 SAY ALLTRIM(SCO->cCarGerCon)
       RETURN NIL
*>>>>FIN IMPRESION DEL PAZ Y SALVO

