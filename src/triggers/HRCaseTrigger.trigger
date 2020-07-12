/*-------------------------------------------------------------------------------------------------*
  Apex trigger - HR_Case__c custom object
  HRM Case Management application trigger for validations and record sharing with AS/AO/ROO.
 *-------------------------------------------------------------------------------------------------*
  Author           | Date        | Version | Description
 *-------------------------------------------------------------------------------------------------*
  Rajakumar          12/05/2013    1.0       Initial version.
 *-------------------------------------------------------------------------------------------------* 
 
 *-------------------------------------------------------------------------------------------------*/
trigger HRCaseTrigger on HR_Case__c (before insert, before update, after insert, after update, after delete) {
    
    // before inserting a new record
    if(Trigger.isBefore && Trigger.isInsert) {
        HRCaseHelper.onBeforeInsert(Trigger.new);
    }
    
    // before updating the existing record
    if(Trigger.isBefore && Trigger.isUpdate) {
        HRCaseHelper.onBeforeUpdate(Trigger.new, Trigger.oldMap);
    }
    
    // after inserting a new record
    if(Trigger.isAfter && Trigger.isInsert) {
        HRCaseHelper.onAfterInsert(Trigger.new);
    }
    
    // after updating the existing record
    if(Trigger.isAfter && Trigger.isUpdate) {
        HRCaseHelper.onAfterUpdate(Trigger.new, Trigger.oldMap, Trigger.newMap);
    }
    
    // after deleting the existing record
    if(Trigger.isAfter && Trigger.isDelete) {
        HRCaseHelper.onAfterDelete(Trigger.old);
    }          
}