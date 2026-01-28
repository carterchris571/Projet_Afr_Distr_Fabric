[StagingDefinition = [Kind = "FastCopy"]]
section Section1;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Combine_listing_DataDestination", IsNewTarget = true], Settings = [Kind = "Automatic", TypeSettings = [Kind = "Table"]]]}]
shared Combine_listing = let
  Source = Lakehouse.Contents([]),
  #"Navigation 1" = Source{[workspaceId = "d65a8c5a-8ab9-47a8-94f6-18a93be16d6e"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[lakehouseId = "0229fa72-7799-4106-ab94-61fd29fedf56"]}[Data],
  #"Navigation 3" = #"Navigation 2"{[Id = "Combine_listing", ItemKind = "Table"]}[Data],
  #"Autres colonnes supprimées" = Table.SelectColumns(#"Navigation 3", {"Id", "Date", "Status", "Type", "From", "From Name", "To", "To Name", "Amount", "Balance", "Date_modified"}),
  #"Texte extrait entre les délimiteurs" = Table.TransformColumns(#"Autres colonnes supprimées", {{"From", each Text.BetweenDelimiters(_, ":", "/", 0, 0), type text}}),
  #"Texte extrait entre les délimiteurs 1" = Table.TransformColumns(#"Texte extrait entre les délimiteurs", {{"To", each Text.BetweenDelimiters(_, ":", "/", 0, 0), type text}}),
  #"Texte extrait avant le délimiteur" = Table.TransformColumns(#"Texte extrait entre les délimiteurs 1", {{"Date_modified", each Text.BeforeDelimiter(_, "T", 0), type text}}),
  #"Type de colonne changé" = Table.TransformColumnTypes(#"Texte extrait avant le délimiteur", {{"Date_modified", type date}, {"Date", type datetime}}),
  #"Colonnes renommées" = Table.RenameColumns(#"Type de colonne changé", {{"From Name", "From_name"}, {"To", "To_num"}, {"From", "From_num"}, {"To Name", "To_name"}})
in
  #"Colonnes renommées";
shared Combine_listing_DataDestination = let
  Pattern = Lakehouse.Contents([HierarchicalNavigation = null, CreateNavigationProperties = false, EnableFolding = false]),
  Navigation_1 = Pattern{[workspaceId = "d65a8c5a-8ab9-47a8-94f6-18a93be16d6e"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "0229fa72-7799-4106-ab94-61fd29fedf56"]}[Data],
  TableNavigation = Navigation_2{[Id = "Combine_listing_nettoye", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
