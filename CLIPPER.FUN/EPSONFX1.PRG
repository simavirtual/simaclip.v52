*>>>>INICIALIZACION DE VARIABLES PARA LA IMPRESORA EPSON FX
       #DEFINE ON_LINE      SENDCODES('DC1')
       #DEFINE PICA         SENDCODES(CHR(27)+'P')
       #DEFINE ELITE        SENDCODES(CHR(27)+'M')
       #DEFINE PROPOR_OF    SENDCODES(CHR(27)+'p0')
       #DEFINE DRAFT_OF     SENDCODES(CHR(27)+'x1')
       #DEFINE DRAFT_ON     SENDCODES(CHR(27)+'x0')
       #DEFINE ROMAN_ON     SENDCODES(CHR(27)+'k0')
       #DEFINE CONDEN_ON    SENDCODES(CHR(15))
       #DEFINE CONDEN_OF    SENDCODES(CHR(18))
       #DEFINE DOBANC_ON    SENDCODES(CHR(27)+'W1')
       #DEFINE DOBANC_OF    SENDCODES(CHR(27)+'W0')
       #DEFINE DOBALT_ON    SENDCODES(CHR(27)+'w1')
       #DEFINE DOBALT_OF    SENDCODESCHR(27)+'w0'
       #DEFINE DOBGOL_ON    SENDCODES(CHR(27)+'G')
       #DEFINE DOBGOL_OF    SENDCODES(CHR(27)+'H')
       #DEFINE NEGRA_ON     SENDCODES(CHR(27)+'E')
       #DEFINE NEGRA_OF     SENDCODES(CHR(27)+'F')
       #DEFINE SUBRAY_ON    SENDCODES(CHR(27)+'-1')
       #DEFINE SUBRAY_OF    SENDCODES(CHR(27)+'-0')
       #DEFINE ITALIC_ON    SENDCODES(CHR(27)+'4')
       #DEFINE ITALIC_OF    SENDCODES(CHR(27)+'5')
       #DEFINE GRAPHI_ON    SENDCODES(CHR(27)+'t1')
       #DEFINE LINESP1_6    SENDCODES(CHR(27)+'2')
       #DEFINE LINESP1_8    SENDCODES(CHR(27)+'0')
       #DEFINE INICIALIZA   SENDCODES(CHR(27)+'@')

       #DEFINE n10Stan      80              // Pica  10 cpi Standard
       #DEFINE n10Wide      136             // Pica  10 cpi Wide
       #DEFINE n12Stan      96              // Elite 12 cpi Standard
       #DEFINE n12Wide      163             // Elite 12 cpi Wide
       #DEFINE n17Stan      137             // Pica Condensado Standard
       #DEFINE n17Wide      233             // Pica Condensado Wide
       #DEFINE n20Stan      160             // Elite Condensado Standard
       #DEFINE n20Wide      272             // Elite Condensado Wide
*>>>>FIN INICIALIZACION DE VARIABLES PARA LA IMPRESORA EPSON FX