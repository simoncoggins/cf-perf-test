-- create table for storing text data
create sequence elis_field_data_text_seq;
create table mdl_elis_field_data_text (id integer not null DEFAULT NEXTVAL('elis_field_data_text_seq'), type varchar(255) not null, itemid integer not null, fieldid integer not null, data text);
create index text_fieldid on mdl_elis_field_data_text (fieldid);
create index text_typeitemid on mdl_elis_field_data_text (type,itemid);

-- create table for storing integer data
create sequence elis_field_data_int_seq;
create table mdl_elis_field_data_int (id integer not null DEFAULT NEXTVAL('elis_field_data_text_seq'), type varchar(255) not null, itemid integer not null, fieldid integer not null, data integer);
create index int_fieldid on mdl_elis_field_data_int (fieldid);
create index int_typeitemid on mdl_elis_field_data_int (type,itemid);

-- create table for storing varchar data
create sequence elis_field_data_char_seq;
create table mdl_elis_field_data_char (id integer not null DEFAULT NEXTVAL('elis_field_data_text_seq'), type varchar(255) not null, itemid integer not null, fieldid integer not null, data varchar(1024));
create index char_fieldid on mdl_elis_field_data_char (fieldid);
create index char_typeitemid on mdl_elis_field_data_char (type,itemid);

-- create table for storing floating point data
create sequence elis_field_data_num_seq;
create table mdl_elis_field_data_num (id integer not null DEFAULT NEXTVAL('elis_field_data_text_seq'), type varchar(255) not null, itemid integer not null, fieldid integer not null, data numeric(15, 5));
create index num_fieldid on mdl_elis_field_data_num (fieldid);
create index num_typeitemid on mdl_elis_field_data_num (type,itemid);


-- create user_extend table with one field of each type
create sequence mdl_user_extend_seq;
create table mdl_user_extend (id integer not null DEFAULT NEXTVAL('mdl_user_extend_seq'), itemid integer not null, textfield text, intfield integer, charfield varchar(1024), numfield numeric(15,5));
create index user_extend_itemid on mdl_user_extend (itemid);


-- reformat the profile field data for elis schema
insert into mdl_elis_field_data_int (type,itemid,fieldid,data) select 'user' as type,d.userid as itemid,d.fieldid,cast(d.data as int) from mdl_user_info_data d join mdl_user_info_field f on f.id = d.fieldid where f.shortname = 'check';

insert into mdl_elis_field_data_char (type,itemid,fieldid,data) select 'user' as type,d.userid as itemid,d.fieldid,cast(d.data as varchar) from mdl_user_info_data d join mdl_user_info_field f on f.id = d.fieldid where f.shortname = 'text';

insert into mdl_elis_field_data_text (type,itemid,fieldid,data) select 'user' as type,d.userid as itemid,d.fieldid,d.data from mdl_user_info_data d join mdl_user_info_field f on f.id = d.fieldid where f.shortname = 'area';

insert into mdl_elis_field_data_num (type,itemid,fieldid,data) select 'user' as type,d.userid as itemid,d.fieldid,cast(d.data as float) from mdl_user_info_data d join mdl_user_info_field f on f.id = d.fieldid where f.shortname = 'num';

-- reformat the profile field data for user_extend schema
insert into mdl_user_extend (itemid, intfield, charfield, textfield, numfield) select d.userid as itemid, max(case when f.shortname = 'check' then cast(d.data as int) else -1 end) as intfield, max(case when f.shortname = 'text' then cast(d.data as varchar) else '' end) as charfield, max(case when f.shortname = 'area' then d.data else '' end) as textfield, max(case when f.shortname = 'num' then cast(d.data as float) else -1.0 end) as numfield from mdl_user_info_data d left join mdl_user_info_field f on d.fieldid = f.id group by d.userid;

