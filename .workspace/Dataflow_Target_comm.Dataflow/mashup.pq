[StagingDefinition = [Kind = "FastCopy"]]
section Section1;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Destockage_sodi_DataDestination", IsNewTarget = true], Settings = [Kind = "Automatic", TypeSettings = [Kind = "Table"]]]}]
shared Destockage_sodi = let
    Source = GoogleSheets.Contents("https://docs.google.com/spreadsheets/d/16exQOjuWqS0FzV0bgmzIEALbjBBaZD9UwO553tyUu40/edit?pli=1&gid=1299121404#gid=1299121404"),
    #"Navigation 1" = Source{[name = "Sodi", ItemKind = "Table"]}[Data],
    #"En-têtes promus" = Table.PromoteHeaders(#"Navigation 1", [PromoteAllScalars = true]),

    // Types
    #"Types changés" = Table.TransformColumnTypes(
        #"En-têtes promus",
        {
            {"CDS", type text},
            {"Nom_comm", type text},
            {"Num_comm", Int64.Type},
            {"Target_févr 2026", Int64.Type},
            {"Real_févr 2026", Int64.Type}
        },
        "fr"
    ),
  #"Lignes filtrées" = Table.SelectRows(#"Types changés", each ([CDS] <> "")),

    // Colonnes fixes
    ColonnesFixes = {"CDS", "Nom_comm", "Num_comm"},

    // Colonnes à unpivot (dynamiques)
    ColonnesValeurs =
        List.RemoveItems(
            Table.ColumnNames(#"Lignes filtrées"),
            ColonnesFixes
        ),

    // Transformation manuelle en lignes
    UnpivotManuel =
        Table.FromRecords(
            List.Combine(
                List.Transform(
                    Table.ToRecords(#"Lignes filtrées"),
                    (r) =>
                        List.Transform(
                            ColonnesValeurs,
                            (c) => [
                                CDS = r[CDS],
                                Nom_comm = r[Nom_comm],
                                Num_comm = r[Num_comm],
                                Attribut = c,
                                Valeur = Record.Field(r, c)
                            ]
                        )
                )
            )
        ),

    // Type Target / Real
    #"Type ajouté" =
        Table.AddColumn(
            UnpivotManuel,
            "Type",
            each if Text.StartsWith([Attribut], "Target") then "Target" else "Real",
            type text
        ),

    // Mois
    #"Mois ajouté" =
        Table.AddColumn(
            #"Type ajouté",
            "Mois",
            each Text.AfterDelimiter([Attribut], "_"),
            type text
        ),

    #"Colonne supprimée" = Table.RemoveColumns(#"Mois ajouté", {"Attribut"}),
  #"Type de colonne changé" = Table.TransformColumnTypes(#"Colonne supprimée", {{"CDS", type text}, {"Nom_comm", type text}, {"Num_comm", type text}, {"Valeur", Int64.Type}}),
  #"Colonne personnalisée ajoutée" = Table.TransformColumnTypes(Table.AddColumn(#"Type de colonne changé", "Date_modifie", each Date.From(DateTime.LocalNow())), {{"Date_modifie", type date}})
in
    #"Colonne personnalisée ajoutée";
shared Destockage_sodi_DataDestination = let
  Pattern = Lakehouse.Contents([HierarchicalNavigation = null, CreateNavigationProperties = false, EnableFolding = false]),
  Navigation_1 = Pattern{[workspaceId = "d65a8c5a-8ab9-47a8-94f6-18a93be16d6e"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "0229fa72-7799-4106-ab94-61fd29fedf56"]}[Data],
  TableNavigation = Navigation_2{[Id = "Destockage_sodi_nettoye", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
