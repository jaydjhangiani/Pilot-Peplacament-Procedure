/* Formatted on 6/25/2019 3:42:13 PM (QP5 v5.149.1003.31008) */
CREATE OR REPLACE TRIGGER tr_dgca_data_bom
   AFTER INSERT or update 
   ON tb_plt_schdl_bom 
   FOR EACH ROW
BEGIN
   INSERT INTO tb_dgca_rcrd
        VALUES (:new.psbom_Plt_ID_v,
                :new.psbom_flght_nmbr_v,
                :new.psbom_Dsgntn_v,
                :new.psbom_src_v,
                :new.psbom_tm_of_dprtr_d,
                :new.psbom_dstntn_v,
                :new.psbom_bac_prc_V,
                -1,
                '');
                update tb_plt_mstr
                set
                PM_TM_OF_FLT_D = :new.psbom_tm_of_dprtr_d
                where  PM_PLT_ID_V = :new.psbom_Plt_ID_v;
                
END;
/

CREATE OR REPLACE TRIGGER tr_dgca_data_blr
   AFTER INSERT or update
   ON tb_plt_schdl_blr
   FOR EACH ROW
BEGIN 
   INSERT INTO tb_dgca_rcrd
        VALUES (:new.psblr_Plt_ID_v,
                :new.psblr_flght_nmbr_v,
                :new.psblr_Dsgntn_v,
                :new.psblr_src_v,
                :new.psblr_tm_of_dprtr_d,
                :new.psblr_dstntn_v,
                :new.psblr_bac_prc_V,
                -1,
                '');
                update tb_plt_mstr
                set
                PM_TM_OF_FLT_D = :new.psblr_tm_of_dprtr_d
               where  PM_PLT_ID_V = :new.psblr_Plt_ID_v;
END;
/

CREATE OR REPLACE TRIGGER tr_dgca_data_del
   AFTER INSERT or update
   ON tb_plt_schdl_del
   FOR EACH ROW
BEGIN
   INSERT INTO tb_dgca_rcrd
        VALUES (:new.psdel_Plt_ID_v,
                :new.psdel_flght_nmbr_v,
                :new.psdel_Dsgntn_v,
                :new.psdel_src_v,
                :new.psdel_tm_of_dprtr_d,
                :new.psdel_dstntn_v,
                :new.psdel_bac_prc_V,
                -1,
                '');
                update tb_plt_mstr
                set
                PM_TM_OF_FLT_D = :new.psdel_tm_of_dprtr_d
                where  PM_PLT_ID_V = :new.psdel_Plt_ID_v;
END;
/