/*************************************************************************
* TITULO..: MANTENIMIENTO DEL REGISTRO                                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 11/2004 SAB A
       Colombia, Bucaramanga        INICIO:  5:28 PM   DIC 11/2004 SAB

OBJETIVOS:

1- Permite inclusi¢n,modificaci¢n y consulta del registro

2- Puede invocarse en la lectura a trav‚s de la clausula VALID

2- Returna .T.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lManRegPer(lShared,cNomUsr,nTipMod,oBrowse,cDocNit,nNroOpc,nIdeReg)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cNomUsr                              // Nombre del Usuario
       nTipMod                              // Tipo de Modificaci¢n. 1 =>Insertar, 2=>Modificar 3=>Consultar
       xCodigo                              // C¢digo a Ingresar, Actualizar
       cTipNit                              // Tipo de Documento
       nNroOpc                              // N£mero de Opci¢n
       oBrowse                              // Browse del Archivo
       nIdeReg                              // @Id del Registro */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas

       LOCAL cSavPan := ''                  // Salvar Pantalla

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£

       LOCAL nTipCur := 1                   // Tipo de Cursor
       LOCAL nNroFil := 0                   // N£mero de la fila
       LOCAL nNroCol := 1                   // N£mero de la Columna
       LOCAL nColTem := 0                   // Columna Temporal
       LOCAL nFilIni := 0                   // Fila Inicial

       LOCAL nNroReg := 0                   // N£mero del Registro
       LOCAL lGrabar := .T.                 // .T. Grabar el registro
       LOCAL lInsReg := .F.                 // .T. Insertar el Registro

       LOCAL cTxtTem := ''                  // Texto temporal
       LOCAL cTxtHlp := ''                  // Texto de Ayuda

       LOCAL cTipNitTpe := ''               // Tipo del Documento                                          
       LOCAL cLugNitTpe := ''               // Lugar del Documento                                         
       LOCAL lFotNitTpe := .F.              // Fotocopia del Documento                                     
       LOCAL cFotNitTpe := ''               // Fotocopia del Documento                                     
       LOCAL cApeUnoTpe := ''               // Primer Apellido                                             
       LOCAL cApeDosTpe := ''               // Segundo Apellido                                            
       LOCAL cNomUnoTpe := ''               // Primer Nombre                                               
       LOCAL cNomDosTpe := ''               // Segundo Nombre                                              
       LOCAL dFecNacTpe := CTOD('00/00/00')   // Fecha de nacimiento                                         
       LOCAL cLugNacTpe := ''               // Lugar de nacimiento                                         
       LOCAL lSiQepdTpe := .F.              // .T. Que En la Paz Del señor                                 
       LOCAL cSiQepdTpe := ''               // .T. Que En la Paz Del señor                                 
       LOCAL lSexFemTpe := .F.              // .T. Sexo Femenino .F. Sexo Masculino                        
       LOCAL cSexFemTpe := ''               // .T. Sexo Femenino .F. Sexo Masculino                        
       LOCAL cTipoRhTpe := ''               // Tipo de Sangre                                              
       LOCAL cEstratTpe := ''               // Estrato                                                     
       LOCAL cEstCivTpe := ''               // Estado Civil                                                
       LOCAL cNitPadTpe := ''               // Documento del Padre                                         
       LOCAL cTntPadTpe := ''               // Tipo de Documento del Padre                                 
       LOCAL cNitMadTpe := ''               // Documento de la Madre                                       
       LOCAL cTntMadTpe := ''               // Tipo de Documento de la Madre                               
       LOCAL cNitCmpTpe := ''               // Documento de Compa¤era(o)                                   
       LOCAL cTntCmpTpe := ''               // Tipo de Documento de la Compañera(o)                        
       LOCAL nNroHijTpe := 0                // N£mero de Hijos                                             
       LOCAL nPerCarTpe := 0                // Personas a Cargo                                            
       LOCAL nTotIngTpe := 0                // Total de Ingresos                                           
       LOCAL nTotEgrTpe := 0                // Total de Egresos                                            
       LOCAL cDireccTpe := ''               // Direccion de la Casa                                        
       LOCAL cBarrioTpe := ''               // Barrio de la Direccion                                      
       LOCAL cCiudadTpe := ''               // Ciudad                                                      
       LOCAL cTelefnTpe := ''               // Telefono Casa                                               
       LOCAL cTelFaxTpe := ''               // Telefono Fax de la Casa                                     
       LOCAL cTelCelTpe := ''               // Telefono celular                                            
       LOCAL cBipperTpe := ''               // Biper de la Persona                                         
       LOCAL cTelOtrTpe := ''               // Otros Telefonos de la Persona                               
       LOCAL cUrlWwwTpe := ''               // Sitio de Internet                                           
       LOCAL cMaiUnoTpe := ''               // e-mail 1                                                    
       LOCAL cMaiDosTpe := ''               // e-mail 2                                                    
       LOCAL cMaiTreTpe := ''               // e-mail 3                                                    
       LOCAL cDirEnvTpe := ''               // Direccion de Envio de Correspondencia                       
       LOCAL cBarEnvTpe := ''               // Barrio de Envio de Correspondencia                          
       LOCAL cCiuEnvTpe := ''               // Ciudad de Envio de la Correspondencia                       
       LOCAL cTelEnvTpe := ''               // Telefono Direccion de Correspondencia                       
       LOCAL cFaxEnvTpe := ''               // Fax Direccion de la correspondencia                         
       LOCAL cEmpTraTpe := ''               // Empresa del Trabajo                                         
       LOCAL cCarTraTpe := ''               // Cargo de la Empresa                                         
       LOCAL cDirTraTpe := ''               // Direccion del Trabajo                                       
       LOCAL cBarTraTpe := ''               // Barrio del Trabajo                                          
       LOCAL cCiuTraTpe := ''               // Ciudad del Trabajo                                          
       LOCAL cTelTraTpe := ''               // Telefono del Trabajo                                        
       LOCAL cFaxTraTpe := ''               // Fax del Trabajo                                             
       LOCAL cTeoTraTpe := ''               // Otros Telefonos del Trabajo                                 
       LOCAL nSueldoTpe := 0                // Sueldo                                                      
       LOCAL dIngTraTpe := CTOD('00/00/00')   // Fecha del Ingreso                                           
       LOCAL cTipConTpe := ''               // Tipo de Contrato                                            
       LOCAL cProfesTpe := ''               // Profesion de la Persona                                     

       LOCAL GetList := {}                 // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DEL MENU
       nIdeReg := IF(nIdeReg==NIL,0,nIdeReg)
       nTipMod := IF(nTipMod==NIL,1,nTipMod)

       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := IF(EMPTY(nNroOpc),0,nNroOpc)
       IF EMPTY(nNroOpc)

	  AADD(aMenus,'1<INFORMACION BASICA    >')
	  AADD(aMenus,'2<ENVIO CORRESPONDIENCIA>')
	  AADD(aMenus,'3<E-MAILS E INTERNET    >')
	  AADD(aMenus,'4<INFORMACION FAMILIAR  >')
	  AADD(aMenus,'5<INFORMACION LABORAL   >')

	  AADD(aAyuda,IF(nTipMod==3,'Consulta','Actualiza')+' '+;
		     'la Informaci¢n B sica de la Personal')
	  AADD(aAyuda,IF(nTipMod==3,'Consulta','Actualiza')+' '+;
		     'la Direcci¢n para Envio de Correspondencia')
	  AADD(aAyuda,IF(nTipMod==3,'Consulta','Actualiza')+' '+;
		      'los E-Mail o el Sitio de Internet')
	  AADD(aAyuda,IF(nTipMod==3,'Consulta','Actualiza')+' '+;
		      'Actualiza la Informaci¢n Familiar')
	  AADD(aAyuda,IF(nTipMod==3,'Consulta','Actualiza')+' '+;
		      'la Informaci¢n Laboral')

	  cSavPan := SAVESCREEN(0,0,24,79)
          nNroOpc := 1
          nNroOpc := nMenu(aMenus,aAyuda,10,25,;
          IF(nTipMod==3,'CONSULTAR','ACTUALIZAR'),NIL,1,.F.)
             RESTSCREEN(0,0,24,79,cSavPan)
             IF nNroOpc == 0
		RETURN NIL
             ENDIF
       ENDIF
*>>>>FIN DECLARACION DEL MENU

*>>>>MARCO DEL MANTENIMIENTO
       nTipCur := SETCURSOR()
       DO CASE
       CASE nTipMod == 1
	    cTxtTem := 'PERSONAS. INCLUIR. '+aMenus[nNroOpc]
	    PER->(DBGOBOTTOM())
	    PER->(DBSKIP())
	    nTipCur := SETCURSOR(1)

       CASE nTipMod == 2
	    cTxtTem := 'PERSONAS. ACTUALIZAR. '+aMenus[nNroOpc]
	    nTipCur := SETCURSOR(1)

       CASE nTipMod == 3
	    cTxtTem := 'PERSONAS. CONSULTA. '+aMenus[nNroOpc]
       ENDCASE
       nFilIni := nMarco(03,cTxtTem,22,'°')
*>>>>FIN MARCO DEL MANTENIMIENTO

*>>>>VALIDACION DE LA INFORMACION BASICA
       IF nNroOpc # 1
	  IF EMPTY(PER->cApeUnoPer) .OR. EMPTY(PER->cNomUnoPer)

	     cError('PRIMERO DEBE ESTAR ACTUALIZADA LA INFORMACION BASICA')

	     RESTSCREEN(0,0,24,79,cSavPan)
	     SETCURSOR(nTipCur)

	     IF !EMPTY(oBrowse)
		nNroReg := PER->(RECNO())
		PER->(DBGOTOP())
		oBrowse:GOTOP()
		PER->(DBGOTO(nNroReg))
		oBrowse:FORCESTABLE()
	     ENDIF
	     RETURN NIL

	  ENDIF
       ENDIF
*>>>>FIN VALIDACION DE LA INFORMACION BASICA

*>>>>MANTENIMIENTO DEL REGISTRO
       SET ESCAPE     ON               // Activa <ESC> salida GETS
       SELECT PER
       DO WHILE .T.

**********INICIALIZACION DE LAS VARIABLES
            IF lGrabar

               IF EMPTY(cDocNit)
                  cDocNit := PER->cDocNitPer
               ENDIF

               cTipNitTpe := PER->cTipNitPer
               cLugNitTpe := PER->cLugNitPer
               lFotNitTpe := PER->lFotNitPer
               cFotNitTpe := IF(lFotNitTpe,'S','N')
               cApeUnoTpe := PER->cApeUnoPer
               cApeDosTpe := PER->cApeDosPer
               cNomUnoTpe := PER->cNomUnoPer
               cNomDosTpe := PER->cNomDosPer
               dFecNacTpe := PER->dFecNacPer
               cLugNacTpe := PER->cLugNacPer
               lSiQepdTpe := PER->lSiQepdPer
               cSiQepdTpe := IF(lSiQepdTpe,'S','N')
               lSexFemTpe := PER->lSexFemPer
	       cSexFemTpe := IF(lSexFemTpe,'F','M')
               cTipoRhTpe := PER->cTipoRhPer
               cEstratTpe := PER->cEstratPer
               cEstCivTpe := PER->cEstCivPer
               cNitPadTpe := PER->cNitPadPer
               cTntPadTpe := PER->cTntPadPer
               cNitMadTpe := PER->cNitMadPer
               cTntMadTpe := PER->cTntMadPer
               cNitCmpTpe := PER->cNitCmpPer
               cTntCmpTpe := PER->cTntCmpPer
               nNroHijTpe := PER->nNroHijPer
               nPerCarTpe := PER->nPerCarPer
               nTotIngTpe := PER->nTotIngPer
               nTotEgrTpe := PER->nTotEgrPer
               cDireccTpe := PER->cDireccPer
               cBarrioTpe := PER->cBarrioPer
               cCiudadTpe := PER->cCiudadPer
               cTelefnTpe := PER->cTelefnPer
               cTelFaxTpe := PER->cTelFaxPer
               cTelCelTpe := PER->cTelCelPer
               cBipperTpe := PER->cBipperPer
               cTelOtrTpe := PER->cTelOtrPer
               cUrlWwwTpe := PER->cUrlWwwPer
               cMaiUnoTpe := PER->cMaiUnoPer
               cMaiDosTpe := PER->cMaiDosPer
               cMaiTreTpe := PER->cMaiTrePer
               cDirEnvTpe := PER->cDirEnvPer
               cBarEnvTpe := PER->cBarEnvPer
               cCiuEnvTpe := PER->cCiuEnvPer
               cTelEnvTpe := PER->cTelEnvPer
               cFaxEnvTpe := PER->cFaxEnvPer
               cEmpTraTpe := PER->cEmpTraPer
               cCarTraTpe := PER->cCarTraPer
               cDirTraTpe := PER->cDirTraPer
               cBarTraTpe := PER->cBarTraPer
               cCiuTraTpe := PER->cCiuTraPer
               cTelTraTpe := PER->cTelTraPer
               cFaxTraTpe := PER->cFaxTraPer
               cTeoTraTpe := PER->cTeoTraPer
               nSueldoTpe := PER->nSueldoPer
               dIngTraTpe := PER->dIngTraPer
               cTipConTpe := PER->cTipConPer
               cProfesTpe := PER->cProfesPer
            ENDIF
**********FIN INICIALIZACION DE LAS VARIABLES

**********LECTURA DE CAMPO
	    nNroFil := nFilIni
	    nColTem := nNroCol
	    cTxtTem := 'DOCUMENTO:'

	    IF nTipMod == 2 .OR. nTipMod == 3 .OR. !EMPTY(cDocNit)
	       @ nNroFil,nNroCol SAY cTxtTem
	       @ nNroFil,nNroCol+LEN(cTxtTem)+1 SAY cDocNit COLOR('I')
	    ELSE
	       @ nNroFil,nNroCol SAY cTxtTem;
				 GET cDocNit PICT '9999999999999999';
				 VALID !EMPTY(cDocNit) .AND.;
				       !lValCodPer(cDocNit)
	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    nColTem := nNroCol+30
	    cTxtTem := 'TIPO:'

	    IF nTipMod == 2 .OR. nTipMod == 3
	       @ nNroFil,nColTem SAY cTxtTem
	       @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cTipNitTpe COLOR('I')
	    ELSE
	       @ nNroFil,nColTem SAY cTxtTem;
				 GET cTipNitTpe PICT '9';
				 VALID lValTipDoc(ROW(),COL()-1,@cTipNitTpe,'145') .AND.;
				       !EMPTY(cTipNitTpe);
				 WHEN {||HelpRead('FAVOR INGRESE EL TIPO DE DOCUMENTO')}
	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    nColTem := nNroCol+40
	    cTxtTem := 'DE:'

	    IF nTipMod == 3 .OR. (nTipMod == 2 .AND. nNroOpc # 1)
	       @ nNroFil,nColTem SAY cTxtTem
	       @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cLugNitTpe COLOR('I')
	    ELSE
	       @ nNroFil,nColTem SAY cTxtTem;
				 GET cLugNitTpe PICT '@!';
				 VALID !EMPTY(cLugNitTpe);
				 WHEN {||HelpRead('FAVOR INGRESE EL LUGAR DEL DOCUMENTO')}
	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    nColTem := nNroCol+66
	    cTxtTem := 'FOTOCOPIA?'

	    IF nTipMod == 3 .OR. (nTipMod == 2 .AND. nNroOpc # 1)
	       @ nNroFil-1,nColTem SAY cTxtTem
	       @ nNroFil,nColTem SAY cFotNitTpe COLOR('I')
	    ELSE
	       @ nNroFil-1,nColTem SAY cTxtTem
	       @ nNroFil,nColTem GET cFotNitTpe PICT '@!';
				 VALID lValSiNo(ROW(),COL()-1,;
				       @cFotNitTpe,@lFotNitTpe);
				 WHEN {||HelpRead('FAVOR INGRESE SI EXISTE FOTOCOPIA DEL DOCUMENTO')}
	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    nNroFil += 2
	    nColTem := nNroCol
	    cTxtTem := 'PRIMER APELLIDO:'

	    IF nTipMod == 3 .OR. (nTipMod == 2 .AND. nNroOpc # 1)
	       @ nNroFil,nColTem SAY cTxtTem
	       @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cApeUnoTpe COLOR('I')
	    ELSE
	       @ nNroFil,nColTem SAY cTxtTem;
				   GET cApeUnoTpe PICT '@!';
				   VALID !EMPTY(cApeUnoTpe);
				   WHEN {||HelpRead('FAVOR INGRESE EL PRIMER APELLIDO')}
	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    nColTem := nNroCol+38
	    cTxtTem := 'SEGUNDO APELLIDO:'

	    IF nTipMod == 3 .OR. (nTipMod == 2 .AND. nNroOpc # 1)
	       @ nNroFil,nColTem SAY cTxtTem
	       @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cApeDosTpe COLOR('I')
	    ELSE
	       @ nNroFil,nColTem SAY cTxtTem;
				 GET cApeDosTpe PICT '@!';
				 WHEN {||HelpRead('FAVOR INGRESE EL SEGUNDO APELLIDO')}
	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    nNroFil++
	    nColTem := nNroCol
	    cTxtTem := 'PRIMER NOMBRE:'

	    IF nTipMod == 3 .OR. (nTipMod == 2 .AND. nNroOpc # 1)
	       @ nNroFil,nColTem SAY cTxtTem
	       @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cNomUnoTpe COLOR('I')
	    ELSE
	       @ nNroFil,nColTem SAY cTxtTem;
				 GET cNomUnoTpe PICT '@!';
				 VALID !EMPTY(cNomUnoTpe);
				 WHEN {||HelpRead('FAVOR INGRESE EL PRIMER NOMBRE')}
	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    nColTem := nNroCol+38
	    cTxtTem := 'SEGUNDO NOMBRE:'

	    IF nTipMod == 3 .OR. (nTipMod == 2 .AND. nNroOpc # 1)
	       @ nNroFil,nColTem SAY cTxtTem
	       @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cNomDosTpe COLOR('I')
	    ELSE
	       @ nNroFil,nColTem SAY cTxtTem;
				 GET cNomDosTpe PICT '@!';
				 WHEN {||HelpRead('FAVOR INGRESE EL SEGUNDO NOMBRE')}
	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 1

	       nNroFil += 2
	       nColTem := nNroCol
	       cTxtTem := 'FECHA DE NACIMIENTO:'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY dFecNacTpe COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				    GET dFecNacTpe PICT '@D';
				    WHEN {||HelpRead('FAVOR INGRESE LA FECHA DE NACIMIENTO CON FORMATO MM/DD/AAAA')}
	       ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 1

	       nColTem := nNroCol+32
	       cTxtTem := 'LUGAR:'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cLugNacTpe COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				      GET cLugNacTpe PICT '@!';
				      WHEN {||HelpRead('FAVOR INGRESE EL LUGAR DE NACIMIENTO')}
	       ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 1

	       nNroFil += 2
	       nColTem := nNroCol
	       cTxtTem := 'SEXO:'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cSexFemTpe COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				    GET cSexFemTpe PICT '@!';
				    VALID lValSexo(ROW(),COL()-1,;
					  @cSexFemTpe,@lSexFemTpe);
				    WHEN {||HelpRead('FAVOR INGRESE EL SEXO DE LA PERSONA')}
	       ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 1

	       nColTem := nNroCol+9
	       cTxtTem := 'FALLECIDO:'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cSiQepdTpe COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				    GET cSiQepdTpe PICT '@!';
				    VALID lValSiNo(ROW(),COL()-1,;
					  @cSiQepdTpe,@lSiQepdTpe);
				      WHEN {||HelpRead('FAVOR INGRESE SI LA PERSONA ESTA FALLECIDA')}
	       ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
            IF nNroOpc == 1

	       nColTem := nNroCol+23
	       cTxtTem := 'TIPO DE SANGRE:'

               IF nTipMod == 3
                  @ nNroFil,nColTem SAY cTxtTem
                  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cTipoRhTpe COLOR('I')
               ELSE
                  @ nNroFil,nColTem SAY cTxtTem;
                                    GET cTipoRhTpe PICT '@X!';
                                    WHEN {||HelpRead('FAVOR INGRESE EL TIPO DE SANGRE')}
               ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 1

	       nColTem := nNroCol+45
	       cTxtTem := 'ESTRATO:'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cEstratTpe COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				    GET cEstratTpe PICT '@!';
				    WHEN {||HelpRead('FAVOR INGRESE EL ESTRATO')}
	       ENDIF

	    ENDIF
**********LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 1 .OR. nNroOpc == 2

	       nNroFil += 2
	       nColTem := nNroCol
	       cTxtTem := 'DIRECCION CASA:'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cDireccTpe COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				    GET cDireccTpe PICT '@!';
				    WHEN {||HelpRead('FAVOR INGRESE LA DIRECCION DE LA CASA')}
	       ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 1 .OR. nNroOpc == 2

	       nNroFil++
	       nColTem := nNroCol
	       cTxtTem := 'BARRIO:'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cBarrioTpe;
						   PICT '@!S30' COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				    GET cBarrioTpe PICT '@!S30';
				    WHEN {||HelpRead('FAVOR INGRESE EL BARRIO DE LA DIRECCION')}
	       ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 1 .OR. nNroOpc == 2

	       nColTem := nNroCol+39
	       cTxtTem := 'CIUDAD:'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cCiudadTpe;
						   PICT '@!S30' COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				    GET cCiudadTpe PICT '@!S30';
				    WHEN {||HelpRead('FAVOR INGRESE LA CIUDAD')}
	       ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 1 .OR. nNroOpc == 2

	       nNroFil++
	       nColTem := nNroCol
	       cTxtTem := 'TEL CASA:'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cTelefnTpe COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				    GET cTelefnTpe PICT '99999999999999';
				    WHEN {||HelpRead('FAVOR INGRESE EL TELEFONO DE LA CASA')}
	       ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 1 .OR. nNroOpc == 2

	       nColTem := nNroCol+26
	       cTxtTem := 'FAX CASA:'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cTelFaxTpe COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				    GET cTelFaxTpe PICT '99999999999999';
				    WHEN {||HelpRead('FAVOR INGRESE EL FAX DE LA CASA')}
	       ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 1 .OR. nNroOpc == 2

	       nColTem := nNroCol+51
	       cTxtTem := 'CELULAR:'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cTelCelTpe COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				      GET cTelCelTpe PICT '99999999999999';
				      WHEN {||HelpRead('FAVOR INGRESE EL TELEFONO CELULAR')}
	       ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 1 .OR. nNroOpc == 2

	       nNroFil++
	       nColTem := nNroCol
	       cTxtTem := 'BIPER:'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cBipperTpe COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				    GET cBipperTpe PICT '@!';
				    WHEN {||HelpRead('FAVOR INGRESE EL BIPER DE LA PERSONA')}
	       ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 1 .OR. nNroOpc == 2

	       nColTem := nNroCol+38
	       cTxtTem := 'OTROS TELS:'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cTelOtrTpe;
						       PICT '@!S27' COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				    GET cTelOtrTpe PICT '@!S27';
				    WHEN {||HelpRead('FAVOR INGRESE LOS OTROS TELEFONOS DE LA PERSONA')}
	       ENDIF

	    ENDIF
**********LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 2

	       nNroFil += 2
	       nColTem := nNroCol
	       cTxtTem := 'DIRECCION CORRESPONDENCIA:'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cDirEnvTpe PICT '@!S50' COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				    GET cDirEnvTpe PICT '@!S50';
				    WHEN {||HelpRead('FAVOR INGRESE LA DIRECCION CORRESPONDENCIA')}
	       ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 2

	       nNroFil++
	       nColTem := nNroCol
	       cTxtTem := 'BARRIO:'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cBarEnvTpe;
						   PICT "@!S30" COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				    GET cBarEnvTpe PICT "@!S30";
				    WHEN {||HelpRead('FAVOR INGRESE EL BARRIO DE LA DIRECCION DE ENVIO')}
	       ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 2

	       nColTem := nNroCol+39
	       cTxtTem := 'CIUDAD:'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cCiuEnvTpe;
						   PICT '@!S30' COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				      GET cCiuEnvTpe PICT '@!S30';
				      WHEN {||HelpRead('FAVOR INGRESE LA CIUDAD DE LA DIRECCION DE ENVIO')}
	       ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 2

	       nNroFil++
	       nColTem := nNroCol
	       cTxtTem := 'TELEFONO:'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cTelEnvTpe COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				    GET cTelEnvTpe PICT '99999999999999';
				    WHEN {||HelpRead('FAVOR INGRESE EL TELEFONO DE ENVIO')}
	       ENDIF
	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 2

	       nColTem := nNroCol+26
	       cTxtTem := 'FAX:'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cFaxEnvTpe COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				    GET cFaxEnvTpe PICT '99999999999999';
				    WHEN {||HelpRead('FAVOR INGRESE EL FAX DE LA DIRECCION DE ENVIO')}
	       ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 1 .OR. nNroOpc == 3

	       nNroFil += 2
	       nColTem := nNroCol
	       cTxtTem := 'SITIO DE INTERNET:'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cUrlWwwTpe COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				    GET cUrlWwwTpe PICT '@X';
				    WHEN {||HelpRead('FAVOR INGRESE EL SITIO DE INTERNET')}
	       ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 1 .OR. nNroOpc == 3

	       nNroFil++
	       nColTem := nNroCol
	       cTxtTem := 'E-MAIL No.1:'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cMaiUnoTpe COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				    GET cMaiUnoTpe PICT '@X';
				    WHEN {||HelpRead('FAVOR INGRESE EL E-MAIL No. 1')}
	       ENDIF

	    ENDIF
**********LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 3

	       nNroFil++
	       nColTem := nNroCol
	       cTxtTem := 'E-MAIL No.2:'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cMaiDosTpe COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				    GET cMaiDosTpe PICT 'X';
				    WHEN {||HelpRead('FAVOR INGRESE EL E-MAIL 2')}
	       ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 3

	       nNroFil++
	       nColTem := nNroCol
	       cTxtTem := 'E-MAIL No.3:'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cMaiTreTpe COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				    GET cMaiTreTpe PICT '@X';
				    WHEN {||HelpRead('FAVOR INGRESE EL E-MAIL 3')}
	       ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 4

	       nNroFil += 2
	       nColTem := nNroCol
	       cTxtTem := 'DOCUMENTO DEL PADRE  :'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cNitPadTpe COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				    GET cNitPadTpe PICT '9999999999999999';
				    WHEN {||HelpRead('FAVOR INGRESE EL DOCUMENTO DEL PADRE')}
	       ENDIF
	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 4

	       nColTem := nNroCol+41
	       cTxtTem := 'TIPO:'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cTntPadTpe COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				    GET cTntPadTpe PICT '9';
				    WHEN {||HelpRead('FAVOR INGRESE EL TIPO DE DOCUMENTO DEL PADRE')}
	       ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 4

	       nNroFil++
	       nColTem := nNroCol
	       cTxtTem := 'DOCUMENTO DE LA MADRE:'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cNitMadTpe COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				      GET cNitMadTpe PICT '9999999999999999';
				      WHEN {||HelpRead('FAVOR INGRESE EL DOCUMENTO DE LA MADRE')}
	       ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 4

	       nColTem := nNroCol+41
	       cTxtTem := 'TIPO:'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cTntMadTpe COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				      GET cTntMadTpe PICT '9';
				      WHEN {||HelpRead('FAVOR INGRESE EL TIPO DE DOCUMENTO DE LA MADRE')}
	       ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 4

	       nNroFil += 2
	       nColTem := nNroCol
	       cTxtTem := 'ESTADO CIVIL:'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cEstCivTpe COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				      GET cEstCivTpe PICT '@!';
				      WHEN {||HelpRead('FAVOR INGRESE SU ESTADO CIVIL')}
	       ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 4
	       nNroFil++
	       nColTem := nNroCol
	       cTxtTem := 'DOCUMENTO DE COMPA¥ERA(O):'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cNitCmpTpe COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				    GET cNitCmpTpe PICT '9999999999999999';
				    WHEN {||HelpRead('FAVOR INGRESE EL DOCUMENTO DE LA COMPA¥ERA(O)')}
	       ENDIF
	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 4

	       nColTem := nNroCol+45
	       cTxtTem := 'TIPO:'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cTntCmpTpe COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				    GET cTntCmpTpe PICT '@!';
				    WHEN {||HelpRead('FAVOR INGRESE EL TIPO DE DOCUMENTO DE SU COMPAÑERA(O)')}
	       ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 4

	       nNroFil += 2
	       nColTem := nNroCol
	       cTxtTem := 'NUMERO DE HIJOS :'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY nNroHijTpe COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				      GET nNroHijTpe PICT '99';
				      WHEN {||HelpRead('FAVOR INGRESE EL NUMERO DE HIJOS')}
	       ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 4

	       nNroFil++
	       nColTem := nNroCol
	       cTxtTem := 'PERSONAS A CARGO:'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY nPerCarTpe COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				    GET nPerCarTpe PICT '99';
				    WHEN {||HelpRead('FAVOR INGRESE EL NUMERO DE PERSONAS A CARGO')}
	       ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 4

	       nNroFil += 2
	       nColTem := nNroCol
	       cTxtTem := 'TOTAL DE INGRESOS:'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY nTotIngTpe COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				    GET nTotIngTpe PICT '99999999.99';
				    WHEN {||HelpRead('FAVOR INGRESE EL TOTAL DE INGRESOS')}
	       ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 4

	       nNroFil++
	       nColTem := nNroCol
	       cTxtTem := 'TOTAL DE EGRESOS :'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY nTotEgrTpe COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				    GET nTotEgrTpe PICT '99999999.99';
				    WHEN {||HelpRead('FAVOR INGRESE EL TOTAL DE EGRESOS')}
	       ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 5

	       nNroFil += 2
	       nColTem := nNroCol
	       cTxtTem := 'EMPRESA DEL TRABAJO:'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cEmpTraTpe COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				    GET cEmpTraTpe PICT '@!';
				    WHEN {||HelpRead('FAVOR INGRESE LA EMPRESA DEL TRABAJO')}
	       ENDIF
	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 5

	       nNroFil++
	       nColTem := nNroCol
	       cTxtTem := 'CARGO DE LA EMPRESA:'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cCarTraTpe COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				    GET cCarTraTpe PICT '@!';
				    WHEN {||HelpRead('FAVOR INGRESE EL CARGO DE LA EMPRESA')}
	       ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 5

	       nNroFil += 2
	       nColTem := nNroCol
	       cTxtTem := 'DIRECCION:'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cDirTraTpe COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				      GET cDirTraTpe PICT '@!';
				      WHEN {||HelpRead('FAVOR INGRESE LA DIRECCION DEL TRABAJO')}
	       ENDIF
	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 5

	       nNroFil++
	       nColTem := nNroCol
	       cTxtTem := 'BARRIO:'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cBarTraTpe PICT '@!S30' COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				    GET cBarTraTpe PICT '@!S30';
				    WHEN {||HelpRead('FAVOR INGRESE EL BARRIO DEL TRABAJO')}
	       ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 5

	       nColTem := nNroCol+39
	       cTxtTem := 'CIUDAD:'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cCiuTraTpe PICT '@!S30' COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				    GET cCiuTraTpe PICT '@!S30';
				    WHEN {||HelpRead('FAVOR INGRESE LA CIUDAD DEL TRABAJO')}
	       ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 5

	       nNroFil++
	       nColTem := nNroCol
	       cTxtTem := 'TELEFONO:'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cTelTraTpe COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				    GET cTelTraTpe PICT '99999999999999';
				    WHEN {||HelpRead('FAVOR INGRESE EL TELEFONO DEL TRABAJO')}
	       ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 5

	       nColTem := nNroCol+26
	       cTxtTem := 'FAX:'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cFaxTraTpe COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				    GET cFaxTraTpe PICT '99999999999999';
				    WHEN {||HelpRead('FAVOR INGRESE EL FAX DEL TRABAJO')}
	       ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 5

	       nNroFil++
	       nColTem := nNroCol
	       cTxtTem := 'OTROS TELS:'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cTeoTraTpe COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				      GET cTeoTraTpe PICT '@!';
				      WHEN {||HelpRead('FAVOR INGRESE LOS OTROS TELEFONOS DEL TRABAJO')}
	       ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 5

	       nNroFil += 2
	       nColTem := nNroCol
	       cTxtTem := 'SUELDO:'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY nSueldoTpe COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				    GET nSueldoTpe PICT '99999999.99';
				    WHEN {||HelpRead('FAVOR INGRESE EL SUELDO QUE DEVENGA')}
	       ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 5

	       nColTem := nNroCol+22
	       cTxtTem := 'FECHA DEL INGRESO:'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY dIngTraTpe COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				    GET dIngTraTpe PICT '@D';
				    WHEN {||HelpRead('FAVOR INGRESE LA FECHA DE INGRESO CON FORMATO MM/DD/AAAA')}
	       ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 5

	       nColTem := nNroCol+52
	       cTxtTem := 'TIPO DE CONTRATO:'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cTipConTpe COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				    GET cTipConTpe PICT '@!';
				    WHEN {||HelpRead('FAVOR INGRESE EL TIPO DE CONTRATO')}
	       ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE CAMPO
	    IF nNroOpc == 5

	       nNroFil += 2
	       nColTem := nNroCol
	       cTxtTem := 'PROFESION DE LA PERSONA:'

	       IF nTipMod == 3
		  @ nNroFil,nColTem SAY cTxtTem
		  @ nNroFil,nColTem+LEN(cTxtTem)+1 SAY cProfesTpe COLOR('I')
	       ELSE
		  @ nNroFil,nColTem SAY cTxtTem;
				    GET cProfesTpe PICT '@!';
				    WHEN {||HelpRead('FAVOR INGRESE LA PROFESION DE LA PERSONA')}
	       ENDIF

	    ENDIF
**********FIN LECTURA DE CAMPO

**********LECTURA DE LOS CAMPOS
	    IF nTipMod == 3
	       cPausa()
	       EXIT
	    ELSE
	       READ
	    ENDIF
**********FIN LECTURA DE LOS CAMPOS

**********PREGUNTA DE DECISION
            DO CASE
            CASE LASTKEY() # K_ESC .AND. nTipMod # 3
                 IF !lPregunta('DESEA GRABAR? Si No')
                    lGrabar := .F.
                    LOOP
                 ELSE
                    lGrabar := .T.
                    EXIT
                 ENDIF

            CASE LASTKEY() == K_ESC
                 lGrabar := .F.
                 IF !lPregunta('DESEA ABANDONAR? Si No')
                    LOOP
                 ENDIF
                 EXIT
            ENDCASE
**********FIN PREGUNTA DE DECISION

       ENDDO
*>>>>FIN MANTENIMIENTO DEL REGISTRO

*>>>>GRABACION DEL REGISTRO
       SELECT PER
       IF nTipMod # 3 .AND. lGrabar

          lInsReg := IF(nTipMod == 1,.T.,.F.)
          IF PER->(lRegLock(lShared,lInsReg))

	     nIdeReg := PER->(RECNO())
	     IF lInsReg
		REPL PER->nIdeCodPer WITH nIdeReg
                REPL PER->cDocNitPer WITH cDocNit
             ENDIF

             REPL PER->cTipNitPer WITH cTipNitTpe
             REPL PER->cLugNitPer WITH cLugNitTpe
             REPL PER->lFotNitPer WITH lFotNitTpe
             REPL PER->cApeUnoPer WITH cApeUnoTpe
             REPL PER->cApeDosPer WITH cApeDosTpe
             REPL PER->cNomUnoPer WITH cNomUnoTpe
             REPL PER->cNomDosPer WITH cNomDosTpe
             REPL PER->dFecNacPer WITH dFecNacTpe
             REPL PER->cLugNacPer WITH cLugNacTpe
             REPL PER->lSiQepdPer WITH lSiQepdTpe
             REPL PER->lSexFemPer WITH lSexFemTpe
             REPL PER->cTipoRhPer WITH cTipoRhTpe
             REPL PER->cEstratPer WITH cEstratTpe
             REPL PER->cEstCivPer WITH cEstCivTpe
             REPL PER->cNitPadPer WITH cNitPadTpe
             REPL PER->cTntPadPer WITH cTntPadTpe
             REPL PER->cNitMadPer WITH cNitMadTpe
             REPL PER->cTntMadPer WITH cTntMadTpe
             REPL PER->cNitCmpPer WITH cNitCmpTpe
             REPL PER->cTntCmpPer WITH cTntCmpTpe
             REPL PER->nNroHijPer WITH nNroHijTpe
             REPL PER->nPerCarPer WITH nPerCarTpe
             REPL PER->nTotIngPer WITH nTotIngTpe
             REPL PER->nTotEgrPer WITH nTotEgrTpe
             REPL PER->cDireccPer WITH cDireccTpe
             REPL PER->cBarrioPer WITH cBarrioTpe
             REPL PER->cCiudadPer WITH cCiudadTpe
             REPL PER->cTelefnPer WITH cTelefnTpe
             REPL PER->cTelFaxPer WITH cTelFaxTpe
             REPL PER->cTelCelPer WITH cTelCelTpe
             REPL PER->cBipperPer WITH cBipperTpe
             REPL PER->cTelOtrPer WITH cTelOtrTpe
             REPL PER->cUrlWwwPer WITH cUrlWwwTpe
             REPL PER->cMaiUnoPer WITH cMaiUnoTpe
             REPL PER->cMaiDosPer WITH cMaiDosTpe
             REPL PER->cMaiTrePer WITH cMaiTreTpe
             REPL PER->cDirEnvPer WITH cDirEnvTpe
             REPL PER->cBarEnvPer WITH cBarEnvTpe
             REPL PER->cCiuEnvPer WITH cCiuEnvTpe
             REPL PER->cTelEnvPer WITH cTelEnvTpe
             REPL PER->cFaxEnvPer WITH cFaxEnvTpe
             REPL PER->cEmpTraPer WITH cEmpTraTpe
             REPL PER->cCarTraPer WITH cCarTraTpe
             REPL PER->cDirTraPer WITH cDirTraTpe
             REPL PER->cBarTraPer WITH cBarTraTpe
             REPL PER->cCiuTraPer WITH cCiuTraTpe
             REPL PER->cTelTraPer WITH cTelTraTpe
             REPL PER->cFaxTraPer WITH cFaxTraTpe
             REPL PER->cTeoTraPer WITH cTeoTraTpe
             REPL PER->nSueldoPer WITH nSueldoTpe
             REPL PER->dIngTraPer WITH dIngTraTpe
             REPL PER->cTipConPer WITH cTipConTpe
             REPL PER->cProfesPer WITH cProfesTpe

             REPL PER->cNomUsrPer WITH cNomUsr
             REPL PER->dFecUsrPer WITH DATE()
	     REPL PER->cHorUsrPer WITH TIME()

             PER->(DBCOMMIT())
          ENDIF

          IF lShared
             PER->(DBUNLOCK())
          ENDIF

       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
       SETCURSOR(nTipCur)
*>>>>FIN GRABACION DEL REGISTRO

*>>>>REFRESCAR EL BROWSE
       IF nTipMod == 2 .AND. !EMPTY(oBrowse)
	  nNroReg := PER->(RECNO())
          PER->(DBGOTOP())
          oBrowse:GOTOP()
          PER->(DBGOTO(nNroReg))
          oBrowse:FORCESTABLE()
       ENDIF
       SET ESCAPE     OFF              // DesActiva <ESC> salida GETS
       RETURN .T.
*>>>>FIN REFRESCAR EL BROWSE

/*************************************************************************
* TITULO..: VALIDACION DEL DOCUMENTO                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 06/2004 LUN A
       Colombia, Bucaramanga        INICIO: 03:00 PM   OCT 06/2004 LUN

OBJETIVOS:

1- Debe estar en uso el archivo.

2- Valida si el documento del proveedor existe como Empresa o como persona

3- Retorna .T. si el documento existe.

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValDoc(cDocNit,cTipNit,cNalias)

*>>>>DESCRIPCION DE PARAMETROS
/*     cDocNit			            // N£mero del Documento
       cTipNit                              // Tipo del Documento
       cNalias                              // @Alias del Archivo del Documento */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lExiste := .F.                 // .T. Existe el c¢digo
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cCampo  := ''                  // Nombre del Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DEL DOCUMENTO
       cNalias := ''
       DO CASE
       CASE cTipNit == '1' .OR.;  // Cedula
	    cTipNit == '4' .OR.;  // Cedula de Estranjeria,
	    cTipNit == '5'        // N£mero £nico de identificaci¢n personal

	    cCampo  := 'cDocNitPer'
	    cNalias := 'PER'

       CASE cTipNit == '2' .OR.;  // Nits Empresariales
	    cTipNit == '3'        // Nits de Extranjeria

	    cCampo  := 'cDocNitEmp'
	    cNalias := 'EMP'
       ENDCASE
*>>>>FIN ANALISIS DEL DOCUMENTO

*>>>>VALIDACION DE EXISTENCIA
       IF !EMPTY(cNalias)
	  IF lLocCodigo(cCampo,cNalias,cDocNit)
	     lExiste := .T.
	  ENDIF
       ENDIF
       RETURN lExiste
*>>>>FIN VALIDACION DE EXISTENCIA

/*************************************************************************
* TITULO..: LOCALIZAR POR DOCUMENTO DE IDENTIDAD                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 15/2004 JUE A
       Colombia, Bucaramanga        INICIO: 10:10 PM   JUL 15/2004 JUE

OBJETIVOS:

1- Permite localizar la persona por documento de identidad.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lLocNitPer(cDocNit,cTipNit,lMensaj)

*>>>>DESCRIPCION DE PARAMETROS
/*     cDocNit                              // Documento de Identidad
       cTipNit                              // Tipo de Documento
       lMensaj                              // .T. Mostrar mensaje error */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lExiste := .T.                 // .T. Existe el c¢digo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION DEL CODIGO
       lMensaj := IF(lMensaj == NIL,.F.,lMensaj)

       SELECT PER
       PER->(DBGOTOP())
       LOCATE FOR PER->cDocNitPer == cDocNit .AND.;
		  PER->cTipNitPer == cTipNit

       IF .NOT. PER->(FOUND())
	  IF lMensaj
	     cError('EL DOCUMENTO '+cTipNitPer(cTipNit)+' NO EXISTE ')
	  ENDIF
	  lExiste := .F.
       ENDIF
       RETURN lExiste
*>>>>FIN LOCALIZACION DEL CODIGO

/*************************************************************************
* TITULO..: DESCRIPCION DEL TIPO DE DOCUMENTO                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 15/2004 JUE A
       Colombia, Bucaramanga        INICIO: 10:15 PM   JUL 15/2004 JUE

OBJETIVOS:

1- Determina la descripci¢n del tipo de documento.

2- Retorna la descripci¢n del Tipo de Documento

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cTipNitPer(cTipNit,lAbrevi)

*>>>>DESCRIPCION DE PARAMETROS
/*     cTipNit                              // Documento de Identidad
       lAbrevi                              // .T. Abreviado */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cNomTip := ''                  // Descripci¢n del Tipo de Documento
       LOCAL nNroPos := ''                  // N£mero de Posici¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE DECISION
       lAbrevi := IF(lAbrevi == NIL,.T.,lAbrevi)
       DO CASE
       CASE cTipNit == '1'  // Cedula
	    cNomTip := IF(lAbrevi,'C.C','CEDULA')

       CASE cTipNit == '2'  // Nits Empresariales
	    cNomTip := IF(lAbrevi,'NIT','NIT DE EMPRESA')

       CASE cTipNit == '3'  // Nits de Extranjer¡a
	    cNomTip := IF(lAbrevi,'NIT','NIT DE EXTRANJERIA')

       CASE cTipNit == '4'  // Cedula de Extrajer¡a
	    cNomTip := IF(lAbrevi,'C.E','CEDULA DE ESTRANJERIA')

       CASE cTipNit == '5'  // NUIP: N£mero £nico de identificaci¢n personal
	    cNomTip := IF(lAbrevi,'NUIP','NUIP')

       CASE cTipNit == '6'  // Tarjeta de Identidad
	    cNomTip := IF(lAbrevi,'T.I','TARJETA DE IDENTIDAD')

       CASE cTipNit == '7'  // Registro Civil
	    cNomTip := IF(lAbrevi,'R.C','REGISTRO CIVIL')

       ENDCASE
       RETURN cNomTip
*>>>>FIN ANALISIS DE DECISION

/*************************************************************************
* TITULO..: VALIDACION DEL TIPO DE DOCUMENTO                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 25/2004 MAR A
       Colombia, Bucaramanga        INICIO: 02:30 PM   MAR 25/2004 MAR

OBJETIVOS:

1- Realiza la validaci¢n del tipo de Documento

2- Retorna .T. si hay problemas

3- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValTipDoc(nNroFil,nNroCol,cCodigo,cValDoc)

*>>>>DESCRIPCION DE PARAMETROS
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       cCodigo			            // @Codigo a validar
       cValDoc                              // Validaci¢n del Documento */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL aMenus  := {}                  // Declaraci¢n de Men£s
       LOCAL aAyudas := {}                  // Declaraci¢n de Ayudas
       LOCAL nNroOpc := 1                   // N£mero de Opci¢n
*>>>>DECLARACION DE VARIABLES

*>>>>VALIDACION DEL TIPO
       cValDoc := IF(cValDoc == NIL,'1234567',cValDoc)
       IF cCodigo $ cValDoc
	  RETURN .T.
       ENDIF
*>>>>FIN VALIDACION DEL TIPO

*>>>>DEFINICION TIPOS DE DOCUMENTOS
       aMenus := {}
       aAyudas := {}

       IF '1' $ cValDoc
	  AADD(aMenus,'1<CEDULA DE CIUDADANIA >')
	  AADD(aAyudas,'C‚dula de Ciudadania')
       ENDIF

       IF '2' $ cValDoc
	  AADD(aMenus,'2<NIT EMPRESARIAL      >')
          AADD(aAyudas,'Nit Empresarial')
       ENDIF

       IF '3' $ cValDoc
	  AADD(aMenus,'3<NIT DE EXTRANJERIA   >')
          AADD(aAyudas,'Nit de Extranjer¡a')
       ENDIF

       IF '4' $ cValDoc
	  AADD(aMenus,'4<CEDULA DE EXTRANJERIA>')
          AADD(aAyudas,'C‚dula de Extranjer¡a')
       ENDIF

       IF '5' $ cValDoc
	  AADD(aMenus,'5<NUIP                 >')
          AADD(aAyudas,'NUIP. N£mero £nico de identificaci¢n personal')
       ENDIF

       IF '6' $ cValDoc
	  AADD(aMenus,'6<TARJETA DE IDENTIDAD >')
	  AADD(aAyudas,'Tarjeta de Identidad')
       ENDIF

       IF '7' $ cValDoc
	  AADD(aMenus,'7<REGISTRO CIVIL       >')
	  AADD(aAyudas,'Registro Civil')
       ENDIF
*>>>>FIN DEFINICION TIPOS DE DOCUMENTOS

*>>>>SELECCION DEL TIPO DE DOCUMENTO
       cCodigo := ALLTRIM(cCodigo)

       IF LEN(aMenus) # 0

	  cSavPan := SAVESCREEN(0,0,24,79)
	  nNroOpc := nMenu(aMenus,aAyudas,nNroFil,nNroCol,NIL,NIL,1,.F.)
	  RESTSCREEN(0,0,24,79,cSavPan)

	  IF nNroOpc == 0
	     cCodigo := SPACE(01)
	  ELSE
	     cCodigo := SUBS(aMenus[nNroOpc],1,1)
	  ENDIF

       ENDIF
       RETURN .T.
*>>>>FIN SELECCION DEL TIPO DE DOCUMENTO

/*************************************************************************
* TITULO..: APELLIDOS DE LA PERSONA                                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 14/2004 JUE A
       Colombia, Bucaramanga        INICIO: 03:00 PM   OCT 14/2004 JUE

OBJETIVOS:

3- Retorna .T. los Apellidos de la Persona

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cApelliPer()
RETURN ALLTRIM(PER->cApeUnoPer)+;
      IF(EMPTY(PER->cApeDosPer),'',' '+;
	       ALLTRIM(PER->cApeDosPer))

/*************************************************************************
* TITULO..: NOMBRES DE LA PERSONA                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 14/2004 JUE A
       Colombia, Bucaramanga        INICIO: 03:10 PM   OCT 14/2004 JUE

OBJETIVOS:

3- Retorna .T. los Nombres de la Persona

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cNombrePer()
RETURN ALLTRIM(PER->cNomUnoPer)+;
       IF(EMPTY(PER->cNomDosPer),'',' '+;
		ALLTRIM(PER->cNomDosPer))

/*************************************************************************
* TITULO..: NOMBRES Y APELLIDOS DE LA PERSONA                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 14/2004 JUE A
       Colombia, Bucaramanga        INICIO: 03:15 PM   OCT 14/2004 JUE

OBJETIVOS:

3- Retorna .T. los Nombres de la Persona

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cNomApePer()
RETURN cNombrePer()+' '+cApelliPer()

/*************************************************************************
* TITULO..: APELLIDOS Y NOMBRES DE LA PERSONA                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 14/2004 JUE A
       Colombia, Bucaramanga        INICIO: 03:15 PM   OCT 14/2004 JUE

OBJETIVOS:

3- Retorna .T. los Nombres de la Persona

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cApeNomPer()
RETURN cApelliPer()+' '+cNombrePer()

/*************************************************************************
* TITULO..: LOCALIZAR DEL NOMBRE DE LA PERSONA                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 15/2007 VIE A
       Colombia, Bucaramanga        INICIO: 12:50 AM   JUN 15/2007 VIE

OBJETIVOS:

1- Deben estar en uso el archivo de personas

2- Permite localizar el c¢digo de la materia variable

3- Se debe pasar el Alias del Archivo del Browse

4- Retorna .T. si la Materia es Variable

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cLocNomPer(nCodigo,cNalias)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodigo				      // C¢digo de b£squeda
       cNalias				      // Alias del Browse */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cNombreTpe := ''                 // Nombre del profesor
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION DEL CODIGO
       IF lLocCodigo('nIdeCodPer','PER',nCodigo)

	  cNombreTpe := cNomApePer()

	  IF PER->lSiQepdPer
	     cNombreTpe := 'Qepd '+cNombreTpe
	  ENDIF

       ELSE
	  cNombreTpe := 'PERSONA NO EXISTE'
       ENDIF
       IF cNalias # NIL
	  SELECT &cNalias
       ENDIF
       RETURN cNombreTpe+SPACE(50-LEN(cNombreTpe))
*>>>>FIN LOCALIZACION DEL CODIGO


