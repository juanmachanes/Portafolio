import random
import math
def rand(prob):
    r = random.random()
    for val in prob:
        if r < val[1]:
            return val[0]

def getDesvio(acumulada):
    suma = 0
    muestras = 0
    desvioAct = 0
    desvioAnt = 1
    sumaCuadrado = 0
    while not converge(desvioAct,desvioAnt) or muestras<1000:
        val=rand(acumulada)
        suma=suma+val
        muestras+=1
        mediaAct = suma/muestras
        desvioAnt = desvioAct
        sumaCuadrado = sumaCuadrado+(val-mediaAct)**2
        desvioAct = math.sqrt(sumaCuadrado/muestras)
    return desvioAct

def getMedia(acumulada):
    suma = 0
    muestras = 0
    mediaAct = 0
    mediaAnt = 1
    while not converge(mediaAct,mediaAnt) or muestras<1000:
        val=rand(acumulada)
        suma=suma+val
        muestras+=1
        mediaAnt = mediaAct
        mediaAct = suma/muestras
    return mediaAct


def converge(probAct,probAnt):
    return abs(probAct-probAnt)<1/1000


def contains(lista, valor):
    for i in range(len(lista)):
        if lista[i][0] == valor:
            return i
    return None

signal = []
cantidad=0
nombre_archivo_input = "signal1"
with open(nombre_archivo_input, "r") as archivo:
    for linea in archivo:
        numero = int(linea[:len(linea)-1])
        i = contains(signal,numero)
        if i != None:
            signal[i][1]+=1
        else:
            signal.append([numero,1])
        cantidad+=1
for val in signal:
    val.append(val[1]/cantidad)

prob_acumulada = []
prob_acumulada.append([signal[0][0],signal[0][2]])
for i in range(1,len(signal)):  # generamos el vector de prob acumulada
    prob_acumulada.append([signal[i][0],signal[i][2]+prob_acumulada[i-1][1]])

# muestreo computacional
print(f"media:{getMedia(prob_acumulada)}")
print(f"desvio:{getDesvio(prob_acumulada)}")