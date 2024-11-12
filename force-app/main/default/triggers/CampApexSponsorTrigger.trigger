trigger CampApexSponsorTrigger on CAMPX__Sponsor__c (before insert, before update, after update, after insert) {
    if(trigger.isBefore){
        if(trigger.isInsert){
            CampApexSponsorHandlerClass.pendingSponsorStatus(trigger.new);
            CampApexSponsorHandlerClass.sponsorEmailRequired(trigger.new);
            CampApexSponsorHandlerClass.sponsorTier(trigger.new, null);
            CampApexSponsorHandlerClass.sponsorEventRequired(trigger.new, null);
        }

        if(trigger.isUpdate){
            CampApexSponsorHandlerClass.sponsorTier(trigger.new, trigger.oldMap);
            CampApexSponsorHandlerClass.sponsorEventRequired(trigger.new, trigger.oldMap);
        }
    }

    if(trigger.isAfter){
        if(trigger.isUpdate){
            //CampApexSponsorHandlerClass.sponsorAcceptedAmountChange(trigger.new, trigger.oldMap);
            CampApexSponsorHandlerClass.sponsorContributionRemoved(trigger.new, trigger.oldMap);
            
        }

        if(trigger.isInsert){
            //CampApexSponsorHandlerClass.sponsorAcceptedAmountChange(trigger.new, null);
            CampApexSponsorHandlerClass.sponsorContributionRemoved(trigger.new, null);
            
        }
    }

}