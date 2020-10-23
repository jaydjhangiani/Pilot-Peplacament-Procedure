select * from tb_plt_schdl_bom;
select * from tb_plt_schdl_blr;
select * from tb_plt_schdl_del;
select * from tb_rplcmnt_plt_lst_bom;
select * from tb_rplcmnt_plt_lst_blr;
select * from tb_rplcmnt_plt_lst_del;
select * from tb_dfltr;
select * from tb_dgca_rcrd;

exec PR_pre_flt_examination('9WC110',TO_DATE('2019/06/27 01:45:00','yyyy/mm/dd hh24:mi:ss'),0.065);
exec pr_post_flt_examination('9WC010',TO_DATE('2019/06/27 01:45:00','yyyy/mm/dd hh24:mi:ss'),0.5);

UPDATE tb_rplcmnt_plt_lst_blr
SET 
RPblr_PRRTY_N = 3
where RPblr_PLT_ID_V = '9WC982'