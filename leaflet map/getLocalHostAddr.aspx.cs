using System;
using System.Net;

    public partial class getLocalHostAddr : System.Web.UI.Page
    {
        public static string checkIntranet;
        protected void Page_Load(object sender, EventArgs e)
        {
            checkIntranet = GetIP();
       }
        public static string GetIP()
        {
            string strHostName = "";
            strHostName = System.Net.Dns.GetHostName();
            IPHostEntry ipEntry = System.Net.Dns.GetHostEntry(strHostName);
            IPAddress[] addr = ipEntry.AddressList;
            int k = 0;
            int kk0 = 0;
            int[] ip = new int[4];
            string retValue = "";
            int[] checkIntranet = new int[] { 60, 72, 85};
            bool isIntranet = false;

            for (k=0; k<addr.Length;k++)
            {
                kk0 = 0;

                if (addr[k].ToString().IndexOf('.')>0)
                {
                    foreach (string kk in addr[k].ToString().Split('.'))
                    {
                        ip[kk0] = Convert.ToInt32(kk);
                        kk0++;
                    }

                    if (ip[0]== 192 && ip[1]==168 && !isIntranet)
                    {
                        if (Array.IndexOf(checkIntranet, ip[2]) >= 0)
                        {
                            isIntranet = true;
                            retValue = "{\"" + addr[k].ToString() + "\": \"" + "intranet" + "\"}";
                        }
                        else
                            retValue = "{\"" + addr[k].ToString() + "\": \"" + "internet" + "\"}";
                    }
                }                    
            }
            return retValue;
        }
    }

/*
private string GetIP()
{
string strHostName = """";
strHostName = System.Net.Dns.GetHostName();
IPHostEntry ipEntry = System.Net.Dns.GetHostEntry(strHostName);
IPAddress[] addr = ipEntry.AddressList;
return addr[addr.Length - 1].ToString();
}
*/
