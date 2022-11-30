import { LightningElement,track,wire,api  } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';

import EPIC_ACCOUNT_DATA_OBJECT from '@salesforce/schema/Epic_Account_Data__c';

import PATIENT_RELATIONSHIP_TO_SUBSCRIBER_1 from '@salesforce/schema/Epic_Account_Data__c.Patient_Relationship_to_Subscriber_1__c';
import INSURANCE_GENDER_1 from '@salesforce/schema/Epic_Account_Data__c.Insurance_Gender_1__c';
import INSURANCE_STATE_1 from '@salesforce/schema/Epic_Account_Data__c.Insurance_State_1__c';
import INSURANCE_COUNTRY_1 from '@salesforce/schema/Epic_Account_Data__c.Insurance_Country_1__c';

export default class AddInsuranceGuarantorScreen extends LightningElement {
 @api accountId;
    patientRelationshipPicklist ='';
    genderPicklist ='';
    statePicklist ='';
    countryPicklist ='';
    firstName='';
    lastName='';
    patientRelationshiptoSub='';
       
  

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


// Data setup
handleChange(event) {
        const field = event.target.name;
         if (field === 'patientRelationshiptoSub') {
            this.patientRelationshiptoSub = event.target.value;
        } else if (field === 'firstName') {
            this.firstName = event.target.value;
        } else if (field === 'lastName') {
            this.lastName = event.target.value;
        }
       // this.patientRelationshiptoSub = event.target.value;
    }
// Data flow
handleSavePatient1Button(event){
    
      let epicAccountRecord = { 'sObjectType': 'Epic_Account_Data__c' };
   
 // epicAccountRecord.FirstName = this.template.querySelector('lightning-input[name="firstName"]').value;
 // epicAccountRecord.LastName = this.template.querySelector('lightning-input[name="lastName"]').value;
 // epicAccountRecord.PatientRelationshiptoSub = this.template.querySelector('lightning-input[name="patientRelationshiptoSub"]').value;

 epicAccountRecord.FirstName = this.firstName;
 epicAccountRecord.LastName = this.lastName;
 epicAccountRecord.PatientRelationshiptoSub = this.patientRelationshiptoSub;
    alert('firstname '+ JSON.stringify(epicAccountRecord.FirstName));
    alert('lastName '+ JSON.stringify(epicAccountRecord.LastName));
    alert('patientRelationshiptoSub '+ JSON.stringify(epicAccountRecord.PatientRelationshiptoSub));
 
        



           
    }



    }