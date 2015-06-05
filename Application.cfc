<cfcomponent output="false">

  <!--- Name the application. --->
  <cfset this.name="addressverification">
  <!--- Turn on session management. --->
  <cfset this.sessionManagement=true>
  <cfset This.sessiontimeout="#createtimespan(0,3,0,0)#">
  
  
</cfcomponent>
