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
    with an event before being Accepted." 
    

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
    }*/
    
}