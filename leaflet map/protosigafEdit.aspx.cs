using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net;

namespace leaflet_map
{
    public partial class getLocalHostAddr : Page
    {
        public static string serverAddrAndType;
        protected void Page_Load(object sender, EventArgs e)
        {
            serverAddrAndType = GetIP();

            //    // -- controllo se siamo in sessione (da migliorare verificando  user e password in tabella Utente)

            //    // -- debug per permettere di accedere alla pagina anche se non autenticati

            //    Session["user"] = "leo";
            //    Session["pwd"] = "miaPass";

            //    int counter = 0;
            //    String str;
            //    for (int k = 1; k <= Session.Count(); k++)
            //    {
            //        str = Session.Key(k);
            //        if (str == "user" || str == "pwd") counter++;
            //        if (counter == 2) break;
            //    }
            //    if (counter == 2) Response.Write("autenticato");
            //    else
            //    {
            //        Response.Write("non autenticato");
            //        Response.End();
            //    }
        }
        public static string GetIP()
        {
            /*-------------------------------------------------------------------------------------
             * gets IPv4 interfaces addresses of computer running IIS server process.
             * If finds 192.168.60|61|72|85.0/24 addresses then assumes we are on ARTEA intranet
             * else on an external internet network.
             *------------------------------------------------------------------------------------*/
            string strHostName = "";
            strHostName = System.Net.Dns.GetHostName();
            IPHostEntry ipEntry = System.Net.Dns.GetHostEntry(strHostName);
            IPAddress[] addr = ipEntry.AddressList;  // -- list of ip addresses bound to  host active network interfaces
            int k = 0;
            int kk0 = 0;
            int[] ip = new int[4];
            string retValue = "";
            int[] checkIntranet = new int[] { 60, 61, 72, 85 }; // -- list of ARTEA intranet networks
            bool isIntranet = false;

            for (k = 0; k < addr.Length; k++) // -- scans all IP addresses like with ipconfig /all command
            {
                kk0 = 0;

                if (addr[k].ToString().IndexOf('.') > 0)  // -- check only IPv4 addresses
                {
                    // -- convert IPv4 address in array of four integer numbers
                    foreach (string kk in addr[k].ToString().Split('.'))
                    {
                        ip[kk0] = Convert.ToInt32(kk);
                        kk0++;
                    }

                    // -- check only 192.168.0.0/32 private IP class,
                    //    when found the first intranet IP address then it is assumed definitely we are on the intranet
                    if (ip[0] == 192 && ip[1] == 168 && !isIntranet)
                    {
                        // -- check only ARTEA intranet networks 
                        if (Array.IndexOf(checkIntranet, ip[2]) >= 0)
                        {
                            isIntranet = true;
                            retValue = "{\"ipAddress\": \"" + addr[k].ToString() + "\",\"location\": \"intranet\"}";
                        }
                        else
                            retValue = "{\"ipAddress\": \"" + addr[k].ToString() + "\",\"location\": \"internet\"}";
                    }
                }
            }
            return retValue;
        }
    }
}

