section .data
    cmd_clear                           db      "clear",0
    mensajeInicial                      db      "Bienvenidos al juego 'El Asalto'",0
    tablero                 times 50    db      0                                           ;49 para los caracteres y 1 para el 0 que agrega fgets
    archivoTablero                      db      "tablero.txt",0
    archivoTableroGuardado              db      "tableroGuardado.txt",0
    mensajeErrorLectura                 db      "Hubo un error al leer: %s",10,0
    modoLectura                         db      "r",0
    mensajeCargarPartida                db      "Hay una partida guardada, ¿quiere reanudarla? S/N",10,0
    respuestaPositiva                   db      'S'
    respuestaNegativa                   db      'N'
    mensajeEleccionCargaIncorrecta      db      "Respuesta inválida, debe ser S o N",10,0
    formatoChar                         db      "%c",0    
    formatoInputFilCol                  db      "%hhi %hhi",0 ; Transformar los campos a nro entero (me sobra para guardar un nro entre 1 y 7)
    juegoTerminado                      db      'N'
    turnoJugador                        db      0   ;0 representa Soldados, 1 representa Oficiales
    mensajeDelGanador                   db      "Los ganadores son los %s",10,0
    oficiales                           db      "OFICIALES",0
    soldados                            db      "SOLDADOS",0
    mensajeTurno                        db      "Turno de: %s",10,0
    strOficial                          db      "oficial",0
    strSoldado                          db      "soldado",0
    cantidadOficiales                   db      2
    cantidadSoldados                    db      24
    posicionesFortaleza                 db      30,31,32,37,38,39,44,45,46

    ;Para la impresion del tablero
    e                                   db      "   ",0
    formatoIndiceInt                    db      " %i ",0
    formatoIndiceChar                   db      " %c ",0
    nuevaLinea                          db      "",0

    ;Seccion movimientos
    mensajeIngFilColOrigen              db      "-->Ingrese fila (0 a 6) y columna (0 a 6) del que desea mover, separados por un espacio: ", 0
    mensajeIngFilColDestino             db      "-->Ingrese fila (0 a 6) y columna (0 a 6) a la que se desea mover separados por un espacio: ", 0
    mensajeFormatoIncorrecto            db      "El formato es incorrecto, ingrese nuevamente.",0
    mensajeFilColFueraTablero           db      "La posicion es inválida, ingrese nuevamente.",0
    mensajeNoHayJugador                 db      "En la posicion elegida no hay un %s, ingrese nuevamente.",10,0
    mensajeErrorMovimiento              db      "El movimiento planteado es inválido, ingrese nuevamente.", 0
    diffPosCercanas                     db      -8,-7,-6,-1,1,6,7,8
    diffPosLejanas                      db      -16,-14,-12,-2,2,12,14,16

                 





section .bss
    fileHandle                          resq    1
    archivoALeer                        resb    30
    inputStr                            resb    30
    inputChar                           resb    1
    ganador                             resb    10
    inputFilCol                         resb    50 ; Defino un campo lo suficientemente grande para mitigar el riesgo de pisar memoria
    inputValido                         resb    1  
    nombreJugador                       resb    10  ;Tiene valor "soldado" u "oficial". Se setea el valor segun el turno, y sirve para el mensaje "mensajeNoHayJugador"
    inputFila                           resb    1
    inputColumna                        resb    1
    filaOrigen                          resb    1
    columnaOrigen                       resb    1
    filaDestino                         resb    1
    columnaDestino                      resb    1
    caracter                            resb    1
    direccionFuncion                    resq    1
    posicionDestino                     resb    1
    posicionOrigen                      resb    1
    diff                                resb    1
    

    haySoldadoCerca                     resb    1   ; S o N
    sePuedeCapturar                     resb    1   ; S o N

    diffPosicionesSoldadosCerca         resb    8   ;es un vector con los valores de las posiciones de los soldados cercanos al oficial
    cantidadDeSoldadosCerca             resb    1
    
    posicionesDestinoParaCapturar       resb    8   ; si el soldado está completamente rodeado, puede pasar que tenga 8 posiciones disponibles para capturar a cualquier soldado
    cantidadPosicionesDestinoParaCapturar resb 1

    hayObligacionDeCapturar             resb    1   ; S o N
    soldadoCaptura                      resb    1   ; S o N
    posicionSoldadoCapturado            resb    1
    