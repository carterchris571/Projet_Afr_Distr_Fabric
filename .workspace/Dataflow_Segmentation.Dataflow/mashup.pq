[StagingDefinition = [Kind = "FastCopy"]]
section Section1;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Segmentation centre 2 et 3 xlsx_DataDestination", IsNewTarget = true], Settings = [Kind = "Automatic", TypeSettings = [Kind = "Table"]]]}]
shared #"Segmentation centre 2 et 3 xlsx" = let
  Source = Lakehouse.Contents([]),
  #"Navigation 1" = Source{[workspaceId = "d65a8c5a-8ab9-47a8-94f6-18a93be16d6e"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[lakehouseId = "0229fa72-7799-4106-ab94-61fd29fedf56"]}[Data],
  #"Navigation 3" = #"Navigation 2"{[Id = "Files", ItemKind = "Folder"]}[Data],
  #"Navigation 4" = #"Navigation 3"{[Name = "Segmentation"]}[Content],
  #"Navigation 5" = #"Navigation 4"{[Name = "Segmentation centre 2 et 3.xlsx"]}[Content],
  #"Classeur Excel importé" = Excel.Workbook(#"Navigation 5", null, true),
  Navigation = #"Classeur Excel importé"{[Item = "Segmentation", Kind = "Sheet"]}[Data],
  #"En-têtes promus" = Table.PromoteHeaders(Navigation, [PromoteAllScalars = true]),
  #"Type de colonne changé" = Table.TransformColumnTypes(#"En-têtes promus", {{"agent_msisdn", Int64.Type}, {"Centre ", type text}, {"sa_incharge", type text}, {"quartier", type text}, {"sitename", type text}, {"site_id", Int64.Type}, {"segment_group", type text}}, "fr"),
  #"Colonnes renommées" = Table.RenameColumns(#"Type de colonne changé", {{"agent_msisdn", "Num_POS"}, {"Centre ", "Zone"}, {"sa_incharge", "SA_incharge"}, {"quartier", "Cluster"}, {"sitename", "Site_name"}, {"segment_group", "Segment_group"}}),
  #"Type de colonne changé 1" = Table.TransformColumnTypes(#"Colonnes renommées", {{"Num_POS", type text}}),
  #"Colonne dupliquée" = Table.DuplicateColumn(#"Type de colonne changé 1", "Segment_group", "Segment_group - Copier"),
  #"Colonnes renommées 1" = Table.RenameColumns(#"Colonne dupliquée", {{"Segment_group - Copier", "Seg_gpre"}}),
  #"Texte extrait après le délimiteur" = Table.TransformColumns(#"Colonnes renommées 1", {{"Seg_gpre", each Text.AfterDelimiter(_, "-", 0), type text}})
in
  #"Texte extrait après le délimiteur";
shared #"Segmentation centre 2 et 3 xlsx_DataDestination" = let
  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false]),
  Navigation_1 = Pattern{[workspaceId = "d65a8c5a-8ab9-47a8-94f6-18a93be16d6e"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "0229fa72-7799-4106-ab94-61fd29fedf56"]}[Data],
  TableNavigation = Navigation_2{[Id = "Segmentation_nettoye", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
