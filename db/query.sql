select * from article.article;

explain select * from article.article where board_id = 1 order by created_at desc limit 30 offset 90;
create index idx_board_id_article_id on article.article(board_id asc, article_id desc);
explain select * from article.article where board_id = 1 order by article_id desc limit 30 offset 90;
explain select * from article.article where board_id = 1 order by article_id desc limit 30 offset 1499970;
explain select board_id, article_id from article.article
where board_id = 1
order by article_id desc
limit 30 offset 1499970;

explain
select * from (select board_id, article_id
               from article.article
               where board_id = 1
               order by article_id desc
               limit 30 offset 8999970) a
inner join article.article b
on a.article_id = b.article_id;

select count(*)
from (
select article_id from article.article where board_id = 1 limit 300301
) t;

select count(*)
from article.article where board_id = 1 limit 300301;

--------------------------------------------------------------------------------------------------------

create database comment;
use comment;
create table comment (
    comment_id bigint not null primary key,
    content varchar(3000) not null,
    article_id bigint not null,
    parent_comment_id bigint not null,
    writer_id bigint not null,
    deleted bool not null,
    created_at datetime not null
);
create index idx_article_id_parent_comment_id_comment_id on comment (
article_id asc,
parent_comment_id asc,
comment_id asc
);

SELECT table_name, table_collation FROM information_schema.TABLES where table_schema = 'comment';
-- ci -> 대소문자 비교 불가

create table comment_v2 (
comment_id bigint not null primary key,
content varchar(3000) not null,
article_id bigint not null,
writer_id bigint not null,
path varchar(25) character set utf8mb4 collate utf8mb4_bin not null,
deleted bool not null,
created_at datetime not null
);

create unique index idx_article_id_path on comment_v2(
article_id asc, path asc
);

select table_name, column_name, collation_name
from information_schema.COLUMNS
where TABLE_SCHEMA = 'comment' and TABLE_NAME = 'comment_v2' and COLUMN_NAME = 'path'
;

select path from comment_v2
where article_id = '1'
and path > '00a0z'
and path like '00a0z%'
order by path desc limit 1
;

----------------------------------------------------------------------------------------------------------

create database article_like;
use article_like;
create table article_like (
article_like_id bigint not null primary key,
article_id bigint not null,
user_id bigint not null,
created_at datetime not null
);
create unique index idx_article_id_user_id on article_like(article_id asc, user_id asc);

------------------------------------------------------------------------------------------------------------

create database test_db;
use test_db;
create table lock_test (
    id bigint not null primary key,
    content varchar(100) not null
);
insert into lock_test values(1234, 'test');
select * from lock_test;
start transaction;
update lock_test
set content='test2'
where id =1234;
select * from performance_schema.data_locks;
commit;

------------------------------------------------------------------------------------------------------------

use article_like;
create table article_like_count (
article_id bigint not null primary key,
like_count bigint not null,
version bigint not null
);

------------------------------------------------------------------------------------------------------------

use article;
create table board_article_count (
board_id bigint not null primary key,
article_count bigint not null
);

use comment;
create table article_comment_count (
article_id bigint not null primary key,
comment_count bigint not null
);

