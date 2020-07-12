/*-------------------------------------------------------------------------------------
  TestHRCaseTrigger.cls
  Class for testing the apex trigger on HR_Case__c custom object
  -------------------------------------------------------------------------------------
   Author                |Date       |Version  |Description
  -------------------------------------------------------------------------------------
   Rajakumar              12/05/2013  1.0       Created.
   Rajakumar              02/14/2014  1.1       Revised after new requirements.
   Rajakumar              07/30/2015  1.2       O&M Case# 19802 - lookup field filters
  -------------------------------------------------------------------------------------
  
  -------------------------------------------------------------------------------------
*/  
@isTest(seeAllData=true)
private class TestHRCaseTrigger {
    
    @isTest
    static void deleteASAOShare() {
        Id cpoallusersGrpId = [Select Id from Group Where DeveloperName = 'HRM_Users'].Id;
        Id cposuperusersGrpId = [Select Id from Group Where DeveloperName = 'HRM_Superusers'].Id;
//        createUserAssignGroup();
        List<GroupMember> allusersGrpmember = [Select GroupId, UserorGroupId from GroupMember 
                                                WHERE GroupId = :cposuperusersGrpId LIMIT 1];
        List<User> users = [SELECT Id FROM User WHERE IsActive = true AND Id = :allusersGrpmember[0].UserorGroupId LIMIT 1];
        
        Id oigCaseRecTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'HRM_OIG_Case' AND SObjectType = 'HR_Case__c'].Id;
        Id adverseCaseRecTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'HRM_Disciplinary_Case' AND SObjectType = 'HR_Case__c'].Id;
        
        Id cpoQueueId = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'HRM_Case_Queue'].Id;
        
        List<HR_Case__c> pcaseList = new List<HR_Case__c>();
        Set<Id> recordIds = new Set<Id>();
        // only selected the gsa recordtypes - version 1.2.
        List<Contact> contacts = [SELECT Id FROM Contact WHERE RecordType.Name='GSA' LIMIT 1];
        
        HR_Case__c parent = new HR_Case__c(RecordTypeId= oigCaseRecTypeId, HRM_OIG_Case_Number__c='Trig10d231$Test', 
                                   HRM_Office__c='C', Priority__c='Low', Status__c='Open', Private__c = false,
                                   Stage__c='With Intake Reviewer', HRM_Deciding_Official_RMO__c=contacts[0].Id,
                                   HRM_Office_of_Assigned_Specialist__c='C',
                                   HRM_Assigned_Specialist__c=users[0].Id, HRM_ROO_AO__c=users[0].Id);
        insert parent;
        
        recordIds.add(parent.Id);
        
        Test.startTest();
        delete parent;
        Test.stopTest();
        
        List<HR_Case__Share> pcASshares = [SELECT Id FROM HR_Case__Share 
                                                WHERE ParentId IN :recordIds AND UserorGroupId =:users[0].Id 
                                                AND AccessLevel = 'Edit' AND RowCause = 'AS_Access__c'];
        System.assertEquals(0, pcASshares.size());
        
        List<HR_Case__Share> pcAOshares = [SELECT Id FROM HR_Case__Share 
                                                WHERE ParentId IN :recordIds AND UserorGroupId =:users[0].Id 
                                                AND AccessLevel = 'Edit' AND RowCause = 'ROO_AO_Access__c'];
        System.assertEquals(0, pcAOshares.size());
        
    }
    
    /* Commented after DEMO# 1
    @isTest
    static void updateParentCaseClosure() {
        Id cpoallusersGrpId = [Select Id from Group Where DeveloperName = 'HRM_Users'].Id;
        Id cposuperusersGrpId = [Select Id from Group Where DeveloperName = 'HRM_Superusers'].Id;
        
        List<GroupMember> allusersGrpmember = [Select GroupId, UserorGroupId from GroupMember 
                                                WHERE GroupId = :cposuperusersGrpId LIMIT 1];
        List<User> users = [SELECT Id FROM User WHERE IsActive = true AND Id = :allusersGrpmember[0].UserorGroupId LIMIT 1];
        
        Id oigCaseRecTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'HRM_OIG_Case' AND SObjectType = 'HR_Case__c'].Id;
        Id adverseCaseRecTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'HRM_Disciplinary_Case' AND SObjectType = 'HR_Case__c'].Id;
        
        Id cpoQueueId = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'HRM_Case_Queue'].Id;
        
        List<HR_Case__c> pcaseList = new List<HR_Case__c>();
        Set<Id> recordIds = new Set<Id>();
        List<Contact> contacts = [SELECT Id FROM Contact LIMIT 1];
        HR_Case__c parent = new HR_Case__c(RecordTypeId= oigCaseRecTypeId, HRM_OIG_Case_Number__c='Trig9d231$Test', 
                                   HRM_Office__c='C', Priority__c='Low', Status__c='Open', Private__c = false,
                                   Stage__c='With Intake Reviewer', HRM_Deciding_Official_RMO__c=contacts[0].Id,
                                   HRM_Office_of_Assigned_Specialist__c='C',
                                   HRM_Assigned_Specialist__c=users[0].Id, HRM_ROO_AO__c=users[0].Id);
        insert parent;
          
        parent.Stage__c = 'Assigned to Responsible Office Official';
        update parent;
        parent.Stage__c = 'Assigned to Action Officer';
        update parent;
        parent.Stage__c = 'Assigned to Assigned Specialist';
        parent.HRM_Office_of_Assigned_Specialist__c = 'C';
        update parent;
        
        HR_Case__c child = new HR_Case__c(RecordTypeId= adverseCaseRecTypeId, HRM_OIG_Case_Number__c='Trig9d232$Test', 
                                   HRM_Office__c='CH', Priority__c='Low', Status__c='Open', Private__c = false,
                                   Stage__c='With Intake Reviewer', HRM_Deciding_Official_RMO__c=contacts[0].Id,
                                   HRM_Office_of_Assigned_Specialist__c='C',
                                   HRM_Assigned_Specialist__c=users[0].Id,Parent_HR_Case_No__c=parent.Id);
        insert child;
        
        parent.Stage__c = 'Ready for Action Officer to View';
        update parent;
        
        parent.Status__c = 'Closed'; 
        parent.HRM_Date_Initial_Draft_to_MGMT__c = Date.today();
        parent.HRM_Date_OGC_Returned_Draft__c = Date.today();
        parent.HRM_Date_to_OGC_for_Concurrence__c = Date.today();
        parent.HRM_Concurrence_Recd_from_MGMT__c = Date.today();
        parent.HRM_Date_Employee_Response_Due__c = Date.today();
        parent.HRM_Date_MGMT_HR_Agree_to_Action__c = Date.today();
        parent.HRM_Date_of_Arbitration_Decision__c = Date.today();
        parent.HRM_Date_of_Final_Letter_to_Supervisor__c = Date.today();
        parent.HRM_Final_Arbitration_Decision__c = 'Settled';
        parent.HRM_Final_Decision_Letter_to_Emp_Union__c = Date.today();
        
        parent.HRM_Ethical_Conduct_Violation__c='No';     
          
        try {
            update parent;   
        }
        catch (DmlException e) {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION', e.getDmlStatusCode(0));
        }     
        
    }
    */
    /* commented
    @isTest
    static void updateParentChildCase() {
        Id cpoallusersGrpId = [Select Id from Group Where DeveloperName = 'HRM_Users'].Id;
        Id cposuperusersGrpId = [Select Id from Group Where DeveloperName = 'HRM_Superusers'].Id;
        
        List<GroupMember> allusersGrpmember = [Select GroupId, UserorGroupId from GroupMember 
                                                WHERE GroupId = :cposuperusersGrpId LIMIT 1];
        List<User> users = [SELECT Id FROM User WHERE IsActive = true AND Id = :allusersGrpmember[0].UserorGroupId LIMIT 1];
        
        Id oigCaseRecTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'HRM_OIG_Case' AND SObjectType = 'HR_Case__c'].Id;
        Id adverseCaseRecTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'HRM_Disciplinary_Case' AND SObjectType = 'HR_Case__c'].Id;
        
        Id cpoQueueId = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'HRM_Case_Queue'].Id;
        
        List<HR_Case__c> pcaseList = new List<HR_Case__c>();
        Set<Id> recordIds = new Set<Id>();
        List<Contact> contacts = [SELECT Id FROM Contact LIMIT 1];
        HR_Case__c parent = new HR_Case__c(RecordTypeId= oigCaseRecTypeId, HRM_OIG_Case_Number__c='Trig8d231$Test', 
                                   HRM_Office__c='C', Priority__c='Low', Status__c='Open', Private__c = false,
                                   Stage__c='With Intake Reviewer', HRM_Deciding_Official_RMO__c=contacts[0].Id,
                                   HRM_Office_of_Assigned_Specialist__c='C',
                                   HRM_Assigned_Specialist__c=users[0].Id, HRM_ROO_AO__c=users[0].Id);
        insert parent;
        
        HR_Case__c child = new HR_Case__c(RecordTypeId= adverseCaseRecTypeId, HRM_OIG_Case_Number__c='Trig8d232$Test', 
                                   HRM_Office__c='CH', Priority__c='Low', Status__c='Open', Private__c = false,
                                   Stage__c='With Intake Reviewer', HRM_Deciding_Official_RMO__c=contacts[0].Id,
                                   HRM_Office_of_Assigned_Specialist__c='C',
                                   HRM_Assigned_Specialist__c=users[0].Id);
        insert child;
        
        child.Parent_HR_Case_No__c=parent.Id;
        Test.startTest();
        update child;
        Test.stopTest();
        HR_Case__c parentExt = [SELECT Id, HRM_Office__c, HRM_OIG_Case_Number__c FROM HR_Case__c WHERE Id = :parent.Id];
        HR_Case__c childExt = [SELECT Id, HRM_Office__c, HRM_OIG_Case_Number__c FROM HR_Case__c WHERE Id = :child.Id];
          
        System.assertEquals(parentExt.HRM_Office__c, childExt.HRM_Office__c);
        
        System.assertEquals(parentExt.HRM_OIG_Case_Number__c, childExt.HRM_OIG_Case_Number__c);       
        
    }
    */
    
    @isTest
    static void insertParentChildCase() {
        Id cpoallusersGrpId = [Select Id from Group Where DeveloperName = 'HRM_Users'].Id;
        Id cposuperusersGrpId = [Select Id from Group Where DeveloperName = 'HRM_Superusers'].Id;
        
        List<GroupMember> allusersGrpmember = [Select GroupId, UserorGroupId from GroupMember 
                                                WHERE GroupId = :cposuperusersGrpId LIMIT 1];
        List<User> users = [SELECT Id FROM User WHERE IsActive = true AND Id = :allusersGrpmember[0].UserorGroupId LIMIT 1];
        
        Id oigCaseRecTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'HRM_OIG_Case' AND SObjectType = 'HR_Case__c'].Id;
        Id adverseCaseRecTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'HRM_Disciplinary_Case' AND SObjectType = 'HR_Case__c'].Id;
        
        Id cpoQueueId = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'HRM_Case_Queue'].Id;
        
        List<HR_Case__c> pcaseList = new List<HR_Case__c>();
        Set<Id> recordIds = new Set<Id>();
        // only selected the gsa recordtypes- version 1.2.
        List<Contact> contacts = [SELECT Id FROM Contact WHERE RecordType.Name='GSA' LIMIT 1];
        HR_Case__c parent = new HR_Case__c(RecordTypeId= oigCaseRecTypeId, HRM_OIG_Case_Number__c='Trig7d231$Test', 
                                   HRM_Office__c='C', Priority__c='Low', Status__c='Open', Private__c = false,
                                   Stage__c='With Intake Reviewer', HRM_Deciding_Official_RMO__c=contacts[0].Id,
                                   HRM_Office_of_Assigned_Specialist__c='C',
                                   HRM_Assigned_Specialist__c=users[0].Id, HRM_ROO_AO__c=users[0].Id);
        insert parent;
        
        HR_Case__c child = new HR_Case__c(RecordTypeId= adverseCaseRecTypeId, HRM_OIG_Case_Number__c='Trig7d232$Test', 
                                   HRM_Office__c='CH', Priority__c='Low', Status__c='Open', Private__c = false,
                                   Stage__c='With Intake Reviewer', HRM_Deciding_Official_RMO__c=contacts[0].Id,
                                   HRM_Office_of_Assigned_Specialist__c='C',
                                   HRM_Assigned_Specialist__c=users[0].Id, Parent_HR_Case_No__c=parent.Id);
        Test.startTest();
        insert child;
        Test.stopTest();
        HR_Case__c parentExt = [SELECT Id, HRM_Office__c, HRM_OIG_Case_Number__c FROM HR_Case__c WHERE Id = :parent.Id];
        HR_Case__c childExt = [SELECT Id, HRM_Office__c, HRM_OIG_Case_Number__c FROM HR_Case__c WHERE Id = :child.Id];
          
        System.assertEquals(parentExt.HRM_Office__c,childExt.HRM_Office__c);
        
        System.assertEquals(parentExt.HRM_OIG_Case_Number__c,childExt.HRM_OIG_Case_Number__c);       
        
    }
    
    @isTest
    static void updatePrivateClosed() {
        Id cpoallusersGrpId = [Select Id from Group Where DeveloperName = 'HRM_Users'].Id;
        Id cposuperusersGrpId = [Select Id from Group Where DeveloperName = 'HRM_Superusers'].Id;
        
        List<GroupMember> allusersGrpmember = [Select GroupId, UserorGroupId from GroupMember 
                                                WHERE GroupId = :cposuperusersGrpId LIMIT 1];
        List<User> users = [SELECT Id FROM User WHERE IsActive = true AND Id = :allusersGrpmember[0].UserorGroupId LIMIT 1];
        
        
        Id oigCaseRecTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'HRM_OIG_Case' AND SObjectType = 'HR_Case__c'].Id;
        Id adverseCaseRecTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'HRM_Disciplinary_Case' AND SObjectType = 'HR_Case__c'].Id;
        
        Id cpoQueueId = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'HRM_Case_Queue'].Id;
        
        List<HR_Case__c> pcaseList = new List<HR_Case__c>();
        Set<Id> recordIds = new Set<Id>();
        // only selected the gsa recordtypes- version 1.2.
        List<Contact> contacts = [SELECT Id FROM Contact WHERE RecordType.Name='GSA' LIMIT 1];
        for(Integer i=0; i<100; i++) {
            pcaseList.add(new HR_Case__c(RecordTypeId= adverseCaseRecTypeId, HRM_OIG_Case_Number__c='Trig66d231$Test', 
                                   HRM_Office__c='C', Priority__c='Low', Status__c='Open', Private__c = true,
                                   Stage__c='With Intake Reviewer', HRM_Deciding_Official_RMO__c=contacts[0].Id,
                                   HRM_Office_of_Assigned_Specialist__c='C',
                                   HRM_Assigned_Specialist__c=users[0].Id));
           }
        insert pcaseList;   
        for(HR_Case__c p: pcaseList) {
            recordIds.add(p.Id);
            p.Status__c = 'Closed';
            p.HRM_Date_Initial_Draft_to_MGMT__c = Date.today();
            p.HRM_Date_OGC_Returned_Draft__c = Date.today();
            p.HRM_Date_to_OGC_for_Concurrence__c = Date.today();
            p.HRM_Concurrence_Recd_from_MGMT__c = Date.today();
            p.HRM_Date_Employee_Response_Due__c = Date.today();
            p.HRM_Date_MGMT_HR_Agree_to_Action__c = Date.today();
            p.HRM_Date_of_Arbitration_Decision__c = Date.today();
            p.HRM_Date_of_Final_Letter_to_Supervisor__c = Date.today();
            //p.HRM_Final_Arbitration_Decision__c = 'Settled';
            p.HRM_Final_Decision_Letter_to_Emp_Union__c = Date.today();
            p.HRM_Ethical_Conduct_Violation__c='No';
            p.HRM_Bargaining_Unit__c='No';
        }
        Test.startTest();
        update pcaseList;
        Test.stopTest();
        List<HR_Case__Share> pcASshares = [SELECT Id FROM HR_Case__Share 
                                                WHERE ParentId IN :recordIds AND UserorGroupId =:users[0].Id 
                                                AND AccessLevel = 'Edit' AND RowCause = 'AS_Access__c'];
        System.assertEquals(0, pcASshares.size());        
    }
    
    @isTest
    static void updatePrivateReOpen() {
        Id cpoallusersGrpId = [Select Id from Group Where DeveloperName = 'HRM_Users'].Id;
        Id cposuperusersGrpId = [Select Id from Group Where DeveloperName = 'HRM_Superusers'].Id;
        
        List<GroupMember> allusersGrpmember = [Select GroupId, UserorGroupId from GroupMember 
                                                WHERE GroupId = :cposuperusersGrpId LIMIT 1];
        List<User> users = [SELECT Id FROM User WHERE IsActive = true AND Id = :allusersGrpmember[0].UserorGroupId LIMIT 1];
        
        Id oigCaseRecTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'HRM_OIG_Case' AND SObjectType = 'HR_Case__c'].Id;
        Id adverseCaseRecTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'HRM_Disciplinary_Case' AND SObjectType = 'HR_Case__c'].Id;
        
        Id cpoQueueId = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'HRM_Case_Queue'].Id;
        
        List<HR_Case__c> pcaseList = new List<HR_Case__c>();
        Set<Id> recordIds = new Set<Id>();
        // only selected the gsa recordtypes- version 1.2.
        List<Contact> contacts = [SELECT Id FROM Contact WHERE RecordType.Name='GSA' LIMIT 1];
        
        HR_Case__c parent = new HR_Case__c(RecordTypeId= oigCaseRecTypeId, HRM_OIG_Case_Number__c='Trig6d231$Test', 
                                   HRM_Office__c='C', Priority__c='Low', Status__c='Open', Private__c = true,
                                   Stage__c='With Intake Reviewer', HRM_Deciding_Official_RMO__c=contacts[0].Id,
                                   HRM_Office_of_Assigned_Specialist__c='C',
                                   HRM_Assigned_Specialist__c=users[0].Id, HRM_ROO_AO__c=users[0].Id);
        insert parent;
          
        parent.Stage__c = 'Assigned to Responsible Office Official';
        update parent;
        parent.Stage__c = 'Assigned to Action Officer';
        update parent;
        parent.Stage__c = 'Assigned to Assigned Specialist';
        parent.HRM_Office_of_Assigned_Specialist__c = 'C';
        update parent;
        parent.Stage__c = 'Ready for Action Officer to View';
        update parent;
        System.runAs(users[0]) {
            parent.Status__c = 'Closed'; 
            parent.HRM_Date_Initial_Draft_to_MGMT__c = Date.today();
            parent.HRM_Date_OGC_Returned_Draft__c = Date.today();
            parent.HRM_Date_to_OGC_for_Concurrence__c = Date.today();
            parent.HRM_Concurrence_Recd_from_MGMT__c = Date.today();
            parent.HRM_Date_Employee_Response_Due__c = Date.today();
            parent.HRM_Date_MGMT_HR_Agree_to_Action__c = Date.today();
            parent.HRM_Date_of_Arbitration_Decision__c = Date.today();
            parent.HRM_Date_of_Final_Letter_to_Supervisor__c = Date.today();
            //parent.HRM_Final_Arbitration_Decision__c = 'Settled';
            parent.HRM_Final_Decision_Letter_to_Emp_Union__c = Date.today();
            parent.HRM_Ethical_Conduct_Violation__c='No';
            parent.HRM_Assigned_Office_Code__c='A Ofc of the Administrator'; 
            parent.HRM_Assigned_Organization_Code__c='FAS'; 
            parent.HRM_Assigned_Point_of_Contact__c=contacts[0].Id;
            parent.HRM_Charge_Violation_Description__c='Violated';
            update parent; 
            recordIds.add(parent.Id);
            parent.Status__c = 'Open';
            update parent;
        }
        
        List<HR_Case__Share> pcASshares = [SELECT Id FROM HR_Case__Share 
                                                WHERE ParentId IN :recordIds AND UserorGroupId =:users[0].Id 
                                                AND AccessLevel = 'Edit' AND RowCause = 'AS_Access__c'];
        System.assertEquals(1, pcASshares.size());
        
        List<HR_Case__Share> pcAOshares = [SELECT Id FROM HR_Case__Share 
                                                WHERE ParentId IN :recordIds AND UserorGroupId =:users[0].Id 
                                                AND AccessLevel = 'Edit' AND RowCause = 'ROO_AO_Access__c'];
        System.assertEquals(1, pcAOshares.size());        
    }
    
    @isTest
    static void updateMarkforDelete() {
        Id cpoallusersGrpId = [Select Id from Group Where DeveloperName = 'HRM_Users'].Id;
        Id cposuperusersGrpId = [Select Id from Group Where DeveloperName = 'HRM_Superusers'].Id;
        
        List<GroupMember> allusersGrpmember = [Select GroupId, UserorGroupId from GroupMember 
                                                WHERE GroupId = :cposuperusersGrpId LIMIT 1];
        List<User> users = [SELECT Id FROM User WHERE IsActive = true AND Id = :allusersGrpmember[0].UserorGroupId LIMIT 1];
        
        Id oigCaseRecTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'HRM_OIG_Case' AND SObjectType = 'HR_Case__c'].Id;
        Id adverseCaseRecTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'HRM_Disciplinary_Case' AND SObjectType = 'HR_Case__c'].Id;
        
        Id cpoQueueId = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'HRM_Case_Queue'].Id;
        
        List<HR_Case__c> pcaseList = new List<HR_Case__c>();
        Set<Id> recordIds = new Set<Id>();
        // only selected the gsa recordtypes- version 1.2.
        List<Contact> contacts = [SELECT Id FROM Contact WHERE RecordType.Name='GSA' LIMIT 1];
        for(Integer i=0; i<2; i++) {
            pcaseList.add(new HR_Case__c(RecordTypeId= oigCaseRecTypeId, HRM_OIG_Case_Number__c='Trig44d231$Test', 
                                   HRM_Office__c='C', Priority__c='Low', Status__c='Open',
                                   Stage__c='With Intake Reviewer', HRM_Deciding_Official_RMO__c=contacts[0].Id,
                                   HRM_Office_of_Assigned_Specialist__c='C',
                                   HRM_Assigned_Specialist__c=users[0].Id, HRM_ROO_AO__c=users[0].Id));
            pcaseList.add(new HR_Case__c(RecordTypeId= oigCaseRecTypeId, HRM_OIG_Case_Number__c='Trig44d231$Test', 
                                   HRM_Office__c='C', Priority__c='Low', Status__c='Open',
                                   Stage__c='With Intake Reviewer', HRM_Deciding_Official_RMO__c=contacts[0].Id,
                                   HRM_Office_of_Assigned_Specialist__c='C', Marked_for_Deletion__c = true,
                                   HRM_Assigned_Specialist__c=users[0].Id, HRM_ROO_AO__c=users[0].Id));
        }
        insert pcaseList;   
        
        for(HR_Case__c p: pcaseList) {
            recordIds.add(p.Id);
            if(p.Marked_for_Deletion__c == false) 
                p.Marked_for_Deletion__c = true;                
            else
                p.Marked_for_Deletion__c = false;
        }
        Test.startTest();
        update pcaseList;
        Test.stopTest();
        List<HR_Case__Share> pcASshares = [SELECT Id FROM HR_Case__Share 
                                                WHERE ParentId IN :recordIds AND UserorGroupId =:users[0].Id 
                                                AND AccessLevel = 'Edit' AND RowCause = 'AS_Access__c'];
        System.assertEquals(2, pcASshares.size());
        
        List<HR_Case__Share> pcAOshares = [SELECT Id FROM HR_Case__Share 
                                                WHERE ParentId IN :recordIds AND UserorGroupId =:users[0].Id 
                                                AND AccessLevel = 'Edit' AND RowCause = 'ROO_AO_Access__c'];
        System.assertEquals(2, pcAOshares.size());
        
    }
    
    @isTest
    static void insertASAOShare() {
        Id cpoallusersGrpId = [Select Id from Group Where DeveloperName = 'HRM_Users'].Id;
        Id cposuperusersGrpId = [Select Id from Group Where DeveloperName = 'HRM_Superusers'].Id;
        
        List<GroupMember> allusersGrpmember = [Select GroupId, UserorGroupId from GroupMember 
                                                WHERE GroupId = :cposuperusersGrpId LIMIT 1];
        List<User> users = [SELECT Id FROM User WHERE IsActive = true AND Id = :allusersGrpmember[0].UserorGroupId LIMIT 1];
        
        Id oigCaseRecTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'HRM_OIG_Case' AND SObjectType = 'HR_Case__c'].Id;
        Id adverseCaseRecTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'HRM_Disciplinary_Case' AND SObjectType = 'HR_Case__c'].Id;
        
        Id cpoQueueId = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'HRM_Case_Queue'].Id;
        
        List<HR_Case__c> pcaseList = new List<HR_Case__c>();
        Set<Id> recordIds = new Set<Id>();
        // only selected the gsa recordtypes- version 1.2.
        List<Contact> contacts = [SELECT Id FROM Contact WHERE RecordType.Name='GSA' LIMIT 1];
        for(Integer i=0; i<100; i++) {
            pcaseList.add(new HR_Case__c(RecordTypeId= adverseCaseRecTypeId, HRM_OIG_Case_Number__c='Trig5d231$Test', 
                                   HRM_Office__c='C', Priority__c='Low', Status__c='Open', Private__c = false,
                                   Stage__c='With Intake Reviewer', HRM_Deciding_Official_RMO__c=contacts[0].Id,
                                   HRM_Office_of_Assigned_Specialist__c='C',
                                   HRM_Assigned_Specialist__c=users[0].Id));
           pcaseList.add(new HR_Case__c(RecordTypeId= oigCaseRecTypeId, HRM_OIG_Case_Number__c='Trig5d231$Test', 
                                   HRM_Office__c='C', Priority__c='Low', Status__c='Open', Private__c = true,
                                   Stage__c='With Intake Reviewer', HRM_Deciding_Official_RMO__c=contacts[0].Id,
                                   HRM_Office_of_Assigned_Specialist__c='C',
                                   HRM_Assigned_Specialist__c=users[0].Id, HRM_ROO_AO__c=users[0].Id));
        }
        Test.startTest();
        insert pcaseList;
        Test.stopTest();   
        for(HR_Case__c p: pcaseList) {
            recordIds.add(p.Id);
        }
        List<HR_Case__Share> pcASshares = [SELECT Id FROM HR_Case__Share 
                                                WHERE ParentId IN :recordIds AND UserorGroupId =:users[0].Id 
                                                AND AccessLevel = 'Edit' AND RowCause = 'AS_Access__c'];
        System.assertEquals(200, pcASshares.size());
        
        List<HR_Case__Share> pcAOshares = [SELECT Id FROM HR_Case__Share 
                                                WHERE ParentId IN :recordIds AND UserorGroupId =:users[0].Id 
                                                AND AccessLevel = 'Edit' AND RowCause = 'ROO_AO_Access__c'];
        System.assertEquals(100, pcAOshares.size());
        
    }    
    
    @isTest
    static void updateASAOShare() {
        Id cpoallusersGrpId = [Select Id from Group Where DeveloperName = 'HRM_Users'].Id;
        Id cposuperusersGrpId = [Select Id from Group Where DeveloperName = 'HRM_Superusers'].Id;
        
        List<GroupMember> allusersGrpmember = [Select GroupId, UserorGroupId from GroupMember 
                                                WHERE GroupId = :cposuperusersGrpId LIMIT 1];
        List<User> users = [SELECT Id FROM User WHERE IsActive = true AND Id = :allusersGrpmember[0].UserorGroupId LIMIT 1];
        
        Id oigCaseRecTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'HRM_OIG_Case' AND SObjectType = 'HR_Case__c'].Id;
        Id adverseCaseRecTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'HRM_Disciplinary_Case' AND SObjectType = 'HR_Case__c'].Id;
        
        Id cpoQueueId = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'HRM_Case_Queue'].Id;
        
        List<HR_Case__c> pcaseList = new List<HR_Case__c>();
        Set<Id> recordIds = new Set<Id>();
        // only selected the gsa recordtypes- version 1.2.
        List<Contact> contacts = [SELECT Id FROM Contact WHERE RecordType.Name='GSA' LIMIT 1];
        for(Integer i=0; i<200; i++) {
            pcaseList.add(new HR_Case__c(RecordTypeId= oigCaseRecTypeId, HRM_OIG_Case_Number__c='Trig4d231$Test', 
                                   HRM_Office__c='C', Priority__c='Low', Status__c='Open',
                                   Stage__c='With Intake Reviewer', HRM_Deciding_Official_RMO__c=contacts[0].Id,
                                   HRM_Office_of_Assigned_Specialist__c='C',
                                   HRM_Assigned_Specialist__c=null, HRM_ROO_AO__c=users[0].Id));
            pcaseList.add(new HR_Case__c(RecordTypeId= oigCaseRecTypeId, HRM_OIG_Case_Number__c='Trig4d231$Test', 
                                   HRM_Office__c='C', Priority__c='Low', Status__c='Open',
                                   Stage__c='With Intake Reviewer', HRM_Deciding_Official_RMO__c=contacts[0].Id,
                                   HRM_Office_of_Assigned_Specialist__c='C',
                                   HRM_Assigned_Specialist__c=users[0].Id, HRM_ROO_AO__c=null));
        }
        insert pcaseList;   
        
        for(HR_Case__c p: pcaseList) {
            recordIds.add(p.Id);
            if(p.HRM_Assigned_Specialist__c == null) 
                p.HRM_Assigned_Specialist__c = users[0].Id;                
            else
                p.HRM_Assigned_Specialist__c = null;
            if(p.HRM_ROO_AO__c == null)
                p.HRM_ROO_AO__c = users[0].Id;
            else
                p.HRM_ROO_AO__c = null;
        }
        Test.startTest();
        update pcaseList;
        Test.stopTest();
        List<HR_Case__Share> pcASshares = [SELECT Id FROM HR_Case__Share 
                                                WHERE ParentId IN :recordIds AND UserorGroupId =:users[0].Id 
                                                AND AccessLevel = 'Edit' AND RowCause = 'AS_Access__c'];
        System.assertEquals(200, pcASshares.size());
        
        List<HR_Case__Share> pcAOshares = [SELECT Id FROM HR_Case__Share 
                                                WHERE ParentId IN :recordIds AND UserorGroupId =:users[0].Id 
                                                AND AccessLevel = 'Edit' AND RowCause = 'ROO_AO_Access__c'];
        System.assertEquals(200, pcAOshares.size());
        
    }    
    
    @isTest
    static void updateDelASAOShare() {
        Id cpoallusersGrpId = [Select Id from Group Where DeveloperName = 'HRM_Users'].Id;
        Id cposuperusersGrpId = [Select Id from Group Where DeveloperName = 'HRM_Superusers'].Id;
        
        List<GroupMember> allusersGrpmember = [Select GroupId, UserorGroupId from GroupMember 
                                                WHERE GroupId = :cposuperusersGrpId LIMIT 1];
        List<User> users = [SELECT Id FROM User WHERE IsActive = true AND Id = :allusersGrpmember[0].UserorGroupId LIMIT 1];
        
        Id oigCaseRecTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'HRM_OIG_Case' AND SObjectType = 'HR_Case__c'].Id;
        Id adverseCaseRecTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'HRM_Disciplinary_Case' AND SObjectType = 'HR_Case__c'].Id;
        
        Id cpoQueueId = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'HRM_Case_Queue'].Id;
        
        List<HR_Case__c> pcaseList = new List<HR_Case__c>();
        Set<Id> recordIds = new Set<Id>();
        // only selected the gsa recordtypes- version 1.2.
        List<Contact> contacts = [SELECT Id FROM Contact WHERE RecordType.Name='GSA' LIMIT 1];
        for(Integer i=0; i<100; i++) {
            pcaseList.add(new HR_Case__c(RecordTypeId= oigCaseRecTypeId, HRM_OIG_Case_Number__c='Trig3d231$Test', 
                                   HRM_Office__c='C', Priority__c='Low', Status__c='Open',
                                   Stage__c='With Intake Reviewer', HRM_Deciding_Official_RMO__c=contacts[0].Id,
                                   HRM_Office_of_Assigned_Specialist__c='C',
                                   HRM_Assigned_Specialist__c=users[0].Id, HRM_ROO_AO__c=users[0].Id));
        }
        insert pcaseList;   
        
        for(HR_Case__c p: pcaseList) {
            recordIds.add(p.Id);
            p.HRM_Assigned_Specialist__c = null;
            p.HRM_ROO_AO__c = null;
        }
        Test.startTest();
        update pcaseList;
        Test.stopTest();
        List<HR_Case__Share> pcASshares = [SELECT Id FROM HR_Case__Share 
                                                WHERE ParentId IN :recordIds AND UserorGroupId =:users[0].Id 
                                                AND AccessLevel = 'Edit' AND RowCause = 'AS_Access__c'];
        System.assertEquals(0, pcASshares.size());
        
        List<HR_Case__Share> pcAOshares = [SELECT Id FROM HR_Case__Share 
                                                WHERE ParentId IN :recordIds AND UserorGroupId =:users[0].Id 
                                                AND AccessLevel = 'Edit' AND RowCause = 'ROO_AO_Access__c'];
        System.assertEquals(0, pcAOshares.size());
        
    }    

    @isTest
    static void insertBulk() {
        Id cpoallusersGrpId = [Select Id from Group Where DeveloperName = 'HRM_Users'].Id;
        Id cposuperusersGrpId = [Select Id from Group Where DeveloperName = 'HRM_Superusers'].Id;
        
        List<GroupMember> allusersGrpmember = [Select GroupId, UserorGroupId from GroupMember 
                                                WHERE GroupId = :cposuperusersGrpId LIMIT 1];
        List<User> users = [SELECT Id FROM User WHERE IsActive = true AND Id = :allusersGrpmember[0].UserorGroupId LIMIT 1];
        
        Id oigCaseRecTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'HRM_OIG_Case' AND SObjectType = 'HR_Case__c'].Id;
        Id adverseCaseRecTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'HRM_Disciplinary_Case' AND SObjectType = 'HR_Case__c'].Id;
        
        Id cpoQueueId = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'HRM_Case_Queue'].Id;
        
        List<HR_Case__c> pcaseList = new List<HR_Case__c>();
        Set<Id> recordIds = new Set<Id>();
        // only selected the gsa recordtypes- version 1.2.
        List<Contact> contacts = [SELECT Id FROM Contact WHERE RecordType.Name='GSA' LIMIT 1];
        for(Integer i=0; i<200; i++) {
            pcaseList.add(new HR_Case__c(RecordTypeId= oigcaseRecTypeId, HRM_OIG_Case_Number__c='Trig2d231$Test', 
                                   HRM_Office__c='C', Priority__c='Low', Status__c='Open',
                                   Stage__c='With Intake Reviewer', HRM_Deciding_Official_RMO__c=contacts[0].Id,
                                   HRM_Office_of_Assigned_Specialist__c='C',
                                   HRM_Assigned_Specialist__c=users[0].Id, HRM_ROO_AO__c=users[0].Id));
        }
        Test.startTest();
        insert pcaseList;
        Test.stopTest();   
        for(HR_Case__c p: pcaseList) {
            recordIds.add(p.Id);
        }
        
        List<HR_Case__Share> pcASshares = [SELECT Id FROM HR_Case__Share 
                                                WHERE ParentId IN :recordIds AND UserorGroupId =:users[0].Id 
                                                AND AccessLevel = 'Edit' AND RowCause = 'AS_Access__c'];
        System.assertEquals(200, pcASshares.size());
        
        List<HR_Case__Share> pcAOshares = [SELECT Id FROM HR_Case__Share 
                                                WHERE ParentId IN :recordIds AND UserorGroupId =:users[0].Id 
                                                AND AccessLevel = 'Edit' AND RowCause = 'ROO_AO_Access__c'];
        System.assertEquals(200, pcAOshares.size());
    }
    
    @isTest
    static void insertValidation() {
        Id cpoallusersGrpId = [Select Id from Group Where DeveloperName = 'HRM_Users'].Id;
        Id cposuperusersGrpId = [Select Id from Group Where DeveloperName = 'HRM_Superusers'].Id;
        
        List<GroupMember> allusersGrpmember = [Select GroupId, UserorGroupId from GroupMember 
                                                WHERE GroupId = :cposuperusersGrpId LIMIT 2];
        Set<Id> userIds = new Set<Id>();
        for(GroupMember g: allusersGrpmember) {
            userIds.add(g.UserorGroupId);
        }
            
        List<User> users = [SELECT Id FROM User WHERE IsActive = true AND Id NOT IN :userIds LIMIT 1];
        
        Id oigCaseRecTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'HRM_OIG_Case' AND SObjectType = 'HR_Case__c'].Id;
        Id adverseCaseRecTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'HRM_Disciplinary_Case' AND SObjectType = 'HR_Case__c'].Id;
        
        Id cpoQueueId = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'HRM_Case_Queue'].Id;
        
        List<HR_Case__c> pcaseList = new List<HR_Case__c>();
        List<Id> recordIds = new List<Id>();
        // only selected the gsa recordtypes- version 1.2.
        List<Contact> contacts = [SELECT Id FROM Contact WHERE RecordType.Name='GSA' LIMIT 1];
        
        pcaseList.add(new HR_Case__c(RecordTypeId= oigcaseRecTypeId, HRM_OIG_Case_Number__c='Trig1d231$Test', 
                                   HRM_Office__c='C',Priority__c='Low',Status__c='Open',
                                   Stage__c='With Intake Reviewer',HRM_Deciding_Official_RMO__c=contacts[0].Id,
                                   HRM_Office_of_Assigned_Specialist__c='C',
                                   HRM_Assigned_Specialist__c=users[0].Id, HRM_ROO_AO__c=users[0].Id));
        pcaseList.add(new HR_Case__c(RecordTypeId= oigcaseRecTypeId, HRM_OIG_Case_Number__c='Trig1d232$Test', 
                                   HRM_Office__c='C', Priority__c='Low', Status__c='Closed',
                                   Stage__c='With Intake Reviewer', HRM_Deciding_Official_RMO__c=contacts[0].Id,
                                   HRM_Office_of_Assigned_Specialist__c='C',
                                   HRM_Assigned_Specialist__c=users[0].Id, HRM_ROO_AO__c=users[0].Id));
        pcaseList.add(new HR_Case__c(RecordTypeId= oigcaseRecTypeId, HRM_OIG_Case_Number__c='Trig1d232$Test', 
                                   HRM_Office__c='C', Priority__c='Low', Status__c='Closed',
                                   Stage__c='With Intake Reviewer', HRM_Deciding_Official_RMO__c=contacts[0].Id,
                                   HRM_Assigned_Specialist__c=users[0].Id, HRM_ROO_AO__c=users[0].Id));
        pcaseList.add(new HR_Case__c(RecordTypeId= adversecaseRecTypeId, HRM_OIG_Case_Number__c='Trig1d233$Test', 
                                   HRM_Office__c='C', Priority__c='Low', Status__c='Open',
                                   Stage__c='With Intake Reviewer', HRM_Deciding_Official_RMO__c=contacts[0].Id));
        try {
            insert pcaseList;   
        }
        catch (DmlException e) {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION', e.getDmlStatusCode(0));
        }
    }
    
    @isTest
    static void updateValidation() {
        Id cpoallusersGrpId = [Select Id from Group Where DeveloperName = 'HRM_Users'].Id;
        Id cposuperusersGrpId = [Select Id from Group Where DeveloperName = 'HRM_Superusers'].Id;
        
        List<GroupMember> allusersGrpmember = [Select GroupId, UserorGroupId from GroupMember 
                                                WHERE GroupId = :cposuperusersGrpId LIMIT 2];
        Set<Id> userIds = new Set<Id>();
        for(GroupMember g: allusersGrpmember) {
            userIds.add(g.UserorGroupId);
        }
        List<User> validUsers = [SELECT Id FROM User WHERE IsActive = true AND Id IN :userIds LIMIT 2];
        List<User> users = [SELECT Id FROM User WHERE IsActive = true AND Id NOT IN :userIds LIMIT 1];
        
        Id oigCaseRecTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'HRM_OIG_Case' AND SObjectType = 'HR_Case__c'].Id;
        Id adverseCaseRecTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'HRM_Disciplinary_Case' AND SObjectType = 'HR_Case__c'].Id;
        
        Id cpoQueueId = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'HRM_Case_Queue'].Id;
        
        List<HR_Case__c> pcaseList = new List<HR_Case__c>();
        List<Id> recordIds = new List<Id>();
        // only selected the gsa recordtypes- version 1.2.
        List<Contact> contacts = [SELECT Id FROM Contact WHERE RecordType.Name='GSA' LIMIT 1];
        
        pcaseList.add(new HR_Case__c(RecordTypeId= oigcaseRecTypeId, HRM_OIG_Case_Number__c='Trig0d231$Test', 
                                   HRM_Office__c='C',Priority__c='Low',Status__c='Open',
                                   Stage__c='With Intake Reviewer',HRM_Deciding_Official_RMO__c=contacts[0].Id,
                                   HRM_Office_of_Assigned_Specialist__c='C',
                                   HRM_Assigned_Specialist__c=validUsers[0].Id, HRM_ROO_AO__c=validUsers[0].Id));
        pcaseList.add(new HR_Case__c(RecordTypeId= oigcaseRecTypeId, HRM_OIG_Case_Number__c='Trig0d231$Test', 
                                   HRM_Office__c='C',Priority__c='Low',Status__c='Open',
                                   Stage__c='With Intake Reviewer',HRM_Deciding_Official_RMO__c=contacts[0].Id,
                                   HRM_ROO_AO__c=validUsers[0].Id));
        
        pcaseList.add(new HR_Case__c(RecordTypeId= adversecaseRecTypeId, HRM_OIG_Case_Number__c='Trig0232$Test', 
                                   HRM_Office__c='C', Priority__c='Low', Status__c='Closed',
                                   Stage__c='With Intake Reviewer', HRM_Deciding_Official_RMO__c=contacts[0].Id,
                                   HRM_Date_Initial_Draft_to_MGMT__c=Date.today(),
                                   HRM_Date_OGC_Returned_Draft__c = Date.today(),
                                   HRM_Date_to_OGC_for_Concurrence__c = Date.today(),
                                   HRM_Concurrence_Recd_from_MGMT__c = Date.today(),
                                   HRM_Date_Employee_Response_Due__c = Date.today(),
                                   HRM_Date_MGMT_HR_Agree_to_Action__c = Date.today(),
                                   HRM_Date_of_Arbitration_Decision__c = Date.today(),
                                   HRM_Date_of_Final_Letter_to_Supervisor__c = Date.today(),
                                   //HRM_Final_Arbitration_Decision__c = 'Settled',
                                   HRM_Final_Decision_Letter_to_Emp_Union__c = Date.today(),
                                   HRM_Ethical_Conduct_Violation__c='No',
                                   HRM_Office_of_Assigned_Specialist__c='C',
                                   HRM_Bargaining_Unit__c='No',
                                   HRM_Assigned_Specialist__c=validUsers[0].Id));
        /*
        pcaseList.add(new HR_Case__c(RecordTypeId= adversecaseRecTypeId, HRM_OIG_Case_Number__c='Trig0d233$Test', 
                                   HRM_Office__c='C', Priority__c='Low', Status__c='Open',
                                   Stage__c='With Intake Reviwer', HRM_Deciding_Official_RMO__c=contacts[0].Id));
        */
        insert pcaseList;
        for(HR_Case__c pc: pcaseList) {
            if(pc.Status__c == 'Closed') {
                pc.HRM_Assigned_Specialist__c = users[0].Id;
                pc.Status__c ='Open';
            }
            if(pc.Status__c == 'Open') {    
                pc.HRM_Assigned_Specialist__c = users[0].Id;
                pc.HRM_ROO_AO__c = users[0].Id;
                pc.Status__C = 'Closed';
            }
            if(pc.HRM_Assigned_Specialist__c == null) {    
                pc.HRM_Assigned_Specialist__c = validUsers[0].Id;
            }    
        }    
        try {
            update pcaseList;   
        }
        catch (DmlException e) {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION', e.getDmlStatusCode(0));
        }
    }

    
}