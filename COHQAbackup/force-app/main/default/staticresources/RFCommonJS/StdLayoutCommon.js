var stdLayoutScreenWidth = 671;
var stdLayoutScreenHeight = 400;
function stdScreenLeft(){
	return parseInt((screen.availWidth/2) - (stdLayoutScreenWidth/2));
}

function stdScreenTop(){
	return parseInt((screen.availHeight/2) - (stdLayoutScreenHeight/2));
}

// Added For Std Form Mgr

var active_element;
var bIsMSIE;
// changes for std layout ---
    function initiateSelfClosing() {
        if((showStdLayout) && (enableSelfClosing != 'false' || enableSelfClosing == undefined || enableSelfClosing == null || enableSelfClosing =='')){
            if (Ext.isIE) {
                active_element = document.activeElement;
                document.onfocusout = closeWnd;
                bIsMSIE = true;
            }
            else { window.onblur = closeWnd; }
        }
    }

    function closeWnd() {
        if(showStdLayout){
            if (window.opener != null) {
                if (bIsMSIE && (active_element != document.activeElement)) {
                    active_element = document.activeElement;
                }
                else {  
                    window.close();
                }
            }
        }
    }

    var showStdLayout = getStandardLayout();
	var enableSelfClosing = getUrlParameter('enableSelfClosing');
	
	// end std layout --
	
    function getFocus(){
        if(window.focus){
            window.focus();
        }
    }
    function callFunc(){
        window.close();
    }
    function getStandardLayout(){
         var showStdLayout = getUrlParameter('standardLayout');
         return showStdLayout;
    }
    function getPopupFor(){
         var popupFor = getUrlParameter('popupFor');
         return popupFor;
    }
    
    var popupFor=getPopupFor().toUpperCase();
    
	function getPopupHeader(){
         var popupHeader = getUrlParameter('popupHeader');
         return popupHeader;
    }
	
	function getObjName(){
         var objName = getUrlParameter('objName');
         return objName;
    }
	
    function getUrlParameter( param ){
        param = param.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
        var r1 = "[\\?&]"+param+"=([^&#]*)";
        var r2 = new RegExp( r1 );
        var r3 = r2.exec( window.location.href );
        if( r3 == null ){return ""}
        else {return r3[1]};
    }  
	var url = document.URL;

	  //Code By Manasi
       
	
	// End of Code - Std Form Mgr
	
	//Category Tree
	function openCategoryTree(){
		var popupWidth = 671;
		var popupHeight = 530;
		var left = stdScreenLeft();
		var top = stdScreenTop();
		var winParams = '?recordId='+recordId+'&popupId='+popupId+'&objectName='+objectName+'&state='+state+'&stdForm=true&standardLayout=true';
		if(popupId!=null && popupId!='null' && popupId!='' && popupId == 'incident'){
			winParams = winParams + '&serviceRequest='+ getServiceRequestVar(incType);	//service request param for incident module
		}
		var windowFeatures = "width=" + popupWidth + ",height=" + popupHeight + ",status,resizable,scrollbars=no,left=" + left + ",top=" + top+',toolbar=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,modal=yes'; 
		categoryTreeWindow = window.open(page_CategoryTree + winParams,recordId,windowFeatures);
		categoryTreeWindow.focus();
	}
	
	function getServiceRequestVar(incidentType){
		serviceRequest = 'false';
		if(incidentType!=null && incidentType!='null' && incidentType!='' && incidentType==serviceRequestLabel){
		    serviceRequest = 'true';
		}
		return serviceRequest;
	}

	function getOpener(){
		var opener = null;
		if(window.dialogArguments){ // Internet Explorer supports window.dialogArguments 
			opener = window.dialogArguments;
   		}else{ // Firefox, Safari, Google Chrome and Opera supports window.opener
			if(window.opener) {
        		opener = window.opener;
       		}
		}
		return opener;
	}