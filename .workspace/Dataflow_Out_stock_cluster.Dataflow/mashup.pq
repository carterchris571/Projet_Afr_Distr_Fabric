[StagingDefinition = [Kind = "FastCopy"]]
section Section1;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "OOS et Day stock par cluster_DataDestination", IsNewTarget = true], Settings = [Kind = "Automatic", TypeSettings = [Kind = "Table"]]]}]
shared #"OOS et Day stock par cluster" = let
  Source = Lakehouse.Contents([]),
  #"Navigation 1" = Source{[workspaceId = "d65a8c5a-8ab9-47a8-94f6-18a93be16d6e"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[lakehouseId = "0229fa72-7799-4106-ab94-61fd29fedf56"]}[Data],
  #"Navigation 3" = #"Navigation 2"{[Id = "Files", ItemKind = "Folder"]}[Data],
  #"Navigation 4" = #"Navigation 3"{[Name = "OOS et Day stock par cluster"]}[Content],
  #"Colonne personnalisée ajoutée" = Table.AddColumn(#"Navigation 4", "Personnalisé", each Excel.Workbook([Content], null, true)),
  #"Personnalisé développé" = Table.ExpandTableColumn(#"Colonne personnalisée ajoutée", "Personnalisé", {"Name", "Data", "Item", "Kind", "Hidden"}, {"Name.1", "Data", "Item", "Kind", "Hidden"}),
  #"Data développé" = Table.ExpandTableColumn(#"Personnalisé développé", "Data", {"Column1", "Column2", "Column3", "Column4", "Column5", "Column6", "Column7", "Column8", "Column9", "Column10", "Column11", "Column12"}, {"Column1", "Column2", "Column3", "Column4", "Column5", "Column6", "Column7", "Column8", "Column9", "Column10", "Column11", "Column12"}),
  #"Colonnes supprimées" = Table.RemoveColumns(#"Data développé", {"Content", "Extension", "Date accessed", "Date modified", "Date created", "Attributes", "Folder Path", "Name.1", "Item", "Kind", "Hidden"}),
  #"En-têtes promus" = Table.PromoteHeaders(#"Colonnes supprimées", [PromoteAllScalars = true]),
  #"Type de colonne changé" = Table.TransformColumnTypes(#"En-têtes promus", {{"ZONE", type text}, {"SA_NAME", type text}, {"TERRITORY", type text}, {"CLUSTER", type text}}, "fr"),
  #"Lignes filtrées" = Table.SelectRows(#"Type de colonne changé", each ([CLUSTER] <> null and [CLUSTER] <> "CLUSTER" and [CLUSTER] <> "Total")),
  #"Choisir des colonnes" = Table.SelectColumns(#"Lignes filtrées", {"01-09-2025 data_ofs.xlsx", "ZONE", "SA_NAME", "TERRITORY", "CLUSTER", "# Distinct HVC", "# Avg HVC OOS", "#day HVC", "%OOS HVC"}),
  #"Texte extrait avant le délimiteur" = Table.TransformColumns(#"Choisir des colonnes", {{"01-09-2025 data_ofs.xlsx", each Text.BeforeDelimiter(_, " ", 0), type text}}),
  #"Colonnes renommées" = Table.RenameColumns(#"Texte extrait avant le délimiteur", {{"01-09-2025 data_ofs.xlsx", "Date"}, {"ZONE", "Zone"}, {"SA_NAME", "SA_name"}, {"TERRITORY", "Territory"}, {"CLUSTER", "Cluster"}, {"# Distinct HVC", "#Distinct_HVC"}, {"# Avg HVC OOS", "#_Avg_HVC_OOS"}, {"#day HVC", "#day_HVC"}, {"%OOS HVC", "%OOS_HVC"}}),
  #"Type de colonne changé 1" = Table.TransformColumnTypes(#"Colonnes renommées", {{"#Distinct_HVC", Int64.Type}, {"#_Avg_HVC_OOS", Int64.Type}, {"#day_HVC", type number}}),
  #"Colonne personnalisée ajoutée 1" = Table.AddColumn(#"Type de colonne changé 1", "P_OOS", each [#"#_Avg_HVC_OOS"] / [#"#Distinct_HVC"]),
  #"Colonnes renommées 1" = Table.RenameColumns(#"Colonne personnalisée ajoutée 1", {{"#_Avg_HVC_OOS", "#Avg_HVC_OOS"}}),
  #"Type de colonne changé 2" = Table.TransformColumnTypes(#"Colonnes renommées 1", {{"P_OOS", type number}, {"%OOS_HVC", type number}, {"Date", type date}})
in
  #"Type de colonne changé 2";
shared #"OOS et Day stock par cluster_DataDestination" = let
  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false]),
  Navigation_1 = Pattern{[workspaceId = "d65a8c5a-8ab9-47a8-94f6-18a93be16d6e"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "0229fa72-7799-4106-ab94-61fd29fedf56"]}[Data],
  TableNavigation = Navigation_2{[Id = "Out_stock_cluster_nettoye", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
