/*
 * This is the server side controller for the COH_UTIL_DependentPicklist component.
 * Tim Hughes
 */ 
public class COH_UTIL_DependentPicklistController {
	PRIVATE STATIC FINAL STRING BASE_64_CHARS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' + 'abcdefghijklmnopqrstuvwxyz' + '0123456789+/';

    /*
     * This method returns a JSON array containing piclist values and labels for a child picklist based on the value of the parent picklist
     * 
     * @param String sObjectAPIName					The API name of the sObject the controlling and dependent picklists are fields of
     * @param String controllingFieldAPIName		The API name of the controlling picklist
     * @param String dependentFieldAPIName			The API name of the dependent picklist
     * 
     * @return COH_UniversalIntakeRequest__c		The COH_UniversalIntakeRequest that is being returned
     */ 
    @AuraEnabled 
    public static Map<String, List<String>> getPicklistOptionsServer(String sObjectAPIName, String controllingFieldAPIName, String dependentFieldAPIName) {
        Schema.SobjectType sObjType = Schema.getGlobalDescribe().get(sObjectAPIName);
		Map<String, List<String>> returnValue = new Map<String, List<String>>();
        Schema.SObjectField controllingField;
        Schema.SObjectField dependentField;
        
        if (sObjType != null) {
            Map<String, Schema.SObjectField> sObjFieldMap = sObjType.getDescribe().fields.getMap();
            controllingField = sObjFieldMap.get(controllingFieldAPIName);
			dependentField = sObjFieldMap.get(dependentFieldAPIName);
            if (controllingField != null && dependentField != null) {
                returnValue = createDependentOptionsMap(controllingField, dependentField);
            }
        }
        return returnValue;
    }    

	//-------------- Private Functions --------------//     
    
    /*
     * This function creates a Map of dependent picklist options. The Map looks like {Controlling Field: List of Dependent options}
     * It does this by serializing and deserializing the dependentpicklist options to JSON. This allows it to access the validfor field.
     * It then converts the validfor field to binary, and checks the bits to see determine if the dependent value is valid for a specific controlling value
     * 
     * @param Schema.SObjectField controllingField					The SObject field of the controlling picklist
     * @param Schema.SObjectField dependentField					The SObject field of the dependent picklist
     * 
     * @return Map<String, List<String>>							The Map of dependent options 			
     */
    private static Map<String, List<String>> createDependentOptionsMap(Schema.SObjectField controllingField, Schema.SObjectField dependentField) {
		Map<String, List<String>> objResults = new Map<String, List<String>>();
		List<String> controllingValues = new List<String>();        
        List<Schema.PicklistEntry> controllingOptions = controllingField.getDescribe().getPicklistValues();
        List<PicklistEntryWrapper> dependentOptions = wrapPicklistEntries(dependentField.getDescribe().getPicklistValues());
        System.debug(dependentOptions);
        
		for (Schema.PicklistEntry picklistEntry : controllingOptions) {
			String label = picklistEntry.getLabel();
			objResults.put(label, new List<String>());
			controllingValues.add(label);
		}
        
		for (PicklistEntryWrapper picklistWrapper : dependentOptions) {
            if (picklistWrapper.active == 'true') {
                String label = picklistWrapper.label;
                String validForBits = base64ToBits(picklistWrapper.validFor);
                for (Integer i = 0; i < validForBits.length(); i++) {
                    // For each bit, in order: if it's a 1, add this label to the dependent list for the corresponding controlling value
                    String bit = validForBits.mid(i, 1);
                    if (bit == '1') {
                        objResults.get(controllingValues.get(i)).add(label);
                    }
                }                
            }
		}        
        return objResults;
    }

    /*
     * This function handles the serializing and deserializing to JSON a List of picklist entries into the PicklistEntryWrapper class. 
     * This allows us to access the validfor value that we are unable to access in APEX
     * 
     * @param List<Schema.PicklistEntry> picklistEntries					The list of picklist entries that needs to be serialized and deserialized
     * 
     * @return List<PicklistEntryWrapper> 									The list of PicklistEntryWrapper created from the picklistEntries parameter
     */ 
	private static List<PicklistEntryWrapper> wrapPicklistEntries(List<Schema.PicklistEntry> picklistEntries) {
		return (List<PicklistEntryWrapper>) JSON.deserialize(JSON.serialize(picklistEntries), List<PicklistEntryWrapper>.class);
	}        
    
    /*
     * 
     */ 
	private static String base64ToBits(String validFor) {
		String validForBits = '';        
        
        
        if (String.isNotEmpty(validFor)){
            for (Integer i = 0; i < validFor.length(); i++) {
                String thisChar = validFor.mid(i, 1);
                Integer val = BASE_64_CHARS.indexOf(thisChar);
                String bits = decimalToBinary(val).leftPad(6, '0');
                validForBits += bits;
            }        
        } 

		return validForBits;
	}     
    
    /*
     * 
     */ 
	private static String decimalToBinary(Integer val) {
		String bits = '';
		while (val > 0) {
			Integer remainder = Math.mod(val, 2);
			val = Integer.valueOf(Math.floor(val / 2));
			bits = String.valueOf(remainder) + bits;
		}
		return bits;
	}
    
    /*
     * 
     */ 
    private class PicklistEntryWrapper {
		public String active {get; set;}
		public String label {get; set;}
//		public String value {get; set;}
		public String validFor {get; set;}        
    }
}