# Desafio POPE

O nome do time POPE quer dizer P de performance e Ope de Operação. Então essas
são as principais atividades do time.

Cansado de desenvolver features? Este é o time certo para você!

Adora um P&D, ao invés de ficar só desenvolvendo?
Gosta de desafios, problemas complexos e cabulosos? Este é o time certo para você!

## Performance issues

    Não deixamos o barco andar pra trás

Então, um dos nossos principais desafios é que temos que suportar e escalar a infra do RDStation pra sempre suportar mais e mais clientes.

Imagina um cadastro de alguma coisa bem simples.  Que funcionou bem no primeiro dia e vai bem até alguns meses.

Mas de repente começa a ser altamente utilizado pelos clientes. 

Então se faz necessário:

- [ ] criar uma paginação para os registros.
- [ ] adicionar índices das colunas mais utilizadas
- [ ] analisar o código e encontrar tweaks para melhorar o processamento
- [ ] criar caches em locais específicos para evitar reprocessamento

Então, esses são passos evolutivos de performance que realizamos no dia a dia.

Encontramos gargalos e ficamos engrachando a máquina para rodar o mais liso e rápido possível.

## Operação

    Não deixamos o barco afundar

Temos a responsabilidade de manter o RDStation no ar. Dessa maneira, sempre que
alguma coisa trava ou cai fora e que não trata-se de um simples bug de um
usuário. Cai pro nosso time resolver.

Temos várias ferramentas e dashboards de acompanhamento da infra. Passamos
horas e horas analisando e criando novos dashboards e métricas para observar
os gargalos e garantir que o sistema está andando bem.


## Suporte

    Quando não houver mais times especializados cai pra gente
     -> questões de suporte e operação

O suporte técnico é verticalizado e atualemente temos poucos tickets. Quando
algum cliente está encarando alguma lentidão ou não consegue realizar uma
tarefa pois o processo não termina, entramos em ação.

## COGS

Outra grande responsabilidade do nosso time é o que diz a respeito dos **custos
operacionais**.

Somos responsáveis pela previsibilidade do crescimento e também custos
envolvidos. Precisamos sempre estar atentos a migrações e capacidade de cada
serviço ou infra dos servidores.

## O que esperamos de um POPER?

 A maioria das atividades do nosso time é cross-team pois envolve entender os componentes já existentes,
 e saber depurar os problemas, possívelmente implementando / apresentando novas soluções para o
 time que está com a funcionalidade afetada.

- **Visão de infraestrutura**: arquitetura, componentes, mensageria entre micro-serviços
- Posição **pró-ativa na operação**: acompanhar e encontrar a raíz dos problemas
- Posição **pró-ativa na performance** do RDStation

### Conhecimentos desejados

- poliglota (sem medo de linguagens) - manjar de Ruby e GO é :+1:
- ferramentas: Redis, MongoDB, Postgresql, ElasticSearch, Background jobs (Sidekiq, Resque)
- infrastructure/platforms: heroku, circleci, amazon, NewRelic


# Ok! vamos ao desafio :dancers:


A ideia do desafio é expor um pouco do que encaramos no dia a dia. Melhorar a
performance de um código já existente.  Encontrar detalhes que estão lentos e otimizar.

Este repositório contém o projeto que queremos que você analise e melhore.

O projeto foi escrito em poucas horas mas simula a funcionalidade básica que
temos no RDStation de importação de leads.

Então imagina que na nossa base de leads estamos com mais de 40 milhões de leads.
Temos clientes que importam planilhas com seus leads diariamente. Tanto para
atualizar dados em massa quanto para fazer um setup inicial de sua base.

Assim, temos uma funcionalidade frenéticamente usada e com volumes grandes.

Imagina que o nosso cliente sobe uma planilha com 300 mil linhas para atualizar
ou inserir cerca de 300k de leads. Então temos que buscar os leads na base para
atualizar as informações ou inserir um lead novo com os dados e detalhes.

A aplição não tem frontend e a ideia é apenas melhorar o processo de importação
deixando-o cada vez mais rápido.

Use `bundle exec rake test` para rodar a bateria de testes ou `bundle exec guard` para
rodar os testes continuamente assistindo suas alterações.

Crie seu fork privado e envie seu pull request com a descrição e um benchmark
mostrando o antes e o depois das melhorias.

## Workflow basico

Inicie criando o banco e executando as migrações básicas

    rake db:{create,setup,migrate}


Tem algumas tarefas utilitárias para facilitar o benchmark em [./lib/tasks/gen.rake]() 
que podem ser bem úteis para fazer os benchmarks.

```
rake gen:leads[size]   # rake gen:leads[100] to create 100 random leads
rake gen:csv[size]     # rake gen:csv[1000] to create 1000 random leads in a csv
```

A tarefa `rake gen:leads` serve para subir uns leads de exemplo. Depois você
pode usar `rake gen:csv` para baixar uns leads para um csv com os dados dos leads
e re-utilizar no upload.

Então para gerar 10 mil leads use:

```
➜  pope-challenge git:(master) ✗ rake gen:leads[10000]
creating 10000 leads: 100.0% (elapsed: 3.2m)
```


Agora confira que os leads existem:

```
➜  pope-challenge git:(master) ✗ rails c
Running via Spring preloader in process 23366
Loading development environment (Rails 4.2.3)
Lirb(main):001:0> Lead.count
   (2.5ms)  SELECT COUNT(*) FROM "leads"
   => 10000
```


Agora é hora de gerar um csv para testar e realmente poder realizar a primeira
importação:

```
➜  pope-challenge git:(master) ✗ rake gen:csv[10000]
 exporting 10000 leads: 100.0% (elapsed: 20s)
```

Isso vai gerar um arquivo `leads.csv` no diretório atual.


```
➜  pope-challenge git:(master) ✗ wc -l leads.csv
   10001 leads.csv
```

O arquivo tem 10001 linhas pois contém cabeçalho.

Entre no terminal e faça sua primeira importação:

```
➜  pope-challenge git:(master) ✗ rails c
```

Limpe a base caso queira observar inicialmente os updates:

```ruby
[Lead,City,State].each &:delete_all
```

Instancie um LeadImport e coloque no benchmark para verificar a velocidade.

```ruby
importer = LeadImport.new file: "leads.csv" # => #<LeadImport id: nil, file: "leads.csv", leads_imported: nil, leads_updated: nil, process_status: nil, created_at: nil, updated_at: nil>
Benchmark.realtime { importer.import! } # => Diminuir essa tempo de processamento é o seu objetivo!
```

Bom. Esse é o começo de tudo. Agora é com você!

Na minha máquina (@jonatas) rodou em 238 com 10 mil leads. Macbook 2011 com hd ssd.

A partir deste tempo inicial pode ser sua base para implementar melhorias e tentar novamente.

Experimente com arquivos de diversos tamanhos. Faça seus experimentos e observações.

Aguardamos seu pull request com o resumo da jornada! Qualquer dúvida só
mencionar o @jonatas ou me enviar um email em `jonatas.paganini@resultadosdigitais.com.br`.

