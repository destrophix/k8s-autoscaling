# k8s-autoscaling

### Prerequisites
1. [Rancher Desktop](https://rancherdesktop.io/)
2. K8s Version 1.30.3

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