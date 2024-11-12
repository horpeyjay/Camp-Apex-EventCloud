@isTest
public with sharing class Testclassforevent {
    @isTest
    static void testForAmountChange(){
        CAMPX__Event__c e = new CAMPX__Event__c(Name = 'Apex Event', CAMPX__GrossRevenue__c = 200);
        insert e;
        System.debug('The Id of the insert event is ' + e.Id);
        system.assertEquals(200, e.CAMPX__GrossRevenue__c, 'The records was not inserted');

        CAMPX__Sponsor__c sp = new CAMPX__Sponsor__c (Name = 'sponsor 1', CAMPX__ContributionAmount__c = 400, CAMPX__Email__c = 'test@gmail.com', CAMPX__Event__c = e.Id, CAMPX__Status__c = 'Pending');
        insert sp;
        CAMPX__Sponsor__c sp1 = new CAMPX__Sponsor__c (Name = 'sponsor 2', CAMPX__ContributionAmount__c = 400, CAMPX__Email__c = 'test1@gmail.com', CAMPX__Event__c = e.Id, CAMPX__Status__c = 'Accepted');
        insert sp1;
        List<CAMPX__Sponsor__c> eventSponsor = [Select Id, CAMPX__ContributionAmount__c From CAMPX__Sponsor__c where CAMPX__Event__c = : e.Id];
        system.assertEquals(2, eventSponsor.size(), 'something is wrong with the query');
        sp.CAMPX__Status__c = 'Accepted';
        update sp;

        List<CAMPX__Event__c> eventList = [Select Id, CAMPX__GrossRevenue__c From CAMPX__Event__c where Id = : e.Id];
        System.Assert.areEqual(800, eventList[0].CAMPX__GrossRevenue__c, 'The update event does not work');
    }
}