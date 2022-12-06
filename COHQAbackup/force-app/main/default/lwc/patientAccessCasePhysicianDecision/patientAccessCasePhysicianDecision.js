import { LightningElement, wire, api, track } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';

import Insurance_Matrix_OBJECT from '@salesforce/schema/Insurance_Matrix__c';
import searchLocation from '@salesforce/apex/COHCaseInsuranceTabController.getLocationValuesServer';
import searchDepartment from '@salesforce/apex/COHCaseInsuranceTabController.getDepartmentValuesServer';
import searchServiceLine from '@salesforce/apex/COHCaseInsuranceTabController.getServiceLineValuesServer';
import searchSpecialty from '@salesforce/apex/COHCaseInsuranceTabController.getSpecialtyValuesServer';
import searchPhysician from '@salesforce/apex/COHCaseInsuranceTabController.getPhysiciansServer';
import getPhysicianId from '@salesforce/apex/COHCaseInsuranceTabController.getPhysicianID';


export default class patientAccessCasePhysicianDecision extends LightningElement {
    @api strRecordId;
    @api strRecordTypeId;
    @api strObjectName;
    /*Output Attributes*/
    @api locationvalue;
    @api departmentvalue;
    @api servicelinevalue;
    @api specialtyvalue;
    @api physicianvalue;
    @api physicianId;
    
    @wire(getObjectInfo, { objectApiName: Insurance_Matrix_OBJECT })insuranceMatrixMetadata;
    
    @track locationoptions;
    @track departmentoptions;
    @track servicelineoptions;
    @track specialtyoptions;    
    @track physicianoptions;



    handleChangeLocation (event){
        this.locationvalue = event.target.value;
        searchLocation({
            department: this.departmentvalue,
            serviceline: this.servicelinevalue,
            specialty: this.specialtyvalue,
            physician: this.physicianvalue,
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
            department: this.departmentvalue,
            location: this.locationvalue,
            specialty: this.specialtyvalue,
            physician: this.physicianvalue,
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
            department: this.departmentvalue,
            location: this.locationvalue,
            serviceline: this.servicelinevalue,
            physician: this.physicianvalue,
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
            department: this.departmentvalue,
            location: this.locationvalue,
            serviceline: this.servicelinevalue,
            specialty: this.specialtyvalue,
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
        const searchEvent = new CustomEvent('search',{
            detail : {
                location: this.locationvalue,
                department: this.departmentvalue,
                serviceline: this.servicelinevalue,
                specialty: this.specialtyvalue,
                physician: this.physicianvalue,
            }
        });
        this.dispatchEvent(searchEvent);
    }

    handleChangeDepartment (event){
        this.departmentvalue = event.target.value;
        searchLocation({
            department: this.departmentvalue,
            serviceline: this.servicelinevalue,
            specialty: this.specialtyvalue,
            physician: this.physicianvalue,
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
        
        searchServiceLine({
            department: this.departmentvalue,
            location: this.locationvalue,
            specialty: this.specialtyvalue,
            physician: this.physicianvalue,
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
            department: this.departmentvalue,
            location: this.locationvalue,
            serviceline: this.servicelinevalue,
            physician: this.physicianvalue,
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
            department: this.departmentvalue,
            location: this.locationvalue,
            serviceline: this.servicelinevalue,
            specialty: this.specialtyvalue,
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
        const searchEvent = new CustomEvent('search',{
            detail : {
                location: this.locationvalue,
                department: this.departmentvalue,
                serviceline: this.servicelinevalue,
                specialty: this.specialtyvalue,
                physician: this.physicianvalue,
            }
        });
        this.dispatchEvent(searchEvent);
    }
 
    handleChangeServiceLine (event){
        this.servicelinevalue = event.target.value;
        searchLocation({
            department: this.departmentvalue,
            serviceline: this.servicelinevalue,
            specialty: this.specialtyvalue,
            physician: this.physicianvalue,
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

        searchSpecialty({
            department: this.departmentvalue,
            location: this.locationvalue,
            serviceline: this.servicelinevalue,
            physician: this.physicianvalue,
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
            department: this.departmentvalue,
            location: this.locationvalue,
            serviceline: this.servicelinevalue,
            specialty: this.specialtyvalue,
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
        const searchEvent = new CustomEvent('search',{
            detail : {
                location: this.locationvalue,
                department: this.departmentvalue,
                serviceline: this.servicelinevalue,
                specialty: this.specialtyvalue,
                physician: this.physicianvalue,
            }
        });
        this.dispatchEvent(searchEvent);
    }
    
    handleChangeSpecialty (event){
        this.specialtyvalue = event.target.value;
        searchLocation({
            department: this.departmentvalue,
            serviceline: this.servicelinevalue,
            specialty: this.specialtyvalue,
            physician: this.physicianvalue,
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
            department: this.departmentvalue,
            location: this.locationvalue,
            specialty: this.specialtyvalue,
            physician: this.physicianvalue,
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

        searchPhysician({
            department: this.departmentvalue,
            location: this.locationvalue,
            serviceline: this.servicelinevalue,
            specialty: this.specialtyvalue,
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
        const searchEvent = new CustomEvent('search',{
            detail : {
                location: this.locationvalue,
                department: this.departmentvalue,
                serviceline: this.servicelinevalue,
                specialty: this.specialtyvalue,
                physician: this.physicianvalue,
            }
        });
        this.dispatchEvent(searchEvent);
    }
    
    handleChangePhysician (event){
        this.physicianvalue = event.target.value;
        searchLocation({
            department: this.departmentvalue,
            serviceline: this.servicelinevalue,
            specialty: this.specialtyvalue,
            physician: this.physicianvalue,
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
            department: this.departmentvalue,
            location: this.locationvalue,
            specialty: this.specialtyvalue,
            physician: this.physicianvalue,
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
            department: this.departmentvalue,
            location: this.locationvalue,
            serviceline: this.servicelinevalue,
            physician: this.physicianvalue,
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
        getPhysicianId({
            physicianStr:this.physicianvalue,
        })
        .then(result =>{
            this.physicianId = result;
            this.errors = undefined;
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.physicianId = undefined;
        })
        const searchEvent = new CustomEvent('search',{
            detail : {
                location: this.locationvalue,
                department: this.departmentvalue,
                serviceline: this.servicelinevalue,
                specialty: this.specialtyvalue,
                physician: this.physicianvalue,
            }
        });
        this.dispatchEvent(searchEvent);
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
        searchLocation({
            department: this.departmentvalue,
            serviceline: this.servicelinevalue,
            specialty: this.specialtyvalue,
            physician: this.physicianvalue,
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
            department: this.departmentvalue,
            location: this.locationvalue,
            specialty: this.specialtyvalue,
            physician: this.physicianvalue,
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
            department: this.departmentvalue,
            location: this.locationvalue,
            serviceline: this.servicelinevalue,
            physician: this.physicianvalue,
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
            department: this.departmentvalue,
            location: this.locationvalue,
            serviceline: this.servicelinevalue,
            specialty: this.specialtyvalue,
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
            this.physicianId = result;
            this.errors = undefined;
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.physicianId = undefined;
        })
        const searchEvent = new CustomEvent('search',{
            detail : {
                location: this.locationvalue,
                department: this.departmentvalue,
                serviceline: this.servicelinevalue,
                specialty: this.specialtyvalue,
                physician: this.physicianvalue,
            }
        });
        this.dispatchEvent(searchEvent);
    }
    
    connectedCallback(){
        searchLocation({
            department: this.departmentvalue,
            serviceline: this.servicelinevalue,
            specialty: this.specialtyvalue,
            physician: this.physicianvalue,
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
            department: this.departmentvalue,
            location: this.locationvalue,
            serviceline: this.servicelinevalue,
            specialty: this.specialtyvalue,
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
            this.physicianId = result;
            this.errors = undefined;
        })
        .catch(error =>{
            console.log(' Errors ', error);
            this.errors = error;
            this.physicianId = undefined;
        })
        const searchEvent = new CustomEvent('search',{
            detail : {
                location: this.locationvalue,
                department: this.departmentvalue,
                serviceline: this.servicelinevalue,
                specialty: this.specialtyvalue,
                physician: this.physicianvalue,
            }
        });
        this.dispatchEvent(searchEvent);
    }
}