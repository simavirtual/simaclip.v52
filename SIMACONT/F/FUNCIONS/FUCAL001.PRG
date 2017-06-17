/*************************************************************************
* TITULO..: JUICIO VALORATIVO CALCULADO. POR GRUPO. METODO No. 001       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 06/2008 JUE A
       Colombia, Bucaramanga        INICIO: 03:00 PM   NOV 06/2008 JUE

OBJETIVOS:

1- Recorre todos los estudiantes del grupo para realizar los c lculos

2- Calcula el juicio valorativo para el informe final de acuerdo al
   promedio del valor n£merico de cada uno de los juicios valorativos
   de cada periodo.

3- M‚todo sugerido por Colegio La Salle - Villavicencio.

4- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CalNot001(aP1,aP2,aP3,;
		   nNroPer,nTotPer,aNotAre,aNotMat,lRecNot,aTotErr)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1			            // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       nNroPer			            // N£mero del Periodo
       nTotPer                              // Total Periodos
       aNotAre                              // Detalles de las areas
       aNotMat                              // Detalles de las materias
       lRecNot                              // .T. Recuperar el Juicio Valorativo
       aTotErr			            // Hay Error */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION PARAMETROS
       LOCAL lShared := xPrm(aP1,'lShared') // .T. Sistema Compartido
       LOCAL nModCry := xPrm(aP1,'nModCry') // Modo de Protecci¢n
       LOCAL cCodSui := xPrm(aP1,'cCodSui') // C¢digo del Sistema
       LOCAL cNomSis := xPrm(aP1,'cNomSis') // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := xPrm(aP1,'cEmpPal') // Nombre de la Empresa principal
       LOCAL cNitEmp := xPrm(aP1,'cNitEmp') // Nit de la Empresa
       LOCAL cNomEmp := xPrm(aP1,'cNomEmp') // Nombre de la Empresa
       LOCAL cNomSec := xPrm(aP1,'cNomSec') // Nombre de la Empresa Secundario
       LOCAL cCodEmp := xPrm(aP1,'cCodEmp') // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := xPrm(aP1,'cNomUsr') // Nombre del Usuario
       LOCAL cAnoUsr := xPrm(aP1,'cAnoUsr') // A¤o del usuario
       LOCAL cAnoSis := xPrm(aP1,'cAnoSis') // A¤o del sistema
       LOCAL cPatSis := xPrm(aP1,'cPatSis') // Path del sistema
     *ÀDetalles del Usuario

       LOCAL PathW01 := xPrm(aP1,'PathW01') // Sitio del Sistema No.01
       LOCAL PathW02 := xPrm(aP1,'PathW02') // Sitio del Sistema No.02
       LOCAL PathW03 := xPrm(aP1,'PathW03') // Sitio del Sistema No.03
       LOCAL PathW04 := xPrm(aP1,'PathW04') // Sitio del Sistema No.04
       LOCAL PathW05 := xPrm(aP1,'PathW05') // Sitio del Sistema No.05
       LOCAL PathW06 := xPrm(aP1,'PathW06') // Sitio del Sistema No.06
       LOCAL PathW07 := xPrm(aP1,'PathW07') // Sitio del Sistema No.07
       LOCAL PathW08 := xPrm(aP1,'PathW08') // Sitio del Sistema No.08
       LOCAL PathW09 := xPrm(aP1,'PathW09') // Sitio del Sistema No.09
       LOCAL PathW10 := xPrm(aP1,'PathW10') // Sitio del Sistema No.10
     *ÀSitios del Sistema

       LOCAL PathUno := xPrm(aP1,'PathUno') // Path de Integraci¢n Uno
       LOCAL PathDos := xPrm(aP1,'PathDos') // Path de Integraci¢n Dos
       LOCAL PathTre := xPrm(aP1,'PathTre') // Path de Integraci¢n Tres
       LOCAL PathCua := xPrm(aP1,'PathCua') // Path de Integraci¢n Cuatro
     *ÀPath de Integraci¢n

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Actual
       LOCAL cJornad := xPrm(aP1,'cJornad') // Jornadas habilitadas
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lRetiroTes := .F.              // .T. Retiro del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECORRIDO POR NOTAS
       SELECT NOT
       NOT->(DBGOTOP())
       DO WHILE .NOT. NOT->(EOF())

**********ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
	    IF NOT->lRetGruNot
	       NOT->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

**********LINEA DE ESTADO
	    LineaEstado('METODO No.1'+;
			'ºGRUPO:'+GRU->cCodigoGru+;
			'ºNo. '+NOT->(STR(RECNO(),2))+'/'+;
				NOT->(STR(RECCOUNT(),2))+;
			'ºCODIGO:'+NOT->cCodigoEst,cNomSis)
**********FIN LINEA DE ESTADO

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    IF lSekCodigo(NOT->cCodigoEst,cMaeAct)
	       cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			     RTRIM(&cMaeAct->cNombreEst)
	    ELSE
	       cNombreTes := 'EL ALUMNO NO EXISTE'
	    ENDIF
	    cNombreTes := SUBS(cNombreTes+SPACE(50),1,50)
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********ANALISIS DEL PERIODO DEL RETIRO
	    lRetiroTes := &cMaeAct->lRetiroEst
	    IF lRetiroTes
	       IF nNroPer <= &cMaeAct->nPerRetEst
		  lRetiroTes := .F.
	       ENDIF
	    ENDIF
**********FIN ANALISIS DEL PERIODO DEL RETIRO

**********ANALISIS SI EL ESTUDIANTE ESTA RETIRADO
	    IF lRetiroTes
	       SELECT NOT
	       NOT->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO

**********CALCULOS AREAS MATERIAS
	    AreMat001(lShared,aNotAre,aNotMat,;
		      nNroPer,nTotPer,lRecNot,;
		      aTotErr)
**********FIN CALCULOS AREAS MATERIAS

	  NOT->(DBSKIP())

       ENDDO
       RETURN NIL
*>>>>FIN RECORRIDO POR NOTAS

/*************************************************************************
* TITULO..: JUICIO VALORATIVO CALCULADO. AREAS Y MATERIAS                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 08/2008 MAR A
       Colombia, Bucaramanga        INICIO: 11:00 PM   JUL 08/2008 MAR

OBJETIVOS:

1- Recorre todas las areas y materias para realizar el c lculo

2- Calcula el juicio valorativo para el informe final de acuerdo al
   promedio del valor n£merico de cada uno de los juicios valorativos
   de cada periodo.

3- M‚todo sugerido por Colegio La Salle - Villavicencio.

4- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION AreMat001(lShared,aNotAre,aNotMat,;
		   nNroPer,nTotPer,lRecNot,aTotErr)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       aNotAre                              // Detalles de las areas
       aNotMat                              // Detalles de las materias
       nNroPer                              // N£mero del Periodo
       nTotPer                              // Total Periodos
       lRecNot                              // .T. Recuperar el Juicio Valorativo
       aTotErr			            // Hay Error */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL     i,j := 0                   // Contador

       LOCAL       p := 0                   // Periodos

       LOCAL cNotDef := ''                  // Nota Definitiva
       LOCAL cNotRec := ''                  // Nota de Recuperaci¢n
       LOCAL nVlrNum := 0                   // Volor N£merico
       LOCAL nTotNot := 0                   // Sumatoria de la Nota
       LOCAL nNroNot := 0                   // N£mero de Notas
       LOCAL cNotCal := ''                  // Nota calculada.
       LOCAL cNotJvf := ''                  // Nota Juicio Valorativo final

       LOCAL lJvfCalTma := .F.              // .F. Calcula el Juicio Valorativo .T. No Calcula el Juicio Valorativo

       LOCAL cCamNotDef := ''               // Campo de Notas Definitivas
       LOCAL cCamNotRec := ''               // Campo de Notas de Recuperaci¢n
       LOCAL cCodigoTma := ''               // C¢digo de la materia
       LOCAL cCamDefNot := ''               // Campo notas definitivas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECORRIDO POR AREAS
       FOR i := 1 TO LEN(aNotAre)

**********AREAS NO PROMEDIABLES
	    IF SUBS(aNotAre[i][4],7,4) == 'AREN'

*==============ANALISIS DE DECISION
		 lJvfCalTma := !aNotAre[i,19]
		 IF .NOT. lJvfCalTma
		    LOOP
		 ENDIF
*==============FIN ANALISIS DE DECISION

*==============LECTURA DE LA NOTA DEL AREA
		 cCamNotDef := aNotAre[i,4]
		 cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

		 nTotNot := 0
		 nNroNot := 0
		 FOR p := 1 TO nTotPer-1

		     cNotDef := SUBS(&cCamNotDef,p*4-3,4)
		     cNotRec := SUBS(&cCamNotRec,p*4-3,4)

		     IF lRecNot .AND. !EMPTY(cNotRec)
			cNotDef := cNotRec
		     ENDIF

		     nVlrNum := nFactorJvf(ALLTRIM(cNotDef))

		     IF nVlrNum > 0
			nTotNot += nVlrNum
			nNroNot++
		     ENDIF

		 ENDFOR
*==============FIN LECTURA DE LA NOTA DEL AREA

*==============CALCULO DE LA NOTA DEFINITIVA. AREA
		 cNotCal := SPACE(04)
		 IF nTotNot > 0
		    cNotCal := nTotNot/nNroNot
		    IF cNotCal == 10
		       cNotCal := '10.0'
		    ELSE
		       cNotCal := SUBS(STR(cNotCal,4,1),1,4)
		    ENDIF
		 ENDIF

		 cNotJvf := cNotDefJvf(VAL(cNotCal))+SPACE(03)
*==============FIN CALCULO DE LA NOTA DEFINITIVA. AREA

*===============GRABACION DE LA NOTA DEL AREA
		  SELECT NOT
		  IF NOT->(lRegLock(lShared,.F.))

		     REPL &cCamNotDef WITH;
			  STUFF(&cCamNotDef,nTotPer*4-3,4,cNotJvf)
		   *ÀNota del Area

		     NOT->(DBCOMMIT())
		  ELSE
		     cError('NO SE PUEDE GRABAR JVF DEL AREA')
		  ENDIF
		  IF lShared
		     NOT->(DBUNLOCK())
		  ENDIF
*===============FIN GRABACION DE LA NOTA DEL AREA

	    ENDIF
**********FIN AREAS NO PROMEDIABLES

**********RECORRIDO POR MATERIAS DEL AREA PROMEDIABLE
	    FOR j := 1 TO LEN(aNotMat)

***************MATERIA DEL AREA
		 IF aNotAre[i,2] == aNotMat[j,1]

*===================ANALISIS DE DECISION
		      lJvfCalTma := !aNotMat[j,19]
		      IF .NOT. lJvfCalTma
			 LOOP
		      ENDIF
*===================FIN ANALISIS DE DECISION

*===================LECTURA DE LA NOTA DE LA MATERIA
		      cCamNotDef := aNotMat[j,4]
		      cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

		      nTotNot := 0
		      nNroNot := 0
		      FOR p := 1 TO nTotPer-1

			  cNotDef := SUBS(&cCamNotDef,p*4-3,4)
			  cNotRec := SUBS(&cCamNotRec,p*4-3,4)

			  IF lRecNot .AND. !EMPTY(cNotRec)
			     cNotDef := cNotRec
			  ENDIF

			  nVlrNum := nFactorJvf(ALLTRIM(cNotDef))

			  IF nVlrNum > 0
			     nTotNot += nVlrNum
			     nNroNot++
			  ENDIF

		      ENDFOR
*===================FIN LECTURA DE LA NOTA DE LA MATERIA

*===================CALCULO DE LA NOTA DEFINITIVA. MATERIA
		      cNotCal := SPACE(04)
		      IF nTotNot > 0
			 cNotCal := nTotNot/nNroNot
			 IF cNotCal == 10
			    cNotCal := '10.0'
			 ELSE
			    cNotCal := SUBS(STR(cNotCal,4,1),1,4)
			 ENDIF
		      ENDIF

		      cNotJvf := cNotDefJvf(VAL(cNotCal))+SPACE(03)
*===================FIN CALCULO DE LA NOTA DEFINITIVA. MATERIA

*===================GRABACION DE LA NOTA DE LA MATERIA
		      SELECT NOT
		      IF NOT->(lRegLock(lShared,.F.))

			 REPL &cCamNotDef WITH;
			      STUFF(&cCamNotDef,nTotPer*4-3,4,cNotJvf)
		       *ÀNota de la materia

			 NOT->(DBCOMMIT())
		      ELSE
			 cError('NO SE PUEDE GRABAR JVF DEL AREA')
		      ENDIF
		      IF lShared
			 NOT->(DBUNLOCK())
		      ENDIF
*===================FIN GRABACION DE LA NOTA DE LA MATERIA

		 ENDIF
***************FIN MATERIA DEL AREA

	    ENDFOR
**********FIN RECORRIDO POR MATERIAS DEL AREA PROMEDIABLE

       ENDFOR
       RETURN NIL
*>>>>FIN RECORRIDO POR AREAS