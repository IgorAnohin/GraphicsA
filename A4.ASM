.model small
.data
address dw 0
bitmask db 8
x1 dw 100
x2 dw 200
y dw 100

.code
drawpixel proc near uses ax bx dx cx
    ; Координаты преващаем в смещение

    mov ax, y        ; select y
    mov dx, 40          ; 320 / 40 = 8 -> смещение в битах
    mul dx        ; ax = y * 80 -> смещение в байтах от y
    
    mov bx, x1
    mov cl, bl
    shr bx, 1               ; x // 8
    shr bx, 1
    shr bx, 1
    
    add bx, ax        ; x + y => смещение
    
    ; Макска для них
    
    and cl, 07h        ; bitmask mask
    xor cl, 07h
    mov ah, 01h
    shl ah, cl
    mov bitmask, ah
    
    ;---маскируем биты
    mov dx, 3CEh        ;указываем на адресный регистр
    mov al, 8            ;номер регистра
    out dx, al            ;посылаем его
    inc dx                ;указываем на регистр данных
    mov al, bitmask            ;маска
    out dx, al            ;посылаем данные

    ; Чистая магия. Без этого точки, а не линиии
    mov al, es:[bx]        ;читаем содержимое в задвижку

    ;---рисуем точку
    mov al, 0FFh        ;любое значение с установленным 7 битом
    mov es:[bx], al        ;выводим точку

    ret
    drawpixel endp

start:
; Init Adapter

mov ax, @data     ; настройка сегмента данных
mov ds, ax        ; через регистр ах
mov ax, 6         ; CGA
int 10h           ; Прерывание BIOS 

; Init offset

mov ax, 0b800h    ; адрес видеопамяти
mov es, ax        ; устанавливаем сегментный регистр

drawline: call drawpixel
    inc x1
    mov bx, x1
    cmp bx, x2
    jle drawline
;loop drawline

; Завершение

xor ax, ax        ;ожидание нажатия клавиши
int 16h

mov ax, 4C00h     ;выход из графики с возвратом
int 21h           ;в предыдущий режим
end start
