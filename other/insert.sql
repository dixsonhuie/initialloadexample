/*
  https://dba.stackexchange.com/questions/130392/generate-and-insert-1-million-rows-into-simple-table
 */

drop table t1;

declare @count int;
declare @filler nvarchar(1024);

set @count = 0;
set @filler = '';

while @count < 114
begin
  set @filler = @filler + cast (@count as nvarchar)
  set @count = @count + 1;
end;

set @filler = CAST(@filler + @filler + @filler + @filler AS NVARCHAR(926))
print @filler;


/* create table t1 (id int, a varchar, b varchar)  */
WITH
  L0   AS (SELECT c FROM (SELECT 1 UNION ALL SELECT 1) AS D(c)), -- 2^1
  L1   AS (SELECT 1 AS c FROM L0 AS A CROSS JOIN L0 AS B),       -- 2^2
  L2   AS (SELECT 1 AS c FROM L1 AS A CROSS JOIN L1 AS B),       -- 2^4
  L3   AS (SELECT 1 AS c FROM L2 AS A CROSS JOIN L2 AS B),       -- 2^8
  L4   AS (SELECT 1 AS c FROM L3 AS A CROSS JOIN L3 AS B),       -- 2^16
  L5   AS (SELECT 1 AS c FROM L4 AS A CROSS JOIN L4 AS B),       -- 2^32
  nums AS (SELECT ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS k FROM L5)

select k as id,
  'a_' + CAST (k as varchar(255)) as a,
  'b_' + RIGHT('00000000'+ CAST(k AS NVARCHAR(8)),8) + @filler as b,
  CAST (1 AS BIT) as c into t1
  from nums
where k <= 96000000;


select * from t1 where id < 10;
