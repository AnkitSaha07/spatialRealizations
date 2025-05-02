Data:
Data downloaded from UPAg - Unified Portal for Agricultural Statistics by  Department of Agriculture & Farmers Welfare

Link: https://upag.gov.in/dash-reports/stateprofile?rtab=State+Profile%3A+Crop-wise+APY&rtype=reports

Units of data:  Area in Thousand Ha, Production in Thousand Tonnes & Yield in Kg/Ha
		Data for the year 2024-25 is of 2ⁿᵈ Advance Estimates
		# Cotton Production in Thousand Bales, 1Bale=170 Kg
		## Jute, Sannhemp & Mesta Production in Thousand Bales, 1Bale=180 Kg


Years: 1990 - 2025 (Some states do not have data from 1990)

Crops: (Some are totals among these, and have to be kept separate) 
"Rice"                      "Wheat"                     "Maize"                     "Barley"                    "Jowar"                    
"Bajra"                     "Ragi"                      "Small Millets"             "Shree Anna /Nutri Cereals" "Nutri/Coarse Cereals"     
"Cereals"                   "Tur"                       "Gram"                      "Urad"                      "Moong"                    
"Lentil"                    "Other Pulses"              "Total Pulses"              "Total Food Grains"         "Groundnut"                
"Castorseed"                "Sesamum"                   "Nigerseed"                 "Soybean"                   "Sunflower"                
"Rapeseed & Mustard"        "Linseed"                   "Safflower"                 "Total Oil Seeds"           "Sugarcane"                
"Cotton"                    "Jute"                      "Mesta"                     "Jute & Mesta"              "Tobacco"                  
"Sannhemp"                  "Guarseed"

R script:

Unzips and loads all the .csv files to create a dataframe which lists crops, state, year, area, production, and yield.

These crop items are removed: Shree Anna /Nutri Cereals; Nutri/Coarse Cereals; Cereals; Total Pulses; Total Food Grains; Total Oil Seeds; Jute & Mesta

Download the zip folder and paste the location to define the zip_folder. Run the entire script, and data will be downloaded in a panel format in the same directory the zip folder is saved.
