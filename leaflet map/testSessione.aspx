<%@ Page Language="C#"  EnableViewState="true" AutoEventWireup="true"  Inherits="MSDN.SessionPage"%>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
        <style>
            body         {font:12px verdana; padding:3px;}
            table,tr,td  {font:12px verdana; border:1px solid black;border-collapse:collapse;}
            .tabBody     {padding:3px;background-Color:#f9eadb; color:#122cbf; font-weight:normal}
            .tabHeadings {padding:3px;background-Color:paleGoldenRod; color:firebrick; font-weight:bold}
            iframe       {margin-top:20px; width:100%;height:300px;border:1px solid black;overflow:auto}
        </style>
        <script runat="server">
            protected void Page_Load(object sender, EventArgs e)
            {
                Session["nome1"] = "Leonardo";
                Session["nome2"] = "Antonella";
                Session["nome3"] = "Silvana";
                Session["nome4"] = "Giampaolo";

                String[] intestazioni = { "k", "Session.Key(k)", "Session[Session.Key(k)]" };
                String[] valori;

                Table1.Rows.Add(new TableRow());
                for (int k = 0;k < 3; k++)
                {
                    Table1.Rows[0].Cells.Add(new TableCell());
                    Table1.Rows[0].Cells[k].Controls.Add(new LiteralControl(intestazioni[k]));
                    Table1.Rows[0].Cells[k].CssClass = "tabHeadings";
                }

                for (int k = 1; k <= Session.Count(); k++)
                {
                    valori = new string[] {k.ToString(),Session.Key(k).ToString(),Session[Session.Key(k)].ToString()};
                    Table1.Rows.Add(new TableRow());
                    for (int h=0; h<3;h++)
                    {
                        Table1.Rows[k].Cells.Add(new TableCell());
                        Table1.Rows[k].Cells[h].Controls.Add(new LiteralControl(valori[h]));
                        Table1.Rows[k].Cells[h].CssClass = h==0 ? "tabHeadings":"tabBody";
                    }
                }
            }
        </script>
</head>
<body onload="bload.call()">
    <div>
        Questa pagina utilizza il componente COM <strong>SessionManager.dll</strong> (in codice nativo) costruito per mantenere le variabili di sessione ASP classica su database, diversamente dall&#39;oggetto ASP Session di microsoft, che non supportava la condivisione dello stato della Sessione fra istanza diverse dei worker processes (w3wp) collegati ad un processo server IIS, oppure fra diverse istanze di IIS.<br />
        <br />
        La pagina utilizza inoltre l&#39;assembly <strong>SessionUtility.dll</strong> (in codice managed) che permette di collegare lo stato asp classico con lo stato asp.net mantenendoli sincronizzati.<br />
        <br />
        <strong>SessionManager.dll</strong> deve semplicemente essere posto in <strong>\Windows\System32</strong> (os 32 bit) oppure in <strong>\Windows\SysWow64</strong> (os 64 bit) e registrato con <strong>regsvr32</strong> <br />
        <strong>SessionUtility.dll</strong> deve essere posto nella cartella <strong>bin</strong> del sito web ospitato dalserver IIS, unitamente al file <strong>SessionUtility.tlb</strong> (type library) contenente le informazioni riguardo proprietà e metodi in formato accessibile alle altre applicazioni in fase di runtime. Deve poi essere registrato con <strong>regasm </strong>come da esempio che segue: <span style="background-color:#feec8a">C:\Windows\Microsoft.NET\Framework64\v4.0.30319\regasm.exe SessionUtility.dll /tlb:SessionUtility.tlb</span><br />
        <br />
        Questa la configurazione necessaria per il funzionamento delle due dll:<br />
        <ul>
            <li>inserire nel file di configurazione <strong>global.asa</strong>, funzione <strong>application_onstart</strong>, la riga <span style="background-color:#feec8a">Application("SessionDSN") = "data source=ARTEA-SQL2V8\SQL2;initial catalog=TempDB;persist security info=False;user id=ospiteWeb1;Password=ospe*1word;packet size=4096"</span> contenente la stringa di connessione accedere al database per gestire la tabella contenente gli oggetti di sessione serializzati (Session status).</li> 
            <li>inserire le stesse informazioni nella sezione <strong>&lt;configuration&gt;</strong> -&gt; <strong>&lt;appSettings&gt;</strong> del file di configurazione <strong>Web.Config</strong> della applicazione asp.net&nbsp; &lt;<span style="background-color:#feec8a">add key="SessionDSN" value="data source=ARTEA-SQL2V8\SQL2;initial catalog=TempDB;persist security info=False;user id=ospiteWeb1;Password=ospe*1word;packet size=4096" /&gt;</span> in modo che l'assembly <strong>SessionUtility.dll</strong> possa accedere allo stesso database per gestire la tabella contenente gli oggetti di sessione serializzati (Session status).</li>
            <li>inserire nella sezione <strong>&lt;system.web&gt;</strong> -&gt; <strong>&lt;compilation&gt;</strong> -&gt; <strong>&lt;assemblies&gt;</strong> del file di configurazione <strong>Web.Config</strong> della applicazione asp.net&nbsp;&lt;<span style="background-color:#feec8a">add assembly=&quot;SessionUtility, Version=1.0.0.0, Culture=neutral, PublicKeyToken=8cb006bf1d449859&quot;/&gt;</span> in modo da caricare l'assembly.</li>
            <li>inserire nella testata (prima riga) della pagina asp net seguente configurazione di pagina <span style="background-color:#feec8a"> &lt;%@ Page Language="C#"  EnableViewState="true" AutoEventWireup="true"  <strong>Inherits="MSDN.SessionPage</strong>"%&gt;</span> in modo da collegare alla pagina l&#39;assembly.
        </ul>
        Questa pagina produce la tabella visibile sotto, contenente alcune variabili di sessione generate per test nella pagina stessa. Le variabili generate dalla pagina sono visibili anche da pagina asp classica (es. <strong>/list_var.asp</strong>).<br />
        Il codice è stato messo a punto per riempire automaticamente una tabella con tutti i dati prelevati dalla sessione. L&#39;oggetto <strong>Session</strong>, disponibile in questo assembly, contiene una collection <strong>Key</strong> che, con indice compreso fra <strong>0</strong> e <strong>Session.Count()</strong>, può essere interrogata per ottenere le stringhe identificative degli oggetti di sessione contenuti. Si può accedere al contenuto dell&#39;oggetto con <strong>Session[stringaIdentificativa] </strong>cioè <strong>Session[Session.Key(k)]</strong> .</div>
    <div>
        <asp:Table ID="Table1" runat="server">
        </asp:Table>
    </div>
    <div></div>
    <iframe src="informazioni SessionManager nel registro di sistema.htm"></iframe>
    </body>
</html>
