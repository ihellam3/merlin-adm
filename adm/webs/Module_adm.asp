<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - 阿呆喵</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/>
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="usp_style.css"/>
<link rel="stylesheet" type="text/css" href="ParentalControl.css">
<link rel="stylesheet" type="text/css" href="css/icon.css">
<link rel="stylesheet" type="text/css" href="css/element.css">
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/dbconf?p=adm&v=<% uptime(); %>"></script>
<script type="text/javascript" src="/dbconf?p=koolproxy_enable&v=<% uptime(); %>"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
<script language="JavaScript" type="text/javascript" src="/client_function.js"></script>
<script>
var $j = jQuery.noConflict();
var $G = function(id){return document.getElementById(id);};
function init() {
	show_menu();
	get_status();
	buildswitch();
    version_show();
    setTimeout("version_show()", 3000);
	conf2obj();
    var kp_enable = db_koolproxy_enable["koolproxy_enable"];
	if(kp_enable == "1"){
		$j("#warn").html("<i>警告：你开启了koolprxoy, 阿呆喵无法启用</i>");
		document.form.adm_enable.value = 0;
		inputCtrl(document.form.switch,0);
	}else{
		$j("#warn").html("");
	}
}

function conf2obj(){
    var rrt = document.getElementById("switch");
    if (document.form.adm_enable.value != "1") {
        rrt.checked = false;
    } else {
        rrt.checked = true;
    }
}

function get_status() {
    $j.ajax({
        url: 'apply.cgi?current_page=Module_adm.asp&next_page=Module_adm.asp&group_id=&modified=0&action_mode=+Refresh+&action_script=&action_wait=&first_time=&preferred_lang=CN&SystemCmd=adm_status.sh&firmver=3.0.0.4',
        dataType: 'html',
        error: function(xhr) {
	        alert("error");
	        },
        success: function(response) {
    		checkCmdRet2();
        	}
    });
}
var _responseLen;
var noChange = 0;
function checkCmdRet2(){
	$j.ajax({
		url: '/res/adm_check.htm',
		dataType: 'html',
		
		error: function(xhr){
			setTimeout("checkCmdRet2();", 1000);
		},
		success: function(response){
			var _cmdBtn = document.getElementById("cmdBtn");
			if(response.search("XU6J03M6") != -1){
				adm_status = response.replace("XU6J03M6", " ");
				document.getElementById("status").innerHTML = adm_status;
				setTimeout("get_status();", 2000);
				return true;
			}
			
			if(_responseLen == response.length){
				noChange++;
			}else{
				noChange = 0;
			}

			if(noChange > 100){
				noChange = 0;
				refreshpage();
			}else{
				setTimeout("checkCmdRet2();", 400);
			}
			_responseLen = response.length;
			
		}
	});
}

function buildswitch(){
	$j("#switch").click(
	function(){
		if(document.getElementById('switch').checked){
			document.form.adm_enable.value = 1;
			
		}else{
			document.form.adm_enable.value = 0;
		}
	});
}

function onSubmitCtrl(o, s) {
	document.form.action_mode.value = s;
	showLoading(15);
	document.form.submit();
}

function version_show(){
	$j("#adm_version_status").html("<i>当前插件版本：" + db_adm['adm_version']);

    $j.ajax({
        url: 'https://raw.githubusercontent.com/koolshare/koolshare.github.io/acelan_softcenter_ui/adm/config.json.js',
        type: 'GET',
        success: function(res) {
            var txt = $j(res.responseText).text();
            if(typeof(txt) != "undefined" && txt.length > 0) {
                //console.log(txt);
                var obj = $j.parseJSON(txt.replace("'", "\""));
		$j("#adm_version_status").html("<i>当前插件版本：" + obj.version);
		if(obj.version != db_adm["adm_version"]) {
			$j("#adm_version_status").html("<i>插件有新版本：" + obj.version);
		}
            }
        }
    });
}

function reload_Soft_Center(){
location.href = "/Main_Soft_center.asp";
}
</script>
</head>
<body onload="init();">
	<div id="TopBanner"></div>
	<div id="Loading" class="popup_bg"></div>
	<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
	<form method="POST" name="form" action="/applydb.cgi?p=adm_" target="hidden_frame">
	<input type="hidden" name="current_page" value="Module_adm_.asp"/>
	<input type="hidden" name="next_page" value="Module_adm_.asp"/>
	<input type="hidden" name="group_id" value=""/>
	<input type="hidden" name="modified" value="0"/>
	<input type="hidden" name="action_mode" value=""/>
	<input type="hidden" name="action_script" value=""/>
	<input type="hidden" name="action_wait" value=""/>
	<input type="hidden" name="first_time" value=""/>
	<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>"/>
	<input type="hidden" name="SystemCmd" onkeydown="onSubmitCtrl(this, ' Refresh ')" value="adm_config.sh"/>
	<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>"/>
	<input type="hidden" id="adm_enable" name="adm_enable" value='<% dbus_get_def("adm_enable", "0"); %>'/>
	<table class="content" align="center" cellpadding="0" cellspacing="0">
		<tr>
			<td width="17">&nbsp;</td>
			<td valign="top" width="202">
				<div id="mainMenu"></div>
				<div id="subMenu"></div>
			</td>
			<td valign="top">
				<div id="tabMenu" class="submenuBlock"></div>
				<table width="98%" border="0" align="left" cellpadding="0" cellspacing="0">
					<tr>
						<td align="left" valign="top">
							<table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FormTitle">
								<tr>
									<td bgcolor="#4D595D" colspan="3" valign="top">
										<div>&nbsp;</div>
										<div style="float:left;" class="formfonttitle">ADM 阿呆猫</div>
										<div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
										<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
										<div class="formfontdesc" id="cmdDesc"><i>当前插件版本：<% dbus_get_def("adm_version", "0"); %></i>&nbsp;&nbsp;&nbsp;&nbsp;<i>当前adm版本：2.5</i></div>
										<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="routing_table">
											<thead>
											<tr>
												<td colspan="2">开关设置</td>
											</tr>
											</thead>
											<tr id="switch_tr">
												<th>
													<label>开启ADM</label>
												</th>
												<td colspan="2">
													<div class="switch_field" style="display:table-cell">
														<label for="switch">
															<input id="switch" class="switch" type="checkbox" style="display: none;">
															<div class="switch_container" >
																<div class="switch_bar"></div>
																<div class="switch_circle transition_style">
																	<div></div>
																</div>
															</div>
														</label>
													</div>
													<div id="adm_install_show" style="padding-top:5px;margin-left:80px;margin-top:-30px;float: left;"></div>	
												</td>
											</tr>
											<tr id="adm_status">
												<th>adm运行状态</th>
												<td><span id="status"></span></td>
											</tr>
                                    	</table>
                                    	<div id="warn"></div>
										<div id="adm_note">
										<div><i>1&nbsp;&nbsp;adm 2.5支持https过滤，你需要修改/koolshare/adm/ADMConfig.ini文件，然后重启adm，才能正常使用</div>
										<div><i>2&nbsp;&nbsp;启用https功能后，你还需要手动运行<font color='#66FF00'>cd /koolshare/adm && ./adm /ssl rsa</font>生成证书。</i></div>
										<div><i>3&nbsp;&nbsp;证书生成后，需要拷贝路由器内<font color='#66FF00'>/koolshare/adm/adm_ca.crt</font>文件到你的设备，然后安装证书。</div>
										<div><i>4&nbsp;&nbsp;adm在运行时，打开网页等操作会生成很多子进程，会对路由器造成很大的负担，可以通过运行状态一栏看到进程数量。</i></div>
										<div><i>5&nbsp;&nbsp;请注意，adm和koolproxy不能同时运行！</i></div>
										<div><i>6&nbsp;&nbsp;adm运行的稳定与否与本插件和merlin改版固件无关，如有任何问题，请向adm方面反馈！</i></div>
										</div>
										<div class="apply_gen">
											<button id="cmdBtn" class="button_gen" onclick="onSubmitCtrl(this, ' Refresh ')">提交</button>
										</div>
										<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
										<div class="KoolshareBottom">
											<br/>论坛技术支持： <a href="http://www.koolshare.cn" target="_blank"> <i><u>www.koolshare.cn</u></i> </a> <br/>
											后台技术支持： <i>Xiaobao</i> <br/>
											Shell, Web by： <i>Sadoneli</i><br/>
										</div>

									</td>
								</tr>
							</table>
						</td>
						<td width="10" align="center" valign="top"></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	</form>
	</td>
	<div id="footer"></div>
</body>
</html>



