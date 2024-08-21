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
   
 - **Colisões**: definimos 3 tipos diferentes de colisões: *ponto-plano*, *cubo-plano* e *cubo-cubo*. Todas as entidades que colidem possuem um objeto da classe **Box**, que serve como uma *bounding box* para os testes. Estas *boxes* são cubos alinhados aos eixos, ou seja, não sofrem rotação apenas translação. A colisão ponto-plano foi implementada baseado na formula de intersecção de segmento-plano apresentada na aula, com restrições de altura y, largura x e profundidade z para limitar o plano. Esta colisão é chamada durante a colisão cubo-plano, onde, para cada par de pontos do cubo, é checado se ocorre uma colisão 
  
## Imagens
![image](https://github.com/user-attachments/assets/bddbd83c-10f5-4941-aec1-0a57e6092136)
![image](https://github.com/user-attachments/assets/037f8af6-e994-40d9-93b1-c4ae791c533a)
![image](https://github.com/user-attachments/assets/6e116352-bb7a-435b-8075-064efc6cc30d)




## Manual
### Objetivos:
- Alcançar modelo do Coelho (1º Fase) ou Vaca (2º Fase) para concluir a fase
- Tentar coletar o maior número de morangos possível (opcional)
- PS: Morangos fogem em espiral para cima quando player realiza seu primeiro Dash
### Mapeamento de teclas:
- SPACEBAR == Pulo do player character
- C == Dash do player character (boost de velocidade na direção para onde o jogador está caminhando)
- L == Troca entre câmera look-at (third-person) e livre (first-person)
- P == Troca para projeção perspectiva
- O == Troca para projeção ortogonal
