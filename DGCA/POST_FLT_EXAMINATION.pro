/* Formatted on 6/27/2019 4:14:39 PM (QP5 v5.149.1003.31008) */
CREATE OR REPLACE PROCEDURE pr_post_flt_examination (code        VARCHAR2,
                                                     flt_time    DATE,
                                                     bac         NUMBER)
IS
   desg      VARCHAR2 (20);
   destntn      VARCHAR2 (20);
   flt_num   VARCHAR2 (20);
   post number;
   pre number;
BEGIN
  SELECT  pm_dsgntn_v
     INTO desg
     FROM tb_plt_mstr
    WHERE pM_plt_id_v = code ;
   --raise_application_error(-20001,code); 
   
  
    SELECT pm_flt_nmbr_v
     INTO flt_num
     FROM  tb_plt_mstr
    WHERE  pm_plt_id_v = code;


    select dr_pre_bac_perc_n into pre from  tb_dgca_rcrd
        WHERE dr_plt_id_v = code AND DR_TM_OF_DPRTR_D = flt_time;
         --raise_application_error(-20001,pre||' '||CODE);

   SELECT  FLM_dstntn_V
     INTO destntn
     FROM tb_flght_lst_mstr
    WHERE FLM_FLGHT_NMBR_V = FLT_NUM ;
   --raise_application_error(-20001,destNTN);
   
      if      pre != -1 then
       IF bac > 0.01
      THEN
      if destntn = 'MUMBAI'
      then
         UPDATE tb_plt_schdl_bom
            SET psbom_bac_prc_v = bac
          WHERE psbom_plt_id_v = code AND PSBOM_TM_OF_DPRTR_D = flt_time;
       end if;
       
       if destntn = 'BENGALURU'
      then
         UPDATE tb_plt_schdl_blr
            SET psblr_bac_prc_v = bac
          WHERE psblr_plt_id_v = code AND PSBlr_TM_OF_DPRTR_D = flt_time;
       end if;
      
      if destntn = 'DELHI'
      then
         UPDATE tb_plt_schdl_del
            SET psdel_bac_prc_v = bac
          WHERE psdel_plt_id_v = code AND PSdel_TM_OF_DPRTR_D = flt_time;
       end if;
         
         UPDATE tb_dgca_rcrd
            SET dr_post_bac_perc_n = bac
          WHERE dr_plt_id_v = code AND DR_TM_OF_DPRTR_D = flt_time;


         UPDATE tb_dgca_rcrd
            SET dr_rslt_v = 'FPOST'
          WHERE dr_plt_id_v = code AND DR_TM_OF_DPRTR_D = flt_time;
          
          post := 2;

         pr_replacement (flt_num,
                         desg,
                         flt_time,
                         code,post);
      ELSE
        

        UPDATE tb_dgca_rcrd
            SET dr_post_bac_perc_n = bac
          WHERE dr_plt_id_v = code AND DR_TM_OF_DPRTR_D = flt_time;

         UPDATE tb_dgca_rcrd
            SET dr_rslt_v = 'PASS'
          WHERE dr_plt_id_v = code AND DR_TM_OF_DPRTR_D = flt_time;
           end if; 
          else
          
          raise_application_error(-20001,'INVALID ENTRY !!! // PRE FLT EXAMINATION RECORD NOT UPDATED!!!');
       

         
      END IF;


END;
/


