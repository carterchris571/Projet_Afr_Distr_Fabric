[StagingDefinition = [Kind = "FastCopy"]]
section Section1;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "DTR_DTC_cluster_nettoyé_DataDestination", IsNewTarget = true], Settings = [Kind = "Automatic", TypeSettings = [Kind = "Table"]]]}]
shared DTR_DTC_cluster_nettoyé = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "d65a8c5a-8ab9-47a8-94f6-18a93be16d6e"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "0229fa72-7799-4106-ab94-61fd29fedf56"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "Files", ItemKind = "Folder"]}[Data],
  #"Navigation 3" = #"Navigation 2"{[Name = "Fichier_DTR-Perf_DCT-Perf_Net-ADDS par cluster"]}[Content],
  #"Colonne personnalisée ajoutée" = Table.AddColumn(#"Navigation 3", "Personnalisé", each Excel.Workbook([Content], null, true)),
  #"Personnalisé développé" = Table.ExpandTableColumn(#"Colonne personnalisée ajoutée", "Personnalisé", {"Name", "Data", "Item", "Kind", "Hidden"}, {"Name.1", "Data", "Item", "Kind", "Hidden"}),
  #"Data développé" = Table.ExpandTableColumn(#"Personnalisé développé", "Data", {"Column1", "Column2", "Column3", "Column4", "Column5", "Column6", "Column7", "Column8", "Column9", "Column10", "Column11", "Column12", "Column13", "Column14", "Column15", "Column16", "Column17", "Column18", "Column19", "Column20", "Column21", "Column22", "Column23", "Column24", "Column25", "Column26", "Column27", "Column28", "Column29", "Column30", "Column31", "Column32", "Column33", "Column34", "Column35", "Column36", "Column37", "Column38", "Column39", "Column40", "Column41", "Column42", "Column43", "Column44", "Column45", "Column46", "Column47", "Column48", "Column49", "Column50", "Column51", "Column52", "Column53", "Column54", "Column55", "Column56", "Column57", "Column58", "Column59", "Column60", "Column61", "Column62", "Column63"}, {"Column1", "Column2", "Column3", "Column4", "Column5", "Column6", "Column7", "Column8", "Column9", "Column10", "Column11", "Column12", "Column13", "Column14", "Column15", "Column16", "Column17", "Column18", "Column19", "Column20", "Column21", "Column22", "Column23", "Column24", "Column25", "Column26", "Column27", "Column28", "Column29", "Column30", "Column31", "Column32", "Column33", "Column34", "Column35", "Column36", "Column37", "Column38", "Column39", "Column40", "Column41", "Column42", "Column43", "Column44", "Column45", "Column46", "Column47", "Column48", "Column49", "Column50", "Column51", "Column52", "Column53", "Column54", "Column55", "Column56", "Column57", "Column58", "Column59", "Column60", "Column61", "Column62", "Column63"}),
  #"En-têtes promus" = Table.PromoteHeaders(#"Data développé", [PromoteAllScalars = true]),
  #"Choisir des colonnes" = Table.SelectColumns(#"En-têtes promus", {"01-09-2025 LOADING_DRIVERS.xlsx", "Zone - Zone", "Zone - Territory", "Zone - Cluster", "Lo Day Perf", "DTR Day", "DTC Day", "DTC Day Perf", "Lo MTD Perf", "DTR MTD", "DTR MoM", "DTR Gap vs LM", "DTC MTD", "DTC MTD Perf", "DTC MoM", "DTC Gap vs LM"}),
  #"Lignes filtrées" = Table.SelectRows(#"Choisir des colonnes", each ([#"Zone - Cluster"] <> null and [#"Zone - Cluster"] <> "Total" and [#"Zone - Cluster"] <> "Zone - Cluster")),
  #"Texte extrait avant le délimiteur" = Table.TransformColumns(#"Lignes filtrées", {{"01-09-2025 LOADING_DRIVERS.xlsx", each Text.BeforeDelimiter(_, " ", 0), type text}}),
  #"Type de colonne changé 1" = Table.TransformColumnTypes(#"Texte extrait avant le délimiteur", {{"01-09-2025 LOADING_DRIVERS.xlsx", type date}, {"Lo Day Perf", type number}, {"DTR Day", type number}, {"DTC Day", type number}, {"DTC Day Perf", type number}, {"Lo MTD Perf", type number}, {"DTR MTD", type number}, {"DTR MoM", type number}, {"DTR Gap vs LM", type number}, {"DTC MTD", type number}, {"DTC MTD Perf", type number}, {"DTC MoM", type number}, {"DTC Gap vs LM", type number}}),
  #"Colonnes renommées" = Table.RenameColumns(#"Type de colonne changé 1", {{"01-09-2025 LOADING_DRIVERS.xlsx", "Date"}, {"Zone - Zone", "Zone"}, {"Zone - Territory", "Territory"}, {"Zone - Cluster", "Cluster"}, {"Lo Day Perf", "DTR Day Perf"}}),
  #"Colonne personnalisée ajoutée 1" = Table.AddColumn(#"Colonnes renommées", "Target DTR day", each [DTR Day] / [DTR Day Perf]),
  #"Colonne personnalisée ajoutée 2" = Table.AddColumn(#"Colonne personnalisée ajoutée 1", "Target DTC day", each [DTC Day] / [DTC Day Perf]),
  #"Type de colonne changé 2" = Table.TransformColumnTypes(#"Colonne personnalisée ajoutée 2", {{"Target DTR day", type number}, {"Target DTC day", type number}}),
  #"Lignes triées" = Table.Sort(#"Type de colonne changé 2", {{"Cluster", Order.Ascending}}),
  #"Type de colonne changé" = Table.TransformColumnTypes(#"Lignes triées", {{"Zone", type text}, {"Territory", type text}, {"Cluster", type text}})
in
  #"Type de colonne changé";
shared NavigationQuery = let
  Source = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false])
in
  Source;
shared DTR_DTC_cluster_nettoyé_DataDestination = let
  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false]),
  Navigation_1 = Pattern{[workspaceId = "d65a8c5a-8ab9-47a8-94f6-18a93be16d6e"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "0229fa72-7799-4106-ab94-61fd29fedf56"]}[Data],
  TableNavigation = Navigation_2{[Id = "DTR_DTC_cluster_nettoyé", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
