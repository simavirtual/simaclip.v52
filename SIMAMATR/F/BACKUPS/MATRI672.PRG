/* SIMA - MATRICULA ACADEMICA

MODULO      : MATRICULAS
SUBMODULO...: RETIROS                MODULO No. 607

**************************************************************************
* NOMBRE DEL PROGRAMA..: MATRI607.PRG                                    *
* TITULO DEL PROGRAMA..: RETIRO DE ESTUDIANTES                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 02/96 JUE A
       Colombia, Bucaramanga        INICIO: 12:25 PM   MAY 02/96 JUE

REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Permite retirar o activar a estudiantes

2- Retorna Nil

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_672(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-MATR.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lAnoAct := .T.                 // A¤o Actual

       LOCAL cSavLin := ''                  // Salvar linea
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal

       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTes := ''               // C¢digo del estudiante
       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL lRetiroTes := .F.              // .T. Estudiante Retirado
       LOCAL dFecRetTes := CTOD('00/00/00') // Fecha de Retiro
       LOCAL cObsRetTes := ''               // Observaci¢n del Retiro
       LOCAL nUltRecTes := 0                // Ultimo mes del Recibo
       LOCAL nPerRetTes := 0                // Ultimo Perido del Periodo
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

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMaeMtr(lShared,PathUno+'\'+cPatSis,cMaeAlu,cAnoSis)
	  cError('ABRIENDO ARCHIVOS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,'POR FAVOR DIGITE EL CODIGO DE LOS '+;
				 ' ESTUDIANTES A RETIRAR O ACTIVAR',22,'°')
       aTamCol := {06,06,20,08,10,18}
       aTitulo := {'CODIGO','CURSO ','NOMBRE','RETIRADO','FECHA ','MOTIVO'}
       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>GRABACION DE LOS BECADOS
       nNroFil++
       DO WHILE .T.

**********LECTURA DEL CODIGO DEL ESTUDIANTE
	    cSavLin := SAVESCREEN(nNroFil,00,nNroFil,79)
	    cCodigoTes := cLeeCodEst(nNroFil,aNroCol[1],cMaeAlu,@cMaeAct)
	    IF EMPTY(cCodigoTes) .OR. EMPTY(cMaeAct)
	       EXIT
	    ENDIF
	    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			  RTRIM(&cMaeAct->cNombreEst)
	    cNombreTes := SUBS(cNombreTes+SPACE(20),1,20)
	    @ nNroFil,aNroCol[2] SAY &cMaeAct->cCodigoGru
	    @ nNroFil,aNroCol[3] SAY cNombreTes
**********FIN LECTURA DEL CODIGO DEL ESTUDIANTE

*********PREGUNTA DE DECISION
	    cSavLin := SAVESCREEN(nNroFil,aNroCol[4],nNroFil,79)
	    lRetiroTes := &cMaeAct->lRetiroEst
	    @ nNroFil,aNroCol[4]+6 SAY IF(lRetiroTes,'SI','NO')
	    @ nNroFil,aNroCol[5]   SAY IF(lRetiroTes,&cMaeAct->dFecRetEst,'')

	    lRetiroTes := .F.
	    IF lPregunta('Si No',nNroFil,aNroCol[4])
	       lRetiroTes := .T.
	    ENDIF
	    RESTSCREEN(nNroFil,aNroCol[4],nNroFil,79,cSavLin)
	    @ nNroFil,aNroCol[4] SAY IF(lRetiroTes,'SI','NO')
*********FIN PREGUNTA DE DECISION

*********LECTURA DE LA FECHA DEL RETIRO
	   dFecRetTes := CTOD('00/00/00')
	   cObsRetTes := ''
	   nUltRecTes := &cMaeAct->nUltRecEst
	   nPerRetTes := &cMaeAct->nPerRetEst

	   IF lRetiroTes
	      IF EMPTY(&cMaeAct->dFecRetEst)
		 dFecRetTes := DATE()
	      ELSE
		 dFecRetTes := &cMaeAct->dFecRetEst
	      ENDIF
	      cObsRetTes := &cMaeAct->cObsRetEst
	      nUltRecTes := &cMaeAct->nUltRecEst
	      nPerRetTes := &cMaeAct->nPerRetEst

	      @ nNroFil,aNroCol[5] GET dFecRetTes PICT "@D";
				   VALID {||HelpRead()};
				   WHEN  {||HelpRead('FECHA')}

	      @ nNroFil++,aNroCol[6] GET cObsRetTes PICT "@!S23";
				   VALID !EMPTY(cObsRetTes) .AND.;
					   HelpRead();
				   WHEN  {||HelpRead('POR FAVOR INGRESE EL '+;
						     'MOTIVO DEL RETIRO')}

	      @ nNroFil,aNroCol[3] SAY 'ULTIMO MES DEL RECIBO';
				   GET nUltRecTes PICT "99";
				   VALID lnValMes(ROW(),COL()-2,@nUltRecTes) .AND.;
					 HelpRead();
				   WHEN  {||HelpRead('POR FAVOR INGRESE EL '+;
				      'MES PARA EL ULTIMO RECIBO A FACTURAR')}

	      @ nNroFil,aNroCol[5] SAY 'ULTIMO PERIODO HABILITADO';
				   GET nPerRetTes PICT "9";
				   VALID nPerRetTes <= 5 .AND.;
					 HelpRead();
				   WHEN  {||HelpRead('POR FAVOR INGRESE EL '+;
				      'ULTIMO PERIODO HABILITADO DEL ESTUDIANTE')}
	      READ
	   ENDIF
*********FIN LECTURA DE LA FECHA DEL RETIRO

**********PREGUNTA DE DECISION
	    IF !lPregunta('DESEA CONTINUAR? No Si')
	       cError('NO SE GRABAN LOS DETALLES DEL RETIRO')
	       nNroFil--
	       LOOP
	    ENDIF
**********FIN PREGUNTA DE DECISION

*********GRABACION DEL REGISTRO
	   SELECT &cMaeAct
	   IF lRegLock(lShared,.F.)
	      REPL lRetiroEst WITH lRetiroTes
	      REPL dFecRetEst WITH dFecRetTes
	      REPL cObsRetEst WITH cObsRetTes
	      REPL nUltRecEst WITH IF(lRetiroTes,nUltRecTes,0)
	      REPL nPerRetEst WITH IF(lRetiroTes,nPerRetTes,0)

	      DBCOMMIT()
	   ELSE
	      cError('NO SE GRABA EL REGISTRO')
	   ENDIF
	   IF lShared
	      DBUNLOCK()
	   ENDIF
*********FIN GRABACION DEL REGISTRO

**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    IF nNroFil > 19

*--------------IMPRESION DEL ULTIMO REGISITRO
		 nNroFil := nMarco(nFilPal+1,'POR FAVOR DIGITE EL CODIGO '+;
			    'DE LOS ESTUDIANTES A RETIRAR O ACTIVAR',22,'°')
		 @ nNroFil,nNroCol SAY cMsgTxt

		 nNroFil++
		 SET COLOR TO I
		 @ nNroFil,aNroCol[1] SAY cCodigoTes
		 @ nNroFil,aNroCol[2] SAY &cMaeAct->cCodigoGru
		 @ nNroFil,aNroCol[3] SAY cNombreTes
		 @ nNroFil,aNroCol[4] SAY IF(lRetiroTes,'SI','NO')
		 @ nNroFil,aNroCol[5] SAY dFecRetTes PICT "@D"
		 SET COLOR TO

		 nNroFil++
*--------------FIN IMPRESION DEL ULTIMO REGISITRO

	    ENDIF
**********FIN INCREMENTO DE LAS FILAS


       ENDDO
       CLOSE ALL
       RETURN NIL
*>>>>FIN GRABACION DE LOS BECADOS


