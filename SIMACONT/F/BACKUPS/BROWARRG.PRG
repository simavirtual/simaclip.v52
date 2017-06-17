/*************************************************************************
* TITULO DE LA FUNCION..: SELECCION DEL MES DE ACUERDO A UN ARREGLO      *
**************************************************************************

OBJETIVOS:                          FECHA DE CREACION: JUL 11/94 LUN A
						       JUL 11/94 LUN
1- Permite escoger un mes de acuerdo a un Browse de un arreglo con los
   meses del a¤o.

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Retorna el n£mero del mes escogido en tipo caracter

SINTAXIS:

  cNroMes := ''
  lSelMes(nFilInf,nColInf,@cNroMes)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lSelMes(nNroFil,nNroCol,cNroMes)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de Impresi¢n
       nNroCol                              // Columna de Impresi¢n
       cNroMes                              // @N£mero del Mes */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL oBrwArr := NIL                 // Browse de Arreglos
       LOCAL oColumn := NIL                 // Columna del Objetos
       LOCAL aVector := NIL                 // Arreglo para el Browse
       LOCAL nIndice := 1                   // N£mero del indice
       LOCAL nLenEle := 0                   // Elementos del Arreglo

       LOCAL nFilSup := 0                   // Fila Superior
       LOCAL nColSup := 0                   // Columna Superior
       LOCAL nFilInf := 0                   // Fila Inferior
       LOCAL nColInf := 0                   // Columna Inferior
*>>>>FIN DECLARACION DE VARIABLES

*>>>>INICIALIZACION DEL VECTOR
       aVector := {'ENE','FEB','MAR','ABR','MAY','JUN',;
			 'JUL','AGO','SEP','OCT','NOV','DIC'}
       nLenEle := LEN(aVector)
*>>>>FIN INICIALIZACION DEL VECTOR

*>>>>INICIALIZACION DE LAS COORDENADAS
       nFilSup := nNroFil
       nColSup := nNroCol
       nFilInf := nFilSup+nLenEle+2
       IF nFilInf > 22
	  nFilInf := 22
       ENDIF
       nColInf := nFilSup+4
*>>>>FIN INICIALIZACION DE LAS COORDENADAS

*>>>>DEFINICION DEL OBJETO BROWSE
       @ nFilSup,nColSup TO nFilInf,nColInf DOUBLE
       oBrwArr := TBrowseNew(nFilSup,nColSup,nFilInf,nColInf)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrwArr:skipBlock     := {|n|nSkipArray(n,@nIndice,nLenEle,oBrwArr)}
       oBrwArr:GoTopBlock    := {||nIndice:= 1}
       oBrwArr:GoBottomBlock := {||nIndice:= nLenEle}
     *ÀEspecificaciones del Objeto

       oColumn         := TBColumnNew()
       oColumn:Heading := 'MES'
       oColumn:Block   := {||aVector[nIndice]}
       oBrwArr:addColumn(oColumn)
     *ÀDefinici¢n Columna No. 1
*>>>>FIN DEFINICION DEL OBJETO BROWSE

*>>>>BROWSE DEL ARREGLO
      BrwArray(oBrwArr, aVector, @nIndice)
      cNroMes := STR(nIndice,2)
      RETURN .T.
*>>>>FIN BROWSE DEL ARREGLO