public with sharing class Amountchanged {
    /**
     * When a CAMPX__Sponsor__c record is updated to have an "Accepted" CAMPX__Status__c, the system should account for the sponsor's CAMPX__ContributedAmount__c in the CAMPX__Event__c's CAMPX__GrossRevenue__c field
    
    
    public static void sponsorAcceptedAmountChange(List<CAMPX__Sponsor__c> sponsorList, Map<Id, CAMPX__Sponsor__c> sponsorMap){
        Map<Id, Decimal> eventIdsToContributionMap = new Map<Id, Decimal>();
        Set<Id> eventIds = new Set<Id>();
        System.debug('Method sponsorAcceptedAmountChange invoked'); 
        // Debugging sponsorList and sponsorMap
        System.debug('sponsorList: ' + sponsorList);
        System.debug('sponsorMap: ' + sponsorMap);
        
        if(!sponsorList.isEmpty()){
            for(CAMPX__Sponsor__c cs : sponsorList){
                System.debug('Processing Sponsor: ' + cs);
                
                if(sponsorMap != null){
                    CAMPX__Sponsor__c oldRecord = sponsorMap.get(cs.Id);
                    System.debug('Old Record: ' + oldRecord);
                    
                    if(cs.CAMPX__Status__c == 'Accepted' && oldRecord.CAMPX__Status__c != 'Accepted'){
                        System.debug('Sponsor status changed to Accepted, adding to eventIds: ' + cs.CAMPX__Event__c);
                        eventIds.add(cs.CAMPX__Event__c);
                    }
    
                    if(cs.CAMPX__Event__c != oldRecord.CAMPX__Event__c){
                        System.debug('Sponsor event changed, adding both events to eventIds: ' + cs.CAMPX__Event__c + ', ' + oldRecord.CAMPX__Event__c);
                        eventIds.add(cs.CAMPX__Event__c);
                        eventIds.add(oldRecord.CAMPX__Event__c);
                    }
                }
            }
        }
    
        System.debug('eventIds: ' + eventIds); // Check the eventIds that were added
    
        if (!eventIds.isEmpty()) {
            // Querying related sponsors and events
            List<CAMPX__Sponsor__c> sponsList = [ Select Id, CAMPX__Event__c, CAMPX__ContributionAmount__c From CAMPX__Sponsor__c Where CAMPX__Event__c In :eventIds ];
            List<CAMPX__Event__c> eventList = [Select Id, CAMPX__GrossRevenue__c From CAMPX__Event__c Where Id In :eventIds];
    
            System.debug('sponsList: ' + sponsList); // Check the list of sponsors retrieved
            System.debug('eventList: ' + eventList); // Check the list of events retrieved
    
            for (CAMPX__Event__c ce : eventList){
                eventIdsToContributionMap.put(ce.Id, ce.CAMPX__GrossRevenue__c);
                System.debug('Event: ' + ce.Id + ', Gross Revenue: ' + ce.CAMPX__GrossRevenue__c); // Debug each event's gross revenue
            }
    
            for(CAMPX__Sponsor__c sp : sponsList){
                if(eventIdsToContributionMap.containsKey(sp.CAMPX__Event__c)){
                    Decimal gross = eventIdsToContributionMap.get(sp.CAMPX__Event__c) + sp.CAMPX__ContributionAmount__c;
                    eventIdsToContributionMap.put(sp.CAMPX__Event__c, gross);
                    System.debug('Updated Gross Revenue for Event ' + sp.CAMPX__Event__c + ': ' + gross);
                }
            }
        }
        
        List<CAMPX__Event__c> eventsToUpdate = new List<CAMPX__Event__c>();
        if(eventIdsToContributionMap != null){
            for(Id eventId : eventIdsToContributionMap.keySet()){
                CAMPX__Event__c event = new CAMPX__Event__c();
                event.Id = eventId;
                event.CAMPX__GrossRevenue__c = eventIdsToContributionMap.get(eventId);
                eventsToUpdate.add(event);
                System.debug('Preparing to update Event ' + eventId + ' with Gross Revenue: ' + event.CAMPX__GrossRevenue__c);
            }
        }
    
        if(!eventsToUpdate.isEmpty()){
            update eventsToUpdate;
            System.debug('Updated events: ' + eventsToUpdate);
        } else {
            System.debug('No events to update.');
        }
    }*/
}