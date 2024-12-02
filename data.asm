section .data
    cmd_clear                           db      "clear",0
    mensajeInicial                      db      "'El Asalto'.",10,"Reglas:",0
    reglasSoldados                      db      "-Los soldados (X) solo se pueden mover hacia abajo en linea recta o en diagonal, y solo en una unidad, a excepción de los de la posicion 4-0, 4-1, 4-5 y 4-6, que pueden moverse horizontalmente.",0
    reglasOficiales                     db      "-Los oficiales (O) pueden moverse en cualquier dirección en una unidad. El soldado elegido no puede desentenderse de su obligación de capturar a los soldados, y si así lo hace, es retirado.",0
    tablero                 times 50    db      0                                           ;49 para los caracteres y 1 para el 0 que agrega fgets
    archivoTablero                      db      "tablero.txt",0
    archivoTableroGuardado              db      "tableroGuardado.txt",0
    archivoOficiales                    db      "datosOficiales.txt",0
    archivoOficialesGuardado            db      "datosOficialesGuardado.txt",0
    archivoTurno                        db      "turno.txt",0
    mensajeErrorLectura                 db      "Hubo un error al leer: %s",10,0
    modoLectura                         db      "r",0
    modoEscritura                       db      "w",0
    mensajeCargarPartida                db      10,"Hay una partida guardada, ¿quiere reanudarla? S/N",0
    hayPartidaGuardada                  db      'N'  ;por default    
    respuestaPositiva                   db      'S'
    respuestaNegativa                   db      'N'
    mensajeEleccionCargaIncorrecta      db      "Respuesta inválida, debe ser S o N",10,0
    informacion                         db      10,"Ingrese par fila-columna:",10,"- 0 0 para ver menú de salida.",10,"- 1 1 para cambiar la posicion origen seleccionada.",0
    mensajeEleccionSalida               db      10,"Ingrese:",10,"- G para guardar la partida.",10,"- X para salir de la partida.",10,0
    mensajeEleccionSalidaIncorrecta     db      "La elección es incorrecta, ingrese nuevamente.",0
    mensajeErrorAperturaGuardado        db      "Hubo un error al abrir el archivo de guardado",0
    mensajeErrorGuardado                db      "Hubo un error al guardar el archivo.",0
    mensajeGuardadoExitoso              db      "La partida fue guardada con exito!.",0
    mensajeSalirSinGuardar              db      "Se salió sin guardar.",0
    formatoChar                         db      "%c",0
    formatoInt                          db      "%hhi",0
    formatoInputFilCol                  db      "%hhi %hhi",0 ; Transformar los campos a nro entero (me sobra para guardar un nro entre 1 y 7)
    juegoTerminado                      db      'N'
    turnoJugador                        db      1   ;1 representa Soldados, 2 representa Oficiales
    mensajeDelGanador                   db      "Los ganadores son los %s",10,0
    oficiales                           db      "OFICIALES (O)",0
    soldados                            db      "SOLDADOS (X)",0
    mensajeTurno                        db      "Turno de: %s",10,0
    strOficial                          db      "oficial",0
    strSoldado                          db      "soldado",0
    cantidadOficiales                   db      2
    cantidadSoldados                    db      24
    posicionesFortaleza                 db      30,31,32,37,38,39,44,45,46
    posicionOficial1                    db      44      ; es dinamico, arranca con este valor
    posicionOficial2                    db      39      ; es dinamico, arranca con este valor 

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
    mensajeSoldadoEncerrado             db      "El soldado no puede moverse, ingrese nuevamente.",0
    mensajeOficialEncerrado             db      "El oficial está encerrado y no puede moverse, ingrese nuevamente.", 0

    ;Para la impresion del tablero
    e                                   db      "   ",0
    formatoIndiceInt                    db      " %i ",0
    formatoIndiceChar                   db      " %c ",0
    nuevaLinea                          db      "",0

    ;Seccion movimientos
    mensajeIngFilColOrigen              db      "-->Ingrese fila (0 a 6) y columna (0 a 6) ORIGEN, separados por un espacio: ", 0
    mensajeIngFilColDestino             db      "-->Ingrese fila (0 a 6) y columna (0 a 6) DESTINO, separados por un espacio: ", 0
    mensajeFormatoIncorrecto            db      "El formato es incorrecto, ingrese nuevamente.",0
    mensajeFilColFueraTablero           db      "La posicion es inválida, ingrese nuevamente.",0
    mensajeNoHayJugador                 db      "En la posicion elegida no hay un %s, ingrese nuevamente.",10,0
    mensajeErrorMovimiento              db      "El movimiento planteado es inválido, ingrese nuevamente.", 0
    diffPosCercanas                     db      -8,-7,-6,-1,1,6,7,8
    diffPosLejanas                      db      -16,-14,-12,-2,2,12,14,16

    hayObligacionDeCapturar             db      'N'   ; S o N en ejecucion
    oficialCaptura                      db      'N'   ; S o N en ejecucion
    oficialRemovido                     db      'N'   ; S o N en ejecucion

    numeroOficialRemovido               db      0     ; luego toma el valor 1 o 2 cuando se capture un soldado. 1 para el que comienza a la izquierda, y 2 para el de la derecha
    oficialesBloqueados                 db      'N'   ; se setea en S cuando los oficiales son acorralados
    
    ;Comentario de la jugada
    comentario                          db      "Comentario jugada: %s",10,0
    mensajeSoldadoCapturado             db      "se capturó un soldado.",0
    mensajeOficialRetirado              db      "el oficial no capturó y fue retirado.",0
    mensajeVacio                        db      "",0
    ;Motivos de la victoria
    mensajeFortalezaOcupada             db      "Motivo: La fortaleza fue ocupada completamente.",0
    mensajeOficialesRetirados           db      "Motivo: Los dos oficiales fueron retirados.",0
    mensajeSoldadosInsuficientes        db      "Motivo: Los soldados ya no pueden ocupar la fortaleza.",0
    mensajeOficialesBloqueados          db      "Motivo: Los oficiales fueron bloqueados."

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
    eleccionSalida                      resb    1
    inputStr                            resb    30
    inputChar                           resb    1
    ganador                             resb    10
    inputFilCol                         resb    50  ; Defino un campo lo suficientemente grande para mitigar el riesgo de pisar memoria
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
    pedirInputOrigenDeNuevo             resb    1   ; S o N
    
    haySoldadoCerca                     resb    1   ; S o N
    sePuedeCapturar                     resb    1   ; S o N

    diffPosicionesSoldadosCerca         resb    8   ;es un vector con los valores de las posiciones de los soldados cercanos al oficial
    cantidadDeSoldadosCerca             resb    1
    
    posicionesDestinoParaCapturar       resb    8   ; si el soldado está completamente rodeado, puede pasar que tenga 8 posiciones disponibles para capturar a cualquier soldado
    cantidadPosicionesDestinoParaCapturar   resb 1

    posicionSoldadoCapturado            resb    1
    
    comentarioJugadaStr                 resb    100
    motivoGanador                       resb    100

    turnoJugadorStr                     resb    2
