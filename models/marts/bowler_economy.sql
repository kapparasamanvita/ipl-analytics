/*
    Top bowlers by economy rate (minimum 200 balls bowled).
    Business question: Which bowlers are the most economical in IPL?
*/
with bowler_stats as (
    select
        bowler,
        bowling_team,
        count(distinct match_id)                                    as matches,
        count(*)                                                    as balls_bowled,
        sum(total_runs)                                             as runs_conceded,
        sum(case when dismissal_kind is not null
                  and dismissal_kind != ''
                  and dismissal_kind != 'run out'
             then 1 else 0 end)                                    as wickets,
        sum(case when wide_runs > 0 then 1 else 0 end)             as wides,
        sum(case when noball_runs > 0 then 1 else 0 end)           as no_balls
    from {{ ref('stg_deliveries') }}
    group by bowler, bowling_team
),

calculated as (
    select
        bowler,
        bowling_team,
        matches,
        balls_bowled,
        runs_conceded,
        wickets,
        wides,
        no_balls,
        -- economy = runs per over (6 balls)
        round(runs_conceded * 6.0 / nullif(balls_bowled, 0), 2)    as economy_rate,
        -- bowling average = runs per wicket
        round(runs_conceded * 1.0 / nullif(wickets, 0), 2)         as bowling_avg,
        -- strike rate = balls per wicket
        round(balls_bowled * 1.0 / nullif(wickets, 0), 2)          as bowling_strike_rate
    from bowler_stats
    where balls_bowled >= 200  -- minimum threshold for meaningful stats
)

select *
from calculated
order by economy_rate asc
limit 50
