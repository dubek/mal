module reader
    implicit none

    private

    type token
        character(:), allocatable :: s
    end type token

    type tokens_list
        type(token), dimension(:), allocatable :: list
    end type tokens_list

    function tokenize(str, list)
        character(len=*), intent(in)      :: str
        class(tokens_list), intent(inout) :: list
    end function tokenize
end module reader
