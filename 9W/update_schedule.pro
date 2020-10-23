/* Formatted on 6/26/2019 1:24:59 PM (QP5 v5.149.1003.31008) */
CREATE OR REPLACE PROCEDURE pr_update_schedule (pilot_id         VARCHAR2,
                                                flt_num          VARCHAR2,
                                                flt_time         DATE,
                                                next_flt_time    DATE)
IS
   no_d   NUMBER;
   desg   VARCHAR2 (20);
   src    VARCHAR2 (30);
   dest   VARCHAR2 (30);
BEGIN
   SELECT flm_src_v
     INTO src
     FROM tb_flght_lst_mstr
    WHERE flm_flght_nmbr_v = flt_num;

   SELECT flm_DSTNTN_V
     INTO dest
     FROM tb_flght_lst_mstr
    WHERE flm_flght_nmbr_v = flt_num;

   SELECT pm_nmbr_of_dflts_n
     INTO no_d
     FROM tb_plt_mstr
    WHERE pm_plt_id_v = pilot_id;

   SELECT pm_dsgntn_v
     INTO desg
     FROM tb_plt_mstr
    WHERE pm_plt_id_v = pilot_id;

   --raise_application_error(-20001,desg);
   IF no_d = 0
   THEN
      UPDATE tb_plt_mstr
         SET pm_tm_of_flt_d = flt_time
       WHERE pm_plt_id_v = pilot_id;

      UPDATE tb_plt_mstr
         SET pm_tm_of_nxt_flt_d = next_flt_time
       WHERE pm_plt_id_v = pilot_id;

      UPDATE tb_plt_mstr
         SET pm_flght_nmbr_v = flt_num
       WHERE pm_plt_id_v = pilot_id;

      --raise_application_error(-20001,dest);
      INSERT INTO tb_plt_schdl_bom
           VALUES (pilot_id,
                   flt_num,
                   desg,
                   src,
                   dest,
                   flt_time,
                   -1);
   ELSE
      raise_application_error (-20001, 'PILOT IS ON LAY OFF PERIOD !!!');
   END IF;
END;
/