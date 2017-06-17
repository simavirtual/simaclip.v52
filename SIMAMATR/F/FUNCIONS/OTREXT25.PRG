/*************************************************************************
* TITULO ..: REPORTE DE MATRICULAS PARA LA DIAN                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 04/2017 JUE A
       Colombia, Bucaramanga        INICIO: 07:00 AM   MAY 04/2017 JUE

OBJETIVOS:

1- Generar un archivo .csv con los pagos de matriculas que figura en el
   extracto.

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION FOtrExt25(aP1,aP2,aP3,;
		   cNroMes,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1			            // Parametros Generales
       aP2			            // Parametros Generales
       aP3			            // Parametros Generales
       cNroMes                              // N£mero del Mes
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION PARAMETROS GENERALES
       #INCLUDE "CAMPOS\ARC-MATR.PRG"       // Archivos del Sistema

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
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL nCodigo := 0                   // Codigo del Concepto
       LOCAL nNroAlu := 0                   // N£mero de Estudiantes
     *ÀVariables espec¡ficas

       LOCAL nNroArc := 0                   // N£mero del Archivo
       LOCAL cRegTxt := ''                  // Texto del registro
       LOCAL nByeWri := 0                   // Bytes Escritos
       LOCAL lGraReg := .F.                 // Grabar el Registro
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cDocPad := ''                  // N£mero del Documento
       LOCAL cAp1Pad := ''                  // Primer apellido
       LOCAL cAp2Pad := ''                  // Segundo apellido
       LOCAL cNo1Pad := ''                  // Primer Nombre
       LOCAL cNo2Pad := ''                  // Segundo Nombre
       LOCAL cDirPad := ''                  // Direccion del Padre
       LOCAL cCiuPad := ''                  // Ciudad del Padre
       LOCAL cDepPad := ''                  // Departamento del Padre

       LOCAL cDocMad := ''                  // N£mero del Documento
       LOCAL cAp1Mad := ''                  // Primer apellido
       LOCAL cAp2Mad := ''                  // Segundo apellido
       LOCAL cNo1Mad := ''                  // Primer Nombre
       LOCAL cNo2Mad := ''                  // Segundo Nombre
       LOCAL cDirMad := ''                  // Direccion de la Madre
       LOCAL cCiuMad := ''                  // Ciudad de la Madre
       LOCAL cDepMad := ''                  // Departamento de la Madre

       LOCAL cDocNit := ''                  // Documento de Identidad
       LOCAL cApeUno := ''                  // Primer Apellido
       LOCAL cApeDos := ''                  // Segundo Apellido
       LOCAL cNomUno := ''                  // Primer Nombre
       LOCAL cNomDos := ''                  // Segundo Nombre
       LOCAL cDirecc := ''                  // Direccion de la Casa
       LOCAL cCiudad := ''                  // Ciudad de la Direcci¢n
       LOCAL cDepart := ''                  // Departamento de la Direcci¢n

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathUno+'\'+PathSis+'\'+FilePer,'PER',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO PERSONAS')
	  CLOSE PER
	  RETURN NIL
       ENDIF
*>>>>FIN AREAS DE TRABAJO

*>>>>LECTURA DEL CODIGO
       cSavPan := SAVESCREEN(0,0,24,79)
       SET CURSOR ON
       nCodigo := 9999
       TitBuscar(2,@nNroFil,@nNroCol)
       @ nNroFil,nNroCol GET nCodigo PICT '9999';
			 VALID lValidaCmv(ROW(),COL()-1,@nCodigo)
       READ
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN LECTURA DEL CODIGO

*>>>>ANALISIS DE DECISION
       lHayErr := .T.
       DO CASE
       CASE !(CMV->nCodigoCmv == 4 .OR. CMV->nCodCmvCmv == 4)

	    cError('SOLO SE ADMITEN CONCEPTOS DE MATRICULAS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CLOSE PER
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>ANALISIS DEL A¥O DEL MAESTRO DE ESTUDIANTES
       IF EMPTY(ANO->cAnoAluAno)
	  IF !lPregunta(ALLTRIM(CMV->cNombreCmv)+' '+;
			cAnoUsr+'.DESEA CONTINUAR? Si No')
	     CLOSE PER
	     RETURN NIL
	  ENDIF
       ELSE
	  IF !lPregunta(ALLTRIM(CMV->cNombreCmv)+' '+;
			ANO->cAnoAluAno+'.DESEA CONTINUAR? Si No')
	     CLOSE PER
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN ANALISIS DEL A¥O DEL MAESTRO DE ESTUDIANTES

*>>>>CREACION DEL ARCHIVO
       FileTem = 'mt'+cNroMes+ALLTRIM(STR(nCodigo,4))+'.csv'
       nNroArc := FCREATE(PathDoc+'\'+FileTem,0)
       IF nNroArc == -1
	  CLOSE PER
	  cError('NO SE PUEDE CREAR EL ARCHIVO '+FileOnl)
	  RETURN NIL
       ENDIF
*>>>>FIN CREACION DEL ARCHIVO

*>>>>GRABACION DEL REGISTRO
     cRegTxt := "CCAMPO1;CCAMPO2;CCAMPO3;CCAMPO4;CCAMPO5;CCAMPO6;"+;
		"CCAMPO7;CCAMPO8;CCAMPO9;CCAMPO10;CCAMPO11;CCAMPO12;"+;
		"CCAMPO13;CCAMPO14;CCAMPO15;CCAMPO16"+CHR(13)+CHR(10)

     nByeWri := FWRITE(nNroArc,cRegTxt,LEN(cRegTxt))
     IF nByeWri # LEN(cRegTxt)
	CLOSE PER
	cError('GRABACION DEL REGISTRO')
	RETURN NIL
     ENDIF
*>>>>FIN GRABACION DEL REGISTRO

*>>>>RECORRIDO DEL EXTRACTO
       SELECT TRA
       TRA->(DBGOTOP())
       DO WHILE .NOT. TRA->(EOF())

**********ANALISIS DE DECISION
	    IF TRA->nCodigoCmv # nCodigo

	       TRA->(DBSKIP())
	       LOOP

	    ENDIF
**********FIN ANALISIS DE DECISION

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('REFERENCIA: '+TRA->cCodRefTra+'º'+;
			'MOVIMIENTOS: '+STR(TRA->(RECNO()),5)+'/'+;
					STR(TRA->(RECCOUNT()),5),;
					cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********ANALISIS DE DECISION
	    cCodigoTes := SUBS(TRA->cCodRefTra,1,6)
	    IF !lSekCodMae(cCodigoTes,cMaeAlu,@cMaeAct)

	       cError(cCodigoTes+' NO FIGURA MATRICULADO')

	       TRA->(DBSKIP())
	       LOOP

	    ENDIF
	    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			  RTRIM(&cMaeAct->cNombreEst)
**********FIN ANALISIS DE DECISION

**********INFORMACION DEL PADRE Y MADRE
	    cDocPad := ''
	    cAp1Pad := ''
	    cAp2Pad := ''
	    cNo1Pad := ''
	    cNo2Pad := ''
	    cDirPad := ''
	    cCiuPad := ''
	    cDepPad := ''
	  *ÀInformaci¢n del padre

	    cDocMad := ''
	    cAp1Mad := ''
	    cAp2Mad := ''
	    cNo1Mad := ''
	    cNo2Mad := ''
	    cDirMad := ''
	    cCiuMad := ''
	    cDepMad := ''
	  *ÀInformaci¢n de la Madre


	    cDocPad := ALLTRIM(&cMaeAct->cPadNitEst)

	    SepararNom(ALLTRIM(&cMaeAct->cApePadEst),;
		       @cAp1Pad,@cAp2Pad)              // Apellidos

	    SepararNom(ALLTRIM(&cMaeAct->cNomPadEst),;
		       @cNo1Pad,@cNo2Pad)              // Nombres

	    cDirPad := ALLTRIM(&cMaeAct->cDirPadEst)+' '+;
		       ALLTRIM(&cMaeAct->cBarPadEst)
	    cCiuPad := &cMaeAct->cCiuPadEst
	    cDepPad := SPACE(01)
	  *ÀInformaci¢n del padre

	   cDocMad := ALLTRIM(&cMaeAct->cMadNitEst)

	   SepararNom(ALLTRIM(&cMaeAct->cApeMadEst),;
		      @cAp1Mad,@cAp2Mad)              // Apellidos

	   SepararNom(ALLTRIM(&cMaeAct->cNomMadEst),;
		      @cNo1Mad,@cNo2Mad)              // Nombres

	   cDirMad := ALLTRIM(&cMaeAct->cDirMadEst)+' '+;
		      ALLTRIM(&cMaeAct->cBarMadEst)
	   cCiuMad := &cMaeAct->cCiuMadEst

	   cDepMad := SPACE(01)
	 *ÀInformaci¢n de la Madre
**********FIN INFORMACION DEL PADRE Y MADRE

**********LOCALIZACION DE PRIMER CONTRATANTE
	    cDocNit := ''
	    cApeUno := ''
	    cApeDos := ''
	    cNomUno := ''
	    cNomDos := ''
	    cDirecc := ''
	    cCiudad := ''
	    cDepart := ''

	    DO CASE

	    CASE EMPTY(&cMaeAct->cNitCo1Est)

		 DO CASE
		 CASE !EMPTY(cDocPad)

		      cDocNit := cDocPad
		      cApeUno := cAp1Pad
		      cApeDos := cAp2Pad
		      cNomUno := cNo1Pad
		      cNomDos := cNo2Pad
		      cDirecc := cDirPad
		      cCiudad := cCiuPad
		      cDepart := cDepPad
		    *ÀPrimer contratante. Padre

		 CASE !EMPTY(cDocMad)

		      cDocNit := cDocMad
		      cApeUno := cAp1Mad
		      cApeDos := cAp2Mad
		      cNomUno := cNo1Mad
		      cNomDos := cNo2Mad
		      cDirecc := cDirMad
		      cCiudad := cCiuMad
		      cDepart := cDepMad
		    *ÀPrimer contratante. Madre

		 OTHERWISE
		      cApeUno := 'C:'+&cMaeAct->cNitCo1Est
		      cApeDos := 'P:'+cDocPad
		      cNomUno := 'M:'+cDocMad
		 ENDCASE


	    CASE ALLTRIM(&cMaeAct->cNitCo1Est) == ALLTRIM(cDocPad)

		 cDocNit := cDocPad
		 cApeUno := cAp1Pad
		 cApeDos := cAp2Pad
		 cNomUno := cNo1Pad
		 cNomDos := cNo2Pad
		 cDirecc := cDirPad
		 cCiudad := cCiuPad
		 cDepart := cDepPad
	       *ÀPrimer contratante. Padre

	    CASE ALLTRIM(&cMaeAct->cNitCo1Est) == ALLTRIM(cDocMad)

		 cDocNit := cDocMad
		 cApeUno := cAp1Mad
		 cApeDos := cAp2Mad
		 cNomUno := cNo1Mad
		 cNomDos := cNo2Mad
		 cDirecc := cDirMad
		 cCiudad := cCiuMad
		 cDepart := cDepMad
	       *ÀPrimer contratante. Madre

	    OTHERWISE

		IF lLocNitPer(&cMaeAct->cNitCo1Est,;
			      &cMaeAct->cTipCo1Est)

		   cDocNit := PER->cDocNitPer
		   cApeUno := PER->cApeUnoPer
		   cApeDos := PER->cApeDosPer
		   cNomUno := PER->cNomUnoPer
		   cNomDos := PER->cNomDosPer
		   cDirecc := ALLTRIM(PER->cDireccPer)+' '+;
			      ALLTRIM(PER->cBarrioPer)
		   cCiudad := PER->cCiudadPer
		   cDepart := SPACE(01)

		ELSE

		   cApeUno := 'C:'+&cMaeAct->cNitCo1Est
		   cApeDos := 'P:'+cDocPad
		   cNomUno := 'M:'+cDocMad

		ENDIF

	    ENDCASE
**********FIN LOCALIZACION DE PRIMER CONTRATANTE

**********SUSTITUCION DE TEXTO
	    IF ";" $ cDirecc
	       DO WHILE AT(";",cDirecc) # 0
		  cDirecc := STUFF(cDirecc,AT(";",cDirecc),1,',')
	       ENDDO
	    ENDIF
**********FIN SUSTITUCION DE TEXTO

**********GRABACION DEL REGISTRO

	    nNroAlu++
	    cRegTxt := STR(nNroAlu,6)+";"+;        // 1
		       cCodigoTes+";"+;            // 2
		       &cMaeAct->cCodigoGru+";"+;  // 3
		       cDocNit+";"+;               // 4
		       cApeUno+";"+;               // 5
		       cApeDos+";"+;               // 6
		       cNomUno+";"+;               // 7
		       cNomDos+";"+;               // 8
		       cDirecc+";"+;               // 9
		       cCiudad+";"+;               // 10
		       cDepart+";"+;               // 11
		       SPACE(01)+";"+;             // 12
		       TRANS(0,"##########")+";"+; // 13
		       TRANS(0,"##########")+";"+; // 14
		       TRANS(0,"##########")+";"+; // 15
		       TRANS(TRA->nValorTra,"##########")+CHR(13)+CHR(10)

	    nByeWri := FWRITE(nNroArc,cRegTxt,LEN(cRegTxt))
	    IF nByeWri # LEN(cRegTxt)
	       cError('GRABACION DEL REGISTRO DEL CODIGO:'+cCodigoTes)
	       RETURN NIL
	    ENDIF
**********FIN GRABACION DEL REGISTRO

	  TRA->(DBSKIP())

       ENDDO
       CLOSE PER
       cError(FileTem+' EN '+PathDoc,'SE CREO EL ARCHIVO:')
       RETURN NIL
*>>>>FIN RECORRIDO DEL EXTRACTO

