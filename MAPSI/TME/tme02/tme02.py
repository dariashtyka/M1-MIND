# Auteurs : [à compléter]

import math

import matplotlib.pyplot as plt
import numpy as np
import pyagrum as gum
import pyagrum.lib.notebook as gnb

def bernoulli(p: float) -> int:
    """Tire 0 ou 1 selon une loi de Bernoulli de paramètre p."""
    if not 0.0 <= p <= 1.0:
        raise ValueError("Le paramètre p doit être compris entre 0 et 1.")
    return int(np.random.random() < p)


def binomiale(n: int, p: float) -> int:
    """Tire un entier selon une loi binomiale B(n, p)."""
    if n < 0:
        raise ValueError("Le nombre d'essais n doit être positif ou nul.")
    if not 0.0 <= p <= 1.0:
        raise ValueError("Le paramètre p doit être compris entre 0 et 1.")
    return int(np.random.binomial(n, p))


def galton(l: int, n: int, p: float) -> np.ndarray:
    """Produit un tableau de l tirages selon la loi B(n, p)."""
    if l < 0:
        raise ValueError("Le nombre de tirages l doit être positif ou nul.")
    return np.random.binomial(n, p, size=l).astype(int)


def histo_galton(l: int, n: int, p: float) -> np.ndarray:
    """Trace l'histogramme de la loi binomiale correspondant à la planche de Galton."""
    tab = galton(l, n, p)
    bins = np.arange(np.min(tab), np.max(tab) + 2)
    plt.hist(tab, bins=bins, edgecolor="black")
    plt.title(f"Histogramme de Galton (l={l}, n={n}, p={p})")
    plt.xlabel("Nombre de droits")
    plt.ylabel("Fréquence")
    plt.show()
    return tab


def normale(k: int, sigma: float) -> np.ndarray:
    """Renvoie les valeurs de la densité d'une loi normale N(0, sigma^2) en k points."""
    if k % 2 == 0:
        raise ValueError("Le nombre de points k doit être impair.")
    if sigma <= 0:
        raise ValueError("Le paramètre sigma doit être strictement positif.")

    x = np.linspace(-2 * sigma, 2 * sigma, k)
    y = np.exp(-(x ** 2) / (2 * sigma ** 2)) / (sigma * math.sqrt(2 * math.pi))
    return y


def proba_affine(k: int, slope: float) -> np.ndarray:
    if k % 2 == 0:
        raise ValueError("Le nombre de points k doit être impair.")
    if slope == 0:
        return np.array([i/k for i in range(k)])
    else:
        return np.array([1/k+(i-(k-1)/2)*slope for i in range (k)])

def Pxy(A, B):
    return np.array( [ [a*b for b in B] for a in A ])

#EXO ### II.4- Affichage de la distribution jointe refaire sur la machine PPTI

def calcYZ(P_XYZT):
    res = P_XYZT.copy()
    # print ("CALC Y Z ")
    for xi in range(len(P_XYZT)-1):
        # p_yz += x
        res[0]+=P_XYZT[xi+1]
    # for xi in range(len(P_XYZT)):
    for yi in range(len(res[0])):
        for zi in range(len(res[0][yi])):
            for ti in range(len(res[0][yi][zi])-1):
                res[0][yi][zi][0]+=res[0][yi][zi][ti+1]
    # return res[0][:][:][0]
    return res[0].reshape(4, 2).T[0].reshape(2, 2) #trop null mais ça marche
# la même chose que ça: sommer les axes 0 et 3 c'est à dire P[X(=axe0)][Y][Z][T(=axe3)]
    # return np.sum(P_XYZT, axis=(0, 3))

def calcXTcondYZ(P_XYZT):
    print("XT")
    P = P_XYZT.copy()
    P_YZ = calcYZ(P_XYZT)
    return P/P_YZ[None, :, :, None]
    # return P_XYZT / calcYZ(P_XYZT).reshape(1, 2, 2, 1) # meême chose
# P_YZ[0][1] = 0.084
# Alors toutes les valeurs ayant Y=0 et Z=1 sont divisées par 0.084.

def calcX_etTcondYZ(P_XYZT):
    P_XT_YZ = calcXTcondYZ(P_XYZT) #un tableau avec P[X(=axe0)][Y][Z][T(=axe3)]
    print("X et T séparement")
    #j'ai P_XT_YZ avec pas d'axe T donc (X, Y, Z) = (0, 1, 2)
    #j'ai P_XT_YZ avec pas d'axe X donc (Y, Z, T) = (0, 1, 2) => il faut T en premier => (2, 0, 1)
    return np.sum(P_XT_YZ, axis = 3), np.sum(P_XT_YZ, axis = 0).transpose(2, 0 , 1)


def testXTindepCondYZ(P_XYZT,epsilon):
    pXT_YZ = calcXTcondYZ(P_XYZT)
    pX_YZ, pT_YZ = calcX_etTcondYZ(P_XYZT)
    # print(np.shape(pXT_YZ))
    # print(np.shape(pX_YZ))
    # return pXT_YZ. == np.matmul(pX_YZ, pT_YZ)
    for xi in range(len(pXT_YZ)):
        for yi in range(len(pXT_YZ[xi])):
            for zi in range(len(pXT_YZ[xi][yi])):
                for ti in range(len(pXT_YZ[xi][yi][zi])):
                    # if int(pXT_YZ[xi][yi][zi][ti]*epsilon) != int((pX_YZ[xi][yi][zi] * pT_YZ[ti][yi][zi])*epsilon): # FAUX
                    if abs(pXT_YZ[xi][yi][zi][ti] - pX_YZ[xi][yi][zi] * pT_YZ[ti][yi][zi]) > epsilon: #ATTENTION COMME ça pour epsilon
                        # print("pXT_YZ[xi][yi][zi][ti]:", pXT_YZ[xi][yi][zi][ti]*epsilon )
                        # print("(pX_YZ[xi][yi][zi] * pT_YZ[ti][yi][zi]) :",(pX_YZ[xi][yi][zi] * pT_YZ[ti][yi][zi]))
                        # print("(pX_YZ[xi][yi][zi] * pT_YZ[ti][yi][zi])*eps :",(pX_YZ[xi][yi][zi] * pT_YZ[ti][yi][zi])*epsilon)
                        return False
    return True

    #facon numpy en une ligne
    # return np.all(
    #     np.abs(
    #         pXT_YZ - pX_YZ[..., np.newaxis]
    #         * pT_YZ.transpose(1, 2, 0)[np.newaxis, ...]
    #     ) <= epsilon
    # )


def testXindepYZ(P_XYZT,epsilon=1e-10):
    #1-tableau P(X, Y, Z)
    P_XYZ = np.sum(P_XYZT, axis = 3)
    #2-calcul de P(X) et P(Y, Z)
    P_X = np.sum(P_XYZ, axis = (1, 2))
    P_YZ = np.sum(P_XYZ, axis = 0)
    print("P X doit etre [0.4, 0.6], il est :", P_X)
    for xi in range(len(P_XYZ)):
        for yi in range(len(P_XYZ[xi])):
            for zi in range(len(P_XYZ[xi][yi])):
                # if int(P_XYZ[xi][yi][zi]*epsilon) != int((P_X[xi] * P_YZ[yi][zi])*epsilon):
                if abs(P_XYZ[xi][yi][zi] - P_X[xi] * P_YZ[yi][zi]) > epsilon:
                    return False
    return True
    # return np.all(
    #     np.abs(P_XYZ - P_X[..., np.newaxis, np.newaxis, np.newaxis]
    #            *P_YZ[...,np.newaxis, np.newaxis, ]
    #         )  <=epsilon
    #     )
    

def conditional_indep(Pjointe, X, Y, conditions, epsilon):
    # print("\n--- conditional_indep ---")
    # print("Variables disponibles :", Pjointe.names)
    # print("X :", X)
    # print("Y :", Y)
    # print("conditions :", conditions)
    # print("Variables demandées :", [X, Y] + conditions)
    if conditions == []:
        return True
    print( "conditional indep X, Y , cond ", X, Y, conditions)
    pXY_cond = Pjointe.sumIn([X, Y]+conditions)/Pjointe.sumIn(conditions)
    pX_cond = Pjointe.sumIn([X]+conditions)/Pjointe.sumIn(conditions)
    pY_cond = Pjointe.sumIn([Y]+conditions)/Pjointe.sumIn(conditions)
    # if  (pCond - pX*pY).abs().max()<epsilon:
    if  pXY_cond == pX_cond*pY_cond:
        # print(f"=> {X} et {Y} sont indépendants")
        return True
    else:
        # print(f"=> pas d'indépéndance trouvé pour {X} et {Y} ")
        return False

def compact_conditional_proba(Pjointe, Xi, vars):
    # print(Pjointe)
    # print(type(Pjointe))
    # S = Pjointe.var_names
    # S = vars
    # K = S.copy()
    K = vars.copy()
    K.remove(Xi)
    S = K.copy()
    for x in S:
        k_no_x = K.copy()
        if x in k_no_x:
            k_no_x.remove(x)
        # print("K.copy().remove(x) ",k_no_x )
        if conditional_indep(Pjointe, x, Xi, k_no_x, epsilon=1e-10):
            if x in K:
                K.remove(x)
    print("Xi :", Xi)
    print("K final :", K)
    print("Variables du Tensor :", Pjointe.names)
    if K == []:
        return (Pjointe.sumIn([Xi]+K)/Pjointe).putFirst(Xi)
    return (Pjointe.sumIn([Xi]+K)/Pjointe.sumIn(K)).putFirst(Xi)


def create_bayesian_network( Pjointe, eps, vars ):
    l = []
    p = Pjointe
    n = len(vars)-1
    for i in range(n, 0, -1):
        q = compact_conditional_proba(p, vars[i], vars[:i+1])
        print("Liste de vars Q: ", q)
        l.append(q)
        p = p.sumOut(vars[i])
    return l












    # """Renvoie une distribution de probabilité affine sur k points.

    # Les valeurs sont de la forme :
    #     y_i = 1/k + (i - (k - 1)/2) * slope
    # avec k impair et la pente limitée pour conserver la positivité.
    # """
    # if k % 2 == 0:
    #     raise ValueError("Le nombre de points k doit être impair.")

    # max_abs_slope = 2.0 / (k * (k - 1))
    # if abs(slope) > max_abs_slope:
    #     raise ValueError(
    #         f"La pente est trop grande : la valeur absolue maximale autorisée est {max_abs_slope:.10f}."
    #     )

    # i = np.arange(k, dtype=float)
    # centered = i - ((k - 1) / 2)
    # y = (1.0 / k) + centered * slope
    # return y
