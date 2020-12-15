#!/usr/bin/env python

import argparse
import pandas as pd

# parser
parser = argparse.ArgumentParser(description = 'get data from VNE database')

parser.add_argument('-o','--observatory', required=True, dest='observatory',
metavar = "observatory.txt", type = str, 
help = 'observatory name')

args = parser.parse_args()

if args.observatory is None:
    sys.exit('missing observatory')

# path to the files  
url_depot = "https://depot.vigienature-ecole.fr/datasets/bricks/"

if args.observatory == "Vers_de_terre":
    file = "vdt.csv"
elif args.observatory == "Oiseaux_des_jardins":
    file = "oiseaux.csv"
elif args.observatory == "Operation_escargots":
    file = "escargots.csv"
elif args.observatory == "Sauvages_de_ma_rue":
    file = "sauvages.csv"
elif args.observatory == "INPN":
    file = "DataINPN.csv"
elif args.observatory == "INPN_Gasteropodes":
    file = "Gasteropodes.csv"
elif args.observatory == "INPN_Rhopaloceres":
    file = "Rhopaloceres.csv"
    
donnees_VNE=pd.read_csv("".join([url_depot,file]))
donnees_VNE.to_csv('output-importVNE.csv')
