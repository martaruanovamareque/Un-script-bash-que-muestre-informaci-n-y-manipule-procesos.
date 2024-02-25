#!/bin/bash
# ● Función para conseguir os procesos do usuario que lanza o script
function filtrarPorUsuario () {
    usuario_actual=$(id -nu)
    eleccionPID=$( zenity --list  \
                --text="Elije el PID" \
                --column="PID" \
                --print-column=1 \
                $(ps aux | egrep "^$usuario_actual" | awk '{print $2}')
                )
    # ● O if fai que no caso en que o usuario dea a cancelar saia do script
    if [ $? -eq 1 ] ;
    then
        exit 1
    fi
}
# ● Función para conseguir os procesos con saída polo terminal
function filtrarPorTerminal(){
    eleccionPID=$( zenity --list  \
                --text="Elije el PID" \
                --column="PID" \
                --print-column=1 \
                $(ps aux | egrep "*pts/*" | awk '{print $2}')
                )
    # ● O if fai que no caso en que o usuario dea a cancelar saia do script
    if [ $? -eq 1 ] ;
    then
        exit 1
    fi
}
# ● Función para escoller a opción a exercer sobre o proceso escollido
function opcionProcesos(){
    eleccionopcion=$( zenity --list \
    --text="Elija la opción a ejercer sobre el proceso" \
    --column="valor" --column="Descripcion" \
    --hide-column=1 --print-column=1 \
    1 " Matar" \
    2 " Parar" \
    3 " Permitir que continúe" )
    # ● O if fai que no caso en que o usuario dea a cancelar saia do script
    if [ $? -eq 1 ] ;
    then
        exit 1
    fi
    # ● Un if para que segunda a elección escollida realicese o que se pida
    if [ $eleccionopcion -eq 1 ] ;
    then
        # ● Un ventana que pregunta se se está seguro de actuar sobre o proceso
        eleccionactuacion=$( zenity --question \
        --text="Va a Actuar sobre el proceso, está seguro?" 
        )
        # ● Se o usuario clica en si entón se abre outra ventana
        if [ $? -eq 0 ] ;
        then
            # ● Se abrea a ventana que pide o contrasinal 
            eleccioncontrasenha=$( zenity --password )
                # ● Establecemenos o contrasinal que se debe poñer para que se faga a acción
                contrasenha="abc123."
                # ● Se a contraseña que o usuario pasou corresponde coa establecida entón se mata o proceso
                if [ $eleccioncontrasenha == $contrasenha ] ;
                then
                    kill -9 $eleccionPID
                # ● Se a contraseña non é igual entón acaba o script
                else
                    exit 1
                fi
        # ● E se o usuario clica en non pois entón sae e acaba o script 
        else
            exit 1
        fi
    elif [ $eleccionopcion -eq 2 ] ;
    then
        # ● Un ventana que pregunta se se está seguro de actuar sobre o proceso
        eleccionactuacion=$( zenity --question \
        --text="Va a Actuar sobre el proceso, está seguro?" 
        )
        # ● Se o usuario clica en si entón se abre outra ventana
        if [ $? -eq 0 ] ;
        then
            # ● Se abrea a ventana que pide o contrasinal 
            eleccioncontrasenha=$( zenity --password )
                # ● Establecemenos o contrasinal que se debe poñer para que se faga a acción
                contrasenha="abc123."
                # ● Se a contraseña que o usuario pasou corresponde coa establecida entón se mata o proceso
                if [ $eleccioncontrasenha == $contrasenha ] ;
                then
                    kill -19 $eleccionPID
                # ● Se a contraseña non é igual entón acaba o script
                else
                    exit 1
                fi
        else
            exit 1
        fi
    else
        # ● Un ventana que pregunta se se está seguro de actuar sobre o proceso
        eleccionactuacion=$( zenity --question \
        --text="Va a Actuar sobre el proceso, está seguro?" 
        )
        # ● Se o usuario clica en si entón se abre outra ventana
        if [ $? -eq 0 ] ;
        then
            # ● Se abrea a ventana que pide o contrasinal 
            eleccioncontrasenha=$( zenity --password )
                # ● Establecemenos o contrasinal que se debe poñer para que se faga a acción
                contrasenha="abc123."
                # ● Se a contraseña que o usuario pasou corresponde coa establecida entón se mata o proceso
                if [ $eleccioncontrasenha == $contrasenha] ;
                then
                    kill -18 $eleccionPID
                else
                    exit 1
                fi 
        # ● E se o usuario clica en non pois entón sae e acaba o script     
        else
            exit 1
        fi
    fi
    
}
# ● Ventana principal onde se lle pide ao usuario que escolla entre filtrar por usuario, por salida a terminal
#   ou por outros procesos
eleccion=$( zenity --list \
    --text="Elija el filtraje de procesos" \
    --column="valor" --column="Descripcion" \
    --hide-column=1 --print-column=1 \
    1 " Por usuario actual" \
    2 " Procesos con salida en terminal" \
    3 " Procesos con... " )
    case $eleccion in
        1)
            # ● Se o usuario escolle filtrar por usuario actual entón chamamos ás funcións por usuario
            #   e a de escoller a opción a facer no proceso que se escolle
            filtrarPorUsuario
            opcionProcesos
        ;;
        2)
            # ● Se o usuario escolle filtrar por terminal entón chamamos ás función de filtrar por terminal
            #   e a de escoller a opción a facer no proceso que se escolle
            filtrarPorTerminal
            opcionProcesos
        ;;
        3)
            exit 1
        ;;
    esac