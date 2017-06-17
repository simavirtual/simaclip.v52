/* SIMA - MATRICULA ACADEMICA

MODULO      : HOJA DE VIDA
SUBMODULO...: INFORMACION PERSONAL                     MODULO No. 307

**************************************************************************
* TITULO..: GRABACION DE INFORMACION PERSONAL                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 03/96 MIE A
       Colombia, Bucaramanga        INICIO: 05:40 PM   ENE 03/96 MIE


REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Permite grabar las notas parciales de las entrevistas

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_371(aParam1,aParam2,aParam3)

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

       CASE ANO->nNroEntAno == 0 .AND. ANO->lHayEntAno
	    cError('No se han definido el n£mero de notas '+;
		   'para las entrevistas')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,'POR FAVOR ENTRE LOS DATOS '+;
			 'DE LA ENTREVISTA',22,'°')
       nNroCol := 1
       cLenNom := '302620'

       nNroNot := IF(ANO->lHayEntAno,ANO->nNroEntAno,0)
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

**********VALIDACION DEL CODIGO
	    IF !ADM->lExamenAdm .AND. ANO->lHayEntAno
	       cError(cNombreTes+' NO FUE CITADO A ENTREVISTA')
	       LOOP
	    ENDIF
**********FIN VALIDACION DEL CODIGO

**********GRABACION DE LA INFORMACION PERSONAL
	    cSavPan := SAVESCREEN(0,0,24,79)
	    IF !lHojaVida(lShared,nFilPal,1,ADM->cNumeroAdm,;
			  cNombreTes,;
			  ADM->cCodigoGru,1)
	       RESTSCREEN(0,0,24,79,cSavPan)
	       LOOP
	    ENDIF
	    RESTSCREEN(0,0,24,79,cSavPan)
**********FIN GRABACION DE LA INFORMACION PERSONAL

**********GRABACION DE LA INFORMACION DEL PADRE
	    cSavPan := SAVESCREEN(0,0,24,79)
	    IF !lHojaVida(lShared,nFilPal,1,ADM->cNumeroAdm,;
			  cNombreTes,;
			  ADM->cCodigoGru,2)
	       RESTSCREEN(0,0,24,79,cSavPan)
	       LOOP
	    ENDIF
	    RESTSCREEN(0,0,24,79,cSavPan)
**********FIN GRABACION DE LA INFORMACION DEL PADRE

**********GRABACION DE LA INFORMACION DE LA MADRE
	    cSavPan := SAVESCREEN(0,0,24,79)
	    IF !lHojaVida(lShared,nFilPal,1,ADM->cNumeroAdm,;
			  cNombreTes,;
			  ADM->cCodigoGru,3)
	       RESTSCREEN(0,0,24,79,cSavPan)
	       LOOP
	    ENDIF
	    RESTSCREEN(0,0,24,79,cSavPan)
**********FIN GRABACION DE LA INFORMACION DE LA MADRE

**********GRABACION DE LA INFORMACION DEL ACUDIENTE
	    cSavPan := SAVESCREEN(0,0,24,79)
	    IF !lHojaVida(lShared,nFilPal,1,ADM->cNumeroAdm,;
			  cNombreTes,;
			  ADM->cCodigoGru,4)
	       RESTSCREEN(0,0,24,79,cSavPan)
	       LOOP
	    ENDIF
	    RESTSCREEN(0,0,24,79,cSavPan)
**********FIN GRABACION DE LA INFORMACION DEL ACUDIENTE

**********IMPRESION DE LAS NOTAS ACTUALES
	    @ nNroFil,aNroCol[2] SAY cNombreTes

	    IF !lHayErr .AND. ANO->lHayEntAno
	       cNotas := SUBS(ADM->cNotEntAdm,1,nNroNot*4)

	       SET COLOR TO I
	       FOR j=1 TO nNroNot
		  @ nNroFil,aNroCol[j+2] SAY SUBS(cNotas,j*4-3,4)
	       NEXT
	       SET COLOR TO
	    ENDIF
**********FIN IMPRESION DE LAS NOTAS ACTUALES

**********CAPTURA Y VALIDACION DE LAS NOTAS
	    i:= 1
	    DO WHILE i <= nNroNot .AND. ANO->lHayEntAno

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
	    IF nNota = 11 .AND. ANO->lHayEntAno
	       EXIT
	    ENDIF
**********FIN SALIDA DEL PROCESO DE GRABACION

**********GRABAR DE LAS NOTAS Y LA DEFINITIVA
	    IF ANO->lHayEntAno
	       IF ADM->(lRegLock(lShared,.F.))
		  REPLACE ADM->cNotEntAdm WITH ;
			  STUFF(ADM->cNotEntAdm,1,nNroNot*4,cNotas)

		  REPLACE ADM->nDefEntAdm WITH nDefinitiva(nNroNot,cNotas)

		  REPLACE ADM->cNotEntAdm WITH ;  // Marca de grabaci¢n
			  STUFF(ADM->cNotEntAdm,41,1,'*')
	       ELSE
		   cError('NO SE GRABA EL REGISTRO NOTAS')
	       ENDIF
	       ADM->(DBCOMMIT())
	       IF lShared
		  ADM->(DBUNLOCK())
	       ENDIF
	    ENDIF
**********FIN GRABAR DE LAS NOTAS Y LA DEFINITIVA

**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    IF nNroFil > 19

*--------------IMPRESION DE LOS DATOS DEL ULTIMO ESTUDIANTE
		 nNroFil := nMarco(nFilPal+1,'POR FAVOR ENTRE LOS DATOS '+;
				   'DE LA ENTREVISTA',22,'°')
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

***************************************************************************
*----------------------------FIN DEL PROGRAMA ----------------------------*
*--------------- DECLARACION DE FUNCIONES PARA EL PROGRAMA ---------------*
***************************************************************************

/*************************************************************************
* TITULO DEL PROGRAMA..: GRABACION DE LA HOJA DE VIDA DEL CANDIDATO      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 03/96 MIE A
       Colombia, Bucaramanga        INICIO: 05:20 PM   ENE 03/96 MIE

OBJETIVOS:

1- Debe estar en uso el archivo de admisiones.

2- El archivo debe estar ubicado en el registro del candidato y debe estar
   bloqueado

3- Graba la hoja de vida del candidato

4- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lHojaVida(lShared,nFilInf,nColInf,cNroIns,;
		   cNombre,cCodGru,nNroOpc,oBrowse)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nFilInf                              // Fila de lectura
       nColInf                              // Columna de lectura
       cNroIns                              // N£mero de Inscripci¢n
       cNombre                              // Nombre del Estudiante
       cCodGru                              // C¢digo del grupo
       nNroOpc                              // Opci¢n de Actualizaci¢n
       oBrowse			            // Browse de Consulta */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nTipCur := 0                   // Tipo de Cursor
       LOCAL lGrabar := .T.                 // .T. Grabar el registro
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nNroReg := 0                   // N£mero de Registro
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL cSexFem := ''                  // Sexo del Estudiante
       LOCAL nTipAcu := 0                   // Tipo de Acudiente

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cLugNacTes := ''               // Lugar de nacimiento
       LOCAL dFecNacTes := ''               // Fecha de nacimiento
       LOCAL cDocNitTes := ''		    // Documento de identidad
       LOCAL cLugNitTes := ''		    // Lugar de expedici¢n
       LOCAL cTipNitTes := ''               // Tipo del Documento
       LOCAL lSexFemTes := .F.              // Sexo del Estudiante
       LOCAL nEstratTes := 0                // Estracto del Estudiante
       LOCAL cDireccTes := ''		    // Direcci¢n del candidato
       LOCAL cBarrioTes := ''		    // Barrio
       LOCAL cCiudadTes := ''               // Ciudad del Estudiante
       LOCAL cTelefnTes := ''		    // Telefono de la residencia
       LOCAL cTelCelTes := ''               // *Telefono celular del Estudiante
       LOCAL cMaiEstTes := ''               // E-MAIL de la Casa o del Estudiante
       LOCAL cNomEpsTes := ''               // Nombre de la Eps
       LOCAL cGrupRhTes := ''               // Grupo Sanguineo

       LOCAL cViveCoTes := ''               // *Estudiante vive con.
       LOCAL nNroHerTes := ''               // *N£mero de Hermanos.
       LOCAL cHerGruTes := ''               // *Grupo de los Hermanos
       LOCAL cLocaliTes := ''               // *Localidad.
       LOCAL cZonaDiTes := ''               // *Zona de la Direcci¢n.

       LOCAL cApePadTes := ''               // Apellido del padre
       LOCAL cNomPadTes := ''		    // Nombre del padre
       LOCAL lPadQepTes := .F.              // Fallecido
       LOCAL cPadQepTes := ''               // Fallecido
       LOCAL cPadNitTes := ''               // C‚dula del padre
       LOCAL cPadLugTes := ''               // Lugar de la c‚dula
       LOCAL cPadTntTes := ''               // Tipo del Documento
       LOCAL cDirPadTes := ''               // Direcci¢n del Padre
       LOCAL cBarPadTes := ''               // Barrio del Padre
       LOCAL cCiuPadTes := ''               // Ciudad del Padre
       LOCAL cProPadTes := ''		    // Profesi¢n del padre
       LOCAL cEmpPadTes := ''		    // Empresa del padre
       LOCAL cCarPadTes := ''		    // Cargo del padre
       LOCAL cTelPadTes := ''               // Telefono del padre
       LOCAL cCelPadTes := ''               //*Telefono celular del Padre
       LOCAL cFaxPadTes := ''               //*Fax del Padre
       LOCAL cBipPadTes := ''               //*Biper del Padre
       LOCAL cMaiPadTes := ''               // E-MAIL del Padre

       LOCAL cApeMadTes := ''               // Apellido de la madre
       LOCAL cNomMadTes := ''		    // Nombre de la madre
       LOCAL lMadQepTes := .F.              // Fallecida
       LOCAL cMadQepTes := ''               // Fallecida
       LOCAL cMadNitTes := ''               // C‚dula de la madre
       LOCAL cMadLugTes := ''               // Lugar de la c‚dula
       LOCAL cMadTntTes := ''               // Tipo del Documento
       LOCAL cDirMadTes := ''               // Direcci¢n de la Madre
       LOCAL cBarMadTes := ''               // Barrio de la Madre
       LOCAL cCiuMadTes := ''               // Ciudad de la Madre
       LOCAL cProMadTes := ''		    // Profesi¢n de la madre
       LOCAL cEmpMadTes := ''		    // Empresa de la madre
       LOCAL cCarMadTes := ''		    // Cargo de la madre
       LOCAL cTelMadTes := ''		    // Telefono de la madre
       LOCAL cCelMadTes := ''               //*Telefono celular de la Madre
       LOCAL cFaxMadTes := ''               //*Fax de la Madre
       LOCAL cBipMadTes := ''               //*Biper de la Madre
       LOCAL cMaiMadTes := ''               // E-MAIL de la Madre

       LOCAL cApeAcuTes := ''               // Apellido del Acudiente
       LOCAL cNomAcuTes := ''		    // Nombre del acudiente
       LOCAL cAcuNitTes := ''               // C‚dula del acudiante
       LOCAL cAcuLugTes := ''               // Lugar de la c‚dula
       LOCAL cAcuTntTes := ''               // Tipo del Documento
       LOCAL cDirAcuTes := ''               // Direcci¢n del Acudiente
       LOCAL cBarAcuTes := ''               // Barrio del Acudiente
       LOCAL cCiuAcuTes := ''               // Ciudad del Acudiente
       LOCAL cProAcuTes := ''		    // Profesi¢n del Acudiente
       LOCAL cEmpAcuTes := ''		    // Empresa del Acudiente
       LOCAL cCarAcuTes := ''		    // Cargo de la Acudiente
       LOCAL cTe1AcuTes := ''		    // Telefono casa acudiente
       LOCAL cTe2AcuTes := ''		    // Telefono oficina acudiente
       LOCAL cCelAcuTes := ''               //*Telefono celular del Acudiente
       LOCAL cFaxAcuTes := ''               //*Fax del Acudiente
       LOCAL cBipAcuTes := ''               //*Biper del Acudiente
       LOCAL cMaiAcuTes := ''               // E-MAIL del Acudiente
       LOCAL cParAcuTes := ''               // Parentesco del Acudiente

       LOCAL GetList    := {}               // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE DECISION
       IF !EMPTY(oBrowse)
	  cSavPan := SAVESCREEN(0,0,24,79)
	  SET CURSOR ON
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>MENU DE ACTUALIZACION
       IF EMPTY(nNroOpc)
	  AADD(aMenus,'1<INFORMACION PERSONAL>')
	  AADD(aMenus,'2<INFORMACION FAMILIAR>')
	  AADD(aAyuda,'Actualiza la Informaci¢n Personal')
	  AADD(aAyuda,'Actualiza la Informaci¢n Familiar')

	  nNroOpc := 1
	  cSavPan := SAVESCREEN(0,0,24,79)
	  nNroOpc := nMenu(aMenus,aAyuda,10,25,'ACTUALIZAR',NIL,1,.F.)
	  RESTSCREEN(0,0,24,79,cSavPan)
	  IF nNroOpc == 0
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN MENU DE ACTUALIZACION

*>>>>IMPRESION DEL NOMBRE DEL CANDIDATOS
       nNroFil := nMarco(nFilInf+1,;
		  IF(nNroOpc==1,;
		     'POR FAVOR ACTUALICE LA INFORMACION DEL ESTUDIANTE',;
		     'CODIGO: '+ADM->cNumeroAdm+' '+cNombreTes+' '+;
		     'CURSO : '+ADM->cCodigoGru),22,'°')

       nNroCol := nColInf
       IF nNroOpc == 1
	  @ nNroFil,nNroCol+00 SAY 'CODIGO: '+ADM->cCodigoEst
	  @ nNroFil,nNroCol+15 SAY 'NOMBRE: '+RTRIM(ADM->cApelliEst)+' '+;
						    ADM->cNombreEst
	  @ nNroFil,nNroCol+65 SAY 'CURSO : '+ADM->cCodigoGru
       ENDIF
*>>>>FIN IMPRESION DEL NOMBRE DEL CANDIDATOS

*>>>>IMPRESION DEL NOMBRE DEL CANDIDATOS
       nNroFil := nMarco(nFilInf+1,;
		  IF(nNroOpc==1,;
		     'POR FAVOR ACTUALICE LA INFORMACION DEL ESTUDIANTE',;
		     'CODIGO: '+cNroIns+' '+cNombre+' '+;
		     'CURSO : '+cCodGru),22,'°')

       nNroCol := nColInf
       IF nNroOpc == 1
	  @ nNroFil,nNroCol+00 SAY 'CODIGO: '+cNroIns
	  @ nNroFil,nNroCol+15 SAY 'NOMBRE: '+cNombre
	  @ nNroFil,nNroCol+65 SAY 'CURSO : '+cCodGru
       ENDIF
*>>>>FIN IMPRESION DEL NOMBRE DEL CANDIDATOS

*>>>>LECTURA Y GRABACION DE LA HOJA DE VIDA
       SET ESCAPE ON
       SELECT ADM
       DO WHILE .T.

**********INICIALIZACION DE LAS VARIABLES TEMPORALES
	    IF lGrabar

	       cLugNacTes := ADM->cLugNacEst
	       dFecNacTes := ADM->dFecNacEst
	       cDocNitTes := ADM->cDocNitEst
	       cLugNitTes := ADM->cLugNitEst
	       cTipNitTes := ADM->cTipNitEst
	       lSexFemTes := ADM->lSexFemEst
	       nEstratTes := ADM->nEstratEst
	       IF lSexFemTes
		  cSexFem := 'F'
	       ELSE
		  cSexFem := 'M'
	       ENDIF
	       cDireccTes := ADM->cDireccEst
	       cBarrioTes := ADM->cBarrioEst
	       cCiudadTes := ADM->cCiudadEst
	       cTelefnTes := ADM->cTelefnEst
	       cTelCelTes := ADM->cTelCelEst
	       cMaiEstTes := ADM->cMaiEstEst
	       cNomEpsTes := ADM->cNomEpsEst
	       cGrupRhTes := ADM->cGrupRhEst
	     *ÀImformaci¢n Personal

	       cViveCoTes := ADM->cViveCoEst
	       nNroHerTes := ADM->nNroHerEst
	       cHerGruTes := ADM->cHerGruEst
	       cLocaliTes := ADM->cLocaliEst
	       cZonaDiTes := ADM->cZonaDiEst
	     *ÀImformaci¢n Personal

	       cApePadTes := ADM->cApePadEst
	       cNomPadTes := ADM->cNomPadEst
	       lPadQepTes := ADM->lPadQepEst
	       cPadQepTes := IF(lPadQepTes,'S','N')
	       cPadNitTes := ADM->cPadNitEst
	       cPadLugTes := ADM->cPadLugEst
	       cPadTntTes := ADM->cPadTntEst
	       cDirPadTes := ADM->cDirPadEst
	       cBarPadTes := ADM->cBarPadEst
	       cCiuPadTes := ADM->cCiuPadEst
	       cProPadTes := ADM->cProPadEst
	       cEmpPadTes := ADM->cEmpPadEst
	       cCarPadTes := ADM->cCarPadEst
	       cTelPadTes := ADM->cTelPadEst
	       cCelPadTes := ADM->cCelPadEst
	       cFaxPadTes := ADM->cFaxPadEst
	       cBipPadTes := ADM->cBipPadEst
	       cMaiPadTes := ADM->cMaiPadEst
	     *ÀInformaci¢n del Padre

	       cApeMadTes := ADM->cApeMadEst
	       cNomMadTes := ADM->cNomMadEst
	       lMadQepTes := ADM->lMadQepEst
	       cMadQepTes := IF(lMadQepTes,'S','N')
	       cMadNitTes := ADM->cMadNitEst
	       cMadLugTes := ADM->cMadLugEst
	       cMadTntTes := ADM->cMadTntEst
	       cDirMadTes := ADM->cDirMadEst
	       cBarMadTes := ADM->cBarMadEst
	       cCiuMadTes := ADM->cCiuMadEst
	       cProMadTes := ADM->cProMadEst
	       cEmpMadTes := ADM->cEmpMadEst
	       cCarMadTes := ADM->cCarMadEst
	       cTelMadTes := ADM->cTelMadEst
	       cCelMadTes := ADM->cCelMadEst
	       cFaxMadTes := ADM->cFaxMadEst
	       cBipMadTes := ADM->cBipMadEst
	       cMaiMadTes := ADM->cMaiMadEst
	     *ÀInformaci¢n de la Madre

	       cApeAcuTes := ADM->cApeAcuEst
	       cNomAcuTes := ADM->cNomAcuEst
	       cAcuNitTes := ADM->cAcuNitEst
	       cAcuLugTes := ADM->cAcuLugEst
	       cAcuTntTes := ADM->cAcuTntEst
	       cDirAcuTes := ADM->cDirAcuEst
	       cBarAcuTes := ADM->cBarAcuEst
	       cCiuAcuTes := ADM->cCiuAcuEst
	       cProAcuTes := ADM->cProAcuEst
	       cEmpAcuTes := ADM->cEmpAcuEst
	       cCarAcuTes := ADM->cCarAcuEst
	       cTe1AcuTes := ADM->cTe1AcuEst
	       cTe2AcuTes := ADM->cTe2AcuEst
	       cParAcuTes := ADM->cParAcuEst
	       cCelAcuTes := ADM->cCelAcuEst
	       cFaxAcuTes := ADM->cFaxAcuEst
	       cBipAcuTes := ADM->cBipAcuEst
	       cMaiAcuTes := ADM->cMaiAcuEst
	     *ÀInformaci¢n del Acudiente

	    ENDIF
**********FIN INICIALIZACION DE LAS VARIABLES TEMPORALES

**********ACTUALIZACION DE LA INFORMACION DEL ESTUDIANTE
	    DO CASE
	    CASE nNroOpc == 1

*----------------INFORMACION PERSONAL
		   nNroFil := nFilInf+6
		   @nNroFil,nNroCol+00   SAY 'NACIDO EN:';
					 GET cLugNacTes PICT "@!";
					 VALID !EMPTY(cLugNacTes)

		   @nNroFil,nNroCol+34 SAY 'FECHA:';
					 GET dFecNacTes;
					 VALID !EMPTY(dFecNacTes);
					 WHEN {||HelpRead('FECHA MM/DD/AAAA')}


		   @nNroFil,nNroCol+53 SAY 'SEXO:';
					 GET cSexFem;
					 VALID lValSexo(ROW(),COL()-1,;
					       @cSexFem,@lSexFemTes)

		   @nNroFil++,nNroCol+62 SAY 'ESTRATO:';
					 GET nEstratTes PICT "99"

		   @nNroFil  ,nNroCol+00 SAY 'DOCUMENTO:';
					 GET cDocNitTes PICT "@!";
					 VALID !EMPTY(cDocNitTes)

		   @nNroFil  ,nNroCol+28 SAY 'TIPO:';
					 GET cTipNitTes PICT "@!";
					 VALID lValTipNit(ROW(),COL()-1,;
							  @cTipNitTes)

		   @nNroFil++,nNroCol+40 SAY 'DE:';
					 GET cLugNitTes PICT "@!" ;
					 VALID !EMPTY(cLugNitTes)


		   @nNroFil,nNroCol+00 SAY 'DIRECCION:';
					 GET cDireccTes PICT "@!S40";
					 VALID !EMPTY(cDireccTes)

		   @nNroFil++  ,nNroCol+53 SAY 'BARRIO:';
					   GET cBarrioTes PICT "@!";
					   VALID !EMPTY(cBarrioTes)

		   @nNroFil,nNroCol+00   SAY 'CIUDAD   :';
					 GET cCiudadTes PICT "@!S30";
					 VALID !EMPTY(cCiudadTes)

		   @nNroFil++,nNroCol+43 SAY 'TELEFONO:';
					 GET cTelefnTes PICT "@!"

		   @nNroFil,nNroCol+00 SAY 'E-MAIL   :';
					 GET cMaiEstTes PICT "@!"

		   @nNroFil++,nNroCol+53 SAY 'CELULAR :';
					 GET cTelCelTes PICT "@!"

		   @nNroFil  ,nNroCol+00 SAY 'EPS :';
					 GET cNomEpsTes PICT "@!"

		   @nNroFil++,nNroCol+53 SAY 'GRUPO RH :';
					 GET cGrupRhTes PICT "@X"

		   IF .T.
		      @nNroFil++,nNroCol+00 SAY 'VIVE CON :';
					    GET cViveCoTes PICT "@!"

		      @nNroFil  ,nNroCol+00 SAY 'No.HERMANOS :';
					    GET nNroHerTes PICT "99"
		      @nNroFil++,nNroCol+17 SAY 'CURSOS :';
					    GET cHerGruTes PICT "@X"

		      @nNroFil++,nNroCol+00 SAY 'LOCALIDAD:';
					    GET cLocaliTes PICT "@!"

		      @nNroFil++,nNroCol+00 SAY 'ZONA:';
					    GET cZonaDiTes PICT "@!"
		   ENDIF
*----------------FIN INFORMACION PERSONAL

	    CASE nNroOpc == 2

*----------------ACTUALIZACION DE LOS DATOS DEL PADRE
		   nNroFil := nFilInf+3

		   @++nNroFil,nNroCol+00 SAY 'APELLIDOS PADRE:';
					 GET cApePadTes PICT "@!S20"

		   @nNroFil++,nNroCol+38 SAY 'NOMBRES PADRE:';
					 GET cNomPadTes PICT "@!S25"

		   @nNroFil,nNroCol+00 SAY 'DOCUMENTO:';
					 GET cPadNitTes PICT "@!"

		   @nNroFil,nNroCol+28 SAY 'TIPO:';
				       GET cPadTntTes PICT "@!";
				       VALID EMPTY(cPadTntTes) .OR.;
					     lValTipNit(ROW(),COL()-1,;
							@cPadTntTes)


		   @nNroFil,nNroCol+38 SAY 'DE:';
					 GET cPadLugTes PICT "@!S16";

		   @nNroFil++,nNroCol+59 SAY 'TEL:';
					 GET cTelPadTes PICT "@!9"

		   @nNroFil  ,nNroCol+00 SAY 'EMPRESA:';
					 GET cEmpPadTes PICT "@!"

		   @nNroFil++,nNroCol+38 SAY 'CARGO:';
					 GET cCarPadTes PICT "@!"

		   @nNroFil,nNroCol+00 SAY 'DIRECCION:';
					 GET cDirPadTes PICT "@!S45"

		   @nNroFil++  ,nNroCol+52 SAY 'BARRIO:';
					   GET cBarPadTes PICT "@!"

		   @nNroFil,nNroCol+00 SAY 'CIUDAD:';
				       GET cCiuPadTes PICT "@!S29"

		   @nNroFil++,nNroCol+38 SAY 'PROFESION:';
					 GET cProPadTes PICT "@!"

		   @nNroFil  ,nNroCol+00 SAY 'E-MAIL   :';
					 GET cMaiPadTes PICT "@!"

		   @nNroFil++,nNroCol+52 SAY 'FAX      :';
					 GET cFaxPadTes PICT "@!"

		   @nNroFil,nNroCol+00   SAY 'CELULAR  :';
					 GET cCelPadTes PICT "@!"

		   @nNroFil,nNroCol+26 SAY 'BIPER    :';
					 GET cBipPadTes PICT "@!"

		  @ nNroFil++,nNroCol+52 SAY 'FALLECIDO:';
					 GET cPadQepTes PICT '@!';
					 VALID lValSiNo(ROW(),COL()-1,;
					       @cPadQepTes,@lPadQepTes)
*----------------FIN ACTUALIZACION DE LOS DATOS DEL PADRE

	    CASE nNroOpc == 3

*----------------ACTUALIZACION DE LOS DATOS DE LA MADRE
		   nNroFil := nFilInf+3

		   @++nNroFil,nNroCol+00 SAY 'APELLIDOS MADRE:';
					 GET cApeMadTes PICT "@!S20"

		   @nNroFil++,nNroCol+38 SAY 'NOMBRES MADRE:';
					 GET cNomMadTes PICT "@!S25"

		   @nNroFil,nNroCol+00 SAY 'DOCUMENTO:';
					 GET cMadNitTes PICT "@!"

		   @nNroFil  ,nNroCol+28 SAY 'TIPO:';
					 GET cMadTntTes PICT "@!";
					 VALID EMPTY(cMadTntTes) .OR.;
					 lValTipNit(ROW(),COL()-1,;
						    @cMadTntTes)

		   @nNroFil,nNroCol+38 SAY 'DE:';
					 GET cMadLugTes PICT "@!S16"

		   @nNroFil++,nNroCol+59 SAY 'TEL:';
					 GET cTelMadTes PICT "@!9"

		   @nNroFil  ,nNroCol+00 SAY 'EMPRESA:';
					 GET cEmpMadTes PICT "@!"

		   @nNroFil++,nNroCol+38  SAY 'CARGO:';
					 GET cCarMadTes PICT "@!"

		   @nNroFil,nNroCol+00 SAY 'DIRECCION:';
					 GET cDirMadTes PICT "@!S45"

		   @nNroFil++,nNroCol+52 SAY 'BARRIO:';
					   GET cBarMadTes PICT "@!"

		   @nNroFil,nNroCol+00 SAY 'CIUDAD:';
					 GET cCiuMadTes PICT "@!S29"

		   @nNroFil++,nNroCol+38 SAY 'PROFESION:';
					 GET cProMadTes PICT "@!"

		   @nNroFil,  nNroCol+00 SAY 'E-MAIL   :';
					 GET cMaiMadTes PICT "@!"

		   @nNroFil++,nNroCol+52 SAY 'FAX      :';
					 GET cFaxMadTes PICT "@!"

		   @nNroFil,nNroCol+00   SAY 'CELULAR  :';
					 GET cCelMadTes PICT "@!"

		   @nNroFil,nNroCol+26   SAY 'BIPER    :';
					 GET cBipMadTes PICT "@!"

		  @ nNroFil++,nNroCol+52 SAY 'FALLECIDA:';
					 GET cMadQepTes PICT '@!';
					 VALID lValSiNo(ROW(),COL()-1,;
					       @cMadQepTes,@lMadQepTes)
*----------------FIN ACTUALIZACION DE LOS DATOS DE LA MADRE

	    CASE nNroOpc == 4

*----------------LECTURA DEL PARENTESCO DEL ACUDIENTE
		   nNroFil := nFilInf+3
		   IF EMPTY(cParAcuTes)
		      nTipAcu := nLeeOpcion('ACUDIENTE: '+;
				'1<PADRE> 2<MADRE> 3<OTRO>?',3,'0')
		   ELSE
		      @++nNroFil,nNroCol+00 SAY 'PARENTESCO DEL ACUDIENTE:';
					      GET cParAcuTes PICT "@!";
					      VALID !EMPTY(cParAcuTes)
		      READ
		   ENDIF

		   IF !EMPTY(cParAcuTes)
		      DO CASE
		      CASE 'PADRE' $ UPPER(cParAcuTes)
			   nTipAcu := 1

		      CASE 'MADRE' $ UPPER(cParAcuTes)
			   nTipAcu := 2

		      OTHERWISE
			   nTipAcu := 3
		      ENDCASE
		   ENDIF

		   DO CASE
		   CASE nTipAcu == 1
			cParAcuTes := 'PADRE'
			cApeAcuTes := cApePadTes
			cNomAcuTes := cNomPadTes
			cAcuNitTes := cPadNitTes
			cAcuLugTes := cPadLugTes
			cAcuTntTes := cPadTntTes
			cDirAcuTes := cDirPadTes
			cBarAcuTes := cBarPadTes
			cCiuAcuTes := cCiuPadTes
			cProAcuTes := cProPadTes
			cEmpAcuTes := cEmpPadTes
			cCarAcuTes := cCarPadTes
			cTe1AcuTes := cTelPadTes
			cCelAcuTes := cCelPadTes
			cFaxAcuTes := cFaxPadTes
			cBipAcuTes := cBipPadTes
			cMaiAcuTes := cMaiPadTes
		      *ÀInformaci¢n del Padre

		   CASE nTipAcu == 2
			cParAcuTes := 'MADRE'
			cApeAcuTes := cApeMadTes
			cNomAcuTes := cNomMadTes
			cAcuNitTes := cMadNitTes
			cAcuLugTes := cMadLugTes
			cAcuTntTes := cMadTntTes
			cDirAcuTes := cDirMadTes
			cBarAcuTes := cBarMadTes
			cCiuAcuTes := cCiuMadTes
			cProAcuTes := cProMadTes
			cEmpAcuTes := cEmpMadTes
			cCarAcuTes := cCarMadTes
			cTe1AcuTes := cTelMadTes
			cCelAcuTes := cCelMadTes
			cFaxAcuTes := cFaxMadTes
			cBipAcuTes := cBipMadTes
			cMaiAcuTes := cMaiMadTes
		      *ÀInformaci¢n de la Madre
		   ENDCASE
*----------------FIN LECTURA DEL PARENTESCO DEL ACUDIENTE

*----------------ACTUALIZACION DE LOS DATOS DEL ACUDIENTE
		   IF nTipAcu == 3
		      nNroFil += 2
		      @nNroFil,nNroCol+00 SAY 'APELLIDOS ACUDIENTE:';
					  GET cApeAcuTes PICT "@!S16";
					  VALID !EMPTY(cApeAcuTes)

		      @nNroFil++,nNroCol+38 SAY 'NOMBRES ACUDIENTE:';
					    GET cNomAcuTes PICT "@!S21";
					    VALID !EMPTY(cNomAcuTes)

		      @nNroFil,nNroCol+00 SAY 'DOCUMENTO:';
					    GET cAcuNitTes PICT "@!S11";
					    VALID !EMPTY(cAcuNitTes)

		      @nNroFil,nNroCol+23 SAY 'TIPO:';
					  GET cAcuTntTes PICT "@!";
					  VALID lValTipNit(ROW(),COL()-1,;
							   @cAcuTntTes)

		      @nNroFil,nNroCol+33 SAY 'DE:';
					  GET cAcuLugTes PICT "@!S12";
					  VALID !EMPTY(cAcuLugTes)

		      @nNroFil++,nNroCol+59 SAY 'TEL:';
					    GET cTe1AcuTes PICT "@!9"

		      @nNroFil  ,nNroCol+00 SAY 'EMPRESA:';
					    GET cEmpAcuTes PICT "@!"

		      @nNroFil++,nNroCol+38  SAY 'CARGO:';
					    GET cCarAcuTes PICT "@!"

		      @nNroFil,nNroCol+00 SAY 'DIRECCION:';
					    GET cDirAcuTes PICT "@!S45"

		      @nNroFil++  ,nNroCol+52 SAY 'BARRIO:';
					      GET cBarAcuTes PICT "@!"

		      @nNroFil,nNroCol+00 SAY 'CIUDAD:';
					    GET cCiuAcuTes PICT "@!S29"

		      @nNroFil++,nNroCol+38 SAY 'PROFESION:';
					    GET cProAcuTes PICT "@!"

		      @nNroFil,nNroCol+00 SAY 'E-MAIL   :';
					    GET cMaiAcuTes PICT "@!"

		      @nNroFil++,nNroCol+52 SAY 'FAX      :';
					    GET cFaxAcuTes PICT "@!"

		      @nNroFil,nNroCol+00   SAY 'CELULAR  :';
					    GET cCelAcuTes PICT "@!"

		      @nNroFil++,nNroCol+38 SAY 'BIPER    :';
					    GET cBipAcuTes PICT "@!"
		   ENDIF
*----------------FIN ACTUALIZACION DE LOS DATOS DEL ACUDIENTE

	    ENDCASE
	    READ
**********FIN ACTUALIZACION DE LA INFORMACION DEL ESTUDIANTE

**********PREGUNTA DE DECISION
	    DO CASE
	    CASE LASTKEY() # K_ESC
		 IF !lPregunta('DESEA GRABAR? Si No')
		    lGrabar := .F.
		    LOOP
		 ELSE
		    lGrabar := .T.
		 ENDIF

	    CASE LASTKEY() == K_ESC
		 lGrabar := .F.
		 IF !lPregunta('DESEA ABANDONAR? Si No')
		    LOOP
		 ENDIF
	    ENDCASE
**********FIN PREGUNTA DE DECISION

**********GRABACION DE LOS DATOS DEL CANDIDATO
	    IF lGrabar
	       IF ADM->(lRegLock(lShared,.F.))
		  DO CASE
		  CASE nNroOpc == 1

*----------------------GRABACION DE LA INFORMACION PERSONAL
			 REPL ADM->cLugNacEst WITH cLugNacTes
			 REPL ADM->dFecNacEst WITH dFecNacTes
			 REPL ADM->cDocNitEst WITH cDocNitTes
			 REPL ADM->cLugNitEst WITH cLugNitTes
			 REPL ADM->cTipNitEst WITH cTipNitTes
			 REPL ADM->lSexFemEst WITH lSexFemTes
			 REPL ADM->nEstratEst WITH nEstratTes
			 REPL ADM->cDireccEst WITH cDireccTes
			 REPL ADM->cBarrioEst WITH cBarrioTes
			 REPL ADM->cCiudadEst WITH cCiudadTes
			 REPL ADM->cTelefnEst WITH cTelefnTes
			 REPL ADM->cTelCelEst WITH cTelCelTes
			 REPL ADM->cMaiEstEst WITH cMaiEstTes
			 REPL ADM->cNomEpsEst WITH cNomEpsTes
			 REPL ADM->cGrupRhEst WITH cGrupRhTes

			 REPL ADM->cViveCoEst WITH cViveCoTes
			 REPL ADM->nNroHerEst WITH nNroHerTes
			 REPL ADM->cHerGruEst WITH cHerGruTes
			 REPL ADM->cLocaliEst WITH cLocaliTes
			 REPL ADM->cZonaDiEst WITH cZonaDiTes
*----------------------FIN GRABACION DE LA INFORMACION PERSONAL

		  CASE nNroOpc == 2

*----------------------GRABACION DE LA INFORMACION DEL PADRE
			 REPL ADM->cApePadEst WITH cApePadTes
			 REPL ADM->cNomPadEst WITH cNomPadTes
			 REPL ADM->lPadQepEst WITH lPadQepTes
			 REPL ADM->cPadNitEst WITH cPadNitTes
			 REPL ADM->cPadLugEst WITH cPadLugTes
			 REPL ADM->cPadTntEst WITH cPadTntTes
			 REPL ADM->cDirPadEst WITH cDirPadTes
			 REPL ADM->cBarPadEst WITH cBarPadTes
			 REPL ADM->cCiuPadEst WITH cCiuPadTes
			 REPL ADM->cProPadEst WITH cProPadTes
			 REPL ADM->cEmpPadEst WITH cEmpPadTes
			 REPL ADM->cCarPadEst WITH cCarPadTes
			 REPL ADM->cTelPadEst WITH cTelPadTes
			 REPL ADM->cCelPadEst WITH cCelPadTes
			 REPL ADM->cFaxPadEst WITH cFaxPadTes
			 REPL ADM->cBipPadEst WITH cBipPadTes
			 REPL ADM->cMaiPadEst WITH cMaiPadTes
		       *ÀGrabaci¢n de la Informaci¢n del Padre
*----------------------GRABACION DE LA INFORMACION DEL PADRE

		  CASE nNroOpc == 3

*----------------------GRABACION DE LA INFORMACION DE LA MADRE
			 REPL ADM->cApeMadEst WITH cApeMadTes
			 REPL ADM->cNomMadEst WITH cNomMadTes
			 REPL ADM->lMadQepEst WITH lMadQepTes
			 REPL ADM->cMadNitEst WITH cMadNitTes
			 REPL ADM->cMadLugEst WITH cMadLugTes
			 REPL ADM->cMadTntEst WITH cMadTntTes
			 REPL ADM->cDirMadEst WITH cDirMadTes
			 REPL ADM->cBarMadEst WITH cBarMadTes
			 REPL ADM->cCiuMadEst WITH cCiuMadTes
			 REPL ADM->cProMadEst WITH cProMadTes
			 REPL ADM->cEmpMadEst WITH cEmpMadTes
			 REPL ADM->cCarMadEst WITH cCarMadTes
			 REPL ADM->cTelMadEst WITH cTelMadTes
			 REPL ADM->cCelMadEst WITH cCelMadTes
			 REPL ADM->cFaxMadEst WITH cFaxMadTes
			 REPL ADM->cBipMadEst WITH cBipMadTes
			 REPL ADM->cMaiMadEst WITH cMaiMadTes
		       *ÀGrabaci¢n de la Informaci¢n de la Madre
*----------------------FIN GRABACION DE LA INFORMACION DE LA MADRE

		  CASE nNroOpc == 4

*----------------------GRABACION DE LA INFORMACION DEL ACUDIENTE
			 REPL ADM->cParAcuEst WITH cParAcuTes
			 REPL ADM->cApeAcuEst WITH cApeAcuTes
			 REPL ADM->cNomAcuEst WITH cNomAcuTes
			 REPL ADM->cAcuNitEst WITH cAcuNitTes
			 REPL ADM->cAcuLugEst WITH cAcuLugTes
			 REPL ADM->cAcuTntEst WITH cAcuTntTes
			 REPL ADM->cDirAcuEst WITH cDirAcuTes
			 REPL ADM->cBarAcuEst WITH cBarAcuTes
			 REPL ADM->cCiuAcuEst WITH cCiuAcuTes
			 REPL ADM->cProAcuEst WITH cProAcuTes
			 REPL ADM->cEmpAcuEst WITH cEmpAcuTes
			 REPL ADM->cCarAcuEst WITH cCarAcuTes
			 REPL ADM->cTe1AcuEst WITH cTe1AcuTes
			 REPL ADM->cTe2AcuEst WITH cTe2AcuTes
			 REPL ADM->cCelAcuEst WITH cCelAcuTes
			 REPL ADM->cFaxAcuEst WITH cFaxAcuTes
			 REPL ADM->cBipAcuEst WITH cBipAcuTes
			 REPL ADM->cMaiAcuEst WITH cMaiAcuTes
		       *ÀGrabaci¢n de la Informaci¢n del Acudiente
*----------------------FIN GRABACION DE LA INFORMACION DEL ACUDIENTE

		  ENDCASE
	       ELSE
		   cError('NO SE GRABA EL REGISTRO')
	       ENDIF

	       DBCOMMIT()
	       IF lShared
		  DBUNLOCK()
	       ENDIF

	    ENDIF
	    EXIT
**********FIN GRABACION DE LOS DATOS DEL CANDIDATO

       ENDDO
*>>>>FIN LECTURA Y GRABACION DE LA HOJA DE VIDA

*>>>>GRABACION DE LA PROCEDENCIA DEL ESTUDIANTE
       IF lPregunta('DESEA GRABAR LOS COLEGIOS DE '+;
		    'PROCEDENCIA DEL ESTUDIANTE? No Si')
	  lProceEst(lShared,nFilInf,nColInf,cNroIns,cNombre,cCodGru,'ADM')
       END
*>>>>FIN GRABACION DE LA PROCEDENCIA DEL ESTUDIANTE

*>>>>ANALISIS DE DECISION
       IF !EMPTY(oBrowse)
	  SET CURSOR OFF
	  RESTSCREEN(0,0,24,79,cSavPan)
	  nNroReg := RECNO()
	  GO TOP
	  oBrowse:GOTOP()
	  GO nNroReg
	  oBrowse:FORCESTABLE()
       ENDIF
       SET ESCAPE OFF
       RETURN lGrabar
*>>>>FIN ANALISIS DE DECISION