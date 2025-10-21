[StagingDefinition = [Kind = "FastCopy"]]
section Section1;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Cluster_nettoyé_DataDestination", IsNewTarget = true], Settings = [Kind = "Automatic", TypeSettings = [Kind = "Table"]]]}]
shared Cluster_nettoyé = let
  Source = Lakehouse.Contents([]),
  #"Navigation 1" = Source{[workspaceId = "d65a8c5a-8ab9-47a8-94f6-18a93be16d6e"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[lakehouseId = "0229fa72-7799-4106-ab94-61fd29fedf56"]}[Data],
  #"Navigation 3" = #"Navigation 2"{[Id = "Files", ItemKind = "Folder"]}[Data],
  #"Navigation 4" = #"Navigation 3"{[Name = "Cluster"]}[Content],
  #"Navigation 5" = #"Navigation 4"{[Name = "Cluster.xlsx"]}[Content],
  #"Classeur Excel importé" = Excel.Workbook(#"Navigation 5", null, true),
  Navigation = #"Classeur Excel importé"{[Item = "Cluster", Kind = "Sheet"]}[Data],
  #"Type de colonne changé" = Table.TransformColumnTypes(Navigation, {{"Column1", type text}, {"Column2", type text}, {"Column3", type text}}, "fr"),
  #"En-têtes promus" = Table.PromoteHeaders(#"Type de colonne changé", [PromoteAllScalars = true]),
  #"Colonnes renommées" = Table.RenameColumns(#"En-têtes promus", {{"quartier", "Cluster"}, {"sa_incharge", "SA_incharge"}})
in
  #"Colonnes renommées";
shared Cluster_nettoyé_DataDestination = let
  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false]),
  Navigation_1 = Pattern{[workspaceId = "d65a8c5a-8ab9-47a8-94f6-18a93be16d6e"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "0229fa72-7799-4106-ab94-61fd29fedf56"]}[Data],
  TableNavigation = Navigation_2{[Id = "Cluster_nettoyé", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
