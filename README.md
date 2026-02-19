# BibleTimeline

Solução voltada à leitura da Bíblia em ordem cronológica. O MVP inicia
com os quatro Evangelhos organizados segundo a Harmonia dos Evangelhos,
estruturando a narrativa de forma linear e progressiva.

---

## Sobre o projeto

Os Evangelhos se sobrepõem em eventos e narrativas, o que dificulta uma
leitura contínua. O BibleTimeline resolve isso organizando 169 eventos
cronológicos em uma única linha de leitura, consumindo o texto
diretamente da API.Bible em tempo real.

---

## Funcionalidades

- Leitura cronológica dos 4 Evangelhos com 169 eventos ordenados
- Verso do dia dinâmico com cache inteligente por data
- Continuidade de leitura — retoma exatamente onde parou
- Exploração por seção da Harmonia dos Evangelhos
- Busca por livro e capítulo
- Saudação contextual por horário do dia
- Splash screen animada

---

## Tecnologias e decisões técnicas

- **SwiftUI** — interface declarativa e reativa
- **Swift Concurrency** — `async/await` e `TaskGroup` para chamadas paralelas
- **API.Bible** — fonte do texto bíblico via REST
- **SOLID** — injeção de dependências em todos os níveis
- **State-driven UI** — ViewModels com `enum State` (loading / loaded / error)
- **AppStorage + UserDefaults** — persistência leve sem Core Data
- **Design System próprio** — componentes reutilizáveis com tema centralizado
- **XCTest** — testes unitários para regras de negócio críticas

---

## Arquitetura
```
BibleTimeline/
├── App/
├── Features/        # Home, Reading, Explore, Search
├── Domain/          # Modelos, protocolos e regras de negócio
├── Data/            # API.Bible, HTTP, Repositórios
├── DesignSystem/    # Theme e componentes reutilizáveis
└── Shared/          # Utilitários e extensões
```

Camadas desacopladas — `Domain` não conhece `Data`, e `Data` não conhece
`Features`. Dependências sempre injetadas via `init`.

---

## Testes
```
BibleTimelineTests/
├── StringExtensionsTests      # Remoção de números de verso
├── ChronologyLoaderTests      # Carregamento e mapeamento do JSON
└── VerseOfDayReferenceTests   # Seed determinístico por data
```

---

## Configuração

1. Clone o repositório
2. Adicione sua chave no `Info.plist`:
   - `API_BIBLE_KEY` — sua API key da [API.Bible](https://scripture.api.bible)
   - `API_BIBLE_ID` — ID da versão bíblica desejada
3. Rode no Xcode 15+ com iOS 17+

---

## Autor

**Higor Lo Castro**  
[LinkedIn](https://www.linkedin.com/in/higor-crisostomo) · [GitHub](https://github.com/HigorCris21)
```
