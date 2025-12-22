[StagingDefinition = [Kind = "FastCopy"]]
section Section1;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Listing_hierachie_DataDestination", IsNewTarget = true], Settings = [Kind = "Automatic", TypeSettings = [Kind = "Table"]]]}]
shared Listing_hierachie = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "d65a8c5a-8ab9-47a8-94f6-18a93be16d6e"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "0229fa72-7799-4106-ab94-61fd29fedf56"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "Files", ItemKind = "Folder"]}[Data],
  #"Navigation 3" = #"Navigation 2"{[Name = "Listing_hierachie"]}[Content],
  #"Colonne personnalisée ajoutée" = Table.AddColumn(#"Navigation 3", "Personnalisé", each Csv.Document([Content])),
  #"Personnalisé développé" = Table.ExpandTableColumn(#"Colonne personnalisée ajoutée", "Personnalisé", {"Column1", "Column2", "Column3", "Column4", "Column5", "Column6", "Column7", "Column8", "Column9", "Column10", "Column11", "Column12", "Column13", "Column14", "Column15", "Column16", "Column17", "Column18", "Column19", "Column20", "Column21", "Column22", "Column23", "Column24", "Column25", "Column26", "Column27", "Column28", "Column29", "Column30", "Column31", "Column32", "Column33", "Column34"}, {"Column1", "Column2", "Column3", "Column4", "Column5", "Column6", "Column7", "Column8", "Column9", "Column10", "Column11", "Column12", "Column13", "Column14", "Column15", "Column16", "Column17", "Column18", "Column19", "Column20", "Column21", "Column22", "Column23", "Column24", "Column25", "Column26", "Column27", "Column28", "Column29", "Column30", "Column31", "Column32", "Column33", "Column34"}),
  #"Colonnes supprimées" = Table.RemoveColumns(#"Personnalisé développé", {"Name", "Content", "Extension", "Date accessed", "Date created", "Attributes", "Folder Path"}),
 #"En-têtes promus" = Table.PromoteHeaders(#"Colonnes supprimées"),

    // Conversion sécurisée des colonnes sensibles
    #"Conversions sécurisées" = Table.TransformColumns(#"En-têtes promus", {
        {"Id", each try Number.FromText(_) otherwise null, type nullable number},
        {"External Transaction Id", each try Number.FromText(_) otherwise null, type nullable number},
        {"Date", each try DateTime.From(_) otherwise null, type nullable datetime},
        {"Amount", each try Number.FromText(_) otherwise null, type nullable number},
        {"Balance", each try Number.FromText(_) otherwise null, type nullable number},
        {"Fee", each try Number.FromText(_) otherwise null, type nullable number}
    }),

    // Typage des autres colonnes (non critiques)
    #"Type de colonne changé" = Table.TransformColumnTypes(#"Conversions sécurisées", {
        {"Status", type text},
        {"Type", type text},
        {"Provider Category", type text},
        {"Note/Message", type text},
        {"From", type text},
        {"From Name", type text},
        {"From Handler Name", type text},
        {"To", type text},
        {"To Name", type text},
        {"To Handler Name", type text},
        {"Initiated By", type text},
        {"On Behalf Of", type text},
        {"Original Amount", type text},
        {"Currency", type text},
        {"Currency_1", type text},
        {"External Amount", type text},
        {"Currency_2", type text},
        {"External FX Rate", type text},
        {"External Service Provider", type text},
        {"Currency_3", type text},
        {"Discount", type text},
        {"Currency_4", type text},
        {"Promotion", type text},
        {"Currency_5", type text},
        {"Coupon", type text},
        {"Currency_6", type text},
        {"Currency_7", type text},
        {"", type text}
    }, "fr"),

    // Sélection des colonnes finales
    #"Choisir des colonnes" = Table.SelectColumns(#"Type de colonne changé", {"Column1", "Id", "Date", "Status", "Type", "From", "From Name", "To", "To Name", "Amount", "Balance"}),
  #"Type de colonne changé 1" = Table.TransformColumnTypes(#"Choisir des colonnes", {{"Id", type text}, {"Column1", type date}}),
  #"Type de colonne changé 5" = Table.TransformColumnTypes(#"Type de colonne changé 1", {{"Date", type datetime}}),
  #"Texte extrait entre les délimiteurs" = Table.TransformColumns(#"Type de colonne changé 5", {{"From", each Text.BetweenDelimiters(_, ":", "/", 0, 0), type text}}),
  #"Texte extrait entre les délimiteurs 1" = Table.TransformColumns(#"Texte extrait entre les délimiteurs", {{"To", each Text.BetweenDelimiters(_, ":", "/", 0, 0), type text}}),
  #"Colonnes renommées" = Table.RenameColumns(#"Texte extrait entre les délimiteurs 1", {{"Date", "Date"}, {"From", "From_num"}, {"From Name", "From_name"}, {"To", "To_num"}, {"To Name", "To_name"}}),
  #"Type de colonne changé 3" = Table.TransformColumnTypes(#"Colonnes renommées", {{"Balance", Int64.Type}, {"Amount", Int64.Type}}),
  #"Colonnes renommées 1" = Table.RenameColumns(#"Type de colonne changé 3", {{"Column1", "Date_modifie"}}),
  #"Type de colonne changé 4" = Table.TransformColumnTypes(#"Colonnes renommées 1", {{"Date_modifie", type datetime}}),
  #"Requête ajoutée" = Table.Combine({#"Type de colonne changé 4", #"Listing classique"}),
  #"Lignes filtrées" = Table.SelectRows(#"Requête ajoutée", each ([Date] <> null) and ([Type] = "Cash out")),
  #"Type de colonne changé 2" = Table.TransformColumnTypes(#"Lignes filtrées", {{"Date", type datetime}}),
  #"Colonnes supprimées 1" = Table.RemoveColumns(#"Type de colonne changé 2", {"Hour"}),
  #"Type de colonne changé 6" = Table.TransformColumnTypes(#"Colonnes supprimées 1", {{"Type", type text}, {"Id", type text}, {"Status", type text}, {"From_num", type text}, {"From_name", type text}, {"To_num", type text}, {"To_name", type text}, {"Amount", Int64.Type}, {"Balance", Int64.Type}, {"Date", type datetime}, {"Date_modifie", type datetime}})
in
    #"Type de colonne changé 6";
shared #"Listing classique" = let
  Source = Lakehouse.Contents([]),
  #"Navigation 1" = Source{[workspaceId = "d65a8c5a-8ab9-47a8-94f6-18a93be16d6e"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[lakehouseId = "0229fa72-7799-4106-ab94-61fd29fedf56"]}[Data],
  #"Navigation 3" = #"Navigation 2"{[Id = "Files", ItemKind = "Folder"]}[Data],
  #"Navigation 4" = #"Navigation 3"{[Name = "Listing classique"]}[Content],
  #"Colonne personnalisée ajoutée" = Table.AddColumn(#"Navigation 4", "Personnalisé", each Csv.Document([Content])),
  #"Personnalisé développé" = Table.ExpandTableColumn(#"Colonne personnalisée ajoutée", "Personnalisé", {"Column1", "Column2", "Column3", "Column4", "Column5", "Column6", "Column7", "Column8", "Column9", "Column10", "Column11", "Column12", "Column13", "Column14", "Column15", "Column16", "Column17", "Column18", "Column19", "Column20", "Column21", "Column22", "Column23", "Column24", "Column25", "Column26", "Column27", "Column28", "Column29", "Column30", "Column31", "Column32", "Column33", "Column34", "Column35", "Column36", "Column37", "Column38", "Column39", "Column40", "Column41", "Column42", "Column43", "Column44", "Column45", "Column46", "Column47", "Column48", "Column49", "Column50", "Column51", "Column52", "Column53", "Column54"}, {"Column1", "Column2", "Column3", "Column4", "Column5", "Column6", "Column7", "Column8", "Column9", "Column10", "Column11", "Column12", "Column13", "Column14", "Column15", "Column16", "Column17", "Column18", "Column19", "Column20", "Column21", "Column22", "Column23", "Column24", "Column25", "Column26", "Column27", "Column28", "Column29", "Column30", "Column31", "Column32", "Column33", "Column34", "Column35", "Column36", "Column37", "Column38", "Column39", "Column40", "Column41", "Column42", "Column43", "Column44", "Column45", "Column46", "Column47", "Column48", "Column49", "Column50", "Column51", "Column52", "Column53", "Column54"}),
  #"Colonnes supprimées" = Table.RemoveColumns(#"Personnalisé développé", {"Content", "Name", "Extension", "Date accessed", "Date created", "Attributes", "Folder Path"}),
 #"En-têtes promus" = Table.PromoteHeaders(#"Colonnes supprimées", [PromoteAllScalars = true]),

  // Conversion sécurisée des colonnes critiques (pour éviter les erreurs lors du chargement)
  #"Conversions sécurisées" = Table.TransformColumns(
    #"En-têtes promus",
    {
      {"External id", each try Number.FromText(_) otherwise null, type nullable number},
      {"Date", each try DateTime.From(_) otherwise null, type nullable datetime},
      {"To message", each try Number.FromText(_) otherwise null, type nullable number},
      {"Amount", each try Number.FromText(_) otherwise null, type nullable number},
      {"Balance", each try Number.FromText(_) otherwise null, type nullable number}
    }
  ),

  // Application des types texte sur le reste des colonnes
  #"Type de colonne changé" = Table.TransformColumnTypes(#"Conversions sécurisées", {
      {"Id", type text}, {"Status", type text}, {"Type", type text}, {"Provider category", type text},
      {"From", type text}, {"From name", type text}, {"From handler name", type text},
      {"To", type text}, {"To name", type text}, {"To handler name", type text},
      {"Initiated by", type text}, {"Initiated by_1", type text}, {"On behalf of", type text},
      {"On behalf of_2", type text}, {"Approved by", type text}, {"From / Fee", type text},
      {"Currency", type text}, {"From / External fee", type text}, {"Currency_3", type text},
      {"To / Fee", type text}, {"Currency_4", type text}, {"To / External fee", type text},
      {"Currency_5", type text}, {"From / Refunded fee", type text}, {"Currency_6", type text},
      {"To / Refunded fee", type text}, {"Currency_7", type text}, {"From / Taxes", type text},
      {"Currency_8", type text}, {"To / Taxes", type text}, {"Currency_9", type text},
      {"From / Refunded taxes", type text}, {"Currency_10", type text}, {"To / Refunded taxes", type text},
      {"Currency_11", type text}, {"Discount", type text}, {"Currency_12", type text},
      {"From / Promotion", type text}, {"Currency_13", type text}, {"To / Promotion", type text},
      {"Currency_14", type text}, {"Coupon", type text}, {"Currency_15", type text},
      {"Currency_16", type text}, {"Currency_17", type text}, {"External amount", type text},
      {"Currency_18", type text}, {"External FX rate", type text}, {"External service provider", type text}
    }, "fr"),

  // Colonnes finales sélectionnées pour l'export
  #"Choisir des colonnes" = Table.SelectColumns(#"Type de colonne changé", {"08/10/2025 15:02:27", "Id", "Date", "Status", "Type", "From", "From name", "To", "To name", "Amount", "Balance"}),
  #"Diviser la colonne par délimiteur" = Table.SplitColumn(Table.TransformColumnTypes(#"Choisir des colonnes", {{"Date", type text}}), "Date", Splitter.SplitTextByDelimiter(" "), {"Date.1", "Date.2"}),
  #"Type de colonne changé 1" = Table.TransformColumnTypes(#"Diviser la colonne par délimiteur", {{"Date.1", type date}, {"Date.2", type time}}, "fr"),
  #"Texte extrait entre les délimiteurs" = Table.TransformColumns(#"Type de colonne changé 1", {{"From", each Text.BetweenDelimiters(_, ":", "/", 0, 0), type text}}),
  #"Texte extrait entre les délimiteurs 1" = Table.TransformColumns(#"Texte extrait entre les délimiteurs", {{"To", each Text.BetweenDelimiters(_, ":", "/", 0, 0), type text}}),
  #"Colonnes renommées" = Table.RenameColumns(#"Texte extrait entre les délimiteurs 1", {{"08/10/2025 15:02:27", "Date_modifie"}, {"Date.1", "Date"}, {"Date.2", "Hour"}, {"From", "From_num"}, {"From name", "From_name"}, {"To", "To_num"}, {"To name", "To_name"}}),
  #"Type de colonne changé 2" = Table.TransformColumnTypes(#"Colonnes renommées", {{"Balance", Int64.Type}, {"Amount", Int64.Type}}),
  #"Lignes filtrées" = Table.SelectRows(#"Type de colonne changé 2", each ([Date] <> null))
in
  #"Lignes filtrées";
shared param_dernieredateimport = let
    // Création d'une petite table avec une seule colonne et une seule ligne
    Source = #table(
        {"DerniereDateImport"},      // Nom de la colonne
        {
            {#datetime(2025, 10, 9, 0, 0, 0)}  // Valeur initiale (ta dernière date d'import)
        }
    ),
  #"Type de colonne changé" = Table.TransformColumnTypes(Source, {{"DerniereDateImport", type datetime}})
in
    #"Type de colonne changé";
shared DerniereDateImport = "" meta [IsParameterQuery = true, IsParameterQueryRequired = false, Type = type text];
shared Listing_hierachie_DataDestination = let
  Pattern = Lakehouse.Contents([HierarchicalNavigation = null, CreateNavigationProperties = false, EnableFolding = false]),
  Navigation_1 = Pattern{[workspaceId = "d65a8c5a-8ab9-47a8-94f6-18a93be16d6e"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "0229fa72-7799-4106-ab94-61fd29fedf56"]}[Data],
  TableNavigation = Navigation_2{[Id = "Listing_hierachie_nettoye3", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
