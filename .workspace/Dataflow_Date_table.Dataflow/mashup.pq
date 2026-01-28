[StagingDefinition = [Kind = "FastCopy"]]
section Section1;
shared Requête = let CreateDateTable = (StartDate as date, EndDate as date, optional Culture as nullable text) as table =>

  let
    DayCount = Duration.Days(Duration.From(EndDate - StartDate)),
    Source = List.Dates(StartDate,DayCount,#duration(1,0,0,0)),
    TableFromList = Table.FromList(Source, Splitter.SplitByNothing()),
    ChangedType = Table.TransformColumnTypes(TableFromList,{{"Column1", type date}}),
    RenamedColumns = Table.RenameColumns(ChangedType,{{"Column1", "Date"}}),
	InsertYear = Table.AddColumn(RenamedColumns,"Année", each Date.Year([Date])),
	InsertQuarter = Table.AddColumn(InsertYear, "Trimestre", each Date.QuarterOfYear([Date])),   
	InsertMonth = Table.AddColumn(InsertQuarter, "MoisNombre", each Date.Month([Date])),
	InsertDay = Table.AddColumn(InsertMonth, "Jour", each Date.Day([Date])),
    InsertDayInt = Table.AddColumn(InsertDay, "DateNombre", each [Année] * 10000 + [MoisNombre] * 100 + [Jour]),
    InsertMonthName = Table.AddColumn(InsertDayInt, "MoisNom", each Date.ToText([Date], "MMMM", Culture), type text),
	InsertCalendarMonth = Table.AddColumn(InsertMonthName, "MoisCalendrier", each (try(Text.Range([MoisNom],0,4)) otherwise [MoisNom]) & " " & Number.ToText([Année])),
	InsertCalendarQtr = Table.AddColumn(InsertCalendarMonth, "TrimestreCalendrier", each "T" & Number.ToText([Trimestre]) & " " & Number.ToText([Année])),
	InsertDayWeek = Table.AddColumn(InsertCalendarQtr, "JourSemaine", each Date.DayOfWeek([Date])),
    InsertDayName = Table.AddColumn(InsertDayWeek, "NomJourSemaine", each Date.ToText([Date], "dddd", Culture), type text),
    InsertWeekEnding = Table.AddColumn(InsertDayName, "FinSemaine", each Date.EndOfWeek([Date]), type date)

  in

    InsertWeekEnding

in
CreateDateTable;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Date_table_DataDestination", IsNewTarget = true], Settings = [Kind = "Automatic", TypeSettings = [Kind = "Table"]]]}]
shared Date_table = let
  Source = Requête(#date(2025, 1, 1), #date(2026, 12, 31), ""),
  #"Type de colonne changé" = Table.TransformColumnTypes(Source, {{"Année", type text}, {"DateNombre", type text}, {"MoisCalendrier", type text}, {"MoisNombre", Int64.Type}, {"Trimestre", Int64.Type}, {"Jour", Int64.Type}, {"TrimestreCalendrier", type text}, {"JourSemaine", Int64.Type}}),
  #"Type de colonne changé avec les paramètres régionaux" = Table.TransformColumnTypes(#"Type de colonne changé", {{"Date", type datetime}}, "fr-FR")
in
  #"Type de colonne changé avec les paramètres régionaux";
shared Date_table_DataDestination = let
  Pattern = Lakehouse.Contents([HierarchicalNavigation = null, CreateNavigationProperties = false, EnableFolding = false]),
  Navigation_1 = Pattern{[workspaceId = "d65a8c5a-8ab9-47a8-94f6-18a93be16d6e"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "0229fa72-7799-4106-ab94-61fd29fedf56"]}[Data],
  TableNavigation = Navigation_2{[Id = "Date_table_nettoye", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
