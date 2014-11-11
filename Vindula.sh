#!/bin/bash
#IntranetVindula
#
#  Nesse Shell Script, Ã© executado o processo de instalaÃ§Ã£o e/ou execuÃ§Ã£o
# da Intranet Vindula.
#---------------------------------------------------------------------------
# VersÃ£o 1.04 - 21/04/2014
#             - AdiÃ§Ã£o de opÃ§Ã£o a base de dados Vindula
#---------------------------------------------------------------------------
# VersÃ£o 1.03 - 07/03/2014
#             - AlteraÃ§Ã£o caminho para executar o script IntranetVindula
#             - AtribuiÃ§Ã£o de variavel para "leitura/download"
#             - AdiÃ§ao de expressÃ£o regular para dinamismo sobre o nome do arquivo baixado
#             - AtribuiÃ§Ã£o de variavel para o nome o arquivo
#             - Adicionado as opÃ§Ãµes:
#             --------- Ajuda
#---------------------------------------------------------------------------
# VersÃ£o 1.02 - 28/02/2014
#             - HomolagaÃ§Ã£o
#---------------------------------------------------------------------------
# VersÃ£o 1.02b - 27/02/2014
#             - AdiÃ§ao de expressÃ£o regular para dinamismo da autalizaÃ§ao de versÃ£o
#             - AdiÃ§Ã£o de opÃ§Ãµes
#             - VerificaÃ§Ã£o de pacotes instalados
#             - CorreÃ§Ã£o ortografica
#---------------------------------------------------------------------------
# VersÃ£o 1.01a - 26/02/2014
#             - AdiÃ§Ã£o de Layout
#             - AdiÃ§Ã£o de FunÃ§Ãµes de controle
#---------------------------------------------------------------------------
# VersÃ£o 1.00a - 25/02/2014
#             - A versÃ£o so Instalador estÃ¡ desatualizado!
#---------------------------------------------------------------------------

versaoAtual=1.09

cursorVI(){ sleep 0.25; echo -n "   -"; sleep 0.25; echo -n "> "; }

#Nessa variavel não colocado o endereço eletronico arquivo IntranetVindula.sh
varHTTP=(http://vindula.s3-sa-east-1.amazonaws.com/vindula-2.0.3/instalador/IntranetVindula.sh)

nomeArquivoB=$( echo "$varHTTP" \
                | sed 's:/:\n|:g' \
                | sed -n '/|/{h;${x;p;};d;};H;${x;p;}'\
                | sed 's:|:.:g' )


installN=$(dpkg -l | grep curl | wc -l)

if [[ $installN -eq 0 ]]; then

    apt-get -y install curl

fi


mensaAlert(){

local y=""
local x=""

while [[ y -lt 6 ]]; do

    if [[ x -gt 1 ]]; then
        x=0
        coAle="40;"
    else
        coAle="$corInfo"
    fi

echo -ne "  \e[${coAle}37;1m       $mensaInfo       \e[m\r"

sleep 0.25;

((x++))

((y++))

done

}

estiPrinci(){

    txtT="Intranet Vindula."
    coRa=42
    coRaB=43

}

layouT(){

clear
    echo -e "\n  \e[40m                              \e[m"
    echo -e "  \e[40m \e[m\e[${coRa}m \e[m\e[40m \e[m\e[${coRaB}${txtSt}m \
${txtT} \e[m\e[40m \e[m\e[${coRaB}m  \e[m\e[40m \e[m\e[${coRaB}m \e[m\e[40m \
\e[m\e[${coRaB}m \e[m\e[40m \e[m"
    echo -e "  \e[40m                              \e[m"

}

vertificaDor(){

    estiPrinci
    vercionaDor
    layouT

    echo -e "\n  \e[42;37;1m $validador \a\e[m Ãšltimo release"

    if [[ $versaoAtual = $validador ]]; then

        echo -e "\n  Seu instalador estÃ¡ atualizado\n"

        sleep 3

    else

        echo -e "  \e[41;37;1m $versaoAtual \e[m VersÃ£o atual\n"

            if [[ -n $vVersao ]];then

                echo -e "   Deseja atualizar a versÃ£o \
                    \n        do Instalador?\n"
                echo -e "     (\e[1ms\e[m) Sim    (\e[1mn\e[m)  NÃ£o\n"

                cursorVI

                read opcEsco;

                    case "$opcEsco" in

                        s | S )

                            atualizaDor
                        ;;

                        n | N )

                            clear
                            exit 0
                        ;;

                        * )
                            local corInfo="41;"
                            local mensaInfo="OPÃ‡ÃƒO INVALIDA"
                            mensaAlert

                            sleep 2
                            vertificaDor
                        ;;

                    esac
            fi
    fi

if [[ -z $vVersao ]]; then

echo -e "\n      Aguarde por favor...\n"

sleep 2

cd /opt

./$nomeArquivoB

fi

}

vercionaDor(){

    local versLert=$(curl -s $varHTTP)

    local versConf=$( echo -e "$versLert" \
        | sed -r '/^# Vers/!g' \
        | sed '/^$/d' \
        | sed -n '/\#/{p;q;}' \
        | sed 's/-.*$//'\
        | sed 's/\#.*o /versaoAtual=/' )

        validador=$(echo $versConf \
            | sed 's/versaoAtual=//' )

        # casting da variavel versConf
        versConfC=$(echo $versConf)


}

atualizaDor(){

    vercionaDor

    if [[ -f /opt/"$nomeArquivoB" ]]; then

        rm /opt/"$nomeArquivoB"

            sleep 3

    fi

    wget -c -q "$varHTTP" -O /opt/$nomeArquivoB && chmod +x /opt/$nomeArquivoB

    local linhaVersoa=$(cat $(basename "$0") \
        | sed -n '/^versaoAtual/{=;d;}')

    echo "$(sed ''$linhaVersoa's/.*/'$versConfC'/' < $(basename "$0"))" > $(basename "$0")


    if [[ -n $vVersao ]]; then

        local corInfo="42;"
        local mensaInfo="ATUALIZAÃ‡ÃƒO COMPLETA"
        mensaAlert
        sleep 2

        clear

        exit 0

    fi

./$(basename "$0")

exit 0

}

MENSAGEM_USO="
Uso: $(basename "$0") ['OPCOES']

OPCOES:

  -a, --ajuda           - Mostra a ajuda e sai.
  -V, --versao          - Mostra a versÃ£o do Vindula, habilita atualizaÃ§Ãµes e sai.
      --reinstalar      - Reinstalar a Intranet.
      --database        - Reinstala a Base de Dados da Intranet.
      --status          - Mostra o Statu da execuÃ§Ã£o da intranet.

"
 clear
        case "$1" in

           -a | --ajuda )

                echo -e " $MENSAGEM_USO"
                exit 0

                ;;
           -V | --versao )

                vVersao=" "

                vertificaDor
                ;;

               --reinstalar )
                cd /
                /opt/"$nomeArquivoB" --instalar
                ;;

               --status )

                cd /
                /opt/"$nomeArquivoB" --statos
                exit 0
                ;;

                --database )
                cd /
                /opt/"$nomeArquivoB" --dados
                exit 0
                ;;

            *)
                if test -n "$1"; then
                    echo -e "\n A opÃ§Ã£o [ $1 ] Ã© invÃ¡lida. \n"
                 exit 0
                fi
                ;;
        esac

 if [[ -f /opt/"$nomeArquivoB" ]]; then

    vertificaDor

else

    atualizaDor

fi