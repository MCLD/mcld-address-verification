<style type="text/css">
      .clip_button {
        border: 1px solid black;
        background-color: #ccc;
        margin: 8px;
        padding: 8px;
		width: 40%;
      }
      .clip_button.zeroclipboard-is-hover { background-color: #eee; }
      .clip_button.zeroclipboard-is-active { background-color: #aaa; }
    </style>

<cfif StructKeyExists(Form,"address")>
	<cfset variables.findapt = find(" Apt ",Form.address)>
	<cfif variables.findapt EQ 0>
		<cfset variables.findapt = find(" apt ",Form.address)>
	</cfif>
	<cfif variables.findapt EQ 0>
		<cfset variables.findapt = find(" unit ",Form.address)>
	</cfif>
	<cfif variables.findapt EQ 0>
		<cfset variables.findapt = find(" apartment ",Form.address)>
	</cfif>
	<cfif variables.findapt EQ 0>
		<cfset variables.findapt = find(" Apartment ",Form.address)>
	</cfif>
	<cfif variables.findapt EQ 0>
		<cfset variables.findapt = find(" ##",Form.address)>
	</cfif>
	<cfif variables.findapt EQ 0>
		<cfset variables.findapt = find(" Unit ",Form.address)>
	</cfif>

	<cfif variables.findapt GT 0>
		<cfset variables.sendtoacess = LEFT(Form.address,EVALUATE(variables.findapt - 1))>
	<cfelse>
		<cfset variables.sendtoacess = "Nothing here">
	</cfif>
<cfelse>
	<cfset variables.sendtoacess = "Nothing here">
</cfif>
<script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
<script type="text/javascript" src="ZeroClipboard.js"></script>
<cfset variables.pagetitle="Address Verification Tool">
<cfinclude template="header.cfm">
<script src="/Javascripts/jquery-1.11.1.js"></script>
<cfif StructKeyExists(Form,"barcode")>
	<cfquery datasource="dsn" name="bcsearch">
	select info from database
	</cfquery>
	<cfset form.address=#bcsearch.streetOne#>
	<cfset form.zip=#bcsearch.postalcode#>
	<br>
	Search for Patron:<br>
	<cfoutput>
	#bcsearch.NameFirst# #bcsearch.NameLast# (#Form.barcode#)<br>
	#bcsearch.streetOne# #bcsearch.city#, #bcsearch.state# #bcsearch.postalcode#<br><br>
	</cfoutput>
<cfelse>
	<cfset form.barcode = "NULL">
</cfif>
<!-- End copy to clipboard in browser -->
<br>
<a href="designworkbench.cfm">Click to Search Again</a>
<br><br>
<script>
$( document ).ready(function() {
});
</script>
<cfif NOT StructKeyExists(Form,"address")>
<br>
Sorry this page cannot be accessed directly
<cfabort>
</cfif>

<cfif variables.sendtoacess NEQ "Nothing here">
	<cfset variables.search=#reReplace(variables.sendtoacess,"\s+","+","All")#>
<cfelse>
	<cfset variables.search=#reReplace(form.address,"\s+","+","All")#>
</cfif>

<cfhttp method="get" url="http://mcassessor.maricopa.gov/?s=#variables.search#" result="mcaccessor">
</cfhttp>

<cfhttp url="https://proapi.whitepages.com/2.0/location.json?street_line_1=#URLENCODEDFORMAT(Form.address)#&zip=#Form.zip#&api_key=apikey" method="get" result="httpResp" timeout="60">
</cfhttp>

<cfoutput>
	<cftry>
		<cfset variables.QResults = DeserializeJSON(httpResp.filecontent)>
		<cfcatch type="any">
		<br>
		Sorry there was an issue with the call, possible a bad address<br>
		Please try again. <a href="javascript:history.back();">BACK</a><br>
		<cfabort>
		</cfcatch>
	</cftry>

<cftry>
	<cfset variables.firstlocation=variables.QResults.results>
		<cfcatch type="any">
				<br>
				Sorry there was an issue with the call, possible a bad address<br>
				Please try again. <a href="javascript:history.back();">BACK</a><br>
				<cfset variables.dontshowwhitepages="yes">
		</cfcatch>
</cftry>
</cfoutput>
<cfif NOT StructKeyExists(variables,"dontshowwhitepages")> <!--- Begining of White Pages --->
<cfset Qlocation = QueryNew("locationid,address,postalcode")>
<cfset Qname = QueryNew("locationid,bestlocation,best_name,begindate,enddate","varchar,varchar,varchar,date,date")>
<cfoutput>
<cfset variables.searchedAddress = variables.QResults.results[1]>
<cfset variables.keylist = StructKeyList(variables.QResults.Dictionary)>
<cfset variables.looploc = 1>
<cfset variables.loopname = 1>
<cfloop list="#variables.keylist#" index="i">

	<cfif LEFT(i,8) EQ "Location">
		<cfset variables.newRowLoc = QueryAddRow(variables.Qlocation,1)>
		<cfset temp = QuerySetCell(Qlocation,"locationid","#i#",#variables.looploc#)>
		<cfset temp = QuerySetCell(Qlocation,"address","#variables.QResults.Dictionary['#i#']['address']#",#variables.looploc#)>
		<cfset temp = QuerySetCell(Qlocation,"postalcode","#variables.QResults.Dictionary['#i#']['postal_code']#",#variables.looploc#)>
		<cfset variables.looploc=variables.looploc+1>
	<cfelseif LEFT(i,6) EQ "Person">

		<cfloop from="1" to="#ArrayLEN(variables.QResults.Dictionary['#i#']['locations'])#" index="ii">
			<cfset variables.newRowName = QueryAddRow(Qname,1)>
			<cfset temp = QuerySetCell(Qname,"locationid","#variables.QResults.Dictionary['#i#']['locations'][ii]['id']['key']#",#variables.loopname#)>
			<cfset temp = QuerySetCell(Qname,"best_name","#variables.QResults.Dictionary['#i#']['best_name']#",#variables.loopname#)>
			<cfset temp = QuerySetCell(Qname,"bestlocation","#variables.QResults.Dictionary['#i#']['best_location']['id']['key']#",#variables.loopname#)>
			<cftry>
				<cfset variables.bdate="#variables.QResults.Dictionary['#i#']['locations'][ii]['valid_for']['start']['month']#/#variables.QResults.Dictionary['#i#']['locations'][ii]['valid_for']['start']['day']#/#variables.QResults.Dictionary['#i#']['locations'][ii]['valid_for']['start']['year']#">
				<cfcatch type="any">
					<cfset variables.bdate="0">
				</cfcatch>
			</cftry>
			<cftry>
				<cfset variables.edate="#variables.QResults.Dictionary['#i#']['locations'][ii]['valid_for']['stop']['month']#/#variables.QResults.Dictionary['#i#']['locations'][ii]['valid_for']['stop']['day']#/#variables.QResults.Dictionary['#i#']['locations'][ii]['valid_for']['stop']['year']#">
				<cfcatch type="any">
					<cfset variables.edate="0">
				</cfcatch>
			</cftry>
			<cfset temp = QuerySetCell(Qname,"begindate","#variables.bdate#",#variables.loopname#)>
			<cfset temp = QuerySetCell(Qname,"enddate","#variables.edate#",#variables.loopname#)>
			<cfset variables.loopname=variables.loopname+1>
		</cfloop>

	</cfif>
</cfloop>
<cfquery datasource="dsn" name="postalcodes">
select Distinct(county) as County, postalcode
from   PostalCodes pc
where  County IS NOT NULL
group by County, postalcode
</cfquery>
<cfquery dbtype="query" name="Qcombined">
select Qname.Best_Name,Qlocation.address,Qname.bestlocation,Qlocation.locationid,begindate,enddate,postalcode
from   Qname,Qlocation
where  Qname.locationid =  Qlocation.locationid
order by Qname.Best_Name
</cfquery>
<cfquery dbtype="query" name="Qcombined1">
select Best_Name,address,bestlocation,locationid,begindate,enddate,Qcombined.postalcode,county
from   Qcombined,postalcodes
where  cast(Qcombined.postalcode as varchar) = cast(postalcodes.postalcode as varchar)
order by Best_Name
</cfquery>
<cfmail to="dannycone@mcldaz.org" from="CarisOMalley@mcldaz.org" subject="count of records from whitepages.cfm" type="html">
user is <!--- #session.loginname#---> no login information<br>
<cfdump var="#session#">
<cfdump var="#form#">
<cfdump var="#Qcombined1#">
<cfif StructKeyExists(variables,"findapt")>
variables.findapt=#variables.findapt#<br>
variables.sendtoacess=#variables.sendtoacess#
</cfif>
</cfmail>
</cfoutput>
<div id="results" style="display: none">
<h2>Address Searched for:</h2>
<cfoutput>
	<cfloop query="#Qcombined1#">
		<cfif Qcombined1.locationid EQ variables.searchedAddress>
        <input id="hiddenaddress" type="hidden" value='#GetToken(Qcombined1.address,1,",")#'>
        <div id="ClipBoard" width="60%" ALIGN="left">
        <div id="itscopied" width="20%" style="display:none;margin-left:110px;color:red;"><strong>Address is now copied to clipboard</strong></div>
		<cfset variables.returnedAddress = Qcombined1.address>
		<div class="clip_button">#Qcombined1.address#</div> &nbsp; <input id="makecopy" type="button" value="Click to Copy to clipboard">
		</div>
		<cfbreak>
		</cfif>
	</cfloop>
</cfoutput>
<script type="text/javascript">
      //var client = new ZeroClipboard( $('.clip_button') );
		var client = new ZeroClipboard( $('#makecopy') );
      client.on( 'ready', function(event) {
        // console.log( 'movie is loaded' );
		$('#itscopied').hide();

        client.on( 'copy', function(event) {
          //event.clipboardData.setData('text/plain', event.target.innerHTML);
          var justaddress = $('.clip_button').text();
          var justaddress1 = justaddress.split(",",1);
          event.clipboardData.setData('text/plain', $('#hiddenaddress').val() );
          //alert(justaddress1);
          //event.clipboardData.setData('text',justaddress1.val());
          $('#itscopied').slideDown(800,'swing');
        } );

        client.on( 'aftercopy', function(event) {
          console.log('Copied text to clipboard: ' + event.data['text/plain']);
        } );
      } );

      client.on( 'error', function(event) {
        // console.log( 'ZeroClipboard error of type "' + event.name + '": ' + event.message );
        ZeroClipboard.destroy();
      } );
    </script>
<h2>Current Resident(s):</h2>
<table cellspacing="1" cellpadding="1" border="1" id="showresults">
	<cfoutput query="Qcombined1" group="Best_Name">
		<tr>
			<td colspan=2><strong>#Qcombined1.Best_Name#</strong></td>

		</tr>
	</cfoutput>
</table>
<div>
<script>
$('div').slideDown(900,'swing');
</script>
</cfif> <!--- End of White Pages --->
<br>
<cfset variables.begin = find("rp-results",mcaccessor.filecontent)>
<cfif variables.begin EQ 0>
	<cfset variables.newhtml = "<span style='color:red;font-weight:bold;'>Address not in County or no Address returned/matched</span>">
<cfelse>
	<cfset variables.newhtml1 = "<span style='color:green;font-weight:bold;'>Address(es) are in County<br></span>">
	<cfset variables.begin = variables.begin -9>
	<cfset variables.end = find("<!-- ##content",mcaccessor.filecontent)>
	<cfset variables.complete = variables.end - variables.begin>
	<cfset variables.newhtml = MID(mcaccessor.filecontent,variables.begin,variables.complete)>
	<cfset variables.newhtml = variables.newhtml1 & variables.newhtml>
	<cfset variables.removelinks = find("View full details",variables.newhtml)> <!--- this line not used --->
</cfif>
<cfoutput>
	<h2>Current Owner(s):</h2>
	#variables.newhtml#
</cfoutput>
<cfparam name="Qcombined.RecordCount" default="0">

<cfquery datasource="dsn" name="tracking" result="auditno">
insert into address_verification (IPAddress,account,address,postalcode,recordsreturned,barcode,returned_address)
values('#CGI.Remote_addr#','no login','#form.address#','#form.zip#',#Qcombined.RecordCount#<cfif form.barcode eq "NULL">,NULL<cfelse>,'#Form.barcode#'</cfif>,
<cfif IsDefined("variables.returnedAddress")>'#variables.returnedAddress#'<cfelse>NULL</cfif>)
</cfquery>
<br><br><hr>
<center><div id="surveyMonkeyInfo"><div><script src="http://www.surveymonkey.com/jsEmbed.aspx?sm=key"> </script></div>Create your free online surveys with <a href="https://www.surveymonkey.com">SurveyMonkey</a> , the world's leading questionnaire tool.</div></center>
<cfinclude template="/suggestions/footer.cfm">