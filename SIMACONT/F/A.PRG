IF nProMat > 10
   wait 'paso'
   wait nProMat
   wait aTotNot[k]
   wait aNroEst[k]
ENDIF

/*************************************************************************
* TITULO..: MATERIAS DEL ESTUDIANTE CON INSUFICIENTE O DEFICIENTE        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 19/2002 MAR A
       Colombia, Bucaramanga        INICIO: 03:15 PM   NOV 19/2002 MAR

OBJETIVOS:

1- Determina el n£mero de materias con juicio valorativo Insuficiente o
   Deficiente.

3- Retorna un vector con las materias.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MatEstID(aNotAre,aNotMat,nNroPer,lRecNot,aMateID)

*>>>>DESCRIPCION DE PARAMETROS
/*     aNotAre                              // Detalles de las areas
       aNotMat                              // Detalles de las materias
       nNroPer                              // N£mero del Periodo
       lRecNot                              // .T. Recuperar el Juicio Valorativo
       aMateID                              // Materia Insuficiente o Deficiente */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL i,j := 0                       // Contadores
       LOCAL cNotDef := ''                  // Nota Definitiva
       LOCAL cNotRec := ''                  // Nota de Recuperaci¢n
       LOCAL lHayItv := .F.                 // .T. Nota Numerica por Intervalo de Juicios valorativos

       LOCAL cCamNotDef := ''               // Campo de Notas Definitivas
       LOCAL cCamNotRec := ''               // Campo de Notas de Recuperaci¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>MATERIAS CON INSUFICIENTE O DEFICIENTE
       aMateID := {}
       lHayItv := lHayItvJvf()
       FOR i:=1 TO LEN(aNotAre)

***********ANALISIS DE LA MATERIA NO RECUPERABLE
	     IF aNotAre[i][15]
		LOOP
	     ENDIF
***********FIN ANALISIS DE LA MATERIA NO RECUPERABLE

***********ANALISIS JUICIO VALORATIVO DEL AREA
	     IF SUBS(aNotAre[i][4],7,4) == 'AREN'
		cCamNotDef := aNotAre[i,4]
		cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

		cNotDef := ALLTRIM(SUBS(&cCamNotDef,nNroPer*4-3,4))
		cNotRec := ALLTRIM(SUBS(&cCamNotRec,nNroPer*4-3,4))
		IF lHayItv
		   cNotDef := cNotDefJvf(VAL(cNotDef))
		   cNotRec := cNotDefJvf(VAL(cNotRec))
		ENDIF

		IF lRecNot .AND. !EMPTY(cNotRec)
		   cNotDef := cNotRec
		ENDIF

		IF UPPER(cNotDef) == 'I' .OR. UPPER(cNotDef) == 'D'

		   AADD(aMateID,{aNotAre[i,10],;
				 cNotDef,;
				 IF (UPPER(cNotDef) == 'I',;
				     'INSUFICIENTE','DEFICIENTE'),;
				 aNotAre[i,7]})
		ENDIF
	     ENDIF
***********FIN ANALISIS JUICIO VALORATIVO DEL AREA

***********ANALISIS DE LA MATERIA
	     FOR j:=1 TO LEN(aNotMat)

*................ANALISIS DE LA MATERIA NO RECUPERABLE
		   IF aNotMat[j,15]
		      LOOP
		   ENDIF
*................ANALISIS DE LA MATERIA NO RECUPERABLE

*................ANALISIS DEL JUICIO VALORATIVO
		   IF aNotAre[i,2] == aNotMat[j,1]

		      cCamNotDef := aNotMat[j,4]
		      cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

		      cNotDef := ALLTRIM(SUBS(&cCamNotDef,nNroPer*4-3,4))
		      cNotRec := ALLTRIM(SUBS(&cCamNotRec,nNroPer*4-3,4))
		      IF lHayItv
			 cNotDef := cNotDefJvf(VAL(cNotDef))
			 cNotRec := cNotDefJvf(VAL(cNotRec))
		      ENDIF

		      IF lRecNot .AND. !EMPTY(cNotRec)
			 cNotDef := cNotRec
		      ENDIF

		      IF UPPER(cNotDef) == 'I' .OR. UPPER(cNotDef) == 'D'
			 AADD(aMateID,{aNotMat[j,10],;
				       cNotDef,;
				       IF (UPPER(cNotDef) == 'I',;
					   'INSUFICIENTE','DEFICIENTE'),;
				       aNotMat[j,7]})


		      ENDIF
		   ENDIF
*................FIN ANALISIS DEL JUICIO VALORATIVO

	     ENDFOR
***********FIN ANALISIS DE LA MATERIA

       ENDFOR
       RETURN NIL
*>>>>FIN MATERIAS CON INSUFICIENTE O DEFICIENTE

