/* Formatted on 6/27/2019 11:15:33 AM (QP5 v5.149.1003.31008) */
CREATE OR REPLACE PROCEDURE pr_update_flt_schedule_status (
   flt_num    VARCHAR2,
   status     VARCHAR2)
IS
BEGIN
   IF status = 'E'
   THEN
      UPDATE tb_flght_schdl_bom
         SET fsbom_stts_v = 'En - Route'
       WHERE fsbom_flght_nmbr_v = flt_num;

      UPDATE tb_flght_lst_mstr
         SET FLM_STTS_V = 'En - Route'
       WHERE FLM_FLGHT_NMBR_V = flt_num;
   END IF;

   IF status = 'ED'
   THEN
      UPDATE tb_flght_schdl_bom
         SET fsbom_stts_v = 'En - Route // Delayed'
       WHERE fsbom_flght_nmbr_v = flt_num;

      UPDATE tb_flght_lst_mstr
         SET FLM_STTS_V = 'En - Route // Delayed'
       WHERE FLM_FLGHT_NMBR_V = flt_num;
   END IF;

   IF status = 'L'
   THEN
      UPDATE tb_flght_schdl_bom
         SET fsbom_stts_v = 'Landed'
       WHERE fsbom_flght_nmbr_v = flt_num;

      UPDATE tb_flght_lst_mstr
         SET FLM_STTS_V = 'Landed'
       WHERE FLM_FLGHT_NMBR_V = flt_num;
   END IF;

   IF status = 'D'
   THEN
      UPDATE tb_flght_schdl_bom
         SET fsbom_stts_v = 'Scheduled // Delayed'
       WHERE fsbom_flght_nmbr_v = flt_num;

      UPDATE tb_flght_lst_mstr
         SET FLM_STTS_V = 'Scheduled // Delayed'
       WHERE FLM_FLGHT_NMBR_V = flt_num;
   END IF;

   IF status = 'S'
   THEN
      UPDATE tb_flght_schdl_bom
         SET fsbom_stts_v = 'Scheduled'
       WHERE fsbom_flght_nmbr_v = flt_num;

      UPDATE tb_flght_lst_mstr
         SET FLM_STTS_V = 'Scheduled'
       WHERE FLM_FLGHT_NMBR_V = flt_num;
   END IF;

   IF status = 'C'
   THEN
      UPDATE tb_flght_schdl_bom
         SET fsbom_stts_v = 'Cancelled'
       WHERE fsbom_flght_nmbr_v = flt_num;

      UPDATE tb_flght_lst_mstr
         SET FLM_STTS_V = 'Cancelled'
       WHERE FLM_FLGHT_NMBR_V = flt_num;
   END IF;
END;
/