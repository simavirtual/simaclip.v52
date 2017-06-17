/*                    SIMA - CONTABILIDAD ACADEMICA
	    BIBLIOTECAS DE FUNCIONES PARA EL DISE¥O DE BOLETINES

REQUERIMIENTOS:

- Compilar: clipper FuncsBol /w/m/b

OBJETIVOS:

- Funciones aplicadas para los diferentes boletines y libro final.


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO DEL PROGRAMA..: IMPRESION DEL LIBRO FINAL No. 01                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 17/97 LUN A
       Colombia, Bucaramanga        INICIO: 10:10 PM   DIC 17/97 LUN

OBJETIVOS:

1- Imprime el libro final modelo sugerido por el Colegio San Bernando
   de la Salle.

2- Libro final No. 01 no imprime los indicadores, s¢lo las
   asignaturas con los juicios valorativos, la intensidad horaria
   y las ausencias.

3- Debe estar en uso el archivo de notas del grupo correspondiente.

4- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION LibroFin01(cEmpPal,cNomEmp,cNomSis,cAnoUsr,cNomEst,lRetEst,dFecRet,;
		    aFirmas,cJorTxt,aNotAre,aNotMat,cNroFol,cMaeAct,cTxtLib,;
		    lInfFin,cMatMod)

*>>>>PARAMETROS DE LA FUNCION
/*     cEmpPal                              // Nombre de la Empresa principal
       cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       cAnoUsr			            // A¤o del Usuario
       cNomEst                              // Nombre del estudiante
       lRetEst                              // .T. Retirado
       dFecRet                              // Fecha de Retiro
       aFirmas                              // Firmas del libro
       cNomTit                              // Nombre del titular
       cJorTxt                              // Jornada escogida
       aNotAre                              // Detalles de las areas
       aNotMat                              // Detalles de las materias
       cNroFol                              // N£mero del Folio
       cMaeAct                              // Maestro Actual
       cTxtLib                              // Texto para el libro
       lInfFin                              // .T. Informe Final .F. Libro Final
       cMatMod                              // Materia de Modalidad o Especialidad */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
*       #INCLUDE "EPSONFX.PRG"               // Impresora ESPSON FX

       LOCAL   i,j,k := 0                   // Contadores

       LOCAL aNroCol := {}                  // Columnas de los titulos
       LOCAL aTitulo := {}                  // T¡tulos para el informe
       LOCAL aRegPrn := {}                  // Registro de impresion

       LOCAL lPagina := .T.                 // .T. Cambio de p gina
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL nTotCab := 0                   // Total l¡neas del encabezado
       LOCAL nTotReg := 0                   // Total registros a imprimir
       LOCAL nTotImp := 0                   // Totales de impresion
       LOCAL cTxtPrn := ''                  // Texto de impresion
       LOCAL nLenPrn := PCL('n17Stan')      // Longitud de impresi¢n

       LOCAL lPrnEmp := .F.                 // .T. Imprimir la Empresa
       LOCAL lPrnAre := .F.                 // .T. Imprimir el  rea
       LOCAL lNegAre := .F.                 // .T. Imprimir en negrilla el  rea
       LOCAL lPrnNot := .F.                 // .T. Imprimir la nota
       LOCAL lHayNot := .F.                 // .T. Hay Notas
       LOCAL lNotNum := .F.                 // .T. Nota Numerica .F. Nota Cualitativa
       LOCAL lHabObs := .F.                 // .T. Habilitacion Columna .F. Habilitaci¢n como observaci¢n
       LOCAL cMsgBol := ''                  // Mensaje para el boletin
       LOCAL lMatVar := .F.                 // .T. Imprimir Materia Variable

       LOCAL cNroCol := ''                  // N£mero de columnas
       LOCAL cNotDef := ''                  // Nota de area o materia

       LOCAL cCamFal := ''                  // Campo de las fallas

       LOCAL nMarSup := 0                   // Margen Superior
       LOCAL nLinCab := 0                   // L¡neas del Encabezado
       LOCAL nLinCol := 0                   // L¡neas de Columnas
       LOCAL nEncCol := 0                   // Encabezados de Columna
       LOCAL nLinTop := 0                   // L¡neas del Top

       LOCAL nColEnc := 0                   // N£mero de Columnas para el encabezado del libro
       LOCAL nColLib := 0                   // N£mero de Columnas para el cuerpo del libro

       LOCAL nNroPer := 0                   // N£mero del Bimestre
       LOCAL bCabeza := NIL                 // Code Block
       LOCAL lOficio := .F.                 // .F. Tama¤o carta
       LOCAL nTotPer := 0                   // Total de periodos
       LOCAL nNroArn := 0                   // N£mero areas no promediables
       LOCAL nJuiMat := 0                   // Total Juicios Materias
       LOCAL cCodAre := ''                  // C¢digo del area
       LOCAL cNomAre := ''                  // Nombre del area
       LOCAL cNomMat := ''                  // Nombre de la materia
       LOCAL cEvalua := ''                  // Evaluaci¢n conceptual
       LOCAL cCodJui := ''                  // C¢digo del juicio
       LOCAL cEstado := ''                  // Estado final de aprobaci¢n
       LOCAL aMatHab := {}                  // Detalles de la Recuperaci¢n

       LOCAL cCodigoTju := ''               // C¢digo del juicio
       LOCAL cNombreTju := ''               // Nombre del juicio
       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL cNombreTma := ''               // Nombre de la materia
       LOCAL cNotHabTno := ''               // Nota de la habilitaci¢n
       LOCAL cFecHabTno := ''               // Fecha de la habilitaci¢n
       LOCAL cCodigoTni := ''               // C¢digo del nivel
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO TOTAL DE AREAS
       nNroArn := 0
       FOR i:=1 TO LEN(aNotAre)
	  IF SUBS(aNotAre[i][4],7,4) == 'AREN'
	     nNroArn ++
	  ENDIF
       ENDFOR
       cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
*>>>>FIN CALCULO TOTAL DE AREAS

*>>>>LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD
       nTotPer := TCO->nTotPerTbl
       lOficio := TCO->lOficioTbl
       lHabObs := TCO->lHabObsTbl
       nNroPer := nTotPer
       lPrnEmp := TCO->lPrnEmpTbl
       lPrnAre := TCO->lPrnAreTbl
       lNegAre := TCO->lNegAreTbl
       lPrnNot := IF(SUBS(TCO->cPrnNotTbl,nNroPer,1)='1',.T.,.F.)
       lHayNot := IF(SUBS(TCO->cHayNotTbl,nNroPer,1)='1',.T.,.F.)
       lNotNum := IF(SUBS(TCO->cNotNumTbl,nNroPer,1)='1',.T.,.F.)

       nColEnc := TCO->nCo1LibTbl
       nColLib := TCO->nCo2LibTbl

       cMsgBol := ALLTRIM(TCO->cMsgBolTbl)

       IF !lPrnNot
	  lHayNot := .F.
       ENDIF

       IF !lHayNot
	  lNotNum := .F.
       ENDIF
*>>>>FIN LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD

*>>>>CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR
       IF lPrnEmp
	  nTotImp := IF(nNroPer==nTotPer,15,08)
       ELSE
	  nTotImp := IF(nNroPer==nTotPer,15,11)
       ENDIF
      *L¡neas de los totales de impresi¢n

       nMarSup := TCO->nLinEspTbl
       nLinCab := 9
       nTotCab := IIF(nMarSup > nLinCab, nMarSup - nLinCab, 0)
     *Encabezado de columna

       nEncCol := 3
       nLinTop := nTotCab+nEncCol
     *Total l¡neas del encabezado

      nTotReg := nLinTop+nNroArn+LEN(aNotMat)+nTotImp
      nTotReg := 0
     *Total de registros a imprimir
*>>>>FIN CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR

*>>>>IMPRESION DE LA HOJA DEL LIBRO
       bCabeza := {||CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
				nTotReg,;
				cNomEst,;
				NOT->cCodigoEst,;
				GRU->cCodigoGru,;
				NOT->(RECNO()),;
				NIL,NIL,nNroPer,cAnoUsr,;
				cJorTxt,3,cNomEmp,lPrnEmp,;
				cNroFol,cTxtLib,cEmpPal,;
				IF(lInfFin,TCO->cTitBolTbl,''),;
				cMatMod,nColEnc)}

       lMatVar := .T.
       aMatHab := aMatHabPla(NOT->nAproboNot,aNotAre,aNotMat,nTotPer,lNotNum,;
			     lMatVar)
      *Materias de las Recuperaciones

       CuerpLib01(cNomSis,cJorTxt,cMsgBol,lRetEst,dFecRet,lNotNum,aNotAre,;
		  aNotMat,nNroPer,cNomEmp,lPrnEmp,cNroFol,lNegAre,bCabeza,;
		  aFirmas,lHayNot,lPrnAre,lOficio,cMaeAct,lHabObs,aMatHab,;
		  lInfFin)

       RETURN NIL
*>>>>FIN IMPRESION DE LA HOJA DEL LIBRO


/*************************************************************************
* TITULO DEL PROGRAMA..: CUERPO DEL LIBRO FINAL No. 01                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 17/97 MIE A
       Colombia, Bucaramanga        INICIO: 11:05 AM   DIC 17/97 MIE

OBJETIVOS:

1- El cuerpo del libro est  formado por el encabezado y las asignaturas.

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CuerpLib01(cNomSis,cJorTxt,cMsgBol,lRetEst,dFecRet,lNotNum,;
		    aNotAre,aNotMat,nNroPer,cNomEmp,lPrnEmp,cNroFol,;
		    lNegAre,bCabeza,aFirmas,lHayNot,lPrnAre,lOficio,;
		    cMaeAct,lHabObs,aMatHab,lInfFin)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomSis                              // Nombre del Sistema
       cJorTxt                              // Jornada escogida
       cMsgBol                              // T¡tulo de Encabezado
       lRetEst                              // .T. Estudiante Retirado
       dFecRet                              // Fecha de Retiro
       lNotNum                              // .F. Nota Cualitativa
       aNotAre                              // Detalles de las areas
       aNotMat                              // Detalles de las materias
       nNroPer			            // N£mero del Periodo
       cNomEmp                              // Nombre de la Empresa
       lPrnEmp                              // .T. Imprimir la Empresa
       cNroFol                              // N£mero del Folio
       lNegAre                              // .T. Areas en negrilla
       bCabeza                              // Funci¢n con Encabezado
       aFirmas                              // Firmas del libro.
       lHayNot                              // .T. Hay Notas
       lPrnAre                              // .T. Imprimir las areas
       lOficio                              // .F. Tama¤o Carta
       cMaeAct                              // Maestro Actual
       lHabObs                              // .T. Habilitaci¢n como observaci¢n .F. Habilitaci¢n en Columna
       aMatHab                              // Materias por Habilitar
       lInfFin                              // .T. Informe Final .F. Libro Final */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL   i,j,k := 0                   // Contadores

       LOCAL nColEnc := 0                   // N£mero de Columnas para el encabezado del libro
       LOCAL nColLib := 0                   // N£mero de Columnas para el cuerpo del libro

       LOCAL aNroCol := {}                  // Columnas de los titulos
       LOCAL aTitulo := {}                  // T¡tulos para el informe
       LOCAL aRegPrn := {}                  // Registro de impresion

       LOCAL lPagina := .T.                 // .T. Cambio de p gina
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL nTotCab := 0                   // Total l¡neas del encabezado
       LOCAL nTotImp := 0                   // Totales de impresion
       LOCAL cTxtPrn := ''                  // Texto de impresion
       LOCAL nLenPrn := PCL('n17Stan')      // Longitud de impresi¢n

       LOCAL cNroCol := ''                  // N£mero de columnas
       LOCAL cCamFal := ''                  // Campo de las fallas

       LOCAL nTotPer := 0                   // Total de periodos.
       LOCAL nNroArn := 0                   // N£mero areas no promediables
       LOCAL cCodAre := ''                  // C¢digo del area
       LOCAL cNomAre := ''                  // Nombre del area
       LOCAL cNomMat := ''                  // Nombre de la materia
       LOCAL cEvalua := ''                  // Evaluaci¢n conceptual
       LOCAL cEstado := ''                  // Estado final de aprobaci¢n
       LOCAL cIntens := ''                  // Intensidad Horaria
       LOCAL cNroFal := ''                  // N£mero de Ausencias
       LOCAL nLenTxt := ''                  // Longitud del texto
       LOCAL aNroLin := {}                  // N£mero de l¡neas
       LOCAL nPosHab := 0                   // Posici¢n de la Habilitaci¢n
       LOCAL cNotDef := ''                  // Nota Definitiva materia o area
       LOCAL cNotRec := ''                  // Nota de Recuperaci¢n

       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL cNombreTma := ''               // Nombre de la materia
       LOCAL cNotHabTno := ''               // Nota de la habilitaci¢n
       LOCAL cFecHabTno := ''               // Fecha de la habilitaci¢n
       LOCAL cCodigoTev := ''               // C¢digo de la Evaluaci¢n
       LOCAL cCodigoTni := ''               // C¢digo del nivel
       LOCAL cCodigoTcl := ''               // C¢digo de la clase
       LOCAL cTxtObsTap := ''               // Texto de Observaci¢n de Promoci¢n.

       LOCAL cCamNotDef := ''               // Campo de Notas Definitivas
       LOCAL cCamNotRec := ''               // Campo de Notas de Recuperaci¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ENCABEZADOS DE COLUMNA
       nColEnc := TCO->nCo1LibTbl
       nColLib := TCO->nCo2LibTbl

       IF lHabObs .OR. EMPTY(aMatHab)
	  aNroCol := {80,02,04,14}
	  aTitulo := {'AREAS O ASIGNATURAS','IH','AUS.','EVALUACION'}
       ELSE
	  aNroCol := {80,02,04,14,10,06,06}
	  aTitulo := {'AREAS O ASIGNATURAS','IH','AUS.','EVALUACION',;
		      'FECHA','ACTA',IF(lNotNum,'NOTA','JUICIO')}
       ENDIF
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>IMPRESION DE LAS NOTAS
       nTotPer := TCO->nTotPerTbl
       FOR i:=1 TO LEN(aNotAre)

***********IMPRESION DEL ENCABEZADO
	    IF lPagina
	       OtraPagina(PCL({"DraftOn","CondenOn"}),;
			  PCL({"NegraOf","DobGolOf"}),;
			  aTitulo,aNroCol,bCabeza,nColLib)
	    ENDIF
***********FIN IMPRESION DEL ENCABEZADO

**********IMPRESION DE LAS NOTAS DEL AREA
	    IF SUBS(aNotAre[i][4],7,4) == 'AREN'

*--------------ANALISIS DE LA IMPRESION DEL AREA
		 IF aNotAre[i][12]  // .T. No Imprimir
		    LOOP
		 ENDIF
*--------------FIN ANALISIS DE LA IMPRESION AREA

*--------------LECTURA DE LA NOTA DEL AREA
		 cCamNotDef := aNotAre[i,4]
		 cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

		 cNotDef := ALLTRIM(SUBS(&cCamNotDef,nNroPer*4-3,4))
		 cNotRec := ALLTRIM(SUBS(&cCamNotRec,nNroPer*4-3,4))
		 IF TCO->lRecNotTbl .AND. !EMPTY(cNotRec)
		    cNotDef := cNotRec
		 ENDIF

		 cNotDef := cNotDef(cNotDef,lNotNum)
		 cNotDef := cNombreJvf(cNotDef)
*--------------FIN LECTURA DE LA NOTA DEL AREA

*--------------CONTEO DE LAS FALLAS
		 cCamFal := 'NOT->cFa'+SUBS(aNotAre[i,6],9,4)+'Not'
		 cNroFal := 0
		 IF nNroPer == nTotPer
		    FOR k := 1 TO nNroPer
		       cNroFal += VAL(SUBS(&cCamFal,k*2-1,2))
		    NEXT
		 ELSE
		    cNroFal := VAL(SUBS(&cCamFal,nNroPer*2-1,2))
		 ENDIF
		 cNroFal := IF(EMPTY(cNroFal),SPACE(02),STR(cNroFal,2,0))
*--------------FIN CONTEO DE LAS FALLAS

*--------------INTENSIDAD HORARIA
		 IF VAL(aNotAre[i,11]) == 0
		    cIntens := SPACE(02)
		 ELSE
		    cIntens := aNotAre[i,11]
		 ENDIF
*--------------FIN INTENSIDAD HORARIA

*--------------IMPRESION DEL REGISTRO DEL AREA
		 cNomAre := aNotAre[i,10]+SPACE(80-LEN(aNotAre[i,10]))

		 IF lHabObs .OR. EMPTY(aMatHab)
		    aRegPrn := {cNomAre,;
				cIntens,;
				cNroFal,;
				cNotDef}
		 ELSE
		    cCodigoTma := SUBS(aNotAre[i,6],9,4)
		       nPosHab := ASCAN(aMatHab,{|x|x[1] == cCodigoTma})
		    IF nPosHab == 0
		       aRegPrn := {cNomAre,;
				   cIntens,;
				   cNroFal,;
				   cNotDef,;
				   SPACE(10),;
				   SPACE(06),;
				   SPACE(06)}
		    ELSE
		       aRegPrn := {cNomAre,;
				   cIntens,;
				   cNroFal,;
				   cNotDef,;
				   aMatHab[nPosHab,2],;
				   aMatHab[nPosHab,3],;
				   aMatHab[nPosHab,4]}
		    ENDIF
		 ENDIF

		cTxtPrn := cRegPrint(aRegPrn,aNroCol)
		@ PROW()+1,nColLib SAY cTxtPrn
*--------------FIN IMPRESION DEL REGISTRO DEL AREA

*--------------ANALISIS PARA EL CAMBIO DE PAGINA
		 IF PROW() > IIF(lOficio,70,58)
		    DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
		    EJECT
		    OtraPagina(PCL({"DraftOn","CondenOn"}),;
			       PCL({"NegraOf","DobGolOf"}),;
			       aTitulo,aNroCol,bCabeza,nColLib)
		 ENDIF
*--------------FIN ANALISIS PARA EL CAMBIO DE PAGINA

	    ENDIF
**********FIN IMPRESION DE LAS NOTAS DEL AREA

**********IMPRESION DE LAS NOTAS DE LA MATERIA
	    FOR j:=1 TO LEN(aNotMat)

	       IF aNotAre[i,2] == aNotMat[j,1]

*-----------------ANALISIS DE LA IMPRESION DE LA MATERIA
		    IF aNotMat[j][12]   // .T. No Imprimir
		       LOOP
		    ENDIF
*-----------------FIN ANALISIS DE LA IMPRESION DE LA MATERIA

*-----------------LECTURA DE LA NOTA DE LA MATERIA
		    cCamNotDef := aNotMat[j,4]
		    cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

		    cNotDef := ALLTRIM(SUBS(&cCamNotDef,nNroPer*4-3,4))
		    cNotRec := ALLTRIM(SUBS(&cCamNotRec,nNroPer*4-3,4))

		    IF TCO->lRecNotTbl .AND. !EMPTY(cNotRec)
		       cNotDef := cNotRec
		    ENDIF

		    cNotDef := cNotDef(cNotDef,lNotNum)
		    cNotDef := cNombreJvf(cNotDef)
*-----------------FIN LECTURA DE LA NOTA DE LA MATERIA

*-----------------CONTEO DE LAS FALLAS
		    cCamFal := aNotMat[j,6]
		    cNroFal := 0
		    IF nNroPer == nTotPer
		       FOR k := 1 TO nNroPer
			  cNroFal += VAL(SUBS(&cCamFal,k*2-1,2))
		       NEXT
		    ELSE
		       cNroFal := VAL(SUBS(&cCamFal,nNroPer*2-1,2))
		    ENDIF
		    cNroFal := IF(EMPTY(cNroFal),SPACE(02),STR(cNroFal,2,0))
*-----------------FIN CONTEO DE LAS FALLAS

*-----------------IMPRESION DEL REGISTRO DEL AREA
		    IF VAL(aNotMat[j,3]) == 0
		       cIntens := SPACE(02)
		    ELSE
		       cIntens := aNotMat[j,3]
		    ENDIF
		  *ÀLectura de la Intensidad horaria

		    cNomMat := aNotMat[j,10]+SPACE(80-LEN(aNotMat[j,10]))
		  *ÀMateria Notas o Certificado

		    IF !EMPTY(TCO->cSpaBolTbl)
		       IF aNotMat[j,1] == cCodAre .AND. SUBS(aNotMat[j,5],11,2) # '00'
			  cNomMat := SUBS(SPACE(02)+cNomMat,1,80)
		       ELSE
			  cCodAre := aNotMat[j,1]
		       ENDIF
		    ENDIF
		  *ÀIndentaci¢n de la materia

		    IF lHabObs .OR. EMPTY(aMatHab)
		       aRegPrn := {cNomMat,;
				   cIntens,;
				   cNroFal,;
				   cNotDef}
		    ELSE
		       cCodigoTma := SUBS(aNotMat[j,5],9,4)
			  nPosHab := ASCAN(aMatHab,{|x|x[1] == cCodigoTma})
			  IF nPosHab == 0
			     aRegPrn := {cNomMat,;
					 cIntens,;
					 cNroFal,;
					 cNotDef,;
					 SPACE(10),;
					 SPACE(06),;
					 SPACE(06)}
			  ELSE
			     aRegPrn := {cNomMat,;
					 cIntens,;
					 cNroFal,;
					 cNotDef,;
					 aMatHab[nPosHab,2],;
					 aMatHab[nPosHab,3],;
					 aMatHab[nPosHab,4]}
			  ENDIF
		    ENDIF

		    cTxtPrn := cRegPrint(aRegPrn,aNroCol)
		    @ PROW()+1,nColLib SAY cTxtPrn
*-----------------FIN IMPRESION DEL REGISTRO DEL AREA

*-----------------ANALISIS PARA EL CAMBIO DE PAGINA
		    IF PROW() > IIF(lOficio,70,58)
		       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
		       EJECT
		       OtraPagina(PCL({"DraftOn","CondenOn"}),;
				  PCL({"NegraOf","DobGolOf"}),;
				  aTitulo,aNroCol,bCabeza,nColLib)
		    ENDIF
*-----------------FIN ANALISIS PARA EL CAMBIO DE PAGINA

	       ENDIF
	    ENDFOR
**********FIN IMPRESION DE LAS NOTAS DE LA MATERIA

**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > IIF(lOficio,70,58)
	       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
	       EJECT
	       lPagina := .T.
	    ELSE
	       lPagina := .F.
	    ENDIF
**********FIN ANALISIS PARA EL CAMBIO DE PAGINA

       ENDFOR
       nLenTxt := LEN(cTxtPrn)
       @ PROW()+1,nColLib SAY REPL('-',LEN(cTxtPrn))
      *Impresi¢n de la £ltima l¡nea
*>>>>FIN IMPRESION DE LAS NOTAS

*>>>>ANALISIS PARA EL CAMBIO DE PAGINA
       IF PROW() > IIF(lOficio,70,58) - nTotImp .OR. PROW() = 0
	  IF PROW() <> 0
	     IF PROW() <= IIF(lOficio,70,58)
		DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
	     ENDIF
	     EJECT
	  ENDIF
	  OtraPagina(PCL({"DraftOn","CondenOn"}),;
		     PCL({"NegraOf","DobGolOf"}),;
		     aTitulo,aNroCol,bCabeza,nColLib)
       ENDIF
*>>>>FIN ANALISIS PARA EL CAMBIO DE PAGINA

*>>>>IMPRESION DE LAS AREAS HABILITAR
       IF nNroPer == nTotPer .AND. !EMPTY(NOT->cMatHabNot)

**********IMPRESION DE LOS DETALLES DE LA HABILITACION
	    @PROW()+2,nColLib SAY IF ('0000' $ TCO->cNotNumTbl,;
				 'RECUPERACIONES','HABILITACIONES')
	    @PROW()  ,32 SAY SPACE(50)+'FECHA      ACTA  EVALUACION'
	    FOR k := 1 TO LEN(ALLTRIM(NOT->cMatHabNot))/4

*--------------LOCALIZACION DE LA MATERIAS A HABILITAR
		 cCodigoTma := SUBS(NOT->cMatHabNot,k*4-3,4)
		 cNombreTma := 'FAVOR VERIFICAR'
		 IF lLocCodigo('cCodigoMat','MAT',cCodigoTma,;
				     'DEL AREA')
		    cNombreTma := MAT->cNombreMat
		 ENDIF
*--------------FIN LOCALIZACION DE LA MATERIAS A HABILITAR

*--------------LECTURA DE LA NOTA DE LA RECUPERACION O HABILITACION
		 cNotHabTno := SUBS(NOT->cNotHabNot,k*4-3,4)
		 cNotHabTno := cNotDef(cNotHabTno,lNotNum)
		 cNotHabTno := cNombreJvf(cNotHabTno)
*--------------FIN LECTURA DE LA NOTA DE LA RECUPERACION O HABILITACION

*--------------IMPRESION DE LA HABILITACION
		 cFecHabTno := cFecha(NOT->dFecHa1Not)
		 @PROW()+1,nColLib SAY cNombreTma+SPACE(02)+;
				       cFecHabTno+SPACE(02)+;
				       SUBS(NOT->cActHabNot,k*4-3,4)+SPACE(02)+;
				       cNotHabTno+SPACE(02)
*--------------FIN IMPRESION DE LA HABILITACION

	    ENDFOR
**********FIN IMPRESION DE LOS DETALLES DE LA HABILITACION

       ENDIF
*>>>>FIN IMPRESION DE LAS AREAS HABILITAR

*>>>>ANALISIS PARA EL CAMBIO DE PAGINA
       IF PROW() > 46
	  DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
	  EJECT
	  OtraPagina(PCL({"DraftOn","CondenOn"}),;
		     PCL({"NegraOf","DobGolOf"}),;
		     aTitulo,aNroCol,bCabeza,nColLib)
       ENDIF
*>>>>FIN ANALISIS PARA EL CAMBIO DE PAGINA

*>>>>IMPRESION DE LA PROMOCION FINAL
       cEstado := ''
       IF nNroPer == nTotPer
	  IF lRetEst
	     cEstado := 'NO TERMINO. SE RETIRO EN '+cFecha(dFecRet)+' '+;
			&cMaeAct->cObsRetEst
	     cTxtObsTap := ''
	  ELSE
	     cEstado := cAproboJui(NOT->nAproboNot,;
				   SUBS(&cMaeAct->cCodigoGru,1,2),;
					@cTxtObsTap)
	  ENDIF
	  cEstado    := ALLTRIM(cEstado)

       ENDIF
       aNroLin := aDivLin(ALLTRIM('OBSERVACION FINAL: '+cEstado),110)
       FOR i := 1 TO LEN(aNroLin)
	   @ PROW()+1,nColLib SAY aNroLin[i]
       NEXT
*>>>>FIN IMPRESION DE LA PROMOCION FINAL

*>>>>IMPRESION DE LAS RECUPERACIONES COMO OBSERVACIONES
       IF lHabObs .AND. !EMPTY(aMatHab)
	  @ PROW()+1,nColLib SAY ''

	  IF EMPTY(TCO->cTitRecTbl)
	     cTxtPrn := 'ACTIVIDADES DE RECUPERACION DE:'
	  ELSE
	     cTxtPrn := ALLTRIM(TCO->cTitRecTbl)
	  ENDIF

	  FOR i := 1 TO LEN(aMatHab)
	      cTxtPrn += ALLTRIM(aMatHab[i,5])+': '
	      IF ALLTRIM(cTxtNota(aMatHab[i,4])) == 'SIN NOTA'
		 cTxtPrn += 'PENDIENTE. '

	      ELSE
		 cTxtPrn += ALLTRIM(cTxtNota(aMatHab[i,4]))+;
			    ' - ACTA No.'+ALLTRIM(aMatHab[i,3])+;
			    ' DE '+aMatHab[i,2]+'. '
	      ENDIF
	  NEXT
	  aNroLin := aDivLin(ALLTRIM(cTxtPrn),110)
	  FOR i := 1 TO LEN(aNroLin)
	      @ PROW()+1,nColLib SAY aNroLin[i]
	  NEXT
       ENDIF
*>>>>FIN IMPRESION DE LAS RECUPERACIONES COMO OBSERVACIONES

*>>>>IMPRESION DE LA OBSERVACION
       IF lInfFin .AND. !EMPTY(cTxtObsTap)
	  aNroLin := aDivLin(ALLTRIM(cTxtObsTap),110)
	  FOR i := 1 TO LEN(aNroLin)
	      @ PROW()+1,nColLib SAY aNroLin[i]
	  NEXT
       ENDIF
     *ÀObservaci¢n de Recuperacion.

       IF !EMPTY(TCO->cOb4BolTbl)
	  aNroLin := aDivLin(ALLTRIM(TCO->cOb4BolTbl),110)
	  FOR i := 1 TO LEN(aNroLin)
	      @ PROW()+1,nColLib SAY aNroLin[i]
	  NEXT
       ENDIF
     *ÀObservaci¢n General del Libro

       IF !EMPTY(&cMaeAct->cObsLibEst)
	  aNroLin := aDivLin(ALLTRIM(&cMaeAct->cObsLibEst),110)
	  FOR i := 1 TO LEN(aNroLin)
	      @ PROW()+1,nColLib SAY aNroLin[i]
	  NEXT
       ENDIF
     *ÀObservaci¢n del Estudiante.

       @ PROW()+2,nColLib SAY 'OBSERVACIONES:'
       @ PROW()+1,nColLib SAY REPL('-',nLenTxt)
       @ PROW()+2,nColLib SAY REPL('-',nLenTxt)
       @ PROW()+2,nColLib SAY REPL('-',nLenTxt)
     *ÀImpresi¢n l¡neas de la observaci¢n
*>>>>FIN IMPRESION DE LA OBSERVACION

*>>>>IMPRESION DE LAS FIRMAS
       IF lInfFin
	  cTxtPrn := 'Dir. '+aFirmas[1,1]
	  @ PROW()+2,(nLenPrn-LEN(cTxtPrn))/2 SAY REPL('-',LEN(cTxtPrn)+4)
	  @ PROW()+1,((nLenPrn-LEN(cTxtPrn))/2)+2 SAY cTxtPrn
       ELSE
	  Firmas(PCL('n17Stan'),6,aFirmas,.F.,nColLib)
       ENDIF
      *Impresi¢n firmantes del libro

       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
       EJECT
       RETURN NIL
*>>>>FIN IMPRESION DE LAS FIRMAS

/*************************************************************************
* TITULO DEL PROGRAMA..: IMPRESION DEL LIBRO FINAL No. 02                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 24/97 LUN A
       Colombia, Bucaramanga        INICIO: 11:35 PM   ENE 24/97 LUN

OBJETIVOS:

1- Imprime el libro final modelo original del sistema de logros

2- Libro final No. 02 esta formado por indicadores de logro y juicios
   valorativos.

3- Debe estar en uso el archivo de notas del grupo correspondiente.

4- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION LibroFin02(cEmpPal,cNomEmp,cNomSis,cAnoUsr,cNomEst,;
		    lRetEst,dFecRet,aFirmas,cJorTxt,cMaeAct,;
		    aNotAre,aNotMat,cNroFol,cTxtLib)

*>>>>PARAMETROS DE LA FUNCION
/*     cEmpPal                              // Nombre de la Empresa principal
       cNomSis                              // Nombre del sistema
       cAnoUsr			            // A¤o del Usuario
       cNomEst                              // Nombre del estudiante
       lRetEst                              // .T. Retirado
       dFecRet                              // Fecha de Retiro
       aFirmas                              // Firmas del libro
       cNomTit                              // Nombre del titular
       cJorTxt                              // Jornada escogida
       cMaeAct                              // Maestro Actual
       aNotAre                              // Detalles de las areas
       aNotMat                              // Detalles de las materias
       cNroFol                              // N£mero del Folio
       cTxtLib                              // Texto para el libro */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL   i,j,k := 0                   // Contadores

       LOCAL aNroCol := {}                  // Columnas de los titulos
       LOCAL aTitulo := {}                  // T¡tulos para el informe
       LOCAL aRegPrn := {}                  // Registro de impresion

       LOCAL lPagina := .T.                 // .T. Cambio de p gina
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL nTotCab := 0                   // Total l¡neas del encabezado
       LOCAL nTotReg := 0                   // Total registros a imprimir
       LOCAL nTotImp := 0                   // Totales de impresion
       LOCAL cTxtPrn := ''                  // Texto de impresion
       LOCAL nLenPrn := PCL('n17Stan')      // Longitud de impresi¢n

       LOCAL lPrnEmp := .F.                 // .T. Imprimir la Empresa
       LOCAL lPrnAre := .F.                 // .T. Imprimir el  rea
       LOCAL lNegAre := .F.                 // .T. Imprimir en negrilla el  rea
       LOCAL lPrnNot := .F.                 // .T. Imprimir la nota
       LOCAL lIndNiv := .F.                 // .T. Indicadores por nivel
       LOCAL lEvaInd := .F.                 // .T. Evaluar el indicador
       LOCAL lHayNot := .F.                 // .T. Hay Notas
       LOCAL lNotNum := .F.                 // .T. Nota Numerica .F. Nota Cualitativa
       LOCAL cMsgBol := ''                  // Mensaje para el boletin
       LOCAL lMatVar := .F.                 // .T. Imprimir Materia Variable

       LOCAL cNroCol := ''                  // N£mero de columnas
       LOCAL cNotDef := ''                  // Nota de area o materia

       LOCAL cCamFal := ''                  // Campo de las fallas

       LOCAL nMarSup := 0                   // Margen Superior
       LOCAL nLinCab := 0                   // L¡neas del Encabezado
       LOCAL nLinCol := 0                   // L¡neas de Columnas
       LOCAL nEncCol := 0                   // Encabezados de Columna
       LOCAL nLinTop := 0                   // L¡neas del Top


       LOCAL nNroPer := 0                   // N£mero del Bimestre
       LOCAL bCabeza := NIL                 // Code Block
       LOCAL lOficio := .F.                 // .F. Tama¤o carta
       LOCAL nTotPer := 0                   // Total de periodos
       LOCAL nNroArn := 0                   // N£mero areas no promediables
       LOCAL cJuicio := ''                  // Juicios para el periodo
       LOCAL nJuiAre := 0                   // Total Juicios Area
       LOCAL nJuiMat := 0                   // Total Juicios Materias
       LOCAL cCodAre := ''                  // C¢digo del area
       LOCAL cNomAre := ''                  // Nombre del area
       LOCAL cNomMat := ''                  // Nombre de la materia
       LOCAL cEvalua := ''                  // Evaluaci¢n conceptual
       LOCAL cCodJui := ''                  // C¢digo del juicio
       LOCAL cEstado := ''                  // Estado final de aprobaci¢n
       LOCAL aMatHab := {}                  // Detalles de la Recuperaci¢n
       LOCAL lHabObs := .F.                 // .T. Habilitacion Columna .F. Habilitaci¢n como observaci¢n

       LOCAL cCodigoTju := ''               // C¢digo del juicio
       LOCAL cNombreTju := ''               // Nombre del juicio
       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL cNombreTma := ''               // Nombre de la materia
       LOCAL cNotHabTno := ''               // Nota de la habilitaci¢n
       LOCAL cFecHabTno := ''               // Fecha de la habilitaci¢n
       LOCAL cCodigoTni := ''               // C¢digo del nivel
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO TOTAL DE JUICIOS APLICADOS A AREAS
       nJuiAre := 0
       nNroArn := 0

       FOR i:=1 TO LEN(aNotAre)
	  IF SUBS(aNotAre[i][4],7,4) == 'AREN'
	     cJuicio := ALLTRIM(&(aNotAre[i,6]))
	     nJuiAre += ROUND(LEN(cJuicio)/5,0)
	     nNroArn ++
	  ENDIF
       ENDFOR
       cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
*>>>>FIN CALCULO TOTAL DE JUICIOS APLICADOS A AREAS

*>>>>LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD
       nTotPer := TCO->nTotPerTbl
       lOficio := TCO->lOficioTbl
       nNroPer := nTotPer
       lPrnEmp := TCO->lPrnEmpTbl
       lPrnAre := TCO->lPrnAreTbl
       lNegAre := TCO->lNegAreTbl
       lHabObs := TCO->lHabObsTbl
*       lPrnNot := IF(SUBS(TCO->cPrnNotTbl,nNroPer,1)='1',.T.,.F.)
       lPrnNot := .T.
       lIndNiv := TCO->lIndNivTbl
       lEvaInd := IF(SUBS(TCO->cEvaIndTbl,nNroPer,1)='1',.T.,.F.)
       lHayNot := IF(SUBS(TCO->cHayNotTbl,nNroPer,1)='1',.T.,.F.)
       lNotNum := IF(SUBS(TCO->cNotNumTbl,nNroPer,1)='1',.T.,.F.)
       cMsgBol := ALLTRIM(TCO->cMsgBolTbl)
       IF !lPrnNot
	  lHayNot := .F.
       ENDIF
       IF !lHayNot .AND. lEvaInd
	  lNotNum := .F.
       ENDIF
*>>>>FIN LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD

*>>>>CALCULO TOTAL DE JUICIOS APLICADOS A MATERIAS
       nJuiMat := 0
       FOR i:=1 TO LEN(aNotMat)
	  cJuicio := ALLTRIM(&(aNotMat[i,5]))
	  nJuiMat += ROUND(LEN(cJuicio)/5,0)
       ENDFOR
*>>>>FIN CALCULO TOTAL DE JUICIOS APLICADOS A MATERIAS

*>>>>CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR
       IF lPrnEmp
	  nTotImp := IF(nNroPer==nTotPer,15,08)
       ELSE
	  nTotImp := IF(nNroPer==nTotPer,15,11)
       ENDIF
      *L¡neas de los totales de impresi¢n

       nMarSup := TCO->nLinEspTbl
       nLinCab := 9
       nTotCab := IIF(nMarSup > nLinCab, nMarSup - nLinCab, 0)
     *Encabezado de columna

       nEncCol := 3
       nLinTop := nTotCab+nEncCol
     *Total l¡neas del encabezado

      nTotReg := nLinTop+nNroArn+LEN(aNotMat)+nJuiAre+nJuiMat+nTotImp
     *Total de registros a imprimir
*>>>>FIN CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR

*>>>>IMPRESION DE LA HOJA DEL LIBRO
       bCabeza := {||CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
				nTotReg,;
				cNomEst,;
				NOT->cCodigoEst,;
				GRU->cCodigoGru,;
				NOT->(RECNO()),;
				NIL,NIL,nNroPer,cAnoUsr,;
				cJorTxt,3,cNomEmp,lPrnEmp,;
				cNroFol,cTxtLib,cEmpPal)}

       lMatVar := .T.
       aMatHab := aMatHabPla(NOT->nAproboNot,aNotAre,aNotMat,nTotPer,lNotNum,;
			     lMatVar)
      *Materias de las Recuperaciones

       CuerpLib02(cNomSis,cJorTxt,cMsgBol,lRetEst,dFecRet,lEvaInd,lNotNum,;
		  aNotAre,aNotMat,nNroPer,cNomEmp,lPrnEmp,cNroFol,lNegAre,;
		  bCabeza,aFirmas,lIndNiv,lHayNot,lPrnAre,lOficio,cMaeAct,;
		  lHabObs,aMatHab)

       RETURN NIL
*>>>>FIN IMPRESION DE LA HOJA DEL LIBRO

/*************************************************************************
* TITULO DEL PROGRAMA..: CUERPO DEL LIBRO FINAL No. 02                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 17/97 MIE A
       Colombia, Bucaramanga        INICIO: 11:05 AM   DIC 17/97 MIE

OBJETIVOS:

1- El cuerpo del libro est  formado por el encabezado y las asignaturas.

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CuerpLib02(cNomSis,cJorTxt,cMsgBol,lRetEst,dFecRet,lEvaInd,lNotNum,;
		    aNotAre,aNotMat,nNroPer,cNomEmp,lPrnEmp,cNroFol,lNegAre,;
		    bCabeza,aFirmas,lIndNiv,lHayNot,lPrnAre,lOficio,cMaeAct,;
		    lHabObs,aMatHab)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomSis                              // Nombre del Sistema
       cJorTxt                              // Jornada escogida
       cMsgBol                              // T¡tulo de Encabezado
       lRetEst                              // .T. Estudiante Retirado
       dFecRet                              // Fecha de Retiro
       lEvaInd                              // .T. Evaluar Indicadores
       lNotNum                              // .F. Nota Cualitativa
       aNotAre                              // Detalles de las areas
       aNotMat                              // Detalles de las materias
       nNroPer			            // N£mero del Periodo
       cNomEmp                              // Nombre de la Empresa
       lPrnEmp                              // .T. Imprimir la Empresa
       cNroFol                              // N£mero del Folio
       lNegAre                              // .T. Areas en negrilla
       bCabeza                              // Funci¢n con Encabezado
       aFirmas                              // Firmas del libro.
       lIndNiv                              // .T. Indicadores de Nivel
       lHayNot                              // .T. Hay Notas
       lPrnAre                              // .T. Imprimir las areas
       lOficio                              // .F. Tama¤o Carta
       cMaeAct                              // Maestro Actual
       lHabObs                              // .T. Habilitaci¢n como observaci¢n .F. Habilitaci¢n en Columna
       aMatHab                              // Materias por Habilitar */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL i,j,k,x := 0                   // Contadores

       LOCAL aNroCol := {}                  // Columnas de los titulos
       LOCAL aTitulo := {}                  // T¡tulos para el informe
       LOCAL aRegPrn := {}                  // Registro de impresion
       LOCAL aNroLin := {}                  // N£mero de l¡neas

       LOCAL lPagina := .T.                 // .T. Cambio de p gina
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL nTotCab := 0                   // Total l¡neas del encabezado
       LOCAL nTotImp := 0                   // Totales de impresion
       LOCAL cTxtPrn := ''                  // Texto de impresion
       LOCAL nLenPrn := PCL('n17Stan')      // Longitud de impresi¢n

       LOCAL cNroCol := ''                  // N£mero de columnas
       LOCAL cNotDef := ''                  // Nota de area o materia

       LOCAL cCamFal := ''                  // Campo de las fallas

       LOCAL nTotPer := 0                   // Total de periodos.
       LOCAL nNroArn := 0                   // N£mero areas no promediables
       LOCAL cCodAre := ''                  // C¢digo del area
       LOCAL cNomAre := ''                  // Nombre del area
       LOCAL cNomMat := ''                  // Nombre de la materia
       LOCAL cEvalua := ''                  // Evaluaci¢n conceptual
       LOCAL cCodJui := ''                  // C¢digo del juicio
       LOCAL cEstado := ''                  // Estado final de aprobaci¢n
       LOCAL cIntens := ''                  // Intensidad Horaria
       LOCAL cNroFal := ''                  // N£mero de Ausencias
       LOCAL nLenTxt := ''                  // Longitud del texto
       LOCAL cClaInd := ''                  // Clase de Indicador de Configuraci¢n
       LOCAL cCodLog := ''                  // C¢digo del logro
       LOCAL cJuicio := ''                  // C¢digos de los indicadores
       LOCAL nNroInd := ''                  // N£mero del Indicador

       LOCAL cCodigoTju := ''               // C¢digo del juicio
       LOCAL cNombreTju := ''               // Nombre del juicio
       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL cNombreTma := ''               // Nombre de la materia
       LOCAL cNotHabTno := ''               // Nota de la habilitaci¢n
       LOCAL cFecHabTno := ''               // Fecha de la habilitaci¢n
       LOCAL cCodigoTev := ''               // C¢digo de la Evaluaci¢n
       LOCAL cCodigoTni := ''               // C¢digo del nivel
       LOCAL cCodigoTcl := ''               // C¢digo de la clase
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {02,108,04,04}
       IF lHayNot .OR. lEvaInd
	  aTitulo := {'IH',cMsgBol,IF(lNotNum,'NOTA','JUIC'),'AUS.'}
       ELSE
	  aTitulo := {'IH',cMsgBol,'AUS.'}
       ENDIF
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>IMPRESION DE LAS NOTAS
       nTotPer := TCO->nTotPerTbl
       cClaInd := TCO->cClaIndTbl
       FOR i:=1 TO LEN(aNotAre)

***********IMPRESION DEL ENCABEZADO
	    IF lPagina
	       OtraPagina(PCL({"DraftOn","CondenOn"}),;
			  PCL({"NegraOf","DobGolOf"}),;
			  aTitulo,aNroCol,bCabeza)
	    ENDIF
***********FIN IMPRESION DEL ENCABEZADO

**********IMPRESION DE LAS NOTAS DEL AREA
	    IF SUBS(aNotAre[i][4],7,4) == 'AREN'

*--------------LECTURA DE LA NOTA DEL AREA
		 cNotDef := SUBS(&(aNotAre[i,4]),nNroPer*4-3,4)
		 DO CASE
		 CASE VAL(cNotDef) == 0 .AND. aNotAre[i,4] = 'N'
		      IF 'SN' $ cNotDef
			 cNotDef := ' SN '
		      ENDIF
		 CASE VAL(cNotDef) == 0 .AND. aNotAre[i,4] # 'N'
		      cNotDef := ' SN '
		 ENDCASE
*--------------FIN LECTURA DE LA NOTA DEL AREA

*--------------CONTEO DE LAS FALLAS
		 cCamFal := 'NOT->cFa'+SUBS(aNotAre[i,6],9,4)+'Not'
		 cNroFal := 0
		 IF nNroPer == nTotPer
		    FOR k := 1 TO nNroPer
		       cNroFal += VAL(SUBS(&cCamFal,k*2-1,2))
		    NEXT
		 ELSE
		    cNroFal := VAL(SUBS(&cCamFal,nNroPer*2-1,2))
		 ENDIF
		 cNroFal := IF(EMPTY(cNroFal),SPACE(04),STR(cNroFal,4,0))
*--------------FIN CONTEO DE LAS FALLAS

*--------------INTENSIDAD HORARIA
		 IF VAL(aNotAre[i,11]) == 0
		    cIntens := SPACE(02)
		 ELSE
		    cIntens := aNotAre[i,11]
		 ENDIF
*--------------FIN INTENSIDAD HORARIA

*--------------IMPRESION DEL REGISTRO DEL AREA
		 cNomAre := aNotAre[i,3]
		 IF lNegAre
		    cNomAre := PCL('NegraOn')+cNomAre+PCL('NegraOf')
		 ENDIF

		 IF lHayNot .OR. lEvaInd
		    aRegPrn := {cIntens,;
				cNomAre+SPACE(108-LEN(aNotAre[i,3])),;
				IF(lHayNot,cNotDef,SPACE(04)),;
				cNroFal}
		 ELSE
		    aRegPrn := {cIntens,;
				cNomAre+SPACE(108-LEN(aNotAre[i,3])),;
				cNroFal}
		 ENDIF
		@ PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
*--------------FIN IMPRESION DEL REGISTRO DEL AREA

*--------------ANALISIS PARA EL CAMBIO DE PAGINA
		 IF PROW() > IIF(lOficio,70,58)
		    DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
		    EJECT

		    IF !EMPTY(bCabeza)
		       EVAL(bCabeza)
		      *Impresi¢n del Encabezado
		    ENDIF

		    cTxtPrn := cRegPrint(aTitulo,aNroCol)
		    SendCodes(PCL({'DraftOn','CondenOn'}))

		    @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
		    @ PROW()+1,00 SAY cTxtPrn
		    @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))

		    SendCodes(PCL({'NegraOf','DobGolOf'}))
		 ENDIF
*--------------FIN ANALISIS PARA EL CAMBIO DE PAGINA

*--------------IMPRESION DE LOS JUICIOS
		 cJuicio := &(aNotAre[i,6])
		 nNroInd := ROUND(LEN(ALLTRIM(cJuicio))/5,0)
		 FOR j:= 1 TO nNroInd

*   	      	    VALIDACION DEL JUICIO
		      cCodJui    := SUBS(cJuicio,j*5-4,5)
		      cCodLog    := SUBS(cCodJui,1,4)
		      cCodigoTev := SUBS(cCodJui,5,1)+SPACE(03)
		      IF EMPTY(cCodJui)
			 LOOP
		      ENDIF
*   		    FIN VALIDACION DEL JUICIO

*                   BUSQUEDA DE LA CLASE DE INDICADOR
		      cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
		      cCodigoTma := SUBS(aNotAre[i,6],9,4)

		      IF cCodLog # SPACE(04)
			 cCodigoTcl := UPPER(SUBS(cCodLog,1,1))
			 IF lLocCodigo('cCodigoCla','CLA',cCodigoTcl,;
				       'DE LA CLASE')

			    IF EMPTY(CLA->cCodigoMat)
			       cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
			       cCodigoTma := SUBS(aNotAre[i,6],9,4)
			    ELSE
			       cCodigoTni := SPACE(02)
			       cCodigoTma := CLA->cCodigoMat
			    ENDIF
			  *ÀAsignaci¢n del nivel para usar indicador nivel o materia

			 ENDIF
		      ENDIF
*                   FIN BUSQUEDA DE LA CLASE DE INDICADOR

*   		    BUSQUEDA DEL JUICIO
		      cCodigoTju := IF(lIndNiv,;
				       cCodigoTni+cCodigoTma+cCodLog,;
				       cCodigoTma+cCodLog)

		      cNombreTju := 'NO EXISTE EL CODIGO '+cCodJui
		      cNombreTju := SUBS(cNombreTju+SPACE(106),1,106)
		      IF lSekCodigo(cCodigoTju,'JUI')
			 cNombreTju := JUI->cNombreJui
		      ENDIF
*   		    FIN BUSQUEDA DEL JUICIO

*                   IMPRESION DEL JUICIO
		      IF lHayNot .OR. lEvaInd
			 aRegPrn := {cClaInd(cClaInd,cCodigoTcl),;
				     '- '+cNombreTju,;
				     IF(lEvaInd,cCodigoTev,SPACE(04)),;
				     SPACE(02)}
		      ELSE
			  aRegPrn := {cClaInd(cClaInd,cCodigoTcl),;
				      '- '+cNombreTju,;
				      SPACE(02)}
		      ENDIF
		      @PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
*                   FIN IMPRESION DEL JUICIO

*                   IMPRESION DE LOS INDICADORES EXTRAS
		      FOR x := 1 TO TCO->nJuiExtTbl

			  cNombreTju := &('JUI->cExtra'+STR(x,1)+'Jui')
			  IF lHayNot .OR. lEvaInd
			     aRegPrn := {SPACE(02),;
					 '  '+cNombreTju,;
					 SPACE(04),;
					 SPACE(02)}
			  ELSE
			      aRegPrn := {SPACE(02),;
					  '  '+cNombreTju,;
					  SPACE(02)}
			  ENDIF

			  IF !EMPTY(cNombreTju)
			     @PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
			  ENDIF

		      ENDFOR
*                   FIN IMPRESION DE LOS INDICADORES EXTRAS

*                   ANALISIS PARA EL CAMBIO DE PAGINA
		      IF PROW() > IIF(lOficio,70,58)
			 DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
			 EJECT

			 IF !EMPTY(bCabeza)
			    EVAL(bCabeza)
			   *Impresi¢n del Encabezado
			 ENDIF

			 cTxtPrn := cRegPrint(aTitulo,aNroCol)
			 SendCodes(PCL({'DraftOn','CondenOn'}))

			 @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
			 @ PROW()+1,00 SAY cTxtPrn
			 @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))

			 SendCodes(PCL({'NegraOf','DobGolOf'}))
		      ENDIF
*                   FIN ANALISIS PARA EL CAMBIO DE PAGINA

		 ENDFOR
*--------------FIN IMPRESION DE LOS JUICIOS

	    ENDIF
**********FIN IMPRESION DE LAS NOTAS DEL AREA

**********IMPRESION DE LAS NOTAS DE LA MATERIA
	    FOR j:=1 TO LEN(aNotMat)

	       IF aNotAre[i,2] == aNotMat[j,1]

*-----------------LECTURA DE LA NOTA DE LA MATERIA
		    cNotDef := SUBS(&(aNotMat[j,4]),nNroPer*4-3,4)
		   *Nota de la materia

		    DO CASE
		    CASE VAL(cNotDef) == 0
*			 cNotDef := ' SN '
		    ENDCASE
*-----------------FIN LECTURA DE LA NOTA DE LA MATERIA

*-----------------CONTEO DE LAS FALLAS
		    cCamFal := aNotMat[j,6]
		    cNroFal := 0
		    IF nNroPer == nTotPer
		       FOR k := 1 TO nNroPer
			  cNroFal += VAL(SUBS(&cCamFal,k*2-1,2))
		       NEXT
		    ELSE
		       cNroFal := VAL(SUBS(&cCamFal,nNroPer*2-1,2))
		    ENDIF
		    cNroFal := IF(EMPTY(cNroFal),SPACE(04),STR(cNroFal,4,0))
*-----------------FIN CONTEO DE LAS FALLAS

*-----------------IMPRESION DEL REGISTRO DEL AREA
		    IF VAL(aNotMat[j,3]) == 0
		       cIntens := SPACE(02)
		    ELSE
		       cIntens := aNotMat[j,3]
		    ENDIF
		  *ÀLectura de la Intensidad horaria

		    IF lPrnAre

		       cNomMat := ALLTRIM(aNotAre[i,3])+' : '+aNotMat[j,10]
		     *ÀMateria Notas o Certificado

		       nLenTxt := LEN(cNomMat)
		       cNomMat := cNomMat+SPACE(108-nLenTxt)
		    ELSE
		       cNomMat := aNotMat[j,2]+SPACE(108-LEN(aNotMat[j,10]))
		     *ÀMateria Notas o Certificado
		    ENDIF

		    cNomMat := SUBS(cNomMat+SPACE(108),1,108)
		    IF lNegAre
		       cNomMat := PCL('NegraOn')+cNomMat+PCL('NegraOf')
		    ENDIF

		    IF lHayNot .OR. lEvaInd
		       aRegPrn := {cIntens,;
				   cNomMat,;
				   IF(lHayNot,cNotDef,SPACE(04)),;
				   cNroFal}
		    ELSE
		       aRegPrn := {cIntens,;
				   cNomMat,;
				   cNroFal}
		    ENDIF
		    cTxtPrn := cRegPrint(aRegPrn,aNroCol)
		    @PROW()+1,00 SAY cTxtPrn
*-----------------FIN IMPRESION DEL REGISTRO DEL AREA

*-----------------ANALISIS PARA EL CAMBIO DE PAGINA
		    IF PROW() > IIF(lOficio,70,58)
		       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
		       EJECT

		       IF !EMPTY(bCabeza)
			  EVAL(bCabeza)
			 *Impresi¢n del Encabezado
		       ENDIF

		       cTxtPrn := cRegPrint(aTitulo,aNroCol)
		       SendCodes(PCL({'DraftOn','CondenOn'}))

		       @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
		       @ PROW()+1,00 SAY cTxtPrn
		       @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))

		       SendCodes(PCL({'NegraOf','DobGolOf'}))
		    ENDIF
*-----------------FIN ANALISIS PARA EL CAMBIO DE PAGINA

*-----------------IMPRESION DE LOS JUICIOS
		    cJuicio := &(aNotMat[j,5])
		    nNroInd := ROUND(LEN(ALLTRIM(cJuicio))/5,0)
		    FOR k:= 1 TO nNroInd

*			VALIDACION DEL JUICIO
			  cCodJui    := SUBS(cJuicio,k*5-4,5)
			  cCodLog    := SUBS(cCodJui,1,4)
			  cCodigoTev := SUBS(cCodJui,5,1)+SPACE(03)
			  IF EMPTY(cCodJui)
			     LOOP
			  ENDIF
*			FIN VALIDACION DEL JUICIO

*                      BUSQUEDA DE LA CLASE DE INDICADOR
			 cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
			 cCodigoTma := SUBS(aNotMat[j,11],3,4)

			 IF cCodLog # SPACE(04)
			    cCodigoTcl := UPPER(SUBS(cCodLog,1,1))
			    IF lLocCodigo('cCodigoCla','CLA',cCodigoTcl,;
					  'DE LA CLASE')

			       IF EMPTY(CLA->cCodigoMat)
				  IF EMPTY(SUBS(aNotMat[j,11],1,2))
				     cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
				    *Por nivel
				  ELSE
				     cCodigoTni := SUBS(aNotMat[j,11],1,2)
				    *Por Niveles
				  ENDIF
			       ELSE
				  cCodigoTni := SPACE(02)
				  cCodigoTma := CLA->cCodigoMat
			       ENDIF
			     *ÀAsignaci¢n del nivel para usar indicador nivel o materia

			    ENDIF
			 ENDIF
*                      FIN BUSQUEDA DE LA CLASE DE INDICADOR

*			BUSQUEDA DEL JUICIO
			  cCodigoTju := IF(lIndNiv,;
					   cCodigoTni+cCodigoTma+cCodLog,;
					   cCodigoTma+cCodLog)

			  cNombreTju := 'NO EXISTE EL CODIGO '+cCodJui
			  cNombreTju := SUBS(cNombreTju+SPACE(106),1,106)
			  IF lSekCodigo(cCodigoTju,'JUI')
			     cNombreTju := JUI->cNombreJui
			  ENDIF
*			FIN BUSQUEDA DEL JUICIO

*                       IMPRESION DEL JUICIO
			  IF lHayNot .OR. lEvaInd
			     aRegPrn := {cClaInd(cClaInd,cCodigoTcl),;
					 '- '+cNombreTju,;
					 IF(lEvaInd,cCodigoTev,SPACE(04)),;
					 SPACE(02)}
			  ELSE
			     aRegPrn := {cClaInd(cClaInd,cCodigoTcl),;
					 '- '+cNombreTju,;
					 SPACE(02)}
			  ENDIF
			  @PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
*                       FIN IMPRESION DEL JUICIO

*                       IMPRESION DE LOS INDICADORES EXTRAS
			  FOR x := 1 TO TCO->nJuiExtTbl

			      cNombreTju := &('JUI->cExtra'+STR(x,1)+'Jui')
			      IF lHayNot .OR. lEvaInd
				 aRegPrn := {SPACE(02),;
					     '  '+cNombreTju,;
					     SPACE(04),;
					     SPACE(02)}
			      ELSE
				  aRegPrn := {SPACE(02),;
					      '  '+cNombreTju,;
					      SPACE(02)}
			      ENDIF

			      IF !EMPTY(cNombreTju)
				 @PROW()+1,00 SAY cRegPrint(aRegPrn,aNroCol)
			      ENDIF

			  ENDFOR
*                       FIN IMPRESION DE LOS INDICADORES EXTRAS

*                       ANALISIS PARA EL CAMBIO DE PAGINA
			  IF PROW() > IIF(lOficio,70,58)
			     DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
			     EJECT
			     OtraPagina(PCL({"DraftOn","CondenOn"}),;
					PCL({"NegraOf","DobGolOf"}),;
					aTitulo,aNroCol,bCabeza)
			  ENDIF
*                       FIN ANALISIS PARA EL CAMBIO DE PAGINA

		    ENDFOR
*-----------------FIN IMPRESION DE LOS JUICIOS

	       ENDIF
	    ENDFOR
**********FIN IMPRESION DE LAS NOTAS DE LA MATERIA

**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > IIF(lOficio,70,58)
	       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
	       EJECT
	       lPagina := .T.
	    ELSE
	       lPagina := .F.
	    ENDIF
**********FIN ANALISIS PARA EL CAMBIO DE PAGINA

       ENDFOR
       nLenTxt := LEN(cTxtPrn)
*>>>>FIN IMPRESION DE LAS NOTAS

*>>>>ANALISIS PARA EL CAMBIO DE PAGINA
       IF PROW() > IIF(lOficio,70,58) - nTotImp .OR. PROW() = 0
	  IF PROW() <> 0
	     IF PROW() <= IIF(lOficio,70,58)
		DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
	     ENDIF
	     EJECT
	  ENDIF
	  OtraPagina(PCL({"DraftOn","CondenOn"}),;
		     PCL({"NegraOf","DobGolOf"}),;
		     aTitulo,aNroCol,bCabeza)
       ENDIF
*>>>>FIN ANALISIS PARA EL CAMBIO DE PAGINA

*>>>>IMPRESION DE LAS AREAS HABILITAR
       IF nNroPer == nTotPer .AND. !EMPTY(NOT->cMatHabNot)

**********IMPRESION DE LOS DETALLES DE LA HABILITACION
	    @PROW()+2,00 SAY 'HABILITACIONES'
	    @PROW()  ,32 SAY 'NOTA  ACTA  FECHA'
	    FOR k := 1 TO LEN(ALLTRIM(NOT->cMatHabNot))/4

*--------------LOCALIZACION DE LA MATERIAS A HABILITAR
		 cCodigoTma := SUBS(NOT->cMatHabNot,k*4-3,4)
		 cNombreTma := 'FAVOR VERIFICAR'
		 IF lLocCodigo('cCodigoMat','MAT',cCodigoTma,;
				     'DEL AREA')
		    cNombreTma := MAT->cNombreMat
		 ENDIF
*--------------FIN LOCALIZACION DE LA MATERIAS A HABILITAR

*--------------IMPRESION DE LA HABILITACION
		 cNotHabTno := SUBS(NOT->cNotHabNot,k*4-3,4)
		 cFecHabTno := cFecha(NOT->dFecHabNot)
		 @PROW()+1,00 SAY cNombreTma     +SPACE(02)+;
				  cNotHabTno     +SPACE(02)+;
				  NOT->cActHabNot+SPACE(02)+;
				  cFecHabTno
*--------------FIN IMPRESION DE LA HABILITACION

	    ENDFOR
**********FIN IMPRESION DE LOS DETALLES DE LA HABILITACION

       ENDIF
*>>>>FIN IMPRESION DE LAS AREAS HABILITAR

*>>>>ANALISIS PARA EL CAMBIO DE PAGINA
       IF PROW() > 46
	  DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
	  EJECT
	  OtraPagina(PCL({"DraftOn","CondenOn"}),;
		     PCL({"NegraOf","DobGolOf"}),;
		     aTitulo,aNroCol,bCabeza)
       ENDIF
*>>>>FIN ANALISIS PARA EL CAMBIO DE PAGINA

*>>>>IMPRESION DE LA PROMOCION FINAL
       cEstado := ''
       IF nNroPer == nTotPer
	  IF lRetEst
	     cEstado := 'NO TERMINO. SE RETIRO EN '+cFecha(dFecRet)+' '+;
			&cMaeAct->cObsRetEst
	  ELSE
	     cEstado := cAproboJui(NOT->nAproboNot)
	  ENDIF
	  cEstado := ALLTRIM(cEstado)
	 *Estado final del estudiante
       ENDIF
       aNroLin := aDivLin(ALLTRIM('OBSERVACION FINAL: '+cEstado),110)
       FOR i := 1 TO LEN(aNroLin)
	   @ PROW()+1,00 SAY aNroLin[i]
       NEXT
*>>>>FIN IMPRESION DE LA PROMOCION FINAL

*>>>>IMPRESION DE LAS RECUPERACIONES COMO OBSERVACIONES
       IF !EMPTY(aMatHab)
	  @ PROW()+1,00 SAY ''
	  cTxtPrn := IF(EMPTY(TCO->cTitRecTbl),;
		     'ACTIVIDADES DE RECUPERACION DE',;
			ALLTRIM(TCO->cTitRecTbl))+':'
	  FOR i := 1 TO LEN(aMatHab)
	      cTxtPrn += ALLTRIM(aMatHab[i,5])+': '
	      IF ALLTRIM(cTxtNota(aMatHab[i,4])) == 'SIN NOTA'
		 cTxtPrn += 'PENDIENTE. '

	      ELSE
		 cTxtPrn += ALLTRIM(cTxtNota(aMatHab[i,4]))+;
			    ' - ACTA No.'+ALLTRIM(aMatHab[i,3])+;
			    ' DE '+aMatHab[i,2]+'. '
	      ENDIF
	  NEXT
	  aNroLin := aDivLin(ALLTRIM(cTxtPrn),110)
	  FOR i := 1 TO LEN(aNroLin)
	      @ PROW()+1,00 SAY aNroLin[i]
	  NEXT
       ENDIF
*>>>>FIN IMPRESION DE LAS RECUPERACIONES COMO OBSERVACIONES

*>>>>IMPRESION DE LA OBSERVACION
       IF !EMPTY(&cMaeAct->cObsLibEst)
	  aNroLin := aDivLin(ALLTRIM(&cMaeAct->cObsLibEst),110)
	  FOR i := 1 TO LEN(aNroLin)
	      @ PROW()+1,00 SAY aNroLin[i]
	  NEXT
       ENDIF
     *ÀObservaci¢n General.

       @ PROW()+2,00 SAY 'OBSERVACIONES:'
       @ PROW()+1,00 SAY REPL('-',nLenTxt)
       @ PROW()+1,00 SAY REPL('-',nLenTxt)
       @ PROW()+1,00 SAY REPL('-',nLenTxt)
       @ PROW()+1,00 SAY REPL('-',nLenTxt)
       @ PROW()+1,00 SAY REPL('-',nLenTxt)
     *ÀImpresi¢n l¡neas de la observaci¢n
*>>>>FIN IMPRESION DE LA OBSERVACION

*>>>>IMPRESION DE LA FIRMA
       IF LEN(aFirmas) == 1
	  cTxtPrn := 'Dir. '+aFirmas[1]
	  @ PROW()+4,(nLenPrn-LEN(cTxtPrn))/2 SAY REPL('-',LEN(cTxtPrn)+4)
	  @ PROW()+1,((nLenPrn-LEN(cTxtPrn))/2)+2 SAY cTxtPrn
       ELSE
	  Firmas(PCL('n17Stan'),4,aFirmas)
	 *Impresi¢n firmantes del libro
       ENDIF
       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
       EJECT
       RETURN NIL
*>>>>FIN IMPRESION DE LA FIRMA

/*************************************************************************
* TITULO..: IMPRESION DEL LIBRO FINAL No. 03                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 26/2003 LUN A
       Colombia, Bucaramanga        INICIO: 10:10 PM   MAY 26/2003 LUN

OBJETIVOS:

1- Imprime el libro final modelo sugerido por el Colegio de la Salle
   de Bogot .

2- Libro final No. 03 no imprime los juicios valorativos, s¢lo las
   asignaturas con los juicios valorativos, la intensidad horaria
   y las ausencias.

3- Debe estar en uso el archivo de notas del grupo correspondiente.

4- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION LibroFin03(cEmpPal,cNomEmp,cNomSis,cAnoUsr,cNomEst,lRetEst,dFecRet,;
		    aFirmas,cJorTxt,aNotAre,aNotMat,cNroFol,cMaeAct,cTxtLib,;
		    lInfFin,cMatMod)

*>>>>PARAMETROS DE LA FUNCION
/*     cEmpPal                              // Nombre de la Empresa principal
       cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       cAnoUsr			            // A¤o del Usuario
       cNomEst                              // Nombre del estudiante
       lRetEst                              // .T. Retirado
       dFecRet                              // Fecha de Retiro
       aFirmas                              // Firmas del libro
       cNomTit                              // Nombre del titular
       cJorTxt                              // Jornada escogida
       aNotAre                              // Detalles de las areas
       aNotMat                              // Detalles de las materias
       cNroFol                              // N£mero del Folio
       cMaeAct                              // Maestro Actual
       cTxtLib                              // Texto para el libro
       lInfFin                              // .T. Informe Final .F. Libro Final
       cMatMod                              // Materia de Modalidad o Especialidad */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL   i,j,k := 0                   // Contadores

       LOCAL aNroCol := {}                  // Columnas de los titulos
       LOCAL aTitulo := {}                  // T¡tulos para el informe
       LOCAL aRegPrn := {}                  // Registro de impresion

       LOCAL lPagina := .T.                 // .T. Cambio de p gina
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL nTotCab := 0                   // Total l¡neas del encabezado
       LOCAL nTotReg := 0                   // Total registros a imprimir
       LOCAL nTotImp := 0                   // Totales de impresion
       LOCAL cTxtPrn := ''                  // Texto de impresion
       LOCAL nLenPrn := PCL('n17Stan')      // Longitud de impresi¢n

       LOCAL cNomSec := ''                  // Nombre Secundario.
       LOCAL lPrnEmp := .F.                 // .T. Imprimir la Empresa
       LOCAL lPrnAre := .F.                 // .T. Imprimir el  rea
       LOCAL lNegAre := .F.                 // .T. Imprimir en negrilla el  rea
       LOCAL lPrnNot := .F.                 // .T. Imprimir la nota
       LOCAL lHayNot := .F.                 // .T. Hay Notas
       LOCAL lNotNum := .F.                 // .T. Nota Numerica .F. Nota Cualitativa
       LOCAL lHabObs := .F.                 // .T. Habilitacion Columna .F. Habilitaci¢n como observaci¢n
       LOCAL cMsgBol := ''                  // Mensaje para el boletin
       LOCAL cNotAcu := ''                  // Notas Acumuladas
       LOCAL lMatVar := .F.                 // .T. Imprimir Materia Variable

       LOCAL cNroCol := ''                  // N£mero de columnas
       LOCAL cNotDef := ''                  // Nota de area o materia

       LOCAL cCamFal := ''                  // Campo de las fallas

       LOCAL nMarSup := 0                   // Margen Superior
       LOCAL nLinCab := 0                   // L¡neas del Encabezado
       LOCAL nLinCol := 0                   // L¡neas de Columnas
       LOCAL nEncCol := 0                   // Encabezados de Columna
       LOCAL nLinTop := 0                   // L¡neas del Top


       LOCAL nNroPer := 0                   // N£mero del Bimestre
       LOCAL bCabeza := NIL                 // Code Block
       LOCAL lOficio := .F.                 // .F. Tama¤o carta
       LOCAL nTotPer := 0                   // Total de periodos
       LOCAL nNroArn := 0                   // N£mero areas no promediables
       LOCAL nJuiMat := 0                   // Total Juicios Materias
       LOCAL cCodAre := ''                  // C¢digo del area
       LOCAL cNomAre := ''                  // Nombre del area
       LOCAL cNomMat := ''                  // Nombre de la materia
       LOCAL cEvalua := ''                  // Evaluaci¢n conceptual
       LOCAL cCodJui := ''                  // C¢digo del juicio
       LOCAL cEstado := ''                  // Estado final de aprobaci¢n
       LOCAL aMatHab := {}                  // Detalles de la Recuperaci¢n
       LOCAL cNroMat := ''                  // N£mero de la Matricula

       LOCAL cCodigoTju := ''               // C¢digo del juicio
       LOCAL cNombreTju := ''               // Nombre del juicio
       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL cNombreTma := ''               // Nombre de la materia
       LOCAL cNotHabTno := ''               // Nota de la habilitaci¢n
       LOCAL cFecHabTno := ''               // Fecha de la habilitaci¢n
       LOCAL cCodigoTni := ''               // C¢digo del nivel
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO TOTAL DE AREAS
       nNroArn := 0
       FOR i:=1 TO LEN(aNotAre)
	  IF SUBS(aNotAre[i][4],7,4) == 'AREN'
	     nNroArn ++
	  ENDIF
       ENDFOR
       cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
*>>>>FIN CALCULO TOTAL DE AREAS

*>>>>LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD
       nTotPer := TCO->nTotPerTbl
       lOficio := TCO->lOficioTbl
       lHabObs := TCO->lHabObsTbl
       nNroPer := nTotPer
       lPrnEmp := TCO->lPrnEmpTbl
       lPrnAre := TCO->lPrnAreTbl
       lNegAre := TCO->lNegAreTbl
       lPrnNot := IF(SUBS(TCO->cPrnNotTbl,nNroPer,1)='1',.T.,.F.)
       lHayNot := IF(SUBS(TCO->cHayNotTbl,nNroPer,1)='1',.T.,.F.)
       lNotNum := IF(SUBS(TCO->cNotNumTbl,nNroPer,1)='1',.T.,.F.)
       cNotAcu := TCO->cNotAcuTbl

       cNroFol := 'FOLIO No._______'
       cNroFol := PCL("CondenOn")+SPACE(01)+cNroFol+PCL("CondenOf")

       cNroMat := IF(EMPTY(TCO->cNroMatTbl),;
		    'MATRICULA No._______',TCO->cNroMatTbl)
       IF .NOT. EMPTY(cNroMat)
	  cNroMat := PCL("CondenOn")+ALLTRIM(cNroMat)+PCL("CondenOf")
       ENDIF

       cMsgBol := ALLTRIM(TCO->cMsgBolTbl)
       IF !lPrnNot
	  lHayNot := .F.
       ENDIF

       IF !lHayNot
	  lNotNum := .F.
       ENDIF
*>>>>FIN LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD

*>>>>CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR
       IF lPrnEmp
	  nTotImp := IF(nNroPer==nTotPer,15,08)
       ELSE
	  nTotImp := IF(nNroPer==nTotPer,15,11)
       ENDIF
      *L¡neas de los totales de impresi¢n

       nMarSup := TCO->nLinEspTbl
       nLinCab := 9
       nTotCab := IIF(nMarSup > nLinCab, nMarSup - nLinCab, 0)
     *Encabezado de columna

       nEncCol := 3
       nLinTop := nTotCab+nEncCol
     *Total l¡neas del encabezado

      nTotReg := nLinTop+nNroArn+LEN(aNotMat)+nTotImp
      nTotReg := 0
     *Total de registros a imprimir
*>>>>FIN CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR

*>>>>IMPRESION DE LA HOJA DEL LIBRO
       bCabeza := {||CabezaLib(TCO->nLinEspTbl,; // Espacios para el encabezado
			       cNomEmp,;         // Nombre de la Empresa
			       lPrnEmp,;         // .T. Imprimir la Empresa
			       cNomSec,;         // Nombre Secundario
			       cAnoUsr,;         // A¤o del Usuario
			       cJorTxt,;         // Jornada escogida
			       NOT->cCodigoEst,; // C¢digo del Estudiante
			       cNomEst,;         // Nombre del Estudiante
			       GRU->cCodigoGru,; // C¢digo del Grupo
			       NOT->(RECNO()),;  // N£mero de Lista
			       0,;               // N£mero del Periodo. 0=>Libro Final
			       nNroPag++,;       // N£mero de p gina
			       cMatMod,;         // Materia de Modalidad
			       cNroMat,;         // N£mero de Matr¡cula
			       cNroFol,;         // N£mero de Folio
			       cTxtLib,;         // Texto del Libro
			       lInfFin,;         // .T. Informe Final
			       IF(lInfFin,TCO->cTitBolTbl,''))} // T¡tulo Superior

       lMatVar := .T.
       aMatHab := aMatHabPla(NOT->nAproboNot,aNotAre,aNotMat,nTotPer,lNotNum,;
			     lMatVar)
      *Materias de las Recuperaciones

       CuerpLib03(cNomSis,cJorTxt,cMsgBol,lRetEst,dFecRet,lNotNum,aNotAre,;
		  aNotMat,nNroPer,cNomEmp,lPrnEmp,cNroFol,lNegAre,bCabeza,;
		  aFirmas,lHayNot,lPrnAre,lOficio,cMaeAct,lHabObs,aMatHab,;
		  lInfFin,cNotAcu)

       RETURN NIL
*>>>>FIN IMPRESION DE LA HOJA DEL LIBRO


/*************************************************************************
* TITULO..: CUERPO DEL LIBRO FINAL No. 03                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 26/2003 LUN A
       Colombia, Bucaramanga        INICIO: 10:10 PM   MAY 26/2003 LUN

OBJETIVOS:

1- El cuerpo del libro est  formado por el encabezado y las asignaturas.

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CuerpLib03(cNomSis,cJorTxt,cMsgBol,lRetEst,dFecRet,lNotNum,;
		    aNotAre,aNotMat,nNroPer,cNomEmp,lPrnEmp,cNroFol,;
		    lNegAre,bCabeza,aFirmas,lHayNot,lPrnAre,lOficio,;
		    cMaeAct,lHabObs,aMatHab,lInfFin,cNotAcu)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomSis                              // Nombre del Sistema
       cJorTxt                              // Jornada escogida
       cMsgBol                              // T¡tulo de Encabezado
       lRetEst                              // .T. Estudiante Retirado
       dFecRet                              // Fecha de Retiro
       lNotNum                              // .F. Nota Cualitativa
       aNotAre                              // Detalles de las areas
       aNotMat                              // Detalles de las materias
       nNroPer			            // N£mero del Periodo
       cNomEmp                              // Nombre de la Empresa
       lPrnEmp                              // .T. Imprimir la Empresa
       cNroFol                              // N£mero del Folio
       lNegAre                              // .T. Areas en negrilla
       bCabeza                              // Funci¢n con Encabezado
       aFirmas                              // Firmas del libro.
       lHayNot                              // .T. Hay Notas
       lPrnAre                              // .T. Imprimir las areas
       lOficio                              // .F. Tama¤o Carta
       cMaeAct                              // Maestro Actual
       lHabObs                              // .T. Habilitaci¢n como observaci¢n .F. Habilitaci¢n en Columna
       aMatHab                              // Materias por Habilitar
       lInfFin                              // .T. Informe Final .F. Libro Final
       cNotAcu                              // Notas Acumuladas */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL i,j,k,p := 0                   // Contadores

       LOCAL aNroCol := {}                  // Columnas de los titulos
       LOCAL aTitulo := {}                  // T¡tulos para el informe
       LOCAL aRegPrn := {}                  // Registro de impresion

       LOCAL lPagina := .T.                 // .T. Cambio de p gina
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL nTotCab := 0                   // Total l¡neas del encabezado
       LOCAL nTotImp := 0                   // Totales de impresion
       LOCAL cTxtPrn := ''                  // Texto de impresion
       LOCAL nLenPrn := PCL('n17Stan')      // Longitud de impresi¢n

       LOCAL cNroCol := ''                  // N£mero de columnas
       LOCAL cCamFal := ''                  // Campo de las fallas

       LOCAL nTotPer := 0                   // Total de periodos.
       LOCAL nNroArn := 0                   // N£mero areas no promediables
       LOCAL cCodAre := ''                  // C¢digo del area
       LOCAL cNomAre := ''                  // Nombre del area
       LOCAL cNomMat := ''                  // Nombre de la materia
       LOCAL cEvalua := ''                  // Evaluaci¢n conceptual
       LOCAL cEstado := ''                  // Estado final de aprobaci¢n
       LOCAL cIntens := ''                  // Intensidad Horaria
       LOCAL cNroFal := ''                  // N£mero de Ausencias
       LOCAL nLenTxt := ''                  // Longitud del texto
       LOCAL aNroLin := {}                  // N£mero de l¡neas
       LOCAL nPosHab := 0                   // Posici¢n de la Habilitaci¢n
       LOCAL cNotDef := ''                  // Nota Definitiva materia o area
       LOCAL cNotRec := ''                  // Nota de Recuperaci¢n
       LOCAL cNota   := ''                  // Notas

       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL cNombreTma := ''               // Nombre de la materia
       LOCAL cNotHabTno := ''               // Nota de la habilitaci¢n
       LOCAL cFecHabTno := ''               // Fecha de la habilitaci¢n
       LOCAL cCodigoTev := ''               // C¢digo de la Evaluaci¢n
       LOCAL cCodigoTni := ''               // C¢digo del nivel
       LOCAL cCodigoTcl := ''               // C¢digo de la clase
       LOCAL cTxtObsTap := ''               // Texto de Observaci¢n de Promoci¢n.

       LOCAL cCamNotDef := ''               // Campo de Notas Definitivas
       LOCAL cCamNotRec := ''               // Campo de Notas de Recuperaci¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {80,02,04}
       aTitulo := {'AREAS O ASIGNATURAS','IH','AUS.'}

       IF !EMPTY(cNotAcu)
	  FOR i := 1 TO nNroPer
	      AADD(aNroCol,2)
	      AADD(aTitulo,SUBS(cNotAcu,i*2-1,2))
	  ENDFOR
       ENDIF
       AADD(aNroCol,14)
       AADD(aTitulo,'EVALUACION')
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>IMPRESION DE LAS NOTAS
       nTotPer := TCO->nTotPerTbl
       FOR i:=1 TO LEN(aNotAre)

***********IMPRESION DEL ENCABEZADO
	    IF lPagina
	       OtraPagina(PCL({"DraftOn","CondenOn"}),;
			  PCL({"NegraOf","DobGolOf"}),;
			  aTitulo,aNroCol,bCabeza)
	    ENDIF
***********FIN IMPRESION DEL ENCABEZADO

**********IMPRESION DE LAS NOTAS DEL AREA
	    IF SUBS(aNotAre[i][4],7,4) == 'AREN'

*--------------ANALISIS DE LA IMPRESION DEL AREA
		 IF aNotAre[i][12]  // .T. No Imprimir
		    LOOP
		 ENDIF
*--------------FIN ANALISIS DE LA IMPRESION AREA

*--------------LECTURA DE LA NOTA DEL AREA
		 IF EMPTY(cNotAcu)
		    cCamNotDef := aNotAre[i,4]
		    cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

		    cNotDef := ALLTRIM(SUBS(&cCamNotDef,nNroPer*4-3,4))
		    cNotRec := ALLTRIM(SUBS(&cCamNotRec,nNroPer*4-3,4))
		    IF TCO->lRecNotTbl .AND. !EMPTY(cNotRec)
		       cNotDef := cNotRec
		    ENDIF
		 ENDIF
*--------------FIN LECTURA DE LA NOTA DEL AREA

*--------------LECTURA NOTAS ACUMULADAS DEL AREA
		 cNota := ''
		 IF !EMPTY(cNotAcu)

		    cCamNotDef := aNotAre[i,4]
		    cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

		    FOR p := 1 TO nNroPer

			cNotDef := SUBS(&cCamNotDef,p*4-3,4)
			cNotRec := SUBS(&cCamNotRec,p*4-3,4)

			IF !EMPTY(cNotRec)
			   cNota += ALLTRIM(cNotDef)+;
				    LOWER(ALLTRIM(cNotRec))+SPACE(02)
			ELSE
			   cNota += cNotDef
			ENDIF

			IF TCO->lRecNotTbl .AND. !EMPTY(cNotRec)
			   cNotDef := cNotRec
			ENDIF

		   ENDFOR
		 ENDIF
*--------------FIN LECTURA NOTAS ACUMULADAS DEL AREA

*--------------CONTEO DE LAS FALLAS
		 cCamFal := 'NOT->cFa'+SUBS(aNotAre[i,6],9,4)+'Not'
		 cNroFal := 0
		 IF nNroPer == nTotPer
		    FOR k := 1 TO nNroPer
		       cNroFal += VAL(SUBS(&cCamFal,k*2-1,2))
		    NEXT
		 ELSE
		    cNroFal := VAL(SUBS(&cCamFal,nNroPer*2-1,2))
		 ENDIF
		 cNroFal := IF(EMPTY(cNroFal),SPACE(02),STR(cNroFal,2,0))
*--------------FIN CONTEO DE LAS FALLAS

*--------------INTENSIDAD HORARIA DEL AREA
		 cIntens := IF(EMPTY(aNotAre[i,16]),aNotAre[i,11],aNotAre[i,16])
		 IF EMPTY(cIntens)
		    cIntens := SPACE(02)
		 ENDIF
*--------------FIN INTENSIDAD HORARIA DEL AREA

*--------------IMPRESION DEL REGISTRO DEL AREA
		 cNomAre := aNotAre[i,3]+SPACE(80-LEN(aNotAre[i,3]))
		 aRegPrn := {cNomAre,cIntens,cNroFal}

		 IF !EMPTY(cNotAcu)
		    FOR p := 1 TO nNroPer
			AADD(aRegPrn,ALLTRIM(SUBS(cNota,p*4-3,4)))
		    ENDFOR
		    cNotDef := ALLTRIM(SUBS(cNota,nNroPer*4-3,4))

		    IF LEN(cNotDef) == 2
		       cNotDef := SUBS(cNotDef,2,1)
		    ENDIF
		 ENDIF

		 AADD(aRegPrn,ALLTRIM(cTxtNota(UPPER(cNotDef),.T.)))
		 cTxtPrn := cRegPrint(aRegPrn,aNroCol)
		 @ PROW()+1,00 SAY cTxtPrn
*--------------FIN IMPRESION DEL REGISTRO DEL AREA

*--------------ANALISIS PARA EL CAMBIO DE PAGINA
		 IF PROW() > IIF(lOficio,70,58)
		    DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
		    EJECT
		    OtraPagina(PCL({"DraftOn","CondenOn"}),;
			       PCL({"NegraOf","DobGolOf"}),;
			       aTitulo,aNroCol,bCabeza)
		 ENDIF
*--------------FIN ANALISIS PARA EL CAMBIO DE PAGINA

	    ENDIF
**********FIN IMPRESION DE LAS NOTAS DEL AREA

**********IMPRESION DE LAS NOTAS DE LA MATERIA
	    FOR j:=1 TO LEN(aNotMat)

	       IF aNotAre[i,2] == aNotMat[j,1]

*-----------------ANALISIS DE LA IMPRESION DE LA MATERIA
		    IF aNotMat[j][12]   // .T. No Imprimir
		       LOOP
		    ENDIF
*-----------------FIN ANALISIS DE LA IMPRESION DE LA MATERIA

*-----------------LECTURA DE LA NOTA DE LA MATERIA
		    IF EMPTY(cNotAcu)
		       cCamNotDef := aNotMat[j,4]
		       cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

		       cNotDef := SUBS(&cCamNotDef,nNroPer*4-3,4)
		       cNotRec := SUBS(&cCamNotRec,nNroPer*4-3,4)

		       IF TCO->lRecNotTbl .AND. !EMPTY(cNotRec)
			  cNotDef := cNotRec
		       ENDIF
		    ENDIF
*-----------------FIN LECTURA DE LA NOTA DE LA MATERIA

*-----------------LECTURA NOTAS ACUMULADAS DE LA MATERIA
		    cNota := ''
		    IF !EMPTY(cNotAcu)

		       cCamNotDef := aNotMat[j,4]
		       cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

		       FOR p := 1 TO nNroPer

			   cNotDef := SUBS(&cCamNotDef,p*4-3,4)
			   cNotRec := SUBS(&cCamNotRec,p*4-3,4)

			   IF !EMPTY(cNotRec)
			      cNota += ALLTRIM(cNotDef)+;
				       LOWER(ALLTRIM(cNotRec))+SPACE(02)
			   ELSE
			      cNota += cNotDef
			   ENDIF

			   IF TCO->lRecNotTbl .AND. !EMPTY(cNotRec)
			      cNotDef := cNotRec
			   ENDIF

		      ENDFOR
		    ENDIF
*-----------------FIN LECTURA NOTAS ACUMULADAS DE LA MATERIA

*-----------------CONTEO DE LAS FALLAS DE LA MATERIA
		    cCamFal := aNotMat[j,6]
		    cNroFal := 0
		    IF nNroPer == nTotPer
		       FOR k := 1 TO nNroPer
			  cNroFal += VAL(SUBS(&cCamFal,k*2-1,2))
		       NEXT
		    ELSE
		       cNroFal := VAL(SUBS(&cCamFal,nNroPer*2-1,2))
		    ENDIF
		    cNroFal := IF(EMPTY(cNroFal),SPACE(02),STR(cNroFal,2,0))
*-----------------FIN CONTEO DE LAS FALLAS DE LA MATERIA

*-----------------INTENSIDAD HORARIA DE LA MATERIA
		    cIntens := IF(EMPTY(aNotMat[j,16]),aNotMat[j,3],aNotMat[j,16])
		    IF EMPTY(cIntens)
		       cIntens := SPACE(02)
		    ENDIF
*-----------------FIN INTENSIDAD HORARIA DE LA MATERIA

*-----------------IMPRESION DEL REGISTRO DE LA MATERIA
		    cNomMat := aNotMat[j,10]+SPACE(80-LEN(aNotMat[j,10]))
		  *ÀMateria Notas o Certificado

		    IF !EMPTY(TCO->cSpaBolTbl)
		       IF aNotMat[j,1] == cCodAre .AND. SUBS(aNotMat[j,5],11,2) # '00'
			  cNomMat := SUBS(SPACE(02)+cNomMat,1,80)
		       ELSE
			  cCodAre := aNotMat[j,1]
		       ENDIF
		    ENDIF
		  *ÀIndentaci¢n de la materia

		    aRegPrn := {cNomMat,cIntens,cNroFal}

		    IF !EMPTY(cNotAcu)
		       FOR p := 1 TO nNroPer
			   AADD(aRegPrn,ALLTRIM(SUBS(cNota,p*4-3,4)))
		       ENDFOR
		       cNotDef := ALLTRIM(SUBS(cNota,nNroPer*4-3,4))

		       IF LEN(cNotDef) == 2
			  cNotDef := SUBS(cNotDef,2,1)
		       ENDIF
		    ENDIF

		    AADD(aRegPrn,ALLTRIM(cTxtNota(UPPER(cNotDef),.T.)))
		    cTxtPrn := cRegPrint(aRegPrn,aNroCol)
		    @ PROW()+1,00 SAY cTxtPrn
*-----------------FIN IMPRESION DEL REGISTRO DE LA MATERIA

*-----------------ANALISIS PARA EL CAMBIO DE PAGINA
		    IF PROW() > IIF(lOficio,70,58)
		       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
		       EJECT
		       OtraPagina(PCL({"DraftOn","CondenOn"}),;
				  PCL({"NegraOf","DobGolOf"}),;
				  aTitulo,aNroCol,bCabeza)
		    ENDIF
*-----------------FIN ANALISIS PARA EL CAMBIO DE PAGINA

	       ENDIF
	    ENDFOR
**********FIN IMPRESION DE LAS NOTAS DE LA MATERIA

**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > IIF(lOficio,70,58)
	       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
	       EJECT
	       lPagina := .T.
	    ELSE
	       lPagina := .F.
	    ENDIF
**********FIN ANALISIS PARA EL CAMBIO DE PAGINA

       ENDFOR
       nLenTxt := LEN(cTxtPrn)
       @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
      *Impresi¢n de la £ltima l¡nea
*>>>>FIN IMPRESION DE LAS NOTAS

*>>>>ANALISIS PARA EL CAMBIO DE PAGINA
       IF PROW() > IIF(lOficio,70,58) - nTotImp .OR. PROW() = 0
	  IF PROW() <> 0
	     IF PROW() <= IIF(lOficio,70,58)
		DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
	     ENDIF
	     EJECT
	  ENDIF
	  OtraPagina(PCL({"DraftOn","CondenOn"}),;
		     PCL({"NegraOf","DobGolOf"}),;
		     aTitulo,aNroCol,bCabeza)
       ENDIF
*>>>>FIN ANALISIS PARA EL CAMBIO DE PAGINA

*>>>>IMPRESION DE LAS AREAS HABILITAR
       IF nNroPer == nTotPer .AND. !EMPTY(NOT->cMatHabNot)

**********IMPRESION DE LOS DETALLES DE LA HABILITACION
	    @PROW()+2,00 SAY IF ('0000' $ TCO->cNotNumTbl,;
				 'RECUPERACIONES','HABILITACIONES')
	    @PROW()  ,32 SAY SPACE(50)+'FECHA      ACTA  EVALUACION'
	    FOR k := 1 TO LEN(ALLTRIM(NOT->cMatHabNot))/4

*--------------LOCALIZACION DE LA MATERIAS A HABILITAR
		 cCodigoTma := SUBS(NOT->cMatHabNot,k*4-3,4)
		 cNombreTma := 'FAVOR VERIFICAR'
		 IF lLocCodigo('cCodigoMat','MAT',cCodigoTma,;
				     'DEL AREA')
		    cNombreTma := MAT->cNombreMat
		 ENDIF
*--------------FIN LOCALIZACION DE LA MATERIAS A HABILITAR

*--------------LECTURA DE LA NOTA DE LA RECUPERACION O HABILITACION
		 cNotHabTno := SUBS(NOT->cNotHabNot,k*4-3,4)

		 IF '0000' $ TCO->cNotNumTbl
		    DO CASE
		    CASE 'D' $ cNotHabTno
			 cNotHabTno := 'DEFICIENTE'
		    CASE 'I' $ cNotHabTno
			 cNotHabTno := 'INSUFICIENTE'
		    CASE 'A' $ cNotHabTno
			 cNotHabTno := 'ACEPTABLE'
		    CASE 'B' $ cNotHabTno
			 cNotHabTno := 'BUENO'
		    CASE 'S' $ cNotHabTno
			 cNotHabTno := 'SOBRESALIENTE'
		    CASE 'E' $ cNotHabTno
			 cNotHabTno := 'EXCELENTE'
		    CASE 'R' $ cNotHabTno
			 cNotHabTno := 'REGULAR'
		    ENDCASE
		 ENDIF
*--------------FIN LECTURA DE LA NOTA DE LA RECUPERACION O HABILITACION

*--------------IMPRESION DE LA HABILITACION
		 cFecHabTno := cFecha(NOT->dFecHa1Not)
		 @PROW()+1,00 SAY cNombreTma+SPACE(02)+;
				  cFecHabTno+SPACE(02)+;
				  SUBS(NOT->cActHabNot,k*4-3,4)+SPACE(02)+;
				  cNotHabTno+SPACE(02)
*--------------FIN IMPRESION DE LA HABILITACION

	    ENDFOR
**********FIN IMPRESION DE LOS DETALLES DE LA HABILITACION

       ENDIF
*>>>>FIN IMPRESION DE LAS AREAS HABILITAR

*>>>>ANALISIS PARA EL CAMBIO DE PAGINA
       IF PROW() > 46
	  DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
	  EJECT
	  OtraPagina(PCL({"DraftOn","CondenOn"}),;
		     PCL({"NegraOf","DobGolOf"}),;
		     aTitulo,aNroCol,bCabeza)
       ENDIF
*>>>>FIN ANALISIS PARA EL CAMBIO DE PAGINA

*>>>>IMPRESION DE LA PROMOCION FINAL
       cEstado := ''
       IF nNroPer == nTotPer
	  IF lRetEst
	     cEstado := 'NO TERMINO. SE RETIRO EN '+cFecha(dFecRet)+' '+;
			&cMaeAct->cObsRetEst
	     cTxtObsTap := ''
	  ELSE
	     cEstado := cAproboJui(NOT->nAproboNot,;
				   SUBS(&cMaeAct->cCodigoGru,1,2),;
					@cTxtObsTap)
	  ENDIF
	  cEstado    := ALLTRIM(cEstado)

       ENDIF
       aNroLin := aDivLin(ALLTRIM('OBSERVACION FINAL: '+cEstado),110)
       FOR i := 1 TO LEN(aNroLin)
	   @ PROW()+1,00 SAY aNroLin[i]
       NEXT
*>>>>FIN IMPRESION DE LA PROMOCION FINAL

*>>>>IMPRESION DE LAS RECUPERACIONES COMO OBSERVACIONES
       IF lHabObs .AND. !EMPTY(aMatHab)
	  @ PROW()+1,00 SAY ''

	  IF EMPTY(TCO->cTitRecTbl)
	     cTxtPrn := 'ACTIVIDADES DE RECUPERACION DE:'
	  ELSE
	     cTxtPrn := ALLTRIM(TCO->cTitRecTbl)
	  ENDIF

	  FOR i := 1 TO LEN(aMatHab)
	      cTxtPrn += ALLTRIM(aMatHab[i,5])+': '
	      IF ALLTRIM(cTxtNota(aMatHab[i,4])) == 'SIN NOTA'
		 cTxtPrn += 'PENDIENTE. '

	      ELSE
		 cTxtPrn += ALLTRIM(cTxtNota(aMatHab[i,4]))+;
			    ' - ACTA No.'+ALLTRIM(aMatHab[i,3])+;
			    ' DE '+aMatHab[i,2]+'. '
	      ENDIF
	  NEXT
	  aNroLin := aDivLin(ALLTRIM(cTxtPrn),110)
	  FOR i := 1 TO LEN(aNroLin)
	      @ PROW()+1,00 SAY aNroLin[i]
	  NEXT
       ENDIF
*>>>>FIN IMPRESION DE LAS RECUPERACIONES COMO OBSERVACIONES

*>>>>IMPRESION DE LA OBSERVACION
       IF lInfFin .AND. !EMPTY(cTxtObsTap)
	  aNroLin := aDivLin(ALLTRIM(cTxtObsTap),110)
	  FOR i := 1 TO LEN(aNroLin)
	      @ PROW()+1,00 SAY aNroLin[i]
	  NEXT
       ENDIF
     *ÀObservaci¢n de Recuperacion.

       IF !EMPTY(TCO->cOb4BolTbl)
	  aNroLin := aDivLin(ALLTRIM(TCO->cOb4BolTbl),110)
	  FOR i := 1 TO LEN(aNroLin)
	      @ PROW()+1,00 SAY aNroLin[i]
	  NEXT
       ENDIF
     *ÀObservaci¢n General del Libro

       IF !EMPTY(&cMaeAct->cObsLibEst)
	  aNroLin := aDivLin(ALLTRIM(&cMaeAct->cObsLibEst),110)
	  FOR i := 1 TO LEN(aNroLin)
	      @ PROW()+1,00 SAY aNroLin[i]
	  NEXT
       ENDIF
     *ÀObservaci¢n del Estudiante

       @ PROW()+2,00 SAY 'OBSERVACIONES:'
       @ PROW()+1,00 SAY REPL('-',nLenTxt)
       @ PROW()+2,00 SAY REPL('-',nLenTxt)
       @ PROW()+2,00 SAY REPL('-',nLenTxt)
     *ÀImpresi¢n l¡neas de la observaci¢n
*>>>>FIN IMPRESION DE LA OBSERVACION

*>>>>IMPRESION DE LAS FIRMAS
       IF lInfFin
	  cTxtPrn := 'Dir. '+aFirmas[1,1]
	  @ PROW()+2,(nLenPrn-LEN(cTxtPrn))/2 SAY REPL('-',LEN(cTxtPrn)+4)
	  @ PROW()+1,((nLenPrn-LEN(cTxtPrn))/2)+2 SAY cTxtPrn
       ELSE
	  Firmas(PCL('n17Stan'),6,aFirmas,.F.)
       ENDIF
      *Impresi¢n firmantes del libro

       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
       EJECT
       RETURN NIL
*>>>>FIN IMPRESION DE LAS FIRMAS

/*************************************************************************
* TITULOA..: IMPRESION DEL ENCABEZADO DEL LIBRO FINAL                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 28/2003 MIE A
       Colombia, Bucaramanga        INICIO: 03:30 PM   MAY 28/2003 MIE

OBJETIVOS:

1- Imprime el encabezado del libro y Boletines

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CabezaLib(nLinSpa,cNomEmp,lPrnEmp,cNomSec,cAnoUsr,cJorTxt,;
		   cCodEst,cNomEst,cCodGru,nNroLis,nNroPer,nNroPag,;
		   cMatMod,cNroMat,cNroFol,cTxtObs,lInfFin,cTitTop)

*>>>>PARAMETROS DE LA FUNCION
/*     nLinSpa                              // Espacios para el encabezado
       cNomEmp                              // Nombre de Empresa
       lPrnEmp                              // .T. Imprimir la Empresa
       cNomSec                              // Nombre Secundario
       cAnoUsr			            // A¤o del sistema
       cJotTxt                              // Jornada escogidad
       cCodEst                              // C¢digo del estudiante
       cNomEst                              // Nombre del Estudiante
       cCodGru                              // C¢digo del Grupo
       nNroLis                              // N£mero de lista
       nNroPer			            // N£mero del bimestre
       nNroPag                              // N£mero de p gina
       cMatMod                              // Materia de Modalida o Especialidad
       cNroMat                              // N£mero de Matr¡cula
       cNroFol                              // N£mero del folio
       cTxtObs                              // Texto de Observaci¢n
       lInfFin                              // .T. Informe Final .F. Libro Final
       cTitTop                              // T¡tulo Superior */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL aNroLin := {}                  // N£mero de l¡neas
       LOCAL lLibro  := .F.                 // .T. Encabezado del libro
       LOCAL nNroCol := 0                   // N£mero de Columna
       LOCAL nNroLin := 0                   // N£mero de l¡neas
       LOCAL cTxtPrn := ''                  // Texto de Impresi¢n

       LOCAL nLenPrn := 0                           // Longitud de impresi¢n
       LOCAL cCodIni := ''                          // C¢digos Iniciales de Impresi¢n
       LOCAL cCodFin := ''                          // C¢digos Finales de Impresi¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS SI ES ENCABEZADO DEL LIBRO FINAL
       IF EMPTY(nNroPer)
	  lLibro := .T.
       ENDIF
*>>>>FIN ANALISIS SI ES ENCABEZADO DEL LIBRO FINAL

*>>>>IMPRESION DEL NOMBRE DE LA EMPRESA
       @ PROW(),00 SAY PCL({"GraphiOn","CondenOf","ProporOf",;
			    "Pica","DraftOf","Roman"})


       lPrnEmp := IF(lPrnEmp == NIL,.F.,lPrnEmp)
       IF lPrnEmp

	  nLenPrn := 80
	  cCodIni := PCL({'DobAncOn','NegraOn','DobGolOn'})
	  cCodFin := PCL({'DobAncOf','NegraOf','DobGolOf'})

	  DO CASE
	  CASE LEN(cNomEmp) <= 40
	       nNroCol := ((nLenPrn/2)-LEN(cNomEmp))/2

	  CASE LEN(cNomEmp) > 40 .AND. LEN(cNomEmp) <= 42
	       nNroCol = 0
	  OTHERWISE
	       nNroCol := (nLenPrn-LEN(cNomEmp))/2
	       cCodIni := PCL({'NegraOn','DobGolOn'})
	       cCodFin := PCL({'NegraOf','DobGolOf'})
	  ENDCASE
	  @ PROW(),nNroCol SAY cCodIni
	  @ PROW(),nNroCol SAY cNomEmp
	  @ PROW(),nNroCol SAY cCodFin

	  IF !EMPTY(cNomSec)
	     DO CASE
	     CASE 'BETHLEMITAS' $ cNomSec
		  @ PROW()+1,00 SAY PCL("DobAncOn")+cNomSec+PCL("DobAncOf")
	     ENDCASE
	  ENDIF

	  SendCodes(PCL("CondenOn"))
	  aNroLin := aDivLin(ALLTRIM(cTxtObs),120)
	  FOR i := 1 TO LEN(aNroLin)
	      @ PROW()+1,00 SAY aNroLin[i]
	  NEXT
	  SendCodes(PCL("CondenOf"))
	*ÀImpresi¢n del Texto despu‚s de la Empresa
       ENDIF
*>>>>IMPRESION DEL NOMBRE DE LA EMPRESA

*>>>>IMPRESION DEL TITULO SUPERIOR
       cTitTop := IF(cTitTop == NIL,'',cTitTop)
       IF !EMPTY(cTitTop)
	  cTitTop := ALLTRIM(cTitTop)
	  nNroCol := (80-LEN(cTitTop))/2
	  @ PROW()+nLinSpa,nNroCol SAY cTitTop
	  nLinSpa := 2
       ENDIF
*>>>>FIN IMPRESION DEL TITULO SUPERIOR

*>>>>IMPRESION DEL NOMBRE DEL ALUMNO
       cNomEst := SUBS(cNomEst+SPACE(50),1,49)
       cTxtPrn := 'ALUMNO: '+cNomEst
       IF lLibro
	  IF .NOT. lInfFin
	     cTxtPrn += SPACE(02)+IF(EMPTY(cNroMat),'',cNroFol)
	  ENDIF
       ELSE
	  IF .NOT. lInfFin
	     cTxtPrn += SPACE(01)+'PERIODO:' +STR(nNroPer,2)
	  ENDIF
       ENDIF
       @ PROW()+nLinSpa,00 SAY cTxtPrn
*>>>>FIN IMPRESION DEL NOMBRE DEL ALUMNO

*>>>>IMPRESION DEL GRUPO,PERIODO,A¥O Y JORNADA
       cTxtPrn := 'CODIGO:' +cCodEst          +SPACE(02)+;
		  'GRUPO:'  +cConverNiv(SUBS(cCodGru,1,2))+;
			     SUBS(cCodGru,3,2)+SPACE(02)+;
		  'No.'     +STR(nNroLis,2)   +SPACE(01)+;
		  'A¥O:'    +cAnoUsr	      +SPACE(01)+;
		  'JORNADA:'+cJorTxt          +SPACE(01)

       IF lLibro
	  IF .NOT. lInfFin
	     cTxtPrn += IF(EMPTY(cNroMat),cNroFol,cNroMat)
	  ELSE
	     cTxtPrn += 'P gina No.'+LTRIM(STR(nNroPag))
	  ENDIF
       ELSE
	  cTxtPrn += 'P gina No.'+LTRIM(STR(nNroPag))
       ENDIF

       @ PROW()+1,00 SAY cTxtPrn
       @ PROW(),00 SAY PCL({"DraftOn","CondenOn"})
*>>>>FIN IMPRESION DEL GRUPO,PERIODO,A¥O Y JORNADA

*>>>>IMPRESION DE LA MODALIDAD O ESPECIALIDAD
       cMatMod := IF(cMatMod == NIL,'',cMatMod)
       nNroLin := 2
       IF !EMPTY(cMatMod)
	  SendCodes(PCL("CondenOn"))
	  @ PROW()+1,00 SAY ALLTRIM(cMatMod)
	  nNroLin := 1
       ENDIF
*>>>>FIN IMPRESION DE LA MODALIDAD O ESPECIALIDAD

*>>>>IMPRESION DE LA DESCRIPCION DE LA ESCALA EVALUATIVA
       IF nNroPag == 1
	  IF !EMPTY(COA->cDescrECoA)
	     @ PROW()+nNroLin,00 SAY REPL('-',122)
	     SendCodes(PCL("CondenOn"))
	     @ PROW()+1,00 SAY PCL("NegraOn")+;
			      'ESCALA EVALUATIVA...:'+;
			       PCL("NegraOf")


	     aNroLin := aDivLin(ALLTRIM(COA->cDescrECoA),100)
	     FOR i := 1 TO LEN(aNroLin)
		 IF i == 1
		    @ PROW()+1,00 SAY 'EXCELENTE(Ee).......: '+aNroLin[i]
		 ELSE
		    @ PROW()+1,00 SAY '                      '+aNroLin[i]
		 ENDIF
	     NEXT
	     SendCodes(PCL("CondenOf"))
	  ENDIF

	  IF !EMPTY(COA->cDescrSCoA)
	     SendCodes(PCL("CondenOn"))

	     aNroLin := aDivLin(ALLTRIM(COA->cDescrSCoA),100)
	     FOR i := 1 TO LEN(aNroLin)
		 IF i == 1
		    @ PROW()+1,00 SAY 'SOBRESALIENTE(Ss)...: '+aNroLin[i]
		 ELSE
		    @ PROW()+1,00 SAY '                      '+aNroLin[i]
		 ENDIF
	     NEXT
	     SendCodes(PCL("CondenOf"))
	  ENDIF

	  IF !EMPTY(COA->cDescrACoA)
	     SendCodes(PCL("CondenOn"))

	     aNroLin := aDivLin(ALLTRIM(COA->cDescrACoA),100)
	     FOR i := 1 TO LEN(aNroLin)
		 IF i == 1
		    @ PROW()+1,00 SAY 'ACEPTABLE(Aa).......: '+aNroLin[i]
		 ELSE
		    @ PROW()+1,00 SAY '                      '+aNroLin[i]
		 ENDIF
	     NEXT
	     SendCodes(PCL("CondenOf"))
	  ENDIF

	  IF !EMPTY(COA->cDescrICoA)
	     SendCodes(PCL("CondenOn"))

	     aNroLin := aDivLin(ALLTRIM(COA->cDescrICoA),100)
	     FOR i := 1 TO LEN(aNroLin)
		 IF i == 1
		    @ PROW()+1,00 SAY 'INSUFICIENTE(Ii)....: '+aNroLin[i]
		 ELSE
		    @ PROW()+1,00 SAY '                      '+aNroLin[i]
		 ENDIF
	     NEXT
	     SendCodes(PCL("CondenOf"))
	  ENDIF

	  IF !EMPTY(COA->cDescrDCoA)
	     SendCodes(PCL("CondenOn"))

	     aNroLin := aDivLin(ALLTRIM(COA->cDescrDCoA),100)
	     FOR i := 1 TO LEN(aNroLin)
		 IF i == 1
		    @ PROW()+1,00 SAY 'DEFICIENTE(Dd)......: '+aNroLin[i]
		 ELSE
		    @ PROW()+1,00 SAY '                      '+aNroLin[i]
		 ENDIF
	     NEXT
	     SendCodes(PCL("CondenOf"))
	  ENDIF
       ENDIF
       RETURN NIL
*>>>>FIN IMPRESION DE LA DESCRIPCION DE LA ESCALA EVALUATIVA

/*************************************************************************
* TITULO..: IMPRESION DEL LIBRO FINAL No. 04                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 17/97 LUN A
       Colombia, Bucaramanga        INICIO: 10:10 PM   DIC 17/97 LUN

OBJETIVOS:

1- Imprime el libro final modelo sugerido por el Colegio de la
   Presentaci¢n Centro de Bogota.

2- Libro final No. 04 imprime las Areas y las asignaturas con el
   juicio valorativo, la nota numerica y la promoci¢n l¢gica.

3- Debe estar en uso el archivo de notas del grupo correspondiente.

4- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION LibroFin04(cEmpPal,cNomEmp,cNomSis,cAnoUsr,cNomEst,lRetEst,dFecRet,;
		    aFirmas,cJorTxt,aNotAre,aNotMat,cNroFol,cMaeAct,cTxtLib,;
		    lInfFin,cMatMod)

*>>>>PARAMETROS DE LA FUNCION
/*     cEmpPal                              // Nombre de la Empresa principal
       cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       cAnoUsr			            // A¤o del Usuario
       cNomEst                              // Nombre del estudiante
       lRetEst                              // .T. Retirado
       dFecRet                              // Fecha de Retiro
       aFirmas                              // Firmas del libro
       cNomTit                              // Nombre del titular
       cJorTxt                              // Jornada escogida
       aNotAre                              // Detalles de las areas
       aNotMat                              // Detalles de las materias
       cNroFol                              // N£mero del Folio
       cMaeAct                              // Maestro Actual
       cTxtLib                              // Texto para el libro
       lInfFin                              // .T. Informe Final .F. Libro Final
       cMatMod                              // Materia de Modalidad o Especialidad */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL   i,j,k := 0                   // Contadores

       LOCAL aNroCol := {}                  // Columnas de los titulos
       LOCAL aTitulo := {}                  // T¡tulos para el informe
       LOCAL aRegPrn := {}                  // Registro de impresion

       LOCAL lPagina := .T.                 // .T. Cambio de p gina
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL nTotCab := 0                   // Total l¡neas del encabezado
       LOCAL nTotReg := 0                   // Total registros a imprimir
       LOCAL nTotImp := 0                   // Totales de impresion
       LOCAL cTxtPrn := ''                  // Texto de impresion
       LOCAL nLenPrn := PCL('n17Stan')      // Longitud de impresi¢n

       LOCAL lPrnEmp := .F.                 // .T. Imprimir la Empresa
       LOCAL lPrnAre := .F.                 // .T. Imprimir el  rea
       LOCAL lNegAre := .F.                 // .T. Imprimir en negrilla el  rea
       LOCAL lPrnNot := .F.                 // .T. Imprimir la nota
       LOCAL lHayNot := .F.                 // .T. Hay Notas
       LOCAL lNotNum := .F.                 // .T. Nota Numerica .F. Nota Cualitativa
       LOCAL lHabObs := .F.                 // .T. Habilitacion Columna .F. Habilitaci¢n como observaci¢n
       LOCAL cMsgBol := ''                  // Mensaje para el boletin
       LOCAL lMatVar := .F.                 // .T. Imprimir Materia Variable

       LOCAL cNroCol := ''                  // N£mero de columnas
       LOCAL cNotDef := ''                  // Nota de area o materia

       LOCAL cCamFal := ''                  // Campo de las fallas

       LOCAL nMarSup := 0                   // Margen Superior
       LOCAL nLinCab := 0                   // L¡neas del Encabezado
       LOCAL nLinCol := 0                   // L¡neas de Columnas
       LOCAL nEncCol := 0                   // Encabezados de Columna
       LOCAL nLinTop := 0                   // L¡neas del Top

       LOCAL nColEnc := 0                   // N£mero de Columnas para el encabezado del libro
       LOCAL nColLib := 0                   // N£mero de Columnas para el cuerpo del libro

       LOCAL nNroPer := 0                   // N£mero del Bimestre
       LOCAL bCabeza := NIL                 // Code Block
       LOCAL lOficio := .F.                 // .F. Tama¤o carta
       LOCAL nTotPer := 0                   // Total de periodos
       LOCAL nNroArn := 0                   // N£mero areas no promediables
       LOCAL nJuiMat := 0                   // Total Juicios Materias
       LOCAL cCodAre := ''                  // C¢digo del area
       LOCAL cNomAre := ''                  // Nombre del area
       LOCAL cNomMat := ''                  // Nombre de la materia
       LOCAL cEvalua := ''                  // Evaluaci¢n conceptual
       LOCAL cCodJui := ''                  // C¢digo del juicio
       LOCAL cEstado := ''                  // Estado final de aprobaci¢n
       LOCAL aMatHab := {}                  // Detalles de la Recuperaci¢n

       LOCAL cCodigoTju := ''               // C¢digo del juicio
       LOCAL cNombreTju := ''               // Nombre del juicio
       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL cNombreTma := ''               // Nombre de la materia
       LOCAL cNotHabTno := ''               // Nota de la habilitaci¢n
       LOCAL cFecHabTno := ''               // Fecha de la habilitaci¢n
       LOCAL cCodigoTni := ''               // C¢digo del nivel
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO TOTAL DE AREAS
       nNroArn := 0
       FOR i:=1 TO LEN(aNotAre)
	  IF SUBS(aNotAre[i][4],7,4) == 'AREN'
	     nNroArn ++
	  ENDIF
       ENDFOR
       cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
*>>>>FIN CALCULO TOTAL DE AREAS

*>>>>LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD
       nTotPer := TCO->nTotPerTbl
       lOficio := TCO->lOficioTbl
       lHabObs := TCO->lHabObsTbl
       nNroPer := nTotPer
       lPrnEmp := TCO->lPrnEmpTbl
       lPrnAre := TCO->lPrnAreTbl
       lNegAre := TCO->lNegAreTbl
       lPrnNot := IF(SUBS(TCO->cPrnNotTbl,nNroPer,1)='1',.T.,.F.)
       lHayNot := IF(SUBS(TCO->cHayNotTbl,nNroPer,1)='1',.T.,.F.)
       lNotNum := IF(SUBS(TCO->cNotNumTbl,nNroPer,1)='1',.T.,.F.)

       nColEnc := TCO->nCo1LibTbl
       nColLib := TCO->nCo2LibTbl

       cMsgBol := ALLTRIM(TCO->cMsgBolTbl)

       IF !lPrnNot
	  lHayNot := .F.
       ENDIF

       IF !lHayNot
	  lNotNum := .F.
       ENDIF
*>>>>FIN LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD

*>>>>CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR
       IF lPrnEmp
	  nTotImp := IF(nNroPer==nTotPer,15,08)
       ELSE
	  nTotImp := IF(nNroPer==nTotPer,15,11)
       ENDIF
      *L¡neas de los totales de impresi¢n

       nMarSup := TCO->nLinEspTbl
       nLinCab := 9
       nTotCab := IIF(nMarSup > nLinCab, nMarSup - nLinCab, 0)
     *Encabezado de columna

       nEncCol := 3
       nLinTop := nTotCab+nEncCol
     *Total l¡neas del encabezado

      nTotReg := nLinTop+nNroArn+LEN(aNotMat)+nTotImp
      nTotReg := 0
     *Total de registros a imprimir
*>>>>FIN CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR

*>>>>IMPRESION DE LA HOJA DEL LIBRO
       bCabeza := {||CabezaBole(lOficio,TCO->nLinEspTbl,cTxtPrn,nNroPag++,;
				nTotReg,;
				cNomEst,;
				NOT->cCodigoEst,;
				GRU->cCodigoGru,;
				NOT->(RECNO()),;
				NIL,NIL,nNroPer,cAnoUsr,;
				cJorTxt,3,cNomEmp,lPrnEmp,;
				cNroFol,cTxtLib,cEmpPal,;
				IF(lInfFin,TCO->cTitBolTbl,''),;
				cMatMod,nColEnc)}

       lMatVar := .T.
       aMatHab := aMatHabPla(NOT->nAproboNot,aNotAre,aNotMat,nTotPer,lNotNum,;
			     lMatVar)
      *Materias de las Recuperaciones

       CuerpLib04(cNomSis,cJorTxt,cMsgBol,lRetEst,dFecRet,lNotNum,aNotAre,;
		  aNotMat,nNroPer,cNomEmp,lPrnEmp,cNroFol,lNegAre,bCabeza,;
		  aFirmas,lHayNot,lPrnAre,lOficio,cMaeAct,lHabObs,aMatHab,;
		  lInfFin)

       RETURN NIL
*>>>>FIN IMPRESION DE LA HOJA DEL LIBRO


/*************************************************************************
* TITULO DEL PROGRAMA..: CUERPO DEL LIBRO FINAL No. 04                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 17/97 MIE A
       Colombia, Bucaramanga        INICIO: 11:05 AM   DIC 17/97 MIE

OBJETIVOS:

1- El cuerpo del libro est  formado por el encabezado y las asignaturas.

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CuerpLib04(cNomSis,cJorTxt,cMsgBol,lRetEst,dFecRet,lNotNum,;
		    aNotAre,aNotMat,nNroPer,cNomEmp,lPrnEmp,cNroFol,;
		    lNegAre,bCabeza,aFirmas,lHayNot,lPrnAre,lOficio,;
		    cMaeAct,lHabObs,aMatHab,lInfFin)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomSis                              // Nombre del Sistema
       cJorTxt                              // Jornada escogida
       cMsgBol                              // T¡tulo de Encabezado
       lRetEst                              // .T. Estudiante Retirado
       dFecRet                              // Fecha de Retiro
       lNotNum                              // .F. Nota Cualitativa
       aNotAre                              // Detalles de las areas
       aNotMat                              // Detalles de las materias
       nNroPer			            // N£mero del Periodo
       cNomEmp                              // Nombre de la Empresa
       lPrnEmp                              // .T. Imprimir la Empresa
       cNroFol                              // N£mero del Folio
       lNegAre                              // .T. Areas en negrilla
       bCabeza                              // Funci¢n con Encabezado
       aFirmas                              // Firmas del libro.
       lHayNot                              // .T. Hay Notas
       lPrnAre                              // .T. Imprimir las areas
       lOficio                              // .F. Tama¤o Carta
       cMaeAct                              // Maestro Actual
       lHabObs                              // .T. Habilitaci¢n como observaci¢n .F. Habilitaci¢n en Columna
       aMatHab                              // Materias por Habilitar
       lInfFin                              // .T. Informe Final .F. Libro Final */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL   i,j,k := 0                   // Contadores

       LOCAL nColEnc := 0                   // N£mero de Columnas para el encabezado del libro
       LOCAL nColLib := 0                   // N£mero de Columnas para el cuerpo del libro

       LOCAL aNroCol := {}                  // Columnas de los titulos
       LOCAL aTitulo := {}                  // T¡tulos para el informe
       LOCAL aRegPrn := {}                  // Registro de impresion

       LOCAL lPagina := .T.                 // .T. Cambio de p gina
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL nTotCab := 0                   // Total l¡neas del encabezado
       LOCAL nTotImp := 0                   // Totales de impresion
       LOCAL cTxtPrn := ''                  // Texto de impresion
       LOCAL nLenPrn := PCL('n17Stan')      // Longitud de impresi¢n

       LOCAL cNroCol := ''                  // N£mero de columnas
       LOCAL cCamFal := ''                  // Campo de las fallas

       LOCAL nTotPer := 0                   // Total de periodos.
       LOCAL nNroArn := 0                   // N£mero areas no promediables
       LOCAL cCodAre := ''                  // C¢digo del area
       LOCAL cNomAre := ''                  // Nombre del area
       LOCAL cNomMat := ''                  // Nombre de la materia
       LOCAL cEvalua := ''                  // Evaluaci¢n conceptual
       LOCAL cEstado := ''                  // Estado final de aprobaci¢n
       LOCAL cIntens := ''                  // Intensidad Horaria
       LOCAL cNroFal := ''                  // N£mero de Ausencias
       LOCAL nLenTxt := ''                  // Longitud del texto
       LOCAL aNroLin := {}                  // N£mero de l¡neas
       LOCAL nPosHab := 0                   // Posici¢n de la Habilitaci¢n
       LOCAL cNotDef := ''                  // Nota Definitiva materia o area
       LOCAL cNotRec := ''                  // Nota de Recuperaci¢n
       LOCAL cNotTxt := ''                  // Nota en Texto
       LOCAL lMatVar := .F.                 // .T. Imprimir Materia Variable

       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL cNombreTma := ''               // Nombre de la materia
       LOCAL cNotHabTno := ''               // Nota de la habilitaci¢n
       LOCAL cFecHabTno := ''               // Fecha de la habilitaci¢n
       LOCAL cCodigoTev := ''               // C¢digo de la Evaluaci¢n
       LOCAL cCodigoTni := ''               // C¢digo del nivel
       LOCAL cCodigoTcl := ''               // C¢digo de la clase
       LOCAL cTxtObsTap := ''               // Texto de Observaci¢n de Promoci¢n.

       LOCAL cCamNotDef := ''               // Campo de Notas Definitivas
       LOCAL cCamNotRec := ''               // Campo de Notas de Recuperaci¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ENCABEZADOS DE COLUMNA
       nColEnc := TCO->nCo1LibTbl
       nColLib := TCO->nCo2LibTbl

       aNroCol := {82,02,04,20,18}
       aTitulo := {'AREAS O ASIGNATURAS','IH','AUS.',;
		   'EVALUACION','NOTA'}
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>IMPRESION DE LAS NOTAS
       nTotPer := TCO->nTotPerTbl
       FOR i:=1 TO LEN(aNotAre)

***********IMPRESION DEL ENCABEZADO
	    IF lPagina

	       OtraPagina(PCL({"DraftOn","CondenOn"}),;
			  PCL({"NegraOf","DobGolOf"}),;
			  aTitulo,aNroCol,bCabeza,nColLib)

	       lPagina := .F.
	    ENDIF
***********FIN IMPRESION DEL ENCABEZADO

***********IMPRESION DEL NOMBRE DEL AREA
	     IF SUBS(aNotAre[i][4],7,4) == 'AREP'
		cNomAre := SUBS(RTRIM(aNotAre[i,10])+SPACE(80),1,82)
		aRegPrn := {cNomAre,'','',''}
		cTxtPrn := cRegPrint(aRegPrn,aNroCol)
*		@ PROW()+1,nColLib SAY cTxtPrn
	     ENDIF
***********FIN IMPRESION DEL NOMBRE DEL AREA

**********IMPRESION DE LAS NOTAS DEL AREA
	    IF SUBS(aNotAre[i][4],7,4) == 'AREN'

*--------------ANALISIS DE LA IMPRESION DEL AREA
		 IF aNotAre[i][12]  // .T. No Imprimir
		    LOOP
		 ENDIF
*--------------FIN ANALISIS DE LA IMPRESION AREA

*--------------LECTURA DE LA NOTA DEL AREA
		 cCamNotDef := aNotAre[i,4]
		 cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

		 cNotDef := ALLTRIM(SUBS(&cCamNotDef,nNroPer*4-3,4))
		 cNotRec := ALLTRIM(SUBS(&cCamNotRec,nNroPer*4-3,4))

		 IF TCO->lRecNotTbl .AND. !EMPTY(cNotRec)
		    cNotDef := cNotRec
		 ENDIF

		 IF VAL(cNotDef) # 0

		    cNotTxt := cNotDef+' '+cNroToTxt(VAL(cNotDef))
		    cNotTxt := SUBS(cNotTxt+SPACE(18),1,18)

		    cNotDef := cNotDefJvf(VAL(cNotDef))
		    cNotDef := cNombreJvf(ALLTRIM(cNotDef))

		 ELSE
		    cNotDef := cNombreJvf(ALLTRIM(cNotDef))
		    cNotTxt := ''
		 ENDIF
*--------------FIN LECTURA DE LA NOTA DEL AREA

*--------------CONTEO DE LAS FALLAS
		 cCamFal := 'NOT->cFa'+SUBS(aNotAre[i,6],9,4)+'Not'
		 cNroFal := 0
		 IF nNroPer == nTotPer
		    FOR k := 1 TO nNroPer
		       cNroFal += VAL(SUBS(&cCamFal,k*2-1,2))
		    NEXT
		 ELSE
		    cNroFal := VAL(SUBS(&cCamFal,nNroPer*2-1,2))
		 ENDIF
		 cNroFal := IF(EMPTY(cNroFal),SPACE(02),STR(cNroFal,2,0))
*--------------FIN CONTEO DE LAS FALLAS

*--------------INTENSIDAD HORARIA
		 IF VAL(aNotAre[i,11]) == 0
		    cIntens := SPACE(02)
		 ELSE
		    cIntens := aNotAre[i,11]
		 ENDIF
*--------------FIN INTENSIDAD HORARIA

*--------------IMPRESION DEL REGISTRO DEL AREA
		 cNomAre := aNotAre[i,3]+SPACE(80-LEN(aNotAre[i,3]))

		 aRegPrn := {}
		 AADD(aRegPrn,cNomAre)
		 AADD(aRegPrn,cIntens)
		 AADD(aRegPrn,cNroFal)
		 AADD(aRegPrn,cNotDef)
		 AADD(aRegPrn,cNotTxt)

		 cTxtPrn := cRegPrint(aRegPrn,aNroCol)
		 @ PROW()+1,nColLib SAY cTxtPrn
*--------------FIN IMPRESION DEL REGISTRO DEL AREA

*--------------ANALISIS PARA EL CAMBIO DE PAGINA
		 IF PROW() > IIF(lOficio,70,58)
		    DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
		    EJECT
		    OtraPagina(PCL({"DraftOn","CondenOn"}),;
			       PCL({"NegraOf","DobGolOf"}),;
			       aTitulo,aNroCol,bCabeza,nColLib)
		 ENDIF
*--------------FIN ANALISIS PARA EL CAMBIO DE PAGINA

	    ENDIF
**********FIN IMPRESION DE LAS NOTAS DEL AREA

**********IMPRESION DE LAS NOTAS DE LA MATERIA
	    FOR j:=1 TO LEN(aNotMat)

	       IF aNotAre[i,2] == aNotMat[j,1]

*-----------------ANALISIS DE LA IMPRESION DE LA MATERIA
		    IF aNotMat[j][12]   // .T. No Imprimir
		       LOOP
		    ENDIF

/*
		   IF !('AREA' $ aNotMat[j,2])
		      LOOP
		   ENDIF
*/
*-----------------FIN ANALISIS DE LA IMPRESION DE LA MATERIA

*-----------------LECTURA DE LA NOTA DE LA MATERIA
		    cCamNotDef := aNotMat[j,4]
		    cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

		    cNotDef := ALLTRIM(SUBS(&cCamNotDef,nNroPer*4-3,4))
		    cNotRec := ALLTRIM(SUBS(&cCamNotRec,nNroPer*4-3,4))

		    IF TCO->lRecNotTbl .AND. !EMPTY(cNotRec)
		       cNotDef := cNotRec
		    ENDIF

		    IF VAL(cNotDef) # 0

		       cNotTxt := cNotDef+' '+cNroToTxt(VAL(cNotDef))
		       cNotTxt := SUBS(cNotTxt+SPACE(18),1,18)

		       cNotDef := cNotDefJvf(VAL(cNotDef))
		       cNotDef := cNombreJvf(ALLTRIM(cNotDef))

		    ELSE
		       cNotDef := cNombreJvf(ALLTRIM(cNotDef))
		       cNotTxt := ''
		    ENDIF
*-----------------FIN LECTURA DE LA NOTA DE LA MATERIA

*-----------------CONTEO DE LAS FALLAS
		    cCamFal := aNotMat[j,6]
		    cNroFal := 0
		    IF nNroPer == nTotPer
		       FOR k := 1 TO nNroPer
			  cNroFal += VAL(SUBS(&cCamFal,k*2-1,2))
		       NEXT
		    ELSE
		       cNroFal := VAL(SUBS(&cCamFal,nNroPer*2-1,2))
		    ENDIF
		    cNroFal := IF(EMPTY(cNroFal),SPACE(02),STR(cNroFal,2,0))
*-----------------FIN CONTEO DE LAS FALLAS

*-----------------IMPRESION DEL REGISTRO DEL AREA
		    IF VAL(aNotMat[j,3]) == 0
		       cIntens := SPACE(02)
		    ELSE
		       cIntens := aNotMat[j,3]
		    ENDIF
		  *ÀLectura de la Intensidad horaria

		    cNomMat := aNotMat[j,10]+SPACE(80-LEN(aNotMat[j,10]))
		  *ÀMateria Notas o Certificado

		    IF !EMPTY(TCO->cSpaBolTbl)
		       IF aNotMat[j,1] == cCodAre .AND. SUBS(aNotMat[j,5],11,2) # '00'
			  cNomMat := SUBS(SPACE(02)+cNomMat,1,80)
		       ELSE
			  cCodAre := aNotMat[j,1]
		       ENDIF
		    ENDIF
		  *ÀIndentaci¢n de la materia

		    aRegPrn := {}
		    AADD(aRegPrn,cNomMat)
		    AADD(aRegPrn,cIntens)
		    AADD(aRegPrn,cNroFal)
		    AADD(aRegPrn,cNotDef)
		    AADD(aRegPrn,cNotTxt)

		    cTxtPrn := cRegPrint(aRegPrn,aNroCol)
		    @ PROW()+1,nColLib SAY cTxtPrn
*-----------------FIN IMPRESION DEL REGISTRO DEL AREA

*-----------------ANALISIS PARA EL CAMBIO DE PAGINA
		    IF PROW() > IIF(lOficio,70,58)
		       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
		       EJECT
		       OtraPagina(PCL({"DraftOn","CondenOn"}),;
				  PCL({"NegraOf","DobGolOf"}),;
				  aTitulo,aNroCol,bCabeza,nColLib)
		    ENDIF
*-----------------FIN ANALISIS PARA EL CAMBIO DE PAGINA

	       ENDIF
	    ENDFOR
**********FIN IMPRESION DE LAS NOTAS DE LA MATERIA

**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > IIF(lOficio,70,58)
	       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
	       EJECT
	       lPagina := .T.
	    ELSE
	       lPagina := .F.
	    ENDIF
**********FIN ANALISIS PARA EL CAMBIO DE PAGINA

       ENDFOR
       nLenTxt := LEN(cTxtPrn)
       @ PROW()+1,nColLib SAY REPL('-',LEN(cTxtPrn))
      *Impresi¢n de la £ltima l¡nea
*>>>>FIN IMPRESION DE LAS NOTAS

*>>>>IMPRESION DE LA PROMOCION FINAL
	  cEstado := ''
       cTxtObsTap := ''
       IF nNroPer == nTotPer
	  cEstado := cAproboJui(NOT->nAproboNot,;
				SUBS(GRU->cCodigoGru,1,2),;
				     @cTxtObsTap)
	  cEstado := ALLTRIM(cEstado)
       ENDIF

       aNroLin := aDivLin(ALLTRIM('OBSERVACION: '+cEstado),110)
       FOR i := 1 TO LEN(aNroLin)
	   @ PROW()+1,nColLib SAY aNroLin[i]
       NEXT
*>>>>FIN IMPRESION DE LA PROMOCION FINAL

*>>>>IMPRESION DE LAS RECUPERACIONES EN TABLA
       aMatHab := {}
       IF nNroPer == nTotPer

	  lMatVar := .T.
	  aMatHab := aMatHabPla(NOT->nAproboNot,aNotAre,;
				aNotMat,nTotPer,lNotNum,;
				lMatVar)
	 *Materias de las Recuperaciones

       ENDIF

       IF !EMPTY(aMatHab)

	  @ PROW()+1,00 SAY ''

	  aNroCol := {80,20,18,06,14}
	  aTitulo := {'MATERIAS','EVALUACION','NOTA','ACTA','FECHA'}

	  cTxtPrn := cRegPrint(aTitulo,aNroCol)
	  SendCodes(PCL({'DraftOn','CondenOn'}))

****************IMPRESION DEL ENCABEZADO
		 IF LEN(aMatHab) # 0 .AND. LEN(aMatHab) > 3

		    IF PROW() > IIF(lOficio,60,50)
		       EJECT
		       OtraPagina(PCL({"DraftOn","CondenOn"}),;
				  PCL({"NegraOf","DobGolOf"}),;
				  aTitulo,aNroCol,bCabeza,nColLib)
		    ENDIF
		 ENDIF

		 @ PROW()+2,nColLib+50 SAY 'R E C U P E R A C I O N E S'
		 @ PROW()+1,nColLib SAY REPL('-',LEN(cTxtPrn))
		 @ PROW()+1,nColLib SAY cTxtPrn
		 @ PROW()+1,nColLib SAY REPL('-',LEN(cTxtPrn))
****************FIN IMPRESION DEL ENCABEZADO

****************IMPRESION DE LAS RECUPERACIONES
		  FOR i := 1 TO LEN(aMatHab)

		      cNotDef := aMatHab[i,4]

		      IF VAL(cNotDef) > 0
			 cNotTxt := cNotDef+' '+cNroToTxt(VAL(cNotDef))
		      ELSE
			 cNotTxt := ''
		      ENDIF

		      cNotDef := cNotDef(cNotDef,IF(VAL(cNotDef) > 0,.T.,.F.))
		      IF VAL(cNotDef) > 0
			 cNotDef := cNotDefJvf(VAL(cNotDef))
			 cNotDef := cNombreJvf(ALLTRIM(cNotDef))
		      ENDIF


		      aTitulo := {}
		      AADD(aTitulo,SUBS(aMatHab[i,5],1,80))
		      AADD(aTitulo,cNotDef)
		      AADD(aTitulo,cNotTxt)
		      AADD(aTitulo,aMatHab[i,3])
		      AADD(aTitulo,aMatHab[i,2])
		      cTxtPrn := cRegPrint(aTitulo,aNroCol)
		      @ PROW()+1,nColLib SAY cTxtPrn
		  ENDFOR
		  @ PROW()+1,nColLib SAY REPL('-',LEN(cTxtPrn))
****************FIN IMPRESION DE LAS RECUPERACIONES

       ENDIF
*>>>>FIN IMPRESION DE LAS RECUPERACIONES COMO OBSERVACIONES

*>>>>IMPRESION DE LAS FIRMAS
       IF lInfFin
	  cTxtPrn := 'Dir. '+aFirmas[1,1]
	  @ PROW()+2,(nLenPrn-LEN(cTxtPrn))/2 SAY REPL('-',LEN(cTxtPrn)+4)
	  @ PROW()+1,((nLenPrn-LEN(cTxtPrn))/2)+2 SAY cTxtPrn
       ELSE
	  Firmas1(PCL('n17Stan'),6,aFirmas,.F.,50,nColLib)
       ENDIF
      *Impresi¢n firmantes del libro

       EJECT
       RETURN NIL
*>>>>FIN IMPRESION DE LAS FIRMAS

/*************************************************************************
* TITULO..: IMPRESION DEL LIBRO FINAL No. 05                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 09/2003 LUN A
       Colombia, Bucaramanga        INICIO: 10:10 PM   NOV 09/2003 LUN

OBJETIVOS:

1- Copiado del libro No. 3

2- Imprime los juicios valorativos de las las areas promediables y las
   asignaturas de dichas areas.

3- Imprime los juicios valorativos de la areas no promediables

4- La caracteristica principal de este libro es que imprime las areas
   00 y no era posible imprimir en anteriores libros.

4- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION LibroFin05(cEmpPal,cNomEmp,cNomSis,cAnoUsr,cNomEst,lRetEst,dFecRet,;
		    aFirmas,cJorTxt,aNotAre,aNotMat,cNroFol,cMaeAct,cTxtLib,;
		    lInfFin,cMatMod)

*>>>>DESCRIPCION DE PARAMETROS
/*     cEmpPal                              // Nombre de la Empresa principal
       cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       cAnoUsr			            // A¤o del Usuario
       cNomEst                              // Nombre del estudiante
       lRetEst                              // .T. Retirado
       dFecRet                              // Fecha de Retiro
       aFirmas                              // Firmas del libro
       cNomTit                              // Nombre del titular
       cJorTxt                              // Jornada escogida
       aNotAre                              // Detalles de las areas
       aNotMat                              // Detalles de las materias
       cNroFol                              // N£mero del Folio
       cMaeAct                              // Maestro Actual
       cTxtLib                              // Texto para el libro
       lInfFin                              // .T. Informe Final .F. Libro Final
       cMatMod                              // Materia de Modalidad o Especialidad */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL   i,j,k := 0                   // Contadores

       LOCAL aNroCol := {}                  // Columnas de los titulos
       LOCAL aTitulo := {}                  // T¡tulos para el informe
       LOCAL aRegPrn := {}                  // Registro de impresion

       LOCAL lPagina := .T.                 // .T. Cambio de p gina
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL nTotCab := 0                   // Total l¡neas del encabezado
       LOCAL nTotReg := 0                   // Total registros a imprimir
       LOCAL nTotImp := 0                   // Totales de impresion
       LOCAL cTxtPrn := ''                  // Texto de impresion
       LOCAL nLenPrn := PCL('n17Stan')      // Longitud de impresi¢n

       LOCAL cNomSec := ''                  // Nombre Secundario.
       LOCAL lPrnEmp := .F.                 // .T. Imprimir la Empresa
       LOCAL lPrnAre := .F.                 // .T. Imprimir el  rea
       LOCAL lNegAre := .F.                 // .T. Imprimir en negrilla el  rea
       LOCAL lPrnNot := .F.                 // .T. Imprimir la nota
       LOCAL lHayNot := .F.                 // .T. Hay Notas
       LOCAL lNotNum := .F.                 // .T. Nota Numerica .F. Nota Cualitativa
       LOCAL lHabObs := .F.                 // .T. Habilitacion Columna .F. Habilitaci¢n como observaci¢n
       LOCAL cMsgBol := ''                  // Mensaje para el boletin
       LOCAL cNotAcu := ''                  // Notas Acumuladas
       LOCAL lMatVar := .F.                 // .T. Imprimir Materia Variable

       LOCAL cNroCol := ''                  // N£mero de columnas
       LOCAL cNotDef := ''                  // Nota de area o materia

       LOCAL cCamFal := ''                  // Campo de las fallas

       LOCAL nMarSup := 0                   // Margen Superior
       LOCAL nLinCab := 0                   // L¡neas del Encabezado
       LOCAL nLinCol := 0                   // L¡neas de Columnas
       LOCAL nEncCol := 0                   // Encabezados de Columna
       LOCAL nLinTop := 0                   // L¡neas del Top


       LOCAL nNroPer := 0                   // N£mero del Bimestre
       LOCAL bCabeza := NIL                 // Code Block
       LOCAL lOficio := .F.                 // .F. Tama¤o carta
       LOCAL nTotPer := 0                   // Total de periodos
       LOCAL nNroArn := 0                   // N£mero areas no promediables
       LOCAL nJuiMat := 0                   // Total Juicios Materias
       LOCAL cCodAre := ''                  // C¢digo del area
       LOCAL cNomAre := ''                  // Nombre del area
       LOCAL cNomMat := ''                  // Nombre de la materia
       LOCAL cEvalua := ''                  // Evaluaci¢n conceptual
       LOCAL cCodJui := ''                  // C¢digo del juicio
       LOCAL cEstado := ''                  // Estado final de aprobaci¢n
       LOCAL aMatHab := {}                  // Detalles de la Recuperaci¢n
       LOCAL cNroMat := ''                  // N£mero de la Matricula

       LOCAL cCodigoTju := ''               // C¢digo del juicio
       LOCAL cNombreTju := ''               // Nombre del juicio
       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL cNombreTma := ''               // Nombre de la materia
       LOCAL cNotHabTno := ''               // Nota de la habilitaci¢n
       LOCAL cFecHabTno := ''               // Fecha de la habilitaci¢n
       LOCAL cCodigoTni := ''               // C¢digo del nivel
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO TOTAL DE AREAS
       nNroArn := 0
       FOR i:=1 TO LEN(aNotAre)
	  IF SUBS(aNotAre[i][4],7,4) == 'AREN'
	     nNroArn ++
	  ENDIF
       ENDFOR
       cCodigoTni := SUBS(GRU->cCodigoGru,1,2)
*>>>>FIN CALCULO TOTAL DE AREAS

*>>>>LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD
       nTotPer := TCO->nTotPerTbl
       lOficio := TCO->lOficioTbl
       lHabObs := TCO->lHabObsTbl
       nNroPer := nTotPer
       lPrnEmp := TCO->lPrnEmpTbl
       lPrnAre := TCO->lPrnAreTbl
       lNegAre := TCO->lNegAreTbl
       lPrnNot := IF(SUBS(TCO->cPrnNotTbl,nNroPer,1)='1',.T.,.F.)
       lHayNot := IF(SUBS(TCO->cHayNotTbl,nNroPer,1)='1',.T.,.F.)
       lNotNum := IF(SUBS(TCO->cNotNumTbl,nNroPer,1)='1',.T.,.F.)
       cNotAcu := TCO->cNotAcuTbl

       cNroFol := 'FOLIO No._______'
       cNroFol := PCL("CondenOn")+SPACE(01)+cNroFol+PCL("CondenOf")

       cNroMat := IF(EMPTY(TCO->cNroMatTbl),;
		    'MATRICULA No._______',TCO->cNroMatTbl)
       IF .NOT. EMPTY(cNroMat)
	  cNroMat := PCL("CondenOn")+ALLTRIM(cNroMat)+PCL("CondenOf")
       ENDIF

       cMsgBol := ALLTRIM(TCO->cMsgBolTbl)
       IF !lPrnNot
	  lHayNot := .F.
       ENDIF

       IF !lHayNot
	  lNotNum := .F.
       ENDIF
*>>>>FIN LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD

*>>>>CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR
       IF lPrnEmp
	  nTotImp := IF(nNroPer==nTotPer,15,08)
       ELSE
	  nTotImp := IF(nNroPer==nTotPer,15,11)
       ENDIF
      *L¡neas de los totales de impresi¢n

       nMarSup := TCO->nLinEspTbl
       nLinCab := 9
       nTotCab := IIF(nMarSup > nLinCab, nMarSup - nLinCab, 0)
     *Encabezado de columna

       nEncCol := 3
       nLinTop := nTotCab+nEncCol
     *Total l¡neas del encabezado

      nTotReg := nLinTop+nNroArn+LEN(aNotMat)+nTotImp
      nTotReg := 0
     *Total de registros a imprimir
*>>>>FIN CALCULO DEL TOTAL DE REGISTROS A IMPRIMIR

*>>>>IMPRESION DE LA HOJA DEL LIBRO
       bCabeza := {||CabezaLib(TCO->nLinEspTbl,; // Espacios para el encabezado
			       cNomEmp,;         // Nombre de la Empresa
			       lPrnEmp,;         // .T. Imprimir la Empresa
			       cNomSec,;         // Nombre Secundario
			       cAnoUsr,;         // A¤o del Usuario
			       cJorTxt,;         // Jornada escogida
			       NOT->cCodigoEst,; // C¢digo del Estudiante
			       cNomEst,;         // Nombre del Estudiante
			       GRU->cCodigoGru,; // C¢digo del Grupo
			       NOT->(RECNO()),;  // N£mero de Lista
			       0,;               // N£mero del Periodo. 0=>Libro Final
			       nNroPag++,;       // N£mero de p gina
			       cMatMod,;         // Materia de Modalidad
			       cNroMat,;         // N£mero de Matr¡cula
			       cNroFol,;         // N£mero de Folio
			       cTxtLib,;         // Texto del Libro
			       lInfFin,;         // .T. Informe Final
			       IF(lInfFin,TCO->cTitBolTbl,''))} // T¡tulo Superior

       lNotNum := IF(lNotNum,lNotNum,lHayItvJvf())

       lMatVar := .T.
       aMatHab := aMatHabPla(NOT->nAproboNot,aNotAre,aNotMat,nTotPer,lNotNum,;
			     lMatVar)
      *Materias de las Recuperaciones

       CuerpLib05(cNomSis,cJorTxt,cMsgBol,lRetEst,dFecRet,lNotNum,aNotAre,;
		  aNotMat,nNroPer,cNomEmp,lPrnEmp,cNroFol,lNegAre,bCabeza,;
		  aFirmas,lHayNot,lPrnAre,lOficio,cMaeAct,lHabObs,aMatHab,;
		  lInfFin,cNotAcu)

       RETURN NIL
*>>>>FIN IMPRESION DE LA HOJA DEL LIBRO

/*************************************************************************
* TITULO..: CUERPO DEL LIBRO FINAL No. 05                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 09/2003 LUN A
       Colombia, Bucaramanga        INICIO: 10:10 PM   NOV 09/2003 LUN

OBJETIVOS:

1- El cuerpo del libro est  formado por el encabezado y las asignaturas.

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CuerpLib05(cNomSis,cJorTxt,cMsgBol,lRetEst,dFecRet,lNotNum,;
		    aNotAre,aNotMat,nNroPer,cNomEmp,lPrnEmp,cNroFol,;
		    lNegAre,bCabeza,aFirmas,lHayNot,lPrnAre,lOficio,;
		    cMaeAct,lHabObs,aMatHab,lInfFin,cNotAcu)

*>>>>DESCRIPCION DE PARAMETROS
/*     cNomSis                              // Nombre del Sistema
       cJorTxt                              // Jornada escogida
       cMsgBol                              // T¡tulo de Encabezado
       lRetEst                              // .T. Estudiante Retirado
       dFecRet                              // Fecha de Retiro
       lNotNum                              // .F. Nota Cualitativa
       aNotAre                              // Detalles de las areas
       aNotMat                              // Detalles de las materias
       nNroPer			            // N£mero del Periodo
       cNomEmp                              // Nombre de la Empresa
       lPrnEmp                              // .T. Imprimir la Empresa
       cNroFol                              // N£mero del Folio
       lNegAre                              // .T. Areas en negrilla
       bCabeza                              // Funci¢n con Encabezado
       aFirmas                              // Firmas del libro.
       lHayNot                              // .T. Hay Notas
       lPrnAre                              // .T. Imprimir las areas
       lOficio                              // .F. Tama¤o Carta
       cMaeAct                              // Maestro Actual
       lHabObs                              // .T. Habilitaci¢n como observaci¢n .F. Habilitaci¢n en Columna
       aMatHab                              // Materias por Habilitar
       lInfFin                              // .T. Informe Final .F. Libro Final
       cNotAcu                              // Notas Acumuladas */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL i,j,k,p := 0                   // Contadores

       LOCAL aNroCol := {}                  // Columnas de los titulos
       LOCAL aTitulo := {}                  // T¡tulos para el informe
       LOCAL aRegPrn := {}                  // Registro de impresion

       LOCAL lPagina := .T.                 // .T. Cambio de p gina
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL nTotCab := 0                   // Total l¡neas del encabezado
       LOCAL nTotImp := 0                   // Totales de impresion
       LOCAL cTxtPrn := ''                  // Texto de impresion
       LOCAL nLenPrn := 0                   // Longitud de impresi¢n

       LOCAL cNroCol := ''                  // N£mero de columnas
       LOCAL cCamFal := ''                  // Campo de las fallas

       LOCAL nTotPer := 0                   // Total de periodos.
       LOCAL nNroArn := 0                   // N£mero areas no promediables
       LOCAL cCodAre := ''                  // C¢digo del area
       LOCAL cNomAre := ''                  // Nombre del area
       LOCAL cNomMat := ''                  // Nombre de la materia
       LOCAL cEvalua := ''                  // Evaluaci¢n conceptual
       LOCAL cEstado := ''                  // Estado final de aprobaci¢n
       LOCAL cIntens := ''                  // Intensidad Horaria
       LOCAL cNroFal := ''                  // N£mero de Ausencias
       LOCAL nLenTxt := ''                  // Longitud del texto
       LOCAL aNroLin := {}                  // N£mero de l¡neas
       LOCAL nPosHab := 0                   // Posici¢n de la Habilitaci¢n
       LOCAL cNotDef := ''                  // Nota Definitiva materia o area
       LOCAL cNotRec := ''                  // Nota de Recuperaci¢n
       LOCAL cNota   := ''                  // Notas

       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL cNombreTma := ''               // Nombre de la materia
       LOCAL cNotHabTno := ''               // Nota de la habilitaci¢n
       LOCAL cFecHabTno := ''               // Fecha de la habilitaci¢n
       LOCAL cCodigoTev := ''               // C¢digo de la Evaluaci¢n
       LOCAL cCodigoTni := ''               // C¢digo del nivel
       LOCAL cCodigoTcl := ''               // C¢digo de la clase
       LOCAL cTxtObsTap := ''               // Texto de Observaci¢n de Promoci¢n.

       LOCAL cCamNotDef := ''               // Campo de Notas Definitivas
       LOCAL cCamNotRec := ''               // Campo de Notas de Recuperaci¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ENCABEZADOS DE COLUMNA
       nLenPrn := PCL('n17Stan')

       aNroCol := {80,02,04}
       aTitulo := {'AREAS O ASIGNATURAS','IH','AUS.'}

       IF !EMPTY(cNotAcu)
	  FOR i := 1 TO nNroPer
	      AADD(aNroCol,2)
	      AADD(aTitulo,SUBS(cNotAcu,i*2-1,2))
	  ENDFOR
       ENDIF
       AADD(aNroCol,14)
       AADD(aTitulo,'EVALUACION')
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>IMPRESION DE LAS NOTAS
       nTotPer := TCO->nTotPerTbl
       FOR i:=1 TO LEN(aNotAre)

***********IMPRESION DEL ENCABEZADO
	    IF lPagina
	       OtraPagina(PCL({"DraftOn","CondenOn"}),;
			  PCL({"NegraOf","DobGolOf"}),;
			  aTitulo,aNroCol,bCabeza)
	    ENDIF
***********FIN IMPRESION DEL ENCABEZADO

**********IMPRESION DE LAS NOTAS DEL AREA
	    IF SUBS(aNotAre[i][4],7,4) == 'AREN'

*--------------ANALISIS DE LA IMPRESION DEL AREA
		 IF aNotAre[i][12]  // .T. No Imprimir
		    LOOP
		 ENDIF
*--------------FIN ANALISIS DE LA IMPRESION AREA

*--------------LECTURA DE LA NOTA DEL AREA
		 IF EMPTY(cNotAcu)
		    cCamNotDef := aNotAre[i,4]
		    cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

		    cNotDef := ALLTRIM(SUBS(&cCamNotDef,nNroPer*4-3,4))
		    cNotRec := ALLTRIM(SUBS(&cCamNotRec,nNroPer*4-3,4))

		    IF lNotNum
		       cNotDef := cNotDefJvf(VAL(cNotDef))+SPACE(03)
		       cNotRec := cNotDefJvf(VAL(cNotRec))+SPACE(03)
		    ENDIF

		    IF TCO->lRecNotTbl .AND. !EMPTY(cNotRec)
		       cNotDef := cNotRec
		    ENDIF
		 ENDIF
*--------------FIN LECTURA DE LA NOTA DEL AREA

*--------------LECTURA NOTAS ACUMULADAS DEL AREA
		 cNota := ''
		 IF !EMPTY(cNotAcu)

		    cCamNotDef := aNotAre[i,4]
		    cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

		    FOR p := 1 TO nNroPer

			cNotDef := SUBS(&cCamNotDef,p*4-3,4)
			cNotRec := SUBS(&cCamNotRec,p*4-3,4)

			IF lNotNum
			   cNotDef := cNotDefJvf(VAL(cNotDef))+SPACE(03)
			   cNotRec := cNotDefJvf(VAL(cNotRec))+SPACE(03)
			ENDIF

			IF !EMPTY(cNotRec)
			   cNota += ALLTRIM(cNotDef)+;
				    LOWER(ALLTRIM(cNotRec))+SPACE(02)
			ELSE
			   cNota += cNotDef
			ENDIF

			IF TCO->lRecNotTbl .AND. !EMPTY(cNotRec)
			   cNotDef := cNotRec
			ENDIF

		   ENDFOR
		 ENDIF
*--------------FIN LECTURA NOTAS ACUMULADAS DEL AREA

*--------------CONTEO DE LAS FALLAS
		 cCamFal := 'NOT->cFa'+SUBS(aNotAre[i,6],9,4)+'Not'
		 cNroFal := 0
		 IF nNroPer == nTotPer
		    FOR k := 1 TO nNroPer
		       cNroFal += VAL(SUBS(&cCamFal,k*2-1,2))
		    NEXT
		 ELSE
		    cNroFal := VAL(SUBS(&cCamFal,nNroPer*2-1,2))
		 ENDIF
		 cNroFal := IF(EMPTY(cNroFal),SPACE(02),STR(cNroFal,2,0))
*--------------FIN CONTEO DE LAS FALLAS

*--------------INTENSIDAD HORARIA DEL AREA
		 cIntens := IF(EMPTY(aNotAre[i,16]),aNotAre[i,11],aNotAre[i,16])
		 IF EMPTY(cIntens)
		    cIntens := SPACE(02)
		 ENDIF
*--------------FIN INTENSIDAD HORARIA DEL AREA

*--------------IMPRESION DEL REGISTRO DEL AREA
		 cNomAre := aNotAre[i,3]+SPACE(80-LEN(aNotAre[i,3]))
		 aRegPrn := {cNomAre,cIntens,cNroFal}

		 IF !EMPTY(cNotAcu)
		    FOR p := 1 TO nNroPer
			AADD(aRegPrn,ALLTRIM(SUBS(cNota,p*4-3,4)))
		    ENDFOR
		    cNotDef := ALLTRIM(SUBS(cNota,nNroPer*4-3,4))

		    IF LEN(cNotDef) == 2
		       cNotDef := SUBS(cNotDef,2,1)
		    ENDIF
		 ENDIF

		 AADD(aRegPrn,ALLTRIM(cTxtNota(UPPER(cNotDef),.T.)))
		 cTxtPrn := cRegPrint(aRegPrn,aNroCol)
		 @ PROW()+1,00 SAY cTxtPrn
*--------------FIN IMPRESION DEL REGISTRO DEL AREA

*--------------ANALISIS PARA EL CAMBIO DE PAGINA
		 IF PROW() > IIF(lOficio,70,58)
		    DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
		    EJECT
		    OtraPagina(PCL({"DraftOn","CondenOn"}),;
			       PCL({"NegraOf","DobGolOf"}),;
			       aTitulo,aNroCol,bCabeza)
		 ENDIF
*--------------FIN ANALISIS PARA EL CAMBIO DE PAGINA

	    ENDIF
**********FIN IMPRESION DE LAS NOTAS DEL AREA

**********IMPRESION DE LAS NOTAS DE LA MATERIA
	    FOR j:=1 TO LEN(aNotMat)

	       IF aNotAre[i,2] == aNotMat[j,1]

*-----------------ANALISIS DE LA IMPRESION DE LA MATERIA
		    IF aNotMat[j][12]   // .T. No Imprimir
		       LOOP
		    ENDIF
*-----------------FIN ANALISIS DE LA IMPRESION DE LA MATERIA

*-----------------LECTURA DE LA NOTA DE LA MATERIA
		    IF EMPTY(cNotAcu)
		       cCamNotDef := aNotMat[j,4]
		       cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

		       cNotDef := SUBS(&cCamNotDef,nNroPer*4-3,4)
		       cNotRec := SUBS(&cCamNotRec,nNroPer*4-3,4)

		       IF lNotNum
			  cNotDef := cNotDefJvf(VAL(cNotDef))+SPACE(03)
			  cNotRec := cNotDefJvf(VAL(cNotRec))+SPACE(03)
		       ENDIF

		       IF TCO->lRecNotTbl .AND. !EMPTY(cNotRec)
			  cNotDef := cNotRec
		       ENDIF
		    ENDIF
*-----------------FIN LECTURA DE LA NOTA DE LA MATERIA

*-----------------LECTURA NOTAS ACUMULADAS DE LA MATERIA
		    cNota := ''
		    IF !EMPTY(cNotAcu)

		       cCamNotDef := aNotMat[j,4]
		       cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

		       FOR p := 1 TO nNroPer

			   cNotDef := SUBS(&cCamNotDef,p*4-3,4)
			   cNotRec := SUBS(&cCamNotRec,p*4-3,4)

			   IF lNotNum
			      cNotDef := cNotDefJvf(VAL(cNotDef))+SPACE(03)
			      cNotRec := cNotDefJvf(VAL(cNotRec))+SPACE(03)
			   ENDIF

			   IF !EMPTY(cNotRec)
			      cNota += ALLTRIM(cNotDef)+;
				       LOWER(ALLTRIM(cNotRec))+SPACE(02)
			   ELSE
			      cNota += cNotDef
			   ENDIF

			   IF TCO->lRecNotTbl .AND. !EMPTY(cNotRec)
			      cNotDef := cNotRec
			   ENDIF

		      ENDFOR
		    ENDIF
*-----------------FIN LECTURA NOTAS ACUMULADAS DE LA MATERIA

*-----------------CONTEO DE LAS FALLAS DE LA MATERIA
		    cCamFal := aNotMat[j,6]
		    cNroFal := 0
		    IF nNroPer == nTotPer
		       FOR k := 1 TO nNroPer
			  cNroFal += VAL(SUBS(&cCamFal,k*2-1,2))
		       NEXT
		    ELSE
		       cNroFal := VAL(SUBS(&cCamFal,nNroPer*2-1,2))
		    ENDIF
		    cNroFal := IF(EMPTY(cNroFal),SPACE(02),STR(cNroFal,2,0))
*-----------------FIN CONTEO DE LAS FALLAS DE LA MATERIA

*-----------------INTENSIDAD HORARIA DE LA MATERIA
		    cIntens := IF(EMPTY(aNotMat[j,16]),aNotMat[j,3],aNotMat[j,16])
		    IF EMPTY(cIntens)
		       cIntens := SPACE(02)
		    ENDIF
*-----------------FIN INTENSIDAD HORARIA DE LA MATERIA

*-----------------IMPRESION DEL REGISTRO DE LA MATERIA
		    cNomMat := aNotMat[j,10]+SPACE(80-LEN(aNotMat[j,10]))
		  *ÀMateria Notas o Certificado

		    IF aNotMat[j,1] == cCodAre .AND. SUBS(aNotMat[j,5],11,2) # '00'
		       cNomMat := SUBS(SPACE(02)+cNomMat,1,80)
		    ELSE
		       cCodAre := aNotMat[j,1]
		    ENDIF
		  *ÀIndentaci¢n de la materia

		    aRegPrn := {cNomMat,cIntens,cNroFal}

		    IF !EMPTY(cNotAcu)
		       FOR p := 1 TO nNroPer
			   AADD(aRegPrn,ALLTRIM(SUBS(cNota,p*4-3,4)))
		       ENDFOR
		       cNotDef := ALLTRIM(SUBS(cNota,nNroPer*4-3,4))

		       IF LEN(cNotDef) == 2
			  cNotDef := SUBS(cNotDef,2,1)
		       ENDIF
		    ENDIF

		    AADD(aRegPrn,ALLTRIM(cTxtNota(UPPER(cNotDef),.T.)))
		    cTxtPrn := cRegPrint(aRegPrn,aNroCol)
		    @ PROW()+1,00 SAY cTxtPrn
*-----------------FIN IMPRESION DEL REGISTRO DE LA MATERIA

*-----------------ANALISIS PARA EL CAMBIO DE PAGINA
		    IF PROW() > IIF(lOficio,70,58)
		       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
		       EJECT

		       OtraPagina(PCL({"DraftOn","CondenOn"}),;
				  PCL({"NegraOf","DobGolOf"}),;
				  aTitulo,aNroCol,bCabeza)

		    ENDIF
*-----------------FIN ANALISIS PARA EL CAMBIO DE PAGINA

	       ENDIF
	    ENDFOR
**********FIN IMPRESION DE LAS NOTAS DE LA MATERIA

**********ANALISIS PARA EL CAMBIO DE PAGINA
	    IF PROW() > IIF(lOficio,70,58)
	       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
	       EJECT
	       lPagina := .T.
	    ELSE
	       lPagina := .F.
	    ENDIF
**********FIN ANALISIS PARA EL CAMBIO DE PAGINA

       ENDFOR
       nLenTxt := LEN(cTxtPrn)
       @ PROW()+1,00 SAY REPL('-',LEN(cTxtPrn))
      *Impresi¢n de la £ltima l¡nea
*>>>>FIN IMPRESION DE LAS NOTAS

*>>>>ANALISIS PARA EL CAMBIO DE PAGINA
       IF PROW() > IIF(lOficio,70,58) - nTotImp .OR. PROW() = 0
	  IF PROW() <> 0
	     IF PROW() <= IIF(lOficio,70,58)
		DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
	     ENDIF
	     EJECT
	  ENDIF
	  OtraPagina(PCL({"DraftOn","CondenOn"}),;
		     PCL({"NegraOf","DobGolOf"}),;
		     aTitulo,aNroCol,bCabeza)
       ENDIF
*>>>>FIN ANALISIS PARA EL CAMBIO DE PAGINA

*>>>>IMPRESION DE LAS AREAS HABILITAR
       IF nNroPer == nTotPer .AND. !EMPTY(NOT->cMatHabNot)

**********IMPRESION DE LOS DETALLES DE LA HABILITACION
	    @PROW()+2,00 SAY IF ('0000' $ TCO->cNotNumTbl,;
				 'RECUPERACIONES','HABILITACIONES')
	    @PROW()  ,32 SAY SPACE(50)+'FECHA      ACTA  EVALUACION'
	    FOR k := 1 TO LEN(ALLTRIM(NOT->cMatHabNot))/4

*--------------LOCALIZACION DE LA MATERIAS A HABILITAR
		 cCodigoTma := SUBS(NOT->cMatHabNot,k*4-3,4)
		 cNombreTma := 'FAVOR VERIFICAR'
		 IF lLocCodigo('cCodigoMat','MAT',cCodigoTma,;
				     'DEL AREA')
		    cNombreTma := MAT->cNombreMat
		 ENDIF
*--------------FIN LOCALIZACION DE LA MATERIAS A HABILITAR

*--------------LECTURA DE LA NOTA DE LA RECUPERACION O HABILITACION
		 cNotHabTno := SUBS(NOT->cNotHabNot,k*4-3,4)

		 IF '0000' $ TCO->cNotNumTbl
		    DO CASE
		    CASE 'D' $ cNotHabTno
			 cNotHabTno := 'DEFICIENTE'
		    CASE 'I' $ cNotHabTno
			 cNotHabTno := 'INSUFICIENTE'
		    CASE 'A' $ cNotHabTno
			 cNotHabTno := 'ACEPTABLE'
		    CASE 'B' $ cNotHabTno
			 cNotHabTno := 'BUENO'
		    CASE 'S' $ cNotHabTno
			 cNotHabTno := 'SOBRESALIENTE'
		    CASE 'E' $ cNotHabTno
			 cNotHabTno := 'EXCELENTE'
		    CASE 'R' $ cNotHabTno
			 cNotHabTno := 'REGULAR'
		    ENDCASE
		 ENDIF
*--------------FIN LECTURA DE LA NOTA DE LA RECUPERACION O HABILITACION

*--------------IMPRESION DE LA HABILITACION
		 cFecHabTno := cFecha(NOT->dFecHa1Not)
		 @PROW()+1,00 SAY cNombreTma+SPACE(02)+;
				  cFecHabTno+SPACE(02)+;
				  SUBS(NOT->cActHabNot,k*4-3,4)+SPACE(02)+;
				  cNotHabTno+SPACE(02)
*--------------FIN IMPRESION DE LA HABILITACION

	    ENDFOR
**********FIN IMPRESION DE LOS DETALLES DE LA HABILITACION

       ENDIF
*>>>>FIN IMPRESION DE LAS AREAS HABILITAR

*>>>>ANALISIS PARA EL CAMBIO DE PAGINA
       IF PROW() > 46
	  DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
	  EJECT
	  OtraPagina(PCL({"DraftOn","CondenOn"}),;
		     PCL({"NegraOf","DobGolOf"}),;
		     aTitulo,aNroCol,bCabeza)
       ENDIF
*>>>>FIN ANALISIS PARA EL CAMBIO DE PAGINA

*>>>>IMPRESION DE LA PROMOCION FINAL
       cEstado := ''
       IF nNroPer == nTotPer
	  IF lRetEst
	     cEstado := 'NO TERMINO. SE RETIRO EN '+cFecha(dFecRet)+' '+;
			&cMaeAct->cObsRetEst
	     cTxtObsTap := ''
	  ELSE
	     cEstado := cAproboJui(NOT->nAproboNot,;
				   SUBS(&cMaeAct->cCodigoGru,1,2),;
					@cTxtObsTap)
	  ENDIF
	  cEstado    := ALLTRIM(cEstado)

       ENDIF
       aNroLin := aDivLin(ALLTRIM('OBSERVACION FINAL: '+cEstado),110)
       FOR i := 1 TO LEN(aNroLin)
	   @ PROW()+1,00 SAY aNroLin[i]
       NEXT
*>>>>FIN IMPRESION DE LA PROMOCION FINAL

*>>>>IMPRESION DE LAS RECUPERACIONES COMO OBSERVACIONES
       IF lHabObs .AND. !EMPTY(aMatHab)
	  @ PROW()+1,00 SAY ''

	  IF EMPTY(TCO->cTitRecTbl)
	     cTxtPrn := 'ACTIVIDADES DE RECUPERACION DE:'
	  ELSE
	     cTxtPrn := ALLTRIM(TCO->cTitRecTbl)
	  ENDIF

	  FOR i := 1 TO LEN(aMatHab)
	      cTxtPrn += ALLTRIM(aMatHab[i,5])+': '
	      IF ALLTRIM(cTxtNota(aMatHab[i,4])) == 'SIN NOTA'
		 cTxtPrn += 'PENDIENTE. '

	      ELSE
		 cTxtPrn += ALLTRIM(cTxtNota(aMatHab[i,4]))+;
			    ' - ACTA No.'+ALLTRIM(aMatHab[i,3])+;
			    ' DE '+aMatHab[i,2]+'. '
	      ENDIF
	  NEXT
	  aNroLin := aDivLin(ALLTRIM(cTxtPrn),110)
	  FOR i := 1 TO LEN(aNroLin)
	      @ PROW()+1,00 SAY aNroLin[i]
	  NEXT
       ENDIF
*>>>>FIN IMPRESION DE LAS RECUPERACIONES COMO OBSERVACIONES

*>>>>IMPRESION DE LA OBSERVACION
       IF lInfFin .AND. !EMPTY(cTxtObsTap)
	  aNroLin := aDivLin(ALLTRIM(cTxtObsTap),110)
	  FOR i := 1 TO LEN(aNroLin)
	      @ PROW()+1,00 SAY aNroLin[i]
	  NEXT
       ENDIF
     *ÀObservaci¢n de Recuperacion.

       IF !EMPTY(TCO->cOb4BolTbl)
	  aNroLin := aDivLin(ALLTRIM(TCO->cOb4BolTbl),110)
	  FOR i := 1 TO LEN(aNroLin)
	      @ PROW()+1,00 SAY aNroLin[i]
	  NEXT
       ENDIF
     *ÀObservaci¢n General del Libro

       IF !EMPTY(&cMaeAct->cObsLibEst)
	  aNroLin := aDivLin(ALLTRIM(&cMaeAct->cObsLibEst),110)
	  FOR i := 1 TO LEN(aNroLin)
	      @ PROW()+1,00 SAY aNroLin[i]
	  NEXT
       ENDIF
     *ÀObservaci¢n del Estudiante

       @ PROW()+2,00 SAY 'OBSERVACIONES:'
       @ PROW()+1,00 SAY REPL('-',nLenTxt)
       @ PROW()+2,00 SAY REPL('-',nLenTxt)
       @ PROW()+2,00 SAY REPL('-',nLenTxt)
     *ÀImpresi¢n l¡neas de la observaci¢n
*>>>>FIN IMPRESION DE LA OBSERVACION

*>>>>IMPRESION DE LAS FIRMAS
       IF lInfFin
	  cTxtPrn := 'Dir. '+aFirmas[1,1]
	  @ PROW()+2,(nLenPrn-LEN(cTxtPrn))/2 SAY REPL('-',LEN(cTxtPrn)+4)
	  @ PROW()+1,((nLenPrn-LEN(cTxtPrn))/2)+2 SAY cTxtPrn
       ELSE
	  Firmas(PCL('n17Stan'),6,aFirmas,.F.)
       ENDIF
      *Impresi¢n firmantes del libro

       DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio)
       EJECT
       RETURN NIL
*>>>>FIN IMPRESION DE LAS FIRMAS