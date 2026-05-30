/*
    Does winning the toss give you an advantage?
    Breaks down by toss decision (bat/field) and season.
    Business question: What is the optimal toss strategy in IPL?
*/
with toss_outcomes as (
    select
        season,
        toss_decision,
        count(*)                                                        as total_matches,
        sum(case when toss_winner = winner then 1 else 0 end)          as toss_winner_won,
        sum(case when toss_winner != winner then 1 else 0 end)         as toss_winner_lost
    from {{ ref('stg_matches') }}
    where result != 'no result'  -- exclude rain-affected matches
    group by season, toss_decision
)

select
    season,
    toss_decision,
    total_matches,
    toss_winner_won,
    toss_winner_lost,
    round(
        toss_winner_won * 100.0 / nullif(total_matches, 0), 1
    )                   as win_pct_after_toss
from toss_outcomes
order by season desc, toss_decision
