import { LightningElement , wire } from 'lwc';
import saveCaseLead from '@salesforce/apex/COH_LeadCaseCreation.saveCaseLead';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin }  from 'lightning/navigation';

import { getObjectInfo } from 'lightning/uiObjectInfoApi';
 
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
 
import Case_OBJECT from '@salesforce/schema/Case';
 
import Account_OBJECT from '@salesforce/schema/Account';

import Lead_OBJECT from '@salesforce/schema/Lead';

import Origin_FIELD from '@salesforce/schema/Case.Origin';
import Priority_FIELD from '@salesforce/schema/Case.Priority';
import Status_FIELD from '@salesforce/schema/Case.Status';
import InquiryType_FIELD from '@salesforce/schema/Case.Inquiry_Type__c';
import ClosedReason_FIELD from '@salesforce/schema/Case.Closed_Reason__c';
import duplicateLeadAcc from '@salesforce/apex/COH_LeadCaseCreation.dupeLeadAccount';
import State_FIELD from '@salesforce/schema/Account.COH_PA_State__c';
import Country_FIELD from '@salesforce/schema/Account.COH_PA_Country__c';
import PPN_FIELD from '@salesforce/schema/Account.Primary_Phone_Number__c';
import RFD_FIELD from '@salesforce/schema/Lead.Reason_for_Duplicate__c';
import L_SALUTATION_FIELD from '@salesforce/schema/Lead.Salutation';



import searchLeadAccount from '@salesforce/apex/COH_LeadCaseCreation.searchLeadAccount';
import getCases from '@salesforce/apex/COH_LeadCaseCreation.getCases';




export default class LightningExampleAccordionBasic extends NavigationMixin(LightningElement) {
   
    searchText = '';
    isNewFrom = false;
    isServer = false;
    checkVal = false;
    gender = '';
    city = '';
    street = '';
    country = '';
    province = '';
    postalCode = '';
    relationship = '';
    relationshipList = [];
    caseOrigin = 'Inbound Call';
    priority = 'Routine';
    reasonfordupe = '';
    status = '';
    ppnId = '';
    showInquiryType = false;
    inquiry = '';
    showClosedReason = false;
    isDuplicate = false;
    showAccount = false;
    showLead = false;
    accountList;
    selectedRecord;
    leadList;
    leadObject;
    caseObject;
    firstName ='';
    middleName='';
    mobile ='';
    home = '';
    other = '';
    email ='';
    lastName = '';
    dateOfBirth = '';
    duplicateComment = '';
    isCommentBox = false;
    showFrom = false;
    casesList = [];
    showCases = false;
    showNext = false;
    showPatientFrom =true;
    showClearButton = false;
    showDuplicates = false;
    salutation = '';
    



    @wire(getObjectInfo, { objectApiName: Case_OBJECT }) caseMD;

    @wire(getObjectInfo, { objectApiName: Account_OBJECT }) accountMD;

    @wire(getObjectInfo, { objectApiName: Lead_OBJECT }) leadMD;
    
 
    // now retriving the StageName picklist values of Case
 
    @wire(getPicklistValues,{
        recordTypeId: '$caseMD.data.defaultRecordTypeId', 
        fieldApiName: Origin_FIELD
    }) CaseOriginPicklist;

    @wire(getPicklistValues,{
        recordTypeId: '$caseMD.data.defaultRecordTypeId', 
        fieldApiName: Priority_FIELD
    }) CasePriorityPicklist;

    @wire(getPicklistValues,{
        recordTypeId: '$caseMD.data.defaultRecordTypeId', 
        fieldApiName: Status_FIELD
    }) CaseStatusPicklist;

    @wire(getPicklistValues,{
        recordTypeId: '$caseMD.data.defaultRecordTypeId', 
        fieldApiName: InquiryType_FIELD
    }) CaseInquiryPicklist;

    @wire(getPicklistValues,{
        recordTypeId: '$caseMD.data.defaultRecordTypeId', 
        fieldApiName: ClosedReason_FIELD
    }) CaseClosedReasonPicklist;

     @wire(getPicklistValues,{
        recordTypeId: '$accountMD.data.defaultRecordTypeId', 
        fieldApiName: State_FIELD
    }) AccountStatePicklist;

    @wire(getPicklistValues,{
        recordTypeId: '$accountMD.data.defaultRecordTypeId', 
        fieldApiName: Country_FIELD
    }) AccountCountryPicklist;

    @wire(getPicklistValues,{
        recordTypeId: '$leadMD.data.defaultRecordTypeId', 
        fieldApiName: RFD_FIELD
    }) LeadReasonForDupePicklist;


    @wire(getPicklistValues,{
        recordTypeId: '$accountMD.data.defaultRecordTypeId', 
        fieldApiName: PPN_FIELD
    }) AccountPPNPicklist;

    @wire(getPicklistValues,{
        recordTypeId: '$leadMD.data.defaultRecordTypeId', 
        fieldApiName: L_SALUTATION_FIELD
    }) LeadSalution;
    
    

    


    connectedCallback() {
       this.relationshipList = this.notSelfList;
       //this.showToast();
    }

    handleppnChange(event){
        this.ppnId = event.detail.value;
    }

    get ppnList(){
    if(this.AccountPPNPicklist.data)
        return this.AccountPPNPicklist.data.values;
    }

    get countryList(){
        if(this.AccountCountryPicklist.data)
        return this.AccountCountryPicklist.data.values;
    }

    get stateList(){
        if(this.AccountStatePicklist.data)
        return this.AccountStatePicklist.data.values;
    }

    get closedReasonList(){
        if(this.CaseClosedReasonPicklist.data)
        return this.CaseClosedReasonPicklist.data.values;
    }

    get salutationList(){
        if(this.LeadSalution.data){
            return this.LeadSalution.data.values;
        }
    }
    

    get inquiryList(){
        console.log('this.CaseInquiryPicklist.data',JSON.parse(JSON.stringify(this.CaseInquiryPicklist)))
        if(this.CaseInquiryPicklist.data){
            console.log('INQUIRY TYPE',this.CaseInquiryPicklist.data.values)
            return this.CaseInquiryPicklist.data.values;
        }
    }

    get priorityList(){
        if(this.CasePriorityPicklist.data)
        return this.CasePriorityPicklist.data.values;
    }

    get statusList(){
        if(this.CaseStatusPicklist.data)
        return this.CaseStatusPicklist.data.values;
    }


    get originList(){
        if(this.CaseOriginPicklist.data)
        return this.CaseOriginPicklist.data.values;
    }

    get reasonForDupeList(){
        console.log('LeadReasonForDupePicklist',JSON.parse(JSON.stringify(this.LeadReasonForDupePicklist.data)))
        if(this.LeadReasonForDupePicklist.data)
        return this.LeadReasonForDupePicklist.data.values;
         /*return [
            { label: '--None--', value: '' },
            { label: 'Male', value: 'Male' },
            { label: 'Female', value: 'Female' },
        ];*/
    }

    get genderlist() {
        return [
            { label: '--None--', value: '' },
            { label: 'Male', value: 'Male' },
            { label: 'Female', value: 'Female' },
             { label: 'Other', value: 'Other' },
        ];
    }

    get selfList(){
        return [
            { label: '--None--', value: '' },
            { label: 'Self', value: 'Self' },         
        ];
    }

    get notSelfList(){
        return [
            { label: '--None--', value: '' },
            { label: 'Caregiver', value: 'Caregiver' },    
            { label: 'Brother', value: 'Brother' },   
            { label: 'COH House Supervisor', value: 'COH House Supervisor' },   
            { label: 'COH Physician', value: 'COH Physician' },   
            { label: 'Daughter', value: 'Daughter' },   
            { label: 'Daughter / Son', value: 'Daughter / Son' },   
            { label: 'Domestic Partner', value: 'Domestic Partner' },  
             { label: 'Father', value: 'Father' },   
              { label: 'Insurance Plan', value: 'Insurance Plan' },   
               { label: 'Mother', value: 'Mother' },   
                { label: 'Other', value: 'Other' },   
                 { label: 'Parent', value: 'Parent' },   
                  { label: 'Physician / MD Office', value: 'Physician / MD Office' },   
            { label: 'Sister', value: 'Sister' },  
            { label: 'Sister / Brother', value: 'Sister / Brother' },  
            { label: 'Son', value: 'Son' },  
            { label: 'Spouse', value: 'Spouse' },  
            { label: 'Spouse / Domestic Partner', value: 'Spouse / Domestic Partner' }, 
            { label: 'Transfer Center', value: 'Transfer Center' },  
                  
        ];
    }

    handlePatientChangeServer(event){

        var patientName = event.detail.value;
        if(patientName){
            patientName = patientName.trim();
        }
        this.selectedRecord = undefined;
        this.showCases = false;
        this.casesList = [];
        this.showDuplicates = false;
        /*this.searchText = patientName;

        var patientName = this.searchText;
        if(patientName){
            patientName = patientName.trim();
        }*/
        if(patientName == undefined || patientName == '' || patientName == null){
            console.log('patientName blank')
            this.isDuplicate = false;
            this.showAccount = false;
            this.accountList = [];
            this.showLead = false;
            this.leadList = [];
           
        }else{
            this.showClearButton = false;  
            this.showFrom = false;
            this.showPatientFrom = true;
            //console.log('patientName before finding records',patientName)
            this.searchPatientRecords(patientName);
        }
        
        
    }

    handleEnter(event){
        console.log('event.keyCode ',event.keyCode )
        if(event.keyCode == 13){
            this.handlePatientChangeServer();
        }
    }

    handlePatientChange(event){
        var patientName = event.detail.value;
        if(patientName){
            patientName = patientName.trim();
        }
        this.searchText = patientName;
      
    }

    handleShowForm(){
        this.showFrom = true;
        this.showPatientFrom = false;
        this.isNewFrom = true;

        this.accountList = [];
        this.showAccount = false;
        this.leadList = [];
        this.showLead = false;
        this.selectedRecord = undefined;
        this.showCases = false;
        this.casesList = [];
        this.isDuplicate = false;
        this.showNext = false;
        this.showClearButton = false;

        this.firstName = undefined;
        this.lastName = undefined;
        this.middleName = undefined;
        this.dateOfBirth = undefined;
        this.ppnId = undefined;
        this.mobile = undefined;
        this.home = undefined
        this.other = undefined
        this.gender = undefined
        this.email = undefined
        this.city = undefined
        this.street = undefined
        this.country = undefined
        this.province = undefined
        this.postalCode = undefined
    }

    searchPatientRecords(patientName){
        this.isServer = true;
        console.log('patientName server',patientName)
        searchLeadAccount({
            patientName : patientName
        })
        .then(results=>{
            this.isServer = false;
            //console.log('RESULTS',results)
            console.log('Duplicate Lead Data',patientName ,JSON.parse(results));
            var dupeData = JSON.parse(results);
            if((dupeData.lead && dupeData.lead.length >0 ) || (dupeData.account && dupeData.account.length >0 ) ){
                this.isDuplicate = true;
                if(dupeData.account ){
                    if(dupeData.account.length>0){
                        var accList = dupeData.account;
                        for(var i= 0 ;i < accList.length;i++){
                            console.log('Original BirthDate',accList[i].Record.PersonBirthdate)
                            if(accList[i].Record.PersonBirthdate){
                                var birthdata = accList[i].Record.PersonBirthdate.split('-');
                                console.log('birthdata',birthdata)
                                accList[i].Record.PersonBirthdate = parseInt(birthdata[1])+'/'+parseInt(birthdata[2])+'/'+parseInt(birthdata[0]);
                            }
                            
                        }
                        this.accountList = accList;
                        this.showAccount = true;
                    }else{
                        this.accountList = [];
                        this.showAccount = false;
                    }
                }

                if(dupeData.lead){
                    if(dupeData.lead.length >0){
                        var accList = dupeData.lead;
                        for(var i= 0 ;i < accList.length;i++){
                            if(accList[i].Record.BirthDate__c){
                                var birthdata = accList[i].Record.BirthDate__c.split('-');
                                accList[i].Record.BirthDate__c = parseInt(birthdata[1])+'/'+parseInt(birthdata[2])+'/'+parseInt(birthdata[0]);
                            }
                            
                        }
                        this.leadList = accList;
                        this.showLead = true;
                    }else{
                        this.leadList = [];
                        this.showLead = false;
                    }
                }

            }else{
                this.accountList = [];
                this.showAccount = false;
                this.leadList = [];
                this.showLead = false;
                this.isDuplicate = false;
                this.selectedRecord = undefined;
                //this.saveCaseAndLead(leadrecord,caserecord,null);
            }
        }).catch(error=>{
            console.log('ERROR',error)
            this.isServer = false;
        });
    }

    showSuccessToast(message) {
        const event = new ShowToastEvent({
            title: 'Success',
            variant : 'success',
            message: message,
            mode: 'sticky'
        });
        this.dispatchEvent(event);
    }

    showErroToast(message) {
        const event = new ShowToastEvent({
            title: 'Error',
            variant : 'error',
            message: message
        });
        this.dispatchEvent(event);
    }

    /*validateAdress(){
        const address =
            this.template.querySelector('lightning-input-address');
        const isValid = address.checkValidity();
        address.reportValidity(); 
       return isValid;
    }*/



    validateInput(){
        return [...this.template.querySelectorAll('lightning-input')].reduce((validSoFar, inputField) => {               
           return validSoFar && inputField.reportValidity();
        }, true);
    }

    validateComboBox(){
        return [...this.template.querySelectorAll('lightning-combobox')].reduce((validSoFar, inputField) => {               
           return validSoFar && inputField.reportValidity();
        }, true); 
    }

    handleSaveForm() {

        if(!this.validateInput())
            return;

        //if(!this.validateAdress())
          //  return;

        if(!this.validateComboBox())
            return;

        var leadObj = new Object();
        var caseObj = new Object();
        var input = this.template.querySelectorAll("lightning-input");
        console.log('Checkbox',this.checkVal);
        var checkBoxData = this.checkVal;
        console.log('isServer',this.isServer)
        input.forEach(function(element){
            //console.log('element.name',element.name)
            //console.log('element.value',element.value)
            if(element.name == 'firstname'){
               leadObj.FirstName = element.value;
            }
            if(element.name == 'middename'){
                leadObj.MiddleName = element.value;
            }
            if(element.name == 'lastname'){
                leadObj.LastName = element.value;
            }
            if(element.name == 'birthdate'){
                leadObj.BirthDate__c = element.value;
            }
            if(element.name == 'mobilephone'){
                leadObj.MobilePhone = element.value;
            }
            if(element.name == 'email'){
                leadObj.Email = element.value;
            }
            if(element.name == 'primaryphone'){
                console.log('Primary Phone',element.value);
                //leadObj.Primary_Phone__c = element.value;
            }
            if(element.name == 'otherphone'){
                leadObj.Other_Phone__c = element.value;
            }
            if(element.name == 'homephone'){
                leadObj.Home_Phone__c = element.value;
            }
            /*if(element.name == 'gender'){
                leadObj.Gender__c = element.value;
            }*/

            if(element.name == 'callerfirstname'){
                caseObj.Caller_First_Name__c = element.value;
            }
            if(element.name == 'callerlastname'){
                caseObj.Caller_Last_Name__c = element.value;
            }
            if(element.name == 'sameaspatient'){
                caseObj.Caller_Same_as_Patient__c = checkBoxData;
            }
            if(element.name == 'callercallbacknumber'){
                caseObj.Primary_Callback_Number__c = element.value;
            }
           
           
            
            

         })

          var inputTextArea = this.template.querySelectorAll("lightning-textarea");
          inputTextArea.forEach(function(element){
               if(element.name == 'inquirynotes'){
                caseObj.Inquiry_Notes__c = element.value;
            }
          });

          console.log('inputTextArea',inputTextArea[0].value);

        leadObj.Salutation = this.salutation
        leadObj.Street = this.street;
        leadObj.City = this.city;
        leadObj.State = this.province;
        leadObj.PostalCode = this.postalCode;
        leadObj.Country = this.country;
        leadObj.Primary_Phone_Number__c = this.ppnId;
        leadObj.Gender__c = this.gender;
        
        caseObj.Caller_Relationship_to_Patient__c = this.relationship;
        caseObj.Origin = this.caseOrigin;
        caseObj.Priority = this.priority;
        caseObj.Status = this.status;
        caseObj.Inquiry_Type__c = this.inquiry;
        caseObj.Closed_Reason__c = this.closedreason;
  
        if(this.postalCode == undefined || this.postalCode == null || this.postalCode == ''){
            this.showErroToast('Postal Code is required');
            return; 
        }

        if(this.ppnId == 'Mobile'){
            if(leadObj.MobilePhone == undefined || leadObj.MobilePhone == null || leadObj.MobilePhone == ''){
                this.showErroToast('Mobile Number is required');
                return; 
            }
        }
        if(this.ppnId == 'Home'){
            if(leadObj.Home_Phone__c == undefined || leadObj.Home_Phone__c == null || leadObj.Home_Phone__c == ''){
                this.showErroToast('Home Number is required');
                return; 
            }
        }
        if(this.ppnId == 'Other'){
            if(leadObj.Other_Phone__c == undefined || leadObj.Other_Phone__c == null || leadObj.Other_Phone__c == ''){
                this.showErroToast('Other Number is required');
                return; 
            }
        }

       console.log('leadObj',leadObj);
       console.log('caseObj',caseObj);
        this.leadObject = leadObj;
        this.caseObject = caseObj;

        var selectedRecord = this.selectedRecord;
        var showDuplicates = this.showDuplicates;
        //var comment = this.duplicateComment;
        console.log('showDuplicates',showDuplicates);
        
        if(showDuplicates){
            if(selectedRecord = undefined || selectedRecord == null || selectedRecord == ''){
                this.isCommentBox = true;
                return;
            }
        }
        console.log('selectedRecord',selectedRecord)
        this.saveCaseAndLead(this.leadObject,this.caseObject,this.selectedRecord,this.duplicateComment);
        

      // this.duplicateleadAccount(leadObj,caseObj);
    }

    clearSelection(){
        this.selectedRecord = undefined;
        var radiobuttons = this.template.querySelectorAll('input');
        
        for(var k=0 ;k <radiobuttons.length ; k++){
           
            if(radiobuttons[k].type === 'radio'){ 
                radiobuttons[k].checked = false;
            }
            
        }

        this.showClearButton = false;
        this.showCases =false;
        this.casesList = [];
        this.showNext = false;
    }

    prepopulateForm(){
        
        //this.ppnId = 'Mobile';
        var accountList = this.accountList;
        var leadList = this.leadList;
        var selectedrec = this.selectedRecord;
        //var showform = false;
        if(accountList){
            for(var i =0 ;i<accountList.length;i++){
                var acc = accountList[i].Record;
                console.log('acc',acc)
                if(acc.Id == selectedrec){
                    //showform = true;
                    this.firstName = acc.FirstName;
                    this.lastName = acc.LastName;
                    this.middleName = acc.MiddleName;
                    console.log(' acc.PersonBirthdate', acc.PersonBirthdate);

                    if(acc.PersonBirthdate){
                        var dateofbirth = acc.PersonBirthdate.split("/");
                        var month = dateofbirth[0];
                        if(month.toString().length<2)
                        month = "0"+month;

                        var date = dateofbirth[1];
                        if(date.toString().length<2)
                        date = "0"+date;

                        var year = dateofbirth[2];

                        var modifedDate = year+'-'+month+'-'+date;
                        console.log('modifedDate',modifedDate)
                        this.dateOfBirth = modifedDate;
                    }
                   
                    this.salutation = acc.Salutation
                    this.ppnId = acc.Primary_Phone_Number__c;
                    this.mobile = acc.PersonMobilePhone;
                    this.home = acc.PersonHomePhone;
                    this.other = acc.PersonOtherPhone;
                    this.gender = acc.Gender__pc;
                    this.email = acc.PersonEmail;
                    this.city = acc.Patient_City__c;
                    this.street = acc.Patient_Street1__c;
                    this.country = acc.COH_PA_Country__c;
                    this.province = acc.COH_PA_State__c;
                    this.postalCode = acc.Patient_Postal_Code__c;
                    break;
                }
            }
        }
        if(leadList){
            for(var i =0 ;i<leadList.length;i++){
                var acc = leadList[i].Record;
                console.log('PREPOPULATE RECORD',acc)
                if(leadList[i].Record.Id == selectedrec){
                    this.firstName = acc.FirstName;
                    this.lastName = acc.LastName;
                    this.middleName = acc.MiddleName;
                    console.log(' acc.BirthDate__c', acc.BirthDate__c)
                    if(acc.BirthDate__c){
                        var dateofbirth = acc.BirthDate__c.split("/");
                        var month = dateofbirth[0];
                        if(month.toString().length<2)
                        month = "0"+month;

                        var date = dateofbirth[1];
                        if(date.toString().length<2)
                        date = "0"+date;

                        var year = dateofbirth[2];

                        var modifedDate = year+'-'+month+'-'+date;
                        console.log('modifedDate',modifedDate)
                        this.dateOfBirth = modifedDate;
                    }

                    this.salutation = acc.Salutation
                    this.ppnId = acc.Primary_Phone_Number__c;
                    this.mobile = acc.MobilePhone;
                    this.home = acc.Home_Phone__c;
                    this.other = acc.Other_Phone__c;
                    this.gender = acc.Gender__c;
                    this.email = acc.Email;
                    this.city = acc.City;
                    this.street = acc.Street;
                    this.country = acc.Country;
                    this.province = acc.State;
                    this.postalCode = acc.PostalCode;
                    break;
                }
            }
        }
        this.showFrom = true;
        this.casesList = [];
        this.showCases = false;
        this.showNext = false;
        this.showAccount = false;
        this.showLead = false;
        this.accountList = [];
        this.leadList = [];
        this.showClearButton = false;
        this.isDuplicate = false;
        this.showPatientFrom = false;
    }

    handleComments(event){
        this.duplicateComment = event.detail.value;
    }

    handleAddressChange(event){


        this.street = event.target.street;
        this.city = event.target.city;
        this.province = event.target.province;
        this.country = event.target.country;
        this.postalCode = event.target.postalCode;

    }

    closeModal(){
        console.log('CLOSE MODAL')
        this.isCommentBox = false;
        this.duplicateComment = undefined;
        //this.selectedRecord = undefined;
    }

    duplicateleadAccount(leadrecord , caserecord){
        this.isServer = true;
        duplicateLeadAcc({
            leadRec : leadrecord,
            caseRec : caserecord
        })
        .then(results=>{
            this.isServer = false;
            console.log('RESULTS',results)
            console.log('Duplicate Lead Data',JSON.parse(results));
            var dupeData = JSON.parse(results);
            if((dupeData.lead && dupeData.lead.length >0 ) || (dupeData.account && dupeData.account.length >0 ) ){
                this.showDuplicates = true;
                if(dupeData.account && dupeData.account.length >0){
                    var accList = dupeData.account;
                    for(var i= 0 ;i < accList.length;i++){
                        if(accList[i].Record.PersonBirthdate){
                            var birthdata = accList[i].Record.PersonBirthdate.split('-');
                            accList[i].Record.PersonBirthdate = parseInt(birthdata[1])+'/'+parseInt(birthdata[2])+'/'+parseInt(birthdata[0]);
                        }
                        
                    }
                    this.accountList = accList;
                    this.showAccount = true;
                }

                if(dupeData.lead && dupeData.lead.length >0){
                    var accList = dupeData.lead;
                    for(var i= 0 ;i < accList.length;i++){
                        if(accList[i].Record.BirthDate__c){
                            var birthdata = accList[i].Record.BirthDate__c.split('-');
                            accList[i].Record.BirthDate__c = parseInt(birthdata[1])+'/'+parseInt(birthdata[2])+'/'+parseInt(birthdata[0])
                        }
                        
                    }
                    this.leadList = accList;
                    this.showLead = true;
                }

            }else{
                this.accountList = [];
                this.showAccount = false;
                this.leadList = [];
                this.showLead = false;
                this.showDuplicates = false;
                this.selectedRecord = undefined;
                //this.saveCaseAndLead(leadrecord,caserecord,null);
            }
        }).catch(error=>{
            console.log('ERROR',error)
            this.isServer = false;
        });
    }
    updateRecord(){
        console.log('COMMENT',this.reasonfordupe);
        this.saveCaseAndLead(this.leadObject,this.caseObject,this.selectedRecord,this.reasonfordupe);
    }

    storeSelectedRec(event){
        console.log('Selected Record',event.target.id);
        var splitId = event.target.id.split('-');
        console.log('splitId',splitId)
        this.selectedRecord = splitId[0];
        this.getcases(this.selectedRecord);
        this.showNext = true;
        this.showClearButton = true;
       // this.objectType = event.target.objectname;
    }

    storeSelectedDupeRec(event){
        console.log('Selected Record',event.target.id);
        var splitId = event.target.id.split('-');
        console.log('splitId',splitId)
        this.selectedRecord = splitId[0];
        this.getcases(this.selectedRecord);
        //this.showNext = true;
        this.showClearButton = true;
    }

    getcases(recordId){
        this.isServer = true;
        getCases({
            recordId : recordId
        })
        .then(results=>{
            console.log('results',results);
           
            this.isServer = false;
            if(results.length>0){
                this.showCases = true;
            }
            for(var i=0 ;i <results.length;i++){
                results[i].url = '/'+results[i].Id;
            }
            this.casesList = results;
           
        }).catch(error=>{
            this.isServer = false;
            this.showErroToast(error.body.message) 
        });
    }
    

    saveCaseAndLead(leadrecord , caserecord ,  recordId,comments){
        this.isServer = true;
        saveCaseLead({
            leadRec : leadrecord,
            caseRec : caserecord,
            recordId : recordId,
            comment : comments
        })
        .then(results=>{
            console.log('results',results);
            this.showSuccessToast('Record Saved Successfully');
            this.isServer = false;
            this[NavigationMixin.GenerateUrl]({
            type: 'standard__recordPage',
            attributes: {
                recordId: results,
                actionName: 'view',
            },
            }).then((url) => {
                window.location.replace(url);
                console.log('url',url)
            });
        }).catch(error=>{
            this.isServer = false;
            this.showErroToast(error.body.message) 
        });
    }

    handleCheckbox(event){
        console.log(event.target.checked);
        this.checkVal = event.target.checked;
        if(this.checkVal){
            this.relationshipList = this.selfList;
        }else{
            this.relationshipList = this.notSelfList;
        }
        this.relationship = '';
    }

    handleChange(event){
        this.gender = event.detail.value;
        this.validateDupeRecords(this.firstName,this.lastName,this.gender,this.dateOfBirth);
    }

    handleSalutationChange(event){
        this.salutation = event.detail.value;
    }

    handleFirstNameChange(event){
        this.firstName = event.detail.value;
        this.validateDupeRecords(this.firstName,this.lastName,this.gender,this.dateOfBirth);
    }

    handleLastNameChange(event){
        this.lastName = event.detail.value;
        this.validateDupeRecords(this.firstName,this.lastName,this.gender,this.dateOfBirth);
    }

    handleDOBChange(event){
        console.log('Date of Birth',event.detail.value)
        this.dateOfBirth = event.detail.value;
        this.validateDupeRecords(this.firstName,this.lastName,this.gender,this.dateOfBirth);
    }


    validateDupeRecords(firstName,lastName,gender,dateOfBirth){
        if(firstName == undefined || firstName == '' || firstName == null||
        lastName == undefined || lastName == '' || lastName == null||
        gender == undefined || gender == '' || gender == null||
        dateOfBirth == undefined || dateOfBirth == '' || dateOfBirth == null){
            
        }else{
            var leadObj = new Object();
            leadObj.FirstName = firstName;
            leadObj.LastName = lastName;
            leadObj.Gender__c = gender;
            leadObj.BirthDate__c = dateOfBirth;
            console.log('LEADOBJ',leadObj);
            this.duplicateleadAccount(leadObj,null);
        }
    }

    

    handeRelationshipChange(event){
        this.relationship = event.detail.value;
    }

    handleOriginChange(event){
        this.caseOrigin = event.detail.value;
    }

    handlePriorityChange(event){
        this.priority = event.detail.value;
    }

    handleReasonFordupe(event){
        this.reasonfordupe = event.detail.value;
    }

    handleStatusChange(event){
        var statusValue = event.detail.value;
        this.status = statusValue;

        if(statusValue.includes('Closed')){
            this.showClosedReason = true
        }else{
            this.showClosedReason = false;
            this.closedreason = '';
        }

        if(statusValue == 'Inquiry'){
            this.showInquiryType = true;
        }else{
            this.showInquiryType = false;
            this.inquiry = '';
        }
    }

    handleInquiryChange(event){
        this.inquiry = event.detail.value;
    }

    handleReasonChange(event){
        this.closedreason = event.detail.value;

    }
  
}