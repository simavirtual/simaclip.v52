/*                    SIMA - MATRICULA ACADEMICA
      BIBLIOTECAS DE FUNCIONES PARA EL DISE¥O DE LA HOJA DE MATRICULA

REQUERIMIENTOS:

- Compilar: clipper fTipoMat /w/m/b

OBJETIVOS:

- Funciones aplicadas para los diferentes Hoja de matr¡cula

***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO ..: HOJA DE MATRICULA No. 01                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 04/99 SAB A
       Colombia, Bucaramanga        INICIO: 06:00 PM   SEP 04/99 SAB

OBJETIVOS:

1- Imprime la Hoja de Matricula No. 01

2- Esta es la Hoja de Matricula por defecto del sistema.

3- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION HojaMatr01(cCodigo,lNuevos,lRepite,nNroNiv,cNombre,cApelli,dFecNac,;
		    cLugNac,cNroNit,cLugNit,cDirecc,cBarrio,cTelefn,cNomPad,;
		    cPadNit,cPadLug,cProPad,cEmpPad,cCarPad,cTelPad,cNomMad,;
		    cMadNit,cMadLug,cProMad,cEmpMad,cCarMad,cTelMad,cNomAcu,;
		    cAcuNit,cAcuLug,cTelAcu,dFecMat,cHorMat,cObserv,cNomSis,;
		    cNomEmp,cAnoUsr,cJorTxt,cCodIso,lMatric)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodigo                              // C¢digo de la estudiante
       lNuevos                              // .T. Alumno Nuevo
       lRepite                              // .T. Alumno Repitente
       nNroNiv				    // N£mero de Nivel
       cNombre                              // Nombres del aspirante
       cApelli                              // Apellidos del aspirante
       dFecNac                              // Fecha de Nacimiento
       cLugNac                              // Lugar de Nacimiento
       cNroNit                              // Documento de identidad
       cLugNit                              // Lugar de documento
       cDirecc                              // Direccion del estudiante
       cBarrio                              // Barrio
       cTelefn                              // Telefono
       cNomPad                              // Nombre del padre
       cPadNit                              // C‚dula del padre
       cPadLug                              // Lugar de la c‚dula
       cProPad                              // Profesion del padre
       cEmpPad			            // Empresa donde trabaja
       cCarPad                              // Cargo en la Empresa
       cTelPad                              // Telefono del padre
       cNomMad                              // Nombre de la madre
       cMadNit                              // C‚dula de la madre
       cMadLug                              // Lugar de la c‚dula de la madre
       cProMad                              // Profesion de la madre
       cEmpMad			            // Empresa donde trabaja
       cCarMad                              // Cargo de la madre
       cTelMad                              // Telefono de la madre
       cNomAcu                              // Nombre del acudiente
       cAcuNit                              // C‚dula del Acudiente
       cAcuLug                              // Lugar del Acudiente
       cTelAcu                              // Telefono del acudiente
       dFecMat                              // Fecha de la Matricula
       cHorMat                              // Hora de la matricula
       cObserv			            // Observaci¢n uno para matr¡cula
       cNomSis                              // Nombre del Sistema
       cNomEmp                              // Nombre de la Empresa
       cAnoUsr                              // A¤o del usuario
       cJorTxt                              // Jornada Escogida
       cCodIso                              // C¢digo Iso
       lMatric                              // .T. Matricula .F. Prematricula */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nLenPrn := 0                   // Longitud de impresi¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ACTIVACION DE LA IMPRESORA
       #INCLUDE "EPSONFX.PRG"

       @ PROW(),00 SAY GRAPHI_ON+CONDEN_OF+PROPOR_OF+DRAFT_ON
       @ PROW(),00 SAY NEGRA_ON+DOBGOL_ON+ELITE
       nLenPrn := n12Stan
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL ENCABEZADO
       @ PROW(),00 SAY DOBANC_ON+DOBALT_ON

       lMatric := IF(lMatric==NIL,.T.,lMatric)
       IF lMatric
	  cTxtPrn := 'MATRICULA CODIGO: '+cCodigo
       ELSE
	  cTxtPrn := 'PRE MATRICULA CODIGO: '+cCodigo
       ENDIF

       IF ANO->lPrnEmpAno
	  @ PROW()+6,((nLenPrn/2)-LEN(ALLTRIM(cNomEmp)))/2 SAY ALLTRIM(cNomEmp)
	  @ PROW()+2,((nLenPrn/2)-LEN(cTxtPrn))/2 SAY cTxtPrn
       ELSE
	  @ PROW()+8,((nLenPrn/2)-LEN(cTxtPrn))/2 SAY cTxtPrn
       ENDIF
       @ PROW(),00 SAY DOBANC_OF+DOBALT_OF

       cCodIso := IF(cCodIso==NIL,'',cCodIso)
       DO CASE
       CASE LEN(ALLTRIM(cCodIso)) <= 12
	    @ PROW(),90 SAY cCodIso
       OTHERWISE
	    @ PROW(),00 SAY CONDEN_ON
	    @ PROW(),132 SAY cCodIso
	    @ PROW(),00 SAY CONDEN_OF
       ENDCASE

       cTxtPrn := 'NIVEL: '+cNomNiv(nNroNiv)
       lNuevos := IF(lNuevos==NIL,.F.,lNuevos)
       lRepite := IF(lRepite==NIL,.F.,lRepite)
       DO CASE
       CASE lNuevos .AND. !lRepite
	    cTxtPrn += " (NUEVO)"
       CASE !lNuevos .AND. lRepite
	    cTxtPrn += " (REPITE)"
       OTHERWISE
	    cTxtPrn += " (ANTIGUO)"
       ENDCASE
       cTxtPrn += ' '+cAnoUsr+'. JORNADA: '+cJorTxt

       IF EMPTY(cCodIso)
	  @ PROW()+2,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn
       ELSE
	  @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn
       ENDIF
*>>>>FIN IMPRESION DEL ENCABEZADO

*>>>>IMPRESION DEL CUERPO DEL FORMULARIO
       LineaPrn({SPACE(13)+'NOMBRE: ',RTRIM(cApelli)+' '+cNombre},3)

       IF lMatric 
	  @ PROW(),78 SAY 'FOLIO No. ______'
       ENDIF

       LineaPrn({SPACE(13)+'NACIDO EN: ',cLugNac,;
		 SPACE(21)+'FECHA: ',cFecha(dFecNac)},3)

       LineaPrn({SPACE(13)+'IDENTIFICACION No: ',cNroNit,;
		 SPACE(17)+'DE' ,cLugNit},2)

       LineaPrn({SPACE(13)+'DIRECCION:',cDirecc},2)
       LineaPrn({SPACE(13)+'BARRIO:',cBarrio,;
		 SPACE(29)+'TELEFONO:',cTelefn},1)

       LineaPrn({SPACE(13)+'PADRE:',SUBS(cNomPad+SPACE(40),1,40),;
			    SPACE(06)+'TELEFONO:',cTelPad},2)
       LineaPrn({SPACE(13)+'C.C No.:',cPadNit,SPACE(28)+'DE:',cPadLug},1)
       LineaPrn({SPACE(13)+'PROFESION:',cProPad},1)
       LineaPrn({SPACE(13)+'EMPRESA:',cEmpPad,SPACE(18)+'CARGO:',cCarPad},1)

       LineaPrn({SPACE(13)+'MADRE:',SUBS(cNomMad+SPACE(40),1,40),;
			    SPACE(06)+'TELEFONO:',cTelMad},2)
       LineaPrn({SPACE(13)+'C.C No.:',cMadNit,SPACE(28)+'DE:',cMadLug},1)
       LineaPrn({SPACE(13)+'PROFESION:',cProMad},1)
       LineaPrn({SPACE(13)+'EMPRESA:',cEmpMad,SPACE(18)+'CARGO:',cCarMad},1)

       LineaPrn({SPACE(13)+'ACUDIENTE:',SUBS(cNomAcu+SPACE(40),1,40),;
		 SPACE(02)+'TELEFONO:',cTelAcu},2)
       LineaPrn({SPACE(13)+'C.C No.:',cAcuNit,SPACE(28)+'DE:',cAcuLug},1)

       IF !EMPTY(dFecMat) .AND. !EMPTY(cHorMat)
	  LineaPrn({SPACE(13)+'FECHA DE MATRICULA:',cFecha(dFecMat)+;
		   " "+cDia(DOW(dFecMat),3),SPACE(23)+cHoraSys(cHorMat)},3)
       ENDIF

       IF EMPTY(cObserv)
	  LineaPrn({SPACE(13)+'OBSERVACIONES:',REPL('_',65)},3)
       ELSE
	  cObserv := ALLTRIM(cObserv)+REPL('_',65-LEN(ALLTRIM(cObserv)))
	  LineaPrn({SPACE(13)+'OBSERVACIONES:',cObserv},3)
       ENDIF
       LineaPrn({SPACE(13)+REPL('_',80)},1)
       LineaPrn({SPACE(13)+REPL('_',80)},1)
       LineaPrn({SPACE(13)+REPL('_',80)},1)

       IF EMPTY(ANO->cObsMtrAno)
	  LineaPrn({SPACE(13)+'ACEPTAMOS LA CONFESIONALIDAD, FILOSOFIA, '+;
			      'ORIENTACION Y REGLAMENTO DEL COLEGIO.'},3)
       ELSE
	  LineaPrn({SPACE(13)+CONDEN_ON+ANO->cObsMtrAno+CONDEN_OF},2)
       ENDIF

       LineaPrn({SPACE(13)+REPL('_',30),SPACE(10)+REPL('_',30)},5)
       LineaPrn({SPACE(14)+"FIRMA DEL PADRE O TUTOR LEGAL",;
		 SPACE(18)+"FIRMA DEL ALUMNO"},1)

       LineaPrn({SPACE(13)+REPL('_',30),SPACE(10)+REPL('_',30)},5)
       LineaPrn({SPACE(25)+"RECTOR",;
		 SPACE(30)+"SECRETARIA"},1)

       DerechosPrn(cNomSis,cNomEmp,n20Stan)
       EJECT
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DEL CUERPO DEL FORMULARIO


/*************************************************************************
* TITULO ..: HOJA DE MATRICULA No. 02                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 04/99 SAB A
       Colombia, Bucaramanga        INICIO: 06:00 PM   SEP 04/99 SAB

OBJETIVOS:

1- Imprime la Hoja de Matricula No. 02

2- Esta es la Hoja de Matricula con Colegios de Procedencia.

3- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION HojaMatr02(cCodigo,lNuevos,lRepite,nNroNiv,cNombre,cApelli,dFecNac,;
		    cLugNac,cNroNit,cLugNit,cDirecc,cBarrio,cTelefn,cNomPad,;
		    cPadNit,cPadLug,cProPad,cEmpPad,cCarPad,cTelPad,cNomMad,;
		    cMadNit,cMadLug,cProMad,cEmpMad,cCarMad,cTelMad,cNomAcu,;
		    cAcuNit,cAcuLug,cTelAcu,dFecMat,cHorMat,cObserv,cNomSis,;
		    cNomEmp,cAnoUsr,cJorTxt,cCodIso,lMatric)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodigo                              // C¢digo de la estudiante
       lNuevos                              // .T. Alumno Nuevo
       lRepite                              // .T. Alumno Repitente
       nNroNiv				    // N£mero de Nivel
       cNombre                              // Nombres del aspirante
       cApelli                              // Apellidos del aspirante
       dFecNac                              // Fecha de Nacimiento
       cLugNac                              // Lugar de Nacimiento
       cNroNit                              // Documento de identidad
       cLugNit                              // Lugar de documento
       cDirecc                              // Direccion del estudiante
       cBarrio                              // Barrio
       cTelefn                              // Telefono
       cNomPad                              // Nombre del padre
       cPadNit                              // C‚dula del padre
       cPadLug                              // Lugar de la c‚dula
       cProPad                              // Profesion del padre
       cEmpPad			            // Empresa donde trabaja
       cCarPad                              // Cargo en la Empresa
       cTelPad                              // Telefono del padre
       cNomMad                              // Nombre de la madre
       cMadNit                              // C‚dula de la madre
       cMadLug                              // Lugar de la c‚dula de la madre
       cProMad                              // Profesion de la madre
       cEmpMad			            // Empresa donde trabaja
       cCarMad                              // Cargo de la madre
       cTelMad                              // Telefono de la madre
       cNomAcu                              // Nombre del acudiente
       cAcuNit                              // C‚dula del Acudiente
       cAcuLug                              // Lugar del Acudiente
       cTelAcu                              // Telefono del acudiente
       dFecMat                              // Fecha de la Matricula
       cHorMat                              // Hora de la matricula
       cObserv			            // Observaci¢n uno para matr¡cula
       cNomSis                              // Nombre del Sistema
       cNomEmp                              // Nombre de la Empresa
       cAnoUsr                              // A¤o del usuario
       cJorTxt                              // Jornada Escogida
       cCodIso                              // C¢digo Iso
       lMatric                              // .T. Matricula .F. Prematricula */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nLenPrn := 0                   // Longitud de impresi¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ACTIVACION DE LA IMPRESORA
       #INCLUDE "EPSONFX.PRG"

       @ PROW(),00 SAY GRAPHI_ON+CONDEN_OF+PROPOR_OF+DRAFT_ON
       @ PROW(),00 SAY NEGRA_ON+DOBGOL_ON+ELITE
       nLenPrn := n12Stan
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL ENCABEZADO
       @ PROW(),00 SAY DOBANC_ON+DOBALT_ON

       lMatric := IF(lMatric==NIL,.T.,lMatric)
       IF lMatric
	  cTxtPrn := 'MATRICULA CODIGO: '+cCodigo
       ELSE
	  cTxtPrn := 'PRE MATRICULA CODIGO: '+cCodigo
       ENDIF

       IF ANO->lPrnEmpAno
	  @ PROW()+6,((nLenPrn/2)-LEN(ALLTRIM(cNomEmp)))/2 SAY ALLTRIM(cNomEmp)
	  @ PROW()+2,((nLenPrn/2)-LEN(cTxtPrn))/2 SAY cTxtPrn
       ELSE
	  @ PROW()+8,((nLenPrn/2)-LEN(cTxtPrn))/2 SAY cTxtPrn
       ENDIF
       @ PROW(),00 SAY DOBANC_OF+DOBALT_OF

       cTxtPrn := 'NIVEL: '+cNomNiv(nNroNiv)
       lNuevos := IF(lNuevos==NIL,.F.,lNuevos)
       lRepite := IF(lRepite==NIL,.F.,lRepite)
       DO CASE
       CASE lNuevos .AND. !lRepite
	    cTxtPrn += " (NUEVO)"
       CASE !lNuevos .AND. lRepite
	    cTxtPrn += " (REPITE)"
       OTHERWISE
	    cTxtPrn += " (ANTIGUO)"
       ENDCASE
       cTxtPrn += ' '+cAnoUsr+'. JORNADA: '+cJorTxt
       @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn
*>>>>FIN IMPRESION DEL ENCABEZADO

*>>>>IMPRESION DEL CUERPO DEL FORMULARIO
       LineaPrn({SPACE(13)+'NOMBRE: ',RTRIM(cApelli)+' '+cNombre},2)

       IF lMatric
	  @ PROW(),78 SAY 'FOLIO No. ______'
       ENDIF

       LineaPrn({SPACE(13)+'NACIDO EN: ',cLugNac,;
		 SPACE(21)+'FECHA: ',cFecha(dFecNac)},2)

       LineaPrn({SPACE(13)+'IDENTIFICACION No: ',cNroNit,;
		 SPACE(17)+'DE' ,cLugNit},1)

       LineaPrn({SPACE(13)+'DIRECCION:',cDirecc},1)
       LineaPrn({SPACE(13)+'BARRIO:',cBarrio,;
		 SPACE(29)+'TELEFONO:',cTelefn},1)

       LineaPrn({SPACE(13)+'PADRE:',SUBS(cNomPad+SPACE(40),1,40),;
			    SPACE(06)+'TELEFONO:',cTelPad},2)
       LineaPrn({SPACE(13)+'C.C No.:',cPadNit,SPACE(28)+'DE:',cPadLug},1)
       LineaPrn({SPACE(13)+'PROFESION:',cProPad},1)
       LineaPrn({SPACE(13)+'EMPRESA:',cEmpPad,SPACE(18)+'CARGO:',cCarPad},1)

       LineaPrn({SPACE(13)+'MADRE:',SUBS(cNomMad+SPACE(40),1,40),;
			   SPACE(06)+'TELEFONO:',cTelMad},2)
       LineaPrn({SPACE(13)+'C.C No.:',cMadNit,SPACE(28)+'DE:',cMadLug},1)
       LineaPrn({SPACE(13)+'PROFESION:',cProMad},1)
       LineaPrn({SPACE(13)+'EMPRESA:',cEmpMad,SPACE(18)+'CARGO:',cCarMad},1)

       LineaPrn({SPACE(13)+'ACUDIENTE:',SUBS(cNomAcu+SPACE(40),1,40),;
		 SPACE(02)+'TELEFONO:',cTelAcu},2)
       LineaPrn({SPACE(13)+'C.C No.:',cAcuNit,SPACE(28)+'DE:',cAcuLug},1)

       IF !EMPTY(cCole13Est+cCole00Est+cCole06Est+cCole07Est+;
		cCole08Est+cCole09Est+cCole10Est+cCole11Est+;
		cCole12Est)
	  LineaPrn({SPACE(13)+'COLEGIOS DE PROCEDENCIA'},2)
	  LineaPrn({SPACE(13)+'A¥O',SPACE(01)+'NIVEL',SPACE(04),;
		    'INSTITUCION',SPACE(28),'CIUDAD'},1)
       ENDIF

       cNroCam := '130006070809101112'
       FOR i := 1 TO 8
	   cCampo := 'cCole'+SUBS(cNroCam,i*2-1,2)+'Est'
	   cCampo := &cCampo
	   IF !EMPTY(cCampo)
	      LineaPrn({SPACE(13)+SUBS(cCampo,01,04),;
				  SUBS(cCampo,05,10),;
				  SUBS(cCampo,15,40),;
				  SUBS(cCampo,55,20)},1)
	   ENDIF
       ENDFOR

       IF !EMPTY(dFecMat) .AND. !EMPTY(cHorMat)
	  LineaPrn({SPACE(13)+'FECHA DE MATRICULA:',cFecha(dFecMat)+;
		   " "+cDia(DOW(dFecMat),3),SPACE(23)+cHoraSys(cHorMat)},1)
       ENDIF

       IF EMPTY(cObserv)
	  LineaPrn({SPACE(13)+'OBSERVACIONES:',REPL('_',65)},2)
       ELSE
	  cObserv := ALLTRIM(cObserv)+REPL('_',65-LEN(ALLTRIM(cObserv)))
	  LineaPrn({SPACE(13)+'OBSERVACIONES:',cObserv},3)
       ENDIF
       LineaPrn({SPACE(13)+REPL('_',80)},1)
       LineaPrn({SPACE(13)+REPL('_',80)},1)
*      LineaPrn({SPACE(13)+REPL('_',80)},1)


       LineaPrn({SPACE(13)+CONDEN_ON+ANO->cObsMtrAno+CONDEN_OF},2)

       LineaPrn({SPACE(13)+REPL('_',30),SPACE(10)+REPL('_',30)},3)
       LineaPrn({SPACE(18)+"FIRMA DEL PADRE",;
		 SPACE(28)+"FIRMA DEL ALUMNO"},1)

       LineaPrn({SPACE(13)+REPL('_',30),SPACE(10)+REPL('_',30)},3)
       LineaPrn({SPACE(18)+"FIRMA DE LA MADRE",;
		 SPACE(24)+"FIRMA DEL ACUDIENTE"},1)

       LineaPrn({SPACE(13)+REPL('_',30),SPACE(10)+REPL('_',30)},3)
       LineaPrn({SPACE(25)+"RECTOR",;
		 SPACE(30)+"SECRETARIA"},1)

       DerechosPrn(cNomSis,cNomEmp,n20Stan)
       EJECT
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DEL CUERPO DEL FORMULARIO

/*************************************************************************
* TITULO ..: HOJA DE MATRICULA No. 03                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 05/2002 MAR A
       Colombia, Bucaramanga        INICIO: 06:00 PM   NOV 05/2002 MAR

OBJETIVOS:

1- Imprime la Hoja de Matricula No. 03

2- Esta es la Hoja de Matricula sugerida Colegio la Salle Bogot 

3- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION HojaMatr03(cCodigo,lNuevos,lRepite,nNroNiv,;
		    cNombre,cApelli,dFecNac,cLugNac,cNroNit,cLugNit,cDirecc,;
		    cBarrio,cTelefn,cCelEst,cMaiEst,;
		    cNomPad,cPadNit,cPadLug,cProPad,cEmpPad,cDirPad,cBarPad,;
		    cCarPad,cTelPad,cCelPad,cFaxPad,cBipPad,cMaiPad,;
		    cNomMad,cMadNit,cMadLug,cProMad,cEmpMad,cDirMad,cBarMad,;
		    cCarMad,cTelMad,cCelMad,cFaxMad,cBipMad,cMaiMad,;
		    cParAcu,;
		    cNomAcu,cAcuNit,cAcuLug,cProAcu,cEmpAcu,cDirAcu,cBarAcu,;
		    cCarAcu,cTe1Acu,cCelAcu,cFaxAcu,cBipAcu,cMaiAcu,;
		    dFecMat,cHorMat,cObserv,cNomSis,cNomEmp,cAnoUsr,cJorTxt,;
		    cCodIso,lMatric)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodigo                              // C¢digo de la estudiante
       lNuevos                              // .T. Alumno Nuevo
       lRepite                              // .T. Alumno Repitente
       nNroNiv				    // N£mero de Nivel
       cNombre                              // Nombres del aspirante
       cApelli                              // Apellidos del aspirante
       dFecNac                              // Fecha de Nacimiento
       cLugNac                              // Lugar de Nacimiento
       cNroNit                              // Documento de identidad
       cLugNit                              // Lugar de documento
       cDirecc                              // Direccion del estudiante
       cBarrio                              // Barrio
       cTelefn                              // Telefono
       cCelEst                              //*Celular del Estudiante
       cMaiEst                              //*Mail del Estudiante
       cClgAnt                              //*Colegio de Procedencia

       cNomPad                              // Nombre del padre
       cPadNit                              // C‚dula del padre
       cPadLug                              // Lugar de la c‚dula
       cProPad                              // Profesion del padre
       cEmpPad			            // Empresa donde trabaja
       cDirPad                              //*Direcci¢n del Padre
       cBarPad                              //*Barrio del Padre
       cCarPad                              // Cargo en la Empresa
       cTelPad                              // Telefono del padre
       cCelPad                              //*Celular del Padre
       cFaxPad                              //*Fax del Padre
       cBipPad                              //*Bip del Padre
       cMaiPad                              //*EMail del Padre

       cParAcu                              // Parentesco del Acudiente
       cNomMad                              // Nombre de la madre
       cMadNit                              // C‚dula de la madre
       cMadLug                              // Lugar de la c‚dula de la madre
       cProMad                              // Profesion de la madre
       cEmpMad			            // Empresa donde trabaja
       cDirMad                              //*Direcci¢n de la Madre
       cBarMad                              //*Barrio de la Madre
       cCarMad                              // Cargo de la madre
       cTelMad                              // Telefono de la madre
       cCelMad                              //*Celular de la Madre
       cFaxMad                              //*Fax de la Madre
       cBipMad                              //*Biper de la Madre
       cMaiMad                              //*EMail del Padre

       cNomAcu                              // Nombre del acudiente
       cAcuNit                              // C‚dula del Acudiente
       cAcuLug                              // Lugar del Acudiente
       cProAcu                              //*Profesi¢n del Acudiente
       cEmpAcu                              //*Empresa del Acudiente
       cDirAcu                              //*Direcci¢n del Acudiente
       cBarAcu                              //*Barrio del Acudiente
       cCarAcu                              //*Cargo del Acudiente
       cTe1Acu                              // Telefono del Acudiente
       cCelAcu                              //*Celular del Acudiente
       cFaxAcu                              //*Fax del Acudiente
       cBipAcu                              //*Biper del Acudiente
       cMaiAcu                              //*Email del Acudiente

       dFecMat                              // Fecha de la Matricula
       cHorMat                              // Hora de la matricula
       cObserv			            // Observaci¢n uno para matr¡cula
       cNomSis                              // Nombre del Sistema
       cNomEmp                              // Nombre de la Empresa
       cAnoUsr                              // A¤o del usuario
       cJorTxt                              // Jornada Escogida
       cCodIso                              // C¢digo Iso
       lMatric                              // .T. Matricula .F. Prematricula */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nLenPrn := 0                   // Longitud de impresi¢n
       LOCAL cNroFol := ''                  // N£mero del Folio
       LOCAL cNroMat := ''                  // N£mero de la Matricula
       LOCAL cNroNiv := ''                  // Nivel Anterior
       LOCAL cClgAnt := ''                  // Colegio Anterior
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ACTIVACION DE LA IMPRESORA
       #INCLUDE "EPSONFX.PRG"

       @ PROW(),00 SAY GRAPHI_ON+CONDEN_OF+PROPOR_OF+DRAFT_ON
       @ PROW(),00 SAY NEGRA_ON+DOBGOL_ON+ELITE
       nLenPrn := n12Stan
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>COLEGIO DE PROCEDENCIA
       DO CASE
       CASE nNroNiv == 0
	    cNroNiv := '13'
       CASE nNroNiv > 0 .AND. nNroNiv <= 5
	    cNroNiv := '00'
       CASE nNroNiv >= 6 .AND. nNroNiv <= 11
	    cNroNiv := STR(nNroNiv-1,2)
	    lCorrecion(@cNroNiv)
       OTHERWISE
	    cNroNiv := '13'
       ENDCASE
*       cClgAnt := &('cCole'+cNroNiv+'Est')
*       cClgAnt := SUBS(cClgAnt,15,40)
*>>>>FIN COLEGIO DE PROCEDENCIA

*>>>>IMPRESION DEL ENCABEZADO
       @ PROW(),00 SAY DOBANC_ON+DOBALT_ON

       lMatric := IF(lMatric==NIL,.T.,lMatric)
       IF lMatric
	  cTxtPrn := 'MATRICULA CODIGO: '+cCodigo
       ELSE
	  cTxtPrn := 'PRE MATRICULA CODIGO: '+cCodigo
       ENDIF

       IF ANO->lPrnEmpAno
	  @ PROW()+6,((nLenPrn/2)-LEN(ALLTRIM(cNomEmp)))/2 SAY ALLTRIM(cNomEmp)
	  @ PROW()+2,((nLenPrn/2)-LEN(cTxtPrn))/2 SAY cTxtPrn
       ELSE
	  @ PROW()+8,((nLenPrn/2)-LEN(cTxtPrn))/2 SAY cTxtPrn
       ENDIF
       @ PROW(),00 SAY DOBANC_OF+DOBALT_OF

       cTxtPrn := 'GRADO: '+cNomNiv(nNroNiv)
       lNuevos := IF(lNuevos==NIL,.F.,lNuevos)
       lRepite := IF(lRepite==NIL,.F.,lRepite)
       DO CASE
       CASE lNuevos .AND. !lRepite
	    cTxtPrn += " (NUEVO)"
       CASE !lNuevos .AND. lRepite
	    cTxtPrn += " (REPITE)"
       OTHERWISE
	    cTxtPrn += " (ANTIGUO)"
       ENDCASE
       cTxtPrn += ' '+cAnoUsr+'. JORNADA: '+cJorTxt
       @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn
*>>>>FIN IMPRESION DEL ENCABEZADO

*>>>>DETALLES DE LA MATRICULA
       IF lMatric
	  IF EMPTY(dFecMat)
	     dFecMat := '__________'
	  ELSE
	     dFecMat := cFecha(dFecMat)
	  ENDIF
	  LineaPrn({SPACE(13)+'FOLIO No. _____________',cNroFol,;
		    'MATRICULA No. _____________',cNroMat,;
		    'FECHA MATRICULA:',dFecMat},2)
       ENDIF
*>>>>FIN DETALLES DE LA MATRICULA

*>>>>IMPRESION DEL CUERPO DEL FORMULARIO
       LineaPrn({SPACE(13)+'ALUMNO: ',RTRIM(cApelli)+' '+cNombre},2)
       LineaPrn({SPACE(13)+'NACIDO EN: ',cLugNac,;
		 SPACE(21)+'FECHA: ',cFecha(dFecNac)},1)
       LineaPrn({SPACE(13)+'IDENTIFICACION No: ',cNroNit,;
		 SPACE(17)+'DE' ,cLugNit},1)
       LineaPrn({SPACE(13)+'DIRECCION:',cDirecc},1)
       LineaPrn({SPACE(13)+'BARRIO:',cBarrio,;
		 SPACE(29)+'TELEFONO:',cTelefn},1)
       LineaPrn({SPACE(13)+'EMAIL:',cMaiEst,;
		 SPACE(06)+'CELULAR:'+cCelEst},1)
*       LineaPrn({SPACE(13)+'COLEGIO DE PROCEDENCIA:',cClgAnt},1)

       LineaPrn({SPACE(13)+'PADRE:',SUBS(cNomPad+SPACE(40),1,40),;
			    SPACE(06)+'TELEFONO:',cTelPad},2)
       LineaPrn({SPACE(13)+'C.C No.:',cPadNit,SPACE(28)+'DE:',cPadLug},1)
       LineaPrn({SPACE(13)+'PROFESION:',cProPad},1)
       LineaPrn({SPACE(13)+'EMPRESA:',cEmpPad,SPACE(18)+'CARGO:',cCarPad},1)
       LineaPrn({SPACE(13)+'DIRECCION:',cDirPad,;
		 SPACE(02)+'BARRIO:',cBarPad},1)
       LineaPrn({SPACE(13)+'EMAIL:',cMaiPad,;
		 SPACE(06)+'FAX:'+cFaxPad},1)
       LineaPrn({SPACE(13)+'CELULAR:',cCelPad,;
		 SPACE(30)+'BIPER:'+cBipPad},1)

       LineaPrn({SPACE(13)+'MADRE:',SUBS(cNomMad+SPACE(40),1,40),;
			    SPACE(06)+'TELEFONO:',cTelMad},2)
       LineaPrn({SPACE(13)+'C.C No.:',cMadNit,SPACE(28)+'DE:',cMadLug},1)
       LineaPrn({SPACE(13)+'PROFESION:',cProMad},1)
       LineaPrn({SPACE(13)+'EMPRESA:',cEmpMad,SPACE(18)+'CARGO:',cCarMad},1)
       LineaPrn({SPACE(13)+'DIRECCION:',cDirMad,;
		 SPACE(02)+'BARRIO:',cBarMad},1)
       LineaPrn({SPACE(13)+'EMAIL:',cMaiMad,;
		 SPACE(06)+'FAX:'+cFaxMad},1)
       LineaPrn({SPACE(13)+'CELULAR:',cCelMad,;
		 SPACE(30)+'BIPER:'+cBipMad},1)

       LineaPrn({SPACE(13)+'PARENTESCO DEL ACUDIENTE:',cParAcu},2)
       LineaPrn({SPACE(13)+'ACUDIENTE:',SUBS(cNomAcu+SPACE(40),1,40),;
		 SPACE(02)+'TELEFONO:',cTe1Acu},1)
       LineaPrn({SPACE(13)+'C.C No.:',cAcuNit,SPACE(28)+'DE:',cAcuLug},1)
       LineaPrn({SPACE(13)+'PROFESION:',cProAcu},1)
       LineaPrn({SPACE(13)+'EMPRESA:',cEmpAcu,SPACE(18)+'CARGO:',cCarAcu},1)
       LineaPrn({SPACE(13)+'DIRECCION:',cDirAcu,;
		 SPACE(02)+'BARRIO:',cBarAcu},1)
       LineaPrn({SPACE(13)+'EMAIL:',cMaiAcu,;
		 SPACE(06)+'FAX:'+cFaxAcu},1)
       LineaPrn({SPACE(13)+'CELULAR:',cCelAcu,;
		 SPACE(30)+'BIPER:'+cBipAcu},1)

       IF EMPTY(ANO->cObsMtrAno)
	  LineaPrn({SPACE(13)+'ACEPTAMOS LA CONFESIONALIDAD, FILOSOFIA, '+;
			      'ORIENTACION Y REGLAMENTO DEL COLEGIO.'},3)
       ELSE
	  LineaPrn({SPACE(13)+CONDEN_ON+ANO->cObsMtrAno+CONDEN_OF},2)
       ENDIF

       LineaPrn({SPACE(13)+REPL('_',30),SPACE(10)+REPL('_',30)},3)
       LineaPrn({SPACE(14)+"FIRMA DEL PADRE O ACUDIENTE",;
		 SPACE(20)+"FIRMA DEL ALUMNO"},1)

       LineaPrn({SPACE(13)+REPL('_',30),SPACE(10)+REPL('_',30)},3)
       LineaPrn({SPACE(25)+"RECTOR",;
		 SPACE(30)+"SECRETARIA"},1)

       DerechosPrn(cNomSis,cNomEmp,n20Stan)
       EJECT
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DEL CUERPO DEL FORMULARIO

/*************************************************************************
* TITULO ..: HOJA DE MATRICULA No. 04                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 19/2008 MIE A
       Colombia, Bucaramanga        INICIO: 08:30 AM   NOV 19/2008 MIE

OBJETIVOS:

1- Imprime la Hoja de Matricula No. 04

2- Hoja de Matricula codigo F-AM-04 versi¢n 2 del 20-10-2008

3- Formato aprobado por la Congregaci¢n de los Hermanos de las Escuelas
   Cristianas, Distrito Lasallista de Bogota.

4- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION HojaMatr04(cCodigo,lNuevos,lRepite,nNroNiv,cNombre,cApelli,dFecNac,;
		    cLugNac,cNroNit,cLugNit,cDirecc,cBarrio,cTelefn,cNomPad,;
		    cPadNit,cPadLug,cProPad,cEmpPad,cCarPad,cTelPad,cNomMad,;
		    cMadNit,cMadLug,cProMad,cEmpMad,cCarMad,cTelMad,cNomAcu,;
		    cAcuNit,cAcuLug,cTelAcu,dFecMat,cHorMat,cObserv,cNomSis,;
		    cNomEmp,cAnoUsr,cJorTxt,cCodIso,lMatric)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodigo                              // C¢digo de la estudiante
       lNuevos                              // .T. Alumno Nuevo
       lRepite                              // .T. Alumno Repitente
       nNroNiv				    // N£mero de Nivel
       cNombre                              // Nombres del aspirante
       cApelli                              // Apellidos del aspirante
       dFecNac                              // Fecha de Nacimiento
       cLugNac                              // Lugar de Nacimiento
       cNroNit                              // Documento de identidad
       cLugNit                              // Lugar de documento
       cDirecc                              // Direccion del estudiante
       cBarrio                              // Barrio
       cTelefn                              // Telefono
       cNomPad                              // Nombre del padre
       cPadNit                              // C‚dula del padre
       cPadLug                              // Lugar de la c‚dula
       cProPad                              // Profesion del padre
       cEmpPad			            // Empresa donde trabaja
       cCarPad                              // Cargo en la Empresa
       cTelPad                              // Telefono del padre
       cNomMad                              // Nombre de la madre
       cMadNit                              // C‚dula de la madre
       cMadLug                              // Lugar de la c‚dula de la madre
       cProMad                              // Profesion de la madre
       cEmpMad			            // Empresa donde trabaja
       cCarMad                              // Cargo de la madre
       cTelMad                              // Telefono de la madre
       cNomAcu                              // Nombre del acudiente
       cAcuNit                              // C‚dula del Acudiente
       cAcuLug                              // Lugar del Acudiente
       cTelAcu                              // Telefono del acudiente
       dFecMat                              // Fecha de la Matricula
       cHorMat                              // Hora de la matricula
       cObserv			            // Observaci¢n uno para matr¡cula
       cNomSis                              // Nombre del Sistema
       cNomEmp                              // Nombre de la Empresa
       cAnoUsr                              // A¤o del usuario
       cJorTxt                              // Jornada Escogida
       cCodIso                              // C¢digo Iso
       lMatric                              // .T. Matricula .F. Prematricula */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nLenPrn := 0                   // Longitud de impresi¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ACTIVACION DE LA IMPRESORA
       SendCodes(PCL({'GraphiOn','CondenOf','ProporOf','DraftOn'}))
       SendCodes(PCL({'NegraOn','DobGolOn','Elite'}))

       nLenPrn := PCL('n12Stan')
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL ENCABEZADO
       SendCodes(PCL({'DobAncOn','DobAncOn'}))

       lMatric := IF(lMatric==NIL,.T.,lMatric)
       IF lMatric
	  cTxtPrn := 'MATRICULA CODIGO: '+cCodigo
       ELSE
	  cTxtPrn := 'PRE MATRICULA CODIGO: '+cCodigo
       ENDIF

       IF ANO->lPrnEmpAno
	  @ PROW()+6,((nLenPrn/2)-LEN(ALLTRIM(cNomEmp)))/2 SAY ALLTRIM(cNomEmp)
	  @ PROW()+2,((nLenPrn/2)-LEN(cTxtPrn))/2 SAY cTxtPrn
       ELSE
	  @ PROW()+8,((nLenPrn/2)-LEN(cTxtPrn))/2 SAY cTxtPrn
       ENDIF
       SendCodes(PCL({'DobAncOf','DobAltOf'}))

       cCodIso := IF(cCodIso==NIL,'',cCodIso)
       DO CASE
       CASE LEN(ALLTRIM(cCodIso)) <= 12
	    @ PROW(),90 SAY cCodIso
       OTHERWISE
	    @ PROW(),132 SAY PCL('CondenOn')+cCodIso+PCL('CondenOf')
       ENDCASE

       cTxtPrn := 'NIVEL: '+cNomNiv(nNroNiv)
       lNuevos := IF(lNuevos==NIL,.F.,lNuevos)
       lRepite := IF(lRepite==NIL,.F.,lRepite)
       DO CASE
       CASE lNuevos .AND. !lRepite
	    cTxtPrn += " (NUEVO)"
       CASE !lNuevos .AND. lRepite
	    cTxtPrn += " (REPITE)"
       OTHERWISE
	    cTxtPrn += " (ANTIGUO)"
       ENDCASE
       cTxtPrn += ' '+cAnoUsr+'. JORNADA: '+cJorTxt

       IF EMPTY(cCodIso)
	  @ PROW()+2,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn
       ELSE
	  @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn
       ENDIF
*>>>>FIN IMPRESION DEL ENCABEZADO

*>>>>IMPRESION DEL CUERPO DEL FORMULARIO
       LineaPrn({SPACE(13)+'NOMBRE: ',RTRIM(cApelli)+' '+cNombre},3)

       IF lMatric 
	  @ PROW(),78 SAY 'FOLIO No. ______'
       ENDIF

       LineaPrn({SPACE(13)+'NACIDO EN: ',cLugNac,;
		 SPACE(21)+'FECHA: ',cFecha(dFecNac)},3)

       LineaPrn({SPACE(13)+'IDENTIFICACION No: ',cNroNit,;
		 SPACE(17)+'DE' ,cLugNit},2)

       LineaPrn({SPACE(13)+'DIRECCION:',cDirecc},2)
       LineaPrn({SPACE(13)+'BARRIO:',cBarrio,;
		 SPACE(29)+'TELEFONO:',cTelefn},1)

       LineaPrn({SPACE(13)+'PADRE:',SUBS(cNomPad+SPACE(40),1,40),;
			    SPACE(06)+'TELEFONO:',cTelPad},2)
       LineaPrn({SPACE(13)+'C.C No.:',cPadNit,SPACE(28)+'DE:',cPadLug},1)
       LineaPrn({SPACE(13)+'PROFESION:',cProPad},1)
       LineaPrn({SPACE(13)+'EMPRESA:',cEmpPad,SPACE(18)+'CARGO:',cCarPad},1)

       LineaPrn({SPACE(13)+'MADRE:',SUBS(cNomMad+SPACE(40),1,40),;
			    SPACE(06)+'TELEFONO:',cTelMad},2)
       LineaPrn({SPACE(13)+'C.C No.:',cMadNit,SPACE(28)+'DE:',cMadLug},1)
       LineaPrn({SPACE(13)+'PROFESION:',cProMad},1)
       LineaPrn({SPACE(13)+'EMPRESA:',cEmpMad,SPACE(18)+'CARGO:',cCarMad},1)

       LineaPrn({SPACE(13)+'ACUDIENTE:',SUBS(cNomAcu+SPACE(40),1,40),;
		 SPACE(02)+'TELEFONO:',cTelAcu},2)
       LineaPrn({SPACE(13)+'C.C No.:',cAcuNit,SPACE(28)+'DE:',cAcuLug},1)

/*
       IF !EMPTY(dFecMat) .AND. !EMPTY(cHorMat)
	  LineaPrn({SPACE(13)+'FECHA DE MATRICULA:',cFecha(dFecMat)+;
		   " "+cDia(DOW(dFecMat),3),SPACE(23)+cHoraSys(cHorMat)},3)
       ENDIF
*/

       IF EMPTY(cObserv)
	  LineaPrn({SPACE(13)+'OBSERVACIONES:',REPL('_',65)},3)
       ELSE
	  cObserv := ALLTRIM(cObserv)+REPL('_',65-LEN(ALLTRIM(cObserv)))
	  LineaPrn({SPACE(13)+'OBSERVACIONES:',cObserv},3)
       ENDIF
       LineaPrn({SPACE(13)+REPL('_',80)},1)
       LineaPrn({SPACE(13)+REPL('_',80)},1)
       LineaPrn({SPACE(13)+REPL('_',80)},1)

       IF EMPTY(ANO->cObsMtrAno)
	  LineaPrn({SPACE(13)+'ACEPTAMOS LA CONFESIONALIDAD,FILOSOFIA, '+;
			      'ORIENTACION Y MANUAL DE CONVIVENCIA '+;
			      'DEL COLEGIO.'},3)
       ELSE
	  LineaPrn({SPACE(13)+;
		   PCL('CondenOn')+ANO->cObsMtrAno+PCL('CondenOf')},2)
       ENDIF

       LineaPrn({SPACE(13)+REPL('_',30),SPACE(10)+REPL('_',30)},3)
       LineaPrn({SPACE(20)+"FIRMA DEL PADRE",;
		 SPACE(24)+"FIRMA DEL ALUMNO"},1)

       LineaPrn({SPACE(13)+REPL('_',30),SPACE(10)+REPL('_',30)},3)
       LineaPrn({SPACE(20)+"FIRMA DE LA MADRE",;
		 SPACE(22)+"FIRMA DEL ACUDIENTE"},1)

       LineaPrn({SPACE(13)+REPL('_',30),SPACE(10)+REPL('_',30)},3)
       LineaPrn({SPACE(25)+"RECTOR",;
		 SPACE(30)+"SECRETARIA"},1)

*       DerechosPrn(cNomSis,cNomEmp,n20Stan)
       EJECT
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DEL CUERPO DEL FORMULARIO


/*************************************************************************
* TITULO ..: HOJA DE MATRICULA No. 05                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 05/2010 MAR A
       Colombia, Bucaramanga        INICIO: 04:30 AM   OCT 05/2010 MAR

OBJETIVOS:

1- Imprime la Hoja de Matricula No. 05

2- Esta es la Hoja de Matricula con Colegios de Procedencia.

3- Esta hoja de matricula esta dise¤ada para implementar el formato
   F-AM-04 formato global del Distrito Lasallista de Bogot .

4- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION HojaMatr05(cCodigo,lNuevos,lRepite,nNroNiv,cNombre,cApelli,dFecNac,;
		    cLugNac,cNroNit,cLugNit,cDirecc,cBarrio,cTelefn,cCelEst,;
		    cMaiEst,;
		    cNomPad,cPadNit,cPadLug,cProPad,cEmpPad,cCarPad,cTelPad,;
		    cDirPad,cCelPad,;
		    cNomMad,cMadNit,cMadLug,cProMad,cEmpMad,cCarMad,cTelMad,;
		    cDirMad,cCelMad,;
		    cNomAcu,cAcuNit,cAcuLug,cTelAcu,cDirAcu,cProAcu,cCelAcu,;
		    dFecMat,cHorMat,cObserv,cNomSis,cNomEmp,cAnoUsr,cJorTxt,;
		    cCodIso,lMatric)


*>>>>DESCRIPCION DE PARAMETROS
/*     cCodigo                              // C¢digo de la estudiante
       lNuevos                              // .T. Alumno Nuevo
       lRepite                              // .T. Alumno Repitente
       nNroNiv				    // N£mero de Nivel
       cNombre                              // Nombres del aspirante
       cApelli                              // Apellidos del aspirante
       dFecNac                              // Fecha de Nacimiento
       cLugNac                              // Lugar de Nacimiento
       cNroNit                              // Documento de identidad
       cLugNit                              // Lugar de documento
       cDirecc                              // Direccion del estudiante
       cBarrio                              // Barrio
       cTelefn                              // Telefono
       cCelEst                              // Celular del Estudiante
       cMaiEst                              // Mail del Estudiante

       cNomPad                              // Nombre del padre
       cPadNit                              // C‚dula del padre
       cPadLug                              // Lugar de la c‚dula
       cProPad                              // Profesion del padre
       cEmpPad			            // Empresa donde trabaja
       cCarPad                              // Cargo en la Empresa
       cTelPad                              // Telefono del padre
       cDirPad                              // Direcci¢n del Padre
       cCelPad                              // Celular del Padre

       cNomMad                              // Nombre de la madre
       cMadNit                              // C‚dula de la madre
       cMadLug                              // Lugar de la c‚dula de la madre
       cProMad                              // Profesion de la madre
       cEmpMad			            // Empresa donde trabaja
       cCarMad                              // Cargo de la madre
       cTelMad                              // Telefono de la madre
       cDirMad                              // Direcci¢n de la Madre
       cCelMad                              // Celular de la Madre

       cNomAcu                              // Nombre del acudiente
       cAcuNit                              // C‚dula del Acudiente
       cAcuLug                              // Lugar del Acudiente
       cTelAcu                              // Telefono del acudiente
       cDirAcu                              // Direcci¢n del Acudiente
       cProAcu                              // Profesi¢n del Acudiente
       cCelAcu                              // Celular del Acudiente

       dFecMat                              // Fecha de la Matricula
       cHorMat                              // Hora de la matricula
       cObserv			            // Observaci¢n uno para matr¡cula
       cNomSis                              // Nombre del Sistema
       cNomEmp                              // Nombre de la Empresa
       cAnoUsr                              // A¤o del usuario
       cJorTxt                              // Jornada Escogida
       cCodIso                              // C¢digo Iso
       lMatric                              // .T. Matricula .F. Prematricula */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador

       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nLenPrn := 0                   // Longitud de impresi¢n
       LOCAL cCampo  := ''                  // Variable de Campo
       LOCAL cGrado  := ''                  // Grado
       LOCAL cAnoCol := ''                  // A¤o del Colegio
       LOCAL cNomCol := ''                  // Nombre del Colegio
       LOCAL cCiuCol := ''                  // Ciudad del Colegio
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ACTIVACION DE LA IMPRESORA
       SendCodes(PCL({'GraphiOn','CondenOf','ProporOf','DraftOn'}))
       SendCodes(PCL({'NegraOn','DobGolOn','Elite'}))

       nLenPrn := PCL('n12Stan')
*>>>>FIN ACTIVACION DE LA IMPRESORA


/*
       wait cCodigo
       wait lNuevos
       wait lRepite
       wait nNroNiv
       wait cNombre
       wait cApelli
       wait dFecNac
       wait cLugNac
       wait cNroNit
       wait cLugNit
       wait cDirecc
       wait cBarrio
       wait cTelefn
       wait cCelEst
       wait cMaiEst

       wait 'cNomPad'
       wait cNomPad

       wait 'cPadNit'
       wait cPadNit

       wait 'cPadLug'
       wait cPadLug

       wait 'cProPad'
       wait cProPad

       wait 'cEmpPad'
       wait cEmpPad

       wait 'cCarPad'
       wait cCarPad

       wait 'cTelPad'
       wait cTelPad

       wait 'cDirPad'
       wait cDirPad

       wait 'cCelPad'
       wait cCelPad




       wait 'cNomMad'
       wait cNomMad

       wait 'cMadNit'
       wait cMadNit

       wait 'cMadLug'
       wait cMadLug

       wait 'cProMad'
       wait cProMad

       wait 'cEmpMad'
       wait cEmpMad

       wait 'cCarMad'
       wait cCarMad

       wait 'cTelMad'
       wait cTelMad

       wait 'cDirMad'
       wait cDirMad

       wait 'cCelMad'
       wait cCelMad

       wait cNomAcu
       wait cAcuNit
       wait cAcuLug
       wait cTelAcu
       wait cDirAcu
       wait cProAcu
       wait cCelAcu

       wait dFecMat
       wait cHorMat
       wait cObserv
       wait cNomSis
       wait cNomEmp
       wait cAnoUsr
       wait cJorTxt
       wait cCodIso
       wait lMatric

*/

*>>>>FORMATO F-AM-04 30-09-2010
       LineaPrn({SPACE(13)+'INSTITUCION EDUCATIVA: ',ALLTRIM(cNomEmp)},6)


       IF !EMPTY(dFecMat)

	  LineaPrn({SPACE(13)+'CODIGO:',cCodigo,;
		    +'A¥O:',cAnoUsr,;
		    'GRADO:',cNomNiv(nNroNiv),;
		    'FECHA MATRICULA: D¡a:   Mes:   A¤o:  '},2)

       ELSE

	  LineaPrn({SPACE(13)+'CODIGO:',cCodigo,;
		    +'A¥O:',cAnoUsr,;
		    'GRADO:',cNomNiv(nNroNiv),;
		    'FECHA MATRICULA: D¡a:   Mes:   A¤o:  '},2)

       ENDIF


       LineaPrn({SPACE(33)+'FOLIO No. ',REPL('_',10),;
		 SPACE(04)+'MATRICULA No',REPL('_',10)},3)



       LineaPrn({SPACE(13)+'ESTUDIANTE: ',RTRIM(cApelli)+' '+cNombre},2)

       LineaPrn({SPACE(13)+'LUGAR Y FECHA NACIMIENTO: ',cLugNac,;
		 'FECHA: ',cFecha(dFecNac)},1)


       LineaPrn({SPACE(13)+'DOCUMENTO DE IDENTIDAD: ',cNroNit,;
		 SPACE(06)+'EXPEDIDO EN:' ,cLugNit},1)

       LineaPrn({SPACE(13)+'DIRECCION RESIDENCIA:',cDirecc},1)


       LineaPrn({SPACE(13)+'BARRIO:',cBarrio,;
		 SPACE(24)+'TELEFONO FIJO:',cTelefn},1)


       LineaPrn({SPACE(13)+'CORREO ELECTRONICO:',cMaiEst,;
		 'CELULAR:'+SUBS(cCelEst,1,13)},1)

       cDirPad := ALLTRIM(cDirPad)+SPACE(40)
       cDirPad := SUBS(cDirPad,1,40)

       LineaPrn({SPACE(13)+'PADRE: ',SUBS(cNomPad+SPACE(40),1,40)},2)
       LineaPrn({SPACE(13)+'DOCUMENTO DE IDENTIDAD:',cPadNit,SPACE(12)+'EXPEDIDO EN:',cPadLug},1)
       LineaPrn({SPACE(13)+'DIRECCION:'             ,cDirPad,SPACE(01)+'PROFESION:',SUBS(cProPad,1,18)},1)
       LineaPrn({SPACE(13)+'TELEFONOS FIJOS:'       ,cTelPad,SPACE(21)+'CELULAR:',cCelPad},1)

       cDirMad := ALLTRIM(cDirMad)+SPACE(40)
       cDirMad := SUBS(cDirMad,1,40)

       LineaPrn({SPACE(13)+'MADRE: ',SUBS(cNomMad+SPACE(40),1,40)},2)
       LineaPrn({SPACE(13)+'DOCUMENTO DE IDENTIDAD:',cMadNit,SPACE(12)+'EXPEDIDO EN:',cMadLug},1)
       LineaPrn({SPACE(13)+'DIRECCION:'             ,cDirMad,SPACE(01)+'PROFESION:',SUBS(cProMad,1,18)},1)
       LineaPrn({SPACE(13)+'TELEFONOS FIJOS:'       ,cTelMad,SPACE(21)+'CELULAR:',cCelMad},1)

       cDirAcu := ALLTRIM(cDirAcu)+SPACE(40)
       cDirAcu := SUBS(cDirAcu,1,40)

       LineaPrn({SPACE(13)+'ACUDIENTE: ',SUBS(cNomAcu+SPACE(40),1,40)},2)
       LineaPrn({SPACE(13)+'DOCUMENTO DE IDENTIDAD:',cAcuNit,SPACE(12)+'EXPEDIDO EN:',cAcuLug},1)
       LineaPrn({SPACE(13)+'DIRECCION:'             ,cDirAcu,SPACE(01)+'PROFESION:',SUBS(cProAcu,1,18)},1)
       LineaPrn({SPACE(13)+'TELEFONOS FIJOS:'       ,cTelAcu,SPACE(21)+'CELULAR:',cCelAcu},1)

       IF !EMPTY(cCole13Est+;
		 cCole00Est+cCole01Est+cCole02Est+cCole03Est+;
		 cCole04Est+cCole05Est+;
		 cCole06Est+cCole07Est+cCole08Est+cCole09Est+;
		 cCole10Est+cCole11Est+;
		 cCole12Est)


	  LineaPrn({SPACE(31)+'HISTORIAL ACADEMICO DEL ESTUDIANTE'},2)
	  LineaPrn({SPACE(13)+'GRADO',SPACE(05)+'A¥O',SPACE(00),;
		    'COLEGIO',SPACE(32),'CIUDAD'},1)


       ENDIF

       cNroCam := '1213000102030405060708091011'
       FOR i := 1 TO 14
	   cCampo := 'cCole'+SUBS(cNroCam,i*2-1,2)+'Est'
	   cCampo := &cCampo
	   IF !EMPTY(cCampo)

	      cAnoCol := SUBS(cCampo,01,04)
	      cGrado  := SUBS(cCampo,05,10)
	      cNomCol := SUBS(cCampo,15,40)
	      cCiuCol := SUBS(cCampo,55,20)


/*
wait 'cCampo'
wait cCampo

wait 'cAnoCol'
wait cAnoCol

wait 'cGrado'
wait cGrado

wait 'cNomCol'
wait cNomCol

wait cCiuCol
wait cCiuCol
*/



	      LineaPrn({SPACE(13)+cGrado,cAnoCol,cNomCol,cCiuCol},1)

	   ENDIF
       ENDFOR


       LineaPrn({SPACE(13)+ANO->cObsMtrAno},2)

       LineaPrn({SPACE(13)+REPL('_',41),SPACE(10)+REPL('_',30)},3)
       LineaPrn({SPACE(17)+"FIRMA DEL PADRE,MADRE O ACUDIENTE",;
		 SPACE(21)+"FIRMA DEL ALUMNO"},1)

       LineaPrn({SPACE(13)+REPL('_',41),SPACE(10)+REPL('_',30)},3)
       LineaPrn({SPACE(28)+"RECTOR",;
		 SPACE(38)+"SECRETARIA"},1)

       DerechosPrn(cNomSis,cNomEmp,n20Stan)
       EJECT
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN FORMATO F-AM-04 30-09-2010



*>>>>IMPRESION DEL ENCABEZADO

*>>>>FIN IMPRESION DEL CUERPO DEL FORMULARIO