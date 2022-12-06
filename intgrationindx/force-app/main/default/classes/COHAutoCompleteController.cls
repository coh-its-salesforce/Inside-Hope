global class COHAutoCompleteController {
    @RemoteAction
    global static SObject[] findSObjects(string obj, string qry, string addFields) {
    //global static string findSObjects(string obj, string qry, string addFields) {  
        // more than one field can be passed in the addFields parameter
        // split it into an array for later use
        List<String> fieldList;
        if (addFields != null && addFields != '') fieldList = addFields.split(',');
       // check to see if the object passed is valid
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.SObjectType sot = gd.get(obj);
        if (sot == null) {
            // Object name not valid
            return null;
        }
        // create the filter text
        String filter = ' like \'%' + String.escapeSingleQuotes(qry) + '%\'';
        //begin building the dynamic soql query
        String soql = 'select id, Name, BMCServiceDesk__FKParentCategory__c';
        // if an additional field was passed in add it to the soql
        if (fieldList != null) {
            for (String s : fieldList) {
                soql += ', ' + s;
            }
        }
        // add the object and filter by name to the soql
        if (obj == 'User')
            soql += ' from ' + obj + ' where IsActive=true AND (name' + filter;
        else
            soql += ' from ' + obj + ' where BMCServiceDesk__inactive__c = false AND BMCServiceDesk__AvailableForIncidents__c = true AND (name' + filter;
        // add the filter by additional fields to the soql
        if (fieldList != null) {
            for (String s : fieldList) {
                soql += ' or ' + s + filter;
            }
        }
        soql += ') order by Name limit 60';
        system.debug('#### SOQL: ' + soql);
        string rValue = '';
        List<sObject> L = new List<sObject>();
        try {
            L = Database.query(soql);
        }
        catch (QueryException e) {
            return null;
        }

        return L;
          
   }
}