-- postgres

CREATE EXTENSION plr;

CREATE TABLE IF NOT EXISTS plr_modules (
  modseq int4,
  modsrc text
);

TRUNCATE plr_modules;
INSERT INTO plr_modules VALUES (0, 'library(dbscan)');

CREATE TABLE mtl_crimes (
  categorie text,
  date date,
  quart text,
  pdq text,
  x float,
  y float,
  lat float,
  lon float
);

\copy mtl_crimes FROM mtl_crimes.csv WITH CSV HEADER;

DELETE FROM mtl_crimes WHERE x=0;

CREATE OR REPLACE FUNCTION PLR_ClusterDBSCAN(x double precision, y double precision, eps double precision, minpoints integer)
RETURNS int
AS $$
    if (pg.state.firstpass == TRUE) {
        pg.state.firstpass <<- FALSE
        c <- dbscan(cbind(farg1, farg2), eps=eps, MinPts=minpoints)
        assign("cluster", c$cluster, env = .GlobalEnv)
    }

    return(cluster[prownum])
$$ WINDOW LANGUAGE PLR;

\timing on
SELECT count(DISTINCT cid) FROM (SELECT PLR_ClusterDBSCAN(x, y, 300, 15) OVER() AS cid FROM mtl_crimes) sq;
