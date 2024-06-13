

--select top 100 *, ldb.nextduedate from Essbase.Ops.LoanDailyBalance ldb where loanid = 35473747 order by businessdate desc

--select top 100 * from EIS.loan.loan



SET ANSI_WARNINGS OFF;
-- Your insert TSQL here.
--SET ANSI_WARNINGS ON;

--column
declare @keyword varchar(255) = '%brokenpromisdate%'
--table
declare @keyword2 varchar(255) = '%brokenpromisdate%'
--stored procedure

declare @keyword3 varchar(255) = '%brokenpromisdate%'


declare @dbList table (db_name varchar(255), id int)

insert into @dbList values ('bidwsandbox', 1 )
insert into @dbList values ('SBT', 2 )
insert into @dbList values ('eismart', 3 )
insert into @dbList values ('essbase', 4 )
insert into @dbList values ('PerformanceKPIs', 5 )
insert into @dbList values ('kpi', 6 )
insert into @dbList values ('CentralizedCollections', 7 )
insert into @dbList values ('CentralizedCommunications', 8 )
insert into @dbList values ('Marketing', 9 )
insert into @dbList values ('SalesForce', 10 )
insert into @dbList values ('DM_Leads', 11 )
insert into @dbList values ('eis', 12 )
insert into @dbList values ('StoreCallsLog', 13 )



drop table if exists #search_results
create table #search_results  (
DB varchar(255),
object_name varchar(255),
schema_name varchar(255),
DataType varchar(255),
isColumn varchar(255),
columns_name varchar(255),
table_name varchar(255),
FullName varchar(255),
create_date datetime,
modify_date datetime
)
declare @search_name as varchar(255)




declare @end as int
declare @i int = 1
declare @col_name as varchar(255)
declare @dir_name as varchar(255)




--select * from @dbList



while @i <= 13
begin



--get db name
drop table if exists #tmp_get_db
select db_name
into #tmp_get_db
--column_name, fullname 
from @dbList where id = @i

declare @db_name varchar(255)
select @db_name = db_name from #tmp_get_db





declare @SQL nvarchar(max)



set @SQL = '


use '+ @db_name

+'

SELECT 
'''+@db_name+''' DB
,o.name AS object_name
,sm.name AS schema_name
,(case when o.type_desc like ''%STORED%PROC%'' then ''StoredProc'' 
when o.type_Desc like ''%TABLE%'' then ''Table''
else o.type_desc end) DataType
,''N'' isColumn
,c.name column_name
,o.name table_name
,'''+@db_name+'''+''.'' + cast(sm.name as varchar)+''.''+cast(t.name as varchar) FullName
,o.create_date
,o.modify_date
FROM '+@db_name+'.sys.objects o

left JOIN '+@db_name+'.sys.tables t ON t.OBJECT_ID = o.OBJECT_ID
left JOIN '+@db_name+'.sys.columns c ON t.OBJECT_ID = c.OBJECT_ID
left JOIN '+@db_name+'.sys.schemas sm ON sm.schema_ID = o.schema_ID
where 1=1
and (o.name like '''+ @keyword2 +''' or c.name like '''+ @keyword +''') 
or (o.name like '''+ @keyword3 +''' and o.type_desc like ''%STORED%PROC%'')



union


SELECT 
'''+@db_name+''' DB
,c.name AS object_name
,sm.name AS schema_name
,(case when o.type_desc like ''%STORED%PROC%'' then ''StoredProc'' 
when o.type_Desc like ''%TABLE%'' then ''Table''
else o.type_desc end) DataType
,''Y'' isColumn
,c.name column_name
,t.name table_name
,'''+@db_name+'''+''.''+ cast(sm.name as varchar)+''.''+cast(t.name as varchar) FullName
,o.create_date
,o.modify_date

FROM eis.sys.tables AS t
INNER JOIN '+@db_name+'.sys.columns c ON t.OBJECT_ID = c.OBJECT_ID
INNER JOIN '+@db_name+'.sys.objects o ON t.OBJECT_ID = o.OBJECT_ID
INNER JOIN '+@db_name+'.sys.schemas sm ON sm.schema_ID = o.schema_ID

--WHERE name LIKE ''%spGetFinChargeOffs%''
where 1=1
and (o.name like '''+ @keyword2 +''' or c.name like '''+ @keyword +''')




'

--select top 100 * from eis.Acv.CollateralAppraisal





insert into #search_results
exec(@Sql)

set @i = @i +1


end



select * from #search_results













SET ANSI_WARNINGS ON;


















