/*
 * This test class verifies the functionality of the COHUtil class.  
 * 
 * Raymond Tam
 * City of Hope
 * Copyright (c) 2014
 * 
 * No portion of this code may be copied, transferred, or transmitted
 * in any form (written, electronic, or otherwise) without the prior
 * written consent from the City of Hope.
 *  
 */
@isTest
public class COHUtilTester {
    
    // test constants
    
    private static final String stringType = 'String';
    private static final String dateType = 'Date';
    private static final String booleanType = 'Boolean';
    private static final String decimalType = 'Decimal';
    private static final String integerType = 'Integer';
    
    private static final String WTPApplicationName = 'Web To Patient';
    private static final String defaultWTPNPSAccountOwnerProperty = 'Default NPS Account Owner';
    private static final String defaultWTPNPSAccountOwnerValue = 'saccount';
    private static final String defaultWTPFoundationAccountOwnerProperty = 'Default Foundation Account Owner';
    private static final String defaultWTPFoundationAccountOwnerValue = 'saccount';
    
    private static final String WTPFoundationExclusiveProperty = 'Foundation Exclusive';
    private static final String WTPNPSLocations = 'NPS Locations';
    private static final String WTPHealthNetHMOProperty = 'Health Net HMO';
    private static final String WTPHealthNetHMOValue = 'HealthNet -- HMO';
    private static final String WTPHealthNetPPOProperty = 'Health Net PPO';
    private static final String WTPHealthNetPPOValue = 'HealthNet -- PPO';
    
    private static final String NPSArcadiaRadiationPPOProperty = 'Arcadia Radiation Oncology';
    private static final String NPSArcadiaRadiationPPOValue = 'Arcadia-Radiation Oncology Services';
    private static final String NPSDuartePPOProperty = 'Duarte Main Medical';
    private static final String NPSDuartePPOPropertyValue = 'Duarte-Main Medical Center';
    
    private static final String defaultLocationProperty = 'Default Medical Location';
    private static final String defaultLocationValue = 'Duarte-Main Medical Center';
    private static final String integerTestProperty = 'Integer Test';
    private static final String integerTestValue = '42';
    private static final String decimalTestProperty = 'Decimal Test';
    private static final String decimalTestValue = '3.14159';
    private static final String booleanTestProperty = 'Boolean Test';
    private static final String booleanTestValue = 'true';
    private static final String dateTestProperty = 'Date Test';
    private static final String dateTestValue = '2014-12-04 00:00:00';
    private static final String inactiveTestProperty = 'Inactive Test';
    private static final String inactiveTestValue = 'true';
    
    private static final String excludedLeadsProperty = 'Excluded Leads';
    private static final String excludedOwnersProperty = 'Excluded Owners';
    private static final String marketingSourceProperty = 'Excluded Marketing Masterfile';
    private static final String marketingSourceValue = 'Provider Masterfile Search';
    private static final String marketingOwnerProperty = 'Excluded Marketing Oscar Mendez';
    private static final String marketingOwnerValue = 'osmende';
    private static final String excludedLeadRecordTypes = 'Excluded Lead Record Types';
    private static final String internationalIntakeProperty = 'International Intake';
    private static final String internationalIntakeValue = 'International Intake';
    private static final String internationalIntakeInsuranceProperty = 'International Insurance';
    private static final String internationalIntakeInsuranceValue = 'International';
    private static final String domesticIntakeProperty = 'Domestic Patient';
    private static final String domesticIntakeValue = 'Domestic Patient';
    
    private static final Integer WTPConfigurationObjectsCount = 17;
    private static final Integer WTPConfigurationGroupObjectsCount = 2;
    private static final Integer WTPConfigurationGroupOExcludedSourcesObjectsCount = 1;
    private static final Integer WTPConfigurationGroupOExcludedOwnersObjectsCount = 1;
        
    // Configuration for the WTP test environment
    private static List<COH_App_Configuration__c> mWTPConfigList = null;

	// Test constants for IMS Testing    
    private static final String IMSApplicationName = 'Incident Management System';
    private static final String IMSNonClinicalRecordType = 'Non-clinical';
    private static final String IMSClinicalRecordType = 'Clinical';
    private static final Integer IMSConfigurationObjectsCount = 2;
        
    // Configuration for the IMS test environment
    private static List<COH_App_Configuration__c> mIMSConfigList = null;
    
    
    // The public methods are for use by external test classes.
    
    
    /*
     * Returns the Marketing owner.
     * 
     */
    public static String getMarketingOwner() {
        return marketingOwnerValue;
    }

	/*
	 * Returns the default NPS Account owner
	 * 
	 */
    public static String getDefaultNPSAccountOwner() {
        return defaultWTPNPSAccountOwnerValue;
    }    
    
	/*
	 * Returns the default Foundation Account owner
	 * 
	 */
    public static String getDefaultFoundationAccountOwner() {
        return defaultWTPFoundationAccountOwnerValue;
    }    

    /*
     *  Creates and retrieves the configuration objects for the WTP test environment.
     */
    private static List<COH_App_Configuration__c> getWTPConfiguration() {
        
        if (COHUtil.isValidList(mWTPConfigList)) {
            return mWTPConfigList;
        } else {
            mWTPConfigList = new List<COH_App_Configuration__c>();
        }
        
        COH_App_Configuration__c configObj1 = new COH_App_Configuration__c();
		configObj1.Name = defaultWTPNPSAccountOwnerProperty;
        configObj1.Application_Name__c = WTPApplicationName;
        configObj1.Value__c = defaultWTPNPSAccountOwnerValue;
        configObj1.Value_Type__c = stringType;
        configObj1.Active__c = true;

        COH_App_Configuration__c configObj2 = new COH_App_Configuration__c();
		configObj2.Name = defaultWTPFoundationAccountOwnerProperty;
        configObj2.Application_Name__c = WTPApplicationName;
        configObj2.Value__c = defaultWTPFoundationAccountOwnerValue;
        configObj2.Value_Type__c = stringType;
        configObj2.Active__c = true;

        COH_App_Configuration__c configObj3 = new COH_App_Configuration__c();
		configObj3.Name = integerTestProperty;
        configObj3.Application_Name__c = WTPApplicationName;
        configObj3.Value__c = integerTestValue;
        configObj3.Value_Type__c = integerTYPE;
        configObj3.Active__c = true;

        COH_App_Configuration__c configObj4 = new COH_App_Configuration__c();
		configObj4.Name = decimalTestProperty;
        configObj4.Application_Name__c = WTPApplicationName;
        configObj4.Value__c = decimalTestValue;
        configObj4.Value_Type__c = decimalTYPE;
        configObj4.Active__c = true;

        COH_App_Configuration__c configObj5 = new COH_App_Configuration__c();
		configObj5.Name = booleanTestProperty;
        configObj5.Application_Name__c = WTPApplicationName;
        configObj5.Value__c = booleanTestValue;
        configObj5.Value_Type__c = booleanTYPE;
        configObj5.Active__c = true;

        COH_App_Configuration__c configObj6 = new COH_App_Configuration__c();
		configObj6.Name = dateTestProperty;
        configObj6.Application_Name__c = WTPApplicationName;
        configObj6.Value__c = dateTestValue;
        configObj6.Value_Type__c = dateType;
        configObj6.Active__c = true;

        COH_App_Configuration__c configObj7 = new COH_App_Configuration__c();
		configObj7.Name = inactiveTestProperty;
        configObj7.Application_Name__c = WTPApplicationName;
        configObj7.Value__c = inactiveTestValue;
        configObj7.Value_Type__c = booleanTYPE;
        configObj7.Active__c = false;

        // These test the configuration WTPFoundationExclusiveProperty group
         
        COH_App_Configuration__c configObj8 = new COH_App_Configuration__c();
		configObj8.Name = WTPHealthNetHMOProperty;
        configObj8.Application_Name__c = WTPApplicationName;
        configObj8.Value__c = WTPHealthNetHMOValue;
        configObj8.Value_Type__c = stringType;
        configObj8.Configuration_Group__c = WTPFoundationExclusiveProperty;
        configObj8.Active__c = true;

        COH_App_Configuration__c configObj9 = new COH_App_Configuration__c();
		configObj9.Name = WTPHealthNetPPOProperty;
        configObj9.Application_Name__c = WTPApplicationName;
        configObj9.Value__c = WTPHealthNetPPOValue;
        configObj9.Value_Type__c = stringType;
        configObj9.Configuration_Group__c = WTPFoundationExclusiveProperty;
        configObj9.Active__c = true;
        
        COH_App_Configuration__c configObj10 = new COH_App_Configuration__c();
		configObj10.Name = NPSArcadiaRadiationPPOProperty;
        configObj10.Application_Name__c = WTPApplicationName;
        configObj10.Value__c = NPSArcadiaRadiationPPOValue;
        configObj10.Value_Type__c = stringType;
        configObj10.Configuration_Group__c = WTPNPSLocations;
        configObj10.Active__c = true;
        
        COH_App_Configuration__c configObj11 = new COH_App_Configuration__c();
		configObj11.Name = NPSDuartePPOProperty;
        configObj11.Application_Name__c = WTPApplicationName;
        configObj11.Value__c = NPSDuartePPOPropertyValue;
        configObj11.Value_Type__c = stringType;
        configObj11.Configuration_Group__c = WTPNPSLocations;
        configObj11.Active__c = true;
        
        COH_App_Configuration__c configObj12 = new COH_App_Configuration__c();
		configObj12.Name = defaultLocationProperty;
        configObj12.Application_Name__c = WTPApplicationName;
        configObj12.Value__c = defaultLocationValue;
        configObj12.Value_Type__c = stringType;
        configObj12.Active__c = true;
        
        COH_App_Configuration__c configObj13 = new COH_App_Configuration__c();
		configObj13.Name = marketingSourceProperty;
        configObj13.Application_Name__c = WTPApplicationName;
        configObj13.Value__c = marketingSourceValue;
        configObj13.Value_Type__c = stringType;
        configObj13.Configuration_Group__c = excludedLeadsProperty;
        configObj13.Active__c = true;

        COH_App_Configuration__c configObj14 = new COH_App_Configuration__c();
		configObj14.Name = marketingOwnerProperty;
        configObj14.Application_Name__c = WTPApplicationName;
        configObj14.Value__c = marketingOwnerValue;
        configObj14.Value_Type__c = stringType;
        configObj14.Configuration_Group__c = excludedOwnersProperty;
        configObj14.Active__c = true;

        COH_App_Configuration__c configObj15 = new COH_App_Configuration__c();
		configObj15.Name = internationalIntakeProperty;
        configObj15.Application_Name__c = WTPApplicationName;
        configObj15.Value__c = internationalIntakeValue;
        configObj15.Value_Type__c = stringType;
        configObj15.Configuration_Group__c = excludedLeadRecordTypes;
        configObj15.Active__c = true;

        COH_App_Configuration__c configObj16 = new COH_App_Configuration__c();
		configObj16.Name = domesticIntakeProperty;
        configObj16.Application_Name__c = WTPApplicationName;
        configObj16.Value__c = domesticIntakeValue;
        configObj16.Value_Type__c = stringType;
        configObj16.Active__c = true;
        
        COH_App_Configuration__c configObj17 = new COH_App_Configuration__c();
		configObj17.Name = internationalIntakeInsuranceProperty;
        configObj17.Application_Name__c = WTPApplicationName;
        configObj17.Value__c = internationalIntakeInsuranceValue;
        configObj17.Value_Type__c = stringType;
        configObj17.Active__c = true;

        mWTPConfigList.add(configObj1);
        mWTPConfigList.add(configObj2);
        mWTPConfigList.add(configObj3);
        mWTPConfigList.add(configObj4);
        mWTPConfigList.add(configObj5);
        mWTPConfigList.add(configObj6);
        mWTPConfigList.add(configObj7);
        mWTPConfigList.add(configObj8);
        mWTPConfigList.add(configObj9);
        mWTPConfigList.add(configObj10);
        mWTPConfigList.add(configObj11);
        mWTPConfigList.add(configObj12);
        mWTPConfigList.add(configObj13);
        mWTPConfigList.add(configObj14);
        mWTPConfigList.add(configObj15);
        mWTPConfigList.add(configObj16);
        mWTPConfigList.add(configObj17);
        
        return mWTPConfigList;
        
    }
    
    /*
     *  Creates and retrieves the configuration objects for the IMS test environment.
     */
    private static List<COH_App_Configuration__c> getIMSConfiguration() {
        
        if (COHUtil.isValidList(mIMSConfigList)) {
            return mIMSConfigList;
        } else {
            mIMSConfigList = new List<COH_App_Configuration__c>();
        }
        
        COH_App_Configuration__c configObj1 = new COH_App_Configuration__c();
       
		configObj1.Name = IMSNonClinicalRecordType;
        configObj1.Application_Name__c = IMSApplicationName;
        configObj1.Value__c = IMSClinicalRecordType;
        configObj1.Value_Type__c = stringType;
        configObj1.Active__c = true;

        COH_App_Configuration__c configObj2 = new COH_App_Configuration__c();

		configObj2.Name = IMSClinicalRecordType;
        configObj2.Application_Name__c = IMSApplicationName;
        configObj2.Value__c = IMSNonClinicalRecordType;
        configObj2.Value_Type__c = stringType;
        configObj2.Active__c = true;

        mIMSConfigList.add(configObj1);
        mIMSConfigList.add(configObj2);
        return mIMSConfigList;
    }
    
    /*
     * Insert configuration objects for the WTP test environment.  Test.startTest() and Test.stopTest()
     * must be invoked by the caller.
     */
    public static void setWTPConfiguration() {
        List<COH_App_Configuration__c> configList = getWTPConfiguration();
        Boolean val = COHUtil.isValidList(configList);
        System.assertEquals(true, val);
        Integer listSize = configList.size();
        System.assertEquals(WTPConfigurationObjectsCount, listSize);
        
        Database.insert(configList);
    }
    
    /*
     * Insert configuration objects for the IMS test environment.  Test.startTest() and Test.stopTest()
     * must be invoked by the caller.
     * 
     */
    public static void setIMSConfiguration() {
        List<COH_App_Configuration__c> configList = getIMSConfiguration();
        Boolean val = COHUtil.isValidList(configList);
        System.assertEquals(true, val);
        Integer listSize = configList.size();
        System.assertEquals(IMSConfigurationObjectsCount, listSize);
        
        for (COH_App_Configuration__c configObj : configList)         {
            insert configObj;
        }
    }
    
    /*
     * Test isValidStr()
     */
    private static testMethod void isValidStrTest() {
        
        String query = COHUtil.buildSelectAllSOQLStatement('ApexTrigger');
        Boolean val = COHUtil.isValidStr(null);
        System.assertEquals(false, val);
        val = COHUtil.isValidStr('');
        System.assertEquals(false, val);
        val = COHUtil.isValidStr('foo');
        System.assertEquals(true, true);
    }
    
    /*
     * Test isValidList()
     */
    private static testMethod void isValidListTest() {
        Boolean val = COHUtil.isValidList(null);
        System.assertEquals(false, val);
        List<String> foo = new List<String>();
        val = COHUtil.isValidList(foo);
        System.assertEquals(false, val);
        foo.add('bar');
        val = COHUtil.isValidList(foo);
        System.assertEquals(true, true);
    }

    /*
     * Test getRecordType()
     */
    private static testMethod void getRecordType() {
        // Not a very good test because the Id is dependent on the sandbox/environment,
        // where the real testing takes place.  But it's good for code coverage.
        Id recordType = COHUtil.getRecordType('Account', 'Foundation');
        if (recordType == null) {
            System.assert(false, 'Error: expected an Id but retrieved null instead');
        }
        recordType = COHUtil.getRecordType('Account', 'foobar');
        if (recordType != null) {
            System.assert(false, 'Error: expected null but retrieved an Id instead');
        }
    }    
    
    /*
     * Test getConfigurationGroup
     */
    private static testMethod void getConfigurationGroupTest() {

        test.startTest();

        setWTPConfiguration();        

        List<COH_App_Configuration__c> configGroupList = COHUtil.getConfigurationGroup(null, null);
        if (COHUtil.isValidList(configGroupList)) {
			System.assert(false, 'Expected a null list but retrieved a list with ' + configGroupList.size() + ' elements');
        }

		// Test the NPS locations

        configGroupList = COHUtil.getConfigurationGroup(WTPApplicationName, WTPNPSLocations);
		Integer listSize = configGroupList.size();
        System.assertEquals(WTPConfigurationGroupObjectsCount, listSize);
        for (COH_App_Configuration__c configObj : configGroupList) {
            String name = configObj.Name;
            String propertyVal = configObj.Value__c;
            if (name.equalsIgnoreCase(NPSArcadiaRadiationPPOProperty)) {
                System.assertEquals(NPSArcadiaRadiationPPOValue, propertyVal);
            } else if (name.equalsIgnoreCase(NPSDuartePPOProperty)) {
                System.assertEquals(NPSDuartePPOPropertyValue, propertyVal);
            } else {
                String msg = 'Error: retrieved unexpected location values--> ';
                msg += '\n name: ' + name;
                msg += '\n value: ' + propertyVal;
                System.assert(false, msg);
            }
        }  

		// Test the Foundation exclusive health plans        

        configGroupList = COHUtil.getConfigurationGroup(WTPApplicationName, WTPFoundationExclusiveProperty);
		listSize = configGroupList.size();
        System.assertEquals(WTPConfigurationGroupObjectsCount, listSize);
        for (COH_App_Configuration__c configObj : configGroupList) {
            String name = configObj.Name;
            String propertyVal = configObj.Value__c;
            if (name.equalsIgnoreCase(WTPHealthNetHMOProperty)) {
                System.assertEquals(WTPHealthNetHMOValue, propertyVal);
            } else if (name.equalsIgnoreCase(WTPHealthNetPPOProperty)) {
                System.assertEquals(WTPHealthNetPPOValue, propertyVal);
            } else {
                String msg = 'Error: retrieved unexpected health plan values--> ';
                msg += '\n name: ' + name;
                msg += '\n value: ' + propertyVal;
                System.assert(false, msg);
            }
        }  
        
		// Test the excluded sources

        configGroupList = COHUtil.getConfigurationGroup(WTPApplicationName, excludedLeadsProperty);
		listSize = configGroupList.size();
        System.assertEquals(WTPConfigurationGroupOExcludedSourcesObjectsCount, listSize);
        for (COH_App_Configuration__c configObj : configGroupList) {
            String name = configObj.Name;
            String propertyVal = configObj.Value__c;
            if (name.equalsIgnoreCase(marketingSourceProperty)) {
                System.assertEquals(marketingSourceValue, propertyVal);
            }
        }  
        
		// Test the excluded owners

        configGroupList = COHUtil.getConfigurationGroup(WTPApplicationName, excludedOwnersProperty);
		listSize = configGroupList.size();
        System.assertEquals(WTPConfigurationGroupOExcludedOwnersObjectsCount, listSize);
        for (COH_App_Configuration__c configObj : configGroupList) {
            String name = configObj.Name;
            String propertyVal = configObj.Value__c;
			 if (name.equalsIgnoreCase(marketingOwnerProperty)) {
                System.assertEquals(marketingOwnerValue, propertyVal);
             }
        }  

        test.stopTest();
    }    

    /*
     * Test setConfigurationValue()
     * 
     */
    private static testMethod void testSetConfigurationValue() {
        
        String chatterMonitorApp = 'Chatter Monitor';
        String name0 = 'Name0';
        String name1 = 'Name1';
        String name2 = 'Name2';
        String name3 = 'Name3';
        String name4 = 'Name4';
		String stringVal0 = 'foo';
		String stringVal1 = 'bar';
        String booleanVal0 = 'false';
        String booleanVal1 = 'true';
        String decimalVal0 = '3.14159';
        String decimalVal1 = '3.14159';
        String dateVal0 = String.valueOf(Date.today());
        String dateVal1 = String.valueOf(Date.today() + 1);
        String integerVal0 = '1';
        String integerVal1 = '2';
            
        COH_App_Configuration__c configObj0 = new COH_App_Configuration__c();
        configObj0.Application_Name__c = chatterMonitorApp;
		configObj0.Name = name0;
        configObj0.Value__c = stringVal0;
        configObj0.Value_Type__c = COHUtil.STRING_TYPE;
        configObj0.Active__c = true;
            
        COH_App_Configuration__c configObj1 = new COH_App_Configuration__c();
        configObj1.Application_Name__c = chatterMonitorApp;
		configObj1.Name = name1;
        configObj1.Value__c = booleanVal0;
        configObj1.Value_Type__c = COHUtil.BOOLEAN_TYPE;
        configObj1.Active__c = true;

        COH_App_Configuration__c configObj2 = new COH_App_Configuration__c();
        configObj2.Application_Name__c = chatterMonitorApp;
		configObj2.Name = name2;
        configObj2.Value__c = decimalVal0;
        configObj2.Value_Type__c = COHUtil.DECIMAL_TYPE;
        configObj2.Active__c = true;
 
        COH_App_Configuration__c configObj3 = new COH_App_Configuration__c();
        configObj3.Application_Name__c = chatterMonitorApp;
		configObj3.Name = name3;
        configObj3.Value__c = dateVal0;
        configObj3.Value_Type__c = COHUtil.DATE_TYPE;
        configObj3.Active__c = true;

        COH_App_Configuration__c configObj4 = new COH_App_Configuration__c();
        configObj4.Application_Name__c = chatterMonitorApp;
		configObj4.Name = name4;
        configObj4.Value__c = integerVal0;
        configObj4.Value_Type__c = COHUtil.INTEGER_TYPE;
        configObj4.Active__c = true;
 
        List<COH_App_Configuration__c> configList = new List<COH_App_Configuration__c>();
        configList.add(configObj0);
        configList.add(configObj1);
        configList.add(configObj2);
        configList.add(configObj3);
        configList.add(configObj4);

        Test.startTest();
        Database.insert(configList);

	    COHUtil.setConfigurationValue(chatterMonitorApp, name0, stringVal1);
	    COHUtil.setConfigurationValue(chatterMonitorApp, name1, booleanVal1);
	    COHUtil.setConfigurationValue(chatterMonitorApp, name2, decimalVal1);
	    COHUtil.setConfigurationValue(chatterMonitorApp, name3, dateVal1);
	    COHUtil.setConfigurationValue(chatterMonitorApp, name4, integerVal1);
        
        configList = [select id, Application_Name__c, Name, Value__c, Value_Type__c, Active__c from COH_App_Configuration__c];
		System.assertEquals(5, configList.size());  
		
        String strVal = (String) COHUtil.getConfigurationValue(chatterMonitorApp, name0);
        System.assertEquals(stringVal1, strVal);
        
        Boolean boolVal = (Boolean) COHUtil.getConfigurationValue(chatterMonitorApp, name1);
        System.assertEquals(Boolean.valueOf(booleanVal1), boolVal);
        
        Decimal decVal = (Decimal) COHUtil.getConfigurationValue(chatterMonitorApp, name2);
        System.assertEquals(Decimal.valueOf(decimalVal1), decVal);
        
        Date dateVal = (Date) COHUtil.getConfigurationValue(chatterMonitorApp, name3);
        System.assertEquals(Date.valueOf(dateVal1), dateVal);
        
        Integer intVal = (Integer) COHUtil.getConfigurationValue(chatterMonitorApp, name4);
        System.assertEquals(Integer.valueOf(integerVal1), intVal);
        
        Test.stopTest();
    }    
    
    /*
     * Test getConfigurationValue()
     */
    private static testMethod void getConfigurationValueTest() {
        
        test.startTest();
        
		setWTPConfiguration();        
        
        String defaultNPSOwner = (String) COHUtil.getConfigurationValue(WTPApplicationName, defaultWTPNPSAccountOwnerProperty);
		System.assertEquals(defaultWTPNPSAccountOwnerValue, defaultNPSOwner);
        String defaultFoundationOwner = (String) COHUtil.getConfigurationValue(WTPApplicationName, defaultWTPFoundationAccountOwnerProperty);
		System.assertEquals(defaultWTPFoundationAccountOwnerValue, defaultFoundationOwner);
        String defaultLocation = (String) COHUtil.getConfigurationValue(WTPApplicationName, defaultLocationProperty);
		System.assertEquals(defaultLocationValue, defaultLocation);
        Integer integerVal = (Integer) COHUtil.getConfigurationValue(WTPApplicationName, integerTestProperty);
		System.assertEquals(Integer.valueOf(integerTestValue), integerVal);
        Decimal decimalVal = (Decimal) COHUtil.getConfigurationValue(WTPApplicationName, decimalTestProperty);
		System.assertEquals(Decimal.valueOf(decimalTestValue), decimalVal);
        Boolean booleanVal = (Boolean) COHUtil.getConfigurationValue(WTPApplicationName, booleanTestProperty);
		System.assertEquals(Boolean.valueOf(booleanTestValue), booleanVal);
        Date dateVal = (Date) COHUtil.getConfigurationValue(WTPApplicationName, dateTestProperty);
		System.assertEquals(Date.valueOf(dateTestValue), dateVal);
        Object foo = COHUtil.getConfigurationValue(WTPApplicationName, inactiveTestProperty);
		System.assertEquals(null, foo);
        foo = COHUtil.getConfigurationValue(null, null);
		System.assertEquals(null, foo);
        
        test.stopTest();
    }
    
    /*
     * Test buildSelectAllSOQLStatement()
     */
    private static testMethod void buildSelectAllSOQLStatementTest() {
        
        test.startTest();
        
        String soqlQuery = COHUtil.buildSelectAllSOQLStatement('Lead');
        if (!COHUtil.isValidStr(soqlQuery)) {
            System.assert(false, 'Error: soqlQuery is either null or empty');
        } else {
            System.assert(true);
        }
        
        soqlQuery = COHUtil.buildSelectAllSOQLStatement(null);
        if (!COHUtil.isValidStr(soqlQuery)) {
            System.assert(true);
        } else {
            System.assert(false, 'Error: soqlQuery is NOT null nor empty');
        }
        
        test.stopTest();
    }
    
    /*
     * Test getObjectName()
     */
    private static testMethod void getObjectNameTest() {
 		COH_App_Configuration__c configObj = new COH_App_Configuration__c();  
        
 		configObj.Name = defaultWTPNPSAccountOwnerProperty;
        configObj.Application_Name__c = WTPApplicationName;
        configObj.Value__c = defaultWTPNPSAccountOwnerValue;
        configObj.Value_Type__c = stringType;
        configObj.Active__c = true;
        
        test.startTest();
        
        insert configObj;
        
        Id configObjID = [select Id from COH_App_Configuration__c where Name = :defaultWTPNPSAccountOwnerProperty limit 1].Id;
		String objectName = COHUtil.getObjectName(configObjID);
        System.assertEquals('COH_App_Configuration__c', objectName);
        
		objectName = COHUtil.getObjectName(null);
        System.assertEquals(null, objectName);
        
        test.stopTest();
	}

    /*
     * Test COH_LogTest()
     */
    private static testMethod void COH_LogTest() {
        
        String debugLevel = 'DEBUG';
        String location = 'COHUtil.foo():  line 61';
        String message = 'Unexpected value found';
        Integer expectedListSize = 1;
        
        test.startTest();
        
		COHUtil.logMessage(WTPApplicationName, debugLevel, location, message);
        
        String soqlQuery = COHUtil.buildSelectAllSOQLStatement('COH_Log__c');
        List<COH_Log__c> cohLogs = Database.query(soqlQuery);
        System.assertEquals(expectedListSize, cohLogs.size());
		COH_Log__c cohLogObj = cohLogs.get(0);
                            
        System.assertEquals(WTPApplicationName, cohLogObj.Application_Name__c);
        System.assertEquals(debugLevel, cohLogObj.Level__c);
        System.assertEquals(location, cohLogObj.Location__c);
        System.assertEquals(message, cohLogObj.Message__c);
        
        test.stopTest();
	}
    
    /*
     * Test COH_LogInfoTest()
     */
    private static testMethod void COH_LogInfoTest() {
        
        String debugLevel = 'INFO';
        String location = 'COHUtil.foo():  line 61';
        String message = 'Unexpected value found';
        Integer expectedListSize = 1;
        
        test.startTest();

		COHUtil.logInfoMessage(WTPApplicationName, location, message);
        
        String soqlQuery = COHUtil.buildSelectAllSOQLStatement('COH_Log__c');
        List<COH_Log__c> cohLogs = Database.query(soqlQuery);
        System.assertEquals(expectedListSize, cohLogs.size());
		COH_Log__c cohLogObj = cohLogs.get(0);
                            
        System.assertEquals(WTPApplicationName, cohLogObj.Application_Name__c);
        System.assertEquals(debugLevel, cohLogObj.Level__c);
        System.assertEquals(location, cohLogObj.Location__c);
        System.assertEquals(message, cohLogObj.Message__c);
        
        test.stopTest();
	}
    
    /*
     * Test COH_LogDebugTest()
     */
    private static testMethod void COH_LogDebugTest() {
        
        String debugLevel = 'DEBUG';
        String location = 'COHUtil.foo():  line 61';
        String message = 'Unexpected value found';
        Integer expectedListSize = 1;
        
        test.startTest();

		COHUtil.logDebugMessage(WTPApplicationName, location, message);
        
        String soqlQuery = COHUtil.buildSelectAllSOQLStatement('COH_Log__c');
        List<COH_Log__c> cohLogs = Database.query(soqlQuery);
        System.assertEquals(expectedListSize, cohLogs.size());
		COH_Log__c cohLogObj = cohLogs.get(0);
                            
        System.assertEquals(WTPApplicationName, cohLogObj.Application_Name__c);
        System.assertEquals(debugLevel, cohLogObj.Level__c);
        System.assertEquals(location, cohLogObj.Location__c);
        System.assertEquals(message, cohLogObj.Message__c);
        
        test.stopTest();
	}
    
    /*
     * Test COH_LogWarnTest()
     */
    private static testMethod void COH_LogWarnTest() {
        
        String debugLevel = 'WARN';
        String location = 'COHUtil.foo():  line 61';
        String message = 'Unexpected value found';
        Integer expectedListSize = 1;
        
        test.startTest();

		COHUtil.logWarnMessage(WTPApplicationName, location, message);
        
        String soqlQuery = COHUtil.buildSelectAllSOQLStatement('COH_Log__c');
        List<COH_Log__c> cohLogs = Database.query(soqlQuery);
        System.assertEquals(expectedListSize, cohLogs.size());
		COH_Log__c cohLogObj = cohLogs.get(0);
                            
        System.assertEquals(WTPApplicationName, cohLogObj.Application_Name__c);
        System.assertEquals(debugLevel, cohLogObj.Level__c);
        System.assertEquals(location, cohLogObj.Location__c);
        System.assertEquals(message, cohLogObj.Message__c);
        
        test.stopTest();
	}
    
    /*
     * Test COH_LogErrorTest()
     */
    private static testMethod void COH_LogErrorTest() {
        
        String debugLevel = 'ERROR';
        String location = 'COHUtil.foo():  line 61';
        String message = 'Unexpected value found';
        Integer expectedListSize = 1;
        
        test.startTest();

		COHUtil.logErrorMessage(WTPApplicationName, location, message);
        
        String soqlQuery = COHUtil.buildSelectAllSOQLStatement('COH_Log__c');
        List<COH_Log__c> cohLogs = Database.query(soqlQuery);
        System.assertEquals(expectedListSize, cohLogs.size());
		COH_Log__c cohLogObj = cohLogs.get(0);
                            
        System.assertEquals(WTPApplicationName, cohLogObj.Application_Name__c);
        System.assertEquals(debugLevel, cohLogObj.Level__c);
        System.assertEquals(location, cohLogObj.Location__c);
        System.assertEquals(message, cohLogObj.Message__c);
        
        test.stopTest();
	}
    
    /*
     * Test COH_LogFatalTest()
     */
    private static testMethod void COH_LogFatalTest() {
        
        String debugLevel = 'FATAL';
        String location = 'COHUtil.foo():  line 61';
        String message = 'Unexpected value found';
        Integer expectedListSize = 1;
        
        test.startTest();

		COHUtil.logFatalMessage(WTPApplicationName, location, message);
        
        String soqlQuery = COHUtil.buildSelectAllSOQLStatement('COH_Log__c');
        List<COH_Log__c> cohLogs = Database.query(soqlQuery);
        System.assertEquals(expectedListSize, cohLogs.size());
		COH_Log__c cohLogObj = cohLogs.get(0);
                            
        System.assertEquals(WTPApplicationName, cohLogObj.Application_Name__c);
        System.assertEquals(debugLevel, cohLogObj.Level__c);
        System.assertEquals(location, cohLogObj.Location__c);
        System.assertEquals(message, cohLogObj.Message__c);
        
        test.stopTest();
	}
    
    /*
     * Test generateNumberStringTest()
     */
    private static testMethod void generateNumberStringTest() {
        
        String str0Expected = '000';
        String str1Expected = '011';
        String str2Expected = '222';
        String str3Expected = '3333';
        
 		String str0 = COHUtil.generateNumberString(0);
 		String str1 = COHUtil.generateNumberString(11);
 		String str2 = COHUtil.generateNumberString(222);
 		String str3 = COHUtil.generateNumberString(3333);
        
        System.assertEquals(str0Expected, str0);
        System.assertEquals(str1Expected, str1);
        System.assertEquals(str2Expected, str2);
        System.assertEquals(str3Expected, str3);
	}
    
    /*
     * Test delay()
     */
    private static testMethod void delayTest() {

        Long delayDuration = 2000;		// milliseconds
        Long startTime = System.currentTimeMillis();
        COHUtil.delay(delayDuration);		
        Long currentTime = System.currentTimeMillis();
        Long currentDelay = currentTime - startTime;
        System.assert(currentDelay >= delayDuration, 'Error: current delay (' + currentDelay + ') is less than the requested delay (' + delayDuration + ')');
        
        // this should throw an exception--used for code coverage reasons
        try {
	        COHUtil.delay(10000);		
        } catch (COHException e) {
            System.assert(true, 'delayTest():  COHException caught as expected');
        }
    }

    /*
     * Test isValidCreateLiteralRegExprTest()
     * 
     */
    private static testMethod void isValidCreateLiteralRegExprTest() {
	    String substitutionStr = '***';

        String ruleRegEx0 = 'Stupid';
        String targetRuleRegEx0a = 'Stupid';
        String targetRuleRegEx0b = '\\bStupid\\b';
        String targetRuleRegEx0c = '(?i)Stupid';
        String candidateStr0 = 'Stupidly, the Stupid fox jumps over stupid dogs.  Very Stupid.';
        String maskedResult0a = '***ly, the *** fox jumps over stupid dogs.  Very ***.';
        String maskedResult0b = 'Stupidly, the *** fox jumps over stupid dogs.  Very ***.';
        String maskedResult0c = '***ly, the *** fox jumps over *** dogs.  Very ***.';

        String regExprLiteral = COHUtil.createLiteralRegExprSearchString(ruleRegEx0, false, false);
        System.assertEquals(targetRuleRegEx0a, regExprLiteral);
		String newString = candidateStr0.replaceAll(regExprLiteral, substitutionStr);    
        System.assertEquals(maskedResult0a, newString);
        
        // test whole word search
        regExprLiteral = COHUtil.createLiteralRegExprSearchString(ruleRegEx0, true, false);
        System.assertEquals(targetRuleRegEx0b, regExprLiteral);
		newString = candidateStr0.replaceAll(regExprLiteral, substitutionStr);    
        System.assertEquals(maskedResult0b, newString);
        
		// test case insensitive search
        regExprLiteral = COHUtil.createLiteralRegExprSearchString(ruleRegEx0, false, true);
        System.assertEquals(targetRuleRegEx0c, regExprLiteral);
		newString = candidateStr0.replaceAll(regExprLiteral, substitutionStr);    
        System.assertEquals(maskedResult0c, newString);
        
        String ruleRegEx1 = '[abc]*4[0-9]{3}\\s*\\d{3}';
        String targetRuleRegEx1 = '\\[abc\\]\\*4\\[0\\-9\\]\\{3\\}\\\\s\\*\\\\d\\{3\\}';
        String candidateStr1 = 'Test abcab4123 121 foobar ' + ruleRegEx1 + ' tallyho';
        String maskedResult1 = 'Test abcab4123 121 foobar ' + substitutionStr + ' tallyho';

        regExprLiteral = COHUtil.createLiteralRegExprSearchString(ruleRegEx1, false, false);
        System.assertEquals(targetRuleRegEx1, regExprLiteral);
		newString = candidateStr1.replaceAll(regExprLiteral, substitutionStr);    
        System.assertEquals(maskedResult1, newString);
        
        String ruleRegEx2 = '[abc]*4[0-9]{3}\\s*\\d{3}[def]';
        String targetRuleRegEx2 = '\\b\\[abc\\]\\*4\\[0\\-9\\]\\{3\\}\\\\s\\*\\\\d\\{3\\}\\[def\\]\\b';
        String candidateStr2 = 'Test' + ruleRegEx2 + 'foobar ' + ruleRegEx2 + ' tallyho';
        String maskedResult2 = 'Test' + substitutionStr + 'foobar ' + ruleRegEx2 + ' tallyho';

        regExprLiteral = COHUtil.createLiteralRegExprSearchString(ruleRegEx2, true, false);
        System.assertEquals(targetRuleRegEx2, regExprLiteral);
		newString = candidateStr2.replaceAll(regExprLiteral, substitutionStr);    

        System.assertEquals(maskedResult2, newString);
        
    }
    
    /*
     * Test getLongID()
     * 
     */
    private static testMethod void getLongIDTest() {
        String baseShortID = '001xa000003DIlo';
        String baseLongID = '005d0000003cyGSAAY';
        
        String longID = COHUtil.getLongID(baseShortID);
        System.assertEquals(18, longID.length());
        System.assertEquals(baseShortID, longID.left(COHUtil.GUI_ID_LENGTH));
        
        longID = COHUtil.getLongID(baseLongID);
        System.assertEquals(18, longID.length());
        System.assertEquals(baseLongID, longID);
        
        longID = COHUtil.getLongID(null);
        System.assertEquals(null, longID);
    }
    
    /*
     * Test Code for identifying the director & VP - 01/15/2017
     */
    
    private static testMethod void FindDirectorVPTest() {     
        test.startTest();
        Map<String,ID> profiles = new Map<String,ID>();
        List<Profile> ps = [select id, name from Profile where name = 'System Administrator'];        
        for(Profile p : ps){
            profiles.put(p.name, p.id);
        }
        User admin = [SELECT Id, name, ManagerId, Director__c, VP_SVP_CTO__c, MGR__c FROM user WHERE profileid = 
                      :profiles.get('System Administrator') and name = 'Abhishek Kumar' and isactive = true Limit 1];
        id iAdmin;
        if (admin != null)
        {
            iAdmin = admin.MGR__c;
        }
            
        User objEmployeeMgr = [Select id, Name, ManagerId, Title, MGR__c from User where Id = :iAdmin and IsActive=true limit 1];
        id iDirector;
        id iVP;
        if(objEmployeeMgr != null)
        {
            User objEmployeeDirector = COHUtil.FindDirectorRecursive(objEmployeeMgr);
            if(objEmployeeDirector != null)
            {
                iDirector = objEmployeeDirector.Id;
                admin.Director__c = objEmployeeDirector.Id;
            }
            
            User objEmployeeVP = COHUtil.FindDirectorVPRecursive(objEmployeeMgr);
            if(objEmployeeVP != null)
            {
                iVP = objEmployeeVP.Id;
                admin.VP_SVP_CTO__c = objEmployeeVP.Id;
            }
        }
        
        if(iDirector != null)
        {
            System.assertEquals(admin.Director__c, iDirector); 
        }
        if(iVP != null)
        {
            System.assertEquals(admin.VP_SVP_CTO__c, iVP);
        }
        
        /*admin.Line_Item_ID__c = admin.Id;
        Schema.SObjectField schemaField = User.Fields.Line_Item_ID__c;
        Database.upsertResult result =  Database.upsert(admin, schemaField, false) ;
        system.assert(result.issuccess());
           
       	Schema.SObjectField schemaFieldVP = User.Fields.VP_SVP_CTO__c;
        Database.upsertResult ResultsVP = Database.upsert(admin, schemaFieldVP, false);
        system.assert(ResultsVP.issuccess());*/     
        
        test.stopTest();
    }
    
    
    /*
     * Test standardizeIntegerLeft and standardizeIntegerRight()
     * 
     */
    private static testMethod void standardizeIntegerTest() {

        String result = COHUtil.standardizeIntegerRight(5, null, 6);
        System.assertEquals(null, result);
        result = COHUtil.standardizeIntegerRight(5, '0', 0);
        System.assertEquals(null, result);
        result = COHUtil.standardizeIntegerRight(5, '0', -1);
        System.assertEquals(null, result);
        result = COHUtil.standardizeIntegerRight(-1, '0', 6);
        System.assertEquals(null, result);
        
        result = COHUtil.standardizeIntegerRight(1, '0', 6);
        System.assertEquals('100000', result);
        result = COHUtil.standardizeIntegerRight(12345, '0', 6);
        System.assertEquals('123450', result);
        result = COHUtil.standardizeIntegerRight(123456, '0', 6);
        System.assertEquals('123456', result);
        result = COHUtil.standardizeIntegerRight(1234567, '0', 6);
        System.assertEquals('1234567', result);

        result = COHUtil.standardizeIntegerLeft(5, null, 6);
        System.assertEquals(null, result);
        result = COHUtil.standardizeIntegerLeft(5, '0', 0);
        System.assertEquals('5', result);
        result = COHUtil.standardizeIntegerLeft(-1, '0', -1);
        System.assertEquals('-1', result);
        result = COHUtil.standardizeIntegerLeft(null, '0', -1);
        System.assertEquals(null, result);
        
        result = COHUtil.standardizeIntegerLeft(1, '0', 6);
        System.assertEquals('000001', result);
        result = COHUtil.standardizeIntegerLeft(12345, '0', 6);
        System.assertEquals('012345', result);
        result = COHUtil.standardizeIntegerLeft(123456, '0', 6);
        System.assertEquals('123456', result);
        result = COHUtil.standardizeIntegerLeft(1234567, '0', 6);
        System.assertEquals('1234567', result);
    }

    /*
     * test putSObjectValue() 
     * 
     */
    private static TestMethod void putSObjectValueTest() {
        String firstName = 'Thomas';
        String lastName = 'Magnum';
		Id NPSAccountRecordTypeID = [select Id,name from RecordType where name = 'New Patient Services' and SObjectType = 'Account' limit 1].Id;
    	String accountPatientStatusNew = 'New';
    	String cohMRN = '00000000000001';  
		String accountStatusReason = 'This is a test';	// To comply with a Validation Rule
    
        Test.startTest();
        
        Id accountObjID = createAccountRecord(NPSAccountRecordTypeID, firstName, lastName, accountPatientStatusNew, accountStatusReason, cohMRN);
        String getAccountQuery = COHUtil.buildSelectAllSOQLStatement('Account') + ' where Id = :accountObjID';
        List<Account> accountList = Database.query(getAccountQuery);
        System.assertEquals(1, accountList.size());
        Account accountObj = accountList.get(0);
        
        System.assertEquals(null, accountObj.Alternate_MRN__c);
        System.assertEquals(null, accountObj.Appointment_Date_Time__c);
        System.assertEquals(false, accountObj.Advanced_Directive__c);
        System.assertEquals(0, accountObj.NumberOfEmployees);

        String newCOHMRN = '00000000000002';
        Date newDateVal = Date.today();
        Boolean newBooleanVal = true;
        Integer newIntegerVal = 42;
        
        COHUtil.putSObjectValue(accountObj, 'Alternate_MRN__c', newCOHMRN, 'String');
        COHUtil.putSObjectValue(accountObj, 'Appointment_Date_Time__c', String.valueOf(newDateVal), 'Date');
        COHUtil.putSObjectValue(accountObj, 'Advanced_Directive__c', String.valueOf(newBooleanVal), 'Boolean');
        COHUtil.putSObjectValue(accountObj, 'NumberOfEmployees', String.valueOf(newIntegerVal), 'Integer');
        
        Database.update(accountObj);
        
        accountList = Database.query(getAccountQuery);
        System.assertEquals(1, accountList.size());
        accountObj = accountList.get(0);
        System.assertEquals(newCOHMRN, accountObj.Alternate_MRN__c);
        System.assertEquals(newDateVal, accountObj.Appointment_Date_Time__c);
        System.assertEquals(newBooleanVal, accountObj.Advanced_Directive__c);
        System.assertEquals(newIntegerVal, accountObj.NumberOfEmployees);   
        
        Boolean exceptionCaught = false;
        try {
             COHUtil.putSObjectValue(accountObj, 'Alternate_MRN__c', newCOHMRN, 'XXX');
        } catch (Exception e) {
            exceptionCaught = true;
        }
        System.assertEquals(true, exceptionCaught);

        exceptionCaught = false;
        try {
             COHUtil.putSObjectValue(null, 'Alternate_MRN__c', newCOHMRN, 'XXX');
        } catch (Exception e) {
            exceptionCaught = true;
        }
        System.assertEquals(true, exceptionCaught);
        
        Test.stopTest();
    }
    
    /*
     * Create an account record.
     * 
     * @param recordTypeID			Record Type for the account object.
     * @param firstName				First name for the account.
     * @param lastName				Last name for the account.
     * @param patientStatus			Patient status.
     * @param accountStatusReason	Account Status Reason (to comply with an unrelated validation rule).
     * @param cohMRN				MRN for the patient.
     * @return 						Object ID for the created record.
     * 
     */
    private static Id createAccountRecord(Id recordTypeID, String firstName, String lastName, 
                                          String patientStatus, String accountStatusReason, String cohMRN) {
        
        Account accountObj0 = new Account();
        accountObj0.RecordTypeId = recordTypeID;
        accountObj0.FirstName = firstName;
        accountObj0.LastName = lastName;
       	accountObj0.Patient_Status__c = patientStatus;
        accountObj0.Status_Reason__c = accountStatusReason;
        accountObj0.COH_MRN__c = cohMRN;   
        accountObj0.Alternate_MRN__c = null;
        accountObj0.Appointment_Date_Time__c = null;
        accountObj0.Advanced_Directive__c = false;
        accountObj0.NumberOfEmployees = 0;
        
        Database.insert(accountObj0);
        return accountObj0.Id;
    }    
    
    /*
     * Test convertToBoolean() 
     * 
     */
    private static TestMethod void convertToBooleanTest() {
        Boolean bVal = COHUtil.convertToBoolean('True');
        System.assertEquals(true, bVal);
        bVal = COHUtil.convertToBoolean('YES');
        System.assertEquals(true, bVal);
        bVal = COHUtil.convertToBoolean('falSe');
        System.assertEquals(false, bVal);
        bVal = COHUtil.convertToBoolean('No');
        System.assertEquals(false, bVal);
        bVal = COHUtil.convertToBoolean('foo');
        System.assertEquals(false, bVal);
    }    

    /*
     * Test createEmailMessage()
     * 
     */
    private static TestMethod void createEmailMessageTest() {
        String getUserSOQLQuery = COHUtil.buildSelectAllSOQLStatement('User') + ' where alias = \'saccount\'';
        List<User> userList= Database.query(getUserSOQLQuery);
        User systemAccountUser = userList.get(0);
        List<String> toAddresses = new LIst<String> {'addressTo@coh.org'};
        Messaging.SingleEmailMessage email = COHUtil.createEmailMessage(systemAccountUser, systemAccountUser, 'from@coh.org',  
                                                                        													toAddresses, 'Test Subject', 'Test Body');
        System.assertEquals(systemAccountUser.Email, email.getReplyTo());
        List<String> toAddressesList = email.getToAddresses();
        System.assertEquals(1, toAddressesList.size());
        System.assertEquals(systemAccountUser.Email, toAddressesList.get(0));

        System.assertEquals('Test Subject', email.getSubject());
        System.assertEquals('Test Body', email.getHtmlBody());
        
    }

    
	/*
	 * Test getPicklistValuesTes(;)
	 * 
	 */
    private static TestMethod void getPicklistValuesTest() {
		List<String> picklistValues = COHUtil.getPicklistValues('Account', 'Account_Type__c', true);
        Integer picklistSize = picklistValues.size();
        if (picklistSize <= 0) {
            System.assert(false, 'Error: expected values for the Account.Account_Type__c field');
        }
		picklistValues = COHUtil.getPicklistValues('Account', 'Account_Type__c', false);
        picklistSize = picklistValues.size();
        if (picklistSize <= 0) {
            System.assert(false, 'Error: expected values for the Account.Account_Type__c field');
        }
    }
    /*
     * Test the getDependentPicklistValues
     * 
     */
    private static TestMethod void getDependentPicklistValuesTest(){
        
        Map<Object, List<Schema.PicklistEntry>> picklistValues=COHUtil.getDependentPicklistValues('Account','Strategic_Program__c');
        
        list<object> pickvalues=new list<object>();
        set<Object> objName=picklistValues.keyset();
        for(Object ob:objName){
            pickvalues.add(ob);
        }
        pickvalues.sort();
        if(pickvalues.size()>0){
            system.assertEquals('CAR-OTHER',pickvalues.get(0));
            system.assertEquals('CCG-GENETIC CONSULT',pickvalues.get(1));
        }
    }
    
     /*
      * Test the functinality of businessDays between startDate & endDate.
      * 
      */
     private static TestMethod void businessDaysTest(){
     date startdate =date.newInstance(2019, 03, 22);
     date enddate =date.newInstance(2019, 03, 27);
     Integer businessDays=Integer.valueof(COHUtil.calculateWorkingDays(startdate,enddate));
     system.assertEquals(4, businessDays);
}    
   
}