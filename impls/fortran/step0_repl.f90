program step0_repl
    use iso_fortran_env
    implicit none (type, external)
    call main()

contains

    function READ_ (str)
        character(len=*), intent(in)  :: str
        character(len=:), allocatable :: READ_
        READ_ = str
    end function READ_

    function EVAL_ (ast, env)
        character(len=*), intent(in)  :: ast
        character(len=*), intent(in)  :: env
        character(len=:), allocatable :: EVAL_
        EVAL_ = ast
    end function EVAL_

    function PRINT_ (ast)
        character(len=*), intent(in)  :: ast
        character(len=:), allocatable :: PRINT_
        PRINT_ = ast
    end function PRINT_

    function REP (str)
        character(len=*), intent(in)  :: str
        character(len=:), allocatable :: REP
        REP = PRINT_(EVAL_(READ_(str), ''))
    end function REP

    subroutine main ()
        character(1000)               :: line
        character(len=:), allocatable :: trimmed_line
        integer                       :: io_status

        do while(.true.)
            ! prompt with caret on same line as input, here using a greater than sign >
            write(output_unit,'(A)',advance='no') 'user> '
            flush(output_unit)

            io_status = 0
            read(input_unit,"(A)", iostat=io_status) line
            ! trap Ctrl-D EOF on Unix-like systems to avoid crashing program
            if (io_status /= 0) then
                backspace(input_unit)  ! ctrl D gobble
                exit
            else
                line = adjustl(line)
                trimmed_line = trim(line)
                if (len(trimmed_line) /= 0) write(output_unit,'(A)') REP(trimmed_line)
            endif
        enddo
        write(output_unit,'(A)') ''
    end subroutine main
end program step0_repl
