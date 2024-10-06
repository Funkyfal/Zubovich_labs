extrn MessageBoxA: PROC
extrn ExitProcess:PROC
extrn CreateThread:PROC
extrn FindWindowA:PROC
extrn MoveWindow:PROC
extrn Sleep:PROC

.data
caption             db      '64-bit hello', 0
message             db      'Hello, World!', 0
HWINDOW             dword   ?
SLEEP_DURATION      dword   10 
CURRENT_X           dword   450
CURRENT_Y           dword   350
new_x               dword   0
new_y               dword   0
MSGBOX_WIDTH        dword   133               
MSGBOX_HEIGHT       dword   140               
MAX_X               dword   1250              
MAX_Y               dword   600
const_X             dword   1000
const_Y             dword   600
const_sleep         dword   500

.code

Start proc
    sub rsp,28h 
    mov rcx, 0 
    lea rdx, message 
    lea r8, caption 
    mov r9d, 0 
    call MessageBoxA
    add rsp,28h

    ;CreateThread(0,0,Thread_Func, 0, 0, 0)
    mov RCX, 0           
    mov RDX, 0           
    mov R8,  Move 
    mov R9,  0           
    sub RSP, 12          
    mov qword ptr [RSP], 0     
    mov dword ptr [RSP + 8], 0 
    call CreateThread
    add RSP, 12

    sub rsp,28h 
    mov message+7,'h'
    mov message+8, 'e'
    mov message+9,'l'
    mov message+10,'l'
    mov message+11,'!'
    mov caption+11,'!'
    mov rcx, 0 
    lea rdx, message
    lea r8, caption
    mov r9d, 0 
    call MessageBoxA
    add rsp,28h 
    
Start endp

Move proc

;Find_WIndow(0,caption) return handler in EAX
FIND:
    mov  RCX, 0              
    lea  RDX, [caption] 
    call FindWindowA    
    cmp  RAX, 0
    je FIND

    mov [HWINDOW], EAX

new_coord:
    mov edx, 0
    rdrand AX
    div const_X
    mov eax, edx
    mov new_x , eax
  
    mov edx, 0
    rdrand AX
    div const_Y
    mov eax, edx
    mov new_y, eax
  
    mov edx, 0
    rdrand AX
    div const_sleep
    mov eax, edx
    add eax, 1
    mov SLEEP_DURATION, eax
  
LP_MOVE:
    ; Sleep(SLEEP_DURATION)
    mov ECX, [SLEEP_DURATION]
    call Sleep

    ; Генерация новых случайных координат для хаотичного перемещения
    mov edx, 0
    rdrand AX
    div const_X
    mov eax, edx
    mov CURRENT_X, eax

    mov edx, 0
    rdrand AX
    div const_Y
    mov eax, edx
    mov CURRENT_Y, eax

MOOVE_WINDOW:
    ; MoveWindow(HWINDOW,Current_x,Current_Y,MSGBOX_Width, MSGBOX_Height, 1)
    mov ECX, [HWINDOW]
    mov EDX, CURRENT_X
    mov R8D, CURRENT_Y
    mov R9D, [MSGBOX_WIDTH]
    mov EAX, [MSGBOX_HEIGHT]
    mov dword ptr [RSP+20h], EAX
    mov dword ptr [RSP+28h], 1
    call MoveWindow

    cmp EAX, 0
    jne LP_MOVE

    mov RCX, 0   
    jmp exit_p

exit_p:
  call ExitProcess
Move endp
End