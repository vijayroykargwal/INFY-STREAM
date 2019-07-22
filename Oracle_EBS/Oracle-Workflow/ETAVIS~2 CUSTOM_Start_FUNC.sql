create or replace procedure start_func_9767(itemtype   IN     VARCHAR2,
ITEMKEY    IN     VARCHAR2,ACTID      IN     NUMBER,FUNCMODE   IN     VARCHAR2,RESULT OUT VARCHAR2)
IS
  l_user   VARCHAR2(200);  
BEGIN
   IF funcmode = 'RUN'
   THEN
      --Getting the value of attributes
      l_user := fnd_profile.value('USER_ID');
     WF_ENGINE.SETITEMATTRTEXT (itemtype   => 'FYA_9767',
                                    itemkey    => itemkey,
                                    aname      => 'USER_FYA_9767',
                                    avalue => l_user
                                  );
      --Inserting order details in XX_ORDER_DETAILS_<your employee ID> table     
   END IF;
   
EXCEPTION
   WHEN OTHERS
   THEN
      wf_core.CONTEXT ('wf_test_pkg',
                       'start_func_9767',
                       'Unexpected error in procedure ' || SQLERRM);
      RAISE;
END start_func_9767;
