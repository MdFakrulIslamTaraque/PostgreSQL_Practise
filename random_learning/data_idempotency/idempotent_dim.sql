BEGIN
    -- create dim_industry
    CREATE TABLE IF NOT EXISTS `data-engineering-440306.financial_sample.dim_industry` (
        id STRING,
        , Industry_aggregation_NZSIOC string
        , Industry_code_NZSIOC string
        , Industry_name_NZSIOC string
        , Industry_code_ANZSIC06 string
        , created_at DATE
    );


    -- create dim table as temprary
    create table if not exists `data-engineering-440306.financial_sample.dim_industry_temp`
    as
    with codes_with_entry as (
    SELECT 
        Industry_aggregation_NZSIOC, Industry_code_NZSIOC, Industry_name_NZSIOC, Industry_code_ANZSIC06
        , row_number() over(partition by 
                                Industry_code_NZSIOC, Industry_code_ANZSIC06 
                            order by 
                                Industry_aggregation_NZSIOC, Industry_code_NZSIOC, Industry_name_NZSIOC, Industry_code_ANZSIC06
        ) as rn
    FROM `data-engineering-440306.financial_sample.financial_sample_data3`
    )
    select
        GENERATE_UUID() AS id
        , Industry_aggregation_NZSIOC, Industry_code_NZSIOC, Industry_name_NZSIOC, Industry_code_ANZSIC06
        , CURRENT_DATE() AS created_at
    from
        codes_with_entry
    where
        1 = 1
        and rn = 1
    order by
        1,2,3,4,5
    ;

    -- Insert new unique industries from raw data if any new entry appears merge them
    MERGE `data-engineering-440306.financial_sample.dim_industry` AS target
    USING (
            select
                *
            from
                `data-engineering-440306.financial_sample.dim_industry_temp`
    ) AS source
    ON target.Industry_code_NZSIOC = source.Industry_code_NZSIOC
    and target.Industry_code_ANZSIC06 = source.Industry_code_ANZSIC06
    WHEN NOT MATCHED THEN
        INSERT (id, Industry_aggregation_NZSIOC, Industry_code_NZSIOC, Industry_name_NZSIOC, Industry_code_ANZSIC06, created_at)
        VALUES (source.id, source.Industry_aggregation_NZSIOC, source.Industry_code_NZSIOC, source.Industry_name_NZSIOC, source.Industry_code_ANZSIC06, source.created_at);


    -- drop the temp table
    drop table `data-engineering-440306.financial_sample.dim_industry_temp`;

END

-- insert a new entry and call the stored procedure and check the dim_industry table
insert into `data-engineering-440306.financial_sample.financial_sample_data3`
(Year, Industry_aggregation_NZSIOC, Industry_code_NZSIOC, Industry_name_NZSIOC, Units, Variable_code, Variable_name, Variable_category, Value,  Industry_code_ANZSIC06)
values
(2028, "Level 1", "AATareq", "Agriculture, Forestry and Fishing", "Dollars (millions)", "H01", "Total income", "Financial performance", "54462", "ANZSIC06 division A tareq")
;


-- call the stored procedure
call `data-engineering-440306.financial_sample.generate_dim_industry`();
