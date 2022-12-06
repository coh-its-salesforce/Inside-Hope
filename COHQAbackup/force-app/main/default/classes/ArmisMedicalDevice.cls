/*
Author : CloudAction
Date : July 2019
Description : Armis Medical Device.
*/

global class ArmisMedicalDevice{
    Public String Category {get;set;}
    Public String FirstSeen {get;set;}
    Public String Id {get;set;}
    Public String IpAddress {get;set;}
    Public String LastSeen {get;set;}
    Public String MacAddress {get;set;}
    Public String Manufacturer {get;set;}
    Public String Model {get;set;}
    Public String Name {get;set;}
    Public String OperatingSystem {get; set;}
    Public String OperatingSystemVersion {get; set;}
    Public String RiskLevel {get; set;}
    Public List<String> Tags {get;set;}
    Public String Type {get;set;}
    Public String User {get;set;}
}