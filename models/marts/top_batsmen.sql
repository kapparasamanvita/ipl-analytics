/*
    Top 50 batsmen by total runs across all IPL seasons.
    Includes strike rate, boundary counts, and matches played.
    Business question: Who are the most prolific IPL batsmen of all time?
*/
with batsman_stats as (
    select
        batsman,
        batting_team,
        sum(batsman_runs)                                           as total_runs,
        count(distinct match_id)                                    as matches_played,
        count(*)                                                    as balls_faced,
        sum(case when batsman_runs = 4 then 1 else 0 end)          as fours,
        sum(case when batsman_runs = 6 then 1 else 0 end)          as sixes,
        sum(case when batsman_runs >= 50
                  and batsman_runs < 100 then 1 else 0 end)        as fifties,
        sum(case when batsman_runs >= 100 then 1 else 0 end)       as hundreds,
        round(
            sum(batsman_runs) * 100.0 / nullif(count(*), 0), 2
        )                                                           as strike_rate
    from {{ ref('stg_deliveries') }}
    where wide_runs = 0  -- exclude wides from balls faced
    group by batsman, batting_team
)

select
    batsman,
    batting_team,
    total_runs,
    matches_played,
    balls_faced,
    round(total_runs / nullif(matches_played, 0), 1)    as avg_runs_per_match,
    strike_rate,
    fours,
    sixes,
    fifties,
    hundreds
from batsman_stats
order by total_runs desc
limit 50
