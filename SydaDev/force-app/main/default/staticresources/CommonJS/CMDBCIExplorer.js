function ShowCIExplorer(ciInstanceID)
{
	var title = _ServerValues.CMDBCIExplorerTitle;
    var linkci = escape("CIExplorerLauncher?Module=CI&RecordSequence="+ciInstanceID+"&id="+ciInstanceID);
    var url = "NavigatorPage?title="+ title +"&target=" + linkci;
   if(getUrlParameter('wid')==null ||getUrlParameter('wid')=='') {
		 url="CIExplorerLauncher?Module=CI&RecordSequence="+ciInstanceID+"&id="+ciInstanceID ;
	     window.open('/apex/'+url,null,"status = 1,height = "+750+", width = "+700+",left="+200+",top="+200+", resizable = 1,scrollbars=yes");
    } else 
    window.parent.parent.addNewTab("CIExplorerLauncher",_ServerValues.CIExplorerLabel,url);
}

function ShowCIRelationshipExplorer(relInstanceID)
{
	//alert('showing ci explorer with relationship: ' + relInstanceID);
	//return;
	var title = _ServerValues.CMDBCIExplorerTitle;
	var linkci = escape("CIExplorerLauncher?Module=BMC_BaseRelationship__c&RecordSequence="+relInstanceID+"&id="+relInstanceID);
	var url = "NavigatorPage?title="+ title +"&target=" + linkci;
   if(getUrlParameter('wid')==null ||getUrlParameter('wid')=='') {
		url="CIExplorerLauncher?Module=BMC_BaseRelationship__c&RecordSequence="+relInstanceID+"&id="+relInstanceID;	
	     window.open('/apex/'+url,null,"status = 1,height = "+750+", width = "+700+",left="+200+",top="+200+", resizable = 1,scrollbars=yes");
    } else 
    window.parent.parent.parent.addNewTab("CIExplorerLauncher",_ServerValues.CIExplorerLabel,url);   
         
}