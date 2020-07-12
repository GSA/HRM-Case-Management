<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>HRM_Case_15_Day_Notification_for_30_Day_Deadline</fullName>
        <description>HRM Case 15 Day Notification for 30 Day Deadline</description>
        <protected>false</protected>
        <recipients>
            <field>HRM_Assigned_Specialist__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HRM_Case_Management/HRM_Case_Reminder_15_Day_Email</template>
    </alerts>
    <alerts>
        <fullName>HRM_Case_15_Day_Notification_for_60_Day_Deadline</fullName>
        <description>HRM Case 15 Day Notification for 60 Day Deadline</description>
        <protected>false</protected>
        <recipients>
            <field>HRM_Assigned_Specialist__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HRM_Case_Management/HRM_Case_Reminder_15_Day_Email_for_60_Day_Deadline</template>
    </alerts>
    <alerts>
        <fullName>HRM_Case_45_Day_Notification_for_60_Day_Deadline</fullName>
        <description>HRM Case 45 Day Notification for 60 Day Deadline</description>
        <protected>false</protected>
        <recipients>
            <field>HRM_Assigned_Specialist__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HRM_Case_Management/HRM_Case_Reminder_45_Day_Email_for_60_Day_Deadline</template>
    </alerts>
    <alerts>
        <fullName>HRM_Case_Creation_Notification</fullName>
        <description>HRM Case Creation Notification</description>
        <protected>false</protected>
        <recipients>
            <field>HRM_Assigned_Specialist__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HRM_Case_Management/HRM_Case_Notification_Initial_Email</template>
    </alerts>
    <alerts>
        <fullName>HRM_Case_Reminder_15_Days</fullName>
        <description>15 Days after HR Case: HRM Case Reminder 15 Day Notification for 30 Day Deadline</description>
        <protected>false</protected>
        <recipients>
            <recipient>packagesf@gmail.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HRM_Case_Management/HRM_Case_Reminder_15_Day_Email</template>
    </alerts>
    <alerts>
        <fullName>HRM_Expedited_Grievance_Case_10_Day_Notification</fullName>
        <description>HRM Expedited Grievance Case 10 Day Notification for 15 Day Deadline</description>
        <protected>false</protected>
        <recipients>
            <field>HRM_Assigned_Specialist__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HRM_Case_Management/HRM_Case_Reminder_10_Day_Email</template>
    </alerts>
    <alerts>
        <fullName>HRM_New_AS_Notification</fullName>
        <description>HRM New AS Notification</description>
        <protected>false</protected>
        <recipients>
            <field>HRM_Assigned_Specialist__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HRM_Case_Management/HRM_Case_Notification_Initial_Email</template>
    </alerts>
    <alerts>
        <fullName>HRM_OIG_Case_30_Day_Notification_for_60_Day_Deadline</fullName>
        <description>HRM OIG Case 30 Day Notification for 60 Day Deadline</description>
        <protected>false</protected>
        <recipients>
            <field>HRM_Assigned_Specialist__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HRM_Case_Management/HRM_OIG_Case_Reminder_30_Day_Email</template>
    </alerts>
    <alerts>
        <fullName>HRM_OIG_Case_Assignment_Notification_for_Assigned_Specialist</fullName>
        <description>HRM OIG Case Assignment Notification for Assigned Specialist</description>
        <protected>false</protected>
        <recipients>
            <field>HRM_Assigned_Specialist__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HRM_Case_Management/HRM_OIG_Case_Assignment_Notification_Email_for_Assigned_Specialist</template>
    </alerts>
    <alerts>
        <fullName>HRM_OIG_Case_Assignment_Notification_for_ROO_AO</fullName>
        <description>HRM OIG Case Assignment Notification for ROO/AO</description>
        <protected>false</protected>
        <recipients>
            <field>HRM_ROO_AO__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HRM_Case_Management/HRM_OIG_Case_Assignment_Notification_Email_ROO_AO</template>
    </alerts>
    <alerts>
        <fullName>HRM_OIG_Case_Notification_for_Action_Officer</fullName>
        <description>HRM OIG Case Notification Ready for Action Officer to View</description>
        <protected>false</protected>
        <recipients>
            <field>HRM_ROO_AO__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HRM_Case_Management/HRM_OIG_Case_Notification_Ready_for_Action_Officer_to_View</template>
    </alerts>
    <fieldUpdates>
        <fullName>HRM_Field_Update_Set_Priority_High</fullName>
        <field>Priority__c</field>
        <literalValue>High</literalValue>
        <name>HRM Update Priority to High</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>HRM_OIG_Case_Update_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>packagesf@gmail.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>HRM OIG Case Update Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>HRM_OIG_Case_Update_Stage</fullName>
        <description>This will update Stage to Reviewed by Action Officer</description>
        <field>Stage__c</field>
        <literalValue>Reviewed by Action Officer</literalValue>
        <name>HRM OIG Case Update Stage to AO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>HRM_OIG_Stage_field_to_AS</fullName>
        <field>Stage__c</field>
        <literalValue>Assigned to Assigned Specialist</literalValue>
        <name>HRM OIG Case Update Stage to AS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>HR_Closed_Date_field_updated_to_Today</fullName>
        <description>Closed Date is updated to today&apos;s date</description>
        <field>HRM_Date_Case_Closed__c</field>
        <formula>today()</formula>
        <name>HR Update Closed Date to Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>X30_Days_After_HR_Case_Date_MGMT_HR_Ag</fullName>
        <field>Priority__c</field>
        <literalValue>High</literalValue>
        <name>30 Days After HR Case: Date MGMT &amp; HR Ag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>HR Date Closed when Status Closed</fullName>
        <actions>
            <name>HR_Closed_Date_field_updated_to_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>HR_Case__c.Status__c</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>HR Date Closed is filled in with today&apos;s date when Status is set to Closed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>HRM 10 and 15 Day Action Based on Date Case Received</fullName>
        <actions>
            <name>HRM_Case_Creation_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>HRM_Expedited_Grievance_Case_10_Day_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>HRM_Field_Update_Set_Priority_High</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>HR_Case__c.Status__c</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <criteriaItems>
            <field>HR_Case__c.Marked_for_Deletion__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>HR_Case__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Grievances and Arbitration Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>HR_Case__c.HRM_Expedited_Greviance__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>This workflow will send email notifications to AS at start of case, 10 days later, and set priority to high if case is not closed in 15 days. Based on Date Case Received.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>HRM 15 and 30 Day Action Based on Date Case Received</fullName>
        <actions>
            <name>HRM_Case_15_Day_Notification_for_30_Day_Deadline</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>HRM_Case_Creation_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>HRM_Field_Update_Set_Priority_High</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND ((3 AND 4) OR (5))</booleanFilter>
        <criteriaItems>
            <field>HR_Case__c.Status__c</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <criteriaItems>
            <field>HR_Case__c.Marked_for_Deletion__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>HR_Case__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Grievances and Arbitration Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>HR_Case__c.HRM_Expedited_Greviance__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>HR_Case__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Reasonable Accommodation (RA) Case</value>
        </criteriaItems>
        <description>This workflow will send email notifications to AS at start of case, 15 days later, and set priority to high if case is not closed in 30 days. Based on Date Case Received.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>HRM 15 and 30 Day Action Based on Date MGMT %26 HR Agree to Decided Action</fullName>
        <actions>
            <name>HRM_Case_15_Day_Notification_for_30_Day_Deadline</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>HRM_Case_Creation_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>HRM_Field_Update_Set_Priority_High</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>HR_Case__c.Status__c</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <criteriaItems>
            <field>HR_Case__c.Marked_for_Deletion__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>HR_Case__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Medical Case</value>
        </criteriaItems>
        <description>This workflow will send email notifications to AS at start of case, 15 days later, and set priority to high if case is not closed in 30 days. Based on Date MGMT &amp; HR Agree to Decided Action.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>HRM 15 and 30 Day Action Based on Date MGMT %26 HR Agree to Proposed Action</fullName>
        <actions>
            <name>HRM_Case_Creation_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>HRM_Case_Reminder_15_Days</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>X30_Days_After_HR_Case_Date_MGMT_HR_Ag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND ((3 AND 4) OR (5 AND 6))</booleanFilter>
        <criteriaItems>
            <field>HR_Case__c.Status__c</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <criteriaItems>
            <field>HR_Case__c.Marked_for_Deletion__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>HR_Case__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Disciplinary Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>HR_Case__c.HRM_Proposed_Type_of_Action__c</field>
            <operation>equals</operation>
            <value>Warning Notice,Reprimand</value>
        </criteriaItems>
        <criteriaItems>
            <field>HR_Case__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Performance Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>HR_Case__c.HRM_Proposed_Type_of_Action__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>This workflow will send email notifications to AS at start of case, 15 days later, and set priority to high if case is not closed in 30 days. Based on Date MGMT &amp; HR Agree to Proposed Action.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>HRM 15%2C 45 and 60 Day Notification Based on Date MGMT %26 HR Agree to Proposed Action</fullName>
        <actions>
            <name>HRM_Case_15_Day_Notification_for_30_Day_Deadline</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>HRM_Case_45_Day_Notification_for_60_Day_Deadline</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>HRM_Case_Creation_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>HRM_Field_Update_Set_Priority_High</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND ((3 AND 4) OR (5 AND 6))</booleanFilter>
        <criteriaItems>
            <field>HR_Case__c.Status__c</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <criteriaItems>
            <field>HR_Case__c.Marked_for_Deletion__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>HR_Case__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Disciplinary Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>HR_Case__c.HRM_Proposed_Type_of_Action__c</field>
            <operation>equals</operation>
            <value>Suspension,Removal,Demotion,Reassignment</value>
        </criteriaItems>
        <criteriaItems>
            <field>HR_Case__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Performance Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>HR_Case__c.HRM_Proposed_Type_of_Action__c</field>
            <operation>equals</operation>
            <value>Removal,Demotion,Reassignment,Denial WIGI</value>
        </criteriaItems>
        <description>This workflow will send email notifications to AS at start of case, 15 days later, 45 days later and set priority to high if case is not closed in 60 days. Based on Date MGMT &amp; HR Agree to Proposed Action.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>HRM New Assigned Specialist Notification</fullName>
        <actions>
            <name>HRM_New_AS_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow will send an email notification to the new Assigned Specialist for all HRM cases except OIG.</description>
        <formula>AND(  OR(RecordType.DeveloperName = &apos;HRM_Disciplinary_Case&apos;, RecordType.DeveloperName = &apos;HRM_Grievances_and_Arbitration_Case&apos;,  RecordType.DeveloperName = &apos;HRM_Medical_Case&apos;, RecordType.DeveloperName = &apos;HRM_Performance_Case&apos;, RecordType.DeveloperName = &apos;HRM_Reasonable_Accommodation_RA_Case&apos; ),  ISPICKVAL(Status__c, &quot;Open&quot;) , ISCHANGED(HRM_Assigned_Specialist__c ), NOT(Marked_for_Deletion__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>HRM OIG 30 and 60 Day Action Based on Date Case Recieved</fullName>
        <actions>
            <name>HRM_OIG_Case_30_Day_Notification_for_60_Day_Deadline</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>HRM_Field_Update_Set_Priority_High</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>HR_Case__c.Status__c</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <criteriaItems>
            <field>HR_Case__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>OIG Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>HR_Case__c.Marked_for_Deletion__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>This workflow will send an email notification to AS 30 days after Date Case Received and set priority to high if case is not closed in 60 days. Only for an OIG case.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>HRM OIG Case Notification Ready for Action Officer to View</fullName>
        <actions>
            <name>HRM_OIG_Case_Notification_for_Action_Officer</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>HR_Case__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>OIG Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>HR_Case__c.Stage__c</field>
            <operation>equals</operation>
            <value>Ready for Action Officer to View</value>
        </criteriaItems>
        <criteriaItems>
            <field>HR_Case__c.Marked_for_Deletion__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>This workflow will send an email notification to the Action Officer when the Stage of an OIG case is set to &quot;Ready for Action Officer to View.&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>HRM OIG Case Notification Rules</fullName>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>HR_Case__c.Status__c</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <criteriaItems>
            <field>HR_Case__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>OIG Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>HR_Case__c.Marked_for_Deletion__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>This workflow will send an email notification to AS 30 days after Date Case Received and set priority to high if case is not closed in 60 days. Only for an OIG case.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>HRM OIG Case Notification for Assigned Specialist</fullName>
        <actions>
            <name>HRM_OIG_Case_Assignment_Notification_for_Assigned_Specialist</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow will send an email notification to the new Assigned Specialist. Only for an OIG case.</description>
        <formula>AND(  RecordType.DeveloperName = &apos;HRM_OIG_Case&apos;, ISPICKVAL(Status__c, &quot;Open&quot;) , ISCHANGED(HRM_Assigned_Specialist__c ), NOT(Marked_for_Deletion__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>HRM OIG Case Notification for ROO%2FAO</fullName>
        <actions>
            <name>HRM_OIG_Case_Assignment_Notification_for_ROO_AO</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow will send an email notification to the new ROO/AO.</description>
        <formula>AND( RecordType.DeveloperName = &apos;HRM_OIG_Case&apos;,  ISPICKVAL(Status__c, &quot;Open&quot;) , OR(ISNEW(), ISCHANGED( HRM_ROO_AO__c )),NOT(Marked_for_Deletion__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>HRM OIG Case On Status Change to Closed</fullName>
        <actions>
            <name>HRM_OIG_Case_Update_Stage</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>HR_Case__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>OIG Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>HR_Case__c.Status__c</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>This workflow will change stage to “Reviewed by Action Officer” when OIG case is closed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>HRM OIG Case Reopen</fullName>
        <actions>
            <name>HRM_OIG_Stage_field_to_AS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow will change stage to “Assigned to Assigned Specialist&quot; when OIG case is re-opened.</description>
        <formula>AND(RecordType.DeveloperName == &apos;HRM_OIG_Case&apos;,  ISPICKVAL(Status__c, &apos;Open&apos;),  ISPICKVAL(PRIORVALUE(Status__c),&apos;Closed&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>HRM OIG Case Transfer Case Ownership</fullName>
        <actions>
            <name>HRM_OIG_Case_Update_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>HR_Case__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>OIG Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>HR_Case__c.OwnerId</field>
            <operation>notEqual</operation>
            <value>CPO – Case Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>HR_Case__c.Stage__c</field>
            <operation>notEqual</operation>
            <value>With Intake Reviewer</value>
        </criteriaItems>
        <criteriaItems>
            <field>HR_Case__c.Status__c</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <description>This workflow will change the owner to a queue when Stage is set other than “With Intake Reviewer”</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
