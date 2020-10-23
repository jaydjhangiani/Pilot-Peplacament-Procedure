/* Formatted on 7/1/2019 1:08:50 PM (QP5 v5.149.1003.31008) */
CREATE OR REPLACE PROCEDURE pr_pre_flt_examination (code        VARCHAR2,
                                                    flt_time    DATE,
                                                    BAC         NUMBER)
IS
   flt_num   VARCHAR2 (20);
   desg      VARCHAR2 (20);
   src       VARCHAR2 (20);
   pre       NUMBER;
BEGIN
   SELECT pm_dsgntn_v
     INTO desg
     FROM tb_plt_mstr
    WHERE pM_plt_id_v = code;

   --raise_application_error(-20001,code);


   SELECT pm_flt_nmbr_v
     INTO flt_num
     FROM tb_plt_mstr
    WHERE pm_plt_id_v = code;

   --raise_application_error(-20001,code);

   --raise_application_error(-20001,flt_num);
   SELECT FLM_SRC_V
     INTO src
     FROM tb_flght_lst_mstr
    WHERE FLM_FLGHT_NMBR_V = FLT_NUM;


   IF bac > 0.01
   THEN
      IF src = 'MUMBAI'
      THEN
         UPDATE tb_plt_schdl_bom
            SET psbom_bac_prc_v = bac
          WHERE psbom_plt_id_v = code AND PSBOM_TM_OF_DPRTR_D = flt_time;
      END IF;

      IF src = 'BENGALURU'
      THEN
         UPDATE tb_plt_schdl_blr
            SET psblr_bac_prc_v = bac
          WHERE psblr_plt_id_v = code AND PSBlr_TM_OF_DPRTR_D = flt_time;
      END IF;

      IF src = 'DELHI'
      THEN
         UPDATE tb_plt_schdl_del
            SET psdel_bac_prc_v = bac
          WHERE psdel_plt_id_v = code AND PSdel_TM_OF_DPRTR_D = flt_time;
      END IF;


      pre := 1;

      UPDATE tb_dgca_rcrd
         SET DR_PRE_BAC_PERC_N = bac
       WHERE dr_plt_id_v = code AND DR_TM_OF_DPRTR_D = flt_time;

      --raise_application_error(-20001,bac);
      -- raise_application_error(-20001,flt_time);
      UPDATE tb_dgca_rcrd
         SET dr_post_bac_perc_n = '99'
       WHERE dr_plt_id_v = code AND dr_tm_of_dprtr_d = flt_time;

      UPDATE tb_dgca_rcrd
         SET dr_rslt_v = 'FAIL'
       WHERE dr_plt_id_v = code AND DR_TM_OF_DPRTR_D = flt_time;


      --raise_application_error (-20001, desg);
      pr_replacement (flt_num,
                      desg,
                      flt_time,
                      code,
                      pre);
   ELSE
      UPDATE tb_dgca_rcrd
         SET dr_pre_bac_perc_n = bac
       WHERE dr_plt_id_v = code AND DR_TM_OF_DPRTR_D = flt_time;

      --raise_application_error(-20001,code||' '||bac);

      UPDATE tb_dgca_rcrd
         SET dr_rslt_v = 'PASS'
       WHERE dr_plt_id_v = code AND DR_TM_OF_DPRTR_D = flt_time;

      IF src = 'MUMBAI'
      THEN
         --raise_application_error(-20001,code||' '||bac);
         UPDATE tb_plt_schdl_bom
            SET psbom_bac_prc_v = bac
          WHERE psbom_plt_id_v = code AND psbom_TM_OF_DPRTR_D = flt_time;
      END IF;

      IF src = 'BENGALURU'
      THEN
         UPDATE tb_plt_schdl_blr
            SET psblr_bac_prc_v = bac
          WHERE psblr_plt_id_v = code AND psblr_TM_OF_DPRTR_D = flt_time;
      END IF;

      IF src = 'DELHI'
      THEN
         UPDATE tb_plt_schdl_del
            SET psdel_bac_prc_v = bac
          WHERE psdel_plt_id_v = code AND psdel_TM_OF_DPRTR_D = flt_time;
      END IF;
   END IF;
END;
/