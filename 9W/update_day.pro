/* Formatted on 6/25/2019 11:21:22 AM (QP5 v5.149.1003.31008) */
CREATE OR REPLACE PROCEDURE pr_update_day (flt_number    VARCHAR2,
                                             set_date      DATE)
IS
   defaults   NUMBER;
   pilot_id varchar2(20);
BEGIN  
      UPDATE tb_plt_mstr
         SET PM_TM_OF_FLT_D = set_date
       WHERE pm_flght_nmbr_v = flt_number;

      UPDATE tb_flght_schdl_bom
         SET fsbom_tm_of_dprtr_d = set_date
       WHERE fsbom_flght_nmbr_v = flt_number;

      UPDATE tb_plt_schdl_bom
         SET psbom_tm_of_dprtr_d = set_date
       WHERE psbom_flght_nmbr_v = flt_number;

      UPDATE tb_dgca_rcrd
         SET dr_TM_OF_DPRTR_d = set_date
       WHERE dr_flght_nmbr_v = flt_number;

END;
/