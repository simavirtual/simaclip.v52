/* SIMA - MATRICULA ACADEMICA

MODULO      : EXAMENES
SUBMODULO...: EXAMENES               MODULO No. 201

**************************************************************************
* NOMBRE DEL PROGRAMA..: MATRI201.PRG                                    *
* TITULO DEL PROGRAMA..: GRABACION DE EXAMENES                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 03/96 MIE A
       Colombia, Bucaramanga        INICIO: 05:05 PM   ENE 03/96 MIE


REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Permite grabar las notas parciales de los examenes

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_201(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-MATR.PRG"      // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr    := .F.              // .T. Hay Error

       LOCAL cSavLin := ''                  // Salvar Linea
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal

       LOCAL cLenNom := ''                  // Longitud para los nombres
       LOCAL nLenNom := 0                   // Longitud del nombre
       LOCAL nNroNot := 0                   // Numero de notas a grabar
       LOCAL cNotas  := ''                  // Notas de los examenes
       LOCAL nNota   := 0                   // Nota parcial del examen

       LOCAL     i,j := 0                   // Contadores

       LOCAL aTitulo[12]                    // Titulos de las Columnas
       LOCAL aTamCol[12]                    // Tama¤o de las Columnas
       LOCAL aNroCol[12]                    // N£meros de Columnas
       LOCAL cNumeroTad := ''               // N£mero de Inscripci¢n
       LOCAL cNombreTes := ''               // Nombre del Estudiante

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // Modo de Protecci¢n
       LOCAL cCodSui := ''                  // C¢digo del Sistema
       LOCAL cNomSis := ''                  // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := ''                  // Nombre de la Empresa principal
       LOCAL cNitEmp := ''                  // Nit de la Empresa
       LOCAL cNomEmp := ''                  // Nombre de la Empresa
       LOCAL cNomSec := ''                  // Nombre de la Empresa Secundario
       LOCAL cCodEmp := ''                  // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := ''                  // Nombre del Usuario
       LOCAL cAnoUsr := ''                  // A¤o del usuario
       LOCAL cAnoSis := ''                  // A¤o del sistema
       LOCAL cPatSis := ''                  // Path del sistema
     *ÀDetalles del Usuario

       LOCAL nFilPal := 0                   // Fila Inferior Men£ principal
       LOCAL nFilInf := 0                   // Fila Inferior del SubMen£
       LOCAL nColInf := 0                   // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL PathW01 := ''                  // Sitio del Sistema No.01
       LOCAL PathW02 := ''                  // Sitio del Sistema No.02
       LOCAL PathW03 := ''                  // Sitio del Sistema No.03
       LOCAL PathW04 := ''                  // Sitio del Sistema No.04
       LOCAL PathW05 := ''                  // Sitio del Sistema No.05
       LOCAL PathW06 := ''                  // Sitio del Sistema No.06
       LOCAL PathW07 := ''                  // Sitio del Sistema No.07
       LOCAL PathW08 := ''                  // Sitio del Sistema No.08
       LOCAL PathW09 := ''                  // Sitio del Sistema No.09
       LOCAL PathW10 := ''                  // Sitio del Sistema No.10
     *ÀSitios del Sistema

       LOCAL PathUno := ''                  // Path de Integraci¢n Uno
       LOCAL PathDos := ''                  // Path de Integraci¢n Dos
       LOCAL PathTre := ''                  // Path de Integraci¢n Tres
       LOCAL PathCua := ''                  // Path de Integraci¢n Cuatro
     *ÀPath de Integraci¢n

       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cJorTxt := ''                  // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL aParams := {}                  // Parametros Generales
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>LECTURA PARAMETROS GENERALES
       aParams := aParams(aParam1,aParam2,aParam3)
       IF  !lParam0101(aParams,;
		       @lShared,@nModCry,@cCodSui,@cNomSis,;
		       @cEmpPal,@cNitEmp,@cNomEmp,@cNomSec,@cCodEmp,;
		       @cNomUsr,@cAnoUsr,@cAnoSis,@cPatSis,;
		       @nFilPal,@nFilInf,@nColInf,;
		       @PathW01,@PathW02,@PathW03,@PathW04,@PathW05,;
		       @PathW06,@PathW07,@PathW08,@PathW09,@PathW10,;
		       @PathUno,@PathDos,@PathTre,@PathCua,;
		       @cMaeAlu,@cMaeAct,@cJorTxt)
	  CloseAll()
	  RETURN NIL
       ENDIF
       CloseAll()
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+;
		       fMtrAno+cAnoUsr+ExtFile,'ANO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FileAdm+cAnoUsr+ExtFile,'ADM',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE ANO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DE LA MATRICULA PARA EL A¥O')

       CASE ADM->(RECCOUNT()) == 0
	    cError('No Existen Inscripciones')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>ANALISIS DE LA ACTIVACION DE LOS EXAMENES
       IF !ANO->lHayExaAno
	  cError('NO ESTA HABILITADA LA OPCION PARA EXAMENES')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE LA ACTIVACION DE LOS EXAMENES

*>>>>LECTURA DEL TOTAL DE NOTAS
       nNroNot := ANO->nNroExaAno
       IF nNroNot == 0
	  cError('NO SE HA DEFINIDO EL NUMERO DE NOTAS PARA LOS EXAMENES')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL TOTAL DE NOTAS

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,'POR FAVOR ENTRE LAS NOTAS '+;
			 'DEL EXAMEN',22,'°')
       nNroCol := 1
       cLenNom := '302620'
       FOR i := 1 TO nNroNot+2

	   DO CASE
	   CASE i == 1
		aTamCol[i] := 06
		aTitulo[i] := 'CODIGO'
	   CASE i == 2
		   nLenNom := VAL(IIF(nNroNot<=7,'36',;
				  SUBS(cLenNom,(nNroNot-7)*2-1,2)))
		aTamCol[i] := nLenNom
		aTitulo[i] := 'NOMBRE'
	   OTHERWISE
		aTamCol[i] := 04
		aTitulo[i] := 'NOT'+IF(i<12,STR(i-2,1),STR(i-2,2))
	   ENDCASE
       NEXT
       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>GRABACION DE LAS NOTAS
       nNroFil++
       DO WHILE .T.

**********LECTURA DEL CODIGO
	    cSavPan := SAVESCREEN(nNroFil,0,nNroFil,79)
	    IF lLeeCodAdm(nNroFil,aNroCol[1],;
			  @cNumeroTad,{||lLocCodigo('cNumeroAdm',;
					 'ADM',cNumeroTad,;
					 'NUMERO DE INSCRIPCION')})
		EXIT
	    ENDIF
	    cNombreTes := RTRIM(SUBS(RTRIM(ADM->cNombreEst)+;
				     ' '+ADM->cApelliEst,1,nLenNom))
**********FIN LECTURA DEL CODIGO

**********ANALISIS SI EL CANDIDATO ESTA RETIRADO
	    IF ADM->lRetiroAdm
	       cError(cNombreTes+ ' ESTA RETIRADO')
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL CANDIDATO ESTA RETIRADO

**********IMPRESION DE LAS NOTAS ACTUALES
	    @ nNroFil,aNroCol[2] SAY cNombreTes
	    IF !lHayErr
	       cNotas := SUBS(ADM->cNotExaAdm,1,nNroNot*4)

	       SET COLOR TO I
	       FOR j=1 TO nNroNot
		  @ nNroFil,aNroCol[j+2] SAY SUBS(cNotas,j*4-3,4)
	       NEXT
	       SET COLOR TO
	    ENDIF
**********FIN IMPRESION DE LAS NOTAS ACTUALES

**********CAPTURA Y VALIDACION DE LAS NOTAS
	    i:= 1
	    DO WHILE i <= nNroNot

*--------------CAPTURA DE LA NOTA
		 IF I = 1
		    cSavLin := SAVESCREEN(21,0,21,79)
		    Centrar('Teclee 11 en la nota para terminar',21)
		 ENDIF

		 nNota = VAL(SUBS(cNotas,I*4-3,4))
		 @ nNroFil,aNroCol[i+2] GET nNota PICT "99.9"
		 READ
		 RESTSCREEN(21,0,21,79,cSavLin)
*--------------FIN CAPTURA DE LA NOTA

*--------------DETERMINACION PARA LA SALIDA DE GRABACION
		 IF nNota == 11
		    EXIT
		 ENDIF
*--------------FIN DETERMINACION PARA LA SALIDA DE GRABACION

*--------------VALIDACION DE LA NOTA
		 DO CASE
		 CASE nNota > 10.0 .OR. nNota < 0
		      cError('LA NOTA ESTA POR FUERA DEL RANGO')
		      LOOP
		 CASE nNota >0 .AND. nNota < 1
		      cError('LA NOTA ESTA POR FUERA DEL RANGO')
		      LOOP
		 ENDCASE
*--------------FIN VALIDACION DE LA NOTA

*--------------ASIGNACION DE LA NOTA
		  cNotas = STUFF(cNotas,I*4-3,4,;
				 IIF(nNota=0,SPACE(04),STR(nNota,4,1)))
*--------------FIN ASIGNACION DE LA NOTA

*--------------PREGUNTA DE DECISION
		 IF i == nNroNot
		    IF !lPregunta('DESEA GRABAR LA NOTAS? Si No')
		       i := 1
		       LOOP
		    ENDIF
		 ENDIF
		 lHayErr := .F.
*--------------FIN CORREGIR LAS NOTAS

	       i++
	    ENDDO
**********FIN CAPTURA Y VALIDACION DE LAS NOTAS

**********SALIDA DEL PROCESO DE GRABACION
	    IF nNota = 11
	       EXIT
	    ENDIF
**********FIN SALIDA DEL PROCESO DE GRABACION

**********GRABAR DE LAS NOTAS Y LA DEFINITIVA
	    IF ADM->(lRegLock(lShared,.F.))
	       REPLACE ADM->cNotExaAdm WITH ;
		       STUFF(ADM->cNotExaAdm,1,nNroNot*4,cNotas)

	       REPLACE ADM->nDefExaAdm WITH nDefinitiva(nNroNot,cNotas)

	       REPLACE ADM->cNotExaAdm WITH ;  // Marca de grabaci¢n
		       STUFF(ADM->cNotExaAdm,41,1,'*')
	    ELSE
		cError('NO SE GRABA EL REGISTRO NOTAS')
	    ENDIF
	    ADM->(DBCOMMIT())
	    IF lShared
	       ADM->(DBUNLOCK())
	    ENDIF
**********FIN GRABAR DE LAS NOTAS Y LA DEFINITIVA

**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    IF nNroFil > 19

*--------------IMPRESION DE LOS DATOS DEL ULTIMO ESTUDIANTE
		 nNroFil := nMarco(nFilPal+1,'POR FAVOR ENTRE LAS NOTAS '+;
				   'DEL EXAMEN',22,'°')
		 @ nNroFil,nNroCol SAY cMsgTxt

		 nNroFil++
		 SET COLOR TO I
		 @ nNroFil,01 SAY cNumeroTad
		 SET COLOR TO

		 @ nNroFil,aNroCol[2] SAY cNombreTes
*--------------FIN IMPRESION DE LOS DATOS DEL ULTIMO ESTUDIANTE

*--------------IMPRESION DE LAS NOTAS DEL ULTIMO ESTUDIANTE
		 SET COLOR TO I
		 FOR i=1 TO nNroNot
		    @ nNroFil,aNroCol[i+2] SAY SUBS(cNotas,i*4-3,4)
		 NEXT
		 SET COLOR TO
		 nNroFil ++
*--------------FIN IMPRESION DE LAS NOTAS DEL ULTIMO ESTUDIANTE

	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

       ENDDO
       CLOSE ALL
       RETURN NIL
*>>>>FIN GRABACION DE LAS NOTAS DE LOS ESTUDIANTES