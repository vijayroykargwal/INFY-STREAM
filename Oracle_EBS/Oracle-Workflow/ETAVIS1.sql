declare
  v_itemkey number ;
begin
  v_itemkey :=1039767781 ;  --assign an unique number to identify the workflow instance
  wf_engine.CreateProcess(
		itemtype => 'FYA_9767', -- provide the itemtype of your workflow with in the quotes
		itemkey => v_itemkey ,
		process =>'FYA_9767_PROCESS' -- provide the startup process of your workflow itemtype with in the quotes
	);
                    
    wf_engine.SetItemOwner (
		itemtype      => 'FYA_9767', -- provide the itemtype of your workflow with in the quotes
		itemkey       => v_itemkey,
		owner         => 'ORCL_EBS_FEB19_LC1_14' -- provide your EBS userid with in the quotes to track the status of the instance
                            );
                                   
  wf_engine.Startprocess(
		itemtype => 'FYA_9767' ,  -- provide the itemtype of your workflow with in the quotes
		itemkey => v_itemkey);
 
commit; -- this is must to start the workflow instance
end;













-------------------------------------------------------------------
DROP TABLE XX_ORDER_DETAILS_9767;
CREATE TABLE XX_ORDER_DETAILS_9767
  (
    "ORDER_ID"      VARCHAR2(20 BYTE),
    "CUSTOMER_NAME" VARCHAR2(30 BYTE),
    "COMMENTS"      VARCHAR2(200 BYTE),
    "STATUS"        VARCHAR2(10 BYTE),
    "APPROVER_NAME" VARCHAR2(50 BYTE),
    PRIMARY KEY ("ORDER_ID")
  );
---------------------------------------------------
-----------------------------------------------------------------------------------
/* This PL/SQL procedure is used to be called from Workflow Functions
   Create a sequence for auto-generation of ORDER_ID starting from 1000*/
-----------------------------------------------------------------------------------
create sequence seq_order_id_9767 start with 101;
CREATE OR REPLACE PROCEDURE sp_func_act_9767 (itemtype   IN     VARCHAR2,
                                            ITEMKEY    IN     VARCHAR2,
                                            ACTID      IN     NUMBER,
                                            FUNCMODE   IN     VARCHAR2,
                                            RESULT        OUT VARCHAR2)
IS
   l_customer   VARCHAR2 (50);
   l_business_emp   VARCHAR2 (50);   
   l_order_id VARCHAR2(4);
BEGIN
   IF funcmode = 'RUN'
   THEN
      --Getting the value of attributes
      l_customer :=
         wf_engine.getitemattrtext (itemtype   => 'FYA_9767',
                                    itemkey    => itemkey,
                                    aname      => 'CUSTOMER_PERFORMER');
      l_business_emp :=
         wf_engine.getitemattrtext (itemtype   => 'FYA_9767',
                                    itemkey    => itemkey,
                                    aname      => 'BUSINESS_EMPLOYEE');
     
      l_order_id :=seq_order_id_9767.NEXTVAL;
       WF_ENGINE.SETITEMATTRNUMBER (itemtype   => 'FYA_9767',
                                    itemkey    => itemkey,
                                    aname      => 'OREDR_ID_ATT',
                                    avalue => l_order_id);
      --Inserting order details in XX_ORDER_DETAILS_<your employee ID> table 
      INSERT INTO XX_ORDER_DETAILS_9767 (APPROVER_NAME,CUSTOMER_NAME,ORDER_ID,STATUS,COMMENTS) 
        VALUES (l_business_emp,l_customer,l_order_id,'Pending',NULL);
      
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      wf_core.CONTEXT ('wf_test_pkg',
                       'sp_func_act_9767',
                       'Unexpected error in procedure ' || SQLERRM);
      RAISE;
END sp_func_act_9767;

-----------------------Approved---------------------

CREATE OR REPLACE PROCEDURE sp_func_act_approve_9767 (itemtype   IN     VARCHAR2,
                                            ITEMKEY    IN     VARCHAR2,
                                            ACTID      IN     NUMBER,
                                            FUNCMODE   IN     VARCHAR2,
                                            RESULT        OUT VARCHAR2)
IS
   l_customer   VARCHAR2 (50);
   l_business_emp   VARCHAR2 (50);   
   l_order_id VARCHAR2(4);
BEGIN
   IF funcmode = 'RUN'
   THEN
      --Getting the value of attributes
      l_customer :=
         wf_engine.getitemattrtext (itemtype   => 'FYA_9767',
                                    itemkey    => itemkey,
                                    aname      => 'CUSTOMER_PERFORMER');
      l_business_emp :=
         wf_engine.getitemattrtext (itemtype   => 'FYA_9767',
                                    itemkey    => itemkey,
                                    aname      => 'BUSINESS_EMPLOYEE');
   
        l_order_id :=
         WF_ENGINE.GETITEMATTRNUMBER (itemtype   => 'FYA_9767',
                                    itemkey    => itemkey,
                                    aname      => 'OREDR_ID_ATT'
                                    );
     
     
      
      --Inserting order details in XX_ORDER_DETAILS_<your employee ID> table 
        UPDATE XX_ORDER_DETAILS_9767 set STATUS='APPROVED' where order_id=l_order_id;
      
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      wf_core.CONTEXT ('wf_test_pkg',
                       'sp_func_act_9767',
                       'Unexpected error in procedure ' || SQLERRM);
      RAISE;
END sp_func_act_approve_9767;
-----------------------Reject------------------------------------------------

CREATE OR REPLACE PROCEDURE sp_func_act_reject_9767 (itemtype   IN     VARCHAR2,
                                            ITEMKEY    IN     VARCHAR2,
                                            ACTID      IN     NUMBER,
                                            FUNCMODE   IN     VARCHAR2,
                                            RESULT        OUT VARCHAR2)
IS
   l_customer   VARCHAR2 (50);
   l_business_emp   VARCHAR2 (50);   
   l_order_id VARCHAR2(4);
BEGIN
   IF funcmode = 'RUN'
   THEN
      --Getting the value of attributes
      l_customer :=
         wf_engine.getitemattrtext (itemtype   => 'FYA_9767',
                                    itemkey    => itemkey,
                                    aname      => 'CUSTOMER_PERFORMER');
      l_business_emp :=
         wf_engine.getitemattrtext (itemtype   => 'FYA_9767',
                                    itemkey    => itemkey,
                                    aname      => 'BUSINESS_EMPLOYEE');
     
       l_order_id:=WF_ENGINE.GETITEMATTRNUMBER (itemtype   => 'FYA_9767',
                                    itemkey    => itemkey,
                                    aname      => 'OREDR_ID_ATT'
                                  );
      --Inserting order details in XX_ORDER_DETAILS_<your employee ID> table 
        UPDATE XX_ORDER_DETAILS_9767 set STATUS='REJECTED' where order_id=l_order_id;
      
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      wf_core.CONTEXT ('wf_test_pkg',
                       'sp_func_act_9767',
                       'Unexpected error in procedure ' || SQLERRM);
      RAISE;
END sp_func_act_reject_9767;


select * from XX_ORDER_DETAILS_9767;