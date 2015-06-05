<cfset variables.pagetitle="Address Verification Tool">
<cfinclude template="header.cfm">
										<!-- START content -->

<cfform action="whitepages.cfm" name="address_form" method="post">
<br>
<table width="50%" border="1" cellpadding="10">
  <tr>
    <td colspan="2" align="center"><p style="color:#ff6b08; font-weight:bold;">Address Verification Tool</p></td>
  </tr>
  <tr>
    <!-- Begin street address search -->
    <td width="50%"><p style="font-weight:bold;">Search by street address</p>
    <p>Street:
		<cfinput required="yes" message="Please enter an address" type="text" maxlength="100" name="address"></p>
	<p>Zip:
		<cfinput required="yes" message="Please enter a zip" validate="zipcode" type="text" maxlength="10" name="zip">
<input type="submit" value="Check Address"></cfform>
<input type="reset" value="Clear">
    </td> <!-- End street address search -->

    <!-- Begin library card search -->
    <cfform action="whitepages.cfm" name="barcode_form" method="post">
    <td width="50%"><p style="font-weight:bold;">Search by library Card</p>
    <p>&nbsp;</p>
    <p>Barcode:
		<cfinput required="yes" message="Please enter a barcode" validate="integer" type="text" maxlength="21" name="barcode">
<input type="submit" value="Submit Barcode">
<input type="reset" value="Clear"></td>
    </cfform>
    </td> <!-- End library card search -->
  </tr>
  <tr>
    <td colspan="2" align="center"><p style="font-weight:bold;"><a href="http://mcldaz.org">Maricopa County Library District</a></td>
  </tr>
</table>
<cfinclude template="/suggestions/footer.cfm">