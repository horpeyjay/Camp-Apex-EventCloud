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
    
    /**
     * The CAMPX__NetRevenue__c of an CAMPX__Event__c record should always reflect the formula: CAMPX__GrossRevenue__c - CAMPX__TotalExpenses__c
    If either CAMPX__GrossRevenue__c or CAMPX__TotalExpenses__c are blank, the CAMPX__NetRevenue__c should be blank.
     */
    public static void eventNetRevenue(List<CAMPX__Event__c> eventList, Map<Id, CAMPX__Event__c> eventMap){
        List<CAMPX__Event__c> newList = new List<CAMPX__Event__c>();
        if(!eventList.isEmpty()){
            for(CAMPX__Event__c ce : eventList){
                if(eventMap != null){
                    CAMPX__Event__c oldEvent = eventMap.get(ce.Id);

                    if(ce.CAMPX__GrossRevenue__c != oldEvent.CAMPX__GrossRevenue__c || ce.CAMPX__TotalExpenses__c != oldEvent.CAMPX__TotalExpenses__c){
                        newList.add(ce);
                    }
                }else{
                    newList.add(ce);
                }
            }
        }

        if(!newList.isEmpty()){
            for(CAMPX__Event__c nce : newList){
                if(nce.CAMPX__GrossRevenue__c == null || nce.CAMPX__TotalExpenses__c == null){
                    nce.CAMPX__NetRevenue__c = null;
                }else{
                    nce.CAMPX__NetRevenue__c = nce.CAMPX__GrossRevenue__c - nce.CAMPX__TotalExpenses__c;
                }
            }
        }
    }
}