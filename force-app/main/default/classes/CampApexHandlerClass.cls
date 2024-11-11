public with sharing class CampApexHandlerClass {
    public static void updateStatus(List<CAMPX__Event__c> eventList){

        if(!eventList.isEmpty()){
            for (CAMPX__Event__c  ce : eventList){
                ce.CAMPX__Status__c = 'Planning';
            }
        }
    }

    public static void eventStatusChange(List<CAMPX__Event__c >eventList, Map<Id, CAMPX__Event__c > eventToIdMap){

        for(CAMPX__Event__c ce : eventList){
            if(eventToIdMap != null){
                CAMPX__Event__c oldevent = eventToIdMap.get(ce.Id);

                if(ce.CAMPX__Status__c != oldevent.CAMPX__Status__c){
                    ce.CAMPX__StatusChangeDate__c = Datetime.now();
                }
            }else{
                ce.CAMPX__StatusChangeDate__c = Datetime.now();
            }    
        }
    }
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
}