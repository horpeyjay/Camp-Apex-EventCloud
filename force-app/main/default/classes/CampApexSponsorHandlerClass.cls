public with sharing class CampApexSponsorHandlerClass {
    /**When a CAMPX__Sponsor__c record is created, and the CAMPX__Status__c is blank, it should be set to "Pending" */
    public static void pendingSponsorStatus(List<CAMPX__Sponsor__c> sponsorList){
        if(!sponsorList.isEmpty()){
            for(CAMPX__Sponsor__c cs : sponsorList){
                if(cs.CAMPX__Status__c == null || String.isBlank(cs.CAMPX__Status__c)){
                    cs.CAMPX__Status__c = 'Pending';
                }
            }
        }
    }
    /**When a CAMPX__Sponsor__c record is created without a value in CAMPX__Email__c, the user should see an error stating "A sponsor can not be created without an email address" */
    public static void sponsorEmailRequired(List<CAMPX__Sponsor__c> sponsorList){
        if(!sponsorList.isEmpty()){
            for(CAMPX__Sponsor__c cs : sponsorList){
                if(cs.CAMPX__Email__c == null){
                    cs.CAMPX__Email__c.addError('A sponsor can not be created without an email address');
                }
            }
        }
    }

    /**The CAMPX__Tier__c should be set based on their contribution amount */

    public static void sponsorTier(List<CAMPX__Sponsor__c> sponsorList, Map<Id, CAMPX__Sponsor__c> sponsorMap){
        List<CAMPX__Sponsor__c> sponsorsNewList = new List<CAMPX__Sponsor__c>();
        
        if(!sponsorList.isEmpty()){
            for(CAMPX__Sponsor__c cs : sponsorList){
                if(sponsorMap != null){
                    CAMPX__Sponsor__c oldRecord = sponsorMap.get(cs.Id);

                    if(cs.CAMPX__ContributionAmount__c != oldRecord.CAMPX__ContributionAmount__c){
                        sponsorsNewList.add(cs);
                    }
                }else{
                    sponsorsNewList.add(cs);
                }
            }
        }

        if(!sponsorsNewList.isEmpty()){
            for(CAMPX__Sponsor__c cs : sponsorsNewList){
                if(cs.CAMPX__ContributionAmount__c > 0){
                    
                    if(cs.CAMPX__ContributionAmount__c > 0 && cs.CAMPX__ContributionAmount__c < 1000){
                        cs.CAMPX__Tier__c = 'Bronze';
                    }else if(cs.CAMPX__ContributionAmount__c >= 1000 && cs.CAMPX__ContributionAmount__c < 5000){
                        cs.CAMPX__Tier__c = 'Silver';
                    }else if(cs.CAMPX__ContributionAmount__c >= 5000){
                        cs.CAMPX__Tier__c  = 'Gold';
                    }
                }else{
                    cs.CAMPX__Tier__c = null;
                }
            }
        }
    }

    /**
    The CAMPX__Status__c field of a CAMPX__Sponsor__c record can not be updated to "Accepted" until the CAMPX__Event__c field is populated
    The user should see this error when attempting to accept a sponsor without an event: "A Sponsor must be associated 
    with an event before being Accepted." */
    
    
    public static void sponsorEventRequired(List<CAMPX__Sponsor__c> sponsorList, Map<Id, CAMPX__Sponsor__c> sponsorMap){
        List<CAMPX__Sponsor__c> sponsorsNewList = new List<CAMPX__Sponsor__c>();

        if(!sponsorList.isEmpty()){
            for(CAMPX__Sponsor__c cs : sponsorList){
                if(sponsorMap != null){
                    CAMPX__Sponsor__c oldRecord = sponsorMap.get(cs.Id);

                    if(cs.CAMPX__Status__c != oldRecord.CAMPX__Status__c){
                        sponsorsNewList.add(cs);
                    }
                }else{
                    sponsorsNewList.add(cs);
                }
                
            }
        }

        if(!sponsorsNewList.isEmpty()){
            for(CAMPX__Sponsor__c cs : sponsorsNewList){
                if(cs.CAMPX__Status__c == 'Accepted' && cs.CAMPX__Event__c == null){
                    cs.CAMPX__Event__c.addError('A Sponsor must be associated with an event before being Accepted.');
                }
            }
        }
    }
    

    /**
     * When a CAMPX__Sponsor__c record is updated to have an "Accepted" CAMPX__Status__c, the system should account for the sponsor's CAMPX__ContributedAmount__c in the CAMPX__Event__c's CAMPX__GrossRevenue__c field
    */

    /*public static void sponsorAcceptedAmountChange(List<CAMPX__Sponsor__c> newsponsorList, Map<Id, CAMPX__Sponsor__c> oldSponsorMap){

        //get the event ids
        Set<Id> eventIds = new Set<Id>();

        if(!newsponsorList.isEmpty()){
            for(CAMPX__Sponsor__c sp : newsponsorList){
                if(oldSponsorMap != null){
                    CAMPX__Sponsor__c oldRecord = oldSponsorMap.get(sp.Id);
                    if(sp.Id != oldRecord.Id){
                        eventIds.add(sp.CAMPX__Event__c);
                        eventIds.add(oldRecord.CAMPX__Event__c);
                    }else if(sp.CAMPX__Status__c != oldRecord.CAMPX__Status__c && sp.CAMPX__Status__c == 'Accepted'){
                        eventIds.add(sp.CAMPX__Event__c);
                    }
                }else{
                    eventIds.add(sp.CAMPX__Event__c);
                }
            }
        }
        system.debug('here is the event ids' + eventIds);
        Map<Id, Decimal> eventIdsToContributionMap = new Map<Id, Decimal>();
        if(!eventIds.isEmpty()){

            List<CAMPX__Event__c> events = [Select Id, CAMPX__GrossRevenue__c From CAMPX__Event__c where Id in : eventIds];
            system.debug('here is the events' + events);
            //initialize the gross revenue to 0
            for(CAMPX__Event__c e : events){
                eventIdsToContributionMap.put(e.Id, 0);
            }
            system.debug('Here is the map gotten' + eventIdsToContributionMap);
            List<CAMPX__Sponsor__c> relatedSponsor = [Select CAMPX__Event__c, CAMPX__ContributionAmount__c From CAMPX__Sponsor__c where CAMPX__Event__c in : eventIdsToContributionMap.keySet() and CAMPX__Status__c = 'Accepted'];

            for(CAMPX__Sponsor__c sp : relatedSponsor){
                Decimal gross = eventIdsToContributionMap.get(sp.CAMPX__Event__c) + sp.CAMPX__ContributionAmount__c;
                eventIdsToContributionMap.put(sp.CAMPX__Event__c, gross);
            }

            system.debug('Here is the updated map' + eventIdsToContributionMap);
        }
        List<CAMPX__Event__c> eventsToUpdate = new List<CAMPX__Event__c>();
        if(eventIdsToContributionMap != null){
            for(Id eventId : eventIdsToContributionMap.keySet()){
                CAMPX__Event__c event = new CAMPX__Event__c();
                event.Id = eventId;
                event.CAMPX__GrossRevenue__c = eventIdsToContributionMap.get(eventId);
                eventsToUpdate.add(event);
            }
        }

        if(!eventsToUpdate.isEmpty()){
            update eventsToUpdate;
        }
    }*/

    public static void sponsorContributionRemoved(List<CAMPX__Sponsor__c> declinedSponsorList, Map<Id, CAMPX__Sponsor__c> oldSponsorMap) {
        Set<Id> eventIds = new Set<Id>();
    
        // Gather relevant Event IDs based on status or event changes
        if (!declinedSponsorList.isEmpty()) {
            for (CAMPX__Sponsor__c sp : declinedSponsorList) {
                if (oldSponsorMap != null) {
                    CAMPX__Sponsor__c oldRecord = oldSponsorMap.get(sp.Id);
                    if (sp.CAMPX__Status__c != oldRecord.CAMPX__Status__c || sp.CAMPX__Event__c != oldRecord.CAMPX__Event__c) {
                        eventIds.add(sp.CAMPX__Event__c);
                        eventIds.add(oldRecord.CAMPX__Event__c);
                    }
                } else {
                    eventIds.add(sp.CAMPX__Event__c);
                }
            }
        }
    
        // Create a map to store the new gross revenue for each event
        Map<Id, Decimal> amountMap = new Map<Id, Decimal>();
    
        if (!eventIds.isEmpty()) {
            // Query accepted sponsors for each event and sum their contributions
            List<CAMPX__Sponsor__c> relatedSponsors = [
                SELECT CAMPX__Event__c, CAMPX__ContributionAmount__c 
                FROM CAMPX__Sponsor__c 
                WHERE CAMPX__Event__c IN :eventIds AND CAMPX__Status__c = 'Accepted'
            ];
    
            for (CAMPX__Sponsor__c sponsor : relatedSponsors) {
                if (amountMap.containsKey(sponsor.CAMPX__Event__c)) {
                    amountMap.put(sponsor.CAMPX__Event__c, amountMap.get(sponsor.CAMPX__Event__c) + sponsor.CAMPX__ContributionAmount__c);
                } else {
                    amountMap.put(sponsor.CAMPX__Event__c, sponsor.CAMPX__ContributionAmount__c);
                }
            }
        }
    
        // Prepare and update events with the recalculated gross revenue
        List<CAMPX__Event__c> eventUpdates = new List<CAMPX__Event__c>();
        for (Id eventId : amountMap.keySet()) {
            eventUpdates.add(new CAMPX__Event__c(Id = eventId, CAMPX__GrossRevenue__c = amountMap.get(eventId)));
        }
    
        if (!eventUpdates.isEmpty()) {
            update eventUpdates;
        }
    }
    
}