
Private Sub Comando1_Click()

Dim nHoras As Integer
Dim nMinutos As Integer

TimerInterval = 0
nHoras = Format(LblTiempoTranscurrido, "HH")
nMinutos = Format(LblTiempoTranscurrido, "NN")
lblprecio = nHoras * lblPrecioHora

    If nHoras = 0 And nMinutos < 59 Then
    lblprecio = lblPrecioHora
    
    Else
    
        If nMinutos >= 10 Then
        lblprecio = lblprecio + lblPrecioHora
        End If
       
    End If
End Sub



Private Sub Form_Timer()

lblHoraActual = Time()
LblTiempoTranscurrido = Format(lblHoraActual - lblHoraEntrada, "HH:NN:SS")
End Sub
