from pathlib import Path
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import missingno as msno

DATA_DIR = Path("project/data")
if Path("session1").is_dir():
    DATA_DIR = Path("session1/project/data")
pd.set_option("display.max_rows", 20)
# Load and inspect the two files.
# Write your code here.
data = pd.read_csv("data/gender_ukr.csv")
h=data.head()
print(h)
print(data.isna().sum())
data["Year"] = pd.to_numeric(data["Year"])
print("YEAR SORTED", data.sort_values("Year", ascending=True))
# h=data.head()
# print(h)