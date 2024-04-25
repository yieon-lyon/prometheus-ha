# Prometheus HA + Thanos + S3 + Loki-3
- 고가용성 확보를 위한 Prometheus의 병렬구조와 Thanos를 사용한 중복 Metric 제거
- S3 연동으로 데이터 장기 보존
- Loki-3를 사용한 logging stack

## Architecture
![](./yieon-prometheus-ha.svg)

## Your changed values

[x] thanos/thanos-storage-config.yaml, thanos/build.sh
  - access_key: {YOUR_ACCESS_KEY} 
  - secret_key: {YOUR_SECRET_KEY}
  - ECR_REGISTRY

[x] prometheus-operator/*-pv.yaml
  - set your vol-ID

[x] prometheus-operator/values.yaml
  - check smtp
  - check ingress
  - check thanos image

[x] loki/values.yaml
  - access_key: {YOUR_ACCESS_KEY}
  - secret_key: {YOUR_SECRET_KEY}

## Install
```bash
$ ./deploy.sh
```

## Heap check
```bash
$ go tool pprof -svg <prometheus url>/debug/pprof/heap > heap.svg
```

---
## Loki
Helm chart for Grafana Loki in simple, scalable mode

![Loki](loki.png)

> Grafana Loki is a set of components that can be composed into a fully featured logging stack.

> Unlike other logging systems, Loki is built around the idea of only indexing metadata about your logs: labels (just like Prometheus labels). Log data itself is then compressed and stored in chunks in object stores such as Amazon Simple Storage Service (S3) or Google Cloud Storage (GCS), or even locally on the filesystem.
A small index and highly compressed chunks simplifies the operation and significantly lowers the cost of Loki.

Pull in any logs with Promtail

Promtail is a logs collector built specifically for Loki. It uses the same service discovery as Prometheus and includes analogous features for labeling, transforming, and filtering logs before ingestion into Loki.

Store the logs in Loki

Loki does not index the text of logs. Instead, entries are grouped into streams and indexed with labels.Not only does this reduce costs, it also means log lines are available to query within milliseconds of being received by Loki.

Use LogQL to explore

Use Loki’s powerful query language, LogQL, to explore your logs. Run LogQL queries directly within Grafana to visualize your logs alongside other data sources, or with LogCLI, for those who prefer a command line experience.

Alert on your logs

Set up alerting rules for Loki to evaluate on your incoming log data. Configure Loki to send the resulting alerts to a Prometheus Alertmanager so they can then get routed to the right team.

---

https://grafana.com/docs/loki/latest/setup/install/helm/concepts/


Loki를 운영하게 되면 필연적으로 스토리지가 필요하게 됩니다. 데이터를 PV에 저장하게 되면 디스크 크기가 한정적이고 용량한계에 도달하게 되면 Loki는 작동을 중지하게 됩니다.
AWS EBS를 사용한다해도 스토리지 가용공간 및 보존기간을 예측해야되며 롤백 및 HA를 고려해야합니다.

#### Loki에서 S3는 기본적으로 지원하는 외부 스토리지이며, 높은 가용성과 확장성을 가지고 있고 비용 효율적이기 때문에 운영자입장에서는 고려해야 할 부분이 줄어들게됩니다.

S3의 비용은 매우 저렴한편이며 일반적으로 Object Storage인 S3는 EBS보다 성능이 떨어집니다. 하지만, Loki의 경우 쿼리 요구 사항이 복잡하지 않습니다.