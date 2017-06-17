/*************************************************************************
* TITULO ..: INFORMES DEL SISTEMA                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MES 99/9999 DIA A
       Colombia, Bucaramanga        INICIO: 99:99 AM   MES 99/9999 DIA

OBJETIVOS:

1- Registra los informes del sistema

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ScoInfSys(lShared,cNomUsr,cCodSui)

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
       cCodInf := 'SCO00100'
       cTitulo := 'INFORMES DEL SISTEMA'
       cObsInf := 'Informes del Sistema'
       lInfVar := .F.
       AADD(aInfSys,{nOrdInf,nNroInf,cCodInf,cTitulo,cObsInf,lInfVar})
     *ÀDefinici¢n del informe.

       nOrdInf := 2
       nNroInf := 002
       cCodInf := 'SCO00200'
       cTitulo := 'INFORMES CONTROLADOS'
       cObsInf := 'Informes Controlados'
       lInfVar := .F.
       AADD(aInfSys,{nOrdInf,nNroInf,cCodInf,cTitulo,cObsInf,lInfVar})
     *ÀDefinici¢n del informe.

       nOrdInf := 3
       nNroInf := 412
       cCodInf := 'SCO41200'
       cTitulo := 'INDICADORES PENDIENTES'
       cObsInf := 'Indicadores Pendientes'
       lInfVar := .F.
       AADD(aInfSys,{nOrdInf,nNroInf,cCodInf,cTitulo,cObsInf,lInfVar})
     *ÀDefinici¢n del informe.

       nOrdInf := 4
       nNroInf := 404
       cCodInf := 'SCO40400'
       cTitulo := 'CLASIFICACION DE INDICADORES'
       cObsInf := 'Clasificaci¢n de Indicadores'
       lInfVar := .F.
       AADD(aInfSys,{nOrdInf,nNroInf,cCodInf,cTitulo,cObsInf,lInfVar})
     *ÀDefinici¢n del informe.

       nOrdInf := 5
       nNroInf := 622
       cCodInf := 'SCO62200'
       cTitulo := 'PAZ Y SALVO'
       cObsInf := 'Paz y Salvo'
       lInfVar := .F.
       AADD(aInfSys,{nOrdInf,nNroInf,cCodInf,cTitulo,cObsInf,lInfVar})
     *ÀDefinici¢n del informe.

       nOrdInf := 6
       nNroInf := 765
       cCodInf := 'SCO76500'
       cTitulo := 'CLASE DE INDICADORES'
       cObsInf := 'Clase de Indicadores'
       lInfVar := .F.
       AADD(aInfSys,{nOrdInf,nNroInf,cCodInf,cTitulo,cObsInf,lInfVar})
     *ÀDefinici¢n del informe.

       nOrdInf := 7
       nNroInf := 773
       cCodInf := 'SCO77300'
       cTitulo := 'NUMERO DE INDICADORES'
       cObsInf := 'Control del Total de Indicadores'
       lInfVar := .F.
       AADD(aInfSys,{nOrdInf,nNroInf,cCodInf,cTitulo,cObsInf,lInfVar})
     *ÀDefinici¢n del informe.

       nOrdInf := 8
       nNroInf := 774
       cCodInf := 'SCO77400'
       cTitulo := 'INDICADORES FINALES'
       cObsInf := 'Indicadores Finales'
       lInfVar := .F.
       AADD(aInfSys,{nOrdInf,nNroInf,cCodInf,cTitulo,cObsInf,lInfVar})
     *ÀDefinici¢n del informe.

       nOrdInf := 9
       nNroInf := 254
       cCodInf := 'SCO25400'
       cTitulo := 'VALIDACION DEL CALCULO DE LAS AREAS'
       cObsInf := 'Informe de validaci¢n del Calculo de las Areas'
       lInfVar := .F.
       AADD(aInfSys,{nOrdInf,nNroInf,cCodInf,cTitulo,cObsInf,lInfVar})
     *ÀDefinici¢n del informe.

       nOrdInf := 10
       nNroInf := 502
       cCodInf := 'SCO50200'
       cTitulo := 'RELACION DE REPROBADOS'
       cObsInf := 'Informe de los estudiantes reprobados'
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

