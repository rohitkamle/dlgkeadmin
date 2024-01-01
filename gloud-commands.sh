PROJECT_ID="fabled-era-408608"
WIF_POOL_NAME="dlwifpoolgkeadmin"
WIF_POOL_DISPLAY_NAME="DL DEMO WIF POOL for GKE Admin"
WIF_PROVIDER_NAME="dlwifprovidergkeadmin"
SA_NAME="dlgkedemosagkadmin"
SA_DISPLAY_NAME="DL DEMO SERVICE ACCOUNT FOR GITHUB ACTION for GKE Admin"
GITHUB_REPO="rohitkamle/dlgkeadmin"


echo $PROJECT_ID
echo $PROJECT_ID
echo $WIF_POOL_NAME
echo $WIF_POOL_DISPLAY_NAME
echo $WIF_PROVIDER_NAME
echo $SA_NAME
echo $SA_DISPLAY_NAME
echo $GITHUB_REPO

# CREATE SERVICE ACCOUNT
gcloud iam service-accounts create $SA_NAME --description="Service account for Terraform GCP deployment" --display-name="$SA_DISPLAY_NAME"

# ASSIGN PERSMISSIONS TO SERVICE ACCOUNT
gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com" --role="roles/container.admin"

# CREATED MANAGED IDENTITY POOL AND PROVIDER
gcloud iam workload-identity-pools create $WIF_POOL_NAME --project $PROJECT_ID --location "global" --display-name "$WIF_POOL_DISPLAY_NAME"

gcloud iam workload-identity-pools providers create-oidc $WIF_PROVIDER_NAME --project $PROJECT_ID --location="global" --workload-identity-pool=$WIF_POOL_NAME --display-name=$WIF_PROVIDER_NAME --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.aud=assertion.aud,attribute.repository=assertion.repository" --issuer-uri="https://token.actions.githubusercontent.com"


# GET PROJECT NUMBER
PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")

#THIS STEP IS IMPORTANT TO ASSIGNING WORKLOAD IDENTITY PROVIDER TO SERVICES ACCOUNT MAPPING AND GITHUB ACCOUNT DETAILS.
gcloud iam service-accounts add-iam-policy-binding "$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com" --project="$PROJECT_ID" --role="roles/iam.workloadIdentityUser" --member="principalSet://iam.googleapis.com/projects/$PROJECT_NUMBER/locations/global/workloadIdentityPools/$WIF_POOL_NAME/attribute.repository/$GITHUB_REPO"



GCP_WORKLOAD_IDENTITY_PROVIDER=$(gcloud iam workload-identity-pools providers describe $WIF_PROVIDER_NAME --project $PROJECT_ID --location="global" --workload-identity-pool=$WIF_POOL_NAME --format="value(name)" )

# output: projects/717097444127/locations/global/workloadIdentityPools/dlwifpool/providers/dlwifprovider

# Below command it get the Service Account name which needs to be added in Github secrets as GCP_SERVICE_ACCOUNT
GCP_SERVICE_ACCOUNT=$(gcloud iam service-accounts describe $SA_NAME@$PROJECT_ID.iam.gserviceaccount.com --project=$PROJECT_ID --format="value(email)")

#output: dlgkedemosatf@fabled-era-408608.iam.gserviceaccount.com

echo "GCP_WORKLOAD_IDENTITY_PROVIDER = $GCP_WORKLOAD_INDENTITY_PROVIDER"
echo "GCP_SERVICE_ACCOUNT = $GCP_SERVICE_ACCOUNT"








