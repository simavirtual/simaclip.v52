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

FUNCTION Mtr_001_99(cCodigo,cCodNiv,cNombre,cApelli,;
		    lExAlum,cAnoUsr,cJorTxt,cObsInc,;
		    nNroDoc)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodigo                              // C¢digo de la Solicitud
       cCodNiv			            // C¢digo del Nivel
       cNombre                              // Nombres del aspirante
       cApelli                              // Apellidos del aspirante
       lExAlum                              // .T. Ex-Alumno
       cAnoUsr                              // A¤o del usuario
       cJorTxt                              // Jornada escogida
       cObsInc                              // Observaci¢n de la Inscripci¢n
       nNroDoc                              // N£mero del Documento */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador

       LOCAL cNroDoc := ''                  // N£mero del Documento
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
       cNroDoc := STR(nNroDoc,2)
       lCorrecion(@cNroDoc)

       DO WHILE !Printer_on(MTR->lPrnArcMtr); ENDDO
       PrnFileDoc('Bases\FrmAdm'+cNroDoc+'.Txt',aMezcla,;
		   NIL,NIL,NIL,lOficio)
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DEL DOCUMENTO