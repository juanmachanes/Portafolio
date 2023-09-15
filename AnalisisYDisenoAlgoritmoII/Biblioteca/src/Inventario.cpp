#include "Inventario.h"
#include "Libro.h"

Inventario::Inventario()
{
    cantLibros = 0;
}
Inventario::~Inventario()
{
    //dtor
}
void Inventario::AgregarLibro(const Libro & agregar){
    datos.push_back(agregar);
    cantLibros+=agregar.getEjemplares();
}
void Inventario::print(){
    typename list<Libro>:: const_iterator itList= datos.begin();
    while(itList!= datos.end()){
        cout<<itList->getTitulo()<<endl;
        itList++;
    }
}
Libro Inventario::tomarPrimero()
{
    typename list<Libro>::iterator itList = datos.begin();
    while ((itList != datos.end()) && (itList->getEjemplares() == 0))  // si no tiene mas ejemplares tomo del siguiente libro
        itList++;
    itList->restarEjemplar();
    cantLibros--;
    return *itList;
}
bool Inventario::vacio() const
{
    return (cantLibros == 0);
}
void Inventario::sumarLibro(int id)
{
        // se entiende que el libro existe
    typename list<Libro>::iterator itList = datos.begin();
    while ((itList != datos.end()) && (itList->getId() != id))
        itList++;
    itList->sumarEjemplar();
    cantLibros++;
}
void Inventario::generarConjuntoLibrosParaNChicos(int alumnosMax, int puntajeAprobacion, vector<map<int,Libro>> & retorno)
{
    solucion mejor;
    mejor.sol.resize(alumnosMax);
    for (int i = 0; i < alumnosMax; i++)
        mejor.sol[i].puntajeActual=0;
    mejor.aprobados = 0;
    int estados=0;
    /*int alumnoActual = solucionRapida(mejor,alumnosMax,puntajeAprobacion,estados);  // acotar el conjunto
    solucion temp;
    temp = mejor;
    backTracking(temp,mejor,alumnosMax,puntajeAprobacion,alumnoActual,estados);
    *///Descomentar para usar backtracking y comentar solucionHeuristica
    solucionHeuristica(mejor,alumnosMax,puntajeAprobacion,estados);
    for(int i = 0 ; i < alumnosMax ; i++)
        retorno[i]=mejor.sol[i].datos;
    cout<<estados<<endl;

}

int Inventario::solucionRapida(solucion & mejorSolucion, int alumnosMax, int valorEsperado,int & estados) 
{
    int personaActual = 0;
    typename list<Libro>::iterator itList = datos.begin();
    while ((itList != datos.end()) && (personaActual < alumnosMax))    // recorro conjunto e inserto listas individuales
    {
        while ((itList->getPuntaje() >= valorEsperado) && (itList->getEjemplares() > 0) && (personaActual < alumnosMax)){
            mejorSolucion.sol[personaActual].datos[itList->getId()]=*itList;  // inserto el libro en el mapa en la id del libro
            mejorSolucion.sol[personaActual].puntajeActual=itList->getPuntaje();
            mejorSolucion.aprobados++;
            itList->restarEjemplar();
            cantLibros--;
            personaActual++;
            estados++;
        }
        itList++;
    }
    return personaActual;  // retorno el alumno actual
}

void Inventario::backTracking(solucion & solucionActual, solucion & mejorSolucion, int alumnosMax, int valorEsperado, int alumnoActual,int & estados)
{
    estados++;
    if ((this->vacio()) || (alumnosMax == solucionActual.aprobados)){
        if (solucionActual.aprobados > mejorSolucion.aprobados)
            mejorSolucion=solucionActual;
    }else{
        int persona = alumnoActual;
        while ((persona < alumnosMax) && !this->vacio()){
            Libro agregar = this->tomarPrimero();//tomo el primer libro de la lista
            solucionActual.sol[persona].puntajeActual+=agregar.getPuntaje();//sumo puntaje para acotar complejidad
            // si no agrego libro por demas y el libro no pertenece al conjunto del alumno, lo tomo como solucion valida
            if (((solucionActual.sol[persona].puntajeActual-agregar.getPuntaje()) < valorEsperado)&&(solucionActual.sol[persona].datos.find(agregar.getId()) == solucionActual.sol[persona].datos.end())){ // si no existe lo tomamos por solucion valida
                if (solucionActual.sol[persona].puntajeActual >= valorEsperado)
                    solucionActual.aprobados++;
                solucionActual.sol[persona].datos[agregar.getId()] = agregar;
                backTracking(solucionActual,mejorSolucion,alumnosMax,valorEsperado,alumnoActual,estados); //recursiva
                if (solucionActual.sol[persona].puntajeActual>= valorEsperado)
                    solucionActual.aprobados--;
                solucionActual.sol[persona].datos.erase(agregar.getId());
            }
            this->sumarLibro(agregar.getId());// devuelvo el libro al conjunto
            solucionActual.sol[persona].puntajeActual-=agregar.getPuntaje();
            persona++;
        }
    }
}

void Inventario::solucionHeuristica(solucion & mejorSolucion, int alumnosMax,int valorEsperado,int &estados)
{
    datos.sort();   // ordeno de mayor a menor el conjunto
    int personaActual = 0;
    while (!vacio() && (personaActual < alumnosMax))
    {
        list<Libro>::iterator itLista = datos.begin();
        // tomo libros siempre y cuando no me pase del valor esperado al sumarselo al puntaje acumulado
        while ((itLista != datos.end()) && (mejorSolucion.sol[personaActual].puntajeActual+itLista->getPuntaje() <= valorEsperado)){
            if (itLista->getEjemplares() > 0){  // si no tiene mas ejemplares lo salteo
                mejorSolucion.sol[personaActual].datos[itLista->getId()] = *itLista;
                mejorSolucion.sol[personaActual].puntajeActual+=itLista->getPuntaje();
                itLista->restarEjemplar();
                cantLibros--;
            }
            estados++;
            itLista++;
        }
        // salgo porque lo complete o porque el libro por el que estoy se pasa del puntaje esperado
        while ((itLista != datos.end())&&(mejorSolucion.sol[personaActual].puntajeActual < valorEsperado)){
            list<Libro>::iterator it2 = itLista;
            list<Libro>::iterator ultimoDisponible = datos.end();
            // recorro la lista buscando el libro que complete el conjunto o uno que sume sin pasarse
            while (it2 != datos.end() && ((mejorSolucion.sol[personaActual].puntajeActual+it2->getPuntaje() >= valorEsperado || ultimoDisponible == datos.end()))) {
                if ((it2->getEjemplares() > 0) && (mejorSolucion.sol[personaActual].datos.find(it2->getId()) == mejorSolucion.sol[personaActual].datos.end()))
                    ultimoDisponible = it2;
                it2++;
                estados++;
            }
            if (ultimoDisponible != datos.end()){   // si pude tomar un libro lo agrego
                mejorSolucion.sol[personaActual].datos[ultimoDisponible->getId()] = *ultimoDisponible;
                mejorSolucion.sol[personaActual].puntajeActual+=ultimoDisponible->getPuntaje();
                ultimoDisponible->restarEjemplar();
                cantLibros--;
            } else if (itLista != datos.begin())   // puede ser que desde el punto en el que estoy hacia adelante no hay mas libros, recorro desde el principio y tomo el primero
                itLista = datos.begin();    // doy una ultima vuelta
            else
                itLista = datos.end();  // ya no hay caso, salgo
            estados++;
        }
        // si lo pude aprobar sumo aprobados
        if (mejorSolucion.sol[personaActual].puntajeActual >= valorEsperado)
            mejorSolucion.aprobados++;
        personaActual++;
    }
}
