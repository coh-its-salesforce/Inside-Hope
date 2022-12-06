/* 
 * This test class verifies the functionality of COHCustomSettingUtil.  
 * 
 * Raymond Tam
 * City of Hope
 * Copyright (c) 2017
 * 
 * No portion of this code may be copied, transferred, or transmitted
 * in any form (written, electronic, or otherwise) without the prior
 * written consent from the City of Hope.
 *  
 */
@isTest
public class COHCustomSettingUtilTest {
    private static final Boolean mRunVerifyGetCustomSettingConfigurationGroup = false;
    private static final Boolean mRunVerifyGetCustomSettingConfigurationValue = true;
    private static final Boolean mRunAllTests = true;

    private static final String INVALID_TYPE = 'Invalid Type';

    private static final String APP_NAME1 = 'App Name1';
    private static final String APP_NAME2 = 'App Name2';
    private static final String APP_NAME3 = 'App Name3';
    private static final String EXCLUDED_PROVIDER = 'Excluded Provider';
    private static final String VALID_PROVIDER = 'Valid Provider';
    private static final String MOLINA = 'Molina';
    private static final String MOLINA_VAL = 'Molina Health';
    private static final String KAISER = 'Kaiser';
    private static final String KAISER_VAL = 'Kaiser Permanente';
    private static final String AETNA = 'Aetna';
    private static final String AETNA_VAL = 'Aetna PPO';
    private static final String BLUE_CROSS = 'Blue Cross';
    private static final String BLUE_CROSS_VAL = 'Blue Cross HMO';
    private static final String DEFAULT_COST = 'Default Cost';
    private static final String DEFAULT_COST_VAL = '32';
    private static final String ENABLE_AUDIT = 'Enable Audit';
    private static final String ENABLE_AUDIT_VAL = 'false';
    private static final String INACTIVE = 'foo';
    private static final String INACTIVE_VAL = 'bar';
    private static final String DATE_TEST = 'Date Test';
    private static final String DATE_TEST_VAL = '2014-12-04 00:00:00';
    private static final String PI_TEST = 'Pi';
    private static final String PI_TEST_VAL = '3.14156';
    private static final String INVALID_TEST = 'Invalid value type';
    private static final String INVALID_TEST_VAL = 'foobar';
    private static final String ACTIVE = 'true';
    
    /*
     * Test getCustomSettingConfigurationGroup
     * 
     */
    private static testMethod void getCustomSettingConfigurationGroupTest() {
        if (!mRunAllTests && !mRunVerifyGetCustomSettingConfigurationGroup) {
            System.debug('Skipping getCustomSettingConfigurationGroupTest()');
            return;
        }

        test.startTest();
        setupCustomSettings();
        
        List<COH_Config_Setting__c> configGroupList = COHCustomSettingUtil.getCustomSettingConfigurationGroup(null, null);
        if (COHUtil.isValidList(configGroupList)) {
            System.assert(false, 'Expected a null list but retrieved a list with ' + configGroupList.size() + ' elements');
        }

        // Test excluded providers for APP_NAME1
        configGroupList = COHCustomSettingUtil.getCustomSettingConfigurationGroup(APP_NAME1, EXCLUDED_PROVIDER);
        Integer listSize = configGroupList.size();
        System.assertEquals(2, listSize);
        for (COH_Config_Setting__c configObj : configGroupList) {
            String name = configObj.Name;
            String propertyVal = configObj.Value__c;
            if (name.equalsIgnoreCase(BLUE_CROSS)) {
                System.assertEquals(BLUE_CROSS_VAL, propertyVal);
            } else if (name.equalsIgnoreCase(AETNA)) {
                System.assertEquals(AETNA_VAL, propertyVal);
            } else {
                String msg = 'Error: retrieved unexpected excluded provider values--> ';
                msg += '\n name: ' + name;
                msg += '\n value: ' + propertyVal;
                System.assert(false, msg);
            }
        }  

        // Test valid providers for APP_NAME1

        configGroupList = COHCustomSettingUtil.getCustomSettingConfigurationGroup(APP_NAME1, VALID_PROVIDER);
        listSize = configGroupList.size();
        System.assertEquals(1, listSize);
        for (COH_Config_Setting__c configObj : configGroupList) {
            String name = configObj.Name;
            String propertyVal = configObj.Value__c;
            if (name.equalsIgnoreCase(MOLINA)) {
                System.assertEquals(MOLINA_VAL, propertyVal);
            } else {
                String msg = 'Error: retrieved unexpected valid provider values--> ';
                msg += '\n name: ' + name;
                msg += '\n value: ' + propertyVal;
                System.assert(false, msg);
            }
        }  
        test.stopTest();
    }    

    /*
     * Test getCustomSettingConfigurationValue()
     * 
     */
    private static testMethod void getCustomSettingConfigurationValueTest() {
        if (!mRunAllTests && !mRunVerifyGetCustomSettingConfigurationValue) {
            System.debug('Skipping getCustomSettingConfigurationValueTest()');
            return;
        }
        
        test.startTest();
        
        setupCustomSettings();
        
        String strVal = (String) COHCustomSettingUtil.getCustomSettingConfigurationValue(APP_NAME1, KAISER);
        System.assertEquals(KAISER_VAL, strVal);

        Integer integerVal = (Integer) COHCustomSettingUtil.getCustomSettingConfigurationValue(APP_NAME2, DEFAULT_COST);
        System.assertEquals(Integer.valueOf(DEFAULT_COST_VAL), integerVal);
        
        Boolean booleanVal = (Boolean) COHCustomSettingUtil.getCustomSettingConfigurationValue(APP_NAME2, ENABLE_AUDIT);
        System.assertEquals(false, booleanVal);
        
        strVal = (String) COHCustomSettingUtil.getCustomSettingConfigurationValue(APP_NAME3, 'foo');
        System.assertEquals(null, strVal);

        strVal = (String) COHCustomSettingUtil.getCustomSettingConfigurationValue(null, 'foo');
        System.assertEquals(null, strVal);

        strVal = (String) COHCustomSettingUtil.getCustomSettingConfigurationValue(APP_NAME3, null);
        System.assertEquals(null, strVal);

        Date dateVal = (Date) COHCustomSettingUtil.getCustomSettingConfigurationValue(APP_NAME3, DATE_TEST);
        System.assertEquals(Date.valueOf(DATE_TEST_VAL), dateVal);
        
        Decimal decimalVal = (Decimal) COHCustomSettingUtil.getCustomSettingConfigurationValue(APP_NAME3, PI_TEST);
        System.assertEquals(Decimal.valueOf(PI_TEST_VAL), decimalVal);
        
        Object invalidVal =  COHCustomSettingUtil.getCustomSettingConfigurationValue(APP_NAME3, INVALID_TEST);
        System.assertEquals(null, invalidVal);
        
        invalidVal =  COHCustomSettingUtil.getCustomSettingConfigurationValue(APP_NAME3, null);
        System.assertEquals(null, invalidVal);
        
        invalidVal =  COHCustomSettingUtil.getCustomSettingConfigurationValue(null, PI_TEST);
        System.assertEquals(null, invalidVal);
        
        
        test.stopTest();
    }

    /*    
     * Set up the custom settings
     * 
     */
    private static void setupCustomSettings() {
        COH_Config_Setting__c configObj0 = new COH_Config_Setting__c();
        configObj0.Active__c = true;
        configObj0.Application_Name__c = APP_NAME1;
        configObj0.Name = KAISER;
        configObj0.Value__c = KAISER_VAL;
        configObj0.Value_Type__c = COHCustomSettingUtil.STRING_TYPE;
        configObj0.Configuration_Group__c = null;

        COH_Config_Setting__c configObj1 = new COH_Config_Setting__c();
        configObj1.Active__c = true;
        configObj1.Application_Name__c = APP_NAME1;
        configObj1.Name = MOLINA;
        configObj1.Value__c = MOLINA_VAL;
        configObj1.Value_Type__c = COHCustomSettingUtil.STRING_TYPE;
        configObj1.Configuration_Group__c = VALID_PROVIDER;
        
        COH_Config_Setting__c configObj2 = new COH_Config_Setting__c();
        configObj2.Active__c = true;
        configObj2.Application_Name__c = APP_NAME1;
        configObj2.Name = AETNA;
        configObj2.Value__c = AETNA_VAL;
        configObj2.Value_Type__c = COHCustomSettingUtil.STRING_TYPE;
        configObj2.Configuration_Group__c = EXCLUDED_PROVIDER;
       
        COH_Config_Setting__c configObj3 = new COH_Config_Setting__c();
        configObj3.Active__c = true;
        configObj3.Application_Name__c = APP_NAME1;
        configObj3.Name = BLUE_CROSS;
        configObj3.Value__c = BLUE_CROSS_VAL;
        configObj3.Value_Type__c = COHCustomSettingUtil.STRING_TYPE;
        configObj3.Configuration_Group__c = EXCLUDED_PROVIDER;
        
        COH_Config_Setting__c configObj4 = new COH_Config_Setting__c();
        configObj4.Active__c = true;
        configObj4.Application_Name__c = APP_NAME2;
        configObj4.Name = ENABLE_AUDIT;
        configObj4.Value__c = ENABLE_AUDIT_VAL;
        configObj4.Value_Type__c = COHCustomSettingUtil.BOOLEAN_TYPE;
        configObj4.Configuration_Group__c = null;
        
        COH_Config_Setting__c configObj5 = new COH_Config_Setting__c();
        configObj5.Active__c = true;
        configObj5.Application_Name__c = APP_NAME2;
        configObj5.Name = DEFAULT_COST;
        configObj5.Value__c = DEFAULT_COST_VAL;
        configObj5.Value_Type__c = COHCustomSettingUtil.INTEGER_TYPE;
        configObj5.Configuration_Group__c = null;
        
        COH_Config_Setting__c configObj6 = new COH_Config_Setting__c();
        configObj6.Active__c = false;
        configObj6.Application_Name__c = APP_NAME3;
        configObj6.Name = INACTIVE;
        configObj6.Value__c = INACTIVE_VAL;
        configObj6.Value_Type__c = COHCustomSettingUtil.BOOLEAN_TYPE;
        configObj6.Configuration_Group__c = null;
        
        COH_Config_Setting__c configObj7 = new COH_Config_Setting__c();
        configObj7.Active__c = true;
        configObj7.Application_Name__c = APP_NAME3;
        configObj7.Name = DATE_TEST;
        configObj7.Value__c = DATE_TEST_VAL;
        configObj7.Value_Type__c = COHCustomSettingUtil.DATE_TYPE;
        configObj7.Configuration_Group__c = null;
        
        COH_Config_Setting__c configObj8 = new COH_Config_Setting__c();
        configObj8.Active__c = true;
        configObj8.Application_Name__c = APP_NAME3;
        configObj8.Name = PI_TEST;
        configObj8.Value__c = PI_TEST_VAL;
        configObj8.Value_Type__c = COHCustomSettingUtil.DECIMAL_TYPE;
        configObj8.Configuration_Group__c = null;

        COH_Config_Setting__c configObj9 = new COH_Config_Setting__c();
        configObj9.Active__c = true;
        configObj9.Application_Name__c = APP_NAME3;
        configObj9.Name = INVALID_TEST;
        configObj9.Value__c = INVALID_TEST_VAL;
        configObj9.Value_Type__c = INVALID_TYPE;
        configObj9.Configuration_Group__c = null;

        
        List<COH_Config_Setting__c> configObjList = new List<COH_Config_Setting__c>();
        configObjList.add(configObj0);
        configObjList.add(configObj1);
        configObjList.add(configObj2);
        configObjList.add(configObj3);
        configObjList.add(configObj4);
        configObjList.add(configObj5);
        configObjList.add(configObj6);
        configObjList.add(configObj7);
        configObjList.add(configObj8);
        configObjList.add(configObj9);
        
        Database.insert(configObjList);
    }
}