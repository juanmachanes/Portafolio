#ifndef INVENTARIO_H
#define INVENTARIO_H
#include "iostream"
#include "Libro.h"
#include "map"
#include "list"
#include "vector"

using namespace std;

class Inventario
{
    public:
        Inventario();
        void AgregarLibro(const Libro & agregar);
        void print();
        bool vacio() const;
        Libro tomarPrimero();
        void sumarLibro(int id);
        void generarConjuntoLibrosParaNChicos(int alumnosMax, int puntajeAprobacion, vector<map<int,Libro>> & retorno);
        virtual ~Inventario();

    private:
        struct estructura{   // estructura con la lista de libros y el puntaje acumulado
            map<int,Libro> datos;
            int puntajeActual;
        };
        struct solucion{    // estructura con la solucion y la cantidad de aprobados
            vector<estructura> sol;
            int aprobados;
        };
        void backTracking(solucion & solucionActual, solucion & mejorSolucion, int alumnosMax, int valorEsperado, int alumnoActual,int & estados);
        int solucionRapida(solucion & mejorSolucion, int alumnosMax, int valorEsperado,int & estados);
        void solucionHeuristica(solucion & mejorSolucion, int alumnosMax,int valorEsperado,int &estados);


        list<Libro> datos;
        int cantLibros;

};

#endif // INVENTARIO_H
