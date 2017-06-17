**********CALCULO DEL TIEMPO TRANSCURRIDO
	    lHayPag := .F.
	    lHayVeh := lLocCodigo('cPlacaVeh','VEH',cPlacaTve)

	    DO CASE
	    CASE !lInsReg .AND. !lHayVeh

		 cObservTre := ''
		 aTiempo := aHoraDias(dFecIngTre,dFecOutTre,;
				      cHorIngTre,cHorOutTre,;
				      PAR->cIniDiaPak,PAR->cFinDiaPak,;
				      PAR->cIniNocPak,PAR->cFinNocPak,;
				      @nTipHor)
	       *ÀNO hay Mensualidad

	    CASE !lInsReg .AND. lHayVeh .AND.;
		 dFecIngTre < VEH->dIniPakVeh .AND.;
		 dFecOutTre < VEH->dFinPakVeh

		 cObservTre := ''
		 aTiempo := aHoraDias(dFecIngTre,dFecOutTre,;
				      cHorIngTre,cHorOutTre,;
				      PAR->cIniDiaPak,PAR->cFinDiaPak,;
				      PAR->cIniNocPak,PAR->cFinNocPak,;
				      @nTipHor)
	       *ÀPor fuera de la Mensualidad

	    CASE !lInsReg .AND. lHayVeh .AND.;
		 dFecIngTre > VEH->dIniPakVeh .AND.;
		 dFecIngTre > VEH->dFinPakVeh .AND.;
		 dFecOutTre > VEH->dFinPakVeh

		 cObservTre := 'SERVICIO VENCIO: '+cFecha(VEH->dFinPakVeh)
		 aTiempo := aHoraDias(dFecIngTre,dFecOutTre,;
				      cHorIngTre,cHorOutTre,;
				      PAR->cIniDiaPak,PAR->cFinDiaPak,;
				      PAR->cIniNocPak,PAR->cFinNocPak,;
				      @nTipHor)
	       *ÀMensualidad Vencida.

	    CASE !lInsReg .AND. lHayVeh .AND.;
		 dFecIngTre >= VEH->dIniPakVeh .AND.;
		 dFecOutTre <= VEH->dFinPakVeh

		 lHayPag := .T.
		 cObservTre := 'SERVICIO HASTA '+cFecha(VEH->dFinPakVeh)

		 aTiempo := aHoraDias(dFecIngTre,dFecOutTre,;
				      cHorIngTre,cHorOutTre,;
				      PAR->cIniDiaPak,PAR->cFinDiaPak,;
				      PAR->cIniNocPak,PAR->cFinNocPak,;
				      @nTipHor)
	       *ÀMensualidad Total.


	    CASE !lInsReg .AND. lHayVeh .AND.;
		 dFecIngTre <  VEH->dIniPakVeh .AND.;
		 dFecOutTre <= VEH->dFinPakVeh // Pago Parcial Caso No. 2

		 cObservTre := 'SERVICIO DE '+cFecha(VEH->dIniPakVeh)+' A '+;
			       cFecha(VEH->dFinPakVeh)

		 aTiempo := aHoraDias(dFecIngTre,VEH->dIniPakVeh-1,;
				      cHorIngTre,'24:00:00',;
				      PAR->cIniDiaPak,PAR->cFinDiaPak,;
				      PAR->cIniNocPak,PAR->cFinNocPak,;
				      @nTipHor)
	       *ÀMensualidad Parcial. Hora Inicial por cobrar

	    CASE !lInsReg .AND. lHayVeh .AND.;
		 dFecIngTre >= VEH->dIniPakVeh .AND.;
		 dFecIngTre <= VEH->dFinPakVeh .AND.;
		 dFecOutTre >  VEH->dFinPakVeh // Pago Parcial Caso No. 3

		 cObservTre := 'SERVICIO DE '+cFecha(VEH->dIniPakVeh)+' A '+;
			       cFecha(VEH->dFinPakVeh)

		 aTiempo := aHoraDias(VEH->dFinPakVeh+1,dFecOutTre,;
				      '00:00:00',cHorOutTre,;
				      PAR->cIniDiaPak,PAR->cFinDiaPak,;
				      PAR->cIniNocPak,PAR->cFinNocPak,;
				      @nTipHor)
	       *ÀMensualidad Parcial. Hora final por cobrar


	    CASE !lInsReg .AND. lHayVeh .AND.;
		 dFecIngTre < VEH->dIniPakVeh  .AND.;
		 dFecOutTre > VEH->dFinPakVeh  // Pago Parcial Caso No. 4

		 cObservTre := 'SERVICIO DE '+cFecha(VEH->dIniPakVeh)+' A '+;
			       cFecha(VEH->dFinPakVeh)

		 aTimes1 := aHoraDias(dFecIngTre,VEH->dIniPakVeh-1,;
				      cHorIngTre,'24:00:00',;
				      PAR->cIniDiaPak,PAR->cFinDiaPak,;
				      PAR->cIniNocPak,PAR->cFinNocPak,;
				      @nTipHor)
	       *ÀMensualidad Parcial. Hora inicial por cobrar

		 aTimes2 := aHoraDias(VEH->dFinPakVeh+1,dFecOutTre,;
				      '00:00:00',cHorOutTre,;
				      PAR->cIniDiaPak,PAR->cFinDiaPak,;
				      PAR->cIniNocPak,PAR->cFinNocPak,;
				      @nTipHor)
	       *ÀMensualidad Parcial. Hora final por cobrar

		 aTiempo := aTimes1
		 FOR i := 1 TO LEN(aTimes2)
		     aTiempo[i] += aTimes2[i]
		 ENDFOR
	       *ÀAcumulaci¢n de los tiempos

	    ENDCASE
**********FIN CALCULO DEL TIEMPO TRANSCURRIDO