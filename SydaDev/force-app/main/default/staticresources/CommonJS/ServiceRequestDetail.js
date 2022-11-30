var NumberFormatter =  new Ext.form.NumberField({
						allowNegative : false
					});
var isRefreshEvent = false;	
					
function closeIt() {  //this
			
			if(isRefreshEvent){
				isRefreshEvent =false;
				return;
			}else{
				return "Please save your data before you leave this page.";
			}
			
		}

        function initiateSelfClosing() {//this
            if(standardLayout== 'true'){
              if (requestDetailId == null || requestDetailId== '' || typeof(requestDetailId) == 'undefined'){
              
                  window.onbeforeunload = closeIt;    
                                                                                                                                                                                      
              }else{
                window.onbeforeunload = null;
              } 
            }
        }
   function buttonValidator() { //this
        	if( standardLayout == 'true' ){
	        	if((requestDetailId != null && requestDetailId != '')&&(errormsg == null||errormsg ==''||errormsg==succesvar)){   
	                
	                Ext.getCmp('saveId').setDisabled(true);
	                Ext.getCmp('resetId').setDisabled(true);
	                
						if( standardLayout == 'true' ){
							window.onbeforeunload = null;
			                 
			                 if(Ext.isIE){
			                     	
		                    	var parentObj = window.dialogArguments;
		                    	parentObj.saveIncidentWithRequestDtl(requestDetailId);
			                    	
			                 }else{
			                    	
		                    	window.parent.opener.saveIncidentWithRequestDtl(requestDetailId);
			                 }
			                   
			                window.close();
			           }
				}
		   }
     } 	

var initialCost =0; 
	var officialNamespace='';
	var SaveBtnHandler = function(button,event) {
		save(); 
	};
    var ResetBtnHandler = function(button,event) {  
		
		isRefreshEvent = true;
		replaceUrl();
		
        
     };
	 var PreviuosBtnHandler = function (button,event) {previous();};
	 var NextBtnHandler = function (button,event) {next();};
     var quantitySpinner;
     var currencyDecimal=0;
	 
	function setUnitPrice(){
		if(initialCost != undefined && initialCost != null) {
			if(!isNaN(initialCost)) {
				NumberFormatter.setValue(initialCost);
				document.getElementById('unitPrice').innerHTML = NumberFormatter.getRawValue();			
			}
		}
    }
	function convertInitialCostToInt(){
		if(initialCost!=undefined && initialCost!=''){
			initialCost = parseInt(initialCost);
		}else{
			initialCost = 0;
		}
	} 
     Ext.onReady(function(){
    	initialCost = getInitialCost();
		var detailQuantity = getDetailQuantity();
		setUnitPrice();
		if(detailQuantity == 0)
			detailQuantity = 1; 
		new Ext.Toolbar({
        renderTo: 'toolBar',
         cls:'toolSpCls',
		id:'SLToolbar',
         items: [
                {
                    scale: 'medium',
                    iconCls: 'bmcSave',
                    tooltipType : 'title',
                    tooltip: ServiceRequestPage.Labels.Save,
                    id:'saveId' ,
                    handler:SaveBtnHandler   
                 },'',
                 {
                    scale: 'medium',
                    iconCls: 'bmcResetOn',
                    tooltipType : 'title',
                    tooltip: ServiceRequestPage.Labels.Reset, 
                    id:'resetId',
					handler:ResetBtnHandler
                }
         ]
    });
    var setQuantity =  function(){
            var quantityEle = fetchQuantityText();
			var quantity = quantitySpinner.getValue();
            quantityEle.value = quantity;
			var totalCostEle = document.getElementById('totalCost');
			if(initialCost != undefined && initialCost !=null &&
				totalCostEle != undefined && totalCostEle!=null
				) {
					var total = 0;
					if(!isNaN(initialCost)) {
						total = initialCost * quantity;
					} 
					NumberFormatter.setValue(total);				
					totalCostEle.innerHTML = NumberFormatter.getRawValue();
				}
        } 
           quantitySpinner= new Ext.ux.form.SpinnerField({
                id:'quantitySpinner',
                value:detailQuantity,
                minValue: 1,
                maxValue: 999,
                width:100,
                maxLength:3,
                allowDecimals: false,
				readOnly:quantitySpinnerState,
                autoCreate: {tag: 'input', type: 'text', autocomplete: 'off', maxlength: '3'},
                renderTo:'quantity',
                enableKeyEvents : true,
                listeners: {
                spin:  function(){
                     setQuantity(); 
                }
                        ,
                keyup:  function(obj, e){
                            validateSpinnerField(obj, e);
							setQuantity();
                }
                       ,
                keydown:    function( obj, e) {
                                if(e.getKey()==109)
                                e.stopEvent();
                            }
                }   
            }); 
	   setQuantity();
		if(incidentWithRequest){ 
			Ext.getCmp('saveId').setDisabled(true);
			Ext.getCmp('resetId').setDisabled(true);
		}		
 	}); 
	
	function validateSpinnerField(obj,e){
		var val=obj.getValue();
		val=val.toString();
		if(val!='' && val< obj.minValue){
		  obj.setValue('');  
		} 
	}

function setIdToParent(){
	if(requestDetailId != null && typeof(requestDetailId) != null){
		window.parent.RequestDetailId(requestDetailId); 
	}
}	

function openPopUpForSR(obj,localName){
	openLookupPopup(obj,localName,'SRM_RequestDetail__c',null,null,officialNamespace+'SearchPage');
	return false;
}

function assignApexErrorMessage(){			
	var elem = document.getElementById('apexMessageErrorPanelDiv');
	if(elem != null && elem.firstChild != null){
		var ulList = elem.firstChild;
		var msgvalue = ulList.firstChild.innerHTML;
		Ext.MessageBox.show({ msg: msgvalue, buttons: Ext.MessageBox.OK});
	}
}