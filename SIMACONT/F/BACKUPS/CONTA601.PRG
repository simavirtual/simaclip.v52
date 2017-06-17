/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : CERTIFICADOS
SUBMODULO...: ESTUDIANTES

**************************************************************************
* TITULO..: CERTIFICADOS PARA ESTUDIANTES                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 29/1997 JUE A
       Colombia, Bucaramanga        INICIO: 04:40 PM   JUL 17/1997 JUE

OBJETIVOS:

1- Permite un Browse de los estudiantes para escoger el estudiante
   e imprimir los certificados o constancias.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_601(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1			      // Parametros Generales
       aP2			      // Parametros Generales
       aP3			      // Parametros Generales */
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
       LOCAL cLogEmp := xPrm(aP1,'cLogEmp') // Logo de la Empresa
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
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJornad := xPrm(aP1,'cJornad') // Jornadas habilitadas
       LOCAL cIniJor := xPrm(aP1,'cIniJor') // Iniciales de la jornada
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lAnoAct := .T.                 // A¤o Actual
       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL dFecSys := CTOD('00/00/00')    // Fecha del sistema

       LOCAL cMsgErr := ''                  // Mensaje de Error
       LOCAL cAnoIni := ''                  // A¤o Inicial
       LOCAL cAnoFin := ''                  // A¤o Final
       LOCAL cDocNit := ''                  // Nro de Indentificaci¢n
       LOCAL cLugDoc := ''                  // Lugar del Documento
       LOCAL cObsEst := '.'                 // Observaci¢n para el Estudiante
       LOCAL cUsoCer := '.'                 // Uso del Certificado
       LOCAL nCopias := 0                   // N£meros de copias a imprimir
       LOCAL nNroCop := 1                   // N£mero de copia
       LOCAL aFirmas := {}                  // Firmantes del Certificado
       LOCAL nLenLin := 0                   // Longitud de la l¡nea
       LOCAL nColPrn := 0                   // Columna de Impresi¢n

       LOCAL oBrwCer := NIL                 // Browse de Alumnos
       LOCAL GetList := {}                  // Variable del Sistema
       CloseAll()
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DEL NIVEL
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       nParameSet(aP1,'cMaeAct',cMaeAct)
*>>>>FIN SELECCION DEL NIVEL

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimaCo,'SCO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION GENERAL PARA EL SISTEMA')

       CASE EMPTY(SCO->nAnoIniCon)
	    cError('NO SE HA FIJADO EL A¥O INICIAL EN QUE ESTA '+;
		   'DISPONIBLE LA CONTABILIDAD')

       CASE EMPTY(SCO->nAnoFinCon)
	    cError('NO SE HA FIJADO EL A¥O FINAL EN QUE ESTA '+;
		   'DISPONIBLE LA CONTABILIDAD')

       CASE EMPTY(SCO->nSupCerCon)
	    cError('DEBE ESPECIFICAR EL MARGEN SUPERIOR PARA EL CERTIFICADO')

       CASE EMPTY(SCO->nInfCerCon)
	    cError('DEBE ESPECIFICAR EL MARGEN INFERIOR PARA EL CERTIFICADO')


       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>VALIDACION DE LOS DATOS GENERALES DEL CERTIFICADO
       lHayErr := .T.
       DO CASE
       CASE EMPTY(cNomEmp)
	    cMsgErr := 'FALTA EL NOMBRE DE LA EMPRESA'

       CASE EMPTY(cJorTxt)
	    cMsgErr := 'FALTA EL NOMBRE DE LA JORNADA DE ESTUDIO'

       CASE EMPTY(SCO->cGerentCon)
	    cMsgErr :='FALTA EL NOMBRE DEL RECTOR(A)'

       CASE EMPTY(SCO->cNitGerCon)
	    cMsgErr :='FALTA EL DOCUMENTO DEL RECTOR(A)'

       CASE EMPTY(SCO->cSecretCon)
	    cMsgErr :='FALTA EL NOMBRE DEL SECRETARIO(A)'

       CASE EMPTY(SCO->cNitSecCon)
	    cMsgErr :='FALTA EL DOCUMENTO DEL SECRETARIO(A)'

       OTHERWISE
	    lHayErr := .F.
       ENDCASE

       IF lHayErr
	  cError(cMsgErr)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE LOS DATOS GENERALES DEL CERTIFICADO

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SCO->nPrnCerPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>LECTURA Y VALIDACION DEL A¥O DE CONSULTA
       cSavPan := SAVESCREEN(0,0,24,79)
       @ nFilInf+1,nColInf SAY 'A¥O:' GET cAnoUsr PICT '9999'
       READ
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN LECTURA Y VALIDACION DEL A¥O DE CONSULTA

*>>>>LECTURA DE LA FECHA ACTUAL
       dFecSys := DATE()
       IF !lPregunta(cDia(DOW(DATE()),9)+' '+;
		     cFecha(DATE(),10)+' '+;
		     'ES LA FECHA DEL CERTIFICADO? Si No')

**********LECTURA DE LA FECHA
	    @ nFilInf+1,nColInf SAY "FECHA:" GET dFecSys PICT "@D";
				   VALID dFecSys <> CTOD('00/00/00')
	    READ
**********FIN LECTURA DE LA FECHA

       ENDIF
*>>>>FIN LECTURA DE LA FECHA ACTUAL

*>>>>INICIALIZACION DE VARIABLES
       nLenLin := IF(EMPTY(SCO->nMarDerCon),70,SCO->nMarDerCon)
       nColPrn := SCO->nMarIzqCon

       cAnoIni := STR(SCO->nAnoIniCon,4)
       cAnoFin := STR(SCO->nAnoFinCon,4)

       cIniJor := cJornada(nFilInf+1,nColInf,cJornad,@cJorTxt)
       nParameSet(aP1,'cIniJor',cIniJor)

       cPatSis := cAnoUsr+'.'+cIniJor
       nParameSet(aP1,'cPatSis',cPatSis)

       cAnoSis := SUBS(cAnoUsr,3,2)
       nParameSet(aP1,'cAnoSis',cAnoSis)

       aFirmas := {{ALLTRIM(SCO->cGerentCon),;
		    ALLTRIM(SCO->cNitGerCon),'RECTOR(A)'},;
		   {ALLTRIM(SCO->cSecretCon),;
		    ALLTRIM(SCO->cNitSecCon),'SECRETARIO(A)'}}
*>>>>FIN INICIALIZACION DE VARIABLES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,;
		       cPatSis+'\'+cMaeAct+'\'+;
		       fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared)
	  cError('NO ESTA DISPONIBLE LA INFORMACION DEL A¥O '+cAnoUsr)
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       SELECT &cMaeAct
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTE ESTUDIANTES GRABADOS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTE GRUPOS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>BUSQUEDA DEL ESTUDIANTE
       SELECT &cMaeAct
       cDocNit := &cMaeAct->cDocNitEst
       cLugDoc := &cMaeAct->cLugNitEst

       oBrwCer := oBrwAluCer(lShared,nFilPal+1,00,22,79,cMaeAct,;
			     '<<  ESTUDIANTES DE '+cMaeAct+' A¥O: '+cAnoUsr+;
			     ' .TOTAL ='+STR(RECCOUNT(),4)+'  >>',;
			     '<F5>Buscar '+;
			     '<F8>Contancias <F9>Certificados <ESC>Abandonar')

       SETKEY(K_F5,{||BuscarAlu(lShared,oBrwCer,cMaeAct,cAnoSis,cPatSis)})
*>>>>FIN BUSQUEDA DEL ESTUDIANTE

*>>>>IMPRESION DE CERTIFICADO DE VARIOS A¥OS
       SETKEY(K_F8,{||Constancia(lShared,cNomSis,cNomEmp,cAnoUsr,cMaeAlu,;
				 cMaeAct,cJorTxt,cIniJor,cAnoIni,cAnoFin,;
				 cDocNit,cLugDoc,aFirmas,oBrwCer,nLenLin,;
				 nColPrn)})

       SETKEY(K_F9,{||Certificado(aP1,aP2,aP3,;
				  cAnoIni,cAnoFin,cDocNit,cLugDoc,;
				  aFirmas,oBrwCer,nLenLin,nColPrn,;
				  dFecSys)})

       CtrlBrw(lShared,oBrwCer)

       SETKEY(K_F3,NIL)
       SETKEY(K_F5,NIL)
       SETKEY(K_F6,NIL)
       SETKEY(K_F7,NIL)
       SETKEY(K_F8,NIL)
       SETKEY(K_F9,NIL)

       SET DEVICE TO SCREEN
       CloseAll()
       RETURN NIL
*>>>>FIN IMPRESION DE CERTIFICADO DE VARIOS A¥OS

/*************************************************************************
* TITULO..: CERTIFICADOS DEL ESTUDIANTE                                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 15/99 VIE A
       Colombia, Bucaramanga        INICIO: 11:30 AM   OCT 15/99 VIE

OBJETIVOS:

1- Permite imprimir los certificados por a¤os.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Certificado(aP1,aP2,aP3,;
		     cAnoIni,cAnoFin,cDocNit,cLugDoc,;
		     aFirmas,oBrwCer,nMarDer,nMarIzq,;
		     dFecCer)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1			            // Parametros Generales
       aP2			            // Parametros Generales
       aP3			            // Parametros Generales
       cAnoIni                              // A¤o Inicial Habilitado
       cAnoFin                              // A¤o Final Habilitado
       cDocNit                              // Documento de Identidad
       cLugNit                              // Lugar del Documento
       cUsoCer                              // Uso del Certificado
       aFirmas                              // Firmantes del Certificado
       oBrwCer                              // Browse del certificado
       nMarDer                              // Margen Derecho
       nMarIzq                              // Margen Izquierdo
       dFecCer                              // Fecha del Certificado */
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
       LOCAL cLogEmp := xPrm(aP1,'cLogEmp') // Logo de la Empresa
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
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJornad := xPrm(aP1,'cJornad') // Jornadas habilitadas
       LOCAL cIniJor := xPrm(aP1,'cIniJor') // Iniciales de la jornada
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cSavPan := ''                  // Salvar pantalla
       LOCAL   i,j,k := 0                   // Contadores

       LOCAL cUsoCer := ''                  // Uso del Certificado
       LOCAL nCopias := 1                   // N£meros de copias a imprimir
       LOCAL nNroCop := 1                   // N£mero de copia
       LOCAL nLenLin := nMarDer             // Longitud de la l¡nea
       LOCAL nColPrn := 0                   // Columna de Impresi¢n

       LOCAL cNalias := ''                  // Alias del Maestro
       LOCAL nRegAlu := 0                   // Registro del Alumno
       LOCAL nPosBrw := 0                   // Posici¢n del Browse
       LOCAL nNroFil := 0                   // N£mero de la fila
       LOCAL nNroCol := 0                   // N£mero de la Columna
       LOCAL cAnoCer := ''                  // A¤o del Certificado
       LOCAL aAnoCer := {}                  // A¤os del Certificado
       LOCAL cAnoUno := ''                  // A¤o del Certificado
       LOCAL cAnoDos := ''                  // A¤o del Certificado
       LOCAL cIntAno := ''                  // A¤o del Certificado
       LOCAL nVeces  := 0                   // Veces del A¤o
       LOCAL bNotas  := NIL                 // Code Block de Notas
       LOCAL bNotas1 := NIL                 // Code Block de Notas No. 1
       LOCAL bNotas2 := NIL                 // Code Block de Notas No. 2
       LOCAL aMezcla := {}                  // Mezcla de Texto
       LOCAL lPrnAre := .T.                 // Imprimir el Area
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL nOpcCer := 0                   //  Opci¢n de impresi¢n de los Certificados

       LOCAL cAprobo := ''                  // Aprobo o No Aprobo
       LOCAL cNomNiv := ''                  // Nombre del Nivel
       LOCAL cNivEdu := ''                  // Nivel de Educaci¢n

       LOCAL GetList:= {}                   // Variable del sistema

       STATIC nTipLet := 0                  // Tipo de Letra


       LOCAL lRetiroTes := .F.              // .T. Estudiante Retirado
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cApelliTes := ''               // Apellido del Estudiante
       LOCAL cCodigoTes := ''               // C¢digo del estudiante
       LOCAL cCodigoTgr := ''               // C¢digo del Grupo

       SET CURSOR ON
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE LOS A¥OS PARA LOS CERTIFICADOS
       cSavPan := SAVESCREEN(0,0,24,79)
       cAnoCer := SPACE(70)
       cAnoCer := SPACE(04)
       aAnoCer := {}

/*
       TitBuscar(70,@nNroFil,@nNroCol,'A¥OS:',;
		 'INGRESE LOS A¥OS PARA LOS CERTIFICADOS',13)
*/

       TitBuscar(70,@nNroFil,@nNroCol,'A¥OS:',;
		  'INGRESE EL A¥O DEL CERTIFICADO',13)
       SETCURSOR(1)
       DO WHILE .T.

**********LECTURA DE LOS A¥OS
*	    @ nNroFil,nNroCol GET cAnoCer PICT '@S70!'
	    @ nNroFil,nNroCol GET cAnoCer PICT '9999'
	    READ
	    cAnoCer := ALLTRIM(cAnoCer)+SPACE(01)

	    IF EMPTY(cAnoCer)
	       EXIT
	    ENDIF
**********FIN LECTURA DE LOS A¥OS

**********VALIDACION DEL A¥O
	    IF MOD(LEN(cAnoCer),5) # 0
	       cError('MAL DIGITADO EL FORMATO DE LOS A¥OS')
	       LOOP
	    ENDIF
**********FIN VALIDACION DEL A¥O

**********SEPERACION DE LOS A¥OS
	    i := 1
	    k := 1
	    DO WHILE i <= LEN(cAnoCer)/5

*--------------SEPARACION Y VALIDACION DEL A¥O
		 cAnoUno := SUBS(cAnoCer,i*5-4,4)
		 lHayErr := .T.
		 DO CASE
		 CASE .NOT. ISDIGIT(cAnoUno)
		      cError('EL A¥O '+cAnoUno+' NO ES VALIDO')
		 OTHERWISE
		      lHayErr := .F.
		 ENDCASE
		 IF lHayErr
		    EXIT
		 ENDIF
		 AADD(aAnoCer,k)
		 aAnoCer[k] := VAL(cAnoUno)
*--------------FIN SEPARACION Y VALIDACION DEL A¥O

*--------------SEPARACION DE LOS A¥OS POR INTERVALOS
		 cIntAno := SUBS(cAnoCer,(i*5-4)+4,1)
		 IF cIntAno == '-'
		    i++
		    cAnoDos := SUBS(cAnoCer,i*5-4,4)
		    IF VAL(cAnoDos) >= VAL(cAnoUno)
		       nVeces := VAL(cAnoDos) - VAL(cAnoUno)
		    ELSE
		       aAnoCer[i-1] := VAL(cAnoDos)
		       nVeces := VAL(cAnoUno) - VAL(cAnoDos)
		    ENDIF

		    k := i
		    FOR j := 1 TO nVeces
			AADD(aAnoCer,k)
			aAnoCer[k] := aAnoCer[k-1]+1
			k++
		    ENDFOR
		 ELSE
		    k++
		 ENDIF
*--------------FIN SEPARACION DE LOS A¥OS POR INTERVALOS

		i++

	    ENDDO
	    IF lHayErr
	       LOOP
	    ENDIF
	    EXIT
**********FIN SEPERACION DE LOS A¥OS

       ENDDO
*>>>>FIN LECTURA DE LOS A¥OS PARA LOS CERTIFICADOS

*>>>>VALIDACION DE LOS A¥OS PARA LOS CERTIFICADOS
       IF EMPTY(cAnoCer)
	  RESTSCREEN(0,0,24,79,cSavPan)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE LOS A¥OS PARA LOS CERTIFICADOS

*>>>>LECTURA DEL NUMERO DE COPIA
       @ nNroFil+1,nNroCol SAY 'NRO COPIAS' GET nCopias PICT '99'
       READ
       SETCURSOR(0)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nCopias == 0
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL NUMERO DE COPIA

*>>>>LECTURA DE LA DESTINACION DEL CERTIFICADO
       cSavPan := SAVESCREEN(0,0,24,79)
       cUsoCer := SPACE(70)
       TitBuscar(70,@nNroFil,@nNroCol,'CERTIFICADO PARA:',;
		 'USO DEL CERTIFICADO')

       SETCURSOR(1)
       @ nNroFil,nNroCol GET cUsoCer PICT '@S70!'
       READ
       cUsoCer := ALLTRIM(cUsoCer)
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN LECTURA DE LA DESTINACION DEL CERTIFICADO

*>>>>ANALISIS PARA LA IMPRESION DE LAS AREAS
       lPrnAre := .F.

       nOpcCer := 3
       IF SCO->nOpcCerCon # 0
	  nOpcCer := nLeeOpcion('CERTIFICADO CON: '+;
				'1<AREAS> 2<SOLO ASIGNATURAS> '+;
				'3<AREAS Y ASIGNATURAS>?',3,'0')
       ENDIF
       SETCURSOR(0)
*>>>>FIN ANALISIS PARA LA IMPRESION DE LAS AREAS

*>>>>LECTURA DE LOS ESTADOS INICIALES
       SELECT &cMaeAct

       nPosBrw := oBrwCer:ROWPOS()
       nRegAlu := RECNO()

       lRetiroTes := &cMaeAct->lRetiroEst
       cNombreTes := RTRIM(&cMaeAct->cNombreEst)+' '+;
		     RTRIM(&cMaeAct->cApelliEst)
       cCodigoTes := &cMaeAct->cCodigoEst
       cCodigoTgr := &cMaeAct->cCodigoGru
*>>>>FIN LECTURA DE LOS ESTADOS INICIALES

*>>>>PREGUNTA DE DECISION
       cError(cNombreTes,'CERTIFICADO PARA','A¥OS:'+ALLTRIM(cAnoCer))
       IF !lPregunta('DESEA IMPRIMIR EL CERTIFICADO? Si No')
	  RETURN NIL
       ENDIF
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  RETURN NIL
       ENDIF
       Termometro(0,'IMPRIMIENDO EL CERTIFICADO')
       Termometro(50)
*>>>>FIN PREGUNTA DE DECISION

*>>>>DATOS EXTRAS DEL CERTIFICADO
       cAprobo := ''
       cNomNiv := ''
       cNivEdu := ''

       cAnoSis := SUBS(cAnoUsr,3,2)
       cPatSis := ALLTRIM(cAnoCer)+'.'+cIniJor

       IF !lDatosCert(lShared,cPatSis,cAnoCer,cAnoSis,cMaeAct,;
		      cCodigoTes,cCodigoTgr,@cAprobo,@cNomNiv,@cNivEdu)
	  cAprobo := 'REVISAR'
	  cNomNiv := 'REVISAR'
	  cNivEdu := 'REVISAR'
       ENDIF
*>>>>FIN DATOS EXTRAS DEL CERTIFICADO

*>>>>PARAMETROS ESPECIFICOS
       AADD(aP2,{'cCodEst',cCodigoTes})
       AADD(aP2,{'lRetEst',lRetiroTes})
       AADD(aP2,{'cNomEst',cNombreTes})
       AADD(aP2,{'aAnoCer',aAnoCer})

       AADD(aP2,{'lPrnAre',lPrnAre})
       AADD(aP2,{'nMarIzq',SCO->nNo1IzqCon})
       AADD(aP2,{'nTipCer',1})
       AADD(aP2,{'nOpcCer',nOpcCer})
*>>>>FIN PARAMETROS ESPECIFICOS


*>>>>SUSTITUCION DE CAMPOS
       aMezcla := {}
       bNotas  := {||CertiNotas(lShared,@aMezcla,cCodigoTes,lRetiroTes,;
				cNombreTes,aAnoCer,cIniJor,cJorTxt,;
				cMaeAlu,cMaeAct,lPrnAre,SCO->nNo1IzqCon,1,;
				nOpcCer)}

       bNotas1 := {||CertiNotas(lShared,@aMezcla,cCodigoTes,lRetiroTes,;
				cNombreTes,aAnoCer,cIniJor,cJorTxt,;
				cMaeAlu,cMaeAct,lPrnAre,SCO->nNo1IzqCon,2,;
				nOpcCer)}

       bNotas2 := {||CertiNot02(aP1,aP2,aP3)}

       AADD(aMezcla,{'<TC>',PCL('Carta')})
       AADD(aMezcla,{'<TO>',PCL('Oficio')})
       AADD(aMezcla,{'<T1>',PCL('Pica')})
       AADD(aMezcla,{'<T2>',PCL('Elite')})
       AADD(aMezcla,{'<C1>',PCL('CondenOn')})
       AADD(aMezcla,{'<C0>',PCL('CondenOf')})
       AADD(aMezcla,{'<G1>',PCL('DobAncOn')})
       AADD(aMezcla,{'<G2>',PCL('DobAncOf')})
       AADD(aMezcla,{'<G3>',PCL('Elite')})
       AADD(aMezcla,{'<JORNADA>',cJorTxt})
       AADD(aMezcla,{'<NROCER>',ALLTRIM(STR(SCO->nNroCerCon,16))})
       AADD(aMezcla,{'<NOMBRE>',cNombreTes})
       AADD(aMezcla,{'<CODIGO>',&cMaeAct->cCodigoEst})
       AADD(aMezcla,{'<NRODOC>',ALLTRIM(&cMaeAct->cDocNitEst)})
       AADD(aMezcla,{'<LUGDOC>',ALLTRIM(&cMaeAct->cLugNitEst)})
       AADD(aMezcla,{'<A¥O>' ,cAnoCer})
       AADD(aMezcla,{'<GRADO>',cNomNiv})
       AADD(aMezcla,{'<NIVEDU>',cNivEdu})
       AADD(aMezcla,{'<APROBO>',cAprobo})
       AADD(aMezcla,{'<NOTAS>' ,bNotas})
       AADD(aMezcla,{'<NOTAS1>',bNotas1})
       AADD(aMezcla,{'<NOTAS2>',bNotas2})
       AADD(aMezcla,{'<USO>',cUsoCer})
       AADD(aMezcla,{'<FECHA>',cFecha(dFecCer,10)})
*>>>>FIN SUSTITUCION DE CAMPOS

*>>>>ACTIVACION DE LA IMPRESORA
       IF SCO->lPrnArcCon
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'CE'+&cMaeAct->cCodigoEst
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCO->cOpcPrnCon,.T.,;
				 NIL,NIL,PathDoc)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
       @ PROW(),00 SAY PCL({"Reset"})
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>ESPECIFICACION DEL TAMA¥O DEL PAPEL
       FOR i = 1 TO nCopias

	   @PROW()+SCO->nSupCerCon,00 SAY ''

	   IF FILE(cPatSis+'\'+'Certi'+cMaeAct+'.TXT')

	      PrnFileDoc(cPatSis+'\'+;
			 'Certi'+cMaeAct+'.TXT',;
			 aMezcla,nLenLin,nMarIzq,1000)

	   ELSE

	      PrnFileDoc('Bases\Certi'+cMaeAct+'.TXT',;
			 aMezcla,nLenLin,nMarIzq,1000)

	   ENDIF

       ENDFOR
       SET DEVICE TO SCREEN
       Termometro(100)
*>>>>FIN ESPECIFICACION DEL TAMA¥O DEL PAPEL

*>>>>GRABACION DEL SECUENCIAL DEL CERTIFICADO
       IF SCO->(lRegLock(lShared,.F.))
	  REPL SCO->nNroCerCon WITH SCO->nNroCerCon+1
	  SCO->(DBCOMMIT())
       ENDIF
       IF lShared
	  SCO->(DBUNLOCK())
       ENDIF
*>>>>FIN GRABACION DEL SECUENCIAL DEL CERTIFICADO

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       cPatSis := cAnoUsr+'.'+cIniJor
       cAnoSis := SUBS(cAnoUsr,3,2)

       CloseDbf('JAR')
       CloseDbf('PRI')
       CloseDbf('BTO')

       IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,;
		       cPatSis+'\'+cMaeAct+'\'+;
		       fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared)
	  cError('ABRIENDO LOS ARCHIVOS MAESTROS')
	  CloseDbf('JAR')
	  CloseDbf('PRI')
	  CloseDbf('BTO')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>RESTAURACION DEL ESTADO INICIAL
       SELECT &cMaeAct

       VerPrn(nOpcPrn,FilePrn)

       RESTSCREEN(0,0,24,79,cSavPan)
       GO nRegAlu
       oBrwCer:ROWPOS := nPosBrw
       oBrwCer:REFRESHALL()
       oBrwCer:FORCESTABLE()

       RETURN NIL
*>>>>FIN RESTAURACION DEL ESTADO INICIAL

/*************************************************************************
* TITULO..: CERTIFICADOS DE NOTAS                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 15/99 VIE A
       Colombia, Bucaramanga        INICIO: 11:30 AM   OCT 15/99 VIE

OBJETIVOS:

1- Permite imprimir los certificados por a¤os.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CertiNotas(lShared,aMezcla,cCodEst,lRetEst,cNomEst,;
		    aAnoCer,cIniJor,cJorTxt,cMaeAlu,cMaeAct,;
		    lPrnAre,nMarIzq,nTipCer,nOpcCer)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       aMezcla                              // Mezcla de Texto
       cCodEst                              // C¢digo del Estudiante
       lRetEst                              // .T. Estudiante retirado
       cNomEst                              // Nombre del Estudiante
       aAnoCer                              // A¤os del Certificado
       cIniJor                              // Inicial de la Jornada
       cJorTxt                              // Jornada escogida
       cMaeAlu                              // Maestros Habilitados
       cMaeAct                              // Maestro Actual
       lPrnAre                              // Imprimir el Area
       nMarIzq                              // Margen Izquierdo
       nTipCer                              // Tipo de Certificado
       nOpcCer			            // Opci¢n de impresi¢n de los Certificados */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL   i,j,k := 0                   // Contadores

       LOCAL cAnoSis := ''                  // A¤o del Sistema
       LOCAL cPatSis := ''                  // Path del Sistema
       LOCAL lPagina := .T.                 // .T. Cambio de p gina
       LOCAL nTotImp := 0                   // Totales de impresion
       LOCAL cTxtPrn := ''                  // Texto de impresion
       LOCAL nColPrn := 0                   // Columna de Impresi¢n
       LOCAL nObsCer := 0                   // Margen Inferior de la Observaci¢n para el Certificado

       LOCAL cCodAre := ''                  // C¢digo del area
       LOCAL cMateri := ''                  // Nombre de la Materia
       LOCAL cNomAre := ''                  // Nombre del area
       LOCAL cNomMat := ''                  // Nombre de la materia
       LOCAL   cNota := ''                  // Nota de area o materia
       LOCAL cIntens := ''                  // Intensidad horaria
       LOCAL nFalAno := 0                   // Total fallas del a¤o.
       LOCAL cEstado := ''                  // Estado final de aprobaci¢n
       LOCAL cFolios := ''                  // Folios del libro final
       LOCAL lHayEst := .F.                 // .T. Hay Estudiante
       LOCAL lNegAre := .F.                 // .T. Imprimir Negrilla
       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias
       LOCAL aMatHab := {}                  // Detalles de la Recuperaci¢n
       LOCAL aNroLin := {}                  // N£mero de l¡neas
       LOCAL lNotNum := .F.                 // .T. Nota Numerica .F. Nota Cualitativa
       LOCAL nTotPer := 0                   // Total Periodos
       LOCAL cTitAre := ''                  // T¡tulo del Area
       LOCAL cCamFal := ''                  // Campo de Fallas
       LOCAL lHayNpR := .F.                 // .T. Se presento a la Recuperaci¢n
       LOCAL aTxtNpr := {}                  // Texto para la no presentaci¢n de la Recuperaci¢n.
       LOCAL lMatVar := .F.                 // .T. Imprimir Materia Variable

       LOCAL cCodigoTma := ''               // C¢digo de la Materia
       SET FIXED OFF
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE LAS NOTAS DE CADA A¥O
       nTipCer := IF(EMPTY(nTipCer),1,nTipCer)
       nColPrn := nMarIzq
       FOR k := 1 TO LEN(aAnoCer)

***********VALIDACION DE LOS A¥OS DISPONIBLES
	     lHayEst := .F.
	     IF aAnoCer[k] < SCO->nAnoIniCon .OR.;
		aAnoCer[k] > SCO->nAnoFinCon
		cError('EL A¥O '+STR(aAnoCer[k],4)+' NO ESTA DISPONIBLE',;
		       'INICIAL:'+STR(SCO->nAnoIniCon,4)+;
		       ' FINAL:'+STR(SCO->nAnoFinCon,4))
		LOOP
	     ENDIF
***********FIN VALIDACION DE LOS A¥OS DISPONIBLES

***********INICIALIZACION PARA EL A¥O
	     CloseDbf('JAR')
	     CloseDbf('PRI')
	     CloseDbf('BTO')
	     cAnoSis := SUBS(STR(aAnoCer[k],4),3,2)
	     cPatSis := STR(aAnoCer[k],4)+'.'+cIniJor
***********FIN INICIALIZACION PARA EL A¥O

***********SELECION DE LAS AREAS DE TRABAJO
	     IF !lUseMae(lShared,cPatSis,cMaeAlu,cAnoSis)
		CloseDbf('JAR')
		CloseDbf('PRI')
		CloseDbf('BTO')
		LOOP
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

***********BUSQUEDA DEL ESTUDIANTE
	     lHayEst := lSekCodMae(cCodEst,cMaeAlu,@cMaeAct)
	     IF !lHayEst
		LOOP
	     ENDIF
***********FIN BUSQUEDA DEL ESTUDIANTE

***********SELECION DE LAS AREAS DE TRABAJO
	     IF !lUseDbfCe(lShared,cPatSis,STR(aAnoCer[k],4),;
			   cAnoSis,cMaeAct,&cMaeAct->cCodigoGru)
		CloseDbf('JAR')
		CloseDbf('PRI')
		CloseDbf('BTO')
		LOOP
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

***********VALIDACION DEL NOMBRE DEL ESTUDIANTE
	     IF RTRIM(&cMaeAct->cNombreEst)+' '+;
		&cMaeAct->cApelliEst # cNomEst

		SET DEVICE TO SCREEN
		cError(cNomEst+' '+;
		       'NOMBRES DIFERENTES',;
		       RTRIM(&cMaeAct->cNombreEst)+' '+;
		       &cMaeAct->cApelliEst)
		SET DEVICE TO PRINT

		lHayEst := .F.
		LOOP

	     ENDIF
***********FIN VALIDACION DEL NOMBRE DEL ESTUDIANTE

***********LOCALIZACION DEL GRUPO
	     IF !lLocCodigo('cCodigoGru','GRU',&cMaeAct->cCodigoGru)
		lHayEst := .F.
		LOOP
	     ENDIF
***********FIN LOCALIZACION DEL GRUPO

***********LOCALIZACION DE LAS NOTAS
	     lHayEst := lLocCodigo('cCodigoEst','NOT',cCodEst)
	     IF !lHayEst
		LOOP
	     ENDIF
	     SET DEVICE TO PRINT
***********FIN LOCALIZACION DE LAS NOTAS

***********LECTURA DE LOS NOTAS DEL ESTUDIANTE
	     SELECT NOT
	     aNotAre := {}
	     aNotMat := {}
	     nTotPer := TCO->nTotPerTbl
	     lNotNum := IF(SUBS(TCO->cNotNumTbl,nTotPer,1)='1',.T.,.F.)
	     DetAreas(@aNotAre,@aNotMat,nTotPer)
***********FIN LECTURA DE LOS NOTAS DEL ESTUDIANTE

***********REEMPLAZO DE LAS ASIGNATURAS VARIABLES // Adicionado
	     IF SEL->(RECCOUNT()) # 0
		lDetAreEst(@aNotAre,@aNotMat,nTotPer,NOT->cCodigoEst)
	     ENDIF
***********FIN REEMPLAZO DE LAS ASIGNATURAS VARIABLES

***********CONTEO DEL TOTAL DE FALLAS POR AREAS
	     nFalAno := 0
	     FOR i := 1 TO LEN(aNotAre)

		 IF SUBS(aNotAre[i][4],7,4) == 'AREN'
		    cCamFal := 'NOT->cFa'+SUBS(aNotAre[i,6],9,4)+'Not'
		    FOR j := 1 TO nTotPer
			nFalAno += VAL(SUBS(&cCamFal,j*2-1,2))
		    NEXT
		 ENDIF

	     NEXT
***********FIN CONTEO DEL TOTAL DE FALLAS POR AREAS

***********CONTEO DEL TOTAL DE FALLAS POR MATERIAS
	     FOR i := 1 TO LEN(aNotMat)
		 cCamFal := aNotMat[i,6]
		 FOR j := 1 TO nTotPer
		     nFalAno += VAL(SUBS(&cCamFal,j*2-1,2))
		 NEXT
	     NEXT
***********FIN CONTEO DEL TOTAL DE FALLAS POR MATERIAS

***********IMPRESION DE LOS DETALLES DEL A¥O
	     SendCodes(PCL('Pica'))
	     @PROW()+2,nColPrn SAY 'A¥O: '+STR(aAnoCer[k],4)+' '+;
				   'SECCION: '+cJorTxt+' '+;
				   IF(EMPTY(&cMaeAct->cFolFinEst),'',;
				      'FOLIO: '+&cMaeAct->cFolFinEst)

	     @PROW()+1,nColPrn SAY 'GRADO: '+ALLTRIM(GRU->cNombreGru)+' '+;
				   'DE '+ALLTRIM(GRU->cNivEduGru)


	     DO CASE
	     CASE nTipCer == 1
		  IF lPrnAre
		     cTitAre := 'AREAS Y ASIGNATURAS'+SPACE(17)
		  ELSE
		     cTitAre := 'AREA/ASIGNATURAS'+;
				IF(PRN->TipoPrn == 'M',SPACE(30),SPACE(23))
		  ENDIF

	     CASE nTipCer == 2
		  IF lPrnAre
		     cTitAre := 'AREAS Y ASIGNATURAS'+SPACE(17)
		  ELSE
		     cTitAre := 'AREA/ASIGNATURAS'+;
				IF(PRN->TipoPrn == 'M',SPACE(26),SPACE(23))
		  ENDIF
	     ENDCASE

	     DO CASE
	     CASE nTipCer == 1
		  cTitAre := SUBS(cTitAre,1,82)+'  JVF  '+;
			     IF(PRN->TipoPrn == 'M',SPACE(03),SPACE(02))+;
			     IF(EMPTY(ANO->cHorClaCoA),'','*')+'I.H.S'

	     CASE nTipCer == 2
		  cTitAre := SUBS(cTitAre,1,82)+;
			     IF(EMPTY(ANO->cHorClaCoA),'','*')+'H/SEMANALES'+;
			     IF(PRN->TipoPrn == 'M',SPACE(03),SPACE(02))+;
			     'VALORACION'
	     ENDCASE
	     cTitAre := IF(EMPTY(TCO->cTitAreTbl),cTitAre,TCO->cTitAreTbl)

	     @PROW()+2,nColPrn SAY ALLTRIM(cTitAre)
	     SendCodes(PCL('CondenOn'))
	     nColPrn := SCO->nNo2IzqCon
***********FIN IMPRESION DE LOS DETALLES DEL A¥O

***********IMPRESION DE LAS NOTAS
	     nTotPer := TCO->nTotPerTbl
	     lNegAre := TCO->lNegAreTbl
	     lNegAre := .T.
	     FOR i := 1 TO LEN(aNotAre)

*---------------IMPRESION DEL NOMBRE DEL AREA
		  IF lPrnAre .AND. SUBS(aNotAre[i][4],7,4) == 'AREP' .AND.;
		     aNotAre[i,9]
		     cNomAre := RTRIM(aNotAre[i,10])
		     IF lNegAre
			cNomAre := PCL({"NegraOn"})+cNomAre+PCL({"NegraOf"})
		     ENDIF
		     @PROW()+1,nColPrn SAY cNomAre
		  ENDIF
*---------------FIN IMPRESION DEL NOMBRE DEL AREA

*---------------IMPRESION DE LAS NOTAS DEL AREA
		  IF SUBS(aNotAre[i][4],7,4) == 'AREN' .AND.;
		     aNotAre[i,9]  // El area se imprime en el certificado

*::::::::::::::::::::LECTURA DEL NOMBRE DEL AREA
		      DO CASE
		      CASE nTipCer == 1
			   cNomAre := RTRIM(aNotAre[i,10])+;
				      REPL('.',80-LEN(RTRIM(aNotAre[i,10])))

		      CASE nTipCer == 2
			   cNomAre := RTRIM(aNotAre[i,10])+;
				      REPL(' ',80-LEN(RTRIM(aNotAre[i,10])))
		      ENDCASE

		      IF lNegAre
			 cNomAre := PCL({"NegraOn"})+cNomAre+PCL({"NegraOf"})
		      ENDIF
*::::::::::::::::::::FIN LECTURA DEL NOMBRE DEL AREA

*::::::::::::::::::::LECTURA DE LA NOTA DEL AREA
		       cNota := SUBS(&(aNotAre[i,4]),nTotPer*4-3,4)
		       cNota := cNotDef(cNota,lNotNum)

		       cNota := cTxtNota(cNota)

/*
		       DO CASE
		       CASE 'E' $ cNota
			    cNota := 'EXCELENTE    '
		       CASE 'S' $ cNota
			    cNota := 'SOBRESALIENTE'
		       CASE 'B' $ cNota
			    cNota := 'BUENO        '
		       CASE 'A' $ cNota
			    cNota := 'ACEPTABLE    '
		       CASE 'I' $ cNota
			    cNota := 'INSUFICIENTE '
		       CASE 'D' $ cNota
			    cNota := 'DEFICIENTE   '
		       OTHERWISE
			    cNota := 'SIN NOTA     '
		       ENDCASE
*/


		       cIntens := IF(EMPTY(aNotAre[i,16]),aNotAre[i,11],aNotAre[i,16])
		      *Intensidad Horaria
*::::::::::::::::::::FIN LECTURA DE LA NOTA DEL AREA

*::::::::::::::::::::IMPRESION DEL REGISTRO
		       DO CASE
		       CASE nTipCer == 1
			    @PROW()+1,nColPrn SAY cNomAre+;
						  SPACE(02)+cNota+;
						  SPACE(02)+cIntens
		       CASE nTipCer == 2
			    @PROW()+1,nColPrn SAY cNomAre+;
						  SPACE(02)+cIntens+;
						  SPACE(12)+cNota
		       ENDCASE
*::::::::::::::::::::FIN IMPRESION DEL REGISTRO

*::::::::::::::::::::ANALISIS PARA EL CAMBIO DE PAGINA
		       IF PRN->TipoPrn == 'M' .AND.;
			  PROW() > SCO->nInfCerCon
			  @PROW()+1,nColPrn SAY 'SIGUE..x'
			  EJECT
			  @PROW()+TCO->nLinEspTbl,nColPrn SAY '...CONTINUA '+;
					 'A¥O: '+STR(aAnoCer[k],4)+' '+;
					 'GRADO: '+ALLTRIM(GRU->cNombreGru)+' '+;
					 'DE '+ALLTRIM(GRU->cNivEduGru)
			  @PROW(),nColPrn SAY ''
		       ENDIF
*::::::::::::::::::::FIN ANALISIS PARA EL CAMBIO DE PAGINA

		  ENDIF
*---------------FIN IMPRESION DE LAS NOTAS DEL AREA

*---------------IMPRESION DE LAS NOTAS DE LA MATERIA
		  FOR j := 1 TO LEN(aNotMat)

*::::::::::::::::::::VALIDACION DE IMPRESION
		       IF !aNotMat[j,9] // La materia se imprime en el certificado
			  LOOP
		       ENDIF
*::::::::::::::::::::FIN VALIDACION DE IMPRESION

*::::::::::::::::::::VALIDACION DE LA IMPRESION
		       cCodigoTma := SUBS(aNotMat[j,5],9,4)
		       DO CASE
		       CASE nOpcCer == 1 // Solo Areas

			    IF SUBS(cCodigoTma,3,2) # '00'
			       LOOP
			    ENDIF
			  *ÀDescarta las asignaturas

		       CASE nOpcCer == 2 // Solo Asignaturas

			    IF SUBS(cCodigoTma,3,2) == '00'
			       LOOP
			    ENDIF
			  *ÀDescarta las Areas

		       ENDCASE
*::::::::::::::::::::FIN VALIDACION DE LA IMPRESION

*::::::::::::::::::::IMPRESION DE LA MATERIA CORRESPONDIENTE AL AREA
		       IF aNotAre[i,2] == aNotMat[j,1]

*.........................MATERIA VARIABLE
			    cMateri := RTRIM(aNotMat[j,10])
			    IF SUBS(aNotMat[j,5],9,4) # SUBS(aNotMat[j,11],3,4)
			       IF aNotMat[j,22] // Materia Fija de la Materia Variable. .T.=> Entra en el certificado de notas
				  cMateri := RTRIM(aNotMat[j,2])
			       ENDIF
			    ENDIF
*.........................FIN MATERIA VARIABLE

*.........................LECTURA DE NOMBRE DE LA MATERIA
			   IF lPrnAre
			      DO CASE
			      CASE nTipCer == 1
				   cNomMat := SPACE(02)+cMateri+;
					      REPL('.',78-LEN(cMateri))

			      CASE nTipCer == 2
				   cNomMat := SPACE(02)+cMateri+;
					      REPL(' ',78-LEN(cMateri))
			      ENDCASE
			   ELSE
			      DO CASE
			      CASE nTipCer == 1
				   cNomMat := cMateri+;
					      REPL('.',80-LEN(cMateri))
			      CASE nTipCer == 2
				   cNomMat := cMateri+;
					      REPL(' ',80-LEN(cMateri))
			      ENDCASE

			      IF !EMPTY(TCO->cSpaBolTbl)
				 IF aNotMat[j,1] == cCodAre .AND.;
				    SUBS(aNotMat[j,5],11,2) # '00'
				    IF aNotAre[i,9]
				       cNomMat := SUBS(SPACE(02)+cNomMat,1,80)
				    ELSE
				       cNomMat := SUBS(cNomMat,1,80)
				    ENDIF
				 ELSE
				    cCodAre := aNotMat[j,1]
				 ENDIF
			      ENDIF
			    *ÀIndentaci¢n de la materia

			   ENDIF
			   IF lNegAre
			      cNomMat := PCL({"NegraOn"})+cNomMat+PCL({"NegraOf"})
			   ENDIF
*.........................FIN LECTURA DE NOMBRE DE LA MATERIA

*.........................LECTURA DE LA NOTA
			    cNota := SUBS(&(aNotMat[j,4]),nTotPer*4-3,4)
			    cNota := cNotDef(cNota,lNotNum)


			    cNota := cTxtNota(cNota)

/*

			    DO CASE
			    CASE 'E' $ cNota
				 cNota := 'EXCELENTE    '
			    CASE 'S' $ cNota
				 cNota := 'SOBRESALIENTE'
			    CASE 'B' $ cNota
				 cNota := 'BUENO        '
			    CASE 'A' $ cNota
				 cNota := 'ACEPTABLE    '
			    CASE 'I' $ cNota
				 cNota := 'INSUFICIENTE '
			    CASE 'D' $ cNota
				 cNota := 'DEFICIENTE   '
			    OTHERWISE
				 cNota := 'SIN NOTA     '
			    ENDCASE
*/
			    cIntens := IF(EMPTY(aNotMat[j,16]),aNotMat[j,3],aNotMat[j,16])
			   *Intensidad Horaria
*.........................FIN LECTURA DE LA NOTA

*.........................IMPRESION DEL REGISTRO
			    DO CASE
			    CASE nTipCer == 1
				 @PROW()+1,nColPrn SAY cNomMat+;
						       SPACE(02)+cNota+;
						       SPACE(02)+cIntens
			    CASE nTipCer == 2
				 @PROW()+1,nColPrn SAY cNomMat+;
						       SPACE(02)+cIntens+;
						       SPACE(12)+cNota
			    ENDCASE
*.........................FIN IMPRESION DEL REGISTRO

*.........................ANALISIS PARA EL CAMBIO DE PAGINA
			    IF PRN->TipoPrn == 'M' .AND.;
			       PROW() > SCO->nInfCerCon
			       @PROW()+1,nColPrn SAY 'SIGUE..x'
			       EJECT
			       @PROW()+TCO->nLinEspTbl,nColPrn SAY '...CONTINUA '+;
					      'A¥O: '+STR(aAnoCer[k],4)+' '+;
					      'GRADO: '+ALLTRIM(GRU->cNombreGru)+' '+;
					      'DE '+ALLTRIM(GRU->cNivEduGru)
			       @PROW(),nColPrn SAY ''
			    ENDIF
*.........................FIN ANALISIS PARA EL CAMBIO DE PAGINA

		       ENDIF
*::::::::::::::::::::FIN IMPRESION DE LA MATERIA CORRESPONDIENTE AL AREA

		  ENDFOR
*---------------FIN IMPRESION DE LAS NOTAS DE LA MATERIA

*---------------ANALISIS PARA EL CAMBIO DE PAGINA
		  IF PRN->TipoPrn == 'M' .AND.;
		     PROW() > SCO->nInfCerCon
		     EJECT
		     lPagina := .T.
		  ELSE
		     lPagina := .F.
		  ENDIF
*---------------FIN ANALISIS PARA EL CAMBIO DE PAGINA

	     ENDFOR
***********IMPRESION DE LAS NOTAS

***********ANALISIS PARA EL CAMBIO DE PAGINA
	     nObsCer := IF(SCO->nObsCerCon==0,46,SCO->nObsCerCon)
	     IF PRN->TipoPrn == 'M' .AND. PROW() > nObsCer
		SET DEVICE TO PRINT
		@ PROW()+1,nColPrn SAY 'SIGUE...xx'
		EJECT
		@PROW()+TCO->nLinEspTbl,nColPrn SAY '...CONTINUA '+;
			       'A¥O: '+STR(aAnoCer[k],4)+' '+;
			       'GRADO: '+ALLTRIM(GRU->cNombreGru)+' '+;
			       'DE '+ALLTRIM(GRU->cNivEduGru)
		@PROW(),nColPrn SAY ''
	     ENDIF
***********FIN ANALISIS PARA EL CAMBIO DE PAGINA

***********IMPRESION DE LA OBSERVACION
	     SET DEVICE TO PRINT
	     IF lHayEst
		cEstado := ''
		cEstado := IF(lRetEst,'NO TERMINO. SE RETIRO EN '+;
				      cFecha(&cMaeAct->dFecRetEst),;
			      cAproboJui(NOT->nAproboNot))
		cEstado := ALLTRIM(cEstado)

		IF EMPTY(ANO->cHorClaCoA)
		   @ PROW()+1,nColPrn SAY ''
		   aNroLin := aDivLin('OBSERVACION FINAL: '+cEstado,110)
		   FOR i := 1 TO LEN(aNroLin)
		       @ PROW()+1,nColPrn SAY aNroLin[i]
		   NEXT
		ELSE
		   @ PROW()+1,nColPrn SAY '* '+ANO->cHorClaCoA
		   aNroLin := aDivLin('OBSERVACION FINAL: '+cEstado,110)
		   FOR i := 1 TO LEN(aNroLin)
		       @ PROW()+1,nColPrn SAY aNroLin[i]
		   NEXT
		ENDIF
	     ENDIF
***********FIN IMPRESION DE LA OBSERVACION

***********LECTURA DE LAS RECUPERACIONES
	     IF lHayEst
		lMatVar := .T.
		aMatHab := aMatHabPla(NOT->nAproboNot,aNotAre,;
				      aNotMat,nTotPer,lNotNum,;
				      lMatVar)
	     ENDIF
***********FIN LECTURA DE LAS RECUPERACIONES

***********IMPRESION DE LAS RECUPERACIONES COMO OBSERVACIONES
	     IF lHayEst .AND. !EMPTY(aMatHab)
		@ PROW()+1,nColPrn SAY ''
		cTxtPrn := IF(EMPTY(aMatHab[1,6]),;
			      'ACTIVIDADES DE RECUPERACION DE:',;
			      aMatHab[1,6])

		FOR i := 1 TO LEN(aMatHab)

		    DO CASE
		    CASE nOpcCer == 1 // Solo Areas

			 IF SUBS(aMatHab[i,1],3,2) # '00'
			    LOOP
			 ENDIF
		       *ÀDescarta las asignaturas

		    CASE nOpcCer == 2 // Solo Asignaturas

			 IF SUBS(aMatHab[i,1],3,2) == '00'
			    LOOP
			 ENDIF
		       *ÀDescarta las Areas

		    ENDCASE

		    cTxtPrn += ALLTRIM(aMatHab[i,5])+': '
		    IF ALLTRIM(cTxtNota(aMatHab[i,4])) == 'SIN NOTA'
		       cTxtPrn += 'PENDIENTE. '

		    ELSE
		       IF ALLTRIM(cTxtNota(aMatHab[i,4])) == '*NO SE PRESENTO'
			  cTxtPrn += ALLTRIM(cTxtNota(aMatHab[i,4]))+'. '
			  lHayNpR := .T.
		       ELSE
			  cTxtPrn += ALLTRIM(cTxtNota(aMatHab[i,4]))+;
				     ' - ACTA No.'+ALLTRIM(aMatHab[i,3])+;
				     ' DE '+aMatHab[i,2]+'. '
		       ENDIF
		    ENDIF
		NEXT
		aNroLin := aDivLin(ALLTRIM(cTxtPrn),110)
		FOR i := 1 TO LEN(aNroLin)
		    @ PROW()+1,nColPrn SAY aNroLin[i]
		NEXT

		IF lHayNpR .AND. !EMPTY(ANO->cTxtNpRCoA)
		   aTxtNpr := aDivLin('*'+ALLTRIM(ANO->cTxtNpRCoA),110)
		   FOR i := 1 TO LEN(aTxtNpR)
		       @ PROW()+1,nColPrn SAY aTxtNpR[i]
		   NEXT
		ENDIF
	     ENDIF
***********FIN IMPRESION DE LAS RECUPERACIONES COMO OBSERVACIONES

***********IMPRESION DE LA OBSERVACION
	     IF lHayEst .AND. !EMPTY(&cMaeAct->cObsLibEst)
		aNroLin := aDivLin(ALLTRIM(&cMaeAct->cObsLibEst),110)
		FOR i := 1 TO LEN(aNroLin)
		    @ PROW()+1,nColPrn SAY aNroLin[i]
		NEXT
	     ENDIF
	   *ÀObservaci¢n General.
***********FIN IMPRESION DE LA OBSERVACION

       ENDFOR
       SendCodes(PCL({"CondenOf"}))
       RETURN NIL
*>>>>FIN IMPRESION DE LAS NOTAS DE CADA A¥O

/*************************************************************************
* TITULO DEL PROGRAMA..: APERTURA DE LOS ARCHIVOS DEL CERTIFICADO        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 18/97 VIE A
       Colombia, Bucaramanga        INICIO: 10:30 PM   JUL 18/97 VIE

OBJETIVOS:

1- Pone en uso los archivos necesarios para el certificado.

2- Retorna .T. si existen problemas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lUseDbfCe(lShared,cPatSis,cAnoUsr,cAnoSis,cMaeAct,cCodGru)

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CIERRE DE ARCHIVOS
       CloseDbf('ANO')
       CloseDbf('TCO')
       CloseDbf('NIV')
       CloseDbf('GRU')
       CloseDbf('MAT')
       CloseDbf('APR')
       CloseDbf('PLA')
       CloseDbf('NOT')
       CloseDbf('JVF')

       cAnoUsr := ALLTRIM(cAnoUsr)
       cAnoSis := SUBS(cAnoUsr,3,2)
*>>>>FIN CIERRE DE ARCHIVOS

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+;
		       fConAno+cAnoUsr+ExtFile,'ANO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       fConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileMat,'MAT',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileApr,'APR',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		      cFilePlan(cAnoUsr,cCodGru),'PLA',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\NOTAS\'+;
				'NT'+cCodGru+cAnoSis+ExtFile,;
				'NOT',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileJvf,'JVF',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileSel+cMaeAct+ExtFile,'SEL',;
		       cPatSis+'\'+cMaeAct+'\'+;
		       fNtxSel+cMaeAct+cExtNtx,lShared)
	  RETURN .F.
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION GENERAL DEL SISTEMA')

       CASE ANO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL A¥O')

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL NIVEL')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN EXISTEN GRUPOS GRABADOS')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE APR->(RECCOUNT()) == 0
	    cError('NO EXISTEN LA TABLA DE APROBACIONES')

       CASE lHayJvfTco() .AND. JVF->(RECCOUNT()) == 0
	    cError('NO EXISTEN JUICIOS VALORATIVOS GRAGADOS PARA '+cMaeAct)

       CASE lHayItvTco() .AND. !lHayItvJvf()
	    cError('SE DEBE DEFINIR BIEN EL INTERVALO DE LOS JUICIOS VALORATIVOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  RETURN .F.
       ENDIF
       RETURN .T.
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

/*************************************************************************
* TITULO..: CONSTANCIAS DEL ESTUDIANTE                                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 09/2003 LUN A
       Colombia, Bucaramanga        INICIO: 12:00 PM   JUN 09/2003 LUN

OBJETIVOS:

1- Permite imprimir la constancia de los estudiantes.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Constancia(lShared,cNomSis,cNomEmp,cAnoUsr,cMaeAlu,;
		    cMaeAct,cJorTxt,cIniJor,cAnoIni,cAnoFin,;
		    cDocNit,cLugDoc,aFirmas,oBrwCer,nMarDer,;
		    nMarIzq)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cNomSis                              // Nombre del Sistema
       cNomEmp                              // Nombre de la Empresa
       cAnoUsr                              // A¤o del Usuario
       cMaeAlu                              // Maestros Habilitados
       cMaeAct                              // Maestro Actual
       cJorTxt                              // Jornada escogida
       cIniJor                              // Iniciales jornada escogida
       cAnoIni                              // A¤o Inicial Habilitado
       cAnoFin                              // A¤o Final Habilitado
       cDocNit                              // Documento de Identidad
       cLugNit                              // Lugar del Documento
       cUsoCer                              // Uso del Certificado
       aFirmas                              // Firmantes del Certificado
       oBrwCer                              // Browse del certificado
       nMarDer                              // Margen Derecho
       nMarIzq                              // Margen Izquierdo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cSavPan := ''                  // Salvar pantalla
       LOCAL   i,j,k := 0                   // Contadores

       LOCAL cUsoCer := ''                  // Uso del Certificado
       LOCAL nCopias := 1                   // N£meros de copias a imprimir
       LOCAL nNroCop := 1                   // N£mero de copia
       LOCAL nLenLin := nMarDer             // Longitud de la l¡nea
       LOCAL nColPrn := 0                   // Columna de Impresi¢n

       LOCAL cNalias := ''                  // Alias del Maestro
       LOCAL cPatSis := ''                  // Path del sistema
       LOCAL cAnoSis := ''                  // A¤o del Sistema
       LOCAL nRegAlu := 0                   // Registro del Alumno
       LOCAL nPosBrw := 0                   // Posici¢n del Browse
       LOCAL nNroFil := 0                   // N£mero de la fila
       LOCAL nNroCol := 0                   // N£mero de la Columna
       LOCAL cIntAno := ''                  // A¤o del Certificado
       LOCAL nVeces  := 0                   // Veces del A¤o
       LOCAL bNotas  := NIL                  // Code Block de Notas
       LOCAL bNotas1 := NIL                  // Code Block de Notas No. 1
       LOCAL aMezcla := {}                  // Mezcla de Texto
       LOCAL lPrnAre := .T.                 // Imprimir el Area
       LOCAL cTxtHlp := ''                  // Texto de Ayuda
       LOCAL cTitHlp := ''                  // T¡tulo para la Ayuda
       LOCAL nNroCar := 1                   // N£mero de la Carta
       LOCAL cNroCar := ''                  // N£mero de la Carta

       LOCAL GetList:= {}                   // Variable del sistema

       STATIC nTipLet := 0                  // Tipo de Letra

       LOCAL lRetiroTes := .F.              // .T. Estudiante Retirado
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cApelliTes := ''               // Apellido del Estudiante
       LOCAL cCodigoTes := ''               // C¢digo del estudiante
       LOCAL cCodigoTgr := ''               // C¢digo del Grupo

       SET CURSOR ON
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DEL NUMERO DE COPIA
       cSavPan := SAVESCREEN(0,0,24,79)
       SETCURSOR(1)
       TitBuscar(18,@nNroFil,@nNroCol,'NRO COPIAS:','COPIAS')
       @ nNroFil,nNroCol GET nCopias PICT '99'
       READ
       SETCURSOR(0)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nCopias == 0
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL NUMERO DE COPIA

*>>>>LECTURA DE LA DESTINACION DEL CERTIFICADO
       cSavPan := SAVESCREEN(0,0,24,79)
       cUsoCer := SPACE(70)
       TitBuscar(70,@nNroFil,@nNroCol,'OBSERVACION:',;
		 'OBSERVACION')

       SETCURSOR(1)
       @ nNroFil,nNroCol GET cUsoCer PICT '@S70!'
       READ
       cUsoCer := ALLTRIM(cUsoCer)
       SETCURSOR(0)
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN LECTURA DE LA DESTINACION DEL CERTIFICADO

*>>>>LECTURA DEL NUMERO DE LA CARTA MODELO
       cSavPan := SAVESCREEN(0,0,24,79)
       SET CURSOR ON
       TitBuscar(18,@nNroFil,@nNroCol,'INGRESE EL No.','CARTA MODELO')
       @ nNroFil,nNroCol GET nNroCar PICT '999'
       READ
       IF EMPTY(nNroCar)
	  RESTSCREEN(0,0,24,79,cSavPan)
	  RETURN NIL
       ENDIF
       cNroCar := STR(nNroCar,3)
       lCorrecion(@cNroCar)
*>>>>FIN LECTURA DEL NUMERO DE LA CARTA MODELO

*>>>>EDICION DE LA CARTA MODELO
       cTxtHlp :=   'Inserte el texto: <JORNADA> => '+;
		    'para incluir la Jornada de Estudio'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		    'Inserte el texto: <NOMBRE> => '+;
		    'para incluir el Nombre del Estudiante'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		    'Inserte el texto: <GRADO> => '+;
		    'para incluir el Nombre del Grado o Nivel '+;
		    'del Estudiante'+CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		    'Inserte el texto: <CODIGO> => '+;
		    'para incluir el C¢digo del Estudiante'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		    'Inserte el texto: <NRODOC> => '+;
		    'para incluir el N£mero del Documento del Estudiante'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		    'Inserte el texto: <LUGDOC> => '+;
		    'para incluir el Lugar del Documento del Estudiante'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		    'Inserte el texto: <OSB> => '+;
		    'para incluir la Observaci¢n sobre de la Constancia'+;
		    CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
		    'Inserte el texto: <FECHA> => '+;
		    'para incluir la fecha actual'+;
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

       EditFile(cNomSis,"Bases\Const"+cNroCar+'.txt',;
			 "Edite el Texto de la Carta No. "+cNroCar,;
			 cTxtHlp,cTitHlp)

       IF !lPregunta('DESEA CONTINUAR? No Si')
	  RESTSCREEN(0,0,24,79,cSavPan)
	  RETURN NIL
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN EDICION DE LA CARTA MODELO

*>>>>LECTURA DE LOS ESTADOS INICIALES
       SELECT &cMaeAct

       nPosBrw := oBrwCer:ROWPOS()
       nRegAlu := RECNO()

       lRetiroTes := &cMaeAct->lRetiroEst
       cNombreTes := RTRIM(&cMaeAct->cNombreEst)+' '+;
		     RTRIM(&cMaeAct->cApelliEst)
       cCodigoTes := &cMaeAct->cCodigoEst
       cCodigoTgr := &cMaeAct->cCodigoGru
*>>>>FIN LECTURA DE LOS ESTADOS INICIALES

*>>>>LOCALIZACION DEL GRUPO
       IF lLocCodigo('cCodigoGru','GRU',cCodigoTgr)
	  cCodigoTgr := 'GRADO: '+ALLTRIM(GRU->cNombreGru)+' '+;
			 'DE '+ALLTRIM(GRU->cNivEduGru)
       ELSE
	  cCodigoTgr := 'FALTA DEFINIR EL NOMBRE DEL GRADO'
       ENDIF
       SELECT &cMaeAct
*>>>>FIN LOCALIZACION DEL GRUPO

*>>>>PREGUNTA DE DECISION
       cError(cNombreTes,'CONSTANCIA PARA','A¥OS:'+ALLTRIM(cAnoUsr))
       IF !lPregunta('DESEA IMPRIMIR LA CONSTANCIA? Si No')
	  RETURN NIL
       ENDIF
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  RETURN NIL
       ENDIF
       Termometro(0,'IMPRIMIENDO LA CONSTANCIA')
       Termometro(50)
*>>>>FIN PREGUNTA DE DECISION

*>>>>SUSTITUCION DE CAMPOS
       aMezcla := {{'<TC>',PCL('Carta')},;
		   {'<TO>',PCL('Oficio')},;
		   {'<T1>',PCL('Pica')},;
		   {'<T2>',PCL('Elite')},;
		   {'<C1>',PCL('CondenOn')},;
		   {'<C0>',PCL('CondenOf')},;
		   {'<G1>',PCL('DobAncOn')},;
		   {'<G2>',PCL('DobAncOf')},;
		   {'<G3>',PCL('Elite')},;
		   {'<JORNADA>',cJorTxt},;
		   {'<NOMBRE>',cNombreTes},;
		   {'<GRADO>',cCodigoTgr},;
		   {'<CODIGO>',&cMaeAct->cCodigoEst},;
		   {'<NRODOC>',ALLTRIM(&cMaeAct->cDocNitEst)},;
		   {'<LUGDOC>',ALLTRIM(&cMaeAct->cLugNitEst)},;
		   {'<OBS>',cUsoCer},;
		   {'<FECHA>',cFecha(DATE(),10)}}
*>>>>FIN SUSTITUCION DE CAMPOS

*>>>>ACTIVACION DE LA IMPRESORA
       IF !Printer_on(SCO->lPrnArcCon)
	   SET DEVICE TO SCREEN
	   RETURN NIL
       ENDIF
       @ PROW(),00 SAY PCL({"Reset"})
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>ESPECIFICACION DEL TAMA¥O DEL PAPEL
       FOR i = 1 TO nCopias
	   @PROW()+SCO->nSupCerCon,00 SAY ''
	   PrnFileDoc("Bases\Const"+cNroCar+'.txt',;
		      aMezcla,nLenLin,nMarIzq,1000)
       ENDFOR
       SET DEVICE TO SCREEN
       Termometro(100)
*>>>>FIN ESPECIFICACION DEL TAMA¥O DEL PAPEL

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       cPatSis := cAnoUsr+'.'+cIniJor
       cAnoSis := SUBS(cAnoUsr,3,2)

       CloseDbf('JAR')
       CloseDbf('PRI')
       CloseDbf('BTO')

       IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,;
		       cPatSis+'\'+cMaeAct+'\'+;
		       fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared)
	  cError('ABRIENDO LOS ARCHIVOS MAESTROS')
	  CloseDbf('JAR')
	  CloseDbf('PRI')
	  CloseDbf('BTO')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>RESTAURACION DEL ESTADO INICIAL
       SELECT &cMaeAct

       RESTSCREEN(0,0,24,79,cSavPan)
       GO nRegAlu
       oBrwCer:ROWPOS := nPosBrw
       oBrwCer:REFRESHALL()
       oBrwCer:FORCESTABLE()

       RETURN NIL
*>>>>FIN RESTAURACION DEL ESTADO INICIAL


FUNCTION lDatosCert(lShared,cPatSis,cAnoCer,cAnoSis,cMaeAct,cCodEst,cCodGru,;
		    cAprobo,cNomNiv,cNivEdu)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cPatSis                              // Path del Sistemas
       cAnoCer                              // A¤o Certificados
       cAnoSis                              // A¤o del Sistema
       cMaeAct                              // Maestro Actual
       cCodEst                              // C¢digo del Estudiante
       cCodGru                              // C¢digo del Grupo
       cAprobo                              // @Aprovaci¢n
       cNomNiv                              // @Nombre del Nivel
       cNivEdu                              // @Nivel de Educaci¢n */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL nCodApr := 0                   // C¢digo de Promoci¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfCe(lShared,cPatSis,cAnoCer,;
		     cAnoSis,cMaeAct,cCodGru)
	  lHayErr := .T.
	  RETURN !lHayErr
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>LOCALIZACION DEL CODIGO
       nCodApr := 0
       IF lLocCodigo('cCodigoEst','NOT',cCodEst)

	  IF NOT->lRetGruNot
	     lHayErr := .T.
	     RETURN !lHayErr
	  ENDIF
	  nCodApr := NOT->nAproboNot
       ENDIF
*>>>>FIN LOCALIZACION DEL CODIGO

*>>>>LOCALIZACION DEL CODIGO
       IF lLocCodigo('nCodigoApr','APR',nCodApr)

	  IF APR->lAproboApr
	     cAprobo := 'aprob¢'
	  ELSE
	     cAprobo := 'no aprob¢'
	  ENDIF

       ELSE
	  cAprobo := 'promoci¢n no definida'
       ENDIF
*>>>>FIN LOCALIZACION DEL CODIGO

*>>>>LOCALIZACION DEL CODIGO
       IF lLocCodigo('cCodigoGru','GRU',cCodGru)
	  cNomNiv := ALLTRIM(GRU->cNombreGru)
	  cNivEdu := ALLTRIM(GRU->cNivEduGru)
       ELSE
	  cNomNiv := 'REVISAR'
	  cNivEdu := 'REVISAR'
       ENDIF
*>>>>FIN LOCALIZACION DEL CODIGO

*>>>>CIERRE DE ARCHIVOS
       CloseDbf('ANO')
       CloseDbf('TCO')
       CloseDbf('NIV')
       CloseDbf('GRU')
       CloseDbf('MAT')
       CloseDbf('APR')
       CloseDbf('PLA')
       CloseDbf('NOT')

       RETURN !lHayErr
*>>>>FIN CIERRE DE ARCHIVOS