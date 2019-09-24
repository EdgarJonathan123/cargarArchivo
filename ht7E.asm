;===============SECCION DE MACROS ===========================
print macro cadena 
LOCAL ETIQUETA 
ETIQUETA: 
	MOV ah,09h 
	MOV dx,@data 
	MOV ds,dx 
	MOV dx, offset cadena 
	int 21h
endm

getRuta macro buffer
LOCAL INICIO,FIN
	xor si,si
INICIO:
	getChar
	cmp al,0dh
	    je FIN
	mov buffer[si],al
	inc si
	jmp INICIO
FIN:
	mov buffer[si],00h
endm

getTexto macro buffer
LOCAL INICIO,FIN
	xor si,si
INICIO:
	
	getChar

	cmp al,0dh
		je FIN
	mov buffer[si],al
	inc si
	jmp INICIO
FIN:
	mov buffer[si],'$'
endm

getChar macro
mov ah,0dh
int 21h
mov ah,01h
int 21h
endm

;=========================== FICHEROS ===================
abrirF macro ruta, handle
	mov ah,3dh
	mov al,010b
	lea dx, ruta
	int 21h
		jc ErrorAbrir
	mov handle,ax
endm



leerF macro handle, numBytes, bufferOut
	mov ah,3fh
	mov bx,handle
	mov cx,numBytes
	lea dx, bufferOut
	int 21h
	jc ErrorLeer
	
endm

crearF macro ruta, handle
	mov ah, 3ch
	mov cx, 00h
	lea dx, ruta
	int 21h
	jc ErrorCrear
	mov handle, ax
endm

escribirF macro handle, numBytes, buffer
	mov ah, 40h
	mov bx, handle
	mov cx, numBytes
	lea dx, buffer
	int 21h
	jc ErrorEscribir
endm


cerrarF macro Handle
    mov ah,3eh
    mov bx,handle
    int 21h
    jc ErrorCerrar
endm

;=========================== Conversiones ===================

AMinuscula macro arreglo

LOCAL continuar, finalizar, MAYUSCULA, MAYOR,MENOR ,AUMENTAR

xor di,di 

    continuar:

        cmp arreglo[di],24h
            je finalizar
        jmp MAYOR


    MAYOR: 
    ; ARREGLRO[DI] >= A
        cmp arreglo[di],41h
            ja MENOR 
        jmp AUMENTAR    
    
    MENOR:
     ; ARREGLRO[DI] =< Z
        cmp arreglo[di],5ch
			jb MAYUSCULA
        jmp AUMENTAR        

	MAYUSCULA:
		mov al,arreglo[di]
		mov ah,20h

		add ah, al

		mov arreglo[di],ah
    
        
    AUMENTAR:
        inc di
        jmp continuar
       
    finalizar: 
    

endm



AMayuscula macro arreglo

LOCAL continuar, finalizar, MAYUSCULA, MAYOR,MENOR ,AUMENTAR


xor di,di 

    continuar:

        cmp arreglo[di],24h
            je finalizar
        jmp MAYOR


    MAYOR: 
    ; ARREGLRO[DI]>=a
        cmp arreglo[di],61H
            jae MENOR 
        jmp AUMENTAR    
    
    MENOR:
     ; ARREGLRO[DI]=<z
        cmp arreglo[di],7AH
			jbe MINUSCULA
        jmp AUMENTAR        

	MINUSCULA:
		mov al,arreglo[di]
		mov ah,20h

		sub al,ah

		mov arreglo[di],al
    
        
    AUMENTAR:
        inc di
        jmp continuar
       

    finalizar: 
    


endm
;-----------------------------

contarElementos macro arreglo   ;en di te devuelve el numero de elementos del arreglo en di
    LOCAL continuar, finalizar
    xor di,di
    continuar:
        cmp arreglo[di],24h
        je finalizar
        inc di
        jmp continuar
    finalizar: 
        dec di
endm

;================= DECLARACION TIPO DE EJECUTABLE ============
.model small 
.stack 100h 
.data 
;================ SECCION DE DATOS ========================
encab db 0ah,0dh,' CLASE 7 ARQUI 1',0ah,0dh,'1) Cargar archivo', 0ah,0dh,'2) toLower',0ah,0dh,'3) toUpper',0ah,0dh,'4) Reporte',0ah,0dh,'5) Salir',0ah,0dh,'$'
msm1 db 0ah,0dh,'FUNCION ABRIR',0ah,0dh,'$'
msm2 db 0ah,0dh,'FUNCION toUpper',0ah,0dh,'$'
msm3 db 0ah,0dh,'FUNCION Tolower',0ah,0dh,'$'
msm4 db 0ah,0dh,'FUNCION ESCRIBIR REPORTE',0ah,0dh,'$'
msmError1 db 0ah,0dh,'Error al abrir archivo','$'
msmError2 db 0ah,0dh,'Error al leer archivo','$'
msmError3 db 0ah,0dh,'Error al crear archivo','$'
msmError4 db 0ah,0dh,'Error al escribir reporte','$'
msmError5 db 0ah,0dh,'Error al Cerrar el archivo','$'
corA db 91,'$'
corC db 93,'$'

rutaHtml   db 'report.html',00h
rutatxt   db 'texto.txt',00h


; variables para escribir
tableA    db '<table  border=',022h,'true',022h,'>',0ah,0dh
tableC    db '</table>',0ah,0dh

salida    db ' <td  align=',022h,'center',022h,'>SALIDA</td>',0ah,0dh

trA    db '<tr>',0ah,0dh
trC    db '</tr>',0ah,0dh

tdA    db '<td>',0ah,0dh
tdC    db '</td>',0ah,0dh


rutaArchivo db 100 dup('$')
bufferLectura db 100 dup('$')
bufferEscritura db 100 dup('$')
handleFichero dw ?
handle2 dw ?
.code ;segmento de código
;================== SECCION DE CODIGO ===========================
	main proc 
		Menu:
			print encab
			getChar
			cmp al,'1'
			    je CARGAR
			cmp al,'2'
			    je TOLOWER
            cmp al,'3'
			    je TOUPPER
			cmp al,'4'
			    je REPORTE
			cmp al,'5'
			    je SALIR
			
			
			jmp Menu
		CARGAR:
			abrirF rutatxt, handleFichero
			getChar
			jmp Menu

		TOLOWER:
			print msm3
			leerF handleFichero, SIZEOF bufferLectura, bufferLectura

            print corA
            print bufferLectura
            print corC

            AMinuscula bufferLectura

            print corA
            print bufferLectura
            print corC

       
			getChar
			jmp Menu

        TOUPPER:
            print msm2
			leerF handleFichero, SIZEOF bufferLectura, bufferLectura

            print corA
            print bufferLectura
            print corC

            AMayuscula bufferLectura

            print corA
            print bufferLectura
            print corC

       
			getChar
			jmp Menu


        REPORTE:
			
			print msm2
			print msm4
			crearF rutaHtml, handle2

			contarElementos bufferLectura
           
			escribirF handle2, SIZEOF tableA, tableA
			escribirF handle2, SIZEOF trA, trA
			escribirF handle2, SIZEOF salida, salida
			escribirF handle2, SIZEOF trC, trC
			escribirF handle2, SIZEOF trA, trA
			escribirF handle2, SIZEOF tdA, tdA
			escribirF handle2, di, bufferLectura
			escribirF handle2, SIZEOF tdA, tdA
			escribirF handle2, SIZEOF trC, trC
			escribirF handle2, SIZEOF tableC, tableC
    
            cerrarF handle2


			getChar 
			jmp Menu


		CREAR:
			print msm2
			getRuta rutaArchivo
			crearF rutaArchivo, handle2
			getChar
			jmp Menu
			
		ESCRIBIR: 
			print msm4
			getTexto bufferEscritura
			escribirF handle2, SIZEOF bufferEscritura, bufferEscritura
            cerrarF handle2

        
            print msm4
			getTexto bufferEscritura
			escribirF handle2, SIZEOF bufferEscritura, bufferEscritura
            cerrarF handle2


			getChar 
			jmp Menu


	    ErrorAbrir:
	    	print msmError1
	    	getChar
	    	jmp Menu
	    ErrorLeer:
	    	print msmError2
	    	getChar
	    	jmp Menu
	    ErrorCrear:
	    	print msmError3
	    	getChar
	    	jmp Menu
			
		ErrorEscribir:
	    	print msmError4
	    	getChar
	    	jmp Menu

        ErrorCerrar:
	    	print msmError5
	    	getChar
	    	jmp Menu


		SALIR: 
			MOV ah,4ch 
			int 21h
	main endp
;================ FIN DE SECCION DE CODIGO ========================
end