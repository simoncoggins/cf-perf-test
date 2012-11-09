\timing on

-- CASE 1: return all fields for 1 user

-- existing schema (1 join per field)

-- in cases where a separate query to get the field info would be
-- needed (with the 2nd query being generated via PHP) I've included
-- an extra select and summed the timing of both queries
select * from mdl_user_info_field;
select u.id as userid, cf1.data as cf1, cf2.data as cf2,
    cf3.data as cf3, cf4.data as cf4
from mdl_user u
left join mdl_user_info_data cf1 on u.id = cf1.userid and cf1.fieldid = 1
left join mdl_user_info_data cf2 on u.id = cf2.userid and cf2.fieldid = 2
left join mdl_user_info_data cf3 on u.id = cf3.userid and cf3.fieldid = 3
left join mdl_user_info_data cf4 on u.id = cf4.userid and cf4.fieldid = 4
where u.id = 5000;

-- existing schema (pivot hack)
select u.id, fields.cf1, fields.cf2, fields.cf3, fields.cf4
from mdl_user u
inner join
(SELECT info.userid as userid ,
    MAX(CASE WHEN ff.shortname = 'check' THEN info.data ELSE '' END) as cf1,
    MAX(CASE WHEN ff.shortname = 'text' THEN info.data ELSE '' END) as cf2,
    MAX(CASE WHEN ff.shortname = 'area' THEN info.data ELSE '' END) as cf3,
    MAX(CASE WHEN ff.shortname = 'num' THEN info.data ELSE '' END) as cf4
FROM mdl_user_info_data AS info
LEFT JOIN mdl_user_info_field AS ff ON info.fieldid = ff.id
GROUP BY userid) as fields on fields.userid = u.id WHERE u.id = 5000;

-- elis schema
select * from mdl_user_info_field;
select u.id as userid, cf1.data as cf1, cf2.data as cf2,
    cf3.data as cf3, cf4.data as cf4
from mdl_user u
left join mdl_elis_field_data_int cf1 on cf1.type = 'user' and u.id = cf1.itemid and cf1.fieldid = 1
left join mdl_elis_field_data_char cf2 on cf2.type = 'user' and u.id = cf2.itemid and cf2.fieldid = 3
left join mdl_elis_field_data_text cf3 on cf3.type = 'user' and u.id = cf3.itemid and cf3.fieldid = 2
left join mdl_elis_field_data_num cf4 on cf4.type = 'user' and u.id = cf4.itemid and cf4.fieldid = 4
where u.id = 5000;

-- user_extend schema
select u.id, ue.textfield, ue.intfield, ue.charfield, ue.numfield
from mdl_user u
left join
mdl_user_extend ue on u.id = ue.itemid
where u.id = 5000;



-- CASE 2: return all fields for lots of users



-- existing schema (1 join per field)
select * from mdl_user_info_field;
select u.id as userid, cf1.data as cf1, cf2.data as cf2,
    cf3.data as cf3, cf4.data as cf4
from mdl_user u
left join mdl_user_info_data cf1 on u.id = cf1.userid and cf1.fieldid = 1
left join mdl_user_info_data cf2 on u.id = cf2.userid and cf2.fieldid = 2
left join mdl_user_info_data cf3 on u.id = cf3.userid and cf3.fieldid = 3
left join mdl_user_info_data cf4 on u.id = cf4.userid and cf4.fieldid = 4
limit 1000;

-- existing schema (pivot hack)
select u.id, fields.cf1, fields.cf2, fields.cf3, fields.cf4
from mdl_user u
inner join
(SELECT info.userid as userid ,
    MAX(CASE WHEN ff.shortname = 'check' THEN info.data ELSE '' END) as cf1,
    MAX(CASE WHEN ff.shortname = 'text' THEN info.data ELSE '' END) as cf2,
    MAX(CASE WHEN ff.shortname = 'area' THEN info.data ELSE '' END) as cf3,
    MAX(CASE WHEN ff.shortname = 'num' THEN info.data ELSE '' END) as cf4
FROM mdl_user_info_data AS info
LEFT JOIN mdl_user_info_field AS ff ON info.fieldid = ff.id
GROUP BY userid) as fields on fields.userid = u.id LIMIT 1000;

-- elis schema
select * from mdl_user_info_field;
select u.id as userid, cf1.data as cf1, cf2.data as cf2,
    cf3.data as cf3, cf4.data as cf4
from mdl_user u
left join mdl_elis_field_data_int cf1 on cf1.type = 'user' and u.id = cf1.itemid and cf1.fieldid = 1
left join mdl_elis_field_data_char cf2 on cf2.type = 'user' and u.id = cf2.itemid and cf2.fieldid = 3
left join mdl_elis_field_data_text cf3 on cf3.type = 'user' and u.id = cf3.itemid and cf3.fieldid = 2
left join mdl_elis_field_data_num cf4 on cf4.type = 'user' and u.id = cf4.itemid and cf4.fieldid = 4
LIMIT 1000;

-- user_extend schema
select u.id, ue.textfield, ue.intfield, ue.charfield, ue.numfield
from mdl_user u
left join
mdl_user_extend ue on u.id = ue.itemid
LIMIT 1000;



-- CASE 3: return all users that match 1 field's value



-- existing schema
select d.userid from mdl_user_info_data d
join mdl_user_info_field f on f.id = d.fieldid
where d.data like '%cat%' and f.shortname = 'area';

-- elis schema
select itemid as userid from mdl_elis_field_data_text d
join mdl_user_info_field f on f.id = d.fieldid
where d.data like '%cat%' and f.shortname = 'area';

-- user_extend schema
select itemid as userid from mdl_user_extend where textfield like '%cat%';



-- CASE 4: return all users that match any field's value



-- existing schema
-- note this one behaves slightly different from the two below as it
-- matches any field type, not just the text types. This sort of query
-- is only possible because all data is stored in one text field
select userid from mdl_user_info_data where data like '%cat%';

-- elis schema
select * from mdl_user_info_field;
select u.id as userid
from mdl_user u
left join mdl_elis_field_data_char cf2 on cf2.type = 'user' and u.id = cf2.itemid and cf2.fieldid = 3
left join mdl_elis_field_data_text cf3 on cf3.type = 'user' and u.id = cf3.itemid and cf3.fieldid = 2
where cf2.data like '%cat%' or cf3.data like '%cat%';

-- user_extend schema
select itemid as userid from mdl_user_extend
where textfield like '%cat%' or charfield like '%cat%';

