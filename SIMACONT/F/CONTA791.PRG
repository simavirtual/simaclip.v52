/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : UTILIDADES
SUBMODULO...: SIMAVIRTUAL - DATOS

**************************************************************************
* TITULO..: DATOS                                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 08/2006 MIE A
       Colombia, Bucaramanga        INICIO: 05:15 PM   FEB 08/2006 MIE

OBJETIVOS:

1- Exporta los registros de la base de datos necesarios para publicar los
   boletines a MySql.

2- Return Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_791(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL       i := 0                   // Contador
       LOCAL cTitSup := ''                  // T¡tulo Superior del Browse
       LOCAL aCampos := NIL                 // Definici¢n de Campos
       LOCAL cTitInf := ''                  // T¡tulo Inferior del Browse
       LOCAL oBrowse := NIL                 // Browse de Alumnos

       LOCAL aStrSlq := {}                  // Estructura de Usuarios
       LOCAL aDbfStr := {}                  // Estructura del Archivo
       LOCAL aDelCam := {}                  // Campos a eliminar

       LOCAL aRegTxt := {}                  // Registros de Texto
       LOCAL cRegTxt := {}                  // Registro de Texto
       LOCAL aMaeAct := {}                  // Dbfs de MaeAct

       LOCAL lSiPaso := .F.                 // Control de Flujo
       LOCAL PathSql := 'FILEWWW'           // Path del Sql

       MEMVA xClrSys			    // Color del Sistema
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

*>>>>AREAS DE TRABAJO
       aUseDbf := {}

       AADD(aUseDbf,{.T.,PathSis+'\'+;
			 fSimaCo,'SCO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fTipUsr,'TUS',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,cPatSis,cMaeAlu,cAnoSis,.F.) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO EL ARCHIVO')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>TABLA DE TIPOS DE USUARIOS
       PathSql := cPatSis+'\FILEWWW'

       aDbfStr := {}
       AADD(aDbfStr,{"cCodigoEmp","Character",12,0,cCodEmp})  // C¢digo de la Empresa
       AADD(aDbfStr,{"cCodigoTus","Character",02,0}) // C¢digo del Tipo de Usuario
       AADD(aDbfStr,{"cNombreTus","Character",20,0}) // Nombre del Tipo de Usuario
       AADD(aDbfStr,{'cUrlLnkTus','Character',60,0}) // Url del Link de la p gina
       AADD(aDbfStr,{'cNivBolTus','Character',02,0}) // Nivel de Visualizaci¢n del Boletin. 1=>Todos,2=>Nivel,3=>Grupos,4=>Estudiante
     *ÀCampos

       fSqlIns(PathSql,fTipUsr,fTipUsr,;
	       cCamLecIns(aDbfStr),aDbfStr,'TUS')
     *ÀTabla y datos

       cRegTxt := 'copy '+SUBS(fTipUsr,1,AT('.',fTipUsr)-1)+'.sqr'
*>>>>FIN TABLA DE TIPOS DE USUARIOS

*>>>>TABLA DE EMPRESA
       aDbfStr := {}
       AADD(aDbfStr,{"cCodigoEmp","Character",12,0,cCodEmp}) // C¢digo de la Empresa
       AADD(aDbfStr,{"cNombreEmp","Character",40,0,cNomEmp}) // Nombre de la Empresa
     *ÀCampos

       fSqlIns(PathSql,FileEmp,FileEmp,;
	       cCamLecIns(aDbfStr),aDbfStr,'SCO')
     *ÀTabla y datos

       cRegTxt += '+'+SUBS(FileEmp,1,AT('.',FileEmp)-1)+'.sqr'
*>>>>TABLA DE EMPRESA

*>>>>TABLA DE CONFIGURACION DEL BOLETIN
       aRegTxt := {}
       AADD(aRegTxt,{"INSERT INTO simawww VALUES (1,'"+;
		      cCodEmp+"','boletines','XML','img','fotos','jpg');"})

       FileChr(PathSql+'\simawww.sqr',aRegTxt)
     *ÀDatos

       cRegTxt += '+simawww.sqr'
*>>>>FIN TABLA DE CONFIGURACION DEL BOLETIN

*>>>>REGISTRO DE USUARIOS. PROFESORES
       aDbfStr := {}
       AADD(aDbfStr,{"cCodigoEmp","Character",12,0,cCodEmp})  // C¢digo de la Empresa
       AADD(aDbfStr,{"cCodigoPro","Character",06,0,'X02'}) // C¢digo del profesor
       AADD(aDbfStr,{"cCodigoPro","Character",06,0,'PASSWORD'})       // C¢digo del profesor
       AADD(aDbfStr,{"cCodigoTus","Character",02,0,'02'}) // C¢digo del Tipo de Usuario
     *ÀCampo de Datos

       aDelCam := {}
       AADD(aDelCam,'nIdeCodEmp')
       aStrSlq := aDelCampos(aDelCam,'USR')
     *ÀCampos descartados

       fSqlIns(PathSql,'USRPRO'+cAnoSis+ExtFile,'usuarios',;
	       cCamLecIns(aStrSlq),aDbfStr,'PRO')
     *ÀDatos

       cRegTxt += '+'+'USRPRO'+cAnoSis+'.sqr'
*>>>>FIN REGISTRO DE USUARIOS. PROFESORES

*>>>>TABLA DE PROFESORES
       aDbfStr := {}
       AADD(aDbfStr,{"cCodigoEmp","Character",12,0,cCodEmp})  // C¢digo de la Empresa
       AADD(aDbfStr,{"cCodigoPro","Character", 06,0}) // C¢digo del profesor
       AADD(aDbfStr,{"cNombrePro","Character", 26,0}) // Nombre del profesor
       AADD(aDbfStr,{"cApelliPro","Character", 26,0}) // Apellido del profesor
       AADD(aDbfStr,{"lRetiroPro","Logical"  , 01,0}) // .T. Profesor Retirado
     *ÀCampos

       fSqlIns(PathSql,FilePro+cAnoSis+ExtFile,FilePro,;
	       cCamLecIns(aDbfStr),aDbfStr,'PRO')
     *ÀTabla y Datos

       cRegTxt += '+'+FilePro+cAnoSis+'.sqr'
*>>>>FIN TABLA DE PROFESORES

*>>>>PERFILES DE NIVEL
       aRegTxt := {}
       AADD(aRegTxt,{"INSERT INTO perfil_nivel VALUES (1,'"+;
		      cCodEmp+"','01','Por Estudiantes','swb_dat_niv_01.php');"})

       AADD(aRegTxt,{"INSERT INTO perfil_nivel VALUES (2,'"+;
		      cCodEmp+"','02','Asignacion Academica','swb_dat_niv_02.php');"})

       AADD(aRegTxt,{"INSERT INTO perfil_nivel VALUES (3,'"+;
		      cCodEmp+"','02','Por Nivel','swb_dat_niv_03.php');"})

       AADD(aRegTxt,{"INSERT INTO perfil_nivel VALUES (4,'"+;
		      cCodEmp+"','02','Por Grupo','swb_dat_niv_04.php');"})

       FileChr(PathSql+'\perfiNiv.sqr',aRegTxt)
*>>>>FIN PERFILES DE NIVEL

*>>>>CREACION DEL ARCHIVO BAT
       cRegTxt += '+perfiNiv.sqr sql1.sql'
       aRegTxt := {}
       AADD(aRegTxt,{cRegTxt})

       FileChr(PathSql+'\sql1.bat',aRegTxt)
*>>>>FIN CREACION DEL ARCHIVO BAT

*>>>>RECORRIDO POR MAESTROS HABILITADOS
       cRegTxt := 'copy '

       lSiPaso := .F.
       FOR i := 1 TO LEN(cMaeAlu)/3

**********CIERRE DE ARCHIVOS
	    cMaeAct := SUBS(cMaeAlu,i*3-2,3)
	    CloseDbf('NIV')
	    CloseDbf('GRU')
	    CloseDbf('CAR')
**********FIN CIERRE DE ARCHIVOS

**********AREAS DE TRABAJO
	    aMaeAct := {}
	    AADD(aMaeAct,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			      FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared,nModCry})

	    AADD(aMaeAct,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			      FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared,nModCry})

	    AADD(aMaeAct,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			      FileMat,'MAT',NIL,lShared,nModCry})

	    AADD(aMaeAct,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			      FileCar+cMaeAct+ExtFile,'CAR',NIL,lShared,nModCry})
**********FIN AREAS DE TRABAJO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbfs(aMaeAct)
	       cError('ABRIENDO EL ARCHIVO DE MAEACT')
	       CloseAll(aMaeAct)
	       RETURN NIL
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********REGISTROS DE USUARIOS. ALUMNOS
	    aDbfStr := {}
	    AADD(aDbfStr,{"cCodigoEmp","Character",12,0,cCodEmp})  // C¢digo de la Empresa
	    AADD(aDbfStr,{"cCodigoEst","Character",06,0,'X01'}) // C¢digo del Estudiante
	    AADD(aDbfStr,{"cCodigoEst","Character",06,0,'PASSWORD'}) // C¢digo del Estudiante
	    AADD(aDbfStr,{"cCodigoTus","Character",02,0,'01'}) // C¢digo del Tipo de Usuario
	  *ÀCampos

	    aDelCam := {}
	    AADD(aDelCam,'nIdeCodEmp')
	    aStrSlq := aDelCampos(aDelCam,'USR')
	  *ÀCampos descartados

	    fSqlIns(PathSql,'USR'+cMaeAct+cAnoSis+ExtFile,'usuarios',;
		    cCamLecIns(aStrSlq),aDbfStr,cMaeAct)
	  *ÀDatos

	   cRegTxt += IF(i==1,' ','+')+'USR'+cMaeAct+cAnoSis+'.sqr'
**********FIN REGISTROS DE USUARIOS. ALUMNOS

**********TABLA DE ALUMNOS
	    aDbfStr := {}
	    AADD(aDbfStr,{"cCodigoEmp","Character",12,0,cCodEmp})  // C¢digo de la Empresa
	    AADD(aDbfStr,{"cCodigoEst","Character",06,0}) // C¢digo del Estudiante
	    AADD(aDbfStr,{"cCodigoGru","Character",04,0}) // Codigo del grupo
	    AADD(aDbfStr,{"cApelliEst","Character",30,0}) // Apellido del Estudiante
	    AADD(aDbfStr,{"cNombreEst","Character",30,0}) // Nombre del Estudiante
	    AADD(aDbfStr,{"lRetiroEst","Logical"  ,01,0}) // .T. Retirado
	    AADD(aDbfStr,{"nHayWwwEst","Numeric"  ,01,0,'5'}) // 5 => Periodos para consultar
	  *ÀCampos

	    fSqlIns(PathSql,'MAE'+cMaeAct+cAnoSis+ExtFile,'alumnos',;
		    cCamLecIns(aDbfStr),aDbfStr,cMaeAct)
	  *ÀDatos

*	   cRegTxt += '+'+'MAE'+cMaeAct+cAnoSis+ExtFile+'.sqr'
**********FIN TABLA DE ALUMNOS

**********TABLA DE NIVELES
	    aDbfStr := {}
	    AADD(aDbfStr,{"cCodigoEmp","Character",12,0,cCodEmp})  // C¢digo de la Empresa
	    AADD(aDbfStr,{"cCodigoNiv","Character",02,0}) // C¢digo del nivel
	    AADD(aDbfStr,{"cNombreNiv","Character",12,0}) // Nombre del Nivel
	  *ÀCampos

	    fSqlIns(PathSql,'NIV'+cMaeAct+cAnoSis+ExtFile,'niveles',;
		    cCamLecIns(aDbfStr),aDbfStr,'NIV')
	  *ÀDatos

	   cRegTxt += '+'+'NIV'+cMaeAct+cAnoSis+'.sqr'
**********FIN TABLA DE NIVELES

**********TABLA DE GRUPOS
	    aDbfStr := {}
	    AADD(aDbfStr,{"cCodigoEmp","Character",12,0,cCodEmp})  // C¢digo de la Empresa
	    AADD(aDbfStr,{"cCodigoGru","Character",04,0}) // C¢digo del Grupo
	    AADD(aDbfStr,{"cNombreGru","Character",20,0}) // Nombre del Grupo
	    AADD(aDbfStr,{"cNivEduGru","Character",20,0}) // Nivel de Edudcacion. Preescolar,BP,BS,MV
	    AADD(aDbfStr,{"cCodigoPro","Character",06,0}) // Titular del Grupo No. 1
	    AADD(aDbfStr,{"cCodProPro","Character",06,0}) // Titular del Grupo No. 2
	  *ÀDatos

	    fSqlIns(PathSql,FileGru+cMaeAct+cAnoSis+ExtFile,'grupos',;
		    cCamLecIns(aDbfStr),aDbfStr,'GRU')
	  *ÀDatos

	   cRegTxt += '+'+FileGru+cMaeAct+cAnoSis+'.sqr'
**********FIN TABLA DE GRUPOS

**********TABLA DE MATERIAS
	    aDbfStr := {}
	    AADD(aDbfStr,{"cCodigoEmp","Character",12,0,cCodEmp})  // C¢digo de la Empresa
	    AADD(aDbfStr,{"cCodigoMat","Character",04,0}) // C¢digo de la Materia
	    AADD(aDbfStr,{"cNombreMat","Character",80,0}) // Nombre de la Materia (30)
	    AADD(aDbfStr,{"cTituloMat","Character",08,0}) // Alias de la Materia
	    AADD(aDbfStr,{"cCodigoPro","Character",06,0}) // Codigo del Profesor que dicta la materia para todos los niveles
	    AADD(aDbfStr,{"nMatVarMat","Numeric"  ,01,0}) // 0=> Materia Fija 1=>Materia Variable por Nivel 2=>Materia Variable por Grupo. Ej: Como Ludicas
	    AADD(aDbfStr,{"lMatSelMat","Logical"  ,01,0}) // .T. Materia Selectiva
	    AADD(aDbfStr,{"lPorNivMat","Logical"  ,01,0}) // .T. Materia Selectiva por Nivel
	  *ÀCampos

	    fSqlIns(PathSql,'MAT'+cMaeAct+ExtFile,'materias',;
		    cCamLecIns(aDbfStr),aDbfStr,'MAT')
	  *ÀDatos

	   cRegTxt += '+'+'MAT'+cMaeAct+'.sqr'
**********FIN TABLA DE MATERIAS

**********TABLA DE CARGAS
	    aDbfStr := {}
	    AADD(aDbfStr,{"cCodigoEmp","Character",12,0,cCodEmp})  // C¢digo de la Empresa
	    AADD(aDbfStr,{"cCodigoCar","Character",08,0})  // C¢digo de la Carga. Materia + Grupo
	    AADD(aDbfStr,{"cCodigoPro","Character",06,0})  // C¢digo del profesor
	    AADD(aDbfStr,{"nTipCarCar","Numeric"  ,01,0})  // Tipo de Carga. 0=>Normal 1=>Variable por Grupo 2=>Variable por Nivel 3=>Variable por Niveles
	  *ÀDatos

	    fSqlIns(PathSql,FileCar+cMaeAct+ExtFile,'cargas',;
		    cCamLecIns(aDbfStr),aDbfStr,'CAR')
	  *ÀDatos

	   cRegTxt += '+'+FileCar+cMaeAct+'.sqr'
**********FIN TABLA DE CARGAS

	  lSiPaso := .T.

       ENDFOR
       CloseAll()
*>>>>FIN RECORRIDO POR MAESTROS HABILITADOS

*>>>>CREACION DEL ARCHIVO .BAT
       cRegTxt += ' sql2.sql'
       aRegTxt := {}
       AADD(aRegTxt,{cRegTxt})
       FileChr(PathSql+'\sql2.bat',aRegTxt)
     *ÀArchivo .bat para el sql2

       aRegTxt := {}
       AADD(aRegTxt,{"call sql1.bat"})
       AADD(aRegTxt,{"call sql2.bat"})

       IF 'JAR' $ cMaeAlu
	  AADD(aRegTxt,{"call listajar.bat"})
       ENDIF

       IF 'PRI' $ cMaeAlu
	  AADD(aRegTxt,{"call listapri.bat"})
       ENDIF

       IF 'BTO' $ cMaeAlu
	  AADD(aRegTxt,{"call listabto.bat"})
       ENDIF

       AADD(aRegTxt,{"call allsql.bat"})
     *ÀArchivo .bat que ejecuta todos los .bat

       FileChr(PathSql+'\all.bat',aRegTxt)

       aRegTxt := {}
       AADD(aRegTxt,{'del all.sql'})

       AADD(aRegTxt,{'copy '+;
		     'sql1.sql+'+;
		     'sql2.sql+'+;
		      IF('JAR' $ cMaeAlu,'listajar.sql+','')+;
		      IF('PRI' $ cMaeAlu,'listapri.sql+','')+;
		      IF('BTO' $ cMaeAlu,'listabto.sql','')+;
		      IF('JAR' $ cMaeAlu,'+maejar'+cAnoSis+'.sqr','')+;
		      IF('PRI' $ cMaeAlu,'+maepri'+cAnoSis+'.sqr','')+;
		      IF('BTO' $ cMaeAlu,'+maebto'+cAnoSis+'.sqr','')+;
		      ' all.sql'})
     *ÀArchivo .bat que ejecuta todos los .bat

       FileChr(PathSql+'\allsql.bat',aRegTxt)

       RETURN NIL
*>>>>FIN CREACION DEL ARCHIVO .BAT

/*************************************************************************
* TITULO..: CAMPOS DE LECTURA DEL INSERT                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 29/2005 MAR A
       Colombia, Bucaramanga        INICIO: 11:00 AM   MAR 29/2005 MAR

OBJETIVOS:

1- Crea la cabecera de los campos a leer en una orden insert de SQL

2- Return la cadena con los a leer.


SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cCamLecIns(aStrDbf)

*>>>>DESCRIPCION DE PARAMETROS
/*     aStrDbf			      // Estructura del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cCamIns := ''                  // Campos del Insert
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAMPOS DE LECTURA DEL INSERT
       cCamIns := '('
       FOR i := 1 TO LEN(aStrDbf)
	   IF i < LEN(aStrDbf)
	      cCamIns += aStrDbf[i,1]+','
	   ELSE
	      cCamIns += aStrDbf[i,1]
	   ENDIF
       ENDFOR
       cCamIns += ')'
       RETURN cCamIns
*>>>>FIN CAMPOS DE LECTURA DEL INSERT

/*************************************************************************
* TITULO..: ELIMINAR CAMPOS DE LA ESTRUCTURA                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 07/2005 MIE A
       Colombia, Bucaramanga        INICIO: 03:00 PM   SEP 07/2005 MIE

OBJETIVOS:

1- Elimina campos de la estructura

2- Return la nueva estructura


SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aDelCampos(aDelCam,cNalias)

*>>>>DESCRIPCION DE PARAMETROS
/*     aDelCam			            // Eliminaci¢n de Campos
       cNalias                              // Alias del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL     i,j := 0                   // Contador
       LOCAL aStrNew := {}                  // Nueva Estructura
       LOCAL aDbfStr := {}                  // Estructura del Archivo
       LOCAL lDelCam := .F.                 // .T. Eliminar el Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ELIMINACION DE LOS CAMPOS
       aDbfStr := aStrDbfWww(,cNalias)
       FOR i := 1 TO LEN(aDbfStr)

***********BUSQUEDA DEL CAMPO
	     lDelCam := .F.
	     FOR j := 1 TO LEN(aDelCam)

*================ANALISIS DE DECISION
		   IF aDbfStr[i,1] == aDelCam[j]
		      lDelCam := .T.
		      EXIT
		   ENDIF
*================FIN ANALISIS DE DECISION

	     ENDFOR
***********FIN BUSQUEDA DEL CAMPO

***********DESCARTAR EL CAMPO
	     IF .NOT. lDelCam
		AADD(aStrNew,aDbfStr[i])
	     ENDIF
***********FIN DESCARTAR EL CAMPO

       ENDFOR
       RETURN aStrNew
*>>>>FIN ELIMINACION DE LOS CAMPOS
