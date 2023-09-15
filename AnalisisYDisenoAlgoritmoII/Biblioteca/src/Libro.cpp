#include "Libro.h"
Libro::Libro(){
}
Libro::Libro(int id,string titulo,string autor,string genero,int cantHojas,int puntaje,int ejemplares)
{
    this->id=id;
    this->titulo=titulo;
    this->autor=autor;
    this->genero=genero;
    this->cantHojas=cantHojas;
    this->puntaje=puntaje;
    this->ejemplares=ejemplares;
}
int Libro::getId() const{
    return this->id;
}
string Libro::getTitulo() const{
    return this->titulo;
}
string Libro::getAutor() const{
    return this->autor;
}
string Libro::getGenero() const{
    return this->genero;
}
int Libro::getCantHojas() const{
    return this->cantHojas;
}
int Libro::getPuntaje() const{
    return this->puntaje;
}
int Libro::getEjemplares() const{
    return this->ejemplares;
}
void Libro::sumarEjemplar(){
    this->ejemplares++;
}
void Libro::restarEjemplar(){
    if (this->ejemplares > 0)
        this->ejemplares--;
    else
        cout << "LIBROS NEGATIVOS" << endl; // mensaje de error, no deberia estar
}
bool Libro::operator<(const Libro & lib2) const
{
    return (this->puntaje > lib2.puntaje);
}

Libro::~Libro()
{
    //dtor
}
