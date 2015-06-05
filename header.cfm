<!DOCTYPE HTML>
<html style="scrollbar-arrow-color: #FFFFFF;scrollbar-3dlight-color: #5786BA;scrollbar-highlight-color: #4B9ECB; scrollbar-face-color: #5786BA;scrollbar-shadow-color: #163A4E;scrollbar-darkshadow-color: #0E2532;scrollbar-track-color: #FF6B08;">
<head>
<cfparam name="variables.pagetitle" default="">
<cfoutput>
<title>#variables.pagetitle#</title>
</cfoutput>
<meta http-equiv="content-Type" content="text/html; charset=utf-8">
<meta name="keywords" content="Maricopa County Library District Staff Intranet">
<meta name="description" content="Maricopa County Library District Staff Intranet">
<meta name="robots" content="all" />
<cfinclude template="/Includes/Accordion.inc">
<link href="/Styles/Stylesheet.css" rel="stylesheet" type="text/css">
<link href="/Styles/NewMenu2.css" rel="stylesheet" type="text/css">
<script src="/Javascripts/datetime.js" type="text/javascript" language="JavaScript"></script>
<script src="/Javascripts/javascripts.js" type="text/javascript" language="JavaScript"></script>
<script src="/Javascripts/pop-closeup.js" type="text/javascript" language="JavaScript"></script>
<script src="/Javascripts/mouseover.js" type="text/javascript" language="JavaScript"></script>

<body>
<table id="screencontent" width="100%" cellspacing="0" cellpadding="0" border="0">
	<tr class="printhide">
		<td width="100%" colspan="2" valign="top">
			<table width="100%" cellspacing="0" cellpadding="0" border="0">
				<tr>
					<td valign="top">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="100" valign="bottom" >
								<a href="/Intranet.cfm"><img src="/Graphics/JustSun.gif" alt="Intranet Home Page" width="152" height="79" border="0"></a>
								</td>
								<td width="300" valign="bottom" class="logoheader">
								<cfoutput>#variables.pagetitle#</cfoutput>
								<br>
								<span class="logosmallblack"><script src="/Javascripts/datedisplay.js" type="text/javascript" language="JavaScript"></script></span>
								</td>
								<td>
								<cfinclude template="/Includes/PolarisSearch.inc">
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr><td class="c7"></td></tr>
				<tr><td class="c1"></td></tr>
			</table>
		</td>
	</tr>
	<tr>		<td rowspan="2" valign="top" bgcolor="#5786BA" class="printhide">
			<table border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td>

                    <cfinclude template="/Includes/NewMenu2.inc">
					</td>
				</tr>
			</table>
		</td>
		<td width="100%" height="100%" align="left" valign="top">

										<table width="100%" border="0" cellspacing="2" cellpadding="2">
  <tr>
    <td width="5">&nbsp;</td>
    <td valign="top">