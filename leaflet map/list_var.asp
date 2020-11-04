<%@ Language=VBScript %>
<!--#INCLUDE FILE="anagrafe/inc/IncludeNewSession.asp"-->
<html>
<head>
    <title>variabili di sessione e di applicazione asp classic</title>
    <style>
        body,td {font:12px monospace;color:midnightblue}
        table,tr,td {border-collapse:collapse;background-color:navajowhite;border-color:firebrick}
        td.tLight{background-color:white}
    </style>
</head>
<body>

<%

  Dim V_TipoVar	'array associativo di decodifica dei codici 
  				'numerici dei tipi di variabile 
				
  Set V_TipoVar=Server.CreateObject("Scripting.Dictionary")
  
  V_TipoVar.add "0","Empty"
  V_TipoVar.add "1","Null"
  V_TipoVar.add "2","Integer"
  V_TipoVar.add "3","Long"
  V_TipoVar.add "4","Single"
  V_TipoVar.add "5","Double"
  V_TipoVar.add "6","Currency"
  V_TipoVar.add "7","Date"
  V_TipoVar.add "8","String"
  V_TipoVar.add "9","Object"
  V_TipoVar.add "10","Error"
  V_TipoVar.add "11","Boolean"
  V_TipoVar.add "12","Variant"
  V_TipoVar.add "13","Data Access Object"
  V_TipoVar.add "17","Byte"
  V_TipoVar.add "8192","Array"

' -- SessionID

Response.Write("<b>SessionID: </b>" + cstr(Session.SessionID) + "<br>")
Response.Write("*** " + Request.Cookies("ASPSESSIONID")+ "<br>")
' -- cookies

Response.Write("<b>Cookies</b><br>")

    For Each Item In Request.Cookies 
      Response.Write(Item & " = " & Request.Cookies(Item) & "<BR>")
      If Request.Cookies(Item).HasKeys Then 
        For Each strSubKey In Request.Cookies(Item) 
          Response.Write "->" & Item & "(" & strSubKey & ") = " & _ 
            Request.Cookies(Item)(strSubKey) & "<BR>" 
        Next 
      End If 
    Next 
    Response.Write("<br>" )

' -- Variabili application

Response.Write("<b>Variabili di applicazione</b><br><br>")
Response.Write("<Table border=1>")
Response.Write("<tr><td width=""10%""><b>Nome</b></td><td width=""90%""><b>Valore</b></td></tr>")

  For Each Item in Application.Contents
    Response.Write("<tr>")
    If IsObject(Application.Contents(Item)) Then
      Response.Write "<td>" + Item + "</td><td> [object]</td>"
    Else 
      Response.Write "<td>" + Item + "</td><td class=""tLight"">" + cstr(Application.Contents(Item)) + "</td>"
    End If
    Response.Write("</tr>")
  Next
response.Write("</table><br>")

' -- Variabili di sessione

Response.Write("<b>Variabili di sessione</b><br><br>")
Response.Write("<Table border=1>")
Response.Write("<tr><td width=""10%""><b>Nome</b></td><td width=""10%""><b>Tipo</b></td><td width=""80%""><b>Valore</b></td></tr>")

For i=1 to Session.Contents.count
  V_Tipo = VarType(Session.Contents.item(i))
  Response.Write("<tr>")
  Response.Write("<td class=""tLight"">" + cstr(Session.Contents.key(i)) + "</td>")
  Response.Write("<td class=""tLight"">" + TypeName(Session.Contents.item(i)) + "</td>")
  
  select case V_Tipo
  case 0 
    Response.Write("<td>Empty</td>")
  case 1 
    Response.Write("<td>Null</td>")
  case else 
    if V_Tipo > 17 then
      
      Response.Write("<td> Array(")
      k=0
      on error resume next
      do while err.number = 0
        k=k+1
        V_Dim = Ubound(Session.Contents.item(i),k)
        if err.number=0 then 
          if k>1 then Response.write ","
          Response.Write cstr(V_Dim +1)
        end if
      loop
      on error goto 0
      k=k-1      
      Response.Write(") of " + V_TipoVar(cstr(V_Tipo - 8192))+ "<br>")

      for each k in Session.Contents.item(i)
        Response.Write("|" + cstr(k) + "|<br>")
      next
      Response.Write("</td>")      
    else
      Response.Write("<td>" + cstr(Session.Contents.item(i)) + "&nbsp;</td>")
    end if
  end select
  
  Response.Write("</tr>")
next
Response.Write("</Table>")

'  Response.Write("")
'  Response.Write("")

%>

</body>
</html>
