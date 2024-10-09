org 0x7c00                ; Set the origin of the program to memory address 0x7C00

video = 0x10              ; Define a constant for video service interrupt number
set_cursor_pos = 0x02     ; Define a constant for setting the cursor position
write_char = 0x0a         ; Define a constant for writing a character to the screen

system_services = 0x15    ; Define a constant for system services interrupt number
wait_service = 0x86       ; Define a constant for the wait service function

keyboard_int = 0x16       ; Define a constant for keyboard interrupt number
keyboard_read = 0x00      ; Define a constant for reading a keystroke
keystroke_status = 0x01   ; Define a constant for checking keystroke status

timer_int = 0x1a          ; Define a constant for timer interrupt number
read_time_counter = 0x00  ; Define a constant for reading the time counter

left_arrow = 0x4b         ; Define a constant for the left arrow key scan code
right_arrow = 0x4d        ; Define a constant for the right arrow key scan code
down_arrow = 0x50         ; Define a constant for the down arrow key scan code
up_arrow = 0x48           ; Define a constant for the up arrow key scan code

call handle_food          ; Call the handle_food subroutine to manage food logic

start:                    ; Label marking the start of the main program loop

mov ah, wait_service      ; Load the wait service function into register AH
mov cx, 1                 ; Set CX to 1, indicating we want to wait for one service
mov dx, 0                 ; Clear DX register
int system_services        ; Call the system services interrupt to wait

call handle_keyboard       ; Call the handle_keyboard subroutine to process keyboard input

mov ah, write_char        ; Load the write character function into register AH
mov bh, 0                 ; Set the page number to 0 (default page)
mov cx, 1                 ; Set CX to 1, indicating we want to write one character
mov al, ' '               ; Load a space character into AL for writing
int video                 ; Call the video interrupt to write the character

mov al, [food_pos]        ; Load the current food position into AL
cmp [pos_row], al         ; Compare the current row position with the food position
jne regular_flow          ; If not equal, jump to regular_flow
cmp [pos_col], al         ; Compare the current column position with the food position
jne regular_flow          ; If not equal, jump to regular_flow
call handle_food          ; If both match, call handle_food to manage food logic

regular_flow:             ; Label marking the regular flow of the program

mov ah, set_cursor_pos    ; Load the set cursor position function into register AH
mov dh, [pos_row]         ; Load the current row position into DH
mov dl, [pos_col]         ; Load the current column position into DL
mov bh, 0                 ; Set the page number to 0 (default page)
int video                 ; Call the video interrupt to set the cursor position

mov ah, write_char        ; Load the write character function into register AH
mov bh, 0                 ; Set the page number to 0 (default page)
mov cx, 1                 ; Set CX to 1, indicating we want to write one character
mov al, '*'               ; Load the character '*' into AL for writing
int video                 ; Call the video interrupt to write the character

cmp byte [scan_code], left_arrow  ; Compare the scan code with the left arrow key
jne check_right_arrow     ; If not equal, jump to check_right_arrow
dec byte [pos_col]        ; Decrement the column position to move left
jmp start                 ; Jump back to the start of the main loop

check_right_arrow:        ; Label for checking the right arrow key

cmp byte [scan_code], right_arrow ; Compare the scan code with the right arrow key
jne check_up_arrow        ; If not equal, jump to check_up_arrow
inc byte [pos_col]        ; Increment the column position to move right
jmp start                 ; Jump back to the start of the main loop

check_up_arrow:           ; Label for checking the up arrow key

cmp byte [scan_code], up_arrow ; Compare the scan code with the up arrow key
jne check_down_arrow      ; If not equal, jump to check_down_arrow
dec byte [pos_row]        ; Decrement the row position to move up
jmp start                 ; Jump back to the start of the main loop

check_down_arrow:         ; Label for checking the down arrow key

cmp byte [scan_code], down_arrow ; Compare the scan code with the down arrow key
jne failure               ; If not equal, jump to failure
inc byte [pos_row]        ; Increment the row position to move down

jmp start                 ; Jump back to the start of the main loop

failure:                  ; Label for failure condition
jmp $                     ; Infinite loop to halt the program

handle_keyboard:          ; Subroutine to handle keyboard input
mov ah, keystroke_status  ; Load the keystroke status function into register AH
int keyboard_int          ; Call the keyboard interrupt to check for a keystroke
jz end_of_handle_keyboard  ; If no keystroke, jump to end_of_handle_keyboard

mov ah, keyboard_read     ; Load the keyboard read function into register AH
int keyboard_int          ; Call the keyboard interrupt to read the keystroke
mov [scan_code], ah      ; Store the scan code in the scan_code variable

end_of_handle_keyboard:   ; Label marking the end of the keyboard handling subroutine
ret                       ; Return from the subroutine

handle_food:              ; Subroutine to handle food logic
mov ah, read_time_counter  ; Load the read time counter function into register AH
int timer_int              ; Call the timer interrupt to read the time counter
mov al, 7                 ; Load the value 7 (binary 111) into AL
and al, dl                ; Perform a bitwise AND operation with DL
mov byte [food_pos], al   ; Store the result in the food_pos variable
add byte [food_pos], 7    ; Increment the food position by 7

mov ah, set_cursor_pos     ; Load the set cursor position function into register AH
mov dh, [food_pos]         ; Load the food position into DH
mov dl, [food_pos]         ; Load the food position into DL
mov bh, 0                  ; Set the page number to 0 (default page)
int video                  ; Call the video interrupt to set the cursor position

mov ah, write_char         ; Load the write character function into register AH
mov bh, 0                  ; Set the page number to 0 (default page)
mov cx, 1                  ; Set CX to 1, indicating we want to write one character
mov al, '&'                ; Load the character '&' into AL for writing
int video                  ; Call the video interrupt to write the character

mov ah, set_cursor_pos     ; Load the set cursor position function into register AH
mov dh, 0                  ; Set the row position to 0
mov dl, 0                  ; Set the column position to 0
mov bh, 0                  ; Set the page number to 0 (default page)
int video                  ; Call the video interrupt to set the cursor position

ret                        ; Return from the handle_food subroutine

pos_row:                  ; Variable to store the current row position
db 10                     ; Initialize the row position to 10

pos_col:                  ; Variable to store the current column position
db 5                      ; Initialize the column position to 5

scan_code:                ; Variable to store the current scan code
db left_arrow             ; Initialize the scan code to the left arrow key

food_pos:                 ; Variable to store the food position
db 15                     ; Initialize the food position to 15

times 510 - ($ - $$) db 0 ; Fill the remaining space with zeros until 510 bytes
dw 0xAA55                 ; Boot sector signature to indicate a valid bootable disk

