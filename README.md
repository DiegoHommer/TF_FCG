# TF_FCG
Diego Hommerding Amorim     - 00341793<br/>
Thomas Schneider Wiederkehr - 00342606

## Contribuições de cada membro:
### Diego:
- Câmera livre e look-at
- Modelos de Iluminação Difusa e Blinn-Phong
- Modelos de Interpolação de Phong e Gouraud
- Mapeamento de texturas em todos os objetos
- Importação e busca por objetos/modelos adequados para o projeto
- Organização e criação do template inicial do projeto (unindo código de labs)
- Instanciação de objetos e movimentação baseada no tempo (da câmera)

### Thomas:
- Movimentação com curva Bézier de grau 4
- Três tipos de testes de intersecção (colisões ponto-plano, cubo-plano e cubo-cubo)
- Level Design e criação da lógica de implementação de fases
- Implementação dos movimentos especiais do personagem (dash e pulo)
- Rotação do modelo do personagem seguindo a direção da câmera
- Modularização do código
- Instanciação de objetos e movimentação baseada no tempo (do personagem e dos objetos)

## Uso de ChatGPT
  O ChatGPT foi utilizado durante a realização desse trabalho principalmente para realizar refatorações e apresentar alternativas mais legíveis de código, além de gerar algumas funções auxiliares. Foi útil para refatorações e funções simples e pouco útil para implementar conceitos mais específicos do conteúdo (principalmente quando os mesmos envolviam OpenGL). O modelo apresentou dificuldades de lidar com essas implementações mais especializadas.

## Desenvolvimento e aplicação de conceitos
  Os conceitos de Computação Gráfica foram aplicados ao longo de todo o projeto uma vez que o trabalho foi desenvolvido utilizando os laboratórios da cadeira como base. Num primeiro momento, combinamos todos os laboratórios em um só código para obter um 'protótipo' que satisfazia os requisitos mais básicos (matrizes, interação em tempo real, transformações geométricas, texturas, etc). A partir deste prototipo, dividimos o restante dos requisitos entre os dois participantes da dupla e construimos o restante da aplicação:
 
 - **Câmeras**: implementamos a camera livre como uma câmera em primeira pessoa (se movimenta de acordo com o personagem não sendo totalmente "livre") e a câmera look-at como uma terceira pessoa com o modelo do personagem no centro.
   
 - **Instâncias**: para criar as fases reutilizamos os objetos do laboratório 5 (plano, vaca e coelho) e trouxemos um .obj de cubo (que foi remodelado de diversas formas) assim como objetos para o personagem e o morango voador. Os objetos novos tiveram suas texturas extraída por meio do software *blender* de modelagem 3D.
   
 - **Colisões**: todas as entidades que colidem possuem um objeto da classe **Box**, que serve como uma *bounding box* para os testes. Estas *boxes* são cubos alinhados aos eixos, ou seja, não sofrem rotação apenas translação. Os testes de colisão recebem a Box do personagem e a direção que pretende se mover, verificando se a posição do personagem após esse movimento é valida ou não. Definimos 3 tipos diferentes de colisões:
   - Ponto-plano: esta colisão foi implementada baseado na formula de intersecção de segmento com plano apresentada na aula, com restrições de altura y, largura x e profundidade z para limitar o plano. Esta função é chamada durante a colisão cubo-plano onde, para cada par de pontos do cubo, é checado se ocorre uma colisão com o plano em questão.
   - Cubo-plano: recebe a direção em que o cubo do personagem pretende se mover e devolve a direção em que ele de fato poderá de deslocar, realizando o teste de colisão para o vetor de direção projetado em cada eixo (direção x, direção y e direção z isoladamente).
   - Cubo-cubo: esta colisão foi implementada de outra forma. Basicamente, verifica-se se um ponto de um cubo se encontra entre 2 pontos de outro cubo em um dos eixos (z, por exemplo). Ao encontrar este ponto, marca-se z como encontrado e realiza-se o mesmo processo com os outros eixos x e y. Se forem encontrados 3 pontos, de qualquer um dos 2 cubos, que contemplam a regra para os 3 eixos, e que podem ser iguais, ocorre a colisão e o movimento é impedido naquela direção. Esta função também verifica a direção de cada eixo separadamente.

  - **Iluminação**:
    - Modelo de Iluminação de Lambert:
      Implementado com a fórmula utilizada no laboratório 4 vista em aula. Aplicado para computar a iluminação dos modelos da Madeline (madeline.obj), do cubo (cube.obj) e do morango (winged_strawberry.obj).
      ![image](https://github.com/user-attachments/assets/c0e51db3-204f-4095-a232-d8c65e48e213)
    - Modelo de Iluminação de Blinn-Phong:
      Implementado com a fórmula utilizada no laboratório 4 vista em aula (como implementamos o Phong no Lab, apenas foi necessário atualizar o termo especular para utilizar os vetores 𝑛 (normal) e ℎ (half-vector)). Aplicado para computar a iluminação dos modelos do coelho (bunny.obj) e do plano (plane.obj).
      ![image](https://github.com/user-attachments/assets/8240c9d9-4a5f-4664-ba84-04eda737a2b6)


    - Modelo de Interpolação de Gouraud:
      Implementado calculando os atributos de cor e o mapeamento de textura no shader_vertex (ou seja, para cada vértice) e repassando esse valor (denominado gouraud_color) para o shader_fragment como input para ser definido como o valor de color.rgb. Foi utilizado na iluminação do modelo da vaca (cow.obj). 
    - Modelo de Interpolação de Phong
      Implementado calculando os atributos de cor e o mapeamento de textura diretamente no shader_fragment. Ocorre quando o valor de gouraud_color vindo do shader_vertex é igual a (0.0,0.0,0.0). Utilizado em todos os demais modelos (madeline.obj, bunny.obj,...).
    
    
  - **Bézier**: Foi implementada uma curva de bézier de grau 4 (5 pontos) que procura simular uma curva circular para o morango, isto é, o primeiro e o quinto ponto são o mesmo. Além da curva, o valor de y do objeto do morango é somado a cada interação para que ele suba.

  As funcionalidades do jogo que não estavam listadas na especificação do trabalho tiveram que ser projetadas e implementadas de forma propria. Um exemplo disto foi o mapeamento das fases, onde criamos uma forma "automatizada" de desenhar os objetos na tela com base em listas de Boxes. Também implementamos os movimento de pulo, que basicamente inverte a gravidade do personagem e então decresce a mesma gradativamente, e o *dash*, onde o personagem se move rapidamente em uma direção travada. 
  
## Imagens
![image](https://github.com/user-attachments/assets/bddbd83c-10f5-4941-aec1-0a57e6092136)
Coelho iluminado com Blinn-Phong

![image](https://github.com/user-attachments/assets/037f8af6-e994-40d9-93b1-c4ae791c533a)
Level 1 (terceira pessoa)

![image](https://github.com/user-attachments/assets/6e116352-bb7a-435b-8075-064efc6cc30d)
Level 2

## Manual
### Objetivos:
- Alcançar modelo do Coelho (1º Fase) ou Vaca (2º Fase) para concluir a fase
- Tentar coletar o maior número de morangos possível (opcional)
- PS: Morangos fogem em espiral para cima quando player realiza seu primeiro Dash
### Mapeamento de teclas:
- MOUSE == Move a direção da câmera
- W, A, S, D == Move o personagem nas 4 direções
- SPACEBAR == Pulo do player character
- C == Dash do player character (boost de velocidade na direção para onde o jogador está caminhando)
- L == Troca entre câmera look-at (third-person) e livre (first-person)
- P == Troca para projeção perspectiva
- O == Troca para projeção ortogonal

## Como Rodar

O zip possui um arquivo main.exe na pasta /bin/Debug, bastando abrir este arquivo para rodar o jogo. 

![image](https://github.com/user-attachments/assets/95b25c7a-d7ce-4b8f-9e29-63b0e8daa296)

Se quiser compilar o jogo em seu pc, é necessário copiar os arquivos presentes neste repositório para uma cópia do Laboratório 5 (substituindo os arquivos) e então compilar o código com alguma IDE.
