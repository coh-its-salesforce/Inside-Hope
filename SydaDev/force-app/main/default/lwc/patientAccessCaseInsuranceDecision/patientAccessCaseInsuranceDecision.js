import { LightningElement, wire, api, track } from 'lwc';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import Question_Service_Categories_FIELD from '@salesforce/schema/Insurance_Matrix__c.QUESTION_Service_Categories__c';
import Question_Line_of_Business_FIELD from '@salesforce/schema/Insurance_Matrix__c.QUESTION_Line_of_Bus__c';
import Question_Product_FIELD from '@salesforce/schema/Insurance_Matrix__c.QUESTION_Product__c';
import Question_HealthPlan_FIELD from '@salesforce/schema/Insurance_Matrix__c.QUESTION_Insurance_Plans__c';
import Medical_Group_FIELD from '@salesforce/schema/Insurance_Matrix__c.Medical_Group__c';
import Insurance_Matrix_OBJECT from '@salesforce/schema/Insurance_Matrix__c';
import searchServiceCategory from '@salesforce/apex/COHCaseInsuranceTabController.getServiceCategoryValues';
import searchPlanType from '@salesforce/apex/COHCaseInsuranceTabController.getPlanTypeValues';
import searchLineofBusiness from '@salesforce/apex/COHCaseInsuranceTabController.getLineOfBusinessValuesServer';
import searchHealthPlan from '@salesforce/apex/COHCaseInsuranceTabController.getHealthPlanValuesServer';
import searchMedicalGroupIPA from '@salesforce/apex/COHCaseInsuranceTabController.getMedicalGroupIPAValuesServer';


export default class PatientAccessCaseInsuranceDecision extends LightningElement {
    @api strRecordId;
    @api strRecordTypeId;
    @api strObjectName;
    /*Output Attributes*/
    @api servicecategoriesvalue;
    @api plantypevalue;
    @api lineofbusinessvalue;
    @api healthplanvalue;
    @api medicalgroupipavalue;
    @api doespatienthaveauthvalue;
    @api doespatienthaveauthvalueyesorno;
    
    @wire(getObjectInfo, { objectApiName: Insurance_Matrix_OBJECT })insuranceMatrixMetadata;
    
    @track servicecategoriesoptions;

    @track plantypeoptions;

    @track lineofbusinessoptions;

    @track healthplanoptions;    
    
    @track medicalgroupipaoptions;

    @track authpicklistoptions = [{label:'No', value:'No'},{label:'Yes', value:'Yes'}];

    isAuthAvaliable = false;

    handleChangeServiceCategories (event){
        this.servicecategoriesvalue = 'OP-Prof (Office/Clinic)';
        searchPlanType({
            serviceCategory: 'OP-Prof (Office/Clinic)',
            lineOfBusiness: this.lineofbusinessvalue,
            healthPlan: this.healthplanvalue,
            medicalGroupIPA: this.medicalgroupipavalue,
        })
        .then(result =>{           
            this.plantypeoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.plantypevalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.plantypeoptions = undefined;
        })

        searchLineofBusiness({
            serviceCategory: 'OP-Prof (Office/Clinic)',
            planType: this.plantypevalue,
            healthPlan: this.healthplanvalue,
            medicalGroupIPA: this.medicalgroupipavalue,
        })
        .then(result =>{           
            this.lineofbusinessoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.lineofbusinessvalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.lineofbusinessoptions = undefined;
        })
        
        searchHealthPlan({
            serviceCategory: 'OP-Prof (Office/Clinic)',
            planType: this.plantypevalue,
            lineOfBusiness: this.lineofbusinessvalue,
            medicalGroupIPA: this.medicalgroupipavalue,
        })
        .then(result =>{            
            this.healthplanoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.healthplanvalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.healthplanoptions = undefined;
        })

        searchMedicalGroupIPA({
            serviceCategory: 'OP-Prof (Office/Clinic)',
            planType: this.plantypevalue,
            lineOfBusiness: this.lineofbusinessvalue,
            healthPlan: this.healthplanvalue,
        })
        .then(result =>{            
            this.medicalgroupipaoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.medicalgroupipavalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.medicalgroupipaoptions = undefined;
        })
        
        window.setTimeout(()=> {
            this.handleRefMatrix ();
        }, 1000);
    }

    handleChangePlanType (event){
        this.plantypevalue = event.target.value;
        this.servicecategoriesvalue = 'OP-Prof (Office/Clinic)';
        searchServiceCategory({
            planType: this.plantypevalue,
            lineOfBusiness: this.lineofbusinessvalue,
            healthPlan: this.healthplanvalue,
            medicalGroupIPA: this.medicalgroupipavalue,
        })
        .then(result =>{            
            this.servicecategoriesoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.servicecategoriesvalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.servicecategoriesoptions = undefined;
        })
        searchLineofBusiness({
            serviceCategory: 'OP-Prof (Office/Clinic)',
            planType: this.plantypevalue,
            healthPlan: this.healthplanvalue,
            medicalGroupIPA: this.medicalgroupipavalue,
        })
        .then(result =>{
            this.lineofbusinessoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
               this.lineofbusinessvalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.lineofbusinessoptions = undefined;
        })
        
        searchHealthPlan({
            serviceCategory: 'OP-Prof (Office/Clinic)',
            planType: this.plantypevalue,
            lineOfBusiness: this.lineofbusinessvalue,
            medicalGroupIPA: this.medicalgroupipavalue,
        })
        .then(result =>{
            this.healthplanoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.healthplanvalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.healthplanoptions = undefined;
        })

        searchMedicalGroupIPA({
            serviceCategory: 'OP-Prof (Office/Clinic)',
            planType: this.plantypevalue,
            lineOfBusiness: this.lineofbusinessvalue,
            healthPlan: this.healthplanvalue,
        })
        .then(result =>{
            this.medicalgroupipaoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.medicalgroupipavalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.medicalgroupipaoptions = undefined;
        })

        window.setTimeout(()=> {
            this.handleRefMatrix ();
        }, 1000);
    }
 
    handleChangeLineofBusiness (event){
        this.lineofbusinessvalue = event.target.value;
        this.servicecategoriesvalue = 'OP-Prof (Office/Clinic)';
        searchServiceCategory({
            planType: this.plantypevalue,
            lineOfBusiness: this.lineofbusinessvalue,
            healthPlan: this.healthplanvalue,
            medicalGroupIPA: this.medicalgroupipavalue,
        })
        .then(result =>{
            this.servicecategoriesoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.servicecategoriesvalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.servicecategoriesoptions = undefined;
        })
        searchPlanType({
            serviceCategory: 'OP-Prof (Office/Clinic)',
            lineOfBusiness: this.lineofbusinessvalue,
            healthPlan: this.healthplanvalue,
            medicalGroupIPA: this.medicalgroupipavalue,
        })
        .then(result =>{
            this.plantypeoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.plantypevalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.plantypeoptions = undefined;
        })

        searchHealthPlan({
            serviceCategory: 'OP-Prof (Office/Clinic)',
            planType: this.plantypevalue,
            lineOfBusiness: this.lineofbusinessvalue,
            medicalGroupIPA: this.medicalgroupipavalue,
        })
        .then(result =>{
            this.healthplanoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.healthplanvalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.healthplanoptions = undefined;
        })

        searchMedicalGroupIPA({
            serviceCategory: 'OP-Prof (Office/Clinic)',
            planType: this.plantypevalue,
            lineOfBusiness: this.lineofbusinessvalue,
            healthPlan: this.healthplanvalue,
        })
        .then(result =>{
            this.medicalgroupipaoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.medicalgroupipavalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.medicalgroupipaoptions = undefined;
        })

        window.setTimeout(()=> {
            this.handleRefMatrix ();
        }, 1000);
    }
    
    handleChangeHealthPlan (event){
        this.healthplanvalue = event.target.value;
        this.servicecategoriesvalue = 'OP-Prof (Office/Clinic)';
        searchServiceCategory({
            planType: this.plantypevalue,
            lineOfBusiness: this.lineofbusinessvalue,
            healthPlan: this.healthplanvalue,
            medicalGroupIPA: this.medicalgroupipavalue,
        })
        .then(result =>{
            this.servicecategoriesoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.servicecategoriesvalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.servicecategoriesoptions = undefined;
        })
        searchPlanType({
            serviceCategory: this.servicecategoriesvalue,
            lineOfBusiness: this.lineofbusinessvalue,
            healthPlan: this.healthplanvalue,
            medicalGroupIPA: this.medicalgroupipavalue,
        })
        .then(result =>{
            this.plantypeoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.plantypevalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.plantypeoptions = undefined;
        })
        
        searchLineofBusiness({
            serviceCategory: this.servicecategoriesvalue,
            planType: this.plantypevalue,
            healthPlan: this.healthplanvalue,
            medicalGroupIPA: this.medicalgroupipavalue,
        })
        .then(result =>{
            this.lineofbusinessoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.lineofbusinessvalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.lineofbusinessoptions = undefined;
        })

        searchMedicalGroupIPA({
            serviceCategory: this.servicecategoriesvalue,
            planType: this.plantypevalue,
            lineOfBusiness: this.lineofbusinessvalue,
            healthPlan: this.healthplanvalue,
        })
        .then(result =>{
            this.medicalgroupipaoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.medicalgroupipavalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.medicalgroupipaoptions = undefined;
        })

        window.setTimeout(()=> {
            this.handleRefMatrix ();
        }, 1000);
    }
    
    handleChangeMedicalGroupIPA (event){
        this.medicalgroupipavalue = event.target.value;
        this.servicecategoriesvalue = 'OP-Prof (Office/Clinic)';
        searchServiceCategory({
            planType: this.plantypevalue,
            lineOfBusiness: this.lineofbusinessvalue,
            healthPlan: this.healthplanvalue,
            medicalGroupIPA: this.medicalgroupipavalue,
        })
        .then(result =>{
            this.servicecategoriesoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.servicecategoriesvalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.servicecategoriesoptions = undefined;
        })
        searchPlanType({
            serviceCategory: this.servicecategoriesvalue,
            lineOfBusiness: this.lineofbusinessvalue,
            healthPlan: this.healthplanvalue,
            medicalGroupIPA: this.medicalgroupipavalue,
        })
        .then(result =>{
            this.plantypeoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.plantypevalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.plantypeoptions = undefined;
        })
        
        searchLineofBusiness({
            serviceCategory: this.servicecategoriesvalue,
            planType: this.plantypevalue,
            healthPlan: this.healthplanvalue,
            medicalGroupIPA: this.medicalgroupipavalue,
        })
        .then(result =>{
            this.lineofbusinessoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.lineofbusinessvalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.lineofbusinessoptions = undefined;
        })

        searchHealthPlan({
            serviceCategory: this.servicecategoriesvalue,
            planType: this.plantypevalue,
            lineOfBusiness: this.lineofbusinessvalue,
            medicalGroupIPA: this.medicalgroupipavalue,
        })
        .then(result =>{
            this.healthplanoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.healthplanvalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.healthplanoptions = undefined;
        })

        window.setTimeout(()=> {
            this.handleRefMatrix ();
        }, 1000);
    }
    
    handleChangedoesPatientHaveAuth(event){
        this.doespatienthaveauthvalue = event.target.value;
    }
    
    resetPicklistValues(event){
        this.plantypevalue = null;
        this.lineofbusinessvalue = null;
        this.healthplanvalue = null;
        this.medicalgroupipavalue= null;
        this.servicecategoriesvalue = 'OP-Prof (Office/Clinic)';
        searchPlanType({
            serviceCategory: this.servicecategoriesvalue,
            lineOfBusiness: this.lineofbusinessvalue,
            healthPlan: this.healthplanvalue,
            medicalGroupIPA: this.medicalgroupipavalue,
        })
        .then(result =>{
            this.plantypeoptions = result;
            this.errors = undefined;
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.plantypeoptions = undefined;
        })
        
        searchLineofBusiness({
            serviceCategory: this.servicecategoriesvalue,
            planType: this.plantypevalue,
            healthPlan: this.healthplanvalue,
            medicalGroupIPA: this.medicalgroupipavalue,
        })
        .then(result =>{
            this.lineofbusinessoptions = result;
            this.errors = undefined;
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.lineofbusinessoptions = undefined;
        })

        searchHealthPlan({
            serviceCategory: this.servicecategoriesvalue,
            planType: this.plantypevalue,
            lineOfBusiness: this.lineofbusinessvalue,
            medicalGroupIPA: this.medicalgroupipavalue,
        })
        .then(result =>{
            this.healthplanoptions = result;
            this.errors = undefined;
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.healthplanoptions = undefined;
        })
        searchMedicalGroupIPA({
            serviceCategory: this.servicecategoriesvalue,
            planType: this.plantypevalue,
            lineOfBusiness: this.lineofbusinessvalue,
            healthPlan: this.healthplanvalue,
        })
        .then(result =>{
            this.medicalgroupipaoptions = result;
            this.errors = undefined;
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.medicalgroupipaoptions = undefined;
        })
    }
    
    handleChangeAuthPickList(event) {
        this.doespatienthaveauthvalueyesorno = event.target.value;
        if (event.target.value === 'Yes'){
            this.isAuthAvaliable = true;
        } else {
            this.isAuthAvaliable = false;
            this.doespatienthaveauthvalue = '';
        } 
    }

    handleChangeAuthvalue(event) {
        this.doespatienthaveauthvalue = event.target.value;
    }

    connectedCallback(){
        this.servicecategoriesvalue = 'OP-Prof (Office/Clinic)';
        searchServiceCategory({
            planType: this.plantypevalue,
            lineOfBusiness: this.lineofbusinessvalue,
            healthPlan: this.healthplanvalue,
            medicalGroupIPA: this.medicalgroupipavalue,
        })
        .then(result =>{
            this.servicecategoriesoptions = result;
            this.errors = undefined;
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.servicecategoriesoptions = undefined;
        })

        searchPlanType({
            serviceCategory: 'OP-Prof (Office/Clinic)',
            lineOfBusiness: this.lineofbusinessvalue,
            healthPlan: this.healthplanvalue,
            medicalGroupIPA: this.medicalgroupipavalue,
        })
        .then(result =>{
            this.plantypeoptions = result;
            this.errors = undefined;
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.plantypeoptions = undefined;
        })

        searchLineofBusiness({
            serviceCategory: 'OP-Prof (Office/Clinic)',
            planType: this.plantypevalue,
            healthPlan: this.healthplanvalue,
            medicalGroupIPA: this.medicalgroupipavalue,
        })
        .then(result =>{
            this.lineofbusinessoptions = result;
            this.errors = undefined;
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.lineofbusinessoptions = undefined;
        })

        searchHealthPlan({
        serviceCategory: 'OP-Prof (Office/Clinic)',
        planType: this.plantypevalue,
        lineOfBusiness: this.lineofbusinessvalue,
        medicalGroupIPA: this.medicalgroupipavalue,
        })
        .then(result =>{
            this.healthplanoptions = result;
            this.errors = undefined;
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.healthplanoptions = undefined;
        })

        searchMedicalGroupIPA({
            serviceCategory: 'OP-Prof (Office/Clinic)',
            planType: this.plantypevalue,
            lineOfBusiness: this.lineofbusinessvalue,
            healthPlan: this.healthplanvalue,
        })
        .then(result =>{
            this.medicalgroupipaoptions = result;
            this.errors = undefined;
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.medicalgroupipaoptions = undefined;
        })
        
        if (this.doespatienthaveauthvalueyesorno === 'Yes'){
            this.isAuthAvaliable = true;  
        }
    }

    handleRefMatrix () {
        this.dispatchEvent(new CustomEvent('refreshmatrix'));
    }
}