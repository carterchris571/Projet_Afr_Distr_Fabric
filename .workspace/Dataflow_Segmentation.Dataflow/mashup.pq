[StagingDefinition = [Kind = "FastCopy"]]
section Section1;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "segmentation q4 xlsx_DataDestination", IsNewTarget = true], Settings = [Kind = "Automatic", TypeSettings = [Kind = "Table"]]]}]
shared #"segmentation q4 xlsx" = let
  Source = Lakehouse.Contents([]),
  #"Navigation 1" = Source{[workspaceId = "d65a8c5a-8ab9-47a8-94f6-18a93be16d6e"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[lakehouseId = "0229fa72-7799-4106-ab94-61fd29fedf56"]}[Data],
  #"Navigation 3" = #"Navigation 2"{[Id = "Files", ItemKind = "Folder"]}[Data],
  #"Navigation 4" = #"Navigation 3"{[Name = "Segmentation"]}[Content],
  #"Navigation 5" = #"Navigation 4"{[Name = "segmentation q4.xlsx"]}[Content],
  #"Classeur Excel importé" = Excel.Workbook(#"Navigation 5", null, true),
  Navigation = #"Classeur Excel importé"{[Item = "Feuil1", Kind = "Sheet"]}[Data],
  #"En-têtes promus" = Table.PromoteHeaders(Navigation, [PromoteAllScalars = true]),
  #"Type de colonne changé" = Table.TransformColumnTypes(#"En-têtes promus", {{"MSISDN", Int64.Type}, {"Locality", type text}, {"Cluster", type text}, {"Territory", type text}, {"Zone", type text}, {"Segment Group", type text}, {"SA incharge", type text}}, "fr"),
  #"Type de colonne changé 1" = Table.TransformColumnTypes(#"Type de colonne changé", {{"MSISDN", type text}})
in
  #"Type de colonne changé 1";
shared NavigationQuery = let
  Source = Lakehouse.Contents([HierarchicalNavigation = null, CreateNavigationProperties = false, EnableFolding = false])
in
  Source;
shared #"segmentation q4 xlsx_DataDestination" = let
  Pattern = Lakehouse.Contents([HierarchicalNavigation = null, CreateNavigationProperties = false, EnableFolding = false]),
  Navigation_1 = Pattern{[workspaceId = "d65a8c5a-8ab9-47a8-94f6-18a93be16d6e"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "0229fa72-7799-4106-ab94-61fd29fedf56"]}[Data],
  TableNavigation = Navigation_2{[Id = "Segmentation_nettoye2", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
