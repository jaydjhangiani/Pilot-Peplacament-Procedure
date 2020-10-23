create or replace procedure pr_update_flt_admin is
begin

update tb_flght_admn_bom
set fabom_mx_spr_sv_n = 10
where fabom_flght_nmbr_v = '9W222';
update tb_flght_admn_bom
set fabom_mx_ec_flx_n = 5
where fabom_flght_nmbr_v = '9W222';
update tb_flght_admn_bom
set fabom_mx_clb_n = 5
where fabom_flght_nmbr_v = '9W222';
update tb_flght_admn_bom
set fabom_jmp_sts_lft_n = 1
where fabom_flght_nmbr_v = '9W222';

update tb_flght_admn_bom
set fabom_mx_spr_sv_n = 400
where fabom_flght_nmbr_v = '9W812';
update tb_flght_admn_bom
set fabom_mx_ec_flx_n = 64
where fabom_flght_nmbr_v = '9W812';
update tb_flght_admn_bom
set fabom_mx_clb_n = 30
where fabom_flght_nmbr_v = '9W812';
update tb_flght_admn_bom
set fabom_jmp_sts_lft_n = 4
where fabom_flght_nmbr_v = '9W812';

update tb_flght_admn_bom
set fabom_mx_spr_sv_n = 400
where fabom_flght_nmbr_v = '9W420';
update tb_flght_admn_bom
set fabom_mx_ec_flx_n = 64
where fabom_flght_nmbr_v = '9W420';
update tb_flght_admn_bom
set fabom_mx_clb_n = 30
where fabom_flght_nmbr_v = '9W420';
update tb_flght_admn_bom
set fabom_jmp_sts_lft_n = 4
where fabom_flght_nmbr_v = '9W420';

update tb_flght_admn_bom
set fabom_mx_spr_sv_n = 400
where fabom_flght_nmbr_v = '9W231';
update tb_flght_admn_bom
set fabom_mx_ec_flx_n = 64
where fabom_flght_nmbr_v = '9W231';
update tb_flght_admn_bom
set fabom_mx_clb_n = 30
where fabom_flght_nmbr_v = '9W231';
update tb_flght_admn_bom
set fabom_jmp_sts_lft_n = 4
where fabom_flght_nmbr_v = '9W231';

update tb_flght_admn_bom
set fabom_mx_spr_sv_n = 130
where fabom_flght_nmbr_v = '9W150';
update tb_flght_admn_bom
set fabom_mx_ec_flx_n = 20
where fabom_flght_nmbr_v = '9W150';
update tb_flght_admn_bom
set fabom_mx_clb_n = 20
where fabom_flght_nmbr_v = '9W150';
update tb_flght_admn_bom
set fabom_jmp_sts_lft_n = 3
where fabom_flght_nmbr_v = '9W150';


END;
/