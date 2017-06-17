/*************************************************************************
* TITULO DEL PROGRAMA..: CUADRO DE RESUMEN DE LOGROS DE LOS ESTUDIANTES  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 08/98 VIE A
       Colombia, Bucaramanga        INICIO: 12:25 AM   MAY 08/98 VIE

OBJETIVOS:

1- Imprime los resumenes de los estudiantes de acuerdo al bimestre

2- Debe estar en uso el archivo de notas del grupo correspondiente

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/


FUNCTION ResumenLog(cNomEmp,cNomSis,cAnoUsr,nNroBis,nNroIni,;
		    nNroFin,nPorAcS,nPorBiS,cJorTxt,cMaeAct)


*>>>>PARAMETROS DE LA FUNCION
/*     cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombres del Sistema
       cAnoUsr                              // A¤o del sistema
       nNroBis			            // N£mero del bimestre
       nNroIni                              // N£mero de lista inicial
       nNroFin                              // N£mero de lista final
       cMaeAct			            // Maestro activado
       cJorTxt                              // Jornada escogida */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
*       #INCLUDE "\APLICA.CLI\CLIPPER.FUN\EPSONFX.PRG"  // Impresora EPSON FX

       LOCAL aNroCol := {}                  // Columnas de los titulos
       LOCAL aTitulo := {}                  // T¡tulos para el informe
       LOCAL aRegPrn := {}                  // Registro de impresion

       LOCAL nLinReg := 0                   // L¡neas del registro
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nLenPrn := 0                   // Longitud de impresi¢n

       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL nTotReg := 0                   // Total registros a imprimir
       LOCAL nNroReg := 0                   // N£mero de registros

       LOCAL lTamAnc := .T.                 // .T. Tama¤o Ancho
       LOCAL aCabeza := {}                  // Definici¢n del encabezado
       LOCAL cCodIni := ''                  // C¢digos impresora iniciales
       LOCAL cCabCol := ''                  // Encabezados de columnas
       LOCAL cCodFin := ''                  // C¢digos impresora finales
       LOCAL lCentra := .T.                 // Centrar Encabezados Columna
       LOCAL nColCab := 0                   // Columna encabezado columna

       LOCAL     i,j := 0                   // Contadores
       LOCAL aStrNot := {}                  // Estructura del archivo notas
       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias
       LOCAL aCampos := {}                  // Nombres de los campos
       LOCAL aArePed := {}                  // Detalles areas p‚rdidas
       LOCAL aNotMin := {}                  // Detalles notas m¡nimas
       LOCAL cNotDef := ''                  // Nota definitiva
       LOCAL nArePed := 0                   // Areas perdidas
       LOCAL cAcuAct := ''                  // Acumulado actual
       LOCAL cNotMin := ''                  // Nota M¡nima

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cCodigoTma := ''               // C¢digo de la materia
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ACTIVACION DE LA IMPRESORA
       IF !Printer_on()
	   RETURN NIL
       ENDIF
       @ PROW(),00 SAY INICIALIZA+PROPOR_OF+CONDEN_ON
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>DEFINICION DE LOS DETALLES DE LAS AREAS Y MATERIAS
       aNotAre := {}
       aNotMat := {}
       aCampos := {}
       DetAreas(@aNotAre,@aNotMat,nNroBis)
*>>>>FIN DEFINICION DE LOS DETALLES DE LAS AREAS Y MATERIAS

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nNroReg := NOT->(RECCOUNT())
       IF nNroFin # 0
	  nNroReg := nNroFin - nNroIni + 1
	 *N£mero de registro cuando es un intervalo
       ENDIF
       nTotReg := nNroReg * (nNroBis+4)
     *ÀCalculo del total de registros

       aCabeza := {cNomEmp,;
		   cNomSis+' JORNADA '+cJorTxt+' DE '+cAnoUsr,;
		   'PERIODO No.'+STR(nNroBis,2),;
		   'CUADRO DE RESUMEN LOGROS',;
		   'GRUPO: '+GRU->cCodigoGru,;
		   nNroPag,cTotPagina(nTotReg),lTamAnc}

       cCodIni := DRAFT_ON+CONDEN_ON
       cCodFin := NEGRA_ON+DOBGOL_OF+CONDEN_OF
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       FOR i:=1 TO LEN(aNotAre)

	   IF SUBS(aNotAre[i][4],7,4) == 'AREN'
	      AADD(aTitulo, SUBS(aNotAre[i,7],1,6))
	      AADD(aNroCol,06)
	      AADD(aCampos,{aNotAre[i,7],aNotAre[i,6],aNotAre[i,11]})
	     *               Alias         Logros        Ausencias
	   ENDIF

	   FOR j:=1 TO LEN(aNotMat)

	      IF aNotAre[i,2] == aNotMat[j,1]
		 AADD(aTitulo,LOWER(SUBS(aNotMat[j,7],1,6)))
		 AADD(aNroCol,06)
		 AADD(aCampos,{aNotMat[j,7],aNotMat[j,5],aNotMat[j,6]})
		*               Alias         Logros        Ausencias
	      ENDIF

	   ENDFOR

       ENDFOR
       cCabCol := cRegPrint(aTitulo,@aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n17Stan
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF

       CabezaPrn(cCodIni,aCabeza,cCabCol,nColCab,cCodFin)
      *Impresi¢n del encabezado
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT NOT
       GO nNroIni
       DO WHILE .NOT. NOT->(EOF())

**********ANALISIS PARA LA SALIDA
	    SELECT NOT
	    IF nNroFin <> 0
	       IF NOT->(RECNO()) > nNroFin
		  EXIT
	       ENDIF
	    ENDIF
**********FIN ANALISIS PARA LA SALIDA

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    IF lSekCodigo(NOT->cCodigoEst,'ALU')
	       cNombreTes := RTRIM(ALU->cApelliEst)+' '+;
			     RTRIM(ALU->cNombreEst)
	    ELSE
	       cNombreTes := 'EL ALUMNO NO EXISTE'
	    ENDIF
	    cNombreTes := SUBS(cNombreTes+SPACE(51),1,51)
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********ANALISIS SI EL ESTUDIANTE ESTA RETIRADO
	    IF ALU->lRetiroEst .OR. NOT->lRetGruNot
	       SELECT NOT
	       SKIP
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO

**********IMPRESION DEL CONTENIDO DEL INFORME
	    nLinReg := LEN(aCampos)

	    lPrintPrn(01,00,cCodIni,aCabeza,cCabCol,nColCab,cCodFin,;
			    STR(NOT->(RECNO()),2)+SPACE(02)+;
			    NOT->cCodigoEst+SPACE(02)+;
			    SUBS(cNombreTes,1,51),cNomSis,cNomEmp,;
			    nLinReg,nLenPrn)
	    nLinReg := 0
	   *Por estar imprimiendo el registro
**********FIN IMPRESION DEL CONTENIDO DEL INFORME

**********IMPRESION DEL REGISTRO
	    FOR i:=1 TO LEN(aCampos)

		cJuicio := &(aCampos[i,2])
		nNroInd := ROUND(LEN(ALLTRIM(cJuicio))/5,0)
		cLogros := ''
		FOR j := 1 TO nNroInd
		    cCodLog := SUBS(cJuicio,j*5-4,5)
		    cLogros += cCodLog + SPACE(01)
		ENDFOR

		lPrintPrn(01,00,cCodIni,aCabeza,cCabCol,nColCab,cCodFin,;
				aCampos[i,1]+SPACE(02)+cLogros,;
				cNomSis,cNomEmp,nLinReg,nLenPrn)
	    ENDFOR
	    lPrintPrn(01,00,cCodIni,aCabeza,cCabCol,nColCab,cCodFin,;
			    REPL('=',LEN(cCabCol)),;
			    cNomSis,cNomEmp,nLinReg,nLenPrn)
**********FIN IMPRESION DEL REGISTRO

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT NOT
	    SKIP
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       CLOSE NOT
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS