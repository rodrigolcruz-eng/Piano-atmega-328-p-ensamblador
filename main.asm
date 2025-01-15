
.org 0x00   ;Llamada al reset 
 jmp inicio

.org 0x08
jmp intercc

.org 0x0A ;Llamada a las interrupcones por cambio pcint2 
jmp interca

.org 0x16
jmp semicorch

.org 0x1C; Llamada a la interrucion por registro de comparacion  timer0_compa
jmp compa


inicio:

in r16, ddrd  ; habilitacion de los puertos d como entrada y en pull up 
andi r16, 0x00
out ddrd, r16
ldi r16, 0xFF
out portd, r16

in r16, ddrb ; habilitacion de el puerto B0 como salida 
ori r16, 0x01
out ddrb, r16

in r16, ddrc
andi r16, 0x00
out ddrd, r16
ldi r16, 0x01
out portc, r16

lds r16, PCMSK1 
ldi r16, 0x01
sts pcmsk1, r16

lds r16, PCMSK2 ;Habilitacion de interrupcion por cambio en todas las terminales de D
ldi r16, 0xff
sts pcmsk2, r16

lds r16, PCICR ; Habilitacion de las interrupciones por cambio de PCINT2
ldi r16, 0x06
sts PCICR, r16

IN r16, TCCR0A ; Configuracion en WGM01 en 1 para modo CTC del contador (el maximo de ubica en OCR0A)
ldi r16, 0x02
OUT TCCR0A, r16

IN r16, TCCR0B ; configuracion para mantener apagado el timer al inciar el programa ( tres ultimos bits en 0) 
ldi r16, 0x00
OUT TCCR0B, r16

lds r16, timsk0 ; habilitacion de interrupcion por una coincidencia en la comparacion OCIE0A
ldi r16, 0x02
sts timsk0, r16

lds r16, tccr1a
ldi r16, 0x00
sts tccr1a, r16

lds r16, tccr1b
ldi r16, 0x08
sts tccr1b, r16

lds r16, tccr1c
ldi r16, 0x00
sts tccr1c, r16

lds r16, timsk1 
ldi r16, 0x02
sts timsk1, r16

lds r16, ocr1ah
ldi r16, 0x7A
sts ocr1ah, r16

lds r16, ocr1al
ldi r16, 0x12
sts ocr1al, r16




ldi r17, 0x00 ; Colocar el registro utilizado como salida en 0 
ldi r18, 0x01 ; registro utilizado para realizar el XOR


sei ; habiliacion global de interrupciones 

loop:
out portb, r17
rjmp loop

interca:  ; rutina para la interrpcion por cambio 
in r16, pind ; lectura de las entradas D para evaluarlas despues 

 cpi r16, 0xFE ;evalua que entrada cambio y manda a llamar la rutina para el cambio de frecuencia correspondiente 
 breq do

 cpi r16, 0xfd 
 breq re

 cpi r16, 0xfb 
 breq mi

 cpi r16, 0xf7 
 breq fa

 cpi r16, 0xef
 breq sol

 cpi r16, 0xdf
 breq la
 
 cpi r16,0xbf
 breq si

 cpi r16,0x7f
 breq do2 

 cpi r16, 0xff  
 breq cero
reti

cancion:
lds r16, tccr1b
ldi r16, 0x0a
sts tccr1b, r16

cpi r21, 0x00
breq do

cpi r21, 0x04 
breq cero

rjmp cancion 
reti
do:              ; en cada rutina enciende el timer en el registro TCCR0B y hace el cambio para el registro de comparacion ajustando la frecuencia de cada nota 
IN r16, TCCR0B
ldi r16, 0x02
OUT TCCR0B, r16
in r16, ocr0a
ldi r16, 0x79
out ocr0a, r16
reti

re:
IN r16, TCCR0B
ldi r16, 0x02
OUT TCCR0B, r16
in r16, ocr0a
ldi r16, 0x6c
out ocr0a, r16
reti

mi:
IN r16, TCCR0B
ldi r16, 0x02
OUT TCCR0B, r16
in r16, ocr0a
ldi r16, 0x60
out ocr0a, r16
reti

fa:
IN r16, TCCR0B
ldi r16, 0x02
OUT TCCR0B, r16
in r16, ocr0a
ldi r16, 0x5b
out ocr0a, r16
reti

sol:
IN r16, TCCR0B
ldi r16, 0x02
OUT TCCR0B, r16
in r16, ocr0a
ldi r16, 0x50
out ocr0a, r16
reti

la:
IN r16, TCCR0B
ldi r16, 0x02
OUT TCCR0B, r16
in r16, ocr0a
ldi r16, 0x47
out ocr0a, r16
reti

si:
IN r16, TCCR0B
ldi r16, 0x02
OUT TCCR0B, r16
in r16, ocr0a
ldi r16, 0x3f
out ocr0a, r16
reti

do2:
IN r16, TCCR0B
ldi r16, 0x02
OUT TCCR0B, r16
in r16, ocr0a
ldi r16, 0x3c
out ocr0a, r16
reti

cero:               ; si ninguna tecla se preciona se apaga el timer 
IN r16, TCCR0B
ldi r16, 0x00
OUT TCCR0B, r16
reti

compa:      ;rutina de interrupcion por comparacion 

EOR r17, r18   ; apaga y prende el pin B0 con un EXOR cunado el registro de comparacion se activa 
out portb, r17

reti

intercc:
in r16, pinc
 
 cpi r16, 0xfe
 breq cancion 

reti
semicorch:

ldi r21, 0x00
inc r21
 reti





