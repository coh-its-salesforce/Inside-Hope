Ext.onReady(function() {
	    var  blankvalue = 0 ;            
        
        var AppliesStore = new Ext.data.ArrayStore({
                id:'AppliesStore',
                fields:[
                    {name:'Id'},
                    {name:'AppliesLabel'}
                ]
        });
            
        AppliesStore.loadData(AssigntoListData);
        
        var AssignTo = new Ext.form.Label({
            id:'AssignTo',
            text: SLMSettingPage.Labels.AppliesTo,
            renderTo:'AppliesTotd'
        });
        
        var equalLabel = new Ext.form.Label({
            id:'equalLabelId',
            text:SLMSettingPage.Labels.EqualTo,
            renderTo:'equalLabelTD'
        });
        
        /*function padNumberToTwodigit(number) {
             return (number < 10 ? '0' : '') + number;
        }*/
        function getDuration() {
            var days=padNumberToTwodigit(dayField.getValue());
            hours=padNumberToTwodigit(hourField.getValue());
            minutes=padNumberToTwodigit(minuteField.getValue());
            return days +' '+SLMSettingPage.Labels.Days+' ' +hours+':'+minutes+' '+SLMSettingPage.Labels.HHMM;
        }
        var AssignToCombo = new Ext.form.ComboBox({        
            id:'defaultAssignTo',
            fieldLabel: 'Applies To',
            store: AppliesStore,
            valueField:'Id',            
            displayField:'AppliesLabel',
            renderTo:'AppliesToCombotd',
            mode: 'local',
            editable:false, 
            triggerAction: 'all',
            forceSelection:true,
            selectOnFocus:true,
            value: Assignto1
        }); 
      
      		AssignToCombo.setValue(AppliesStore.getAt(0).get('Id'));
     
         
         var priorityCheckbox = new Ext.form.Checkbox({
             id:'priorityCheckboxId',
             renderTo:'priorityCheckboxTD',
             style: 'width:13px;',
             checked: prioChk ,
            listeners: {
                             check:function(checkbox, checked) {
	                          
	                             if (prioChk == false){
	                              Ext.getCmp('defaultPriorityTo').setDisabled(false);
	                              prioChk = true;
	                             }else {
	                              Ext.getCmp('defaultPriorityTo').setDisabled(true);
	                              prioChk = false;
	                              }
                            }
                          
                       }     
            });
               
        
        var PriorityStore = new Ext.data.ArrayStore({
                id:'PriorityStore',
                fields:[
                    {name:'Id'},
                    {name:'PriorityLabel'}
                ]
            });
            
        PriorityStore.loadData(PriorityListData);
        
        var Priority = new Ext.form.Label({
            id:'Priority',
            text:wherelabel,
            renderTo:'PriorityTD'
        });
        
        var PriorityCombo = new Ext.form.ComboBox({        
            id:'defaultPriorityTo',
            FieldLabel: wherelabel,
            store: PriorityStore,
            emptyText:'--none--',
            valueField:'Id',
            displayField:'PriorityLabel',
            typeAhead: false,
            renderTo:'PriorityComboTD',
            mode: 'local',
            editable:false, 
            triggerAction: 'all',
            forceSelection:true,
            selectOnFocus:true,
            value:Priority1,
            disabled:true
         }); 
        PriorityCombo.setValue( PriorityStore.getAt(0).get('Id'));
         
       
        var TargetTypeStore = new Ext.data.ArrayStore({
                id:'PriorityStore',
                fields:[
                    {name:'Id'},
                    {name:'TargetLabel'}
                ]
            });
        AssignToCombo.on('select', function(combo, record, index) {
			if(combo.value == inc){
				TargetTypeStore.loadData(TargetTypeListDataForIncident);
			}	
			else if(combo.value == change){
					TargetTypeStore.loadData(TargetTypeListDataForChangeRequest);
			}else if(combo.value == prob){
					TargetTypeStore.loadData(TargetTypeListDataForProblem);
			}
			TargetTypeCombo.setValue( TargetTypeStore.getAt(0).get('Id'));	
        });    
        TargetTypeStore.loadData(TargetTypeListDataForIncident);
        
        var TargetType = new Ext.form.Label({
            id:'TargetType',
            text:SLMSettingPage.Labels.TargetType+' '+SLMSettingPage.Labels.EqualTo,
            renderTo:'TargetTypeTD'
        });
        
        
        var TargetTypeCombo = new Ext.form.ComboBox({
        
            id:'defaultTargetType',
            FieldLabel: 'Target Type',
            store: TargetTypeStore,
            valueField:'Id',           
            displayField:'TargetLabel',
            typeAhead: false,
            mode: 'local',
            editable:false, 
            triggerAction: 'all',
            forceSelection:true,
            selectOnFocus:true,
            value:TargetType1,
            renderTo:'TargetTypeComboTD'
         }); 
        
         TargetTypeCombo.setValue( TargetTypeStore.getAt(0).get('Id'));
        
        var TimeRemainingStore = new Ext.data.ArrayStore({
                id:'TimeRemainingStore',
                fields:[
                    {name:'Id'},
                    {name:'TimeRemainingLabel'}
                ]
            });
            
        TimeRemainingStore.loadData(TimeRemainingListData);
        
        var TimeRemaining = new Ext.form.Label({
            id:'TimeRemaining',
            text:SLMSettingPage.Labels.AND,
            renderTo:'TimeRemainingTD'
        });
        
        
        
        var TimeRemainingCombo = new Ext.form.ComboBox({
        
            id:'defaultTimeRemaining',
            store: TimeRemainingStore,
            valueField:'Id',
            displayField:'TimeRemainingLabel',
            typeAhead: false,
            mode: 'local',
            editable:false, 
            triggerAction: 'all',
            forceSelection:true,
            selectOnFocus:true,
            value:'Percent of Time Remaining',
            renderTo:'TimeRemainingComboTD'
         }); 
		 
         TimeRemainingCombo.setValue( TimeRemainingStore.getAt(0).get('Id'));
         TimeRemainingCombo.on('select', function(combo, record, index) {
            if(index == 1){
                Ext.getCmp('dayFieldId').show();
                Ext.getCmp('hourFieldId').show();
                Ext.getCmp('hourLabelId').show();
                Ext.getCmp('minuteFieldId').show();
                Ext.getCmp('dayLabelId').show();
                Ext.getCmp('minLabelId').show();
                Ext.getCmp('perLabelId').hide();
                Ext.getCmp('durationTextFieldId').show();
                Ext.getCmp('durationTextFieldPanelId').hide();
                Ext.getCmp('PercentageFieldId').hide();
                document.getElementById('percentageFieldTD').style.display='none';
                document.getElementById('perLabelTD').style.display='none';
                document.getElementById('dayFieldTD').style.display='block';
                document.getElementById('hourFieldTD').style.display='block';
                document.getElementById('minuteFieldTD').style.display='block';
				 var duration = getDuration();
                 Ext.getCmp('durationTextFieldId').setValue(duration);
				
                
            }else if(index == 0){
                Ext.getCmp('dayFieldId').hide();
                Ext.getCmp('hourFieldId').hide();
                Ext.getCmp('hourLabelId').hide();
                Ext.getCmp('minLabelId').hide();
                Ext.getCmp('perLabelId').show();
                Ext.getCmp('minuteFieldId').hide();
                Ext.getCmp('PercentageFieldId').show();
                Ext.getCmp('durationTextFieldId').hide();
                Ext.getCmp('durationTextFieldPanelId').show();
                Ext.getCmp('dayLabelId').hide();
                document.getElementById('percentageFieldTD').style.display='block';
                document.getElementById('perLabelTD').style.display='block';
                document.getElementById('dayFieldTD').style.display='none';
                document.getElementById('hourFieldTD').style.display='none';
                document.getElementById('minuteFieldTD').style.display='none';
                
            }
            
         });
        var classForSpinnerField = 'clsSpinnerField';
               
        if(Ext.isIE8){
            classForSpinnerField = 'clsSpinnerFieldIE8';
        }     
        var percentageField = new Ext.ux.form.SpinnerField({
             id: 'PercentageFieldId',
             xtype: 'spinnerfield',
             fieldLabel: 'Time in Percent',
             name: 'percentageField',
             minValue: 0,         
             maxValue: 100,
			 maxLength:3,
			 autoCreate: {tag: 'input', type: 'text', autocomplete: 'off', maxlength: '3'},
			 enableKeyEvents : true,
             value:0,
             width:30,
             allowDecimals: false,
			 incrementValue: 1,
             renderTo:'percentageFieldTD',
             listeners: {                
				keydown :function( obj, e) {
				 if(e.getKey()==109)
					 e.stopEvent();
				},
				keyup :function( obj, e) {
					validateSpinnerField(obj, e);
				}
            }
         });
         //percentageField.setValue(10);
         var dayField = new Ext.ux.form.SpinnerField({
            id: 'dayFieldId',
            name: 'dayFieldId',
            minValue: 00,         
            maxValue: 99,
			maxLength:2,
			autoCreate: {tag: 'input', type: 'text', autocomplete: 'off', maxlength: '2'},
            value:00,
            width:23,
            allowDecimals: false,
            renderTo:'dayFieldTD',
			enableKeyEvents : true,
            listeners: {
                spin: function() {
                 var duration = getDuration();
                 Ext.getCmp('durationTextFieldId').setValue(duration);
                },
				keydown :function( obj, e) {
				 if(e.getKey()==109)
					 e.stopEvent();
				},
				keyup :function( obj, e) {
					validateSpinnerField(obj, e);
					var duration = getDuration();
                             Ext.getCmp('durationTextFieldId').setValue(duration);
				}
            }               
         });
             
        var dayLabel = new Ext.form.Label({
            id:'dayLabelId',
            text:SLMSettingPage.Labels.Days,
            renderTo:'dayLabelTD'
        });
        var minLabel = new Ext.form.Label({
            id:'minLabelId',
            text:SLMSettingPage.Labels.Minutes,
            renderTo:'minLabelTD'
        });
        var perLabel = new Ext.form.Label({
            id:'perLabelId',
            text:'%',
            renderTo:'perLabelTD'
        });
        var hourLabel = new Ext.form.Label({
            id:'hourLabelId',
            text:SLMSettingPage.Labels.HoursLabel,
            renderTo:'hourLabelTD'
        });
         var hourField = new Ext.ux.form.SpinnerField({
             id: 'hourFieldId',
             xtype: 'spinnerfield',
             name: 'hourFieldId',
             minValue: 0,         
             maxValue: 23,
			 maxLength:2,
			 autoCreate: {tag: 'input', type: 'text', autocomplete: 'off', maxlength: '2'},
             value:0,
             cls:'spinnerFieldClass',
             allowDecimals: false,
             incrementValue: 1,
			 enableKeyEvents : true,
             renderTo:'hourFieldTD',
             width:23,
                listeners: {
                    spin: function() {
                     var duration = getDuration();
                     Ext.getCmp('durationTextFieldId').setValue(duration);
                    },
					keydown :function( obj, e) {
					 if(e.getKey()==109)
					 e.stopEvent();
					},
					keyup :function( obj, e) {
					validateSpinnerField(obj, e);
					var duration = getDuration();
                    Ext.getCmp('durationTextFieldId').setValue(duration);
				}
          
                 }              
         });
         var minuteField = new Ext.ux.form.SpinnerField({
             id: 'minuteFieldId',
             xtype: 'spinnerfield',
             name: 'minuteFieldId',
             minValue: 0,         
             maxValue: 59,
             value:0,
			 maxLength:2,
			autoCreate: {tag: 'input', type: 'text', autocomplete: 'off', maxlength: '2'},
             allowDecimals: false,
			 enableKeyEvents : true,
             incrementValue: 1,
             renderTo:'minuteFieldTD',
             width:23,             
                listeners: {
                    spin: function() {
                     var duration = getDuration();
                     Ext.getCmp('durationTextFieldId').setValue(duration);
                    },
					keydown :function( obj, e) {
					 if(e.getKey()==109)
					 e.stopEvent();
					},
					keyup :function( obj, e) {
					 validateSpinnerField(obj, e);
					 var duration = getDuration();
                     Ext.getCmp('durationTextFieldId').setValue(duration);
				   }
          
                 }              
         });
   
         
        Ext.getCmp('dayFieldId').hide();
        Ext.getCmp('hourFieldId').hide();
        Ext.getCmp('minuteFieldId').hide();
        Ext.getCmp('dayLabelId').hide();
        Ext.getCmp('hourLabelId').hide();
        Ext.getCmp('minLabelId').hide();
          function slmdata(grid, rowIndex, e) {
               
               selectedId = hiddendata.getAt(rowIndex).get('Id');
               Assignto1 = hiddendata.getAt(rowIndex).get('AppliesToObject');
              
               WarningDuration1 = hiddendata.getAt(rowIndex).get('WarningDuration'); 
               WarningPercentage1 = hiddendata.getAt(rowIndex).get('WarningPercentage');
               if (WarningPercentage1 == -1){
                  	TimeRemaining = SLMSettingPage.Labels.Time_Remaining;
                  	Ext.getCmp('dayFieldId').show();
	                Ext.getCmp('hourFieldId').show();
	                Ext.getCmp('hourLabelId').show();
	                Ext.getCmp('minuteFieldId').show();
	                Ext.getCmp('dayLabelId').show();
	                Ext.getCmp('minLabelId').show();
	                Ext.getCmp('perLabelId').hide();
	                Ext.getCmp('durationTextFieldId').show();
	                Ext.getCmp('durationTextFieldPanelId').hide();
	                Ext.getCmp('PercentageFieldId').hide();
	                document.getElementById('percentageFieldTD').style.display='none';
	                document.getElementById('perLabelTD').style.display='none';
	                document.getElementById('dayFieldTD').style.display='block';
	                document.getElementById('hourFieldTD').style.display='block';
	                document.getElementById('minuteFieldTD').style.display='block';
	                var numOfDays=0,numberOfDays, numOfHours=0, numberOfHours=0, numOfMinutes=1, TotalMin = WarningDuration1;
	                numberOfDays = ((TotalMin) / 1440); 
	                numOfDays = parseInt(numberOfDays);
					numberOfHours = ((TotalMin - (numOfDays * 1440)) / 60);
					numOfHours = parseInt(numberOfHours);
					numOfMinutes =parseInt( TotalMin - (numOfDays * 1440) - (numOfHours * 60));	                
	                dayField.setValue(numOfDays);
	                hourField.setValue(numOfHours);
	                minuteField.setValue(numOfMinutes);
					 var duration = getDuration();
                     Ext.getCmp('durationTextFieldId').setValue(duration);
					 percentageField.setValue(0);
					TimeRemainingCombo.setValue(TimeRemaining);				
	              
               }
               else if(WarningDuration1 == -1){
                  	TimeRemaining = SLMSettingPage.Labels.Percent_of_Time_Remaining;
					Ext.getCmp('dayFieldId').hide();
	                Ext.getCmp('hourFieldId').hide();
	                Ext.getCmp('hourLabelId').hide();
	                Ext.getCmp('minuteFieldId').hide();
	                Ext.getCmp('dayLabelId').hide();
	                Ext.getCmp('minLabelId').hide();
	                Ext.getCmp('perLabelId').show();
	                Ext.getCmp('durationTextFieldId').hide();
	                Ext.getCmp('durationTextFieldPanelId').show();
	                Ext.getCmp('PercentageFieldId').show();
	                document.getElementById('percentageFieldTD').style.display='block';
	                document.getElementById('perLabelTD').style.display='block';
	                document.getElementById('dayFieldTD').style.display='none';
	                document.getElementById('hourFieldTD').style.display='none';
	                document.getElementById('minuteFieldTD').style.display='none';
					dayField.setValue(0);
	                hourField.setValue(0);
	                minuteField.setValue(0);
					TimeRemainingCombo.setValue(TimeRemaining);					
                   }
                    
                
               
			    
               Priortity1 = hiddendata.getAt(rowIndex).get('Priority');
			   //when there are no records in priority object
			    if(PriorityListData=='none,none'){
				     if(Priortity1 ==''){
				        Priortity = 1;
				     }
				   var PriorityList = 'var PriorityListData = [';
			       	 PriorityList += '[\"'+Priortity1+'\",\"'+Priortity1+'\"],'; 
					 PriorityList += ']';
					 eval(PriorityList);
					 PriorityStore.loadData(PriorityListData);
					 				 
				}
				
                TargetType1 = hiddendata.getAt(rowIndex).get('TargetType');
               if(Priortity1!=''&& Priortity1!=null){
			       PriorityCombo.setValue(Priortity1);
	               priorityCheckbox.setValue(true);
	               prioChk = true;
              }else
               {
			     PriorityCombo.setValue( PriorityStore.getAt(0).get('Id'));
                 priorityCheckbox.setValue(false);
	             prioChk = false; 
               }
               //TimeRemaining = hiddendata.getAt(rowIndex).get('TimeRemainingLabel');
               AssignToCombo.setValue(Assignto1);
			   if(Assignto1 == change){
					TargetTypeStore.loadData(TargetTypeListDataForChangeRequest);
			   }else if(Assignto1 == inc){
					TargetTypeStore.loadData(TargetTypeListDataForIncident);
			   }if(Assignto1 == prob){
					TargetTypeStore.loadData(TargetTypeListDataForProblem);
			   }
			   
				TargetTypeCombo.setValue(TargetType1);			   
			   if(WarningPercentage1!=-1){
                 percentageField.setValue(WarningPercentage1);
               } 
			   else{
			     percentageField.setValue(0);
			   }
          }
        
        function UpdateHandle(){
            serviceTarget=AssignToCombo.getValue()+wherelabel+PriorityCombo.getValue();
           /*	if(TimeRemainingCombo.getValue() == 'Percent of Time Remaining'){
            	warningStatus=TargetTypeCombo.getValue()+' '+SLMSettingPage.Labels.AND+' '+SLMSettingPage.Labels.Percent_of_Time_Remaining +' = '+percentageField.getValue();
            }else{
				warningStatus=TargetTypeCombo.getValue()+' '+SLMSettingPage.Labels.AND+' '+SLMSettingPage.Labels.Time_Remaining +' = '+dayField.getValue()+hourField.getValue()+minuteField.getValue();            
            }*/
            update=1;
	    blankvalue = 0;
	    var record = SLMgrid.getSelectionModel().getSelected();
	    var idx = SLMgrid.store.indexOf(record);
	    blankvalue = newgridrender();
            eval(gridstring);
            eval(hiddengridstring);
            store.loadData(griddata); 
            hiddendata.loadData(hiddengriddata);
			if(blankvalue!=1){ /*if validationfails no reset*/
                            reset();
			}else{
			
			SLMgrid.getSelectionModel().selectRow(idx , true);
			
			}
		    update = 0;
        }   
        
        function Cancelhandle(){
	        
            eval(gridstring);
           eval(hiddengriddata);
           store.loadData(griddata); 
           hiddendata.loadData(hiddengriddata);
		   reset();
                     
           }
        
        function newgridrender(){
	           var incId = cnt;
	           var recordExists = 0;
			  // var blankvalue = 0;
			   var valinday = dayField.getValue() ;
			   var valinhr = hourField.getValue() ;
			   var valinmin = minuteField.getValue() ; 
	           minInField = dayField.getValue()*24*60+hourField.getValue()*60+minuteField.getValue();
			 
		         if(addClickedFlag == 1 ){
			              // alert('percentfieldvalue'+ percentageField.getValue());
						 
				   if (TimeRemainingCombo.getValue() == SLMSettingPage.Labels.Time_Remaining )
				 {   
				     if(valinday === ''|| valinhr === ''||valinmin === ''){
						 Ext.MessageBox.show({ msg:SLMSettingPage.Labels.EnterTime , buttons: Ext.MessageBox.OK});    
						 blankvalue = 1 ;
						 return blankvalue;
					 }
				    var iChars = "!@#$%^&*()+=-[]\\\';,./{}|\":<>?";

					  for (var i = 0; i < valinday.length; i++) {
					     
						if (iChars.indexOf(valinday.charAt(i)) != -1) {
						Ext.MessageBox.show({ msg:SLMSettingPage.Labels.EnterTime , buttons: Ext.MessageBox.OK}); 
						return blankvalue;
						}
                     }
					 
					  for (var i = 0; i < valinhr.length; i++) {
						if (iChars.indexOf(valinhr.charAt(i)) != -1) {
						  Ext.MessageBox.show({ msg:SLMSettingPage.Labels.EnterTime , buttons: Ext.MessageBox.OK});    
				          blankvalue = 1 ;
						  return blankvalue;
						}
                     }
					 
					  for (var i = 0; i < valinmin.length; i++) {
						if (iChars.indexOf(valinmin.charAt(i)) != -1) {
					       Ext.MessageBox.show({ msg:SLMSettingPage.Labels.EnterTime , buttons: Ext.MessageBox.OK});    
				           blankvalue = 1 ;
						return blankvalue;
						}
                     }
				}		  
			     if (TimeRemainingCombo.getValue() != SLMSettingPage.Labels.Time_Remaining &&percentageField.getValue() === '')
				 {    
				   Ext.MessageBox.show({ msg:SLMSettingPage.Labels.EnterPercentage , buttons: Ext.MessageBox.OK});    
				   blankvalue = 1 ;
				   return blankvalue ;
				
				}
			                 if (prioChk == true && blankvalue == 0){
							    								 
				                 for (var i= 0; i<=cnt;i++){
								            
					                    if (AssignToCombo.getValue()==AssignCombo1[i]&&PriorityCombo.getValue()==PrioCombo1[i]&&TargetTypeCombo.getValue()== TarGet1[i]&&IdArray1[i]!='removed'){
										     recordExists = 1;
											Ext.MessageBox.show({ msg:SLMSettingPage.Labels.Record_Exists , buttons: Ext.MessageBox.OK});
					                     }
				                
				                }
				              }  
			            
			                 else if(blankvalue == 0){ 
							       for (var i= 0; i<=cnt;i++){
								      
									 if (AssignToCombo.getValue()==AssignCombo1[i]&&TargetTypeCombo.getValue()== TarGet1 [i]&&prioChk == false&& PrioCombo1[i]==''&&IdArray1[i]!='removed'){
											recordExists = 1;
										 Ext.MessageBox.show({ msg:SLMSettingPage.Labels.Record_Exists , buttons: Ext.MessageBox.OK});
										}
									}
				              				                
				             }   
			                 if(recordExists==0 && blankvalue == 0){
									for (var i=cnt+1; i<=(cnt+1); i++){
										  incId++;
										  if(TimeRemainingCombo.getValue() == SLMSettingPage.Labels.Time_Remaining){
												minuteWarning[i] = dayField.getValue()*24*60+hourField.getValue()*60+minuteField.getValue();
												duration[i] = Ext.getCmp('durationTextFieldId').getValue();
												labelWarning[i] = SLMSettingPage.Labels.Time_Remaining;
												Warning[i] = -1;
										  }else{ 
										           
										       /* if (percentageField.getValue() !='')
												{ 
												  Warning[i] = percentageField.getValue();
												
												 }
												 else
												 {
												   Warning[i] = 0;
												 }*/
												Warning[i] = percentageField.getValue();
												minuteWarning[i] = -1;
												duration[i] = -1;
												labelWarning[i] = SLMSettingPage.Labels.Percent_of_Time_Remaining;	         		      	
										  }	 
										  AssignCombo1[i] = AssignToCombo.getValue();
										   if(prioChk == true){  
										    	prioChk == false ;
												if(PriorityCombo.getValue()=='none'){
												    PrioCombo1[i] = '' ;
												}
												 else{
													 
													  PrioCombo1[i] =  PriorityCombo.getValue();
													  }
										   }
											else
										  {
										   PrioCombo1[i] = '' ;
										  }
										  TarGet1 [i] = TargetTypeCombo.getValue();
										  IdArray1[i] ='tmpId'+incId;
									}
								   cnt++;
								   addClickedFlag = 0;
			               }
		          }
		          if (update == 1 && addClickedFlag == 0){
		           
                  /* Validations for blank & special characters */
			      if (TimeRemainingCombo.getValue() != SLMSettingPage.Labels.Time_Remaining && percentageField.getValue() === '')
				 {    
				   Ext.MessageBox.show({ msg:SLMSettingPage.Labels.EnterPercentage , buttons: Ext.MessageBox.OK});    
				   blankvalue = 1 ;
				   return blankvalue ;
				
				} 
				 if (TimeRemainingCombo.getValue() == SLMSettingPage.Labels.Time_Remaining )
				 {   
				     if(valinday === ''|| valinhr === ''||valinmin === ''){
						 Ext.MessageBox.show({ msg:SLMSettingPage.Labels.EnterTime , buttons: Ext.MessageBox.OK});    
						 blankvalue = 1 ;
						 return blankvalue ;
					 }
				    var iChars = "!@#$%^&*()+=-[]\\\';,./{}|\":<>?";

					  for (var i = 0; i < valinday.length; i++) {
					     
						if (iChars.indexOf(valinday.charAt(i)) != -1) {
						Ext.MessageBox.show({ msg:SLMSettingPage.Labels.EnterTime , buttons: Ext.MessageBox.OK}); 
						blankvalue = 1 ;
						return blankvalue ;
						}
                     }
					 
					  for (var i = 0; i < valinhr.length; i++) {
						if (iChars.indexOf(valinhr.charAt(i)) != -1) {
						  Ext.MessageBox.show({ msg:SLMSettingPage.Labels.EnterTime , buttons: Ext.MessageBox.OK});    
				          blankvalue = 1 ;
						  return blankvalue;
						}
                     }
					 
					  for (var i = 0; i < valinmin.length; i++) {
						if (iChars.indexOf(valinmin.charAt(i)) != -1) {
					       Ext.MessageBox.show({ msg:SLMSettingPage.Labels.EnterTime , buttons: Ext.MessageBox.OK});    
				           blankvalue = 1 ;
						return blankvalue;
						}
                     }
				}		  
		            if (prioChk == true &&  blankvalue == 0){
		               
			                for (var i= 0; i<=cnt;i++){
				                if (AssignToCombo.getValue()==AssignCombo1[i]&&PriorityCombo.getValue()==PrioCombo1[i]&&TargetTypeCombo.getValue()== TarGet1 [i]&&IdArray1[i]!='removed'&&IdArray1[i]!=selectedId)
				                 {   
				                     recordExists = 1;
				                     Ext.MessageBox.show({ msg:SLMSettingPage.Labels.Record_Exists , buttons: Ext.MessageBox.OK});
				                     }
				                 }
			        }
		              
		                 else if(blankvalue == 0){
		                 
			                  for (var i= 0; i<=cnt;i++){
				                    if(AssignToCombo.getValue()==AssignCombo1[i]&&TargetTypeCombo.getValue()== TarGet1 [i]&&prioChk == false && PrioCombo1[i]==''&&IdArray1[i]!='removed'&&IdArray1[i]!=selectedId)
				                      
				                    {
				                     recordExists = 1;
									 Ext.MessageBox.show({ msg:SLMSettingPage.Labels.Record_Exists , buttons: Ext.MessageBox.OK});
				                     }
				                  }
			               
			               	}		
			                
		                if(recordExists==0 &&  blankvalue == 0){  
		                  
			               for (var i=0; i<=(cnt); i++){
			                   if (selectedId == IdArray1[i]){ 
			                        
				                      AssignCombo1[i] = AssignToCombo.getValue();  
				                      if(prioChk == true){ 
				                      prioChk == false ;     
				                      PrioCombo1[i] =  PriorityCombo.getValue();
				                       }else
				                      {
				                        PrioCombo1[i] ='';
				                      }
				                      TarGet1 [i] = TargetTypeCombo.getValue();
			                      if(TimeRemainingCombo.getValue() == SLMSettingPage.Labels.Time_Remaining){
			                            
										minuteWarning[i] = dayField.getValue()*24*60+hourField.getValue()*60+minuteField.getValue();
										duration[i] = Ext.getCmp('durationTextFieldId').getValue();
										Warning[i] = -1;
										labelWarning[i] = SLMSettingPage.Labels.Time_Remaining;
			         		      }else{
										Warning[i] = percentageField.getValue(); 
										minuteWarning[i] = -1;
										duration[i] = -1 ;
										labelWarning[i] = SLMSettingPage.Labels.Percent_of_Time_Remaining;
									
				                   }   
			                }
			             } 
			          }     
		          }
		           gridstring = 'griddata = [';
		            for (var i=0; i <= (cnt); i++){
					var tempTargetType, tempAssignTo;
					if(TarGet1[i] == completion){
							tempTargetType = ctimejs;
					   }else if(TarGet1[i] == response){
							tempTargetType = resptimejs;							
					   } else if(TarGet1[i] == resolution){
							tempTargetType = resotimejs;	
					   }else if(TarGet1[i] == initiation){
							tempTargetType = inittimejs;	
					   }
						if(AssignCombo1[i] == change){
							tempAssignTo = changeLabel;
						} else if(AssignCombo1[i] == inc){
							tempAssignTo = incLabel;
						}else if(AssignCombo1[i] == prob){
							tempAssignTo = problemLabel;
						}
		             if(IdArray1[i]!='removed'){								  
			               if(PrioCombo1[i]!=''&& PrioCombo1[i]!=null){
			                if(labelWarning[i] == SLMSettingPage.Labels.Percent_of_Time_Remaining){
			                	gridstring += "['"+IdArray1[i]+"','"+tempAssignTo+wherelabel+PrioCombo1[i]+"','"+SLMSettingPage.Labels.TargetType+" "+SLMSettingPage.Labels.EqualTo+" "+tempTargetType+ " "+SLMSettingPage.Labels.AND+" " +labelWarning[i]+" = "+ Warning[i]+"%"+"'],";
			                }else{
			                	gridstring += "['"+IdArray1[i]+"','"+tempAssignTo+wherelabel+PrioCombo1[i]+"','"+SLMSettingPage.Labels.TargetType+" "+SLMSettingPage.Labels.EqualTo+" "+tempTargetType+" " +SLMSettingPage.Labels.AND+" "
								                  +labelWarning[i]+" = "+ duration[i]+"'],";
												  //+labelWarning[i]+" = "+ numOfDays+SLMSettingPage.Labels.Days+" "+numOfHours+numOfDays+SLMSettingPage.Labels.HoursLabel+" "+numOfMinutes+SLMSettingPage.Labels.Minutes+"'],";
			                }
			              }else{
			              	if(labelWarning[i] == SLMSettingPage.Labels.Percent_of_Time_Remaining){
			                	gridstring += "['"+IdArray1[i]+"','"+tempAssignTo+"','"+SLMSettingPage.Labels.TargetType+" "+SLMSettingPage.Labels.EqualTo+" "+tempTargetType+" "+SLMSettingPage.Labels.AND+" " +labelWarning[i]+" = "+ Warning[i]+"%"+"'],";
			                }else{
			                	gridstring += "['"+IdArray1[i]+"','"+tempAssignTo+"','"+SLMSettingPage.Labels.TargetType+" "+SLMSettingPage.Labels.EqualTo+" "+tempTargetType+" "+SLMSettingPage.Labels.AND+" "
								                   +labelWarning[i]+" = "+ duration[i]+"'],";
												  //+labelWarning[i]+" = "+ numOfDays+SLMSettingPage.Labels.Days+" "+numOfHours+numOfDays+SLMSettingPage.Labels.HoursLabel+" "+numOfMinutes+SLMSettingPage.Labels.Minutes+"'],";
			                }	
			                }
			            }    
			            } 
			           
		              gridstring += "]";
		          
		            gridstring = gridstring.replace('],]',']]');
		            var warningFlag = -1;
		             hiddengridstring  = 'hiddengriddata = [';
		           		 for (var i=0; i<=(cnt); i++){
		           		  if(IdArray1[i]!='removed'){
		           		if(labelWarning[i] == SLMSettingPage.Labels.Percent_of_Time_Remaining){  
		           		     
			        		hiddengridstring += "['"+IdArray1[i]+"','"+AssignCombo1[i]+"','"+Warning[i]+"','"+TarGet1[i]+"','"+PrioCombo1[i]+"','"+warningFlag+"'],";
			        	}else{
			        		   
			        		hiddengridstring += "['"+IdArray1[i]+"','"+AssignCombo1[i]+"','"+warningFlag+"','"+TarGet1[i]+"','"+PrioCombo1[i]+"','"+minuteWarning[i]+"'],";
			        	}
			          }
			        } 
			        
			          hiddengridstring += "]";
			          hiddengridstring = hiddengridstring.replace('],]',']]');
					  return 0;
			        
		}		   
           
        var durationTextField = new Ext.form.TextField({
            id:'durationTextFieldId',
            disabled:true,          
            renderTo:'durationTextFieldTD'                  
        }); 
        Ext.getCmp('durationTextFieldId').setVisible(false);
        var durationTextFieldPanel = new Ext.Panel({ 
            renderTo:'durationTextFieldTD',
            id:'durationTextFieldPanelId',          
            height: 22
            
        });                                 
            
            store = new Ext.data.SimpleStore({fields:[{name:'recordid'},{name:'ServiceTarget'},{name:'WarantyStatus'}]});
            
            newgridrender(); 
            
            eval(gridstring);
            
            store.loadData(griddata); 
            
                
                SLMgrid = new Ext.grid.GridPanel({
                	id:'SLMGridId',
                	store: store, 
					sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
                	columns: [
                		{id: 'Id', header: "Id",dataIndex: 'recordid',hidden:true},
                		{id: 'Service', header: SLMSettingPage.Labels.Service_Target, width:280, dataIndex: 'ServiceTarget'},
                		{id: 'Warning', header: SLMSettingPage.Labels.Warning_Status, width:440,dataIndex: 'WarantyStatus'}
                	],
                	stripeRows:false,
                	height : 300,
                	anchorSize: '100%',
        			width: 720,
        			sortable: false,
        			enableHdMenu:false,
                	renderTo:'GridPanel',
			        viewConfig: {
			                            forceFit: true
			                           
			                    } 
                });
        
          SLMgrid.on('rowclick', slmdata, this);
           function getText(){
				var records1 = Ext.getCmp('SLMGridId').getSelectionModel().getSelections();
				
				if(records1 == null||records1 == ''){
				  return 'ADD';
				}
				else 
				return 'Update';
        
        }
                                         
        var Buttontoolbar=new Ext.Toolbar({
        	id: 'ButtontoolbarId',
            renderTo:'ToolBarPanel',
            anchor:'100%',
            width: 720, 
            border:true,	
             items: [
             	{
             	xtype: 'button',
             	cls:'bgBtnGrey',
             	id:'addupdate',
             	text:SLMSettingPage.Labels.Add,
             	handler: function(){
			                 if(record == null|| record == ''){
			                       addNewSLMSetting(); 
			                 }else{ 
			                   UpdateHandle();
			                 }               
		          		}
		        },
		        {
		        xtype: 'button',
		        id:'cancel',
		        cls:'bgBtnGrey',
		        text: SLMSettingPage.Labels.Cancel,
		        disabled: true,
		        handler:Cancelhandle
		        },
                {
                xtype: 'button',
                id:'SLMremove',
                cls:'bgBtnGrey',
                text: SLMSettingPage.Labels.Remove,
                disabled: true ,
                handler:deleteSelectedRow
                }]
        });
            
       SLMgrid.getSelectionModel().on('selectionchange', function(selModel, row, e){
		    	
		    	 record = selModel.getSelected();
		    	if(record != 'undefined'){       
                    Ext.getCmp('addupdate').setText(SLMSettingPage.Labels.Update);
                    Ext.getCmp('cancel').enable();
                    Ext.getCmp('SLMremove').enable();
                }else{
                  Ext.getCmp('addupdate').setText(SLMSettingPage.Labels.Add);
                }
      });
            
          function addNewSLMSetting(){ 
		                blankvalue =0 ;
				addClickedFlag = 1;
				blankvalue = newgridrender();
				eval(gridstring);
				eval(hiddengridstring);
				store.loadData(griddata); 
				hiddendata.loadData(hiddengriddata);
				addClickedFlag = 0;
				if (blankvalue !=1){
			         	reset();
                                }
        } 
		function reset(){
		TargetTypeStore.loadData(TargetTypeListDataForIncident);
		TargetTypeCombo.setValue( TargetTypeStore.getAt(0).get('Id'));
        TimeRemainingCombo.setValue( TimeRemainingStore.getAt(0).get('Id'));
        PriorityCombo.setValue( PriorityStore.getAt(0).get('Id'));
        AssignToCombo.setValue(AppliesStore.getAt(0).get('Id'));
		
		dayField.setValue(0);
	    hourField.setValue(0);
	    minuteField.setValue(0);
		percentageField.setValue(0);
		priorityCheckbox.setValue(false);
	    prioChk = false; 
		Ext.getCmp('dayFieldId').hide();
		Ext.getCmp('hourFieldId').hide();
		Ext.getCmp('hourLabelId').hide();
		Ext.getCmp('minuteFieldId').hide();
		Ext.getCmp('dayLabelId').hide();
		Ext.getCmp('minLabelId').hide();
		Ext.getCmp('perLabelId').show();
		Ext.getCmp('durationTextFieldId').hide();
		Ext.getCmp('durationTextFieldPanelId').show();
		Ext.getCmp('PercentageFieldId').show();
		document.getElementById('percentageFieldTD').style.display='block';
		document.getElementById('perLabelTD').style.display='block';
		document.getElementById('dayFieldTD').style.display='none';
		document.getElementById('hourFieldTD').style.display='none';
		document.getElementById('minuteFieldTD').style.display='none';
		Ext.getCmp('addupdate').setText(SLMSettingPage.Labels.Add);
		 Ext.getCmp('cancel').disable();
		 Ext.getCmp('SLMremove').disable();
      }
          function deleteSelectedRow() {
	            for (var i=0; i<=(cnt); i++){
			                   if (IdArray1[i] == selectedId){
			                   	IdArray1[i] = 'removed';
			                   }  
					}
				
                     
	        //Reset ToolBar 
					   
				newgridrender();		 
	            eval(gridstring);
				eval(hiddengridstring);
				store.loadData(griddata); 
				hiddendata.loadData(hiddengriddata);
				reset();
			
				 
          }
          
           hiddendata = new Ext.data.Store({
            reader: new Ext.data.ArrayReader({}, [
                    {name: 'Id'},
                    {name: 'AppliesToObject'},
                    {name: 'WarningPercentage'},
                    {name: 'TargetType'},
                    {name: 'Priority'},
                    {name: 'WarningDuration'}
                 ])
          }); 
		  
         eval(hiddengridstring);   
         hiddendata.loadData(hiddengriddata); 
            
        
   
        // Milestone spinner Fields    
         
         MilestonehourField = new Ext.ux.form.SpinnerField({
             id: 'milestonehourFieldId',
             xtype: 'spinnerfield',
             name: 'milestonehourFieldId',
             minValue: 00,     
             autoCreate: {tag: 'input', type: 'text', autocomplete: 'off'},			 
             value:milestonedefaulthourvalue,
             cls:'spinnerFieldClass',
             allowDecimals: false,
             incrementValue: 1,
			 width:55,
             enableKeyEvents : true,
             renderTo:'milestonehourFieldTD',
                    listeners: {
                    
                    keydown :function( obj, e) {
                     if(e.getKey()==109)
					 e.stopEvent();
                    },
					keyup :function( obj, e) {
					validateSpinnerField(obj, e);
				  }
          
                 }       
               
         });
        
         milestoneminuteField = new Ext.ux.form.SpinnerField({
             id: 'milestoneminuteFieldId',
             xtype: 'spinnerfield',
             name: 'milestoneminuteFieldId',
             minValue: 0,         
             maxValue: 59,
			 maxLength:2,
			 autoCreate: {tag: 'input', type: 'text', autocomplete: 'off', maxlength: '2'},
             value:milestonedefaultminutevalue,
             allowDecimals: false,
             enableKeyEvents : true,
             incrementValue: 1,
             renderTo:'milestoneminuteFieldTD',
             width:55,             
                listeners: {
                   
                    keydown :function( obj, e) {
                     if(e.getKey()==109)
					 e.stopEvent();
                    },
					keyup :function( obj, e) {
					 validateSpinnerField(obj, e);
				   }
          
                 }              
         });
          
          milestoneButton = new Ext.Button({
             id: 'milestonebutton',
             name: 'milestonebutton',
             text:'',
             renderTo:'milestoneButtonTD',
			 width:200,
             handler: function(){
                        
                        if(milestoneButton.getText()==startbuttontext){
                        		Ext.getCmp('milestonebutton').setText(stopbuttontext);
								Ext.getCmp('milestonebutton').setDisabled(true);
                         		ScheduleJob();
                        }else{
                         	Ext.getCmp('milestonebutton').setText(startbuttontext);
							Ext.getCmp('milestonebutton').setDisabled(true);
                            StopJob();
                        }
                         
                         
                     }
         });   
        
        milestonedayField = new Ext.ux.form.SpinnerField({
            id: 'milestonedayFieldId',
            name: 'milestonedayFieldId',
            minValue: 01,         
            value:milestonedefaultdayvalue,
            width:55,
			autoCreate: {tag: 'input', type: 'text', autocomplete: 'off'},
            allowDecimals: false,
            renderTo:'milestonedayFieldTD',
            enableKeyEvents : true,
            listeners: {
                 keydown :function( obj, e) {
                 if(e.getKey()==109)
					 e.stopEvent();
                },
				keyup :function( obj, e) {
					validateSpinnerField(obj, e);
				}
            }               
         });

		//Checking Any scheduled job is running or not 
  
       	if(buttontext=='false')
       		Ext.getCmp('milestonebutton').setText(startbuttontext);
        else
			Ext.getCmp('milestonebutton').setText(stopbuttontext);
       		
       
       
        
        
        });
     
     