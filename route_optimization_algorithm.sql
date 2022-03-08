

with cte as (SELECT * FROM pgr_dijkstra('SELECT id, source, target, cost FROM addisc_roads_noded',5, coord_to_node11 
(array [[38.7,8.67878],[39.7,8.787878],[40.7007,8.0707]]), FALSE)as jkll),  with_geom AS (
        SELECT cte.seq, cte.cost, addisc_roads_noded.old_id::text,
        CASE
            WHEN cte.node = addisc_roads_noded.source THEN addisc_roads_noded.way
            ELSE ST_Reverse(addisc_roads_noded.way)
        END AS route_geom
        FROM cte JOIN addisc_roads_noded
        ON (edge = addisc_roads_noded.id) ORDER BY seq
    ) Select * From with_geom;	 
CREATE OR REPLACE FUNCTION routing4 (in arr1 numeric [], in arr2 numeric [],  OUT geom geometry) returns SETOF geometry as 
$body$
with cte as (SELECT * FROM pgr_dijkstra('SELECT id, source, target, cost FROM addisc_roads_noded',coord_to_node11(arr1), coord_to_node11 
(arr2), FALSE)as jkll),  with_geom AS (
        SELECT cte.seq, cte.cost, addisc_roads_noded.old_id::text,
        CASE
            WHEN cte.node = addisc_roads_noded.source THEN addisc_roads_noded.way
            ELSE ST_Reverse(addisc_roads_noded.way)
        END AS route_geom
        FROM cte JOIN addisc_roads_noded
        ON (edge = addisc_roads_noded.id) ORDER BY seq
    ) Select route_geom From with_geom;	
$body$
LANGUAGE 'sql';
select routing4 (array[[38.762214,8.937409]],array[[39.787432,9.964137],[39.756085,9.959341]])
select * from test_ limit 3
SELECT ST_AsGeoJSON (ST_Union (routing4)) from routing4 (array[[38.762214,8.937409]],array[[39.787432,9.964137],[39.756085,9.959341]])
SELECT ST_AsGeoJSON (ST_Transform(ST_Union (routing4),4326)) from routing4 (array[[38.762214,8.937409]],array[[39.787432,9.964137],[39.756085,9.959341]])
SELECT ST_Length(ST_Transform(ST_Union (routing4),4326)) from routing4 (array[[38.762214,8.937409]],array[[39.787432,9.964137],[39.756085,9.959341]])


SELECT ST_SetSRID(ST_Union (routing4),4326) from routing4 (array[[38.762214,8.937409]],array[[38.787432,8.964137],[38.756085,8.959341]])

select coord_to_node11 (array [[39.77,9.8],[38.7774,9.5677]])
select * from addisc_roads_noded
select id from addisc_roads_noded limit 10