create or replace procedure check_leave_days_9767(itemtype   IN     VARCHAR2,
ITEMKEY    IN     VARCHAR2,ACTID      IN     NUMBER,FUNCMODE   IN     VARCHAR2,RESULT OUT VARCHAR2)
is
  l_leaves number;
begin
IF funcmode = 'RUN'
   THEN
   l_leaves := WF_ENGINE.GETITEMATTRNUMBER(itemtype   => 'LP_9767',
                                    itemkey    => itemkey,
                                    aname      => 'NO_LEAVE_DAYS'
                                  );
    if l_leaves<=2 then
      RESULT := 'COMPLETE:D<=2';
    else
      RESULT := 'COMPLETE:D>2';
    end if;
END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      wf_core.CONTEXT ('wf_test_pkg',
                       'check_leave_days_9767',
                       'Unexpected error in procedure ' || SQLERRM);
      RAISE;
END check_leave_days_9767;
-----------------------------------------


declare
  v_itemkey number ;
begin
  v_itemkey :=seq_itemkey_9767.nextval ;  --assign an unique number to identify the workflow instance
  wf_engine.CreateProcess(
		itemtype => 'LP_9767', -- provide the itemtype of your workflow with in the quotes
		itemkey => v_itemkey ,
		process =>'LP_9767_PROCESS' -- provide the startup process of your workflow itemtype with in the quotes
	);
                    
    wf_engine.SetItemOwner (
		itemtype      => 'LP_9767', -- provide the itemtype of your workflow with in the quotes
		itemkey       => v_itemkey,
		owner         => 'ORCL_EBS_FEB19_LC1_14' -- provide your EBS userid with in the quotes to track the status of the instance
                            );
                                   
  wf_engine.Startprocess(
		itemtype => 'LP_9767' ,  -- provide the itemtype of your workflow with in the quotes
		itemkey => v_itemkey);
 
commit; -- this is must to start the workflow instance
end;