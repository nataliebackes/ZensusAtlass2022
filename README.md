1) CSV-Dateien organisieren zur Weiterverarbeitung
  - Vorbereitung: alle CSV Dateien runterladen und in einem Ordner entpacken
  -> Python Skript "sort_files" sortiert die Datensätze nach Grid-Level und benennt sie zur Schleifenverarbeitung um
  -> in txt Datei wird Dokumentation erstellt (Nummerierung + Datensatzname)

2) Merging mit Zensus_CSVtoSTATA.do
     Note: hab mich für Stata entschieden; Verarbeitung dauert zwar länger, aber war für mich als Plattform zur Aufbereitung angenehmer weil Plausibilitätschecks mit databrowser usw entspannter als in python 
     (ansonsten ist python merge + import in Stata natürlich zeiteffizienter)
   -> Datensätze werden anhand gitter id zusammengefügt
   -> Datentypen werden optimiert (String vars -> numerische vars) 
  - Unterkapitel für die verschiedenen Ebenen

3) Zensus 2011 Aufbereitung mit ZENSUS2011wide_and_merge.py
   - Long to Wide Format: Achtung, der Code braucht relativ lange
   -> wandelt erst Subdatasets um
   -> merged dann anhand gitter_id zusammen
   -> erstellt Datenhandbuch
   Note: die automatisch generierten Variablennamen sind für Stata User nicht mehr lesbar (>32 Zeichen), deswegen habe ich mich für die durchnummerierung der Variablen entschieden
