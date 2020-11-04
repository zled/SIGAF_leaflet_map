<%
	dim Session
	set Session = server.CreateObject("SessionMgr.Session2")

    dim V_TestSessione, V_Msg_Riattivata,V_Msg_Errore

    V_Msg_Riattivata=request.QueryString("riattivata") & ""

    on error resume next
    V_TestSessione=Session("stile")

    if err.number =438 then
      on error goto 0
      V_Msg_Riattivata=" (riattivata sessione scaduta)"
      Response.Cookies("mySession")=""
      set Session=nothing
      set Session = server.CreateObject("SessionMgr.Session2")
    else
      if err.number <>0 then
        V_Msg_Errore = "err. n°: " + cstr(hex(err.number)) + " - " + err.Description
        on error goto 0
        response.End
      else
        V_Msg_Errore = ""
        on error goto 0
      end if
    end if

%>