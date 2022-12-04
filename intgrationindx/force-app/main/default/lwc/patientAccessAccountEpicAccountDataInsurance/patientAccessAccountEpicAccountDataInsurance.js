/* eslint-disable @lwc/lwc/no-api-reassignments */
/* eslint-disable @lwc/lwc/no-leading-uppercase-api-name */
import { LightningElement, wire, api, track } from "lwc";
import { getRecord, getRecordNotifyChange } from "lightning/uiRecordApi";
import getSingleEpicAccountData from "@salesforce/apex/PatientAccessEpicAccountController.getEpicAccountData";
import getPurchaserPlanName from "@salesforce/apex/PatientAccessEpicAccountController.getPurchaserPlanName";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import PURCHASERPLAN1ID__FIELD from "@salesforce/schema/Epic_Account_Data__c.Insurance_Purchaser_Plan_1__c";
import PURCHASERPLAN2ID__FIELD from "@salesforce/schema/Epic_Account_Data__c.Insurance_Purchaser_Plan_2__c";
import PURCHASERPLAN3ID__FIELD from "@salesforce/schema/Epic_Account_Data__c.Insurance_Purchaser_Plan_3__c";
const fields = [
  PURCHASERPLAN1ID__FIELD,
  PURCHASERPLAN2ID__FIELD,
  PURCHASERPLAN3ID__FIELD
];

export default class PatientAccessAccountEpicAccountData extends LightningElement {
  @api recordId;
  @api objectApi = "Epic_Account_Data__c";
  @api record;
  @api purchaserPlan1Name;
  @api error;
  @api epicAccountDataId;
  @api name;
  @api AccountMRN;
  @api isLoading = false;
  @api showPayerAddress1 = false;
  @api showPayerAddress2 = false;
  @api showPayerAddress3 = false;
  @api lookupId;
  @api rendered = false;
  @api disableMemberId1 = false;
  @api disableMemberId2 = false;
  @api disableMemberId3 = false;
  @track parelationshiptoInsurance;
  @track isInsurance1 = false;
  @track isInsurance2 = false;
  @track isInsurance3 = false;
  @track originalMessage;
  @track isDialogVisible;
  @track subscriberId1;
  @track subscriberId2;
  @track subscriberId3;
  @api memberId1;
  @api memberId2;
  @api memberId3;

  @wire(getRecord, {
    recordId: "$recordId",
    fields
  })
  epicAccountData;

  connectedCallback() {
    this.AccountMRN = true;
    this.isLoading = true;
    getSingleEpicAccountData({ accountId: this.recordId })
      .then((result) => {
        console.log("created....", result);
        this.record = result;
        console.log("this.record: " + this.record);
        this.epicAccountDataId = this.record.Id;
        console.log("this.epicAccountDataId :" + this.epicAccountDataId);
        this.AccountMRN = this.record.AccountMRN__c;
        console.log("this.AccountMRN : " + this.AccountMRN);
        console.log(
          "PurchaserPlan1Name: " + this.record.Insurance_Purchaser_Plan_1__c
        );
        console.log(
          "PurchaserPlan2Name: " + this.record.Insurance_Purchaser_Plan_2__c
        );
        console.log(
          "PurchaserPlan3Name: " + this.record.Insurance_Purchaser_Plan_3__c
        );
        console.log(
          "Patient Realtionship to sub1: " +
            this.record.Patient_Relationship_to_Subscriber_1__c
        );
        console.log(
          "Patient Realtionship to sub2: " +
            this.record.Patient_Relationship_to_Subscriber_2__c
        );
        console.log(
          "Patient Realtionship to sub3: " +
            this.record.Patient_Relationship_to_Subscriber_3__c
        );
        if (this.record.Patient_Relationship_to_Subscriber_1__c === "Self") {
          this.isInsurance1 = true;
          this.disableMemberId1 = true;
        }
        if (this.record.Patient_Relationship_to_Subscriber_2__c === "Self") {
          this.isInsurance2 = true;
          this.disableMemberId2 = true;
        }
        if (this.record.Patient_Relationship_to_Subscriber_3__c === "Self") {
          this.isInsurance3 = true;
          this.disableMemberId3 = true;
        }
        this.subscriberId1 = this.record.Subscriber_ID_1__c;
        this.subscriberId2 = this.record.Subscriber_ID_2__c;
        this.subscriberId3 = this.record.Subscriber_ID_3__c;
        if (this.record.Insurance_Purchaser_Plan_1__c != null) {
          if (
            this.record.Insurance_Purchaser_Plan_1__r.Name.includes("GENERIC")
          ) {
            this.showPayerAddress1 = true;
          }
        }
        if (this.record.Insurance_Purchaser_Plan_2__c != null) {
          if (
            this.record.Insurance_Purchaser_Plan_2__r.Name.includes("GENERIC")
          ) {
            this.showPayerAddress2 = true;
          }
        }
        if (this.record.Insurance_Purchaser_Plan_3__c != null) {
          if (
            this.record.Insurance_Purchaser_Plan_3__r.Name.includes("GENERIC")
          ) {
            this.showPayerAddress3 = true;
          }
        }
      })
      .catch((error) => {
        console.log("Error", error);
      });
    this.isLoading = false;
  }
  handleonchangeInsurance1(event) {
    // alert(event.target.value);
    this.parelationshiptoInsurance = event.target.value;
    if (this.parelationshiptoInsurance === "Self") {
      this.originalMessage = "text message";
      this.isDialogVisible = true;
      this.isInsurance1 = true;
      this.disableMemberId1 = true;
      this.memberId1 = this.subscriberId1;
    } else {
      this.isInsurance1 = false;
      this.disableMemberId1 = false;
    }
  }
  handleonchangeInsurance2(event) {
    // alert(event.target.value);
    this.parelationshiptoInsurance = event.target.value;
    if (this.parelationshiptoInsurance === "Self") {
      this.originalMessage = "text message";
      this.isDialogVisible = true;
      this.isInsurance2 = true;
      this.disableMemberId2 = true;
      this.memberId2 = this.subscriberId2;
    } else {
      this.isInsurance2 = false;
      this.disableMemberId2 = false;
    }
  }
  handleonchangeInsurance3(event) {
    // alert(event.target.value);
    this.parelationshiptoInsurance = event.target.value;
    if (this.parelationshiptoInsurance === "Self") {
      this.originalMessage = "text message";
      this.isDialogVisible = true;
      this.isInsurance3 = true;
      this.disableMemberId3 = true;
      this.memberId3 = this.subscriberId3;
    } else {
      this.isInsurance3 = false;
      this.disableMemberId3 = false;
    }
  }

  handleonchangeSubscriber1(event) {
    console.log("isInsurance1 : ", this.isInsurance1);
    console.log("subscriber1 : ", event.target.value);
    if (this.isInsurance1 === true) {
      this.memberId1 = event.target.value;
    }
    this.subscriberId1 = event.target.value;
    console.log("memberId1 : ", event.target.value);
  }
  handleonchangeSubscriber2(event) {
    console.log("isInsurance2 : ", this.isInsurance2);
    console.log("subscriber2 : ", event.target.value);
    if (this.isInsurance2 === true) {
      this.memberId2 = event.target.value;
    }
    this.subscriberId2 = event.target.value;
    console.log("memberId2 : ", event.target.value);
  }

  handleonchangeSubscriber3(event) {
    console.log("isInsurance3 : ", this.isInsurance3);
    console.log("subscriber3 : ", event.target.value);
    if (this.isInsurance3 === true) {
      this.memberId3 = event.target.value;
    }
    this.subscriberId3 = event.target.value;
    console.log("memberId1 : ", event.target.value);
  }

  handleClick(event) {
    //alert(event.detail.status);
    if (event.detail.status === "confirm") {
      //alert(this.record.Account__r.Gender__pc);
      //this.closeAction();
      //this.record.Guarantor1_Birth_Date__c = this.record.Account__r.PersonBirthdate;
      this.isDialogVisible = false;
      const inputFields = this.template.querySelectorAll(
        "lightning-input-field"
      );
      if (inputFields) {
        inputFields.forEach((field) => {
          if (
            field.fieldName === "Insurance_Birth_Date_1__c" &&
            this.isInsurance1 === true
          )
            field.value = this.record.Account__r.PersonBirthdate;
          if (
            field.fieldName === "Insurance_Birth_Date_2__c" &&
            this.isInsurance2 === true
          )
            field.value = this.record.Account__r.PersonBirthdate;
          if (
            field.fieldName === "Insurance_Birth_Date_3__c" &&
            this.isInsurance3 === true
          )
            field.value = this.record.Account__r.PersonBirthdate;

          if (
            field.fieldName === "Insurance_Gender_1__c" &&
            this.isInsurance1 === true
          )
            field.value = this.record.Account__r.Gender__pc;
          if (
            field.fieldName === "Insurance_Gender_2__c" &&
            this.isInsurance2 === true
          )
            field.value = this.record.Account__r.Gender__pc;
          if (
            field.fieldName === "Insurance_Gender_3__c" &&
            this.isInsurance3 === true
          )
            field.value = this.record.Account__r.Gender__pc;

          if (
            field.fieldName === "Insurance_Subscriber_First_Name_1__c" &&
            this.isInsurance1 === true
          )
            field.value = this.record.Account__r.FirstName;
          if (
            field.fieldName === "Insurance_Subscriber_First_Name_2__c" &&
            this.isInsurance2 === true
          )
            field.value = this.record.Account__r.FirstName;
          if (
            field.fieldName === "Insurance_Subscriber_First_Name_3__c" &&
            this.isInsurance3 === true
          )
            field.value = this.record.Account__r.FirstName;

          if (
            field.fieldName === "Insurance_Subscriber_Last_Name_1__c" &&
            this.isInsurance1 === true
          )
            field.value = this.record.Account__r.LastName;
          if (
            field.fieldName === "Insurance_Subscriber_Last_Name_2__c" &&
            this.isInsurance2 === true
          )
            field.value = this.record.Account__r.LastName;
          if (
            field.fieldName === "Insurance_Subscriber_Last_Name_3__c" &&
            this.isInsurance3 === true
          )
            field.value = this.record.Account__r.LastName;

          if (
            field.fieldName === "Insurance_Subscriber_Middle_Name_1__c" &&
            this.isInsurance1 === true
          )
            field.value = this.record.Account__r.MiddleName;
          if (
            field.fieldName === "Insurance_Subscriber_Middle_Name_2__c" &&
            this.isInsurance2 === true
          )
            field.value = this.record.Account__r.MiddleName;
          if (
            field.fieldName === "Insurance_Subscriber_Middle_Name_3__c" &&
            this.isInsurance3 === true
          )
            field.value = this.record.Account__r.MiddleName;

          /*if(field.fieldName === 'Guarantor1_Home_Phone__c' && this.isInsurance1 === true)
                        field.value = this.record.Account__r.PersonHomePhone;
                    if(field.fieldName === 'Guarantor2_Home_Phone__c' && this.isInsurance1 === false)
                        field.value = this.record.Account__r.PersonHomePhone;

                    if(field.fieldName === 'Guarantor1_Home_Phone__c' && this.isInsurance1 === true)
                         field.value = this.record.Account__r.PersonHomePhone;						 
                     if(field.fieldName === 'Guarantor2_Home_Phone__c' && this.isInsurance1 === false)
                        field.value = this.record.Account__r.PersonHomePhone; 

                    if(field.fieldName === 'Guarantor1_Mobile_Phone__c' && this.isInsurance1 === true)
                        field.value = this.record.Account__r.PersonMobilePhone;
                    if(field.fieldName === 'Guarantor2_Mobile_Phone__c' && this.isInsurance1 === false)
                        field.value = this.record.Account__r.PersonMobilePhone;
                        
                    if(field.fieldName === 'Guarantor1_Work_Phone__c' && this.isInsurance1 === true)
                        field.value = this.record.Account__r.PersonOtherPhone;
                     if(field.fieldName === 'Guarantor2_Work_Phone__c' && this.isInsurance1 === false)
                        field.value = this.record.Account__r.PersonOtherPhone; */

          if (
            field.fieldName === "Insurance_SSN_1__c" &&
            this.isInsurance1 === true
          )
            field.value =
              this.record.Account__r.COH_Account_PatientAccess_SSN__c;
          if (
            field.fieldName === "Insurance_SSN_2__c" &&
            this.isInsurance2 === true
          )
            field.value =
              this.record.Account__r.COH_Account_PatientAccess_SSN__c;
          if (
            field.fieldName === "Insurance_SSN_3__c" &&
            this.isInsurance3 === true
          )
            field.value =
              this.record.Account__r.COH_Account_PatientAccess_SSN__c;

          if (
            field.fieldName === "Insurance_Street_1__c" &&
            this.isInsurance1 === true
          )
            field.value = this.record.Account__r.Patient_Street1__c;
          if (
            field.fieldName === "Insurance_Street_2__c" &&
            this.isInsurance2 === true
          )
            field.value = this.record.Account__r.Patient_Street1__c;
          if (
            field.fieldName === "Insurance_Street_3__c" &&
            this.isInsurance3 === true
          )
            field.value = this.record.Account__r.Patient_Street1__c;

          if (
            field.fieldName === "Insurance_State_1__c" &&
            this.isInsurance1 === true
          )
            field.value = this.record.Account__r.COH_PA_State__c;
          if (
            field.fieldName === "Insurance_State_2__c" &&
            this.isInsurance2 === true
          )
            field.value = this.record.Account__r.COH_PA_State__c;
          if (
            field.fieldName === "Insurance_State_3__c" &&
            this.isInsurance3 === true
          )
            field.value = this.record.Account__r.COH_PA_State__c;

          if (
            field.fieldName === "Insurance_Country_1__c" &&
            this.isInsurance1 === true
          )
            field.value = this.record.Account__r.COH_PA_Country__c;
          if (
            field.fieldName === "Insurance_Country_2__c" &&
            this.isInsurance2 === true
          )
            field.value = this.record.Account__r.COH_PA_Country__c;
          if (
            field.fieldName === "Insurance_Country_3__c" &&
            this.isInsurance3 === true
          )
            field.value = this.record.Account__r.COH_PA_Country__c;

          if (
            field.fieldName === "Insurance_City_1__c" &&
            this.isInsurance1 === true
          )
            field.value = this.record.Account__r.Patient_City__c;
          if (
            field.fieldName === "Insurance_City_2__c" &&
            this.isInsurance2 === true
          )
            field.value = this.record.Account__r.Patient_City__c;
          if (
            field.fieldName === "Insurance_City_3__c" &&
            this.isInsurance3 === true
          )
            field.value = this.record.Account__r.Patient_City__c;

          if (
            field.fieldName === "Insurance_PostalCode_1__c" &&
            this.isInsurance1 === true
          )
            field.value = this.record.Account__r.Patient_Postal_Code__c;
          if (
            field.fieldName === "Insurance_PostalCode_2__c" &&
            this.isInsurance2 === true
          )
            field.value = this.record.Account__r.Patient_Postal_Code__c;
          if (
            field.fieldName === "Insurance_PostalCode_3__c" &&
            this.isInsurance3 === true
          )
            field.value = this.record.Account__r.Patient_Postal_Code__c;

          if (
            field.fieldName === "Insurance_Subscriber_Member_Id_1__c" &&
            this.isInsurance1 === true
          )
            field.value = this.subscriberId1;
          if (
            field.fieldName === "Insurance_Subscriber_Member_Id_2__c" &&
            this.isInsurance2 === true
          )
            field.value = this.SubscriberId2;
          if (
            field.fieldName === "Insurance_Subscriber_Member_Id_3__c" &&
            this.isInsurance3 === true
          )
            field.value = this.SubscriberId3;
        });
      }
      if (this.isInsurance1 === true) {
        this.disableMemberId1 = true;
        console.log("subscriberId1: ", this.subscriberId1);
        console.log("memberId1: ", this.memberId1);
      }
      if (this.isInsurance2 === true) {
        this.disableMemberId2 = true;
        console.log("subscriberId2: ", this.subscriberId2);
        console.log("memberId2: ", this.memberId2);
      }
      if (this.isInsurance3 === true) {
        this.disableMemberId3 = true;
        console.log("subscriberId3: ", this.subscriberId3);
        console.log("memberId3: ", this.memberId3);
      }
    }
    if (event.detail.status === "cancel") this.isDialogVisible = false;
  }

  handleSubmit() {
    this.isLoading = true;
  }

  async handleSuccessInsurance1() {
    console.log("getRecordNotifyChange : ", this.recordId);
    getRecordNotifyChange([{ recordId: this.recordId }]);
    this.isLoading = false;
    const toastEvt = new ShowToastEvent({
      title: "Insurance 1 Save Successfully",
      variant: "success"
    });
    this.dispatchEvent(toastEvt);
    document.dispatchEvent(new CustomEvent("aura://refreshView"));
  }

  handleSuccessInsurance2() {
    this.isLoading = false;
    const toastEvt = new ShowToastEvent({
      title: "Insurance 2 Save Successfully",
      variant: "success"
    });
    this.dispatchEvent(toastEvt);
    document.dispatchEvent(new CustomEvent("aura://refreshView"));
  }

  handleSuccessInsurance3() {
    this.isLoading = false;
    const toastEvt = new ShowToastEvent({
      title: "Insurance 3 Save Successfully",
      variant: "success"
    });
    this.dispatchEvent(toastEvt);
    document.dispatchEvent(new CustomEvent("aura://refreshView"));
  }

  handleError() {
    this.isLoading = false;
    const toastEvt = new ShowToastEvent({
      title: "Update Failed",
      variant: "error"
    });
    this.dispatchEvent(toastEvt);
  }

  determineAddress1Visibility(event) {
    this.lookupId = event.target.value;
    if (this.lookupId != null) {
      getPurchaserPlanName({ purchaserPlanId: this.lookupId })
        .then((result) => {
          console.log("created....", result);
          this.purchaserPlan1Name = result;
          console.log("this.purchaserPlan1Name: " + this.purchaserPlan1Name);
          if (this.purchaserPlan1Name.includes("GENERIC")) {
            this.showPayerAddress1 = true;
          }
          if (!this.purchaserPlan1Name.includes("GENERIC")) {
            this.showPayerAddress1 = false;
          }
        })
        .catch((error) => {
          console.log("Error", error);
        });
    }
  }

  determineAddress2Visibility(event) {
    this.lookupId = event.target.value;
    if (this.lookupId != null) {
      getPurchaserPlanName({ purchaserPlanId: this.lookupId })
        .then((result) => {
          console.log("created....", result);
          this.purchaserPlan2Name = result;
          console.log("this.purchaserPlan2Name: " + this.purchaserPlan2Name);
          if (this.purchaserPlan2Name.includes("GENERIC")) {
            this.showPayerAddress2 = true;
          }
          if (!this.purchaserPlan2Name.includes("GENERIC")) {
            this.showPayerAddress2 = false;
          }
        })
        .catch((error) => {
          console.log("Error", error);
        });
    }
  }

  determineAddress3Visibility(event) {
    this.lookupId = event.target.value;
    if (this.lookupId != null) {
      getPurchaserPlanName({ purchaserPlanId: this.lookupId })
        .then((result) => {
          console.log("created....", result);
          this.purchaserPlan3Name = result;
          console.log("this.purchaserPlan3Name: " + this.purchaserPlan3Name);
          if (this.purchaserPlan3Name.includes("GENERIC")) {
            this.showPayerAddress3 = true;
          }
          if (!this.purchaserPlan3Name.includes("GENERIC")) {
            this.showPayerAddress3 = false;
          }
        })
        .catch((error) => {
          console.log("Error", error);
        });
    }
  }
}