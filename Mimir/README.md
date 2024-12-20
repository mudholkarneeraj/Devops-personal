# Grafana Mimir

Grafana Mimir is an open source software project that provides a scalable long-term storage for Prometheus.
It's a distributed Time Series Database(TSDB) 

**Prometheus and Grafana are de-factor standard form metrics monitoring of modern cloud native applications and Infrastructures.**

> Note: Mimir **does not replace** `Prometheus`. It **extends** `Prometheus`

- When using `Mimir`, you keep running `Prometheus` configured to `scrape` the `metrics` form your applications/infrastructure. Then you configure prometheus to `remote write` these metrics to centralized Mimir Cluster[TSDB]

    - You can also use `Grafana Agent` instead of Prometheus to scrape metrics from applicationsa and `remote write` tocentrilized Mimir cluster.
    > **Grafana Agent**: Light-weight version of Prometheus.

- And to `query` back these metrics, you configure `Grafana`.

- Then `Mimir` duplicates received from each prometheus HA(Hight Availability) pair / Grafana Agents. And exposes `100%` compatible prometheus API to query metrics.

## Overview

1. **High Availability**
2. **Horizontal Scalability**
3. **Native multi-tenency**
4. **Durable Storage**
5. **Fast Query Perormance**
6. **Production proven dashboards, Alerts and Runbook**

## Typical Setup

<img width="736" alt="Typical-Setup" src="https://github.com/Shreyank031/Documentation/assets/115367978/6f329a01-cf9c-4bd7-bb02-923b221db27e">

**Note**: Mimir requires a `Object Storage` where we store all the metrics data.
> Object Storage: AWS S3 or S3 compatibe[Minio], GCS, Azure Blob storage, OpenStack Swift.


<img width="654" alt="Object Storage" src="https://github.com/Shreyank031/Documentation/assets/115367978/5afdde9c-f182-4433-a108-c0b785fd0fe9">


## Grafana Mimir architecture

Grafana Mimir has a microservices-based architecture. The system has multiple horizontally scalable microservices that can run separately and in parallel. Grafana Mimir microservices are called components.

- **Grafana Mimir components**:
    1. Compactor
    2. Distributor
    3. Ingester
    4. Querier
    5. Query-frontend
    6. Store-gateway
    7. (Optional) Alertmanager
    8. (Optional) Overrides-exporter
    9. (Optional) Query-scheduler
    10. (Optional) Ruler

### The Write Path

<img width="679" alt="Screenshot 2024-05-29 at 07 32 28" src="https://github.com/Shreyank031/Documentation/assets/115367978/29d1cfbe-a43b-47fe-9a84-379ea75ca62d">

1. **Distributor**:
    - The distributor is a stateless component that receives time-series data from Prometheus or the Grafana agent.

    - The distributor validates the data for correctness and ensures that it is within the configured limits for a given tenant. 

    - The distributor then divides the data into batches and sends it to multiple ingesters in parallel, shards the series among ingesters, and replicates each series by the configured replication factor. By default, the configured replication factor is three.
    
    1. **Validation**:
        - The distributor cleans and validates data that it receives before writing the data to the ingesters. Because a single request can contain valid and invalid metrics, samples, metadata, and exemplars, the distributor only passes valid data to the ingesters.

        - The distributor does not include invalid data in its requests to the ingesters. If the request contains invalid data, the distributor returns a 400 HTTP status code and the details appear in the response body.

        - The details about the first invalid data are typically logged by the sender, be it Prometheus or Grafana Agent.

    2. **Rate limiting**: The distributor includes two different types of rate limiters that apply to each tenant.

        - **Request rate**: The maximum number of requests per second that can be served across Grafana Mimir cluster for each tenant.

        - **Ingestion rate**: The maximum samples per second that can be ingested across Grafana Mimir cluster for each tenant.

        > If any of these rates is exceeded, the distributor drops the request and returns an HTTP 429 response code.

    3. **High-availability tracker**:

        - Remote write senders, such as Prometheus, can be configured in pairs, which means that metrics continue to be scraped and written to Grafana Mimir even when one of the remote write senders is down for maintenance or is unavailable due to a failure. We refer to this configuration as high-availability (HA) pairs.

        - The distributor includes an HA tracker. When the HA tracker is enabled, the distributor deduplicates incoming series from Prometheus HA pairs. 
        - This enables you to have multiple HA replicas of the same Prometheus servers that write the same series to Mimir and then deduplicates the series in the Mimir distributor.

    4. **Sharding and Replication**:
        - The distributor shards and replicates incoming series across ingesters. The default replcation count is 3 by. 
        - Distributors use consistent hashing, in conjunction with a configurable replication factor, to determine which ingesters receive a given series.

        - `Sharding` and `replication` uses the ingesters’ hash ring. For each incoming series, the distributor computes a hash using the metric name, labels, and tenant ID.

        - The computed hash is called a token. The distributor looks up the token in the hash ring to determine which ingesters to write a series to.

    5. **Quorum consistency**:

        - Because distributors `share access` to the **same hash ring**, write requests can be sent to any distributor. 
        - You can also set up a **stateless load balancer** in front of it.

        - To ensure consistent query results, Mimir uses **Dynamo-style quorum consistency** on reads and writes. 
        - The distributor waits for a successful response from `n/2 + 1` ingesters, where n is the configured replication factor, before sending a successful response to the Prometheus write request.

    6. **Load balancing across distributors**:
        - Grafana Team recommend **randomly load balancing write requests** across distributor instances. If you’re running Grafana Mimir in a **Kubernetes cluster**, you can define a **Kubernetes Service** as **ingress** for the distributors.

2. **Ingester**: The ingester is a `stateful component` that writes incoming series to `long-term storage` on the **write path** and returns series samples for `queries` on the **read path**.

    - Ingesters receive incoming samples from the distributors. Each push request belongs to a tenant, and the ingester appends the received samples to the specific per-tenant TSDB that is stored on the local disk. 

    - The samples that are received are both kept in-memory and written to a `write-ahead log (WAL)`. If the ingester abruptly terminates, the WAL can help to recover the **in-memory series**. 

    - The per-tenant TSDB is lazily created in each ingester as soon as the first samples are received for that tenant.

    - The **in-memory** samples are periodically flushed to disk, and the **WAL** is truncated, when a new TSDB block is created. By default, this occurs every two hours. 

    - Each newly created block is uploaded to `long-term storage` and kept in the ingester until the configured `-blocks-storage.tsdb.retention-period` expires. This gives queriers and **store-gateways** enough time to discover the new block on the storage and download its **index-header**.
    
    - To effectively use the WAL, and to be able to `recover` the `in-memory series` if an ingester abruptly **terminates**, store the WAL to a persistent disk that can survive an ingester failure. 
    - For example, when running in the cloud, include an `AWS EBS volume`.  
    - If you are running the Grafana Mimir cluster in `Kubernetes`, you can use a **StatefulSet** with a `persistent volume` claim for the ingesters. 
    - The location on the `filesystem` where the `WAL` is stored is the same location where local TSDB blocks (compacted from head) are stored. The locations of the WAL and the local TSDB blocks cannot be `decoupled`.
    
    1. **Ingesters write de-amplification**:

        - Ingesters store recently received samples in-memory in order to perform write de-amplification. 
        - If the ingesters immediately write received samples to the long-term storage, the system would have difficulty scaling due to the high pressure on the long-term storage. 
        - For this reason, the ingesters batch and compress samples in-memory and periodically upload them to the long-term storage.
        >Note: Write de-amplification is a key factor in reducing Mimir’s total cost of ownership (TCO).

    2. **Ingesters failure and data loss**: If an ingester process crashes or exits abruptly, any in-memory time series data that have not yet been uploaded to long-term storage might be lost. There are the following ways to mitigate this failure mode:

        - Replication
        - Write-ahead log (WAL)
        - Write-behind log (WBL), only used if out-of-order ingestion is enabled.

        1. **Replication and availability**:

            - Writes to the Mimir cluster are successful if a majority of ingesters received the data. With the default replication factor of 3, this means 2 out of 3 writes to ingesters must succeed. 
            - If the Mimir cluster loses a minority of ingesters, the in-memory series samples held by the lost ingesters are available in at least one other ingester, meaning no time series samples are lost.
            - If a majority of ingesters fail, time series might be lost if the failure affects all the ingesters holding the replicas of a specific time series.

        2. **Write-ahead log**: 

            - The write-ahead log (WAL) writes all incoming series to a `persistent disk` until the series are uploaded to the `long-term storage`. If an ingester fails, a subsequent process restart replays the WAL and recovers the in-memory series samples.

            - Unlike sole replication, the WAL ensures that in-memory time series data are not lost in the case of multiple ingester failures. Each ingester can recover the data from the WAL after a subsequent restart.

            - Replication is still recommended in order to gracefully handle a single ingester failure.

        3. **Write-behind log**:

            - The write-behind log (WBL) is similar to the WAL, but it only writes incoming `out-of-order` samples to a persistent disk until the series are uploaded to `long-term` storage.

            - There is a different log for this because it is not possible to know if a sample is out-of-order until Mimir tries to append it. First Mimir needs to attempt to append it, the TSDB will detect that it is `out-of-order`, append it anyway if `out-of-order` is enabled and then write it to the log.

            - If the ingesters fail, the same characteristics as in the WAL apply.

    3. **Compactor**: The compactor increases `query performance` and reduces long-term storage usage by combining blocks.

        The compactor is the component **responsible** for:

        - Compacting multiple blocks of a given tenant into a single, optimized larger block. 
        - This deduplicates chunks and reduces the size of the index, resulting in reduced storage costs. 
        - Querying fewer blocks is faster, so it also increases query speed.

        - Keeping the per-tenant bucket index updated. The bucket index is used by queriers, store-gateways, and rulers to discover both new blocks and deleted blocks in the storage.

        - Deleting blocks that are no longer within a configurable retention period.

### The read path


<img width="788" alt="read-path" src="https://github.com/Shreyank031/Documentation/assets/115367978/81b7fdc3-5442-450f-977b-d1ea83dedae0">

1. **Query-frontend**:
Queries coming into Grafana Mimir arrive at the `query-frontend`. The query-frontend then `splits` queries over longer time ranges into multiple, smaller queries.

The query-frontend next checks the results cache. If the result of a query has been cached, the query-frontend returns the cached results. Queries that cannot be answered from the results cache are put into an in-memory queue within the query-frontend.

   - The query-frontend is a `stateless` component that provides the same API as the querier and can be used to `accelerate` the `read path`.
   - Although the query-frontend is not required, but it is recommend that you deploy it.
   - When you deploy the `query-frontend`, you should make query requests to the query-frontend instead of the queriers. 
   - The `queriers` are required within the cluster to execute the queries.

   - The query-frontend internally holds queries in an internal queue. 
   - In this situation, queriers act as workers that pull jobs from the queue, execute them, and return the results to the query-frontend for aggregation.
> Recommended to run atleast two query-frontend replicas for high availability reasons.

<img width="543" alt="query-frontend" src="https://github.com/Shreyank031/Documentation/assets/115367978/961d92e3-372f-4770-b001-d8a2cb98e442">

**The following steps describe how a query moves through the query-frontend.**

1. A `query-frontend`receives a `query`.

2. If the query is a range query, the query-frontend `splits` it by time into **multiple** smaller queries that can be `parallelized`.

3. The query-frontend checks the results `cache`. If the query result is in the cache, the query-frontend returns the **cached result**. If not, query execution continues according to the steps below.

4. If `query-sharding/partitioning` is enabled, the query-frontend attempts to shard the query for further parallelization.

5. The query-frontend places the query (or queries if splitting or sharding of the initial query occurred) in an `in-memory queue`, where it waits to be picked up by a querier.

6. A querier picks up the query from the queue and executes it. If the query was split or sharded into multiple subqueries, different queriers can pick up each of the individual queries.

7. A querier or queriers return the result to query-frontend, which then aggregates and forwards the results to the client.

## Querier

- The querier is a `stateless` component that evaluates `PromQL` expressions by fetching **time series** and **labels** on the read path.

- The querier uses the `store-gateway` component to query the **long-term storage** and the `ingester` component to query **recently written data**.

- Store-gateways and queriers can use Memcached to cache the bucket metadata:

**How it works**

- To find the correct blocks to look up at query time, queriers lazily download the bucket index when they receive the first query for a given tenant. The querier caches the bucket index in memory and periodically keeps it up-to-date.
- The bucket index contains a list of blocks and block deletion marks of a tenant. The querier later uses the list of blocks and block deletion marks to locate the set of blocks that need to be queried for the given query.

## store-gateway

- The store-gateway component, which is stateful, queries blocks from long-term storage. On the read path, the querier and the ruler use the store-gateway when handling the query, whether the query comes from a user or from when a rule is being evaluated.

- To find the right blocks to look up at query time, the store-gateway requires a view of the bucket in long-term storage. The store-gateway keeps the bucket view updated using one of the following options:

    - Periodically downloading the bucket index (default)
    - Periodically scanning the bucket

- The store-gateway uses `shuffle-sharding` to divide the blocks of each tenant across a subset of store-gateway instances.

- Store-gateways include an `auto-forget` feature that they can use to unregister an instance from another store-gateway’s ring when a store-gateway does not properly shut down.

- The store-gateway supports the following type of caches:

    1. Index cache
    2. Chunks cache
    3. Metadata cache


## Long-term storage

- The Grafana Mimir storage format is based on Prometheus TSDB storage. The Grafana Mimir storage format stores each tenant’s time series into their own TSDB, which persists series to an on-disk block. By default, each block has a two-hour range. Each on-disk block directory contains an index file, a file containing metadata, and the time series chunks.

- The TSDB block files contain samples for multiple series. The series inside the blocks are indexed by a per-block index, which indexes both metric names and labels to time series in the block files. Each series has its samples organized in chunks, which represent a specific time range of stored samples. Chunks may vary in length depending on specific configuration options and ingestion rate, usually storing around 120 samples per chunk.

**Grafana Mimir requires any of the following object stores for the block files:**

   1. Amazon S3
   2. Google Cloud Storage
   3. Microsoft Azure Storage
   4. OpenStack Swift
   5. Local Filesystem (single node only)
