/* eslint-disable @lwc/lwc/no-api-reassignments */
/* eslint-disable @lwc/lwc/no-leading-uppercase-api-name */
import { LightningElement, api, track } from "lwc";
import getSingleEpicAccountData from "@salesforce/apex/PatientAccessEpicAccountController.getEpicAccountData";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from "lightning/navigation";

export default class PatientAccessAccountEpicAccountDataGuarantor extends NavigationMixin(
  LightningElement
) {
  //Create an event listener to refresh lwc.
  @api recordId;
  @api objectApi = "Epic_Account_Data__c";
  @api record;
  @api error;
  @api epicAccountDataId;
  @api name;
  @api isLoading;
  @api AccountMRN;
  @track parelationshiptoguarantor;
  @track isDialogVisible;
  @track isGuarantor1;
  @track isGuarantor2;
  @track originalMessage;

  constructor(){
    super();
    document.addEventListener("lwc://refreshView",() =>{
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
          console.log("Account ID: " + this.record.Account__c);
        })
        .catch((error) => {
          console.log("Error", error);
        });
      this.isLoading = false;
    }); 
  }

  connectedCallback() {
    this.isLoading = true;
    getSingleEpicAccountData({ accountId: this.recordId })
      .then((result) => {
        console.log("created....", result);
        this.record = result;
        console.log("this.record: " + this.record);
        this.epicAccountDataId = this.record.Id;
        console.log("this.epicAccountDataId :" + this.epicAccountDataId);
        this.AccountMRN = this.record.Account_MRN_Formula__c;
        console.log("this.AccountMRN : " + this.AccountMRN);
        console.log(this.record.Account__c);
      })
      .catch((error) => {
        console.log("Error", error);
      });
    this.isLoading = false;
  }

  handleonchangeGuarantor1(event) {
    // alert(event.target.value);
    this.parelationshiptoguarantor = event.target.value;
    if (this.parelationshiptoguarantor === "Self") {
      this.originalMessage = "text message";
      this.isDialogVisible = true;
      this.isGuarantor1 = true;
    }
  }
  handleonchangeGuarantor2(event) {
    // alert(event.target.value);
    this.parelationshiptoguarantor = event.target.value;
    if (this.parelationshiptoguarantor === "Self") {
      this.originalMessage = "text message";
      this.isDialogVisible = true;
      this.isGuarantor2 = false;
    }
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
            field.fieldName === "Guarantor1_Birth_Date__c" &&
            this.isGuarantor1 === true
          )
            field.value = this.record.Account__r.PersonBirthdate;
          if (
            field.fieldName === "Guarantor2_Birth_Date__c" &&
            this.isGuarantor2 === false
          )
            field.value = this.record.Account__r.PersonBirthdate;

          if (
            field.fieldName === "Guarantor1_Gender__c" &&
            this.isGuarantor1 === true
          )
            field.value = this.record.Account__r.Gender__pc;
          if (
            field.fieldName === "Guarantor2_Gender__c" &&
            this.isGuarantor2 === false
          )
            field.value = this.record.Account__r.Gender__pc;

          if (
            field.fieldName === "Guarantor1_FirstName__c" &&
            this.isGuarantor1 === true
          )
            field.value = this.record.Account__r.FirstName;
          if (
            field.fieldName === "Guarantor2_FirstName__c" &&
            this.isGuarantor2 === false
          )
            field.value = this.record.Account__r.FirstName;

          if (
            field.fieldName === "Guarantor1_LastName__c" &&
            this.isGuarantor1 === true
          )
            field.value = this.record.Account__r.LastName;

          if (
            field.fieldName === "Guarantor2_LastName__c" &&
            this.isGuarantor2 === false
          )
            field.value = this.record.Account__r.LastName;

          if (
            field.fieldName === "Guarantor1_MiddleName__c" &&
            this.isGuarantor1 === true
          )
            field.value = this.record.Account__r.MiddleName;

          if (
            field.fieldName === "Guarantor2_MiddleName__c" &&
            this.isGuarantor2 === false
          )
            field.value = this.record.Account__r.MiddleName;

          if (
            field.fieldName === "Guarantor1_Home_Phone__c" &&
            this.isGuarantor1 === true
          )
            field.value = this.record.Account__r.PersonHomePhone;

          if (
            field.fieldName === "Guarantor2_Home_Phone__c" &&
            this.isGuarantor2 === false
          )
            field.value = this.record.Account__r.PersonHomePhone;

          if (
            field.fieldName === "Guarantor1_Home_Phone__c" &&
            this.isGuarantor1 === true
          )
            field.value = this.record.Account__r.PersonHomePhone;
          if (
            field.fieldName === "Guarantor2_Home_Phone__c" &&
            this.isGuarantor2 === false
          )
            field.value = this.record.Account__r.PersonHomePhone;

          if (
            field.fieldName === "Guarantor1_Mobile_Phone__c" &&
            this.isGuarantor1 === true
          )
            field.value = this.record.Account__r.PersonMobilePhone;
          if (
            field.fieldName === "Guarantor2_Mobile_Phone__c" &&
            this.isGuarantor2 === false
          )
            field.value = this.record.Account__r.PersonMobilePhone;

          if (
            field.fieldName === "Guarantor1_Work_Phone__c" &&
            this.isGuarantor1 === true
          )
            field.value = this.record.Account__r.PersonOtherPhone;
          if (
            field.fieldName === "Guarantor2_Work_Phone__c" &&
            this.isGuarantor2 === false
          )
            field.value = this.record.Account__r.PersonOtherPhone;

          if (
            field.fieldName === "Guarantor1_SSN__c" &&
            this.isGuarantor1 === true
          )
            field.value =
              this.record.Account__r.COH_Account_PatientAccess_SSN__c;
          if (
            field.fieldName === "Guarantor2_SSN__c" &&
            this.isGuarantor2 === false
          )
            field.value =
              this.record.Account__r.COH_Account_PatientAccess_SSN__c;

          if (
            field.fieldName === "Guarantor1_Street__c" &&
            this.isGuarantor1 === true
          )
            field.value = this.record.Account__r.Patient_Street1__c;
          if (
            field.fieldName === "Guarantor2_Street__c" &&
            this.isGuarantor2 === false
          )
            field.value = this.record.Account__r.Patient_Street1__c;

          if (
            field.fieldName === "Guarantor1_State__c" &&
            this.isGuarantor1 === true
          )
            field.value = this.record.Account__r.COH_PA_State__c;
          if (
            field.fieldName === "Guarantor2_State__c" &&
            this.isGuarantor2 === false
          )
            field.value = this.record.Account__r.COH_PA_State__c;

          if (
            field.fieldName === "Guarantor1_Country__c" &&
            this.isGuarantor1 === true
          )
            field.value = this.record.Account__r.COH_PA_Country__c;
          if (
            field.fieldName === "Guarantor2_Country__c" &&
            this.isGuarantor2 === false
          )
            field.value = this.record.Account__r.COH_PA_Country__c;

          if (
            field.fieldName === "Guarantor1_City__c" &&
            this.isGuarantor1 === true
          )
            field.value = this.record.Account__r.Patient_City__c;
          if (
            field.fieldName === "Guarantor2_City__c" &&
            this.isGuarantor2 === false
          )
            field.value = this.record.Account__r.Patient_City__c;

          if (
            field.fieldName === "Guarantor1_PostalCode__c" &&
            this.isGuarantor1 === true
          )
            field.value = this.record.Account__r.Patient_Postal_Code__c;
          if (
            field.fieldName === "Guarantor2_PostalCode__c" &&
            this.isGuarantor2 === false
          )
            field.value = this.record.Account__r.Patient_Postal_Code__c;
        });
      }
    }
    if (event.detail.status === "cancel") this.isDialogVisible = false;
  }
  handleSubmit() {
    this.isLoading = true;
  }

  handleSuccessGuarantor1() {
    this.isLoading = false;
    const toastEvt = new ShowToastEvent({
      title: "Guarantor 1 Save Successful",
      variant: "success"
    });
    this.dispatchEvent(toastEvt);
    document.dispatchEvent(new CustomEvent("aura://refreshView"));
  }

  /*handleSuccessGuarantor2() {
    this.isLoading = false;
    const toastEvt = new ShowToastEvent({
      title: "Guarantor 2 Save Successful",
      variant: "success"
    });
    this.dispatchEvent(toastEvt);
  }*/
}