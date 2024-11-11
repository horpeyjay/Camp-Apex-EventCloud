trigger CampApexTrigger on CAMPX__Event__c (before insert, before update) {
    if(trigger.isBefore){
        if(trigger.isInsert){
            CampApexHandlerClass.updateStatus(trigger.new);
            CampApexHandlerClass.eventStatusChange(trigger.new, null);
            CampApexHandlerClass.eventNetRevenue(trigger.new, null);
        }

        if(trigger.isUpdate){
            CampApexHandlerClass.eventStatusChange(trigger.new, trigger.oldMap);
            CampApexHandlerClass.eventNetRevenue(trigger.new, trigger.oldMap);
        }   
    }
}