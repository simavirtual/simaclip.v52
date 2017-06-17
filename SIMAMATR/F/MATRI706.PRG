/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : UTILIDADES
SUBMODULO...: ACTUALIZAR                  MODULO No. 606

**************************************************************************
* NOMBRE DEL PROGRAMA..: CARTE606.PRG                                    *
* TITULO DEL PROGRAMA..: MENU DE ACTUALIZAR                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 26/94 LUN A
						       DIC 26/94 LUN
REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Visualiza un men£ de los archivos a realizarle el mantenimiento

2- Ejecuta las diferentes funciones del mantemiento


SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_706(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-MATR.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL nLenOpc := 0                   // Longitud de las opciones
       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroCol := 0                   // N£mero de Columna

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


*>>>>DECLARCION Y EJECUCION DEL MENU
       cSavPan := SAVESCREEN(0,0,24,79)


       AADD(aMenus,'1<CONFIG. GENERAL>')
       AADD(aMenus,'2<CONFIG. A¥O    >')
       AADD(aMenus,'3<CONCEPTOS      >')
       IF 'SIMACONT' $ UPPER(PathCua)
	  AADD(aMenus,'3<ALUMNOS        >')
       ENDIF

       AADD(aAyuda,'Permite Actualizar la Estructura del Archivo '+;
		   'Configuraci¢n General del Sistema')

       AADD(aAyuda,'Permite Actualizar la Estructura del Archivo '+;
		   'Configuraci¢n del A¤o')

       AADD(aAyuda,'Permite Actualizar la Estructura del Archivo Conceptos')
       IF 'SIMACONT' $ UPPER(PathCua)
	   AADD(aAyuda,'Permite Actualizar la Informaci¢n de los Estudiantes')
       ENDIF
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>VALIDACION DEL LIMITE DE LA ULTIMA COLUMNA
       nLenOpc := LEN(aMenus[1])
      *Calculo de la Longitud mayor

       nNroCol := nColInf
       IF nColInf + nLenOpc + 2 > 78
	  nNroCol := 78-nLenOpc-3
       ENDIF
*>>>>FIN VALIDACION DEL LIMITE DE LA ULTIMA COLUMNA

*>>>>ANALISIS DE OPCION ESCOGIDA
       nNroOpc := 1
       DO WHILE nNroOpc # 0

	  nNroOpc := nMenu(aMenus,aAyuda,nFilInf-2,nNroCol,NIL,NIL,nNroOpc,.F.)

	  DO CASE
	  CASE nNroOpc == 0
	       EXIT

	  CASE nNroOpc == 1

***************ACTUALIZACION DEL ARCHIVO CONFIGURACION GENERAL
		 FileTem := SUBS(fSimMtr,1,AT('.',fSimMtr))+'STR'
		 IF !lStrucFile(lShared,;
				PathSis+'\'+fSimMtr,;
				PathSis+'\'+FileTem,;
				{||CreaDbfMtr(lShared,PathSis,FileTem)})
		    cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
		 ENDIF
		 RESTSCREEN(0,0,24,79,cSavPan)
***************FIN ACTUALIZACION DEL ARCHIVO CONFIGURACION GENERAL

	  CASE nNroOpc == 2

***************ACTUALIZACION DEL ARCHIVO CONFIGURACION DEL A¥O
		 FileTem := fMtrAno+cAnoUsr+'.STR'
		 IF !lStrucFile(lShared,;
				cPatSis+'\'+fMtrAno+cAnoUsr+ExtFile,;
				cPatSis+'\'+FileTem,;
				{||CreaDbfAno(lShared,cPatSis,FileTem)})
		    cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
		 ENDIF
		 RESTSCREEN(0,0,24,79,cSavPan)
***************FIN ACTUALIZACION DEL ARCHIVO CONFIGURACION DEL A¥O

	  CASE nNroOpc == 3

***************ACTUALIZACION DEL ARCHIVO CONCEPTOS
		 FileTem := SUBS(FileCon,1,AT('.',FileCon))+'STR'
		 IF !lStrucFile(lShared,;
				cPatSis+'\'+FileCon,;
				cPatSis+'\'+FileTem,;
				{||CreaDbfCon(lShared,cPatSis,FileTem)})
		    cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
		 ENDIF
		 RESTSCREEN(0,0,24,79,cSavPan)
***************FIN ACTUALIZACION DEL ARCHIVO CONCEPTOS


	  CASE nNroOpc == 4

	       Matri_764(aParam1,aParam2,aParam3)
	      *Actualizar estudiantes otros Servicios

	       RESTSCREEN(0,0,24,79,cSavPan)


	  ENDCASE

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA