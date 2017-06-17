/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : CERTIFICADOS
SUBMODULO...: FORMATOS                                 MODULO No. 603

**************************************************************************
* TITULO..: MENU DE FORMATOS DE CERTIFICADOS                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 12/99 MAR A
       Colombia, Bucaramanga        INICIO: 04:40 PM   OCT 12/99 MAR


OBJETIVOS:

1- Visualiza el menu de los diferentes formatos de Certificados

2- Ejecuta las diferentes funciones.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_603(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lAnoAct := .T.                 // A¤o Actual

       LOCAL nLenOpc := 0                   // Longitud de las opciones
       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL cTxtHlp := ''                  // Texto de Ayuda
       LOCAL cTitHlp := ''                  // T¡tulo para la Ayuda

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
       IF  !lParam0102(aParams,;
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

*>>>>SELECCION DEL NIVEL
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       nParameSet(aParam1,'cMaeAct',cMaeAct)
*>>>>FIN SELECCION DEL NIVEL

*>>>>DECLARCION Y EJECUCION DEL MENU
       cSavPan := SAVESCREEN(0,0,24,79)
       aMenus := {'1<FORMATO CERTIFICADO>'}

       aAyuda := {'Permite Editar el formato para los Certificados',;
		  'Permite Editar el formato para las Constancias'}
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>ACTIVACION DE LA AYUDA PARA LA EDICION
       cTxtHlp := 'Inserte el texto: <NROCER> => '+;
		    'para incluir la N£mero del Certificado'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: <REGSE> => '+;
		    'para incluir el Registro de la Secretaria'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: <DANE> => '+;
		    'para incluir el Registro del DANE'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: <JORNADA> => '+;
		    'para incluir la Jornada de Estudio'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: <CODIGO> => '+;
		    'para incluir el C¢digo del Estudiante'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: <DPTO> => '+;
		    'para incluir el nombre del Departamento'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: <COLEGIO> => '+;
		    'para incluir el Nombre del Colegio'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: <APROBO>,<A¥O>,<GRADO><NIVEDU> => '+;
		    'para incluir los textos respectivos.'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: <NOTAS> o <NOTAS1> => '+;
		    'para incluir Nostas del Estudiante'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: <JI>  => '+;
		    'para justificar el texto a la izquierda'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: <JD>  => '+;
		    'para justificar el texto a la derecha'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: <JC>  => '+;
		    'para centrar '+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: <JF>  => '+;
		    'para selecionar justificaci¢n completa'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: <T1>  => '+;
		    'Tama¤o de letra No. 1 : PICA(10cpi)'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: <T2>  => '+;
		    'Tama¤o de letra No. 2 : ELITE(12cpi)'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: <C1>  => '+;
		    'Activar imprisi¢n Condensado'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: <C0>  => '+;
		    'Desactivar impresi¢n Condensado'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: <TC>  => '+;
		    'para imprimir en tama¤o Carta'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: <TO>  => '+;
		    'para imprimir en tama¤o Oficio'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: <G1>  => '+;
		    'para imprimir el Texto en tama¤o Grande'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		  'Inserte el texto: <G0>  => '+;
		    'para terminar la impresi¢n del Texto en tama¤o Grande'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)
       cTitHlp := 'TEXTOS PARA LA SUSTITUCION'
*>>>>FIN ACTIVACION DE LA AYUDA PARA LA EDICION

*>>>>VALIDACION DEL LIMITE DE LA ULTIMA COLUMNA
       nLenOpc := LEN(aMenus[1])
      *Calculo de la Longitud mayor

       IF nColInf + nLenOpc + 2 > 78
	  nColInf := 78-nLenOpc-3
       ENDIF
*>>>>FIN VALIDACION DEL LIMITE DE LA ULTIMA COLUMNA

*>>>>ANALISIS DE OPCION ESCOGIDA
       nNroOpc := 1
       DO WHILE nNroOpc # 0

	  nNroOpc := nMenu(aMenus,aAyuda,nFilInf+1,nColInf,NIL,NIL,nNroOpc)

	  DO CASE
	  CASE nNroOpc == 0
	       EXIT

	  CASE nNroOpc == 1

	       EditFile(cNomSis,"Bases\Certi"+cMaeAct+'.TXT',;
				 "Edite el Texto para los Certificados",;
				 cTxtHlp,cTitHlp)

	  ENDCASE

       ENDDO
       CLOSE ALL
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA