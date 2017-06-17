/*              SIMASOFT. SISTEMAS INTEGRADOS MULTIUSUARIOS AVANZADOS
			BIBLIOTECA GENERAL DE FUNCIONES
	  FUNCIONES PARA GENERAR CODIGO PARA MANTENIMIENTO DE UN ARCHIVO

/*************************************************************************
* TITULO..: CREACION DE LA ESTRUCTURA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 20/2004 MIE A
       Colombia, Bucaramanga        INICIO: 12:00 AM   OCT 20/2004 MIE

OBJETIVOS:

1- Crea la estructura del archivo

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbf(nHandle,fArchvo,cNalias)

*>>>>DESCRIPCION DE PARAMETROS
/*     nHandle                              // Manejador del Archivo
       fArchvo                              // Nombre del Archivo
       cNalias                              // Alias del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL aLinTxt := {}                  // L¡nea de Texto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>TITULO DE LA FUNCION
       AADD(aLinTxt,"/*************************************************************************")
       AADD(aLinTxt,"* TITULO..: CREACION DE LA ESTRUCTURA                                    *")
       AADD(aLinTxt,"**************************************************************************")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: "+cFecha(DATE(),3)+" "+cDia(DOW(DATE()),3)+" A")
       AADD(aLinTxt,"       Colombia, Bucaramanga        INICIO: "+cHoraSys()+"   "+cFecha(DATE(),3)+" "+cDia(DOW(DATE()),3))
       AADD(aLinTxt,"")
       AADD(aLinTxt,"OBJETIVOS:")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"1- Crea la estructura del archivo")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"2- Retorna NIL")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*------------------------------------------------------------------------*")
       AADD(aLinTxt,"*                              PROGRAMA                                  *")
       AADD(aLinTxt,"*------------------------------------------------------------------------*/")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"FUNCTION CreaDbf"+cNalias+"(lShared,nModCry,PathArc,fArchvo,aStrDbf)")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>DESCRIPCION DE PARAMETROS")
       AADD(aLinTxt,"/*     lShared                              // .T. Sistema Compartido")
       AADD(aLinTxt,"       nModCry                              // Modo de Protecci¢n")
       AADD(aLinTxt,"       PathArc                              // Path del Archivo")
       AADD(aLinTxt,"       fArchvo                              // Nombre del Archivo")
       AADD(aLinTxt,"       aStrDbf                              // Estructura del Archivo */")
       AADD(aLinTxt,"*>>>>FIN DESCRIPCION DE PARAMETROS")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>DECLARACION DE VARIABLES")
       AADD(aLinTxt,"       LOCAL PathAct := ''                  // Path Actual")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       LOCAL aDbfStr := {}                  // Estructura del Archivo")
       AADD(aLinTxt,'*>>>>FIN DECLARACION DE VARIABLES')
       AADD(aLinTxt,"")
*>>>>FIN TITULO DE LA FUNCION

*>>>>CREACION DE LA ESTRUCTURA
       AADD(aLinTxt,"*>>>>DECLARACION DE LA ESTRUCTURA")
       AADD(aLinTxt,SPACE(07)+"AADD(aDbfStr,{'nIdeCod"+cNalias+"','Numeric'  ,16,0}) // Ide del Registro")
       AADD(aLinTxt,SPACE(06)+"*Llave Principal")
       AADD(aLinTxt,"")
       SELECT ARC
       ARC->(DBGOTOP())
       DO WHILE .NOT. ARC->(EOF())
	  AADD(aLinTxt,SPACE(07)+;
		       "AADD(aDbfStr,{'"+ALLTRIM(ARC->Field_Name)+"','"+;
					 cFieldType(ARC->Field_Type)+"',"+;
					 ALLTRIM(STR(ARC->Field_Len,3))+","+;
					 STR(ARC->Field_Dec,1)+"})"+;
					 " // "+ALLTRIM(ARC->cDocCamStr))
	  ARC->(DBSKIP())

       ENDDO
       ARC->(DBGOTOP())
       AADD(aLinTxt,"")
       AADD(aLinTxt,SPACE(07)+"AADD(aDbfStr,{'cNomUsr"+cNalias+"','Character',10,0}) // Nombre del Usuario")
       AADD(aLinTxt,SPACE(07)+"AADD(aDbfStr,{'dFecUsr"+cNalias+"','Date'     ,08,0}) // Fecha del Usuario")
       AADD(aLinTxt,SPACE(07)+"AADD(aDbfStr,{'cHorUsr"+cNalias+"','Character',10,0}) // Hora del Usuario")

       AADD(aLinTxt,"*>>>>FIN CREACION DE LA ESTRUCTURA")
       AADD(aLinTxt,"")
*>>>>DECLARACION DE LA ESTRUCTURA

*>>>>CREACION DEL CUERPO DE LA FUNCION
       AADD(aLinTxt,"*>>>>RETORNO DE LA ESTRUCTURA")
       AADD(aLinTxt,"       IF !EMPTY(aStrDbf)")
       AADD(aLinTxt,"          aStrDbf := aDbfStr")
       AADD(aLinTxt,"          RETURN NIL")
       AADD(aLinTxt,"       ENDIF")
       AADD(aLinTxt,"*>>>>FIN RETORNO DE LA ESTRUCTURA")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>CREACION DE LA ESTRUCTURA")
       AADD(aLinTxt,"       PathAct := cPathAct()")
       AADD(aLinTxt,"       DO CASE")
       AADD(aLinTxt,"       CASE nCd(PathArc) == 0")
       AADD(aLinTxt,"            DBCREATE(fArchvo,aDbfStr,'DBFNTX')")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       CASE nCd(PathArc) == -3")
       AADD(aLinTxt,"            cError('NO EXISTE EL DIRECTORIO: '+PathArc)")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       CASE nCd(PathArc) == -5")
       AADD(aLinTxt,"            cError('NO TIENE DERECHOS EN: '+PathArc)")
       AADD(aLinTxt,"       ENDCASE")
       AADD(aLinTxt,"       nCd(PathAct)")
       AADD(aLinTxt,"       RETURN NIL")
       AADD(aLinTxt,"*>>>>FIN CREACION DE LA ESTRUCTURA")
*>>>>FIN CREACION DEL CUERPO DE LA FUNCION

*>>>>CREACION DE LA LINEAS DE CODIGO
       FOR i := 1 TO LEN(aLinTxt)
	   lSaveTxt(aLinTxt[i],nHandle,fArchvo)
       NEXT
       RETURN NIL
*>>>>FIN CREACION DE LA LINEAS DE CODIGO

/*************************************************************************
* TITULO..: RECUPERACION DE LA ESTRUCTURA                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 20/2004 MIE A
       Colombia, Bucaramanga        INICIO: 03:20 PM   OCT 20/2004 MIE

OBJETIVOS:

1- Recupera la estructura del archivo

2- Retorna NIL


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbf(nHandle,fArchvo,cNalias)

*>>>>DESCRIPCION DE PARAMETROS
/*     nHandle                              // Manejador del Archivo
       fArchvo                              // Nombre del Archivo
       cNalias                              // Alias del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL aLinTxt := {}                  // L¡nea de Texto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE LA FUNCION
       AADD(aLinTxt,"/*************************************************************************")
       AADD(aLinTxt,"* TITULO..: RECUPERACION DE LA ESTRUCTURA                                *")
       AADD(aLinTxt,"**************************************************************************")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: "+cFecha(DATE(),3)+" "+cDia(DOW(DATE()),3)+" A")
       AADD(aLinTxt,"       Colombia, Bucaramanga        INICIO: "+cHoraSys()+"   "+cFecha(DATE(),3)+" "+cDia(DOW(DATE()),3))
       AADD(aLinTxt,"")
       AADD(aLinTxt,"OBJETIVOS:")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"1- Recupera la estructura del archivo")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"2- Retorna NIL")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*------------------------------------------------------------------------*")
       AADD(aLinTxt,"*                              PROGRAMA                                  *")
       AADD(aLinTxt,"*------------------------------------------------------------------------*/")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"FUNCTION RecuDbf"+cNalias+"(lShared,nModCry,PathArc,fArchvo)")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>DESCRIPCION DE PARAMETROS")
       AADD(aLinTxt,"/*     lShared                        // .T. Sistema Compartido")
       AADD(aLinTxt,"       nModCry                        // Modo de Protecci¢n")
       AADD(aLinTxt,"       PathArc			      // Path del Archivo")
       AADD(aLinTxt,"       fArchvo			      // Nombre del Archivo */")
       AADD(aLinTxt,"*>>>>FIN DESCRIPCION DE PARAMETROS")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO")
       AADD(aLinTxt,"       SAVE SCREEN")
       AADD(aLinTxt,"       cError('SE BORRO EL ARCHIVO '+PathArc+'\'+fArchvo,;")
       AADD(aLinTxt,"              'Error Grave. TOME NOTA',;")
       AADD(aLinTxt,"              'Al Presionar Cualquier tecla se crea el archivo')")
       AADD(aLinTxt,"       Termometro(0,'CREANDO LA ESTRUCTURA')")
       AADD(aLinTxt,"       Termometro(100)")
       AADD(aLinTxt,"       CreaDbf"+cNalias+"(lShared,nModCry,PathArc,fArchvo)")
       AADD(aLinTxt,"       RESTORE SCREEN")
       AADD(aLinTxt,"       RETURN NIL")
       AADD(aLinTxt,"*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO")
*>>>>FIN CREACION DE LA FUNCION

*>>>>CREACION DE LA LINEAS DE CODIGO
       FOR i := 1 TO LEN(aLinTxt)
	   lSaveTxt(aLinTxt[i],nHandle,fArchvo)
       NEXT
       RETURN NIL
*>>>>FIN CREACION DE LA LINEAS DE CODIGO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 20/2004 MIE A
       Colombia, Bucaramanga        INICIO: 03:30 PM   OCT 20/2004 MIE

OBJETIVOS:

1- Actualiza la Estructura del Archivo

2- Retorna el N£mero de Error:
   0 => No hay Error
	Estructura Actualizada
	Estructura Sin problemas
   1 => Estructura No Actualizada

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nActStr(nHandle,fArchvo,cNalias)

*>>>>DESCRIPCION DE PARAMETROS
/*     nHandle                              // Manejador del Archivo
       fArchvo                              // Nombre del Archivo
       cNalias                              // Alias del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL aLinTxt := {}                  // L¡nea de Texto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE LA FUNCION
       AADD(aLinTxt,"/*************************************************************************")
       AADD(aLinTxt,"* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *")
       AADD(aLinTxt,"**************************************************************************")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: "+cFecha(DATE(),3)+" "+cDia(DOW(DATE()),3)+" A")
       AADD(aLinTxt,"       Colombia, Bucaramanga        INICIO: "+cHoraSys()+"   "+cFecha(DATE(),3)+" "+cDia(DOW(DATE()),3))
       AADD(aLinTxt,"")
       AADD(aLinTxt,"OBJETIVOS:")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"1- Actualiza la Estructura del Archivo")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"2- Retorna el N£mero de Error:")
       AADD(aLinTxt,"   0 => No hay Error")
       AADD(aLinTxt,"	Estructura Actualizada")
       AADD(aLinTxt,"	Estructura Sin problemas")
       AADD(aLinTxt,"   1 => Estructura No Actualizada")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*------------------------------------------------------------------------*")
       AADD(aLinTxt,"*                              PROGRAMA                                  *")
       AADD(aLinTxt,"*------------------------------------------------------------------------*/")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"FUNCTION nActStr"+cNalias+"(lShared,nModCry,PathArc,cNomArc)")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>DESCRIPCION DE PARAMETROS")
       AADD(aLinTxt,"/*     lShared                              // .T. Sistema Compartido")
       AADD(aLinTxt,"       nModCry                              // Modo de Protecci¢n")
       AADD(aLinTxt,"       PathArc                              // Path del Archivo")
       AADD(aLinTxt,"       cNomArc                              // Nombre del Archivo */")
       AADD(aLinTxt,"*>>>>FIN DESCRIPCION DE PARAMETROS")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>DECLARACION DE VARIABLES")
       AADD(aLinTxt,"       LOCAL cSavPan := ''                  // Salvar Pantalla")
       AADD(aLinTxt,"       LOCAL nNroErr := 0                   // N£mero del Error")
       AADD(aLinTxt,"       LOCAL       i := 0                   // Contador")
       AADD(aLinTxt,"       LOCAL aStrNew := {'1'}               // Estructura Nueva")
       AADD(aLinTxt,"       LOCAL aStrOld := {}                  // Estructura Vieja")
       AADD(aLinTxt,"       LOCAL lCambio := .F.                 // .T. Cambio la Estructura")
       AADD(aLinTxt,"       LOCAL FileTem := ''                  // Archivo temporal")
       AADD(aLinTxt,"*>>>>FIN DECLARACION DE VARIABLES")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>SELECCION DE LAS AREAS DE TRABAJO")
       AADD(aLinTxt,"       IF !lUseDbf(.T.,PathArc+'\'+cNomArc,'ACT',NIL,lShared,nModCry)")
       AADD(aLinTxt,"          cError('ABRIENDO EL ARCHIVO')")
       AADD(aLinTxt,"          CloseDbf('ACT')")
       AADD(aLinTxt,"          RETURN nNroErr := 1")
       AADD(aLinTxt,"       ENDIF")
       AADD(aLinTxt,"       aStrOld := ACT->(DBSTRUCT())")
       AADD(aLinTxt,"       CloseDbf('ACT')")
       AADD(aLinTxt,"       CreaDbf"+cNalias+"(lShared,nModCry,PathArc,cNomArc,@aStrNew)")
       AADD(aLinTxt,"*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>VALIDACION DE LA ESTRUCTURA")
       AADD(aLinTxt,"       lCambio := .T.")
       AADD(aLinTxt,"       IF LEN(aStrNew) == LEN(aStrOld)")
       AADD(aLinTxt,"          lCambio := .F.")
       AADD(aLinTxt,"          nNroErr := 1")
       AADD(aLinTxt,"       ENDIF")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       IF !lCambio")
       AADD(aLinTxt,"          FOR i := 1 TO LEN(aStrNew)")
       AADD(aLinTxt,"              IF UPPER(aStrNew[i,1]) # UPPER(aStrOld[i,1]) .OR.;")
       AADD(aLinTxt,"                 UPPER(SUBS(aStrNew[i,2],1,1)) # UPPER(SUBS(aStrOld[i,2],1,1)) .OR.;")
       AADD(aLinTxt,"                 aStrNew[i,3] # aStrOld[i,3] .OR.;")
       AADD(aLinTxt,"                 aStrNew[i,4] # aStrOld[i,4]")
       AADD(aLinTxt,"                 lCambio := .T.")
       AADD(aLinTxt,"                 EXIT")
       AADD(aLinTxt,"              ENDIF")
       AADD(aLinTxt,"          ENDFOR")
       AADD(aLinTxt,"       ENDIF")
       AADD(aLinTxt,"*>>>>FIN VALIDACION DE LA ESTRUCTURA")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>CONFIRMACION DE LA ACTUALIZACION")
       AADD(aLinTxt,"       IF lCambio .AND. lShared")
       AADD(aLinTxt,"          cError('El Archivo '+cNomArc+' su Estructura Esta DesActualizada.',;")
       AADD(aLinTxt,"          'ATENCION',;")
       AADD(aLinTxt,"          'Para Actualizarla NO Debe Haber Ning£n Usuario en la Red.')")
       AADD(aLinTxt,"          lCambio := lPregunta('DESEA ACTUALIZAR LA ESTRUCTURA? No Si')")
       AADD(aLinTxt,"          IF !lCambio")
       AADD(aLinTxt,"             nNroErr := 1")
       AADD(aLinTxt,"          ENDIF")
       AADD(aLinTxt,"       ENDIF")
       AADD(aLinTxt,"*>>>>FIN CONFIRMACION DE LA ACTUALIZACION")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>ACTUALIZACION DE LA ESTRUCTURA")
       AADD(aLinTxt,"       IF lCambio")
       AADD(aLinTxt,"          FileTem := SUBS(cNomArc,1,AT('.',cNomArc))+'STR'")
       AADD(aLinTxt,"          cSavPan := SAVESCREEN(0,0,24,79)")
       AADD(aLinTxt,"          IF !lStrucFile(lShared,;")
       AADD(aLinTxt,"                         PathArc+'\'+cNomArc,;")
       AADD(aLinTxt,"                         PathArc+'\'+FileTem,;")
       AADD(aLinTxt,"                         {||CreaDbf"+cNalias+"(lShared,nModCry,PathArc,FileTem)})")
       AADD(aLinTxt,"             cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')")
       AADD(aLinTxt,"             nNroErr := 1")
       AADD(aLinTxt,"          ENDIF")
       AADD(aLinTxt,"          RESTSCREEN(0,0,24,79,cSavPan)")
       AADD(aLinTxt,"       ENDIF")
       AADD(aLinTxt,"       RETURN nNroErr")
       AADD(aLinTxt,"*>>>>FIN ACTUALIZACION DE LA ESTRUCTURA")
*>>>>FIN CREACION DE LA FUNCION

*>>>>CREACION DE LA LINEAS DE CODIGO
       FOR i := 1 TO LEN(aLinTxt)
	   lSaveTxt(aLinTxt[i],nHandle,fArchvo)
       NEXT
       RETURN NIL
*>>>>FIN CREACION DE LA LINEAS DE CODIGO

/*************************************************************************
* TITULO..: MANTENIMIENTO DEL ARCHIVO                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 20/2004 MIE A
       Colombia, Bucaramanga        INICIO: 03:45 PM   OCT 20/2004 MIE

OBJETIVOS:

1- Permite el mantenimiento del archivo

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Manten(nHandle,fArchvo,cNalias)

*>>>>DESCRIPCION DE PARAMETROS
/*     nHandle                              // Manejador del Archivo
       fArchvo                              // Nombre del Archivo
       cNalias                              // Alias del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL aLinTxt := {}                  // L¡nea de Texto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE LA FUNCION
       AADD(aLinTxt,"/*************************************************************************")
       AADD(aLinTxt,"* TITULO..: MANTENIMIENTO DEL ARCHIVO                                    *")
       AADD(aLinTxt,"**************************************************************************")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: "+cFecha(DATE(),3)+" "+cDia(DOW(DATE()),3)+" A")
       AADD(aLinTxt,"       Colombia, Bucaramanga        INICIO: "+cHoraSys()+"   "+cFecha(DATE(),3)+" "+cDia(DOW(DATE()),3))
       AADD(aLinTxt,"")
       AADD(aLinTxt,"OBJETIVOS:")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"1- Permite el mantenimiento del archivo")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*------------------------------------------------------------------------*")
       AADD(aLinTxt,"*                              PROGRAMA                                  *")
       AADD(aLinTxt,"*------------------------------------------------------------------------*/")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"FUNCTION Manten"+cNalias+"(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;")
       AADD(aLinTxt,"		   cNomEmp,cNomSec,cNomUsr,cAnoUsr,aArchvo,lPrnArc,;")
       AADD(aLinTxt,"		   cOpcPrn,nCodPrn,lModReg,lDelReg,lInsReg,lHaySql)")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>DESCRIPCION DE PARAMETROS")
       AADD(aLinTxt,"/*     lShared                              // .T. Sistema Compartido")
       AADD(aLinTxt,"       nModCry                              // Modo de Protecci¢n")
       AADD(aLinTxt,"       cNomSis                              // Nombre del Sistema")
       AADD(aLinTxt,"       cCodEmp                              // C¢digo de la Empresa")
       AADD(aLinTxt,"       cNitEmp                              // Nit de la Empresa")
       AADD(aLinTxt,"       cEmpPal                              // Nombre de la Empresa principal")
       AADD(aLinTxt,"       cNomEmp                              // Nombre de la Empresa")
       AADD(aLinTxt,"       cNomSec                              // Nombre de la Empresa Secundario")
       AADD(aLinTxt,"       cNomUsr                              // Nombre del Usuario")
       AADD(aLinTxt,"       cAnoUsr                              // A¤o del usuario")
       AADD(aLinTxt,"       aArchvo                              // Archivos en Uso")
       AADD(aLinTxt,"       lPrnArc                              // .T. Imprimir a Archivo")
       AADD(aLinTxt,"       cOpcPrn                              // Opciones de Impresi¢n")
       AADD(aLinTxt,"       nCodPrn                              // C¢digo de Impresi¢n ")
       AADD(aLinTxt,"       lModReg                              // .T. Modificar el Registro")
       AADD(aLinTxt,"       lDelReg                              // .T. Borrar Registros")
       AADD(aLinTxt,"       lInsReg                              // .T. Insertar Registro")
       AADD(aLinTxt,"       lHaySql                              // .T. Exportar a Sql */")
       AADD(aLinTxt,"*>>>>FIN DESCRIPCION DE PARAMETROS")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>DECLARACION DE VARIABLES")
       AADD(aLinTxt,"       #INCLUDE 'inkey.ch'                  // Declaraci¢n de teclas")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       LOCAL cSavPan := ''                  // Salvar Pantalla")
       AADD(aLinTxt,"       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema")
       AADD(aLinTxt,"       LOCAL lHayErr := .F.                 // .T. Hay Error")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       LOCAL       i := 0                   // Contador")
       AADD(aLinTxt,"       LOCAL lHayPrn := .F.                 // .T. Hay Archivo de Impresi¢n")
       AADD(aLinTxt,"       LOCAL aUseDbf := {}                  // Archivos en Uso")
       AADD(aLinTxt,"       LOCAL fArchvo := ''                  // Nombre del Archivo")
       AADD(aLinTxt,"       LOCAL fNtxArc := ''                  // Archivo Indice")
       AADD(aLinTxt,"       LOCAL cNalias := ''                  // Alias del Archivo")
       AADD(aLinTxt,"       LOCAL oBrowse := NIL                 // Browse")
       AADD(aLinTxt,"*>>>>FIN DECLARACION DE VARIABLES")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>AREAS DE TRABAJO")
       AADD(aLinTxt,"       aUseDbf := {}")
       AADD(aLinTxt,"       FOR i := 1 TO LEN(aArchvo)")
       AADD(aLinTxt,"           fArchvo := aArchvo[i,1]")
       AADD(aLinTxt,"           fNtxArc := aArchvo[i,2]")
       AADD(aLinTxt,"           cNalias := aArchvo[i,3]")
       AADD(aLinTxt,"           AADD(aUseDbf,{.T.,fArchvo,cNalias,fNtxArc,lShared,nModCry})")
       AADD(aLinTxt,"           IF cNalias == 'PRN'")
       AADD(aLinTxt,"              lHayPrn := .T.")
       AADD(aLinTxt,"           ENDIF")
       AADD(aLinTxt,"       ENDFOR")
       AADD(aLinTxt,"*>>>>FIN AREAS DE TRABAJO")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>SELECION DE LAS AREAS DE TRABAJO")
       AADD(aLinTxt,"       IF !lUseDbfs(aUseDbf)")
       AADD(aLinTxt,"          cError('ABRIENDO EL ARCHIVO')")
       AADD(aLinTxt,"          CloseAll()")
       AADD(aLinTxt,"          RETURN NIL")
       AADD(aLinTxt,"       ENDIF")
       AADD(aLinTxt,"*>>>>FIN SELECION DE LAS AREAS DE TRABAJO")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>LOCALIZACION DE LA IMPRESORA")
       AADD(aLinTxt,"       IF lHayPrn")
       AADD(aLinTxt,"          IF !lLocCodigo('nCodigoPrn','PRN',nCodPrn)")
       AADD(aLinTxt,"             cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')")
       AADD(aLinTxt,"             CloseAll()")
       AADD(aLinTxt,"             RETURN NIL")
       AADD(aLinTxt,"          ENDIF")
       AADD(aLinTxt,"       ENDIF")
       AADD(aLinTxt,"*>>>>FIN LOCALIZACION DE LA IMPRESORA")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>PARAMETROS POR DEFECTO")
       AADD(aLinTxt,"       lModReg := IF(EMPTY(lModReg),.F.,lModReg)")
       AADD(aLinTxt,"       lModReg := IF(lModReg .AND. "+UPPER(cNalias)+"->(RECCOUNT())==0,.F.,lModReg)")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       lDelReg := IF(lDelReg==NIL,.F.,lDelReg)")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       lInsReg := IF(lInsReg==NIL,.F.,lInsReg)")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       lHaySql := IF(lHaySql==NIL,.F.,lHaySql)")
       AADD(aLinTxt,"*>>>>FIN PARAMETROS POR DEFECTO")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>MANTENIMIENTO DEL ARCHIVO")
       AADD(aLinTxt,"       oBrowse := oBrwDbf"+cNalias+"(lShared,cNomUsr,cAnoUsr,03,00,22,79,;")
       AADD(aLinTxt,"                             lModReg,lDelReg,lInsReg,lHaySql)")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       SETKEY(K_F2,{||lManReg"+cNalias+"(lShared,cNomUsr,3,oBrowse)})")
       AADD(aLinTxt,"     *ÀConsulta")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       IF lModReg")
       AADD(aLinTxt,"          SETKEY(K_F4,{||lManReg"+cNalias+"(lShared,cNomUsr,2,oBrowse,;")
       AADD(aLinTxt,"                                    "+UPPER(cNalias)+"->"+ARC->Field_Name+")})")
       AADD(aLinTxt,"       ENDIF")
       AADD(aLinTxt,"     *ÀActualizar")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       SETKEY(K_F5,{||Buscar"+cNalias+"(oBrowse)})")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       SETKEY(K_F9,{||MenuOtr"+cNalias+"(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,;")
       AADD(aLinTxt,"                                 cEmpPal,cNomEmp,cNomSec,cNomUsr,cAnoUsr,;")
       AADD(aLinTxt,"                                 aArchvo,lPrnArc,cOpcPrn,nCodPrn,lModReg,;")
       AADD(aLinTxt,"                                 lDelReg,lInsReg,lHaySql,oBrowse)})")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       "+UPPER(cNalias)+"->(CtrlBrw(lShared,oBrowse))")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       SETKEY(K_F2,NIL)")
       AADD(aLinTxt,"       SETKEY(K_F4,NIL)")
       AADD(aLinTxt,"       SETKEY(K_F5,NIL)")
       AADD(aLinTxt,"       SETKEY(K_F9,NIL)")
       AADD(aLinTxt,"       CloseAll()")
       AADD(aLinTxt,"       RETURN NIL")
       AADD(aLinTxt,"*>>>>FIN MANTENIMIENTO DEL ARCHIVO")
*>>>>FIN CREACION DE LA FUNCION

*>>>>CREACION DE LA LINEAS DE CODIGO
       FOR i := 1 TO LEN(aLinTxt)
	   lSaveTxt(aLinTxt[i],nHandle,fArchvo)
       NEXT
       RETURN NIL
*>>>>FIN CREACION DE LA LINEAS DE CODIGO

/*************************************************************************
* TITULO..: DEFINICION DEL OBJETO BROWSE                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 20/2004 MIE A
       Colombia, Bucaramanga        INICIO: 04:00 PM   OCT 20/2004 MIE

OBJETIVOS:

1- Define el objeto Browse del archivo

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oBrwDbf(nHandle,fArchvo,cNalias)

*>>>>DESCRIPCION DE PARAMETROS
/*     nHandle                              // Manejador del Archivo
       fArchvo                              // Nombre del Archivo
       cNalias                              // Alias del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL aLinTxt := {}                  // L¡nea de Texto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE LA FUNCION
       AADD(aLinTxt,"/*************************************************************************")
       AADD(aLinTxt,"* TITULO..: DEFINICION DEL OBJETO BROWSE                                 *")
       AADD(aLinTxt,"**************************************************************************")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: "+cFecha(DATE(),3)+" "+cDia(DOW(DATE()),3)+" A")
       AADD(aLinTxt,"       Colombia, Bucaramanga        INICIO: "+cHoraSys()+"   "+cFecha(DATE(),3)+" "+cDia(DOW(DATE()),3))
       AADD(aLinTxt,"")
       AADD(aLinTxt,"OBJETIVOS:")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"1- Define el objeto Browse del archivo")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"SINTAXIS:")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*------------------------------------------------------------------------*")
       AADD(aLinTxt,"*                              PROGRAMA                                  *")
       AADD(aLinTxt,"*------------------------------------------------------------------------*/")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"FUNCTION oBrwDbf"+cNalias+"(lShared,cNomUsr,cAnoUsr,nFilSup,nColSup,nFilInf,nColInf,;")
       AADD(aLinTxt,"                    lModReg,lDelReg,lInsReg,lHaySql)")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>DESCRIPCION DE PARAMETROS")
       AADD(aLinTxt,"/*     lShared                              // .T. Archivos Compartidos")
       AADD(aLinTxt,"       cNomUsr                              // Nombre del Usuario")
       AADD(aLinTxt,"       cAnoUsr                              // A¤o del Usuario")
       AADD(aLinTxt,"       nFilSup                              // Fila Superior")
       AADD(aLinTxt,"       nColSup                              // Columna Superior")
       AADD(aLinTxt,"       nFilInf                              // Fila Inferior")
       AADD(aLinTxt,"       nColInf                              // Columna Inferior")
       AADD(aLinTxt,"       lModReg                              // .T. Modificar el Registro")
       AADD(aLinTxt,"       lDelReg                              // .T. Borrar Registros")
       AADD(aLinTxt,"       lInsReg                              // .T. Insertar Registros")
       AADD(aLinTxt,"       lHaySql                              // .T. Exportar a Sql */")
       AADD(aLinTxt,"*>>>>FIN DESCRIPCION DE PARAMETROS")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>DECLARACION DE VARIABLES")
       AADD(aLinTxt,"       LOCAL oColumn := NIL                 // Objeto Columna")
       AADD(aLinTxt,"       LOCAL oBrowse := NIL                 // Browse del Archivo")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       LOCAL cTitSup := ''                  // T¡tulo Superior del Browse")
       AADD(aLinTxt,"       LOCAL cTitInf := ''                  // T¡tulo Inferior del Browse")
       AADD(aLinTxt,"*>>>>FIN DECLARACION DE VARIABLES")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>DEFINICION DEL OBJETO BROWSE")
       AADD(aLinTxt,"       oBrowse := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)")
       AADD(aLinTxt,"      *Definici¢n de Objeto y asignaci¢n de las coordenadas")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       oBrowse:ColSep    := '³'")
       AADD(aLinTxt,"       oBrowse:HeadSep   := 'Ä'")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       cTitSup := '<< "+ALLTRIM(ARC->cTitArcStr)+" >>'")
       AADD(aLinTxt,"       cTitInf := '<F2>Consultar <F5>Buscar'+;")
       AADD(aLinTxt,"                   IF(lModReg,' <F4>Actualizar','')+' <F9>Otros'+;")
       AADD(aLinTxt,"                   IF(lDelReg,' <DEL>Borrar','')+;")
       AADD(aLinTxt,"                   IF(lInsReg,' <INS>Incluir','')")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       IF lInsReg")
       AADD(aLinTxt,"          oBrowse:Cargo := {cTitSup,cTitInf,{||lManReg"+cNalias+"(lShared,cNomUsr)}}")
       AADD(aLinTxt,"       ELSE")
       AADD(aLinTxt,"          oBrowse:Cargo := {cTitSup,cTitInf}")
       AADD(aLinTxt,"       ENDIF")
       AADD(aLinTxt,"     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       SELECT "+UPPER(cNalias))
*>>>>FIN CREACION DE LA FUNCION

*>>>>DEFINICION DE LOS CAMPOS BROWSE
       SELECT ARC
       ARC->(DBGOTOP())
       DO WHILE .NOT. ARC->(EOF())

	  AADD(aLinTxt,"       oColumn := TBCOLUMNNEW('"+ALLTRIM(ARC->cTxtBrwStr)+"',{||"+UPPER(cNalias)+"->"+ARC->Field_Name+"})")
	  AADD(aLinTxt,"       oColumn:Cargo := {{'MODI',"+ALLTRIM(ARC->Field_Mod)+"},{'ALIAS','"+UPPER(cNalias)+"'},;")
	  AADD(aLinTxt,"			 {'FIELD','"+ARC->Field_Name+"'},{'PICTURE','"+ALLTRIM(ARC->Field_Pic)+"'}}")
	  AADD(aLinTxt,"       oBrowse:ADDCOLUMN(oColumn)")
	  AADD(aLinTxt,"     *ÀDefinici¢n Columna")
	  AADD(aLinTxt,"")

	  ARC->(DBSKIP())

       ENDDO
       ARC->(DBGOTOP())
*>>>>FIN DEFINICION DE LOS CAMPOS BROWSE

*>>>>CAMPOS GENENERALES
       AADD(aLinTxt,"       oColumn	     := TBCOLUMNNEW('NOMBRE;DEL USUARIO',{||"+UPPER(cNalias)+"->cNomUsr"+cNalias+"})")
       AADD(aLinTxt,"       oColumn:Cargo := {{'MODI',.F.}}")
       AADD(aLinTxt,"       oBrowse:ADDCOLUMN(oColumn)")
       AADD(aLinTxt,"     *ÀDefinici¢n Columna")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       oColumn	     := TBCOLUMNNEW('FECHA DE;PROCESO',;")
       AADD(aLinTxt,"				    {||cFecha("+UPPER(cNalias)+"->dFecUsr"+cNalias+")})")
       AADD(aLinTxt,"       oColumn:Cargo := {{'MODI',.F.}}")
       AADD(aLinTxt,"       oBrowse:ADDCOLUMN(oColumn)")
       AADD(aLinTxt,"     *ÀDefinici¢n Columna")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       oColumn	     := TBCOLUMNNEW('HORA DE;PROCESO',;")
       AADD(aLinTxt,"				    {||cHoraSys("+UPPER(cNalias)+"->cHorUsr"+cNalias+")})")
       AADD(aLinTxt,"       oColumn:Cargo := {{'MODI',.F.}}")
       AADD(aLinTxt,"       oBrowse:ADDCOLUMN(oColumn)")
       AADD(aLinTxt,"     *ÀDefinici¢n Columna")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       oColumn	     := TBCOLUMNNEW('CODIGO',{||"+UPPER(cNalias)+"->nIdeCod"+cNalias+"})")
       AADD(aLinTxt,"       oColumn:Cargo := {{'MODI',.F.}}")
       AADD(aLinTxt,"       oBrowse:ADDCOLUMN(oColumn)")
       AADD(aLinTxt,"     *ÀDefinici¢n Columna")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       oColumn	     := TBCOLUMNNEW('No.',{||"+UPPER(cNalias)+"->(RECNO())})")
       AADD(aLinTxt,"       oColumn:Cargo := {{'MODI',.F.}}")
       AADD(aLinTxt,"       oBrowse:ADDCOLUMN(oColumn)")
       AADD(aLinTxt,"     *ÀDefinici¢n Columna")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       RETURN oBrowse")
       AADD(aLinTxt,"*>>>>FIN DEFINICION DEL OBJETO BROWSE")
*>>>>CAMPOS GENENERALES

*>>>>CREACION DE LA LINEAS DE CODIGO
       FOR i := 1 TO LEN(aLinTxt)
	   lSaveTxt(aLinTxt[i],nHandle,fArchvo)
       NEXT
       RETURN NIL
*>>>>FIN CREACION DE LA LINEAS DE CODIGO

/*************************************************************************
* TITULO..: MANTENIMIENTO DEL REGISTRO                                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 20/2004 MIE A
       Colombia, Bucaramanga        INICIO: 04:30 PM   OCT 20/2004 MIE

OBJETIVOS:

1- Permite inclusi¢n,modificaci¢n y consulta del registro

2- Puede invocarse en la lectura a trav‚s de la clausula VALID

2- Returna .T.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lManReg(nHandle,fArchvo,cNalias)

*>>>>DESCRIPCION DE PARAMETROS
/*     nHandle                              // Manejador del Archivo
       fArchvo                              // Nombre del Archivo
       cNalias                              // Alias del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL aLinTxt := {}                  // L¡nea de Texto
       LOCAL nLenTxt := 0                   // Longitud del Texto
       LOCAL cCampos := ''                  // Campo de Variable
*>>>>FIN DECLARACION DE VARIABLES

*>>>>TITULO DE LA FUNCION
       AADD(aLinTxt,"/*************************************************************************")
       AADD(aLinTxt,"* TITULO..: MANTENIMIENTO DEL REGISTRO                                   *")
       AADD(aLinTxt,"**************************************************************************")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: "+cFecha(DATE(),3)+" "+cDia(DOW(DATE()),3)+" A")
       AADD(aLinTxt,"       Colombia, Bucaramanga        INICIO: "+cHoraSys()+"   "+cFecha(DATE(),3)+" "+cDia(DOW(DATE()),3))
       AADD(aLinTxt,"")
       AADD(aLinTxt,"OBJETIVOS:")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"1- Permite inclusi¢n,modificaci¢n y consulta del registro")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"2- Puede invocarse en la lectura a trav‚s de la clausula VALID")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"2- Returna .T.")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*------------------------------------------------------------------------*")
       AADD(aLinTxt,"*                              PROGRAMA                                  *")
       AADD(aLinTxt,"*------------------------------------------------------------------------*/")
       AADD(aLinTxt,"")
       nLenTxt := LEN(ALLTRIM(ARC->Field_Name))
       AADD(aLinTxt,"FUNCTION lManReg"+cNalias+"(lShared,cNomUsr,nTipMod,oBrowse,"+SUBS(ARC->Field_Name,1,nLenTxt-3)+",nNroOpc)")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>DESCRIPCION DE PARAMETROS")
       AADD(aLinTxt,"/*     lShared                              // .T. Archivos Compartidos")
       AADD(aLinTxt,"       cNomUsr                              // Nombre del Usuario")
       AADD(aLinTxt,"       nTipMod                              // Tipo de Modificaci¢n. 1 =>Insertar, 2=>Modificar 3=>Consultar")
       AADD(aLinTxt,"       xCodigo                              // C¢digo a Ingresar, Actualizar")
       AADD(aLinTxt,"       cTipNit                              // Tipo de Documento")
       AADD(aLinTxt,"       nNroOpc                              // N£mero de Opci¢n")
       AADD(aLinTxt,"       oBrowse                              // Browse del Archivo */")
       AADD(aLinTxt,"*>>>>FIN DESCRIPCION DE PARAMETROS")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>DECLARACION DE VARIABLES")
       AADD(aLinTxt,"       LOCAL cSavPan := ''                  // Salvar Pantalla")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       LOCAL aMenus  := {}                  // Vector de declaracion de men£")
       AADD(aLinTxt,"       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       LOCAL nTipCur := 1                   // Tipo de Cursor")
       AADD(aLinTxt,"       LOCAL nNroFil := 0                   // N£mero de la fila")
       AADD(aLinTxt,"       LOCAL nNroCol := 1                   // N£mero de la Columna")
       AADD(aLinTxt,"       LOCAL nColTem := 0                   // Columna Temporal")
       AADD(aLinTxt,"       LOCAL nFilIni := 0                   // Fila Inicial")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       LOCAL nNroReg := 0                   // N£mero del Registro")
       AADD(aLinTxt,"       LOCAL lGrabar := .T.                 // .T. Grabar el registro")
       AADD(aLinTxt,"       LOCAL lInsReg := .F.                 // .T. Insertar el Registro")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       LOCAL cTxtTem := ''                  // Texto temporal")
       AADD(aLinTxt,"       LOCAL cTxtHlp := ''                  // Texto de Ayuda")
       AADD(aLinTxt,"")
*>>>>FIN TITULO DE LA FUNCION

*>>>>DECLARACION DE VARIABLES DE CAMPO
       SELECT ARC
       ARC->(DBGOTOP())
       DO WHILE .NOT. ARC->(EOF())

	  IF ARC->(RECNO()) # 1
	     nLenTxt := LEN(ALLTRIM(ARC->Field_Name))
	     cCampos := SUBS(ARC->Field_Name,1,nLenTxt-3)+ALLTRIM(ARC->cTemCamStr)
	     AADD(aLinTxt,SPACE(07)+;
			  "LOCAL "+cCampos+cIniCampo(ARC->Field_Type,;
						     ARC->cDocCamStr))
	     IF UPPER(ARC->Field_Type) == 'L'
		AADD(aLinTxt,SPACE(07)+;
			     "LOCAL c"+SUBS(cCampos,2,LEN(cCampos))+;
				       cIniCampo('C',ARC->cDocCamStr))
	     ENDIF
	  ENDIF

	  ARC->(DBSKIP())
       ENDDO
       ARC->(DBGOTOP())
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       LOCAL GetList := {}                 // Variable del sistema")
       AADD(aLinTxt,"*>>>>FIN DECLARACION DE VARIABLES")
       AADD(aLinTxt,"")
*>>>>FIN DECLARACION DE VARIABLES DE CAMPO

*>>>>CREACION DE LA FUNCION No. 1
       AADD(aLinTxt,"*>>>>DECLARACION DEL MENU")
       AADD(aLinTxt,"       nTipMod := IF(nTipMod==NIL,1,nTipMod)")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       AADD(aMenus,'1<INFORMACION BASICA>')")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       AADD(aAyuda,IF(nTipMod==3,'Consulta','Actualiza')+' '+;")
       AADD(aLinTxt,"                   'la Informaci¢n B sica.')")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       cSavPan := SAVESCREEN(0,0,24,79)")
       AADD(aLinTxt,"       nNroOpc := IF(nNroOpc==NIL,1,nNroOpc)")
       AADD(aLinTxt,"       IF EMPTY(nNroOpc)")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"          cSavPan := SAVESCREEN(0,0,24,79)")
       AADD(aLinTxt,"          nNroOpc := 1")
       AADD(aLinTxt,"          nNroOpc := nMenu(aMenus,aAyuda,10,25,;")
       AADD(aLinTxt,"                           IF(nTipMod==3,'CONSULTAR','ACTUALIZAR'),NIL,1,.F.)")
       AADD(aLinTxt,"          RESTSCREEN(0,0,24,79,cSavPan)")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"          IF nNroOpc == 0")
       AADD(aLinTxt,"             RETURN NIL")
       AADD(aLinTxt,"          ENDIF")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       ENDIF")
       AADD(aLinTxt,"*>>>>FIN DECLARACION DEL MENU")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>VALIDACION DE LA INFORMACION BASICA")
       AADD(aLinTxt,"       IF nNroOpc # 1")
       AADD(aLinTxt,"          IF EMPTY(nNroOpc) // Ojo")
       AADD(aLinTxt,"             cError('PRIMERO DEBE ESTAR ACTUALIZADA LA INFORMACION BASICA')")
       AADD(aLinTxt,"             RETURN NIL")
       AADD(aLinTxt,"          ENDIF")
       AADD(aLinTxt,"       ENDIF")
       AADD(aLinTxt,"*>>>>FIN VALIDACION DE LA INFORMACION BASICA")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>MARCO DEL MANTENIMIENTO")
       AADD(aLinTxt,"       nTipCur := SETCURSOR()")
       AADD(aLinTxt,"       DO CASE")
       AADD(aLinTxt,"       CASE nTipMod == 1")
       AADD(aLinTxt,"            cTxtTem := '"+ALLTRIM(ARC->cTitArcStr)+" .INCLUIR. '+aMenus[nNroOpc]")
       AADD(aLinTxt,"            "+UPPER(cNalias)+"->(DBGOBOTTOM())")
       AADD(aLinTxt,"            "+UPPER(cNalias)+"->(DBSKIP())")
       AADD(aLinTxt,"            nTipCur := SETCURSOR(1)")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       CASE nTipMod == 2")
       AADD(aLinTxt,"            cTxtTem := '"+ALLTRIM(ARC->cTitArcStr)+" .ACTUALIZAR. '+aMenus[nNroOpc]")
       AADD(aLinTxt,"            nTipCur := SETCURSOR(1)")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       CASE nTipMod == 3")
       AADD(aLinTxt,"            cTxtTem := '"+ALLTRIM(ARC->cTitArcStr)+". CONSUTA. '+aMenus[nNroOpc]")
       AADD(aLinTxt,"       ENDCASE")
       AADD(aLinTxt,"       nFilIni := nMarco(03,cTxtTem,22,'°')")
       AADD(aLinTxt,"*>>>>FIN MARCO DEL MANTENIMIENTO")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>MANTENIMIENTO DEL REGISTRO")
       AADD(aLinTxt,"       SELECT "+UPPER(cNalias))
       AADD(aLinTxt,"       DO WHILE .T.")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"**********INICIALIZACION DE LAS VARIABLES")
       AADD(aLinTxt,"            IF lGrabar")
*>>>>FIN CREACION DE LA FUNCION No. 1

*>>>>INICIALIZACION DE VARIABLES DE CAMPO
       SELECT ARC
       ARC->(DBGOTOP())
       DO WHILE .NOT. ARC->(EOF())

	  nLenTxt := LEN(ALLTRIM(ARC->Field_Name))
	  cCampos := SUBS(ARC->Field_Name,1,nLenTxt-3)+ALLTRIM(ARC->cTemCamStr)

	  IF ARC->(RECNO()) == 1

	     AADD(aLinTxt,"")
	     AADD(aLinTxt,SPACE(15)+"IF EMPTY("+SUBS(ARC->Field_Name,1,nLenTxt-3)+")")
	     AADD(aLinTxt,SPACE(15)+"   "+SUBS(ARC->Field_Name,1,nLenTxt-3)+" := "+UPPER(cNalias)+"->"+ALLTRIM(ARC->Field_Name))
	     AADD(aLinTxt,SPACE(15)+"ENDIF")
	     AADD(aLinTxt,"")
	  ELSE
	     AADD(aLinTxt,SPACE(15)+cCampos+" := "+UPPER(cNalias)+"->"+ALLTRIM(ARC->Field_Name))
	     IF UPPER(ARC->Field_Type) == 'L'
		AADD(aLinTxt,SPACE(15)+"c"+SUBS(cCampos,2,LEN(cCampos))+" := IF("+cCampos+",'S','N')")
	     ENDIF
	  ENDIF
	  ARC->(DBSKIP())

       ENDDO
       ARC->(DBGOTOP())
       AADD(aLinTxt,"            ENDIF")
       AADD(aLinTxt,"**********FIN INICIALIZACION DE LAS VARIABLES")
       AADD(aLinTxt,"")
*>>>>FIN INICIALIZACION DE VARIABLES DE CAMPO

*>>>>LECTURA DE CADA CAMPO
       SELECT ARC
       ARC->(DBGOTOP())
       DO WHILE .NOT. ARC->(EOF())

	  nLenTxt := LEN(ALLTRIM(ARC->Field_Name))
	  cCampos := SUBS(ARC->Field_Name,1,nLenTxt-3)+ALLTRIM(ARC->cTemCamStr)

	  IF ARC->(RECNO()) == 1

	      AADD(aLinTxt,"**********LECTURA DE CAMPO")
	      AADD(aLinTxt,"            IF nNroOpc == 1")
	      AADD(aLinTxt,"")
	      AADD(aLinTxt,"               nNroFil := nFilIni")
	      AADD(aLinTxt,"               cTxtTem := '"+SUBS(ARC->cTxtGetStr,1,ARC->nLenGetStr)+":'")
	      AADD(aLinTxt,"")
	      AADD(aLinTxt,"               IF nTipMod == 2 .OR. nTipMod == 3 .OR. !EMPTY("+SUBS(ARC->Field_Name,1,nLenTxt-3)+")")
	      AADD(aLinTxt,"                  @ nNroFil,nNroCol SAY cTxtTem")
	      AADD(aLinTxt,"                  @ nNroFil,nNroCol+LEN(cTxtTem)+1 SAY "+SUBS(ARC->Field_Name,1,nLenTxt-3)+" COLOR('I')")
	      AADD(aLinTxt,"               ELSE")
	      AADD(aLinTxt,"                  @ nNroFil,nNroCol SAY cTxtTem;")
	      AADD(aLinTxt,"                                    GET "+SUBS(ARC->Field_Name,1,nLenTxt-3)+" PICT '"+ALLTRIM(ARC->Field_Pic)+"';")
	      AADD(aLinTxt,"                                    VALID !EMPTY("+SUBS(ARC->Field_Name,1,nLenTxt-3)+") .AND.;")
	      AADD(aLinTxt,"                                          !lValCod"+cNalias+"("+SUBS(ARC->Field_Name,1,nLenTxt-3)+")")
	      AADD(aLinTxt,"               ENDIF")
	      AADD(aLinTxt,"")
	      AADD(aLinTxt,"	    ENDIF")
	      AADD(aLinTxt,"**********FIN LECTURA DE CAMPO")

	  ELSE

	      AADD(aLinTxt,"**********LECTURA DE CAMPO")
	      AADD(aLinTxt,"            IF nNroOpc == 1")
	      AADD(aLinTxt,"")
	      AADD(aLinTxt,"               nNroFil++")
	      AADD(aLinTxt,"               nColTem := nNroCol")
	      AADD(aLinTxt,"               cTxtTem := '"+SUBS(ARC->cTxtGetStr,1,ARC->nLenGetStr)+":'")
	      AADD(aLinTxt,"")
	      AADD(aLinTxt,"               IF nTipMod == 3")
	      AADD(aLinTxt,"                  @ nNroFil,nColTem SAY cTxtTem")
	      IF UPPER(ARC->Field_Type) == 'L'
		 AADD(aLinTxt,"                  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY c"+SUBS(cCampos,2,LEN(cCampos))+" COLOR('I')")
	      ELSE
		 AADD(aLinTxt,"                  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY "+cCampos+" COLOR('I')")
	      ENDIF
	      AADD(aLinTxt,"               ELSE")
	      AADD(aLinTxt,"                  @ nNroFil,nColTem SAY cTxtTem;")

	      IF UPPER(ARC->Field_Type) == 'L'
		 AADD(aLinTxt,"                                    GET c"+SUBS(cCampos,2,LEN(cCampos))+" PICT '"+ALLTRIM(ARC->Field_Pic)+"';")
	      ELSE
		 AADD(aLinTxt,"                                    GET "+cCampos+" PICT '"+ALLTRIM(ARC->Field_Pic)+"';")
	      ENDIF

	      IF ARC->Field_Val
		 AADD(aLinTxt,"                                    VALID !EMPTY("+cCampos+");")
	      ELSE
		 IF UPPER(ARC->Field_Type) == 'L'
		    AADD(aLinTxt,"                                    VALID lValSiNo(ROW(),COL()-1,;")
		    nLenTxt := LEN(ALLTRIM(ARC->Field_Name))
		    cCampos := SUBS(ARC->Field_Name,1,nLenTxt-3)+ALLTRIM(ARC->cTemCamStr)
		    AADD(aLinTxt,SPACE(53)+"@c"+SUBS(cCampos,2,LEN(cCampos))+",@"+cCampos+");")
		 ENDIF
	      ENDIF

	      AADD(aLinTxt,"                                    WHEN {||HelpRead('"+ALLTRIM(ARC->cHlpGetStr)+"')}")
	      AADD(aLinTxt,"               ENDIF")
	      AADD(aLinTxt,"")
	      AADD(aLinTxt,"	    ENDIF")
	      AADD(aLinTxt,"**********FIN LECTURA DE CAMPO")

	  ENDIF
	  AADD(aLinTxt,"")

	  ARC->(DBSKIP())

       ENDDO
       ARC->(DBGOTOP())
*>>>>FIN LECTURA DE CADA CAMPO

*>>>>CREACION DE LA FUNCION No. 2
       AADD(aLinTxt,"**********LECTURA DE LOS CAMPOS")
       AADD(aLinTxt,"            IF nTipMod == 3")
       AADD(aLinTxt,"               cPausa()")
       AADD(aLinTxt,"               EXIT")
       AADD(aLinTxt,"            ELSE")
       AADD(aLinTxt,"               READ")
       AADD(aLinTxt,"            ENDIF")
       AADD(aLinTxt,"**********FIN LECTURA DE LOS CAMPOS")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"**********PREGUNTA DE DECISION")
       AADD(aLinTxt,"            DO CASE")
       AADD(aLinTxt,"            CASE LASTKEY() # K_ESC .AND. nTipMod # 3")
       AADD(aLinTxt,"                 IF !lPregunta('DESEA GRABAR? Si No')")
       AADD(aLinTxt,"                    lGrabar := .F.")
       AADD(aLinTxt,"                    LOOP")
       AADD(aLinTxt,"                 ELSE")
       AADD(aLinTxt,"                    lGrabar := .T.")
       AADD(aLinTxt,"                    EXIT")
       AADD(aLinTxt,"                 ENDIF")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"            CASE LASTKEY() == K_ESC")
       AADD(aLinTxt,"                 lGrabar := .F.")
       AADD(aLinTxt,"                 IF !lPregunta('DESEA ABANDONAR? Si No')")
       AADD(aLinTxt,"                    LOOP")
       AADD(aLinTxt,"                 ENDIF")
       AADD(aLinTxt,"                 EXIT")
       AADD(aLinTxt,"            ENDCASE")
       AADD(aLinTxt,"**********FIN PREGUNTA DE DECISION")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       ENDDO")
       AADD(aLinTxt,"*>>>>FIN MANTENIMIENTO DEL REGISTRO")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>GRABACION DEL REGISTRO")
       AADD(aLinTxt,"       SELECT "+UPPER(cNalias))
       AADD(aLinTxt,"       IF nTipMod # 3 .AND. lGrabar")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"          lInsReg := IF(nTipMod == 1,.T.,.F.)")
       AADD(aLinTxt,"          IF "+UPPER(cNalias)+"->(lRegLock(lShared,lInsReg))")
       AADD(aLinTxt,"")
*>>>>FIN CREACION DE LA FUNCION No. 2

*>>>>GRABACION DE LOS CAMPOS
       SELECT ARC
       ARC->(DBGOTOP())
       DO WHILE .NOT. ARC->(EOF())

	  nLenTxt := LEN(ALLTRIM(ARC->Field_Name))
	  cCampos := SUBS(ARC->Field_Name,1,nLenTxt-3)+ALLTRIM(ARC->cTemCamStr)

	  IF ARC->(RECNO()) == 1

	     AADD(aLinTxt,SPACE(13)+"IF lInsReg")
	     AADD(aLinTxt,SPACE(13)+"   REPL "+UPPER(cNalias)+"->nIdeCod"+cNalias+" WITH "+UPPER(cNalias)+"->(RECNO())")
	     AADD(aLinTxt,SPACE(13)+"   REPL "+UPPER(cNalias)+"->"+ALLTRIM(ARC->Field_Name)+" WITH "+SUBS(ARC->Field_Name,1,nLenTxt-3))
	     AADD(aLinTxt,SPACE(13)+"ENDIF")
	     AADD(aLinTxt,"")

	  ELSE
	     AADD(aLinTxt,SPACE(13)+"REPL "+UPPER(cNalias)+"->"+ALLTRIM(ARC->Field_Name)+" WITH "+cCampos)
	  ENDIF

	  ARC->(DBSKIP())

       ENDDO
       ARC->(DBGOTOP())
       AADD(aLinTxt,"")
       AADD(aLinTxt,SPACE(13)+"REPL "+UPPER(cNalias)+"->cNomUsr"+cNalias+" WITH cNomUsr")
       AADD(aLinTxt,SPACE(13)+"REPL "+UPPER(cNalias)+"->dFecUsr"+cNalias+" WITH DATE()")
       AADD(aLinTxt,SPACE(13)+"REPL "+UPPER(cNalias)+"->cHorUsr"+cNalias+" WITH TIME()")
*>>>>FIN GRABACION DE LOS CAMPOS

*>>>>CREACION DE LA FUNCION No. 2
       AADD(aLinTxt,"             "+UPPER(cNalias)+"->(DBCOMMIT())")
       AADD(aLinTxt,"          ENDIF")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"          IF lShared")
       AADD(aLinTxt,"             "+UPPER(cNalias)+"->(DBUNLOCK())")
       AADD(aLinTxt,"          ENDIF")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       ENDIF")
       AADD(aLinTxt,"       RESTSCREEN(0,0,24,79,cSavPan)")
       AADD(aLinTxt,"       SETCURSOR(nTipCur)")
       AADD(aLinTxt,"*>>>>FIN GRABACION DEL REGISTRO")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>REFRESCAR EL BROWSE")
       AADD(aLinTxt,"       IF nTipMod == 2")
       AADD(aLinTxt,"          nNroReg := "+UPPER(cNalias)+"->(RECNO())")
       AADD(aLinTxt,"          "+UPPER(cNalias)+"->(DBGOTOP())")
       AADD(aLinTxt,"          oBrowse:GOTOP()")
       AADD(aLinTxt,"          "+UPPER(cNalias)+"->(DBGOTO(nNroReg))")
       AADD(aLinTxt,"          oBrowse:FORCESTABLE()")
       AADD(aLinTxt,"       ENDIF")
       AADD(aLinTxt,"       RETURN .T.")
       AADD(aLinTxt,"*>>>>FIN REFRESCAR EL BROWSE")
*>>>>FIN CREACION DE LA FUNCION No. 2

*>>>>CREACION DE LA LINEAS DE CODIGO
       FOR i := 1 TO LEN(aLinTxt)
	   lSaveTxt(aLinTxt[i],nHandle,fArchvo)
       NEXT
       RETURN NIL
*>>>>FIN CREACION DE LA LINEAS DE CODIGO

/*************************************************************************
* TITULO..: VALIDACION DE EXISTENCIA DEL CODIGO                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 20/2004 MIE A
       Colombia, Bucaramanga        INICIO: 06:45 PM   OCT 20/2004 MIE

OBJETIVOS:

1- Debe estar en uso el archivo.

2- Realiza la validaci¢n de existencia del C¢digo.

3- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValCod(nHandle,fArchvo,cNalias)

*>>>>DESCRIPCION DE PARAMETROS
/*     nHandle                              // Manejador del Archivo
       fArchvo                              // Nombre del Archivo
       cNalias                              // Alias del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL aLinTxt := {}                  // L¡nea de Texto
       LOCAL nLenTxt := 0                   // Longitud del Texto
       LOCAL cCampos := ''                  // Campo de Variable
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE LA FUNCION
       AADD(aLinTxt,"/*************************************************************************")
       AADD(aLinTxt,"* TITULO..: VALIDACION DE EXISTENCIA DEL CODIGO                          *")
       AADD(aLinTxt,"**************************************************************************")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: "+cFecha(DATE(),3)+" "+cDia(DOW(DATE()),3)+" A")
       AADD(aLinTxt,"       Colombia, Bucaramanga        INICIO: "+cHoraSys()+"   "+cFecha(DATE(),3)+" "+cDia(DOW(DATE()),3))
       AADD(aLinTxt,"")
       AADD(aLinTxt,"OBJETIVOS:")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"1- Debe estar en uso el archivo.")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"2- Realiza la validaci¢n de existencia del C¢digo.")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"3- Retorna .T. si hay problemas")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"SINTAXIS:")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*------------------------------------------------------------------------*")
       AADD(aLinTxt,"*                              PROGRAMA                                  *")
       AADD(aLinTxt,"*------------------------------------------------------------------------*/")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"FUNCTION lValCod"+cNalias+"(cCodigo)")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>DESCRIPCION DE PARAMETROS")
       AADD(aLinTxt,"/*     cCodigo                              // C¢digo a Validar */")
       AADD(aLinTxt,"*>>>>FIN DESCRIPCION DE PARAMETROS")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>DECLARACION DE VARIABLES")
       AADD(aLinTxt,"       LOCAL lHayErr := .F.                 // .T. Hay Error")
       AADD(aLinTxt,"*>>>>FIN DECLARACION DE VARIABLES")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>VALIDACION DEL CODIGO")
       AADD(aLinTxt,"       IF cCodigo # cSpaces('"+UPPER(cNalias)+"','"+ALLTRIM(ARC->Field_Name)+"')")
       AADD(aLinTxt,"          IF lLocCodigo('"+ALLTRIM(ARC->Field_Name)+"','"+UPPER(cNalias)+"',cCodigo)")
       AADD(aLinTxt,"             cError('ESTE CODIGO YA EXISTE')")
       AADD(aLinTxt,"             lHayErr := .T.")
       AADD(aLinTxt,"          ENDIF")
       AADD(aLinTxt,"       ENDIF")
       AADD(aLinTxt,"       RETURN lHayErr")
       AADD(aLinTxt,"*>>>>FIN VALIDACION DEL CODIGO")
*>>>>FIN CREACION DE LA FUNCION

*>>>>CREACION DE LA LINEAS DE CODIGO
       FOR i := 1 TO LEN(aLinTxt)
	   lSaveTxt(aLinTxt[i],nHandle,fArchvo)
       NEXT
       RETURN NIL
*>>>>FIN CREACION DE LA LINEAS DE CODIGO

/*************************************************************************
* TITULO..: BUSQUEDA DEL CODIGO                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 20/2004 MIE A
       Colombia, Bucaramanga        INICIO: 07:00 PM   OCT 20/2004 MIE

OBJETIVOS:

1- Permite localizar un c¢digo dentro del archivo.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Buscar(nHandle,fArchvo,cNalias)

*>>>>DESCRIPCION DE PARAMETROS
/*     nHandle                              // Manejador del Archivo
       fArchvo                              // Nombre del Archivo
       cNalias                              // Alias del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL aLinTxt := {}                  // L¡nea de Texto
       LOCAL nLenTxt := 0                   // Longitud del Texto
       LOCAL cCampos := ''                  // Campo de Variable
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE LA FUNCION
       nLenTxt := LEN(ALLTRIM(ARC->Field_Name))
       cCampos := SUBS(ARC->Field_Name,2,nLenTxt-4)

       AADD(aLinTxt,"/*************************************************************************")
       AADD(aLinTxt,"* TITULO..: BUSQUEDA DEL CODIGO                                          *")
       AADD(aLinTxt,"**************************************************************************")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: "+cFecha(DATE(),3)+" "+cDia(DOW(DATE()),3)+" A")
       AADD(aLinTxt,"       Colombia, Bucaramanga        INICIO: "+cHoraSys()+"   "+cFecha(DATE(),3)+" "+cDia(DOW(DATE()),3))
       AADD(aLinTxt,"")
       AADD(aLinTxt,"OBJETIVOS:")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"1- Permite localizar un c¢digo dentro del archivo.")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"2- Retorna NIL")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*------------------------------------------------------------------------*")
       AADD(aLinTxt,"*                              PROGRAMA                                  *")
       AADD(aLinTxt,"*------------------------------------------------------------------------*/")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"FUNCTION Buscar"+cNalias+"(oBrowse)")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>DESCRIPCION DE PARAMETROS")
       AADD(aLinTxt,"/*     oBrowse                              // Browse del Archivo */")
       AADD(aLinTxt,"*>>>>FIN DESCRIPCION DE PARAMETROS")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>DECLARACION DE VARIABLES")
       AADD(aLinTxt,"       LOCAL nNroFil := 0                   // Fila de lectura")
       AADD(aLinTxt,"       LOCAL nNroCol := 0                   // Columna de lectura")
       AADD(aLinTxt,"       LOCAL nNroReg := 0                   // N£mero del Registro")
       AADD(aLinTxt,"       LOCAL lBuscar := .T.                 // .T. Realizar la b£squeda")
       AADD(aLinTxt,"       LOCAL GetList := {}                  // Variable del sistema")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       LOCAL cCodigo := ''                  // C¢digo de b£squeda")
       AADD(aLinTxt,"*>>>>FIN DECLARACION DE VARIABLES")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>CAPTURA DEL CODIGO")
       AADD(aLinTxt,"       SET CURSOR ON")
       AADD(aLinTxt,"       cCodigo := cSpaces('"+UPPER(cNalias)+"','"+ALLTRIM(ARC->Field_Name)+"')")
       AADD(aLinTxt,"       TitBuscar(LEN(cCodigo),@nNroFil,@nNroCol)")
       AADD(aLinTxt,"       @ nNroFil,nNroCol GET cCodigo PICT '@!';")
       AADD(aLinTxt,"			 VALID lVal"+cNalias+"(ROW(),COL()-3,@cCodigo)")
       AADD(aLinTxt,"       READ")
       AADD(aLinTxt,"*>>>>FIN CAPTURA DEL CODIGO")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>VALIDACION DEL CODIGO")
       AADD(aLinTxt,"       IF cCodigo == cSpaces('"+UPPER(cNalias)+"','"+ALLTRIM(ARC->Field_Name)+"')")
       AADD(aLinTxt,"          cError('PATRON DE BUSQUEDA NO ESPECIFICADO',;")
       AADD(aLinTxt,"                 'ADVERTENCIA')")
       AADD(aLinTxt,"          lBuscar := .F.")
       AADD(aLinTxt,"       ENDIF")
       AADD(aLinTxt,"*>>>>FIN VALIDACION DEL CODIGO")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>BUSQUEDA DEL CODIGO")
       AADD(aLinTxt,"       SELECT "+UPPER(cNalias))
       AADD(aLinTxt,"       IF lBuscar .AND. lLocCodigo('"+ALLTRIM(ARC->Field_Name)+"','"+UPPER(cNalias)+"',cCodigo)")
       AADD(aLinTxt,"          nNroReg := "+UPPER(cNalias)+"->(RECNO())")
       AADD(aLinTxt,"          "+UPPER(cNalias)+"->(DBGOTOP())")
       AADD(aLinTxt,"          oBrowse:GOTOP()")
       AADD(aLinTxt,"          "+UPPER(cNalias)+"->(DBGOTO(nNroReg))")
       AADD(aLinTxt,"          oBrowse:FORCESTABLE()")
       AADD(aLinTxt,"       ELSE")
       AADD(aLinTxt,"          oBrowse:GOTOP()")
       AADD(aLinTxt,"       ENDIF")
       AADD(aLinTxt,"       RETURN NIL")
       AADD(aLinTxt,"*>>>>FIN BUSQUEDA DEL CODIGO")
*>>>>FIN CREACION DE LA FUNCION

*>>>>CREACION DE LA LINEAS DE CODIGO
       FOR i := 1 TO LEN(aLinTxt)
	   lSaveTxt(aLinTxt[i],nHandle,fArchvo)
       NEXT
       RETURN NIL
*>>>>FIN CREACION DE LA LINEAS DE CODIGO

/*************************************************************************
* TITULO..: VALIDACION DEL CODIGO                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 20/2004 MIE A
       Colombia, Bucaramanga        INICIO: 07:20 PM   OCT 20/2004 MIE

OBJETIVOS:

1- Debe estar en uso el archivo

2- Realiza la validaci¢n del c¢digo

3- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lVal(nHandle,fArchvo,cNalias)

*>>>>DESCRIPCION DE PARAMETROS
/*     nHandle                              // Manejador del Archivo
       fArchvo                              // Nombre del Archivo
       cNalias                              // Alias del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL aLinTxt := {}                  // L¡nea de Texto
       LOCAL nLenTxt := 0                   // Longitud del Texto
       LOCAL cCampos := ''                  // Campo de Variable
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE LA FUNCION
       nLenTxt := LEN(ALLTRIM(ARC->Field_Name))
       cCampos := SUBS(ARC->Field_Name,2,nLenTxt-4)

       AADD(aLinTxt,"/*************************************************************************")
       AADD(aLinTxt,"* TITULO..: VALIDACION DEL CODIGO                                        *")
       AADD(aLinTxt,"**************************************************************************")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: "+cFecha(DATE(),3)+" "+cDia(DOW(DATE()),3)+" A")
       AADD(aLinTxt,"       Colombia, Bucaramanga        INICIO: "+cHoraSys()+"   "+cFecha(DATE(),3)+" "+cDia(DOW(DATE()),3))
       AADD(aLinTxt,"")
       AADD(aLinTxt,"OBJETIVOS:")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"1- Debe estar en uso el archivo")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"2- Realiza la validaci¢n del c¢digo")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"3- Retorna .T. si hay problemas")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"SINTAXIS:")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*------------------------------------------------------------------------*")
       AADD(aLinTxt,"*                              PROGRAMA                                  *")
       AADD(aLinTxt,"*------------------------------------------------------------------------*/")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"FUNCTION lVal"+cNalias+"(nNroFil,nNroCol,cCodigo)")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>DESCRIPCION DE PARAMETROS")
       AADD(aLinTxt,"/*     nNroFil                              // Fila de lectura")
       AADD(aLinTxt,"       nNroCol                              // Columna de lectura")
       AADD(aLinTxt,"       cCodigo                              // C¢digo a Validar */")
       AADD(aLinTxt,"*>>>>FIN DESCRIPCION DE PARAMETROS")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>DECLARACION DE VARIABLES")
       AADD(aLinTxt,"       LOCAL nNroReg := 0                   // N£mero del Registro")
       AADD(aLinTxt,"*>>>>FIN DECLARACION DE VARIABLES")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>VALIDACION DEL CODIGO")
       AADD(aLinTxt,"       IF !lLocCodigo('"+ALLTRIM(ARC->Field_Name)+"','"+UPPER(cNalias)+"',cCodigo)")
       AADD(aLinTxt,"          nNroReg := nSel"+cNalias+"(nNroFil,nNroCol)")
       AADD(aLinTxt,"          IF nNroReg == 0")
       AADD(aLinTxt,"             cCodigo := cSpaces('"+UPPER(cNalias)+"','"+ALLTRIM(ARC->Field_Name)+"')")
       AADD(aLinTxt,"          ELSE")
       AADD(aLinTxt,"             "+UPPER(cNalias)+"->(DBGOTO(nNroReg))")
       AADD(aLinTxt,"             cCodigo := "+UPPER(cNalias)+"->"+ALLTRIM(ARC->Field_Name))
       AADD(aLinTxt,"          ENDIF")
       AADD(aLinTxt,"       ENDIF")
       AADD(aLinTxt,"       RETURN .T.")
       AADD(aLinTxt,"*>>>>FIN VALIDACION DEL CODIGO")
*>>>>FIN CREACION DE LA FUNCION

*>>>>CREACION DE LA LINEAS DE CODIGO
       FOR i := 1 TO LEN(aLinTxt)
	   lSaveTxt(aLinTxt[i],nHandle,fArchvo)
       NEXT
       RETURN NIL
*>>>>FIN CREACION DE LA LINEAS DE CODIGO

/*************************************************************************
* TITULO..: SELECCION DEL CODIGO                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 21/2004 JUE A
       Colombia, Bucaramanga        INICIO: 08:45 AM   OCT 21/2004 JUE

OBJETIVOS:

1- Debe estar en uso el archivo

2- Permite escoger el registro de acuerdo al c¢digo o descripci¢n

3- Retorna el n£mero del registro escogido

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nSel(nHandle,fArchvo,cNalias)

*>>>>DESCRIPCION DE PARAMETROS
/*     nHandle                              // Manejador del Archivo
       fArchvo                              // Nombre del Archivo
       cNalias                              // Alias del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL aLinTxt := {}                  // L¡nea de Texto
       LOCAL nLenTxt := 0                   // Longitud del Texto
       LOCAL cCampos := ''                  // Campo de Variable
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE LA FUNCION
       nLenTxt := LEN(ALLTRIM(ARC->Field_Name))
       cCampos := SUBS(ARC->Field_Name,2,nLenTxt-4)

       AADD(aLinTxt,"/*************************************************************************")
       AADD(aLinTxt,"* TITULO..: SELECCION DEL CODIGO                                         *")
       AADD(aLinTxt,"**************************************************************************")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: "+cFecha(DATE(),3)+" "+cDia(DOW(DATE()),3)+" A")
       AADD(aLinTxt,"       Colombia, Bucaramanga        INICIO: "+cHoraSys()+"   "+cFecha(DATE(),3)+" "+cDia(DOW(DATE()),3))
       AADD(aLinTxt,"")
       AADD(aLinTxt,"OBJETIVOS:")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"1- Debe estar en uso el archivo")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"2- Permite escoger el registro de acuerdo al c¢digo o descripci¢n")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"3- Retorna el n£mero del registro escogido")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"SINTAXIS:")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*------------------------------------------------------------------------*")
       AADD(aLinTxt,"*                              PROGRAMA                                  *")
       AADD(aLinTxt,"*------------------------------------------------------------------------*/")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"FUNCTION nSel"+cNalias+"(nNroFil,nNroCol)")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>DESCRIPCION DE PARAMETROS")
       AADD(aLinTxt,"/*     nNroFil                              // N£mero de la fila")
       AADD(aLinTxt,"       nNroCol                              // N£mero de la Columna */")
       AADD(aLinTxt,"*>>>>FIN DESCRIPCION DE PARAMETROS")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>DECLARACION DE VARIABLES")
       AADD(aLinTxt,"       LOCAL cSavPan := ''                  // Salvar Pantalla")
       AADD(aLinTxt,"       LOCAL nFilSup := 0                   // Fila superior")
       AADD(aLinTxt,"       LOCAL nColSup := 0                   // Colunma superior")
       AADD(aLinTxt,"       LOCAL nFilInf := 0                   // Fila inferior")
       AADD(aLinTxt,"       LOCAL nColInf := 0                   // Columna inferior")
       AADD(aLinTxt,"       LOCAL nNroReg := 0                   // N£mero del Registro")
       AADD(aLinTxt,"*>>>>FIN DECLARACION DE VARIABLES")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS")
       AADD(aLinTxt,"       IF "+UPPER(cNalias)+"->(RECCOUNT()) == 0")
       AADD(aLinTxt,"          cError('NO EXISTEN REGISTROS GRABADOS')")
       AADD(aLinTxt,"          RETURN 0")
       AADD(aLinTxt,"       ENDIF")
       AADD(aLinTxt,"*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>INICIALIZACION DE LAS COORDENADAS")
       AADD(aLinTxt,"       SELECT "+UPPER(cNalias))
       AADD(aLinTxt,"       nFilSup := nNroFil+1")
       AADD(aLinTxt,"       nColSup := nNroCol+2")
       AADD(aLinTxt,"       IF nFilSup+RECCOUNT() > 22")
       AADD(aLinTxt,"          nFilInf := 22")
       AADD(aLinTxt,"       ELSE")
       AADD(aLinTxt,"          nFilInf := nFilSup + RECCOUNT()")
       AADD(aLinTxt,"       ENDIF")
       AADD(aLinTxt,"       nColInf := nColSup+18")
       AADD(aLinTxt,"*>>>>FIN INICIALIZACION DE LAS COORDENADAS")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>SELECCION DEL CODIGO")
       AADD(aLinTxt,"       "+UPPER(cNalias)+"->(DBGOTOP())")
       AADD(aLinTxt,"       cSavPan := SAVESCREEN(0,0,24,79)")
       AADD(aLinTxt,"       @ nFilSup-1,nColSup-1 TO nFilInf,nColInf+1 DOUBLE")
       AADD(aLinTxt,"       nNroReg := nBrowseDbf(nFilSup,nColSup,nFilInf-1,nColInf,;")
       AADD(aLinTxt,"			     {||"+UPPER(cNalias)+"->"+ALLTRIM(ARC->Field_Name)+"})")
       AADD(aLinTxt,"       RESTSCREEN(0,0,24,79,cSavPan)")
       AADD(aLinTxt,"       RETURN nNroReg")
       AADD(aLinTxt,"*>>>>FIN SELECCION DEL CODIGO")
*>>>>FIN CREACION DE LA FUNCION

*>>>>CREACION DE LA LINEAS DE CODIGO
       FOR i := 1 TO LEN(aLinTxt)
	   lSaveTxt(aLinTxt[i],nHandle,fArchvo)
       NEXT
       RETURN NIL
*>>>>FIN CREACION DE LA LINEAS DE CODIGO

/*************************************************************************
* TITULO..: MENU DE OTROS PARA EL ARCHIVO                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 21/2004 JUE A
       Colombia, Bucaramanga        INICIO: 09:00 AM   OCT 21/2004 JUE

OBJETIVOS:

1- Menu de Otros para el archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuOtr(nHandle,fArchvo,cNalias)

*>>>>DESCRIPCION DE PARAMETROS
/*     nHandle                              // Manejador del Archivo
       fArchvo                              // Nombre del Archivo
       cNalias                              // Alias del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL aLinTxt := {}                  // L¡nea de Texto
       LOCAL nLenTxt := 0                   // Longitud del Texto
       LOCAL cCampos  := ''                  // Campo de Variable
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE LA FUNCION
       AADD(aLinTxt,"/*************************************************************************")
       AADD(aLinTxt,"* TITULO..: MENU DE OTROS PARA EL ARCHIVO                                *")
       AADD(aLinTxt,"**************************************************************************")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: "+cFecha(DATE(),3)+" "+cDia(DOW(DATE()),3)+" A")
       AADD(aLinTxt,"       Colombia, Bucaramanga        INICIO: "+cHoraSys()+"   "+cFecha(DATE(),3)+" "+cDia(DOW(DATE()),3))
       AADD(aLinTxt,"")
       AADD(aLinTxt,"OBJETIVOS:")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"1- Menu de Otros para el archivo")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"2- Retorna NIL")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"SINTAXIS:")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*------------------------------------------------------------------------*")
       AADD(aLinTxt,"*                              PROGRAMA                                  *")
       AADD(aLinTxt,"*------------------------------------------------------------------------*/")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"FUNCTION MenuOtr"+cNalias+"(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;")
       AADD(aLinTxt,"                    cNomEmp,cNomSec,cNomUsr,cAnoUsr,aArchvo,lPrnArc,;")
       AADD(aLinTxt,"                    cOpcPrn,nCodPrn,lModReg,lDelReg,lInsReg,lHaySql,;")
       AADD(aLinTxt,"                    oBrowse)")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>DESCRIPCION DE PARAMETROS")
       AADD(aLinTxt,"/*     lShared                              // .T. Sistema Compartido")
       AADD(aLinTxt,"       nModCry                              // Modo de Protecci¢n")
       AADD(aLinTxt,"       cNomSis                              // Nombre del Sistema")
       AADD(aLinTxt,"       cCodEmp                              // C¢digo de la Empresa")
       AADD(aLinTxt,"       cNitEmp                              // Nit de la Empresa")
       AADD(aLinTxt,"       cEmpPal                              // Nombre de la Empresa principal")
       AADD(aLinTxt,"       cNomEmp                              // Nombre de la Empresa")
       AADD(aLinTxt,"       cNomSec                              // Nombre de la Empresa Secundario")
       AADD(aLinTxt,"       cNomUsr                              // Nombre del Usuario")
       AADD(aLinTxt,"       cAnoUsr                              // A¤o del usuario")
       AADD(aLinTxt,"       aArchvo                              // Archivo en Uso")
       AADD(aLinTxt,"       lPrnArc                              // .T. Imprimir a Archivo")
       AADD(aLinTxt,"       cOpcPrn                              // Opciones de Impresi¢n")
       AADD(aLinTxt,"       nCodPrn                              // C¢digo de Impresi¢n")
       AADD(aLinTxt,"       lModReg                              // .T. Modificar el Registro")
       AADD(aLinTxt,"       lDelReg                              // .T. Borrar Registros")
       AADD(aLinTxt,"       lInsReg                              // .T. Insertar Registro")
       AADD(aLinTxt,"       lHaySql                              // .T. Exportar a Sql")
       AADD(aLinTxt,"       oBrowse                              // Browse del Archivo */")
       AADD(aLinTxt,"*>>>>FIN DESCRIPCION DE PARAMETROS")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>DECLARACION DE VARIABLES")
       AADD(aLinTxt,"       LOCAL cSavPan := ''                  // Salvar Pantalla")
       AADD(aLinTxt,"       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema")
       AADD(aLinTxt,"       LOCAL lHayErr := .F.                 // .T. Hay Error")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       LOCAL aMenus  := {}                  // Vector de declaracion de men£")
       AADD(aLinTxt,"       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£")
       AADD(aLinTxt,"       LOCAL nNroOpc := 1                   // Numero de la opcion")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       LOCAL GetList := {}                  // Variable del Sistema")
       AADD(aLinTxt,"*>>>>FIN DECLARACION DE VARIABLES")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>DECLARCION Y EJECUCION DEL MENU")
       AADD(aLinTxt,"       aMenus := {}")
       AADD(aLinTxt,"       AADD(aMenus,'1<"+ALLTRIM(ARC->cTitArcStr)+">')")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       aAyuda := {}")
       AADD(aLinTxt,"       AADD(aAyuda,'Imprime los Detalles del Archivo')")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       cSavPan := SAVESCREEN(0,0,24,79)")
       AADD(aLinTxt,"       nNroOpc := nMenu(aMenus,aAyuda,10,25,'MENU OTROS',NIL,1,.F.)")
       AADD(aLinTxt,"       RESTSCREEN(0,0,24,79,cSavPan)")
       AADD(aLinTxt,"       IF nNroOpc == 0")
       AADD(aLinTxt,"          RETURN NIL")
       AADD(aLinTxt,"       ENDIF")
       AADD(aLinTxt,"*>>>>FIN DECLARCION Y EJECUCION DEL MENU")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>ANALISIS DE OPCION ESCOGIDA")
       AADD(aLinTxt,"       DO CASE")
       AADD(aLinTxt,"       CASE nNroOpc == 1")
       AADD(aLinTxt,"            Otr"+cNalias+"011(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;")
       AADD(aLinTxt,"                      cNomEmp,cNomSec,cNomUsr,cAnoUsr,aArchvo,lPrnArc,;")
       AADD(aLinTxt,"                      cOpcPrn,nCodPrn,lModReg,lDelReg,lInsReg,lHaySql,;")
       AADD(aLinTxt,"                      oBrowse)")
       AADD(aLinTxt,"           *Impresi¢n de los campos del Archivo")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       ENDCASE")
       AADD(aLinTxt,"       RETURN NIL")
       AADD(aLinTxt,"*>>>>FIN ANALISIS DE OPCION ESCOGIDA")
*>>>>FIN CREACION DE LA FUNCION

*>>>>CREACION DE LA LINEAS DE CODIGO
       FOR i := 1 TO LEN(aLinTxt)
	   lSaveTxt(aLinTxt[i],nHandle,fArchvo)
       NEXT
       RETURN NIL
*>>>>FIN CREACION DE LA LINEAS DE CODIGO

/*************************************************************************
* TITULO..: IMPRESION CAMPOS DEL MANTENIMIENTO                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 21/2004 JUE A
       Colombia, Bucaramanga        INICIO: 09:15 AM   OCT 21/2004 JUE

OBJETIVOS:

1- Imprime los campos del archivo de mantenimiento

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Otr011(nHandle,fArchvo,cNalias)

*>>>>DESCRIPCION DE PARAMETROS
/*     nHandle                              // Manejador del Archivo
       fArchvo                              // Nombre del Archivo
       cNalias                              // Alias del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL aLinTxt := {}                  // L¡nea de Texto
       LOCAL nLenTxt := 0                   // Longitud del Texto
       LOCAL nNroCol := 0                   // N£mero de la Columna
       LOCAL cCampos := ''                  // Campo de Variable
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE LA FUNCION No. 1
       AADD(aLinTxt,"/*************************************************************************")
       AADD(aLinTxt,"* TITULO..: IMPRESION CAMPOS DEL MANTENIMIENTO                           *")
       AADD(aLinTxt,"**************************************************************************")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: "+cFecha(DATE(),3)+" "+cDia(DOW(DATE()),3)+" A")
       AADD(aLinTxt,"       Colombia, Bucaramanga        INICIO: "+cHoraSys()+"   "+cFecha(DATE(),3)+" "+cDia(DOW(DATE()),3))
       AADD(aLinTxt,"")
       AADD(aLinTxt,"OBJETIVOS:")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"1- Imprime los campos del archivo de mantenimiento")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"2- Retorna NIL")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"SINTAXIS:")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*------------------------------------------------------------------------*")
       AADD(aLinTxt,"*                              PROGRAMA                                  *")
       AADD(aLinTxt,"*------------------------------------------------------------------------*/")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"FUNCTION Otr"+cNalias+"011(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;")
       AADD(aLinTxt,"              cNomEmp,cNomSec,cNomUsr,cAnoUsr,aArchvo,lPrnArc,;")
       AADD(aLinTxt,"              cOpcPrn,nCodPrn,lModReg,lDelReg,lInsReg,lHaySql,;")
       AADD(aLinTxt,"              oBrowse)")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>DESCRIPCION DE PARAMETROS")
       AADD(aLinTxt,"/*     lShared                              // .T. Sistema Compartido")
       AADD(aLinTxt,"       nModCry                              // Modo de Protecci¢n")
       AADD(aLinTxt,"       cNomSis                              // Nombre del Sistema")
       AADD(aLinTxt,"       cCodEmp                              // C¢digo de la Empresa")
       AADD(aLinTxt,"       cNitEmp                              // Nit de la Empresa")
       AADD(aLinTxt,"       cEmpPal                              // Nombre de la Empresa principal")
       AADD(aLinTxt,"       cNomEmp                              // Nombre de la Empresa")
       AADD(aLinTxt,"       cNomSec                              // Nombre de la Empresa Secundario")
       AADD(aLinTxt,"       cNomUsr                              // Nombre del Usuario")
       AADD(aLinTxt,"       cAnoUsr                              // A¤o del usuario")
       AADD(aLinTxt,"       aArchvo                              // Archivos en Uso")
       AADD(aLinTxt,"       lPrnArc                              // .T. Imprimir a Archivo")
       AADD(aLinTxt,"       cOpcPrn                              // Opciones de Impresi¢n")
       AADD(aLinTxt,"       nCodPrn                              // C¢digo de Impresi¢n")
       AADD(aLinTxt,"       lModReg                              // .T. Modificar el Registro")
       AADD(aLinTxt,"       lDelReg                              // .T. Borrar Registros")
       AADD(aLinTxt,"       lInsReg                              // .T. Insertar Registro")
       AADD(aLinTxt,"       lHaySql                              // .T. Exportar a Sql")
       AADD(aLinTxt,"       oBrowse                              // Browse del Archivo */")
       AADD(aLinTxt,"*>>>>FIN DESCRIPCION DE PARAMETROS")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>DECLARACION DE VARIABLES")
       AADD(aLinTxt,"       LOCAL cSavPan := ''                  // Salvar Pantalla")
       AADD(aLinTxt,"     *ÀVariables generales")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       LOCAL FilePrn := ''                  // Archivo de impresion")
       AADD(aLinTxt,"       LOCAL nRegPrn := 0                   // Registro de Impresi¢n")
       AADD(aLinTxt,"       LOCAL nHanXml := 0                   // Manejador del Archivo")
       AADD(aLinTxt,"       LOCAL cFecPrn := ''                  // @Fecha de Impresi¢n")
       AADD(aLinTxt,"       LOCAL cHorPrn := ''                  // @Hora de Impresi¢n")
       AADD(aLinTxt,"       LOCAL cDiaPrn := ''                  // @D¡a de Impresi¢n")
       AADD(aLinTxt,"       LOCAL nNroPag := 1                   // N£mero de p gina")
       AADD(aLinTxt,"       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho")
       AADD(aLinTxt,"       LOCAL nLinTot := 0                   // L¡neas totales de control")
       AADD(aLinTxt,"       LOCAL nTotReg := 0                   // Total de registros")
       AADD(aLinTxt,"       LOCAL aCabPrn := {}                  // Encabezado del informe General")
       AADD(aLinTxt,"       LOCAL aCabeza := {}                  // Encabezado del informe")
       AADD(aLinTxt,"       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales")
       AADD(aLinTxt,"       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales")
       AADD(aLinTxt,"       LOCAL aNroCol := {}                  // Columnas de impresi¢n")
       AADD(aLinTxt,"       LOCAL aTitPrn := {}                  // T¡tulos para impresi¢n")
       AADD(aLinTxt,"       LOCAL aRegPrn := {}                  // Registros para impresi¢n")
       AADD(aLinTxt,"       LOCAL cCabCol := ''                  // Encabezado de Columna")
       AADD(aLinTxt,"       LOCAL aCabSec := {}                  // Encabezado Secundario")
       AADD(aLinTxt,"       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n")
       AADD(aLinTxt,"       LOCAL lCentra := .F.                 // .T. Centrar el informe")
       AADD(aLinTxt,"       LOCAL nColCab := 0                   // Columna del encabezado")
       AADD(aLinTxt,"       LOCAL bPagina := NIL                 // Block de P gina")
       AADD(aLinTxt,"       LOCAL bCabeza := NIL                 // Block de Encabezado")
       AADD(aLinTxt,"       LOCAL bDerAut := NIL                 // Block Derechos de Autor")
       AADD(aLinTxt,"       LOCAL nLinReg := 1                   // L¡neas del registro")
       AADD(aLinTxt,"       LOCAL cTxtPrn := ''                  // Texto de impresi¢n")
       AADD(aLinTxt,"       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n")
       AADD(aLinTxt,"     *ÀVariables de informe")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       LOCAL nAvance := 0                   // Avance de registros")
       AADD(aLinTxt,"       LOCAL Getlist := {}                  // Variable del sistema")
       AADD(aLinTxt,"     *ÀVariables espec¡ficas")
       AADD(aLinTxt,"*>>>>FIN DECLARACION DE VARIABLES")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>ACTIVACION DE LA IMPRESORA")
       AADD(aLinTxt,"       nRegPrn := PRN->(RECNO())")
       AADD(aLinTxt,"       nLenPrn := PCL('n17Stan')")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       IF lPrnArc")
       AADD(aLinTxt,"          SET DEVICE TO PRINT")
       AADD(aLinTxt,"       ELSE")
       AADD(aLinTxt,"          FilePrn := '"+cNalias+"'")
       AADD(aLinTxt,"          nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,cOpcPrn,.F.,.T.)")
       AADD(aLinTxt,"          IF EMPTY(nOpcPrn)")
       AADD(aLinTxt,"             RETURN NIL")
       AADD(aLinTxt,"          ENDIF")
       AADD(aLinTxt,"       ENDIF")
       AADD(aLinTxt,"*>>>>FIN ACTIVACION DE LA IMPRESORA")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>DEFINICION DEL ENCABEZADO")
       AADD(aLinTxt,"       nNroPag := 0")
       AADD(aLinTxt,"       lTamAnc := .F.")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       nTotReg := 0")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       aCabPrn := {cNomEmp,cNomSis,;")
       AADD(aLinTxt,"                   '"+ALLTRIM(ARC->cTitArcStr)+"',;")
       AADD(aLinTxt,"                   '',;")
       AADD(aLinTxt,"                   ''}")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;")
       AADD(aLinTxt,"                   nNroPag++,;")
       AADD(aLinTxt,"                   cTotPagina(nTotReg),lTamAnc}")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       cCodIni := PCL({'DraftOn','Elite','CondenOn'})")
       AADD(aLinTxt,"       cCodFin := PCL({'NegraOf','DobGolOf'})")
       AADD(aLinTxt,"*>>>>FIN DEFINICION DEL ENCABEZADO")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>ENCABEZADOS DE COLUMNA")
*>>>>FIN CREACION DE LA FUNCION No. 1

*>>>>ENCABEZADOS DE COLUMNA
       AADD(aLinTxt,SPACE(07)+"aNroCol := {}")
       AADD(aLinTxt,SPACE(07)+"aTitPrn := {}")
       AADD(aLinTxt,"")

       SELECT ARC
       ARC->(DBGOTOP())
       DO WHILE .NOT. ARC->(EOF())

	  nLenTxt := LEN(ALLTRIM(ARC->cTitPrnStr))
	  IF nLenTxt > ARC->Field_Len
	     IF ARC->Field_Type == 'D'
		IF nLenTxt > 12
		   nNroCol := IF(lPar(nLenTxt),nLenTxt,nLenTxt+1)
		ELSE
		   nNroCol := 12
		ENDIF
	     ELSE
		nNroCol := IF(lPar(nLenTxt),nLenTxt,nLenTxt+1)
	     ENDIF
	     AADD(aLinTxt,SPACE(07)+"AADD(aNroCol,"+ALLTRIM(STR(nNroCol,2))+")")
	  ELSE
	     IF ARC->Field_Len == 12 .AND. ARC->Field_Dec == 2
		nNroCol := ARC->Field_Len+2
	     ELSE
		nNroCol := IF(lPar(ARC->Field_Len),ARC->Field_Len,ARC->Field_Len+1)
	     ENDIF
	     AADD(aLinTxt,SPACE(07)+"AADD(aNroCol,"+ALLTRIM(STR(nNroCol,3))+")")
	  ENDIF
	  AADD(aLinTxt,SPACE(07)+"AADD(aTitPrn,'"+ALLTRIM(ARC->cTitPrnStr)+"')")
	  AADD(aLinTxt,"")

	  ARC->(DBSKIP())

       ENDDO
       ARC->(DBGOTOP())
       AADD(aLinTxt,SPACE(07)+"cCabCol := cRegPrint(aTitPrn,aNroCol)")
       AADD(aLinTxt,"*>>>>FIN ENCABEZADOS DE COLUMNA")
       AADD(aLinTxt,"")
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>CREACION DE LA FUNCION No. 2
       AADD(aLinTxt,"*>>>>ANALISIS PARA CENTRAR EL INFORME")
       AADD(aLinTxt,"       lCentra := .F.")
       AADD(aLinTxt,"       nColCab := 0")
       AADD(aLinTxt,"       IF lCentra")
       AADD(aLinTxt,"          nColCab := (nLenPrn-LEN(cCabCol))/2")
       AADD(aLinTxt,"       ENDIF")
       AADD(aLinTxt,"       aCabSec := NIL")
       AADD(aLinTxt,"       bPagina := {||lPagina(nLinReg)}")
       AADD(aLinTxt,"       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;")
       AADD(aLinTxt,"                               nColCab,cCodFin,aCabSec,;")
       AADD(aLinTxt,"                               @cFecPrn,@cHorPrn,@cDiaPrn)}")
       AADD(aLinTxt,"       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}")
       AADD(aLinTxt,"*>>>>FIN ANALISIS PARA CENTRAR EL INFORME")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>IMPRESION DEL ENCABEZADO")
       AADD(aLinTxt,"       SendCodes(PCL('Reset'))")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       EVAL(bCabeza)")
       AADD(aLinTxt,"      *Impresi¢n del Encabezado")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       AADD(aCabPrn,cFecPrn)")
       AADD(aLinTxt,"       AADD(aCabPrn,cHorPrn)")
       AADD(aLinTxt,"       AADD(aCabPrn,cDiaPrn)")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,nOpcPrn,aCabPrn,aTitPrn)")
       AADD(aLinTxt,"*>>>>FIN IMPRESION DEL ENCABEZADO")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>RECORRIDO DE LOS REGISTROS")
       AADD(aLinTxt,"       cSavPan := SAVESCREEN(0,0,24,79)")
       AADD(aLinTxt,"       SET DEVICE TO SCREEN")
       AADD(aLinTxt,"       Termometro(0,'IMPRIMIENDO')")
       AADD(aLinTxt,"       SET DEVICE TO PRINT")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       SELECT "+UPPER(cNalias))
       AADD(aLinTxt,"       "+UPPER(cNalias)+"->(DBGOTOP())")
       AADD(aLinTxt,"       DO WHILE .NOT. "+UPPER(cNalias)+"->(EOF())")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"**********VISUALIZACION DE AVANCE")
       AADD(aLinTxt,"            nAvance := INT(( "+UPPER(cNalias)+"->(RECNO()) / "+UPPER(cNalias)+"->(RECCOUNT()) )*100)")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"            IF STR(nAvance,3) $ '25 50 75100'")
       AADD(aLinTxt,"               SET DEVICE TO SCREEN")
       AADD(aLinTxt,"               Termometro(nAvance)")
       AADD(aLinTxt,"               SET DEVICE TO PRINT")
       AADD(aLinTxt,"            ENDIF")
       AADD(aLinTxt,"**********FIN VISUALIZACION DE AVANCE")
       AADD(aLinTxt,"")
*>>>>CREACION DE LA FUNCION No. 2

*>>>>IMPRESION DEL REGISTRO
       AADD(aLinTxt,"**********IMPRESION DEL REGISTRO")
       AADD(aLinTxt,"            aRegPrn := {}")

       SELECT ARC
       ARC->(DBGOTOP())
       DO WHILE .NOT. ARC->(EOF())

	  AADD(aLinTxt,SPACE(12)+"AADD(aRegPrn,"+;
				       cPrnCampo(ARC->Field_Name,;
						 ARC->Field_Type,;
						 ARC->Field_Len,;
						 ARC->Field_Dec,;
						 UPPER(cNalias))+")")

	  ARC->(DBSKIP())

       ENDDO
       ARC->(DBGOTOP())
       AADD(aLinTxt,"")
       AADD(aLinTxt,"            lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;")
       AADD(aLinTxt,"                    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)")
       AADD(aLinTxt,"**********FIN IMPRESION DEL REGISTRO")
       AADD(aLinTxt,"")
*>>>>FIN IMPRESION DEL REGISTRO

*>>>>CREACION DE LA FUNCION No. 3
       AADD(aLinTxt,"**********AVANCE DEL SIGUIENTE REGISTRO")
       AADD(aLinTxt,"	    SELECT "+UPPER(cNalias))
       AADD(aLinTxt,"	    "+UPPER(cNalias)+"->(DBSKIP())")
       AADD(aLinTxt,"	    IF "+UPPER(cNalias)+"->(EOF())")
       AADD(aLinTxt,"	       SET DEVICE TO SCREEN")
       AADD(aLinTxt,"	       Termometro(100)")
       AADD(aLinTxt,"	       SET DEVICE TO PRINT")
       AADD(aLinTxt,"	    ENDIF")
       AADD(aLinTxt,"**********FIN AVANCE DEL SIGUIENTE REGISTRO")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       ENDDO")
       AADD(aLinTxt,"       RESTSCREEN(0,0,24,79,cSavPan)")
       AADD(aLinTxt,"*>>>>FIN RECORRIDO DE LOS REGISTROS")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"*>>>>IMPRESION DERECHOS")
       AADD(aLinTxt,"       EVAL(bDerAut)")
       AADD(aLinTxt,"      *Derechos de Autor")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       VerPrn(nOpcPrn,FilePrn,nHanXml)")
       AADD(aLinTxt,"       PRN->(DBGOTO(nRegPrn))")
       AADD(aLinTxt,"")
       AADD(aLinTxt,"       SET DEVICE TO SCREEN")
       AADD(aLinTxt,"       RETURN NIL")
       AADD(aLinTxt,"*>>>>FIN IMPRESION DERECHOS")
*>>>>FIN CREACION DE LA FUNCION No. 3

*>>>>CREACION DE LA LINEAS DE CODIGO
       FOR i := 1 TO LEN(aLinTxt)
	   lSaveTxt(aLinTxt[i],nHandle,fArchvo)
       NEXT
       RETURN NIL
*>>>>FIN CREACION DE LA LINEAS DE CODIGO

/*************************************************************************
* TITULO ..: INICIALIZACION DE LOS CAMPOS                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 21/2004 VIE A
       Colombia, Bucaramanga        INICIO: 08:30 PM   OCT 21/2004 VIE

OBJETIVOS:

1- Retorna la inicializaci¢n de la Variable de acuerdo a su tipo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cIniCampo(Field_Type,cDocCam)

*>>>>DESCRIPCION DE PARAMETROS
/*     Field_Type                           // Tipo del Campo
       cDocCam                              // Documentaci¢n del Campo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cIniCam := ''                  // Inicializaci¢n del Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE DECISION
       DO CASE
       CASE UPPER(Field_Type) == 'C'
	    cIniCam := " := ''"
	    cIniCam += SPACE(15)+'// '+cDocCam

       CASE UPPER(Field_Type) == 'N'
	    cIniCam := ' := 0'
	    cIniCam += SPACE(16)+'// '+cDocCam

       CASE UPPER(Field_Type) == 'L'
	    cIniCam := ' := .F. '
	    cIniCam += SPACE(13)+'// '+cDocCam

       CASE UPPER(Field_Type) == 'D'
	    cIniCam := " := CTOD('00/00/00')"
	    cIniCam += SPACE(03)+'// '+cDocCam

       ENDCASE
       RETURN cIniCam
*>>>>FIN ANALISIS DE DECISION

/*************************************************************************
* TITULO ..: CAMPO PARA IMPRESION                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 21/2004 VIE A
       Colombia, Bucaramanga        INICIO: 09:15 PM   OCT 21/2004 VIE

OBJETIVOS:

1- Retorna la campo para poderlo imprimirlo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cPrnCampo(Field_Name,Field_Type,Field_Len,Field_Dec,cNalias)

*>>>>DESCRIPCION DE PARAMETROS
/*     Field_Name                           // Nombre del Campo
       Field_Type                           // Tipo de Campo
       Field_Len                            // Longitud del Campo
       Field_Dec                            // N£mero de decimales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cPrnCam := ''                  // Inicializaci¢n del Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE DECISION
       DO CASE
       CASE UPPER(Field_Type) == 'C'
	    cPrnCam := cNalias+'->'+ALLTRIM(Field_Name)

       CASE UPPER(Field_Type) == 'N'
	    IF Field_Len == 12 .AND. Field_Dec == 2
	       cPrnCam := "TRANS("+cNalias+"->"+ALLTRIM(Field_Name)+",'###,###,###.99')"
	    ELSE
	       cPrnCam := 'STR('+cNalias+'->'+ALLTRIM(Field_Name)+','+;
				      ALLTRIM(STR(Field_Len,3))+','+;
				      ALLTRIM(STR(Field_Dec,3))+')'
	    ENDIF

       CASE UPPER(Field_Type) == 'L'
	    cPrnCam := "IF("+cNalias+"->"+ALLTRIM(Field_Name)+",'SI','NO')"

       CASE UPPER(Field_Type) == 'D'
	    cPrnCam := "cFecha("+cNalias+"->"+ALLTRIM(Field_Name)+")"

       ENDCASE
       RETURN cPrnCam
*>>>>FIN ANALISIS DE DECISION