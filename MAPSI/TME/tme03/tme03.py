import numpy as np
import matplotlib.pyplot as plt

def learnML_parameters(X_train, Y_train):
    #MAX DE VRAISEMBLANCE 
    # (estimation des parametres comme c'est N alors c'est jsute 
    # la moyenne et l'écrat type empuirrique)
        #calcul de L(0)
        #lnL(0)
        #derivé de lnL(0)
        #max en posant dérivé = 0
    #X_train
    # [
        #im1 [nbDEpix1, nbDepix2, pix ... pix ] (256)
        #im2 [pix, pix, pix ... pix ] (256)
        # ...
        #imN 
    #]

    #Y_train 
    # [
        #im1  => chifre 8 
        #im2 => chiffre 9 ...
        # ...
        #imN 
    #]

    mu = np.zeros((10, 256))
    std = np.zeros((10, 256))
    # .shape((10, 256))

    # for imageI in range(len(X_train)): #6229 ?? #FAUX
    for chiffre in range(10):
        # for pixI in range(len(X_train[imageI])): #256 
        for pix in range(256): #256
            # print("imageI[pixI]", X_train[imageI][pixI])
            # niv_gris = int(X_train[imageI][pixI] *100)
            # print("niv_gris", niv_gris)
            # sum[Y_train[imageI]][niv_gris] +=1
            tmp = []
            for imageI in range(len(X_train)):#6229
                if (Y_train[imageI]==chiffre):
                    tmp.append(X_train[imageI][pix]) #contient tous les nombres de pix [0.15, 1.13, ... ]
            mu[chiffre][pix] = np.mean(tmp)  #calcule la moyenne de ce tableau
            std[chiffre][pix] = np.var(tmp)


    # mu = np.array(sum/256)

    # sum_std = np.array([(sum[i][j] - mu)**2 for i in range(len(sum)) for j in range(len(sum[i]))])
    # std =np.array(sum_std/256)
    # sum_std/256

    return mu, std



    #res
    # mu 
        # 0, .... 256 : 
        # [ chiffre 0 : [moyenne de pix0, moyenne de pix1, .... de pix256]
        # chiffre 1 : 
        # ....
        # chiffre 10 ]




def log_likelihood(X_train_i, mu_i, sig_i, eps):
    #on a eu un tableau de mu
        # chiffre 0 : L(theta1, theta2 ... thetha 256) 
        # chiffre 1 ...
    #pour calculer L:
        # L(theta1, theta2 ... thetha 256) = L(theta1) * L(theta2) ... (comme indep)
    #pour calculer logL:
        # log (L(theta1) * L(theta2) ... ) = sum (logL(theta1) ... logL(thetan))
        #et L(theta1) = focntion gaussienne
    # tab_eps = np.array([eps]*2560).reshape((10, 256))
    # print("X:", np.array(X_train_i).shape)
    # print("mu:", np.array(mu_i).shape)
    # print("sig i :", np.array(sig_i).shape)
    tab_eps = []
    sig = []
    if eps > 0:
        tab_eps = np.array([eps]*256)
        sig = np.maximum(sig_i, tab_eps)
    elif eps == -1:
        sig = np.array(sig_i)
        sig[sig == 0] = 1
    else: 
        sig = sig_i
    # print("sig :", np.array(sig).shape)
        #  sig = np.where(np.array(sig_i) == 0, 1, sig_i)
    return (-1/2) * np.sum([np.log(2*np.pi *sig[pixI]) +
                            ((X_train_i[pixI] - mu_i[pixI])**2/ sig[pixI]) 
                            for pixI in range(256)])

#pour une image de X on calcule la vraisemblance pour chaque mu, sig 
# => on choisi le max de vraisemblance
# => on regarde quelle classe(chiffre) elle concerne
def classify_image(X_train_i, mu, sig, eps):
    l = [log_likelihood(X_train_i, mu[i], sig[i], eps) for i in range(10)]
    return l.index(max(l))

def classify_all_images(X_train, mu, sig, eps):
    return [classify_image(image, mu, sig, eps) for image in X_train]

def matrice_confusion(Y_train, Y_train_hat):
        #Y_train 
    # [
        #im1  => chifre 8 
        #im2 => chiffre 9 ...
        # ...
        #imN 
    #]
        #Y_train_hat (predites)
    # [
        #im1  => chifre 8 
        #im2 => chiffre 9 ...
        # ...
        #imN 
    #]
    m = np.zeros((10, 10))
    for i in range(len(Y_train)): #si c'est l'image de 0
        image = Y_train[i]
        image_predite = Y_train_hat[i]
        m[image][image_predite]+=1
    return m
    # for y, yh in zip(Y_train, Y_train_hat): m[y][yh] += 1 #plus court

def classificationRate(Y_train, Y_train_hat):
    # for i, j in zip(len(Y_train), len(Y_train_hat)):
    m = matrice_confusion(Y_train, Y_train_hat)
    nb_im = [np.sum(Y_train == i) for i in range (10)]
    taux_par_classe = [m[i][i]/nb_im[i] for i in range(10)]
    return np.mean(taux_par_classe)

# plus simple
# def classificationRate(Y_train,Y_train_hat):
#     nbr_bonne_prediction =0
#     for i in range(len(Y_train)):
#         if(Y_train[i]==Y_train_hat[i]):
#             nbr_bonne_prediction+=1
#     return nbr_bonne_prediction/len(Y_train)


def classifTest(X_test, Y_test, mu, sig, eps):
    # mal_classees : 
    Y_hat = classify_all_images(X_test, mu, sig, eps)
    print("1- Classify all test images ", Y_hat)
    print("2- Classification rate : ", classificationRate(Y_test, Y_hat))
    print("3- Matrice de confusion : ")
    m = matrice_confusion(Y_test, Y_hat)
    plt.figure(figsize=(3,3))
    plt.imshow(m)
    return np.where(Y_test!=Y_hat) # où Y_hat est l'estimation des Y_test 

def binarisation(X_train):
    X_train[:][X_train > 0] = 1
    return X_train

def learnBernoulli( Xb_train, Y_train):
    #max de vraisemblance pj = sum (xj) /N
        #X_train
    # [
        #im1 [pix1, pix2, pix ... pix ] (256)
        #im2 [pix, pix, pix ... pix ] (256)
        # ...
        #imN 
    #]
    # print(Xb_train.shape)
    # print(Xb_train[0].shape)
    # print( Xb_train[0])

    # theta = np.zeros((10, 256))
    # # for i, im in enumerate(Xb_train):
    # #     for 
    # #     theta[Y_train[i]] = 
    # for chiffre in range(10):
    #     for pix in range(256): #256
    #         nb_de_1 = 0
    #         for imageI in range(len(Xb_train)): #6229
    #             if (Y_train[imageI]==chiffre and Xb_train[imageI][pix] == 1 ):
    #                nb_de_1+=1 #contient tous les nombres de pix [0.15, 1.13, ... ]
    #         theta[chiffre][pix] = nb_de_1/(sum(1 for y in Y_train if y == chiffre))  #calcule la vraisemblance de ce pixel
    theta = np.array([
        #Y_train == chiffre #toutes les indices ou Y == à ce chiffre (une étiquette)
        Xb_train[Y_train == chiffre].mean(axis=0) #le table des images concernant une seule chiffre
        #mean(axis = 0 ) on fait la moyenne axis=0 → verticalement → moyenne de chaque colonne
        #axis=1 → horizontalement → moyenne de chaque ligne
        for chiffre in range(10)
    ])

    # logp = np.array([
    #     #Y_train == chiffre #toutes les indices ou Y == à ce chiffre (une étiquette)
    #     sum(
    #         xij * np.log(pj) +(1-xij)* np.log(1-pj)
    #         for xij in Xb_train[Xb_train == chiffre]
    #         for pj in theta[chiffre]
                
    #     )
    #     #mean(axis = 0 ) on fait la moyenne axis=0 → verticalement → moyenne de chaque colonne
    #     #axis=1 → horizontalement → moyenne de chaque ligne
    #     for chiffre in range(10)
    # ])


    return theta

def logpobsBernoulli(X_train_i, theta, epsilon):
    # theta[:][theta == 0] = epsilon
    # theta[:][theta == 1] = 1 - epsilon
    #même chose
    theta = np.maximum(theta, epsilon)
    theta = np.minimum(theta, 1 - epsilon)
    logp = np.array([
        #Y_train == chiffre #toutes les indices ou Y == à ce chiffre (une étiquette)
        sum(
            xij * np.log(pj) +(1-xij)* np.log(1-pj)
           for xij, pj in zip(X_train_i, theta[chiffre]) #ATTENTION à ZIP
                
        )
        #mean(axis = 0 ) on fait la moyenne axis=0 → verticalement → moyenne de chaque colonne
        #axis=1 → horizontalement → moyenne de chaque ligne
        for chiffre in range(10)
    ])
    return logp
# Résultat anormal : une log-vraisemblance de Bernoulli doit être <= 0, or on obtient +95.
# Cause : on a passé X_train[0] (niveaux de gris, valeurs dans [0,2]) au lieu de
# l'image binarisée Xb_train[0]. Pour x > 1, le terme (1-x)*log(1-p) est
# positif (produit de deux négatifs), ce qui peut rendre la somme positive.
# Le modèle de Bernoulli n'est valide que pour x dans {0,1}.


def classifBernoulliTest(Xb_test, Y_test, theta):
    Y_hat = [
        np.argmax(logpobsBernoulli(image, theta, epsilon=1e-4))
        for image in Xb_test
    ]
    # mal_classees : 
    print("1- Classify all test images ", Y_hat)
    print("2- Classification rate : ", classificationRate(Y_test, Y_hat))
    print("3- Matrice de confusion : ")
    m = matrice_confusion(Y_test, Y_hat)
    plt.figure(figsize=(3,3))
    plt.imshow(m)
    return np.where(Y_test!=Y_hat) # où Y_hat est l'estimation des Y_test 


#notes
#On définit le estimateurs max de vraisemablance 
    # (pour loi noramle c'est la moyenne et l'écart type)
    # pour les pixels allumés on a trouvé une frequence du pixel allumé
    # pour la loi géometrique ...???
    
#Puis on calcule log vraisemblance 

#Puis on calcule pour chaque image les vraisemblances des parametres [0.1, 0.15, ...]
    # on choisit le resultat max pour classifer max = 0.8
    # on classifie les images selon l'indice

# on obtient les classes qu'on a trouvé avec nos algos 
# et on peut comparer avec les classes prédéfinies pour :
    # trouver le nb des IM MAL classés
    # faire une matrice de confusion
