import re
import yaml

qmd_path = "ATS.qmd"
yaml_path = "liste.yaml"

# Lire le fichier ATS.qmd
with open(qmd_path, "r") as f:
    content = f.read()

# Extraire toutes les valeurs de actif="..."
actifs = re.findall(r'actif\s*=\s*"([^"]+)"', content)

# Supprimer les doublons et trier
actifs = sorted(set(actifs))

# Mettre à jour le fichier YAML
with open(yaml_path, "w") as f:
    f.write("symbols:\n")
    for actif in actifs:
        f.write(f'  - "{actif}"\n')
        
print(f"{len(actifs)} actifs extraits et ajoutés à {yaml_path}")