Protect("Bancos")
UnProtect("Bancos")

FUNCTION ProtecDbf(cNomArc)

*>>>>DESCRIPCION DE PARAMETROS
/*     cNomArc			            // Archivo del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroArc := 0                   // N£mero de Archivo
       LOCAL n01byte := 0                   // Primer Byte
       LOCAL cBuffer := SPACE(01)           // Buffer de Lectura
       LOCAL fn := trim(cNomArc)
       #INCLUDE "FILEIO.CH"
*>>>>FIN DECLARACION DE VARIABLES

*>>>>APERTURA DEL ARCHIVO
       nNroArc := FOPEN(cNomArc,2)  // Lectura y Escritura
       IF nNroArc <= 0
	  cError('NO SE PUDO ABRIR EL ARCHIVO')
	  RETURN NIL
       ENDIF
*>>>>FIN APERTURA DEL ARCHIVO

*>>>>LECTURA DEL PRIMER BYTE
       FREAD(nNroArc,@cBuffer,1)      // Lee el primer Byte
       n01Byte := ASC(cBuffer)        // Convierte el Byte a N£mero
*>>>>FIN LECTURA DEL PRIMER BYTE

*>>>>PROTECION O DESPROTECION DEL ARCHIVO
   FSEEK(nNroArc,0,0) // Principio de Archivo
   IF n01Byte == 131 // if memo file field
      FWRITE(nNroArc,CHR(27),1)
   ELSE
      FWRITE(nNroArc,CHR(26),1) // 26
   ENDIF
   FCLOSE(nNroArc)
ENDIF
RETURN NIL

FUNCTION UnProtect(cNomArc)

#INCLUDE "FILEIO.CH"

LOCAL nNroArc,n01Byte,cBuffer := ' '
LOCAL fn := trim(cNomArc)

IF (nNroArc := FOPEN(fn+".DBF",FO_READWRITE)) > - 1
   FREAD(nNroArc,@cBuffer,1) // Lee el primer byte
   n01Byte := ASC(cBuffer)
   FSEEK(nNroArc,0,0) // Principio de Archivo
   IF n01Byte == 27 // if memo file field
      FWRITE(nNroArc,CHR(131),1)
   ELSE
      FWRITE(nNroArc,CHR(03),1) // 26
   ENDIF
   FCLOSE(nNroArc)
ENDIF
RETURN NIL