        format PE GUI 4.0
        entry start
        include '%fasminc%\win32w.inc'

        CONTROLS_NUMBER = 2
        ID_MAIN_FORM = 100
        ID_BLINK_BUTTON = 200
        ID_TIMER_TEXT = 300

section '.code' code readable executable
start:
        invoke GetModuleHandle, 0
        invoke DialogBoxParam, EAX, ID_MAIN_FORM, HWND_DESKTOP, DialogProc, 0
        invoke ExitProcess, 0

        proc DialogProc hWndDlg, msg, wParam, lParam
             cmp    [msg], WM_CLOSE
             je     FreeDialog
             mov    EAX, BN_CLICKED
             shl    EAX, 10h
             add    EAX, ID_BLINK_BUTTON
             cmp    [wParam], EAX
             je     Execute
             jmp    ExitProc

        Execute:
             mov    EDX, 30
        @@:
             push   EDX
             invoke KeyboardEvent, VK_CAPITAL, 0, KEYEVENTF_EXTENDEDKEY, 0
             invoke KeyboardEvent, VK_CAPITAL, 0, KEYEVENTF_KEYUP, 0
             invoke Sleep, 1000
             pop    EDX
             push   EDX
             invoke SetDlgItemInt, [hWndDlg], ID_TIMER_TEXT, EDX, FALSE
             pop    EDX
             dec    EDX
             jnz    @B

        FreeDialog:
             invoke EndDialog, [hWndDlg], 0

        ExitProc:
             xor    EAX, EAX
             ret
        endp

section '.idata' import data readable writeable
        library kernel, 'KERNEL32.DLL',\
                user, 'USER32.DLL',\
                comdlg, 'COMDLG32.DLL'

        import kernel,\
               ExitProcess, 'ExitProcess',\
               GetModuleHandle, 'GetModuleHandleW',\
               GetProcessHeap, 'GetProcessHeap',\
               DeleteFile, 'DeleteFileW',\
               Sleep, 'Sleep'

        import user,\
               DialogBoxParam, 'DialogBoxParamW',\
               EndDialog, 'EndDialog',\
               MessageBox, 'MessageBoxW',\
               GetKeyboardState, 'GetKeyboardState',\
               KeyboardEvent, 'keybd_event',\
               SetDlgItemInt, 'SetDlgItemInt',\
               GetDlgItem, 'GetDlgItem'

section '.rsrc' resource data readable
        directory RT_DIALOG, dialogs
        resource dialogs, ID_MAIN_FORM, LANG_ENGLISH, MainForm
        dialog MainForm, 'BLINK', 300, 200, 20, 45, WS_VISIBLE + WS_CAPTION + WS_SYSMENU
               dialogitem 'BUTTON','RUN', ID_BLINK_BUTTON, 8, 4, 70, 20, WS_VISIBLE
               dialogitem 'STATIC','', ID_TIMER_TEXT, 40, 30, 30, 20, WS_VISIBLE
        enddialog