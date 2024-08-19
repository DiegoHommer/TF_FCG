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

## Imagens
![image](https://github.com/user-attachments/assets/a4949d8a-8f88-4a83-ba6d-92eb1678a427)
![image](https://github.com/user-attachments/assets/037f8af6-e994-40d9-93b1-c4ae791c533a)



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
