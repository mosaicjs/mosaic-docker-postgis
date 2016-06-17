CREATE OR REPLACE FUNCTION sha1a(str text) returns text AS $$
    select digest(str, 'sha1') as hash;
$$ LANGUAGE SQL STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION sha1(str text) returns text AS $$
    select encode(digest(str, 'sha1'), 'hex') as hash;
$$ LANGUAGE SQL STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION UUID5(str TEXT) RETURNS TEXT AS $$
    SELECT regexp_replace(hash, '^(........)(....)(...)(....)(............).*$', '\1-\2-5\3-\4-\5') FROM
    (SELECT encode(digest(str, 'sha1'), 'hex') AS hash) AS N;
$$ LANGUAGE SQL STRICT IMMUTABLE;
