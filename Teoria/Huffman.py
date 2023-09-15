import math

class Nodo:
    def __init__(self,prob,valor,nodoDer,nodoIzq):   
        self.prob=prob
        self.valor=valor
        self.nodoDer=nodoDer #1 => Mayor
        self.nodoIzq=nodoIzq #0 => Menor
    

class Huffman:
    def __init__(self):   
        self.raiz = Nodo(0,0,None,None)
        self.codigos = {}
        self.datos = None
        
    def generarHuffman(self,listaValores):
        self.datos = listaValores
        lista=[]
        for val in listaValores:  # generamos la lista de terminales
            lista.append(Nodo(val[2],val[0],None,None))

        while len(lista)>1:
            lista.sort(key=lambda x:x.prob) # esto ordena de menor a mayor
            nodo1=lista.pop(0) 
            nodo2=lista.pop(0)
            # tomamos los 2 primeros que serian los de probabilidad mas baja
            lista.append(Nodo(nodo1.prob+nodo2.prob,None,nodo2,nodo1))

        self.raiz = lista[0]
        self.generarCodigos(self.raiz,"")
    
    def generarCodigos(self,nodo,codigo):
        if nodo != None:
            if nodo.valor != None:
                self.codigos[nodo.valor] = codigo
                # agregamos los codigos a un diccionario una vez que llegamos a un terminal 
            self.generarCodigos(nodo.nodoDer,codigo+"1")
            self.generarCodigos(nodo.nodoIzq,codigo+"0")

    def getCodigos(self):
        return self.codigos
    
    def longitudPromedio(self):
        prom = 0
        for val in self.datos:
            prom = prom+val[2]*len(self.codigos[val[0]])
        return prom

def contains(lista, valor):
    for i in range(len(lista)):
        if lista[i][0] == valor:
            return i
    return None

def entropia(signal):
    ent = 0
    for val in signal:
        ent = ent+math.log2(val[2])*val[2]
    return -ent

signal = []
cantidad=0
nombre_archivo_output = "output.txt"
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

huffman = Huffman()
huffman.generarHuffman(signal)
codigos = huffman.getCodigos()
resultado = ""
with open(nombre_archivo_input, "r") as archivo:
    for linea in archivo:
        numero = int(linea[:len(linea)-1])
        resultado=resultado+codigos[numero]

with open(nombre_archivo_output, "w") as archivo:
    archivo.write(resultado)

print(f"Longitud promedio: {huffman.longitudPromedio()}")
print(f"Entropia de la señal: {entropia(signal)}")
print(f"Longitud del archivo codificado en bits: {len(resultado)}")
print(f"Tamaño del archivo codificado en kb: {len(resultado)/8000}")
print(f"se creo el archivo {nombre_archivo_output}")