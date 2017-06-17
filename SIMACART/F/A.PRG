
       LOCAL aDbfBan := {{"cCodigoBan","Character",02,0},; // C¢digo del Banco
			 {"cNombreBan","Character",20,0},; // Nombre del Banco
			 {"cNomBanBan","Character",20,0},; // Nombre del Banco
			 {"cLugarBan" ,"Character",16,0},; // Lugar del Banco
			 {"cNroCtaBan","Character",20,0},; // N£mero de la Cuenta
			 {"cValCtaBan","Character",20,0},; // N£mero de la Cuenta a validar
			 {"cEanCtaBan","Character",13,0},; // C¢digo EAN-13 de la Empresa
			 {"nNroCtaBan","Numeric"  ,03,0},; // Posici¢n archivo plano N£mero de la Cuenta
			 {"nLenCtaBan","Numeric"  ,03,0},; // Posici¢n archivo plano Longitud N£mero de la Cuenta
			 {"cChrSepBan","Character",02,0},; // Caracter Seperador
			 {"nCodEstBan","Numeric"  ,03,0},; // Posici¢n archivo plano del c¢digo del Estudiante
			 {"nLenRefBan","Numeric"  ,03,0},; // Posici¢n archivo plano de la longitud del C¢digo de la Referencia.
			 {"nCodRf2Ban","Numeric"  ,03,0},; // Posici¢n archivo plano del c¢digo del Estudiante
			 {"nPagIntBan","Numeric"  ,03,0},; // Posici¢n archivo plano del valor pagado entero
			 {"nLenIntBan","Numeric"  ,03,0},; // Posici¢n archivo plano de la logitud del valor pagado en cifra entera
			 {"nPagDecBan","Numeric"  ,03,0},; // Posici¢n archivo plano del valor pagado en decimal
			 {"nLenDecBan","Numeric"  ,03,0},; // Posici¢n archivo plano de la longitud valor pagado en cifra decimal
			 {"cChrFecBan","Character",01,0},; // Caracter Seperador de fecha
			 {"nAnoPagBan","Numeric"  ,03,0},; // Posici¢n archivo plano A¤o de la fecha de Pago
			 {"nLenAnoBan","Numeric"  ,02,0},; // Posici¢n archivo plano longitud del A¤o de la fecha de Pago
			 {"nMesPagBan","Numeric"  ,03,0},; // Posici¢n archivo plano Mes de la fecha de Pago
			 {"nDiaPagBan","Numeric"  ,03,0},; // Posici¢n archivo plano D¡a de la fecha de Pago
			 {"nTipMovBan","Numeric"  ,03,0},; // Posici¢n archivo plano de tipo de Mvto Ej: NB
			 {"nLenTipBan","Numeric"  ,03,0},; // Posici¢n archivo plano de la longitud tipo de Mvto Ej: NB
			 {"nSigMovBan","Numeric"  ,03,0},; // Posici¢n del Archivo Plano del signo del Tipo del Movimiento. Ej: + o -
			 {"nLenSigBan","Numeric"  ,03,0},; // Posici¢n archivo plano de la longitud del signo del Tipo del Movimiento
			 {"nLugSigBan","Numeric"  ,01,0},; // Lugar del Signo del tipo del movimiento. Ej 0=>No existe o esta integrado en el tipo de movimiento, 1=>Derecha 2=>Inzquierda
			 {"nMotivoBan","Numeric"  ,03,0},; // Posici¢n archivo plano del Motivo de la transaci¢n Ej: Davivienda 0020 Cobro Empresarial
			 {"nLenMtvBan","Numeric"  ,03,0},; // Posici¢n archivo plano de la longitud del Motivo de la transaci¢n Ej: Davivienda 0020 Cobro Empresarial Longitud = 4
			 {"nPosOfiBan","Numeric"  ,03,0},; // Posici¢n archivo plano de la oficina
			 {"nLenOfiBan","Numeric"  ,03,0},; // Posici¢n archivo plano de la longitud de la Oficina
			 {"nPosTerBan","Numeric"  ,03,0},; // Posici¢n archivo plano Terminal de la oficina
			 {"nLenTerBan","Numeric"  ,03,0},; // Posici¢n archivo plano de la longitud de la terminal de la oficina
			 {"nPosTalBan","Numeric"  ,03,0},; // Posici¢n archivo plano talon
			 {"nLenTalBan","Numeric"  ,03,0},; // Posici¢n archivo plano de la longitud del talon
			 {"nPosJorBan","Numeric"  ,03,0},; // Posici¢n archivo plano de la jornada de pago
			 {"nLenJorBan","Numeric"  ,03,0},; // Posici¢n archivo plano de la longitud de la jornada de pago
			 {"nPosMaiBan","Numeric"  ,03,0},; // Posici¢n archivo plano del mail del pago
			 {"nLenMaiBan","Numeric"  ,03,0},; // Posici¢n archivo plano de la longitud del mail del pago
			 {"nPagOnlBan","Numeric"  ,02,0},; // Formato para pagos en lineas.
			 {"nDigVerBan","Numeric"  ,02,0},; //* N£mero del M‚todo de Verificaci¢n
			 {'lLeeExtBan','Logical'  ,01,0}}  // .T. Leer el extracto.