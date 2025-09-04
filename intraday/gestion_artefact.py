import requests
import zipfile
import io
import os
import pandas as pd


def load_intraday():
    GITHUB_TOKEN = os.getenv("TOKEN_GIT")  # Assurez-vous que le token est stocké dans une variable d'environnement
    OWNER = "gschone-data"
    REPO = "ATS"
    WORKFLOW_ID = "update_stock_data.yml"  # ID du workflow, peut être le nom du fichier yml
    ARTIFACT_NAME = "stock-data-csv"
    FILE_NAME = 'donnees.csv'  # Nom du fichier à extraire de l'artifact
    headers = {
        "Authorization": f"token {GITHUB_TOKEN}",
        "Accept": "application/vnd.github+json"
    }

    # 1. Lister les runs du workflow
    runs_url = f"https://api.github.com/repos/{OWNER}/{REPO}/actions/workflows/{WORKFLOW_ID}/runs"
    runs_resp = requests.get(runs_url, headers=headers)
    runs_resp.raise_for_status()
    runs = runs_resp.json()["workflow_runs"]

    if not runs:
        raise Exception("Aucune exécution du workflow trouvée.")

    run_id = runs[0]["id"]  # prendre la dernière run (la plus récente)

    # 2. Lister les artifacts de la run
    artifacts_url = f"https://api.github.com/repos/{OWNER}/{REPO}/actions/runs/{run_id}/artifacts"
    artifacts_resp = requests.get(artifacts_url, headers=headers)
    artifacts_resp.raise_for_status()
    artifacts = artifacts_resp.json()["artifacts"]

    artifact_id = None
    for a in artifacts:
        if a["name"] == ARTIFACT_NAME:
            artifact_id = a["id"]
            break

    if artifact_id is None:
        raise ImportError(f"Artifact nommé '{ARTIFACT_NAME}' non trouvé dans la run {run_id}")
    # 3. Télécharger le ZIP de l’artifact
    download_url = f"https://api.github.com/repos/{OWNER}/{REPO}/actions/artifacts/{artifact_id}/zip"
    zip_resp = requests.get(download_url, headers=headers)
    zip_resp.raise_for_status()

    # 4. Extraire et renvoyer les données
    with zipfile.ZipFile(io.BytesIO(zip_resp.content)) as z:
        try: df= pd.read_csv(z.open(f"{FILE_NAME}"))  # Adapter le nom du fichier selon le contenu de l’archive
        except Exception as e:
            raise ImportError(f"Erreur lors de la lecture du fichier '{FILE_NAME}' dans l'artifact: {e}")
    return df