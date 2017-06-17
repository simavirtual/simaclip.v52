Puerto = "LPT1"
BitmapF = "PRUEBA.BMP"
Pixeles = {}

DecBMP(BitmapF, @Pixeles)
Set Prin to &Puerto
Set( _SET_PRINTER, .t.)
ImprimeBMP(BitmapF, Pixeles, 00, 00)
Ejec
Brea

********************************************************
Function ImprimeBMP(BitmapF, Pixeles, Filas_, Columnas_)
* Programado por Diego D'Onofrio * Email: near@lycos.com 
********************************************************
Pixeles = Iif(Pixeles == Nil, {}, Pixeles)
Filas_ = Iif(Filas_ == Nil, 0, Filas_)
Columnas_ = Iif(Columnas_ == Nil, 0, Columnas_)
P1_ = 0
P2_ = 0
P3_ = 300
P4_ = .F.
Salida = set(17, .F.)
P11_ = Len(Pixeles) - 1
P12_ = Len(Pixeles[1]) + Iif(P4_, 2, 0)
P6_ = Pixeles[P11_ + 1]
If (P3_ == 0 .AND. P1_ == 0 .AND. P2_ == 0)
  P3_ = Iif(P6_ == 1, 150, 300)
EndI
If (P3_ == 0)
  P3_ = AjustTam(P12_ * 8, P11_ + Iif(P4_, 16, 0), P1_, P2_)
EndI
P3_ = Iif(!(P3_ == 75) .AND. !(P3_ == 100) .AND. !(P3_ == ;
        150) .AND. !(P3_ == 300) .AND. !(P3_ == 600), 75, P3_)
PosiTemp = Filas_
PosiTemp = PosiTemp - 0.25
PosiTemp = Iif(PosiTemp < 0, 0, PosiTemp)
Filas_ = Int(PosiTemp * 300)
PosiTemp = Columnas_
PosiTemp = PosiTemp - 0.50
PosiTemp = Iif(PosiTemp < 0, 0, PosiTemp)
Columnas_ = Int(PosiTemp * 300)
P13_ = AllTrim(Tran(Filas_, "9999999999"))
P14_ = AllTrim(Tran(Columnas_, "9999999999"))
P15_ = AllTrim(Tran(P3_, "9999"))
P16_ = AllTrim(Tran(P12_, "9999999999"))
qqOut(Chr(27) + "*p" + P13_ + "x" + P14_ + "Y")
qqOut(Chr(27) + "*t" + P15_ + "R")
qqOut(Chr(27) + "*r0F")
qqOut(Chr(27) + "*r1A")
If P4_
  For P10_ = 1 To 8
    qqOut(Chr(27) + "*b0m" + P16_ + "W" + Iif(P10_ <= 2, ;
    Repl("ÿ", P12_), "À" + Repl(Chr(0), P12_ - 2) + Chr(03)))
  Next
EndI
PosiTemp = 0
Pix2 = ""
P5_ = {"", "", "", ""}
For P10_ = P11_ To 1 Step -1
  If (P6_ == 1)
    qqOut(Chr(27) + "*b0m" + P16_ + "W" + Iif(P4_, "À", "") ;
        + Pixeles[P10_] + Iif(P4_, Chr(03), ""))
  Else
    If (!(Pixeles[P10_] == Pix2))
      BITConvert(Pixeles[P10_], @P5_)
    EndI
    Pix2 = Pixeles[P10_]
    For Loop1 = 1 To 4
      P16_ = AllTrim(Tran(Len(P5_[Loop1]) + ;
      Iif(P4_, 2, 0), "999999"))
      qqOut(Chr(27) + "*b0m" + P16_ + "W" + Iif(P4_, "À", ;
              "") + P5_[Loop1] + Iif(P4_, Chr(03), ""))
    Next
  EndI
Next
If P4_
  For P10_ = 1 To 8
    qqOut(Chr(27) + "*b0m" + P16_ + "W" + Iif(P10_ > 6, ;
        Repl("ÿ", P12_), "À" + Repl(Chr(0), P12_ - 2) + Chr(03)))
  Next
EndI
qqOut(Chr(27) + "*rB")
Set(17, Salida)
Retu 0

********************************************************
Function DecBMP(BitmapF, Pixeles)
* Programado por Diego D'Onofrio * Email: near@lycos.com 
********************************************************
BitmapF = Uppe(AllTrim(BitmapF))
ManeArch = FOpen(BitmapF)
If (FError() != 0)
  FClose(ManeArch)
  Retu
EndI
Cadena = FReadStr(ManeArch, 2)
If (!(Cadena == "BM"))
  FClose(ManeArch)
  Retu
EndI
Cadena = Spac(4)
FRead(ManeArch, @Cadena, 4)
BmpLay = bin2l(Cadena)
FSeek(ManeArch, 4, 1)
Cadena = Spac(4)
FRead(ManeArch, @Cadena, 4)
BuscaB_ = bin2l(Cadena)
Cadena = Spac(2)
FRead(ManeArch, @Cadena, 2)
Cadena = Cadena + Chr(0) + Chr(0)
FSeek(ManeArch, 2, 1)
Cadena = Spac(4)
FRead(ManeArch, @Cadena, 4)
P2_ = bin2l(Cadena)
Cadena = Spac(4)
FRead(ManeArch, @Cadena, 4)
TLargo = bin2l(Cadena)
Cadena = Spac(2)
FRead(ManeArch, @Cadena, 2)
Cadena = Cadena + Chr(0) + Chr(0)
BmpLay = bin2l(Cadena)
If (BmpLay != 1)
  FClose(ManeArch)
  Retu
EndI
Cadena = Spac(2)
FRead(ManeArch, @Cadena, 2)
Cadena = Cadena + Chr(0) + Chr(0)
P1_ = bin2l(Cadena)
If (P1_ != 1 .AND. P1_ != 4)
  FClose(ManeArch)
  Retu
EndI
If (P2_ * P1_ > 2000)
  FClose(ManeArch)
  Retu
EndI
Cadena = Spac(2)
FRead(ManeArch, @Cadena, 2)
Cadena = Cadena + Chr(0) + Chr(0)
BmpLay = bin2l(Cadena)
If (BmpLay != 0)
  FClose(ManeArch)
  Retu
EndI
Cadena = Spac(4)
FRead(ManeArch, @Cadena, 4)
BmpLay = bin2l(Cadena)
FSeek(ManeArch, 4, 1)
Cadena = Spac(4)
FRead(ManeArch, @Cadena, 4)
BmpLay = bin2l(Cadena)
Cadena = Spac(4)
FRead(ManeArch, @Cadena, 4)
BmpLay = bin2l(Cadena)
Cadena = Spac(4)
FRead(ManeArch, @Cadena, 4)
BmpLay = bin2l(Cadena)
Cadena = Spac(4)
FRead(ManeArch, @Cadena, 4)
BmpLay = bin2l(Cadena)
FSeek(ManeArch, BuscaB_, 0)
Pixeles = {}
Cadena = ""
BmpLay = P2_ / IIf(P1_ == 1, 32, 16)
If (!(Int(BmpLay) == BmpLay))
  P3_ = (Int(BmpLay) + 1) * IIf(P1_ == 1, 32, 16)
EndI
BmpLay = 0
For Loop = 1 To TLargo
  P4_ = Spac(P3_ / IIf(P1_ == 1, 8, 2))
  FRead(ManeArch, @P4_, P3_ / IIf(P1_ == 1, 8, 2))
  If (P1_ == 1)
    FragBMP = BMP2cConv(P4_, P2_)
  Else
    FragBMP = BMP16cConv(P4_, P2_)
  EndI
  AAdd(Pixeles, FragBMP)
Next
AAdd(Pixeles, P1_)
FClose(ManeArch)
Retu

********************************************************
Function BITConvert(Pixeles, Salida)
* Programado por Diego D'Onofrio * Email: near@lycos.com 
********************************************************
Bit2Conv = {{"F", "F", "F", "F"}, {"F", "E", "7", "F"}, {"F", ;
        "E", "7", "B"}, {"D", "E", "7", "B"}, {"D", "E", "6", "B"}, ;
        {"D", "6", "6", "B"}, {"D", "6", "6", "9"}, {"9", "6", "6", ;
        "9"}, {"9", "4", "6", "9"}, {"9", "4", "2", "9"}, {"9", ;
        "4", "0", "9"}, {"9", "0", "0", "9"}, {"9", "0", "0", "1"}, ;
        {"8", "0", "0", "1"}, {"8", "0", "0", "0"}, {"0", "0", "0", ;
        "0"}}
Largo = Len(Pixeles)
Salida:= {"", "", "", ""}
For Loop = 1 To Largo
  P2_:= NToc(Asc(SubStr(Pixeles, Loop, 1)), 16, 2, "0")
  For Loop4:= 1 To 4
    P1_:= Bit2Conv[cton(Left(P2_, 1), 16) + 1][Loop4] + ;
        Bit2Conv[cton(right(P2_, 1), 16) + 1][Loop4]
    Salida[Loop4]:= Salida[Loop4] + Chr(cton(P1_, 16))
  Next
Next
Retu

********************************************************
Function AjustTam(Param1, Param2, Param3, Param4)
* Programado por Diego D'Onofrio * Email: near@lycos.com 
********************************************************
Res = 75
If (Param1 / Res <= Param3 .AND. Param2 / Res <= Param4)
  Retu Res
EndI
Res = 100
If (Param1 / Res <= Param3 .AND. Param2 / Res <= Param4)
  Retu Res
EndI
Res = 150
If (Param1 / Res <= Param3 .AND. Param2 / Res <= Param4)
  Retu Res
EndI
Res = 300
If (Param1 / Res <= Param3 .AND. Param2 / Res <= Param4)
  Retu Res
EndI
Retu 600

********************************************************
Function BMP16cConv(Byte1, Byte2)
* Programado por Diego D'Onofrio * Email: near@lycos.com 
********************************************************
If (Len(Byte1) > Byte2 / 2)
  P2_ = Int(Byte2 / 2)
  If (P2_ * 2 < Byte2)
    P2_++
  EndIf
  Byte1 = Left(Byte1, P2_)
  If (P2_ * 2 > Byte2)
    P1_ = right(Byte1, 1)
    Byte1 = Left(Byte1, Len(Byte1) - 1)
    P3_ = NToc(Asc(P1_), 16, 2, "0")
    P3_ = Left(P3_, 1) + "F"
    P1_ = Chr(cton(P3_, 16))
    Byte1 = Byte1 + P1_
  EndI
EndI
Retu Byte1

********************************************************
Function BMP2cConv(Byte1, Byte2)
* Programado por Diego D'Onofrio * Email: near@lycos.com 
********************************************************
XSalida_ = ""
For Loopx = 1 To Len(Byte1)
  Primero = SubStr(Byte1, Loopx, 1)
  ByteLar = 8
  Pos1_ = Loopx * 8
  If (Pos1_ > Byte2)
    ByteLar = 8 - (Pos1_ - Byte2)
    If (ByteLar == 0)
      XSalida_ = XSalida_ + Chr(0)
      Loop
    EndI
  EndI
  PxP = NToc(Asc(Primero), 2, 8, "0")
  Cadenax_ = strtran(PxP, "0", "X")
  Cadenax_ = strtran(Cadenax_, "1", "0")
  Cadenax_ = strtran(Cadenax_, "X", "1")
  If (ByteLar < 8)
    Cadenax_ = Left(Cadenax_, ByteLar) + Repl("0", 8 - ByteLar)
  EndI
  XSalida_ = XSalida_ + Chr(cton(Cadenax_, 2))
Next
Retu XSalida_

********************************************************

