# Fabric notebook source

# METADATA ********************

# META {
# META   "kernel_info": {
# META     "name": "synapse_pyspark"
# META   },
# META   "dependencies": {
# META     "lakehouse": {
# META       "default_lakehouse": "0229fa72-7799-4106-ab94-61fd29fedf56",
# META       "default_lakehouse_name": "LakeH_AfriDistr_DEV",
# META       "default_lakehouse_workspace_id": "d65a8c5a-8ab9-47a8-94f6-18a93be16d6e",
# META       "known_lakehouses": [
# META         {
# META           "id": "0229fa72-7799-4106-ab94-61fd29fedf56"
# META         }
# META       ]
# META     }
# META   }
# META }

# CELL ********************

# Welcome to your new notebook
# Type here in the cell editor to add code!
from pyspark.sql import SparkSession

# Créer une session Spark
spark = SparkSession.builder \
    .appName("ViderTable") \
    .getOrCreate()

# Spécifier le nom de ta table (remplace "Table" par le nom de ta table)
table_name = "Listing_hierachie_nettoye2"

# Charger la table existante dans un DataFrame
df = spark.read.table(table_name)

# Créer un DataFrame vide avec la même structure que la table existante
empty_df = spark.createDataFrame([], df.schema)

# Réécrire la table avec un DataFrame vide, cela videra la table mais conservera la structure
empty_df.write.format("delta").mode("overwrite").saveAsTable(table_name)




# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
