# dlgkeadmin
# GKE Cluster Tools Deployment

This repository contains GitHub Actions workflow files to deploy various tools into a Google Kubernetes Engine (GKE) cluster.

## Prerequisites

Before running the GitHub Actions workflow, make sure you have performed the following steps:

1. **Configure Google Cloud SDK**: Execute the commands in `gcloud-commands.sh` in your Google Cloud Shell or ensure that you have configured the Google Cloud SDK.

## GitHub Actions Workflows

### Install Nginx Controller

- **Workflow File**: [.github/workflows/kubeconfig.yaml]
- **Environment Variables**:
    - `GCP_REGION`: Set this to your desired Google Cloud region.
    - `GCP_CLUSTER_NAME`: Set this to the name of your GKE cluster.

This workflow installs Nginx Ingress Controller into the specified GKE cluster.

### Install Prometheus and Grafana

This workflow installs 
- Ingress controller 
- Prometheus 
- Grafana 

into the specified GKE cluster. Grafana is configured to use Prometheus as a data source.

## How to Run

1. Fork this repository.
2. Update the GitHub Action secrets in your forked repository settings.
3. Commit changes to trigger the desired GitHub Actions workflow.
4. Monitor the workflow progress in the "Actions" tab of your GitHub repository.

Note: Ensure that the prerequisite commands in `gcloud-commands.sh` have been executed before running the workflows.

