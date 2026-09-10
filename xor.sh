#!/bin/bash 

# Author : F4lc0n_x64 
# Messager : Exemple simples de criptografia com Xor 
# Date: 2026-09-08



#======== +++++++++ DESCRIPTOGRAFIA XOR ++++++++ ==============

# A sua cifra em Hexadecimal (cada par de letras/números é 1 byte)
Messager=$2
Key=$4
result_xor=""
result_Xor_Decipher=""

Cipher_text(){
    Messager_text=$1
    Key_cipher=$2
    echo -e "\n========== Iniciando Conversao de Message e Key pra Decimal ======== \n"

    progress_1=""
    M_progress=""

    progress_2=""
    K_progress=""

    c_progress=""


    for ((i = 0 ; i < ${#Messager_text}; i++ )); do
        # converter caracter para decimal 
        printf -v ascii_d "%d" "'${Messager_text:$i:1}" # fatias da string

        # converte a key para decimal para aplicar o XOR operator 
        Position=$(( $i %  ${#Key_cipher} )) # rotação da chave (modulo do I pelo Tamanho da key)
        printf -v ascii_k "%d" "'${Key_cipher:Position:1}"

        # aplica o xor na palavra 
        Xor_cipher=$(( ascii_d ^ ascii_k )) # aplica o xor de caracter pra caracter 

        printf -v d_for_hex "%02x" "$Xor_cipher"
        result_xor+="$d_for_hex"  

        if [ $i -eq 0 ]; then
            #pula 4 linhas pra baixo 
            echo -e "\n\n\n\n"
            progress_1="$ascii_d"
            M_progress="${Messager_text:$i:1}"
            progress_2="$ascii_k"
            K_progress="${Key_cipher:Position:1}"
            c_progress="$d_for_hex"

        else 
            c_progress+=", $d_for_hex"
            progress_1+=", $ascii_d"
            M_progress+=", ${Messager_text:$i:1}"
            progress_2+=", $ascii_k"
            K_progress+=", ${Key_cipher:Position:1}"

        fi 
        # pula 5 linhas pra cima 
        echo -ne "\033[A\033[A\033[A\033[A\033[A"
    
        # Imprime as duas linhas atualizadas
        echo -e "[+] - MESSAGER PARA DECIMAL       : \e[31m[$M_progress]\e[0m -> \e[31m[$progress_1]\e[0m\033[K"
        echo -e "[+] - KEY PARA DECIMAL            : \e[33m[$K_progress]\e[0m -> \e[33m[$progress_2]\e[0m\033[K"
        echo -e "[+] - APLICANDO XOR [ MESS ]      : \e[34m[$(printf "\\$(printf '%03o' "$ascii_d")" | xxd -b | awk '{print $2}')] - bit de [$(printf "\\$(printf '%03o' "$ascii_d")")]\e[0m\033[K"
        echo -e "[+] - APLICANDO XOR [ KEY ]       : \e[34m[$(printf "\\$(printf '%03o' "$ascii_k")" | xxd -b | awk '{print $2}')] - bit de [$(printf "\\$(printf '%03o' "$ascii_k")")]\e[0m\033[K"
        echo -e "[+] - MESSAGER CIPHER             : \e[33m[$(printf "\\$(printf '%03o' "$Xor_cipher")" | xxd -b | awk '{print $2}')]\e[0m -> \e[33m[$c_progress]\e[0m\033[K"

        sleep 1 

    done
}

# ========== +++++++ DESCRIPTOGRAFAR +++++ ====================
Decipher_Text(){
    echo -e "\n========== Iniciando Conversao de Cipher e Key pra Decimal ======== \n"
    Text_Cipher_xor=$1
    key_decipher=$2
    
    length_Bytes=$(( ${#Text_Cipher_xor} / 2 )) #  pra saber quantos bytes temos nessa palavra 
    
    progress_1=""
    M_progress=""

    progress_2=""
    K_progress=""

    c_progress=""

    for ((i = 0 ; i < ${length_Bytes}; i++ )) do 

        Position_Byte=$(($i * 2)) # de 2 em 2 pega sempre o pulando de 2 em 2 bytes
        Letter_slice="${Text_Cipher_xor:$Position_Byte:2}"

        # mudar de Hex para Decimal 
        printf -v ascii_d "%d" "0x${Letter_slice}" # pega a parte extraida do Hex e junta com 0x pra formar a instrução hexdacimal correta 

        position_key_rotation=$(( $i % ${#key_decipher} )) # rotacao da chave 

        # Mudar chave pra decimal
        printf -v ascii_k "%d" "'${key_decipher:$position_key_rotation:1}"

        # aplicar xor reverso | reverso - decimal do carcater correto ! 
        Xor_Decipher=$(( ascii_d ^ ascii_k ))

        Descript_xor=$(printf "\\$(printf '%03o' $Xor_Decipher)") # CARACTER

        result_Xor_Decipher+="$Descript_xor"

        if [ "$i" -eq 0 ]; then 
            # pula + 4 linhas 
            echo -e "\n\n\n\n\n"
            progress_1="$ascii_d" # decimal 
            M_progress="0x$Letter_slice" # caracter puro 

            progress_2="$ascii_k" # decimal 
            K_progress="${key_decipher:$position_key_rotation:1}" # caracter puro 
            c_progress="$Xor_Decipher" # decimal do xor aplicado 

        else 
            progress_1+=", $ascii_d" # decimal 
            M_progress+=", \0x$Letter_slice" # caracter puro 

            progress_2+=", $ascii_k" # decimal 
            K_progress+=", ${key_decipher:$position_key_rotation:1}" # caracter puro 
            c_progress+=", $Xor_Decipher" # decimal do xor aplicado 
        fi 

        echo -ne "\033[A\033[A\033[A\033[A\033[A"

        # Imprime as duas linhas atualizadas
        echo -e "[+] - MESSAGER-CIPHER PARA DECIMAL  : \e[31m[$M_progress]\e[0m -> \e[31m[$progress_1]\e[0m\033[K"
        echo -e "[+] - KEY PARA DECIMAL              : \e[33m[$K_progress]\e[0m -> \e[33m[$progress_2]\e[0m\033[K"
        echo -e "[+] - APLICANDO XOR [ CIPHER ]      : \e[34m[$(printf "\\$(printf '%03o' "$ascii_d")" | xxd -b | awk '{print $2}')] - bit de [$(printf "\\$(printf '%03o' "$ascii_d")")]\e[0m\033[K"
        echo -e "[+] - APLICANDO XOR [ KEY ]         : \e[34m[$(printf "\\$(printf '%03o' "$ascii_k")" | xxd -b | awk '{print $2}')] - bit de [$(printf "\\$(printf '%03o' "$ascii_k")")]\e[0m\033[K"
        echo -e "[+] - MESSAGER DECIPHER             : \e[33m[$(printf "\\$(printf '%03o' "$Xor_Decipher")" | xxd -b | awk '{print $2}')]\e[0m -> \e[33m[$c_progress]\e[0m\033[K"

        sleep 1 


    done
}


if [ "$#" -eq 0 ]; then
    echo -e "\n[+] - Error Voce Não passou argumentos\n"
    echo -e "[+] - Modo de Uso : $0 -M [sua-mensagem-aqui] -K [sua-key-aqui] \n"
    exit 1
fi 


Cipher_text $Messager $Key
sleep 1
Decipher_Text $result_xor $Key

echo 
echo -e "[+] \e[31m======== cifrada cifrada ==============\e[0m"
echo -e "[-] - Messager Pura  : \e[32m$Messager\e[0m"
echo -e "[-] - key-For-Xor    : \e[33m$Key\e[0m"
echo -e "[-] - Palavra Cifrada : \e[31m$result_xor\e[0m"
echo 

sleep 1


echo -e "[+] \e[32m======= palavra Descifrada ============\e[0m"
echo -e "[-] - palavra Cipher   : \e[31m$result_xor\e[0m"
echo -e "[-] - key-For-Xor : \e[33m$Key\e[0m"
echo -e "[-] - palavra Decipher  : \e[32m$result_Xor_Decipher\e[0m"
echo 
