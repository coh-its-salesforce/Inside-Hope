Trigger visaBIBU on Visa__c(before insert,before update){
    Visa__c visa = Trigger.new[0];
    decimal diff = 0.00;
    Date d1 = visa.Proposed_Visa_Start_Date__c;
    Date d2 = Visa.Proposed_Visa_End_Date__c;
    if (d1 != null && d2 != null) {
        if(d2.year() - d1.year()>0) {
            diff += d2.year() - d1.year();
            diff += decimal.valueOf(d2.month() - d1.month())/12;
            diff += decimal.valueOf(d2.day()-d1.day())/1000;
        }else if(d2.month()-d1.month() >0){
            diff += decimal.valueOf(d2.month() - d1.month())/12;
            diff += decimal.valueOf(d2.day()-d1.day())/1000;
        }else if(d2.day()-d1.day() >0){
            diff += decimal.valueOf(d2.day()-d1.day())/1000;
        }        
    }
    
    visa.J_1_ISS_Fee__C = diff;
    IF(visa.Type_of_Visa__c == 'J-1' && (visa.Case_Type__c == 'Amendment' || visa.Case_Type__c == 'Extension of same immigration status') && Visa.Proposed_Visa_End_Date__c != null && visa.Proposed_Visa_Start_Date__c != null){
        if(Visa.J_1_ISS_Fee__c > 2){
            visa.ISS_Fee_Extension__c = 1750;
        }else if(Visa.J_1_ISS_Fee__c > 1.5){
            visa.ISS_Fee_Extension__c = 1250;
        }else if(Visa.J_1_ISS_Fee__c > 1){
            visa.ISS_Fee_Extension__c = 750;
        }else if(Visa.J_1_ISS_Fee__c > 0){
            visa.ISS_Fee_Extension__c = 750;
        }else if(Visa.J_1_ISS_Fee__c == 0){
            visa.ISS_Fee_Extension__c = 250;
        }else{
            visa.ISS_Fee_Extension__c = 0;
        }
    }
}