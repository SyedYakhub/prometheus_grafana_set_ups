#!/bin/bash

#Install grafana using helm
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm install grafana grafana/grafana
kubectl patch service grafana -p '{"spec": {"type": "NodePort"}}'

#Alternatively you can also edit service and change type=NodePort using below command
#kubectl edit svc grfana

#Else you can expose extra svc with the below details
#kubectl expose service grafana --type=NodePort --target-port=3000 --name=grafana-ext




# To check the installed charts in Helm, you can use the `helm list` command. This command will display a list of all the releases (deployments) installed in your Kubernetes cluster using Helm.

# Here's how you can use the `helm list` command to check the installed Grafana chart:

# ```bash
# helm list
# ```

# This will provide an output that looks something like this:

# ```
# NAME            NAMESPACE       REVISION    UPDATED                                 STATUS      CHART                APP VERSION
# grafana         default         1           2023-07-22 12:34:56.789012345 UTC    deployed    grafana-5.0.4        8.2.1
# ```

# In the above output, you can see the following information:

# - `NAME`: The name of the Helm release (in this case, `grafana`).

# - `NAMESPACE`: The namespace where the release is installed (default namespace in this example).

# - `REVISION`: The revision number of the release. Helm assigns a unique revision number to each upgrade or rollback.

# - `UPDATED`: The timestamp when the release was last updated.

# - `STATUS`: The current status of the release, which can be `deployed`, `failed`, etc.

# - `CHART`: The name of the Helm chart used for the installation (`grafana-5.0.4` in this example).

# - `APP VERSION`: The version of the application installed (Grafana version `8.2.1` in this example).

# If you have installed multiple Helm releases, you will see all of them listed in the output. The `helm list` command is useful for checking the status and details of all your installed Helm releases, including Grafana.



# To check the files inside a Grafana Helm chart, you can use the `helm show` command with the `chart` subcommand. This will display the contents of the Helm chart, including all the files and configurations that make up the chart.
# Here's how you can check the files inside the Grafana Helm chart:

# helm show chart grafana/grafana
# This will output the chart's contents, including its files and configurations, to the console.




# Alternatively, you can also download and unpack the Helm chart to inspect its contents in more detail. Here's how you can do that:
# 1. First, fetch the Helm chart package from the repository:
# helm fetch grafana/grafana


# 2. Once you have the Helm chart package (it will have a `.tgz` extension), you can unpack it using `tar`:
# tar -zxvf grafana-x.x.x.tgz
# Replace `grafana-x.x.x.tgz` with the actual name of the Helm chart package you downloaded.


# After unpacking the chart, you can explore its contents by navigating through the directories and files. You will find various YAML files, templates, and other resources that define the configuration and resources for installing Grafana in your Kubernetes cluster.
# Please note that the specific contents of the Helm chart may vary based on the version of the chart and any customizations made by the maintainers. Always refer to the official documentation and GitHub repository of the Helm chart for more detailed information on its structure and configuration.