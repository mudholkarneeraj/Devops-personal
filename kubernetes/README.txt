--------- CPU Requests, CPU Shares and CFS -------------- in KUBERNETES
To allocate resources to containers of Pod, Kubernetes uses Сgroups and CFS (completely fair scheduler) on Linux. Roughly speaking, all processes/threads of a container run in a distinct Cgroup, and CFS allocates CPU resources to these Cgroups according to specified resource requests (bear with me, it will be clear… eventually).
However, CFS operates with something called CPU Shares, and not CPU Units of Kubernetes. To convert CPU Units to CPU Shares, Kubernetes equates 1 CPU to 1024 CPU shares. Meaning that a Pod with 500m CPU requests will be given 512 CPU Shares. And a Node with 6 CPUs has 6144 CPU Shares total.
When Pods do nothing or very little work and CPU is mostly idle, CFS does not care how many shares each Cgroup has. But when multiple Cgroups have runnable tasks, and there are not enough CPU resources, CFS makes sure each Cgroup get CPU time relative to how many shares they have. And, since Kubernetes computes shares from CPU units, it guarantees that a Pod receives requested CPU resources.

-->Kubernetes uses limits to restrict max resource consumption for a Pod. For memory, it is pretty simple: if an application attempts to allocate more memory than specified in Limits — it will be killed by OOMKiller.
CPU Limits, on the other hand, are enforced via throttling. When an application attempts to use more CPU than it is limited to — CFS will throttle it.

CFS Periods and Quotas
As for requests, CFS operates on a level of Cgroups. For each Cgroup limits are defined by two configurable parameters:

cpu.cfs_quota_us — CPU time in microseconds available to cgroup in a period, computed from Limits value.
cpu.cfs_period_us — accounting period in microseconds after which allocatable resources are refilled, by default is 100 ms.
