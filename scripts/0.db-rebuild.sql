CREATE SCHEMA IF NOT EXISTS "import";
CREATE EXTENSION IF NOT EXISTS "postgis";
CREATE EXTENSION IF NOT EXISTS "hstore";
CREATE EXTENSION IF NOT EXISTS "plv8";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
-- CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

/* */
DROP FUNCTION IF EXISTS sha1a(str text);
CREATE OR REPLACE FUNCTION sha1a(str text) returns bytea AS $$
    select digest(str, 'sha1') as hash;
$$ LANGUAGE SQL STRICT IMMUTABLE;

DROP FUNCTION IF EXISTS sha1(str text);
CREATE OR REPLACE FUNCTION sha1(str text) returns text AS $$
    select encode(digest(str, 'sha1'), 'hex') as hash;
$$ LANGUAGE SQL STRICT IMMUTABLE;

DROP FUNCTION IF EXISTS uuid5(str text);
CREATE OR REPLACE FUNCTION uuid5(str text) RETURNS UUID AS $$
    var plan = plv8.prepare("select encode(digest($1, 'sha1'), 'hex') as hash", ['text']);
    try {
        var hash = plan.execute( [str] )[0].hash;
        var val = parseInt(hash.substring(16, 18), 16);
        val = val & 0x3f | 0xa0; // set variant
        return '' + 
            hash.substring( 0,  8) + '-' + //
            hash.substring( 8, 12) + '-' + //
            '5' + // set version
            hash.substring(13, 16) + '-' + //
            val.toString(16) + hash.substring(18, 20) + '-' + //
            hash.substring(20, 32);
    } finally {
        plan.free();
    }
$$ LANGUAGE plv8 STRICT IMMUTABLE;
-- */