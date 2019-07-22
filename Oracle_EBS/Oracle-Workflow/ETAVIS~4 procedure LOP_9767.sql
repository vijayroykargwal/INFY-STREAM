create or replace procedure VAL_LD_FUNC_9767(itemtype   IN     VARCHAR2,
ITEMKEY    IN     VARCHAR2,ACTID      IN     NUMBER,FUNCMODE   IN     VARCHAR2,RESULT OUT VARCHAR2)
is
  l_loan_amount number;
  l_emi number;
  l_la_per_emi number;
begin
IF funcmode = 'RUN'
   THEN
   l_loan_amount := WF_ENGINE.GETITEMATTRNUMBER(itemtype   => 'LOP_9767',
                                    itemkey    => itemkey,
                                    aname      => 'LOAN_AMOUNT'
                                  );
                                  
   l_emi := WF_ENGINE.GETITEMATTRNUMBER(itemtype   => 'LOP_9767',
                                    itemkey    => itemkey,
                                    aname      => 'NO_OF_EMIS'
                                  );
  if l_loan_amount<=10000 then
     RESULT:= 'COMPLETE:REJ_LA';
  elsif l_emi >6 then
    RESULT:='COMPLETE:REJ_EMI';
  else 
    if l_loan_amount>10000 and l_loan_amount<=20000 then
          RESULT := 'COMPLETE:LA-20000';
    elsif l_loan_amount>20000 then
          RESULT := 'COMPLETE:LA>20000';
    end if;
  l_la_per_emi := l_loan_amount/l_emi;
  WF_ENGINE.SETITEMATTRNUMBER(itemtype   => 'LOP_9767',
                              itemkey    => itemkey,
                              aname      => 'PAID_AMOUNT',
                              avalue => l_la_per_emi
                                  );
          end if;
END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      wf_core.CONTEXT ('wf_test_pkg',
                       'VAL_LD_FUNC_9767',
                       'Unexpected error in procedure ' || SQLERRM);
      RAISE;
END VAL_LD_FUNC_9767;


-----------------------------


declare
  v_itemkey number ;
begin
  v_itemkey :=seq_itemkey_9767.nextval ;  --assign an unique number to identify the workflow instance
  wf_engine.CreateProcess(
		itemtype => 'LOP_9767', -- provide the itemtype of your workflow with in the quotes
		itemkey => v_itemkey ,
		process =>'LOP_9767_PROCESS' -- provide the startup process of your workflow itemtype with in the quotes
	);
                    
    wf_engine.SetItemOwner (
		itemtype      => 'LOP_9767', -- provide the itemtype of your workflow with in the quotes
		itemkey       => v_itemkey,
		owner         => 'ORCL_EBS_FEB19_LC1_14' -- provide your EBS userid with in the quotes to track the status of the instance
                            );
                                   
  wf_engine.Startprocess(
		itemtype => 'LOP_9767' ,  -- provide the itemtype of your workflow with in the quotes
		itemkey => v_itemkey);
 
commit; -- this is must to start the workflow instance
end;