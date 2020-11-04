<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="getLocalHostAddr.aspx.cs" inherits="getLocalHostAddr"%>
<!--%@ Page Language="C#"  EnableViewState="true" AutoEventWireup="true"  Inherits="MSDN.SessionPage"%-->

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>get iis express local computer address</title>
    <style>
        .container {margin: 10px}
        .txt { width:100%; font:bold 12px verdana ; padding:5px; background-color:antiquewhite; color:blue}
        .topRow {border:1px solid brown}
        .nextRow {border:1px solid brown;border-top:none}
        .small {font:12px verdana ; text-align:justify; color:#6d1d1d;background-color:rgb(232, 254, 223)}
    </style>
    <script>
        window.addEventListener("load", function () {
            var checkIntranet = JSON.stringify(<%=getLocalHostAddr.checkIntranet%>);
            document.getElementsByTagName("div")[2].textContent = "from Client javascript code: " + checkIntranet;
            document.getElementsByTagName("div")[3].innerHTML = "When debugging web server code with Visual studio (i am using 2015 version) both IIS Express and browser run on the same computer and IIS is connected to LOCALHOST.<br /> Localhost entry in <strong>c:\\windows\\system32\\etc\\hosts</strong>, links with IPv6 <strong>::1</strong> and IPv4 <strong>127.0.0.1</strong> . <strong>Both Request.ServerVariables[&quot;REMOTE_ADDR&quot;] and Request.ServerVariables[&quot;LOCAL_ADDR&quot;] contains the IPv6 address of LOCALHOST, ::1</strong>. So it is not possible to recognise if I am working from my work organization (ARTEA) intranet or from home but i need this information to use public or local ip address of ARTEA GeoServer server.<br/>I buided an <strong>c# server code to detect the IPv4 address of computer hosting IIS Express web server when coding and debugging with Visual Studio</strong>. It uses the <strong>System.Net.Dns GetHostName() </strong>and <strong>GetHostEntry()</strong> methods. Tehe <strong>public static System.Net.IPHostEntry GetHostEntry (string hostNameOrAddress)</strong> produces a list of all the ip address of computer coniaining the same addresses that we found in  the output of &quot;<strong>ipconfig /all</strong>&quot; command from command prompt. In my work intranet user&#39;s network are 192.168.60.0/24, 192.168.72.0/24, 192.168.85/24.&nbsp; VPN connecter pc&#39;s shows in list both the home IP address&nbsp; (in most cases 192.168.1.0/24) and the intranet address (192.168.72.0/24). For this reason I scan all the list and when finding the 72/24 address I definetly consider to be in the work intranet.<br/>The first two lines of this page show the result of my c# method wich is a JSON object."
        });
    </script>
</head>

<body>
    <div class="container">
        <div class="txt topRow"> from Server Page_Load() c# code: <%=getLocalHostAddr.checkIntranet%></div>
        <div class="txt nextRow"></div>
        <div class="txt nextRow small"></div>
    </div>
    <form id="form1" runat="server">
    </form>
</body>
</html>
