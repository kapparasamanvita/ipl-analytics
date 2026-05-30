with source as (
    select * from {{ source('ipl_raw', 'DELIVERIES') }}
),

renamed as (
    select
        MATCH_ID         as match_id,
        INNING           as inning,
        BATTING_TEAM     as batting_team,
        BOWLING_TEAM     as bowling_team,
        OVER             as over_number,
        BALL             as ball_number,
        BATSMAN          as batsman,
        NON_STRIKER      as non_striker,
        BOWLER           as bowler,
        IS_SUPER_OVER    as is_super_over,
        WIDE_RUNS        as wide_runs,
        BYE_RUNS         as bye_runs,
        LEGBYE_RUNS      as legbye_runs,
        NOBALL_RUNS      as noball_runs,
        PENALTY_RUNS     as penalty_runs,
        BATSMAN_RUNS     as batsman_runs,
        EXTRA_RUNS       as extra_runs,
        TOTAL_RUNS       as total_runs,
        PLAYER_DISMISSED as player_dismissed,
        DISMISSAL_KIND   as dismissal_kind
    from source
)

select * from renamed
