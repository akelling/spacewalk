<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://rhn.redhat.com/rhn" prefix="rhn" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<html:html xhtml="true">

<head>
	<script language="javascript" type="text/javascript">
		
		function toggleIFText(ctl) {
			var toDisable = null;
			var toEnable = null;
			if (ctl.id == "dhcpRadio") {
				toDisable = document.getElementById("staticNetworkIf");
				toEnable = document.getElementById("dhcpNetworkIf");
			}
			else {
				toDisable = document.getElementById("dhcpNetworkIf");
				toEnable = document.getElementById("staticNetworkIf");		
			}
			toDisable.disabled = true;
			toEnable.disabled = false;
			toEnable.value = toDisable.value;
			toDisable.value = "";
		}
		
		function flagPassword() {
		   var pwdChanged = document.getElementById("pwdChanged");
		   pwdChanged.value = "true";
		}

        // Workaround for apparent Firefox bug. See Red Hat Bugzilla #459411.
        function init() {
            static = document.getElementById("staticNetworkIf");
            if (static.disabled == true) {
                static.value = "";
            }
        }

	</script>
	
<%
boolean dhcpIfDisabled = Boolean.valueOf(
	(String) request.getAttribute("dhcpIfDisabled")).booleanValue();
boolean staticIfDisabled = Boolean.valueOf(
	(String) request.getAttribute("staticIfDisabled")).booleanValue();
%>
<meta http-equiv="Pragma" content="no-cache" />
</head>

<body onload="init()">
<%@ include file="/WEB-INF/pages/common/fragments/kickstart/kickstart-toolbar.jspf" %>

<rhn:dialogmenu mindepth="0" maxdepth="1" 
    definition="/WEB-INF/nav/kickstart_details.xml" 
    renderer="com.redhat.rhn.frontend.nav.DialognavRenderer" />



<div>
  <html:form method="post" action="/kickstart/SystemDetailsEdit.do">
    <html:hidden property="ksid" />
    <html:hidden property="submitted" />
    <html:hidden property="pwdChanged" styleId="pwdChanged" />
    <h2><bean:message key="kickstart.systemdetails.jsp.header1"/></h2>
    <table class="details" width="80%">
      <tr>
        <th width="10%"><bean:message key="kickstart.netconn.jsp.label" />:</th>
        <td>
            <html:radio styleId="dhcpRadio" property="networkType" value="dhcp" onclick="toggleIFText(this);" /><bean:message key="kickstart.netconn.dhcp.jsp.label"/>&nbsp;<html:text size="4" maxlength="10" property="dhcpNetworkIf" styleId="dhcpNetworkIf" disabled="<%= dhcpIfDisabled%>" /><br />
            <html:radio styleId="staticRadio" property="networkType" value="static" onclick="toggleIFText(this);" /><bean:message key="kickstart.netconn.static.jsp.label"/>&nbsp;<html:text size="4" maxlength="10" property="staticNetworkIf" styleId="staticNetworkIf" disabled="<%= staticIfDisabled%>" />
        </td>
      </tr>      
    </table>
    <c:if test="${not ksdata.legacyKickstart}">
      <h2><bean:message key="kickstart.systemdetails.jsp.header2"/></h2>
      <table class="details">
        <tr>
          <th><bean:message key="kickstart.selinux.jsp.label" />:</th>
          <td>
              <html:radio property="selinuxMode" value="enforcing" /><bean:message key="kickstart.selinux.enforce.policy.jsp.label" /><br />
              <html:radio property="selinuxMode" value="permissive" /><bean:message key="kickstart.selinux.warn.policy.jsp.label" /><br />
              <html:radio property="selinuxMode" value="disabled" /><bean:message key="kickstart.selinux.disable.policy.jsp.label" />
          </td>
        </tr>
      </table>
    </c:if>
    <h2><bean:message key="kickstart.systemdetails.jsp.header3"/></h2>
      <table class="details">
       <tr>
         <th><bean:message key="kickstart.config.mgmt.jsp.label" />:</th>
         <td><html:checkbox property="configManagement" /><br />
             <span class="small-text"><bean:message key="kickstart.config.mgmt.tip.jsp.label" /></span>
         </td>
       </tr>
       <tr>
         <th><bean:message key="kickstart.remote.cmd.jsp.label" />:</th>
         <td><html:checkbox property="remoteCommands" /><br />
             <span class="small-text"><bean:message key="kickstart.remote.cmd.tip.jsp.label" /></span>
         </td>         
       </tr>
      </table>
    <h2><bean:message key="kickstart.systemdetails.jsp.header4"/></h2>
    <table class="details">
      <tr>
        <th><bean:message key="kickstart.root.password.jsp.label" />:</th>
        <td><html:password property="rootPassword" maxlength="32" size="32" onchange="flagPassword(); return true;"/></td>
      </tr>
      <tr>
        <th><bean:message key="kickstart.root.password.verify.jsp.label" />:</th>
        <td><html:password property="rootPasswordConfirm" maxlength="32" size="32" onchange="flagPassword(); return true;"/></td>
      </tr>      
      <tr>
        <td align="right" colspan="2">
            <input type="submit" value="<bean:message key="kickstart.systemdetails.edit.submit.jsp.label" />" />
        </td>
      </tr>
    </table>
  </html:form>
</div>
</body>
</html:html>

