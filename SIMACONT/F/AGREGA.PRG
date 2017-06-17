*>>>>SELECCION DEL GRADO
       CLEAR
       @ 1,1 PROMPT 'BACHILLERATO'
       @ 2,1 PROMPT 'PRIMARIA    '
       @ 3,1 PROMPT 'JARDIN      '
       MENU TO nNroOpc
       IF nNroOpc == 0
	  CLOSE ALL
	  QUIT
       ENDIF
*>>>>FIN SELECCION DEL GRADO

*>>>>LECTURA DEL A•O DE LA APLICACION
       cAnoUsr := STR(YEAR(DATE()),4)
       @04,01 SAY "A•O  :" GET cAnoUsr PICT "9999" ;
			   VALID VAL(cAnoUsr) <> 0
       READ
       cAnoUsr := SUBS(cAnoUsr,3,2)
*>>>>FIN LECTURA DEL A•O DE LA APLICACION

*>>>>ANALISIS DE LA OPCION ESCOGIDA
       DO CASE
       CASE nNroOpc == 1
	    cMaeDbf := 'MAE'+cAnoUsr+'.DBF'
	    cMaeDat := 'MAEBTO'+cAnoUsr+'.DAT'

       CASE nNroOpc == 2
	    cMaeDat := 'MAEPRI'+cAnoUsr+'.DAT'

       CASE nNroOpc == 3
	    cMaeDat := 'MAEJAR'+cAnoUsr+'.DAT'
       ENDCASE
       cMaeDbf := 'MAE'+cAnoUsr+'.DBF'
*>>>>FIN ANALISIS DE LA OPCION ESCOGIDA

*>>>>SELECION DE AREAS DE TRABAJO
       SELECT A
       USE &cMaeDat ALIAS DAT

       SELECT B
       USE &cMaeDbf ALIAS DBF
*>>>>FIN SELECION DE AREAS DE TRABAJO

*>>>>GRABACION DEL MAESTRO PLUSCONT
       SELECT DBF
       GO TOP
       DO WHILE .NOT. EOF()
	  ?Curso+' '+Apelli
	  SELECT DAT
	  APPEND BLANK
	  REPL DAT->cCodigoEst WITH '95'+DBF->Codigo
	  REPL DAT->cCodigoGru WITH SUBS(DBF->Curso,1,2)+'0'+;
				    SUBS(DBF->Curso,3,1)
	  REPL DAT->cApelliEst WITH DBF->Apelli
	  REPL DAT->cNombreEst WITH DBF->Nombre
	  REPL DAT->dFecNacEst WITH DBF->Nac
	  REPL DAT->cLugNacEst WITH DBF->Lugar
	  REPL DAT->cDocNitEst WITH DBF->Nit
	  REPL DAT->cLugNitEst WITH DBF->De
	  REPL DAT->cDireccEst WITH DBF->Direcci
	  REPL DAT->cTelefnEst WITH DBF->Telefon
	  REPL DAT->cBarrioEst WITH DBF->Barrio
	  REPL DAT->cNomPadEst WITH DBF->Padre
	  REPL DAT->cProPadEst WITH DBF->Pprofes
	  REPL DAT->cEmpPadEst WITH DBF->Pempres
	  REPL DAT->cCarPadEst WITH DBF->Poficio
	  REPL DAT->cTelPadEst WITH DBF->PTelOfi
	  REPL DAT->cNomMadEst WITH DBF->Madre
	  REPL DAT->cProMadEst WITH DBF->MProfes
	  REPL DAT->cEmpMadEst WITH DBF->MEmpres
	  REPL DAT->cCarMadEst WITH DBF->MOficio
	  REPL DAT->cTelMadEst WITH DBF->MTelOfi
	  REPL DAT->cNomAcuEst WITH DBF->Acudien
	  REPL DAT->cTe1AcuEst WITH DBF->ATelCas
	  REPL DAT->cTe2AcuEst WITH DBF->ATelOfi
	  REPL DAT->dFecMatEst WITH DBF->FecInic
	  REPL DAT->dFecRetEst WITH DBF->FecReti
	  REPL DAT->lRetiroEst WITH IF(DBF->SW==1,.F.,.T.)
	  REPL DAT->lSiCupoEst WITH .T.
	  REPL DAT->lMatricEst WITH .F.

	  SELECT DBF
	  SKIP

       ENDDO
*>>>>FIN GRABACION DEL MAESTRO PLUSCONT

*Codigo
*{"Numero" , "Character",04,0},;
*{"lMatricNue","Character",01,0},;
*{"Curso"  , "Character",03,0},;
*{"Cursoa" , "Character",03,0},;
*{"Apelli" , "Character",25,0},;
*{"Nombre" , "Character",25,0},;
*{"Nac"    , "Date"     ,08,0},;
*{"Lugar"  , "Character",20,0},;
*{"Nit"    , "Character",15,0},;
*{"De"     , "Character",20,0},;
*{"Padre"  , "Character",40,0},;
*{"Pprofes", "Character",25,0},;
*{"Pempres", "Character",25,0},;
*{"Poficio", "Character",20,0},;
*{"PTelOfi", "Character",07,0},;
*{"Madre"  , "Character",40,0},;
*{"MProfes", "Character",25,0},;
*{"MEmpres", "Character",25,0},;
*{"MOficio", "Character",20,0},;
*{"MTelOfi", "Character",07,0},;
*{"Direcci", "Character",40,0},;
*{"Telefon", "Character",07,0},;
*{"Barrio" , "Character",15,0},;
*{"Acudien", "Character",40,0},;
*{"ATelOfi", "Character",07,0},;
*{"ATelCas", "Character",07,0},;
*{"FecInic", "Date",08,0},;
*{"FecReti", "Date",08,0},;
*{"Sw"     , "Numeric",01,0},;
*{"Final"  , "Numeric",01,0}}ç
