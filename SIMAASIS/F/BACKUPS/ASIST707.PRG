/* SIMA - CONTROL DE ASISTENCIA

MODULO      : MODULO PRINCIPAL
SUBMODULO...: UTILIDADES                               MODULO No. 707

**************************************************************************
* TITULO..: MENU DE MATENIMIENTO ARCHIVOS DEL SISTEMA                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 05/2004 MIE A
       Colombia, Bucaramanga        INICIO: 02:00 PM   JUN 05/2004 MIE

OBJETIVOS:

1- Visualiza un men£ de los archivos a realizarle el mantenimiento

2- Ejecuta las diferentes funciones del mantemiento


SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Asist_707(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-ASIS.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de Integraci¢n Uno
       LOCAL PathDos := ''                  // Path de integraci¢n dos
       LOCAL PathTre := ''                  // Path de integraci¢n tres
       LOCAL PathCua := ''                  // Path de integraci¢n cuatro

       LOCAL aArcNtx := {}                  // Archivo de Indices
       LOCAL aArchvo := {}                  // Archivos para Uso
       LOCAL lPrnArc := .F.                 // .T. Imprimir a Archivo
       LOCAL cOpcPrn := ''                  // Opciones de Impresi¢n.
       LOCAL nCodPrn := 0                   // C¢digo de Impresi¢n
       LOCAL lModReg := .F.                 // .T. Modificar el Registro
       LOCAL lDelReg := .F.                 // .T. Borrar Registros
       LOCAL lInsReg := .F.                 // .T. Insertar Registro
       LOCAL lHaySql := .F.                 // .T. Exportar a Sql
       LOCAL nPrueba := .F.                 // Activar Pruebas

       LOCAL nLenOpc := 0                   // Longitud de las opciones
       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL lHayFec := .T.                 // .T. Hay Fecha

       MEMVA xClrSys			    // Color del Sistema
       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // Modo de Protecci¢n
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

       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cJorTxt := ''                  // Jornada escogida */
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := 0                   // Fila Inferior Men£ principal
       LOCAL nFilInf := 0                   // Fila Inferior del SubMen£
       LOCAL nColInf := 0                   // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL PathW01 := ''                  // Sitio del Sistema No.01
     *ÀSitios del Sistema

       LOCAL aParams := {}                  // Parametros Generales
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>LECTURA PARAMETROS GENERALES
       aParams := aParams(aParam1,aParam2,aParam3)
       IF !lParam0108(aParams,;
		      @lShared,@nModCry,@cNomSis,;
		      @cEmpPal,@cNitEmp,@cNomEmp,@cNomSec,@cCodEmp,;
		      @cNomUsr,@cAnoUsr,@cAnoSis,@cPatSis,;
		      @nFilPal,@nFilInf,@nColInf,;
		      @PathW01,;
		      @cMaeAlu,@cMaeAct,@cJorTxt)
	  CloseAll()
	  RETURN NIL
       ENDIF
       CloseAll()
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>LECTURA DE PATHS
       PathAsiAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @PathDos,@PathTre,@PathCua,nModCry,.F.)

       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       nParameSet(aParam1,'cMaeAct',cMaeAct)
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}

       AADD(aUseDbf,{.T.,PathSis+'\'+fSimAsi,'SAS',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       lPrnArc := SAS->lPrnArcAsi
       nCodPrn := SAS->nCodigoPrn
       cOpcPrn := SAS->cOpcPrnAsi
       nPrueba := SAS->nPruebaAsi
       CloseAll(aUseDbf)
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>DECLARCION Y EJECUCION DEL MENU
       aMenus := {}
       AADD(aMenus,'1<HORAS DE CLASE   >')
       AADD(aMenus,'2<TIPO DE NOVEDADES>')
       AADD(aMenus,'3<HORARIO DE CLASE >')
       AADD(aMenus,'4<ASISTENCIA       >')
       AADD(aMenus,'5<TIPO DE PERSONAL >')
       AADD(aMenus,'6<PERSONAL         >')

       aAyuda := {}
       AADD(aAyuda,'Realiza el Mantenimiento del archivo Horas de Clase')
       AADD(aAyuda,'Realiza el Mantenimiento del archivo Tipo de Novedades')
       AADD(aAyuda,'Realiza el Mantenimiento del archivo Horario de Clase')
       AADD(aAyuda,'Realiza el Mantenimiento del archivo Asistencia')
       AADD(aAyuda,'Realiza el Mantenimiento del Tipo de Personal')
       AADD(aAyuda,'Realiza el Mantenimiento del Personal')
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

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

	  nNroOpc := nMenu(aMenus,aAyuda,nFilInf-2,nColInf,NIL,NIL,;
			   nNroOpc,.F.,;
			   IF(!EMPTY(xClrSys),xClrSys[4],''))

	  DO CASE
	  CASE nNroOpc == 0
	       EXIT

	  CASE nNroOpc == 1
	       lModReg := .T.
	       MantenHra(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			 cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
			 cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
			 cJorTxt,lModReg,PathUno)
	      *Mantenimiento del Archivo Horas

	  CASE nNroOpc == 2
	       MantenTau(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			 cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
			 cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
			 cJorTxt,lModReg)
	      *Mantenimiento del Archivo de tipos de Ausencia

	  CASE nNroOpc == 3

***************AREAS DE TRABAJO
		 aArchvo := {}
		 AADD(aArchvo,{PathSis+'\'+FilePrn,NIL,'PRN'})
		 AADD(aArchvo,{PathUno+'\'+cPatSis+'\'+FileHor,NIL,'HOR'})
		 AADD(aArchvo,{PathUno+'\'+cPatSis+'\'+FileHra,NIL,'HRA'})
		 AADD(aArchvo,{PathUno+'\'+cPatSis+'\'+;
			       FilePro+cAnoSis+ExtFile,NIL,'PRO'})
		 AADD(aArchvo,{PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			       FileGru+cMaeAct+cAnoSis+ExtFile,NIL,'GRU'})
		 AADD(aArchvo,{PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			       FileMat,NIL,'MAT'})
		 AADD(aArchvo,{PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			       FileNiv+cAnoSis+ExtFile,NIL,'NIV'})
***************FIN AREAS DE TRABAJO

***************MANTENIMIENTO DEL ARCHIVO
		  lModReg := IF(nPrueba==1,.T.,.F.)
		  lDelReg := .T.
		  lInsReg := .T.
		  lHaySql := .F.

		  MantenHor(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
			    cNomEmp,cNomSec,cNomUsr,cAnoUsr,aArchvo,lPrnArc,;
			    cOpcPrn,nCodPrn,lModReg,lDelReg,lInsReg,lHaySql,;
			    PathUno,cPatSis,cMaeAlu,cMaeAct,nFilInf,nColInf)
***************FIN MANTENIMIENTO DEL ARCHIVO

	  CASE nNroOpc == 4

***************MANTENIMIENTO DEL ARCHIVO
		  lModReg := IF(nPrueba==1,.T.,.F.)
		  lDelReg := .T.
		  lInsReg := .F.
		  lHaySql := .F.
		  MantenCtr(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			    cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
			    cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
			    cJorTxt,!lHayFec,lModReg,lDelReg)
		*ÀMantenimiento del archivo Asistencia
***************FIN MANTENIMIENTO DEL ARCHIVO

	  CASE nNroOpc == 5

***************AREAS DE TRABAJO
		 aArchvo := {}
		 AADD(aArchvo,{PathSis+'\'+FilePrn,NIL,'PRN'})
		 AADD(aArchvo,{PathUno+'\'+cPatSis+'\'+FileTpe,NIL,'TPE'})
***************FIN AREAS DE TRABAJO

***************MANTENIMIENTO DEL ARCHIVO
		  lModReg := .T.
		  lDelReg := .T.
		  lInsReg := .T.
		  lHaySql := .F.

		  MantenTpe(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
			    cNomEmp,cNomSec,cNomUsr,cAnoUsr,aArchvo,lPrnArc,;
			    cOpcPrn,nCodPrn,lModReg,lDelReg,lInsReg,lHaySql,;
			    PathUno,cPatSis,cMaeAlu,cMaeAct,nFilInf,nColInf)
***************FIN MANTENIMIENTO DEL ARCHIVO


	  CASE nNroOpc == 6

***************AREAS DE TRABAJO
		 aArchvo := {}
		 AADD(aArchvo,{PathSis+'\'+FilePrn,NIL,'PRN'})
		 AADD(aArchvo,{PathUno+'\'+cPatSis+'\'+fPerso1,NIL,'PER'})
		 AADD(aArchvo,{PathUno+'\'+cPatSis+'\'+FilePnl,NIL,'PNL'})
		 AADD(aArchvo,{PathUno+'\'+cPatSis+'\'+FileTpe,NIL,'TPE'})
		 AADD(aArchvo,{cPatSis+'\'+FAsiAno+cAnoUsr+ExtFile,;
					   NIL,'ASA'})
		 AADD(aArchvo,{cPatSis+'\'+fAsiNov,NIL,'NOV'})
***************FIN AREAS DE TRABAJO

***************MANTENIMIENTO DEL ARCHIVO
		  lModReg := .T.
		  lDelReg := .T.
		  lInsReg := .T.
		  lHaySql := .F.

		  MantenPnl(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
			    cNomEmp,cNomSec,cNomUsr,cAnoUsr,aArchvo,lPrnArc,;
			    cOpcPrn,nCodPrn,lModReg,lDelReg,lInsReg,lHaySql,;
			    PathUno,cPatSis,cMaeAlu,cMaeAct,nFilInf,nColInf)
***************FIN MANTENIMIENTO DEL ARCHIVO

	  ENDCASE
       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA