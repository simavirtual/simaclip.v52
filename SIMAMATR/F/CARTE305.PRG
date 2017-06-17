/* SIMA - MATRICULA ACADEMICA

MODULO      : CITACION
SUBMODULO...: FECHA DE CITA          MODULO No. 304

**************************************************************************
* NOMBRE DEL PROGRAMA..: MATRI304.PRG                                    *
* TITULO DEL PROGRAMA..: GRABACION DE FECHAS DE CITAS A ENTREVISTAS      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 25/96 JUE A
       Colombia, Bucaramanga        INICIO: 10:00 AM   JUL 25/96 JUE


REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Permite imprimir los recibos de los canditados a entrevistar

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_305(lShared,nFilInf,nColInf,nFilPal,cNomEmp,cNomSis,cNomUsr,;
		   cAnoUsr,cPatSis,lIntUno,lIntDos,lIntTre,lIntCua,cMaeAlu,;
		   cJorTxt,cMaeAct)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del Sistema
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       lIntUno                              // Primera Integraci¢n
       lIntDos                              // Segunda Integraci¢n
       lIntTre                              // Tercera Integraci¢n
       lIntCua                              // Cuarta Integraci¢n
       cMaeAlu                              // Maestros habilitados
       cJorTxt                              // Jornada escogida
       cMaeAct                              // Maestro Activo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>IMPRESION DEL CUERPO DEL INFORME
       cHorEnt := IF(cHorPar == '00:00:00',cHorIni,cHorPar)
       dFecEnt := dFecIni
       nNroEnt := IF(EMPTY(nGruIni),0,IF(nGruIni==1,nGruIni+1,nGruIni-1))

       nNroRec := 0
       aDetCan := {}
       DO WHILE .NOT. EOF()

**********LECTURA DEL NOMBRE DEL ESTUDIANTE
	    cNombreTad = RTRIM(ADM->cApelliAdm)+' '+;
			       ADM->cNombreAdm+SPACE(10)
	    IF 'ANULADO' $ UPPER(cNombreTad)
	       SELECT ADM
	       SKIP
	       LOOP
	    ENDIF
**********FIN LECTURA DEL NOMBRE DEL ESTUDIANTE

**********IMPRESION DEL CONTENIDO DEL INFORME
	    nNroEnt++
	    nNroRec++
	    IF nNroRec <= 3
	       AADD(aDetCan,{ADM->cCodigoAdm,;
			     cNombreTad,;
			     dFecEnt,;
			     cHorEnt})
	    ENDIF
**********FIN IMPRESION DEL CONTENIDO DEL INFORME

**********IMPRESION DE LA CITA
	    IF nNroRec == 3
	       Cita(cNomEmp,SUBS(cNivels,8*(nNroNiv+1)-7,8),aDetCan)
	       EJECT
	       nNroRec := 0
	       aDetCan := {}
	    ENDIF
**********FIN IMPRESION DE LA CITA

**********CALCULA DE LA FECHA Y HORA DE ENTREVISTA
	    lMisHor := .F.
	    lMisFec := .F.
	    IF nNroEnt >= nEntrev
	       nNroEnt := 0
	       cHorEnt := SECTOTIME(TIMETOSEC(cHorEnt)+nMinEnt*60)
	       IF cHorEnt == cHorFin
		  cHorEnt := cHorIni
		  dFecEnt++
		  DO CASE
		  CASE DOW(dFecEnt) == 7
		       dFecEnt := dFecEnt + 2
		  CASE DOW(dFecEnt) == 1
		       dFecEnt++
		  ENDCASE
	       ENDIF
	    ELSE
	       lMisHor := .T.
	       lMisFec := .T.
	    ENDIF
**********FIN CALCULA DE LA FECHA Y HORA DE ENTREVISTA



	  SKIP

       ENDDO
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DE LA ULTIMA CITA
       IF LEN(aDetCan) # 0
	  Cita(cNomEmp,SUBS(cNivels,8*(nNroNiv+1)-7,8),aDetCan)
       ENDIF

       SET DEVICE TO SCREEN
       SET FILTER TO
       CLOSE ALL
       RETURN NIL
*>>>>FIN IMPRESION DE LA ULTIMA CITA


/*************************************************************************
* TITULO DE LA FUNCION..: IMPRESION DE RECIBO DE PAGO                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 13/94 SAB A
						       AGO 13/94 SAB
OBJETIVOS:

1- Permite imprimir los recibos sencillos o los recibos por adelantado
   de acuerdo como se pasen los parametros de la funci¢n.

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Retorna el total de recibo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Cita(cNomEmp,cNomNiv,aDetCan)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomEmp                              // Nombre de la empresa
       cNomNiv                              // Nombre del nivel
       aDetCan                              // Detalles de los candidatos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>IMPRESION DEL NOMBRE DE LA EMPRESA
       nNroRec := LEN(aDetCan)

       IF nNroRec >= 1
	   @ PROW()+00,003 SAY cNomEmp
       ENDIF

       IF nNroRec >= 2
	   @ PROW()+00,058 SAY cNomEmp
       ENDIF

       IF nNroRec == 3
	   @ PROW()+00,116 SAY cNomEmp
       ENDIF

       cTxtPrn := 'CITACION A ENTREVISTA '
       IF nNroRec >= 1
	   @ PROW()+02,003 SAY cTxtPrn
       ENDIF

       IF nNroRec >= 2
	   @ PROW()+00,058 SAY cTxtPrn
       ENDIF

       IF nNroRec == 3
	   @ PROW()+00,116 SAY cTxtPrn
       ENDIF

       cTxtPrn := 'PARA EL GRADO '
       IF nNroRec >= 1
	   @ PROW()+01,003 SAY cTxtPrn+cNomNiv
       ENDIF

       IF nNroRec >= 2
	   @ PROW()+00,058 SAY cTxtPrn+cNomNiv
       ENDIF

       IF nNroRec >= 3
	   @ PROW()+00,116 SAY cTxtPrn+cNomNiv
       ENDIF

       cTxtPrn := 'INSCRIPCION No. '

       IF nNroRec >= 1
	   @ PROW()+02,003 SAY cTxtPrn+aDetCan[1,1]
       ENDIF

       IF nNroRec >= 2
	   @ PROW()+00,058 SAY cTxtPrn+aDetCan[2,1]
       ENDIF

       IF nNroRec == 3
	   @ PROW()+00,116 SAY cTxtPrn+aDetCan[3,1]
       ENDIF

       cTxtPrn := 'NOMBRE: '

       IF nNroRec >= 1
	   @ PROW()+01,003 SAY cTxtPrn+aDetCan[1,2]
       ENDIF

       IF nNroRec >= 2
	   @ PROW()+00,058 SAY cTxtPrn+aDetCan[2,2]
       ENDIF

       IF nNroRec == 3
	   @ PROW()+00,116 SAY cTxtPrn+aDetCan[3,2]
       ENDIF

       cTxtPrn := 'FECHA: '
       IF nNroRec >= 1
	   dFecEnt := aDetCan[1,3]
	   cFecEnt := cFecha(dFecEnt)+' '+cDia(DOW(dFecEnt))+' '
	   @ PROW()+02,003 SAY cTxtPrn+cFecEnt
       ENDIF

       IF nNroRec >= 2
	  dFecEnt := aDetCan[2,3]
	  cFecEnt := cFecha(dFecEnt)+' '+cDia(DOW(dFecEnt))+' '
	  @ PROW()+00,058 SAY cTxtPrn+cFecEnt
       ENDIF

       IF nNroRec == 3
	   dFecEnt := aDetCan[3,3]
	   cFecEnt := cFecha(dFecEnt)+' '+cDia(DOW(dFecEnt))+' '
	   @ PROW()+00,116 SAY cTxtPrn+cFecEnt
       ENDIF

       IF nNroRec >= 1
	   @ PROW()+00,003+25 SAY cHoraSys(aDetCan[1,4])
       ENDIF

       IF nNroRec >= 2
	   @ PROW()+00,058+25 SAY cHoraSys(aDetCan[2,4])
       ENDIF

       IF nNroRec == 3
	   @ PROW()+00,116+25 SAY cHoraSys(aDetCan[2,4])
       ENDIF

       cLinea1 := 'Debe presentarse puntualmente con los dos '
       cLinea2 := 'PADRES DE FAMILIA en la oficina de '
       cLinea3 := 'Bienestar Estudiantil del Colegio.'

       IF nNroRec >= 1
	   @ PROW()+02,003 SAY cLinea1
       ENDIF
       IF nNroRec >= 2
	   @ PROW()+00,058 SAY cLinea1
       ENDIF
       IF nNroRec == 3
	   @ PROW()+00,116 SAY cLinea1
       ENDIF

       IF nNroRec >= 1
	   @ PROW()+01,003 SAY cLinea2
       ENDIF
       IF nNroRec >= 2
	   @ PROW()+00,058 SAY cLinea2
       ENDIF
       IF nNroRec == 3
	   @ PROW()+00,116 SAY cLinea2
       ENDIF

       IF nNroRec >= 1
	   @ PROW()+01,003 SAY cLinea3
       ENDIF
       IF nNroRec>= 2
	   @ PROW()+00,058 SAY cLinea3
       ENDIF
       IF nNroRec == 3
	   @ PROW()+00,116 SAY cLinea3
       ENDIF
       RETURN NIL
*>>>>FIN IMPRESION DEL TOTAL A PAGAR EN FECHA EXTEMPORANEA