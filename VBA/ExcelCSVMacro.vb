Option Explicit
Private sub SubmitButton_Click()
    Dim ws As Worksheet
    Dim dToday As Date
    dtToday = Date()
    Set ws = ThisWorkbook.Sheets(dtToday)
    Dim nextRow As Integer
    nextRow = ws.Cells(ws.Rows.Count, 1).End(x1up).Row + 1

    ws.Cells(nextRow, 1).Value = TextBox1.Value
    ws.Cells(nextRow, 2).Value = TextBox2.Value
    ws.Cells(nextRow, 3).Value = TextBox3.Value
    ws.Cells(nextRow, 4).Value = TextBox4.Value
    ws.Cells(nextRow, 5).Value = TextBox5.Value
    ws.Cells(nextRow, 6).Value = TextBox6.Value
    ws.Cells(nextRow, 7).Value = TextBox7.Value
    If MsgBox("Do you have more users to enter?", vbYesNo) =vbNo Then
    SendEmail
    End If
End Sub

Sub SendEmail()
    Dim olApp As Object
    Dim olMail As Object
    Set olApp = CreateObject("Outlook.Application")
    Set olMail = olApp.CreateItem(0)

    olMail.To = "csc-it@cardiacstudycenter.com"
    olMail.Subject = "ONBOARDING:" & dToday
    olMail.Body = "This is an automated email sent from onboarding to enroll users into Active Directory."
    olMail.Send

    Set olMail = Nothing
    Set olApp = Nothing
End Sub