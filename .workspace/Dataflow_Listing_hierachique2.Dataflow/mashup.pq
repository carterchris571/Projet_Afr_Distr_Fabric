[StagingDefinition = [Kind = "FastCopy"]]
section Section1;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Listing_hierachique2_DataDestination", IsNewTarget = true], Settings = [Kind = "Automatic", TypeSettings = [Kind = "Table"]]]}]
shared Listing_hierachique2 = let
    Source = Lakehouse.Contents([]),

    #"Navigation 1" =
        Source{[workspaceId = "d65a8c5a-8ab9-47a8-94f6-18a93be16d6e"]}[Data],

    #"Navigation 2" =
        #"Navigation 1"{[lakehouseId = "0229fa72-7799-4106-ab94-61fd29fedf56"]}[Data],

    #"Navigation 3" =
        #"Navigation 2"{[Id = "Files", ItemKind = "Folder"]}[Data],

    #"Navigation 4" =
        #"Navigation 3"{[Name = "Listing_hierachique2"]}[Content],

    // 📂 Ne garder que les fichiers CSV
    #"Fichiers CSV uniquement" =
        Table.SelectRows(
            #"Navigation 4",
            each
                Text.Lower([Extension]) = ".csv"
                and [Content] <> null
                and Value.Is([Content], type binary)
        ),

    // 🔐 Appel sécurisé de la fonction sur tous les CSV
    #"Colonne personnalisée ajoutée" =
        Table.AddColumn(
            #"Fichiers CSV uniquement",
            "Data",
            (r) =>
                let
                    result = try listing_transform(r[Content])
                in
                    if result[HasError] then null else result[Value]
        ),

    // 🧹 Supprimer les fichiers en erreur
    #"Lignes null supprimées" =
        Table.SelectRows(
            #"Colonne personnalisée ajoutée",
            each [Data] <> null
        ),

    // 🔓 Combiner tous les fichiers
    #"Data développé" =
        Table.ExpandTableColumn(
            #"Lignes null supprimées",
            "Data",
            {
                "Date",
                "Status",
                "Type",
                "From_num",
                "From_name",
                "To_num",
                "To_name",
                "Amount",
                "Balance"
            }
        ),

    // 🧼 Nettoyage
    #"Colonnes supprimées" =
        Table.RemoveColumns(
            #"Data développé",
            {
                "Date accessed",
                "Date created",
                "Attributes",
                "Folder Path",
                "Content",
                "Name",
                "Extension"
            }
        ),

    // 🧨 🔑 ÉTAPE CRITIQUE — FORCER LA RÉÉVALUATION DE "Type"
    #"Type réévalué" =
        Table.TransformColumns(
            #"Colonnes supprimées",
            {{"Type", each Text.From(_), type text}}
        ),

    // 🔢 Typage final (APRÈS réévaluation)
    #"Type de colonne changé" =
        Table.TransformColumnTypes(
            #"Type réévalué",
            {
                {"Date", type datetime},
                {"Status", type text},
                {"Type", type text},
                {"From_num", type text},
                {"From_name", type text},
                {"To_num", type text},
                {"To_name", type text},
                {"Amount", Int64.Type},
                {"Balance", Int64.Type}
            }
        )
in
    #"Type de colonne changé";
shared Sample_file = let
  Source = Lakehouse.Contents([]),
  #"Navigation 1" = Source{[workspaceId = "d65a8c5a-8ab9-47a8-94f6-18a93be16d6e"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[lakehouseId = "0229fa72-7799-4106-ab94-61fd29fedf56"]}[Data],
  #"Navigation 3" = #"Navigation 2"{[Id = "Files", ItemKind = "Folder"]}[Data],
  #"Navigation 4" = #"Navigation 3"{[Name = "Listing_hierachique2"]}[Content],
  #"Lignes filtrées" = Table.SelectRows(#"Navigation 4", each ([Name] = "Hierarchy_Transaction_History_MOBILE_MONEY_XAF_2025-12-31-2026-01-01.csv")),
  Navigation = #"Lignes filtrées"{[Name = "Hierarchy_Transaction_History_MOBILE_MONEY_XAF_2025-12-31-2026-01-01.csv"]}[Content],
  #"CSV importé" = Csv.Document(Navigation, [Delimiter = ",", Columns = 34, QuoteStyle = QuoteStyle.None]),
  #"En-têtes promus" = Table.PromoteHeaders(#"CSV importé", [PromoteAllScalars = true]),
  #"Type de colonne changé" = Table.TransformColumnTypes(#"En-têtes promus", {{"Id", Int64.Type}, {"External Transaction Id", Int64.Type}, {"Date", type datetime}, {"Status", type text}, {"Type", type text}, {"Provider Category", type text}, {"Note/Message", type text}, {"From", type text}, {"From Name", type text}, {"From Handler Name", type text}, {"To", type text}, {"To Name", type text}, {"To Handler Name", type text}, {"Initiated By", type text}, {"On Behalf Of", type text}, {"Original Amount", type text}, {"Currency", type text}, {"Amount", Int64.Type}, {"Currency_1", type text}, {"External Amount", type text}, {"Currency_2", type text}, {"External FX Rate", type text}, {"External Service Provider", type text}, {"Fee", Int64.Type}, {"Currency_3", type text}, {"Discount", Int64.Type}, {"Currency_4", type text}, {"Promotion", type text}, {"Currency_5", type text}, {"Coupon", type text}, {"Currency_6", type text}, {"Balance", Int64.Type}, {"Currency_7", type text}, {"", type text}}, "fr"),
  #"Autres colonnes supprimées" = Table.SelectColumns(#"Type de colonne changé", {"Date", "Status", "Type", "From", "From Name", "To", "To Name", "Amount", "Balance"}),
  #"Texte extrait entre les délimiteurs" = Table.TransformColumns(#"Autres colonnes supprimées", {{"To", each Text.BetweenDelimiters(_, ":", "/", 0, 0), type text}}),
  #"Texte extrait entre les délimiteurs 1" = Table.TransformColumns(#"Texte extrait entre les délimiteurs", {{"From", each Text.BetweenDelimiters(_, ":", "/", 0, 0), type text}}),
  #"Colonnes renommées" = Table.RenameColumns(#"Texte extrait entre les délimiteurs 1", {{"To Name", "To_name"}, {"From Name", "From_name"}, {"From", "From_num"}, {"To", "To_num"}})
in
  #"Colonnes renommées";
shared listing_transform = (file as binary) =>
let
    Source = Csv.Document(
        file,
        [
            Delimiter = ",",
            Columns = 34,
            Encoding = 65001,
            QuoteStyle = QuoteStyle.None
        ]
    ),
    #"En-têtes promus" = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    #"Type de colonne changé" = Table.TransformColumnTypes(
        #"En-têtes promus",
        {
            {"Date", type datetime},
            {"Status", type text},
            {"Type", type text},
            {"From", type text},
            {"From Name", type text},
            {"To", type text},
            {"To Name", type text},
            {"Amount", Int64.Type},
            {"Balance", Int64.Type}
        },
        "fr"
    ),
    #"Colonnes nettoyées" =
        Table.SelectColumns(
            #"Type de colonne changé",
            {"Date", "Status", "Type", "From", "From Name", "To", "To Name", "Amount", "Balance"}
        ),
    #"From extrait" =
        Table.TransformColumns(
            #"Colonnes nettoyées",
            {{"From", each Text.BetweenDelimiters(_, ":", "/", 0, 0), type text}}
        ),
    #"To extrait" =
        Table.TransformColumns(
            #"From extrait",
            {{"To", each Text.BetweenDelimiters(_, ":", "/", 0, 0), type text}}
        ),
    #"Colonnes renommées" =
        Table.RenameColumns(
            #"To extrait",
            {
                {"From", "From_num"},
                {"From Name", "From_name"},
                {"To", "To_num"},
                {"To Name", "To_name"}
            }
        )
in
    #"Colonnes renommées";
shared Listing_hierachique2_DataDestination = let
  Pattern = Lakehouse.Contents([HierarchicalNavigation = null, CreateNavigationProperties = false, EnableFolding = false]),
  Navigation_1 = Pattern{[workspaceId = "d65a8c5a-8ab9-47a8-94f6-18a93be16d6e"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "0229fa72-7799-4106-ab94-61fd29fedf56"]}[Data],
  TableNavigation = Navigation_2{[Id = "Listing_h1", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
