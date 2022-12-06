import { LightningElement, track, api } from 'lwc';
import searchServiceCategory from '@salesforce/apex/COHCaseInsuranceTabController.getServiceCategoryValues';
import searchPlanType from '@salesforce/apex/COHCaseInsuranceTabController.getPlanTypeValues';
import searchLineofBusiness from '@salesforce/apex/COHCaseInsuranceTabController.getLineOfBusinessValuesServer';
import searchHealthPlan from '@salesforce/apex/COHCaseInsuranceTabController.getHealthPlanValuesServer';
import searchMedicalGroupIPA from '@salesforce/apex/COHCaseInsuranceTabController.getMedicalGroupIPAValuesServer';
import searchLocation from '@salesforce/apex/COHCaseInsuranceTabController.getLocationValuesServer';
import searchDepartment from '@salesforce/apex/COHCaseInsuranceTabController.getDepartmentValuesServer';
import searchServiceLine from '@salesforce/apex/COHCaseInsuranceTabController.getServiceLineValuesServer';
import searchSpecialty from '@salesforce/apex/COHCaseInsuranceTabController.getSpecialtyValuesServer';
import searchPhysician from '@salesforce/apex/COHCaseInsuranceTabController.getPhysiciansServer';
import getPhysicianId from '@salesforce/apex/COHCaseInsuranceTabController.getPhysicianID';
import SchedulingScripting from '@salesforce/label/c.SchedulingScripting';
import getSchedulingGuidelines from '@salesforce/apex/COHCaseInsuranceTabController.getSchedulingGuidelines';
import searchPhysicianMatrices from '@salesforce/apex/COHCaseInsuranceTabController.searchPhysicianMatrixRecords';

export default class DecisionTreeMenu extends LightningElement {

    showForm = false;
    label = {
        SchedulingScripting
    };

    servicecategoriesvalue;
    plantypevalue;
    lineofbusinessvalue;
    healthplanvalue;
    medicalgroupipavalue;
    doespatienthaveauthvalueyesorno;
    doespatienthaveauthvalue;

    locationvalue;
    departmentvalue;
    servicelinevalue;
    specialtyvalue;
    physicianvalue;
    physicianid;
    inspdcc;

    showSpinner;

    @track isToggleOn = false;
    @track guidelinesTable = {};
    @track isSchedule = false;
    @track recPhysicianMatrix;

    @track servicecategoriesoptions;
    @track plantypeoptions;
    @track lineofbusinessoptions;
    @track healthplanoptions;
    @track medicalgroupipaoptions;
    @track authpicklistoptions = [{label:'No', value:'No'},{label:'Yes', value:'Yes'}];
    @track isAuthAvaliable;


    @track locationoptions;
    @track departmentoptions;
    @track servicelineoptions;
    @track specialtyoptions;
    @track physicianoptions;
    @track isPhysicanupdate = false;

    @track inspdccValue;


    async connectedCallback() {
        this.showSpinner = true;
        try {
            this.servicecategoriesvalue = 'OP-Prof (Office/Clinic)';
            await this.setServiceCategoryOptions();
            await this.setPlantTypeOptions();
            await this.setLineOfBusinessOptions();
            await this.setHealthPlanOptions();
            await this.setMedicalGroupIPAOptions();
            if (this.doespatienthaveauthvalueyesorno === 'Yes') {
                this.isAuthAvaliable = true;
            }
            await this.setLocationOptions();
            await this.setDepartmentOptions();
            await this.setServiceLineOptions();
            await this.setSpecialityOptions();
            await this.setPhysicianOptions();
            await this.setPhysicianId();
        } catch (error) {
            this.errors = error;
        } finally {
            this.showSpinner = false;
            this.showForm = true;
        }
    }

    //Methods for Insurance Matrix
    async setPlantTypeOptions() {
        this.plantypeoptions = await searchPlanType({
            serviceCategory: 'OP-Prof (Office/Clinic)',
            lineOfBusiness: this.lineofbusinessvalue,
            healthPlan: this.healthplanvalue,
            medicalGroupIPA: this.medicalgroupipavalue,
        });
        if (this.plantypeoptions && this.plantypeoptions.length === 1) {
            this.plantypevalue = this.plantypeoptions[0].value;
        }
    }

    async setLineOfBusinessOptions() {
        this.lineofbusinessoptions = await searchLineofBusiness({
            serviceCategory: 'OP-Prof (Office/Clinic)',
            planType: this.plantypevalue,
            healthPlan: this.healthplanvalue,
            medicalGroupIPA: this.medicalgroupipavalue,
        });
        if (this.lineofbusinessoptions && this.lineofbusinessoptions.length === 1) {
            this.lineofbusinessvalue = this.lineofbusinessoptions[0].value;
        }
    }

    async setHealthPlanOptions() {
        this.healthplanoptions = await searchHealthPlan({
            serviceCategory: 'OP-Prof (Office/Clinic)',
            planType: this.plantypevalue,
            lineOfBusiness: this.lineofbusinessvalue,
            medicalGroupIPA: this.medicalgroupipavalue,
        });
        if (this.healthplanoptions && this.healthplanoptions.length === 1) {
            this.healthplanvalue = this.healthplanoptions[0].value;
        }
    }

    async setMedicalGroupIPAOptions() {
        this.medicalgroupipaoptions = await searchMedicalGroupIPA({
            serviceCategory: 'OP-Prof (Office/Clinic)',
            planType: this.plantypevalue,
            lineOfBusiness: this.lineofbusinessvalue,
            healthPlan: this.healthplanvalue,
        });
        if (this.medicalgroupipaoptions && this.medicalgroupipaoptions.length === 1) {
            this.medicalgroupipavalue = this.medicalgroupipaoptions[0].value;
        }
    }

    async setServiceCategoryOptions() {
        this.servicecategoriesoptions = await searchServiceCategory({
            planType: this.plantypevalue,
            lineOfBusiness: this.lineofbusinessvalue,
            healthPlan: this.healthplanvalue,
            medicalGroupIPA: this.medicalgroupipavalue,
        });
        /*if (this.servicecategoriesoptions && this.servicecategoriesoptions.length === 1) {
            this.servicecategoriesvalue = this.servicecategoriesoptions[0].value;
        }*/
    }

    async fireInsuranceRefresh() {
        this.showSpinner = true;
        try {
            this.guidelinesTable = await getSchedulingGuidelines({
                planType: this.plantypevalue,
                lineOfBusiness: this.lineofbusinessvalue,
                healthPlan: this.healthplanvalue,
                medicalGroupIPA: this.medicalgroupipavalue,
                authrequired: this.doespatienthaveauthvalueyesorno,
                servicecategories: this.servicecategoriesvalue
            });
            this.isToggleOn = Object.keys(this.guidelinesTable).length ? true : false;
            this.inspdccValue = this.guidelinesTable?.formPrimaryDeliveryofCareCenter;
            await this.handleRefreshInspdccset();
        } catch (e) {
            console.log(e);
        } finally {
            this.showSpinner = false;
        }
    }

    async handleChangeServiceCategories(event) {
        this.servicecategoriesvalue = 'OP-Prof (Office/Clinic)';
        try {
            this.showSpinner = true;
            await this.setPlantTypeOptions();
            await this.setLineOfBusinessOptions();
            await this.setHealthPlanOptions();
            await this.setMedicalGroupIPAOptions();
            await this.fireInsuranceRefresh();
        } catch (error) {
            this.errors = error;
        } finally {
            this.showSpinner = false;
        }
    }

    async handleChangePlanType(event) {
        this.plantypevalue = event.target.value;
        this.servicecategoriesvalue = 'OP-Prof (Office/Clinic)';
        try {
            this.showSpinner = true;
            await this.setServiceCategoryOptions();
            await this.setLineOfBusinessOptions();
            await this.setHealthPlanOptions();
            await this.setMedicalGroupIPAOptions();
            await this.fireInsuranceRefresh();
        } catch (error) {
            this.errors = error;
        } finally {
            this.showSpinner = false;
        }
    }

    async handleChangeLineofBusiness(event) {
        this.lineofbusinessvalue = event.target.value;
        this.servicecategoriesvalue = 'OP-Prof (Office/Clinic)';
        try {
            this.showSpinner = true;
            await this.setServiceCategoryOptions();
            await this.setPlantTypeOptions();
            await this.setHealthPlanOptions();
            await this.setMedicalGroupIPAOptions();
            await this.fireInsuranceRefresh();
        } catch (error) {
            this.errors = error;
        } finally {
            this.showSpinner = false;
        }
    }

    async handleChangeHealthPlan(event) {
        this.healthplanvalue = event.target.value;
        this.servicecategoriesvalue = 'OP-Prof (Office/Clinic)';
        try {
            this.showSpinner = true;
            await this.setServiceCategoryOptions();
            await this.setPlantTypeOptions();
            await this.setLineOfBusinessOptions();
            await this.setMedicalGroupIPAOptions();
            await this.fireInsuranceRefresh();
        } catch (error) {
            this.errors = error;
        } finally {
            this.showSpinner = false;
        }
    }

    async handleChangeMedicalGroupIPA(event) {
        this.medicalgroupipavalue = event.target.value;
        this.servicecategoriesvalue = 'OP-Prof (Office/Clinic)';
        try {
            this.showSpinner = true;
            await this.setServiceCategoryOptions();
            await this.setPlantTypeOptions();
            await this.setLineOfBusinessOptions();
            await this.setHealthPlanOptions();
            await this.fireInsuranceRefresh();
        } catch (error) {
            this.errors = error;
        } finally {
            this.showSpinner = false;
        }
    }

    async resetInsurancePicklistValues(event) {
        this.plantypevalue = null;
        this.lineofbusinessvalue = null;
        this.healthplanvalue = null;
        this.medicalgroupipavalue = null;
        this.servicecategoriesvalue = 'OP-Prof (Office/Clinic)';
        try {
            this.showSpinner = true;
            await this.setPlantTypeOptions();
            await this.setLineOfBusinessOptions();
            await this.setHealthPlanOptions();
            await this.setMedicalGroupIPAOptions();
            await this.fireInsuranceRefresh();
        } catch (error) {
            this.errors = error;
        } finally {
            this.showSpinner = false;
        }
    }

    handleChangeAuthPickList(event) {
        this.doespatienthaveauthvalueyesorno = event.target.value;
        if (event.target.value === 'Yes') {
            this.isAuthAvaliable = true;
        } else {
            this.isAuthAvaliable = false;
            this.doespatienthaveauthvalue = '';
        }
    }

    handleChangeAuthvalue(event) {
        this.doespatienthaveauthvalue = event.target.value;
    }

    //Methods for Physician Matrix
    async setLocationOptions() {
        this.locationoptions = await searchLocation({
            department: this.departmentvalue,
            serviceline: this.servicelinevalue,
            specialty: this.specialtyvalue,
            physician: this.physicianvalue,
            inspdccs: this.inspdcc
        });
        if (this.locationoptions && this.locationoptions.length === 1) {
            this.locationvalue = this.locationoptions[0].value;
        }
    }

    async setDepartmentOptions() {
        this.departmentoptions = await searchDepartment({
            location: this.locationvalue,
            serviceline: this.servicelinevalue,
            specialty: this.specialtyvalue,
            physician: this.physicianvalue,
            inspdccs: this.inspdcc
        });
        if (this.departmentoptions && this.departmentoptions.length === 1) {
            this.departmentvalue = this.departmentoptions[0].value;
        }
    }

    async setServiceLineOptions() {
        this.servicelineoptions = await searchServiceLine({
            location: this.locationvalue,
            department: this.departmentvalue,
            specialty: this.specialtyvalue,
            physician: this.physicianvalue,
            inspdccs: this.inspdcc
        });
        if (this.servicelineoptions && this.servicelineoptions.length === 1) {
            this.servicelinevalue = this.servicelineoptions[0].value;
        }
    }

    async setSpecialityOptions() {
        this.specialtyoptions = await searchSpecialty({
            location: this.locationvalue,
            department: this.departmentvalue,
            serviceline: this.servicelinevalue,
            physician: this.physicianvalue,
            inspdccs: this.inspdcc
        });
        if (this.specialtyoptions && this.specialtyoptions.length === 1) {
            this.specialtyvalue = this.specialtyoptions[0].value;
        }
    }

    async setPhysicianOptions() {
        this.physicianoptions = await searchPhysician({
            location: this.locationvalue,
            department: this.departmentvalue,
            serviceline: this.servicelinevalue,
            specialty: this.specialtyvalue,
            inspdccs: this.inspdcc
        });
        if (this.physicianoptions && this.physicianoptions.length === 1) {
            this.physicianvalue = this.physicianoptions[0].value;
        }
    }

    async setPhysicianId() {
        this.physicianid = await getPhysicianId({
            physicianStr: this.physicianvalue,
        });
    }

    async fireSearchEvent() {
        this.showSpinner = true;
        try {
            this.recPhysicianMatrix = await searchPhysicianMatrices({
                locationVal: this.locationvalue,
                department: this.departmentvalue,
                serviceline: this.servicelinevalue,
                specialty: this.specialtyvalue,
                physician: this.physicianvalue,
                inspdccs: this.inspdcc
            });
        } catch (error) {
            this.errors = error;
        } finally {
            this.showSpinner = false;
        }
    }

    async handleChangeLocation(event) {
        this.locationvalue = event.target.value;
        try {
            this.showSpinner = true;
            await this.setLocationOptions();
            await this.setDepartmentOptions();
            await this.setServiceLineOptions();
            await this.setSpecialityOptions();
            await this.setPhysicianOptions();
            await this.setPhysicianId();
            await this.fireSearchEvent();
        } catch (error) {
            this.errors = error;
        } finally {
            this.showSpinner = false;
        }
    }

    async handleChangeDepartment(event) {
        this.departmentvalue = event.target.value;
        try {
            this.showSpinner = true;
            await this.setServiceLineOptions();
            await this.setLocationOptions();
            await this.setSpecialityOptions();
            await this.setPhysicianOptions();
            await this.setPhysicianId();
            await this.fireSearchEvent();
        } catch (e) {
            this.errors = e;
        } finally {
            this.showSpinner = false;
        }
    }

    async handleChangeServiceLine(event) {
        this.servicelinevalue = event.target.value;
        try {
            this.showSpinner = true;
            await this.setLocationOptions();
            await this.setDepartmentOptions();
            await this.setSpecialityOptions();
            await this.setPhysicianOptions();
            await this.setPhysicianId();
            await this.fireSearchEvent();
        } catch (error) {
            this.errors = error;
        } finally {
            this.showSpinner = false;
        }
    }

    async handleChangeSpecialty(event) {
        this.specialtyvalue = event.target.value;
        try {
            this.showSpinner = true;
            await this.setLocationOptions();
            await this.setDepartmentOptions();
            await this.setServiceLineOptions();
            await this.setPhysicianOptions();
            await this.setPhysicianId();
            await this.fireSearchEvent();
        } catch (error) {
            this.errors = error;
        } finally {
            this.showSpinner = false;
        }
    }

    async handleChangePhysician(event) {
        this.physicianvalue = event.target.value;
        try {
            this.showSpinner = true;
            await this.setLocationOptions();
            await this.setDepartmentOptions();
            await this.setServiceLineOptions();
            await this.setSpecialityOptions();
            await this.setPhysicianId();
            await this.fireSearchEvent();
        } catch (error) {
            this.errors = error;
        } finally {
            this.showSpinner = false;
        }
    }

    handleChangedoesPatientHaveAuth(event) {
        this.doespatienthaveauthvalue = event.target.value;
    }

    async resetPhysicianPicklistValues(event) {
        this.locationvalue = null;
        this.departmentvalue = null;
        this.servicelinevalue = null;
        this.specialtyvalue = null;
        this.physicianvalue = null;
        this.physicianid = null;
        try {
            this.showSpinner = true;
            await this.setLocationOptions();
            await this.setDepartmentOptions();
            await this.setServiceLineOptions();
            await this.setSpecialityOptions();
            await this.setPhysicianOptions();
            await this.setPhysicianId();
            await this.fireSearchEvent();
        } catch (error) {
            this.errors = error;
        } finally {
            let querySelector = this.template.querySelectorAll('c-reusable-custom-pick-list-with-search');
            querySelector[0].resetParam();
            querySelector[1].resetParam();
            this.showSpinner = false;
        }
    }

    handleDiagnosisListedChange(event) {
        this.diagnosisNotListed = event.target.checked;
    }

    async handleRefreshInspdccset() {
        this.locationvalue = null;
        this.departmentvalue = null;
        this.servicelinevalue = null;
        this.specialtyvalue = null;
        this.physicianvalue = null;
        this.physicianid = null;

        try {
            this.showSpinner = true;
            this.recPhysicianMatrix = [];
            /*await this.setLocationOptions();
            await this.setDepartmentOptions();
            await this.setServiceLineOptions();
            await this.setSpecialityOptions();
            await this.setPhysicianOptions();
            await this.setPhysicianId();
            await this.fireSearchEvent();*/
        } catch (error) {
            this.errors = error;
        } finally {
            this.showSpinner = false;
        }
    }

    handleToggleInsurenceOff() {
        this.isToggleOn = false;

    }

     handelUrlClick (event) {
        let matricUrl = window.location.origin + '/'+ event.currentTarget.dataset.name;
        window.open(matricUrl, "_blank");
    }
}