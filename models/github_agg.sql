with cte as
(
SELECT
    FORMAT_TIMESTAMP("%Y%m%d", created_at) AS date,
    actor.id as actor_id,
    CONCAT('https://github.com/', repo.name) as github_repo,
    type
    FROM
    {{ source("gbq_github", "20131109") }}
)

SELECT
    date,
    github_repo,
    count(IF(type='WatchEvent', type, NULL)) AS subs,
    count(IF(type='PushEvent',  type, NULL)) AS pushes,
    count(IF(type='PullRequestEvent',  type, NULL)) AS pullrequests,
    count(IF(type='ForkEvent',  type, NULL)) AS copies,
    count(IF(type in ('IssueCommentEvent','CommitCommentEvent','PullRequestReviewCommentEvent'),  type, NULL)) AS comments,
    count(*) AS all_event
FROM cte
where github_repo is not null
GROUP BY 1,2
ORDER BY all_event desc

