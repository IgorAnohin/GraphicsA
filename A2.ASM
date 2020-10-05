.model small
.data
address dw 100h
databits db 93h

.code
start:

; Init Adapter

mov ax, @data     ; настройка сегмента данных
mov ds, ax        ; через регистр ах
mov ax, 6         ; CGA
int 10h           ; Прерывание BIOS 

; Init offset

mov ax, 0b800h    ; адрес видеопамяти
mov es, ax        ; устанавливаем сегментный регистр
mov bx, address   ; смещение 

;---рисуем точку
mov al, databits 
mov es:[bx], al   ;выводим точку

; Завершение

xor ax, ax        ;ожидание нажатия клавиши
int 16h

mov ax, 4C00h     ;выход из графики с возвратом
int 21h           ;в предыдущий режим
end start
