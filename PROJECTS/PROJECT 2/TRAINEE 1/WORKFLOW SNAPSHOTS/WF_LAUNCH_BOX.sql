declare
  v_itemkey number ;
begin
  v_itemkey :=seq_itemkey_9767.nextval ;  --assign an unique number to identify the workflow instance
  wf_engine.CreateProcess(
		itemtype => 'SPH_G04', -- provide the itemtype of your workflow with in the quotes
		itemkey => v_itemkey ,
		process =>'SPH_G04_PROCESS' -- provide the startup process of your workflow itemtype with in the quotes
	);
                    
    wf_engine.SetItemOwner (
		itemtype      => 'SPH_G04', -- provide the itemtype of your workflow with in the quotes
		itemkey       => v_itemkey,
		owner         => 'ORCL_EBS_FEB19_LC1_14' -- provide your EBS userid with in the quotes to track the status of the instance
                            );
                                   
  wf_engine.Startprocess(
		itemtype => 'SPH_G04' ,  -- provide the itemtype of your workflow with in the quotes
		itemkey => v_itemkey);
 
commit; -- this is must to start the workflow instance
end;