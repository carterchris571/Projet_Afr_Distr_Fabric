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

df = spark.read.table("Listing_hierachie_nettoye")
df.limit(0).write.mode("overwrite").saveAsTable("Listing_hierachie_nettoye")

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
