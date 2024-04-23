kubectl create namespace monitoring
kubectl -n monitoring create secret generic thanos-objstore-config --from-file=objstore.yml=./thanos/thanos-storage-config.yaml

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts #prometheus
helm repo add bitnami https://charts.bitnami.com/bitnami #thanos

helm repo update

# Chart Versions
PROMETHEUS_OPERATOR_VERSION="57.2.0"
PROMETHEUS_ADAPTOR_VERSION="4.4.1"
PROMETHEUS_BLACK_BOX_EXPORTER_VERSION="8.3.0"
PROMETHEUS_PUSHGATEWAY_VERSION="2.4.0"
THANOS_VERSION="15.0.5"
LOKI_VERSION="6.3.3"
PROMTAIL_VERSION="6.15.5"
VALUES_PATH="values.yaml"

# prometheus-operator
helm install prometheus-operator -n monitoring \
    prometheus-community/kube-prometheus-stack \
    --version $PROMETHEUS_OPERATOR_VERSION \
    --values "prometheus-operator/${VALUES_PATH}"

# prometheus-blackbox-exporter
helm install prometheus-blackbox-exporter -n monitoring \
    prometheus-community/prometheus-blackbox-exporter \
    --version $PROMETHEUS_BLACK_BOX_EXPORTER_VERSION \
    --values "prometheus-blackbox-exporter/${VALUES_PATH}"

# prometheus-adapter
helm install prometheus-adapter -n monitoring \
    prometheus-community/prometheus-adapter \
    --version $PROMETHEUS_ADAPTOR_VERSION \
    --values "prometheus-adapter/${VALUES_PATH}"

# prometheus-pushgateway
helm install prometheus-pushgateway -n monitoring \
    prometheus-community/prometheus-pushgateway \
    --version $PROMETHEUS_PUSHGATEWAY_VERSION \
    --values "prometheus-pushgateway/${VALUES_PATH}"

# thanos
helm install thanos -n monitoring \
    bitnami/thanos \
    --version THANOS_VERSION \
    --values "thanos/${VALUES_PATH}"

# loki
helm install loki -n monitoring \
    grafana/loki \
    --version $LOKI_VERSION |
    --values "loki/${VALUES_PATH}"

# promtail
helm install promtail -n monitoring \
    grafana/promtail \
    --version $PROMTAIL_VERSION |
    --values "promtail/${VALUES_PATH}"