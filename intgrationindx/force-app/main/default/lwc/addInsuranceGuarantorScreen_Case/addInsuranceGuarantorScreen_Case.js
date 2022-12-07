//Created by Syeda Jafri for NewPatientIntegration.
// on Date- 02-Nov-2022
import { LightningElement, track, wire, api } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import EPIC_ACCOUNT_DATA_OBJECT from '@salesforce/schema/Epic_Account_Data__c';
import createEpicRecord from '@salesforce/apex/epicAccountDataController.createEpicRecord';
import getAccountDetails from '@salesforce/apex/epicAccountDataController.getAccountDetails';
import updateEpicRecord from '@salesforce/apex/epicAccountDataController.updateEpicRecord';
import getEpicRecordDetails from '@salesforce/apex/epicAccountDataController.getEpicRecordDetails';
import verifyCreateEpicMRNButton from '@salesforce/apex/COHEpicLightningController.verifyAccountCreateEpicMRNButton';
import createNewEpicRecord from '@salesforce/apex/COHEpicLightningController.createNewEpicRecordViaAccount';
import validateForms from '@salesforce/apex/COHEpicLightningController.ValidateForms';

import SELF_PAY from '@salesforce/schema/Case.Account.Self_Pay__c';
import ACCOUNT_ID from '@salesforce/schema/Case.AccountId';
import PATIENT_RELATIONSHIP_TO_SUBSCRIBER_1 from '@salesforce/schema/Epic_Account_Data__c.Patient_Relationship_to_Subscriber_1__c';
import INSURANCE_GENDER_1 from '@salesforce/schema/Epic_Account_Data__c.Insurance_Gender_1__c';
import INSURANCE_STATE_1 from '@salesforce/schema/Epic_Account_Data__c.Insurance_State_1__c';
import INSURANCE_COUNTRY_1 from '@salesforce/schema/Epic_Account_Data__c.Insurance_Country_1__c';
import GuARANTOR_TYPE from '@salesforce/schema/Epic_Account_Data__c.Guarantor1_Type__c';
import PATIENT_RELATIONSHIP_TO_GuARANTOR_1 from '@salesforce/schema/Epic_Account_Data__c.Guarantor1_Patient_Relationship_to__c';

const fields = [ACCOUNT_ID,SELF_PAY];

export default class AddInsuranceGuarantorScreen extends LightningElement {
    @api accountId;

    @wire(getRecord, { recordId: '$recordId', fields })
    case;

   
    @api recordId;
    @track removeObj;
    patientRelationshipPicklist = '';
    guarantorRelationshipPicklist='';
    genderPicklist = '';
    statePicklist = '';
    countryPicklist = '';
    accountRecord = '';
    guarantorTypePicklist='';
    activeTab = 'PatientInfo';
    insuranceNumber = 'Primary';
    isDisabledInsuranceButton = true;
    disableUpdateButton=true;
    epicRecordId='';
    displayingInsuranceNumber='';

    disableNextButton=true;
    disablePrevButton=true;
    primaryInsuranceAdded=false;
    secondaryInsuranceAdded=false;
    tertiaryInsuranceAdded=false;

    //Patient1 fields
    epicAccountRecord = new Object();

    patientRelationshiptoSub1 = '';
    firstName1 = '';
    lastName1 = '';
    middleName1 = '';
    gender1 = '';
    birthdate1 = '';
    socialsecuritynumber1 = '';
    subscriberStreetAddress1 = '';
    subscribercity1 = '';
    subscriberstate1 = '';
    subscriberzip1 = '';
    subscribercountry1 = '';
    insurancePlan1 = '';
    subscriberId1 = '';
    memberId1 = '';
    groupNumber1 = '';
    authorizationNumber1 = '';
    effectiveFrom1 = '';
    originalReferringProvider1 = '';

    //Guarantor fields
    patientRelationshipToGuarantor = '';
    streetGuarantor = '';
    guarantorType = '';
    cityGuarantor = '';
    firstNameGuarantor = '';
    stateGuarantor = '';
    zipCodeGuarantor = '';
    lastNameGuarantor = '';
    countryGuarantor = '';
    SSNGuarantor = '';
    homePhoneGuarantor = '';
    genderGuarantor = '';
    mobilePhoneGuarantor = '';
    birthDateGuarantor = '';
    middleNameGuarantor='';
    mrnDisabled = false;
    showErrorMessage = '';
    showinsurance=true;
    columns = [
    { label: 'Sequence', fieldName: 'Sequence' },
    { label: 'Name', fieldName: 'Name' },
    { label: 'Relationship', fieldName: 'RelationShip' } ,
    { label: 'Subscriber', fieldName: 'Subscriber' } ,
    { label: 'Group', fieldName: 'Group' } 
     
    ];
    guarantorColumns = [
        { label: 'Sequence', fieldName: 'Sequence' },
        { label: 'Type', fieldName: 'Type' },
        { label: 'Name', fieldName: 'Name' },
        
    ];
    insuranceData = [];
    guarantorList = [];

    get caseAccountId() {
        return getFieldValue(this.case.data, ACCOUNT_ID);
    }


    // getting the object info
    @wire(getObjectInfo, { objectApiName: EPIC_ACCOUNT_DATA_OBJECT })
    epicAccountDataMetadata;
    // getting the picklist values

    @wire(getPicklistValues,
        {
            recordTypeId: '$epicAccountDataMetadata.data.defaultRecordTypeId',
            fieldApiName: PATIENT_RELATIONSHIP_TO_SUBSCRIBER_1
        }
    )
    patientRelationshipPicklist;

    @wire(getPicklistValues,
        {
            recordTypeId: '$epicAccountDataMetadata.data.defaultRecordTypeId',
            fieldApiName: INSURANCE_GENDER_1
        }
    )
    genderPicklist;

    @wire(getPicklistValues,
        {
            recordTypeId: '$epicAccountDataMetadata.data.defaultRecordTypeId',
            fieldApiName: INSURANCE_STATE_1
        }
    )
    statePicklist;

    @wire(getPicklistValues,
        {
            recordTypeId: '$epicAccountDataMetadata.data.defaultRecordTypeId',
            fieldApiName: INSURANCE_COUNTRY_1
        }
    )
    countryPicklist;

@wire(getPicklistValues,
        {
            recordTypeId: '$epicAccountDataMetadata.data.defaultRecordTypeId',
            fieldApiName: GuARANTOR_TYPE
        }
    )
    guarantorTypePicklist;
@wire(getPicklistValues,
        {
            recordTypeId: '$epicAccountDataMetadata.data.defaultRecordTypeId',
            fieldApiName: PATIENT_RELATIONSHIP_TO_GuARANTOR_1
        }
    )
    guarantorRelationshipPicklist;

    handleAccountSelection(event) {
        this.originalReferringProvider1 = event.detail;
        console.log("the selected record id is" + event.detail);
    }
  
    handlePayerSelection(event) {
        this.insurancePlan1 = event.detail;
        console.log("the selected record id is" + event.detail);
    }
//ConnectedCallback

handleSelfPay(event){
    console.log('event.detail',event.detail)
    this.showinsurance = event.detail;
}

 connectedCallback(){
console.log('this.caseAccountId ',this.recordId )
        getEpicRecordDetails({ ObjRecId: this.recordId })
        .then(result => {
            console.log('result getEpicRecordDetails case',result)
            //if(!this.isEmptyObject(result)){
                this.epicAccountRecord = result;
                if(this.epicAccountRecord){
                    this.epicRecordId=this.epicAccountRecord.Id;
                    var insuranceList = [];
                    this.getFirstInsurance();
                    if(result.hasOwnProperty('Patient_Relationship_to_Subscriber_1__c')){
                        this.primaryInsuranceAdded=true;
                        let primary = new Object();
                        primary['Sequence'] = 'Primary';
                        primary['RelationShip'] = this.epicAccountRecord.Patient_Relationship_to_Subscriber_1__c;
                        primary['Name'] = this.epicAccountRecord.Insurance_Purchaser_Plan_1__r?.Name ;
                        primary['Group'] = this.epicAccountRecord.Group_Number_1_c__c;
                        primary['Subscriber'] = this.epicAccountRecord.Subscriber_ID_1__c;
                        insuranceList.push(primary);
                    }
                    if(result.hasOwnProperty('Patient_Relationship_to_Subscriber_2__c')){
                        this.disableNextButton=false;
                        this.secondaryInsuranceAdded=true;
                        let secondary = new Object();
                        secondary['Sequence'] = 'Secondary';
                        secondary['RelationShip'] = this.epicAccountRecord.Patient_Relationship_to_Subscriber_2__c;
                        secondary['Name'] = this.epicAccountRecord.Insurance_Purchaser_Plan_2__r?.Name ;
                                              
                        secondary['Group'] = this.epicAccountRecord.Group_Number_2_c__c;
                        secondary['Subscriber'] = this.epicAccountRecord.Subscriber_ID_2__c;
                        insuranceList.push(secondary);
                    }else{
                            this.isDisabledInsuranceButton=false;
                    }
                    if(result.hasOwnProperty('Patient_Relationship_to_Subscriber_3__c')){
                        this.tertiaryInsuranceAdded=true;
                        let tertiary = new Object();
                        tertiary['Sequence'] = 'Tertiary';
                        tertiary['RelationShip'] = this.epicAccountRecord.Patient_Relationship_to_Subscriber_3__c;
                        tertiary['Name'] = this.epicAccountRecord.Insurance_Purchaser_Plan_3__r?.Name ;
                                              
                        tertiary['Group'] = this.epicAccountRecord.Group_Number_3_c__c;
                        tertiary['Subscriber'] = this.epicAccountRecord.Subscriber_ID_3__c;
                        insuranceList.push(tertiary);
                    }

                    console.log('insuranceList',insuranceList)

                    this.insuranceData = insuranceList;

                    if(result.hasOwnProperty('Guarantor1_Patient_Relationship_to__c')){
                        let guarantorArr = [];
                        let guarantor = new Object();
                        guarantor['Sequence'] = 'Primary';
                        guarantor['Type'] =  this.epicAccountRecord.Guarantor1_Type__c;
                        guarantor['Name'] = this.epicAccountRecord.Guarantor1_FirstName__c +' '
                                              this.epicAccountRecord.Guarantor1_MiddleName__c +  ' '
                                              this.epicAccountRecord.Guarantor1_LastName__c ;
                                              guarantorArr.push(guarantor);
                                              this.guarantorList = guarantorArr;
                    }

                    this.disableUpdateButton = false;
                    this.patientRelationshipToGuarantor = result.Guarantor1_Patient_Relationship_to__c;
                    this.streetGuarantor = result.Guarantor1_Street__c;
                    this.guarantorType = result.Guarantor1_Type__c;
                    this.firstNameGuarantor = result.Guarantor1_FirstName__c;
                    this.cityGuarantor = result.Guarantor1_City__c;
                    this.stateGuarantor = result.Guarantor1_State__c;
                    this.zipCodeGuarantor = result.Guarantor1_PostalCode__c;

                    this.zipCodeGuarantor = result.Guarantor1_PostalCode__c;
                    this.lastNameGuarantor = result.Guarantor1_LastName__c;
                    this.countryGuarantor = result.Guarantor1_Country__c;
                    this.SSNGuarantor = result.Guarantor1_SSN__c;
                    this.homePhoneGuarantor = result.Guarantor1_Home_Phone__c;
                    this.workPhoneGuarantor = result.Guarantor1_Work_Phone__c;

                    this.mobilePhoneGuarantor = result.Guarantor1_Mobile_Phone__c;
                    this.birthDateGuarantor = result.Guarantor1_Birth_Date__c;
                    this.genderGuarantor = result.Guarantor1_Gender__c;
                    this.middleNameGuarantor = result.Guarantor1_MiddleName__c;

                    
                }
                
               // }
                console.log('resultgetdata : ' , JSON.stringify(this.epicAccountRecord));

        })
        .catch((error) =>{
            console.log('ERROR')
             //alert("error1: " + JSON.stringify(error))
        });
    }  
    renderedCallback(){
        console.log('RENDER')
        console.log('getFieldValue(this.case.data, SELF_PAY)',getFieldValue(this.case.data, SELF_PAY))
                        this.showinsurance = getFieldValue(this.case.data, SELF_PAY);
    }
    isEmptyObject(obj){
        return JSON.stringify(obj) === '{}';
    }

    fetchInsuranceTab(){
        getEpicRecordDetails({ ObjRecId: this.caseAccountId })
        .then(result => {
            console.log('result',result)
            //if(!this.isEmptyObject(result)){
                if(result){
                    this.epicRecordId=result.Id;
                    var insuranceList = [];
                    if(result.hasOwnProperty('Patient_Relationship_to_Subscriber_1__c')){
                        
                        let primary = new Object();
                        primary['Sequence'] = 'Primary';
                        primary['RelationShip'] = result.Patient_Relationship_to_Subscriber_1__c;
                        primary['Name'] = result.Insurance_Purchaser_Plan_1__r?.Name;
                        primary['Group'] = result.Group_Number_1_c__c;
                        primary['Subscriber'] = result.Subscriber_ID_1__c;
                        insuranceList.push(primary);
                    }
                    if(result.hasOwnProperty('Patient_Relationship_to_Subscriber_2__c')){
     
                        let secondary = new Object();
                        secondary['Sequence'] = 'Secondary';
                        secondary['RelationShip'] = result.Patient_Relationship_to_Subscriber_2__c;
                        secondary['Name'] = result.Insurance_Purchaser_Plan_2__r?.Name;                      
                        secondary['Group'] = result.Group_Number_2_c__c;
                        secondary['Subscriber'] = result.Subscriber_ID_2__c;
                        insuranceList.push(secondary);
                    }
                    if(result.hasOwnProperty('Patient_Relationship_to_Subscriber_3__c')){
                       
                        let tertiary = new Object();
                        tertiary['Sequence'] = 'Tertiary';
                        tertiary['RelationShip'] = result.Patient_Relationship_to_Subscriber_3__c;
                        tertiary['Name'] = result.Insurance_Purchaser_Plan_3__r?.Name;
                                              
                        tertiary['Group'] = result.Group_Number_3_c__c;
                        tertiary['Subscriber'] = result.Subscriber_ID_3__c;
                        insuranceList.push(tertiary);
                    }
                    if(result.hasOwnProperty('Patient_Relationship_to_Subscriber_3__c')){
                        let guarantorArr = [];
                        let guarantor = new Object();
                        guarantor['Sequence'] = 'Primary';
                        guarantor['Type'] =  result.Guarantor1_Type__c;
                        guarantor['Name'] = result.Guarantor1_FirstName__c +' '
                                              result.Guarantor1_MiddleName__c +  ' '
                                              result.Guarantor1_LastName__c ;
                                              guarantorArr.push(guarantor);
                                              this.guarantorList = guarantorArr;
                    }

                    console.log('insuranceList',insuranceList)

                    this.insuranceData = insuranceList;

                     if(result.hasOwnProperty('Guarantor1_Patient_Relationship_to__c')){
                        let guarantorArr = [];
                        let guarantor = new Object();
                        guarantor['Sequence'] = 'Primary';
                        guarantor['Type'] =  this.epicAccountRecord.Guarantor1_Type__c;
                        guarantor['Name'] = this.epicAccountRecord.Guarantor1_FirstName__c +' '
                                              this.epicAccountRecord.Guarantor1_MiddleName__c +  ' '
                                              this.epicAccountRecord.Guarantor1_LastName__c ;
                                              guarantorArr.push(guarantor);
                                              this.guarantorList = guarantorArr;
                    }
                        
                }
               // }
                console.log('resultgetdata : ' , JSON.stringify(result));

        })
        .catch((error) =>{
             //alert("error1: " + JSON.stringify(error))
        });
    }

    // Data setup
    handleChange(event) {
        const field = event.target.name;
        console.log('field',field)
        if (field === 'patientRelationshiptoSub1') {
            this.patientRelationshiptoSub1 = event.target.value;
            console.log('this.patientRelationshiptoSub1',this.patientRelationshiptoSub1)
            if(this.patientRelationshiptoSub1==='Self'){
                console.log('Self')
                 this.handleCopyPatienteButton();
            }
        } else if (field === 'firstName1') {
            this.firstName1 = event.target.value;
        } else if (field === 'lastName1') {
            this.lastName1 = event.target.value;
        } else if (field === 'middleName1') {
            this.middleName1 = event.target.value;
        } else if (field === 'gender1') {
            this.gender1 = event.target.value;
        } else if (field === 'birthdate1') {
            this.birthdate1 = event.target.value;
        } else if (field === 'socialsecuritynumber1') {
            this.socialsecuritynumber1 = event.target.value;
        } else if (field === 'subscriberStreetAddress1') {
            this.subscriberStreetAddress1 = event.target.value;
        } else if (field === 'subscribercity1') {
            this.subscribercity1 = event.target.value;
        } else if (field === 'subscriberstate1') {
            this.subscriberstate1 = event.target.value;
        } else if (field === 'subscriberzip1') {
            this.subscriberzip1 = event.target.value;
        } else if (field === 'subscribercountry1') {
            this.subscribercountry1 = event.target.value;
        } else if (field === 'insurancePlan1') {
            this.insurancePlan1 = event.target.value;
        } else if (field === 'subscriberId1') {
            this.subscriberId1 = event.target.value;
        } else if (field === 'memberId1') {
            this.memberId1 = event.target.value;
        } else if (field === 'groupNumber1') {
            this.groupNumber1 = event.target.value;
        } else if (field === 'authorizationNumber1') {
            this.authorizationNumber1 = event.target.value;
        } else if (field === 'effectiveFrom1') {
            this.effectiveFrom1 = event.target.value;
        } 
        // Guarantor fields
        else if (field === 'patientRelationshipToGuarantor') {
             this.patientRelationshipToGuarantor = event.target.value;
            if(this.patientRelationshipToGuarantor==='Self'){
                 this.handleCopyPatienteButtoGuarantor();
            }
        
        } else if (field === 'streetGuarantor') {
            this.streetGuarantor = event.target.value;
        } else if (field === 'guarantorType') {
            this.guarantorType = event.target.value;
        } else if (field === 'cityGuarantor') {
            this.cityGuarantor = event.target.value;
        } else if (field === 'firstNameGuarantor') {
            this.firstNameGuarantor = event.target.value;
        } else if (field === 'stateGuarantor') {
            this.stateGuarantor = event.target.value;
        } else if (field === 'zipCodeGuarantor') {
            this.zipCodeGuarantor = event.target.value;
        } else if (field === 'lastNameGuarantor') {
            this.lastNameGuarantor = event.target.value;
        } else if (field === 'countryGuarantor') {
            this.countryGuarantor = event.target.value;
        } else if (field === 'SSNGuarantor') {
            this.SSNGuarantor = event.target.value;
        } else if (field === 'homePhoneGuarantor') {
            this.homePhoneGuarantor = event.target.value;
        } else if (field === 'workPhoneGuarantor') {
            this.workPhoneGuarantor = event.target.value;
        } else if (field === 'mobilePhoneGuarantor') {
            this.mobilePhoneGuarantor = event.target.value;
        } else if (field === 'birthDateGuarantor') {
            this.birthDateGuarantor = event.target.value;
        } else if (field === 'genderGuarantor') {
            this.genderGuarantor = event.target.value;
        }else if (field === 'middleNameGuarantor') {
            this.middleNameGuarantor = event.target.value;
        }

    }

    // Save flow
    handleSavePatient1Button(event) {

            console.log('this.insuranceNumber',this.insuranceNumber == 'Primary' );
            console.log('this.insuranceNumber Primary' );
            let isvalid = this.isInputValid();
            console.log('isvalid',isvalid)
        if(isvalid){  
        //alert('firstname ' + JSON.stringify(this.epicAccountRecord.Insurance_Subscriber_First_Name_1__c));
        //alert('lastName ' + JSON.stringify(this.epicAccountRecord.Insurance_Subscriber_Last_Name_1__c));
        //alert('Patient_Relationship_to_Subscriber_1__c ' + JSON.stringify(this.epicAccountRecord.Patient_Relationship_to_Subscriber_1__c));
         
            if (this.insuranceNumber == 'Tertiary') {
            
                this.setThirdInsurance(true);
                this.tertiaryInsuranceAdded=true;
                this.disablePrevButton=false;
                this.disableNextButton=true;

            }
            if (this.insuranceNumber == 'Secondary') {
                
                this.setSecondInsurance(true);
                this.secondaryInsuranceAdded=true;
                    this.disablePrevButton=false;

                    if(this.tertiaryInsuranceAdded===true){
                    this.disableNextButton=false;
                }else{
                    this.disableNextButton=true;   
                }
            }
            if (this.insuranceNumber == 'Primary') {
                console.log('this.insuranceNumber inside')
                this.setFirstInsurance(true);
                this.primaryInsuranceAdded=true;
                this.disablePrevButton=true;
                if(this.tertiaryInsuranceAdded===true || this.secondaryInsuranceAdded===true){
                    this.disableNextButton=false;
                }else{
                    this.disableNextButton=true;   
                }
            
            }
        /*if(this.epicRecordId===''){
            console.log('epicAccountRecord',this.epicAccountRecord);
            createEpicRecord({ epicRecord: this.epicAccountRecord,accId: this.recordId })
            //.then(() => alert("record created"))
            .then(result => {
                this.data = result;
               // this.resetPatientForm();
                this.disableUpdateButton=false;
                this.isDisabledInsuranceButton=false;
                this.epicRecordId=this.data;
                this.throwSuccessToast('Epic record created Successfully');
                console.log('result : ' + JSON.stringify(this.data));

            })
            .catch((error) => {
                console.log('ERROR',JSON.stringify(error))
                //alert("error: " + JSON.stringify(error))
            });
        }
        else if(this.epicRecordId!==''){
            updateEpicRecord({ epicRecord: this.epicAccountRecord,epicRecordId: this.epicRecordId })
            //.then(() => alert("record created"))
            .then(result => {
                this.data = result;
               // this.resetPatientForm();
                this.disableUpdateButton=false;
            
               // this.epicRecordId=this.data;
                this.throwSuccessToast('Epic record updated Successfully');
                console.log('result : ' + JSON.stringify(this.data));

            })
            .catch((error) => {
                //alert("error: " + JSON.stringify(error))
                });
        }*/
    
        }else{
            this.throwErrorToast('Error! Please fill all the required fields');
        }

        }

    createUpdateEpic(){
         if(this.epicRecordId===''){
            console.log('epicAccountRecord',this.epicAccountRecord);
            createEpicRecord({ epicRecord: this.epicAccountRecord,accId: this.caseAccountId })
            //.then(() => alert("record created"))
            .then(result => {
                this.data = result;
               // this.resetPatientForm();
                this.disableUpdateButton=false;
                this.isDisabledInsuranceButton=false;
                this.epicRecordId=this.data;
                this.throwSuccessToast('Epic record created Successfully');
                console.log('result : ' + JSON.stringify(this.data));

            })
            .catch((error) => {
                console.log('ERROR',JSON.stringify(error))
                //alert("error: " + JSON.stringify(error))
            });
        }
        else if(this.epicRecordId!==''){
            updateEpicRecord({ epicRecord: this.epicAccountRecord,epicRecordId: this.epicRecordId })
            //.then(() => alert("record created"))
            .then(result => {
                this.data = result;
               // this.resetPatientForm();
                this.disableUpdateButton=false;
            
               // this.epicRecordId=this.data;
                this.throwSuccessToast('Epic record updated Successfully');
                console.log('result update: ' + JSON.stringify(this.data));
                console.log('this.disableUpdateButton',this.disableUpdateButton)

            })
            .catch((error) => {
                //alert("error: " + JSON.stringify(error))
                });
        }
    }


    handleOnLoad(){
        verifyCreateEpicMRNButton({ caseID: this.recordId })
        .then((result) => {
            console.log('result',result)
            this.mrnDisabled = result
        })
        .catch((error) => {
            
        });
    }

    handleEpicMrn(event){
        validateForms({ caseRecord: this.recordId,
        saveAll : 'saveAll' })
        .then((result) => {
            console.log('result',result)
            // this.mrnDisabled = result
            var mapData = JSON.parse(result);
            console.log('mapData',mapData)
            if(mapData.isError == true){
                this.throwErrorToast('Forms have errors, please review Patient Checklist');
                this.showErrorMessage = 'Review and confirm New Patient Checklist to create MRN';
                // helper.showErrorToast(component,event,"Forms have errors, please review Patient Checklist");
                // component.set('v.showErrorMessage','Review and confirm New Patient Checklist to create MRN');
            }else{
                this.throwSuccessToast('No Errors');
                this.showErrorMessage = '';
                this.createEpicRecord()
                // helper.showSuccessToast('No Errors');
                // component.set('v.showErrorMessage','');
                // var createEpicRecord = component.get('c.createEpicRecord');
                // $A.enqueueAction(createEpicRecord);
            }
        })
        .catch((error) => {
            
        });

       // this.createEpicRecord();
    }


    createEpicRecord(){
        console.log('createNewEpicRecord')
        createNewEpicRecord({ accountId: this.caseAccountId })
        .then((result) => {
            this.throwSuccessToast('Record saved to Epic');
            location.reload();
        })
        .catch((error) => {
            console.log('error',error)
            if(error.body && error.body.message)
                this.throwErrorToast(error.body.message);
        });
    }
    
isInputValidGuarantor(){
    let isValid = true;
        let inputFields = this.template.querySelectorAll('.spec-req-guarnator');
        inputFields.forEach(inputField => {
            if(!inputField.checkValidity()) {
                inputField.reportValidity();
                isValid = false;
            }
        });
        return isValid;
}

handleGuarantorUpdate(event){

 
        if(this.isInputValidGuarantor()){  
        
            if(this.disableUpdateButton ===false) {
                this.epicAccountRecord.Guarantor1_Patient_Relationship_to__c = this.patientRelationshipToGuarantor;
                this.epicAccountRecord.Guarantor1_Street__c = this.streetGuarantor;
                this.epicAccountRecord.Guarantor1_Type__c = this.guarantorType;
                if (this.firstNameGuarantor !== '') {
                    this.epicAccountRecord.Guarantor1_FirstName__c = this.firstNameGuarantor;
                }
                this.epicAccountRecord.Guarantor1_City__c = this.cityGuarantor;
                this.epicAccountRecord.Guarantor1_State__c = this.stateGuarantor;
                this.epicAccountRecord.Guarantor1_PostalCode__c = this.zipCodeGuarantor;
                this.epicAccountRecord.Guarantor1_LastName__c = this.lastNameGuarantor;
                this.epicAccountRecord.Guarantor1_Country__c = this.countryGuarantor;
                this.epicAccountRecord.Guarantor1_SSN__c = this.SSNGuarantor;
                this.epicAccountRecord.Guarantor1_Home_Phone__c = this.homePhoneGuarantor;
                this.epicAccountRecord.Guarantor1_Work_Phone__c = this.workPhoneGuarantor;
                this.epicAccountRecord.Guarantor1_Mobile_Phone__c = this.mobilePhoneGuarantor;
                this.epicAccountRecord.Guarantor1_Birth_Date__c = this.birthDateGuarantor;
                this.epicAccountRecord.Guarantor1_Gender__c = this.genderGuarantor;
                this.epicAccountRecord.Guarantor1_MiddleName__c = this.middleNameGuarantor;
            
                updateEpicRecord({ epicRecord: this.epicAccountRecord,epicRecordId: this.epicRecordId })
                .then(result => {
                    this.data = result;
                    this.throwSuccessToast('Epic record updated Successfully');
                    console.log('result : ' + JSON.stringify(this.data));

                })
                .catch((error) => {

                    //alert("error: " + JSON.stringify(error))
                
                });
            }
         }else{
            this.throwErrorToast('Error! Please fill all the required fields');
        } 

}
    handleAddInsuranceButton() {
        //   if (!this.validateInput())
        //      return;
        //  if (!this.validateComboBox())
        //     return;

        console.log('Inside add insurance');

        if (this.insuranceNumber === 'Primary') {
            this.setFirstInsurance(false);
            this.primaryInsuranceAdded=true;
            this.disablePrevButton=false;
            this.disableNextButton=true;
            this.insuranceNumber = 'Secondary';
            this.resetPatientForm();
        }
        else if (this.insuranceNumber === 'Secondary') {
            this.setSecondInsurance(false);
            this.insuranceNumber = 'Tertiary';
            this.disablePrevButton=false;
            this.disableNextButton=true;
            this.secondaryInsuranceAdded=true;
            this.isDisabledInsuranceButton = true;
            this.resetPatientForm();

        }



    }

    setFirstInsurance(submit) {

        if(this.isInputValid()){    
        
        let accountRecordId = this.caseAccountId;
        console.log('Inside save',this.epicAccountRecord);
        if (this.insuranceNumber === 'Primary') {

            if(this.epicAccountRecord == null)
            this.epicAccountRecord = new Object();

            this.epicAccountRecord.Account__c = accountRecordId;
            this.epicAccountRecord.Patient_Relationship_to_Subscriber_1__c = this.patientRelationshiptoSub1;
            this.epicAccountRecord.Insurance_Subscriber_First_Name_1__c = this.firstName1;
            this.epicAccountRecord.Insurance_Subscriber_Last_Name_1__c = this.lastName1;
            if (this.middleName1 !== '') {
                this.epicAccountRecord.Insurance_Subscriber_Middle_Name_1__c = this.middleName1;
            }
            this.epicAccountRecord.Insurance_Gender_1__c = this.gender1;
            this.epicAccountRecord.Insurance_Birth_Date_1__c = this.birthdate1;
            this.epicAccountRecord.Insurance_SSN_1__c = this.socialsecuritynumber1;
            this.epicAccountRecord.Insurance_Street_1__c = this.subscriberStreetAddress1;
            this.epicAccountRecord.Insurance_City_1__c = this.subscribercity1;
            this.epicAccountRecord.Insurance_State_1__c = this.subscriberstate1;
            this.epicAccountRecord.Insurance_PostalCode_1__c = this.subscriberzip1;
            this.epicAccountRecord.Insurance_Country_1__c = this.subscribercountry1;
            this.epicAccountRecord.Insurance_Purchaser_Plan_1__c = this.insurancePlan1;
            this.epicAccountRecord.Subscriber_ID_1__c = this.subscriberId1;
            this.epicAccountRecord.Insurance_Subscriber_Member_Id_1__c = this.memberId1;
            if (this.Group_Number_1_c__c !== '') {
                this.epicAccountRecord.Group_Number_1_c__c = this.groupNumber1;
            }
            if (this.Authorization_number_1__c !== '') {
                this.epicAccountRecord.Authorization_number_1__c = this.authorizationNumber1;
            }
            this.epicAccountRecord.Insurance_Member_eff_from_1__c = this.effectiveFrom1;
            this.epicAccountRecord.Original_Referring_Doctor__c = this.originalReferringProvider1;
            if(submit){
                this.createUpdateEpic();
            }
        }
        }else{
            this.throwErrorToast('Error! Please fill all the required fields');
        }    

    }

    setSecondInsurance(submit) {
       

        if(this.isInputValid()){  
            this.epicAccountRecord.Patient_Relationship_to_Subscriber_2__c = this.patientRelationshiptoSub1;
            this.epicAccountRecord.Insurance_Subscriber_First_Name_2__c = this.firstName1;
            this.epicAccountRecord.Insurance_Subscriber_Last_Name_2__c = this.lastName1;
            if (this.middleName1 !== '') {
                this.epicAccountRecord.Insurance_Subscriber_Middle_Name_2__c = this.middleName1;
            }
            this.epicAccountRecord.Insurance_Gender_2__c = this.gender1;
            this.epicAccountRecord.Insurance_Birth_Date_2__c = this.birthdate1;
            this.epicAccountRecord.Insurance_SSN_2__c = this.socialsecuritynumber1;
            this.epicAccountRecord.Insurance_Street_2__c = this.subscriberStreetAddress1;
            this.epicAccountRecord.Insurance_City_2__c = this.subscribercity1;
            this.epicAccountRecord.Insurance_State_2__c = this.subscriberstate1;
            this.epicAccountRecord.Insurance_PostalCode_2__c = this.subscriberzip1;
            this.epicAccountRecord.Insurance_Country_2__c = this.subscribercountry1;
            this.epicAccountRecord.Insurance_Purchaser_Plan_2__c = this.insurancePlan1;
            this.epicAccountRecord.Subscriber_ID_2__c = this.subscriberId1;
            this.epicAccountRecord.Insurance_Subscriber_Member_Id_2__c = this.memberId1;
            if (this.groupNumber1 !== '') {
                this.epicAccountRecord.Group_Number_2_c__c = this.groupNumber1;
            }
            if (this.authorizationNumber1 !== '') {
                this.epicAccountRecord.Authorization_number_2__c = this.authorizationNumber1;
            }
            this.epicAccountRecord.Insurance_Member_eff_from_2__c = this.effectiveFrom1;
            //this.epicAccountRecord.Original_Referring_Doctor__c = this.originalReferringProvider1;
            if(submit){
                this.createUpdateEpic();
            }
         }else{
              this.throwErrorToast('Error! Please fill all the required fields');
         }


    }

    setThirdInsurance(submit) {
       if(this.isInputValid()){ 

            console.log('Inside save3');

            this.epicAccountRecord.Patient_Relationship_to_Subscriber_3__c = this.patientRelationshiptoSub1;
            this.epicAccountRecord.Insurance_Subscriber_First_Name_3__c = this.firstName1;
            this.epicAccountRecord.Insurance_Subscriber_Last_Name_3__c = this.lastName1;
            if (this.middleName1 !== '') {
                this.epicAccountRecord.Insurance_Subscriber_Middle_Name_3__c = this.middleName1;
            }
            this.epicAccountRecord.Insurance_Gender_3__c = this.gender1;
            this.epicAccountRecord.Insurance_Birth_Date_3__c = this.birthdate1;
            this.epicAccountRecord.Insurance_SSN_3__c = this.socialsecuritynumber1;
            this.epicAccountRecord.Insurance_Street_3__c = this.subscriberStreetAddress1;
            this.epicAccountRecord.Insurance_City_3__c = this.subscribercity1;
            this.epicAccountRecord.Insurance_State_3__c = this.subscriberstate1;
            this.epicAccountRecord.Insurance_PostalCode_3__c = this.subscriberzip1;
            this.epicAccountRecord.Insurance_Country_3__c = this.subscribercountry1;
            this.epicAccountRecord.Insurance_Purchaser_Plan_3__c = this.insurancePlan1;
            this.epicAccountRecord.Subscriber_ID_3__c = this.subscriberId1;
            this.epicAccountRecord.Insurance_Subscriber_Member_Id_3__c = this.memberId1;
            if (this.groupNumber1 !== '') {
                this.epicAccountRecord.Group_Number_3_c__c = this.groupNumber1;
            }
            if (this.authorizationNumber1 !== '') {
                this.epicAccountRecord.Authorization_number_3__c = this.authorizationNumber1;
            }
            this.epicAccountRecord.Insurance_Member_eff_from_3__c = this.effectiveFrom1;
            //this.epicAccountRecord.Original_Referring_Doctor__c = this.originalReferringProvider1;
            if(submit){
                this.createUpdateEpic();
            }
       }else{
            this.throwErrorToast('Error! Please fill all the required fields');
       }


    }

    getFirstInsurance() {
    
        if(this.epicRecordId !==''){
            this.insuranceNumber = 'Primary';
            
            this.template.querySelector('c-custom-lookup').onSetData(this.epicAccountRecord.Insurance_Purchaser_Plan_1__c);
            this.patientRelationshiptoSub1=this.epicAccountRecord.Patient_Relationship_to_Subscriber_1__c ;
            this.firstName1=this.epicAccountRecord.Insurance_Subscriber_First_Name_1__c;
            this.lastName1=this.epicAccountRecord.Insurance_Subscriber_Last_Name_1__c;
            if(this.epicAccountRecord.Insurance_Subscriber_Middle_Name_1__c !== '') {
                this.middleName1=this.epicAccountRecord.Insurance_Subscriber_Middle_Name_1__c;
            }
            this.gender1=this.epicAccountRecord.Insurance_Gender_1__c ;
            this.birthdate1=this.epicAccountRecord.Insurance_Birth_Date_1__c ;
            this.socialsecuritynumber1=this.epicAccountRecord.Insurance_SSN_1__c;
            this.subscriberStreetAddress1=this.epicAccountRecord.Insurance_Street_1__c ;
            this.subscribercity1=this.epicAccountRecord.Insurance_City_1__c ;
            this.subscriberstate1=this.epicAccountRecord.Insurance_State_1__c;
            this.subscriberzip1=this.epicAccountRecord.Insurance_PostalCode_1__c ;
            this.subscribercountry1=this.epicAccountRecord.Insurance_Country_1__c;
            //this.insurancePlan1=this.epicAccountRecord.Insurance_Purchaser_Plan_1__c ;
            this.subscriberId1=this.epicAccountRecord.Subscriber_ID_1__c ;
            this.memberId1=this.epicAccountRecord.Insurance_Subscriber_Member_Id_1__c ;
            if ( this.epicAccountRecord.Group_Number_1_c__c !== '') {
                this.groupNumber1=this.epicAccountRecord.Group_Number_1_c__c ;
            }
            if (this.epicAccountRecord.Authorization_number_1__c  !== '') {
                this.authorizationNumber1=this.epicAccountRecord.Authorization_number_1__c ;
            }
            this.effectiveFrom1=this.epicAccountRecord.Insurance_Member_eff_from_1__c ;
            console.log('this.epicAccountRecord.Original_Referring_Doctor__c',this.epicAccountRecord.Original_Referring_Doctor__c)
            if(this.epicAccountRecord.Original_Referring_Doctor__c){
                this.template.querySelector('.lookup-class').onSetOriginalDocData(this.epicAccountRecord.Original_Referring_Doctor__c);
            }
            
        }
      }

      getSecondInsurance() {
          this.insuranceNumber = 'Secondary';
         // this.displayingInsuranceNumber='Secondary';
       this.template.querySelector('c-custom-lookup').onSetData(this.epicAccountRecord.Insurance_Purchaser_Plan_2__c);
            this.patientRelationshiptoSub1=this.epicAccountRecord.Patient_Relationship_to_Subscriber_2__c ;
            this.firstName1=this.epicAccountRecord.Insurance_Subscriber_First_Name_2__c;
             this.lastName1=this.epicAccountRecord.Insurance_Subscriber_Last_Name_2__c;
            if(this.epicAccountRecord.Insurance_Subscriber_Middle_Name_2__c !== '') {
                 this.middleName1=this.epicAccountRecord.Insurance_Subscriber_Middle_Name_2__c;
            }
             this.gender1=this.epicAccountRecord.Insurance_Gender_2__c ;
             this.birthdate1=this.epicAccountRecord.Insurance_Birth_Date_2__c ;
              this.socialsecuritynumber1=this.epicAccountRecord.Insurance_SSN_2__c;
             this.subscriberStreetAddress1=this.epicAccountRecord.Insurance_Street_2__c ;
             this.subscribercity1=this.epicAccountRecord.Insurance_City_2__c ;
              this.subscriberstate1=this.epicAccountRecord.Insurance_State_2__c;
             this.subscriberzip1=this.epicAccountRecord.Insurance_PostalCode_2__c ;
              this.subscribercountry1=this.epicAccountRecord.Insurance_Country_2__c;
             this.insurancePlan1=this.epicAccountRecord.Insurance_Purchaser_Plan_2__c ;
             this.subscriberId1=this.epicAccountRecord.Subscriber_ID_2__c ;
             this.memberId1=this.epicAccountRecord.Insurance_Subscriber_Member_Id_2__c ;
            if ( this.epicAccountRecord.Group_Number_2_c__c !== '') {
                 this.groupNumber1=this.epicAccountRecord.Group_Number_2_c__c ;
            }
            if (this.epicAccountRecord.Authorization_number_2__c  !== '') {
                 this.authorizationNumber1=this.epicAccountRecord.Authorization_number_2__c ;
            }
             this.effectiveFrom1=this.epicAccountRecord.Insurance_Member_eff_from_2__c ;
              this.originalReferringProvider1=this.epicAccountRecord.Original_Referring_Doctor__c;
        }
        getThirdInsurance() {
    this.template.querySelector('c-custom-lookup').onSetData(this.epicAccountRecord.Insurance_Purchaser_Plan_3__c);
             this.insuranceNumber = 'Tertiary';
            //this.displayingInsuranceNumber='Tertiary';
            this.patientRelationshiptoSub1=this.epicAccountRecord.Patient_Relationship_to_Subscriber_3__c ;
            this.firstName1=this.epicAccountRecord.Insurance_Subscriber_First_Name_3__c;
             this.lastName1=this.epicAccountRecord.Insurance_Subscriber_Last_Name_3__c;
            if(this.epicAccountRecord.Insurance_Subscriber_Middle_Name_3__c !== '') {
                 this.middleName1=this.epicAccountRecord.Insurance_Subscriber_Middle_Name_3__c;
            }
             this.gender1=this.epicAccountRecord.Insurance_Gender_3__c ;
             this.birthdate1=this.epicAccountRecord.Insurance_Birth_Date_3__c ;
              this.socialsecuritynumber1=this.epicAccountRecord.Insurance_SSN_3__c;
             this.subscriberStreetAddress1=this.epicAccountRecord.Insurance_Street_3__c ;
             this.subscribercity1=this.epicAccountRecord.Insurance_City_3__c ;
              this.subscriberstate1=this.epicAccountRecord.Insurance_State_3__c;
             this.subscriberzip1=this.epicAccountRecord.Insurance_PostalCode_3__c ;
              this.subscribercountry1=this.epicAccountRecord.Insurance_Country_3__c;
             this.insurancePlan1=this.epicAccountRecord.Insurance_Purchaser_Plan_3__c ;
             this.subscriberId1=this.epicAccountRecord.Subscriber_ID_3__c ;
             this.memberId1=this.epicAccountRecord.Insurance_Subscriber_Member_Id_3__c ;
            if ( this.epicAccountRecord.Group_Number_3_c__c !== '') {
                 this.groupNumber1=this.epicAccountRecord.Group_Number_3_c__c ;
            }
            if (this.epicAccountRecord.Authorization_number_3__c  !== '') {
                 this.authorizationNumber1=this.epicAccountRecord.Authorization_number_3__c ;
            }
             this.effectiveFrom1=this.epicAccountRecord.Insurance_Member_eff_from_3__c ;
              this.originalReferringProvider1=this.epicAccountRecord.Original_Referring_Doctor__c;
        }


 
    handleAddInsurancePreviousButton(event){
        console.log('Inside Prev button');
        if( this.insuranceNumber === 'Secondary'){
            this.getFirstInsurance();
            this.insuranceNumber = 'Primary';
             this.disablePrevButton=true;
             if(this.secondaryInsuranceAdded===true){
                this.disableNextButton=false;
            }else{
                this.disableNextButton=true;   
            }
        }
        if( this.insuranceNumber === 'Tertiary'){
            this.getSecondInsurance();
            this.insuranceNumber = 'Secondary';
             if(this.tertiaryInsuranceAdded===true){
                this.disableNextButton=false;
            }else{
                this.disableNextButton=true;
                this.isDisabledInsuranceButton = false;
            }
        }

    }

 
previousGuarantor(){
    this.activeTab = 'Guarantor';
}


    handleGuarantorPreviousButton(event){
        this.getFirstInsurance();
        this.activeTab = 'Insurance';
         this.disablePrevButton=true;
         this.disableNextButton=false;

    }


    handleNextButton(event) {
       // this.activeTab = 'Guarantor';
       if(this.insuranceNumber === 'Primary'){
           this.insuranceNumber = 'Secondary';
            this.disablePrevButton=false;
            this.getSecondInsurance();
            if(this.tertiaryInsuranceAdded===true){
                this.disableNextButton=false;
                  this.isDisabledInsuranceButton = true;
            }else{
                this.disableNextButton=true;   
                 this.isDisabledInsuranceButton = false;
            }
       }
       else if(this.insuranceNumber === 'Secondary'){
           this.insuranceNumber = 'Tertiary';
            this.getThirdInsurance();
            this.disableNextButton=true;
       }


    }
    handleGuarantorNextButton(event) {
        this.activeTab = 'InsuranceList';
        this.fetchInsuranceTab();

    }
    handleCopyPatienteButton() {
                 
                
        let accountRecordId = this.caseAccountId;
        console.log('Case',accountRecordId)
        getAccountDetails({ accountRecordId: accountRecordId })
            .then(result => {
                this.accountRecord = result;
                this.firstName1 = this.accountRecord.Patient_First_Name__c;
                this.lastName1 = this.accountRecord.Patient_Last_Name__c;
                this.middleName1 = this.accountRecord.MiddleName;
                this.gender1 = this.accountRecord.Gender__pc;
                this.birthdate1 = this.accountRecord.PersonBirthdate;
                this.socialsecuritynumber1 = this.accountRecord.COH_Account_PatientAccess_SSN__c;
                this.subscriberStreetAddress1 = this.accountRecord.Patient_Street1__c;
                this.subscribercity1 = this.accountRecord.Patient_City__c;
                this.subscriberstate1 = this.accountRecord.COH_PA_State__c;
                this.subscriberzip1 = this.accountRecord.Patient_Postal_Code__c;
                this.subscribercountry1 = this.accountRecord.COH_PA_Country__c;
                console.log('result : ' + JSON.stringify(this.accountRecord));
                 
            })
            .catch((error) => {
                console.log('ERROR',JSON.stringify(error))
                //alert("error: " + JSON.stringify(error))
                });
        
    }
       handleCopyPatienteButtoGuarantor() {

        let accountRecordId = this.caseAccountId;
        getAccountDetails({ accountRecordId: accountRecordId })
            .then(result => {
                this.accountRecord = result;
                this.firstNameGuarantor = this.accountRecord.Patient_First_Name__c;
                this.lastNameGuarantor = this.accountRecord.Patient_Last_Name__c;
                this.middleNameGuarantor = this.accountRecord.MiddleName;
                this.genderGuarantor = this.accountRecord.Gender__pc;
                this.birthDateGuarantor = this.accountRecord.PersonBirthdate;
                this.SSNGuarantor = this.accountRecord.COH_Account_PatientAccess_SSN__c;
                this.streetGuarantor = this.accountRecord.Patient_Street1__c;
                this.cityGuarantor = this.accountRecord.Patient_City__c;
                this.stateGuarantor = this.accountRecord.COH_PA_State__c;
                this.zipCodeGuarantor = this.accountRecord.Patient_Postal_Code__c;
                this.countryGuarantor = this.accountRecord.COH_PA_Country__c;
                console.log('result : ' + JSON.stringify(this.accountRecord));

            })
            .catch((error) => alert("error: " + JSON.stringify(error)));



    }


    handleActive(event) {
        this.activeTab = event.target.value;
        console.log('this.activeTab',this.activeTab )
        if(this.activeTab == 'InsuranceList'){
            this.fetchInsuranceTab();
        }
    }

    validateInput() {
        return [...this.template.querySelectorAll('lightning-input')].reduce((validSoFar, inputField) => {
            return validSoFar && inputField.reportValidity();
        }, true);
    }

    validateComboBox() {
        return [...this.template.querySelectorAll('lightning-combobox')].reduce((validSoFar, inputField) => {
            return validSoFar && inputField.reportValidity();
        }, true);
    }
     isInputValid() {
        let isValid = true;
        let inputFields = this.template.querySelectorAll('.spec-req');
        inputFields.forEach(inputField => {
            if(!inputField.checkValidity()) {
                inputField.reportValidity();
                isValid = false;
            }
        });

          if (this.insurancePlan1==='') {
            this.template.querySelector('c-custom-lookup').setInputValid();
        } else {
            this.template.querySelector('c-custom-lookup').hideInputValid();
        }
        if (this.originalReferringProvider1==='') {
            this.template.querySelector('.lookup-class').setInputValid();
        } else {
            this.template.querySelector('.lookup-class').hideInputValid();
        }
        console.log('isValid',isValid)
        return isValid;
    }

    throwErrorToast(error) {
        const event = new ShowToastEvent({
            title: 'Error',
            variant: 'error',
            message: error,
            mode: 'dismissible'
        });
        this.dispatchEvent(event);
    }

    throwSuccessToast(success) {
        const event = new ShowToastEvent({
            title: 'Success',
            variant: 'success',
            message: success,
            mode: 'dismissible'
        });
        this.dispatchEvent(event);
    }
      handleRemove(event){

          console.log('Event-----'+event.detail);
          if(event.detail==='Contact'){
                this.originalReferringProvider1='';
          }
            else{
                this.insurancePlan1='';
            }
      }

    resetPatientForm() {

        this.patientRelationshiptoSub1 = '';
        this.firstName1 = '';
        this.lastName1 = '';
        this.middleName1 = '';
        this.gender1 = '';
        this.birthdate1 = '';
        this.socialsecuritynumber1 = '';
        this.subscriberStreetAddress1 = '';
        this.subscribercity1 = '';
        this.subscriberstate1 = '';
        this.subscriberzip1 = '';
        this.subscribercountry1 = '';
        this.insurancePlan1 = '';
        this.subscriberId1 = '';
        this.memberId1 = '';
        this.groupNumber1 = '';
        this.authorizationNumber1 = '';
        this.effectiveFrom1 = '';
        this.template.querySelector('c-custom-lookup').handleValueChange();
        //this.originalReferringProvider1 = '';

    }

}