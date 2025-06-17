import os
import shutil
from collections import defaultdict

# Arbeitsverzeichnis mit allen CSV-Dateien
input_dir = r"C:\Users\backesne\Desktop\ZENSUS 2022"

# Definition der Gittertypen und zugehörigen Ordner
gittertypen = {
    "100m-Gitter": ("100m-Gitter", "100m"),
    "1km-Gitter": ("1km-Gitter", "1km"),
    "10km-Gitter": ("10km-Gitter", "10km")
}

# 1. Alle CSV-Dateien scannen und in Gruppen sortieren
gruppen = defaultdict(dict)

for file in os.listdir(input_dir):
    if not file.endswith(".csv"):
        continue
    for gittertyp in gittertypen:
        if file.endswith(f"_{gittertyp}.csv"):
            merkmal = file.replace(f"_{gittertyp}.csv", "")
            gruppen[merkmal][gittertyp] = file
            break  # keine weitere Prüfung nötig

# 2. Zielordner vorbereiten und Dateien kopieren
dokumentation_path = os.path.join(input_dir, "dokumentation.txt")
with open(dokumentation_path, "w", encoding="utf-8") as doc_file:
    for nummer, (merkmal, gitter_dict) in enumerate(sorted(gruppen.items()), start=1):
        doc_file.write(f"{nummer} -> {merkmal}\n")
        print(f"\nMerkmal {nummer}: {merkmal}")
        for gittertyp, filename in gitter_dict.items():
            ordnername, label = gittertypen[gittertyp]
            zielordner = os.path.join(input_dir, ordnername)
            os.makedirs(zielordner, exist_ok=True)

            quellpfad = os.path.join(input_dir, filename)
            zielname = f"{nummer}_{label}.csv"
            zielpfad = os.path.join(zielordner, zielname)

            shutil.copy2(quellpfad, zielpfad)
            print(f"  → {filename} → {zielordner}\\{zielname}")

print("\nFertig! Alles wurde einsortiert und dokumentiert.")