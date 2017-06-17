/*************************************************************************
* TITULO ..: INFORMES DEL SISTEMA                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 13/2007 JUE A
       Colombia, Bucaramanga        INICIO: 04:20 PM   SEP 13/2007 JUE

OBJETIVOS:

1- Registra los informes del sistema

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MtrInfSys(lShared,cNomUsr,cCodSui)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cNomUsr                              // Nombre del Usuario
       cCodSui                              // C¢digo del Sistema */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador

       LOCAL nOrdInf := 0                   // Orden del Informe
       LOCAL nNroInf := 0                   // N£mero del Informe
       LOCAL cCodInf := ''                  // C¢digo del Informe
       LOCAL cTitulo := ''                  // T¡tulo del Informe
       LOCAL cObsInf := ''                  // Observaci¢n del Informe
       LOCAL lInfVar := .F.                 // Informe variable

       LOCAL aInfSys := {}                  // Informes del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>INFORME DEL SISTEMA
       nOrdInf := 1
       nNroInf := 001
       cCodInf := 'Mtr00100'
       cTitulo := 'INFORMES DEL SISTEMA'
       cObsInf := 'Informes del Sistema'
       lInfVar := .F.
       AADD(aInfSys,{nOrdInf,nNroInf,cCodInf,cTitulo,cObsInf,lInfVar})
     *ÀDefinici¢n del informe.

       nOrdInf := 2
       nNroInf := 002
       cCodInf := 'Mtr00200'
       cTitulo := 'INFORMES CONTROLADOS'
       cObsInf := 'Informes Controlados'
       lInfVar := .F.
       AADD(aInfSys,{nOrdInf,nNroInf,cCodInf,cTitulo,cObsInf,lInfVar})
     *ÀDefinici¢n del informe.

       nOrdInf := 3
       nNroInf := 101
       cCodInf := 'MTR00101'
       cTitulo := 'SOLICITUD DE CUPO No. 1'
       cObsInf := 'Solicitud por defecto'
       lInfVar := .F.
       AADD(aInfSys,{nOrdInf,nNroInf,cCodInf,cTitulo,cObsInf,lInfVar})
     *ÀDefinici¢n del informe.

       nOrdInf := 4
       nNroInf := 101
       cCodInf := 'MTR00102'
       cTitulo := 'SOLICITUD DE CUPO No. 2'
       cObsInf := 'Hoja Oficio, Solicita Ingreso mensual'
       lInfVar := .F.
       AADD(aInfSys,{nOrdInf,nNroInf,cCodInf,cTitulo,cObsInf,lInfVar})
     *ÀDefinici¢n del informe.

       nOrdInf := 5
       nNroInf := 101
       cCodInf := 'MTR00103'
       cTitulo := 'SOLICITUD DE CUPO No. 3'
       cObsInf := 'Solicita colegios de procedencia'
       lInfVar := .F.
       AADD(aInfSys,{nOrdInf,nNroInf,cCodInf,cTitulo,cObsInf,lInfVar})
     *ÀDefinici¢n del informe.

       nOrdInf := 6
       nNroInf := 101
       cCodInf := 'MTR00104'
       cTitulo := 'SOLICITUD DE CUPO No. 4'
       cObsInf := 'Solicita firma de rector y Psicoorientador'
       lInfVar := .F.
       AADD(aInfSys,{nOrdInf,nNroInf,cCodInf,cTitulo,cObsInf,lInfVar})
     *ÀDefinici¢n del informe.

       nOrdInf := 7
       nNroInf := 101
       cCodInf := 'MTR00105'
       cTitulo := 'SOLICITUD DE CUPO No. 5'
       cObsInf := 'Solicita foto'
       lInfVar := .F.
       AADD(aInfSys,{nOrdInf,nNroInf,cCodInf,cTitulo,cObsInf,lInfVar})
     *ÀDefinici¢n del informe.

       nOrdInf := 8
       nNroInf := 101
       cCodInf := 'MTR00106'
       cTitulo := 'SOLICITUD DE CUPO No. 6'
       cObsInf := 'Hoja Oficio, Colegio de Procedencia,'+;
		  'firma de rector y Psicoorientador'
       lInfVar := .F.
       AADD(aInfSys,{nOrdInf,nNroInf,cCodInf,cTitulo,cObsInf,lInfVar})
     *ÀDefinici¢n del informe.

       nOrdInf := 9
       nNroInf := 101
       cCodInf := 'MTR00107'
       cTitulo := 'SOLICITUD DE CUPO No. 7'
       cObsInf := 'Solicita informaci¢n sobre enfermedades y religi¢n'
       lInfVar := .F.
       AADD(aInfSys,{nOrdInf,nNroInf,cCodInf,cTitulo,cObsInf,lInfVar})
     *ÀDefinici¢n del informe.

       nOrdInf := 10
       nNroInf := 101
       cCodInf := 'MTR00108'
       cTitulo := 'SOLICITUD DE CUPO No. 8'
       cObsInf := 'Solicitud alternativo por defecto'
       lInfVar := .F.
       AADD(aInfSys,{nOrdInf,nNroInf,cCodInf,cTitulo,cObsInf,lInfVar})
     *ÀDefinici¢n del informe.

       nOrdInf := 11
       nNroInf := 101
       cCodInf := 'MTR00109'
       cTitulo := 'SOLICITUD DE CUPO No. 9'
       cObsInf := 'Solicita informaci¢n religiosa, estado civil,'+;
		  'referencias personales'
       lInfVar := .F.
       AADD(aInfSys,{nOrdInf,nNroInf,cCodInf,cTitulo,cObsInf,lInfVar})
     *ÀDefinici¢n del informe.

       nOrdInf := 12
       nNroInf := 101
       cCodInf := 'MTR00110'
       cTitulo := 'SOLICITUD DE CUPO No. 10'
       cObsInf := 'Solicita foto, pendiente por modificar'
       lInfVar := .F.
       AADD(aInfSys,{nOrdInf,nNroInf,cCodInf,cTitulo,cObsInf,lInfVar})
     *ÀDefinici¢n del informe.

       nOrdInf := 13
       nNroInf := 101
       cCodInf := 'MTR00199'
       cTitulo := 'SOLICITUD DE CUPO No. 99'
       cObsInf := 'Solicitud configurable de un archivo plano'
       lInfVar := .T.
       AADD(aInfSys,{nOrdInf,nNroInf,cCodInf,cTitulo,cObsInf,lInfVar})
     *ÀDefinici¢n del informe.

       nOrdInf := 14
       nNroInf := 102
       cCodInf := 'MTR00201'
       cTitulo := 'RELACION DE INSCRITOS POR CEDULAS'
       cObsInf := 'Cedulas de Inscriptos para realizar consultas'
       lInfVar := .F.
       AADD(aInfSys,{nOrdInf,nNroInf,cCodInf,cTitulo,cObsInf,lInfVar})
     *ÀDefinici¢n del informe.
*>>>>FIN INFORME DEL SISTEMA

*>>>>GRABACION DE LOS INFORMES
       FOR i := 1 TO LEN(aInfSys)

***********DETALLES DEL INFORME
	     nOrdInf := aInfSys[i,1]
	     nNroInf := aInfSys[i,2]
	     cCodInf := aInfSys[i,3]
	     cTitulo := aInfSys[i,4]
	     cObsInf := aInfSys[i,5]
	     lInfVar := aInfSys[i,6]
***********FIN DETALLES DEL INFORME

***********GRABACION DEL INFORME
	     IF nInsInfSys(lShared,cNomUsr,cCodInf,cTitulo,;
		cObsInf,nOrdInf,nNroInf,cCodSui,lInfVar) == 0


		cError('PROBLEMAS CON EL INFORME: '+cCodInf,;
		       'ERROR GRAVE. Tome Nota',;
		       'FAVOR INFORMAR')
		RETURN NIL
	     ENDIF
***********FIN GRABACION DEL INFORME

       ENDFOR
       RETURN NIL
*>>>>FIN GRABACION DE LOS INFORMES

