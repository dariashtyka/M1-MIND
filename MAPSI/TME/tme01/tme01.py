import numpy as np
import matplotlib.pyplot as plt
def analyse_rapide(d):
    print(d)
    print("mean", d.mean())
    print("std", d.std())
    print("quantile", [np.quantile(d, i) for i in np.arange(0.0, 1.0, 0.1)])

def discretisation_histogramme(d, n):
    inter = 0
    epsilon = 0.0001
    #print("d", d)
    #pour les bornes on doit:
        #prendre la valeur min
        #prendre la val max
        #(max - min)/nb_intervalles = intervalle
    m1 = np.max(d)+epsilon
    m2 = np.min(d)
    inter = ((m1 - m2)/n)
    #bornes = [m2 + inter*i for i in np.arange(0.0, 1.0, (1.0/(n+1)))]
    bornes = np.arange(m2, m1 + epsilon, inter)
    print("bornes", bornes)
    effectifs = np.array([np.where((d>=bornes[i]) & (d<bornes[i+1]),1,0).sum() for i in range(0,len(bornes)-1)]) #ATTENTION de mettre np.array pour afficher 87 au lieu de np.float(87.00)
    print("effectifs", effectifs)
    plt.bar(bornes[0:-1], effectifs, width=inter )
    plt.show()

    #explication
        #1) plt.bar(x,y, width des barres)
        #bornes[0:-1] on met -1 car on ne met pas la derniere barre dans les histogrammes
        #espilon pour inclure 
    effectifs_np, bornes_np = np.histogram(d, bins=n)
    plt.bar(bornes_np[:-1],effectifs_np,width=np.diff(bornes_np))
    plt.show()
    

def discretisation_prix_au_km(data,n):
    discretisation_histogramme((data[:,-4]/data[:,-1]), n)
    #data[:,-4] = toutes les lignes + colonne -4 (comme si on découpait un array en disant d'abord quelles lignes ensuite "," et quelle colonne; la virgule signife un tableau à 2 dimensions)
    #on divise donc tout element de la colonne -4 par l'élément correspondant de la colonne -1)

    