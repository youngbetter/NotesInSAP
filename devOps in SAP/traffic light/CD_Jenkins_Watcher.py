import JobWatcher
import requests


def _get_by_job(color):
    job_info = JobWatcher.WatchedJob(color=color)
    yield job_info


def watch_cd_jenkins():
    result = requests.get("https://cd.successfactors.com/job/CD%20Pipelines/job/master/api/json?tree=color", verify=False)
    json = result.json()
    color = json.get("color")
    yield from _get_by_job(color)
