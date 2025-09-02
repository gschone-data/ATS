import requests
import os

GITHUB_TOKEN = os.getenv("TOKEN_GIT")  # Assurez-vous que le token est stocké dans une variable d'environnement
OWNER = "gschone-data"
REPO = "ATS"
ARTIFACT_NAME = "stock-data-csv"

headers = {
    "Authorization": f"token {GITHUB_TOKEN}",
    "Accept": "application/vnd.github+json"
}

# 1. Lister tous les artifacts du dépôt
artifacts_url = f"https://api.github.com/repos/{OWNER}/{REPO}/actions/artifacts"
resp = requests.get(artifacts_url, headers=headers)
resp.raise_for_status()
artifacts = resp.json()["artifacts"]

# 2. Supprimer ceux qui correspondent au nom
for artifact in artifacts:
    if artifact["name"] == ARTIFACT_NAME:
        delete_url = artifact["url"]
        del_resp = requests.delete(delete_url, headers=headers)
        if del_resp.status_code == 204:
            print(f"Supprimé: {artifact['name']} (ID: {artifact['id']})")
        else:
            print(f"Erreur suppression: {artifact['name']} (ID: {artifact['id']})")