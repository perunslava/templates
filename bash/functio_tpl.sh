# .bashrc

function foo {
    local email_flag='False'
    local check_flag='False'
    local edit_flag='False'
    local disable_flag='False'

    local email=''
    local script_name="${FUNCNAME[0]}"
    local usage="Usage: ${script_name} -m spam@er.pl -c | -d | -e
    -c - sprawdz status skrzynki email
    -d - zablokuj skrzynke
    -e - edycja pliku shadow
    " 
    
    local OPTIND=1
    while getopts ':m:cde' option
    do
        case $option in
            c)
                check_flag='True'
                ;;
            d)
                disable_flag='True'
                ;;
            e)
                edit_flag='True'
                ;;
            m)
                email_flag='True'
                email="${OPTARG}"
                ;;
            ?)
                echo -e "${usage}" >&2
                return 1
                ;;
        esac
    done
    shift $((OPTIND - 1))

    ## main - allowed flag combinations
    # -m -c
    if [[ "$email_flag" == 'True' ]] && [[ "$check_flag" == 'True' ]]
    then
        echo 'check'
    # -m -d
    elif [[ "$email_flag" == 'True' ]] && [[ "$disable_flag" == 'True' ]]
    then
        echo 'disable'
    # -m -e 
    elif [[ "$email_flag" == 'True' ]] && [[ "$edit_flag" == 'True' ]]
    then
        echo 'edit'
    else
        echo "$usage" >&2 
        return 1
    fi
}
