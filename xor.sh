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
    done
}

# ========== +++++++ DESCRIPTOGRAFAR +++++ ====================
Decipher_Text(){

    Text_Cipher_xor=$1
    key_decipher=$2
    
    length_Bytes=$(( ${#Text_Cipher_xor} / 2 )) #  pra saber quantos bytes temos nessa palavra 

    for ((i = 0 ; i < ${length_Bytes}; i++ )) do 

        Position_Byte=$(($i * 2)) # de 2 em 2 pega sempre o pulando de 2 em 2 bytes
        Letter_slice="${Text_Cipher_xor:$Position_Byte:2}"

        # mudar de Hex para Decimal 
        printf -v ascii_d "%d" "0x${Letter_slice}" # pega a parte extraida do Hex e junta com 0x pra formar a instrução hexdacimal correta 

        position_key_rotation=$(( $i % ${#key_decipher} )) # rotacao da chave 

        # Mudar chave pra decimal
        printf -v ascii_k "%d" "'${key_decipher:$position_key_rotation:1}"

        # aplicar xor reverso 
        Xor_Decipher=$(( ascii_d ^ ascii_k ))

        Descript_xor=$(printf "\\$(printf '%03o' $Xor_Decipher)")

        result_Xor_Decipher+="$Descript_xor"

    done
}


if [ -z "${#@}" ]; then
    echo -e "\n[+] - Error Voce Não passou argumentos\n"
    echo -e "[+] - Modo de Uso : $0 -M [sua-mensagem-aqui] -K [sua-key-aqui] \n"
    exit 1
fi 

Cipher_text $Messager $Key
echo 
echo "[+] ======== cifrada cifrada =============="
echo "[-] - Messager Pura  : $Messager"
echo "[-] - key-For-Xor    : $Key"
echo -e "[-] - Palavra Cifrada : $result_xor\n"

Decipher_Text $result_xor $Key

echo "[+] ======= palavra Descifrada ============"
echo "[-] - palavra Cipher   : $result_xor"
echo "[-] - key-For-Xor : $Key"
echo "[-] - palavra Decipher  : $result_Xor_Decipher"
echo 
