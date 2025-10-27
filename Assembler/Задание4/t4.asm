global _start; Объявляем точку входа _start глобальной для линковщика

section .data; Секция данных (инициализированные данные)

msgNumber1 db "Enter 1 number: ", 0
msgNumber1_len equ $ - msgNumber1

msgNumber2 db "Enter 2 number: ", 0
msgNumber2_len equ $ - msgNumber2

msgResult db "Answer: ", 0
msgResult_len equ $ - msgResult

error_msg db "an error occurred while executing the program",10 ; Сообщение которое будем выводить при ошибке "во время выполнения программы произошла ошибка", с переходом на новую строку(10)
error_msg_length equ $ - error_msg ; Считаем автоматически длину строки

number1 dq 0
number2 dq 0
answer dq 0

section .bss
buffer resb 32
buffer_answer resb 32

section .text ; Секция кода - исполняемая программа
_start: ; Точка входа программы

mov rsi, msgNumber1
mov rdx, msgNumber1_len
call print_console

; Ввод числа 1    
call read_console

mov r9, number1
call str_to_int

mov rsi, msgNumber2
mov rdx, msgNumber2_len
call print_console

; Ввод числа 2    
call read_console

mov r9, number2
call str_to_int

; Сложение
call sum

; Вывод сообщения ответа
mov rsi, msgResult
mov rdx, msgResult_len
call print_console

call int_to_str

; Печать результата
mov rsi, buffer_answer
mov rdx, 32
call print_console

mov rax, 60
mov rdi, 0
syscall

print_console:
mov rax, 1
mov rdi, 1
syscall

cmp rax, 0      ; Сравниваем возвращаемое значение с 0
jl error_end    ; Если отрицательное - ошибка

cmp rax, rdx ; Сравниваем с заранее заданной длиной
jl error_end ; Если выведено не то кол-во байтов - ошибка

ret

read_console:
mov rax, 0 ; read (системный вызов)
mov rdi, 0 ; Читаем поток stdin
mov rsi, buffer ; Считываемый текст в переменную
mov rdx, 32
syscall

cmp rax, 0 ; Сравниваем возвращаемое значение с 0
jl error_end ; Если отрицательное - ошибка

ret

str_to_int:
mov rsi, buffer
mov rax, 0
mov rbx, 10

str_to_int_loop:
mov cl, [rsi] ; берем текущий символ
cmp cl, 10 ; проверяем перенос строки
je str_to_int_done

sub cl, '0' ; преобразуем символ в цифру
mul rbx ; умножаем текущее число на 10
add rax, rcx ; добавляем новую цифру

inc rsi ; переходим к следующему символу
jmp str_to_int_loop

str_to_int_done:
mov [r9], rax        ; сохраняем результат
ret

int_to_str:
mov rax, [answer]
mov rdi, buffer_answer
add rdi, 30
mov rbx, 10 ; основание системы

int_to_str_loop:

dec rdi ; двигаемся назад по буферу
xor rdx, rdx ; обнуляем RDX для деления
div rbx ; делим RAX на 10, остаток в RDX
add dl, '0' ; преобразуем цифру в символ
mov [rdi], dl ; сохраняем символ

test rax, rax ; проверяем, осталось ли число
jnz int_to_str_loop ; если не ноль, продолжаем

ret


sum:
mov r9, [number1]
mov r8, [number2]
add r9, r8
mov [answer], r9
ret        

; Секция вывода сообщения об ошибке
error_end:

mov rax, 1 ; Системный вызов write (вывод)
mov rdi, 2 ; Дескриптор файла stderr (стандартный вывод ошибок)
mov rsi, error_msg ; Адрес сообщения об ошибке
mov rdx, error_msg_length ; Длина сообщения об ошибке
syscall ;  Системной вызов вывода об ошибке

mov rax, 60
mov rdi, 1
syscall