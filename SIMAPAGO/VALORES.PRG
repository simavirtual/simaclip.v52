/*************************************************************************
* TITULO..: CONVERSION DE NUMERO A LETRAS                                *
**************************************************************************

AUTOR: Abraxas                      FECHA DE CREACION: AGO 20/2004 VIE A
       Colombia, Bucaramanga        INICIO: 11:30 AM   AGO 20/2004 VIE

OBJETIVOS:

1- Permite convertir un numero a letras

3- Retorna el texto en letras

SINTAXIS:

       cVlrTxt := ALLTRIM(UPPER(Letras(nVlrChe,'M')))+' PESOS MCTE. XXXXX'

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