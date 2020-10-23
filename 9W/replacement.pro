/* Formatted on 6/29/2019 4:57:23 PM (QP5 v5.149.1003.31008) */
CREATE OR REPLACE PROCEDURE pr_replacement (flt_num     VARCHAR2,
                                            desg        VARCHAR2,
                                            flt_time    DATE,
                                            d_code      VARCHAR2,
                                            num         NUMBER)
IS
   CURSOR rep_blr (
      vl_dsgntn_v     VARCHAR2,
      vl_r_grade_v    VARCHAR2,
      vl_prrty_n      NUMBER)
   IS
      SELECT RPBLR_PLT_ID_V
        FROM TB_RPLCMNT_PLT_LST_BLR
       WHERE     RPBLR_DSGNTN_V = vl_dsgntn_v
             AND RPBLR_ARCRFT_LCNS_GRD_V = vl_r_grade_v
             AND RPBLR_PRRTY_N = vl_prrty_n;

   CURSOR rep_del (
      vl_dsgntn_v     VARCHAR2,
      vl_r_grade_v    VARCHAR2,
      vl_prrty_n      NUMBER)
   IS
      SELECT RPdel_PLT_ID_V
        FROM TB_RPLCMNT_PLT_LST_del
       WHERE     RPdel_DSGNTN_V = vl_dsgntn_v
             AND RPdel_ARCRFT_LCNS_GRD_V = vl_r_grade_v
             AND RPdel_PRRTY_N = vl_prrty_n;

   CURSOR rep_bom (
      vl_dsgntn_v     VARCHAR2,
      vl_r_grade_v    VARCHAR2,
      vl_prrty_n      NUMBER)
   IS
      SELECT RPbom_PLT_ID_V
        FROM TB_RPLCMNT_PLT_LST_bom
       WHERE     RPbom_DSGNTN_V = vl_dsgntn_v
             AND RPbom_ARCRFT_LCNS_GRD_V = vl_r_grade_v
             AND rpbom_prrty_n = vl_prrty_n;

   avail            VARCHAR2 (10);
   flt_type         VARCHAR2 (20);
   r_code           VARCHAR2 (20);                               --replacement
   r_grade          VARCHAR2 (20);
   time_date        DATE;
   next_time_date   DATE;
   p_name           VARCHAR2 (50);
   no_d             NUMBER;
   dest             VARCHAR2 (20);
   src              VARCHAR2 (20);
   priority         NUMBER;
   r_code_bom       VARCHAR2 (20);
   r_code_del       VARCHAR (20);
   r_code_blr       TB_RPLCMNT_PLT_LST_BLR.RPBLR_PLT_ID_V%TYPE;
BEGIN
   --raise_application_error(-20001,d_code);

   SELECT pm_arcrft_lcns_grd_v
     INTO r_grade
     FROM tb_plt_mstr
    WHERE pm_plt_id_v = d_code;

   -- raise_application_error(-20001,r_grade);
   SELECT fsbom_TM_OF_DPRTR_d
     INTO time_date
     FROM tb_flght_schdl_bom
    WHERE fsbom_flght_nmbr_v = flt_num;

   --raise_application_error(-20001,time_date);


   --raise_application_error(-20001,d_code);
   SELECT FLM_DSTNTN_V
     INTO dest
     FROM tb_flght_lst_mstr
    WHERE FLM_FLGHT_NMBR_V = FLT_NUM;

   --raise_application_error(-20001,d_code);
   SELECT FLM_SRC_V
     INTO src
     FROM tb_flght_lst_mstr
    WHERE FLM_FLGHT_NMBR_V = FLT_NUM;

   SELECT pm_plt_nm_v
     INTO p_name
     FROM tb_plt_mstr
    WHERE PM_PLT_ID_V = d_code;

   SELECT PM_NMBR_OF_DFLTS_N
     INTO no_d
     FROM tb_plt_mstr
    WHERE PM_PLT_ID_V = d_code;

   SELECT PM_TM_OF_NXT_FLT_D
     INTO next_time_date
     FROM tb_plt_mstr
    WHERE PM_PLT_ID_V = d_code;

   --raise_application_error(-20001,R_code);
   --select RPBOM_PRRTY_N into priority from tb_rplcmnt_plt_lst_bom where RPBOM_ARCRFT_LCNS_GRD_V = r_grade ;

   --raise_application_error(-20001,priority);
   IF num = 1
   THEN
      IF src = 'MUMBAI'
      THEN
         FOR i IN 1 .. 5
         LOOP
            priority := i;

            -- raise_application_error(-20001,priority);

            OPEN rep_bom (desg, r_grade, priority);

            --raise_application_error (-20002, desg||' '||r_grade||' '||priority);


            FETCH rep_bom INTO r_code_bom;

            -- raise_application_error(-20003,r_code_bom);
            CLOSE rep_bom;

            IF r_code_bom IS NULL
            THEN
               raise_application_error (-20001, 'INVALID ENTRY!!!');
            END IF;


            UPDATE tb_rplcmnt_plt_lst_bom
               SET RPBOM_PRRTY_N = RPBOM_PRRTY_N - 1
             WHERE rpbom_ARCRFT_LCNS_GRD_v = r_grade
                   AND rpbom_dsgntn_v = desg;

            --raise_application_error(-20001,priority);
            IF r_code_bom IS NOT NULL
            THEN
               EXIT;
            END IF;
         END LOOP;

         SELECT rpbom_avlbl_V
           INTO avail
           FROM tb_rplcmnt_plt_lst_bom
          WHERE RPBOM_PLT_ID_V = r_code_bom;



         -- raise_application_error(-20001,next_time_date);

         IF avail = 'YES'
         THEN
            --raise_application_error(-20001,d_code);
            DELETE FROM tb_plt_schdl_bom
                  WHERE psbom_plt_id_v = d_code
                        AND psbom_flght_nmbr_v = flt_num;

            IF desg = 'COMMANDER'
            THEN
               UPDATE tb_flght_admn_bom
                  SET fabom_cptn_id_v = r_code_bom
                WHERE fabom_flght_nmbr_v = flt_num;
            END IF;

            INSERT INTO tb_plt_schdl_bom
                 VALUES (r_code_bom,
                         flt_num,
                         desg,
                         src,
                         dest,
                         time_date,
                         -1);


            --raise_application_error(-20001,'hi!, my name is error !! ');
            UPDATE tb_dgca_rcrd
               SET dr_rslt_v = 'R*'
             WHERE dr_plt_id_v = r_code_bom;

            DELETE FROM tb_rplcmnt_plt_lst_bom
                  WHERE rpbom_plt_id_v = r_code_bom;

            r_code_bom := r_code;
         END IF;
      END IF;


      IF src = 'BENGALURU'
      THEN
         FOR i IN 1 .. 5
         LOOP
            priority := i;

            -- raise_application_error(-20001,r_grade);



            --            BEGIN
            OPEN rep_blr (desg, r_grade, priority);

            --raise_application_error (-20002, desg||' '||r_grade||' '||priority);


            FETCH rep_blr INTO r_code_blr;

            --               raise_application_error(-20003,r_code_blr);
            CLOSE rep_blr;

            IF r_code_blr IS NULL
            THEN
               raise_application_error (-20001, 'INVALID ENTRY!!!');
            END IF;

            --            END;



            UPDATE tb_rplcmnt_plt_lst_blr
               SET RPBlr_PRRTY_N = RPBlr_PRRTY_N - 1
             WHERE rpblr_ARCRFT_LCNS_GRD_v = r_grade
                   AND rpblr_dsgntn_v = desg;

            --raise_application_error(-20001,priority);
            IF r_code IS NOT NULL
            THEN
               EXIT;
            END IF;
         END LOOP;

         SELECT rpblr_avlbl_V
           INTO avail
           FROM tb_rplcmnt_plt_lst_blr
          WHERE RPblr_PLT_ID_V = r_code_blr;



         -- raise_application_error(-20001,next_time_date);

         IF avail = 'YES'
         THEN
            --raise_application_error(-20001,d_code);
            DELETE FROM tb_plt_schdl_blr
                  WHERE psblr_plt_id_v = d_code
                        AND psblr_flght_nmbr_v = flt_num;



            INSERT INTO tb_plt_schdl_blr
                 VALUES (r_code_blr,
                         flt_num,
                         desg,
                         src,
                         dest,
                         time_date,
                         -1);


            --raise_application_error(-20001,'hi!, my name is error !! ');
            UPDATE tb_dgca_rcrd
               SET dr_rslt_v = 'R*'
             WHERE dr_plt_id_v = r_code_blr;

            DELETE FROM tb_rplcmnt_plt_lst_blr
                  WHERE rpblr_plt_id_v = r_code_blr;

            r_code := r_code_blr;
         END IF;
      END IF;

      IF src = 'DELHI'
      THEN
         FOR i IN 1 .. 5
         LOOP
            priority := i;

            -- raise_application_error(-20001,priority);

            OPEN rep_del (desg, r_grade, priority);

            --raise_application_error (-20002, desg||' '||r_grade||' '||priority);


            FETCH rep_del INTO r_code_del;

            --               raise_application_error(-20003,r_code_blr);
            CLOSE rep_del;

            IF r_code_del IS NULL
            THEN
               raise_application_error (-20001, 'INVALID ENTRY!!!');
            END IF;

            UPDATE tb_rplcmnt_plt_lst_del
               SET RPdel_PRRTY_N = RPdel_PRRTY_N - 1
             WHERE rpdel_ARCRFT_LCNS_GRD_v = r_grade
                   AND rpdel_dsgntn_v = desg;

            --raise_application_error(-20001,r_code);
            IF r_code IS NOT NULL
            THEN
               EXIT;
            END IF;
         END LOOP;

         SELECT rpdel_avlbl_V
           INTO avail
           FROM tb_rplcmnt_plt_lst_del
          WHERE RPdel_PLT_ID_V = r_code_del;



         -- raise_application_error(-20001,next_time_date);

         IF avail = 'YES'
         THEN
            --raise_application_error(-20001,d_code);
            DELETE FROM tb_plt_schdl_del
                  WHERE psdel_plt_id_v = d_code
                        AND psdel_flght_nmbr_v = flt_num;



            INSERT INTO tb_plt_schdl_del
                 VALUES (r_code_del,
                         flt_num,
                         desg,
                         src,
                         dest,
                         time_date,
                         -1);


            --raise_application_error(-20001,'hi!, my name is error !! ');
            UPDATE tb_dgca_rcrd
               SET dr_rslt_v = 'R*'
             WHERE dr_plt_id_v = r_code_del;

            DELETE FROM tb_rplcmnt_plt_lst_del
                  WHERE rpdel_plt_id_v = r_code_del;
         END IF;

         r_code := r_code_del;
      END IF;



      IF no_d = 2
      THEN
         no_d := no_d + 1;

         UPDATE tb_plt_mstr
            SET PM_TM_OF_FLT_D = time_date
          WHERE PM_PLT_ID_V = d_code;

         UPDATE tb_plt_mstr
            SET PM_TM_OF_NXT_FLT_D = '31-DEC-9999'
          WHERE PM_PLT_ID_V = d_code;

         UPDATE tb_plt_mstr
            SET PM_TM_OF_FLT_D = time_date
          WHERE PM_PLT_ID_V = r_code;

         UPDATE tb_plt_mstr
            SET PM_TM_OF_NXT_FLT_D = next_time_date
          WHERE PM_PLT_ID_V = r_code;

         UPDATE tb_plt_mstr
            SET PM_NMBR_OF_DFLTS_N = NO_D
          WHERE PM_PLT_ID_V = D_code;

         INSERT INTO tb_dfltr
              VALUES (d_code,
                      p_name,
                      desg,
                      no_d,
                      '31-DEC-9999');
      END IF;

      IF no_d = 1
      THEN
         no_d := no_d + 1;

         UPDATE tb_plt_mstr
            SET PM_TM_OF_FLT_D = time_date
          WHERE PM_PLT_ID_V = d_code;

         UPDATE tb_plt_mstr
            SET PM_TM_OF_NXT_FLT_D = ADD_MONTHS (time_date, 36)
          WHERE PM_PLT_ID_V = d_code;

         UPDATE tb_plt_mstr
            SET PM_TM_OF_FLT_D = time_date
          WHERE PM_PLT_ID_V = r_code;

         UPDATE tb_plt_mstr
            SET PM_NMBR_OF_DFLTS_N = NO_D
          WHERE PM_PLT_ID_V = D_code;

         INSERT INTO tb_dfltr
              VALUES (d_code,
                      p_name,
                      desg,
                      no_d,
                      ADD_MONTHS (time_date, 36));
      END IF;


      IF no_d = 0
      THEN
         no_d := no_d + 1;

         UPDATE tb_plt_mstr
            SET PM_TM_OF_FLT_D = TIME_DATE
          WHERE PM_PLT_ID_V = d_code;

         --raise_application_error(-20001,'???????????????');
         UPDATE tb_plt_mstr
            SET PM_TM_OF_NXT_FLT_D = ADD_MONTHS (time_date, 3)
          WHERE PM_PLT_ID_V = d_code;

         UPDATE tb_plt_mstr
            SET PM_TM_OF_FLT_D = time_date
          WHERE PM_PLT_ID_V = r_code;

         UPDATE tb_plt_mstr
            SET PM_TM_OF_NXT_FLT_D = next_time_date
          WHERE PM_PLT_ID_V = r_code;

         UPDATE tb_plt_mstr
            SET PM_NMBR_OF_DFLTS_N = NO_D
          WHERE PM_PLT_ID_V = D_code;


         INSERT INTO tb_dfltr
              VALUES (d_code,
                      p_name,
                      desg,
                      no_d,
                      ADD_MONTHS (time_date, 3));
      END IF;

      UPDATE tb_plt_mstr
         SET PM_FLT_NMBR_V = ''
       WHERE pm_plt_id_v = d_code;


      UPDATE tb_plt_mstr
         SET PM_FLT_NMBR_V = flt_num
       WHERE pm_plt_id_v = r_code;
   ELSE
      raise_application_error (
         -20001,
         'PILOT NOT AVAILABLE !! REQUEST FROM OTHER BASE');
   END IF;
END;
/