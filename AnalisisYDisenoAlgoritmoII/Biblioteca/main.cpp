#include <iostream>
#include <fstream>
#include "Inventario.h"
#include "list"
#include "map"
#include "vector"
using namespace std;

void procesar_archivo_entrada(string origen,Inventario & cargar)
{
    ifstream archivo(origen);
    if (!archivo.is_open())
        cout << "No se pudo abrir el archivo: " << origen << endl;
    else {
        string linea;
        getline(archivo, linea);
        int cantidad_libros = atoi(linea.c_str());

        cout << "Se cargar�n " << cantidad_libros << " libros." << endl;

        int actual = 1;
        //Leemos de una linea completa por vez (getline).
        while (getline(archivo, linea)) {
            //Primer posici�n del separador ;
            int pos_inicial = 0;
            int pos_final = linea.find(';');

            pos_inicial=pos_final+1;
            pos_final= linea.find(';',pos_inicial);
            string titulo = linea.substr(pos_inicial, pos_final-pos_inicial);

            pos_inicial=pos_final+1;
            pos_final= linea.find(';',pos_inicial);
            string autor = linea.substr(pos_inicial, pos_final-pos_inicial);

            pos_inicial=pos_final+1;
            pos_final= linea.find(';',pos_inicial);
            string genero = linea.substr(pos_inicial, pos_final-pos_inicial);

            pos_inicial=pos_final+1;
            pos_final= linea.find(';',pos_inicial);
            int cantidadHojas = atoi(linea.substr(pos_inicial, pos_final-pos_inicial).c_str());

            pos_inicial=pos_final+1;
            pos_final= linea.find(';',pos_inicial);
            int puntaje = atoi(linea.substr(pos_inicial, pos_final-pos_inicial).c_str());

            pos_inicial=pos_final+1;
            pos_final= linea.find(';',pos_inicial);
            int ejemplares = atoi(linea.substr(pos_inicial, pos_final-pos_inicial).c_str());
            Libro libro(actual,titulo,autor,genero,cantidadHojas,puntaje,ejemplares);
            cargar.AgregarLibro(libro);
            actual++;
        }

    }
}

int main()
{
    vector<map<int,Libro>> retorno;
    int alumnosMax = 1000;
    retorno.resize(alumnosMax);
    string dataset;
    cout << "Ingrese nombre del dataset: ";
    //cin >> dataset;
    Inventario datos;
    procesar_archivo_entrada("./datasets/dataset3.csv",datos);
    datos.generarConjuntoLibrosParaNChicos(alumnosMax,250,retorno);
    for( int i = 0 ; i < alumnosMax ; i++){
        map<int,Libro>::const_iterator itMap = retorno[i].begin();
        cout << "alumno: " << i+1 << endl;
        while (itMap != retorno[i].end()){
            cout << "   "<<itMap->second.getTitulo() << " " << itMap->second.getPuntaje() <<endl;
            itMap++;
        }
    }

    //S: Se pide nuevamente cantidad de alumnos y puntaje m�nimo con el mismo dataset.
    return 0;
}




