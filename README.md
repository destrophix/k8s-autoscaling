# k8s-autoscaling

### Prerequisites

1. [Rancher Desktop](https://rancherdesktop.io/)
2. K8s Version 1.30.3
3. https://github.com/rakyll/hey

### Steps to run app

1. Install poetry
   ```sh
   pip install poetry
   ```
2. Change directory to app_demo
3. Run poetry install
   ```sh
   poetry install
   ```
4. Active Virtual Environment
   ```sh
   $(poetry env activate)
   ```
5. Run the application using
   ```sh
   uvicorn src.foo-app.main:app --reload
   ```

### Steps to simulate load

1. Without Keda
   1. Deploy Deployment and Service
   ```
   kc apply -f deployment.yaml
   kc apply -f service.yaml
   ```
   2. Portforward the service
   ```
   kc port-forward svc/foo-app 8000:8000
   ```
   4. Get a response
   ```
   curl http://localhost:8000/foo
   ```
   5. Load test
   ```
   hey -z 60s -c 100 -q 200  http://localhost:8000/foo
   ```
2. With Keda HttpScaledObject
   1. Increase the timeouts for interceptor by running the shell script
   ```
   chmod +x ./deployment/patch_keda_http_add_on.sh
   ./deployment/patch_keda_http_add_on.sh
   ```
   2. Deploy Deployment, Service and ScaledObject
   ```
   kc apply -f deployment.yaml
   kc apply -f service.yaml
   kc apply -f scaled_object.yaml
   ```
   3. Portforward the service for http add on's interceptor
   ```
   kc port-forward svc/keda-add-ons-http-interceptor-proxy 8080:8080
   ```
   4. Get a response
   ```
   curl -H "Host: foo.local" http://localhost:8080/foo
   ```
   5. Load test
   ```
   hey -z 60s -c 100 -q 200 --host foo.local http://localhost:8080/foo
   ```

### Steps to setup KEDA

1. Install Metrics Server

   ```sh
   helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/

   helm upgrade --install metrics-server metrics-server/metrics-server
   ```

2. Install KEDA

   ```sh
   helm repo add kedacore https://kedacore.github.io/charts

   helm upgrade --install keda kedacore/keda
   ```

3. Install HTTP Add On

   ```sh
   helm upgrade --install http-add-on kedacore/keda-add-ons-http
   ```

### Steps to setup VPA
1. Clone autoscaler repository
   ```shell
   git clone https://github.com/kubernetes/autoscaler.git
   ```
2. Run to setup script
   ```shell
    ./autoscaler/vertical-pod-autoscaler/hack/vpa-up.sh
   ```

### Steps to make VPA trigger updates faster
1. Update vpa recommender to send recommendations more frequenty
   ```shell
   # Edit vpa-recommender deployment in kube-system namespace
   args:
    - --recommender-interval=2s
   ```
2. Update vpa updater to update the pods more frequently
   ```shell
   # Edit vpa-updater deployment in kube-system namespace
   args:
    - --in-recommendation-bounds-eviction-lifetime-threshold=5s
    - --updater-interval=5s
   ```
For more details about the flags, refer [here](https://github.com/kubernetes/autoscaler/blob/master/vertical-pod-autoscaler/docs/flags.md)