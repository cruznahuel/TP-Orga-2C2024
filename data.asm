section .data
    mensajeInicial                      db      "Bienvenidos al juego 'El Asalto'",0
    tablero                 times 50    db      0                                           ;49 para los caracteres y 1 para el 0 que agrega fgets
    archivoTablero                      db      "tablero.txt",0
    archivoTableroGuardado              db      "tableroGuardado.txt",0
    archivoOficiales                    db      "datosOficiales.txt",0
    archivoOficialesGuardado            db      "datosOficialesGuardado.txt",0
    mensajeErrorLectura                 db      "Hubo un error al leer: %s",10,0
    modoLectura                         db      "r",0
    modoEscritura                       db      "w",0
    mensajeCargarPartida                db      "Hay una partida guardada, ¿quiere reanudarla? S/N",10,0
    respuestaPositiva                   db      'S'
    respuestaNegativa                   db      'N'
    mensajeEleccionCargaIncorrecta      db      "Respuesta inválida, debe ser S o N",10,0
    formatoChar                         db      "%c",0    
    formatoInputFilCol                  db      "%hi %hi", 0 ; Transformar los campos a nro entero (me sobra para guardar un nro entre 1 y 7)

    ;para la impresion de  datos de oficiales
    mensajeNoroeste                     db      "noroeste:%hd,",0
    mensajeNorte                        db      "norte:%hd,",0
    mensajeNoreste                      db      "noreste:%hd,",0
    mensajeOeste                        db      "oeste:%hd,",0
    mensajeEste                         db      "este:%hd,",0
    mensajeSudoeste                     db      "sudoeste:%hd,",0
    mensajeSur                          db      "sur:%hd,",0
    mensajeSudeste                      db      "sudeste:%hd,",0
    mensajeCapturas                     db      "capturas:%hd",10,0
    mensajeOficial1                     db      "oficial1:",0
    mensajeOficial2                     db      "oficial2:",0

    ;Para la impresion del tablero
    e                                   db      "   ",0
    formatoIndiceInt                    db      " %i ",0
    formatoIndiceChar                   db      " %c ",0
    nuevaLinea                          db      "",0

    ;para la escritura de archivos
    saltoDeLinea                        db      10


    prueba                              db      "prueba",0

    ; Seccion movimientos
    mensajeIngFilColOrigen              db      "Ingrese fila (0 a 6) y columna (0 a 6) que desea mover separados por un espacio: ", 0
    mensajeErrorInput                   db      "Los datos ingresados son inválidos, intente nuevamente.", 0
    mensajeInputCorrecto                db      "Los datos son correctos", 0
    mensajeSoldadoValido                db      "La posición indicada tiene efectivamente un soldado", 0
    mensajeErrorSoldado                 db      "No hay un soldado presente en esta posición", 0
    mensajeIngFilColDestino             db      "Ingrese fila (0 a 6) y columna (0 a 6) a la que desea mover separados por un espacio: ", 0
    
    soldado                             db      'X' ; Defino variable soldado con valor 'X'
    oficial                             db      'O' ; Defino variable oficial con valor 'O'
    lugarLibre                          db      '_' ; Defino variable lugarLibre con valor '_'
     

    mensajeErrorLugarLibre              db      "La posición seleccionada no está libre, por favor ingrese nuevamente", 0
    mensajeLugarLibreValido             db      "La posición seleccionada está efectivamente libre", 0
    mensajeErrorMovimiento              db      "El movimiento planteado no es valido", 0
    mensajeMovimientoValido             db      "El movimiento planteado es correcto", 0
    mensajeTurnoOficial                 db      "Es turno del oficial para mover", 0
    mensajeTurnoSoldado                 db      "Es turno del soldado para mover", 0
    mensajeErrorOficial                 db      "No hay un oficial presente en esta posición", 0
    mensajeOficialValido                db      "La posición indicada tiene efectivamente un oficial", 0

    turnoSoldado                        db      1

    oficialSeleccionado                 db      1
    filaOficial1                        dw      0
    columnaOficial1                     dw      0
    filaOficial2                        dw      0
    columnaOficial2                     dw      0
    datosOficial1                       times 26 db 0; 22 para datos(pueden ser de 1 o 2 caracteres cada uno) y 4 adicionales
    datosOficial2                       times 26 db 0 
    buffer                              times 50 db 0
    indice                              db      0   
    datosOficialActual                  dw      0   

section .bss
    fileHandle                          resq    1
    fileHandleOficiales                 resq    1
    archivoALeer                        resb    30
    archivoOficialesALeer               resb    30
    inputStr                            resb    30
    inputChar                           resb    1
    inputFilCol                         resb    50 ; Defino un campo lo suficientemente grande para mitigar el riesgo de pisar memoria
    filaOrigen                          resw    1
    columnaOrigen                       resw    1
    inputValido                         resb    1 ; 'S' valido 'N' invalido
    inputFilColDestino                  resb    50
    filaDestino                         resw    1
    columnaDestino                      resw    1
    desplazamientoOrigen                resw    1
    desplazamientoDestino               resw    1
    caracter                            resb    1
