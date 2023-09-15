#ifndef LIBRO_H
#define LIBRO_H
#include "iostream"

using namespace std;
class Libro
{
    public:
        Libro(int id,string titulo,string autor,string genero,int cantHojas,int puntaje,int ejemplares);
        Libro();
        virtual ~Libro();
        int getId() const;
        string getTitulo() const;
        string getAutor() const;
        string getGenero() const;
        int getCantHojas() const;
        int getPuntaje() const;
        int getEjemplares() const;
        void sumarEjemplar();   // PELIGROSO
        void restarEjemplar();  // peligroso 2
        bool operator<(const Libro & lib2) const;


    private:
        int id;
        string titulo;
        string autor;
        string genero;
        int cantHojas;
        int puntaje;
        int ejemplares;

};

#endif // LIBRO_H
