create or replace procedure Val_req_dtl_func_9767(itemtype   IN     VARCHAR2,
ITEMKEY    IN     VARCHAR2,ACTID      IN     NUMBER,FUNCMODE   IN     VARCHAR2,RESULT OUT VARCHAR2)
is
  l_item_name varchar2(100);
  l_inventory varchar2(100);
  l_quantity number;
  l_count_item number;
  l_count_inventory number;
  l_item_id number;
  l_qnty number;
  l_loc_id number;
begin
IF funcmode = 'RUN'
   THEN
   l_quantity := WF_ENGINE.GETITEMATTRNUMBER(itemtype   => 'IRI_9767',
                                    itemkey    => itemkey,
                                    aname      => 'QUANTITY'
                                  );
  l_inventory :=  WF_ENGINE.GETITEMATTRTEXT(itemtype   => 'IRI_9767',
                                    itemkey    => itemkey,
                                    aname      => 'INVENTORY'
                                  );
   l_item_name :=  WF_ENGINE.GETITEMATTRTEXT(itemtype   => 'IRI_9767',
                                    itemkey    => itemkey,
                                    aname      => 'ITEM_NAME'
                                  );
    select count(item_name) into l_count_item from XX_IRSO_ITEMS where item_name = l_item_name;
    select count(loc_name) into l_count_inventory from XX_IRSO_LOCATIONS where loc_name = l_inventory;
    
    if l_count_item > 0 then
       if l_count_inventory > 0 then
          select item_id into l_item_id from XX_IRSO_ITEMS where item_name = l_item_name;
          select loc_id into l_loc_id from XX_IRSO_LOCATIONS where loc_name = l_inventory;
          select quantity into l_qnty from XX_IRSO_INVENTORY where item_id = l_item_id and loc_id = l_loc_id;
          if l_qnty >= l_quantity then
            update XX_IRSO_INVENTORY_9767 set quantity = quantity - l_quantity  
            where item_id = l_item_id and loc_id = l_loc_id;
            RESULT := 'COMPLETE:V';
          else
            RESULT :='COMPLETE:QNTY_UA';
          end if;
       else
            RESULT :='COMPLETE:ININ';
          end if;
      else
          RESULT :='COMPLETE:INIT';
      end if;
            
END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      wf_core.CONTEXT ('wf_test_pkg',
                       'Val_req_dtl_func_9767',
                       'Unexpected error in procedure ' || SQLERRM);
      RAISE;
END Val_req_dtl_func_9767;



select * from XX_IRSO_INVENTORY 
select * from XX_IRSO_LOCATIONS
select * from XX_IRSO_ITEMS
select * from XX_IRSO_INVENTORY_9767
create table XX_IRSO_INVENTORY_9767 as (select * from XX_IRSO_INVENTORY);






-----------------------------------------
declare
  v_itemkey number ;
begin
  v_itemkey :=seq_itemkey_9767.nextval ;  --assign an unique number to identify the workflow instance
  wf_engine.CreateProcess(
		itemtype => 'IRI_9767', -- provide the itemtype of your workflow with in the quotes
		itemkey => v_itemkey ,
		process =>'IRI_9767_PROCESS' -- provide the startup process of your workflow itemtype with in the quotes
	);
                    
    wf_engine.SetItemOwner (
		itemtype      => 'IRI_9767', -- provide the itemtype of your workflow with in the quotes
		itemkey       => v_itemkey,
		owner         => 'ORCL_EBS_FEB19_LC1_14' -- provide your EBS userid with in the quotes to track the status of the instance
                            );
                                   
  wf_engine.Startprocess(
		itemtype => 'IRI_9767' ,  -- provide the itemtype of your workflow with in the quotes
		itemkey => v_itemkey);
 
commit; -- this is must to start the workflow instance
end;
