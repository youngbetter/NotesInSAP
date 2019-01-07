from typing import List

from JobWatcher import WatchedJob
import CD_Jenkins_Watcher


def get_all_watched_jobs() -> List[WatchedJob]:
    watchers = [
        CD_Jenkins_Watcher.watch_cd_jenkins,
    ]
    for watcher in watchers:
        yield from watcher()
