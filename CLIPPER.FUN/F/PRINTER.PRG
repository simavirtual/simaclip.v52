/*                              SIMASOFT
		 SISTEMAS INSTEGRADOS MULTIUSUARIOS AVANZADOS
		     BIBLIOTECA PARA EL ARCHIVO IMPRESORAS

***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO..: CREACION DE LA ESTRUCTURA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 20/2002 JUE A
       Colombia, Bucaramanga        INICIO: 01:00 PM   JUN 20/2002 JUE

OBJETIVOS:

1- Creaci¢n de la estructura

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfPrn(lShared,nModCry,PathArc,fArchvo,fNtxArc,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc				    // Path del Archivo
       fArchvo				    // Nombre del Archivo
       fNtxArc				    // Archivo de Indices
       aStrDbf                              // Estructura del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual      fECHA DE NACIMIENTO

       LOCAL aDbfStr := {}                  // Estructura del Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE LA ESTRUCTURA
       AADD(aDbfStr,{'nCodigoPrn',"Numeric"  ,04,0})  // C¢digo de la Impresora
       AADD(aDbfStr,{'cNombrePrn',"Character",30,0})  // Nombre de la Impresora
       AADD(aDbfStr,{'PuertoPrn' ,"Character",60,0})  // Puerto de la Impresora
       AADD(aDbfStr,{'TipoPrn'   ,"Character",01,0})  // Tipo de Impresora. Ej: M->Matrix B->Burbuja, L->Laser, C->C¢digo de Barras
       AADD(aDbfStr,{'Reset'     ,"Character",60,0})  // Inicializaci¢n
       AADD(aDbfStr,{'Setup'     ,"Character",60,0})  // Configuraci¢n
       AADD(aDbfStr,{'OnLine'    ,"Character",60,0})  // On Line

       AADD(aDbfStr,{'Portrait'  ,"Character",60,0})  // Orientaci¢n Portrait
       AADD(aDbfStr,{'Landscape' ,"Character",60,0})  // Orientaci¢n Landscape
       AADD(aDbfStr,{'PageIni'   ,"Character",60,0})  // Inicializaci¢n de la p gina
       AADD(aDbfStr,{'Carta'     ,"Character",60,0})  // Tama¤o Carta
       AADD(aDbfStr,{'Mcarta'    ,"Character",60,0})  // Tama¤o Media Carta
       AADD(aDbfStr,{'Oficio'    ,"Character",60,0})  // Tama¤o Oficio
       AADD(aDbfStr,{'Moficio'   ,"Character",60,0})  // Tama¤o Medio Oficio
       AADD(aDbfStr,{'PageLen'   ,"Character",60,0})  // l¡neas por p ginas
       AADD(aDbfStr,{'Copias'    ,"Character",60,0})  // N£mero de Copias
       AADD(aDbfStr,{'Eject'     ,"Character",60,0})  // Eject

       AADD(aDbfStr,{'MTop'      ,"Character",60,0})  // Margen Superior
       AADD(aDbfStr,{'MBot'      ,"Character",60,0})  // Margen Inferior
       AADD(aDbfStr,{'MLeft'     ,"Character",60,0})  // Margen Izquierdo
       AADD(aDbfStr,{'MRight'    ,"Character",60,0})  // Margen Izquierdo
       AADD(aDbfStr,{'MClear'    ,"Character",60,0})  // Reset del Margen

       AADD(aDbfStr,{'Centar'    ,"Character",60,0})  // Centrar
       AADD(aDbfStr,{'JLeft'     ,"Character",60,0})  // Justificar Izquierda
       AADD(aDbfStr,{'JRight'    ,"Character",60,0})  // Justificar Derecha
       AADD(aDbfStr,{'JFull'     ,"Character",60,0})  // Justificar Completa

       AADD(aDbfStr,{'Pica'      ,"Character",60,0})  // PICA 10 CPI
       AADD(aDbfStr,{'Elite'     ,"Character",60,0})  // PICA 12 CPI
       AADD(aDbfStr,{'CondenOn'  ,"Character",60,0})  // Condensada On
       AADD(aDbfStr,{'CondenOf'  ,"Character",60,0})  // Condensada Of
       AADD(aDbfStr,{'ProporOf'  ,"Character",60,0})  // Proporcional
       AADD(aDbfStr,{'DraftOn'   ,"Character",60,0})  // Draft On
       AADD(aDbfStr,{'DraftOf'   ,"Character",60,0})  // Draft Of
       AADD(aDbfStr,{'Roman'     ,"Character",60,0})  // Roman
       AADD(aDbfStr,{'DobAncOn'  ,"Character",60,0})  // Doble Ancho On
       AADD(aDbfStr,{'DobAncOf'  ,"Character",60,0})  // Doble Ancho Of
       AADD(aDbfStr,{'DobAltOn'  ,"Character",60,0})  // Doble Alto On
       AADD(aDbfStr,{'DobAltOf'  ,"Character",60,0})  // Doble Alto Of
       AADD(aDbfStr,{'DobGolOn'  ,"Character",60,0})  // Doble Golpe On
       AADD(aDbfStr,{'DobGolOf'  ,"Character",60,0})  // Doble Golpe Of
       AADD(aDbfStr,{'NegraOn'   ,"Character",60,0})  // Negra On
       AADD(aDbfStr,{'NegraOf'   ,"Character",60,0})  // Negra Of
       AADD(aDbfStr,{'SubryOn'   ,"Character",60,0})  // Subrayado On
       AADD(aDbfStr,{'SubryOf'   ,"Character",60,0})  // Subrayado Of
       AADD(aDbfStr,{'ItalicOn'  ,"Character",60,0})  // Italica On
       AADD(aDbfStr,{'ItalicOf'  ,"Character",60,0})  // Italica Of
       AADD(aDbfStr,{'Linesp16'  ,"Character",60,0})  // Espaciado 1/6
       AADD(aDbfStr,{'Linesp18'  ,"Character",60,0})  // Espaciado 1/8
       AADD(aDbfStr,{'GraphiOn'  ,"Character",60,0})  // Modo Gr fico On

       AADD(aDbfStr,{'n10Stan'   ,"Numeric"  ,03,0})  //  80 => Pica  10 cpi Standard
       AADD(aDbfStr,{'n10Wide'   ,"Numeric"  ,03,0})  // 136 => Pica  10 cpi Wide
       AADD(aDbfStr,{'n12Stan'   ,"Numeric"  ,03,0})  //  96 => Elite 12 cpi Standard
       AADD(aDbfStr,{'n12Wide'   ,"Numeric"  ,03,0})  // 163 => Elite 12 cpi Wide
       AADD(aDbfStr,{'n17Stan'   ,"Numeric"  ,03,0})  // 137 => Pica Condensado Standard
       AADD(aDbfStr,{'n17Wide'   ,"Numeric"  ,03,0})  // 233 => Pica Condensado Wide
       AADD(aDbfStr,{'n20Stan'   ,"Numeric"  ,03,0})  // 160 => Elite Condensado Standard
       AADD(aDbfStr,{'n20Wide'   ,"Numeric"  ,03,0})  // 272 => Elite Condensado Wide
       AADD(aDbfStr,{'nLinPag'   ,"Numeric"  ,02,0})  // L¡neas por p gina
       AADD(aDbfStr,{'nLinCar'   ,"Numeric"  ,02,0})  // L¡neas por p gina tama¤o carta
       AADD(aDbfStr,{'nLinOfi'   ,"Numeric"  ,02,0})  // L¡neas por p gina tama¤o Oficio
*>>>>DECLARACION DE LA ESTRUCTURA

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfStr
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathArc) == 0
	    DBCREATE(fArchvo,aDbfStr,"DBFNTX")

       CASE DIRCHANGE(PathArc) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathArc)

       CASE DIRCHANGE(PathArc) == -5
	    cError('NO TIENE DERECHOS EN: '+PathArc)
       ENDCASE
       DIRCHANGE(PathAct)
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathArc+'\'+fArchvo,'PRN',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE CONFIGURACION DEL COLOR')
	  CloseDbf('PRN',PathArc+'\'+fArchvo,nModCry)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>GRABACION IMPRESORA EPSON SERIES FX
       IF PRN->(lRegLock(lShared,.T.))

	  REPL PRN->nCodigoPrn  WITH 0
	  REPL PRN->cNombrePrn  WITH 'Epson Series Fx'
	  REPL PRN->PuertoPrn   WITH 'LPT1'
	  REPL PRN->TipoPrn     WITH 'M'
	  REPL PRN->Reset       WITH CHR(27)+'@'
	  REPL PRN->Setup       WITH ''
	  REPL PRN->OnLine      WITH 'DC1'

	  REPL PRN->Portrait    WITH ''
	  REPL PRN->Landscape   WITH ''
	  REPL PRN->PageIni     WITH CHR(27)+'C'+CHR(66)
	  REPL PRN->Carta       WITH CHR(27)+'C'+CHR(66)
	  REPL PRN->Mcarta      WITH CHR(27)+'C'+CHR(33)
	  REPL PRN->Oficio      WITH CHR(27)+'C'+CHR(78)
	  REPL PRN->Moficio     WITH CHR(27)+'C'+CHR(39)
	  REPL PRN->PageLen     WITH CHR(27)+'C#'
	  REPL PRN->Copias      WITH ''
	  REPL PRN->Eject       WITH CHR(12)

	  REPL PRN->MTop        WITH ''
	  REPL PRN->MBot        WITH ''
	  REPL PRN->MLeft       WITH CHR(27)+'l#'
	  REPL PRN->MRight      WITH CHR(27)+'Q#'
	  REPL PRN->MClear      WITH ''

	  REPL PRN->Centar      WITH CHR(27)+'a'+CHR(1)
	  REPL PRN->JLeft       WITH CHR(27)+'a'+CHR(0)
	  REPL PRN->JRight      WITH CHR(27)+'a'+CHR(2)
	  REPL PRN->JFull       WITH CHR(27)+'a'+CHR(3)

	  REPL PRN->Pica        WITH CHR(27)+'P'
	  REPL PRN->Elite       WITH CHR(27)+'M'
	  REPL PRN->CondenOn    WITH CHR(15)
	  REPL PRN->CondenOf    WITH CHR(18)
	  REPL PRN->ProporOf    WITH CHR(27)+'p0'
	  REPL PRN->DraftOn     WITH CHR(27)+'x0'
	  REPL PRN->DraftOf     WITH CHR(27)+'x1'
	  REPL PRN->Roman       WITH CHR(27)+'k0'

	  REPL PRN->DobAncOn    WITH CHR(27)+'W1'
	  REPL PRN->DobAncOf    WITH CHR(27)+'W0'
	  REPL PRN->DobAltOn    WITH CHR(27)+'w1'
	  REPL PRN->DobAltOf    WITH CHR(27)+'w0'
	  REPL PRN->DobGolOn    WITH CHR(27)+'G'
	  REPL PRN->DobGolOf    WITH CHR(27)+'H'
	  REPL PRN->NegraOn     WITH CHR(27)+'E'
	  REPL PRN->NegraOf     WITH CHR(27)+'F'
	  REPL PRN->SubryOn     WITH CHR(27)+'-1'
	  REPL PRN->SubryOf     WITH CHR(27)+'-0'
	  REPL PRN->ItalicOn    WITH CHR(27)+'4'
	  REPL PRN->ItalicOf    WITH CHR(27)+'5'
	  REPL PRN->Linesp16    WITH CHR(27)+'2'
	  REPL PRN->Linesp18    WITH CHR(27)+'0'
	  REPL PRN->GraphiOn    WITH CHR(27)+'t1'

	  REPL PRN->n10Stan     WITH 80
	  REPL PRN->n10Wide     WITH 136
	  REPL PRN->n12Stan     WITH 96
	  REPL PRN->n12Wide     WITH 163
	  REPL PRN->n17Stan     WITH 137
	  REPL PRN->n17Wide     WITH 233
	  REPL PRN->n20Stan     WITH 160
	  REPL PRN->n20Wide     WITH 272
	  REPL PRN->nLinPag     WITH 60
	  PRN->(DBCOMMIT())
       ELSE
	  cError('NO SE GRABA EL REGISTRO CONFIGURACION DEL COLOR')
       ENDIF
       IF lShared
	  PRN->(DBUNLOCK())
       ENDIF
*>>>>FIN GRABACION IMPRESORA EPSON SERIES FX

*>>>>GRABACION IMPRESORAS HP DESKJET PLUS
       IF PRN->(lRegLock(lShared,.T.))

	  REPL PRN->nCodigoPrn  WITH 1
	  REPL PRN->cNombrePrn  WITH 'HP DeskJet Plus'
	  REPL PRN->PuertoPrn   WITH 'LPT1'
	  REPL PRN->TipoPrn     WITH 'B'
	  REPL PRN->Reset       WITH CHR(27)+'E'
	  REPL PRN->Setup       WITH ''
	  REPL PRN->OnLine      WITH ''

	  REPL PRN->Portrait    WITH CHR(27)+'&l0O'
	  REPL PRN->Landscape   WITH CHR(27)+'&l0O'
	  REPL PRN->PageIni     WITH CHR(27)+'&l0A'
	  REPL PRN->Carta       WITH CHR(27)+'&l2A'
	  REPL PRN->Mcarta      WITH CHR(27)+'&l#P'
	  REPL PRN->Oficio      WITH CHR(27)+'&l3A'
	  REPL PRN->Moficio     WITH CHR(27)+'&l#P'
	  REPL PRN->PageLen     WITH CHR(27)+'&l#P'
	  REPL PRN->Copias      WITH CHR(27)+'&l#X'
	  REPL PRN->Eject       WITH CHR(27)+'&l0H'

	  REPL PRN->MTop        WITH CHR(27)+'&l#E'
	  REPL PRN->MBot        WITH CHR(27)+'&l#F'
	  REPL PRN->MLeft       WITH CHR(27)+'&a#L'
	  REPL PRN->MRight      WITH CHR(27)+'&a#M'
	  REPL PRN->MClear      WITH CHR(27)+'9'

	  REPL PRN->Pica        WITH CHR(27)+'(s10H'
	  REPL PRN->Elite       WITH CHR(27)+'(s12H'
	  REPL PRN->CondenOn    WITH CHR(27)+'(s18H'
	  REPL PRN->CondenOf    WITH CHR(27)+'(s10H'
	  REPL PRN->ProporOf    WITH CHR(27)+'(s0P'
	  REPL PRN->DraftOn     WITH CHR(27)+'(s1Q'
	  REPL PRN->DraftOf     WITH CHR(27)+'(s5B'
	  REPL PRN->Roman       WITH CHR(27)+'(s5B'
	  REPL PRN->DobAncOn    WITH CHR(27)+'(s6H'
	  REPL PRN->DobAncOf    WITH CHR(27)+'(s10H'
	  REPL PRN->DobAltOn    WITH ''
	  REPL PRN->DobAltOf    WITH ''
	  REPL PRN->DobGolOn    WITH ''
	  REPL PRN->DobGolOf    WITH ''
	  REPL PRN->NegraOn     WITH CHR(27)+'(s3B'
	  REPL PRN->NegraOf     WITH CHR(27)+'(s0B'
	  REPL PRN->SubryOn     WITH CHR(27)+'&d1D'
	  REPL PRN->SubryOf     WITH CHR(27)+'&d0D'
	  REPL PRN->ItalicOn    WITH CHR(27)+'(s1S'
	  REPL PRN->ItalicOf    WITH CHR(27)+'(s0S'
	  REPL PRN->Linesp16    WITH CHR(27)+'&l6D'
	  REPL PRN->Linesp18    WITH CHR(27)+'&l8D'
	  REPL PRN->GraphiOn    WITH ''

	  REPL PRN->n10Stan     WITH 80
	  REPL PRN->n10Wide     WITH 136
	  REPL PRN->n12Stan     WITH 96
	  REPL PRN->n12Wide     WITH 163
	  REPL PRN->n17Stan     WITH 137
	  REPL PRN->n17Wide     WITH 233
	  REPL PRN->n20Stan     WITH 160
	  REPL PRN->n20Wide     WITH 272
	  REPL PRN->nLinPag     WITH 58

	  PRN->(DBCOMMIT())
       ELSE
	  cError('NO SE GRABA EL REGISTRO CONFIGURACION DEL COLOR')
       ENDIF
       IF lShared
	  PRN->(DBUNLOCK())
       ENDIF
*>>>>FIN GRABACION IMPRESORAS HP DESKJET PLUS

*>>>>GRABACION IMPRESORAS HP LASER III
       IF PRN->(lRegLock(lShared,.T.))

	  REPL PRN->nCodigoPrn  WITH 2
	  REPL PRN->cNombrePrn  WITH 'HP LaserJet III'
	  REPL PRN->PuertoPrn   WITH 'LPT1'
	  REPL PRN->TipoPrn     WITH 'L'
	  REPL PRN->Reset       WITH CHR(27)+'E'
	  REPL PRN->Setup       WITH ''
	  REPL PRN->OnLine      WITH ''

	  REPL PRN->Portrait    WITH CHR(27)+'&l0O'
	  REPL PRN->Landscape   WITH CHR(27)+'&l0O'+CHR(27)+'&l14c1E'
	  REPL PRN->PageIni     WITH CHR(27)+'&l0A'
	  REPL PRN->Carta       WITH CHR(27)+'&l2A'
	  REPL PRN->Mcarta      WITH CHR(27)+'&l#P'
	  REPL PRN->Oficio      WITH CHR(27)+'&l3A'
	  REPL PRN->Moficio     WITH CHR(27)+'&l#P'
	  REPL PRN->PageLen     WITH CHR(27)+'&l#P'
	  REPL PRN->Copias      WITH CHR(27)+'&l#X'
	  REPL PRN->Eject       WITH CHR(27)+'&l0H'

	  REPL PRN->MTop        WITH CHR(27)+'&l#E'
	  REPL PRN->MBot        WITH CHR(27)+'&l#F'
	  REPL PRN->MLeft       WITH CHR(27)+'&a#L'
	  REPL PRN->MRight      WITH CHR(27)+'&a#M'
	  REPL PRN->MClear      WITH CHR(27)+'9'

	  REPL PRN->Pica        WITH CHR(27)+'(s10H'
	  REPL PRN->Elite       WITH CHR(27)+'(s12H'
	  REPL PRN->CondenOn    WITH CHR(27)+'(s18H'
	  REPL PRN->CondenOf    WITH CHR(27)+'(s10H'
	  REPL PRN->ProporOf    WITH CHR(27)+'(s0P'
	  REPL PRN->DraftOn     WITH CHR(27)+'(s1Q'
	  REPL PRN->DraftOf     WITH CHR(27)+'(s5B'
	  REPL PRN->Roman       WITH CHR(27)+'(s5B'
	  REPL PRN->DobAncOn    WITH CHR(27)+'(s6H'
	  REPL PRN->DobAncOf    WITH CHR(27)+'(s10H'
	  REPL PRN->DobAltOn    WITH ''
	  REPL PRN->DobAltOf    WITH ''
	  REPL PRN->DobGolOn    WITH ''
	  REPL PRN->DobGolOf    WITH ''
	  REPL PRN->NegraOn     WITH CHR(27)+'(s3B'
	  REPL PRN->NegraOf     WITH CHR(27)+'(s0B'
	  REPL PRN->SubryOn     WITH CHR(27)+'&d1D'
	  REPL PRN->SubryOf     WITH CHR(27)+'&d0D'
	  REPL PRN->ItalicOn    WITH CHR(27)+'(s1S'
	  REPL PRN->ItalicOf    WITH CHR(27)+'(s0S'
	  REPL PRN->Linesp16    WITH CHR(27)+'&17.27C'
	  REPL PRN->Linesp18    WITH CHR(27)+'&15.45C'
	  REPL PRN->GraphiOn    WITH ''

	  REPL PRN->n10Stan     WITH 80
	  REPL PRN->n10Wide     WITH 136
	  REPL PRN->n12Stan     WITH 96
	  REPL PRN->n12Wide     WITH 163
	  REPL PRN->n17Stan     WITH 137
	  REPL PRN->n17Wide     WITH 233
	  REPL PRN->n20Stan     WITH 160
	  REPL PRN->n20Wide     WITH 272
	  REPL PRN->nLinPag     WITH 58

	  PRN->(DBCOMMIT())
       ELSE
	  cError('NO SE GRABA EL REGISTRO CONFIGURACION DEL COLOR')
       ENDIF
       IF lShared
	  PRN->(DBUNLOCK())
       ENDIF
*>>>>FIN GRABACION IMPRESORAS HP LASER III

*>>>>GRABACION IMPRESORAS KIOCERA MITA PCL
       IF PRN->(lRegLock(lShared,.T.))

	  REPL PRN->nCodigoPrn  WITH 3
	  REPL PRN->cNombrePrn  WITH 'Kyocera Mita Pcl'
	  REPL PRN->PuertoPrn   WITH 'LPT1'
	  REPL PRN->TipoPrn     WITH 'L'
	  REPL PRN->Reset       WITH CHR(27)+'E'
	  REPL PRN->Setup       WITH ''
	  REPL PRN->OnLine      WITH ''

	  REPL PRN->Portrait    WITH CHR(27)+'&l0O'
	  REPL PRN->Landscape   WITH CHR(27)+'&l0O'+CHR(27)+'&l14c1E'
	  REPL PRN->PageIni     WITH CHR(27)+'&l0A'
	  REPL PRN->Carta       WITH CHR(27)+'&l2A'
	  REPL PRN->Mcarta      WITH CHR(27)+'&l#P'
	  REPL PRN->Oficio      WITH CHR(27)+'&l3A'
	  REPL PRN->Moficio     WITH CHR(27)+'&l#P'
	  REPL PRN->PageLen     WITH CHR(27)+'&l#P'
	  REPL PRN->Copias      WITH CHR(27)+'&l#X'
	  REPL PRN->Eject       WITH CHR(27)+'&l0H'

	  REPL PRN->MTop        WITH CHR(27)+'&l#E'
	  REPL PRN->MBot        WITH CHR(27)+'&l#F'
	  REPL PRN->MLeft       WITH CHR(27)+'&a#L'
	  REPL PRN->MRight      WITH CHR(27)+'&a#M'
	  REPL PRN->MClear      WITH CHR(27)+'9'

	  REPL PRN->Pica        WITH CHR(27)+'(s10H'
	  REPL PRN->Elite       WITH CHR(27)+'(s12H'
	  REPL PRN->CondenOn    WITH CHR(27)+'(s18H'
	  REPL PRN->CondenOf    WITH CHR(27)+'(s10H'
	  REPL PRN->ProporOf    WITH CHR(27)+'(s0P'
	  REPL PRN->DraftOn     WITH CHR(27)+'(s1Q'
	  REPL PRN->DraftOf     WITH CHR(27)+'(s5B'
	  REPL PRN->Roman       WITH CHR(27)+'(s5B'
	  REPL PRN->DobAncOn    WITH CHR(27)+'(s6H'
	  REPL PRN->DobAncOf    WITH CHR(27)+'(s10H'
	  REPL PRN->DobAltOn    WITH ''
	  REPL PRN->DobAltOf    WITH ''
	  REPL PRN->DobGolOn    WITH ''
	  REPL PRN->DobGolOf    WITH ''
	  REPL PRN->NegraOn     WITH CHR(27)+'(s3B'
	  REPL PRN->NegraOf     WITH CHR(27)+'(s0B'
	  REPL PRN->SubryOn     WITH CHR(27)+'&d1D'
	  REPL PRN->SubryOf     WITH CHR(27)+'&d0D'
	  REPL PRN->ItalicOn    WITH CHR(27)+'(s1S'
	  REPL PRN->ItalicOf    WITH CHR(27)+'(s0S'
	  REPL PRN->Linesp16    WITH CHR(27)+'&17.27C'
	  REPL PRN->Linesp18    WITH CHR(27)+'&15.45C'
	  REPL PRN->GraphiOn    WITH ''

	  REPL PRN->n10Stan     WITH 80
	  REPL PRN->n10Wide     WITH 136
	  REPL PRN->n12Stan     WITH 96
	  REPL PRN->n12Wide     WITH 163
	  REPL PRN->n17Stan     WITH 137
	  REPL PRN->n17Wide     WITH 233
	  REPL PRN->n20Stan     WITH 160
	  REPL PRN->n20Wide     WITH 272
	  REPL PRN->nLinPag     WITH 58

	  PRN->(DBCOMMIT())
       ELSE
	  cError('NO SE GRABA EL REGISTRO CONFIGURACION DEL COLOR')
       ENDIF
       IF lShared
	  PRN->(DBUNLOCK())
       ENDIF
*>>>>FIN GRABACION IMPRESORAS KIOCERA MITA PCL

*>>>>GRABACION IMPRESORAS KIOCERA MITA PRESCRIBE
       IF PRN->(lRegLock(lShared,.T.))

	  REPL PRN->nCodigoPrn  WITH 4
	  REPL PRN->cNombrePrn  WITH 'Kyocera Mita Prescribe'
	  REPL PRN->PuertoPrn   WITH 'LPT1'
	  REPL PRN->TipoPrn     WITH 'L'
	  REPL PRN->Reset       WITH CHR(27)+'E'
	  REPL PRN->Setup       WITH ''
	  REPL PRN->OnLine      WITH ''

	  REPL PRN->Portrait    WITH CHR(27)+'&l0O'
	  REPL PRN->Landscape   WITH CHR(27)+'&l0O'+CHR(27)+'&l14c1E'
	  REPL PRN->PageIni     WITH CHR(27)+'&l0A'
	  REPL PRN->Carta       WITH CHR(27)+'&l2A'
	  REPL PRN->Mcarta      WITH CHR(27)+'&l#P'
	  REPL PRN->Oficio      WITH CHR(27)+'&l3A'
	  REPL PRN->Moficio     WITH CHR(27)+'&l#P'
	  REPL PRN->PageLen     WITH CHR(27)+'&l#P'
	  REPL PRN->Copias      WITH CHR(27)+'&l#X'
	  REPL PRN->Eject       WITH CHR(27)+'&l0H'

	  REPL PRN->MTop        WITH CHR(27)+'&l#E'
	  REPL PRN->MBot        WITH CHR(27)+'&l#F'
	  REPL PRN->MLeft       WITH CHR(27)+'&a#L'
	  REPL PRN->MRight      WITH CHR(27)+'&a#M'
	  REPL PRN->MClear      WITH CHR(27)+'9'

	  REPL PRN->Pica        WITH CHR(27)+'(s10H'
	  REPL PRN->Elite       WITH CHR(27)+'(s12H'
	  REPL PRN->CondenOn    WITH CHR(27)+'(s18H'
	  REPL PRN->CondenOf    WITH CHR(27)+'(s10H'
	  REPL PRN->ProporOf    WITH CHR(27)+'(s0P'
	  REPL PRN->DraftOn     WITH CHR(27)+'(s1Q'
	  REPL PRN->DraftOf     WITH CHR(27)+'(s5B'
	  REPL PRN->Roman       WITH CHR(27)+'(s5B'
	  REPL PRN->DobAncOn    WITH CHR(27)+'(s6H'
	  REPL PRN->DobAncOf    WITH CHR(27)+'(s10H'
	  REPL PRN->DobAltOn    WITH ''
	  REPL PRN->DobAltOf    WITH ''
	  REPL PRN->DobGolOn    WITH ''
	  REPL PRN->DobGolOf    WITH ''
	  REPL PRN->NegraOn     WITH CHR(27)+'(s3B'
	  REPL PRN->NegraOf     WITH CHR(27)+'(s0B'
	  REPL PRN->SubryOn     WITH CHR(27)+'&d1D'
	  REPL PRN->SubryOf     WITH CHR(27)+'&d0D'
	  REPL PRN->ItalicOn    WITH CHR(27)+'(s1S'
	  REPL PRN->ItalicOf    WITH CHR(27)+'(s0S'
	  REPL PRN->Linesp16    WITH CHR(27)+'&17.27C'
	  REPL PRN->Linesp18    WITH CHR(27)+'&15.45C'
	  REPL PRN->GraphiOn    WITH ''

	  REPL PRN->n10Stan     WITH 80
	  REPL PRN->n10Wide     WITH 136
	  REPL PRN->n12Stan     WITH 96
	  REPL PRN->n12Wide     WITH 163
	  REPL PRN->n17Stan     WITH 137
	  REPL PRN->n17Wide     WITH 233
	  REPL PRN->n20Stan     WITH 160
	  REPL PRN->n20Wide     WITH 272
	  REPL PRN->nLinPag     WITH 58

	  PRN->(DBCOMMIT())
       ELSE
	  cError('NO SE GRABA EL REGISTRO CONFIGURACION DEL COLOR')
       ENDIF
       IF lShared
	  PRN->(DBUNLOCK())
       ENDIF

       CloseDbf('PRN',PathArc+'\'+fArchvo,nModCry)
       RETURN NIL
*>>>>FIN GRABACION IMPRESORAS KIOCERA MITA PRESCRIBE


/*************************************************************************
* TITULO..: RECUPERACION DE LA ESTRUCTURA                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 20/2002 JUE A
       Colombia, Bucaramanga        INICIO: 01:05 PM   JUN 20/2002 JUE

OBJETIVOS:

1)- Recupera la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuDbfPrn(lShared,nModCry,PathArc,fArchvo,fNtxArc)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       nModCry                        // Modo de Protecci¢n
       PathArc			      // Path del Archivo
       fArchvo			      // Nombre del Archivo
       fNtxArc			      // Archivo de Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathArc+'\'+fArchvo,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")
       Termometro(0,"CREANDO LA ESTRUCTURA")
       Termometro(100)
       CreaDbfPrn(lShared,nModCry,PathArc,fArchvo,fNtxArc)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 20/2002 JUE A
       Colombia, Bucaramanga        INICIO: 01:10 PM   JUN 20/2002 JUE

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

FUNCTION nActStrPrn(lShared,nModCry,PathArc,cNomArc)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc				    // Path del Archivo
       cNomArc				    // Nombre del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nNroErr := 0                   // N£mero del Error
       LOCAL       i := 0                   // Contador
       LOCAL aStrNew := {'1'}               // Estructura Nueva
       LOCAL aStrOld := {}                  // Estructura Vieja
       LOCAL lCambio := .F.                 // .T. Cambio la Estructura
       LOCAL FileTem := ''                  // Archivo temporal
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathArc+'\'+cNomArc,'PRN',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE CORRECIONES')
	  CloseDbf('PRN')
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := PRN->(DBSTRUCT())
       CloseDbf('PRN')
       CreaDbfPrn(lShared,nModCry,PathArc,cNomArc,,@aStrNew)
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE LA ESTRUCTURA
       lCambio := .T.
       IF LEN(aStrNew) == LEN(aStrOld)
	  lCambio := .F.
	  nNroErr := 1
       ENDIF

       IF !lCambio
	  FOR i := 1 TO LEN(aStrNew)
	      IF UPPER(aStrNew[i,1]) # UPPER(aStrOld[i,1]) .OR.;
		 UPPER(SUBS(aStrNew[i,2],1,1)) # UPPER(SUBS(aStrOld[i,2],1,1)) .OR.;
		 aStrNew[i,3] # aStrOld[i,3] .OR.;
		 aStrNew[i,4] # aStrOld[i,4]
		 lCambio := .T.
		 EXIT
	      ENDIF
	  ENDFOR
       ENDIF
*>>>>FIN VALIDACION DE LAS STRUCTURAS

*>>>>CONFIRMACION DE LA ACTUALIZACION
       IF lCambio .AND. lShared
	  cError('El Archivo DRIVERS su Estructura Esta DesActualizada.',;
		 'ATENCION',;
		 'Para Actualizarla NO Debe Haber Ning£n Usuario en la Red.')
	  lCambio := lPregunta('DESEA ACTUALIZAR LA ESTRUCTURA? No Si')
	  IF !lCambio
	     nNroErr := 1
	  ENDIF
       ENDIF
*>>>>FIN CONFIRMACION DE LA ACTUALIZACION

*>>>>ACTUALIZACION DE LA STRUCTURA
       IF lCambio
	  FileTem := SUBS(cNomArc,1,AT('.',cNomArc))+'STR'
	  cSavPan := SAVESCREEN(0,0,24,79)
	  IF !lStrucFile(lShared,;
			 PathArc+'\'+cNomArc,;
			 PathArc+'\'+FileTem,;
			 {||CreaDbfPrn(lShared,nModCry,PathArc,FileTem)})
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA STRUCTURA

/*************************************************************************
* TITULO..: MANTENIMIENTO DEL ARCHIVO                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 20/2002 JUE A
       Colombia, Bucaramanga        INICIO: 01:15 PM   JUN 20/2002 JUE

OBJETIVOS:

1- Permite el mantenimiento del archivo

SINTAXIS:

MantenPro()

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenPrn(lShared,nModCry,cNomSis,cNomEmp,;
		   cNomUsr,cAnoUsr,PathArc,fArchvo,nNroCam)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cNomEmp                              // Nombre de la Empresa
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       PathArc				    // Path del Archivo
       fArchvo				    // Nombre del Archivo
       nNroCam                              // N£mero de Campos */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                   // Declaraci¢n de teclas

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr    := .F.              // .T. Hay Error
       LOCAL oBrowse := NIL                 // Browse de Archivo
       LOCAL nNroPar := 0                   // N£mero de Parte a Visualizar
       CloseAll()
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathArc+'\'+fArchvo,'PRN',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO')
	  CloseDbf('PRN',PathArc+'\'+fArchvo,nModCry)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESORAS GRABADADAS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>MANTENIMIENTO DEL ARCHIVO
       IF !lFileLock()
	  oBrowse := oDefBrwPrn(lShared,03,00,22,79,nNroPar,nNroCam)
	  SETKEY(K_F9,{||MenuOtrPrn(lShared,nModCry,cNomSis,;
				    cNomEmp,cNomUsr,cAnoUsr)})
	  PRN->(CtrlBrw(lShared,oBrowse))

	  SETKEY(K_F9,NIL)

       ENDIF
       PRN->(DBUNLOCKALL())
       CloseAll()
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO..: DEFINICION DEL OBJETO BROWSE                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 20/2002 JUE A
       Colombia, Bucaramanga        INICIO: 01:20 PM   JUN 20/2002 JUE

OBJETIVOS:

1- Define el objeto Browse del archivo

SINTAXIS:

 oBrowse := oDefBrwPrn(00,00,24,79)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwPrn(lShared,nFilSup,nColSup,nFilInf,nColInf,nNroPar,nNroCam)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       nNroPar                              // N£mero de la Parte a Mostrar
       nNroCam                              // N£mero de Campos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL aStrDbf := {}                  // Estructura del Archivo
       LOCAL cCampo  := ''                  // Campo
       LOCAL nDiviso := 0                   // Division por 9
       LOCAL nPosIni := 0                   // Posici¢n Inicial
       LOCAL nPosFin := 0                   // Posici¢n Final

       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrowse := NIL		    // Browse de Grupos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrowse := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'
       oBrowse:Cargo     := {'<<DEFINICION DE IMPRESORAS >>',;
			    '<F5>Buscar <F9>Otros <INS>Incluir <DEL>Borrar',;
			    {||IncluirPrn(lShared)}}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT PRN
       aStrDbf := PRN->(DBSTRUCT())
       nDiviso := ROUND(LEN(aStrDbf)/9,0)

       nNroPar := 0
       DO CASE
       CASE nNroPar == 1
	    nPosIni := nNroPar
	    nPosFin := nDiviso
       CASE nNroPar == 2
	    nPosIni := nDiviso+1
	    nPosFin := 2*nDiviso
       CASE nNroPar == 9
	    nPosIni := ((nNroPar-1)*nDiviso)+1
	    nPosFin := LEN(aStrDbf)
       OTHERWISE
	    nPosIni := ((nNroPar-1)*nDiviso)+1
	    nPosFin := nNroPar*nDiviso
       ENDCASE

*       FOR i := nPosIni TO nPosFin
       nNroCam := IF(nNroCam==NIL,LEN(aStrDbf),nNroCam)
       FOR i := 1 TO nNroCam
	   cCampo  := aStrDbf[i,1]
	   oColumn := TBCOLUMNNEW(ALLTRIM(STR(i,3))+':'+cCampo,{||&cCampo})
	   oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PRN'},{'FIELD',cCampo},;
			     {'PICTURE','@'}}
	   oBrowse:ADDCOLUMN(oColumn)
	 *ÀDefinici¢n Columna
       ENDFOR

       oColumn := TBCOLUMNNEW('Puerto',{||PRN->PuertoPrn})
       oColumn:Cargo := {{'MODI',.T.},{'ALIAS','PRN'},{'FIELD','PuertoPrn'},;
			 {'PICTURE','@X'}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO..: INCLUCION DE UN REGISTRO                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 20/2002 JUE A
       Colombia, Bucaramanga        INICIO: 01:25 PM   JUN 20/2002 JUE

OBJETIVOS:

1- Inserta un registro al archivo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION IncluirPrn(lShared)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE CONSTANTES
       LOCAL nNroFil := 0                   // Fila de Lectura
       LOCAL nNroCol := 2                   // Columna de Lectura
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lGrabar := .F.                 // .T. Grabar
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTpr := ''               // C¢digo del Profesor
       LOCAL cCodigoTca := ''               // C¢digo de la Carga
       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>INCLUSION DEL REGISTRO
       RETURN NIL
*>>>>FIN INCLUSION DEL REGISTRO

/*************************************************************************
* TITULO..: MENU DE OTROS PARA EL ARCHIVO                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 20/2002 JUE A
       Colombia, Bucaramanga        INICIO: 01:30 PM   JUN 20/2002 JUE

OBJETIVOS:

1- Menu de Otros para el archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuOtrPrn(lShared,nModCry,cNomSis,cNomEmp,cNomUsr,cAnoUsr)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cNomEmp                              // Nombre de la Empresa
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARCION Y EJECUCION DEL MENU
       aMenus := {'1<PAGINA DE PRUEBA>'}

       aAyuda := {'Permite imprimir una p gina de prueba'}

       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,aAyuda,10,25,NIL,NIL,1,.F.)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nNroOpc == 0
	  RETURN NIL
       ENDIF
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>ANALISIS DE OPCION ESCOGIDA
       DO CASE
       CASE nNroOpc == 1
	    OtrPrn011(lShared,nModCry,cNomSis,cNomEmp,cNomUsr,cAnoUsr)
	   *Impresi¢n de las Rutas

       ENDCASE
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: PRUEBA DE IMPRESION                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 20/2002 JUE A
       Colombia, Bucaramanga        INICIO: 01:35 PM   JUN 20/2002 JUE

OBJETIVOS:

1- Imprime una prueba de impresi¢n

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrPrn011(lShared,nModCry,cNomSis,cNomEmp,cNomUsr,cAnoUsr)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cNomEmp                              // Nombre de la Empresa
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
     *ÀVariables generales

*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CONTENIDO
       IF PRN->(RECCOUNT()) == 0
	  cError('NO EXISTEN IMPRESORAS GRABADAS')
	  RETURN NIL
       ENDIF
       cSavPan := SAVESCREEN(0,0,24,79)
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>ANALISIS DE DECISION
       IF !lPregunta('DESEA IMPRIMIR LA PAGINA DE PRUEBA? Si No')
	  RETURN NIL
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN ANALISIS DE DECISION

*>>>>ACTIVACION DE LA IMPRESORA
       IF !Printer_on()
	  RETURN NIL
       ENDIF
       SendCodes(PCL({"Reset"}))
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DE LA PAGINA DE PRUEBA
       SendCodes(PCL({'Pica'}))
       @ PROW(),00 SAY 'ESTE TEXTO ESTA EN PICA 10 CARACTERES POR PULGADA'

       SendCodes(PCL({'CondenOn'}))
       @ PROW()+1,00 SAY 'ESTE TEXTO ESTA EN CONDENSADO EN PICA '+;
		       '16 CARACTERES POR PULGADA'
       SendCodes(PCL({'CondenOf'}))

       SendCodes(PCL({'Elite'}))
       @ PROW()+1,00 SAY 'ESTE TEXTO ESTA EN ELITE 12 CARACTERES POR PULGADA'

       SendCodes(PCL({'CondenOn'}))
       @ PROW()+1,00 SAY 'ESTE TEXTO ESTA EN CONDENSADO EN ELITE '+;
		       '20 CARACTERES POR PULGADA'
       SendCodes(PCL({'CondenOf'}))

       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DE LA PAGINA DE PRUEBA

/*************************************************************************
* TITULO..: COMANDO PCL                                                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 25/2002 MAR A
       Colombia, Bucaramanga        INICIO: 04:15 PM   JUN 25/2002 MAR

OBJETIVOS:

1- Retorna un Comando de Control de la impresora

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Pcl(xCodigo)

*>>>>PARAMETROS DE LA FUNCION
/*     xCodigo                              // C¢digo Control para impresora */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL  cCampo := ''                  // Campo
       LOCAL xCodPcl := ''                  // C¢digo Pcl
       LOCAL cCodPcl := ''                  // C¢digo Pcl
       LOCAL lPrnFrm := .F.                 // .T. Imprimir el Formato
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE DECISION
       IF .NOT. ALIAS(SELECT('PRN')) == 'PRN'
	  lPrnFrm := .T.
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>LECTURA DEL CODIGO PCL
       IF VALTYPE(xCodigo) == 'A'
	  FOR i := 1 TO LEN(xCodigo)
	       cCampo := xCodigo[i]
	       IF lPrnFrm
		  xCodPcl := '<'+UPPER(cCampo)+'>'
	       ELSE
		  xCodPcl := ALLTRIM(PRN->&cCampo)
	       ENDIF
	      cCodPcl += xCodPcl
	  ENDFOR
       ELSE
	  cCampo := xCodigo
	 IF lPrnFrm
	    xCodPcl := '<'+UPPER(cCampo)+'>'
	 ELSE
	    xCodPcl := PRN->&cCampo
	 ENDIF
	 IF VALTYPE(xCodPcl) == 'C'
	    cCodPcl := ALLTRIM(xCodPcl)
	 ELSE
	    cCodPcl := xCodPcl
	 ENDIF
       ENDIF
       RETURN cCodPcl
*>>>>FIN LECTURA DEL CODIGO PCL

/*************************************************************************
* TITULO..: VALIDACION DEL CODIGO                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 18/2002 VIE A
       Colombia, Bucaramanga        INICIO: 11:00 AM   OCT 18/2002 VIE

OBJETIVOS:

1- Debe estar en uso el archivo

2- Realiza la validaci¢n del c¢digo.

3- Retorna .T. si hay problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValPrn(nNroFil,nNroCol,nCodigo)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       nCodigo			            // C¢digo para Validar */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroReg := 0                   // Registro del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CODIGO
       IF !lLocCodigo('nCodigoPrn','PRN',nCodigo)
	  nNroReg := nSelPrn(nNroFil,nNroCol)
	  IF nNroReg == 0
	     nCodigo := cSpaces('PRN','nCodigoPrn')
	  ELSE
	     GO nNroReg
	     nCodigo := PRN->nCodigoPrn
	  ENDIF
       ENDIF
       RETURN .T.
*>>>>FIN VALIDACION DEL CODIGO

/*************************************************************************
* TITULO..: SELECCION DE LA IMPRESORA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 18/2002 VIE A
       Colombia, Bucaramanga        INICIO: 11:05 AM   OCT 18/2002 VIE

OBJETIVOS:

1- Debe estar en uso el archivo

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Retorna el n£mero del registro escogido

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nSelPrn(nNroFil,nNroCol)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // N£mero de la fila
       nNroCol                              // N£mero de la Columna */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nFilSup := 0                   // Fila superior
       LOCAL nColSup := 0                   // Colunma superior
       LOCAL nFilInf := 0                   // Fila inferior
       LOCAL nColInf := 0                   // Columna inferior
       LOCAL nNroReg := 0                   // Registro del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       IF PRN->(RECCOUNT()) == 0
	  cError('NO EXISTEN IMPRESORAS GRABADAS')
	  RETURN 0
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>INICIALIZACION DE LAS COORDENADAS
	SELECT PRN
	nFilSup := nNroFil+1
	nColSup := nNroCol+1
	IF nFilSup+RECCOUNT() > 22
	   nFilInf := 22
	ELSE
	   nFilInf := nFilSup + RECCOUNT()
	ENDIF
	nColInf := nColSup+18
*>>>>FIN INICIALIZACION DE LAS COORDENADAS

*>>>>SELECCION DE LA IMPRESORA
       PRN->(DBGOTOP())
       cSavPan := SAVESCREEN(0,0,24,79)
       @ nFilSup-1,nColSup-1 TO nFilInf,nColInf+1 DOUBLE
       nNroReg := nBrowseDbf(nFilSup,nColSup,nFilInf-1,nColInf,;
			     {||PRN->cNombrePrn})
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN nNroReg
*>>>>FIN SELECCION DE LA IMPRESORA

/*************************************************************************
* TITULO..: IMPRESION DEL ARCHIVO TEXTO                                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 05/2001 MIE A
       Colombia, Bucaramanga        INICIO: 12:30 AM   SEP 05/2001 MIE

OBJETIVOS:

1- Permite imprimir un archivo texto en forma justificada.

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnFileDoc(cNomArc,aMezcla,nLenLin,nMarIzq,nLenBuf,lOficio)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomArc                              // Nombre del Archivo
       aMezcla                              // Campos a mezclar con el texto
       nLenLin                              // Longitud de la l¡nea
       nMarIzq                              // Margen Izquierdo
       nLenBuf                              // Buffer de Lectura
       lOficio                              // .T. Oficio */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE CONSTANTES
       #DEFINE pDESDE_BOF 0
       #DEFINE pDESDE_POS_ACTUAL 1
       #DEFINE pDESDE_EOF 2
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL       a := 0                   // Puntero
       LOCAL     i,j := 0                   // Contador
       LOCAL nNroArc := 0                   // N£mero de Archivo
       LOCAL cLinTxt := ''                  // L¡nea de Texto
       LOCAL cDelimi := CHR(13)+CHR(10)     // Delimitador de fin de l¡nea
       LOCAL cLinJus := CHR(141)+CHR(10)    // Fin de l¡nea justificada
       LOCAL cEofFil := CHR(26)             // Final del Archivo.
       LOCAL cBuffer := ''                  // Buffer de Lectura
       LOCAL nBytLee := 0                   // Bytes le¡dos
       LOCAL nFinLin := 0                   // Posici¢n del fin de la l¡nea
       LOCAL nPointr := 0                   // Apuntador
       LOCAL lCodBlo := .F.                 // .T. Hay CodeBlock
       LOCAL aNroLin := {}                  // N£mero de l¡neas
       LOCAL nColPrn := 0                   // Columna de Impresi¢n
       LOCAL nTotLin := 0                   // Total lineas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>PARAMETROS PARA LA IMPRESORA
       lOficio := IF(lOficio==NIL,.F.,lOficio)

/*
       IF lOficio
	  SendCodes(PCL({'GraphiOn','CondenOf',;
			 'ProporOf','Pica','DraftOn',;
			 'Oficio'}))
       ELSE
	  SendCodes(PCL({'GraphiOn','CondenOf',;
			 'ProporOf','Pica','DraftOn'}))
       ENDIF
*/

       nColPrn := IF(EMPTY(nMarIzq),0,nMarIzq)

*>>>>FIN PARAMETROS PARA LA IMPRESORA

*>>>>APERTURA DEL ARCHIVO
       nNroArc := FOPEN(cNomArc)
       IF nNroArc <= 0
	  cError('NO SE PUDO ABRIR EL ARCHIVO')
	  RETURN NIL
       ENDIF
       nLenLin := IF(nLenLin == NIL,134,nLenLin)
*>>>>FIN APERTURA DEL ARCHIVO

*>>>>IMPRESION DEL ARCHIVO TEXTO
       nLenBuf := IF(EMPTY(nLenBuf),50000,nLenBuf)
       cBuffer := SPACE(nLenBuf)

       FSEEK(nNroArc,0,pDESDE_BOF)
      *Ubica el puntero en el inicio

       DO WHILE .T.

**********LECTURA DE LA LINEA
	    nBytLee = fRead(nNroArc,@cBuffer,nLenBuf)
	   *Lee el Buffer de longitud de acuerdo a nLenBuf

	    IF nBytLee == 1 .OR. nBytLee == 0
	       EXIT
	    ENDIF

	    IF AT(cEofFil,cBuffer) < AT(cDelimi,cBuffer)
	       nFinLin = AT(cEofFil,cBuffer)
	      *Buscar delimitador de f¡n de Archivo
	    ELSE
	       nFinLin = AT(cDelimi,cBuffer)
	      *Buscar delimitador de f¡n de l¡nea
	    ENDIF
	  *ÀPendiente por implementar ojo

	    nFinLin = AT(cDelimi,cBuffer)
	   *Buscar delimitador de f¡n de l¡nea
**********FIN LECTURA DE LA LINEA

**********MOVER EL PUNTERO AL INICIO DE LA SIGUIENTE LINEA
	    IF nFinLin = 0
	       // Significa que:
	       //   No se encontr¢ el delimitador, o
	       //   El pointer est  en EOF, o
	       //   La l¡nea es demasiado larga.
	    ELSE
	       a:=FSEEK(nNroArc,(nBytLee*-1)+nFinLin+1,pDESDE_POS_ACTUAL)
	      *Mueve el puntero
	    ENDIF
**********FIN MOVER EL PUNTERO AL INICIO DE LA SIGUIENTE LINEA

**********ACTUALIZACION DEL PUNTERO
	    cLinTxt := SUBSTR(cBuffer, 1, nFinLin - 1)
	    nPointr := FSEEK( nNroArc, 0, pDESDE_POS_ACTUAL )
	   *Actualiza Pointer
**********FIN ACTUALIZACION DEL PUNTERO

**********SUSTITUCION DEL FIN DE LINEA JUSTIFICADA
	    DO WHILE AT(cLinJus,cLinTxt) > 0
	       cLinTxt := STUFF(cLinTxt,AT(cLinJus,cLinTxt),2,'')
	    ENDDO
**********FIN SUSTITUCION DEL FIN DE LINEA JUSTIFICADA

**********SUSTITUCION DE LOS CAMPOS
	    lCodBlo := .F.
	    IF !EMPTY(aMezcla) .AND. !EMPTY(cLinTxt)

*--------------REEMPLAZO DE CADA CAMPO
		 FOR i := 1 TO LEN(aMezcla)

*::::::::::::::::::::ANALISIS DEL CAMPO A SUSTITUIR
		       lCodBlo := .F.
		       IF AT(aMezcla[i,1],cLinTxt) > 0



*.........................ANALISIS DEL TAMA¥O DE LA PAGINA
			    IF aMezcla[i,1] == '<OFICIO>'
			       lOficio := .T.
			    ENDIF
*.........................FIN ANALISIS DEL TAMA¥O DE LA PAGINA

*.........................ANALISIS SI EXISTE UN CODEBLOCK
			    IF VALTYPE(aMezcla[i,2]) # 'B'
			       cLinTxt := cReplTxt(aMezcla[i,1],;
						   aMezcla[i,2],;
						   cLinTxt)
			    ELSE
			       lCodBlo := .T.
			       EXIT
			    ENDIF
*.........................FIN ANALISIS SI EXISTE UN CODEBLOCK

		       ENDIF
*::::::::::::::::::::FIN ANALISIS DEL CAMPO A SUSTITUIR

		 ENDFOR
*--------------FIN REEMPLAZO DE CADA CAMPO

	    ENDIF
**********FIN SUSTITUCION DE LOS CAMPOS

**********IMPRESION DEL TEXTO
	    IF lCodBlo
	       EVAL(aMezcla[i,2])
	    ELSE

	       nTotLin := IF(lOficio,71,59)
	       aNroLin := aDivLin(cLinTxt,nLenLin)

	       FOR j := 1 TO LEN(aNroLin)
		   cLinTxt := aNroLin[j]
		   @ PROW()+1,nColPrn SAY cJustFull(cLinTxt,nLenLin)
		   IF PROW() > nTotLin .AND. PRN->TipoPrn == 'M'
		      EJECT
		   ENDIF
	       NEXT

	    ENDIF
**********FIN IMPRESION DEL TEXTO

       ENDDO
       FCLOSE(nNroArc)
      *Cierra el archivo

       EJECT
       RETURN NIL
*>>>>FIN IMPRESION DEL ARCHIVO TEXTO

/*************************************************************************
* TITULO..: JUSTIFICACION COMPLETA DE TEXTO                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 21/2002 LUN A
       Colombia, Bucaramanga        INICIO: 03:35 AM   OCT 21/2002 LUN

OBJETIVOS:

1- Permite Justificar el texto en forma completa

2- Retorna el texto justificado.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cJustFull(cLinTxt,nLenLin)

*>>>>DESCRIPCION DE PARAMETROS
/*     cLinTxt                              // L¡nea de Texto
       nLenLin                              // Longitud de la l¡nea */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL nLenTxt := 0                   // Longitud del Texto
       LOCAL nLenDif := 0                   // Longitud de Diferencia
       LOCAL nNroPos := 0                   // N£mero de la Posici¢n
       LOCAL nPosAnt := 0                   // Posici¢n Anterior
       LOCAL cNroSpa := ''                  // N£mero de Espacios
       LOCAL nNroSpa := 1                   // N£mero de Espacios
       LOCAL cTxtTem := ''                  // Texto temporal
       LOCAL cSubTxt := ''                  // Sub texto
       STATIC nJusTxt := 0                   // Justificaci¢n del Texto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE LA JUSTIFICACION
       DO CASE
       CASE AT('<JI>',cLinTxt) # 0       // Justificaci¢n a la Izquierda
	    nNroPos := AT('<JI>',cLinTxt)
	    cLinTxt := STUFF(cLinTxt,nNroPos,4,'')
	    nJusTxt := 0

       CASE AT('<JC>',cLinTxt) # 0       // Texto Centrado
	    nNroPos := AT('<JC>',cLinTxt)
	    cLinTxt := STUFF(cLinTxt,nNroPos,4,'')
	    nJusTxt := 1

       CASE AT('<JD>',cLinTxt) # 0       // Justificaci¢n a la Derecha
	    nNroPos := AT('<JD>',cLinTxt)
	    cLinTxt := STUFF(cLinTxt,nNroPos,4,'')
	    nJusTxt := 2

       CASE AT('<JF>',cLinTxt) # 0       // Justificaci¢n Completa
	    nNroPos := AT('<JF>',cLinTxt)
	    cLinTxt := STUFF(cLinTxt,nNroPos,4,'')
	    nJusTxt := 3
       ENDCASE
*>>>>FIN ANALISIS DE LA JUSTIFICACION

*>>>>JUSTIFICACION DE LA LINEA
       IF nJusTxt == 3
	  cLinTxt := ALLTRIM(cLinTxt)
       ENDIF
       nLenTxt := LEN(cLinTxt)
       nLenDif := nLenLin - nLenTxt
       cSubTxt := cLinTxt

       DO CASE
       CASE nJusTxt == 1  // Texto Centrado
	   *Se centra manual por variar el tama¤o y la fuente

       CASE nJusTxt == 2  // Justificaci¢n Derecha
	   *Pendiente

       CASE nJusTxt == 3 .AND. nLenDif # 0  // Justificaci¢n Completa

	    IF nLenDif < 30
	       cNroSpa := SPACE(nNroSpa)
	       FOR i := 1 TO nLenDif
		   nNroPos := AT(' ',cSubTxt)
		   IF nNroPos == 0
		      cSubTxt := cTxtTem+cSubTxt
		      cTxtTem := ''
		      nNroSpa++
		      cNroSpa := SPACE(nNroSpa)
		      nNroPos := AT(' ',cSubTxt)
		      nLenTxt := LEN(cSubTxt)
		   ENDIF
		   cTxtTem += SUBS(cSubTxt,1,nNroPos)+cNroSpa
		   cSubTxt := SUBS(cSubTxt,nNroPos+nNroSpa,nLenTxt)
	       ENDFOR
	       cLinTxt := cTxtTem+cSubTxt
	    ENDIF

       ENDCASE
       RETURN cLinTxt
*>>>>FIN JUSTIFICACION DE LA LINEA

/*************************************************************************
* TITULO..: REEMPLAZO DE TEXTO                                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 21/2002 LUN A
       Colombia, Bucaramanga        INICIO: 03:45 AM   OCT 21/2002 LUN

OBJETIVOS:

1- Permite reemplazar el nombre del texto por su contenido

2- Retorna el texto reemplazado.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/


FUNCTION cReplTxt(cCampo,cConCam,cLinTxt)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCampo                               // Campo de Sustitituci¢n
       cConCam                              // Contenido del Campo
       cLinTxt                              // L¡nea del Texto */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cNomTxt := ''                  // Nombre del Texto
       LOCAL cConTxt := ''                  // Contenido del Texto
       LOCAL nNroPos := 0                   // N£mero de Posici¢n
       LOCAL nLenTxt := 0                   // Longitud del Texto
       LOCAL nPosIni := 0                   // Posici¢n Inicial
       LOCAL cNroLen := ''                  // Longitud de la cadena
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SUSTITUCION DEL TEXTO
       cNomTxt := cCampo
       cConTxt := cTrunCampo(@cNomTxt,cConCam,cLinTxt)

       nNroPos := AT(cNomTxt,cLinTxt)
       nLenTxt := LEN(cNomTxt)

       DO WHILE nNroPos > 0

	  cLinTxt := STUFF(cLinTxt,nNroPos,nLenTxt,cConTxt)

	  cNomTxt := cCampo
	  cConTxt := cTrunCampo(@cNomTxt,cConCam,cLinTxt)
	  nNroPos := AT(cNomTxt,cLinTxt)
	  nLenTxt := LEN(cNomTxt)

       ENDDO
       RETURN cLinTxt
*>>>>FIN SUSTITUCION DEL TEXTO

/*************************************************************************
* TITULO..: TRUNCAMIENTO DEL TEXTO DEL CAMPO                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 26/2005 LUN A
       Colombia, Bucaramanga        INICIO: 04:00 PM   OCT 26/2005 LUN

OBJETIVOS:

1- Permite truncar o eliminar los espacios de una cadena de texto

2- Retorna el texto truncado

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cTrunCampo(cNomTxt,cConTxt,cLinTxt)

*>>>>DESCRIPCION DE PARAMETROS
/*     cNomTxt                              // @Nombre del Texto
       cConTxt                              // Contendo del Texto
       cLinTxt                              // L¡nea del Texto */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroPos := 0                   // N£mero de Posici¢n
       LOCAL cNroLen := ''                  // Longitud de la cadena
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA Y VALIDACION DE LA LONGITUD A TRUNCAR
       nNroPos := AT(cNomTxt,cLinTxt)
       IF nNroPos # 0 .AND. SUBS(cLinTxt,nNroPos+LEN(cNomTxt),1) # SPACE(01)

**********LECTURA DE LA LONGITUD A TRUNCAR
	    cNroLen := SUBS(cLinTxt,nNroPos+LEN(cNomTxt),2)
	  *ÀLongitud de Truncamiento

	    IF TYPE(cNroLen) # 'N'
	       RETURN cConTxt
	    ENDIF
	  *ÀValidaci¢n de la longitudo

	    cNomTxt += cNroLen
	  *ÀEquivalencia del campo

	    IF VAL(cNroLen) > LEN(cConTxt)
	       cNroLen := LEN(cConTxt)
	    ENDIF
	  *ÀValidaci¢n de la longitud
**********FIN LECTURA DE LA LONGITUD A TRUNCAR

**********TRUNCAMIENTO DEL TEXTO
	    IF VAL(cNroLen) == 0
	       cConTxt := ALLTRIM(cConTxt)
	    ELSE
	       cConTxt := SUBS(cConTxt,1,VAL(cNroLen))
	    ENDIF
**********FIN TRUNCAMIENTO DEL TEXTO

       ENDIF
       RETURN cConTxt
*>>>>FIN LECTURA Y VALIDACION DE LA LONGITUD A TRUNCAR


/*************************************************************************
* TITULO..: COMANDO POSTCRIP                                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 27/2002 VIE A
       Colombia, Bucaramanga        INICIO: 10:30 PM   DIC 27/2002 VIE

OBJETIVOS:

1- Envia un comando PostCrip a la Impresora

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Post(cCodigo)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodigo                              // C¢digo Postscript */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cDelimi := CHR(13)+CHR(10)     // Delimitador de fin de l¡nea
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DEL CODIGO
       @ PROW()+1,00 SAY cCodigo
       RETURN NIL
*>>>>FIN IMPRESION DEL CODIGO


/*************************************************************************
* TITULO..: FECHA NUMERICA EN TEXTO                                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 08/2003 MIE A
       Colombia, Bucaramanga        INICIO: 10:30 AM   ENE 08/2003 MIE

1- Convierte la fecha en formato numerico en texto

2- Retorna Retorna la fecha n£merica

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cFecNum(dFecha,nTipFrm)

*>>>>DESCRIPCION DE PARAMETROS
/*     dFecha                               // Fecha a Convertir
       nTipFrm                              // Tipo de Formato */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cNroDia := ''                  // N£mero del D¡a
       LOCAL cNroMes := ''                  // N£mero del Mes
       LOCAL cNroAno := ''                  // N£mero del A¤o
       LOCAL cFecNum  := ''                 // Fecha N£merica
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CONVERSION DE LA FECHA
       cNroDia := STR(DAY(dFecha),2)
       lCorrecion(@cNroDia,.T.)

       cNroMes := STR(MONTH(dFecha),2)
       lCorrecion(@cNroMes,.T.)

       cNroAno := STR(YEAR(dFecha),4)
       lCorrecion(@cNroAno,.T.)
*>>>>FIN CONVERSION DE LA FECHA

*>>>>ANALISIS DEL FORMATO
       nTipFrm := IF(EMPTY(nTipFrm),1,nTipFrm)
       DO CASE
       CASE nTipFrm == 1  // MMDDAAAA
	    cFecNum := cNroMes+cNroDia+cNroAno

       CASE nTipFrm == 2  // AAAAMMDD
	    cFecNum := cNroAno+cNroMes+cNroDia

       CASE nTipFrm == 3  // DDMMAAAA
	    cFecNum := cNroDia+cNroMes+cNroAno

       OTHERWISE
	    cFecNum := cNroMes+cNroDia+cNroAno
       ENDCASE
       RETURN cFecNum
*>>>>FIN ANALISIS DEL FORMATO

/*************************************************************************
* TITULO..: CODIGO DE BARRA EANUCC128                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 08/2003 MIE A
       Colombia, Bucaramanga        INICIO: 11:35 AM   ENE 08/2003 MIE

1- Arma el c¢digo de Barras EANUCC128

2- Retorna el Texto del C¢digo de Barras

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cEanUcc128(cCodEan,cRefPag,cVlrPag,cFecPag,;
		    cCodBar,cIndRec,cIndRef,cIndVlr,cIndFec)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodEan                              // C¢digo EAN13
       cRefPag                              // Referencia de Pago
       cVlrPag                              // Valor a Pagar
       cFecPag			            // Fecha de Pago
       cCodBar                              // @C¢digo de Barra
       cIndRec                              // Indicativo de Recaudo
       cIndRef                              // Indicativo de Referencia
       cIndVlr                              // Indicativo de Valor
       cIndFec                              // Indicativo de Fecha */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cTxtBar := ''                  // Texto del C¢digo de Barras
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE PARAMETROS
       cIndRec := IF(EMPTY(cIndRec),'415' ,cIndRec)
       cIndRef := IF(EMPTY(cIndRef),'8020',cIndRef)
       cIndVlr := IF(EMPTY(cIndVlr),'3900',cIndVlr)
       cIndFec := IF(EMPTY(cIndFec),'96'  ,cIndFec)
*>>>>FIN VALIDACION DE PARAMETROS

*>>>>VALIDACION DE PARES
       IF .NOT. lPar(LEN(cRefPag))
	  cRefPag := cRefPag
       ENDIF
       IF .NOT. lPar(LEN(cVlrPag))
	  cVlrPag := '0'+cVlrPag
       ENDIF
*>>>>FIN VALIDACION DE PARES

*>>>>CODIGO DE BARRA EANUCC128
       cCodBar := cIndRec+cCodEan+;
		  cIndRef+cRefPag+'@86'+;
		  cIndVlr+cVlrPag+'@86'+;
		  cIndFec+cFecPag

       cTxtBar := '('+cIndRec+')'+cCodEan+;
		  '('+cIndRef+')'+cRefPag+;
		  '('+cIndVlr+')'+cVlrPag+;
		  '('+cIndFec+')'+cFecPag
       RETURN cTxtBar
*>>>>FIN CODIGO DE BARRA EANUCC128

/*************************************************************************
* TITULO..: ERROR DE EJECUCION                                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 15/2003 VIE A
       Colombia, Bucaramanga        INICIO: 05:00 PM   AGO 15/2003 VIE

OBJETIVOS:

1- Describe el error generado por la orden de ejecuci¢n SWPRUNCMD del
   Blinker

3- Retorna la Descripci¢n del Error

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cErrorRun(nNroErr)

*>>>>DECLARACION DE VARIABLES
/*     nNroErr                              // N£mero de Error */
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE VARIABLES
       LOCAL cMsgErr := ''                  // Mensaje de Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE VARIABLES
       DO CASE
       CASE nNroErr == 0
	    cMsgErr :=  ''
       CASE nNroErr == 1
	    cMsgErr := 'EL DISCO DURO ESTA LLENO'
       CASE nNroErr == 2
	    cMsgErr := 'ARCHIVO NO ENCONTRO'
       CASE nNroErr == 3
	    cMsgErr := 'ERROR I/O DEL DISCO'
       CASE nNroErr == 4
	    cMsgErr := 'ERROR CAMBIANDO EL DIRECTORIO'
       CASE nNroErr == 5
	    cMsgErr := 'ERROR CREANDO EL ARCHIVO TEMPORAL'
       CASE nNroErr == 6
	    cMsgErr := 'ERROR CAMBIANDO EL DRIVE'
       CASE nNroErr == 7
	    cMsgErr := 'ERROR EMS'
       CASE nNroErr == 8
	    cMsgErr := 'ERROR XMS'
       CASE nNroErr == 9
	    cMsgErr := 'ERROR EN EL SHELL'
       CASE nNroErr == 10
	    cMsgErr := 'POCOS MANEJADORES DISPONIBLES'
       CASE nNroErr == 11
	    cMsgErr := 'MEMORIA FULL'
       CASE nNroErr == 12
	    cMsgErr := 'MCB: BLOQUE DE CONTROL DE MEMORIA CORRUPTOS'
       CASE nNroErr == 13
	    cMsgErr := 'POCOS BLOQUES DE CONTROL DE MEMORIA DISPONIBLES'
       CASE nNroErr == 14
	    cMsgErr := 'DOS memory function call error'
       CASE nNroErr == 15
	    cMsgErr := 'Unable to locate same segment'
       CASE nNroErr == 16
	    cMsgErr := 'No se puede encontrar COMSPEC environment'
       CASE nNroErr == 254
	    cMsgErr := 'Swap Internal Error'
       CASE nNroErr == 255
	    cMsgErr := 'Swap Internal Error'
       OTHERWISE
	    cMsgErr := str(nNroErr,4)+'Error Desconocido'
       ENDCASE
       RETURN cMsgErr
*>>>>FIN DECLARACION DE VARIABLES

/*************************************************************************
* TITULO..: SELECCION DE LA IMPRESION                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 13/2003 MIE A
       Colombia, Bucaramanga        INICIO: 12:00 PM   AGO 13/2003 MIE

OBJETIVOS:

1- Permite selecionar el tipo de impresora.

2- Permite escoger el modo de impresi¢n, por impresora, por pantalla,
   en archivo, abrir archivo.

3- La variable nOpci¢n permite habilitar el men£

3- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nPrinter_On(cNomUsr,FilePrn,cOpcion,lSelPrn,lFrmArc,bInsIso,;
		     PathPrn)

*>>>>DESCRIPCION DE VARIABLES
/*     cNomUsr                       // Nombre del Usuario
       FilePrn                       // @Archivo de Impresi¢n
       cOpcion                       // Opciones de Impresi¢n
       lSelPrn                       // .T. Selecionar Impresora
       lFrmArc                       // .T. Formato de Archivo
       bInsIso                       // Gestion documental
       PathPrn                       // Path de impresi¢n */
*>>>>FIN DESCRIPCION DE VARIABLES

*>>>>DECLARACION DE VARIABLES
       LOCAL PathDoc := 'c:\misdoc'         // Path de Documentos del sima

       LOCAL       i := 0                   // Contador
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL nOpcFrm := 0                   // Opci¢n del formato de Archivo
       LOCAL cOpcSel := ''                  // Opciones Seleccionadas
       LOCAL bCodF02 := NIL                 // Code Block asignado a F2
       LOCAL bCodF05 := NIL                 // Code Block asignado a F5
       LOCAL nTipCur := 0                   // Tipo de Cursor
       LOCAL lPrnArc := .F.                 // .T. Imprimir Archivo
       LOCAL FileTem := ''                  // Archivo Temporal
       LOCAL cPuerto := ''                  // Puerto de Impresi¢n
       LOCAL cTitInf := ''                  // T¡tulo Inferior
       LOCAL nFrmArc := 0                   // Formato Archivo

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DEL TITULO INFERIOR
       cSavPan := SAVESCREEN(0,0,24,79)

       cOpcion := IF(EMPTY(cOpcion),'',ALLTRIM(cOpcion))
       lSelPrn := IF(lSelPrn==NIL,.T.,lSelPrn)

       IF lSelPrn
	  cTitInf := '<F2>Cambiar Impresora '
       ENDIF

       IF VALTYPE(bInsIso) == 'B'
	  cTitInf += '<F5>Gestion Documental'
       ENDIF
*>>>>FIN ANALISIS DEL TITULO INFERIOR

*>>>>ANALISIS DEL TIPO DE FORMATO
       IF lFrmArc==NIL
	  nFrmArc := 0
       ELSE
	  IF VALTYPE(lFrmArc) == 'L'
	     nFrmArc := IF(lFrmArc,1,0)
	  ELSE
	     nFrmArc := lFrmArc
	  ENDIF
       ENDIF
*>>>>FIN ANALISIS DEL TIPO DE FORMATO

*>>>>DIBUJO DEL MARCO DE IMPRESION
       IF EMPTY(cOpcion) .OR. LEN(cOpcion) # 0
	  nNroFil = nMarcos(05,'SELECCION DEL TIPO DE IMPRESION',cTitInf,;
			       16,10,62,20)
       ENDIF
*>>>>FIN DIBUJO DEL MARCO DE IMPRESION

*>>>>IMPRESION DE LA IMPRESORA ACTUAL
       IF lSelPrn
	  @ nNroFil  ,11 SAY 'IMPRESORA ACTUAL:'
	  @ nNroFil+1,11 SAY ALLTRIM(PRN->cNombrePrn)

	  @ nNroFil+3,11 SAY 'PUERTO:'
	  @ nNroFil+4,11 SAY IF(EMPTY(PRN->PuertoPrn),;
				'LPT1',ALLTRIM(PRN->PuertoPrn))
       ELSE
	  @ nNroFil+2,11 SAY 'Por Favor, Seleccione su'
	  @ nNroFil+3,11 SAY 'opci¢n de Impresi¢n'
       ENDIF
*>>>>FIN IMPRESION DE LA IMPRESORA ACTUAL

*>>>>CAMBIAR DE LA IMPRESORA
       nTipCur := SETCURSOR()
       IF lSelPrn
	  bCodF02 := SETKEY(K_F2)
	  SETKEY(K_F2,NIL)
	  SETKEY(K_F2,{||SelePrn(nNroFil,11)})
       ENDIF
*>>>>FIN CAMBIAR DE LA IMPRESORA

*>>>>CAMBIAR LA GESTION DOCUMENTAL
       IF VALTYPE(bInsIso) == 'B'
	  bCodF05 := SETKEY(K_F5)
	  SETKEY(K_F5,NIL)
	  SETKEY(K_F5,bInsIso)
       ENDIF
*>>>>FIN CAMBIAR LA GESTION DOCUMENTAL

*>>>>DECLARACION Y EJECUCION DEL MENU
       IF EMPTY(cOpcion) .OR. LEN(cOpcion) # 0

**********OPCION IMPRESORA WINDOWS XP
	    IF EMPTY(cOpcion) .OR. '1' $ cOpcion
	       AADD(aMenus,STR(++i,1)+'<Impresora Win>')
	       AADD(aAyuda,'Imprime a la impresora en Windows')
	       cOpcSel += '1'
	    ENDIF
**********FIN OPCION IMPRESORA WINDOWS XP

**********OPCION POR IMPRESORA DIRECTA
	    IF EMPTY(cOpcion) .OR. '2' $ cOpcion
	       AADD(aMenus,STR(++i,1)+'<Por Impresora>')
	       AADD(aAyuda,'Imprime a la impresora')
	       cOpcSel += '2'
	    ENDIF
**********FIN OPCION POR IMPRESORA DIRECTA

**********OPCION POR PANTALLA
	    IF EMPTY(cOpcion) .OR. '3' $ cOpcion
	       AADD(aMenus,STR(++i,1)+'<Por Pantalla >')
	       AADD(aAyuda,'Permite ver el informe en la pantalla')
	       cOpcSel += '3'
	    ENDIF
**********FIN OPCION POR PANTALLA

**********OPCION EN ARCHIVO
	    IF EMPTY(cOpcion) .OR. '4' $ cOpcion
	       AADD(aMenus,STR(++i,1)+'<En Archivo   >')
	       AADD(aAyuda,'Imprime a un Archivo')
	       cOpcSel += '4'
	    ENDIF
**********FIN OPCION EN ARCHIVO

**********VALIDACION DE LA OPCION
	    IF EMPTY(aMenus)
	       AADD(aMenus,'1<Impresora Win>')
	       AADD(aMenus,'2<Por Impresora>')
	       AADD(aMenus,'3<Por Pantalla >')
	       AADD(aMenus,'4<En Archivo   >')

	       AADD(aAyuda,'Imprime a la impresora en Windows')
	       AADD(aAyuda,'Imprime a la impresora')
	       AADD(aAyuda,'Permite ver el informe en la pantalla')
	       AADD(aAyuda,'Imprime a un Archivo')
	       cOpcSel := '1234'
	    ENDIF
**********FIN VALIDACION DE LA OPCION

**********SELECCION DEL MENU
	    DO WHILE nOpcPrn == 0
	       nOpcPrn := nMenu(aMenus,aAyuda,nNroFil,43,NIL,NIL,1,.F.)
	    ENDDO
	    nOpcPrn := VAL(SUBS(cOpcSel,nOpcPrn,1))
**********FIN SELECCION DEL MENU

       ELSE
	  nOpcPrn := VAL(cOpcion)
       ENDIF
*>>>>FIN DECLARACION Y EJECUCION DEL MENU

*>>>>ANALISIS DEL TIPO DE IMPRESION
       PathPrn := IF(EMPTY(PathPrn),'printer',PathPrn)
       DO CASE
       CASE nOpcPrn == 1  // Impresora Windows
	    lPrnArc := .F.
	    FilePrn := cFileTempo(PathPrn+'\',SUBS(cNomUsr,1,4),'.pr1')
*	    FilePrn := PathPrn+'\'+'printwin.txt'

       CASE nOpcPrn == 2  // Por Impresora Directa
	    lPrnArc := .F.
	    FilePrn := ''

       CASE nOpcPrn == 3  // Por Pantalla
	    lPrnArc := .T.
	    FilePrn := cFileTempo(PathPrn+'\',SUBS(cNomUsr,1,4),'.pr3')

       CASE nOpcPrn == 4  // En Archivo

	    IF .NOT. (LEN(cOpcion) == 1 .AND. VAL(cOpcion) == 4)

	       aMenus  := {}
	       aAyuda  := {}
	       DO CASE
	       CASE nFrmArc == 1
		    AADD(aMenus,'1<A Formato Prn>')
		    AADD(aMenus,'2<A Formato Txt>')
		    AADD(aMenus,'3<A Formato Dbf>')
		    AADD(aMenus,'4<A Formato Csv>')

		    AADD(aAyuda,'Imprime a Formato de impresora')
		    AADD(aAyuda,'Imprime a Formato de Archivo Texto')
		    AADD(aAyuda,'Imprime a Formato de Archivo Dbf')
		    AADD(aAyuda,'Imprime a Formato de Archivo Csv')

	       CASE nFrmArc == 2
		    AADD(aMenus,'1<A Formato Prn>')
		    AADD(aMenus,'2<A Excel  2003>')
		    AADD(aMenus,'3<A Formato Dbf>')
		    AADD(aMenus,'4<A Formato Csv>')

		    AADD(aAyuda,'Imprime a Formato de impresora')
		    AADD(aAyuda,'Imprime a Formato de Excel 2003')
		    AADD(aAyuda,'Imprime a Formato de Archivo Dbf')
		    AADD(aAyuda,'Imprime a Formato de Archivo Csv')

	       ENDCASE

	       IF LEN(aMenus) # 0
		  nOpcFrm := nMenu(aMenus,aAyuda,nNroFil,43,NIL,NIL,1,.F.)
		  nOpcPrn += nOpcFrm
	       ENDIF

	       SETCURSOR(1)
	       IF 'DRIVERS' $ FilePrn
		  FilePrn := 'tem'+SPACE(05)
	       ELSE
		  FilePrn := SUBS(FilePrn+SPACE(08),1,8)
	       ENDIF
	       @ nNroFil+3,11 SAY 'NOMBRE DEL ARCHIVO:'

	       DO WHILE .T.
		  @ nNroFil+4,11 GET FilePrn PICT '@X'
		  READ
		  IF !EMPTY(FilePrn)
		     EXIT
		  ENDIF
	       ENDDO

	       FilePrn := ALLTRIM(FilePrn)
	       DO CASE
	       CASE nOpcFrm == 2
		    IF nFrmArc == 2
		       FilePrn += '.xls'
		    ELSE
		       FilePrn += '.txt'
		    ENDIF

	       CASE nOpcFrm == 3  // .dbf
*		    FilePrn += '.dbf'
		    FilePrn += '.xls'

	       CASE nOpcFrm == 4
		    FilePrn += '.csv'

	       OTHERWISE
		    FilePrn += '.txt'
	       ENDCASE

	       IF nOpcFrm == 2 .AND. nFrmArc == 2
		  FilePrn := LOWER(PathDoc+'\'+FilePrn)
	       ELSE
		  FilePrn := LOWER(PathPrn+'\'+FilePrn)
	       ENDIF

	    ELSE
	       FilePrn := cFileTempo(PathPrn+'\',SUBS(cNomUsr,1,4),'.pr4')
	    ENDIF
	    lPrnArc := .T.

       ENDCASE
*>>>>FIN ANALISIS DEL TIPO DE IMPRESION

*>>>>ANALISIS DEL ARCHIVO DE IMPRESION
       IF LEN(ALLTRIM(cOpcSel)) # 0
	  IF !lPregunta('DESEA CONTINUAR? Si No') .OR.;
	     !Printer_on(lPrnArc,nOpcPrn)
	     nOpcPrn := 0
	  ENDIF
       ENDIF
*>>>>FIN ANALISIS DEL ARCHIVO DE IMPRESION

*>>>>ACTIVACION DEL ARCHIVO DE IMPRESION
       cPuerto := ALLTRIM(PRN->PuertoPrn)
       cPuerto := IF(EMPTY(cPuerto),'LPT1',cPuerto)
       IF !EMPTY(nOpcPrn)
	  DO CASE
	  CASE nOpcPrn == 1                 // Impresora Win
	     SET PRINTER TO
	     SET PRINTER TO &(FilePrn)

	  CASE nOpcPrn == 2                 // Directa
	       SET PRINTER TO

	  CASE nOpcPrn == 3                 // Por Pantalla
	     SET PRINTER TO
	     SET PRINTER TO &(FilePrn)

	  CASE nOpcPrn == 4                 // Formato Prn
	       SET PRINTER TO
	       SET PRINTER TO &(FilePrn)

	  CASE nOpcPrn == 5                 // Formato Prn
	       SET PRINTER TO
	       SET PRINTER TO &(FilePrn)

	  CASE nOpcPrn == 6 .AND. nOpcFrm == 1    // Formato Txt
	       SET PRINTER TO
	       SET PRINTER TO &(FilePrn)
	       PRN->(DBGOBOTTOM())
	       PRN->(DBSKIP())

	  CASE nOpcPrn == 6 .AND. nOpcFrm == 2    // Formato Xls
	       SET PRINTER TO
	       SET PRINTER TO printer\temprn

	  CASE nOpcPrn == 7                 // Formato Dbf
	       SET PRINTER TO
	       SET PRINTER TO printer\temprn

	  CASE nOpcPrn == 8                 // Formato Xml
	       SET PRINTER TO
	       SET PRINTER TO printer\temprn

	  ENDCASE
       ENDIF
       IF lSelPrn
	  SETKEY(K_F2,bCodF02)
       ENDIF
       IF VALTYPE(bInsIso) == 'B'
	  SETKEY(K_F5,bInsIso)
       ENDIF

       RESTSCREEN(0,0,24,79,cSavPan)
       SETCURSOR(nTipCur)
       RETURN nOpcPrn
*>>>>FIN ACTIVACION DEL ARCHIVO DE IMPRESION

/*************************************************************************
* TITULO..: SELECCION DE LA IMPRESORA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 13/2003 MIE A
       Colombia, Bucaramanga        INICIO: 06:30 PM   AGO 13/2003 MIE

OBJETIVOS:

1- Permite escoger la impresora

3- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION SelePrn(nNroFil,nNroCol)

*>>>>DECLARACION DE VARIABLES
       LOCAL nTipCur := 0                   // Tipo de Cursor
       LOCAL nNroReg                        // N£mero del Registro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE LA IMPRESORA
       nNroReg := nSelPrn(nNroFil+1,nNroCol)
       PRN->(DBGOTO(nNroReg))
*>>>>FIN SELECCION DE LA IMPRESORA

*>>>>IMPRESION DE LA IMPRESORA ACTUAL
       @ nNroFil  ,nNroCol SAY 'IMPRESORA ACTUAL:'
       @ nNroFil+1,nNroCol SAY ALLTRIM(PRN->cNombrePrn)

       @ nNroFil+3,nNroCol SAY 'PUERTO:'
       @ nNroFil+4,nNroCol SAY IF(EMPTY(PRN->PuertoPrn),;
			       'LPT1',ALLTRIM(PRN->PuertoPrn))
       SETCURSOR(0)
       RETURN NIL
*>>>>FIN IMPRESION DE LA IMPRESORA ACTUAL

/*************************************************************************
* TITULO..: VER IMPRESION                                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 14/2003 JUE A
       Colombia, Bucaramanga        INICIO: 04:45 PM   AGO 14/2003 JUE

OBJETIVOS:

1- Permite visualizar o impremir el archivo de impresi¢n

2- Debe estar en uso el archivo de impresoras en uso

3- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION VerPrn(nOpcPrn,FilePrn,nHandle,lHayMsg)

*>>>>DESCRIPCION DE VARIABLES
/*     nOpcPrn                              // Opci¢n de Impresi¢n
       FilePrn                              // @Archivo de Impresi¢n
       nHandle                              // Manejador del Archivo
       lHayMsg                              // .T. Visualizar mensaje */
*>>>>FIN DESCRIPCION DE VARIABLES

*>>>>DECLARACION DE VARIABLES
       LOCAL i := 0                         // Contador
       LOCAL cPuerto := ''                  // Puerto de Impresi¢n
       LOCAL cOrden  := ''                  // Orden de Ejecuci¢n
       LOCAL lSiorNo := .F.                 // Control de flujo

       LOCAL oBrowse := NIL                 // Browse del Archivo
       LOCAL aCampos := {}                  // Definici¢n de Campos
       LOCAL aStrPrn := {}                  // Estructura de impresi¢n
       LOCAL lSiDele := .F.                 // .T. Borrar Archivo
       LOCAL cPatSim := ''                  // Path del Sima
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE LA OPCION DE IMPRESION
       IF EMPTY(nOpcPrn)
	  RETURN NIL
       ENDIF
       lHayMsg := IF(lHayMsg==NIL,.T.,lHayMsg)
       cPatSim := cPathSima()
*>>>>FIN VALIDACION DE LA OPCION DE IMPRESION

*>>>>IMPRESION DE LA ULTIMA LINEA
       SET DEVICE TO PRINT

       lSiorNo := .T.
       DO CASE
       CASE nOpcPrn == 1 // Impresora Win
       CASE nOpcPrn == 2 // Por Pantalla
	    @ PROW()-PROW(),00 SAY ' '
       OTHERWISE
	    @ PROW()+1,00 SAY '.'
       ENDCASE

       SET PRINTER TO
       SET DEVICE TO SCREEN
*>>>>FIN IMPRESION DE LA ULTIMA LINEA

*>>>>DEFINICION DEL BROWSE
       IF nOpcPrn == 7
	  aStrPrn := DBP->(DBSTRUCT())
	  FOR i := 1 TO LEN(aStrPrn)
	      AADD(aCampos,{{ALLTRIM(aStrPrn[i,1]),;
			     ALLTRIM(aStrPrn[i,1])},{NIL}})
	  ENDFOR
	  oBrowse := oBrowse(03,00,22,79,FilePrn,'<ESC>Abondonar',aCampos)
       ENDIF
*>>>>FIN DEFINICION DEL BROWSE

*>>>>ANALISIS DE LA OPCION DE IMPRESION
       cPuerto := ALLTRIM(PRN->PuertoPrn)
       cPuerto := IF(EMPTY(cPuerto),'LPT1',cPuerto)

       DO CASE
       CASE nOpcPrn == 1  // Por Impresora

	    IF FILE(cPatSim+'\'+'SIMACONT\BASES\SIMAPRN.EXE')

	       cOrden := cPatSim+'\'+'SIMACONT\BASES\SIMAPRN '+FilePrn
	       IF !SWPRUNCMD(cOrden,0,"","")
		  cError(cErrorRun(SWPERRMAJ(),SWPERRMIN()))
	       ENDIF

	    ELSE

	       cOrden := 'TYPE ' +FilePrn+' > '+cPuerto
	       IF !SWPRUNCMD(cOrden,0,"","")
		  cError(cErrorRun(SWPERRMAJ(),SWPERRMIN()))
	       ENDIF

	    ENDIF
	    lSiDele := .T.


       CASE nOpcPrn == 2  // Directa
	    lSiDele := .F.

       CASE nOpcPrn == 3  // Por Pantalla

	    LeeTexto(FilePrn)
	    lSiDele := .T.

       CASE nOpcPrn == 4  // En Archivo
	    LeeTexto(FilePrn)

       CASE nOpcPrn == 5  // En Archivo
	    LeeTexto(FilePrn)

       CASE nOpcPrn == 6 .AND. '.TXT' $ UPPER(FilePrn) // En Archivo
	    LeeTexto(FilePrn)
	    CloseXls(FilePrn,nHandle)

       CASE nOpcPrn == 6 .AND. '.XLS' $ UPPER(FilePrn) // En Archivo

	    CloseXls(FilePrn,nHandle)

	    IF lHayMsg
	       IF 'MISDOC' $ UPPER(FilePrn)
		   cError(FilePrn,'ARCHIVO GENERADO:')
	       ELSE
		   cError('ARCHIVO GENERADO')
	       ENDIF
	    ENDIF

       CASE nOpcPrn == 7  // En Archivo Dbf
	    DBP->(CtrlBrw(.T.,oBrowse))


       CASE nOpcPrn == 8  // En Archivo Csv
	    LeeTexto(FilePrn)
	    CloseCsv(FilePrn,nHandle)

/*
       CASE nOpcPrn == 8  // En Archivo Xml
	    LeeTexto(FilePrn)
	    CloseXml(FilePrn,nHandle)
*/

       ENDCASE
*>>>>FIN ANALISIS DE LA OPCION DE IMPRESION

/*
*>>>>CIERRE DEL ARCHIVO XML
       IF EMPTY(nHandle)
	  CloseXml(FilePrn,nHandle)
       ENDIF
*>>>>FIN CIERRE DEL ARCHIVO XML
*/

*>>>>ELIMINACION DEL ARCHIVO
       IF lSiDele
	  IF !lFileDelete(FilePrn)
	     cError('NO SE BORRO EL ARCHIVO DE IMPRESION')
	  ENDIF
       ENDIF
       RETURN NIL
*>>>>FIN ELIMINACION DEL ARCHIVO

/*************************************************************************
* TITULO..: CONVERSION DE NUMERO A LETRAS                                *
**************************************************************************

AUTOR: Abraxas                      FECHA DE CREACION: AGO 20/2004 VIE A
       Colombia, Bucaramanga        INICIO: 11:30 AM   AGO 20/2004 VIE

OBJETIVOS:

1- Permite convertir un numero a letras

3- Retorna el texto en letras

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Letras( nNumero, cGenero )

// Declaraci¢n de constantes
#define  Y           "y "
#define  F           "as "
#define  M           "os "
#define  MIL         "mil "
#define  MILLON      "millon "
#define  MILLONES    "millones "
#define  BILLON      "billon "
#define  BILLONES    "billones "

// Declaraci¢n de Variables
LOCAL aGrupos[5], aUnidad[10], aDecena[10,10], aCentena[10],;
      aConector[5], cEnLetra, nGrupo, cNumStr, cUnidad,;
      cDecena, cCentena

  // Control de Par metros opcionales
  if cGenero = NIL
     cGenero := "F"
  else
     cGenero := upper( cGenero )
  end if

  // Control del tipo de los par metros
  if valtype( nNumero ) != "N" .or. valtype( cGenero ) != "C"
     RETURN ""
  end if

  // Code Blocks para las Unidades
  aUnidad[ 1] := {|| if( nNumero = 0 .and. nGrupo = 1,     ;
                         "cero", "" )}
  aUnidad[ 2] := {|| if( cDecena = "1",                    ;
                         aDecena[2, val( cUnidad ) + 1],   ;
                         if( aGrupos[nGrupo] = "001" .and. ;
                             ( nGrupo = 2.or.nGrupo = 4 ), ;
                             "",                         ;
                             if( nGrupo > 2, "un ",        ;
                                 if( cGenero = "F", "una ",;
                                     "uno " ) ) ) ) }

  aUnidad[ 3] := {|| if( cDecena="1",                      ;
                         aDecena[2, val( cUnidad ) + 1],   ;
                         "dos " )}

  aUnidad[ 4] := {|| if( cDecena="1",                      ;
                         aDecena[2, val( cUnidad ) + 1],   ;
                         "tres " )}

  aUnidad[ 5] := {|| if( cDecena="1",                      ;
                         aDecena[2, val( cUnidad ) + 1],   ;
                         "cuatro " )}

  aUnidad[ 6] := {|| if( cDecena="1",                      ;
                         aDecena[2, val( cUnidad ) + 1],   ;
                         "cinco " )}

  aUnidad[ 7] := {|| if( cDecena="1",                      ;
                         aDecena[2, val( cUnidad ) + 1],   ;
                         "seis " )}

  aUnidad[ 8] := {|| if( cDecena="1",                      ;
                         aDecena[2, val( cUnidad ) + 1],   ;
                         "siete " )}

  aUnidad[ 9] := {|| if( cDecena="1",                      ;
                         aDecena[2, val( cUnidad ) + 1],   ;
                         "ocho " )}

  aUnidad[10] := {|| if( cDecena="1",                      ;
                         aDecena[2, val( cUnidad ) + 1],   ;
                         "nueve " )}

  // Code Blocks para las Decenas
  aDecena[ 1, 1] := {|| ""}
  aDecena[ 2, 1] := {|| if( cUnidad = "0", "diez ", "" )}
  aDecena[ 2, 2] := "once "
  aDecena[ 2, 3] := "doce "
  aDecena[ 2, 4] := "trece "
  aDecena[ 2, 5] := "catorce "
  aDecena[ 2, 6] := "quince "
  aDecena[ 2, 7] := "dieciseis "
  aDecena[ 2, 8] := "diecisiete "
  aDecena[ 2, 9] := "dieciocho "
  aDecena[ 2,10] := "diecinueve "
  aDecena[ 3, 1] := {|| if( cUnidad="0","veinte ","veinti" )}
  aDecena[ 4, 1] := {|| "treinta "+if( cUnidad!="0",Y,"" )}
  aDecena[ 5, 1] := {|| "cuarenta "+if( cUnidad!="0",Y,"")}
  aDecena[ 6, 1] := {|| "cincuenta "+if(cUnidad!="0",Y,"")}
  aDecena[ 7, 1] := {|| "sesenta "+ if( cUnidad!="0",Y,"")}
  aDecena[ 8, 1] := {|| "setenta "+ if( cUnidad!="0",Y,"")}
  aDecena[ 9, 1] := {|| "ochenta "+ if( cUnidad!="0",Y,"")}
  aDecena[10, 1] := {|| "noventa "+ if( cUnidad!="0",Y,"")}

  // Code Blocks para las Centenas
  aCentena[ 1] := {|| ""}
  aCentena[ 2] := {|| if( cDecena + cUnidad = "00","cien ",;
                          "ciento " )}

  aCentena[ 3] := {|| "doscient" + if(nGrupo < 3 .and. ;
                                      cGenero = "F", F, M )}

  aCentena[ 4] := {|| "trescient" + if(nGrupo < 3 .and. ;
                                       cGenero = "F", F, M )}

  aCentena[ 5] := {|| "cuatrocient"+if(nGrupo < 3 .and. ;
                                       cGenero = "F", F, M )}

  aCentena[ 6] := {|| "quinient" + if( nGrupo < 3 .and. ;
                                       cGenero = "F", F, M )}

  aCentena[ 7] := {|| "seiscient" + if(nGrupo < 3 .and. ;
                                       cGenero = "F", F, M )}

  aCentena[ 8] := {|| "setecient" + if(nGrupo < 3 .and.;
                                       cGenero = "F", F, M )}

  aCentena[ 9] := {|| "ochocient" + if(nGrupo < 3 .and.;
                                       cGenero = "F", F, M )}

  aCentena[10] := {|| "novecient" + if(nGrupo < 3 .and.;
                                       cGenero = "F", F, M )}

  // Code Blocks para los Conectores
  aConector[1] := {|| ""}
  aConector[2] := {|| if( aGrupos[2] > "000", MIL , "")}
  aConector[3] := {|| if( aGrupos[3] > "000" .or.;
                          aGrupos[4] > "000",    ;
                          if( aGrupos[3] = "001", MILLON,;
                              MILLONES ), "" )}
  aConector[4] := {|| if( aGrupos[4] > "000", MIL, "" )}
  aConector[5] := {|| if( aGrupos[5] > "000", ;
                      if( aGrupos[5] = "001", BILLON,;
                          BILLONES ), "" )}

  // Conversi¢n a car cter del n£mero,
  // justificando con 0 a la izquierda
  cNumStr := alltrim( str( nNumero, 15, 0 ) )
  cNumStr := replicate( "0", 15 - len( cNumStr ) ) + cNumStr

  // Confecci¢n de los Grupos
  for nGrupo := 1 TO 5
      aGrupos[5 - nGrupo + 1] := substr( cNumStr, ;
                                 ( nGrupo - 1 ) * 3 + 1, 3 )
  next

  // Proceso
  cEnLetra := ""
  for nGrupo := 5 to 1 step -1
   // Extraer cada una de las 3 cifras del Grupo en curso
   cUnidad :=right ( aGrupos[nGrupo], 1    )
   cDecena :=substr( aGrupos[nGrupo], 2, 1 )
   cCentena:=left  ( aGrupos[nGrupo], 1    )

   // Componer la cifra en letra del Grupo en curso
   cEnletra:=cEnLetra+eval( aCentena[val( cCentena )+1])   +;
                            eval(aDecena[val(cDecena)+1,1])+;
                            eval(aUnidad[val(cUnidad)+1])  +;
                            eval( aConector[nGrupo] )
  next

// Salida
RETURN cEnLetra

FUNCTION Eject()
EJECT
RETURN NIL

/*************************************************************************
* TITULO..: CAMPOS DE SUSTITUCION                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 24/2004 JUE A
       Colombia, Bucaramanga        INICIO: 11:00 PM   SEP 24/2004 JUE

OBJETIVOS:

1- Agrega a los campos del archivo al vector de sustituci¢n de texto

2- Return Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CamSusPrn(aMezcla)

*>>>>PARAMETROS DE LA FUNCION
/*     aMezcla                              // @Campos a Mesclar */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL aStrDbf := {}                  // Estructura Vieja
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE LA ESTRUCTURA
       aStrDbf := PRN->(DBSTRUCT())
       FOR i := 1 TO LEN(aStrDbf)
	   AADD(aMezcla,{'<'+aStrDbf[i,1]+'>',PCL(aStrDbf[i,1])})
       ENDFOR
       RETURN NIL
*>>>>FIN VALIDACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO..: TEXTO DE AYUDA CAMPOS DE IMPRESION                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 18/2005 VIE A
       Colombia, Bucaramanga        INICIO: 02:15 PM   MAR 18/2005 VIE

OBJETIVOS:

1- Retorna el texto de ayuda con los titulos de los campos correspondientes

2- Return Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cTxtHlpPrn()

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL aStrDbf := {}                  // Estructura Vieja
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE VARIABLES
       LOCAL cTxtHlp := ''                  // Texto de Ayuda
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE LA ESTRUCTURA
       cTxtHlp := cEnter(2)+'Para controlar la impresora usar: '+cEnter()+;
       '<JI> => Justificaci¢n a la Izquierda'+cEnter()+;
       '<JD> => Justificaci¢n a la Derecha'+cEnter()+;
       '<JC> => Texto centrado'+cEnter()+;
       '<JF> => Justificaci¢n completa'+cEnter()

       aStrDbf := PRN->(DBSTRUCT())
       FOR i := 1 TO LEN(aStrDbf)
	   cTxtHlp += '<'+aStrDbf[i,1]+'>'+cEnter()
       ENDFOR
       RETURN cTxtHlp
*>>>>FIN VALIDACION DE LAS STRUCTURAS

/*************************************************************************
* TITULO..: PIE DE PAGINA PARA LOS INFORMES                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 10/2006 VIE A
       Colombia, Bucaramanga        INICIO: 05:20 PM   NOV 10/2006 VIE

OBJETIVOS:

1- Imprime el pie de p gina para los informes SIN SALTO DE PAGINA

2- Return NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PiePagPrn(aTxtPie,nLenPrn,nLinPie,lOficio)

*>>>>DESCRIPCION DE PARAMETROS
/*     aTxtPie				    // Textos del pie de p gina
       nLenPrn                              // Longitud de impresi¢n
       nLinPie			            // L¡neas de impresion del pie de pagina
       lOficio                              // .F. Tama¤o Carta */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL nNroCol := 0                   // N£mero de columna
       LOCAL cTxtPrn := ''                  // Texto a imprimir
       LOCAL lSiorNo := .F.                 // Control de flujo
       LOCAL aPiePag := {}                  // Pie de p gina
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE PARAMETROS
       SET DEVICE TO PRINT
       IF EMPTY(aTxtPie)
*	  EJECT
	  RETURN NIL
       ENDIF

       lOficio := IIF(EMPTY(lOficio),.F.,lOficio)
       IF EMPTY(nLinPie)
	  nLinPie := IIF(lOficio,73,61)-PROW()
       ENDIF
*>>>>FIN VALIDACION DE PARAMETROS

*>>>>CALCULO DE COLUMNA DE IMPRESION
       nNroCol = (nLenPrn-LEN(cTxtPrn))/2
       IF nNroCol < 0
	  SET DEVICE TO SCREEN
	  cError('LA COLUMNA ES NEGATIVA EN PiePagina()')
	  SET DEVICE TO PRINT
       ENDIF
*>>>>FIN CALCULO DE COLUMNA DE IMPRESION

*>>>>PIE DE PAGINA
       aPiePag := {}
       FOR i := 1 TO LEN(aTxtPie)

	   IF !EMPTY(aTxtPie[i])
	      AADD(aPiePag,aTxtPie[i])
	   ENDIF

       ENDFOR
*>>>>FIN PIE DE PAGINA

*>>>>IMPRESION DEL PIE DE PAGINA
       FOR i := 1 TO LEN(aPiePag)

***********CONVERSION DE LOS CODIGO DE IMPRESION
	     cTxtPrn := ALLTRIM(cTxtToPcl(aPiePag[i]))
	     IF EMPTY(cTxtPrn)
		LOOP
	     ENDIF
***********FIN CONVERSION DE LOS CODIGO DE IMPRESION

***********CALCULO DE COLUMNA DE IMPRESION
	     nNroCol = (nLenPrn-LEN(cTxtPrn))/2
	     IF nNroCol < 0
		SET DEVICE TO SCREEN
		cError('LA COLUMNA ES NEGATIVA EN PiePagina()')
		SET DEVICE TO PRINT
	     ENDIF
***********FIN CALCULO DE COLUMNA DE IMPRESION

***********IMPRESION DEL PIE DE PAGINA
	   IF i == 1
	      @ PROW(),00 SAY PCL({"NegraOf","CondenOn","DobGolOn"})
	      @ PROW()+nLinPie,nNroCol SAY cTxtPrn
	      lSiorNo := .T.
	   ELSE
	      @ PROW()+1,nNroCol SAY cTxtPrn
	   ENDIF
***********FIN IMPRESION DEL PIE DE PAGINA

       ENDFOR
       IF lSiorNo
	  @ PROW(),00 SAY PCL({"CondenOf","DobGolOf"})
       ENDIF
*       EJECT
       RETURN NIL
*>>>>FIN IMPRESION DEL PIE DE PAGINA

/*************************************************************************
* TITULO..: PIE DE PAGINA PARA LOS INFORMES                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 10/2006 VIE A
       Colombia, Bucaramanga        INICIO: 05:20 PM   NOV 10/2006 VIE

OBJETIVOS:

1- Imprime el pie de p gina para los informes CON SALTO DE PAGINA
2- Return NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PiePagIso(aTxtPie,nLenPrn,nLinPie,lOficio)

*>>>>DESCRIPCION DE PARAMETROS
/*     aTxtPie				    // Textos del pie de p gina
       nLenPrn                              // Longitud de impresi¢n
       nLinPie			            // L¡neas de impresion del pie de pagina
       lOficio                              // .F. Tama¤o Carta */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL nNroCol := 0                   // N£mero de columna
       LOCAL cTxtPrn := ''                  // Texto a imprimir
       LOCAL lSiorNo := .F.                 // Control de flujo
       LOCAL aPiePag := {}                  // Pie de p gina
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE PARAMETROS
       SET DEVICE TO PRINT
       IF EMPTY(aTxtPie)
	  EJECT
	  RETURN NIL
       ENDIF

       lOficio := IIF(EMPTY(lOficio),.F.,lOficio)
       IF EMPTY(nLinPie)
	  nLinPie := IIF(lOficio,71,59)-PROW()
       ENDIF
*>>>>FIN VALIDACION DE PARAMETROS

*>>>>CALCULO DE COLUMNA DE IMPRESION
       nNroCol = (nLenPrn-LEN(cTxtPrn))/2
       IF nNroCol < 0
	  SET DEVICE TO SCREEN
	  cError('LA COLUMNA ES NEGATIVA EN PiePagina()')
	  SET DEVICE TO PRINT
       ENDIF
*>>>>FIN CALCULO DE COLUMNA DE IMPRESION

*>>>>PIE DE PAGINA
       aPiePag := {}
       FOR i := 1 TO LEN(aTxtPie)

	   IF !EMPTY(aTxtPie[i])
	      AADD(aPiePag,aTxtPie[i])
	   ENDIF

       ENDFOR
*>>>>FIN PIE DE PAGINA

*>>>>IMPRESION DEL PIE DE PAGINA
       FOR i := 1 TO LEN(aPiePag)

***********CONVERSION DE LOS CODIGO DE IMPRESION
	     cTxtPrn := ALLTRIM(cTxtToPcl(aPiePag[i]))
	     IF EMPTY(cTxtPrn)
		LOOP
	     ENDIF
***********FIN CONVERSION DE LOS CODIGO DE IMPRESION

***********CALCULO DE COLUMNA DE IMPRESION
	     nNroCol = (nLenPrn-LEN(cTxtPrn))/2
	     IF nNroCol < 0
		SET DEVICE TO SCREEN
		cError('LA COLUMNA ES NEGATIVA EN PiePagina()')
		SET DEVICE TO PRINT
	     ENDIF
***********FIN CALCULO DE COLUMNA DE IMPRESION

***********IMPRESION DEL PIE DE PAGINA
	   IF i == 1
	      @ PROW(),00 SAY PCL({"NegraOf","CondenOn","DobGolOn"})
	      @ PROW()+nLinPie,nNroCol SAY cTxtPrn
	      lSiorNo := .T.
	   ELSE
	      @ PROW()+1,nNroCol SAY cTxtPrn
	   ENDIF
***********FIN IMPRESION DEL PIE DE PAGINA

       ENDFOR
       IF lSiorNo
	  @ PROW(),00 SAY PCL({"CondenOf","DobGolOf"})
       ENDIF
       EJECT
       RETURN NIL
*>>>>FIN IMPRESION DEL PIE DE PAGINA

/*************************************************************************
* TITULO..: SUSTITUCION CAMPOS CON COMANDOS DE LA IMPRESORA              *
**************************************************************************

OBJETIVOS:

1- Sustituye los campos de la impresora con los comandos de impresion
   de la impresora.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cTxtToPcl(cLinTxt)

*>>>>DESCRIPCION DE PARAMETROS
/*     cLinTxt                              // L¡nea de Texto */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL aCamPrn := {}                  // Campos a Mesclar iniciales
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SUSTITUCION DE LOS CAMPOS
       CamSusPrn(@aCamPrn)
       FOR i := 1 TO LEN(aCamPrn)
	   IF AT(aCamPrn[i,1],cLinTxt) > 0
	      cLinTxt := cReplTxt(aCamPrn[i,1],aCamPrn[i,2],cLinTxt)
	   ENDIF
       ENDFOR
       RETURN cLinTxt
*>>>>FIN SUSTITUCION DE LOS CAMPOS

/*************************************************************************
* TITULO..: IMPRIMIR UN INFORME                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 22/2006 MAR A
       Colombia, Bucaramanga        INICIO: 02:00 PM   AGO 22/2006 MAR

OBJETIVOS:

1- Permite imprimir un informe con los detalles de iso.
   de admisi¢n.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrinterInf(lShared,cNomSis,cNomEmp,cNomUsr,nNroIso,cOpcSys,aMezIso,;
		    aTitIso,cPiePag,aPieIso,lPrnArc,FilePrn,cOpcPrn,lSelPrn,;
		    lFrmArc,aTitPrn,aNroCol,aCabSec,cNalias,aRegPrn,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cNomSis                              // Nombre del Sistema
       cNomEmp                              // Nombre de la Empresa
       cNomUsr                              // Nombre del Usuario
       nNroIso                              // N£mero Iso del Informe
       cOpcSys                              // Opci¢n del Sistema
       aMezIso                              // Campos a Mesclar
       aTitIso                              // T¡tulo Iso del Informe
       cPiePag                              // Pie de P gina por defecto
       aPieIso                              // Textos del pie de p gina
       lPrnArc                              // .T. Imprimir a Archivo
       FilePrn                              // Archivo de impresion
       cOpcPrn                              // Opciones de Impresi¢n
       lSelPrn                              // .T. Selecionar Impresora
       lFrmArc                              // .T. Formato de Archivo
       aTitPrn                              // T¡tulos para impresi¢n
       aNroCol                              // Columnas de impresi¢n
       aCabSec                              // Encabezado Secundario
       cNalias                              // Alias del Archivo a imprimir
       aRegPrn                              // Registros para impresi¢n
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
     *ÀVariables generales

       LOCAL     i,j := 0                   // Contador
       LOCAL cCodIso := ''                  // C¢digo Iso del Informe

       LOCAL nTotPie := 0                   // Total de Pie de p ginas

       LOCAL bInsIso := NIL                 // Block de Gestion Documental

       LOCAL nRegPrn := 0                   // Registro de Impresi¢n
       LOCAL nHanXml := 0                   // Manejador del Archivo
       LOCAL cFecPrn := ''                  // @Fecha de Impresi¢n
       LOCAL cHorPrn := ''                  // @Hora de Impresi¢n
       LOCAL cDiaPrn := ''                  // @D¡a de Impresi¢n
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabPrn := {}                  // Encabezado del informe General
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL cCabCol := ''                  // Encabezado de Columna
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL lCentra := .F.                 // .T. Centrar el informe
       LOCAL nColCab := 0                   // Columna del encabezado
       LOCAL bPagina := NIL                 // Block de P gina
       LOCAL bCabeza := NIL                 // Block de Encabezado
       LOCAL bDerAut := NIL                 // Block Derechos de Autor
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
     *ÀVariables de informe

       LOCAL nAvance := 0                   // Avance de registros
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>GESTION DOCUMENTAL DEL INFORME
       nLenPrn := PCL('n17Stan')
       IF !EMPTY(cPiePag)
	  cPiePag := SPACE((nLenPrn-LEN(cTxtPrn))/2)+cPiePag
       ENDIF

       bInsIso := {||lModRegIso(lShared,cNomUsr,oBrowse,;
				nNroIso,aTitIso[1],cOpcSys)}
     *ÀInclusi¢n o modificaci¢n de la gesti¢n docuemental
*>>>>FIN GESTION DOCUMENTAL DEL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       nRegPrn := PRN->(RECNO())

       IF lPrnArc
	  SET DEVICE TO PRINT
       ELSE
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,cOpcPrn,lSelPrn,lFrmArc,;
				 bInsIso)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>SUSTITUCION DE TEXTO
       DetalleIso(nNroIso,@cCodIso,@aTitIso,@aPieIso)

       IF !EMPTY(cCodIso)
	  cCodIso := 'ISO:'+cCodIso
       ENDIF

       FOR i := 1 TO LEN(aTitIso)
	   FOR j := 1 TO LEN(aMezIso)
	       aTitIso[i] := cReplTxt(aMezIso[j,1],aMezIso[j,2],aTitIso[i])
	   ENDFOR
       ENDFOR

       nTotPie := 0
       FOR i := 1 TO LEN(aPieIso)
	   IF EMPTY(aPieIso[i])
	      LOOP
	   ENDIF
	   nTotPie++
       ENDFOR
*>>>>FIN SUSTITUCION DE TEXTO

*>>>>DEFINICION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.
       nTotReg := 0

       aCabPrn := {cNomEmp,cNomSis+cCodIso,aTitIso[1],aTitIso[2],aTitIso[3]}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
                   nNroPag++,;
                   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINICION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       cCabCol := cRegPrint(aTitPrn,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       lCentra := .F.
       nColCab := 0
       IF lCentra
          nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF

       bPagina := {||lPagina(nTotPie)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
                               nColCab,cCodFin,aCabSec,;
			       @cFecPrn,@cHorPrn,@cDiaPrn)}

       bDerAut := {||PiePagPrn(aPieIso)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>IMPRESION DEL ENCABEZADO
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado

       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)

       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,nOpcPrn,aCabPrn,aTitPrn)
*>>>>FIN IMPRESION DEL ENCABEZADO

*>>>>RECORRIDO DE LOS REGISTROS
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT

       SELECT &cNalias
       DBGOTOP()
       DO WHILE .NOT. EOF()

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( RECNO() / RECCOUNT() )*100)

            IF STR(nAvance,3) $ '25 50 75100'
               SET DEVICE TO SCREEN
               Termometro(nAvance)
               SET DEVICE TO PRINT
            ENDIF
**********FIN VISUALIZACION DE AVANCE

**********REGISTROS DE IMPRESION
	    FOR i := 1 TO LEN(aRegPrn)

/*
SET DEVICE TO SCREEN
cError('1:'+PRO->cCodigoPro,;
       '2:'+EVAL({||PRO->cCodigoPro}),;
       '3:'+EVAL(aRegPrn[i]))
SET DEVICE TO PRINT
*/

		IF VALTYPE(aRegPrn[i]) == 'B'
		   aRegPrn[i] := EVAL(aRegPrn[i])
		ELSE
		   aRegPrn[i] := aRegPrn[i]
		ENDIF

/*
SET DEVICE TO SCREEN
cError('1:'+PRO->cCodigoPro,;
       '2:'+EVAL({||PRO->cCodigoPro}),;
       '3:'+aRegPrn[i])
SET DEVICE TO PRINT
*/

SET DEVICE TO SCREEN
wait aNroCol[i]
wait aTitPrn[i]
wait aRegPrn[i]
SET DEVICE TO PRINT



	    ENDFOR
**********FIN REGISTROS DE IMPRESION

/*
**********IMPRESION DEL REGISTRO
	    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL REGISTRO
*/

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT &cNalias
	    DBSKIP()
	    IF EOF()
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN RECORRIDO DE LOS REGISTROS

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       VerPrn(nOpcPrn,FilePrn,nHanXml)
       PRN->(DBGOTO(nRegPrn))

       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: IMPRESION DEL CAMPO MEMO                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 25/2006 VIE A
       Colombia, Bucaramanga        INICIO: 07:00 PM   AGO 25/2006 VIE

OBJETIVOS:

1- Imprime el campo memo

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnMemo(lShared,nOpcPrn,FilePrn,nHanXml,nColCab,aTitPrn,;
		 aNroCol,bPagina,bDerAut,bCabeza,cMemo,nLenPrn)

*>>>>DECLARACION DE VARIABLES
/*     lShared                              // .T. Sistema Compartido
       nOpcPrn                              // Opci¢n de Impresi¢n
       FilePrn                              // Archivo de impresion
       nHanXml                              // Manejador del Archivo
       nColCab                              // Columna del encabezado
       aTitPrn                              // T¡tulos para impresi¢n
       aNroCol                              // Columnas de impresi¢n
       bPagina                              // Block de P gina
       bCabeza                              // Block de Encabezado
       bDerAut                              // Block Derechos de Autor
       cMemo                                // Campo de memo
       nLenPrn                              // Longitud del campo a imprimir */
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE VARIABLES
       LOCAL     i,j := 0                   // Contadores
       LOCAL nNroPos := 0                   // N£mero de la posici¢n
       LOCAL cSalLin := ''                  // Salto de l¡nea
       LOCAL cEnter  := ''                  // Enter
       LOCAL aTxtMem := {}                  // Texto por parrafos
       LOCAL cTxtTem := ''                  // Texto temporal
       LOCAL aNroLin := {}                  // N£mero de l¡neas
       LOCAL aRegPrn := {}                  // Registros para impresi¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ELIMINACION CARACTERES ESPECIALES
       cMemo := ALLTRIM(cMemo)

       cSalLin := CHR(141)+CHR(10)
       nNroPos := 1
       DO WHILE nNroPos # 0
	  nNroPos := AT(cSalLin,cMemo)
	  IF nNroPos # 0
	     cMemo := STUFF(cMemo,nNroPos,2,'')
	  ENDIF
       ENDDO
*>>>>FIN ELIMINACION CARACTERES ESPECIALES

*>>>>DIVISION POR PARRAFOS
       aTxtMem := {}

	cEnter := CHR(13)+CHR(10)
       nNroPos := 1
       DO WHILE nNroPos # 0
	  nNroPos := AT(cEnter,cMemo)
	  IF nNroPos # 0
	     cTxtTem := SUBS(cMemo,1,nNroPos-1)

	     AADD(aTxtMem,cTxtTem)
	     cMemo := STUFF(cMemo,1,nNroPos+1,'')
	  ELSE
	     AADD(aTxtMem,cMemo)
	  ENDIF
       ENDDO
*>>>>FIN DIVISION POR PARRAFOS

*>>>>IMPRESION DEL CAMPO MEMO
       FOR i := 1 TO LEN(aTxtMem)

	   aNroLin := aDivLin(aTxtMem[i],nLenPrn)

	   FOR j := 1 TO LEN(aNroLin)

	       cMemo := aNroLin[j]
	       cMemo := SUBS(cMemo+SPACE(nLenPrn),1,nLenPrn)

	       aRegPrn := {}
	       AADD(aRegPrn,cMemo)

	       lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		       aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

	   ENDFOR

       ENDFOR
       RETURN NIL
*>>>>FIN IMPRESION DEL CAMPO MEMO

/*************************************************************************
* TITULO..: TAMA¥O DE LA PAGINA                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 16/2006 JUE A
       Colombia, Bucaramanga        INICIO: 11:30 AM   NOV 16/2006 JUE

OBJETIVOS:

1- Retorna un Comando de Control de la impresora del tama¤o de la p gina.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cPageLen(nLinPag)

*>>>>DESCRIPCION DE PARAMETROS
/*     nLinPag                              // L¡neas por p gina. */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroPos := ''                  // N£mero de la posici¢n
       LOCAL cTxtPcl := ''                  // Texto Pcl
       LOCAL cCmdPcl := ''                  // Comando Pcl
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DEL TAMA¥O DE LA PAGINA
       cTxtPcl := PCL('PageLen')
       nNroPos := AT('#',cTxtPcl)

       IF nNroPos # 0
	  cCmdPcl := SUBS(cTxtPcl,1,nNroPos-1)+ALLTRIM(STR(nLinPag,2))+;
		     SUBS(cTxtPcl,nNroPos+1,LEN(cTxtPcl))
       ENDIF

       RETURN cCmdPcl
*>>>>FIN CALCULO DEL TAMA¥O DE LA PAGINA

/*************************************************************************
* TITULO..: POSICION X,Y EN PRESCRIBE                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 23/2006 JUE A
       Colombia, Bucaramanga        INICIO: 07:30 PM   ENE 23/2006 JUE

OBJETIVOS:

1- Lee la posici¢n de impresi¢n de los valores pasados como argumentos

2- Cada posici¢n leida es truncada de la posici¢n original

2- Retorna la posici¢n de retorno

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cPosMzp(cCodMzp)

*>>>>DECLARACION DE PARAMETROS
/*     cCosMzp                              // @C¢digos de las posiciones de impresi¢n */
*>>>>FIN DECLARACION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroPos := 0                   // N£mero de la posici¢n
       LOCAL cPosMzp := ''                  // Coordenas de Impresi¢n */
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE LA POSICION
       cCodMzp := ALLTRIM(cCodMzp)
       nNroPos := AT(';',cCodMzp)

       IF nNroPos # 0

	  IF LEN(cCodMzp) # nNroPos
	     cPosMzp := SUBS(cCodMzp,1,nNroPos)
	   *ÀLee las coordenas de impresion

	     cCodMzp := SUBS(cCodMzp,nNroPos+1,LEN(cCodMzp))
	   *ÀTruncamiento de la coordena leida
	  ELSE
	     cPosMzp := cCodMzp
	     cCodMzp := ''
	  ENDIF
       ENDIF

       RETURN cPosMzp
*>>>>FIN LECTURA DE LA POSICION

/*************************************************************************
* TITULO..: LEE UNA COORDENA DE IMPRESION X,Y EN PRESCRIBE                                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 23/2006 JUE A
       Colombia, Bucaramanga        INICIO: 07:30 PM   ENE 23/2006 JUE

OBJETIVOS:

1- Lee una posici¢n de impresi¢n de los valores pasados como argumentos

2- Cada posici¢n leida es truncada de la posici¢n original

2- Retorna la posici¢n de retorno

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cPosMzpXY(cCodMzp,nNroPos)

*>>>>DECLARACION DE VARIABLES
/*     cCosMzp                              // C¢digos de las posiciones de impresi¢n
       nNroPos                              // N£mero de la Posici¢n */
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE VARIABLES
       LOCAL i := 1                         // Contador
       LOCAL cPosMzp := ''                  // Coordenas de Impresi¢n */
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE LA COORDENADA
       FOR i := 1 TO nNroPos
	   cPosMzp := cPosMzp(@cCodMzp)
       ENDFOR
       RETURN cPosMzp
*>>>>FIN LECTURA DE LA COORDENADA

/*************************************************************************
* TITULO..: IMPRESION DE LINEAS EN PRESCRIBE                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 23/2006 JUE A
       Colombia, Bucaramanga        INICIO: 08:00 PM   ENE 23/2006 JUE

OBJETIVOS:

1- Imprime una linea de impresi¢n en Prescribe

2- Retorna Nil


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION LineaMzp(cCodMzp,cTxtPrn,nTotPrn,nNroPos)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodMzp                              // C¢digos de las coordenadas de impresi¢n
       cTxtPrn                              // Texto a imprimir
       nTotPrn                              // Total de Impresiones
       nNroPos                              // N£mero de la Posici¢n */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL i := 0                         // Contador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE LAS LINEAS
       nNroPos := IF(nNroPos == NIL,0,nNroPos)
       IF nNroPos == 0
	  FOR i := 1 TO nTotPrn
	      Post('MZP '+cPosMzpXY(cCodMzp,i)+' TEXT "'+cTxtPrn+'";')
	  ENDFOR
       ELSE
	  Post('MZP '+cPosMzpXY(cCodMzp,nNroPos)+' TEXT "'+cTxtPrn+'";')
       ENDIF
       RETURN NIL
*>>>>FIN IMPRESION DE LAS LINEAS

/*************************************************************************
* TITULO..: IMPRESION DE UNA LINA A LA IMPRESORA                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 27/2007 JUE A
       Colombia, Bucaramanga        INICIO: 11:15 PM   SEP 27/2007 JUE

OBJETIVOS:

1- Imprime una linea a la impresora

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Prn(cTxtPrn,nNroFil,nNroCol)

*>>>>DESCRIPCION DE PARAMETROS
/*     cTxtPrn                              // Texto a imprimir
       nNroFil                              // N£mero de la fila
       nNroCol                              // N£mero de la Columna */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>IMPRESION DE LA LINEA
      nNroFil := IF(nNroFil=NIL,1,nNroFil)
      nNroCol := IF(nNroCol=NIL,0,nNroCol)
      @ PROW()+nNroFil,nNroCol SAY cTxtPrn
      RETURN NIL
*>>>>FIN IMPRESION DE LA LINEA

/*************************************************************************
* TITULO..: CREACION DEL ARCHIVO XSL PARA LOS INFORMES                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 27/2007 JUE A
       Colombia, Bucaramanga        INICIO: 11:00 PM   SEP 27/2007 JUE

OBJETIVOS:

1- Crea el archivo XSL para los informes virtuales.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION InfPrnXsl(PathWww)

*>>>>DESCRIPCION DE PARAMETROS
/*     PahtWww                              // Path del Sitio */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL FileXsl := ''                  // Archivo Xsl
       LOCAL FilePdf := ''                  // Archivo Pdf

       LOCAL       k := 0                   // Contador
       LOCAL cTxtPrn := ''                  // Texto a imprimir
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL ARCHIVO
       IF FILE(FileXsl)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL ARCHIVO

*>>>>XSL POR DEFECTO
      FileXsl := PathWww+'\'+'INFHTM00.WWW'
      IF !FILE(FileXsl)
	 fXslHtm00(FileXsl)
      ENDIF
*>>>>FIN XSL POR DEFECTO

*>>>>XSL FORMATO ISO
      FileXsl := PathWww+'\'+'INFHTM01.WWW'
      IF !FILE(FileXsl)
	 fXslHtm01(FileXsl)
      ENDIF
*>>>>FIN XSL FORMATO ISO

*>>>>XSL CONVERSION A PDF
      FileXsl := PathWww+'\'+'INFPDF00.WWW'
      IF !FILE(FileXsl)
	 fXslPdf00(FileXsl)
      ENDIF
      SET DEVICE TO SCREEN
      RETURN NIL
*>>>>XSL FIN CONVERSION A PDF

/*************************************************************************
* TITULO..: ARCHIVO XSL No.00 PARA LOS INFORMES EN HTML                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 30/2007 VIE A
       Colombia, Bucaramanga        INICIO: 04:00 PM   NOV 30/2007 VIE

OBJETIVOS:

1- Crea el archivo XSL No.00 para la transformacion de los informes
   a xHtml.

2- El encabezado del archivo en formato NO iso.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION fXslHtm00(FileXsl)

*>>>>DESCRIPCION DE PARAMETROS
/*     LOCAL FileXsl := ''                  // Archivo Xsl */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cCodXsl := ''                  // C¢digo Xsl de los informes

       LOCAL       k := 0                   // Contador
       LOCAL cTxtPrn := ''                  // Texto a imprimir
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL ARCHIVO
       IF FILE(FileXsl)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL ARCHIVO

*>>>>CREACION DEL ARCHIVO
       SET DEVICE TO PRINT
       SET PRINTER TO &FileXsl
*>>>>FIN CREACION DEL ARCHIVO

*>>>>CREACION DEL ARCHIVO
Prn("<?xml version='1.0' encoding='iso-8859-1'?>")
Prn("<xsl:transform")
Prn("  xmlns:xsl='http://www.w3.org/1999/XSL/Transform'")
Prn("  version='1.0'")
Prn("  xmlns='http://www.w3.org./TR/REC-html40'")
Prn(">")

Prn("<xsl:template match='registros'>",2)
Prn("<html>")
Prn("   <title>SIMA.Informe:<xsl:value-of select='@codiinf'/></title>")
Prn("   <style type='text/css'>")
Prn("	  body {background-image: url(<xsl:value-of select='@pathweb'/>\IMG\fondoprn.jpg);}")
Prn("   </style>")
Prn(" ")
Prn("<body>")

Prn("<table border='0' cellpadding='0' cellspacing='0'>")
Prn("  <tr><td width='138'><font size='1'></font>")
Prn("      </td>")
Prn(" ")
Prn("      <td width='800' align='center'><font size='5'>")
Prn("        <xsl:value-of select='@empresa'/></font>")
Prn("      </td>")
Prn(" ")
Prn("      <td width='200' align='right'><font size='1'>")
Prn("        <xsl:value-of select='@codiiso'/><font size='1'>&#xa0;</font>")
Prn("        <xsl:value-of select='@fechiso'/><font size='1'>&#xa0;</font>")
Prn("        <xsl:value-of select='@versiso'/></font>")
Prn("      </td>")
Prn(" ")
Prn("  </tr>")
Prn("</table>")
Prn(" ")
Prn("<table border='0' cellpadding='0' cellspacing='0'>")
Prn("  <tr><td width='750' align='center'><font size='3'><em>")
Prn("         <xsl:value-of select='@sistema'/></em></font>")
Prn("      </td>")
Prn("  </tr>")
Prn("</table>")
Prn(" ")
Prn("<table border='0' cellpadding='0' cellspacing='0'>")
Prn("  <tr><td width='750' align='center'><font size='3'><strong>")
Prn("	    <xsl:value-of select='@titulo1'/></strong></font>")
Prn("      </td>")
Prn("  </tr>")
Prn("</table>")
Prn(" ")
Prn("<font size='1'>&#xa0;</font>")
Prn(" ")
Prn("<table border='0' cellpadding='0' cellspacing='0'>")
Prn("  <tr><td width='150'><font size='1'>")
Prn("         <xsl:value-of select='@fechprn'/></font>")
Prn("      </td>")
Prn(" ")
Prn("      <td width='900' align='center'><font size='3'>")
Prn("        <xsl:value-of select='@titulo2'/></font>")
Prn("      </td>")
Prn(" ")
Prn("      <td width='150' align='right'><font size='1'>")
Prn("        HORA:<xsl:value-of select='@horaprn'/></font>")
Prn("      </td>")
Prn(" ")
Prn("  </tr>")
Prn("</table>")
Prn(" ")
Prn("<table border='0' cellpadding='0' cellspacing='0'>")
Prn("  <tr><td width='138'><font size='1'>")
Prn("        <xsl:value-of select='@fdiaprn'/></font>")
Prn("      </td>")
Prn(" ")
Prn("      <td width='800' align='center'><font size='3'>")
Prn("        <xsl:value-of select='@titulo3'/></font>")
Prn("      </td>")
Prn("")
Prn("      <td width='150' align='right'></td>")
Prn("  </tr>")
Prn("</table>")

Prn("<table border='1'>",2)
Prn("  <xsl:for-each select='cabecera'>")
Prn("  <tr>")
Prn("    <xsl:for-each select='columna'>")
Prn("      <th><strong>")
Prn(" ")
Prn("        <font size='1' ><xsl:value-of select='.'/></font>")
/*
Prn('      <xsl:if test="@size = '+"'1'"+'">')
Prn("        <font size='1' ><xsl:value-of select='.'/></font>")
Prn("      </xsl:if>")
Prn(" ")
Prn('      <xsl:if test="@size = '+"'2'"+'">')
Prn("        <font size='2'><xsl:value-of select='.'/></font>")
Prn("      </xsl:if>")
*/
Prn(" ")
Prn("      </strong></th>")
Prn("    </xsl:for-each><!-- campo -->")
Prn("  </tr>")
Prn("  </xsl:for-each><!-- cabecera -->")

Prn("  <xsl:for-each select='registro'>",2)
Prn("  <tr>")
Prn("    <xsl:for-each select='campo'>")
Prn("      <td>")
Prn("	<xsl:if test=" + '"@url != ' + "'no'" + + '">')
Prn(" ")
Prn("       <font size='1'>")
Prn("         <a href='{@url}' target='_blank'><xsl:value-of select='.'/></a>")
Prn("       </font>")
/*
Prn('      <xsl:if test="@size = '+"'1'"+'">')
Prn("       <font size='1'>")
Prn("         <a href='{@url}' target='_blank'><xsl:value-of select='.'/></a>")
Prn("       </font>")
Prn("     </xsl:if>")
Prn(" ")
Prn('      <xsl:if test="@size = '+"'2'"+'">')
Prn("       <font size='2'>")
Prn("         <a href='{@url}' target='_blank'><xsl:value-of select='.'/></a>")
Prn("       </font>")
Prn("     </xsl:if>")
*/
Prn(" ")
Prn("	</xsl:if>")
Prn("	<xsl:if test=" + '"@url = ' + "'no'" + + '">')
Prn(" ")
Prn("        <font size='1'> ")
Prn("          <xsl:value-of select='.'/> ")
Prn("        </font> ")
/*
Prn('      <xsl:if test="@size = '+"'1'"+'">')
Prn("        <font size='1'> ")
Prn("          <xsl:value-of select='.'/> ")
Prn("        </font> ")
Prn("      </xsl:if> ")
Prn("  ")
Prn('      <xsl:if test="@size = '+"'2'"+'">')
Prn("        <font size='2'> ")
Prn("          <xsl:value-of select='.'/> ")
Prn("        </font> ")
Prn("      </xsl:if> ")
*/
Prn("  ")
Prn("	</xsl:if>")
Prn("      </td>")
Prn("    </xsl:for-each><!-- campo -->")
Prn("  </tr>")
Prn("  </xsl:for-each><!-- registro -->")

Prn("</table>",2)
Prn("</body>")
Prn("</html>")
Prn("</xsl:template>")
Prn("</xsl:transform>")

      SET DEVICE TO SCREEN
      RETURN NIL
*>>>>FIN CREACION DEL ARCHIVO

/*************************************************************************
* TITULO..: ARCHIVO XSL No. 01 PARA LOS INFORMES EN HTML                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 30/2007 VIE A
       Colombia, Bucaramanga        INICIO: 04:00 PM   NOV 30/2007 VIE

OBJETIVOS:

1- Crea el archivo XSL No.00 para la transformacion de los informes
   a xHtml.

2- El encabezado del archivo en formato SI iso.

3- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION fXslHtm01(FileXsl)

*>>>>DESCRIPCION DE PARAMETROS
/*     LOCAL FileXsl := ''                  // Archivo Xsl */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>VALIDACION DEL ARCHIVO
       IF FILE(FileXsl)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL ARCHIVO

*>>>>CREACION DEL ARCHIVO
       SET DEVICE TO PRINT
       SET PRINTER TO &FileXsl
*>>>>FIN CREACION DEL ARCHIVO

*>>>>CREACION DEL ARCHIVO
Prn("<?xml version='1.0' encoding='iso-8859-1'?>")
Prn("<xsl:transform")
Prn("  xmlns:xsl='http://www.w3.org/1999/XSL/Transform'")
Prn("  version='1.0'")
Prn("  xmlns='http://www.w3.org./TR/REC-html40'")
Prn(">")

Prn("<xsl:template match='registros'>",2)
Prn("<html>")
Prn("   <title>SIMA.Informe:<xsl:value-of select='@codiinf'/></title>")
Prn("   <style type='text/css'>")
Prn("	  body {background-image: url(<xsl:value-of select='@pathweb'/>\IMG\fondoprn.jpg);}")
Prn("   </style>")
Prn(" ")
Prn("<body>")
Prn(" ")
Prn("<font size='1'>FECHA DE IMPRESION:")
Prn("  <xsl:value-of select='@fechprn'/><font size='1'>&#xa0;</font>")
Prn("  <xsl:value-of select='@fdiaprn'/>")
Prn("  HORA:<xsl:value-of select='@horaprn'/>")
Prn("</font>")
Prn(" ")
Prn("<table border='1' cellpadding='0' cellspacing='0'>")
Prn("  <tr><td width='138'>")
Prn("	     <img align='top' width='128' height='79'>")
Prn("	       <xsl:attribute name='src'>")
Prn("          <xsl:value-of select='@pathweb'/>\IMG\logoprn.jpg")
Prn("	       </xsl:attribute>")
Prn("	     </img>")
Prn("      </td>")
Prn(" ")
Prn("      <td width='800' align='center'><font size='3'>")
Prn("        <xsl:value-of select='@titulo1'/>")
Prn("        <br><xsl:value-of select='@titulo2'/></br>")
Prn("        <br><xsl:value-of select='@titulo3'/></br>")
Prn("        </font>")
Prn("      </td>")
Prn(" ")
Prn("      <td width='200'>")
Prn("         <table border='1' cellpadding='0' cellspacing='0'>")
Prn("	        <tr><td width='200'><font size='1'>C&#xF3;digo del Documento:")
Prn("		      <br><xsl:value-of select='@codiiso'/></br></font>")
Prn("	            </td>")
Prn("	        </tr>")
Prn("	        <tr><td width='200'><font size='1'>Versi&#xF3;n:")
Prn("                 <xsl:value-of select='@versiso'/></font>")
Prn("               </td>")
Prn("           </tr>")
Prn("	        <tr><td width='200'><font size='1'>Fecha de aprobaci&#xF3;n:")
Prn("		      <br><xsl:value-of select='@fechiso'/></br></font>")
Prn("	            </td>")
Prn("	        </tr>")
Prn("	      </table>")
Prn("      </td>")
Prn(" ")
Prn("  </tr>")
Prn("</table>")
Prn(" ")
Prn("<table border='1'>",2)
Prn("  <xsl:for-each select='cabecera'>")
Prn("  <tr>")
Prn("    <xsl:for-each select='columna'>")
Prn("      <th><strong>")
Prn(" ")
Prn("        <font size='1' ><xsl:value-of select='.'/></font>")
/*
Prn('      <xsl:if test="@size = '+"'1'"+'">')
Prn("        <font size='1' ><xsl:value-of select='.'/></font>")
Prn("      </xsl:if>")
Prn(" ")
Prn('      <xsl:if test="@size = '+"'2'"+'">')
Prn("        <font size='2'><xsl:value-of select='.'/></font>")
Prn("      </xsl:if>")
*/
Prn(" ")
Prn("      </strong></th>")
Prn("    </xsl:for-each><!-- campo -->")
Prn("  </tr>")
Prn("  </xsl:for-each><!-- cabecera -->")

Prn("  <xsl:for-each select='registro'>",2)
Prn("  <tr>")
Prn("    <xsl:for-each select='campo'>")
Prn("      <td>")
Prn("	<xsl:if test=" + '"@url != ' + "'no'" + + '">')
Prn("       <font size='1'>")
Prn("         <a href='{@url}' target='_blank'><xsl:value-of select='.'/></a>")
Prn("       </font>")
/*
Prn(" ")
Prn('      <xsl:if test="@size = '+"'1'"+'">')
Prn("       <font size='1'>")
Prn("         <a href='{@url}' target='_blank'><xsl:value-of select='.'/></a>")
Prn("       </font>")
Prn("     </xsl:if>")
Prn(" ")
Prn('      <xsl:if test="@size = '+"'2'"+'">')
Prn("       <font size='2'>")
Prn("         <a href='{@url}' target='_blank'><xsl:value-of select='.'/></a>")
Prn("       </font>")
Prn("     </xsl:if>")
*/
Prn(" ")
Prn("	</xsl:if>")
Prn("	<xsl:if test=" + '"@url = ' + "'no'" + + '">')
Prn(" ")
Prn("        <font size='1'> ")
Prn("          <xsl:value-of select='.'/> ")
Prn("        </font> ")
/*
Prn('      <xsl:if test="@size = '+"'1'"+'">')
Prn("        <font size='1'> ")
Prn("          <xsl:value-of select='.'/> ")
Prn("        </font> ")
Prn("      </xsl:if> ")
Prn("  ")
Prn('      <xsl:if test="@size = '+"'2'"+'">')
Prn("        <font size='2'> ")
Prn("          <xsl:value-of select='.'/> ")
Prn("        </font> ")
Prn("      </xsl:if> ")
*/
Prn("  ")
Prn("	</xsl:if>")
Prn("      </td>")
Prn("    </xsl:for-each><!-- campo -->")
Prn("  </tr>")
Prn("  </xsl:for-each><!-- registro -->")

Prn("</table>",2)
Prn("</body>")
Prn("</html>")
Prn("</xsl:template>")
Prn("</xsl:transform>")

       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN CREACION DEL ARCHIVO

/*************************************************************************
* TITULO..: ARCHIVO XSL No. 00 PARA LOS INFORMES EN PDF                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 30/2007 VIE A
       Colombia, Bucaramanga        INICIO: 04:00 PM   NOV 30/2007 VIE

OBJETIVOS:

1- Crea el archivo XSL No.00 para la transformacion de los informes
   a Pdf.

2- El encabezado del archivo en formato SI iso.

3- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION fXslPdf00(FileXsl)

*>>>>DESCRIPCION DE PARAMETROS
/*     LOCAL FileXsl := ''                  // Archivo Xsl */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>VALIDACION DEL ARCHIVO
       IF FILE(FileXsl)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL ARCHIVO

*>>>>CREACION DEL ARCHIVO
       SET DEVICE TO PRINT
       SET PRINTER TO &FileXsl
*>>>>FIN CREACION DEL ARCHIVO

*>>>>CREACION DEL ARCHIVO
Prn("<?xml version='1.0' encoding='iso-8859-1'?>")
Prn("<xsl:stylesheet version='1.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform' xmlns:fo='http://www.w3.org/1999/XSL/Format'>")
Prn("  <xsl:output encoding='ISO-8859-1' indent='yes'/>")
Prn(" ")
Prn("<xsl:template match='registros'>")
Prn(" ")
Prn("<fo:root xmlns:fo='http://www.w3.org/1999/XSL/Format'>")
Prn(" ")
Prn("  <fo:layout-master-set>")
Prn("    <fo:simple-page-master master-name='first'")
Prn("	                        margin-right = '1.5cm'")
Prn("	                        margin-left  = '1.5cm'")
Prn("	                        margin-bottom= '2cm'")
Prn("	                        margin-top   = '1cm'")
Prn("	                        page-width   = '21cm'")
Prn("	                        page-height  = '29.7cm'>")
Prn("       <fo:region-body margin-top = '1cm'/>")
Prn("       <fo:region-before extent   = '1cm'/>")
Prn("       <fo:region-after extent    = '1.5cm'/>")
Prn("    </fo:simple-page-master>")
Prn("  </fo:layout-master-set>")
Prn(" ")
Prn("  <fo:page-sequence master-reference='first'>")
Prn(" ")
Prn("    <fo:static-content flow-name='xsl-region-before'>")
Prn("      <fo:block line-height='14pt'")
Prn("		     font-size  ='10pt'")
Prn("		     text-align ='end'>")
Prn("          <xsl:value-of select='@titulo1'/>")
Prn("      </fo:block>")
Prn("    </fo:static-content>")
Prn(" ")
Prn("    <fo:static-content flow-name='xsl-region-after'>")
Prn("      <fo:block line-height='14pt'")
Prn("		     font-size  ='10pt'")
Prn("		     text-align ='end'>")
Prn("         Página <fo:page-number/>")
Prn("      </fo:block>")
Prn("    </fo:static-content>")
Prn(" ")
Prn("    <fo:flow flow-name='xsl-region-body'>")
Prn(" ")
Prn("    <fo:table border-style='solid' border-width='0.5pt'>")
Prn(" ")
Prn("       <xsl:for-each select='cabecera'>")
Prn("	      <xsl:for-each select='columna'>")
Prn("	        <fo:table-column/>")
Prn("	      </xsl:for-each><!-- campo -->")
Prn("       </xsl:for-each><!-- cabecera -->")
Prn(" ")
Prn("       <fo:table-header>")
Prn(" ")
Prn("       <fo:table-row>")
Prn(" ")
Prn("	      <xsl:for-each select='cabecera'>")
Prn("	        <xsl:for-each select='columna'>")
Prn(" ")
Prn("	          <fo:table-cell border-style='solid' border-width='0.5pt'>")
Prn("		     <fo:block font-weight='bold'")
Prn("		               text-align='center'")
Prn("		               vertical-align='middle'")
Prn("		               border-width='1pt'")
Prn("		               border-color='black'>")
Prn("	                <xsl:value-of select='.'/>")
Prn("	             </fo:block>")
Prn("	          </fo:table-cell>")
Prn(" ")
Prn("           </xsl:for-each><!-- campo -->")
Prn("         </xsl:for-each><!-- cabecera -->")
Prn(" ")
Prn("      </fo:table-row>")
Prn("      </fo:table-header>")
Prn(" ")
Prn("      <fo:table-body>")
Prn(" ")
Prn("        <xsl:for-each select='registro'>")
Prn("	       <fo:table-row>")
Prn("	         <xsl:for-each select='campo'>")
Prn("	           <fo:table-cell border-style='solid' border-width='0.5pt'>")
Prn("	             <fo:block text-align='center'>")
Prn("                 <xsl:value-of select='.'/>")
Prn("	             </fo:block>")
Prn("              </fo:table-cell>")
Prn("            </xsl:for-each><!-- campo -->")
Prn("	       </fo:table-row>")
Prn("	     </xsl:for-each><!-- registro -->")
Prn(" ")
Prn("      </fo:table-body>")
Prn(" ")
Prn("    </fo:table>")
Prn(" ")
Prn("    </fo:flow>")
Prn("  </fo:page-sequence>")
Prn("</fo:root>")
Prn("</xsl:template>")
Prn("</xsl:stylesheet>")

       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN CREACION DEL ARCHIVO

/*************************************************************************
* TITULO..: ARCHIVO BUILD PARA GENERAR LOS PDF                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 30/2008 VIE A
       Colombia, Bucaramanga        INICIO: 03:00 PM   ENE 30/2008 VIE

OBJETIVOS:

1- Crea el archivo build.xml con las tareas en Ant para generar los
   archivos xml a pdf
   a Pdf.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION fBuild00(FileXml)

*>>>>DESCRIPCION DE PARAMETROS
/*     LOCAL FileXml := ''                  // Archivo Xml */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>VALIDACION DEL ARCHIVO
       IF FILE(FileXml)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL ARCHIVO

*>>>>CREACION DEL ARCHIVO
       SET DEVICE TO PRINT
       SET PRINTER TO &FileXml
*>>>>FIN CREACION DEL ARCHIVO

*>>>>CREACION DEL ARCHIVO
Prn("<?xml version='1.0'?>",0)
Prn("")
Prn("<project default='pdf' basedir='.'>")
Prn("")
Prn("  <target name='init'>")
Prn("")
Prn("    <tstamp/>")
Prn("    <property file='${basedir}/build.pro' />")
Prn("    <property name='outfo'  value='fo'/>")
Prn("    <property name='outpdf' value='pdf'/>")
Prn("")
Prn("    <mkdir dir='${outfo}'/>")
Prn("    <mkdir dir='${outpdf}'/>")
Prn("")
Prn("    <path id='run-classpath'>")
Prn("      <fileset dir='${dir.fop}/lib'>")
Prn("	     <include name='*.jar'/>")
Prn("      </fileset>")
Prn("      <pathelement location='${dir.fop}/lib/fop.jar'/>")
Prn("    </path>")
Prn("")
Prn("    <path id='file-xml'>")
Prn("      <fileset dir='.'>")
Prn("	     <include name='*.xml'/>")
Prn("      </fileset>")
Prn("    </path>")
Prn("")
Prn("    <taskdef name='fop'")
Prn("	     classname='org.apache.fop.tools.anttasks.Fop'")
Prn("	     classpathref='run-classpath'/>")
Prn("  </target>")
Prn("")
Prn("  <target name='fo' depends='init'>")
Prn("    <echo message='Generando los pdf' />")
Prn("")
Prn("    <xslt style='${dir.infpdf}/infpdf00.www' destdir='${outfo}' basedir='xml' extension='.fo'>")
Prn("      <outputproperty name='method' value='xml'/>")
Prn("      <outputproperty name='standalone' value='yes'/>")
Prn("      <outputproperty name='encoding' value='ISO-8859-1'/>")
Prn("      <outputproperty name='indent' value='yes'/>")
Prn("    </xslt>")
Prn("  </target>")
Prn("")
Prn("  <target name='fo1' depends='init'>")
Prn("    <echo message='Generando los pdf' />")
Prn("")
Prn("    <xslt basedir='xml' destdir='${outfo}'")
Prn("	   includes='*.xml'")
Prn("	   extension='.fo'")
Prn("	   style='${dir.infpdf}/infpdf00.www'>")
Prn("    </xslt>")
Prn("")
Prn("  </target>")
Prn("")
Prn("  <target name='pdf' depends='fo' description='Generando los pdfs'>")
Prn("")
Prn("    <fop format='application/pdf' outdir='${outpdf}' messagelevel='warn' relativebase='true'>")
Prn("      <fileset dir='${outfo}'>")
Prn("	     <include name='**/*.fo'/>")
Prn("      </fileset>")
Prn("    </fop>")
Prn("  </target>")
Prn("")
Prn("</project>")

       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN CREACION DEL ARCHIVO

/*************************************************************************
* TITULO..: ARCHIVO BUILD PROPERTIES PARA GENERAR LOS PDF                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 30/2008 VIE A
       Colombia, Bucaramanga        INICIO: 03:30 PM   ENE 30/2008 VIE

OBJETIVOS:

1- Crea el archivo build.properties con los parametros para el archivo
   build con las tareas en Ant para generar los archivos xml a pdf
   a Pdf.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION fBuild00pr(FileXml)

*>>>>DESCRIPCION DE PARAMETROS
/*     LOCAL FileXml := ''                  // Archivo Xml */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>VALIDACION DEL ARCHIVO
       IF FILE(FileXml)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL ARCHIVO

*>>>>CREACION DEL ARCHIVO
       SET DEVICE TO PRINT
       SET PRINTER TO &FileXml
*>>>>FIN CREACION DEL ARCHIVO

*>>>>CREACION DEL ARCHIVO
Prn("dir.fop=C:/javajdk/fop")
Prn("dir.infpdf=/sima/simaweb/rec")

       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN CREACION DEL ARCHIVO

/*************************************************************************
* TITULO..: IMPRESION DE INFORME                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 19/2008 MAY A
       Colombia, Bucaramanga        INICIO: 09:00 AM   ENE 19/2008 MAY

OBJETIVOS:

1- Permite imprimir un informe estandar de acuerdo a los registros a
   imprimir pasados como parametro.

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION InfPrn00(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
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
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
     *ÀVariables generales

       LOCAL i,j,k,x := 0                   // Contadores
       LOCAL cUsrIso := ''                  // Usuario de la Iso
       LOCAL nNroInf := 0                   // N£mero del informe
       LOCAL cOpcSys := ''                  // Opci¢n del Sistema
       LOCAL cCodInf := ''                  // C¢digo del Informe
       LOCAL aMarInf := {}                  // L¡neas de Espaciado
       LOCAL nNroDoc := 0                   // N£mero del Documento variable
       LOCAL fDocPrn := ''                  // Archivo a imprimir
       LOCAL cCodIso := ''                  // C¢digo Iso del Informe
       LOCAL cFecIso := ''                  // Fecha del Iso
       LOCAL cVerIso := ''                  // Versi¢n del Iso
       LOCAL aTitIso := ''                  // T¡tulo Iso del Informe
       LOCAL cPiePag := ''                  // Pie de P gina por defecto
       LOCAL aPieIso := {}		    // Textos del pie de p gina
       LOCAL nTotPie := 0                   // Total de Pie de p ginas
       LOCAL aObsIso := {}                  // Observaciones del informe
       LOCAL aMezIso := {}                  // Campos a Mesclar
       LOCAL bInsIso := NIL                 // Block de Gestion Documental
     *ÀGestion Documental

       LOCAL cOpcPrn := ''                  // Opciones de Impresi¢n
       LOCAL FilePrn := ''                  // Archivo de impresion
       LOCAL nRegPrn := 0                   // Registro de Impresi¢n
       LOCAL cFecPrn := ''                  // @Fecha de Impresi¢n
       LOCAL cHorPrn := ''                  // @Hora de Impresi¢n
       LOCAL cDiaPrn := ''                  // @D¡a de Impresi¢n
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabPrn := {}                  // Encabezado del informe General
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitPrn := {}                  // T¡tulos para impresi¢n
       LOCAL aRegPrn := {}                  // Registros para impresi¢n
       LOCAL cCabCol := ''                  // Encabezado de Columna
       LOCAL aCabSec := {}                  // Encabezado Secundario
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL lCentra := .F.                 // .T. Centrar el informe
       LOCAL nColCab := 0                   // Columna del encabezado
       LOCAL bPagina := NIL                 // Block de P gina
       LOCAL bCabeza := NIL                 // Block de Encabezado
       LOCAL bDerAut := NIL                 // Block Derechos de Autor
       LOCAL nLinReg := 1                   // L¡neas del registro
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL aPrnWww := {}		    // Detalles informes para www
       LOCAL lSiorNo := .F.                 // Control de Flujo
       STATI nHanXml := 0                   // Manejador del Archivo
       STATI lHanXml := .F.                 // Manejador del Archivo
     *ÀVariables de informe

       LOCAL aTotReg := {}                  // Registros a Imprimir
       LOCAL oBrowse := {}                  // Browse del Archivo
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE LA IMPRESION
       aTotReg := xPrm(aP3,'aTotReg')

       IF LEN(aTotReg) == 0
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE LA IMPRESION

*>>>>ACTIVACION DE LA IMPRESORA
       nOpcPrn := xPrm(aP3,'nOpcPrn')
       FilePrn := xPrm(aP3,'FilePrn')
       cCodInf := xPrm(aP3,'cCodInf')

       IF nOpcPrn == 0
	  cOpcPrn := xPrm(aP3,'cOpcPrn')
	  IF nNroInf == 0
	     FilePrn := cCodInf
	     nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,cOpcPrn,.T.,.T.)
	  ELSE
	     FilePrn := cCodInf
	     nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,cOpcPrn,.T.,2,bInsIso)
	  ENDIF
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>GESTION DOCUMENTAL DEL INFORME
       nLenPrn := PCL('n17Stan')
     *ÀLogitud de impresi¢n.

       nNroInf := xPrm(aP3,'nNroInf')
     *ÀN£mero de identificaci¢n del informe

       cOpcSys := xPrm(aP3,'cOpcSys')
     *ÀOpci¢n del sistema del informe

       cCodInf := xPrm(aP3,'cCodInf')
       aMarInf := xPrm(aP3,'aMarInf')
       nNroDoc := xPrm(aP3,'nNroDoc')
     *ÀInforme por defecto

       aMezIso := xPrm(aP3,'aMezIso')
     *ÀCampos a sustituir

       aTitIso := xPrm(aP3,'aTitIso')
     *ÀT¡tulos del Informe por defecto

       cPiePag := xPrm(aP3,'cPiePag')
       IF !EMPTY(cPiePag)
	  cPiePag := SPACE((nLenPrn-LEN(cPiePag))/2)+cPiePag
       ENDIF
     *ÀPie de p gina.

	  aPieIso := xPrm(aP3,'aPieIso')
       aPieIso[3] := IF(EMPTY(aPieIso[3]),cPiePag,aPieIso[3])
     *ÀPie de p ginas por defecto

       aObsIso := xPrm(aP3,'aObsIso')
     *ÀObservaciones

       cUsrIso := xPrm(aP3,'cUsrIso')
       oBrowse := xPrm(aP3,'oBrowse')
       bInsIso := {||lModRegIso(lShared,cNomUsr,oBrowse,;
				nNroInf,aTitIso[1],cOpcSys,;
				cUsrIso,;
				cCodInf,aMarInf,nNroDoc,aObsIso)}
     *ÀInclusi¢n o modificaci¢n de la gesti¢n docuemental
*>>>>FIN GESTION DOCUMENTAL DEL INFORME

*>>>>CONTROL DE DOCUMENTOS
       IF nNroInf # 0
	  cCodIso := ALLTRIM(ISO->cCodigoIso)
	  cFecIso := ALLTRIM(ISO->cFecAprIso)
	  cVerIso := ALLTRIM(ISO->cNroVerIso)
       ENDIF
*>>>>FIN CONTROL DE DOCUMENTOS

*>>>>SUSTITUCION DE TEXTO
       fDocPrn := ''
       IF !lValDetIso(nNroInf,@cCodIso,@aTitIso,@aPieIso,;
		      @cCodInf,@aMarInf,@nNroDoc,@aObsIso,;
		      @fDocPrn)
	  RETURN NIL
       ENDIF
       ReplTitIso(@aTitIso,aMezIso)
*>>>>FIN SUSTITUCION DE TEXTO

*>>>>DEFINICION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0

       aCabPrn := {cNomEmp,cNomSis,;
		   aTitIso[1],;
		   aTitIso[2],;
		   aTitIso[3]}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
                   nNroPag++,;
                   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINICION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := xPrm(aP3,'aNroCol')
       aTitPrn := xPrm(aP3,'aTitPrn')

       cCabCol := cRegPrint(aTitPrn,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       lCentra := .F.
       nColCab := 0
       IF lCentra
          nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := xPrm(aP3,'aCabSec')
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
                               nColCab,cCodFin,aCabSec,;
			       @cFecPrn,@cHorPrn,@cDiaPrn,;
			       cCodIso,cFecIso,cVerIso)}
       bDerAut := {||PiePagPrn(aPieIso,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>IMPRESION DEL ENCABEZADO
       SET DEVICE TO PRINT
       SendCodes(PCL('Reset'))

       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)

       EVAL(bCabeza)
      *Impresi¢n del Encabezado

       aPrnWww := {}
       AADD(aPrnWww,{'nCodXsl',xPrm(aP3,'nCodXsl')})
       AADD(aPrnWww,{'cCodInf',cCodInf})
       AADD(aPrnWww,{'cCodIso',cCodIso})
       AADD(aPrnWww,{'cFecIso',cFecIso})
       AADD(aPrnWww,{'cVerIso',cVerIso})
       AADD(aPrnWww,{'cPieUno',aPieIso[1]})
       AADD(aPrnWww,{'cPieDos',aPieIso[2]})
       AADD(aPrnWww,{'cPieTre',aPieIso[2]})

       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,;
			     nOpcPrn,aCabPrn,aTitPrn,aPrnWww)

       SET DEVICE TO SCREEN
*>>>>FIN IMPRESION DEL ENCABEZADO

*>>>>RECORRIDO DE LOS REGISTROS
       cSavPan := SAVESCREEN(0,0,24,79)

       FOR i := 1 TO LEN(aTotReg)

**********IMPRESION DEL REGISTRO
	    aRegPrn := {}
	    FOR j := 1 TO LEN(aTotReg[i])
		AADD(aRegPrn,aTotReg[i,j])
	    ENDFOR

	    SET DEVICE TO PRINT
	    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
	    SET DEVICE TO SCREEN
**********FIN IMPRESION DEL REGISTRO

       ENDFOR
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN RECORRIDO DE LOS REGISTROS

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       VerPrn(nOpcPrn,FilePrn,nHanXml)
       PRN->(DBGOTO(nRegPrn))

       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: VALIDACION DE LOS REGISTROS DE INCONSISTENCIAS               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 19/2008 LUN A
       Bucaramanga, Colombia        INICIO: 03:00 PM   MAY 19/2008 LUN

OBJETIVOS:

1- Permite validar la duplicaci¢n de los registros de inconsistencias.

2- Para la validaci¢n en el vector aCamVal se define el n£mero de las
   columnas que se desean validar.

3- Todas las columnas definidas se validan para evitar registros
   duplicados de la misma inconsistencia.

4- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ValRegArr(aTotReg,aRegPrn,aCamVal)

*>>>>DESCRIPCION DE PARAMETROS
/*     aTotReg                              // Total de Registros
       aRegPrn                              // Registro a Imprimir
       aCamVal                              // Campos a Valirdar */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL i,j,k,y := 0                   // Contadores

       LOCAL nTotReg := 0                   // Total Registros
       LOCAL aRegTem := {}                  // Registro Temporal
       LOCAL nTotVal := 0                   // Total validaciones
       LOCAL lInsReg := .F.                 // Insertar el registro
       LOCAL cCampo1 := ''                  // Campo No.1
       LOCAL cCampo2 := ''                  // Campo No.2
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE LOS REGISTROS
       lInsReg := .T.
       FOR i := 1 TO LEN(aTotReg)

	   aRegTem := aTotReg[i]

***********VALIDACION DE LOS CAMPOS
	     FOR j := 1 TO LEN(aRegPrn)

		 nTotVal := 0

*================CAMPOS VALIDADOS
		   FOR k := 1 TO LEN(aCamVal)

			     y := aCamVal[k]
		       cCampo1 := aRegTem[y]
		       cCampo2 := aRegPrn[y]

		       IF cCampo1 == cCampo2
			  nTotVal++
		       ENDIF

		   ENDFOR
*================FIN CAMPOS VALIDADOS

*================ANALISIS DE DECISION
		   IF nTotVal == LEN(aCamVal)
		      lInsReg := .F.
		   ENDIF
*================FIN ANALISIS DE DECISION

	     ENDFOR
***********FIN VALIDACION DE LOS CAMPOS

       ENDFOR
       IF lInsReg
	  AADD(aTotReg,aRegPrn)
       ENDIF
       RETURN NIL
*>>>>FIN VALIDACION DE LOS REGISTROS