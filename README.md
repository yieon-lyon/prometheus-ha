# Prometheus HA + Thanos + S3
고가용성 확보를 위한 Prometheus의 병렬구조와 Thanos를 사용한 중복 Metric 제거, S3 연동으로 데이터 장기 보존

## your changed values

[x] thanos/thanos-storage-config.yaml, thanos/build.sh
  - access_key: {YOUR_ACCESS_KEY} 
  - secret_key: {YOUR_PASS_KEY}
  - ECR_REGISTRY

[x] prometheus-operator/*-pv.yaml
  - set your vol-ID

[x] prometheus-operator/values.yaml
  - check smtp
  - check ingress
  - check thanos image

## install
```bash
$ ./deploy.sh
```

## heap check
```bash
$ go tool pprof -svg <prometheus url>/debug/pprof/heap > heap.svg
```