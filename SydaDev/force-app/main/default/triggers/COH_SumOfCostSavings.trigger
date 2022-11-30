/*************************************************************************
    This Trigger is written on Child object to update parents
	QH, CM, RW, AM, HD & COH Evaluation request's Cost savings Section
	fields ROI & Cost Savings Added.

	Rajeshwar Chittari
	City of Hope
	Copyright (c) 2019

	No portion of this code may be copied, transferred, or transmitted
	in any form (written, electronic, or otherwise) without the prior
	written consent from the City of Hope
**************************************************************************/
trigger COH_SumOfCostSavings on Cost_Saving__c (after insert, after update, after delete) 
{
    
    //for Quantam Health Evaluation request update:
    //Lookup fields on Cost saving Object: COH_CSQH_Evalution_Request__c,COH_CSCM_Evaluation_Request__c,COH_CSRW_Evalution_Request__c,COH_CSAM_Evaluationrequest__c,COH_CSHD_Evaluationrequest__c
    set<Id> vSetEReqIds = new set<Id>();
    for(Cost_Saving__c vCostSaving : trigger.isInsert ? trigger.new : trigger.old)
    {
        if(vCostSaving.COH_CSQH_Evalution_Request__c!=null)
        {
        vSetEReqIds.add(vCostSaving.COH_CSQH_Evalution_Request__c);
        }
    }
	if(!vSetEReqIds.isEmpty() && vSetEReqIds!=null)
	{
    List<AggregateResult> AggregateResultList = [SELECT COH_CSQH_Evalution_Request__c parent, Sum(Savings__c)amt from Cost_Saving__c WHERE COH_CSQH_Evalution_Request__c IN:vSetEReqIds GROUP BY COH_CSQH_Evalution_Request__c];    
    Map<id, Evaluation_Request__c> vMapIdERequests= new Map<id, Evaluation_Request__c>([SELECT id,Cost_Savings_Added__c,Program_Cost__c,ROI__c from Evaluation_Request__c WHERE id IN: vSetEReqIds]);
    for(AggregateResult vAgg : AggregateResultList)
    {
        Id vId = (id) vAgg.get('parent');
        if(vAgg.get('parent')==vMapIdERequests.get(vId).id)
        {           
            vMapIdERequests.get(vId).Projected_Savings__c = (Decimal) vAgg.get('amt');
            if(vMapIdERequests.get(vId).Program_Cost__c==NULL || vMapIdERequests.get(vId).Program_Cost__c==0)
            {
                vMapIdERequests.get(vId).ROI__c = (Decimal) vAgg.get('amt') / 1;
            }
            else vMapIdERequests.get(vId).ROI__c = (Decimal) vAgg.get('amt') / vMapIdERequests.get(vId).Program_Cost__c;
        }
    }
    List<Evaluation_Request__c> vListERequests = New list<Evaluation_Request__c>();
    vListERequests=vMapIdERequests.values();
    for(Evaluation_Request__c vERequest : vListERequests)
    {
        vERequest.Cost_Savings_Added__c=true;
    }
    if(! vListERequests.isEmpty())
    {
        UPDATE vListERequests;
    }
	}    
    //for Consumer Medical Evaluation request update:
    set<Id> vSetCMEReqIds = new set<Id>();
    for(Cost_Saving__c vCostSaving : trigger.isInsert ? trigger.new : trigger.old)
    {
        if(vCostSaving.COH_CSCM_Evaluation_Request__c!=null)
        {
        vSetCMEReqIds.add(vCostSaving.COH_CSCM_Evaluation_Request__c);
        }
    }
    if(!vSetCMEReqIds.isEmpty() && vSetCMEReqIds!=null)
    {
    List<AggregateResult> AggregateResultListCM = [SELECT COH_CSCM_Evaluation_Request__c parent, Sum(Savings__c)amt from Cost_Saving__c WHERE COH_CSCM_Evaluation_Request__c IN:vSetCMEReqIds GROUP BY COH_CSCM_Evaluation_Request__c];
    Map<id, CH_Evaluation_Request__c> vMapIdCMERequests= new Map<id, CH_Evaluation_Request__c>([SELECT id,Cost_Savings_Added__c,Program_Cost__c,ROI__c from CH_Evaluation_Request__c WHERE id IN: vSetCMEReqIds]);
    for(AggregateResult vAgg : AggregateResultListCM)
    {
        Id vId = (id) vAgg.get('parent');
        if(vAgg.get('parent')==vMapIdCMERequests.get(vId).id)
        {           
            vMapIdCMERequests.get(vId).Projected_Savings__c = (Decimal) vAgg.get('amt');
            if(vMapIdCMERequests.get(vId).Program_Cost__c==NULL || vMapIdCMERequests.get(vId).Program_Cost__c==0)
            {
                vMapIdCMERequests.get(vId).ROI__c = (Decimal) vAgg.get('amt') / 1;
            }
            else vMapIdCMERequests.get(vId).ROI__c = (Decimal) vAgg.get('amt') / vMapIdCMERequests.get(vId).Program_Cost__c;
        }
    }
    List<CH_Evaluation_Request__c> vListCMERequests = New list<CH_Evaluation_Request__c>();
    vListCMERequests=vMapIdCMERequests.values();
    for(CH_Evaluation_Request__c vERequest : vListCMERequests)
    {
        vERequest.Cost_Savings_Added__c=true;
    }
    if(! vListCMERequests.isEmpty())
    {
        UPDATE vListCMERequests;
    }
    }
    //for Redwood Evaluation request update:
    set<Id> vSetRWEReqIds = new set<Id>();
    for(Cost_Saving__c vCostSaving : trigger.isInsert ? trigger.new : trigger.old)
    {
        if(vCostSaving.COH_CSRW_Evalution_Request__c!=null)
        {
        vSetRWEReqIds .add(vCostSaving.COH_CSRW_Evalution_Request__c);
        }
    }
    if(!vSetRWEReqIds.isEmpty() && vSetRWEReqIds!=null)
    {
    List<AggregateResult> AggregateResultListRW = [SELECT COH_CSRW_Evalution_Request__c parent, Sum(Savings__c)amt from Cost_Saving__c WHERE COH_CSRW_Evalution_Request__c IN:vSetRWEReqIds GROUP BY COH_CSRW_Evalution_Request__c];
    Map<id, RW_Evaluation_Request__c> vMapIdRWERequests= new Map<id, RW_Evaluation_Request__c>([SELECT id,Cost_Savings_Added__c,Program_Cost__c,ROI__c from RW_Evaluation_Request__c WHERE id IN: vSetRWEReqIds]);
    for(AggregateResult vAgg : AggregateResultListRW)
    {
        Id vId = (id) vAgg.get('parent');
        if(vAgg.get('parent')==vMapIdRWERequests.get(vId).id)
        {           
            vMapIdRWERequests.get(vId).Projected_Savings__c = (Decimal) vAgg.get('amt');
            if(vMapIdRWERequests.get(vId).Program_Cost__c==NULL || vMapIdRWERequests.get(vId).Program_Cost__c==0)
            {
                vMapIdRWERequests.get(vId).ROI__c = (Decimal) vAgg.get('amt') / 1;
            }
            else vMapIdRWERequests.get(vId).ROI__c = (Decimal) vAgg.get('amt') / vMapIdRWERequests.get(vId).Program_Cost__c;
        }
    }
    List<RW_Evaluation_Request__c> vListRWERequests = New list<RW_Evaluation_Request__c>();
    vListRWERequests=vMapIdRWERequests.values();
    for(RW_Evaluation_Request__c vERequest : vListRWERequests)
    {
        vERequest.Cost_Savings_Added__c=true;
    }
    if(! vListRWERequests.isEmpty())
    {
        UPDATE vListRWERequests;
    }
    }
    //for Golden Evaluation request update:
    set<Id> vSetAMEReqIds = new set<Id>();
    for(Cost_Saving__c vCostSaving : trigger.isInsert ? trigger.new : trigger.old)
    {
        if(vCostSaving.COH_CSAM_Evaluationrequest__c!=null)
        {
        vSetAMEReqIds .add(vCostSaving.COH_CSAM_Evaluationrequest__c);
        }
    }
    if(!vSetAMEReqIds.isEmpty() && vSetAMEReqIds!=null)
    {
    List<AggregateResult> AggregateResultListAM = [SELECT COH_CSAM_Evaluationrequest__c parent, Sum(Savings__c)amt from Cost_Saving__c WHERE COH_CSAM_Evaluationrequest__c IN:vSetAMEReqIds GROUP BY COH_CSAM_Evaluationrequest__c];
    Map<id, AM_Evaluation_Request__c> vMapIdAMERequests= new Map<id, AM_Evaluation_Request__c>([SELECT id,Cost_Savings_Added__c,Program_Cost__c,ROI__c from AM_Evaluation_Request__c WHERE id IN: vSetAMEReqIds]);
    for(AggregateResult vAgg : AggregateResultListAM)
    {
        Id vId = (id) vAgg.get('parent');
        if(vAgg.get('parent')==vMapIdAMERequests.get(vId).id)
        {           
            vMapIdAMERequests.get(vId).Projected_Savings__c = (Decimal) vAgg.get('amt');
            if(vMapIdAMERequests.get(vId).Program_Cost__c==NULL || vMapIdAMERequests.get(vId).Program_Cost__c==0)
            {
                vMapIdAMERequests.get(vId).ROI__c = (Decimal) vAgg.get('amt') / 1;
            }
            else vMapIdAMERequests.get(vId).ROI__c = (Decimal) vAgg.get('amt') / vMapIdAMERequests.get(vId).Program_Cost__c;
        }
    }
    List<AM_Evaluation_Request__c> vListAMERequests = New list<AM_Evaluation_Request__c>();
    vListAMERequests=vMapIdAMERequests.values();
    for(AM_Evaluation_Request__c vERequest : vListAMERequests)
    {
        vERequest.Cost_Savings_Added__c=true;
    }
    if(! vListAMERequests.isEmpty())
    {
        UPDATE vListAMERequests;
    }
    }    
    //for HD(The Home Depot) Evaluation request update:
    set<Id> vSetHDEReqIds = new set<Id>();
    for(Cost_Saving__c vCostSaving : trigger.isInsert ? trigger.new : trigger.old)
    {
        if(vCostSaving.COH_CSHD_Evaluationrequest__c!=null)
        {
        vSetHDEReqIds .add(vCostSaving.COH_CSHD_Evaluationrequest__c);
        }
    }
    if(!vSetHDEReqIds.isEmpty() && vSetHDEReqIds!=null)
    {
    List<AggregateResult> AggregateResultListHD = [SELECT COH_CSHD_Evaluationrequest__c parent, Sum(Savings__c)amt from Cost_Saving__c WHERE COH_CSHD_Evaluationrequest__c IN:vSetHDEReqIds GROUP BY COH_CSHD_Evaluationrequest__c];
    Map<id, HD_Evaluation_Request__c> vMapIdHDERequests= new Map<id, HD_Evaluation_Request__c>([SELECT id,Cost_Savings_Added__c,Program_Cost__c,ROI__c from HD_Evaluation_Request__c WHERE id IN: vSetHDEReqIds]);
    for(AggregateResult vAgg : AggregateResultListHD)
    {
        Id vId = (id) vAgg.get('parent');
        if(vAgg.get('parent')==vMapIdHDERequests.get(vId).id)
        {           
            vMapIdHDERequests.get(vId).Projected_Savings__c = (Decimal) vAgg.get('amt');
            if(vMapIdHDERequests.get(vId).Program_Cost__c==NULL || vMapIdHDERequests.get(vId).Program_Cost__c==0)
            {
                vMapIdHDERequests.get(vId).ROI__c = (Decimal) vAgg.get('amt') / 1;
            }
            else vMapIdHDERequests.get(vId).ROI__c = (Decimal) vAgg.get('amt') / vMapIdHDERequests.get(vId).Program_Cost__c;
        }
    }
    List<HD_Evaluation_Request__c> vListHDERequests = New list<HD_Evaluation_Request__c>();
    vListHDERequests=vMapIdHDERequests.values();
    for(HD_Evaluation_Request__c vERequest : vListHDERequests)
    {
        vERequest.Cost_Savings_Added__c=true;
    }
    if(! vListHDERequests.isEmpty())
    {
        UPDATE vListHDERequests;
    }
    }
    
    //for City Of Hope Evaluation request update:
    set<Id> vSetCOHEReqIds = new set<Id>();
    for(Cost_Saving__c vCostSaving : trigger.isInsert ? trigger.new : trigger.old)
    {
        if(vCostSaving.COH_Evaluation_Request__c!=null)
        {
        vSetCOHEReqIds .add(vCostSaving.COH_Evaluation_Request__c);
        }
    }
    if(!vSetCOHEReqIds.isEmpty() && vSetCOHEReqIds!=null)
    {
    List<AggregateResult> AggregateResultListCOH = [SELECT COH_Evaluation_Request__c parent, Sum(Savings__c)amt from Cost_Saving__c WHERE COH_Evaluation_Request__c IN:vSetCOHEReqIds GROUP BY COH_Evaluation_Request__c];
    Map<id, COH_Evaluation_Request__c> vMapIdCOHERequests= new Map<id, COH_Evaluation_Request__c>([SELECT id,Cost_Savings_Added__c,Program_Cost__c,ROI__c from COH_Evaluation_Request__c WHERE id IN: vSetCOHEReqIds]);
    for(AggregateResult vAgg : AggregateResultListCOH)
    {
        Id vId = (id) vAgg.get('parent');
        if(vAgg.get('parent')==vMapIdCOHERequests.get(vId).id)
        {           
            vMapIdCOHERequests.get(vId).Projected_Savings__c = (Decimal) vAgg.get('amt');
            if(vMapIdCOHERequests.get(vId).Program_Cost__c==NULL || vMapIdCOHERequests.get(vId).Program_Cost__c==0)
            {
                vMapIdCOHERequests.get(vId).ROI__c = (Decimal) vAgg.get('amt') / 1;
            }
            else vMapIdCOHERequests.get(vId).ROI__c = (Decimal) vAgg.get('amt') / vMapIdCOHERequests.get(vId).Program_Cost__c;
        }
    }
    List<COH_Evaluation_Request__c> vListCOHERequests = New list<COH_Evaluation_Request__c>();
    vListCOHERequests=vMapIdCOHERequests.values();
    for(COH_Evaluation_Request__c vERequest : vListCOHERequests)
    {
        vERequest.Cost_Savings_Added__c=true;
    }
    if(! vListCOHERequests.isEmpty())
    {
        UPDATE vListCOHERequests;
    }
    }
    /*
     // Voya Evaluation request update
	set<Id> vSetVOReqIds = new set<Id>();
    for(Cost_Saving__c vCostSaving : trigger.isInsert ? trigger.new : trigger.old)
    {
        if(vCostSaving.COH_CSVO_Evaluation_Request__c!=null)
        {
        vSetVOReqIds .add(vCostSaving.COH_CSVO_Evaluation_Request__c);
        }
    }
    if(!vSetVOReqIds.isEmpty() && vSetVOReqIds!=null)
    {
    List<AggregateResult> AggregateResultListVO = [SELECT COH_CSVO_Evaluation_Request__c parent, Sum(Savings__c)amt from Cost_Saving__c WHERE COH_CSVO_Evaluation_Request__c IN:vSetVOReqIds GROUP BY COH_CSVO_Evaluation_Request__c];
    Map<id, VO_Evaluation_Request__c> vMapIdVORequests= new Map<id, VO_Evaluation_Request__c>([SELECT id,Cost_Savings_Added__c,Program_Cost__c,ROI__c from VO_Evaluation_Request__c WHERE id IN: vSetVOReqIds]);
    for(AggregateResult vAgg : AggregateResultListVO)
    {
        Id vId = (id) vAgg.get('parent');
        if(vAgg.get('parent')==vMapIdVORequests.get(vId).id)
        {           
            vMapIdVORequests.get(vId).Projected_Savings__c = (Decimal) vAgg.get('amt');
            if(vMapIdVORequests.get(vId).Program_Cost__c==NULL || vMapIdVORequests.get(vId).Program_Cost__c==0)
            {
                vMapIdVORequests.get(vId).ROI__c = (Decimal) vAgg.get('amt') / 1;
            }
            else vMapIdVORequests.get(vId).ROI__c = (Decimal) vAgg.get('amt') / vMapIdVORequests.get(vId).Program_Cost__c;
        }
    }
    List<VO_Evaluation_Request__c> vListVORequests = New list<VO_Evaluation_Request__c>();
    vListVORequests=vMapIdVORequests.values();
    for(VO_Evaluation_Request__c vERequest : vListVORequests)
    {
        vERequest.Cost_Savings_Added__c=true;
    }
    if(! vListVORequests.isEmpty())
    {
        UPDATE vListVORequests;
    }
    }
    */
   // Sysco Evaluation Request Update
    set<Id> SYReqIds = new set<Id>();
    for(Cost_Saving__c SYCostSaving : trigger.isInsert ? trigger.new : trigger.old)
    {
        if(SYCostSaving.SY_Evaluation_Request__c!=null)
        {
        SYReqIds .add(SYCostSaving.SY_Evaluation_Request__c);
        }
    }
    if(!SYReqIds.isEmpty() && SYReqIds!=null)
    {
    List<AggregateResult> AggregateResultListSY = [SELECT SY_Evaluation_Request__c parent, Sum(Savings__c)amt from Cost_Saving__c WHERE SY_Evaluation_Request__c IN:SYReqIds GROUP BY SY_Evaluation_Request__c];
    Map<id, SY_Evaluation_Request__c> vMapIdSYRequests= new Map<id, SY_Evaluation_Request__c>([SELECT id,Cost_Savings_Added__c,Program_Cost__c,ROI__c from SY_Evaluation_Request__c WHERE id IN: SYReqIds]);
    for(AggregateResult SYAgg : AggregateResultListSY)
    {
        Id SYId = (id) SYAgg.get('parent');
        if(SYAgg.get('parent')==vMapIdSYRequests.get(SYId).id)
        {           
            vMapIdSYRequests.get(SYId).Projected_Savings__c = (Decimal) SYAgg.get('amt');
            if(vMapIdSYRequests.get(SYId).Program_Cost__c==NULL || vMapIdSYRequests.get(SYId).Program_Cost__c==0)
            {
                vMapIdSYRequests.get(SYId).ROI__c = (Decimal) SYAgg.get('amt') / 1;
            }
            else vMapIdSYRequests.get(SYId).ROI__c = (Decimal) SYAgg.get('amt') / vMapIdSYRequests.get(SYId).Program_Cost__c;
        }
    }
    List<SY_Evaluation_Request__c> vListSYRequests = New list<SY_Evaluation_Request__c>();
    vListSYRequests=vMapIdSYRequests.values();
    for(SY_Evaluation_Request__c SYERequest : vListSYRequests)
    {
        SYERequest.Cost_Savings_Added__c=true;
    }
    if(! vListSYRequests.isEmpty())
    {
        UPDATE vListSYRequests;
    }
    } 
    //Plymouth Rock Evaluation Request
    set<Id> PRreqIds = new set<Id>();
    for(Cost_Saving__c PRCostSaving : trigger.isInsert ? trigger.new : trigger.old)
    {
        if(PRCostSaving.PR_Evaluation_Request__c!=null)
        {
        PRreqIds .add(PRCostSaving.PR_Evaluation_Request__c);
        }
    }
    if(!PRreqIds.isEmpty() && PRreqIds!=null)
    {
    List<AggregateResult> AggregateResultListPR = [SELECT PR_Evaluation_Request__c parent, Sum(Savings__c)amt from Cost_Saving__c WHERE PR_Evaluation_Request__c IN:PRreqIds GROUP BY PR_Evaluation_Request__c];
    Map<id, PR_Evaluation_Request__c> vMapIdPRRequests= new Map<id, PR_Evaluation_Request__c>([SELECT id,Cost_Savings_Added__c,Program_Cost__c,ROI__c from PR_Evaluation_Request__c WHERE id IN: PRreqIds]);
    for(AggregateResult PRAgg : AggregateResultListPR)
    {
        Id PRId = (id) PRAgg.get('parent');
        if(PRAgg.get('parent')==vMapIdPRRequests.get(PRId).id)
        {           
            vMapIdPRRequests.get(PRId).Projected_Savings__c = (Decimal) PRAgg.get('amt');
            if(vMapIdPRRequests.get(PRId).Program_Cost__c==NULL || vMapIdPRRequests.get(PRId).Program_Cost__c==0)
            {
                vMapIdPRRequests.get(PRId).ROI__c = (Decimal) PRAgg.get('amt') / 1;
            }
            else vMapIdPRRequests.get(PRId).ROI__c = (Decimal) PRAgg.get('amt') / vMapIdPRRequests.get(PRId).Program_Cost__c;
        }
    }
    List<PR_Evaluation_Request__c> vListPRRequests = New list<PR_Evaluation_Request__c>();
    vListPRRequests=vMapIdPRRequests.values();
    for(PR_Evaluation_Request__c PRERequest : vListPRRequests)
    {
        PRERequest.Cost_Savings_Added__c=true;
    }
    if(! vListPRRequests.isEmpty())
    {
        UPDATE vListPRRequests;
    }
    }
    
    // Genentech Evaluation Request Update
    set<Id> GRReqIds = new set<Id>();
    for(Cost_Saving__c GRCostSaving : trigger.isInsert ? trigger.new : trigger.old)
    {
        if(GRCostSaving.GR_Evaluation_Request__c!=null)
        {
        GRReqIds .add(GRCostSaving.GR_Evaluation_Request__c);
        }
    }
    if(!GRReqIds.isEmpty() && GRReqIds!=null)
    {
    List<AggregateResult> AggregateResultListGR = [SELECT GR_Evaluation_Request__c parent, Sum(Savings__c)amt from Cost_Saving__c WHERE GR_Evaluation_Request__c IN:GRReqIds GROUP BY GR_Evaluation_Request__c];
    Map<id, GR_Evaluation_Request__c> vMapIdGRRequests= new Map<id, GR_Evaluation_Request__c>([SELECT id,Cost_Savings_Added__c,Program_Cost__c,ROI__c from GR_Evaluation_Request__c WHERE id IN: GRReqIds]);
    for(AggregateResult SYAgg : AggregateResultListGR)
    {
        Id GRId = (id) SYAgg.get('parent');
        if(SYAgg.get('parent')==vMapIdGRRequests.get(GRId).id)
        {           
            vMapIdGRRequests.get(GRId).Projected_Savings__c = (Decimal) SYAgg.get('amt');
            if(vMapIdGRRequests.get(GRId).Program_Cost__c==NULL || vMapIdGRRequests.get(GRId).Program_Cost__c==0)
            {
                vMapIdGRRequests.get(GRId).ROI__c = (Decimal) SYAgg.get('amt') / 1;
            }
            else vMapIdGRRequests.get(GRId).ROI__c = (Decimal) SYAgg.get('amt') / vMapIdGRRequests.get(GRId).Program_Cost__c;
        }
    }
    List<GR_Evaluation_Request__c> vListGRRequests = New list<GR_Evaluation_Request__c>();
    vListGRRequests=vMapIdGRRequests.values();
    for(GR_Evaluation_Request__c GYERequest : vListGRRequests)
    {
        GYERequest.Cost_Savings_Added__c=true;
    }
    if(! vListGRRequests.isEmpty())
    {
        UPDATE vListGRRequests;
    }
    } 
   
    /*
     * RedBull
     * Vivek
     * 22/01/2020
     * 
     */
    set<Id> rbreqIds = new set<Id>();
     for(Cost_Saving__c rbCostSaving : trigger.isInsert ? trigger.new : trigger.old)
    {
        if(rbCostSaving.RB_Evaluation_Request__c!=null)
        {
        rbreqIds .add(rbCostSaving.RB_Evaluation_Request__c);
        }
    }
    if(!rbreqIds.isEmpty() && rbreqIds!=null)
    {
    List<AggregateResult> AggregateResultListMT = [SELECT RB_Evaluation_Request__c parent, Sum(Savings__c)amt from Cost_Saving__c WHERE RB_Evaluation_Request__c IN:rbreqIds GROUP BY RB_Evaluation_Request__c];
    Map<id, RB_Evaluation_Request__c> vMapIdRBRequests= new Map<id, RB_Evaluation_Request__c>([SELECT id,Cost_Savings_Added__c,Program_Cost__c,ROI__c from RB_Evaluation_Request__c WHERE id IN: rbreqIds]);
    for(AggregateResult rbAgg : AggregateResultListMT)
    {
        Id rbId = (id) rbAgg.get('parent');
        if(rbAgg.get('parent')==vMapIdRBRequests.get(rbId).id)
        {           
            vMapIdRBRequests.get(rbId).Projected_Savings__c = (Decimal) rbAgg.get('amt');
            if(vMapIdRBRequests.get(rbId).Program_Cost__c==NULL || vMapIdRBRequests.get(rbId).Program_Cost__c==0)
            {
                vMapIdRBRequests.get(rbId).ROI__c = (Decimal) rbAgg.get('amt') / 1;
            }
            else vMapIdRBRequests.get(rbId).ROI__c = (Decimal) rbAgg.get('amt') / vMapIdRBRequests.get(rbId).Program_Cost__c;
        }
    }
    List<RB_Evaluation_Request__c> vListRBRequests = New list<RB_Evaluation_Request__c>();
    vListRBRequests=vMapIdRBRequests.values();
    for(RB_Evaluation_Request__c rbERequest : vListRBRequests)
    {
        rbERequest.Cost_Savings_Added__c=true;
    }
    if(! vListRBRequests.isEmpty())
    {
        UPDATE vListRBRequests;
    }
    } 
     
}