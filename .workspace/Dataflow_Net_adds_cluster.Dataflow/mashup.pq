[StagingDefinition = [Kind = "FastCopy"]]
section Section1;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Net add par cluster_DataDestination", IsNewTarget = true], Settings = [Kind = "Automatic", TypeSettings = [Kind = "Table"]]]}]
shared #"Net add par cluster" = let
  Source = Lakehouse.Contents([]),
  #"Navigation 1" = Source{[workspaceId = "d65a8c5a-8ab9-47a8-94f6-18a93be16d6e"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[lakehouseId = "0229fa72-7799-4106-ab94-61fd29fedf56"]}[Data],
  #"Navigation 3" = #"Navigation 2"{[Id = "Files", ItemKind = "Folder"]}[Data],
  #"Navigation 4" = #"Navigation 3"{[Name = "Net add par cluster"]}[Content],
  #"Colonne personnalisée ajoutée" = Table.AddColumn(#"Navigation 4", "Personnalisé", each Excel.Workbook([Content], null, true)),
  #"Personnalisé développé" = Table.ExpandTableColumn(#"Colonne personnalisée ajoutée", "Personnalisé", {"Name", "Data", "Item", "Kind", "Hidden"}, {"Name.1", "Data", "Item", "Kind", "Hidden"}),
  #"Data développé" = Table.ExpandTableColumn(#"Personnalisé développé", "Data", {"Column1", "Column2", "Column3", "Column4", "Column5", "Column6", "Column7", "Column8", "Column9", "Column10", "Column11", "Column12", "Column13", "Column14", "Column15", "Column16", "Column17", "Column18", "Column19", "Column20", "Column21", "Column22", "Column23", "Column24", "Column25", "Column26", "Column27", "Column28", "Column29", "Column30", "Column31", "Column32", "Column33"}, {"Column1", "Column2", "Column3", "Column4", "Column5", "Column6", "Column7", "Column8", "Column9", "Column10", "Column11", "Column12", "Column13", "Column14", "Column15", "Column16", "Column17", "Column18", "Column19", "Column20", "Column21", "Column22", "Column23", "Column24", "Column25", "Column26", "Column27", "Column28", "Column29", "Column30", "Column31", "Column32", "Column33"}),
  #"Colonnes supprimées" = Table.RemoveColumns(#"Data développé", {"Content", "Extension", "Date accessed", "Date modified", "Date created", "Attributes", "Folder Path", "Name.1", "Item", "Kind", "Hidden"}),
  #"En-têtes promus" = Table.PromoteHeaders(#"Colonnes supprimées", [PromoteAllScalars = true]),
  #"Type de colonne changé" = Table.TransformColumnTypes(#"En-têtes promus", {{"Zone - Zone", type text}, {"Zone - Territory", type text}, {"Zone - Cluster", type text}, {"Zone - Sector", type text}, {"Zone - Sitename", type text}, {".", type text}}, "fr"),
  #"Choisir des colonnes" = Table.SelectColumns(#"Type de colonne changé", {"01-09-2025 NON_FINANCIAL_KPIS.xlsx", "Zone - Zone", "Zone - Territory", "Zone - Cluster", "GA Day", "GA Day Perf", "GA MTD", "GA MTD Gap", "GA MTD Perf", "Net Adds"}),
  #"Texte extrait avant le délimiteur" = Table.TransformColumns(#"Choisir des colonnes", {{"01-09-2025 NON_FINANCIAL_KPIS.xlsx", each Text.BeforeDelimiter(_, " ", 0), type text}}),
  #"Lignes filtrées" = Table.SelectRows(#"Texte extrait avant le délimiteur", each ([#"Zone - Cluster"] <> null and [#"Zone - Cluster"] <> "Total" and [#"Zone - Cluster"] <> "Zone - Cluster")),
  #"Colonnes renommées" = Table.RenameColumns(#"Lignes filtrées", {{"01-09-2025 NON_FINANCIAL_KPIS.xlsx", "Date"}, {"Zone - Zone", "Zone"}, {"Zone - Territory", "Territory"}, {"Zone - Cluster", "Cluster"}, {"GA Day", "GA_day"}, {"GA Day Perf", "GA_day_perf"}, {"GA MTD", "GA_MTD"}, {"GA MTD Gap", "GA_MTD_gap"}, {"GA MTD Perf", "GA_MTD_perf"}, {"Net Adds", "Net_adds"}}),
  #"Type de colonne changé 1" = Table.TransformColumnTypes(#"Colonnes renommées", {{"GA_day", Int64.Type}, {"GA_day_perf", type number}, {"GA_MTD", Int64.Type}, {"GA_MTD_gap", type number}, {"GA_MTD_perf", type number}, {"Net_adds", Int64.Type}}),
  #"Colonne personnalisée ajoutée 1" = Table.TransformColumnTypes(Table.AddColumn(#"Type de colonne changé 1", "Target GA day", each [GA_day] / [GA_day_perf]), {{"Target GA day", type number}}),
  #"Type de colonne changé 2" = Table.TransformColumnTypes(#"Colonne personnalisée ajoutée 1", {{"Date", type date}}),
  #"Colonnes renommées 1" = Table.RenameColumns(#"Type de colonne changé 2", {{"Target GA day", "Target_GA_day"}})
in
  #"Colonnes renommées 1";
shared #"Net add par cluster_DataDestination" = let
  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false]),
  Navigation_1 = Pattern{[workspaceId = "d65a8c5a-8ab9-47a8-94f6-18a93be16d6e"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "0229fa72-7799-4106-ab94-61fd29fedf56"]}[Data],
  TableNavigation = Navigation_2{[Id = "Net_add_cluster_nettoyé", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
