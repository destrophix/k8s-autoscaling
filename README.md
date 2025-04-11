# k8s-autoscaling


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