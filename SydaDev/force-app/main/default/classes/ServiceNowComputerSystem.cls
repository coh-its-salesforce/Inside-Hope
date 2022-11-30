/*
Author : CloudAction
Date : March 2020
Description : ServiceNow Computer System Class.
*/
global class ServiceNowComputerSystem{
    Public String Sys_id {get;set;}
    Public String Name {get;set;}
    Public String Serial_number {get;set;}
    Public String Ip_Address {get;set;}
    Public String Asset_tag {get;set;}
    Public String Manufacturer {get;set;}
    Public String Model_id {get;set;}
    Public String Os_version {get;set;}
    Public String First_discovered {get; set;}
    Public String Last_discovered {get; set;}
    Public String Sys_class_name {get; set;}
    Public String Sys_updated_on {get; set;}
}