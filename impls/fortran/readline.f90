module readline
    use iso_fortran_env
    implicit none

    private
    public:: do_readline

contains

subroutine do_readline(prompt, line, eof)
    character(len=*), intent(in)  :: prompt
    character(len=*), intent(out) :: line
    logical, intent(out)          :: eof

    integer                       :: io_status

    write(output_unit, '(A)', advance='no') prompt
    flush(output_unit)

    io_status = 0
    eof = .false.
    read(input_unit,"(A)", iostat=io_status) line
    if (io_status /= 0) then
        backspace(input_unit)  ! remove the Ctrl-D
        eof = .true.
    endif
end subroutine do_readline

end module readline
