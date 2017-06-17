/*                    SIMA - MATRICULA ACADEMICA
      BIBLIOTECAS DE FUNCIONES PARA EL DISE¥O DE LA ORDEN DE MATRICULA

REQUERIMIENTOS:

- Compilar: clipper fTipoAdm /w/m/b

OBJETIVOS:

- Funciones aplicadas para los diferentes Ordenes de matr¡cula

***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO..: IMPRESION DE LA ORDEN DE MATRICULA No. 1                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 14/96 JUE A
       Colombia, Bucaramanga        INICIO: 05:25 PM   AGO 14/96 JUE

OBJETIVOS:

1- Imprime la Orden de Matr¡cula No. 01

2- Esta es la Orden de Matr¡cula por defecto del sistema.

3- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OrdenMtr01(cCodigo,cCodGru,cNombre,cApelli,;
		    lRepite,cNomSis,cNomEmp,nPrnOrd,;
		    cCodIso)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodigo                              // C¢digo del estudiante
       cCodGru			            // C¢digo del Grupo
       cNombre                              // Nombres del estudiante
       cApelli                              // Apellidos del estudiante
       lRepite                              // .T. Repitente
       cNomSis                              // Nombre del Sistema
       cNomEmp                              // Nombre de la empresa
       nPrnOrd			            // Tipo Orden de Matr¡cula
       cCodIso                              // C¢digo del Iso */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"
       #DEFINE  PAGINA33 CHR(27)+'C'+CHR(33)// P gina de 33 l¡neas

       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nLenPrn := 0                   // Longitud de impresi¢n
       LOCAL aNivel  := {}                  // Nombre de los Niveles
       LOCAL nNroNiv := 0                   // N£mero del nivel
       LOCAL aFirmas := {}                  // Firmas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ACTIVACION DE LA IMPRESORA
       nPrnOrd := IF(nPrnOrd == NIL,2,nPrnOrd)
       IF nPrnOrd == 4 // Actualizaci¢n de datos
	  @ PROW(),00 SAY PAGINA33
       ENDIF
       @ PROW(),00 SAY GRAPHI_ON+CONDEN_OF+PROPOR_OF+DRAFT_ON
       @ PROW(),00 SAY NEGRA_ON+DOBGOL_ON+ELITE
       nLenPrn := n12Stan
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL FORMULARIO
       @ PROW(),00 SAY DOBANC_ON+DOBALT_ON

       IF nPrnOrd # 4 .AND. ANO->lPrnEmpAno
	  cTxtPrn := cNomEmp
	  @ PROW()+3,((nLenPrn/2)-LEN(cTxtPrn))/2 SAY cTxtPrn
       ENDIF

       DO CASE
       CASE nPrnOrd == 1
	    cTxtPrn := 'PREMATRICULA'

       CASE nPrnOrd == 2
	    cTxtPrn := 'ORDEN DE MATRICULA'

       CASE nPrnOrd == 3
	    cTxtPrn := 'SOLICITUD DE CUPO'

       CASE nPrnOrd == 4
	    cTxtPrn := 'ACTUALIZACION DE DATOS'
       ENDCASE

       cTxtPrn += '.CODIGO:'+cCodigo

       @ PROW()+IF(nPrnOrd==4,1,3),((nLenPrn/2)-LEN(cTxtPrn))/2 SAY cTxtPrn
       @ PROW(),00 SAY DOBANC_OF+DOBALT_OF

       aNivel := {'TRANSICION','PRIMERO'    ,'SEGUNDO' ,'TERCERO',;
		  'CUARTO'    ,'QUINTO'     ,'SEXTO'   ,'SEPTIMO',;
		  'OCTAVO'    ,'NOVENO'     ,'DECIMO'  ,'UNDECIMO',;
		  'MATERNALES','CAMINADORES','PARVULOS',;
		  'PREJARDIN' ,'JARDIN'}

       lRepite := IF(lRepite == NIL,.F.,lRepite)
       nNroNiv := VAL(SUBS(cCodGru,1,2))

       IF nPrnOrd # 4
	  DO CASE
	  CASE nNroNiv == 16
	       nNroNiv := IF(lRepite,17,0)
	  CASE nNroNiv == 17
	       nNroNiv := IF(lRepite,1,1)
	  OTHERWISE
	       nNroNiv++
	  ENDCASE

	  IF !lRepite
	     nNroNiv++
	  ENDIF
	  cTxtPrn := IF(lRepite,'REPITE','PARA')+;
		     ' EL GRADO '+aNivel[nNroNiv]
       ELSE
	  cTxtPrn := 'GRADO:'+cCodGru
       ENDIF

       cCodIso := IF(cCodIso==NIL,'',cCodIso)
       @ PROW()+1,90 SAY cCodIso

       IF EMPTY(cCodIso)
	  @ PROW()+2,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn
       ELSE
	  @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn
       ENDIF

       @ PROW()+IF(nPrnOrd==4,1,3),01 SAY 'NOMBRE: '+RTRIM(cApelli)+' '+;
				       cNombre+' '+'SEXO: M__ F__'

       aTitulo := {'NACIDO EN:',REPL('_',30),REPL('_',30),;
		   'EL',REPL('_',04),;
		   REPL('_',04),REPL('_',04)}
       aTamCol := {LEN(aTitulo[1]),LEN(aTitulo[2]),;
		   LEN(aTitulo[3]),LEN(aTitulo[4]),;
		   LEN(aTitulo[5]),LEN(aTitulo[6]),;
		   LEN(aTitulo[7])}
       cRegPrint(aTitulo,aTamCol,aNroCol)
       @ PROW()+2,aNroCol[1] SAY aTitulo[1]
       @ PROW(),  aNroCol[2] SAY aTitulo[2]
       @ PROW(),  aNroCol[3] SAY aTitulo[3]
       @ PROW(),  aNroCol[4] SAY aTitulo[4]
       @ PROW(),  aNroCol[5] SAY aTitulo[5]
       @ PROW(),  aNroCol[6] SAY aTitulo[6]
       @ PROW(),  aNroCol[7] SAY aTitulo[7]

       @ PROW()+1,aNroCol[2]+11 SAY 'CIUDAD'
       @ PROW(),  aNroCol[3]+07 SAY 'DEPARTAMENTO'
       @ PROW(),  aNroCol[5]    SAY 'MES'
       @ PROW(),  aNroCol[6]    SAY 'DIA'
       @ PROW(),  aNroCol[7]    SAY 'A¥O'

       LineaPrn({'IDENTIFICACION: ',REPL('_',04),;
		 'No' ,REPL('_',30),;
		 'DE' ,REPL('_',31)})
       LineaPrn({'DIRECCION:',REPL('_',49),'BARRIO:',REPL('_',21)})
       LineaPrn({'CIUDAD:',REPL('_',20),'TEL:',REPL('_',20),;
		 'E-MAIL:',REPL('_',27)})

       LineaPrn({'APELLIDOS PADRE:',REPL('_',30),;
		 'NOMBRES PADRE:',REPL('_',27)},2)
       LineaPrn({'IDENTIFICACION: ____ No.:',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'TEL:',REPL('_',13)})
       LineaPrn({'EMPRESA:',REPL('_',38),'CARGO:',REPL('_',35)},1)
       LineaPrn({'DIRECCION:',REPL('_',49),'BARRIO:',REPL('_',21)})
       LineaPrn({'CIUDAD:',REPL('_',20),'PROFESION:',REPL('_',20),;
		 'E-MAIL:',REPL('_',21)})

       LineaPrn({'APELLIDOS MADRE:',REPL('_',30),;
		 'NOMBRES MADRE:',REPL('_',27)},2)
       LineaPrn({'IDENTIFICACION: ____ No.:',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'TEL:',REPL('_',13)})
       LineaPrn({'EMPRESA:',REPL('_',38),'CARGO:',REPL('_',35)},1)
       LineaPrn({'DIRECCION:',REPL('_',49),'BARRIO:',REPL('_',21)})
       LineaPrn({'CIUDAD:',REPL('_',20),'PROFESION:',REPL('_',20),;
		 'E-MAIL:',REPL('_',21)})

       LineaPrn({'APELLIDOS ACUDIENTE:',REPL('_',26),;
		 'NOMBRES ACUDIENTE:',REPL('_',23)},2)
       LineaPrn({'IDENTI: ____ No.:',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'PARENTESCO:',REPL('_',14)})
       LineaPrn({'DIRECCION:',REPL('_',28),;
		 'BARRIO:',REPL('_',18),;
		 'TEL CASA:',REPL('_',13)})
       LineaPrn({'CIUDAD:',REPL('_',20),'TEL OFI:',REPL('_',16),;
		 'E-MAIL:',REPL('_',27)})

       IF nPrnOrd # 4
	  LineaPrn({'OBSERVACIONES ',REPL('_',75)},3)
	  @ PROW()+1,01 SAY REPL('_',90)
	  @ PROW()+1,01 SAY REPL('_',90)
	  @ PROW()+1,01 SAY REPL('_',90)
       ENDIF

       IF nPrnOrd # 4
	  IF nPrnOrd == 2
	     LineaPrn({'MATRICULARSE EN FECHA ',REPL('_',10),;
		       'HORA'                  ,REPL('_',10),;
		       'LUGAR'                 ,REPL('_',20),;
		       'MESA No:',REPL('_',02)},5)

	  ELSE

	     LineaPrn({CONDEN_ON+ANO->cObsMtrAno+CONDEN_OF},2)

	     aFirmas := {{'Firma del Padre',NIL,' '},;
			 {'Firma de la Madre',NIL,' '}}

	     @ PROW(),00 SAY CONDEN_ON
	     Firmas(PCL('n17Stan'),5,aFirmas)
	     @ PROW(),00 SAY CONDEN_ON
	  ENDIF
	  DerechosPrn(cNomSis,cNomEmp,n20Stan)
       ELSE
	  @ PROW()+3,01 SAY '>'+REPL('=',88)+'<'
       ENDIF

       EJECT
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DEL FORMULARIO

/*************************************************************************
* TITULO..: IMPRESION DE LA ORDEN DE MATRICULA No. 2                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 14/96 JUE A
       Colombia, Bucaramanga        INICIO: 05:25 PM   AGO 14/96 JUE

OBJETIVOS:

1- Imprime la Orden de Matr¡cula No. 01

2- Esta es la Orden de Matr¡cula con Colegios de Procedencia.

3- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OrdenMtr02(cCodigo,cCodGru,cNombre,cApelli,;
		    lRepite,cNomSis,cNomEmp,nPrnOrd)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodigo                              // C¢digo del estudiante
       cCodGru			            // C¢digo del Grupo
       cNombre                              // Nombres del estudiante
       cApelli                              // Apellidos del estudiante
       lRepite                              // .T. Repitente
       cNomSis                              // Nombre del Sistema
       cNomEmp                              // Nombre de la empresa
       nPrnOrd			            // Tipo de Orden de matricula */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
*       #INCLUDE "EPSONFX.PRG"

       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nLenPrn := 0                   // Longitud de impresi¢n
       LOCAL aNivel  := {}                  // Nombre de los Niveles
       LOCAL nNroNiv := 0                   // N£mero del nivel
       LOCAL aFirmas := {}                  // Firmas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ACTIVACION DE LA IMPRESORA
       @ PROW(),00 SAY GRAPHI_ON+CONDEN_OF+PROPOR_OF+DRAFT_ON
       @ PROW(),00 SAY NEGRA_ON+DOBGOL_ON+ELITE
       nLenPrn := n12Stan
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL FORMULARIO DE ORDEN DE MATRICULA
       @ PROW(),00 SAY DOBANC_ON+DOBALT_ON

       IF nPrnOrd # 4 .AND. ANO->lPrnEmpAno
	  cTxtPrn := cNomEmp
	  @ PROW()+3,((nLenPrn/2)-LEN(cTxtPrn))/2 SAY cTxtPrn
       ENDIF

       nPrnOrd := IF(nPrnOrd == NIL,2,nPrnOrd)
       DO CASE
       CASE nPrnOrd == 1
	    cTxtPrn := 'PREMATRICULA'

       CASE nPrnOrd == 2
	    cTxtPrn := 'ORDEN DE MATRICULA'

       CASE nPrnOrd == 3
	    cTxtPrn := 'SOLICITUD DE CUPO'

       CASE nPrnOrd == 4
	    cTxtPrn := 'ACTUALIZACION DE DATOS'
       ENDCASE
       cTxtPrn += '.CODIGO:'+cCodigo

       @ PROW()+IF(nPrnOrd==4,1,3),((nLenPrn/2)-LEN(cTxtPrn))/2 SAY cTxtPrn
       @ PROW(),00 SAY DOBANC_OF+DOBALT_OF

       aNivel := {'TRANSICION','PRIMERO'    ,'SEGUNDO' ,'TERCERO',;
		  'CUARTO'    ,'QUINTO'     ,'SEXTO'   ,'SEPTIMO',;
		  'OCTAVO'    ,'NOVENO'     ,'DECIMO'  ,'UNDECIMO',;
		  'MATERNALES','CAMINADORES','PARVULOS',;
		  'PREJARDIN' ,'JARDIN'}

       lRepite := IF(lRepite == NIL,.F.,lRepite)
       nNroNiv := VAL(SUBS(cCodGru,1,2))

       IF nPrnOrd # 4
	  DO CASE
	  CASE nNroNiv == 16
	       nNroNiv := IF(lRepite,17,0)
	  CASE nNroNiv == 17
	       nNroNiv := IF(lRepite,1,1)
	  OTHERWISE
	       nNroNiv++
	  ENDCASE

	  IF !lRepite
	     nNroNiv++
	  ENDIF
	  cTxtPrn := IF(lRepite,'REPITE','PARA')+;
		     ' EL GRADO '+aNivel[nNroNiv]
       ELSE
	  cTxtPrn := 'GRADO:'+cCodGru
       ENDIF
       @ PROW()+2,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn

       @ PROW()+IF(nPrnOrd==4,1,2),01 SAY 'NOMBRE: '+RTRIM(cApelli)+' '+;
				       cNombre+' '+'SEXO: M__ F__'

       aTitulo := {'NACIDO EN:',REPL('_',30),REPL('_',30),;
		   'EL',REPL('_',04),;
		   REPL('_',04),REPL('_',04)}
       aTamCol := {LEN(aTitulo[1]),LEN(aTitulo[2]),;
		   LEN(aTitulo[3]),LEN(aTitulo[4]),;
		   LEN(aTitulo[5]),LEN(aTitulo[6]),;
		   LEN(aTitulo[7])}
       cRegPrint(aTitulo,aTamCol,aNroCol)
       @ PROW()+2,aNroCol[1] SAY aTitulo[1]
       @ PROW(),  aNroCol[2] SAY aTitulo[2]
       @ PROW(),  aNroCol[3] SAY aTitulo[3]
       @ PROW(),  aNroCol[4] SAY aTitulo[4]
       @ PROW(),  aNroCol[5] SAY aTitulo[5]
       @ PROW(),  aNroCol[6] SAY aTitulo[6]
       @ PROW(),  aNroCol[7] SAY aTitulo[7]

       @ PROW()+1,aNroCol[2]+11 SAY 'CIUDAD'
       @ PROW(),  aNroCol[3]+07 SAY 'DEPARTAMENTO'
       @ PROW(),  aNroCol[5]    SAY 'MES'
       @ PROW(),  aNroCol[6]    SAY 'DIA'
       @ PROW(),  aNroCol[7]    SAY 'A¥O'

       LineaPrn({'IDENTIFICACION: ',REPL('_',04),;
		 'No' ,REPL('_',30),;
		 'DE' ,REPL('_',31)})
       LineaPrn({'DIRECCION:',REPL('_',49),'BARRIO:',REPL('_',21)})
       LineaPrn({'CIUDAD:',REPL('_',20),'TEL:',REPL('_',20),;
		 'E-MAIL:',REPL('_',27)})

       LineaPrn({'APELLIDOS PADRE:',REPL('_',30),;
		 'NOMBRES PADRE:',REPL('_',27)},2)
       LineaPrn({'IDENTIFICACION: ____ No.:',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'TEL:',REPL('_',13)})
       LineaPrn({'EMPRESA:',REPL('_',38),'CARGO:',REPL('_',35)},1)
       LineaPrn({'DIRECCION:',REPL('_',49),'BARRIO:',REPL('_',21)})
       LineaPrn({'CIUDAD:',REPL('_',20),'PROFESION:',REPL('_',20),;
		 'E-MAIL:',REPL('_',21)})

       LineaPrn({'APELLIDOS MADRE:',REPL('_',30),;
		 'NOMBRES MADRE:',REPL('_',27)},2)
       LineaPrn({'IDENTIFICACION: ____ No.:',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'TEL:',REPL('_',13)})
       LineaPrn({'EMPRESA:',REPL('_',38),'CARGO:',REPL('_',35)},1)
       LineaPrn({'DIRECCION:',REPL('_',49),'BARRIO:',REPL('_',21)})
       LineaPrn({'CIUDAD:',REPL('_',20),'PROFESION:',REPL('_',20),;
		 'E-MAIL:',REPL('_',21)})

       LineaPrn({'APELLIDOS ACUDIENTE:',REPL('_',26),;
		 'NOMBRES ACUDIENTE:',REPL('_',23)},2)
       LineaPrn({'IDENTI: ____ No.:',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'PARENTESCO:',REPL('_',14)})
       LineaPrn({'DIRECCION:',REPL('_',28),;
		 'BARRIO:',REPL('_',18),;
		 'TEL CASA:',REPL('_',13)})
       LineaPrn({'CIUDAD:',REPL('_',20),'TEL OFI:',REPL('_',16),;
		 'MAIL:',REPL('_',29)})

       LineaPrn({SPACE(35)+'COLEGIOS DE PROCEDENCIA'},2)
       LineaPrn({'PREESCOLAR:'},1)
       LineaPrn({'A¥O'        ,SPACE(02),'NIVEL'      ,SPACE(10),;
		 'INSTITUCION',SPACE(30),'CIUDAD'},1)
       LineaPrn({REPL('_',04),SPACE(01),REPL('_',15),SPACE(00),;
		 REPL('_',40),SPACE(01),REPL('_',23)},1)
       LineaPrn({'PRIMARIA:'},1)
       LineaPrn({REPL('_',04),SPACE(01),REPL('_',15),SPACE(00),;
		 REPL('_',40),SPACE(01),REPL('_',23)},1)
       LineaPrn({'BACHILLERATO:'},1)
       LineaPrn({REPL('_',04),SPACE(01),REPL('_',15),SPACE(00),;
		 REPL('_',40),SPACE(01),REPL('_',23)},1)
       LineaPrn({REPL('_',04),SPACE(01),REPL('_',15),SPACE(00),;
		 REPL('_',40),SPACE(01),REPL('_',23)},1)
       LineaPrn({REPL('_',04),SPACE(01),REPL('_',15),SPACE(00),;
		 REPL('_',40),SPACE(01),REPL('_',23)},1)
       LineaPrn({REPL('_',04),SPACE(01),REPL('_',15),SPACE(00),;
		 REPL('_',40),SPACE(01),REPL('_',23)},1)
       LineaPrn({REPL('_',04),SPACE(01),REPL('_',15),SPACE(00),;
		 REPL('_',40),SPACE(01),REPL('_',23)},1)
       LineaPrn({REPL('_',04),SPACE(01),REPL('_',15),SPACE(00),;
		 REPL('_',40),SPACE(01),REPL('_',23)},1)
       LineaPrn({REPL('_',04),SPACE(01),REPL('_',15),SPACE(00),;
		 REPL('_',40),SPACE(01),REPL('_',23)},1)

       IF nPrnOrd # 4
	  LineaPrn({'OBSERVACIONES ',REPL('_',75)},2)
	  @ PROW()+1,01 SAY REPL('_',90)
	  @ PROW()+1,01 SAY REPL('_',90)
       ENDIF

       IF nPrnOrd # 4
	  IF nPrnOrd == 2
	     LineaPrn({'MATRICULARSE EN FECHA ',REPL('_',10),;
		       'HORA'                  ,REPL('_',10),;
		       'LUGAR'                 ,REPL('_',20),;
		       'MESA No:',REPL('_',02)},2)

	  ELSE

	     LineaPrn({CONDEN_ON+ANO->cObsMtrAno+CONDEN_OF},2)
	     aFirmas := {{'Firma del Padre',NIL,' '},;
			 {'Firma de la Madre',NIL,' '}}

	     @ PROW(),00 SAY CONDEN_ON
	     Firmas(PCL('n17Stan'),3,aFirmas)
	     @ PROW(),00 SAY CONDEN_ON
	  ENDIF
	  DerechosPrn(cNomSis,cNomEmp,n20Stan)
       ELSE
	  @ PROW()+3,01 SAY '>'+REPL('=',88)+'<'
       ENDIF

       DerechosPrn(cNomSis,cNomEmp,n20Stan)
       EJECT
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DEL FORMULARIO DE ORDEN DE MATRICULA

/*************************************************************************
* TITULO..: ORDEN DE MATRICULA No. 3                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 14/96 JUE A
       Colombia, Bucaramanga        INICIO: 05:25 PM   AGO 14/96 JUE

OBJETIVOS:

1- Imprime la Orden de Matr¡cula No. 03

2- Esta orden de matr¡cula equivale a una solicitu de cupo

3- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OrdenMtr03(cCodigo,cCodGru,cNombre,cApelli,;
		    lRepite,cNomSis,cNomEmp,cAnoUsr)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodigo                              // C¢digo del estudiante
       cCodGru			            // C¢digo del Grupo
       cNombre                              // Nombres del estudiante
       cApelli                              // Apellidos del estudiante
       lRepite                              // .T. Repitente
       cNomSis                              // Nombre del Sistema
       cNomEmp                              // Nombre de la empresa */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
*       #INCLUDE "EPSONFX.PRG"
*       #DEFINE  PAGINA33 CHR(27)+'C'+CHR(33)// P gina de 33 l¡neas

       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nLenPrn := 0                   // Longitud de impresi¢n
       LOCAL aNivel  := {}                  // Nombre de los Niveles
       LOCAL nNroNiv := 0                   // N£mero del nivel
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ACTIVACION DE LA IMPRESORA
       @ PROW(),00 SAY PAGINA33
       @ PROW(),00 SAY GRAPHI_ON+CONDEN_OF+PROPOR_OF+DRAFT_ON
       @ PROW(),00 SAY NEGRA_ON+DOBGOL_ON+ELITE+PAGINA33

       nLenPrn := n12Stan
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL FORMULARIO DE ORDEN DE MATRICULA
       @ PROW(),00 SAY DOBANC_ON+DOBALT_ON

       cTxtPrn := cNomEmp
       @ PROW()+1,((nLenPrn/2)-LEN(cTxtPrn))/2 SAY cTxtPrn
       @ PROW(),00 SAY DOBANC_OF+DOBALT_OF

       cTxtPrn := 'SOLICITUD DE CUPO PARA CONTINUAR ESTUDIOS EN EL PLANTEL'
       @ PROW()+2,((nLenPrn)-LEN(cTxtPrn))/2 SAY cTxtPrn

       @ PROW()+2,01 SAY 'APELLIDOS Y NOMBRE DEL ALUMNO: '+;
			 RTRIM(cApelli)+' '+cNombre+'CURSO: '+cCodGru

       LineaPrn({'GRADO AL QUE INGRESA:',REPL('_',78)},2)

       LineaPrn({'NOMBRE DEL PADRE:',REPL('_',42),;
		 'CC No.:',REPL('_',31)},2)

       LineaPrn({'DIRECCION:',REPL('_',46),;
		 'TELEFONO:',REPL('_',32)},2)

       LineaPrn({'SITIO DE TRABAJO:',REPL('_',40),;
		 'CARGO:',REPL('_',34)},2)

       LineaPrn({'NOMBRE DE LA MADRE:',REPL('_',40),;
		 'CC No.:',REPL('_',31)},2)

       LineaPrn({'DIRECCION:',REPL('_',46),;
		 'TELEFONO:',REPL('_',32)},2)

       LineaPrn({'SITIO DE TRABAJO:',REPL('_',28),;
		 'CARGO:',REPL('_',26),;
		 'TELEFONO' ,REPL('_',10)},2)

       LineaPrn({'RESERVAMOS EL CUPO PARA EL A¥O '+cAnoUsr,'',;
		 'SI:',REPL('_',04),;
		 'NO:',REPL('_',04)},2)

       LineaPrn({'AL RESERVAR EL CUPO NOS COMPROMETEMOS A MATRICULAR '+;
		 'A NUESTRO HIJO(A) EN LA FECHA PREVISTA POR',''},3)
       LineaPrn({'EL COLEGIO.',''},1)

       LineaPrn({'NOTA: FAVOR ENTREGAR ESTA SOLICITUD ANTES DEL '+;
		 STR(DAY(DATE()),2)+' DE '+cMes(MONTH(DATE()),10)+;
		 ' DE LO CONTRARIO DISPONDREMOS DEL',''},2)

       LineaPrn({'      CUPO DE SU HIJO(A).',''},1)

       EJECT
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DEL FORMULARIO DE ORDEN DE MATRICULA

/*************************************************************************
* TITULO..: IMPRESION DE LA ORDEN DE MATRICULA No. 4                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 24/2004 VIE A
       Colombia, Bucaramanga        INICIO: 03:00 PM   SEP 24/2004 VIE

OBJETIVOS:

1- Imprime la Orden de Matr¡cula No. 04

2- Esta es la Orden de Matr¡cula contiene todos los campos que se
   solicitan en la digitaci¢n de la hoja de vida mas la informaci¢n
   de los contratantes.

3- Es requisito para elaborar los contrantos automaticamente lo que da
   un soporte 100% a la informaci¢n.

4- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OrdenMtr04(cNomSis,cNomEmp,cCodigo,cCodGru,;
		    cNombre,cApelli,lRepite,nPrnOrd)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomSis                              // Nombre del Sistema
       cNomEmp                              // Nombre de la empresa
       cCodigo                              // C¢digo del estudiante
       cCodGru			            // C¢digo del Grupo
       cNombre                              // Nombres del estudiante
       cApelli                              // Apellidos del estudiante
       lRepite                              // .T. Repitente
       nPrnOrd			            // Tipo Orden de Matr¡cula */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lPrnFrm := .F.                 // .T. Imprimir Formato
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroCol := 0                   // N£mero de Columna
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nLenPrn := 0                   // Longitud de impresi¢n
       LOCAL aNivel  := {}                  // Nombre de los Niveles
       LOCAL nNroNiv := 0                   // N£mero del nivel
       LOCAL aFirmas := {}                  // Firmas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE DECISION
       IF cCodigo == NIL
	  lPrnFrm := .T.
	  SET PRINTER TO BASES\OrdMtr01.txt
	  SET DEVICE TO PRINT
	  lRepite := .F.
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>ACTIVACION DE LA IMPRESORA
       nPrnOrd := IF(nPrnOrd == NIL,1,nPrnOrd)

       SendCodes(PCL({'GraphiOn','CondenOf',;
		      'ProporOf','DraftOn'}))
       SendCodes(PCL({'NegraOn','DobGolOn','Elite'}))

       nLenPrn := IF(lPrnFrm,137,PCL('n12Stan'))
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL FORMULARIO
       SendCodes(PCL({'DobAncOn','DobAltOn'}))

       IF !lPrnFrm .AND. ANO->lPrnEmpAno
	  cTxtPrn := cNomEmp
	  nNroCol := ((nLenPrn/2)-LEN(cTxtPrn))/2
	  @ PROW()+3,nNroCol SAY cTxtPrn
       ENDIF

       DO CASE
       CASE nPrnOrd == 1
	    cTxtPrn := 'PREMATRICULA'

       CASE nPrnOrd == 2
	    cTxtPrn := 'ORDEN DE MATRICULA'

       CASE nPrnOrd == 3
	    cTxtPrn := 'SOLICITUD DE CUPO'

       CASE nPrnOrd == 4
	    cTxtPrn := 'ACTUALIZACION DE DATOS'
       ENDCASE

       cTxtPrn += '.CODIGO:'+IF(lPrnFrm,'(CODIGO)',cCodigo)

       nNroCol := ((nLenPrn/2)-LEN(cTxtPrn))/2
       @ PROW()+1,IF(lPrnFrm,nNroCol-10,nNroCol) SAY cTxtPrn

       SendCodes(PCL({'DobAncOf','DobAltOf'}))
       aNivel := {'TRANSICION','PRIMERO'    ,'SEGUNDO' ,'TERCERO',;
		  'CUARTO'    ,'QUINTO'     ,'SEXTO'   ,'SEPTIMO',;
		  'OCTAVO'    ,'NOVENO'     ,'DECIMO'  ,'UNDECIMO',;
		  'MATERNALES','CAMINADORES','PARVULOS',;
		  'PREJARDIN' ,'JARDIN'}

       lRepite := IF(lRepite == NIL,.F.,lRepite)
       nNroNiv := IF(lPrnFrm,0,VAL(SUBS(cCodGru,1,2)))

       DO CASE
       CASE nNroNiv == 16
	    nNroNiv := IF(lRepite,17,0)
       CASE nNroNiv == 17
	    nNroNiv := IF(lRepite,1,1)
       OTHERWISE
	    nNroNiv++
       ENDCASE

       IF !lRepite
	  nNroNiv++
       ENDIF

       cTxtPrn := IF(lRepite,'REPITE','PARA')+;
		  ' EL GRADO '+IF(lPrnFrm,'(NIVEL)',;
					  aNivel[nNroNiv])

       nNroCol := (nLenPrn-LEN(cTxtPrn))/2
       @ PROW()+1,IF(lPrnFrm,nNroCol-24,nNroCol) SAY cTxtPrn

       IF lPrnFrm
	  @ PROW()+2,01 SAY 'NOMBRE: '+'(ESTUDIANTE)'
       ELSE
	  @ PROW()+2,01 SAY 'NOMBRE: '+RTRIM(cApelli)+' '+;
					     cNombre+' '+;
					     'SEXO: M__ F__'+SPACE(08)+;
					     'ESTRATO No: __'
       ENDIF

       aTitulo := {'NACIDO EN:',REPL('_',30),REPL('_',30),;
		   'EL',REPL('_',04),;
		   REPL('_',04),REPL('_',04)}
       aTamCol := {LEN(aTitulo[1]),LEN(aTitulo[2]),;
		   LEN(aTitulo[3]),LEN(aTitulo[4]),;
		   LEN(aTitulo[5]),LEN(aTitulo[6]),;
		   LEN(aTitulo[7])}
       cRegPrint(aTitulo,aTamCol,aNroCol)
       @ PROW()+2,aNroCol[1] SAY aTitulo[1]
       @ PROW(),  aNroCol[2] SAY aTitulo[2]
       @ PROW(),  aNroCol[3] SAY aTitulo[3]
       @ PROW(),  aNroCol[4] SAY aTitulo[4]
       @ PROW(),  aNroCol[5] SAY aTitulo[5]
       @ PROW(),  aNroCol[6] SAY aTitulo[6]
       @ PROW(),  aNroCol[7] SAY aTitulo[7]

       @ PROW()+1,aNroCol[2]+11 SAY 'CIUDAD'
       @ PROW(),  aNroCol[3]+07 SAY 'DEPARTAMENTO'
       @ PROW(),  aNroCol[5]    SAY 'MES'
       @ PROW(),  aNroCol[6]    SAY 'DIA'
       @ PROW(),  aNroCol[7]    SAY 'A¥O'

       LineaPrn({'IDENTIFICACION: ',REPL('_',04),;
		 'No' ,REPL('_',30),;
		 'DE' ,REPL('_',31)})
       LineaPrn({'DIRECCION:',REPL('_',49),'BARRIO:',REPL('_',21)})
       LineaPrn({'CIUDAD:',REPL('_',20),'TEL:',REPL('_',10),;
		 'CEL:',REPL('_',10),'E-MAIL:',REPL('_',21)})

       LineaPrn({'APELLIDOS PADRE:',REPL('_',30),;
		 'NOMBRES PADRE:',REPL('_',27)},2)
       LineaPrn({'IDENTIFICACION: ____ No.:',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'TEL:',REPL('_',13)})
       LineaPrn({'EMPRESA:',REPL('_',38),;
		 'CARGO:',REPL('_',35)},1)
       LineaPrn({'DIRECCION:',REPL('_',49),'BARRIO:',REPL('_',21)})
       LineaPrn({'CIUDAD:',REPL('_',20),'PROFESION:',REPL('_',20),;
		 'E-MAIL:',REPL('_',21)})
       LineaPrn({'FAX:',REPL('_',23),'CELULAR:',REPL('_',22),;
		  'BIPPER:',REPL('_',21)})

       LineaPrn({'APELLIDOS MADRE:',REPL('_',30),;
		 'NOMBRES MADRE:',REPL('_',27)},2)
       LineaPrn({'IDENTIFICACION: ____ No.:',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'TEL:',REPL('_',13)})
       LineaPrn({'EMPRESA:',REPL('_',38),;
		 'CARGO:',REPL('_',35)},1)
       LineaPrn({'DIRECCION:',REPL('_',49),'BARRIO:',REPL('_',21)})
       LineaPrn({'CIUDAD:',REPL('_',20),'PROFESION:',REPL('_',20),;
		 'E-MAIL:',REPL('_',21)})
       LineaPrn({'FAX:',REPL('_',23),'CELULAR:',REPL('_',22),;
		  'BIPPER:',REPL('_',21)})

       LineaPrn({'APELLIDOS ACUDIENTE:',REPL('_',26),;
		 'NOMBRES ACUDIENTE:',REPL('_',23)},2)
       LineaPrn({'IDENTI: ____ No.:',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'PARENTESCO:',REPL('_',14)})
       LineaPrn({'EMPRESA:',REPL('_',38),;
		 'CARGO:',REPL('_',35)},1)
       LineaPrn({'DIRECCION:',REPL('_',28),;
		 'BARRIO:',REPL('_',18),;
		 'TEL CASA:',REPL('_',13)})
       LineaPrn({'CIUDAD:',REPL('_',20),'TEL OFI:',REPL('_',16),;
		 'E-MAIL:',REPL('_',27)})
       LineaPrn({'FAX:',REPL('_',23),'CELULAR:',REPL('_',22),;
		  'BIPPER:',REPL('_',21)})

       LineaPrn({'APELLIDOS CODEUDOR1:',REPL('_',26),;
		 'NOMBRES CODEUDOR1:',REPL('_',23)},2)
       LineaPrn({'IDENTI: ____ No.:',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'PARENTESCO:',REPL('_',14)})
       LineaPrn({'EMPRESA:',REPL('_',38),;
		 'CARGO:',REPL('_',35)},1)
       LineaPrn({'DIRECCION:',REPL('_',28),;
		 'BARRIO:',REPL('_',18),;
		 'TEL CASA:',REPL('_',13)})
       LineaPrn({'CIUDAD:',REPL('_',20),'TEL OFI:',REPL('_',16),;
		 'E-MAIL:',REPL('_',27)})
       LineaPrn({'FAX:',REPL('_',23),'CELULAR:',REPL('_',22),;
		  'BIPPER:',REPL('_',21)})

       LineaPrn({'APELLIDOS CODEUDOR2:',REPL('_',26),;
		 'NOMBRES CODEUDOR2:',REPL('_',23)},2)
       LineaPrn({'IDENTI: ____ No.:',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'PARENTESCO:',REPL('_',14)})
       LineaPrn({'EMPRESA:',REPL('_',38),;
		 'CARGO:',REPL('_',35)},1)
       LineaPrn({'DIRECCION:',REPL('_',28),;
		 'BARRIO:',REPL('_',18),;
		 'TEL CASA:',REPL('_',13)})
       LineaPrn({'CIUDAD:',REPL('_',20),'TEL OFI:',REPL('_',16),;
		 'E-MAIL:',REPL('_',27)})
       LineaPrn({'FAX:',REPL('_',23),'CELULAR:',REPL('_',22),;
		  'BIPPER:',REPL('_',21)})

       SendCodes(PCL('CondenOn'))
       IF !lPrnFrm
	  LineaPrn({ANO->cObsMtrAno},2)
       ELSE
	  LineaPrn({'ACEPTAMOS LA CONFESIONALIDAD, '+;
		    'FILOSOFIA, ORIENTACION Y '+;
		    'REGLAMENTO DEL COLEGIO.'},2)
       ENDIF

       aFirmas := {{'Firma del Contratante No.1',':','Nombre:'},;
		   {'Firma del Contratante No.2',':','Nombre:'}}
       Firmas(IF(lPrnFrm,137,PCL('n17Stan')),3,aFirmas)

       aFirmas := {{'Firma del Codeudor No.2',':','Nombre:'},;
		   {'Firma del Codeudor No.2',':','Nombre:'}}
       Firmas(IF(lPrnFrm,137,PCL('n17Stan')),3,aFirmas)

       @ PROW()+2,00 SAY 'Todos los Items son de OBLIGATORIO diligenciamiento'

       IF !lPrnFrm
	  EJECT
       ELSE
	  @ PROW()+1,00 SAY ''
       ENDIF
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DEL FORMULARIO

/*************************************************************************
* TITULO..: ORDEN DE MATRICULA No. 5                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 16/2006 JUE A
       Colombia, Bucaramanga        INICIO: 05:15 PM   NOV 16/2006 JUE

OBJETIVOS:

1- Esta orden de matr¡cula, sugerido por el Colegio Antonio Ramos de la
   Salle de Cartagena.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OrdenMtr05(cCodEmp,cCodigo,cCodGru,cNombre,;
		    cApelli,lRepite,cNomSis,cNomEmp,;
		    cAnoUsr)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodEmp                              // C¢digo de la Empresa
       cCodigo                              // C¢digo del estudiante
       cCodGru			            // C¢digo del Grupo
       cNombre                              // Nombres del estudiante
       cApelli                              // Apellidos del estudiante
       lRepite                              // .T. Repitente
       cNomSis                              // Nombre del Sistema
       cNomEmp                              // Nombre de la empresa */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
*       #INCLUDE "EPSONFX.PRG"
*       #DEFINE  PAGINA33 CHR(27)+'C'+CHR(33)// P gina de 33 l¡neas

       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nLenPrn := 0                   // Longitud de impresi¢n
       LOCAL aNivel  := {}                  // Nombre de los Niveles
       LOCAL nNroNiv := 0                   // N£mero del nivel
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ACTIVACION DE LA IMPRESORA
       @ PROW(),00 SAY PAGINA33
       @ PROW(),00 SAY GRAPHI_ON+CONDEN_OF+PROPOR_OF+DRAFT_ON
       @ PROW(),00 SAY NEGRA_ON+DOBGOL_ON+ELITE+PAGINA33

       nLenPrn := n12Stan
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL FORMULARIO DE ORDEN DE MATRICULA
       IF cCodEmp == 'COLBOL001002'

	  cTxtPrn := 'INSTITUCION EDUCATIVA'
	  @ PROW()+1,((nLenPrn)-LEN(cTxtPrn))/2 SAY cTxtPrn

	  cTxtPrn := 'HERMANO ANTONIO RAMOS DE LA SALLE'
	  @ PROW()+1,((nLenPrn)-LEN(cTxtPrn))/2 SAY cTxtPrn

	  cTxtPrn := 'Dirigida por los Hermanos De La Salle'
	  @ PROW()+1,((nLenPrn)-LEN(cTxtPrn))/2 SAY cTxtPrn

	  @ PROW(),00 SAY DOBANC_ON+DOBALT_ON
	  cTxtPrn := 'ORDEN DE MATRICULA'
	  @ PROW()+2,((nLenPrn/2)-LEN(cTxtPrn))/2 SAY cTxtPrn
	  @ PROW(),00 SAY DOBANC_OF+DOBALT_OF

       ELSE

	  @ PROW(),00 SAY DOBANC_ON+DOBALT_ON
	  cTxtPrn := cNomEmp
	  @ PROW()+1,((nLenPrn/2)-LEN(cTxtPrn))/2 SAY cTxtPrn
	  @ PROW(),00 SAY DOBANC_OF+DOBALT_OF

	  cTxtPrn := 'ORDEN DE MATRICULA'
	  @ PROW()+2,((nLenPrn)-LEN(cTxtPrn))/2 SAY cTxtPrn

       ENDIF


       cTxtPrn := 'PARA EL GRADO '+;
		  cNomNiv(STR(nSgteNiv(VAL(SUBS(cCodGru,1,2)),lRepite),2))
       @ PROW()+1,((nLenPrn)-LEN(cTxtPrn))/2 SAY cTxtPrn

       @ PROW()+4,01 SAY 'NOMBRE DEL ESTUDIANTE: '+;
			 RTRIM(cApelli)+' '+cNombre

       LineaPrn({'MATRICULARSE EN:',REPL('_',28),;
		 'HORA:',REPL('_',10),;
		 'LUGAR:' ,REPL('_',26)},5)

       cTxtPrn := REPL('_',24)
       @ PROW()+4,((nLenPrn)-LEN(cTxtPrn))/2 SAY cTxtPrn

       cTxtPrn := 'FIRMA DEL RECTOR'
       @ PROW()+1,((nLenPrn)-LEN(cTxtPrn))/2 SAY cTxtPrn

       EJECT
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DEL FORMULARIO DE ORDEN DE MATRICULA

/*************************************************************************
* TITULO..: ORDEN DE MATRICULA No. 6                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 28/2008 JUE A
       Colombia, Bucaramanga        INICIO: 10:30 AM   AGO 28/2008 JUE

OBJETIVOS:

1- Formato sugerido por el Colegio La Salle de Cartagena

2- Formato basado en FrmActInf2

3- El formato permite la Actualizaci¢n de la Informaci¢n.

4- Imprime el grado siguiente de promoci¢n.

5- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OrdenMtr06(cMaeAct,cAnoUsr,cCodIso)

*>>>>PARAMETROS DE LA FUNCION
/*     cMaeAct			            // Maestro Actual
       cAnoUsr                              // A¤o del Usuario
       cCodIso                              // C¢digo del Iso */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nLenPrn := 0                   // Longitud de impresi¢n

       LOCAL aNivel  := {}                  // Nombre de los Niveles
       LOCAL lRepite := .F.                 // .T. Repitente
       LOCAL nNroNiv := 0                   // N£mero del nivel
       LOCAL cTxtNiv := ''                  // Texto del Grado

       LOCAL aNroCnt := {}                  // N£mero de Contratantes
       LOCAL aCntUno := {}                  // Contratante Uno
       LOCAL aCntDos := {}                  // Contratante Dos
       LOCAL aCntTre := {}                  // Contratante Tres
       LOCAL aCntCua := {}                  // Contratante Cuatro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>PROMOCION AL GRADO SIGUIENTE
       aNivel := {'TRANSICION','PRIMERO'    ,'SEGUNDO' ,'TERCERO',;
		  'CUARTO'    ,'QUINTO'     ,'SEXTO'   ,'SEPTIMO',;
		  'OCTAVO'    ,'NOVENO'     ,'DECIMO'  ,'UNDECIMO',;
		  'MATERNALES','CAMINADORES','PARVULOS',;
		  'PREJARDIN' ,'JARDIN'}

       lRepite := &cMaeAct->lRepiteEst
       nNroNiv := VAL(SUBS(&cMaeAct->cCodigoGru,1,2))

       DO CASE
       CASE nNroNiv == 16
	    nNroNiv := IF(lRepite,17,0)
       CASE nNroNiv == 17
	    nNroNiv := IF(lRepite,1,1)
       OTHERWISE
	    nNroNiv++
       ENDCASE

       IF !lRepite
	  nNroNiv++
       ENDIF
*>>>>FIN PROMOCION AL GRADO SIGUIENTE

*>>>>ACTIVACION DE LA IMPRESORA
       cSavPan := SAVESCREEN(0,0,24,79)

       DO WHILE !Printer_on(); ENDDO

       SendCodes(PCL({'Reset','GraphiOn','CondenOf',;
		      'ProporOf','DraftOn'}))

       SendCodes(PCL({'NegraOn','DobGolOn','Elite'}))

       nLenPrn := n12Stan
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL FORMATO DE ACTUALIZACION
       SendCodes(PCL({'DobAncOn','DobAltOn'}))

       cTxtPrn := 'FORMATO DE ACTUALIZACION DE DATOS'
       @ PROW()+3,((nLenPrn/2)-LEN(cTxtPrn))/2 SAY cTxtPrn
       @ PROW(),00 SAY DOBANC_OF+DOBALT_OF

       cTxtPrn := RTRIM(&cMaeAct->cApelliEst)+' '+;
		  RTRIM(&cMaeAct->cNombreEst)+'. '+;
		  'CODIGO: '+&cMaeAct->cCodigoEst+' '+;
		  'A¥O: '+cAnoUsr+' '+;
		  'GRADO:'+IF(lRepite,'REPITE','')+' '+aNivel[nNroNiv]+;
		  SPACE(02)+cCodIso
       @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn

       SendCodes(PCL('CondenOn'))
/*
       @ PROW()+2,02 SAY 'Se¤or Padre de Familia le solicitamos el favor '+;
			 'de revisar y corregir la informaci¢n de su '+;
			 'hijo(a) con el objectivo de mantener actualizado '+;
			 'el Directorio'
       @ PROW()+1,02 SAY 'de los Estudiantes. Favor confronte y solo haga '+;
			 'los cambios necesarios. Muchas Gracias.'
*/
       @ PROW()+2,02 SAY 'Se¤or Padre de Familia: favor '+;
			 'revisar y corregir la sgte informaci¢n '+;
			 'con el objetivo de mantener actualizado '+;
			 'el Directorio de los estudiantes. '
/*
       @ PROW()+1,02 SAY 'de los Estudiantes. Favor confronte y solo haga '+;
			 'los cambios necesarios. Muchas Gracias.'
*/
       SendCodes(PCL('CondenOf'))

       LineaPrn({'NACIDO EN: ',&cMaeAct->cLugNacEst+' FECHA: '+;
		  cFecha(&cMaeAct->dFecNacEst)},2)

       aTitulo := {'NACIDO EN:',REPL('_',30),REPL('_',30),;
		   'EL',REPL('_',04),;
		   REPL('_',04),REPL('_',04)}
       aTamCol := {LEN(aTitulo[1]),LEN(aTitulo[2]),;
		   LEN(aTitulo[3]),LEN(aTitulo[4]),;
		   LEN(aTitulo[5]),LEN(aTitulo[6]),;
		   LEN(aTitulo[7])}
       cRegPrint(aTitulo,aTamCol,aNroCol)
       @ PROW()+1,aNroCol[1] SAY aTitulo[1]
       @ PROW(),  aNroCol[2] SAY aTitulo[2]
       @ PROW(),  aNroCol[3] SAY aTitulo[3]
       @ PROW(),  aNroCol[4] SAY aTitulo[4]
       @ PROW(),  aNroCol[5] SAY aTitulo[5]
       @ PROW(),  aNroCol[6] SAY aTitulo[6]
       @ PROW(),  aNroCol[7] SAY aTitulo[7]

       @ PROW()+1,aNroCol[2]+11 SAY 'CIUDAD'
       @ PROW(),  aNroCol[3]+07 SAY 'DEPARTAMENTO'
       @ PROW(),  aNroCol[5]    SAY 'MES'
       @ PROW(),  aNroCol[6]    SAY 'DIA'
       @ PROW(),  aNroCol[7]    SAY 'A¥O'

       LineaPrn({'IDENTIFICACION: ',&cMaeAct->cTipNitEst+SPACE(01),;
		 'No' ,cLenSpace(&cMaeAct->cDocNitEst,30),;
		 'DE' ,cLenSpace(&cMaeAct->cLugNitEst,31)})

       LineaPrn({'              : ',REPL('_',04),;
		 'No' ,REPL('_',30),;
		 'DE' ,REPL('_',31)})

       LineaPrn({'DIRECCION:',cLenSpace(&cMaeAct->cDireccEst,49),;
		 'BARRIO:',cLenSpace(&cMaeAct->cBarrioEst,21)})
       LineaPrn({'          ',REPL('_',49),'       ',REPL('_',21)})

       LineaPrn({'CIUDAD:',cLenSpace(&cMaeAct->cCiudadEst,39),;
		 'TELEFONO:',cLenSpace(&cMaeAct->cTelefnEst,32)})
       LineaPrn({'       ',REPL('_',39),'         ',REPL('_',32)})



       LineaPrn({'EPS:',cLenSpace(&cMaeAct->cNomEpsEst,39),;
		 ' GRUPO RH:',cLenSpace(&cMaeAct->cGrupRhEst,32)})
       LineaPrn({'   :',REPL('_',40),;
		 '        :',REPL('_',17)})


       LineaPrn({'APELLIDOS PADRE:',cLenSpace(&cMaeAct->cApePadEst,30),;
		 'NOMBRES PADRE:',cLenSpace(&cMaeAct->cNomPadEst,27)},2)
       LineaPrn({'                ',REPL('_',30),;
		 '              ',REPL('_',27)})

       LineaPrn({'IDENTIFICACION: '+&cMaeAct->cPadTntEst+;
		 ' No.: ',cLenSpace(&cMaeAct->cPadNitEst,21),;
		 'DE:',cLenSpace(&cMaeAct->cPadLugEst,19),;
		 'TEL:',cLenSpace(&cMaeAct->cTelPadEst,13)})

       LineaPrn({'                ___ No.  ',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'TEL:',REPL('_',13)})

       LineaPrn({'EMPRESA:',cLenSpace(&cMaeAct->cEmpPadEst,38),;
		 'CARGO:',cLenSpace(&cMaeAct->cCarPadEst,35)},1)
       LineaPrn({'       :',REPL('_',38),'     :',REPL('_',35)},1)

       LineaPrn({'DIRECCION:',cLenSpace(&cMaeAct->cDirPadEst,49),;
		 'BARRIO:',cLenSpace(&cMaeAct->cBarPadEst,21)})
       LineaPrn({'         :',REPL('_',49),'      :',REPL('_',21)})

       LineaPrn({'CIUDAD:',cLenSpace(&cMaeAct->cCiuPadEst,39),;
		 'PROFESION:',cLenSpace(&cMaeAct->cProPadEst,31)})
       LineaPrn({'      :',REPL('_',39),'         :',REPL('_',31)})

       LineaPrn({'E-MAIL:',cLenSpace(&cMaeAct->cMaiPadEst,20),;
		 ' FAX:',cLenSpace(&cMaeAct->cFaxPadEst,16),;
		 'CELULAR:',cLenSpace(&cMaeAct->cCelPadEst,16),;
		 'BIPER:',cLenSpace(&cMaeAct->cBipPadEst,16)})
       LineaPrn({'      :',REPL('_',20),;
		 '     ',REPL('_',16),;
		 '       ',REPL('_',16),;
		 '      ',REPL('_',06)})

       LineaPrn({'APELLIDOS MADRE:',cLenSpace(&cMaeAct->cApeMadEst,30),;
		 'NOMBRES MADRE:',&cMaeAct->cNomMadEst},2)
       LineaPrn({'                ',REPL('_',30),;
		 '              ',REPL('_',27)})

       LineaPrn({'IDENTIFICACION: '+&cMaeAct->cMadTntEst+;
		 ' No.: ',cLenSpace(&cMaeAct->cMadNitEst,21),;
		 'DE:',cLenSpace(&cMaeAct->cMadLugEst,19),;
		 'TEL:',cLenSpace(&cMaeAct->cTelMadEst,13)})
       LineaPrn({'                ___ No.  ',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'TEL:',REPL('_',13)})

       LineaPrn({'EMPRESA:',cLenSpace(&cMaeAct->cEmpMadEst,38),;
		 'CARGO:',cLenSpace(&cMaeAct->cCarMadEst,35)},1)
       LineaPrn({'       :',REPL('_',38),'     :',REPL('_',35)},1)

       LineaPrn({'DIRECCION:',cLenSpace(&cMaeAct->cDirMadEst,49),;
		 'BARRIO:',cLenSpace(&cMaeAct->cBarMadEst,21)})
       LineaPrn({'         :',REPL('_',49),'      :',REPL('_',21)})

       LineaPrn({'CIUDAD:',cLenSpace(&cMaeAct->cCiuMadEst,39),;
		 'PROFESION:',cLenSpace(&cMaeAct->cProMadEst,31)})
       LineaPrn({'      :',REPL('_',39),'         :',REPL('_',31)})

       LineaPrn({'E-MAIL:',cLenSpace(&cMaeAct->cMaiMadEst,20),;
		 ' FAX:',cLenSpace(&cMaeAct->cFaxMadEst,16),;
		 'CELULAR:',cLenSpace(&cMaeAct->cCelMadEst,16),;
		 'BIPER:',cLenSpace(&cMaeAct->cBipMadEst,16)})
       LineaPrn({'      :',REPL('_',20),;
		 '     ',REPL('_',16),;
		 '       ',REPL('_',16),;
		 '      ',REPL('_',06)})


       LineaPrn({'APELLIDOS ACUDIENTE:',cLenSpace(&cMaeAct->cApeAcuEst,26),;
		 'NOMBRES ACUDIENTE:',cLenSpace(&cMaeAct->cNomAcuEst,23)},2)
       LineaPrn({'                    ',REPL('_',26),;
		 '                  ',REPL('_',23)},)

       LineaPrn({'IDENTI: '+&cMaeAct->cAcuTntEst+;
		 ' No.:',cLenSpace(&cMaeAct->cAcuNitEst,21),;
		 'DE:',cLenSpace(&cMaeAct->cAcuLugEst,19),;
		 'PARENTESCO:',cLenSpace(&cMaeAct->cParAcuEst,14)})
       LineaPrn({'        ___'+;
		 '     ',REPL('_',21),;
		 '  :',REPL('_',19),;
		 '          :',REPL('_',14)})

       LineaPrn({'EMPRESA:',cLenSpace(&cMaeAct->cEmpAcuEst,38),;
		 'CARGO:',cLenSpace(&cMaeAct->cCarAcuEst,35)},1)
       LineaPrn({'       :',REPL('_',38),'     :',REPL('_',35)},1)

       LineaPrn({'DIRECCION:',cLenSpace(&cMaeAct->cDirAcuEst,49),;
		 'BARRIO:',cLenSpace(&cMaeAct->cBarAcuEst,21)})
       LineaPrn({'         :',REPL('_',49),'      :',REPL('_',21)})

       LineaPrn({'CIUDAD:',cLenSpace(&cMaeAct->cCiuAcuEst,39),;
		 'PROFESION:',cLenSpace(&cMaeAct->cProAcuEst,31)})
       LineaPrn({'      :',REPL('_',39),'         :',REPL('_',31)})

       LineaPrn({'E-MAIL:',cLenSpace(&cMaeAct->cMaiAcuEst,20),;
		 ' TEL:',cLenSpace(&cMaeAct->cFaxAcuEst,16),;
		 'CELULAR:',cLenSpace(&cMaeAct->cCelAcuEst,16),;
		 'BIPER:',cLenSpace(&cMaeAct->cBipAcuEst,16)})
       LineaPrn({'      :',REPL('_',20),;
		 '     ',REPL('_',16),;
		 '       ',REPL('_',16),;
		 '      ',REPL('_',06)})
       EJECT
*>>>>FIN IMPRESION DEL FORMATO DE ACTUALIZACION

*>>>>PRIMER CONTRATANTE
       aNroCnt := aNroCnts(cMaeAct)
       aCntUno := xPrm(aNroCnt,'aCntUno')

       cTxtPrn := 'INFORMACION DE LOS CONTRATANTES'
       @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn

       cTxtPrn := RTRIM(&cMaeAct->cApelliEst)+' '+;
		  RTRIM(&cMaeAct->cNombreEst)+'. '+;
		  'CODIGO: '+&cMaeAct->cCodigoEst+' '+;
		  'A¥O: '+cAnoUsr+' '+;
		  'GRADO:'+IF(lRepite,'REPITE','')+' '+aNivel[nNroNiv]
       @ PROW()+1,(nLenPrn-LEN(cTxtPrn))/2 SAY cTxtPrn

       LineaPrn({'PRIMIER CONTRATANTE'})

       LineaPrn({'APELLIDOS      :',cLenSpace(xPrm(aCntUno,'cApelli'),30),;
		 'NOMBRES      :',cLenSpace(xPrm(aCntUno,'cNombrs'),27)},1)
       IF !EMPTY(xPrm(aCntUno,'cApelli'))
	  LineaPrn({'                ',REPL('_',30),;
		    '              ',REPL('_',27)})
       ENDIF

       LineaPrn({'IDENTIFICACION: '+xPrm(aCntUno,'cTipNit')+;
		 ' No.: ',cLenSpace(xPrm(aCntUno,'cDocNit'),21),;
		 'DE:',cLenSpace(xPrm(aCntUno,'cLugNit'),19),;
		 'TEL:',cLenSpace(xPrm(aCntUno,'cTelefn'),13)})
       IF !EMPTY(xPrm(aCntUno,'cApelli'))
	  LineaPrn({'                ___ No.  ',REPL('_',21),;
		    'DE:',REPL('_',19),;
		    'TEL:',REPL('_',13)})
       ENDIF

       LineaPrn({'EMPRESA:',cLenSpace(xPrm(aCntUno,'cEmpTra'),38),;
		 'CARGO:',cLenSpace(xPrm(aCntUno,'cCarTra'),35)},1)
       IF !EMPTY(xPrm(aCntUno,'cApelli'))
	  LineaPrn({'       :',REPL('_',38),'     :',REPL('_',35)},1)
       ENDIF

       LineaPrn({'DIRECCION:',cLenSpace(xPrm(aCntUno,'cDirecc'),49),;
		 'BARRIO:',cLenSpace(xPrm(aCntUno,'cBarrio'),21)})
       IF !EMPTY(xPrm(aCntUno,'cApelli'))
	  LineaPrn({'         :',REPL('_',49),'      :',REPL('_',21)})
       ENDIF

       LineaPrn({'CIUDAD:',cLenSpace(xPrm(aCntUno,'cCiudad'),39),;
		 'PROFESION:',cLenSpace(xPrm(aCntUno,'cProfes'),31)})
       IF !EMPTY(xPrm(aCntUno,'cApelli'))
	  LineaPrn({'      :',REPL('_',39),'         :',REPL('_',31)})
       ENDIF

       LineaPrn({'E-MAIL:',cLenSpace(xPrm(aCntUno,'cCorreo'),20),;
		 ' FAX:',cLenSpace(xPrm(aCntUno,'cTelFax'),16),;
		 'CELULAR:',cLenSpace(xPrm(aCntUno,'cTelCel'),16),;
		 'BIPER:',cLenSpace(xPrm(aCntUno,'cBipper'),16)})
       IF !EMPTY(xPrm(aCntUno,'cApelli'))
	  LineaPrn({'      :',REPL('_',20),;
		    '     ',REPL('_',16),;
		    '       ',REPL('_',16),;
		    '      ',REPL('_',06)})
       ENDIF

       LineaPrn({REPL('=',90)})
*>>>>FIN PRIMER CONTRATANTE

*>>>>SEGUNDO CONTRATANTE
       aCntDos := xPrm(aNroCnt,'aCntDos')

       LineaPrn({'SEGUNDO CONTRANTANTE'},1)

       LineaPrn({'APELLIDOS      :',cLenSpace(xPrm(aCntDos,'cApelli'),30),;
		 'NOMBRES      :',cLenSpace(xPrm(aCntDos,'cNombrs'),27)},1)
       IF !EMPTY(xPrm(aCntDos,'cApelli'))
	  LineaPrn({'                ',REPL('_',30),;
		    '              ',REPL('_',27)})
       ENDIF

       LineaPrn({'IDENTIFICACION: '+xPrm(aCntDos,'cTipNit')+;
		 ' No.: ',cLenSpace(xPrm(aCntDos,'cDocNit'),21),;
		 'DE:',cLenSpace(xPrm(aCntDos,'cLugNit'),19),;
		 'TEL:',cLenSpace(xPrm(aCntDos,'cTelefn'),13)})

       IF !EMPTY(xPrm(aCntDos,'cApelli'))
	  LineaPrn({'                ___ No.  ',REPL('_',21),;
		    'DE:',REPL('_',19),;
		    'TEL:',REPL('_',13)})
       ENDIF

       LineaPrn({'EMPRESA:',cLenSpace(xPrm(aCntDos,'cEmpTra'),38),;
		 'CARGO:',cLenSpace(xPrm(aCntDos,'cCarTra'),35)},1)
       IF !EMPTY(xPrm(aCntDos,'cApelli'))
	  LineaPrn({'       :',REPL('_',38),'     :',REPL('_',35)},1)
       ENDIF

       LineaPrn({'DIRECCION:',cLenSpace(xPrm(aCntDos,'cDirecc'),49),;
		 'BARRIO:',cLenSpace(xPrm(aCntDos,'cBarrio'),21)})
       IF !EMPTY(xPrm(aCntDos,'cApelli'))
	  LineaPrn({'         :',REPL('_',49),'      :',REPL('_',21)})
       ENDIF

       LineaPrn({'CIUDAD:',cLenSpace(xPrm(aCntDos,'cCiudad'),39),;
		 'PROFESION:',cLenSpace(xPrm(aCntDos,'cProfes'),31)})
       IF !EMPTY(xPrm(aCntDos,'cApelli'))
	  LineaPrn({'      :',REPL('_',39),'         :',REPL('_',31)})
       ENDIF

       LineaPrn({'E-MAIL:',cLenSpace(xPrm(aCntDos,'cCorreo'),20),;
		 ' FAX:',cLenSpace(xPrm(aCntDos,'cTelFax'),16),;
		 'CELULAR:',cLenSpace(xPrm(aCntDos,'cTelCel'),16),;
		 'BIPER:',cLenSpace(xPrm(aCntDos,'cBipper'),16)})
       IF !EMPTY(xPrm(aCntDos,'cApelli'))
	  LineaPrn({'      :',REPL('_',20),;
		    '     ',REPL('_',16),;
		    '       ',REPL('_',16),;
		    '      ',REPL('_',06)})
       ENDIF

       LineaPrn({REPL('=',90)})
*>>>>FIN SEGUNDO CONTRATANTE

*>>>>TERCER CONTRATANTE
       aCntTre := xPrm(aNroCnt,'aCntTre')

       LineaPrn({'PRIMER CODEUDOR'})

       LineaPrn({'APELLIDOS      :',cLenSpace(xPrm(aCntTre,'cApelli'),30),;
		 'NOMBRES      :',cLenSpace(xPrm(aCntTre,'cNombrs'),27)},1)
       IF !EMPTY(xPrm(aCntTre,'cApelli'))
	  LineaPrn({'                ',REPL('_',30),;
		    '              ',REPL('_',27)})
       ENDIF

       LineaPrn({'IDENTIFICACION: '+xPrm(aCntTre,'cTipNit')+;
		 ' No.: ',cLenSpace(xPrm(aCntTre,'cDocNit'),21),;
		 'DE:',cLenSpace(xPrm(aCntTre,'cLugNit'),19),;
		 'TEL:',cLenSpace(xPrm(aCntTre,'cTelefn'),13)})

       IF !EMPTY(xPrm(aCntTre,'cApelli'))
	  LineaPrn({'                ___ No.  ',REPL('_',21),;
		    'DE:',REPL('_',19),;
		    'TEL:',REPL('_',13)})
       ENDIF

       LineaPrn({'EMPRESA:',cLenSpace(xPrm(aCntTre,'cEmpTra'),38),;
		 'CARGO:',cLenSpace(xPrm(aCntTre,'cCarTra'),35)},1)
       IF !EMPTY(xPrm(aCntTre,'cApelli'))
	  LineaPrn({'       :',REPL('_',38),'     :',REPL('_',35)},1)
       ENDIF

       LineaPrn({'DIRECCION:',cLenSpace(xPrm(aCntTre,'cDirecc'),49),;
		 'BARRIO:',cLenSpace(xPrm(aCntTre,'cBarrio'),21)})
       IF !EMPTY(xPrm(aCntTre,'cApelli'))
	  LineaPrn({'         :',REPL('_',49),'      :',REPL('_',21)})
       ENDIF

       LineaPrn({'CIUDAD:',cLenSpace(xPrm(aCntTre,'cCiudad'),39),;
		 'PROFESION:',cLenSpace(xPrm(aCntTre,'cProfes'),31)})
       IF !EMPTY(xPrm(aCntTre,'cApelli'))
	  LineaPrn({'      :',REPL('_',39),'         :',REPL('_',31)})
       ENDIF

       LineaPrn({'E-MAIL:',cLenSpace(xPrm(aCntTre,'cCorreo'),20),;
		 ' FAX:',cLenSpace(xPrm(aCntTre,'cTelFax'),16),;
		 'CELULAR:',cLenSpace(xPrm(aCntTre,'cTelCel'),16),;
		 'BIPER:',cLenSpace(xPrm(aCntTre,'cBipper'),16)})
       IF !EMPTY(xPrm(aCntTre,'cApelli'))
	  LineaPrn({'      :',REPL('_',20),;
		    '     ',REPL('_',16),;
		    '       ',REPL('_',16),;
		    '      ',REPL('_',06)})
       ENDIF

       LineaPrn({REPL('=',90)})
*>>>>FIN TERCER CONTRATANTE

*>>>>CUARTO CONTRATANTE
       aCntCua := xPrm(aNroCnt,'aCntCua')

       LineaPrn({'SEGUNDO CODEUDOR'})

       LineaPrn({'APELLIDOS      :',cLenSpace(xPrm(aCntCua,'cApelli'),30),;
		 'NOMBRES      :',cLenSpace(xPrm(aCntCua,'cNombrs'),27)},1)
       IF !EMPTY(xPrm(aCntCua,'cApelli'))
	  LineaPrn({'                ',REPL('_',30),;
		    '              ',REPL('_',27)})
       ENDIF

       LineaPrn({'IDENTIFICACION: '+xPrm(aCntCua,'cTipNit')+;
		 ' No.: ',cLenSpace(xPrm(aCntCua,'cDocNit'),21),;
		 'DE:',cLenSpace(xPrm(aCntCua,'cLugNit'),19),;
		 'TEL:',cLenSpace(xPrm(aCntCua,'cTelefn'),13)})
       IF !EMPTY(xPrm(aCntCua,'cApelli'))
	  LineaPrn({'                ___ No.  ',REPL('_',21),;
		    'DE:',REPL('_',19),;
		    'TEL:',REPL('_',13)})
       ENDIF

       LineaPrn({'EMPRESA:',cLenSpace(xPrm(aCntCua,'cEmpTra'),38),;
		 'CARGO:',cLenSpace(xPrm(aCntCua,'cCarTra'),35)},1)
       IF !EMPTY(xPrm(aCntCua,'cApelli'))
	  LineaPrn({'       :',REPL('_',38),'     :',REPL('_',35)},1)
       ENDIF

       LineaPrn({'DIRECCION:',cLenSpace(xPrm(aCntCua,'cDirecc'),49),;
		 'BARRIO:',cLenSpace(xPrm(aCntCua,'cBarrio'),21)})
       IF !EMPTY(xPrm(aCntCua,'cApelli'))
	  LineaPrn({'         :',REPL('_',49),'      :',REPL('_',21)})
       ENDIF

       LineaPrn({'CIUDAD:',cLenSpace(xPrm(aCntCua,'cCiudad'),39),;
		 'PROFESION:',cLenSpace(xPrm(aCntCua,'cProfes'),31)})
       IF !EMPTY(xPrm(aCntCua,'cApelli'))
	  LineaPrn({'      :',REPL('_',39),'         :',REPL('_',31)})
       ENDIF

       LineaPrn({'E-MAIL:',cLenSpace(xPrm(aCntCua,'cCorreo'),20),;
		 ' FAX:',cLenSpace(xPrm(aCntCua,'cTelFax'),16),;
		 'CELULAR:',cLenSpace(xPrm(aCntCua,'cTelCel'),16),;
		 'BIPER:',cLenSpace(xPrm(aCntCua,'cBipper'),16)})
       IF !EMPTY(xPrm(aCntCua,'cApelli'))
	  LineaPrn({'      :',REPL('_',20),;
		    '     ',REPL('_',16),;
		    '       ',REPL('_',16),;
		    '      ',REPL('_',06)})
       ENDIF
       EJECT

       SET DEVICE TO SCREEN
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN CUARTO CONTRATANTE

/*************************************************************************
* TITULO..: IMPRESION DE LA ORDEN DE MATRICULA No. 99                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 24/2004 VIE A
       Colombia, Bucaramanga        INICIO: 03:00 PM   SEP 24/2004 VIE

OBJETIVOS:

1- Imprime la Orden de Matr¡cula No. 99

2- Esta es la Orden de Matr¡cula contiene todos los campos que se
   solicitan en la digitaci¢n de la hoja de vida mas la informaci¢n
   de los contratantes.

3- Es requisito para elaborar los contrantos automaticamente lo que da
   un soporte 100% a la informaci¢n.

4- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OrdenMtr99(cNomSis,cNomEmp,cCodigo,cCodGru,;
		    cNombre,cApelli,lRepite,nPrnOrd)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomSis                              // Nombre del Sistema
       cNomEmp                              // Nombre de la empresa
       cCodigo                              // C¢digo del estudiante
       cCodGru			            // C¢digo del Grupo
       cNombre                              // Nombres del estudiante
       cApelli                              // Apellidos del estudiante
       lRepite                              // .T. Repitente
       nPrnOrd			            // Tipo Orden de Matr¡cula */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lPrnFrm := .F.                 // .T. Imprimir Formato
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroCol := 0                   // N£mero de Columna
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nLenPrn := 0                   // Longitud de impresi¢n
       LOCAL aNivel  := {}                  // Nombre de los Niveles
       LOCAL nNroNiv := 0                   // N£mero del nivel
       LOCAL aFirmas := {}                  // Firmas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE DECISION
       IF cCodigo == NIL
	  lPrnFrm := .T.
	  SET PRINTER TO BASES\OrdMtr99.txt
	  SET DEVICE TO PRINT
	  lRepite := .F.
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>ACTIVACION DE LA IMPRESORA
       nPrnOrd := IF(nPrnOrd == NIL,1,nPrnOrd)

       SendCodes(PCL({'GraphiOn','CondenOf',;
		      'ProporOf','DraftOn'}))
       SendCodes(PCL({'NegraOn','DobGolOn','Elite'}))

       nLenPrn := IF(lPrnFrm,137,PCL('n12Stan'))
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL FORMULARIO
       SendCodes(PCL({'DobAncOn','DobAltOn'}))

       IF !lPrnFrm .AND. ANO->lPrnEmpAno
	  cTxtPrn := cNomEmp
	  nNroCol := ((nLenPrn/2)-LEN(cTxtPrn))/2
	  @ PROW()+3,nNroCol SAY cTxtPrn
       ENDIF

       DO CASE
       CASE nPrnOrd == 1
	    cTxtPrn := 'PREMATRICULA'

       CASE nPrnOrd == 2
	    cTxtPrn := 'ORDEN DE MATRICULA'

       CASE nPrnOrd == 3
	    cTxtPrn := 'SOLICITUD DE CUPO'

       CASE nPrnOrd == 4
	    cTxtPrn := 'ACTUALIZACION DE DATOS'
       ENDCASE

       cTxtPrn += '.CODIGO:'+IF(lPrnFrm,'(CODIGO)',cCodigo)

       nNroCol := ((nLenPrn/2)-LEN(cTxtPrn))/2
       @ PROW()+1,IF(lPrnFrm,nNroCol-10,nNroCol) SAY cTxtPrn

       SendCodes(PCL({'DobAncOf','DobAltOf'}))
       aNivel := {'TRANSICION','PRIMERO'    ,'SEGUNDO' ,'TERCERO',;
		  'CUARTO'    ,'QUINTO'     ,'SEXTO'   ,'SEPTIMO',;
		  'OCTAVO'    ,'NOVENO'     ,'DECIMO'  ,'UNDECIMO',;
		  'MATERNALES','CAMINADORES','PARVULOS',;
		  'PREJARDIN' ,'JARDIN'}

       lRepite := IF(lRepite == NIL,.F.,lRepite)
       nNroNiv := IF(lPrnFrm,0,VAL(SUBS(cCodGru,1,2)))

       DO CASE
       CASE nNroNiv == 16
	    nNroNiv := IF(lRepite,17,0)
       CASE nNroNiv == 17
	    nNroNiv := IF(lRepite,1,1)
       OTHERWISE
	    nNroNiv++
       ENDCASE

       IF !lRepite
	  nNroNiv++
       ENDIF

       cTxtPrn := IF(lRepite,'REPITE','PARA')+;
		  ' EL GRADO '+IF(lPrnFrm,'(NIVEL)',;
					  aNivel[nNroNiv])

       nNroCol := (nLenPrn-LEN(cTxtPrn))/2
       @ PROW()+1,IF(lPrnFrm,nNroCol-24,nNroCol) SAY cTxtPrn

       @ PROW()+2,01 SAY 'Los campos antes del = deben ir en '+;
			 'parentesis en el formato a dise¤ar'

       @ PROW()+2,01 SAY 'Para definir la longitud del contenido de los campos, despu‚s del nombre del campo'
       @ PROW()+1,01 SAY 'se debe agreagar el numero en dos digitos de los caracteres que se desean trurncar'
       @ PROW()+1,01 SAY 'Ejemplo:'
       @ PROW()+1,01 SAY 'cApelliEst20 => 20 Caracteres de longitud'
       @ PROW()+1,01 SAY 'cApelliEst00 => Elimina los Espacios en Blanco'

       @ PROW()+2,01 SAY 'ESTUDIANTE = '+'(ESTUDIANTE)'
       @ PROW()+1,01 SAY 'CODIGO = '+'(CODIGO)'
       @ PROW()+1,01 SAY 'GRUPO = '+'(GRUPO)'
       @ PROW()+1,01 SAY 'GRADO = '+'(GRADO)'
       @ PROW()+1,01 SAY 'NIVEL = '+'(NIVEL)'

       @ PROW()+1,01 SAY 'cApelliEst = '+'(cApelliEst)'
       @ PROW()+1,01 SAY 'cNombreEst = '+'(cNombreEst)'
       @ PROW()+1,01 SAY 'cApelliEst = '+'(cApelliEst)05'
       @ PROW()+1,01 SAY 'cNombreEst = '+'(cApelliEst)00 (cNombreEst)'
       @ PROW()+1,01 SAY 'dFecNacEst = '+'(dFecNacEst)'
       @ PROW()+1,01 SAY 'cLugNacEst = '+'(cLugNacEst)'
       @ PROW()+1,01 SAY 'cDocNitEst = '+'(cDocNitEst)'
       @ PROW()+1,01 SAY 'cLugNitEst = '+'(cLugNitEst)'
       @ PROW()+1,01 SAY 'cTipNitEst = '+'(cTipNitEst)'
       @ PROW()+1,01 SAY 'lFotNitEst = '+'(lFotNitEst)'
       @ PROW()+1,01 SAY 'lSexFemEst = '+'(lSexFemEst)'
       @ PROW()+1,01 SAY 'cDireccEst = '+'(cDireccEst)'
       @ PROW()+1,01 SAY 'cBarrioEst = '+'(cBarrioEst)'
       @ PROW()+1,01 SAY 'cCiudadEst = '+'(cCiudadEst)'
       @ PROW()+1,01 SAY 'cTelefnEst = '+'(cTelefnEst)'
       @ PROW()+1,01 SAY 'cTelCelEst = '+'(cTelCelEst)'
       @ PROW()+1,01 SAY 'cMaiEstEst = '+'(cMaiEstEst)'
       @ PROW()+1,01 SAY 'cParNitEst = '+'(cParNitEst)'
       @ PROW()+1,01 SAY 'cNomEpsEst = '+'(cNomEpsEst)'
       @ PROW()+1,01 SAY 'cGrupRhEst = '+'(cGrupRhEst)'

       @ PROW()+1,01 SAY 'cNitCo1Est = '+'(cNitCo1Est)'
       @ PROW()+1,01 SAY 'cTipCo1Est = '+'(cTipCo1Est)'
       @ PROW()+1,01 SAY 'lNoRCo1Est = '+'(lNoRCo1Est)'
       @ PROW()+1,01 SAY 'cNitCo2Est = '+'(cNitCo2Est)'
       @ PROW()+1,01 SAY 'cTipCo2Est = '+'(cTipCo2Est)'
       @ PROW()+1,01 SAY 'lNoRCo2Est = '+'(lNoRCo2Est)'
       @ PROW()+1,01 SAY 'cNitCo3Est = '+'(cNitCo3Est)'
       @ PROW()+1,01 SAY 'cTipCo3Est = '+'(cTipCo3Est)'
       @ PROW()+1,01 SAY 'lNoRCo3Est = '+'(lNoRCo3Est)'
       @ PROW()+1,01 SAY 'cNitCo4Est = '+'(cNitCo4Est)'
       @ PROW()+1,01 SAY 'cTipCo4Est = '+'(cTipCo4Est)'
       @ PROW()+1,01 SAY 'lNoRCo4Est = '+'(lNoRCo4Est)'

       @ PROW()+1,01 SAY 'cApePadEst = '+'(cApePadEst)'
       @ PROW()+1,01 SAY 'cNomPadEst = '+'(cNomPadEst)'
       @ PROW()+1,01 SAY 'lPadQepEst = '+'(lPadQepEst)'
       @ PROW()+1,01 SAY 'dNacPadEst = '+'(dNacPadEst)'
       @ PROW()+1,01 SAY 'cLugPadEst = '+'(cLugPadEst)'
       @ PROW()+1,01 SAY 'cPadNitEst = '+'(cPadNitEst)'
       @ PROW()+1,01 SAY 'cPadLugEst = '+'(cPadLugEst)'
       @ PROW()+1,01 SAY 'cPadTntEst = '+'(cPadTntEst)'
       @ PROW()+1,01 SAY 'lPadFotEst = '+'(lPadFotEst)'
       @ PROW()+1,01 SAY 'cProPadEst = '+'(cProPadEst)'
       @ PROW()+1,01 SAY 'cEmpPadEst = '+'(cEmpPadEst)'
       @ PROW()+1,01 SAY 'cCarPadEst = '+'(cCarPadEst)'
       @ PROW()+1,01 SAY 'cDirPadEst = '+'(cDirPadEst)'
       @ PROW()+1,01 SAY 'cBarPadEst = '+'(cBarPadEst)'
       @ PROW()+1,01 SAY 'cCiuPadEst = '+'(cCiuPadEst)'
       @ PROW()+1,01 SAY 'cTelPadEst = '+'(cTelPadEst)'
       @ PROW()+1,01 SAY 'cCelPadEst = '+'(cCelPadEst)'
       @ PROW()+1,01 SAY 'cFaxPadEst = '+'(cFaxPadEst)'
       @ PROW()+1,01 SAY 'cBipPadEst = '+'(cBipPadEst)'
       @ PROW()+1,01 SAY 'cMaiPadEst = '+'(cMaiPadEst)'

       @ PROW()+1,01 SAY 'cApeMadEst = '+'(cApeMadEst)'
       @ PROW()+1,01 SAY 'cNomMadEst = '+'(cNomMadEst)'
       @ PROW()+1,01 SAY 'lMadQepEst = '+'(lMadQepEst)'
       @ PROW()+1,01 SAY 'dNacMadEst = '+'(dNacMadEst)'
       @ PROW()+1,01 SAY 'cLugMadEst = '+'(cLugMadEst)'
       @ PROW()+1,01 SAY 'cMadNitEst = '+'(cMadNitEst)'
       @ PROW()+1,01 SAY 'cMadLugEst = '+'(cMadLugEst)'
       @ PROW()+1,01 SAY 'cMadTntEst = '+'(cMadTntEst)'
       @ PROW()+1,01 SAY 'lMadFotEst = '+'(lMadFotEst)'
       @ PROW()+1,01 SAY 'cProMadEst = '+'(cProMadEst)'
       @ PROW()+1,01 SAY 'cEmpMadEst = '+'(cEmpMadEst)'
       @ PROW()+1,01 SAY 'cCarMadEst = '+'(cCarMadEst)'
       @ PROW()+1,01 SAY 'cDirMadEst = '+'(cDirMadEst)'
       @ PROW()+1,01 SAY 'cBarMadEst = '+'(cBarMadEst)'
       @ PROW()+1,01 SAY 'cCiuMadEst = '+'(cCiuMadEst)'
       @ PROW()+1,01 SAY 'cTelMadEst = '+'(cTelMadEst)'
       @ PROW()+1,01 SAY 'cCelMadEst = '+'(cCelMadEst)'
       @ PROW()+1,01 SAY 'cFaxMadEst = '+'(cFaxMadEst)'
       @ PROW()+1,01 SAY 'cBipMadEst = '+'(cBipMadEst)'
       @ PROW()+1,01 SAY 'cMaiMadEst = '+'(cMaiMadEst)'

       @ PROW()+1,01 SAY 'cApeAcuEst = '+'(cApeAcuEst)'
       @ PROW()+1,01 SAY 'cNomAcuEst = '+'(cNomAcuEst)'
       @ PROW()+1,01 SAY 'lAcuQepEst = '+'(lAcuQepEst)'
       @ PROW()+1,01 SAY 'dNacAcuEst = '+'(dNacAcuEst)'
       @ PROW()+1,01 SAY 'cLugAcuEst = '+'(cLugAcuEst)'
       @ PROW()+1,01 SAY 'cAcuNitEst = '+'(cAcuNitEst)'
       @ PROW()+1,01 SAY 'cAcuLugEst = '+'(cAcuLugEst)'
       @ PROW()+1,01 SAY 'cAcuTntEst = '+'(cAcuTntEst)'
       @ PROW()+1,01 SAY 'lAcuFotEst = '+'(lAcuFotEst)'
       @ PROW()+1,01 SAY 'cProAcuEst = '+'(cProAcuEst)'
       @ PROW()+1,01 SAY 'cEmpAcuEst = '+'(cEmpAcuEst)'
       @ PROW()+1,01 SAY 'cCarAcuEst = '+'(cCarAcuEst)'
       @ PROW()+1,01 SAY 'cDirAcuEst = '+'(cDirAcuEst)'
       @ PROW()+1,01 SAY 'cBarAcuEst = '+'(cBarAcuEst)'
       @ PROW()+1,01 SAY 'cCiuAcuEst = '+'(cCiuAcuEst)'
       @ PROW()+1,01 SAY 'cTe1AcuEst = '+'(cTe1AcuEst)'
       @ PROW()+1,01 SAY 'cTe2AcuEst = '+'(cTe2AcuEst)'
       @ PROW()+1,01 SAY 'cCelAcuEst = '+'(cCelAcuEst)'
       @ PROW()+1,01 SAY 'cFaxAcuEst = '+'(cFaxAcuEst)'
       @ PROW()+1,01 SAY 'cBipAcuEst = '+'(cBipAcuEst)'
       @ PROW()+1,01 SAY 'cMaiAcuEst = '+'(cMaiAcuEst)'
       @ PROW()+1,01 SAY 'cParAcuEst = '+'(cParAcuEst)'

       @ PROW()+1,00 SAY ''
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DEL FORMULARIO

/*************************************************************************
* TITULO..: IMPRESION DE LA ORDEN DE MATRICULA No. 4                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 24/2004 VIE A
       Colombia, Bucaramanga        INICIO: 03:00 PM   SEP 24/2004 VIE

OBJETIVOS:

1- Generaci¢n automatica de la orden de matricula

2- Pendiente por terminar.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION FrmPrnAut(FileTxt)

*>>>>DESCRIPCION DE PARAMETROS
/*     FileTxt                              // Archivo texto del formato */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lPrnFrm := .F.                 // .T. Imprimir Formato
       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroCol := 0                   // N£mero de Columna
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nLenPrn := 0                   // Longitud de impresi¢n
       LOCAL aNivel  := {}                  // Nombre de los Niveles
       LOCAL nNroNiv := 0                   // N£mero del nivel
       LOCAL aFirmas := {}                  // Firmas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE DECISION
       SET PRINTER TO &(FileTxt)
       SET DEVICE TO PRINT
*>>>>FIN ANALISIS DE DECISION

*>>>>ACTIVACION DE LA IMPRESORA
       nLenPrn := 137

       SendCodes(PCL({'GraphiOn','CondenOf',;
		      'ProporOf','DraftOn'}))
       SendCodes(PCL({'NegraOn','DobGolOn','Elite'}))
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>ENCABEZADO DEL FORMATO
       cTxtPrn := 'PREMATRICULA. CODIGO: (CODIGO)'

       nNroCol := ((nLenPrn/2)-LEN(cTxtPrn))/2

       SendCodes(PCL({'DobAncOn','DobAltOn'}))
       @ PROW()+1,nNroCol-10 SAY cTxtPrn
       SendCodes(PCL({'DobAncOf','DobAltOf'}))

       cTxtPrn := '(ESTUDIANTE).CODIGO:(CODIGO) NIVEL:(NIVEL)'
       nNroCol := (nLenPrn-LEN(cTxtPrn))/2
       @ PROW()+1,IF(lPrnFrm,nNroCol-24,nNroCol) SAY cTxtPrn
*>>>>FIN ENCABEZADO DEL FORMATO

*>>>>CUERPO DEL FORMATO
       LineaPrn({'NACIDO EN: (cLugNacEst) FECHA: (dFecNacEst)'},2)

       aTitulo := {'NACIDO EN:',REPL('_',30),REPL('_',30),;
		   'EL',REPL('_',04),;
		   REPL('_',04),REPL('_',04)}
       aTamCol := {LEN(aTitulo[1]),LEN(aTitulo[2]),;
		   LEN(aTitulo[3]),LEN(aTitulo[4]),;
		   LEN(aTitulo[5]),LEN(aTitulo[6]),;
		   LEN(aTitulo[7])}
       cRegPrint(aTitulo,aTamCol,aNroCol)
       @ PROW()+1,aNroCol[1] SAY aTitulo[1]
       @ PROW(),  aNroCol[2] SAY aTitulo[2]
       @ PROW(),  aNroCol[3] SAY aTitulo[3]
       @ PROW(),  aNroCol[4] SAY aTitulo[4]
       @ PROW(),  aNroCol[5] SAY aTitulo[5]
       @ PROW(),  aNroCol[6] SAY aTitulo[6]
       @ PROW(),  aNroCol[7] SAY aTitulo[7]

       @ PROW()+1,aNroCol[2]+11 SAY 'CIUDAD'
       @ PROW(),  aNroCol[3]+07 SAY 'DEPARTAMENTO'
       @ PROW(),  aNroCol[5]    SAY 'MES'
       @ PROW(),  aNroCol[6]    SAY 'DIA'
       @ PROW(),  aNroCol[7]    SAY 'A¥O'

       LineaPrn({'IDENTIFICACION: ','(cTipNitEst)',;
		 'No' ,'(cDocNitEst)','DE' ,'(cLugNitEst)'})

       LineaPrn({'              : ',REPL('_',04),;
		 'No' ,REPL('_',30),;
		 'DE' ,REPL('_',31)})

       LineaPrn({'DIRECCION:','(cDireccEst)','BARRIO:','(cBarrioEst)'})
       LineaPrn({'          ',REPL('_',49),'       ',REPL('_',21)})

       LineaPrn({'CIUDAD:','(cCiudadEst)','TELEFONO:','(cTelefnEst)'})
       LineaPrn({'       ',REPL('_',39),'         ',REPL('_',32)})

       LineaPrn({'E-MAIL DEL ESTUDIANTE:','(cMaiEstEst)'})
       LineaPrn({'                     :',REPL('_',40)})

       LineaPrn({REPL('_',137)})


       LineaPrn({'APELLIDOS PADRE:','(cApePadEst)',;
		 'NOMBRES PADRE:','(cNomPadEst)'},2)
       LineaPrn({'                ',REPL('_',30),;
		 '              ',REPL('_',27)})

       LineaPrn({'IDENTIFICACION: (cPadTntEst) No.: (cPadNitEst)',;
		 'DE:','(cPadLugEst)',;
		 'TEL:','(cTelPadEst)'})

       LineaPrn({'                ___ No.  ',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'TEL:',REPL('_',13)})

       LineaPrn({'EMPRESA:','(cEmpPadEst)',;
		 'CARGO:','(cCarPadEst)'},1)
       LineaPrn({'       :',REPL('_',38),'     :',REPL('_',35)},1)

       LineaPrn({'DIRECCION:','(cDirPadEst)',;
		 'BARRIO:','(cBarPadEst)'})
       LineaPrn({'         :',REPL('_',49),'      :',REPL('_',21)})

       LineaPrn({'CIUDAD:','(cCiuPadEst)',;
		 'PROFESION:','(cProPadEst)'})
       LineaPrn({'      :',REPL('_',39),'         :',REPL('_',31)})

       LineaPrn({'E-MAIL DEL PADRE:','(cMaiPadEst)'})
       LineaPrn({'                :',REPL('_',40)})

       LineaPrn({REPL('_',137)})


       LineaPrn({'APELLIDOS MADRE:','(cApeMadEst)',;
		 'NOMBRES MADRE:','(cNomMadEst)'},2)
       LineaPrn({'                ',REPL('_',30),;
		 '              ',REPL('_',27)})

       LineaPrn({'IDENTIFICACION: (cMadTntEst)'+;
		 ' No.: ','(cMadNitEst)',;
		 'DE:','(cMadLugEst)',;
		 'TEL:','(cTelMadEst)'})
       LineaPrn({'                ___ No.  ',REPL('_',21),;
		 'DE:',REPL('_',19),;
		 'TEL:',REPL('_',13)})

       LineaPrn({'EMPRESA:','(cEmpMadEst)',;
		 'CARGO:','(cCarMadEst)'},1)
       LineaPrn({'       :',REPL('_',38),'     :',REPL('_',35)},1)

       LineaPrn({'DIRECCION:','(cDirMadEst)',;
		 'BARRIO:','(cBarMadEst)'})
       LineaPrn({'         :',REPL('_',49),'      :',REPL('_',21)})

       LineaPrn({'CIUDAD:','(cCiuMadEst)',;
		 'PROFESION:','(cProMadEst)'})
       LineaPrn({'      :',REPL('_',39),'         :',REPL('_',31)})

       LineaPrn({'E-MAIL DE LA MADRE:','(cMaiMadEst)'})
       LineaPrn({'                  :',REPL('_',40)})

       LineaPrn({REPL('_',137)})

       LineaPrn({'APELLIDOS ACUDIENTE:','(cApeAcuEst)',;
		 'NOMBRES ACUDIENTE:','(cNomAcuEst)'},2)
       LineaPrn({'                    ',REPL('_',26),;
		 '                  ',REPL('_',23)},)

       LineaPrn({'IDENTI: (cAcuTntEst)'+;
		 ' No.:','(cAcuNitEst)',;
		 'DE:','(cAcuLugEst)',;
		 'PARENTESCO:','(cParAcuEst)'})
       LineaPrn({'        ___'+;
		 '     ',REPL('_',21),;
		 '  :',REPL('_',19),;
		 '          :',REPL('_',14)})

       LineaPrn({'DIRECCION:','(cDirAcuEst)',;
		 'BARRIO:','(cBarAcuEst)'})
       LineaPrn({'         :',REPL('_',49),'      :',REPL('_',21)})

       LineaPrn({'CIUDAD:','(cCiuAcuEst)',;
		 'TEL CASA:','(cTe1AcuEst)',;
		 'TEL OFI:','(cTe2AcuEst)'})
       LineaPrn({'      :',REPL('_',31),;
		 '        :',REPL('_',15),;
		 '       :',REPL('_',15)})
       LineaPrn({'E-MAIL DEL ACUDIENTE:','(cMaiAcuEst)'})
       LineaPrn({'                    :',REPL('_',40)})


       @ PROW()+1,00 SAY ''
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN CUERPO DEL FORMATO

