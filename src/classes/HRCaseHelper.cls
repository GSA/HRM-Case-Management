/*-------------------------------------------------------------------------------------------------*
  Apex class 
  Helper class for HR_Case__c object apex trigger
 *-------------------------------------------------------------------------------------------------*
  Author           | Date        | Version | Description
 *-------------------------------------------------------------------------------------------------*
  Rajakumar          12/05/2013    1.0       Initial version.
  Rajakumar          02/14/2014    1.1       Revised after new requirements.
 *-------------------------------------------------------------------------------------------------*
 
 *-------------------------------------------------------------------------------------------------*/
public class HRCaseHelper {
    
    public static void onAfterInsert(List<HR_Case__c> triggerNew) {
        HR_Case__Share asShr, aoShr;
        List<HR_Case__Share> pcShrs = new List<HR_Case__Share>(); 
        Id oigCaseRecTypeId;
        oigCaseRecTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'HRM_OIG_Case' AND SObjectType = 'HR_Case__c'].Id;
        
        for(HR_Case__c pc: triggerNew) {
            if((pc.Private__c != true) && (pc.Marked_for_Deletion__c != true)) {
                if( pc.HRM_Assigned_Specialist__c != null ) {
                    asShr = new HR_Case__Share();
                    asShr.ParentId = pc.Id;
                    asShr.UserorGroupId = pc.HRM_Assigned_Specialist__c;
                    asShr.AccessLevel = 'Edit';
                    asShr.RowCause = Schema.HR_Case__Share.RowCause.AS_Access__c;
                    pcShrs.add(asShr);
                }
                if( pc.HRM_ROO_AO__c != null ) {
                    aoShr = new HR_Case__Share();
                    aoShr.ParentId = pc.Id;
                    aoShr.UserorGroupId = pc.HRM_ROO_AO__c;
                    aoShr.AccessLevel = 'Edit';
                    aoShr.RowCause = Schema.HR_Case__Share.RowCause.ROO_AO_Access__c;
                    pcShrs.add(aoShr);
                }
            }
            if((pc.Private__c == true) && (pc.Marked_for_Deletion__c != true)) {
                if( pc.HRM_Assigned_Specialist__c != null && pc.Status__c != 'Closed' && 
                    pc.Status__c != 'Closed - In Appeal' ) {
                    asShr = new HR_Case__Share();
                    asShr.ParentId = pc.Id;
                    asShr.UserorGroupId = pc.HRM_Assigned_Specialist__c;
                    asShr.AccessLevel = 'Edit';
                    asShr.RowCause = Schema.HR_Case__Share.RowCause.AS_Access__c;
                    pcShrs.add(asShr);
                }
                if( pc.HRM_ROO_AO__c != null && pc.Status__c != 'Closed' && pc.Status__c != 'Closed - In Appeal' ) {
                    aoShr = new HR_Case__Share();
                    aoShr.ParentId = pc.Id;
                    aoShr.UserorGroupId = pc.HRM_ROO_AO__c;
                    aoShr.AccessLevel = 'Edit';
                    aoShr.RowCause = Schema.HR_Case__Share.RowCause.ROO_AO_Access__c;
                    pcShrs.add(aoShr);
                }
            }
        }
        
        try {
            insert pcShrs;
        }
        
        catch(DMLException e) {
            System.debug(LoggingLevel.INFO,'Error while inserting the HRM apex sharing entry for AS/AO/ROO :' +e.getMessage());    
        }            
                 
    }
    
    public static void onAfterUpdate(List<HR_Case__c> triggerNew, Map<Id, HR_Case__c> triggerOldMap, Map<Id, HR_Case__c> triggerNewMap) {
        HR_Case__Share asShr, aoShr;
        List<HR_Case__Share> pcShrs = new List<HR_Case__Share>();
        List<HR_Case__Share> oldASShrs = new List<HR_Case__Share>(); 
        List<HR_Case__Share> oldAOShrs = new List<HR_Case__Share>();
        Id oigCaseRecTypeId;
        Boolean privateClosed = false;
        oigCaseRecTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'HRM_OIG_Case' AND SObjectType = 'HR_Case__c'].Id;
        Set<Id> oldrecASIds = new Set<Id>();
        Set<Id> oldrecAOIds = new Set<Id>();
        
        for(HR_Case__c pc: triggerNew) {
            privateClosed = false;
            // case is marked for deletion
            if( (pc.Marked_for_Deletion__c == true) && (triggerOldMap.get(pc.Id).Marked_for_Deletion__c == false) ) {
                if(pc.HRM_Assigned_Specialist__c != null) 
                    oldrecASIds.add(pc.Id);
                if(pc.HRM_ROO_AO__c != null)
                    oldrecAOIds.add(pc.Id);
            }
            
            // case is unmarked for deletion
            if( (pc.Marked_for_Deletion__c == false) && (triggerOldMap.get(pc.Id).Marked_for_Deletion__c == true) ) {
                if(pc.HRM_Assigned_Specialist__c != null) {
                    asShr = new HR_Case__Share();
                    asShr.ParentId = pc.Id;
                    asShr.UserorGroupId = pc.HRM_Assigned_Specialist__c;
                    asShr.AccessLevel = 'Edit';
                    asShr.RowCause = Schema.HR_Case__Share.RowCause.AS_Access__c;
                    pcShrs.add(asShr);
                }    
                if(pc.HRM_ROO_AO__c != null) {
                    aoShr = new HR_Case__Share();
                    aoShr.ParentId = pc.Id;
                    aoShr.UserorGroupId = pc.HRM_ROO_AO__c;
                    aoShr.AccessLevel = 'Edit';
                    aoShr.RowCause = Schema.HR_Case__Share.RowCause.ROO_AO_Access__c;
                    pcShrs.add(aoShr);
                }
            }
            
            // private cases status change from 'Open' to 'Closed' or 'Closed - In Appeal'
            if( (pc.Private__c == true) && (pc.Marked_for_Deletion__c != true) &&
                (pc.Status__c != triggerOldMap.get(pc.Id).Status__c) && 
                (pc.Status__c == 'Closed' || pc.Status__c == 'Closed - In Appeal') ) {
                privateClosed = true; 
                if(pc.HRM_Assigned_Specialist__c != null || triggerOldMap.get(pc.Id).HRM_Assigned_Specialist__c != null) 
                    oldrecASIds.add(pc.Id);
                if(pc.HRM_ROO_AO__c != null || triggerOldMap.get(pc.Id).HRM_ROO_AO__c != null) 
                    oldrecAOIds.add(pc.Id);           
            }
            
            // private case status is changed from 'closed' to 'open'
            if( (pc.Private__c == true) && (pc.Marked_for_Deletion__c != true) &&
                (pc.Status__c != triggerOldMap.get(pc.Id).Status__c) && 
                (pc.Status__c == 'Open') ) { 
                if(pc.HRM_Assigned_Specialist__c != null) {
                    asShr = new HR_Case__Share();
                    asShr.ParentId = pc.Id;
                    asShr.UserorGroupId = pc.HRM_Assigned_Specialist__c;
                    asShr.AccessLevel = 'Edit';
                    asShr.RowCause = Schema.HR_Case__Share.RowCause.AS_Access__c;
                    pcShrs.add(asShr);
                }    
                if(pc.HRM_ROO_AO__c != null) {
                    aoShr = new HR_Case__Share();
                    aoShr.ParentId = pc.Id;
                    aoShr.UserorGroupId = pc.HRM_ROO_AO__c;
                    aoShr.AccessLevel = 'Edit';
                    aoShr.RowCause = Schema.HR_Case__Share.RowCause.ROO_AO_Access__c;
                    pcShrs.add(aoShr);
                }
            }    
            
            // cases AS/AO/ROO field update and respective record sharing.
            if( (privateClosed == false) && (pc.Marked_for_Deletion__c != true) ) {
                if( pc.HRM_Assigned_Specialist__c != null && 
                    pc.HRM_Assigned_Specialist__c != triggerOldMap.get(pc.Id).HRM_Assigned_Specialist__c ) {
                    asShr = new HR_Case__Share();
                    asShr.ParentId = pc.Id;
                    asShr.UserorGroupId = pc.HRM_Assigned_Specialist__c;
                    asShr.AccessLevel = 'Edit';
                    asShr.RowCause = Schema.HR_Case__Share.RowCause.AS_Access__c;
                    pcShrs.add(asShr);                
                }
                if( (pc.HRM_Assigned_Specialist__c != triggerOldMap.get(pc.Id).HRM_Assigned_Specialist__c) &&
                    (triggerOldMap.get(pc.Id).HRM_Assigned_Specialist__c != null) ) {
                        oldrecASIds.add(pc.Id);
                }        
                if( pc.HRM_ROO_AO__c != null && 
                    pc.HRM_ROO_AO__c != triggerOldMap.get(pc.Id).HRM_ROO_AO__c ) {
                    aoShr = new HR_Case__Share();
                    aoShr.ParentId = pc.Id;
                    aoShr.UserorGroupId = pc.HRM_ROO_AO__c;
                    aoShr.AccessLevel = 'Edit';
                    aoShr.RowCause = Schema.HR_Case__Share.RowCause.ROO_AO_Access__c;
                    pcShrs.add(aoShr);
                }
                if( (pc.HRM_ROO_AO__c != triggerOldMap.get(pc.Id).HRM_ROO_AO__c) && 
                    (triggerOldMap.get(pc.Id).HRM_ROO_AO__c != null) ) {
                    oldrecAOIds.add(pc.Id); 
                }               
            }
        }
        
        if(!oldrecASIds.isEmpty()) {
            oldASShrs = [SELECT Id FROM HR_Case__Share WHERE RowCause = 'AS_Access__c' AND ParentId IN :oldrecASIds]; 
        }
        
        if(!oldrecAOIds.isEmpty()) {
            oldAOShrs = [SELECT Id FROM HR_Case__Share WHERE RowCause = 'ROO_AO_Access__c' AND ParentId IN :oldrecAOIds]; 
        }        
        
        // deleting the old AS apex record sharing entries
        try {
            delete oldASShrs;
        }
        catch(DMLException e) {
            System.debug(LoggingLevel.INFO,'Error while deleting the HRM apex sharing entry for AS :' +e.getMessage());    
        }
        
        // deleting the old AO apex record sharing entries
        try {
            delete oldAOShrs;
        }
        catch(DMLException e) {
            System.debug(LoggingLevel.INFO,'Error while deleting the HRM apex sharing entry for AO/ROO :' +e.getMessage());    
        }        
        
        // inserting the new AS/AO/ROO apex record sharing entries
        try {
            insert pcShrs;
        }        
        catch(DMLException e) {
            System.debug(LoggingLevel.INFO,'Error while inserting the HRM apex sharing entry for AS/AO/ROO :' +e.getMessage());    
        }            
        
    }
    
    public static void onAfterDelete(List<HR_Case__c> triggerOld) {
        List<HR_Case__Share> oldASShrs = new List<HR_Case__Share>(); 
        List<HR_Case__Share> oldAOShrs = new List<HR_Case__Share>();
        Set<Id> oldrecASIds = new Set<Id>();
        Set<Id> oldrecAOIds = new Set<Id>();
        
        for(HR_Case__c pc: triggerOld) {
            if( pc.HRM_Assigned_Specialist__c != null ) {
                oldrecASIds.add(pc.Id);
            }        
            if( pc.HRM_ROO_AO__c != null )  {
                oldrecAOIds.add(pc.Id); 
            }               
        }
        
        if(!oldrecASIds.isEmpty()) {
            oldASShrs = [SELECT Id FROM HR_Case__Share WHERE RowCause = 'AS_Access__c' AND ParentId IN :oldrecASIds]; 
        }
        
        if(!oldrecAOIds.isEmpty()) {
            oldAOShrs = [SELECT Id FROM HR_Case__Share WHERE RowCause = 'ROO_AO_Access__c' AND ParentId IN :oldrecAOIds]; 
        }        
        
        // deleting the old AS apex record sharing entries
        try {
            delete oldASShrs;
        }
        catch(DMLException e) {
            System.debug(LoggingLevel.INFO,'Error while deleting the HRM apex sharing entry for AS :' +e.getMessage());    
        }
        
        // deleting the old AO apex record sharing entries
        try {
            delete oldAOShrs;
        }
        catch(DMLException e) {
            System.debug(LoggingLevel.INFO,'Error while deleting the HRM apex sharing entry for AO/ROO :' +e.getMessage());    
        }                 
        
    }
        
    public static void onBeforeUpdate(List<HR_Case__c> triggerNew, Map<Id, HR_Case__c> triggerOldMap) {
        //validations
        Id usrGrpId, superUsrGrpId, raUsrGrpId, oigCaseRecTypeId, raCaseRecTypeId; 
        List<GroupMember> usrlist = new List<GroupMember>();
        List<GroupMember> rausrList = new List<GroupMember>();
        List<RecordType> rectypeList = new List<RecordType>();
        List<Group> groupsList = new List<Group>();
        Set<Id> userIds = new Set<Id>();
        Set<Id> oigrecIds = new Set<Id>();
        Set<Id> rarecIds = new Set<Id>();
        Set<Id> parentCaseIds = new Set<Id>();
        List<GroupMember> grpuserslist = new List<GroupMember>();
        Map<Id, Id> grpuserMap = new Map<Id, Id>();
        
        groupsList = [SELECT Id, DeveloperName FROM Group WHERE DeveloperName IN ('HRM_Users','HRM_Superusers','HRM_RAS_Users')];
        for(Group g: groupsList) {
            //if(g.DeveloperName == 'HRM_Users')
            //    usrGrpId = g.Id;
            if(g.DeveloperName == 'HRM_Superusers')
                superusrGrpId = g.Id;
            if(g.DeveloperName == 'HRM_RAS_Users')
                raUsrGrpId = g.Id;
        } 
        
        rectypeList = [SELECT Id, DeveloperName FROM RecordType WHERE SObjectType = 'HR_Case__c'  
                          AND DeveloperName IN ('HRM_OIG_Case', 'HRM_Reasonable_Accommodation_RA_Case')];
        for(RecordType rt: recTypeList) {
            if(rt.DeveloperName == 'HRM_OIG_Case')
                oigCaseRecTypeId = rt.Id; 
            if(rt.DeveloperName == 'HRM_Reasonable_Accommodation_RA_Case')  
                raCaseRecTypeId = rt.Id;
        }
        
        for(HR_Case__c pc: triggerNew) {
            if( (pc.HRM_Assigned_Specialist__c != null) && (pc.HRM_Assigned_Specialist__c != triggerOldMap.get(pc.Id).HRM_Assigned_Specialist__c) ) { 
                userIds.add(pc.HRM_Assigned_Specialist__c);                
            }
            if( (pc.HRM_ROO_AO__c != null) && (pc.HRM_ROO_AO__c != triggerOldMap.get(pc.Id).HRM_ROO_AO__c) ) { 
                userIds.add(pc.HRM_ROO_AO__c);                
            }
            /* Commneted after DEMO# 1
            // for validating the parent cases closure after child records closure
            if( (pc.RecordTypeId == oigCaseRecTypeId) && (pc.Status__c == 'Closed' || pc.Status__c == 'Closed - In Appeal') && 
                (triggerOldMap.get(pc.Id).Status__c == 'Open')) {
                oigrecIds.add(pc.Id);
            }
            */
            /* commented
            //for child cases to auto populate OIG Case number and other fields
            if(pc.Parent_HR_Case_No__c != null) {
                parentCaseIds.add(pc.Parent_HR_Case_No__c);
            } 
            */   
                
        }
        Map<Id, Group> grpMap = new Map<Id, Group>([Select Id from Group Where DeveloperName Like 'HRM_%']);
        
        /* commented
        Map<Id, HR_Case__c> parentCasesMap = new Map<Id, HR_Case__c>([
                    SELECT Id, HRM_Office__c, HRM_OIG_Case_Number__c FROM HR_Case__c WHERE Id IN :parentCaseIds]);
        */
                
        usrlist = [SELECT GroupId, UserorGroupId FROM GroupMember WHERE GroupId = :superUsrGrpId AND UserorGroupId =:UserInfo.getUserId()];
        rausrList = [SELECT GroupId, UserorGroupId FROM GroupMember WHERE GroupId = :raUsrGrpId AND UserorGroupId =:UserInfo.getUserId()];
        
        grpuserslist = [SELECT UserorGroupId, GroupId FROM GroupMember WHERE GroupId IN :grpMap.keySet() AND UserorGroupId IN :userIds];
        
        for(GroupMember g : grpuserslist) {
            grpuserMap.put(g.UserorGroupId, g.GroupId);
        }
        /* Commented after DEMO # 1        
        Map<Id, HR_Case__c> oigcaseMap = 
                new Map<Id, HR_Case__c>([SELECT Id, Name, (SELECT Id FROM CPO_Parent_OIG_Personnel_Case_Number__r 
                                                WHERE Status__c !='Closed' AND Marked_for_Deletion__c = false) 
                                                FROM HR_Case__c WHERE Id IN :oigrecIds]);
        */
        for(HR_Case__c pc: triggerNew) {
            // validate that AS is the member of HRM All Users group
            if( (pc.HRM_Assigned_Specialist__c != null) && (pc.HRM_Assigned_Specialist__c != triggerOldMap.get(pc.Id).HRM_Assigned_Specialist__c) 
                 && (!grpusermap.containsKey(pc.HRM_Assigned_Specialist__c)) ) {
                pc.addError('Assigned Specialist is not a HRM group member, please select the active HRM group member');   
            }
            // validate that ROO/AO is the member of HRM All Users group
            if( (pc.HRM_ROO_AO__c != null) && (pc.HRM_ROO_AO__c != triggerOldMap.get(pc.Id).HRM_ROO_AO__c) && (!grpusermap.containsKey(pc.HRM_ROO_AO__c)) ) {
                pc.addError('ROO/AO is not a HRM group member, please select the active HRM group member');   
            }
            // validate that super user can only reopen the 'closed' or 'closed-in appeal' case
            if( (usrlist.isEmpty()) && (pc.Status__c != triggerOldMap.get(pc.Id).Status__c) && (pc.Status__c == 'Open') &&  
                ((triggerOldMap.get(pc.Id).Status__c == 'Closed') || (triggerOldMap.get(pc.Id).Status__c == 'Closed - In Appeal')) ) {
                pc.addError('Sorry, you do not have permissions to Re-open the Closed Case. Please contact your Super User.');
            }
            // validate that super user or RAS group member can only change the status to 'closed' or 'closed-in appeal'
            if( (pc.RecordTypeId == raCaseRecTypeId) && (usrlist.isEmpty()) && (rausrList.isEmpty()) &&
                (pc.Status__c != triggerOldMap.get(pc.Id).Status__c) && 
                (pc.Status__c == 'Closed' || pc.Status__c == 'Closed - In Appeal') ) {  
                // && (triggerOldMap.get(pc.Id).Status__c == 'Open') ) {
                pc.addError('Sorry, you do not have permissions to close or appeal this RA Case. Please contact your Super User/Reasonable Accommodations Specialist.');
            }            
            // validate that HRM OIG Case should be closed by ROO/AO
            if( (pc.RecordTypeId == oigCaseRecTypeId) && (pc.Status__c == 'Closed') && (pc.Status__c != triggerOldMap.get(pc.Id).Status__c) && 
                (pc.HRM_ROO_AO__c != UserInfo.getUserId()) ) {
                pc.addError('Sorry, you do not have permissions to Close this OIG Case. Please contact ROO/AO to close this OIG case');
            }
            /* Commented after DEMO# 1
            // validate that HRM OIG parent case shouldn't be closed when child cases are in Open status
            if( (pc.RecordTypeId == oigCaseRecTypeId) && (pc.Status__c == 'Closed' || pc.Status__c == 'Closed - In Appeal') && 
                (triggerOldMap.get(pc.Id).Status__c == 'Open')) {
                if(oigcaseMap.get(pc.Id).CPO_Parent_OIG_Personnel_Case_Number__r.size() > 0)
                    pc.addError('Please do not close the parent OIG Case when child cases are Open');
            }
            */
            /* commented
            // While updating a child case record, need to auto-populate the OIG Case Number and HRM Office fields.
            if( (pc.Parent_HR_Case_No__c != null) && (parentCasesMap.containsKey(pc.Parent_HR_Case_No__c)) ) {
                pc.HRM_Office__c = parentCasesMap.get(pc.Parent_HR_Case_No__c).HRM_Office__c;
                pc.HRM_OIG_Case_Number__c = parentCasesMap.get(pc.Parent_HR_Case_No__c).HRM_OIG_Case_Number__c;
            }
            */
             // validate that 'HR Office of AS' is selected when AS field value is filled in. 
            if( (pc.HRM_Assigned_Specialist__c != null) && (triggerOldMap.get(pc.Id).HRM_Assigned_Specialist__c == null) &&
                (pc.HRM_Office_of_Assigned_Specialist__c == null) ) {
                pc.addError('Please select the HR Office of Assigned Specialist');
            }       
        }    
    }
    
    public static void onBeforeInsert(List<HR_Case__c> triggerNew) {
        // validations
        Id usrGrpId, oigCaseRecTypeId, cpoQueueId; 
        List<GroupMember> usrlist = new List<GroupMember>();
        Set<Id> userIds = new Set<Id>();
        Set<Id> parentCaseIds = new Set<Id>();
        List<GroupMember> grpuserslist = new List<GroupMember>();
        Map<Id, Id> grpuserMap = new Map<Id, Id>();
        
        //usrGrpId = [SELECT Id FROM Group WHERE DeveloperName = 'HRM_Users'].Id;
        oigCaseRecTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'HRM_OIG_Case' AND SObjectType = 'HR_Case__c'].Id;
        cpoQueueId = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'HRM_Case_Queue'].Id;
                    
        for(HR_Case__c pc: triggerNew) {
            if(pc.HRM_Assigned_Specialist__c != null) { 
                userIds.add(pc.HRM_Assigned_Specialist__c);                
            }
            if(pc.HRM_ROO_AO__c != null) { 
                userIds.add(pc.HRM_ROO_AO__c);                
            }
            if(pc.Parent_HR_Case_No__c != null) {
                parentCaseIds.add(pc.Parent_HR_Case_No__c);
            }    
        }
        Map<Id, Group> grpMap = new Map<Id, Group>([Select Id from Group Where DeveloperName Like 'HRM_%']);
        
        Map<Id, HR_Case__c> parentCasesMap = new Map<Id, HR_Case__c>([
                    SELECT Id, HRM_Office__c, HRM_OIG_Case_Number__c FROM HR_Case__c WHERE Id IN :parentCaseIds]);
                                                                    
        grpuserslist = [SELECT UserorGroupId, GroupId FROM GroupMember WHERE GroupId IN :grpMap.keySet() AND UserorGroupId IN :userIds];
        
        for(GroupMember g : grpuserslist) {
            grpuserMap.put(g.UserorGroupId, g.GroupId);
        }
        
        for(HR_Case__c pc: triggerNew) {
            // validate that AS is the member of HRM All Users group
            if( (pc.HRM_Assigned_Specialist__c != null) && (!grpusermap.containsKey(pc.HRM_Assigned_Specialist__c)) ) {
                pc.addError('Assigned Specialist is not a HRM group member, please select the active HRM group member');   
            }
            // validate that ROO/AO is the member of HRM All Users group
            if( (pc.HRM_ROO_AO__c != null) && (!grpusermap.containsKey(pc.HRM_ROO_AO__c)) ) {
                pc.addError('ROO/AO is not a HRM group member, please select the active HRM group member');   
            }
            // validate that HRM OIG Case should be closed by ROO/AO
            if( (pc.RecordTypeId == oigCaseRecTypeId) && (pc.Status__c == 'Closed') && (pc.HRM_ROO_AO__c != UserInfo.getUserId()) ) {
                pc.addError('Sorry, you do not have permissions to Close this OIG Case. Please contact ROO/AO to close this OIG case');
            }
            // validate that 'HR Office of AS' is selected when AS field value is filled in. 
            if( (pc.HRM_Assigned_Specialist__c != null) && (pc.HRM_Office_of_Assigned_Specialist__c == null) ) {
                pc.addError('Please select the HR Office of Assigned Specialist');
            }
            // While creating a new Non-OIG case record, Change the Owner to HRM Queue
            if( pc.RecordTypeId != oigCaseRecTypeId ) {
                pc.OwnerId = cpoQueueId;
            }
            // While creating a new Non-OIG Case record without AS field value, creator of the record should be AS. 
            if( (pc.RecordTypeId != oigCaseRecTypeId) && (pc.HRM_Assigned_Specialist__c == null)) {
                pc.HRM_Assigned_Specialist__c = UserInfo.getUserId();
                pc.HRM_Office_of_Assigned_Specialist__c = pc.HRM_Office__c;
            }
            // While creating a child case record, need to auto-populate the OIG Case Number and HRM Office fields.
            if( (pc.Parent_HR_Case_No__c != null) && (parentCasesMap.containsKey(pc.Parent_HR_Case_No__c)) ) {
                pc.HRM_Office__c = parentCasesMap.get(pc.Parent_HR_Case_No__c).HRM_Office__c;
                pc.HRM_OIG_Case_Number__c = parentCasesMap.get(pc.Parent_HR_Case_No__c).HRM_OIG_Case_Number__c;
            }            
        }    
    
    }  
    
}