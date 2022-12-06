var aheight;
var eheight=1;
var qmultiplier;
var amultiplier;
Ext.onReady(function(){
	//Attachments grid
	var store = new Ext.data.ArrayStore({
        fields: [
            {name:'ID'},
            {name:'Created_Date'},
            {name:'File_Name'}
        ]
    });
	store.loadData(attachmentarray);
	if(attachmentarray.length != 0){
		 var attachmentGrid = new Ext.grid.GridPanel({
	        store: attachmentarray,
	        columns: [
	            {id:'ID', width: 250, header:'ID', hidden:true},
                {id:'Created_Date', width: 300, header:'Created Date', hidden:true},
                {id:'File_Name', header:'File Name'}
            ],
            stripeRows: false,
            sortable: false,
            enableHdMenu:false,
            //width:615,
            height:60,
            viewConfig: {
            	forcefit:true
            },
            stateful: true,
            stateId: 'grid',
            id:'attachment_grid',
            border:false,
            renderTo:'attachmentDiv',
            sm: new Ext.grid.RowSelectionModel({singleSelect:true})
        });
       
        attachmentGrid.on('rowdblclick', function(grid,rowIndex){
            var rec = grid.store.getAt(rowIndex);
            openAttachment(attachmentarray[rowIndex][0]);
        });     
    }

    var RatingStore = new Ext.data.ArrayStore({
        id:'RatingStore',
        fields:[
            {name:'Id'},
            {name:'RatingLabel'}
        ]
    });
    RatingStore.loadData(RatingData);
    
    //ellipsis added if in case text length is greater than 22 characters depending upon language selected
  var EmptyText = Ext.util.Format.ellipsis(RatingEmptyText,24);  
   
    // Simple ComboBox using the data store
    if(getCalledFromFormValue() == true){
    	if(getShowFeedbackValue() == true){
	        var RatingCombo = new Ext.form.ComboBox({
	                id:'ratingPicklist',
	                renderTo:'ratingComboDiv',
	                emptyText:EmptyText,
	                fieldLabel: 'ProfileLabel',
	                hiddenName:'ClientProfile',
	                store: RatingStore,
	                valueField:'Id',
	                displayField:'RatingLabel',
	                typeAhead: false,
	                mode: 'local',
	                editable:false,
	                width:150,
	                //value : ratingComboValue,
	                triggerAction: 'all',
	                forceSelection:true,
	                selectOnFocus:true           
	        });
	           
	        RatingCombo.on('select', function(){
	            ratingComboValue = RatingCombo.getValue();
	            enableButtons();
	            var inputs = document.getElementsByTagName('input');
	        	for(var k=0;k<inputs.length;k++)
				{
					var input = inputs[k];
					if(input.type == 'radio'){
						if(ratingComboValue == 'Not Helpful'){
							if(input.value == 'Return to search results'){
								input.checked = true;							
							}
						} else {
							if(input.value == checkedRadioValue){
								input.checked = true;
							}
						}												
						if(input.value == 'Yes' || input.value == 'No'  )
						{					
				            if(ratingComboValue == 'Not Helpful' && input.value == 'No' ){
				            	input.checked = true;
				            }else if(ratingComboValue == 'Helpful'  && input.value == 'Yes'){
				            	input.checked = true;
				            }	
				        }	
				    }	
				}     
	            //changeCopyOption(ratingComboValue);
	            
	        });
	         
    	}
    }
    RatingEmptyText = RatingEmptyText.replace('<','&lt;');
    RatingEmptyText = RatingEmptyText.replace('>','&gt;');
         new Ext.ToolTip({
     	  		 target: 'ratingComboDiv',
     	  		 title : RatingEmptyText
    		});
    	
    if(document.getElementById("attachmentDiv") != null){
	    if(Ext.isIE){
	    	document.getElementById("attachmentDiv").style.height = '65px';
	    	
	    } else {
	    	document.getElementById("attachmentDiv").style.height = '60px';
	    	document.getElementById("attachmentDiv").style.width = '100%';
	    }    
    }
   // settingKASize();
});

window.onresize = function(event) {
    document.getElementById('ArticleContents').contentWindow.location.reload();
}

function getInternetExplorerVersion() {
	var rv = -1; // Return value assumes failure.
	if (navigator.appName == 'Microsoft Internet Explorer') {
		var ua = navigator.userAgent;
		var re = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");

		if (re.exec(ua) != null)
			rv = parseFloat(RegExp.$1);
	}
	return rv;
}

function settingKASizeJS(){
	    var ver = getInternetExplorerVersion();
		//alert('>>>>>ver:'+ver);
	
	if (getCalledFromFormValue()==true && (getIsFromSS()==false) && (getIsGS()==false) ){//for incident form
  		wheight=615;
  		eheight=0.86;
  		if(Ext.isChrome)
  		{
  			eheight=0.85;
  			
  		}
	}
  	
  	else if (getCalledFromFormValue()==true && (getIsFromSS()==true) && (getIsGS()==false)){//for ss 
		wheight=800;	
		eheight=0.80;
		if(Ext.isSafari)
		{
			eheight=0.77;
		}
  	}
	
	else if (getCalledFromFormValue()==true && (getIsFromSS()==false) && (getIsGS()==true)){	 //global search
		wheight= window.innerHeight
		//alert("innerheight "+wheight);
		if (wheight == undefined || wheight == 0)
			{
				wheight=document.documentElement.clientHeight;
				//alert("clientheight "+wheight);
				if (wheight == undefined || wheight == 0)
				{	
					wheight= window.document.body.offsetHeight
					//alert("Offset height "+wheight);
				}
			}
			//alert("Final height is"+wheight);	
		eheight=0.90;
  	}
  	
  	else{	//For Preview
		wheight= window.innerHeight
		//alert("innerheight "+wheight);
		if (wheight == undefined || wheight == 0)
			{
				wheight=document.documentElement.clientHeight;
				//alert("clientheight "+wheight);
				if (wheight == undefined || wheight == 0)
				{	
					wheight= window.document.body.offsetHeight
					//alert("Offset height "+wheight);
				}
			}
		eheight=0.93;
	}
  	
  	if (wheight != null)
	{
	   	aheight=wheight;
	   	
	   	var theight=document.getElementById("KMTitle");
		if (theight != null)
		{
			theight=document.getElementById("KMTitle").offsetHeight; // Height of the title
			aheight=aheight-theight;
			//alert("theight"+theight);
		}
	
		var fheight=document.getElementById("feedbackDetails");
		if (fheight != null)
		{
			fheight=document.getElementById("feedbackDetails").offsetHeight; // Height of the feedback
			aheight=aheight-fheight;
		//	alert("fheight"+fheight);
		}
		
		var att_height=document.getElementById("attachmentDiv");
		if (att_height != null)
		{
			att_height=document.getElementById("attachmentDiv").offsetHeight; // Height of the attachment
			if (Ext.isChrome )
				aheight=aheight-att_height-90;//
			else if (Ext.isIE )
				aheight=aheight-att_height-101;//
			else if(Ext.isSafari)
				{
				aheight=aheight-att_height-108;//
				}
			else
				aheight=aheight-att_height-50;
		//	alert("attheight"+att_height);
		}
		//alert("aheight: "+aheight+"wheight: "+wheight);
		var embeddedpageheight=document.getElementById("ArticleContents");
		//alert("Before Height :"+embeddedpageheight.offsetHeight);
		
		eheight=Math.round(aheight * eheight) - 40 ;
		embeddedpageheight.style.height=eheight;
		//alert("After Height :"+embeddedpageheight.offsetHeight)
		//alert("in main page");
		return eheight;
	} 	
}

function emptyText(){
	var feedbackValue = document.getElementById(feedbackComp).value;
	if(feedbackValue == commentsFeedbackLabel){
		document.getElementById(feedbackComp).value = '';
		document.getElementById(feedbackComp).style.color = '#000000';
	}
}