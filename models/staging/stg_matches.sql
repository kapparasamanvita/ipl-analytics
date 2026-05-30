with source as (
    select * from {{ source('ipl_raw', 'MATCHES') }}
),

renamed as (
    select
        ID               as match_id,
        SEASON           as season,
        CITY             as city,
        DATE             as match_date,
        TEAM1            as team1,
        TEAM2            as team2,
        TOSS_WINNER      as toss_winner,
        TOSS_DECISION    as toss_decision,
        RESULT           as result,
        DL_APPLIED       as duckworth_lewis_applied,
        WINNER           as winner,
        WIN_BY_RUNS      as win_by_runs,
        WIN_BY_WICKETS   as win_by_wickets,
        PLAYER_OF_MATCH  as player_of_match,
        VENUE            as venue,
        UMPIRE1          as umpire1,
        UMPIRE2          as umpire2
    from source
)

select * from renamed
