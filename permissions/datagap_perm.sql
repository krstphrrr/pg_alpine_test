CREATE POLICY ndow_allow
    ON public_test."dataGap"
    AS PERMISSIVE
    FOR ALL
    TO ndow_get
    USING (
      (
        (
          ("FormDate" < (CURRENT_DATE - '3 years'::interval year)) 
          AND 
          ("ProjectKey" ~~* 'NWERN%'::text)
        ) 
        OR ("ProjectKey" ~~* 'NDOW%'::text) 
        OR ("ProjectKey" ~~ 'Jornada%'::text) 
        OR ("ProjectKey" ~~ 'BLM_AIM%'::text)
      )
    );