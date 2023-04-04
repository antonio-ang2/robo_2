# robo_2
trabalho de eletrônica da semana 9 

Trabalho da aula de programação focado em fazer uma simulação feita no GODOT do braço robótico que move-se com base na alteração dos valores do eixo contidos 
em uma banco de dados construído com o ORM SQLAlchemy, além disso, a alimentação do banco é feita por meio de um frontend, conectado ao primeiro por meio do framework
Flask.

tecnlogias utilizadas: 
Banco de dados - Criado usando o ORM SQLAlchemy 
Frontend - Criado usando HTML puro apenas para movimentar a simulação do braço robótico
Integração - A integração entre backend e frontend da aplicação foi feita em Flask, que trata-se de um framework de Python para permitir inteção entre usuário e dados.
Simulação - A simualação do braço robótico foi feita utilizando a plataforma GODOT, que uitliza a liguagem orientada a objetos GD script. Além disso, essa simulação 
foi feita em 3D, utilizando uma simulação pronta de movimentação robótica contida nas referências.

funcionamento do sistema: O sistema funciona de forma simples, porém deve-se seguir alguns passos para seu funcionamento da forma correta.
1 - Abra a pasta antonioangelo no visual studio que contém todos os arquivos e execute arquivo main.py com o código python main.py
    Esse comando fará com que o servidor local em Flask comece a rodar, de forma que o banco de dados possa ser alimentado.
2 - Execute o index.html contido na pasta templates
    Essa execução fará com que a página principal da aplicação abra, com campos em branco para preenchimento dos valores desejados para os eixos.
3 - Rode o programa GODOT e importe o arquivo project.godot, bastando executar a aplicação.
    Essa execução vai abrir a simulação 3D, pronta para receber valores.
4 - Preencha os campos do index e envie os dados.
    Essa ação manda uma requesição de método POST para o banco de dados, criando um novo registro no banco.
5 - Por fim, basta pressionar o botão play e curtir a movimentação.   


referências:
Simulação: adaptação do código de braço robótico 3D desenvolvido em Godot por @bborncr (https://github.com/bborncr/RobotArmTest)
