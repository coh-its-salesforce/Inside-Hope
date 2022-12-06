import { LightningElement, wire, api, track } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { updateRecord } from 'lightning/uiRecordApi';

import Insurance_Matrix_OBJECT from '@salesforce/schema/Insurance_Matrix__c';
import searchLocation from '@salesforce/apex/COHCaseInsuranceTabController.getLocationValuesServer';
import searchDepartment from '@salesforce/apex/COHCaseInsuranceTabController.getDepartmentValuesServer';
import searchServiceLine from '@salesforce/apex/COHCaseInsuranceTabController.getServiceLineValuesServer';
import searchSpecialty from '@salesforce/apex/COHCaseInsuranceTabController.getSpecialtyValuesServer';
import searchPhysician from '@salesforce/apex/COHCaseInsuranceTabController.getPhysiciansServer';
import getPhysicianId from '@salesforce/apex/COHCaseInsuranceTabController.getPhysicianID';


export default class patientAccessPhysicianDecisionSearch extends LightningElement {
    /*Output Attributes*/
    @api locationvalue;
    @api departmentvalue;
    @api servicelinevalue;
    @api specialtyvalue;
    @api physicianvalue;
    @api physicianid;
    @api inspdcc;
    @api strRecordId;
    @api diagnosisNotListed; //CHANGES BY SANJAY 05/23/2022

    @wire(getObjectInfo, { objectApiName: Insurance_Matrix_OBJECT })insuranceMatrixMetadata;
    
    @track locationoptions;
    @track departmentoptions;
    @track servicelineoptions;
    @track specialtyoptions;    
    @track physicianoptions;
    @track isPhysicanupdate = false;



    handleChangeLocation (event){
        this.locationvalue = event.target.value;
        searchLocation({
            department: this.departmentvalue,
            serviceline: this.servicelinevalue,
            specialty: this.specialtyvalue,
            physician: this.physicianvalue,
            inspdccs: this.inspdcc
        })
        .then(result =>{
            this.locationoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.locationvalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.locationoptions = undefined;
        })

        searchDepartment({
            location: this.locationvalue,
            serviceline: this.servicelinevalue,
            specialty: this.specialtyvalue,
            physician: this.physicianvalue,
            inspdccs: this.inspdcc
        })
        .then(result =>{
            this.departmentoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.departmentvalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.departmentoptions = undefined;
        })
        
        searchServiceLine({
            location: this.locationvalue,
            department: this.departmentvalue,
            specialty: this.specialtyvalue,
            physician: this.physicianvalue,
            inspdccs: this.inspdcc
        })
        .then(result =>{
            this.servicelineoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.servicelinevalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.servicelineoptions = undefined;
        })

        searchSpecialty({
            location: this.locationvalue,
            department: this.departmentvalue,
            serviceline: this.servicelinevalue,
            physician: this.physicianvalue,
            inspdccs: this.inspdcc
        })
        .then(result =>{
            this.specialtyoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.specialtyvalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.specialtyoptions = undefined;
        })
        searchPhysician({
            location: this.locationvalue,
            department: this.departmentvalue,
            serviceline: this.servicelinevalue,
            specialty: this.specialtyvalue,
            inspdccs: this.inspdcc
        })
        .then(result =>{            
            this.physicianoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.physicianvalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.physicianoptions = undefined;
        })    
        getPhysicianId({
            physicianStr:this.physicianvalue,
        })
        .then(result =>{            
            this.physicianid = result;
            this.errors = undefined;
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.physicianid = undefined;
        })    
        window.setTimeout(()=> {  
        const searchEvent = new CustomEvent('search',{
            detail : {
                location: this.locationvalue,
                department: this.departmentvalue,
                serviceline: this.servicelinevalue,
                specialty: this.specialtyvalue,
                physician: this.physicianvalue,
                physicianId: this.physicianid,
            }
        });
        this.dispatchEvent(searchEvent);
        }, 1500);
    }

    handleChangeDepartment (event){
        this.departmentvalue = event.target.value;
        searchLocation({
            department: this.departmentvalue,
            serviceline: this.servicelinevalue,
            specialty: this.specialtyvalue,
            physician: this.physicianvalue,
            inspdccs: this.inspdcc,
        })
        .then(result =>{            
            this.locationoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.locationvalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.locationoptions = undefined;
        })
        
        searchServiceLine({
            location: this.locationvalue,
            department: this.departmentvalue,
            specialty: this.specialtyvalue,
            physician: this.physicianvalue,
            inspdccs: this.inspdcc
        })
        .then(result =>{           
            this.servicelineoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.servicelinevalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.servicelineoptions = undefined;
        })

        searchSpecialty({
            location: this.locationvalue,
            department: this.departmentvalue,
            serviceline: this.servicelinevalue,
            physician: this.physicianvalue,
            inspdccs: this.inspdcc
        })
        .then(result =>{           
            this.specialtyoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.specialtyvalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.specialtyoptions = undefined;
        })
        searchPhysician({
            location: this.locationvalue,
            department: this.departmentvalue,
            serviceline: this.servicelinevalue,
            specialty: this.specialtyvalue,
            inspdccs: this.inspdcc
        })
        .then(result =>{
            this.physicianoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.physicianvalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.physicianoptions = undefined;
        })
        getPhysicianId({
            physicianStr:this.physicianvalue,
        })
        .then(result =>{            
            this.physicianid = result;
            this.errors = undefined;
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.physicianid = undefined;
        })
        
        window.setTimeout(()=> {
        const searchEvent = new CustomEvent('search',{
            detail : {
                location: this.locationvalue,
                department: this.departmentvalue,
                serviceline: this.servicelinevalue,
                specialty: this.specialtyvalue,
                physician: this.physicianvalue,
                physicianId: this.physicianid,
            }
        });
        this.dispatchEvent(searchEvent);
        }, 1500);
    }
 
    handleChangeServiceLine (event){
        this.servicelinevalue= event.target.value;
        searchLocation({
            department: this.departmentvalue,
            serviceline: this.servicelinevalue,
            specialty: this.specialtyvalue,
            physician: this.physicianvalue,
            inspdccs: this.inspdcc,
        })
        .then(result =>{           
            this.locationoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.locationvalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.locationoptions = undefined;
        })

        searchDepartment({
            location: this.locationvalue,
            serviceline: this.servicelinevalue,
            specialty: this.specialtyvalue,
            physician: this.physicianvalue,
            inspdccs: this.inspdcc
        })
        .then(result =>{            
            this.departmentoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.departmentvalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.departmentoptions = undefined;
        })
        
        searchSpecialty({
            location: this.locationvalue,
            department: this.departmentvalue,
            serviceline: this.servicelinevalue,
            physician: this.physicianvalue,
            inspdccs: this.inspdcc
        })
        .then(result =>{           
            this.specialtyoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.specialtyvalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.specialtyoptions = undefined;
        })
        searchPhysician({
            location: this.locationvalue,
            department: this.departmentvalue,
            serviceline: this.servicelinevalue,
            specialty: this.specialtyvalue,
            inspdccs: this.inspdcc
        })
        .then(result =>{            
            this.physicianoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.physicianvalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.physicianoptions = undefined;
        })
        getPhysicianId({
            physicianStr:this.physicianvalue,
        })
        .then(result =>{            
            this.physicianid = result;
            this.errors = undefined;
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.physicianid = undefined;
        })

        window.setTimeout(()=> {
        const searchEvent = new CustomEvent('search',{
            detail : {
                location: this.locationvalue,
                department: this.departmentvalue,
                serviceline: this.servicelinevalue,
                specialty: this.specialtyvalue,
                physician: this.physicianvalue,
                physicianId: this.physicianid,
            }
        });
        this.dispatchEvent(searchEvent);
        }, 1500);
    }
    
    handleChangeSpecialty (event){
        this.specialtyvalue = event.target.value;
        searchLocation({
            department: this.departmentvalue,
            serviceline: this.servicelinevalue,
            specialty: this.specialtyvalue,
            physician: this.physicianvalue,
            inspdccs: this.inspdcc,
        })
        .then(result =>{           
            this.locationoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.locationvalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.locationoptions = undefined;
        })

        searchDepartment({
            location: this.locationvalue,
            serviceline: this.servicelinevalue,
            specialty: this.specialtyvalue,
            physician: this.physicianvalue,
            inspdccs: this.inspdcc
        })
        .then(result =>{            
            this.departmentoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.departmentvalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.departmentoptions = undefined;
        })
        
        searchServiceLine({
            location: this.locationvalue,
            department: this.departmentvalue,
            specialty: this.specialtyvalue,
            physician: this.physicianvalue,
            inspdccs: this.inspdcc
        })
        .then(result =>{           
            this.servicelineoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.servicelinevalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.servicelineoptions = undefined;
        })

        searchPhysician({
            location: this.locationvalue,
            department: this.departmentvalue,
            serviceline: this.servicelinevalue,
            specialty: this.specialtyvalue,
            inspdccs: this.inspdcc
        })
        .then(result =>{            
            this.physicianoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.physicianvalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.physicianoptions = undefined;
        })
        getPhysicianId({
            physicianStr:this.physicianvalue,
        })
        .then(result =>{            
            this.physicianid = result;
            this.errors = undefined;
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.physicianid = undefined;
        })
        window.setTimeout(()=> {
        const searchEvent = new CustomEvent('search',{
            detail : {
                location: this.locationvalue,
                department: this.departmentvalue,
                serviceline: this.servicelinevalue,
                specialty: this.specialtyvalue,
                physician: this.physicianvalue,
                physicianId: this.physicianid,
            }
        });
        this.dispatchEvent(searchEvent);
        }, 1500);
    }
    
    handleChangePhysician (event){
        this.physicianvalue = event.target.value;
        searchLocation({
            department: this.departmentvalue,
            serviceline: this.servicelinevalue,
            specialty: this.specialtyvalue,
            physician: this.physicianvalue,
            inspdccs: this.inspdcc,
        })
        .then(result =>{            
            this.locationoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.locationvalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.locationoptions = undefined;
        })

        searchDepartment({
            location: this.locationvalue,
            serviceline: this.servicelinevalue,
            specialty: this.specialtyvalue,
            physician: this.physicianvalue,
            inspdccs: this.inspdcc
        })
        .then(result =>{           
            this.departmentoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.departmentvalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.departmentoptions = undefined;
        })
        
        searchServiceLine({
            location: this.locationvalue,
            department: this.departmentvalue,
            specialty: this.specialtyvalue,
            physician: this.physicianvalue,
            inspdccs: this.inspdcc
        })
        .then(result =>{            
            this.servicelineoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.servicelinevalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.servicelineoptions = undefined;
        })

        searchSpecialty({
            location: this.locationvalue,
            department: this.departmentvalue,
            serviceline: this.servicelinevalue,
            physician: this.physicianvalue,
            inspdccs: this.inspdcc
        })
        .then(result =>{            
            this.specialtyoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.specialtyvalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.specialtyoptions = undefined;
        })
        getPhysicianId({
            physicianStr:this.physicianvalue,
        })
        .then(result =>{           
            this.physicianid = result;
            this.errors = undefined;
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.physicianid = undefined;
        })
        window.setTimeout(()=> {
        const searchEvent = new CustomEvent('search',{
            detail : {
                location: this.locationvalue,
                department: this.departmentvalue,
                serviceline: this.servicelinevalue,
                specialty: this.specialtyvalue,
                physician: this.physicianvalue,
                physicianId: this.physicianid,
            }
        });
        this.dispatchEvent(searchEvent);
        }, 1500);
    }
    
    handleChangedoesPatientHaveAuth(event){
        this.doespatienthaveauthvalue = event.target.value;
    }
    
    resetPicklistValues(event){
        this.locationvalue = null;
        this.departmentvalue = null;
        this.servicelinevalue = null;
        this.specialtyvalue= null;
        this.physicianvalue= null;
        this.physicianid= null;
        searchLocation({
            department: this.departmentvalue,
            serviceline: this.servicelinevalue,
            specialty: this.specialtyvalue,
            physician: this.physicianvalue,
            inspdccs: this.inspdcc,
        })
        .then(result =>{            
            this.locationoptions = result;
            this.errors = undefined;
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.locationoptions = undefined;
        })

        searchDepartment({
            location: this.locationvalue,
            serviceline: this.servicelinevalue,
            specialty: this.specialtyvalue,
            physician: this.physicianvalue,
            inspdccs: this.inspdcc
        })
        .then(result =>{           
            this.departmentoptions = result;
            this.errors = undefined;
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.departmentoptions = undefined;
        })
        
        searchServiceLine({
            location: this.locationvalue,
            department: this.departmentvalue,
            specialty: this.specialtyvalue,
            physician: this.physicianvalue,
            inspdccs: this.inspdcc
        })
        .then(result =>{            
            this.servicelineoptions = result;
            this.errors = undefined;
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.servicelineoptions = undefined;
        })

        searchSpecialty({
            location: this.locationvalue,
            department: this.departmentvalue,
            serviceline: this.servicelinevalue,
            physician: this.physicianvalue,
            inspdccs: this.inspdcc
        })
        .then(result =>{            
            this.specialtyoptions = result;
            this.errors = undefined;
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.specialtyoptions = undefined;
        })
        searchPhysician({
            location: this.locationvalue,
            department: this.departmentvalue,
            serviceline: this.servicelinevalue,
            specialty: this.specialtyvalue,
            inspdccs: this.inspdcc
        })
        .then(result =>{
            this.physicianoptions = result;
            this.errors = undefined;
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.physicianoptions = undefined;
        })
        getPhysicianId({
            physicianStr:this.physicianvalue,
        })
        .then(result =>{            
            this.physicianid = result;
            this.errors = undefined;
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.physicianid = undefined;
        })
        window.setTimeout(()=> {
        const searchEvent = new CustomEvent('search',{
            detail : {
                location: this.locationvalue,
                department: this.departmentvalue,
                serviceline: this.servicelinevalue,
                specialty: this.specialtyvalue,
                physician: this.physicianvalue,
                physicianId: this.physicianid,
            }
        });
        this.dispatchEvent(searchEvent);
    },1000);

    let querySelector = this.template.querySelectorAll('c-reusable-custom-pick-list-with-search');
    querySelector[0].resetParam();
    querySelector[1].resetParam();
    }
    
    connectedCallback(){
        searchLocation({
            department: this.departmentvalue,
            serviceline: this.servicelinevalue,
            specialty: this.specialtyvalue,
            physician: this.physicianvalue,
            inspdccs: this.inspdcc,
        })
        .then(result =>{            
            this.locationoptions = result;
            this.errors = undefined;
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.locationoptions = undefined;
        })

        searchDepartment({
            location: this.locationvalue,
            serviceline: this.servicelinevalue,
            specialty: this.specialtyvalue,
            physician: this.physicianvalue,
            inspdccs: this.inspdcc
        })
        .then(result =>{            
            this.departmentoptions = result;
            this.errors = undefined;
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.departmentoptions = undefined;
        })
        
        searchServiceLine({
            location: this.locationvalue,
            department: this.departmentvalue,
            specialty: this.specialtyvalue,
            physician: this.physicianvalue,
            inspdccs: this.inspdcc
        })
        .then(result =>{            
            this.servicelineoptions = result;
            this.errors = undefined;
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.servicelineoptions = undefined;
        })

        searchSpecialty({
            location: this.locationvalue,
            department: this.departmentvalue,
            serviceline: this.servicelinevalue,
            physician: this.physicianvalue,
            inspdccs: this.inspdcc
        })
        .then(result =>{            
            this.specialtyoptions = result;
            this.errors = undefined;
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.specialtyoptions = undefined;
        })
        searchPhysician({
            location: this.locationvalue,
            department: this.departmentvalue,
            serviceline: this.servicelinevalue,
            specialty: this.specialtyvalue,
            inspdccs: this.inspdcc
        })
        .then(result =>{            
            this.physicianoptions = result;
            this.errors = undefined;
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.physicianoptions = undefined;
        })
        getPhysicianId({
            physicianStr:this.physicianvalue,
        })
        .then(result =>{            
            this.physicianid = result;
            this.errors = undefined;
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.physicianid = undefined;
        })
        const searchEvent = new CustomEvent('search',{
            detail : {
                location: this.locationvalue,
                department: this.departmentvalue,
                serviceline: this.servicelinevalue,
                specialty: this.specialtyvalue,
                physician: this.physicianvalue,
                physicianId: this.physicianid,
            }
        });
        this.dispatchEvent(searchEvent);
    }

    @api refreshInspdccValue () {
        this.isPhysicanupdate = true;
        this.handleRefreshInspdccset();
    }

    /**START: CHANGES BY SANJAY 05/23/2022 */
    handleDiagnosisListedChange(event) {
        this.diagnosisNotListed = event.target.checked;
    }
    /**END: CHANGES BY SANJAY 05/23/2022 */

    handleRefreshInspdccset () {       
        this.locationvalue = null;
        this.departmentvalue = null;
        this.servicelinevalue = null;
        this.specialtyvalue= null;
        this.physicianvalue= null;
        this.physicianid= null;
        
        searchLocation({
            department: this.departmentvalue,
            serviceline: this.servicelinevalue,
            specialty: this.specialtyvalue,
            physician: this.physicianvalue,
            inspdccs: this.inspdcc
        })
        .then(result =>{            
            this.locationoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.locationvalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.locationoptions = undefined;
        })

        searchDepartment({
            location: this.locationvalue,
            serviceline: this.servicelinevalue,
            specialty: this.specialtyvalue,
            physician: this.physicianvalue,
            inspdccs: this.inspdcc
        })
        .then(result =>{            
            this.departmentoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.departmentvalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.departmentoptions = undefined;
        })
        
        searchServiceLine({
            location: this.locationvalue,
            department: this.departmentvalue,
            specialty: this.specialtyvalue,
            physician: this.physicianvalue,
            inspdccs: this.inspdcc,
        })
        .then(result =>{           
            this.servicelineoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.servicelinevalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.servicelineoptions = undefined;
        })

        searchSpecialty({
            location: this.locationvalue,
            department: this.departmentvalue,
            serviceline: this.servicelinevalue,
            physician: this.physicianvalue,
            inspdccs: this.inspdcc
        })
        .then(result =>{            
            this.specialtyoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.specialtyvalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.specialtyoptions = undefined;
        })
        searchPhysician({
            location: this.locationvalue,
            department: this.departmentvalue,
            serviceline: this.servicelinevalue,
            specialty: this.specialtyvalue,
            inspdccs: this.inspdcc
        })
        .then(result =>{            
            this.physicianoptions = result;
            this.errors = undefined;
            if(result.length === 1) {
                this.physicianvalue = result[0].value;
            }
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.physicianoptions = undefined;
        })    
        getPhysicianId({
            physicianStr:this.physicianvalue,
        })
        .then(result =>{           
            this.physicianid = result;
            this.errors = undefined;
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.physicianid = undefined;
        })    
        window.setTimeout(()=> {
        const searchEvent = new CustomEvent('search',{
            detail : {
                location: this.locationvalue,
                department: this.departmentvalue,
                serviceline: this.servicelinevalue,
                specialty: this.specialtyvalue,
                physician: this.physicianvalue,
                physicianId: this.physicianid,
            }
        });
        this.dispatchEvent(searchEvent);
        }, 1500);

       if(this.isPhysicanupdate) {
        window.setTimeout(()=> {
            const recordInput = {fields:{ 
                Id : this.strRecordId,
                Specialty__c : this.specialtyvalue,
                Service_Line__c : this.servicelinevalue,
                Physician_Decision_Tree__c : this.physicianvalue,
                Location__c : this.locationvalue,
                Department__c : this.departmentvalue,
                Physician__c :  this.physicianId,
                Diagnosis_Not_Listed__c: !!this.diagnosisNotListed //CHANGES BY SANJAY 05/23/2022
            }};
            updateRecord(recordInput);
            this.isPhysicanupdate = false;
        },3000);
       }  
    }
}