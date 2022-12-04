//Test Class: physicianListTest

global class physicianList implements Comparable {

    public Decimal DistanceinMiles;
    public String Distance;
    public Physician_Matrix__c record;
    // Constructor
    public physicianList(Decimal dist,String distMiles,Physician_Matrix__c rec) {
        DistanceinMiles = dist;
        Distance = distMiles;
        record = rec;
    }
    
    // Compare opportunities based on the opportunity amount.
    global Integer compareTo(Object compareTo) {
        // Cast argument to OpportunityWrapper
        physicianList compareToPM = (physicianList)compareTo;
        
        // The return value of 0 indicates that both elements are equal.
       if(DistanceinMiles == compareToPM.DistanceinMiles) return 0;
        if(DistanceinMiles > compareToPM.DistanceinMiles) return 1;
        return -1;       
    }
}