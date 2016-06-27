/* Get all tags co-occurred with 'design' */
select * from (
    select distinct(jsonb_array_elements_text(properties->'tags')) as tag, count(*) from prm
    where properties @> '{"tags" : ["design"]}'
    group by jsonb_array_elements_text(properties->'tags')
) as T
where NOT (tag IN ('design')) -- tag::text <> ANY(ARRAY['design','strategie'])
order by count desc, tag
-- */

/* Get the whole table as a GeoJSON collection */
select row_to_json(FC)::jsonb from
(
    select
        'FeatureCollection' as type, 
        coalesce(array_to_json(array_agg(A)), '[]'::json) as features
    from (
        select
            id,
            'Feature' as type, 
            properties::jsonb as properties,
            st_asgeojson(geometry)::jsonb as geometry
        from objects
    ) as A
) as FC
-- */

-- ---------------------------------------------------------------------------------

/* Removes all OSM tags * /
CREATE OR REPLACE FUNCTION cleanup_json(obj jsonb) returns jsonb AS $$
    var result = {};
    var EXCLUDED_FIELDS = { 'tags':1 };
    for (var field in obj){
        var value = obj[field];
        if (!value) continue; 
        result[field] = value;
    }
    var tags = obj.tags || {};
    for (var name in tags){
        result[name] = tags[name];
    }
    for (var name in result){
        if (name.indexOf('osm_') === 0 || (name in EXCLUDED_FIELDS)) {
        delete result[name];
        }
    }
    return result;
$$ LANGUAGE plv8 STRICT IMMUTABLE;
-- Example:
-- update objects set properties = cleanup_json(properties);
-- */